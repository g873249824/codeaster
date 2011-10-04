      SUBROUTINE TE0039(OPTION,NOMTE)
C MODIF ELEMENTS  DATE 03/10/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
      IMPLICIT       NONE
      CHARACTER*16   OPTION,NOMTE
C ----------------------------------------------------------------------
C IN OPTION    : K16 :  OPTION DE CALCUL
C     'SIEF_ELNO'  'SIEQ_ELNO'       'SIEQ_ELGA'  'EFCA_ELNO'
C     'FORC_NODA'  'REFE_FORC_NODA'  'SICA_ELNO'  'CHAR_MECA_EPSI_R'
C     'PMPB_ELGA'  'FONL_NOEU'
C IN NOMTE     : K16 : NOM DU TYPE ELEMENT
C     DISCRETS :
C        'MECA_DIS_T_N'      'MECA_DIS_T_L'     'MECA_DIS_TR_N'
C        'MECA_DIS_TR_L'     'MECA_2D_DIS_T_N'  'MECA_2D_DIS_T_L'
C        'MECA_2D_DIS_TR_N'  'MECA_2D_DIS_TR_L'
C     POUTRES DROITE D'EULER
C        'MECA_POU_D_E'   : SECTION VARIABLE
C        'MECA_POU_D_EM'  : SECTION MULTIFIBRES
C     POUTRE DROITE DE TIMOSHENKO
C        'MECA_POU_D_T'   : SECTION VARIABLE
C        'MECA_POU_D_TG'  : AVEC GAUCHISSEMENT
C        'MECA_POU_D_TGM' : AVEC GAUCHISSEMENT, SECTION MULTIFIBRES
C     POUTRE COURBE DE TIMOSHENKO
C        'MECA_POU_C_T'   : SECTION CONSTANTE
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C     ------------------------------------------------------------------
      INTEGER        NBRES
      PARAMETER     (NBRES=4)

      INTEGER        CODRES(NBRES)
      CHARACTER*8    NOMRES(NBRES),NOMPAR,NOMAIL,K8BID
      CHARACTER*16   CH16,KMESS(5)

      REAL*8   VALRES(NBRES),MATK(78),ALFAY,ALFAZ,XNU,XL,XIZ,XIY2,XIY
      REAL*8   XFLZ,XFLY,XFL,UN,ZERO,DEUX,XJX,A,A2,XIZ2
      REAL*8   R1,R2,VALPAR,E,G,EPX,XKY,XKZ,ANG,TRIGOM,ALONG
      REAL*8   PGL(3,3),PGL1(3,3),PGL2(3,3)
      REAL*8   BSM(12,12),DE(12),FS(14)
      REAL*8   FSS(14),PM(3),PMPB(3),NORM(3),MY(3),MZ(3),R12XIY,A12
      REAL*8   RAD,ANGARC,ANGS2
      REAL*8   CARSEC(6), R8BID
      REAL*8   UGP(12),DUG(12),KLV(78),DULY,FORCE(3),PLOUF
      REAL*8   ULP(12),DUL(12),DVL(12),DPE(12),DVE(12)
      REAL*8   SIM(12),SIP(12),FONO(12),VARMO(8),VARPL(8)

      INTEGER  NCC,NNOC,LORIEN,J,IND,LRCOU,LX,IDEFI,NBPAR,LMATER,IN
      INTEGER  LSECT2,LSECT,LSECR,I,IVECTU,ICONTG,NEQ,NC,NNO,ITSEC
      INTEGER  IELEM,IREPE,NDIM,IRET,IADZI,IAZK24,IREFCO
      INTEGER  NEQ1,IPLOUF,NPG,INFODI,ITYPE,IBID
      INTEGER  IGEOM,IDEPLM,IDEPLP,ICOMPO,NBT,JDC,IREP,IFONO,ILOGIC
      LOGICAL  AUNOEU

      PARAMETER (ZERO=0.0D0, DEUX=2.0D0, UN=1.0D0)
C     ------------------------------------------------------------------

      CALL JEMARQ()
      INFODI = 1
      IREPE  = 0
      IF ( (NOMTE(1:9)  .EQ.'MECA_DIS_') .OR.
     &     (NOMTE(1:12) .EQ.'MECA_2D_DIS_') ) THEN
