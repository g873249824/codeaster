      SUBROUTINE NMREPL(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CNFEXT,PARMET,CARCRI,
     &                  MODEDE,NUMEDE,SOLVDE,PARCRI,DEPPIL,
     &                  ITERAT,VALMOI,POUGD ,DEPDEL,RESOCO, 
     &                  DDEPLA,VALPLU,CNRESI,CNDIRI,CONV  ,
     &                  LICCVG,REAROT,INDRO ,SECMBR,DINST ,
     &                  PILOTE,ETAN  ,ETA   ,DEPOLD,METHOD)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
C TOLE CRP_21
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      LOGICAL       REAROT
      INTEGER       ITERAT, LICCVG(2), INDRO
      REAL*8        PARMET(*), CONV(*),DINST, ETA, ETAN
      REAL*8        PARCRI(*)
      CHARACTER*8   MODEDE
      CHARACTER*14  PILOTE
      CHARACTER*16  METHOD(*)
      CHARACTER*19  LISCHA, CNRESI, CNDIRI, CNFEXT, SOLVDE
      CHARACTER*24  MODELE, NUMEDD, MATE  , CARELE, COMREF, COMPOR
      CHARACTER*24  CARCRI, VALMOI, POUGD , DDEPLA, VALPLU, DEPDEL
      CHARACTER*24  RESOCO, SECMBR, DEPOLD, NUMEDE, DEPPIL(2)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (PILOTAGE)
C
C RECHERCHE LINEAIRE DANS LA DIRECTION DE DESCENTE AVEC PILOTAGE
C      
C ----------------------------------------------------------------------
C 
C
C IN       MODELE K24  MODELE
C IN       NUMEDD K24  NUME_DDL
C IN       MATE   K24  CHAMP MATERIAU
C IN       CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24  VARI_COM DE REFERENCE
C IN       COMPOR K24  COMPORTEMENT
C IN       LISCHA K19  L_CHARGES
C IN/JXVAR CNFEXT K19  RESULTANTE DES EFFORTS EXTERIEURS
C                       (RECALCULEE QD DIRECTION DESCENTE = PREDICTION)
C IN       PARMET  R8  PARAMETRES DES METHODES DE RESOLUTION
C IN       CARCRI K24  PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  MODEDE K8   MODELE NON LOCAL
C IN  NUMEDE K24  NUME_DDL NON LOCAL
C IN  SOLVDE K19  SOLVEUR NON LOCAL
C IN  PARCRI  R   CRITERES DE CONVERGENCE GLOBAUX
C IN       ITERAT  I   NUMERO D'ITERATION DE NEWTON
C IN       VALMOI K24  ETAT EN T-
C IN       POUGD  K24  DONNES POUR POUTRES GRANDES DEFORMATIONS
C IN       DEPDEL K24  INCREMENT DE DEPLACEMENT
C IN       RESOCO K24  SD CONTACT
C IN/JXVAR DDEPLA K24  DIRECTION DE DESCENTE REACTUALISEE
C IN/JXVAR VALPLU K24  ETAT EN T+ : SIGPLU ET VARPLU
C IN/JXVAR CNRESI K19  FINT+BT.LAMBDA
C IN/JXVAR CNDIRI K19  BT.LAMBDA
C OUT      CONV    R8  INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C                       (10) ITERATIONS RECHERCHE LINEAIRE
C                       (11) VALEUR DE RHO
C OUT      LICCVG  I   CODE RETOUR DE LA LOI DE COMPORTEMENT
C IN       REAROT  L   VRAI SI GRANDES ROTATIONS
C IN       INDRO   I   ADRESSE POUR GRANDES ROTATIONS
C IN       SECMBR K24  SECONDS MEMBRES
C IN       PILOTE K14  SD PILOTAGE
C IN       DINST   R8  INCREMENT DE TEMPS
C IN       ETAN    R8  ETA_PILOTAGE AU DEBUT DE L'ITERATION
C OUT      ETA     R8  PARAMETRE DE PILOTAGE
C IN       DEPOLD K24  DEPLACEMENT DE L'INSTANT D'AVANT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      EXOPT, PBCVG, MIEUX
      INTEGER      ITEMAX, ITERHO, NEQ, I, ACT, OPT,LICOPT
      INTEGER      JRESI,JDDEPL, JDEPDE, JDEPDT, JFEXT, JDEPM
      INTEGER      JDEPP, NBEFFE, JPLTK
      INTEGER      NR, POS, IRET, NBSTO,JU0,JU1,N
      INTEGER      ISMAEM
      REAL*8       RHOMIN, RHOMAX, RHOEXM, RHOEXP, RATCVG, FCVG
      REAL*8       RHOOPT, RHO,F0,FOPT, X(2)
      REAL*8       R8MAEM
      REAL*8       R(1002), G(1002), OFFSET, MEMFG(1002)
      REAL*8       FGMAX, FGMIN, AMELIO, RESIDU, ETAOPT
      CHARACTER*8  K8BID
      CHARACTER*19 CNREST(2), CNDIRT(2)
      CHARACTER*24 DEPMOI, SIGMOI, COMMOI
      CHARACTER*24 DEPDET, DEPPLT
      CHARACTER*24 DEPPLU, SIGPLU, VARPLU, COMPLU, VARDEP, LAGDEP
      CHARACTER*24 SIGPLT, VARPLT, VALPLT(8,2), K24BID, K24BLA, TYPILO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()   
