      SUBROUTINE OP0001 ( IER )
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/02/2005   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_20
C-----------------------------------------------------------------------
C                                     EDF / DER / IMA / MMN / I75 / PS
C
C           O P E R A T E U R    M A I L L A G E
C
C                 ---  OPERATEUR NUMERO 1 ---
C
C                                                      2 / 90
C-----------------------------------------------------------------------
C
C       COOVAL          NOM DE L OBJET CHAMP DE GEOMETRIE (VALEURS)
C       COODSC          NOM DE L OBJET CHAMP DE GEOMETRIE (DESCRIPTEUR)
C       COOREF          NOM DE L OBJET CHAMP DE GEOMETRIE (NOM MAILLAGE)
C       GRPNOE          NOM DE L OBJET GROUPE NOEUDS
C       GRPMAI          NOM DE L OBJET GROUPE MAILLES
C       CONNEX          NOM DE L OBJET CONNECTIVITES
C       NOMMAI          NOM DE L OBJET REPERTOIRE DES MAILLES
C       NOMNOE          NOM DE L OBJET REPERTOIRE DES NOEUDS
C       TITRE           NOM DE L OBJET TITRE
C       FORMM           NOM DE L OBJET FORMAT
C
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      INTEGER  IER
C
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
      CHARACTER*32       JEXNOM, JEXNUM,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*16    CMD
      COMMON          /OPMAIL/        CMD
C
C ----- DECLARATIONS
C
      INTEGER         I,N1,IAUX,NIV,IFL,IFM,IOC,ITOUT
      INTEGER         IADIME, NBNOEU, NBMAIL, NBCOOR
      INTEGER         NOCC, NBVAL, IRET, INFMED
      CHARACTER*8     NOMU, NOMG, TOTM, FMT, VERI
      CHARACTER*16    CONCEP
      CHARACTER*24    COOVAL, COODSC, COOREF, GRPNOE, GRPMAI, CONNEX
      CHARACTER*24    FORMM, TITRE, NOMMAI, NOMNOE, TYPMAI
      CHARACTER*24    ADAPMA
      CHARACTER*32    NOMAMD
      REAL*8          DTOL

      CALL JEMARQ ( )
C
C --- RECUPERATION DES ARGUMENTS  DE LA COMMANDE
C
      IFL = 0
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
      CALL GETRES(NOMU,CONCEP,CMD)
C
      CALL GETVIS(' ','UNITE',0,1,1,IFL,IAUX)
C
      CALL GETVTX ( ' ','FORMAT' ,0,1,1,FMT, IAUX )
C
      IF ( FMT(1:3) .EQ. 'MED' ) THEN
        CALL GETVTX ( ' ','NOM_MED' ,0,1,1,NOMAMD, IAUX )
        IF ( IAUX.EQ.0 ) THEN
C                   12345678901234567890123456789012
          NOMAMD = '                                '
        ENDIF
        CALL GETVIS (' ','INFO_MED',0,1,1,INFMED,IAUX)
      ENDIF
C
C
C     CONSTRUCTION DES NOMS JEVEUX POUR L OBJET-MAILLAGE
C     --------------------------------------------------
C
C               123456789012345678901234
      NOMMAI  = NOMU// '.NOMMAI         '
      NOMNOE  = NOMU// '.NOMNOE         '
      COOVAL  = NOMU// '.COORDO    .VALE'
      COODSC  = NOMU// '.COORDO    .DESC'
      COOREF  = NOMU// '.COORDO    .REFE'
      GRPNOE  = NOMU// '.GROUPENO       '
      GRPMAI  = NOMU// '.GROUPEMA       '
      CONNEX  = NOMU// '.CONNEX         '
      TITRE   = NOMU// '           .TITR'
      FORMM   = NOMU// '           .FORM'
      TYPMAI  = NOMU// '.TYPMAIL        '
      ADAPMA  = NOMU// '.ADAPTATION     '
C
C --- LECTURE DU MAILLAGE AU FORMAT ASTER
C
      IF ( FMT(1:5) .EQ. 'ASTER' ) THEN
          CALL LRMAST ( NOMU,NOMMAI,NOMNOE,COOVAL,COODSC,COOREF,
     >                  GRPNOE,GRPMAI,CONNEX,TITRE,TYPMAI,ADAPMA,
     >                  IFM,IFL,NBNOEU,NBMAIL,NBCOOR )
C
C --- LECTURE DU MAILLAGE AU FORMAT MED
C
      ELSEIF (FMT(1:3) .EQ. 'MED' ) THEN
          CALL LRMHDF ( NOMAMD,
     >                  NOMU,NOMMAI,NOMNOE,COOVAL,COODSC,COOREF,
     >                  GRPNOE,GRPMAI,CONNEX,TITRE,FORMM,TYPMAI,
     >                  ADAPMA,IFM,IFL,NIV,INFMED,NBNOEU,NBMAIL,
     >                  NBCOOR )
      ENDIF
C
C       CALCUL D'UNE ABSCISSE CURVILIGNE SUR LE MAILLAGE
C       ------------------------------------------------
C
      CALL GETFAC('ABSC_CURV',IOC)
      IF(IOC.EQ.1) THEN
        ITOUT = 0
        CALL GETVTX('ABSC_CURV','TOUT',1,1,0,ZK8,NBVAL)
        NBVAL = ABS(NBVAL)
        IF (NBVAL .NE. 0) THEN
          CALL GETVTX('ABSC_CURV','TOUT',1,1,1,TOTM,N1)
          IF(N1.NE.0) THEN
            ITOUT = 1
            CALL ABSCUR(CONNEX,TYPMAI,COOVAL,NOMU,ITOUT)
C
          ENDIF
        ELSE
          CALL GETVEM(NOMU,'GROUP_MA','ABSC_CURV','GROUP_MA',
     >                1,1,0,ZK8,NBVAL)
          NBVAL=ABS(NBVAL)
          IF (NBVAL.NE.0) THEN
            CALL UTMESS('E',CMD,' OPTION CALCUL DE L ABSC_CURV SUR '
     >       //' UN GROUP_MA NON IMPLANTEE. ')
          ENDIF
        ENDIF
      ENDIF

  
C     CREATION DE L'OBJET .DIME
C     --------------------------
      CALL WKVECT(NOMU//'.DIME','G V I',6,IADIME)
      ZI(IADIME-1+1)= NBNOEU
      ZI(IADIME-1+3)= NBMAIL
      ZI(IADIME-1+6)= NBCOOR
C
      CALL CARGEO ( NOMU )

  
C     PHASE DE VERIFICATION DU MAILLAGE
C     ---------------------------------
      CALL GETVTX('VERI_MAIL','VERIF',1,1,1,VERI,IRET)
      IF (VERI.EQ.'OUI') THEN
        CALL GETVR8('VERI_MAIL','APLAT',1,1,1,DTOL,IRET)
        CALL CHCKMA(NOMU,CMD,DTOL)
      ELSE
         CALL UTMESS('A',CMD,'- PHASE DE VERIFICATION DU'
     &   //' MAILLAGE DESACTIVEE')
      ENDIF

  
C     IMPRESSIONS DU MOT CLE INFO :
C     ---------------------------------
      CALL INFOMA(NOMU)
  
      CALL JEDEMA ( )
      END