C        ON VERIFIE QUE LES CARACTERISTIQUES ONT ETE AFFECTEES
C        LE CODE DU DISCRET
         CALL INFDIS('CODE',IBID,R8BID,NOMTE)
C        LE CODE STOKE DANS LA CARTE
         CALL INFDIS('TYDI',INFODI,R8BID,K8BID)
         IF (INFODI.NE.IBID) THEN
            CALL U2MESK('F+','DISCRETS_25',1,NOMTE)
            CALL INFDIS('DUMP',IBID,R8BID,'F+')
         ENDIF
C        DISCRET DE TYPE RAIDEUR
         CALL INFDIS('DISK',INFODI,R8BID,K8BID)
         IF (INFODI.EQ.0) THEN
            CALL U2MESK('A+','DISCRETS_27',1,NOMTE)
            CALL INFDIS('DUMP',IBID,R8BID,'A+')
         ENDIF
C        MATRICE DE RAIDEUR SYMETRIQUE OU PAS, POUR LES DISCRETS
         CALL INFDIS('SYMK',INFODI,R8BID,K8BID)
      ENDIF
C     RECUPERE LES INFORMATIONS SUR LES ELEMENTS
      CALL INFTED(NOMTE,INFODI,NBT,NNO,NC,NDIM,ITYPE)
      NEQ = NNO*NC
C     ELEMENT A 1 NOEUD OU 3PTS DE GAUSS : IELEM=0
      IELEM = 1
      IF ( (NOMTE.EQ.'MECA_POU_D_TG').OR.
     &     (NOMTE.EQ.'MECA_POU_D_TGM').OR.
     &     (NNO.EQ.1) ) THEN
         IELEM = 0
      END IF
C     NOMBRE DE POINTS DE GAUSS DE L'ELEMENT
      CALL ELREF4(' ','RIGI',IPLOUF,IPLOUF,IPLOUF,
     &            NPG,IPLOUF,IPLOUF,IPLOUF,IPLOUF)
C
C --- ------------------------------------------------------------------
      IF ( OPTION(1:14) .EQ. 'REFE_FORC_NODA' ) THEN
         CALL JEVECH('PREFCO', 'L',IREFCO)
         CALL JEVECH('PVECTUR','E',IVECTU)
         IF(      NOMTE.EQ.'MECA_POU_C_T' .OR.
     &      NOMTE(1:11).EQ.'MECA_DIS_TR')THEN
            DO 200 IN=1,NNO
               DO 203  I=1,3
                  ZR(IVECTU+(IN-1)*NC+I-1)=ZR(IREFCO)
203            CONTINUE
               DO 202 I=4,NC
                  ZR(IVECTU+(IN-1)*NC+I-1)=ZR(IREFCO+1)
202            CONTINUE
200         CONTINUE
         ELSEIF(NOMTE(1:14).EQ.'MECA_2D_DIS_T_')THEN
            DO 204 IN=1,NNO
               ZR(IVECTU+(IN-1)*NC)=ZR(IREFCO)
               ZR(IVECTU+(IN-1)*NC+1)=ZR(IREFCO)
204         CONTINUE
         ELSEIF(NOMTE(1:14).EQ.'MECA_2D_DIS_TR')THEN
            DO 205 IN=1,NNO
               ZR(IVECTU+(IN-1)*NC)=ZR(IREFCO)
               ZR(IVECTU+(IN-1)*NC+1)=ZR(IREFCO)
               ZR(IVECTU+(IN-1)*NC+2)=ZR(IREFCO+1)
205         CONTINUE
         ELSEIF(NOMTE(1:11).EQ.'MECA_DIS_T_')THEN
            DO 206 IN=1,NNO
               ZR(IVECTU+(IN-1)*NC)=ZR(IREFCO)
               ZR(IVECTU+(IN-1)*NC+1)=ZR(IREFCO)
               ZR(IVECTU+(IN-1)*NC+2)=ZR(IREFCO)
