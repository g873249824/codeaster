      SUBROUTINE DLFEXT(NVECA,NCHAR,TEMPS,NEQ,LIAD,LIFO,CHARGE,INFOCH,
     &                  FOMULT,MODELE,MATE,CARELE,NUMEDD,NBPASE,NRPASE,
     &                  INPSCO,F)
      IMPLICIT  NONE
      INTEGER NVECA,NCHAR,NEQ,LIAD(*),NBPASE,NRPASE
      REAL*8 TEMPS,F(*)
      CHARACTER*(*) INPSCO
      CHARACTER*24 LIFO(*),INFOCH,FOMULT
      CHARACTER*24 MODELE,CARELE,CHARGE,MATE,NUMEDD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------

C  CALCUL DU SECOND MEMBRE F* A PARTIR DE :
C      - VECT_ASSE
C      - CHARGE

C  INPUT:
C        NVECA    : NOMBRE D'OCCURENCES DU MOT CLE VECT_ASSE
C        NCHAR    : NOMBRE D'OCCURENCES DU MOT CLE CHARGE
C        TEMPS    : INSTANT DE CALCUL
C        NEQ      : NOMBRE D'EQUATIONS (D.D.L. ACTIFS)
C        LIAD     : LISTE DES ADRESSES DES VECTEURS CHARGEMENT (NVECT)
C        LIFO     : LISTE DES NOMS DES FONCTIONS EVOLUTION (NVECT)
C        CHARGE   : LISTE DES CHARGES
C        INFOCH   : INFO SUR LES CHARGES
C        FOMULT   : LISTE DES FONC_MULT ASSOCIES A DES CHARGES
C        MODELE   : NOM DU MODELE
C        MATE     : NOM DU CHAMP DE MATERIAU
C        CARELE   : CARACTERISTIQUES DES POUTRES ET COQUES
C        NUMEDD   : NUME_DDL DE LA MATR_ASSE RIGID
C        NBPASE   : NOMBRE DE PARAMETRE SENSIBLE
C        NRPASE   : NUMERO DE PARAMETRE SENSIBLE ( =0 => STANDARD)
C        INPSCO   : STRUCTURE CONTENANT LA LISTE DES NOMS (CF. PSNSIN)

C  OUTPUT:
C        F        : VECTEUR FORCE EXTERIEURE (NEQ)

C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      LOGICAL SECAL
      INTEGER JINF,JTT,LONCH,IF1,IF2,JCN1,JJ,NUMCHT,TYPESE,IFD
      INTEGER IRET,INEW,IBID,IEQ
      INTEGER J2ND1,JAUX,JCHAR,JSTD,JDVEM,JDVEK
      REAL*8 PARTPS(3),R8PREM,R8BID,R8VIDE
      CHARACTER*4 TYPMAT,TYPCAL,PARA
      CHARACTER*8 NOPASE
      CHARACTER*14 COM
      CHARACTER*19 LIGRMO,LISCHA
      CHARACTER*24 VACEL1,VECEL1
      CHARACTER*24 VECHMP,VACHMP,CNCHMP,K24BID,CNCHKM
      CHARACTER*24 VAPRIN,VACOMP
      CHARACTER*24 STYPSE,LCHAR

      DATA COM/'&&DLFEXT.COM'/
      DATA VECEL1,VACEL1/2*' '/
      DATA VECHMP,VACHMP,CNCHMP/3*' '/
      DATA K24BID/' '/
      DATA TYPCAL/'MECA'/
      DATA TYPESE/0/
      DATA STYPSE/' '/
C DEB ------------------------------------------------------------------

      CALL JEMARQ()

      LIGRMO = MODELE(1:8)//'.MODELE'
      TYPMAT = 'R'
      PARA = 'INST'
      LISCHA = CHARGE(1:19)

      PARTPS(1) = TEMPS
      PARTPS(2) = R8VIDE()
      PARTPS(3) = R8VIDE()

C -- NOM DU PARAMETRE
      CALL PSNSLE(INPSCO,NRPASE,1,NOPASE)

C -- REPERAGE DU TYPE DE DERIVATION (TYPESE)
C             0 : CALCUL STANDARD
C            -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C             1 : DERIVEE SANS INFLUENCE
C             2 : DERIVEE DE LA CL DE DIRICHLET
C             3 : PARAMETRE MATERIAU
C             4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C             5 : FORCE
C             N : AUTRES DERIVEES


      IF (NRPASE.EQ.0) THEN
C -- CAS STANDARD
        TYPESE = 0
        TYPCAL = 'MECA'

C --- CAS D'UN CHARGEMENT DEFINI PAR VECT_ASSE ---

        IF (NVECA.NE.0) THEN

          CALL FEXT(TEMPS,NEQ,NVECA,LIAD,LIFO,F)

