      SUBROUTINE DLTALI ( NRORES, NBPASE, INPSCO,
     &                    NEQ,
     &                    IMAT, MASSE, RIGID, LIAD, LIFO,
     &                    NCHAR, NVECA,
     &                    LCREA, LPREM, LAMORT, T0,
     &                    MATE,CARELE,CHARGE,INFOCH,FOMULT,
     &                    MODELE, NUMEDD, NUME,
     &                    SOLVEU, CRITER,
     &                    DEP0, VIT0, ACC0,
     &                    BASENO, TABWK )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2010   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C ----------------------------------------------------------------------
C
C       DYNAMIQUE LINEAIRE TRANSITOIRE - ALGORITHME - INITIALISATION
C       -         -        -             --           -
C ----------------------------------------------------------------------
C  IN  : NRORES    : NUMERO DE LA RESOLUTION
C                  0 : CALCUL STANDARD
C                 >0 : CALCUL DE LA DERIVEE NUMERO NRORES
C  IN  : NBPASE    : NOMBRE DE PARAMETRES SENSIBLES
C  IN  : INPSCO    : STRUCTURE CONTENANT LA LISTE DES NOMS
C  IN  : NEQ       : NOMBRE D'EQUATIONS
C  IN  : IMAT      : TABLEAU D'ADRESSES POUR LES MATRICES
C  IN  : MASSE     : MATRICE DE MASSE
C  IN  : RIGID     : MATRICE DE RIGIDITE
C  IN  : LIAD      : LISTE DES ADRESSES DES VECTEURS CHARGEMENT (NVECT)
C  IN  : LIFO      : LISTE DES NOMS DES FONCTIONS EVOLUTION (NVECT)
C  IN  : NCHAR     : NOMBRE D'OCCURENCES DU MOT CLE CHARGE
C  IN  : NVECA     : NOMBRE D'OCCURENCES DU MOT CLE VECT_ASSE
C  IN  : LCREA     : LOGIQUE INDIQUANT SI IL Y A REPRISE
C  IN  : LAMORT    : LOGIQUE INDIQUANT SI IL Y A AMORTISSEMENT
C  IN  : MATE      : NOM DU CHAMP DE MATERIAU
C  IN  : CARELE    : CARACTERISTIQUES DES POUTRES ET COQUES
C  IN  : CHARGE    : LISTE DES CHARGES
C  IN  : INFOCH    : INFO SUR LES CHARGES
C  IN  : FOMULT    : LISTE DES FONC_MULT ASSOCIES A DES CHARGES
C  IN  : MODELE    : MODELE
C  IN  : NUMEDD    : NUME_DDL DE LA MATR_ASSE RIGID
C  IN  : NUME      : NUMERO D'ORDRE DE REPRISE
C  IN  : SOLVEU    : NOM DU SOLVEUR
C  VAR : DEP0      : TABLEAU DES DEPLACEMENTS A L'INSTANT N
C  VAR : VIT0      : TABLEAU DES VITESSES A L'INSTANT N
C  VAR : ACC0      : TABLEAU DES ACCELERATIONS A L'INSTANT N
C  IN  : BASENO    : BASE DES NOMS DE STRUCTURES
C ----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
C
      INTEGER NRORES, NBPASE
      INTEGER NEQ
      INTEGER NVECA, NCHAR
      INTEGER LIAD(*)
      INTEGER IMAT(3), NUME
C
      REAL*8 DEP0(*), VIT0(*), ACC0(*)
      REAL*8 T0,RBID
      REAL*8 TABWK(*)
C
      CHARACTER*8 BASENO
      CHARACTER*8 MASSE, RIGID
      CHARACTER*13 INPSCO
      CHARACTER*19 SOLVEU
      CHARACTER*24 CHARGE, INFOCH, FOMULT, MATE, CARELE
      CHARACTER*24 MODELE, NUMEDD
      CHARACTER*24 LIFO(*)
      CHARACTER*24 CRITER

      LOGICAL LCREA, LPREM
      LOGICAL LAMORT
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC,CBID
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'DLTALI' )
C
      INTEGER IFORC0, IFORC1,IBID
      INTEGER INCHAC
      INTEGER IRESOL
      INTEGER LVALE, LACCE
C
      INTEGER ICODE,JSTD,IEQ,JAUX
      CHARACTER*1 TYPSOL
      CHARACTER*8  MATREI, MAPREI
      CHARACTER*19 CHSOL
      CHARACTER*19 FORCE0, FORCE1
      CHARACTER*24 CINE
      CHARACTER*24 VAPRIN, VACOMP
C
C     -----------------------------------------------------------------
      TYPSOL = 'R'
C
C====
C 1. NOM DES STRUCTURES
C====
C 1.1. ==> NOM DES STRUCTURES ASSOCIEES AUX DERIVATIONS
C                8. VARIABLE COMPLEMENTAIRE NUMERO 1 INSTANT N
C               10. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N
C
      JAUX = 8
      CALL PSNSLE ( INPSCO, NRORES, JAUX, FORCE0 )
