      SUBROUTINE OP0148(IER)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/01/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   RESTITUTION D'UN INTERSPECTRE DE REPONSE MODALE DANS LA BASE
C   PHYSIQUE  OPERATEUR REST_SPEC_PHYS
C-----------------------------------------------------------------------
C  OUT  : IER = 0 => TOUT S EST BIEN PASSE
C         IER > 0 => NOMBRE D ERREURS RENCONTREES
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      CHARACTER*32 JEXNOM
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
      PARAMETER   ( NBPAR = 10 )
      INTEGER      IOPTCH, IVAL(3)
      REAL*8       R8B
      COMPLEX*16   C16B
      LOGICAL      INTMOD, INTPHY, INTDON, EXISP
      CHARACTER*3  TYPPAR
      CHARACTER*8  NOMU,TABLE,NOMMAI,MODE,NOMCMP,CMP1,K8B,DEPLA(3),
     +             TYPAR(NBPAR)
      CHARACTER*16 CONCEP, CMD, OPTCAL, OPTCHA, NOPAR(NBPAR), NOPAOU(3),
     +             KVAL(2)
      CHARACTER*19 BASE, TYPFLU, NOMCHA
      CHARACTER*24 FSIC, FSVK, VITE, NUMO, FREQ, REFEBA, NOMFON, SIPO
      CHARACTER*24 NOMNOE, CHREFE, CHVALE, NOMOBJ
C
      DATA DEPLA  /'DX      ','DY      ','DZ      '/
C
      DATA NOPAOU / 'NUME_VITE_FLUI' , 'NUME_ORDRE_I' , 'NUME_ORDRE_J' /
      DATA NOPAR  / 'NOM_CHAM' , 'OPTION' , 'DIMENSION' ,
     +              'NUME_VITE_FLUI' , 'VITE_FLUIDE' ,
     +              'NOEUD_I'  , 'NOM_CMP_I'  ,
     +              'NOEUD_J'  , 'NOM_CMP_J' , 'FONCTION'     /
      DATA TYPAR / 'K16' , 'K16' , 'I' , 'I' , 'R' , 'K8' , 'K8' ,
     +             'K8' , 'K8' , 'K24' /
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETRES ( NOMU, CONCEP, CMD )
      CALL GETVTX ( ' ', 'NOM_CHAM',0,1,1, OPTCHA, IBID )
      CALL GETVTX ( ' ', 'NOM_CMP' ,0,1,1, NOMCMP, IBID )
C
C --- 3.RECUPERATION DU NOM DE LA TABLE 
C       VERIFICATION DES PARAMETRES ---
C
      CALL GETVID( ' ','INTE_SPEC_GENE',0,1,1,TABLE,IBID)
      CALL TBEXP2(TABLE,'OPTION')
      CALL TBEXP2(TABLE,'NUME_ORDRE_I')
      CALL TBEXP2(TABLE,'NUME_ORDRE_J')
      CALL TBEXP2(TABLE,'FONCTION')
      CALL TBEXIP ( TABLE, 'NUME_VITE_FLUI', EXISP ,TYPPAR)
      IF ( .NOT. EXISP ) THEN
         CALL TBEXP2(TABLE,'DIMENSION')
         CALL TBEXP2(TABLE,'NOM_CHAM')
         CALL SPEPH0 ( NOMU, TABLE )
         GOTO 9999
      END IF
CC
C
C --- 1.DETERMINATION DU CAS DE CALCUL ---
C
      IF (OPTCHA(1:4).EQ.'DEPL') THEN
        IOPTCH = 1
      ELSE IF (OPTCHA(1:4).EQ.'VITE') THEN
        IOPTCH = 2
      ELSE IF (OPTCHA(1:4).EQ.'ACCE') THEN
        IOPTCH = 3
      ELSE
        IOPTCH = 4
      ENDIF
C
      IF (IOPTCH.LE.3) THEN
        DO 10 IDEP = 1,3
          IF (NOMCMP.EQ.DEPLA(IDEP)) GOTO 11
  10    CONTINUE
  11    CONTINUE
      ELSE
        IF (NOMCMP(1:4).EQ.'SMFY') THEN
          ISMF = 5
        ELSE
          ISMF = 6
        ENDIF
        CALL GETVID(' ','MODE_MECA',0,1,1,MODE,IBID)
      END IF
C
      CALL GETVTX(' ','OPTION',0,1,1,OPTCAL,IBID)
      INTPHY = .FALSE.
      INTMOD = .FALSE.
      IF (OPTCAL(1:4).EQ.'TOUT') INTPHY = .TRUE.
      IF (OPTCAL(6:9).EQ.'TOUT') INTMOD = .TRUE.
C
C
C --- 2.RECUPERATION DES OBJETS DE LA BASE MODALE PERTURBEE ---
C
      CALL GETVID(' ','BASE_ELAS_FLUI',0,1,1,BASE,IBID)
