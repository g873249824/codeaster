      SUBROUTINE NMCERE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CARCRI,FONACT,SDSTAT,
     &                  DEFICO,ITERAT,SDNUME,VALINC,SOLALG,
     &                  VEELEM,VEASSE,SDTIME,OFFSET,RHO   ,
     &                  ETA   ,RESIDU,LDCCVG,MATASS)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/07/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER       FONACT(*)
      INTEGER       ITERAT,LDCCVG
      REAL*8        ETA,RHO, OFFSET,RESIDU
      CHARACTER*19  LISCHA,SDNUME,MATASS
      CHARACTER*24  MODELE,NUMEDD,MATE  ,CARELE,COMREF,COMPOR
      CHARACTER*24  CARCRI,DEFICO
      CHARACTER*24  SDTIME,SDSTAT
      CHARACTER*19  VEELEM(*),VEASSE(*)
      CHARACTER*19  SOLALG(*),VALINC(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
C
C CHOIX DU ETA DE PILOTAGE PAR CALCUL DU RESIDU
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
C IN  LISCHA : LISTE DES CHARGES
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  SDNUME : SD NUMEROTATION
C IN  SDSTAT : SD STATISTIQUES
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  OFFSET : DECALAGE DE ETA_PILOTAGE EN FONCTION DE RHO
C IN  RHO    : PARAMETRE DE RECHERCHE_LINEAIRE
C IN  ETA    : PARAMETRE DE PILOTAGE
C IN  SDNUME : SD NUMEROTATION
C IN  SDTIME : SD TIMER
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                 0 : CAS DE FONCTIONNEMENT NORMAL
C                 1 : ECHEC DE L'INTEGRATION DE LA LDC
C                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT RESIDU : RESIDU OPTIMAL SI L'ON A CHOISI LE RESIDU
C IN  MATASS : SD MATRICE ASSEMBLEE
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
      INTEGER      NVAL,NSOL
      PARAMETER    (NVAL=18,NSOL=17)
C
      LOGICAL      ISFONC,LGROT,LENDO
      INTEGER      NEQ,IRET,NMAX
      CHARACTER*8  K8BID
      CHARACTER*19 VEFINT,VEDIRI,VEBUDI
      CHARACTER*19 CNFINT,CNDIRI,CNFEXT,CNBUDI
      CHARACTER*24 CODERE
      CHARACTER*19 VALINT(NVAL)
      CHARACTER*19 SOLALT(NSOL)
      CHARACTER*19 DEPDET,DEPDEL,DEPPR1,DEPPR2
      INTEGER      JDEPDT,JDEPDL,JDU0, JDU1
      CHARACTER*19 DEPPLT,DDEP
      INTEGER      JDEPPT,JDDEPL
      CHARACTER*19 DEPPLU
      INTEGER      JDEPPL
      CHARACTER*19 SIGPLU,VARPLU,COMPLU
      CHARACTER*19 DEPL,VITE,ACCE,K19BLA
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
        WRITE (IFM,*) '<PILOTAGE> ...... CALCUL DU RESIDU'
      ENDIF
C
C --- INITIALISATIONS
C
      K19BLA = ' '
      LGROT  = ISFONC(FONACT,'GD_ROTA')
      LENDO  = ISFONC(FONACT,'ENDO_NO')
      DDEP   = '&&CNCETA.CHP0'
      DEPDET = '&&CNCETA.CHP1'
      DEPPLT = '&&CNCETA.CHP2'
      CODERE = '&&NMCETA.CODRE1'
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
      CALL NMCHAI('VALINC','LONMAX',NMAX  )
      CALL ASSERT(NMAX.EQ.NVAL)
      CALL NMCHAI('SOLALG','LONMAX',NMAX  )
      CALL ASSERT(NMAX.EQ.NSOL)
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
      CALL NMCHEX(VALINC,'VALINC','SIGPLU',SIGPLU)
      CALL NMCHEX(VALINC,'VALINC','VARPLU',VARPLU)
      CALL NMCHEX(VALINC,'VALINC','COMPLU',COMPLU)
      CALL NMCHEX(SOLALG,'SOLALG','DEPDEL',DEPDEL)
      CALL NMCHEX(SOLALG,'SOLALG','DEPPR1',DEPPR1)
      CALL NMCHEX(SOLALG,'SOLALG','DEPPR2',DEPPR2)
      CALL NMCHEX(VEELEM,'VEELEM','CNDIRI',VEDIRI)
      CALL NMCHEX(VEASSE,'VEASSE','CNDIRI',CNDIRI)
      CALL NMCHEX(VEELEM,'VEELEM','CNFINT',VEFINT)
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT)
      CALL NMCHEX(VEELEM,'VEELEM','CNBUDI',VEBUDI)
      CALL NMCHEX(VEASSE,'VEASSE','CNBUDI',CNBUDI)