C --- CAS D'UN CHARGEMENT DEFINI PAR CHARGE ---

        ELSE IF (NCHAR.NE.0) THEN

          CALL JEVEUO(INFOCH,'L',JINF)
          NCHAR = ZI(JINF)
          NUMCHT = ZI(JINF-1+2+2*NCHAR)

          IF (NUMCHT.GT.0) THEN
            CALL NMVCLE(MODELE,MATE,CARELE,LISCHA,TEMPS,COM)
            CALL VECTME(MODELE,CARELE,MATE,K24BID,COM,VECEL1)
          END IF

          CALL VECHME(TYPCAL,MODELE,CHARGE,INFOCH,PARTPS,CARELE,MATE,
     &                K24BID,LIGRMO,VAPRIN,NOPASE,TYPESE,STYPSE,VECHMP)
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          IF (NUMCHT.GT.0) CALL ASASVE(VECEL1,NUMEDD,TYPMAT,VACEL1)
          CALL ASCOVA('D',VACHMP,FOMULT,'INST',TEMPS,TYPMAT,CNCHMP)
          CALL JELIRA(CNCHMP(1:19)//'.VALE','LONMAX',LONCH,K24BID)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','E',IF1)

          CALL DCOPY(NEQ,ZR(IF1),1,F,1)

          IF (NUMCHT.GT.0) THEN
            CALL JEVEUO(VACEL1,'L',JTT)
            CALL JEVEUO(ZK24(JTT) (1:19)//'.VALE','L',JCN1)
            DO 10 JJ = 1,LONCH
              F(JJ) = F(JJ) + ZR(JCN1+JJ-1)
   10       CONTINUE
            CALL DETRSD('CHAMP_GD',ZK24(JTT) (1:19))
          END IF

C -- LES DIRICHLETS

          CALL VEDIME(MODELE,CHARGE,INFOCH,TEMPS,TYPMAT,TYPESE,NOPASE,
     &                VECHMP)
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JELIRA(CNCHMP(1:19)//'.VALE','LONMAX',LONCH,K24BID)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',IF2)

C -- TEST DE PRESENCE DE CHARGEMENT DIRICHLET (DEPL IMPOSE NON NUL)
          IRET = 0
          DO 20 JJ = 1,LONCH
            IF (ABS(ZR(IF2+JJ-1)).GT.R8PREM()) IRET = 1
   20     CONTINUE
          INEW = 0
          CALL GETFAC('NEWMARK',INEW)
          IF ((IRET.EQ.1) .AND. (INEW.EQ.0)) THEN
            CALL U2MESS('F','ALGORITH3_20')
          END IF

          DO 30 JJ = 1,LONCH
            F(JJ) = F(JJ) + ZR(IF2+JJ-1)
   30     CONTINUE

        END IF

      ELSE
C -- CAS AVEC SENSIBILITE

        CALL METYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)

        SECAL = .FALSE.

C -- DERIVATION EULERIENNE

        IF (TYPESE.EQ.-1) THEN
          SECAL = .FALSE.
C NON TRAITE POUR L INSTANT
        END IF

C -- LES DERIVEES SANS INFLUENCE

        IF (TYPESE.EQ.1) THEN
          SECAL = .TRUE.
          CNCHMP = 'CHARGEMENT'
          CALL WKVECT(CNCHMP,'V V R',NEQ,J2ND1)
          DO 40,IEQ = 1,NEQ
            ZR(J2ND1-1+IEQ) = 0.D0
   40     CONTINUE
        END IF

C -- LES DIRICHLETS

        IF (TYPESE.EQ.2) THEN

          INEW = 0
          CALL GETFAC('NEWMARK',INEW)
          IF (INEW.EQ.0) THEN
            CALL U2MESS('F','ALGORITH3_20')
          END IF

          SECAL = .TRUE.
          CALL PSNSLE(INPSCO,NRPASE,11,VECHMP)
          CALL VEDIME(MODELE,CHARGE,INFOCH,TEMPS,TYPMAT,TYPESE,NOPASE,
     &                VECHMP)
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',J2ND1)
        END IF

C -- LES PARAMETRES MATERIAUX (ATTENTION VERSION PROVISOIRE)
C ON NE TRAITE PAS POUR L INSTANT LA DERIVEE DE MASSE NI AMOR
C PAR RAPPORT AU PARAMETRE MATERIAU
C IL FAUT UTILISER DANS CE CAS : TYPCAL = 'MECM' + 'MECA'

        IF (TYPESE.EQ.3) THEN

          INEW = 0
          CALL GETFAC('ADAPT',INEW)
          IF (INEW.EQ.1) THEN
            CALL U2MESS('F','ALGORITH3_21')
          END IF

          SECAL = .TRUE.
C TYPCAL POUR LE PRODUIT DK/DP * DEPL
          TYPCAL = 'MECA'
C VAPRIN : CHAMP DE DEPL A L INSTANT T (JSTD = 0 ET JAUX = 4)
          JSTD = 0
          JAUX = 4
          CALL PSNSLE(INPSCO,JSTD,JAUX,VAPRIN)
          CALL JEEXIN(CHARGE,IRET)
          IF (IRET.NE.0) THEN
            CALL JEVEUO(CHARGE,'L',JCHAR)
            CALL JEVEUO(INFOCH,'L',JINF)
            NCHAR = ZI(JINF)
            LCHAR = ZK24(JCHAR)
          ELSE
            NCHAR = 0
            LCHAR = K24BID
          END IF
          CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,CARELE(1:8),
     &                R8BID,VAPRIN,K24BID,K24BID,K24BID,LIGRMO,NOPASE,
     &                VECHMP)

          VACHMP = K24BID
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',J2ND1)
        END IF

C -- LES CARACTERISTIQUES ELEMENTAIRES

        IF (TYPESE.EQ.4) THEN
          INEW = 0
          CALL GETFAC('ADAPT',INEW)
          IF (INEW.EQ.1) THEN
            CALL U2MESS('F','ALGORITH3_21')
          END IF

          SECAL = .TRUE.
C TYPCAL POUR  -DK/DP * DEPL
          TYPCAL = 'MECA'
C VAPRIN : CHAMP DE DEPL A L INSTANT T (JSTD = 0 ET JAUX = 4)
          JSTD = 0
          JAUX = 4
          CALL PSNSLE(INPSCO,JSTD,JAUX,VAPRIN)
          CALL JEEXIN(CHARGE,IRET)
          IF (IRET.NE.0) THEN
            CALL JEVEUO(CHARGE,'L',JCHAR)
            CALL JEVEUO(INFOCH,'L',JINF)
            NCHAR = ZI(JINF)
            LCHAR = ZK24(JCHAR)
          ELSE
            NCHAR = 0
            LCHAR = K24BID
          END IF
          CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,CARELE(1:8),
     &                R8BID,VAPRIN,K24BID,K24BID,K24BID,LIGRMO,NOPASE,
     &                VECHMP)

          VACHMP = K24BID
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',JDVEK)

          CNCHKM = 'CHARGEMENT'
          CALL JEEXIN(CNCHKM,IRET)
          IF (IRET .EQ. 0) THEN
            CALL WKVECT(CNCHKM,'V V R',NEQ,J2ND1)
          ELSE
            CALL JEVEUO(CNCHKM,'E',J2ND1)
          ENDIF
          DO 50,IEQ = 1,NEQ
            ZR(J2ND1-1+IEQ) = ZR(JDVEK-1+IEQ)
   50     CONTINUE

