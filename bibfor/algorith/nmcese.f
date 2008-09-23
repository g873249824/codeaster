      SUBROUTINE NMCESE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CARCRI,FONACT,DEFICO,
     &                  ITERAT,SDNURO,VALMOI,VALPLU,POUGD ,
     &                  SOLALG,VEELEM,VEASSE,SDTIME,OFFSET,
     &                  TYPSEL,LICITE,RHO   ,ETA   ,ETAF  ,
     &                  RESIDU,LDCCVG,PILCVG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION 
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      LOGICAL       FONACT(*)
      INTEGER       ITERAT
      REAL*8        RHO, OFFSET,ETA(2)
      CHARACTER*19  LISCHA,SDNURO
      CHARACTER*24  MODELE,NUMEDD,MATE  ,CARELE,COMREF,COMPOR
      CHARACTER*24  CARCRI,DEFICO
      CHARACTER*24  VALMOI(8),POUGD (8),VALPLU(8)
      CHARACTER*19  VEELEM(*),VEASSE(*)
      CHARACTER*19  SOLALG(*)
      CHARACTER*24  TYPSEL,SDTIME
      INTEGER       LICITE(2)
      INTEGER       LDCCVG,PILCVG
      REAL*8        ETAF,RESIDU      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
C
C SELECTION DU PARAMETRE DE PILOTAGE ENTRE DEUX SOLUTIONS
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
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  OFFSET : DECALAGE DE ETA_PILOTAGE EN FONCTION DE RHO
C IN  TYPSEL : TYPE DE SELECTION PILOTAGE
C                'ANGL_INCR_DEPL'
C                'NORM_INCR_DEPL'
C                'RESIDU'
C IN  SDTIME : SD TIMER
C IN  LICITE : CODE RETOUR PILOTAGE DES DEUX PARAMETRES DE PILOTAGE
C IN  RHO    : PARAMETRE DE RECHERCHE_LINEAIRE
C IN  ETA    : LES DEUX PARAMETRES DE PILOTAGE
C OUT ETAF   : PARAMETRE DE PILOTAGE FINALEMENT CHOISI
C OUT RESIDU : VALEUR DU RESIDU
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT POUR
C              LE PARAMETRE DE PILOTAGE CHOISI
C                 0 : CAS DE FONCTIONNEMENT NORMAL
C                 1 : ECHEC DE L'INTEGRATION DE LA LDC
C                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT PILCVG : CODE DE CONVERGENCE POUR LE PILOTAGE
C               - 1 : BORNE ATTEINTE -> FIN DU CALCUL
C                 0 : RAS
C                 1 : PAS DE SOLUTION
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
      INTEGER      LDCCV1,LDCCV2
      REAL*8       F(2)
      CHARACTER*19 NMCHEX,DEPOLD,DEPDEL,DEPPR1,DEPPR2
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('PILOTAGE',IFM,NIV)     
C
C --- INITIALISATIONS
C
      F(1)   = 0.D0
      F(2)   = 0.D0   
      LDCCV1 = 0
      LDCCV2 = 0  
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C      
      DEPPR1 = NMCHEX(SOLALG,'SOLALG','DEPPR1')
      DEPPR2 = NMCHEX(SOLALG,'SOLALG','DEPPR2')
      DEPOLD = NMCHEX(SOLALG,'SOLALG','DEPOLD')
      DEPDEL = NMCHEX(SOLALG,'SOLALG','DEPDEL')     
C
C --- CHOIX DE ETA SI NECESSAIRE (I.E. SI NBEFFE > 1)
C
      IF (TYPSEL.EQ.'ANGL_INCR_DEPL') THEN
        CALL NMCEAI(NUMEDD,DEPDEL,DEPPR1,DEPPR2,DEPOLD,
     &              RHO   ,ETA(1),F(1))
        CALL NMCEAI(NUMEDD,DEPDEL,DEPPR1,DEPPR2,DEPOLD,
     &              RHO   ,ETA(2),F(2))      
      ELSE IF (TYPSEL.EQ.'NORM_INCR_DEPL') THEN
        CALL NMCENI(NUMEDD,DEPDEL,DEPPR1,DEPPR2,RHO   ,
     &              ETA(1),F(1) )
        CALL NMCENI(NUMEDD,DEPDEL,DEPPR1,DEPPR2,RHO   ,
     &              ETA(2),F(2) )  
C
      ELSE IF (TYPSEL.EQ.'RESIDU') THEN 
        CALL NMCERE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,CARCRI,FONACT,DEFICO,
     &              ITERAT,SDNURO,VALMOI,VALPLU,POUGD ,
     &              SOLALG,VEELEM,VEASSE,SDTIME,OFFSET,
     &              RHO   ,ETA(1),F(1)  ,LDCCV1)  
        CALL NMCERE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,CARCRI,FONACT,DEFICO,
     &              ITERAT,SDNURO,VALMOI,VALPLU,POUGD ,
     &              SOLALG,VEELEM,VEASSE,SDTIME,OFFSET,
     &              RHO   ,ETA(2),F(2)  ,LDCCV2)       
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CHOIX DE LA FONCTION MINI
C      
      IF (F(1).LE.F(2)) THEN
        ETAF   = ETA(1)
        PILCVG = LICITE(1)
        LDCCVG = LDCCV1
        RESIDU = F(1)
      ELSE
        ETAF   = ETA(2)
        PILCVG = LICITE(2)
        LDCCVG = LDCCV2
        RESIDU = F(2)
      ENDIF
C
      CALL JEDEMA()
      END