206         CONTINUE
         ELSE
            KMESS(1) = OPTION
            KMESS(2) = NOMTE
            KMESS(3) = 'TE0039'
            CALL U2MESK('F','DISCRETS_15',2,KMESS)
         ENDIF
C --- ------------------------------------------------------------------
      ELSE IF (OPTION.EQ.'SIEF_ELNO') THEN
         CALL JEVECH('PCONTRR','L',ICONTG)
         CALL JEVECH('PSIEFNOR','E',IVECTU)
         DO 10 I = 1,NEQ
            ZR(IVECTU-1+I) = ZR(ICONTG-1+I)
10       CONTINUE
C --- ------------------------------------------------------------------
      ELSE IF ((OPTION.EQ.'PMPB_ELNO') .OR.
     &         (OPTION.EQ.'PMPB_ELGA')) THEN
C        VERIF DU NOMBRE DE POINT DE GAUUS
         CALL ASSERT( (NPG.EQ.2).OR.(NPG.EQ.3) )
C        N1 N2      : EFFORT NORMAUX NOEUDS 1 ET 2
C        N1 N2 N3   : EFFORT NORMAUX GAUSS 1 , 2 ET 3
C        MX, MY, MZ : MOMENTS DE TORSION ET FLEXION
         AUNOEU = .TRUE.
         IF (OPTION.EQ.'PMPB_ELNO') THEN
            CALL JEVECH('PSIEFNOR','L',ICONTG)
            NORM(1) = ZR(ICONTG)
            NORM(2) = ZR(ICONTG+6)
            MY(1)   = ZR(ICONTG+4)
            MY(2)   = ZR(ICONTG+10)
            MZ(1)   = ZR(ICONTG+5)
            MZ(2)   = ZR(ICONTG+11)
         ELSE
            CALL JEVECH('PCONTRR','L',ICONTG)
            NORM(1) = ZR(ICONTG)
            NORM(2) = ZR(ICONTG+6)
            MY(1)   = ZR(ICONTG+4)
            MY(2)   = ZR(ICONTG+10)
            MZ(1)   = ZR(ICONTG+5)
            MZ(2)   = ZR(ICONTG+11)
            IF ( NPG .EQ. 3 ) THEN
               AUNOEU = .FALSE.
               NORM(3) = ZR(ICONTG+12)
               MY(3)   = ZR(ICONTG+16)
               MZ(3)   = ZR(ICONTG+17)
            ENDIF
         END IF
         CALL JEVECH('PCONTEQ','E',IVECTU)
         CALL JEVECH('PCAGNPO','L',LSECT)
         CALL JEVECH('PCAGEPO','L',LSECR)
C        --- CARACTERISTIQUES GENERALES DES SECTIONS ---
         LSECT = LSECT - 1
C        --- SECTION INITIALE ---
         A     = ZR(LSECT+1)
         XIY   = ZR(LSECT+2)
         XIZ   = ZR(LSECT+3)
C        --- SECTION FINALE ---
         LSECT2 = LSECT + 11
         A2     = ZR(LSECT2+1)
         XIY2   = ZR(LSECT2+2)
         XIZ2   = ZR(LSECT2+3)
C
         LSECR = LSECR - 1
         ITSEC = NINT(ZR(LSECR+13))
         IF (ITSEC.EQ.1) THEN
            CALL U2MESS('A','ELEMENTS2_85')
            CALL R8INIR(3, ZERO,  PM  , 1)
            CALL R8INIR(3, ZERO,  PMPB, 1)
         ELSE IF (ITSEC.EQ.2) THEN
C        --- SECTION CIRCULAIRE SECTIONS INITIALE ET FINALE
            R1 = ZR(LSECR+9)
            R2 = ZR(LSECR+11)
