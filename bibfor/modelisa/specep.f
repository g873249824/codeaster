      SUBROUTINE SPECEP(CASINT,NOMU,SPECTR,BASE,VITE,NUOR,IMODI,IMODF,
     &                  NBM,NBPF)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 24/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C-----------------------------------------------------------------------
C     PROJECTION D'UN SPECTRE D'EXCITATION TURBULENTE LOCALISEE (FORCES
C     ET MOMENTS PONCTUELS) SUR UNE BASE MODALE PERTURBEE PAR PRISE EN
C     COMPTE DU COUPLAGE FLUIDE STRUCTURE
C     APPELANT : OP0146 , OPERATEUR PROJ_SPEC_BASE
C-----------------------------------------------------------------------
C IN  : CASINT  : BOOLEEN, DONNE L'OPTION DE CALCUL
C       CASINT  = .TRUE.  => CALCUL DE TOUS LES INTERSPECTRES
C       CASINT  = .FALSE. => CALCUL DES AUTOSPECTRES UNIQUEMENT
C IN  : NOMU    : NOM UTILISATEUR
C IN  : SPECTR  : NOM DU CONCEPT SPECTRE
C IN  : BASE    : NOM DU CONCEPT MELASFLU
C IN  : VITE    : VITESSE ETUDIEE
C IN  : NUOR    : NUMEROS D'ORDRE DES MODES DU CONCEPT MELASFLU
C IN  : IMODI   : INDICE DU PREMIER MODE PRIS EN COMPTE
C IN  : IMODF   : INDICE DU DERNIER MODE PRIS EN COMPTE
C IN  : NBM     : NOMBRE DE MODES DU CONCEPT MELASFLU
C IN  : NBPF    : NOMBRE DE POINTS DE LA DISCRETISATION FREQUENTIELLE
C
C     ------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      LOGICAL      CASINT
      INTEGER      IMODI,IMODF,NBM,NUOR(NBM),NBPF,IJ,NBVAL
      CHARACTER*8  NOMU
      CHARACTER*19 SPECTR,BASE
      REAL*8       VITE
C
      INTEGER      IBID,DIM,IVAL(2)
      REAL*8       R8B,R8PREM,MODULE
      REAL*8       COEFAC(8),COEFAE(8),COEFDC(6),COEFDE(6)
      COMPLEX*16   C16B
      LOGICAL      LTABLE
      CHARACTER*8  K8B,CAELEM,MODELE,TABLE,NOMA,NOMNO0
      CHARACTER*16 CONFIG, NOPART(2)
      CHARACTER*19 TYPFLU,NOMFON
      CHARACTER*24 SPVAIN,SPVATE,SPVARE,SPNNOE
      CHARACTER*24 CHVALE
      CHARACTER*24 REMF,FSIC,CHREFE,MLGNNO,MLGNMA
C
C-----------------------------------------------------------------------
      INTEGER IAXE ,ICHREF ,IDEB ,IDEC ,IER ,IEX ,IEX1 
      INTEGER IEX2 ,IFSIC ,IINTE ,IL ,IM1 ,IM1B ,IM2 
      INTEGER IM2B ,IMAIL ,INAT ,IREMF ,IRET ,ISCAL ,ISPIN 
      INTEGER ISPNO ,ISPRE ,ISPTE ,ITYPFL ,IV ,IVALE ,LWR 
      INTEGER NBEXCP ,NBMA ,NBMANO ,NBMR ,NUMNO0 
      REAL*8 BETA ,COEDIM ,COEF1 ,COEF2 ,COEFD ,DIFPHI ,FR 
      REAL*8 FRC ,FRREF ,PHI1 ,PHI2 ,PHIE ,PTF ,RESUIM 
      REAL*8 RESURE ,RHOF ,S0 ,SCAL11 ,SCAL12 ,SCAL21 ,SCAL22 
      REAL*8 SREF ,TOLR ,UABS 
C-----------------------------------------------------------------------
      DATA NOPART / 'NUME_ORDRE_I' , 'NUME_ORDRE_J' /
C
      DATA COEFAC / 1.D-4  , 1.9D-1 , 7.D-2  , 1.6D0  ,
     &              2.7D-5 , 1.9D-1 , 7.D-2  , 2.1D0  /
