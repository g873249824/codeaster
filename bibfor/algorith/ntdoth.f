      SUBROUTINE NTDOTH ( MODELE, MATE, CARELE, FOMULT, MATCST,
     &                    COECST, INFCHA,RESULT,NUORD)
C
C     THERMIQUE - DONNEES EN THERMIQUE
C     *           **         **
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR PELLET J.PELLET 
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
C
C ----------------------------------------------------------------------
C     SAISIE ET VERIFICATION DE LA COHERENCE DES DONNEES THERMIQUES DU
C     PROBLEME.
C
C VAR MODELE  : NOM DU MODELE
C OUT MATE    : NOM DE LA CARTE CODEE DU CHAMP MATERIAU
C OUT CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C OUT FOMULT  : LISTE DES FONCTIONS MULTIPLICATIVES
C OUT MATCST  : LOGIQUE INDIQUANT SI LE MATERIAU EST CONSTANT / TEMPS
C OUT COECST  : LOGIQUE INDIQUANT SI LES C.L. SONT CONSTANTES / TEMPS
C               POUR LE RECALCUL OU NON DE LA RIGIDITE DANS OP0025
C VAR INFCHA  : CONTIENT LA LISTE DES CHARGES ET DES INFOS SUR
C               SUR LES CHARGES
C IN  : RESULT : NOM DE LA SD RESULTAT
C IN  : NUORD  : NUMERO D'ORDRE
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C 0.1. ==> ARGUMENTS

      INCLUDE 'jeveux.h'
      INTEGER      NUORD, NP, NC, IEXCIT, JORDR
      INTEGER      JLCHA, JINFC, JFCHA
      INTEGER      NBORDR
      CHARACTER*8  RESULT, CRIT
      CHARACTER*16 K16BID, NOMCMD
      CHARACTER*19 INFCHA, KNUME, EXCIT
      CHARACTER*24 MODELE,CARELE,FOMULT,MATE
      REAL*8       PREC
      LOGICAL      MATCST,COECST

C 0.2. ==> COMMUNS


C 0.3. ==> VARIABLES LOCALES

      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'NTDOTH' )

      INTEGER N1,NCHAR,IALICH,IBID,IERD,IALIFC,ICH,IRET,JINF,JPRO,JVAL,
     &        K,NCHCI,LXLGUT
      CHARACTER*8 LCHCI,K8BID,CARA,MODE,TYPCH,PARCHA,REPK,
     &            MATERI,BLAN8
      CHARACTER*16 NOMMOD,NOMEXC,NOMCAR
      CHARACTER*24 LIGRCH,LCHIN,NOMFCT,NOMCHA
      LOGICAL FMULT

C --- NOMBRE MAXIMUM DE TYPE DE CHARGE : NBTYCH

      INTEGER      NBTYCH
      PARAMETER   (NBTYCH = 11)
      CHARACTER*6  NOMLIG(NBTYCH)
      INTEGER      IARG

      DATA NOMLIG/
     &     '.CIMPO'  ,'.SOURE'  ,'.FLURE'  ,'.FLUR2'  ,
     &     '.T_EXT'  ,'.COEFH'  ,'.HECHP'  ,'.GRAIN'  ,'.FLUNL'  ,
     &     '.SOUNL'  , '.RAYO'   /

C====
C 1. PREALABLES
C====
      CALL JEMARQ()
      BLAN8 ='        '
      NOMMOD = 'MODELE'
      NOMCAR = 'CARA_ELEM'
      NOMEXC = 'EXCIT'
      COECST = .TRUE.
      IEXCIT = 1
C
      CALL GETRES(K8BID,K16BID,NOMCMD)
      IF (NOMCMD.EQ.'LIRE_RESU') GOTO 500
C====
C 2. RECUPERATIONS
C====
      IF ( (NOMCMD.EQ.'CALC_ELEM')   .OR.
     &     (NOMCMD.EQ.'CALC_CHAMP')  .OR.
     &     (NOMCMD.EQ.'POST_ELEM')) THEN
C
C     RECUPERATION DU PREMIER NUMERO D'ORDRE
C     --------------------------------------
        KNUME =   '&&'//NOMPRO//'.NUME_ORDRE'
        CALL JEEXIN(KNUME,IRET)
        IF(IRET.NE.0) CALL JEDETR(KNUME)
        CALL GETVR8(' ','PRECISION',1,IARG,1,PREC,NP)
        CALL GETVTX(' ','CRITERE',1,IARG,1,CRIT,NC)
        CALL RSUTNU(RESULT,' ',0,KNUME,NBORDR,PREC,CRIT,IRET)
        CALL JEVEUO(KNUME,'L',JORDR)
        NUORD = ZI(JORDR)