C           B3600 : TUYAUX DROITS SOUS PRESSION
C              B3600 : PM = P.R/E + SQRT(MX**2+MY**2+MZ**2)*R/I
C              ICI, ON REMPLACE P.R/E PAR ABS(N/S)
C           B3200 : PAROI DE RESERVOIR. SUR UNE SECTION DE PAROI :
C              B3200 : PM = MAX(TRESCA(SIGMA_MOYEN(I,J,T)))
C              B3200 : PM = MAX(TRESCA(SIGMA_FLEXION(I,J,T)))
C              POUR UN TUYAU MINCE, ON TROUVE, SI E<<R :
C              B3200 : PM = N/S + SQRT(MX**2+MY**2+MZ**2)*R/I
C                      PB NEGLIGEABLE
C           ICI ON CHOISIT LE
C           G3000 :  PM = ABS(N/S)
C                    PMPB = ABS(N/S) + SQRT(MY**2+MZ**2)*R/I
C           POUR LE NOEUD MILIEU ON APPLIQUE LA FORMULE AVEC LA MOYENNE
C           DES CARACTERISTIQUES MECANIQUE
            PM(1)   = ABS(NORM(1)/A)
            PMPB(1) = ABS(NORM(1)/A) + (R1/XIY)*SQRT(MY(1)**2+MZ(1)**2)
            IF ( AUNOEU ) THEN
               PM(2)   = ABS(NORM(2)/A2)
               PMPB(2) = ABS(NORM(2)/A2) +
     &                      (R2/XIY2)*SQRT(MY(2)**2+MZ(2)**2)
            ELSE
               A12 = (A+A2)/DEUX
               R12XIY = ( (R2/XIY2) + (R1/XIY) )/DEUX
               PM(2)   = ABS(NORM(2)/A12)
               PMPB(2) = ABS(NORM(2)/A12) +
     &                      (R12XIY)*SQRT(MY(2)**2+MZ(2)**2)
               PM(3)   = ABS(NORM(3)/A2)
               PMPB(3) = ABS(NORM(3)/A2) +
     &                      (R2/XIY2)*SQRT(MY(3)**2+MZ(3)**2)
            ENDIF
         ELSE
            CALL U2MESS('A','ELEMENTS2_86')
            CALL R8INIR(3, ZERO,  PM  , 1)
            CALL R8INIR(3, ZERO,  PMPB, 1)
         END IF
         IF ( AUNOEU ) THEN
            ZR(IVECTU)   = PM(1)
            ZR(IVECTU+1) = PMPB(1)
            ZR(IVECTU+2) = PM(2)
            ZR(IVECTU+3) = PMPB(2)
         ELSE
            ZR(IVECTU)   = PM(1)
            ZR(IVECTU+1) = PMPB(1)
            ZR(IVECTU+2) = PM(2)
            ZR(IVECTU+3) = PMPB(2)
            ZR(IVECTU+4) = PM(3)
            ZR(IVECTU+5) = PMPB(3)
         ENDIF
C --- ------------------------------------------------------------------
      ELSE IF (OPTION.EQ.'FONL_NOEU') THEN
         CALL JEVECH('PGEOMER','L',IGEOM)
         CALL JEVECH('PDEPLMR','L',IDEPLM)
         CALL JEVECH('PDEPLPR','L',IDEPLP)
         CALL JEVECH('PCOMPOR','L',ICOMPO)
         CALL JEVECH('PMATERC','L',LMATER)
         IF (NOMTE(1:10).EQ.'MECA_DIS_T') THEN
C           PARAMETRES EN ENTREE
            CALL JEVECH('PCAORIE','L',LORIEN)
            CALL MATROT(ZR(LORIEN),PGL)
C           DEPLACEMENTS DANS LE REPERE GLOBAL
C                 UGM = DEPLACEMENT PRECEDENT
C                 DUG = INCREMENT DE DEPLACEMENT
C                 UGP = DEPLACEMENT COURANT
            DO 300 I = 1,NEQ
               DUG(I) = ZR(IDEPLP+I-1)
               UGP(I) = ZR(IDEPLM+I-1) + DUG(I)
300         CONTINUE
C           DEPLACEMENTS DANS LE REPERE LOCAL
C              ULM = DEPLACEMENT PRECEDENT    = PLG * UGM
C              DUL = INCREMENT DE DEPLACEMENT = PLG * DUG
C              ULP = DEPLACEMENT COURANT      = PLG * UGP
            IF (NDIM.EQ.3) THEN
               CALL UTPVGL(NNO,NC,PGL,DUG,DUL)
               CALL UTPVGL(NNO,NC,PGL,UGP,ULP)
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2VGL(NNO,NC,PGL,DUG,DUL)
               CALL UT2VGL(NNO,NC,PGL,UGP,ULP)
            END IF