C TYPCAL POUR LE PRODUIT -DM/DP * ACCE
          TYPCAL = 'MECM'
C VACOMP : CHAMP ACCE A L INSTANT T (JSTD = 0 ET JAUX = 16)
          JSTD = 0
          JAUX = 16
          CALL PSNSLE(INPSCO,JSTD,JAUX,VACOMP)
          CALL VECHDE(TYPCAL,MODELE(1:8),NCHAR,LCHAR,MATE,
     &                  CARELE(1:8),R8BID,VACOMP,K24BID,
     &                  K24BID,K24BID,LIGRMO,
     &                  NOPASE,VECHMP)
          VACHMP = K24BID
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',JDVEM)

C CALCUL DE : -DK/DP*DEPL -DM/DP*ACCE
          DO 51,IEQ = 1,NEQ
            ZR(J2ND1-1+IEQ) = ZR(J2ND1-1+IEQ) + ZR(JDVEM-1+IEQ)
   51     CONTINUE

        END IF

C -- CHARGEMENTS DE NEUMANN

        IF (TYPESE.EQ.5) THEN
          SECAL = .TRUE.
          CALL PSNSLE(INPSCO,NRPASE,10,VECHMP)
          TYPCAL = 'MECA'
          JSTD = 0
          JAUX = 4
          CALL PSNSLE(INPSCO,JSTD,JAUX,VAPRIN)

          CALL VECHME(TYPCAL,MODELE,CHARGE,INFOCH,PARTPS,CARELE,MATE,
     &                K24BID,LIGRMO,VAPRIN,NOPASE,TYPESE,STYPSE,VECHMP)
          VACHMP = K24BID
          CALL ASASVE(VECHMP,NUMEDD,TYPMAT,VACHMP)
          CALL ASCOVA('D',VACHMP,FOMULT,PARA,TEMPS,TYPMAT,CNCHMP)
          CALL JEVEUO(CNCHMP(1:19)//'.VALE','L',J2ND1)
        END IF

        IF (.NOT.SECAL) THEN
          CALL UTIMPI('S','TYPESE : ',1,TYPESE)
          CALL U2MESS('F','ALGORITH3_22')
        END IF

        CALL DCOPY(NEQ,ZR(J2ND1),1,F,1)

C -- FIN TEST SI CALCUL SENSIBILITE
      END IF

      CALL JEDETR(CNCHMP)

      CALL JEDEMA()

      END
