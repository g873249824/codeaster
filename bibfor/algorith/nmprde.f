      SUBROUTINE NMPRDE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,METHOD,SOLVEU,FONACT,
     &                  PARMET,CARCRI,PARCRI,SDPILO,SDDISC,
     &                  SDTIME,NUMINS,VALMOI,VALPLU,POUGD ,
     &                  SOLALG,LICCVG,MATASS,MAPREC,DEFICO,
     &                  RESOCO,SDDYNA,CODERE,MEELEM,MEASSE,
     &                  VEELEM,VEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      LOGICAL      FONACT(*)
      INTEGER      NUMINS,LICCVG(*)
      REAL*8       PARMET(*),PARCRI(*)
      CHARACTER*14 SDPILO
      CHARACTER*16 METHOD(*)
      CHARACTER*19 MAPREC,MATASS
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA
      CHARACTER*24 MODELE,NUMEDD, MATE, CARELE, COMREF, COMPOR
      CHARACTER*24 CARCRI 
      CHARACTER*24 VALMOI(8),POUGD(8),VALPLU(8)
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 CODERE,SDTIME
      CHARACTER*19 VEELEM(*),VEASSE(*) 
      CHARACTER*19 MEELEM(*),MEASSE(*)
      CHARACTER*19 SOLALG(*)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
C
C PREDICTION PAR DEPLACEMENT DONNE
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
C IN  MAPREC : MATRICE DE PRECONDITIONNEMENT (GCPC)
C IN  MATASS : MATRICE ASSEMBLEE
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN  SOLVEU : SOLVEUR
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  PARCRI : CRITERES DE CONVERGENCE
C IN  SDPILO : SD PILOTAGE
C IN  SDDISC : SD DISC_INST
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDTIME : SD TIMER
C IN  DEFICO : SD CONTACT DEFINITION
C IN  RESOCO : SD CONTACT RESOLUTION
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
C OUT LICCVG : CODES RETOURS (* POUR INDIQUER CEUX QUI SONT CHANGES)
C               (1)   - PILOTAGE
C               (2) * - INTEGRATION DE LA LOI DE COMPORTEMENT
C               (3)   - TRAITEMENT DU CONTACT 
C               (4)   - MATRICE DE CONTACT
C               (5) * - MATRICE DU SYSTEME SINGULIERE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      LDCCVG,FACCVG
      INTEGER      JDEPDE, JDDEPL,JNUM
      INTEGER      NEQ, I,IRET
      CHARACTER*8  K8BID
      CHARACTER*19 DEPSO1,DEPSO2,SOLU1,SOLU2
      CHARACTER*19 CNCINE,CNDONN,CNPILO
      CHARACTER*19 NMCHEX
      CHARACTER*24 DEPEST
      LOGICAL      LDIRI,ISDIRI,LMATRC
      INTEGER      REITER
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CNDONN    = '&&CNCHAR.DONN'
      CNPILO    = '&&CNCHAR.PILO'     
      DEPEST    = '&&CNPART.CHP1'
      SOLU1     = '&&CNPART.CHP2'
      SOLU2     = '&&CNPART.CHP3'
      REITER    = NINT(PARMET(2))      
      CALL VTZERO(DEPEST)
      CALL VTZERO(SOLU1)
      CALL VTZERO(SOLU2)
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CNCINE = NMCHEX(VEASSE,'VEASSE','CNCINE')
      DEPSO1 = NMCHEX(SOLALG,'SOLALG','DEPSO1')
      DEPSO2 = NMCHEX(SOLALG,'SOLALG','DEPSO2')   
      CALL VTZERO(DEPSO1)
      CALL VTZERO(DEPSO2)          