C
      REFEBA = BASE//'.REMF'
      CALL JEVEUO(REFEBA,'L',IREFBA)
      TYPFLU = ZK8(IREFBA)
      FSIC = TYPFLU//'.FSIC'
      CALL JEVEUO(FSIC,'L',IFSIC)
      ITYPFL = ZI(IFSIC)
      IF (ITYPFL.EQ.1 .AND. IOPTCH.NE.4) THEN
        FSVK = TYPFLU//'.FSVK'
        CALL JEVEUO(FSVK,'L',IFSVK)
        CMP1 = ZK8(IFSVK+1)
        IF (NOMCMP(1:2).NE.CMP1(1:2)) THEN
          CALL UTMESS('A',CMD,'LA COMPOSANTE SELECTIONNEE POUR LA '//
     +         'RESTITUTION EN BASE PHYSIQUE DES INTERSPECTRES EST '//
     +         'DIFFERENTE DE CELLE CHOISIE POUR LE COUPLAGE FLUIDE-'//
     +         'STRUCTURE.')
        ENDIF
      ENDIF
C
      VITE = BASE//'.VITE'
      CALL JEVEUO(VITE,'L',IVITE)
      CALL JELIRA(VITE,'LONUTI',NPV,K8B)
C
      NUMO = BASE//'.NUMO'
      CALL JEVEUO(NUMO,'L',INUMO)
      CALL JELIRA(NUMO,'LONUTI',NBM,K8B)
C
      FREQ = BASE//'.FREQ'
      CALL JEVEUO(FREQ,'L',IFREQ)
C
C --- RECUPERATION DU NOM DU MAILLAGE ---
C
      IV = 1
      WRITE(NOMCHA,'(A8,A5,2I3.3)') BASE(1:8),'.C01.',ZI(INUMO),IV
      CHREFE = NOMCHA//'.REFE'
      CALL JEVEUO(CHREFE,'L',ICHREF)
      NOMMAI = ZK24(ICHREF)(1:8)
      NOMNOE = NOMMAI//'.NOMNOE'
      CALL JELIRA(NOMNOE,'NOMUTI',NBP,K8B)
C
C
C --- 3.RECUPERATION DU NOM DE LA TABLE ---
C
      CALL GETVID(' ','INTE_SPEC_GENE',0,1,1,TABLE,IBID)
C
C --- CARACTERISATION DU CONTENU DE LA TABLE   ---
C --- INTERSPECTRES OU AUTOSPECTRES UNIQUEMENT ---
C
      CALL TBLIVA ( TABLE, 0, K8B, IBID, R8B, C16B, K8B, K8B, R8B,
     +             'OPTION', K8B, IBID, R8B, C16B, K8B, IRET )
      IF ( IRET .NE. 0 ) CALL UTMESS('F','OP0148','Y A UN BUG 1' )
C
      INTDON = .TRUE.
      IF ( K8B(1:4) .EQ. 'DIAG' ) INTDON = .FALSE.
      IF ( INTMOD .AND. .NOT. INTDON ) THEN
        CALL UTMESS('F',CMD,'LA TABL_INTSP DE REPONSE MODALE NE '//
     +       'CONTIENT QUE DES AUTOSPECTRES. LE CALCUL DEMANDE N EST '//
     +       'DONC PAS REALISABLE.')
      ENDIF
C
      NOMOBJ = '&&OP0148.TEMP.NUOR'
      CALL TBEXVE ( TABLE, 'NUME_ORDRE_I', NOMOBJ, 'V', NBMR, K8B )
      CALL JEVEUO ( NOMOBJ, 'L', JNUOR )
      CALL ORDIS  ( ZI(JNUOR) , NBMR )
      CALL WKVECT ( '&&OP0148.MODE', 'V V I', NBMR, INUOR )
      NNN = 1
      ZI(INUOR) = ZI(JNUOR)
      DO 20 I = 2 , NBMR
         IF ( ZI(JNUOR+I-1) .EQ. ZI(INUOR+NNN-1) ) GOTO 20
         NNN = NNN + 1
         ZI(INUOR+NNN-1) = ZI(JNUOR+I-1)
 20   CONTINUE
      NBMR = NNN
      DO 30 IM = 1 , NBM
         IF ( ZI(INUMO+IM-1) .EQ. ZI(INUOR) ) THEN
            IMOD1 = IM
            GOTO 31
         ENDIF
 30   CONTINUE
      CALL UTMESS('F','OP0148','PAS LE BON NUMERO DE MODE' )
 31   CONTINUE
