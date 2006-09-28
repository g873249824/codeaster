      SUBROUTINE DYLACH( NBPASE, INPSCO, INFCHA, FOMULT, MODELE, MATE,
     &                                       CARELE, VADIRI, VACHAM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE CAMBIER S.CAMBIER
C ----------------------------------------------------------------------
C
C DYNAMIQUE : LECTURE ET ASSEMBLAGE DU CHARGEMENT EN ENTREE DE
C **          *         **                               DYNA_LINE_HARM
C ----------------------------------------------------------------------
C
C      IN NBPASE : NOMBRE DE PARAMETRE SENSIBLE
C      IN INPSCO : STRUCTURE CONTENANT LA LISTE DES NOMS (CF. PSNSIN)
C      IN INFCHA : INFORMATIONS SUR LES CHARGEMENTS
C      OUT FOMULT : LISTE DES FONCTIONS MULTIPLICATIVES
C      OUT MODELE : NOM DU MODELE
C      OUT MATE   : NOM DU CHAMP DE MATERIAU CODE
C      OUT CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C      OUT/JXOU VADIRI : OBJET JEVEUX CONTENANT LA LISTE DES CHAM_NO
C                  RESULTAT DE L'ASSEMBLAGE DES ELEMENTS DE LAGRANGE
C      OUT/JXOU VACHAM : OBJET JEVEUX CONTENANT LA LISTE DES CHAM_NO
C                 RESULTAT DE L'ASSEMBLAGE DES CHARGEMENTS DE NEUMANN
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER       NBPASE
      CHARACTER*19  INFCHA
      CHARACTER*24  VADIRI, VACHAM, FOMULT, MODELE, MATE, CARELE
      CHARACTER*(*) INPSCO
C
C 0.2. ==> COMMUNS
C
C     ----- DEBUT DES COMMUNS JEVEUX -----------------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN DES COMMUNS JEVEUX -------------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C

      INTEGER IBID
      REAL*8 R8BID
      CHARACTER*8 K8BID, BLAN8
      CHARACTER*19  K19BID
      CHARACTER*16 K16BID
      CHARACTER*24 K24BID, BLAN24

      CHARACTER*24  VEDIRI, VECHAM

      REAL*8        PARTPS(3)

      LOGICAL       CHCOMP
      INTEGER       NRPASE,NBVECT
      INTEGER       TYPESE, IE, NCH, IERD
      REAL*8        TIME
      CHARACTER*1   TYPRES
      CHARACTER*4   TYPCAL
      CHARACTER*8   AFFCHA, NOPASE
      CHARACTER*14  NUMDDL
      CHARACTER*19  LIGRMO, MASSE
      CHARACTER*24  CHARGE, NOMCHA,INFOCH, VAPRIN
      CHARACTER*24 STYPSE

C ----------------------------------------------------------------------
C ----------------------------------------------------------------------

C===============
C 1. PREALABLES
C===============
C
      CALL JEMARQ()
C
C====
C 1.1  ==> INITIALISATIONS DIVERSES
C====
C               123456789012345678901234
      BLAN8  = '        '
      BLAN24 = '                        '

      TIME = 0.D0
      MODELE = BLAN24
      MATE   = BLAN24
      CARELE = BLAN24
      FOMULT = BLAN24
      K24BID = BLAN24

      CHCOMP  = .FALSE.
      TYPRES = 'C'

C====
C 1.2 ==> DONNEES,  RECUPERATION D OPERANDES
C====
      CALL GETVID('EXCIT','CHARGE',1,1,1,NOMCHA,NCH)
      CALL DISMOI('F','TYPE_CHARGE',NOMCHA,'CHARGE',IBID,
     &               AFFCHA,IERD)
      IF  (AFFCHA.EQ.'MECA_RI') CHCOMP  = .TRUE.

      IF (NBPASE.GT.0 .AND. CHCOMP) THEN
          CALL U2MESS('F','ALGORITH3_43')
      ENDIF

      CALL GETFAC('EXCIT',NBVECT)
      CALL GETVID(' ','MATR_MASS',0,1,1,MASSE,IBID)

C============================================
C 2. "CHARGEMENT COMPLEXE" EN ENTREE: RECUPERATION DES VECT_ELEM
C                    ET ASSEMBLAGE DES DIFFERENTS VECT_ASSE
C============================================

      IF ( CHCOMP ) THEN


        CALL NMDOMC (MODELE,MATE,CARELE,FOMULT,INFCHA)

        CHARGE = INFCHA//'.LCHA'
        INFOCH = INFCHA//'.INFC'

        CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,
     &                                                   NUMDDL,IE)
        CALL PSNSLE ( INPSCO, 0, 13, VEDIRI )
        VADIRI = BLAN24
        CALL VEDIME ( MODELE, CHARGE, INFOCH, TIME, TYPRES,
     &                TYPESE, NOPASE, VEDIRI)
        CALL ASASVE(VEDIRI,NUMDDL,TYPRES,VADIRI)

        CALL PSNSLE ( INPSCO, 0, 12, VECHAM )
        VACHAM = BLAN24

        CALL VECHMC(MODELE,CARELE,MATE,CHARGE,INFOCH,TIME,VECHAM)
        CALL ASASVE(VECHAM,NUMDDL,TYPRES,VACHAM)

      ELSE