C
C --- MISE A JOUR DEPLACEMENT
C --- DDEP = RHO*DEPPRE(1) + (ETA-OFFSET)*DEPPRE(2)
C
      CALL JEVEUO(DEPPR1(1:19)//'.VALE','L',JDU0)
      CALL JEVEUO(DEPPR2(1:19)//'.VALE','L',JDU1)
      CALL JEVEUO(DDEP(1:19)  //'.VALE','E',JDDEPL)
      CALL R8INIR(NEQ   ,0.D0      ,ZR(JDDEPL),1)
      CALL DAXPY (NEQ   ,RHO       ,ZR(JDU0)  ,1, ZR(JDDEPL),1)
      CALL DAXPY (NEQ   ,ETA-OFFSET,ZR(JDU1)  ,1, ZR(JDDEPL),1)
C
C --- MISE A JOUR DE L'INCREMENT DE DEPLACEMENT DEPUIS LE DEBUT
C --- DU PAS DE TEMPS DEPDET = DEPDEL+DDEP
C
      CALL JEVEUO(DEPDEL(1:19)//'.VALE','L',JDEPDL)
      CALL JEVEUO(DEPDET(1:19)//'.VALE','E',JDEPDT)
      CALL MAJOUR(NEQ    ,LGROT ,LENDO ,SDNUME,ZR(JDEPDL),
     &            ZR(JDDEPL),1.D0   ,ZR(JDEPDT),0)
C
C --- MISE A JOUR DU DEPLACEMENT DEPPLT = DEPPLU+DDEP
C
      CALL JEVEUO(DEPPLU(1:19)//'.VALE','L',JDEPPL)
      CALL JEVEUO(DEPPLT(1:19)//'.VALE','E',JDEPPT)
      CALL MAJOUR(NEQ    ,LGROT ,LENDO ,SDNUME,ZR(JDEPPL),
     &            ZR(JDDEPL),1.D0   ,ZR(JDEPPT),1)
C
C --- RECONSTRUCTION DES VARIABLES CHAPEAUX
C
      CALL NMCHA0('VALINC','ALLINI',' ',VALINT)
      CALL NMCHCP('VALINC',VALINC,VALINT)
      CALL NMCHA0('VALINC','DEPPLU',DEPPLT,VALINT)
      CALL NMCHSO(SOLALG,'SOLALG','DEPDEL',DEPDET,SOLALT)
      CALL NMCHEX(VALINT,'VALINC','DEPPLU',DEPL  )
      CALL NMCHEX(VALINT,'VALINC','VITPLU',VITE )
      CALL NMCHEX(VALINT,'VALINC','ACCPLU',ACCE  )
C
C --- REACTUALISATION DES FORCES INTERIEURES
C
      CALL NMFINT(MODELE,MATE  ,CARELE,COMREF,COMPOR,
     &            LISCHA,CARCRI,FONACT,ITERAT,K19BLA,
     &            SDSTAT,SDTIME,VALINT,SOLALT,LDCCVG,
     &            CODERE,VEFINT)
C
C --- ASSEMBLAGE DES FORCES INTERIEURES
C
      CALL NMAINT(NUMEDD,FONACT,DEFICO,VEASSE,VEFINT,
     &            CNFINT,SDNUME)
C
C --- MESURES
C
      CALL NMTIME(SDTIME,'INI','SECO_MEMB')
      CALL NMTIME(SDTIME,'RUN','SECO_MEMB')
C
C --- REACTUALISATION DES REACTIONS D'APPUI BT.LAMBDA
C
      CALL NMDIRI(MODELE,MATE  ,CARELE,LISCHA,K19BLA,
     &            DEPL  ,VITE  ,ACCE  ,VEDIRI)
      CALL NMADIR(NUMEDD,FONACT,DEFICO,VEASSE,VEDIRI,
     &            CNDIRI)
C
C --- REACTUALISATION DES CONDITIONS DE DIRICHLET B.U
C
      CALL NMBUDI(MODELE,NUMEDD,LISCHA,DEPPLT,VEBUDI,
     &            CNBUDI,MATASS)
C
C --- REACTUALISATION DES EFFORTS EXTERIEURS (AVEC ETA)
C
      CALL NMCHEX(VEASSE,'VEASSE','CNFEXT',CNFEXT)
      CALL NMFEXT(ETA   ,FONACT,K19BLA,VEASSE,CNFEXT)
C
      CALL NMTIME(SDTIME,'END','SECO_MEMB')
C
C --- CALCUL DU RESIDU
C
      IF (LDCCVG .EQ. 0) THEN
        CALL NMPILR(NUMEDD,VEASSE,RESIDU,ETA)
      ENDIF
C
      CALL JEDEMA()
      END