C
      IVAL(1) = 1
      IVAL(2) = ZI(INUOR)
      IVAL(3) = ZI(INUOR)
      CALL TBLIVA ( TABLE, 3, NOPAOU, IVAL, R8B, C16B, K8B, K8B, R8B,
     +              'FONCTION', K8B, IBID, R8B, C16B, NOMFON, IRET )
      IF ( IRET .NE. 0 ) CALL UTMESS('F','OP0148','Y A UN BUG 3' )
      CALL JELIRA ( NOMFON(1:19)//'.VALE', 'LONUTI', NBPF, K8B )
      NBPF = NBPF/3
C
C
C --- 4.RECUPERATION DES NOEUDS ---
C
      CALL GETVEM(NOMMAI,'NOEUD', ' ','NOEUD',
     +  0,1,0,K8B,NBN)
      NBN = -NBN
C
      CALL WKVECT('&&OP0148.TEMP.NOEN','V V K8',NBN,INOEN)
      CALL WKVECT('&&OP0148.TEMP.NOEI','V V I ',NBN,INOEI)
C
      CALL GETVEM(NOMMAI,'NOEUD', ' ','NOEUD',
     +  0,1,NBN,ZK8(INOEN),IBID)
C
      DO 40 IN = 0 , NBN-1
        CALL JENONU ( JEXNOM(NOMNOE,ZK8(INOEN+IN)), ZI(INOEI+IN) )
  40  CONTINUE
C
C
C --- 5.SI RESTITUTION D'INTERSPECTRES DE DEPLACEMENTS, VITESSES ---
C --- OU ACCELERATIONS                                           ---
C --- => RECUPERATION DES DEFORMEES MODALES AUX NOEUDS CHOISIS   ---
C
C --- SINON (RESTITUTION D'INTERSPECTRES DE CONTRAINTES)         ---
C --- => RECUPERATION DES CONTRAINTES MODALES AUX NOEUDS CHOISIS ---
C
C
      CALL WKVECT('&&OP0148.TEMP.CHAM','V V R',NBMR*NBN,ICHAM)
C
      IF (IOPTCH.NE.4) THEN
C
        DO 50 IMR = 1,NBMR
          WRITE(NOMCHA,'(A8,A5,2I3.3)') BASE(1:8),'.C01.',
     +                                  ZI(INUOR+IMR-1),IV
          CHVALE = NOMCHA//'.VALE'
          CALL JEVEUO(CHVALE,'L',IVALE)
          DO 60 IN = 1,NBN
            NPLACE = ZI(INOEI+IN-1)
            ICHAM1 = ICHAM + NBN*(IMR-1) + IN - 1
            IVALE1 = IVALE + 6*(NPLACE-1) + IDEP - 1
            ZR(ICHAM1) = ZR(IVALE1)
  60      CONTINUE
          CALL JELIBE(CHVALE)
  50    CONTINUE
C
      ELSE
C
        DO 70 IMR = 1,NBMR
          NUMOD = ZI(INUOR + IMR - 1)
          CALL RSEXCH(MODE,'SIPO_ELNO_DEPL',NUMOD,SIPO,ICODE)
          IF (ICODE.GT.0) THEN
            CALL UTMESS('F',CMD,'LE CHAMP DES CONTRAINTES MODALES '//
     +                  'DOIT ETRE CALCULE PAR <CALC_ELEM> OPTION '//
     +                  '<SIPO_ELNO_DEPL>.')
          ELSE
            SIPO = SIPO(1:19)//'.CELV'
            CALL JEVEUO(SIPO,'L',ISIP)
            DO 80 IN = 1,NBN
              NPLACE = ZI(INOEI+IN-1)
              ICHAM1 = ICHAM + NBN*(IMR-1) + IN - 1
              IF (NPLACE.EQ.1) THEN
                ZR(ICHAM1) = ZR(ISIP+ISMF-1)
              ELSE IF (NPLACE.EQ.NBP) THEN
                ISIP1 = ISIP + 6 + 12*(NBP-2) + ISMF - 1
                ZR(ICHAM1) = ZR(ISIP1)
              ELSE
                ISIP1 = ISIP + 6 + 12*(NPLACE-2) + ISMF - 1
                ISIP2 = ISIP1 + 6
                ZR(ICHAM1) = (ZR(ISIP1)+ZR(ISIP2))/2.D0
              ENDIF
  80        CONTINUE
          ENDIF
  70    CONTINUE
C
      ENDIF
C
C
C --- 6.CREATION D'UNE MATRICE POUR STOCKER LES SPECTRES ---
C ---   POUR UNE VITESSE DONNEE                          ---
C
      NBFO1 = (NBMR* (NBMR+1))/2
      CALL WKVECT('&&OP0148.TEMP.FONR','V V R',NBPF*NBFO1,IFOR)
      CALL WKVECT('&&OP0148.TEMP.FONI','V V R',NBPF*NBFO1,IFOI)
      CALL WKVECT('&&OP0148.TEMP.DISC','V V R',NBPF      ,IDIS)
C
      CALL TBCRSD ( NOMU, 'G' )
      CALL TBAJPA ( NOMU, NBPAR, NOPAR, TYPAR )
C
      KVAL(1) = OPTCHA
      KVAL(2) = OPTCAL
      CALL TBAJLI ( NOMU, 3, NOPAR, NBMR, R8B, C16B, KVAL, 0 )
C
C
C --- 7.REALISATION DU CALCUL ---
C
      CALL SPEPHY(IOPTCH,INTPHY,INTMOD,NOMU,TABLE,ZR(IFREQ),ZR(ICHAM),
     +            ZR(IFOR),ZR(IFOI),ZR(IDIS),ZK8(INOEN),NOMCMP,
     +            ZI(INUOR),NBMR,NPV,NBN,IMOD1,NBPF,NBM,ZR(IVITE) )
C
      CALL TITRE
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
