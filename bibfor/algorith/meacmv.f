      SUBROUTINE MEACMV ( MODELE, MATE, CARELE, FOMULT, LISCHA,
     &                    ITPS, PARTPS,
     &                    NUMEDD, ASSMAT, SOLVEU,
     &                    VECASS, MATASS, MAPREC, CNCHCI,
     &                    TYPESE, STYPSE, NOPASE, VAPRIN, REPRIN,
     &                    BASE, COMPOR )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/01/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_21
C ----------------------------------------------------------------------
C     MECANIQUE STATIQUE - ACTUALISATION DES CHARGEMENTS MECANIQUES
C     **                   *                 *           *
C ----------------------------------------------------------------------
C IN  MODELE  : NOM DU MODELE
C IN  MATE    : NOM DU MATERIAU
C IN  CARELE  : NOM D'1 CARAC_ELEM
C IN  FOMULT  : LISTE DES FONCTIONS MULTIPLICATRICES
C IN  LISCHA  : INFORMATION SUR LES CHARGEMENTS
C IN  ITPS    : NUMERO DU PAS DE TEMPS
C IN  PARTPS  : PARAMETRES TEMPORELS
C IN  NUMEDD  : PROFIL DE LA MATRICE
C IN  ASSMAT  : BOOLEEN POUR LE CALCUL DE LA MATRICE
C IN  SOLVEU  : METHODE DE RESOLUTION 'LDLT' OU 'GCPC'
C OUT VECASS  : VECTEUR ASSEMBLE SECOND MEMBRE
C OUT MATASS,MAPREC  MATRICE DE RIGIDITE ASSEMBLEE
C OUT CNCHCI  : OBJET DE S.D. CHAM_NO DIMENSIONNE A LA TAILLE DU
C               PROBLEME, VALANT 0 PARTOUT, SAUF LA OU LES DDLS IMPOSES
C               SONT TRAITES PAR ELIMINATION (= DEPLACEMENT IMPOSE)
C IN  BASE    : BASE DE TRAVAIL
C IN/OUT  MAPREC  : MATRICE PRECONDITIONNEE
C IN  TYPESE  : TYPE DE SENSIBILITE
C                0 : CALCUL STANDARD, NON DERIVE
C                SINON : DERIVE (VOIR METYSE)
C IN  STYPSE  : SOUS-TYPE DE SENSIBILITE (VOIR NTTYSE)
C . POUR UN CALCUL DE DERIVEE, ON A LES DONNEES SUIVANTES :
C IN  NOPASE  : NOM DU PARAMETRE SENSIBLE
C IN  VAPRIN  : VARIABLE PRINCIPALE (DEPLACEMENT) A L'INSTANT COURANT
C IN  REPRIN  : RESULTAT PRINCIPAL
C IN  COMPOR  : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
C----------------------------------------------------------------------
      IMPLICIT NONE

C 0.1. ==> ARGUMENTS

      INTEGER       ITPS,TYPESE
      LOGICAL       ASSMAT
      CHARACTER*1   BASE
      CHARACTER*19  LISCHA,SOLVEU,VECASS,MATASS,MAPREC
      CHARACTER*24  CNCHCI,MODELE,CARELE,FOMULT,NUMEDD,STYPSE,COMPOR
      CHARACTER*(*) VAPRIN,REPRIN,NOPASE,MATE
      REAL*8        PARTPS(*)

C 0.2. ==> COMMUNS

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      CHARACTER*8        ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                 ZK32
      CHARACTER*80                                          ZK80
      COMMON  / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C 0.3. ==> VARIABLES LOCALES

      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'MEACMV' )

      INTEGER      JCHAR,JINF,NH,IERR,JTP,IRET,IAUX,JAUX,IBID
      INTEGER      NCHAR,TYPCUM
      REAL*8       R8VIDE,RUNDF
      REAL*8       TIME,ALPHA
      CHARACTER*1  TYPRES,TYPCOE
      CHARACTER*2  CODRET
      CHARACTER*4  TYPCAL
      CHARACTER*8  MATELE,K8BID
      CHARACTER*8  NOMODE,NOMA
      CHARACTER*14 COM
      CHARACTER*19 CHVREF, CHVARC
      CHARACTER*16 NOSY,OPTION
      CHARACTER*19 CHAMN1,CHAMN2,CHAMN3,CHAMN4,CHEXTR,LIGRMO
      CHARACTER*24 CHGEOM,CHCARA(18),CHHARM,CHAMEL,K24BID,CHTIME,
     &             BLAN24,CHSIG,VEDIRI,VADIRI,VELAPL,VALAPL,
     &             VECOMP,VACOMP,VECHAM,VACHAM,CHLAPL,CHCOMP,CHDIRI,
     &             CHCHAM,CHTHS,CHARGE,INFOCH,VECTHS,CONTEG,CONTEN,
     &             DERITE
      LOGICAL      ASS1ER,LBID,LHYDR,LSECH,LTEMP,LPTOT
      COMPLEX*16   CALPHA