C============================================
C 3. "CHARGEMENT REEL" EN ENTREE: RECUPERATION DES VECT_ELEM
C                    ET ASSEMBLAGE DES DIFFERENTS VECT_ASSE
C               + ASSEMBLAGE DES VECT_ASSE DERIVES
C============================================
C

C====
C 3.1  ==> LECTURE DES DONNEES MECANIQUES
C====

       CALL NMDOME ( MODELE, MATE, CARELE, INFCHA, NBPASE, INPSCO,
     &               BLAN8,IBID)
       FOMULT = INFCHA // '.FCHA'

       CHARGE = INFCHA//'.LCHA'
       INFOCH = INFCHA//'.INFC'
       CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,
     &                                                   NUMDDL,IE)
       LIGRMO = MODELE(1:8)//'.MODELE'
       PARTPS(1) = TIME
       PARTPS(2) = 0.D0
       PARTPS(3) = 0.D0

C====
C 3.2  ==> BOUCLE 32 SUR LES ASSEMBLAGES DES DERIVES DES CHARGEMENTS
C          LE PREMIER PASSAGE, 0, EST CELUI DU CHARGEMENT STANDARD
C          LES PASSAGES SUIVANTS SONT CEUX DES DERIVATIONS
C====
       DO 32 , NRPASE = 0 , NBPASE

C 3.2.1 ==> NOM DU PARAMETRE
         CALL PSNSLE ( INPSCO, NRPASE, 1, NOPASE )

C
C 3.2.2 ==> REPERAGE DU TYPE DE DERIVATION
C             0 : CALCUL STANDARD
C            -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C             1 : DERIVEE SANS INFLUENCE
C             2 : DERIVEE DE LA CL DE DIRICHLET
C             3 : PARAMETRE MATERIAU
C             4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C             5 : FORCE
C             N : AUTRES DERIVEES
C
C
         IF ( NRPASE.GT.0 ) THEN
           CALL METYSE ( NBPASE, INPSCO, NOPASE, TYPESE, STYPSE )
         ELSE
           TYPESE = 0
           STYPSE = ' '
         ENDIF
C

C 3.2.3 ==> LES DIRICHLETS
C
         IF ( TYPESE.EQ.0 .OR. TYPESE.EQ.2 ) THEN

           CALL PSNSLE ( INPSCO, NRPASE, 13, VEDIRI )

           CALL VEDIME ( MODELE, CHARGE, INFOCH, TIME, 'R',
     &              TYPESE, NOPASE, VEDIRI)

           VADIRI = BLAN24
           CALL ASASVE (VEDIRI, NUMDDL, 'R', VADIRI)

C          TRANSFORMATION DES CHAM_NO REELS EN CHAM_NO COMPLEXES
C          ET INCLUSION DU NUMERO DE PARAMETRE DANS LE NOM
           CALL CHOR2C (VADIRI)
         ENDIF


C 3.2.4 ==> CHARGEMENTS DE NEUMANN + DERIV EULERIENNE
C
         IF ( TYPESE.EQ.0 .OR. TYPESE.EQ.-1 .OR. TYPESE.EQ. 5) THEN

           CALL PSNSLE ( INPSCO, NRPASE, 12, VECHAM )
           TYPCAL = 'MECA'
           VAPRIN = BLAN24

           CALL VECHME ( TYPCAL, MODELE, CHARGE, INFOCH, PARTPS,
     &                   CARELE, MATE, K24BID, LIGRMO, VAPRIN,
     &                   NOPASE, TYPESE, STYPSE,
     &                   VECHAM )

           VACHAM = BLAN24
           CALL ASASVE (VECHAM, NUMDDL, 'R', VACHAM)

C          TRANSFORMATION DES CHAM_NO REELS EN CHAM_NO COMPLEXES
C          ET INCLUSION DU NUMERO DE PARAMETRE DANS LE NOM
           CALL CHOR2C (VACHAM)
         ENDIF

C 3.2.5 ==> TERMES COMPLEMENTAIRES POUR DERIVEES MATERIAUX ET LAGR.
C
         IF ( TYPESE.EQ.-1 .OR. TYPESE.EQ.3 ) THEN
C
           IF ( TYPESE.EQ.-1 ) THEN
             TYPCAL = 'DLAG'
             CALL U2MESS('F','ALGORITH3_44')
           ENDIF
C    DANS LE CAS DES DERIVEES P/R AUX MATERIAUX, IL N Y A
C    RIEN A FAIRE CAR LES VECTEURS AU 2ND MEMBRE CORRESPONDANT AUX
C    DERIVEES DEPENDENT DE LA FREQUENCE.
C    UNE ALTERNATIVE PLUS PERFORMANTE SERAIT DE CALCULER ICI LES
C    MATRICES ELEMENTAIRES (ET NON DES VECTEURS ELEMENTAIRES) PUIS
C    DE FAIRE LA MULTIPLICATION MATRICE-VECTEUR DANS LA BOUCLE EN
C    FREQUENCE.
         ENDIF

C
C FIN BOUCLE D ASSEMBLAGE DES DERIVES DES CHARGEMENTS
32     CONTINUE
      ENDIF

C
C============================================
C 4. ==> DESTRUCTION DES OBJETS DE TRAVAIL
C============================================
C
      CALL JEDETC('V',VEDIRI(1:5),1)
      CALL JEDETC('V',VECHAM(1:5),1)

C FIN ------------------------------------------------------------------
      CALL JEDEMA()

      END