C           SEUL LE CAS SYMETRIQUE EST TRAITE
            CALL INFDIS('SYMK',IPLOUF,R8BID,K8BID)
            IF (IPLOUF.NE.1) THEN
               KMESS(1) = OPTION
               KMESS(2) = NOMTE
               KMESS(3) = 'TE0039'
               KMESS(4) = ' '
               CALL U2MESK('F','DISCRETS_12',4,KMESS)
            ENDIF
C
            CALL JEVECH('PCADISK','L',JDC)
            CALL INFDIS('REPK',IREP,R8BID,K8BID)
            CALL DCOPY(NBT,ZR(JDC),1,KLV,1)
            IF (IREP.EQ.1) THEN
               CALL UTPSGL(NNO,NC,PGL,ZR(JDC),KLV)
            END IF
            IF (ZK16(ICOMPO).EQ.'DIS_CHOC') THEN
               CALL R8INIR( 8, ZERO, VARMO, 1)
               CALL R8INIR(12, ZERO, DVL,   1)
               CALL R8INIR(12, ZERO, DPE,   1)
               CALL R8INIR(12, ZERO, DVE,   1)
C              RELATION DE COMPORTEMENT DE CHOC : FORCES NODALES
               CALL JEVECH('PVECTUR','E',IFONO)
               DO 501 I = 1,NEQ
                  ZR(IFONO+I-1) = 0.D0
                  SIM(I) = 0.D0
501            CONTINUE
C
               ILOGIC = 0
               PLOUF = 0.D0
               CALL R8INIR(3,ZERO,FORCE,1)
               CALL DISIEF(NBT,NEQ,NNO,NC,PGL,
     &                     KLV,ULP,SIM,ILOGIC,PLOUF,
     &                     SIP,FONO,FORCE,NDIM)
               CALL DICHOC(NBT,NEQ,NNO,NC,ZI(LMATER),
     &                     DUL,ULP,ZR(IGEOM),PGL,KLV,
     &                     DULY,DVL,DPE,DVE,FORCE,
     &                     VARMO,VARPL,NDIM)
               ILOGIC = 2
               CALL DISIEF(NBT,NEQ,NNO,NC,PGL,
     &                     KLV,ULP,SIM,ILOGIC,DULY,
     &                     SIP,ZR(IFONO),FORCE,NDIM)
               DO 601 I = 1,NEQ
                  ZR(IFONO+I-1) = ZR(IFONO+I-1)-FONO(I)
601            CONTINUE
               IF (NNO.EQ.2) THEN
                  DO 602 I = 1,NC
                     ZR(IFONO+I-1) = 0.D0
602               CONTINUE
               ENDIF
            ENDIF
         ENDIF
      ELSE
C --- ------------------------------------------------------------------
         IF (OPTION.EQ.'SICA_ELNO') THEN
            CALL JEVECH('PCONTRR','L',ICONTG)
            CALL JEVECH('PCONTGL','E',IVECTU)
            NEQ1 = NEQ
            IF ( NOMTE(1:13).EQ.'MECA_POU_D_TG') NEQ1 = 12
            DO 30 IN = 1,NEQ1
               FS(IN) = ZR(ICONTG+IN-1)
30          CONTINUE
C --- ------------------------------------------------------------------
         ELSE IF (OPTION.EQ.'EFCA_ELNO') THEN
            CALL JEVECH('PCONTRR','L',ICONTG)
            CALL JEVECH('PEFFORR','E',IVECTU)
            DO 40 IN = 1,NEQ
               FS(IN) = ZR(ICONTG+IN-1)
40          CONTINUE
            CALL TECACH('NNN','PCAORIR',1,IREPE,IRET)