C DEB-------------------------------------------------------------------
C====
C 1. PREALABLES
C====

      CALL JEMARQ()
      RUNDF = R8VIDE()

C 1.2. ==> NOM DES STRUCTURES

C 1.2.1. ==> FIXES

C               12   345678   9012345678901234
      COM    = '&&'//NOMPRO//'.COM__'
      CONTEG = '&&'//NOMPRO//'.SIEF_ELGA '
      CONTEN = '&&'//NOMPRO//'.SIGM_ELNO '
      DERITE = '&&'//NOMPRO//'.DERIVEE_TEMP   '
      CHVARC = '&&'//NOMPRO//'.CHVRC'
C     -- POUR NE CREER Q'UN SEUL CHAMP DE VARIABLES DE REFERENCE
      CHVREF = MODELE(1:8)//'.CHVCREF'

C               12345678
      MATELE = '&&MATELE'

C
      BLAN24 = ' '
      K24BID = BLAN24
      LHYDR=.FALSE.
      LSECH=.FALSE.
      LPTOT=.FALSE.
      CHTHS = BLAN24

C 1.2. ==> LES CONSTANTES

      TIME = PARTPS(1)

      CHARGE = LISCHA//'.LCHA'

      CALL NMVCLE ( MODELE, MATE,CARELE, LISCHA, TIME, COM, CODRET)
      CALL VRCREF ( MODELE(1:8), MATE(1:8),CARELE(1:8),CHVREF)
      CALL NMVCEX ( 'TOUT',COM,CHVARC )
      CALL NMVCD2 ( 'HYDR',MATE,LHYDR, LBID )
      CALL NMVCD2 ( 'PTOT',MATE,LPTOT, LBID )
      CALL NMVCD2 ( 'SECH',MATE,LSECH, LBID )
      CALL NMVCD2 ( 'TEMP',MATE,LTEMP, LBID )

      CALL JEVEUO (CHARGE,'L',JCHAR)
      INFOCH = LISCHA//'.INFC'
      CALL JEVEUO (INFOCH,'L',JINF)
      NCHAR = ZI(JINF)

      NH = 0

      TYPRES = 'R'
      NOMODE = MODELE(1:8)
      LIGRMO = NOMODE//'.MODELE'

      ASS1ER = .FALSE.

C 1.3. ==> DANS CERTAINS CAS DE DERIVEE, CALCUL DES CONTRAINTES PAR
C          ELEMENT AUX POINTS DE GAUSS ET AUX NOEUDS POUR LE NOUVEAU
C          CHAMP DE DEPLACEMENT.
C          ON REMARQUERA QUE CES CALCULS SONT PEUT-ETRE DEMANDES EN
C          TANT QU'OPTION. MAIS IL EST FAIT PLUS TARD DANS OP0046,
C          HORS DE LA BOUCLE EN TEMPS ACTUELLE. ON CHOISIT DONC DE
C          FAIRE EVENTUELLEMENT PLUSIEURS FOIS LE CALCUL POUR
C          SIMPLIFIER LA PROGRAMMATION.

      IF ( TYPESE.EQ.-1 ) THEN

        ALPHA  = 0.D0
        CALPHA = (0.D0 , 0.D0)
        CALL DISMOI('F','NOM_MAILLA',NOMODE,'MODELE',IAUX,NOMA,IRET)

