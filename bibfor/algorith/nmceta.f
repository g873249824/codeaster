      SUBROUTINE NMCETA(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CNFEXT,CNFINT,CNDIRI,
     &                  CARCRI,FONACT,SDPILO,SDDYNA,ITERAT,
     &                  INDRO ,POUGD ,RESOCO,VALMOI,VALPLU,
     &                  SECMBR,DEPALG,NBEFFE,VEELEM,MEELEM,
     &                  MEASSE,IRECLI,PROETA,OFFSET,RHO   ,
     &                  ETAF  ,LICCVG,RESIDU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION 
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      LOGICAL       FONACT(*),IRECLI
      INTEGER       ITERAT, LICCVG(2), INDRO, NBEFFE
      REAL*8        ETAF,PROETA(2), RHO, OFFSET,RESIDU
      CHARACTER*14  SDPILO
      CHARACTER*19  LISCHA,SDDYNA
      CHARACTER*19  CNFEXT,CNFINT,CNDIRI
      CHARACTER*24  MODELE,NUMEDD,MATE  ,CARELE,COMREF,COMPOR
      CHARACTER*24  CARCRI,RESOCO
      CHARACTER*24  VALMOI(8),POUGD (8),VALPLU(8),DEPALG(8),SECMBR(8) 
      CHARACTER*19  MEELEM(8),VEELEM(30)
      CHARACTER*19  MEASSE(8)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
C
C CHOIX DU ETA DE PILOTAGE 
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : L_CHARGES
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  PARCRI : CRITERES DE CONVERGENCE GLOBAUX
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  IRECLI : VRAI SI RECH LIN (ON VEUT LE RESIDU)
C IN  VALMOI : ETAT EN T-
C IN  VALPLU : ETAT EN T+ 
C IN  SECMBR : SECONDS MEMBRES
C IN  POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C IN  DEPALG : VARIABLE CHAPEAU POUR DEPLACEMENTS 
C IN  CNFEXT : FORCES EXTERNES
C OUT CNFINT : FORCES INTERNES   - FINT + AT.MU
C OUT CNDIRI : REACTIONS D'APPUI - BT.LAMBDA + AT.MU
C IN  SDPILO : SD PILOTAGE
C IN  RESOCO : SD CONTACT
C IN  MEELEM : MATRICES ELEMENTAIRES
C IN  MEASSE : MATRICES ASSEMBLEES
C IN  VEELEM : VECTEURS ELEMENTAIRES
C IN  NBEFFE : NOMBRE DE VALEURS DE PILOTAGE ENTRANTES
C IN  PROETA : VALEURS DE PILOTAGE ENTRANTES
C OUT ETAF   : PARAMETRE DE PILOTAGE
C OUT LICCVG : (1) CODE DE CONVERGENCE POUR LE PILOTAGE
C                     - 1 : BORNE ATTEINTE -> FIN DU CALCUL
C                       0 : RAS
C                       1 : PAS DE SOLUTION
C              (2) CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                       0 : CAS DE FONCTIONNEMENT NORMAL
C                       1 : ECHEC DE L'INTEGRATION DE LA LDC
C                       3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT RESIDU : RESIDU OPTIMAL SI L'ON A CHOISI LE RESIDU
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
      LOGICAL      BORMIN, BORMAX
      LOGICAL      TESTFI
      INTEGER      JPLTK,JPLIR, J, I
      INTEGER      LDCCVG(2),LICITE(2)
      REAL*8       R8VIDE,R8MAEM,INFINI
      REAL*8       ETAMIN,ETAMAX,CONMIN,CONMAX
      REAL*8       ETA(2),F(2)
      CHARACTER*24 PROJBO,TYPSEL
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('PILOTAGE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<PILOTAGE> ...... SELECTION DU ETA_PILOTAGE' 
      ENDIF         
C
C --- INITIALISATIONS
C
      LICITE(1) = 0
      LICITE(2) = 0
      INFINI    = R8MAEM()
      TESTFI    = IRECLI                 
C
C --- LECTURE DONNEES PILOTAGE
C
      CALL JEVEUO(SDPILO(1:14)//'.PLTK','L',JPLTK)
      CALL JEVEUO(SDPILO(1:14)//'.PLIR','L',JPLIR)
      PROJBO = ZK24(JPLTK+4)
      TYPSEL = ZK24(JPLTK+5)
C
      IF (ZR(JPLIR+1) .NE. R8VIDE()) THEN
        ETAMAX = ZR(JPLIR+1)
        BORMAX = .TRUE.
      ELSE
        ETAMAX = R8VIDE()
        BORMAX = .FALSE.
      END IF
C	
      IF (ZR(JPLIR+2) .NE. R8VIDE()) THEN
        ETAMIN = ZR(JPLIR+2)
        BORMIN = .TRUE.
      ELSE
        ETAMIN = R8VIDE()
        BORMIN = .FALSE.
      END IF
C 
      IF (ZR(JPLIR+3) .NE. R8VIDE()) THEN
        CONMAX = ZR(JPLIR+3)
      ELSE
        CONMAX = INFINI
      END IF
C
      IF (ZR(JPLIR+4) .NE. R8VIDE()) THEN
        CONMIN = ZR(JPLIR+4)
      ELSE
        CONMIN = -INFINI
      END IF
C
C --- INTERSECTION AVEC L'INTERVALLE DE CONTROLE ETA_PILO_R_*
C
      J=0
      DO 20 I = 1, NBEFFE
        IF (PROETA(I).GE.CONMIN .AND. PROETA(I).LE.CONMAX) THEN
          J         = J+1
          ETA(J)    = PROETA(I)
          LICITE(J) = LICITE(I)
        ENDIF
 20   CONTINUE
      NBEFFE = J

      IF (NBEFFE.EQ.0) THEN
        LICCVG(1) = 1
        GOTO 9999
      END IF
C
C --- TEST PAR RAPPORT AUX BORNES D'UTILISATION ETA_PILO_*
C --- STRATEGIE : SI LE ETA CHOISI EST EN DEHORS DES BORNES
C ---             D'UTILISATION ON ARRETE LE CALCUL A CONVERGENCE
C ---             DE + SI 'PROJ_BORNE' ON RAMENE LES ETA SUR LES BORNES
C
      DO 50 I = 1, NBEFFE
        IF (BORMAX) THEN
          IF (ETA(I) .GT. ETAMAX) THEN
            IF (PROJBO.EQ.'OUI') ETA(I) = ETAMAX
            LICITE(I) = -1
          END IF
        END IF
        IF (BORMIN) THEN
          IF (ETA(I) .LT. ETAMIN) THEN
            IF (PROJBO.EQ.'OUI') ETA(I) = ETAMIN
            LICITE(I) = -1
          END IF
        END IF
 50   CONTINUE
C
C --- CHOIX DE ETA SI NECESSAIRE (I.E. SI NBEFFE > 1)
C
      IF (NBEFFE.EQ.2) THEN
        CALL NMCESE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,CNFEXT,CARCRI,FONACT,
     &              SDDYNA,ITERAT,INDRO ,POUGD ,RESOCO,
     &              VALMOI,VALPLU,SECMBR,DEPALG,VEELEM,
     &              MEELEM,MEASSE,IRECLI,OFFSET,RHO   ,
     &              TYPSEL,ETA   ,LDCCVG,F     ,TESTFI)
        IF (F(1).LE.F(2)) THEN
          ETAF      = ETA(1)
          LICCVG(1) = LICITE(1)
          LICCVG(2) = LDCCVG(1)
        ELSE
          ETAF      = ETA(2)
          LICCVG(1) = LICITE(2)
          LICCVG(2) = LDCCVG(2)
        ENDIF
      ELSEIF (NBEFFE.EQ.1) THEN
        ETAF      = ETA(1)
        LICCVG(1) = LICITE(1)
      ELSE
        CALL ASSERT(.FALSE.)  
      ENDIF
      
C
C --- VALEUR DU RESIDU
C      
      IF (TYPSEL.EQ.'RESIDU') THEN 
        IF (IRECLI) THEN
          RESIDU    = MIN(F(1),F(2))
        ENDIF
        TESTFI = .FALSE.      
      ENDIF
C
C --- CALCUL DU RESIDU
C      
      IF (TESTFI) THEN
        CALL NMCERE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,CNFEXT,CARCRI,FONACT,
     &              SDDYNA,ITERAT,INDRO ,POUGD ,RESOCO,
     &              VALMOI,VALPLU,SECMBR,DEPALG,VEELEM,
     &              MEELEM,MEASSE,OFFSET,RHO   ,ETAF  ,
     &              RESIDU,LDCCVG)
        LICCVG(2) = LDCCVG(1)
      ENDIF
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<PILOTAGE> ...... ETA_PILOTAGE: ',ETAF 
        WRITE (IFM,*) '<PILOTAGE> ...... RESIDU OPTI.: ',RESIDU         
      ENDIF      

 9999 CONTINUE
      CALL JEDEMA()
      END