C --- ------------------------------------------------------------------
         ELSE IF (OPTION.EQ.'FORC_NODA') THEN
            CALL JEVECH('PCONTMR','L',ICONTG)
            CALL JEVECH('PVECTUR','E',IVECTU)
            IF (IELEM.EQ.0) THEN
               DO 50 IN = 1,NEQ
                  FS(IN) = ZR(ICONTG+IN-1)
50             CONTINUE
            ELSE
C              VERIF DU NOMBRE DE POINT DE GAUUS
               CALL ASSERT( (NPG.EQ.2).OR.(NPG.EQ.3) )
               IF ( NPG .EQ. 2 ) THEN
                  DO 60 IN = 1,NC
                     FS(IN)    = -ZR(ICONTG+IN-1)
                     FS(IN+NC) =  ZR(ICONTG+IN+NC-1)
60                CONTINUE
               ELSE
C                 3 POINTS DE GAUSS : C'EST LE 1 ET LE 3
                  DO 65 IN = 1,NC
                     FS(IN)    = -ZR(ICONTG+IN-1)
                     FS(IN+NC) =  ZR(ICONTG+IN+NC+NC-1)
65                CONTINUE
               ENDIF
            END IF
C --- ------------------------------------------------------------------
         ELSE IF (OPTION.EQ.'CHAR_MECA_EPSI_R') THEN
C           --- CARACTERISTIQUES MATERIAUX ---
            CALL JEVECH('PMATERC','L',LMATER)
            NBPAR  = 0
            NOMPAR = '  '
            VALPAR = ZERO
            DO 70 I = 1,NBRES
               VALRES(I) = ZERO
70          CONTINUE
            NOMRES(1) = 'E'
            NOMRES(2) = 'NU'
            NOMRES(3) = 'ALPHA'
            NOMRES(4) = 'RHO'
            CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,
     &                  NOMRES,VALRES,CODRES,1)
            CALL RCVALA(ZI(LMATER),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,
     &                  NOMRES(3),VALRES(3),CODRES(3),0)
            IF (CODRES(3).NE.0) VALRES(3) = ZERO
            IF (CODRES(4).NE.0) VALRES(4) = ZERO
            E   = VALRES(1)
            XNU = VALRES(2)
            G = E/ (DEUX* (UN+XNU))
C           --- CARACTERISTIQUES GENERALES DES SECTIONS ---
            CALL JEVECH('PCAGNPO','L',LSECT)
            LSECT = LSECT - 1
C           --- SECTION INITIALE ---
            A     = ZR(LSECT+1)
            XIY   = ZR(LSECT+2)
            XIZ   = ZR(LSECT+3)
            ALFAY = ZR(LSECT+4)
            ALFAZ = ZR(LSECT+5)
            XJX   = ZR(LSECT+8)
C
            IF ( (NOMTE.NE.'MECA_POU_D_TG') .AND.
     &           (NOMTE.NE.'MECA_POU_D_TGM') ) THEN
C              --- SECTION FINALE ---
               LSECT2 = LSECT + 11
               A2     = ZR(LSECT2+1)
               XIY2   = ZR(LSECT2+2)
               XIZ2   = ZR(LSECT2+3)
            ENDIF
            CALL JEVECH('PEPSINR','L',IDEFI)
            CALL JEVECH('PVECTUR','E',IVECTU)
            EPX = ZR(IDEFI)
            XKY = ZR(IDEFI+1)
            XKZ = ZR(IDEFI+2)
            IF (NOMTE.NE.'MECA_POU_C_T') THEN
               FS(1) = E*A*EPX
               FS(2) = 0.D0
               FS(3) = 0.D0
               FS(4) = 0.D0
               FS(5) = E*XIY*XKY
               FS(6) = E*XIZ*XKZ
               IF ( (NOMTE.EQ.'MECA_POU_D_TG').OR.
     &              (NOMTE.EQ.'MECA_POU_D_TGM') )THEN
                  FS( 7) = 0.D0
                  FS( 8) = E*A*EPX
                  FS( 9) = 0.D0
                  FS(10) = 0.D0
                  FS(11) = 0.D0
                  FS(12) = E*XIY*XKY
                  FS(13) = E*XIZ*XKZ
                  FS(14) = 0.D0
               ELSE IF (NOMTE.EQ.'MECA_POU_D_EM') THEN