C        DO 13 , IAUX = 1 , 2
C
C          IF ( IAUX.EQ.1 ) THEN
C            NOSY = 'SIEF_ELGA  '
C            CHAMEL = CONTEG
C          ELSE
C            NOSY = 'SIGM_ELNO  '
C            CHAMEL = CONTEN
C          ENDIF
C
C          CALL MECHAM ( NOSY, NOMODE, 0, ' ', CARELE(1:8), NH,
C     &                  CHGEOM, CHCARA, CHHARM, IRET )
C
C          CALL MECHTI ( CHGEOM(1:8), TIME, RUNDF, RUNDF, CHTIME )
C          JAUX = 0
C          CALL MECALC ( NOSY, NOMODE, VAPRIN, CHGEOM, MATE, CHCARA,
C     &                  K24BID, K24BID,CHTIME, BLAN24, CHHARM,
C     &                  BLAN24, BLAN24, BLAN24, BLAN24, K24BID, BLAN24,
C     &                  TYPCOE, ALPHA, CALPHA, K24BID, K24BID,
C     &                  CHAMEL, K24BID, LIGRMO, BASE, CHVARC, CHVREF,
C     &                  K24BID, K24BID,
C     &                  K24BID, K24BID, K8BID, JAUX, K24BID, IRET )
C
C  13    CONTINUE

        NOSY = 'SIEF_ELGA  '
        CHAMEL = CONTEG

        CALL MECHAM ( NOSY, NOMODE, 0, ' ', CARELE(1:8), NH,
     &                CHGEOM, CHCARA, CHHARM, IRET )

        CALL MECHTI ( CHGEOM(1:8), TIME, RUNDF, RUNDF, CHTIME )
        JAUX = 0
        CALL MSCALC ( NOSY, NOMODE, VAPRIN, CHGEOM, MATE, CHCARA,
     &                K24BID, K24BID,CHTIME, BLAN24, CHHARM,
     &                BLAN24, BLAN24, BLAN24, BLAN24, K24BID, BLAN24,
     &                TYPCOE, ALPHA, CALPHA, K24BID, K24BID,
     &                CHAMEL, K24BID, LIGRMO, BASE, CHVARC, CHVREF,
     &                K24BID, K24BID,
     &                K24BID, K24BID, K8BID, JAUX, K24BID, IRET )

        NOSY = 'SIGM_ELNO  '
        CHAMEL = CONTEN
        CHSIG = CONTEG

        CALL MECHAM ( NOSY, NOMODE, 0, ' ', CARELE(1:8), NH,
     &                CHGEOM, CHCARA, CHHARM, IRET )

        CALL MECHTI ( CHGEOM(1:8), TIME, RUNDF, RUNDF, CHTIME )
        JAUX = 0
        CALL MSCALC ( NOSY, NOMODE, VAPRIN, CHGEOM, MATE, CHCARA,
     &                K24BID, K24BID,CHTIME, BLAN24, CHHARM,
     &                CHSIG, BLAN24, BLAN24, BLAN24, K24BID, BLAN24,
     &                TYPCOE, ALPHA, CALPHA, K24BID, K24BID,
     &                CHAMEL, K24BID, LIGRMO, BASE, CHVARC, CHVREF,
     &                K24BID, K24BID,
     &                K24BID, K24BID, K8BID, JAUX, K24BID, IRET )

C    RECOPIE DE "SIGM_ELNO" CAR ON EN A BESOIN POUR LES DERIVEES

        CALL RSEXCH (REPRIN,'SIGM_ELNO',ITPS,CHEXTR,IRET)
        IF ( IRET .LE. 100 ) THEN
          CALL COPISD('CHAMP_GD','G',CONTEN(1:19),CHEXTR(1:19))
          CALL RSNOCH (REPRIN,'SIGM_ELNO',ITPS,' ')
        ENDIF

      ENDIF

C====
C 2. LE PREMIER MEMBRE
C====

C 2.1. ==> CALCULS ELEMENTAIRES DU 1ER MEMBRE:

      IF ( ASSMAT ) THEN

        CALL UTTCPU('CPU.OP0046.1', 'DEBUT',' ')
        CALL MERIME ( MODELE(1:8),NCHAR,ZK24(JCHAR),MATE,
     &                CARELE(1:8),.TRUE.,TIME,COMPOR,MATELE,NH,BASE)
        ASS1ER = .TRUE.
        CALL UTTCPU('CPU.OP0046.1', 'FIN',' ')

      ENDIF

C 2.2. ==> ASSEMBLAGE

      IF ( ASS1ER ) THEN

        CALL UTTCPU('CPU.OP0046.2', 'DEBUT',' ')
        CALL ASMATR ( 1, MATELE, ' ', NUMEDD, SOLVEU,
     &                LISCHA, 'ZERO', 'V', 1, MATASS )
        CALL DETRSD ('MATR_ELEM',MATELE)

C 2.3. ==> DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONEMENT

        CALL PRERES(SOLVEU,'V',IERR,MAPREC,MATASS,IBID,-9999)


        ASS1ER = .FALSE.
        CALL UTTCPU('CPU.OP0046.2', 'FIN',' ')

      ENDIF