C
C     RECUPERATION DU MODELE, MATERIAU, CARA_ELEM et EXCIT
C     POUR LE NUMERO D'ORDRE NUORDR
C
        CALL RSLESD(RESULT,NUORD,MODELE(1:8),MATERI,CARELE(1:8),
     &              EXCIT,IEXCIT)
C
        IF ( MATERI .NE. BLAN8) THEN
          CALL RCMFMC (MATERI , MATE )
        ELSE
          MATE = ' '
        ENDIF
        CARA = CARELE
      ELSE

C 2.1. ==> LE MODELE
      CALL GETVID(' ',NOMMOD,0,IARG,1,MODE,N1)
      MODELE = MODE

C 2.2. ==> LE MATERIAU
      MATERI = ' '
      CALL GETVID (' ', 'CHAM_MATER',0,IARG,1,MATERI,N1)
      CALL DISMOI('F','THER_F_INST',MATERI,'CHAM_MATER',IBID,REPK,IERD)
      MATCST = .FALSE.
      IF ( REPK .EQ. 'NON' ) MATCST = .TRUE.
      CALL RCMFMC ( MATERI , MATE )

C 2.3. ==> LES CARACTERISTIQUES ELEMENTAIRES
      CALL GETVID(' ',NOMCAR,0,IARG,1,CARA,N1)
      IF (N1.LE.0) CARA = '        '
      CARELE = CARA
      END IF

 500  CONTINUE