C                 RECUPERATION DES CARACTERISTIQUES DES FIBRES
                  CALL PMFITX(ZI(LMATER),1,CARSEC,R8BID)
                  FS(1) = CARSEC(1)*EPX
                  FS(2) = 0.D0
                  FS(3) = 0.D0
                  FS(4) = 0.D0
                  FS(5) = CARSEC(5)*XKY
                  FS(6) = CARSEC(4)*XKZ
                  FS(7) = FS(1)
                  FS(8) = 0.D0
                  FS(9) = 0.D0
                  FS(10) = 0.D0
                  FS(11) = FS(5)
                  FS(12) = FS(6)
               ELSE
                  FS( 7) = E*A2*EPX
                  FS( 8) = 0.D0
                  FS( 9) = 0.D0
                  FS(10) = 0.D0
                  FS(11) = E*XIY2*XKY
                  FS(12) = E*XIZ2*XKZ
               END IF
               FS(1) = -FS(1)
               FS(2) = -FS(2)
               FS(3) = -FS(3)
               FS(4) = -FS(4)
               FS(5) = -FS(5)
               FS(6) = -FS(6)
            ELSE IF (NOMTE.EQ.'MECA_POU_C_T') THEN
C              COORDONNEES DES NOEUDS
               CALL JEVECH('PGEOMER','L',LX)
               LX = LX - 1
               XL = SQRT( (ZR(LX+4)-ZR(LX+1))**2 +
     &                    (ZR(LX+5)-ZR(LX+2))**2 +
     &                    (ZR(LX+6)-ZR(LX+3))**2 )
               IF (XL.EQ.ZERO) THEN
                 CALL TECAEL(IADZI,IAZK24)
                 NOMAIL = ZK24(IAZK24-1+3)(1:8)
                 CALL U2MESK('F','ELEMENTS2_43',1,NOMAIL)
               END IF
               CALL JEVECH('PCAARPO','L',LRCOU)
               RAD = ZR(LRCOU)
               ANGARC = ZR(LRCOU+1)
               XFL  = ZR(LRCOU+2)
               XFLY = XFL
               XFLZ = XFL
               IF (XFL.EQ.ZERO) THEN
                  XFLY = ZR(LRCOU+4)
                  XFLZ = ZR(LRCOU+6)
               END IF
               ANGS2 = TRIGOM('ASIN',XL/ (DEUX*RAD))
               ANG  = ANGS2*DEUX
               XL   = RAD*ANG
               XIY  = XIY/XFLY
               XIZ  = XIZ/XFLZ
               XIY2 = XIY2/XFLY
               XIZ2 = XIZ2/XFLZ
               CALL PTKA10(MATK,E,A,XIY,XIZ,XJX,G,ALFAY,ALFAZ,RAD,ANG,1)
C              REMPLISSAGE DE LA MATRICE CARREE
               IND = 0
               DO 90 I = 1,12
                  FS(I) = ZERO
                  DE(I) = ZERO
                  DO 80 J = 1,I - 1
                     IND = IND + 1
                     BSM(I,J) = MATK(IND)
                     BSM(J,I) = MATK(IND)
80                CONTINUE
                  IND = IND + 1
                  BSM(I,I) = MATK(IND)
90             CONTINUE
               ALONG = DEUX*RAD*EPX*SIN(ANGS2)
               DE(1) = -ALONG*COS(ANGS2)
               DE(2) = ALONG*SIN(ANGS2)
               DE(7) = -DE(1)
               DE(8) = DE(2)
C              CALCUL DES FORCES INDUITES ---
               DO 110 I = 1,6
                  FS(I) = 0.D0
                  FS(I+6) = 0.D0
                  DO 100 J = 1,6
                     FS(I)   = FS(I) + BSM(I,J)*DE(J)
                     FS(I+6) = FS(I+6) + BSM(I+6,J+6)*DE(J+6)
100               CONTINUE
110            CONTINUE
            END IF
         ELSE
            CH16 = OPTION
            CALL U2MESK('F','ELEMENTS2_47',1,CH16)
         END IF