C
      CALL VTCREB (FORCE0, NUMEDD, 'V', 'R', NEQ)
      CALL JEVEUO (FORCE0(1:19)//'.VALE', 'E', IFORC0)
C
      JAUX = 10
      CALL PSNSLE ( INPSCO, NRORES, JAUX, FORCE1 )
C
      CALL VTCREB (FORCE1, NUMEDD, 'V', 'R', NEQ)
      CALL JEVEUO (FORCE1(1:19)//'.VALE', 'E', IFORC1)
C
C 1.2. ==> NOM DES STRUCTURES DE TRAVAIL
C
C               12   345678   9012345678901234
      CHSOL  = '&&'//NOMPRO//'.SOLUTION  '
C               123456789012345678901234
      CINE   = '                        '

C====
C 2. L'INITIALISATION
C====

      INCHAC = 0
      LCREA = .TRUE.
      CALL DLTINI ( LCREA, NUME,
     &              DEP0, VIT0, ACC0,
     &              NEQ, NUMEDD, INCHAC, BASENO,
     &              NRORES, INPSCO )
C
C====
C 3. DANS LE CAS DE CALCUL DE SENSIBILITE, IL FAUT ARCHIVER
C    LES VALEURS DU CHAMP STANDARD
C====
C
      IF ( NBPASE.NE.0 .AND. NRORES.EQ.0 ) THEN
C
C 3.1. ==>  DEPLACEMENT DANS VAPRIN
C
        JSTD = 0
        JAUX = 4
        CALL PSNSLE ( INPSCO, JSTD, JAUX, VAPRIN )
        CALL JEEXIN(VAPRIN(1:19)//'.REFE',IRESOL)
        IF (IRESOL.EQ.0) THEN
          CALL VTCREM(VAPRIN(1:19),MASSE,'V',TYPSOL)
        ENDIF
        CALL JEVEUO(VAPRIN(1:19)//'.VALE','E',LVALE)
        DO 31 , IEQ = 1, NEQ
          ZR(LVALE+IEQ-1) = DEP0(IEQ)
   31   CONTINUE
C
C 3.2. ==> ACCELERATION DANS VACOMP
        JSTD = 0
        JAUX = 16
        CALL PSNSLE ( INPSCO, JSTD, JAUX, VACOMP )
        CALL JEEXIN(VACOMP(1:19)//'.REFE',IRESOL)
        IF (IRESOL.EQ.0) THEN
          CALL VTCREM(VACOMP(1:19),MASSE,'V',TYPSOL)
        ENDIF
        CALL JEVEUO(VACOMP(1:19)//'.VALE','E',LACCE)
        DO 32 , IEQ = 1, NEQ
          ZR(LACCE+IEQ-1) = ACC0(IEQ)
   32   CONTINUE
C
      ENDIF
C
C====
C 4. --- CHARGEMENT A L'INSTANT INITIAL OU DE REPRISE ---
C====

      CALL DLFEXT (NVECA,NCHAR,T0,NEQ,LIAD,LIFO,
     &             CHARGE,INFOCH,FOMULT,MODELE,MATE,CARELE,
     &             NUMEDD,NBPASE,NRORES,INPSCO,ZR(IFORC0))


C====
C 5. --- CALCUL DU CHAMP D'ACCELERATION INITIAL ---
C====

      IF ( INCHAC.NE.0 ) THEN
C
C 5.1. ==> --- RESOLUTION AVEC FORCE1 COMME SECOND MEMBRE ---
C
         JAUX = NEQ*NRORES
         CALL JEVEUO (FORCE1(1:19)//'.VALE', 'E', IFORC1)
         CALL DCOPY (NEQ,ZR(IFORC0),1,ZR(IFORC1),1)
         CALL DLFDYN (IMAT(1),IMAT(3),LAMORT,NEQ,
     &                DEP0,VIT0, ZR(IFORC1),TABWK )
C
         MATREI = '&&MASSI'
         IF (LPREM) THEN
           LPREM=.FALSE.
           CALL AJLAGR ( RIGID , MASSE , MATREI )
C
C 5.2. ==> DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONEMENT
           CALL PRERES (SOLVEU,'V',ICODE,MAPREI,MATREI,IBID,-9999)
         ENDIF
C                                       ..          .
C 5.3. ==> RESOLUTION DU PROBLEME:  M.X  =  F - C.X - K.X
C                                       ..          .
         CALL RESOUD ( MATREI, MAPREI, FORCE1, SOLVEU, CINE,
     &                 'V', CHSOL, CRITER,0,RBID,CBID,.TRUE.)
C
C 5.4. ==> SAUVEGARDE DU CHAMP SOLUTION CHSOL DANS VDEPL
C
         CALL COPISD('CHAMP_GD','V',CHSOL(1:19),FORCE1(1:19))
         CALL JEVEUO (FORCE1(1:19)//'.VALE', 'L', IFORC1)
C
C 5.5. ==> DESTRUCTION DU CHAMP SOLUTION CHSOL
C
         CALL DETRSD('CHAMP_GD',CHSOL)
C
C 5.6 ==> STOCKAGE DE LA SOLUTION, FORC1, DANS LA STRUCTURE DE RESULTAT
C           EN TANT QUE CHAMP D'ACCELERATION A L'INSTANT COURANT
         CALL DCOPY(NEQ,ZR(IFORC1),1,ACC0,1)

      ENDIF
C
      END