C====
C 3. LES CHARGES
C====
      IF(IEXCIT.EQ.1) THEN
         CALL GETFAC (NOMEXC,NCHAR)
      ELSE
         CALL JEVEUO(EXCIT//'.INFC','L',JINFC)
         NCHAR = ZI(JINFC)
      ENDIF
      IF ( NCHAR.NE.0 ) THEN
C 3.1. ==> LISTE DES CHARGES

      CALL JEDETR(INFCHA//'.LCHA')
      CALL WKVECT(INFCHA//'.LCHA','V V K24',NCHAR,IALICH)

      CALL JEDETR(INFCHA//'.INFC')
      CALL WKVECT(INFCHA//'.INFC','V V IS',2*NCHAR+1,JINF)

      ZI(JINF) = NCHAR
      FOMULT = INFCHA//'.FCHA'
      CALL JEDETR(FOMULT)
      CALL WKVECT(FOMULT,'V V K24',NCHAR,IALIFC)
      NCHCI = 0

C 3.2. ==> DETAIL DE CHAQUE CHARGE

      DO 32 , ICH = 1 , NCHAR

        IF(IEXCIT.EQ.1) THEN
            CALL GETVID (NOMEXC,'CHARGE',ICH,IARG,1,NOMCHA,N1)
            ZK24(IALICH+ICH-1) = NOMCHA
        ELSE
            CALL JEVEUO(EXCIT//'.LCHA','L',JLCHA)
            ZK24(IALICH+ICH-1) = ZK24(JLCHA+ICH-1)
            NOMCHA = ZK24(JLCHA+ICH-1)
        ENDIF

C 3.2.2. ==> TYPES DE CHARGES UTILISEES

        CALL DISMOI('F','TYPE_CHARGE',NOMCHA,'CHARGE',IBID,
     &               TYPCH,IERD)
        IF ((TYPCH(1:5).NE.'THER_').AND.(TYPCH(1:5).NE.'CITH_')) THEN
          CALL U2MESK('E','ALGORITH9_5',1,NOMCHA(1:8))
        ENDIF
        LIGRCH =  NOMCHA(1:8)//'.CHTH.LIGRE'

C 3.2.3. ==> ON REGARDE LES CHARGES DU TYPE DIRICHLET PAR AFFE_CHAR_CINE

        IF (TYPCH(1:5).EQ.'CITH_') THEN
          CALL JEEXIN(NOMCHA(1:19)//'.AFCK',IRET)
          CALL ASSERT(IRET.NE.0)
          IF (TYPCH(5:7).EQ.'_FT') THEN
            ZI(JINF+ICH) = -3
          ELSE IF (TYPCH(5:7).EQ.'_FO') THEN
            ZI(JINF+ICH) = -2
          ELSE
            ZI(JINF+ICH) = -1
          ENDIF
        ENDIF

C 3.2.4. ==> ON REGARDE LES CHARGES DU TYPE DIRICHLET

        LCHIN = LIGRCH(1:13)//'.CIMPO.DESC'
        CALL JEEXIN(LCHIN,IRET)
        IF ( IRET .NE. 0 ) THEN
          IF (TYPCH(5:7).EQ.'_FO') THEN
            ZI(JINF+ICH) = 2
            CALL DISMOI('F','PARA_INST',LCHIN(1:19),'CARTE',IBID,
     &                   PARCHA,IERD)
            IF ( PARCHA(1:3) .EQ. 'OUI' ) THEN
              ZI(JINF+ICH) = 3
            ENDIF
          ELSE
            ZI(JINF+ICH) = 1
          ENDIF
        ENDIF

C 3.2.5. ==> FONCTIONS MULTIPLICATIVES DES CHARGES

        FMULT = .FALSE.
        IF(IEXCIT.EQ.1) THEN
           CALL GETVID(NOMEXC,'FONC_MULT',ICH,IARG,1,
     &                 ZK24(IALIFC+ICH-1),N1)
        ELSE
           CALL JEVEUO(EXCIT//'.FCHA','L',JFCHA)
           N1=0
           IF(ZK24(JFCHA-1+ICH)(1:2).NE.'&&') THEN
              N1 = 1
              ZK24(IALIFC+ICH-1)=ZK24(JFCHA+ICH-1)
           ENDIF
        ENDIF
        IF (N1.EQ.0) THEN
          NOMFCT = '&&'//NOMPRO
          CALL JEEXIN(NOMFCT(1:19)//'.PROL',IRET)
          IF ( IRET .EQ. 0 ) THEN
            CALL ASSERT(LXLGUT(NOMFCT).LE.24)
            CALL WKVECT(NOMFCT(1:19)//'.PROL','V V K24',6,JPRO)
            ZK24(JPRO)   = 'CONSTANT'
            ZK24(JPRO+1) = 'CONSTANT'
            ZK24(JPRO+2) = 'TOUTPARA'
            ZK24(JPRO+3) = 'TOUTRESU'
            ZK24(JPRO+4) = 'CC      '
            ZK24(JPRO+5) = NOMFCT

            CALL WKVECT(NOMFCT(1:19)//'.VALE','V V R',2,JVAL)
            ZR(JVAL)  = 1.0D0
            ZR(JVAL+1)= 1.0D0
          ENDIF
          ZK24(IALIFC+ICH-1) = '&&'//NOMPRO
        ELSE
          FMULT  = .TRUE.
        ENDIF

C 3.2.6. ==> ON REGARDE LES AUTRES CHARGES

        DO 326 , K = 2 ,NBTYCH
          LCHIN = LIGRCH(1:13)//NOMLIG(K)//'.DESC'
          CALL EXISD('CHAMP_GD',LCHIN,IRET)
          IF ( IRET .NE. 0 ) THEN
            IF  ((K.GE.7).AND.FMULT) THEN
                CALL U2MESK('F','ALGORITH9_7',1,NOMCHA(1:8))
            ENDIF
            IF (TYPCH(5:7).EQ.'_FO') THEN
              ZI(JINF+NCHAR+ICH) = MAX(2,ZI(JINF+NCHAR+ICH))
              CALL DISMOI('F','PARA_INST',LCHIN(1:19),'CARTE',IBID,
     &                    PARCHA,IERD)
              IF ( PARCHA(1:3) .EQ. 'OUI' ) THEN
C
C               IL EST INUTILE DE REASSEMBLER LA MATRICE DE RIGIDITE
C               SI T_EXT VARIE SEULE (ET COEFH CONSTANT)
C               TRAVAIL A COMPLETER POUR SOURCE, FLUX,...
C
                IF ( NOMLIG(K).NE.'.T_EXT' ) THEN
                  COECST = .FALSE.
                ENDIF
                ZI(JINF+NCHAR+ICH) = MAX(3,ZI(JINF+NCHAR+ICH))
              ENDIF
            ELSE
              ZI(JINF+NCHAR+ICH) = MAX(1,ZI(JINF+NCHAR+ICH))
            ENDIF
          ENDIF
  326   CONTINUE

   32 CONTINUE

      IF ( NCHCI .GT. 0 ) CALL JEECRA (LCHCI,'LONUTI',NCHCI,K8BID)

      ENDIF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()

      END