C
      DATA COEFAE / 1.D-5  , 5.D-1  , 2.D-2  , 2.9D0  ,
     &              3.3D-4 , 1.D-1  , 2.D-2  , 2.8D0  /
C
      DATA COEFDC / 4.D-5  , 1.9D-1 , 1.6D0  ,
     &              2.7D-5 , 1.9D-1 , 2.1D0  /
C
      DATA COEFDE / 1.7D-5  , 2.2D-1 , 2.9D0  ,
     &              1.7D-5  , 1.9D-1 , 2.8D0  /
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C
C --- 1.TEST DE COMPATIBILITE TYPE DE SPECTRE/CONFIGURATION ETUDIEE ---
C
      REMF = BASE//'.REMF'
      CALL JEVEUO(REMF,'L',IREMF)
      TYPFLU = ZK8(IREMF)
      FSIC = TYPFLU//'.FSIC'
      CALL JEVEUO(FSIC,'L',IFSIC)
      ITYPFL = ZI(IFSIC)
      IF (ITYPFL.NE.2) THEN
        CALL U2MESS('F','MODELISA7_4')
      ENDIF
C
C
C --- 2.RECUPERATION DU NOM DU CONCEPT MAILLAGE ---
C
      IV = 1
      WRITE(CHREFE,'(A8,A5,2I3.3,A5)') BASE(1:8),'.C01.',NUOR(1),IV,
     &                                 '.REFE'
      CALL JEVEUO(CHREFE,'L',ICHREF)
      NOMA = ZK24(ICHREF)(1:8)
C
C
C --- 3.RECUPERATION DES INFORMATIONS CARACTERISTIQUES DU SPECTRE ---
C
      SPVAIN = SPECTR//'.VAIN'
      SPVATE = SPECTR//'.VATE'
      SPVARE = SPECTR//'.VARE'
      SPNNOE = SPECTR//'.NNOE'
C
      CALL JEVEUO(SPVAIN,'L',ISPIN)
      LTABLE = .FALSE.
      IF (ZI(ISPIN+1).EQ.0) LTABLE = .TRUE.
C
      CALL JEVEUO(SPVATE,'L',ISPTE)
      CAELEM = ZK16(ISPTE+1)(1:8)
      MODELE = ZK16(ISPTE+2)(1:8)
C
      IF ( LTABLE ) THEN
C
        TABLE = ZK16(ISPTE+3)(1:8)
        CALL TBLIVA ( TABLE, 0, K8B, IBID, R8B, C16B, K8B, K8B, R8B,
     &              'DIMENSION', K8B, NBEXCP, R8B, C16B, K8B, IRET )
        IF ( IRET .NE. 0 ) CALL U2MESS('F','MODELISA2_89')
C
      ELSE
C
        NBEXCP = 2
        CONFIG = ZK16(ISPTE+4)
        CALL JEVEUO(SPVARE,'L',ISPRE)
        RHOF = ZR(ISPRE)
        CALL JEVEUO(SPNNOE,'L',ISPNO)
        NOMNO0 = ZK8(ISPNO)
C
C-------RECUPERATION DU DIAMETRE EXTERIEUR DE LA POUTRE, NECESSAIRE AU
C       DIMENSIONNEMENT DE L'EXCITATION GRAPPE2
C
        MLGNNO = NOMA//'.NOMNOE'
        CALL JENONU(JEXNOM(MLGNNO,NOMNO0),NUMNO0)
        MLGNMA = NOMA//'.NOMMAI'
        CALL JELIRA(MLGNMA,'NOMMAX',NBMA,K8B)
        CALL WKVECT('&&SPECEP.TEMP.MAIL','V V I',NBMA,IMAIL)
        CALL EXMANO(NOMA,NUMNO0,ZI(IMAIL),NBMANO)
        IF (NBMANO.NE.2) CALL U2MESS('F','ALGELINE_70')
        CALL DEELPO(CAELEM,NOMA,ZI(IMAIL)  ,PHI1)
        CALL DEELPO(CAELEM,NOMA,ZI(IMAIL+1),PHI2)
        TOLR = R8PREM()
        DIFPHI = DBLE(ABS(PHI1-PHI2))
        IF (DIFPHI.GT.PHI1*TOLR) THEN
          CALL U2MESS('F','ALGELINE_71')
        ELSE
          PHIE = PHI1
        ENDIF