C
C --- VALEUR DU DEPLACEMENT A ESTIMER -> DEPEST/DEPSO1
C             
      IF (METHOD(5) .EQ. 'EXTRAPOL') THEN
        CALL NMPREX(METHOD,NUMEDD,VALMOI,SOLALG,SDDISC,
     &              NUMINS,DEPSO1,DEPEST)
      ELSE IF (METHOD(5) .EQ. 'DEPL_CALCULE') THEN
        CALL NMPRDC(METHOD,NUMEDD,VALMOI,SDDISC,NUMINS,
     &              DEPSO1,DEPEST)      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- Y-A-T-IL DES CONDITIONS DE DIRICHLET (TYPE _MECA et NON _CINE)
C --- SI NON -> PAS DE RE-PROJECTION POUR AVOIR CHAMP CINEMATIQUEMENT 
C --- ADMISSIBLE
C
      LDIRI = ISDIRI(LISCHA)
      IF (.NOT.LDIRI) THEN
        CALL U2MESS('A','MECANONLINE5_48')
C       MATRICE EN CORRECTION ?
        LMATRC = .TRUE.
        IF (REITER.EQ.0) THEN
          LMATRC = .FALSE.
        ELSE
          LMATRC = MOD(1,REITER) .EQ. 0 
        ENDIF      
        IF (.NOT.LMATRC) THEN
          IF ((NINT(PARCRI(4)).EQ.0).AND.
     &        (NINT(PARCRI(1)).NE.0)) THEN
            CALL U2MESS('F','MECANONLINE5_49')
          ENDIF
        ENDIF
        
        GOTO 9999
      ENDIF
C
C --- CALCUL DE LA MATRICE GLOBALE
C  
      CALL NMPRMA(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &            PARMET,METHOD,LISCHA,NUMEDD,SOLVEU,
     &            COMREF,SDDISC,SDDYNA,SDTIME,NUMINS,
     &            FONACT,DEFICO,RESOCO,VALMOI,VALPLU,
     &            SOLALG,POUGD ,VEELEM,MEELEM,MEASSE,
     &            MAPREC,MATASS,CODERE,FACCVG,LDCCVG)      
C  
      IF ((FACCVG.EQ.1).OR.(FACCVG.EQ.2)) GOTO 9999  
C
C --- CALCUL DU SECOND MEMBRE 
C      
      CALL NMASSD(MODELE,NUMEDD,MATE  ,CARELE,LISCHA,
     &            FONACT,DEFICO,DEPEST,VEASSE,CNPILO,
     &            CNDONN)
C
C --- RESOLUTION
C
      CALL NMRESO(FONACT,SDPILO,CNDONN,CNPILO,CNCINE,
     &            SOLVEU,MAPREC,MATASS,SOLU1,SOLU2)
C
C --- MODIFICATION DE L'INCREMENT SOLUTION DE LA
C --- PREDICTION (EXCEPTE LES LAGRANGES)
C --- CHAMP DE DEPLACEMENT CINEMATIQUEMENT ADMISSIBLE
C       
      CALL JEVEUO(NUMEDD(1:14)// '.NUME.DELG','L',JNUM)

      CALL JEVEUO(SOLU1 (1:19)//'.VALE','L',JDDEPL)
      CALL JEVEUO(DEPSO1(1:19)//'.VALE','E',JDEPDE)
      DO 10 I = 1, NEQ
        IF (ZI(JNUM+I-1).EQ.0) THEN
          ZR(JDEPDE+I-1) = ZR(JDEPDE+I-1) + ZR(JDDEPL+I-1)
        ENDIF  
 10   CONTINUE

      CALL JEVEUO(SOLU2 (1:19)// '.VALE','L',JDDEPL)
      CALL JEVEUO(DEPSO2(1:19)// '.VALE','E',JDEPDE)
      DO 11 I = 1, NEQ
        IF (ZI(JNUM+I-1).EQ.0) THEN
          ZR(JDEPDE+I-1) = ZR(JDDEPL+I-1)
        ENDIF  
 11   CONTINUE
C
 9999 CONTINUE
C
C --- RECOPIE CODE RETOUR ERREURS      
C
      LICCVG(5) = FACCVG
      LICCVG(2) = LDCCVG
C
      CALL JEDEMA()
      END