C
C --- INITIALISATIONS
C
      K24BLA = ' '
      
C -- CAS DES FONCTIONS DE PILOTAGE LINEAIRES :
C       RECHERCHE LINEAIRE STANDARD

      CALL JEVEUO (PILOTE // '.PLTK','L',JPLTK)
      TYPILO = ZK24(JPLTK)
      IF (TYPILO.EQ.'DDL_IMPO' ) THEN
        CALL NMRELI(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &              COMPOR, LISCHA, CNFEXT, PARMET, CARCRI,
     &              MODEDE, NUMEDE, SOLVDE, PARCRI,
     &              ITERAT, VALMOI, POUGD , DEPDEL,
     &              RESOCO, DDEPLA, VALPLU, CNRESI, CNDIRI,
     &              CONV  , LICCVG, REAROT, INDRO , METHOD)
        GOTO 9999
      END IF


C -- INITIALISATION

      IF (DINST .LT. PARMET(13)) THEN
        ITEMAX = NINT(PARMET(12))
      ELSE
        ITEMAX = NINT(PARMET(10))
      END IF

      RHOMIN =   PARMET(14)
      RHOMAX =   PARMET(15)
      RHOEXM =  -PARMET(16)
      RHOEXP =   PARMET(16)


      CALL DESAGG(VALMOI, DEPMOI, SIGMOI, K24BID, COMMOI,
     &                      K24BID, K24BID, K24BID, K24BID)
      CALL DESAGG(VALPLU, DEPPLU, SIGPLU, VARPLU, COMPLU,
     &                    VARDEP, LAGDEP, K24BID, K24BID)

      RATCVG = PARMET(11)
      FOPT   = R8MAEM()
      LICOPT = ISMAEM()
      DEPDET = '&&CNREPL.CHP1'
      DEPPLT = '&&CNREPL.CHP2'

      CALL JEVEUO (DEPMOI(1:19) // '.VALE','E',JDEPM )
      CALL JEVEUO (DEPDEL(1:19) // '.VALE','E',JDEPDE)
      CALL JEVEUO (DEPPLU(1:19) // '.VALE','E',JDEPP )
      CALL JEVEUO (DEPDET(1:19) // '.VALE','E',JDEPDT)
      CALL JELIRA (DEPDEL(1:19) // '.VALE','LONMAX',NEQ,K8BID)

      NBSTO = 0


C -- PREPARATION DES ZONES TEMPORAIRES POUR ITERATION COURANTE

C    BUT : CONSERVER LES RESULTATS DE L'INTEGRATION POUR RHO OPTIMAL
C          SANS DUPLIQUER LES SD CORRESPONDANTES A CHAQUE ITERATION

      CNREST(1) =  CNRESI
      CNREST(2) = '&&NMREPL.RESI'
      CNDIRT(1) =  CNDIRI
      CNDIRT(2) = '&&NMREPL.DIRI'
      SIGPLT    = '&&NMREPL.SIGP'
      VARPLT    = '&&NMREPL.VARP'

      CALL EXISD('CHAMP_GD',VARPLT,IRET)
      IF (IRET.EQ.0) CALL COPISD('CHAMP_GD','V',VARPLU,VARPLT)

      CALL COPISD('CHAMP_GD','V',DEPPLU,DEPPLT)

      CALL AGGLOM(DEPPLT, SIGPLU, VARPLU, COMPLU,
     &            VARDEP, LAGDEP, K24BLA, K24BLA, 6, VALPLT(1,1))
      CALL AGGLOM(DEPPLT, SIGPLT, VARPLT, COMPLU,
     &            VARDEP, LAGDEP, K24BLA, K24BLA, 6, VALPLT(1,2))


C -- CALCUL DE F(RHO=0)
      CALL JEVEUO (CNFEXT // '.VALE','L',JFEXT)
      CALL JEVEUO (CNRESI // '.VALE','L',JRESI)
      F0 = 0.D0
      DO 10 I = 0, NEQ-1
         F0 = MAX(F0 , ABS(ZR(JRESI+I)-ZR(JFEXT+I)) )
  10  CONTINUE

      FCVG = ABS(RATCVG * F0)


C ======================================================================
C                     BOUCLE DE RECHERCHE LINEAIRE
C ======================================================================

      ACT  = 1
      RHO  = 1.D0

      NR   = 2
      R(1) = 0.D0
      R(2) = 1.D0
      G(1) = F0
      POS  = 2

      IF (ITEMAX .GT. 1000) CALL U2MESS('F','ALGORITH8_29')
      DO 20 ITERHO = 0, ITEMAX


C      CALCUL DE LA NOUVELLE DIRECTION DE DESCENTE
        OFFSET = ETAN*(1-RHO)

        CALL NMPILO(PILOTE, DINST , RHO   , OFFSET, DEPPIL,
     &              DEPDEL, DEPOLD, MODELE, MATE  , COMPOR,
     &              VALMOI, 2     , NBEFFE, X     , LICCVG)
        IF(LICCVG(1).EQ.1) GOTO 9999
        DO 21 N=1,NBEFFE
          X(N) = X(N) + OFFSET
 21     CONTINUE

        CALL NMCETA(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &              COMPOR, LISCHA, CNFEXT, PARMET, CARCRI,
     &              MODEDE, NUMEDE, SOLVDE, PARCRI, POUGD ,
     &              ITERAT, VALMOI, RESOCO, VALPLT(1,ACT),CNREST(ACT),
     &              CNDIRT(ACT), CONV,   INDRO , DEPOLD, .TRUE.,
     &              PILOTE, NBEFFE, X, DEPDEL, DEPPIL,
     &              REAROT, OFFSET, RHO, SECMBR, ETA   , LICCVG, RESIDU)

C      PB CVG : S'IL EXISTE DEJA UN RHO OPTIMAL, ON LE CONSERVE
C               ET ON SORT
        PBCVG = LICCVG(2).LT.0
        IF (PBCVG) THEN
          IF (EXOPT) GOTO 100
          GOTO 9999
        END IF

C       SI ON A PAS ENCORE CONVERGE LE PILO : ON PREND UN PILO CONVERGE
C                                             QQ SOIT LE RESIDU
C       SINON ON CHERCHE A BAISSER LE RESIDU AVEC UN PILO CONVERGE
        IF (LICOPT.GT.0) THEN
          MIEUX = LICCVG(1).LE.0 .OR. RESIDU.LT.FOPT
        ELSE
          MIEUX = LICCVG(1).LE.0 .AND . RESIDU.LT.FOPT
        END IF

        IF (MIEUX) THEN
          EXOPT  = .TRUE.
          RHOOPT = RHO
          ETAOPT = ETA
          LICOPT = LICCVG(1)
          FOPT   = RESIDU
          OPT    = ACT
          ACT    = 3 - ACT
        END IF

C      MEMOIRE DES RESIDUS ATTEINTS
        NBSTO = NBSTO + 1
        MEMFG(NBSTO) = RESIDU


C      ARRET SI SATISFACTION DU CRITERE
        IF (RESIDU .LT. FCVG) GOTO 100

C      ARRET SI IL N'Y A PLUS D'AMELIORATIONS SIGNIFICATIVES
        IF (NBSTO .GE. 3) THEN
          FGMAX = MAX(MEMFG(NBSTO),MEMFG(NBSTO-1),MEMFG(NBSTO-2))
          FGMIN = MIN(MEMFG(NBSTO),MEMFG(NBSTO-1),MEMFG(NBSTO-2))
          AMELIO = FGMIN / FGMAX
          IF (AMELIO .GT. 0.95D0) GOTO 100
        END IF

C -- CALCUL DE RHO(N+1) PAR INTERPOLATION QUADRATIQUE AVEC BORNES

        G(POS) = RESIDU
        CALL NMREP2(NR,R,G,FCVG,RHOMIN,RHOMAX,RHOEXM,RHOEXP,POS)
        RHO = R(POS)
 20   CONTINUE
      ITERHO = ITEMAX


C -- STOCKAGE DU RHO OPTIMAL ET DES CHAMPS CORRESPONDANTS

 100  CONTINUE


C    CALCUL DE LA DIRECTION DE DESCENTE ET DE ETA_PILOTAGE
      ETA = ETAOPT
      CALL JEVEUO(DEPPIL(1)(1:19) // '.VALE','L',JU0)
      CALL JEVEUO(DEPPIL(2)(1:19) // '.VALE','L',JU1)
      CALL JEVEUO(DDEPLA(1:19) // '.VALE','E',JDDEPL)
      DO 90 N = 0, NEQ-1
        ZR(JDDEPL+N) = RHOOPT * ZR(JU0+N) + (ETA-OFFSET) * ZR(JU1+N)
 90   CONTINUE

C    CALCUL DES EFFORTS EXTERIEURS
      CALL NMFEXT (NUMEDD, ETA   , SECMBR, RESOCO, K24BID, CNFEXT)


C    RECUPERATION DES VARIABLES EN T+ SI NECESSAIRE
      IF (OPT.NE.1) THEN
        CALL COPISD('CHAMP_GD','V',SIGPLT,SIGPLU)
        CALL COPISD('CHAMP_GD','V',VARPLT,VARPLU)
        CALL COPISD('CHAMP_GD','V',CNREST(OPT),CNRESI)
        CALL COPISD('CHAMP_GD','V',CNDIRT(OPT),CNDIRI)
      END IF

C    INFORMATIONS SUR LA RECHERCHE LINEAIRE
      CONV(10) = ITERHO
      CONV(11) = RHOOPT

      LICCVG(1)   = LICOPT

 9999 CONTINUE
      CALL JEDEMA()
      END