C
C-------CALCUL DE COEFFICIENTS DE DIMENSIONNEMENT
C
        COEF1 = 282.D0/890.D0
        COEF2 = 0.77D0*0.77D0/4.D0
        COEFD = PHIE/8.9D-2
C
      ENDIF
C
C
C --- 4.DETERMINATION DE L'AXE DIRECTEUR DE LA POUTRE ---
C
      CALL AXDIPO(NOMA,CAELEM,MODELE,IAXE)
C
C
C --- 5.CALCUL DES PRODUITS SCALAIRES PHII(XK).NK ET PHII'(XM).NM ---
C ---   XK POINTS D'APPLICATION DES FORCES PONCTUELLES            ---
C ---   XM POINTS D'APPLICATION DES MOMENTS PONCTUELS             ---
C ---   NK ET NM DIRECTIONS D'APPLICATION DES EXCITATIONS         ---
C
      NBMR = IMODF - IMODI + 1
      CALL WKVECT('&&SPECEP.TEMP.SCAL','V V R',NBEXCP*NBMR,ISCAL)
      CALL SCALEP(SPECTR,NOMA,BASE,NUOR,NBM,IMODI,NBMR,NBEXCP,LTABLE,
     &            IAXE,ZR(ISCAL))
C
C
C --- 6.CALCUL DES INTERSPECTRES D'EXCITATIONS MODALES ---
C ---   BOUCLE SUR LE NOMBRE DE VITESSES               ---
C
      CALL WKVECT('&&SPECEP.TEMP.SWR ','V V R',NBPF,LWR)
      DIM = NBEXCP*(NBEXCP+1)/2
      DIM = 2*NBPF*DIM
      CALL WKVECT('&&SPECEP.TEMP.INTE','V V R',DIM,IINTE)