C====
C 3. LES CHARGEMENTS
C====

      CALL UTTCPU('CPU.OP0046.3', 'DEBUT',' ')

C 3.1. ==> LES DIRICHLETS

      IF ( TYPESE.EQ.0 .OR. TYPESE.EQ.2 ) THEN

      VADIRI = BLAN24
      VEDIRI = BLAN24
      CHDIRI = BLAN24

      CALL VEDIME ( MODELE, CHARGE, INFOCH, TIME, TYPRES,
     &              TYPESE, NOPASE, VEDIRI )

      CALL ASASVE ( VEDIRI, NUMEDD,TYPRES,VADIRI)
      CALL ASCOVA('D', VADIRI,FOMULT,'INST',TIME,TYPRES,CHDIRI)


      ENDIF

C 3.2. ==> CAS DU CHARGEMENT TEMPERATURE, HYDRATATION, SECHAGE,
C          PRESSION TOTALE (CHAINAGE HM)

      IF ( TYPESE.EQ.0 ) THEN

        IF ( LTEMP .OR. LHYDR .OR. LSECH .OR. LPTOT) THEN
          VECTHS = BLAN24
          IF ( LTEMP) THEN
            CALL VECTME(MODELE,CARELE,MATE,COMPOR,COM,VECTHS)
            CALL ASASVE(VECTHS,NUMEDD,TYPRES,CHTHS)
          ENDIF
          IF ( LHYDR  ) THEN
            OPTION = 'CHAR_MECA_HYDR_R'
            CALL VECVME(OPTION,MODELE,CARELE,
     &                  MATE  ,COMPOR,COM   ,NUMEDD,CHTHS)
          ENDIF
          IF ( LPTOT  ) THEN
            OPTION = 'CHAR_MECA_PTOT_R'
            CALL VECVME(OPTION,MODELE,CARELE,
     &                  MATE  ,COMPOR,COM   ,NUMEDD,CHTHS)
          ENDIF
          IF ( LSECH  ) THEN
            OPTION = 'CHAR_MECA_SECH_R'
            CALL VECVME(OPTION,MODELE,CARELE,
     &                  MATE  ,COMPOR,COM   ,NUMEDD,CHTHS)
          ENDIF

          CALL JEVEUO (CHTHS,'L',JTP)
          CHTHS=ZK24(JTP)(1:19)
        ENDIF

      ENDIF

C 3.3. ==> FORCES DE LAPLACE

      IF ( TYPESE.EQ.0 ) THEN

      VALAPL = BLAN24
      VELAPL = BLAN24
      CHLAPL = BLAN24
      K24BID = BLAN24

      CALL VELAME ( MODELE, CHARGE, INFOCH,K24BID, VELAPL)


      CALL ASASVE ( VELAPL, NUMEDD,TYPRES,VALAPL)
      CALL ASCOVA('D', VALAPL,FOMULT,'INST',TIME,TYPRES,CHLAPL)

      ENDIF

C 3.4. ==> AUTRES CHARGEMENTS

      IF ( TYPESE.LE.0 .OR. TYPESE.GE.5 ) THEN

      VACHAM = BLAN24
      VECHAM = BLAN24
      CHCHAM = BLAN24
      K24BID = BLAN24

      IF ( TYPESE.EQ.-1 ) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        TYPCAL = 'MECA'
      ENDIF
      CALL VECHME ( TYPCAL, MODELE, CHARGE, INFOCH, PARTPS,
     &              CARELE, MATE, CHVARC, LIGRMO,
     &              VAPRIN, NOPASE, TYPESE, STYPSE,
     &              VECHAM )

      CALL ASASVE ( VECHAM, NUMEDD,TYPRES,VACHAM)
      CALL ASCOVA('D', VACHAM,FOMULT,'INST',TIME,TYPRES,CHCHAM)

      ENDIF

C 3.5. ==> TERMES COMPLEMENTAIRES POUR CERTAINES DERIVEES

      IF ( TYPESE.EQ.-1 .OR. TYPESE.EQ.3 .OR. TYPESE.EQ.4 ) THEN

      VACOMP = BLAN24
      VECOMP = BLAN24
      CHCOMP = BLAN24
      K24BID = BLAN24