C        RECUPERATION DES ORIENTATIONS ALPHA,BETA,GAMMA
         CALL JEVECH('PCAORIE','L',LORIEN)
C        MATRICE DE ROTATION MGL
         IF (NOMTE.EQ.'MECA_POU_C_T') THEN
C           POUTRE COURBE DE TIMOSKENKO A 6 DDL: COORDONNEES DES NOEUDS
            CALL JEVECH('PGEOMER','L',LX)
            LX = LX - 1
            XL = SQRT( (ZR(LX+4)-ZR(LX+1))**2 +
     &                 (ZR(LX+5)-ZR(LX+2))**2 +
     &                 (ZR(LX+6)-ZR(LX+3))**2 )
            IF (XL.EQ.ZERO) THEN
               CH16 = ' ?????????'
               CALL U2MESK('F','ELEMENTS2_43',1,CH16(:8))
            END IF
            CALL JEVECH('PCAARPO','L',LRCOU)
            RAD    = ZR(LRCOU)
            ANGARC = ZR(LRCOU+1)
            ANGS2  = TRIGOM('ASIN',XL/ (DEUX*RAD))
            CALL MATRO2(ZR(LORIEN),ANGARC,ANGS2,PGL1,PGL2)
            NNOC = 1
            NCC  = 6
            CALL UTPVLG(NNOC,NCC,PGL1,FS,ZR(IVECTU))
            CALL UTPVLG(NNOC,NCC,PGL2,FS(7),ZR(IVECTU+6))
            IF (IREPE.NE.0) THEN
               CALL MATRO2(ZR(IREPE),ANGARC,ANGS2,PGL1,PGL2)
               CALL UTPVLG(NNOC,NCC,PGL1,ZR(IVECTU),ZR(IVECTU))
               CALL UTPVLG(NNOC,NCC,PGL2,ZR(IVECTU+6),ZR(IVECTU+6))
            END IF
         ELSE
            CALL MATROT(ZR(LORIEN),PGL)
            IF (NDIM.EQ.3) THEN
               IF ( NOMTE(1:13).EQ.'MECA_POU_D_TG' .AND.
     &              OPTION.EQ.'EFCA_ELNO') THEN
                  CALL UTPVLG(NNO,NC,PGL,FS,FSS)
                  IF (IREPE.NE.0) THEN
                     CALL MATROT(ZR(IREPE),PGL)
                     CALL UTPVLG(NNO,NC,PGL,FSS,FSS)
                  END IF
                  DO 120 IN=1,6
                     ZR(IVECTU-1+IN)   = FSS(IN)
                     ZR(IVECTU-1+IN+6) = FSS(IN+7)
120               CONTINUE
               ELSE IF ( NOMTE(1:13).EQ.'MECA_POU_D_TG' .AND.
     &              OPTION.EQ.'SICA_ELNO') THEN
                  CALL UTPVLG(NNO,6,PGL,FS,FSS)
                  IF (IREPE.NE.0) THEN
                     CALL MATROT(ZR(IREPE),PGL)
                     CALL UTPVLG(NNO,6,PGL,FSS,FSS)
                  END IF
                  DO 130 IN=1,6
                     ZR(IVECTU-1+IN)   = FSS(IN)
                     ZR(IVECTU-1+IN+6) = FSS(IN+6)
130               CONTINUE
               ELSE
                 CALL UTPVLG(NNO,NC,PGL,FS,ZR(IVECTU))
                 IF (IREPE.NE.0) THEN
                    CALL MATROT(ZR(IREPE),PGL)
                    CALL UTPVLG(NNO,NC,PGL,ZR(IVECTU),ZR(IVECTU))
                 END IF
               ENDIF
            ELSE IF (NDIM.EQ.2) THEN
               CALL UT2VLG(NNO,NC,PGL,FS,ZR(IVECTU))
               IF (IREPE.NE.0) THEN
                  CALL MATROT(ZR(IREPE),PGL)
                  CALL UT2VLG(NNO,NC,PGL,ZR(IVECTU),ZR(IVECTU))
               END IF
            END IF
         END IF
      END IF
      CALL JEDEMA()
      END