C
C --- 6.1.RECUPERATION DE LA DISCRETISATION FREQUENTIELLE
        CALL JEVEUO(NOMU//'.FREQ','L',LWR)
C
C --- 6.2.INTERPOLATION DES INTERSPECTRES A PROJETER
C
        IF ( LTABLE ) THEN
C
          DO 20 IEX2 = 1,NBEXCP
            IVAL(2) = IEX2
            DO 21 IEX1 = 1,IEX2
              IEX = IEX2*(IEX2-1)/2 + IEX1
              IVAL(1) = IEX1
              CALL TBLIVA ( TABLE, 2, NOPART, IVAL, R8B, C16B, K8B, K8B,
     &           R8B, 'FONCTION_C', K8B, IBID, R8B, C16B, NOMFON, IRET )
              CALL ASSERT(IRET.EQ.0)
              K8B = ' '
              DO 22 IL = 1,NBPF
                PTF = ZR(LWR+IL-1)
                CALL FOINTC('E',NOMFON,0,K8B,PTF,RESURE,RESUIM,IER)
                IF (IER.NE.0) THEN
                  CALL U2MESS('F','MODELISA7_5')
                ENDIF
                IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
                ZR(IINTE+IDEC) = RESURE
                ZR(IINTE+IDEC+1) = RESUIM
  22          CONTINUE
  21        CONTINUE
  20      CONTINUE
C
        ELSE IF (CONFIG(1:7).EQ.'ASC_CEN') THEN
C
          UABS = DBLE(ABS(VITE))
C
          DO 30 IEX2 = 1,NBEXCP
            SREF  = COEFAC(4*(IEX2-1)+1)
            FRREF = COEFAC(4*(IEX2-1)+2)
            FRC   = COEFAC(4*(IEX2-1)+3)
            BETA  = COEFAC(4*(IEX2-1)+4)
            S0 = SREF * ( 1.D0 + (FRREF/FRC)**(BETA) )
            INAT = IEX2 - INT(IEX2/2) * 2
            COEDIM = COEF1 * COEFD * COEFD
            IF (INAT.EQ.0) COEDIM = COEDIM * COEFD * COEFD * COEF2
            IEX = IEX2*(IEX2+1)/2
            DO 31 IL = 1,NBPF
              IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
              FR = ZR(LWR+IL-1)*PHIE/UABS
              MODULE = 1.D0 + (FR/FRC)**(BETA)
              MODULE = S0/MODULE
              ZR(IINTE+IDEC) = COEDIM * MODULE
  31        CONTINUE
  30      CONTINUE
C
        ELSE IF (CONFIG(1:7).EQ.'ASC_EXC') THEN
C
          UABS = DBLE(ABS(VITE))
C
          DO 40 IEX2 = 1,NBEXCP
            SREF  = COEFAE(4*(IEX2-1)+1)
            FRREF = COEFAE(4*(IEX2-1)+2)
            FRC   = COEFAE(4*(IEX2-1)+3)
            BETA  = COEFAE(4*(IEX2-1)+4)
            S0 = SREF * ( 1.D0 + (FRREF/FRC)**(BETA) )
            INAT = IEX2 - INT(IEX2/2) * 2
            COEDIM = COEF1 * COEFD * COEFD
            IF (INAT.EQ.0) COEDIM = COEDIM * COEFD * COEFD * COEF2
            IEX = IEX2*(IEX2+1)/2
            DO 41 IL = 1,NBPF
              IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
              FR = ZR(LWR+IL-1)*PHIE/UABS
              MODULE = 1.D0 + (FR/FRC)**(BETA)
              MODULE = S0/MODULE
              ZR(IINTE+IDEC) = COEDIM * MODULE
  41        CONTINUE
  40      CONTINUE
C
        ELSE IF (CONFIG(1:7).EQ.'DES_CEN') THEN
C
          UABS = DBLE(ABS(VITE))
C
          DO 50 IEX2 = 1,NBEXCP
            S0   = COEFDC(3*(IEX2-1)+1)
            FRC  = COEFDC(3*(IEX2-1)+2)
            BETA = COEFDC(3*(IEX2-1)+3)
            INAT = IEX2 - INT(IEX2/2) * 2
            COEDIM = COEF1 * COEFD * COEFD
            IF (INAT.EQ.0) COEDIM = COEDIM * COEFD * COEFD * COEF2
            IEX = IEX2*(IEX2+1)/2
            DO 51 IL = 1,NBPF
              IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
              FR = ZR(LWR+IL-1)*PHIE/UABS
              MODULE = 1.D0 + (FR/FRC)**(BETA)
              MODULE = S0/MODULE
              ZR(IINTE+IDEC) = COEDIM * MODULE
  51        CONTINUE
  50      CONTINUE
C
        ELSE IF (CONFIG(1:7).EQ.'DES_EXC') THEN
C
          UABS = DBLE(ABS(VITE))
C
          DO 60 IEX2 = 1,NBEXCP
            S0   = COEFDE(3*(IEX2-1)+1)
            FRC  = COEFDE(3*(IEX2-1)+2)
            BETA = COEFDE(3*(IEX2-1)+3)
            INAT = IEX2 - INT(IEX2/2) * 2
            COEDIM = COEF1 * COEFD * COEFD
            IF (INAT.EQ.0) COEDIM = COEDIM * COEFD * COEFD * COEF2
            IEX = IEX2*(IEX2+1)/2
            DO 61 IL = 1,NBPF
              IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
              FR = ZR(LWR+IL-1)*PHIE/UABS
              MODULE = 1.D0 + (FR/FRC)**(BETA)
              MODULE = S0/MODULE
              ZR(IINTE+IDEC) = COEDIM * MODULE
  61        CONTINUE
  60      CONTINUE
C
        ENDIF
C
C --- 6.3.PROJECTION DES INTERSPECTRES
C
        IJ = 0
        CHVALE = NOMU//'.VALE'
        DO 70 IM2 = IMODI,IMODF
          IDEB = IM2
          IF (CASINT) IDEB = IMODI
          DO 71 IM1 = IDEB,IM2
            IJ = IJ + 1
            CALL JEVEUO(JEXNUM(CHVALE,IJ),'E',IVALE)
            CALL JELIRA(JEXNUM(CHVALE,IJ),'LONMAX',NBVAL,K8B)
C
            IM2B = IM2 - IMODI + 1
            IM1B = IM1 - IMODI + 1
C
            IF ( LTABLE ) THEN
C
              DO 80 IL = 1,NBPF
C
                DO 81 IEX2 = 1,NBEXCP
                  SCAL12 = ZR(ISCAL+NBEXCP*(IM1B-1)+IEX2-1)
                  SCAL22 = ZR(ISCAL+NBEXCP*(IM2B-1)+IEX2-1)
                  IEX = IEX2*(IEX2+1)/2
                  IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
                  IF (NBVAL .EQ. NBPF) THEN
                    ZR(IVALE+IL-1) = ZR(IVALE+IL-1)
     &                            + SCAL12*SCAL22 * ZR(IINTE+IDEC)
                  ELSE
                    ZR(IVALE+2*(IL-1)) = ZR(IVALE+2*(IL-1))
     &                            + SCAL12*SCAL22 * ZR(IINTE+IDEC)
                  ENDIF
  81            CONTINUE
C
                IF (NBEXCP.GT.1) THEN
                  DO 82 IEX2 = 2,NBEXCP
                    SCAL12 = ZR(ISCAL+NBEXCP*(IM1B-1)+IEX2-1)
                    SCAL22 = ZR(ISCAL+NBEXCP*(IM2B-1)+IEX2-1)
                    DO 83 IEX1 = 1,IEX2-1
                      SCAL11 = ZR(ISCAL+NBEXCP*(IM1B-1)+IEX1-1)
                      SCAL21 = ZR(ISCAL+NBEXCP*(IM2B-1)+IEX1-1)
                      IEX = IEX2*(IEX2-1)/2 + IEX1
                      IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
                      IF (NBVAL .EQ. NBPF) THEN
                        ZR(IVALE+IL-1)
     &                    = ZR(IVALE+IL-1) + ( SCAL11*SCAL22
     &                    + SCAL12*SCAL21 ) * ZR(IINTE+IDEC)
                      ELSE
                        ZR(IVALE+2*(IL-1))
     &                    = ZR(IVALE+2*(IL-1)) + ( SCAL11*SCAL22
     &                    + SCAL12*SCAL21 ) * ZR(IINTE+IDEC)
                        ZR(IVALE+2*(IL-1)+1)
     &                    = ZR(IVALE+2*(IL-1)+1) + ( SCAL11*SCAL22
     &                    - SCAL12*SCAL21 ) * ZR(IINTE+IDEC+1)
                      ENDIF
  83                CONTINUE
  82              CONTINUE
                ENDIF
C
  80          CONTINUE
C
            ELSE
C
              COEDIM = 0.25D0 * COEF1*COEF1 * RHOF*RHOF * UABS*UABS*UABS
     &                        * PHIE*PHIE*PHIE
              DO 90 IL = 1,NBPF
                DO 91 IEX2 = 1,NBEXCP
                  SCAL12 = ZR(ISCAL+NBEXCP*(IM1B-1)+IEX2-1)
                  SCAL22 = ZR(ISCAL+NBEXCP*(IM2B-1)+IEX2-1)
                  IEX = IEX2*(IEX2+1)/2
                  IDEC = 2*NBPF*(IEX-1)+2*(IL-1)
                  IF (NBVAL .EQ. NBPF) THEN
                    ZR(IVALE+IL-1) = ZR(IVALE+IL-1)
     &                         + COEDIM * SCAL12*SCAL22 * ZR(IINTE+IDEC)
                  ELSE
                    ZR(IVALE+2*(IL-1)) = ZR(IVALE+2*(IL-1))
     &                         + COEDIM * SCAL12*SCAL22 * ZR(IINTE+IDEC)
                  ENDIF
  91            CONTINUE
  90          CONTINUE
C
            ENDIF
  71      CONTINUE
  70    CONTINUE
C
      CALL JEDETR('&&SPECEP.TEMP.MAIL')
      CALL JEDETR('&&SPECEP.TEMP.SCAL')
      CALL JEDETR('&&SPECEP.TEMP.SWR ')
      CALL JEDETR('&&SPECEP.TEMP.INTE')
C
      CALL JEDEMA()
      END