C     ... DETERMINATION DE LA DERIVEE % DONNEES MATERIAUX        (MECA)

      IF ( TYPESE.EQ.-1 ) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        TYPCAL = 'MECA'
      ENDIF

      CALL VECHDE ( TYPCAL, MODELE(1:8),NCHAR,ZK24(JCHAR), MATE,
     &              CARELE(1:8), PARTPS,
     &              VAPRIN, CONTEG, CHVARC, DERITE, LIGRMO,
     &              NOPASE, VECOMP )

      CALL ASASVE ( VECOMP, NUMEDD,TYPRES,VACOMP)
      CALL ASCOVA('D', VACOMP,FOMULT,'INST',TIME,TYPRES,CHCOMP)

      ENDIF

C 3.6. ==> SECOND MEMBRE DEFINITIF : VECASS

C 3.6.1. ==>  0 : CALCUL STANDARD
C            -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C             1 : DERIVEE SANS INFLUENCE
C             2 : DERIVEE DE LA CL DE DIRICHLET
C             3 : PARAMETRE MATERIAU
C             4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C             5 : FORCE
C             N : AUTRES DERIVEES


      IF ( TYPESE.EQ.0 ) THEN
        TYPCUM = 3
        CHAMN1 = CHDIRI(1:19)
        CHAMN2 = CHCHAM(1:19)
        CHAMN3 = CHLAPL(1:19)
        IF ( CHTHS(1:19).NE.' ' ) THEN
          TYPCUM = 4
          CHAMN4 = CHTHS(1:19)
        ENDIF
      ELSEIF ( TYPESE.EQ.-1 ) THEN
        TYPCUM = 2
        CHAMN1 = CHCHAM(1:19)
        CHAMN2 = CHCOMP(1:19)
      ELSEIF ( TYPESE.EQ.1  ) THEN
        TYPCUM = 0
      ELSEIF ( TYPESE.EQ.2  ) THEN
        TYPCUM = 1
        CHAMN1 = CHDIRI(1:19)
      ELSEIF ( TYPESE.EQ.3  ) THEN
        TYPCUM = 1
        CHAMN1 = CHCOMP(1:19)
      ELSEIF ( TYPESE.EQ.4  ) THEN
        TYPCUM = 1
        CHAMN1 = CHCOMP(1:19)
      ELSEIF ( TYPESE.EQ.5 ) THEN
        TYPCUM = 1
        CHAMN1 = CHCHAM(1:19)
      ELSE
        CALL U2MESK('A','SENSIBILITE_9',1,NOPASE)
      ENDIF

C 3.6.2. ==> CONCATENATION DES SECOND(S) MEMBRE(S) AVEC EVENTUELLEMENT
C            LEURS ENCAPSULATIONS FETI

      CALL FETCCN(CHAMN1,CHAMN2,CHAMN3,CHAMN4,TYPCUM,VECASS)


C 3.7. ==> CHARGES CINEMATIQUES                              ---& CNCHCI

      CNCHCI = BLAN24
      CALL ASCAVC(CHARGE,INFOCH,FOMULT,NUMEDD,TIME,CNCHCI)

C====
C 4. DESTRUCTION DES CHAMPS TEMPORAIRES
C====

      IF ((TYPESE.EQ.0).OR.(TYPESE.EQ.2)) THEN
        CALL DETRSD('VECT_ELEM',VEDIRI(1:19))
        CALL DETRSD('CHAMP_GD',CHDIRI(1:19))
      ENDIF
      IF (TYPESE.EQ.0) THEN
        CALL DETRSD('VECT_ELEM',VELAPL(1:19))
        CALL DETRSD('CHAMP_GD',CHLAPL(1:19))
      ENDIF
      IF ((TYPESE.LE.0) .OR. (TYPESE.GE.5)) THEN
        CALL DETRSD('VECT_ELEM',VECHAM(1:19))
        CALL DETRSD('CHAMP_GD',CHCHAM(1:19))
      ENDIF
      IF ((TYPESE.EQ.-1) .OR. (TYPESE.EQ.3).OR. (TYPESE.EQ.4)) THEN
        CALL DETRSD('VECT_ELEM',VECOMP(1:19))
        CALL DETRSD('CHAMP_GD',CHCOMP(1:19))
      ENDIF
      IF (TYPESE.EQ.0) THEN
        IF ( LTEMP ) THEN
          CALL DETRSD('VECT_ELEM',VECTHS(1:19))
          CALL DETRSD('CHAMP_GD',CHTHS(1:19))
        ENDIF
      ENDIF


      CALL JEDEMA()
      END
