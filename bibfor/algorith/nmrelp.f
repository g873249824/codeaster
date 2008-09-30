      SUBROUTINE NMRELP(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CARCRI,FONACT,ITERAT,
     &                  SDNURO,SDDYNA,DELTAT,PARMET,METHOD,  
     &                  VALMOI,VALPLU,SOLALG,POUGD ,VEELEM,
     &                  VEASSE,SDTIME,CONV  ,LDCCVG)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2008   AUTEUR ABBAS M.ABBAS 
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
      INTEGER       ITERAT,LDCCVG
      REAL*8        PARMET(*),CONV(*),DELTAT
      CHARACTER*16  METHOD(*)
      CHARACTER*24  CARCRI,SDTIME       
      CHARACTER*19  LISCHA,SDDYNA,SDNURO
      CHARACTER*24  MODELE,NUMEDD,MATE  ,CARELE, COMREF, COMPOR
      CHARACTER*24  VALMOI(8),POUGD (8),VALPLU(8)
      CHARACTER*19  VEELEM(*),VEASSE(*)     
      CHARACTER*19  SOLALG(*) 
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C RECHERCHE LINEAIRE DANS LA DIRECTION DE DESCENTE
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
C IN  SDTIME : SD TIMER
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  SDNURO : SD POUTRES EN GRANDES ROTATIONS
C IN  DELTAT : INCREMENT DE TEMPS
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  SDDYNA : SD DYNAMIQUE
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                       0 : CAS DE FONCTIONNEMENT NORMAL
C                       1 : ECHEC DE L'INTEGRATION DE LA LDC
C                       3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT CONV   : INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C                       (10) ITERATIONS RECHERCHE LINEAIRE
C                       (11) VALEUR DE RHO
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
      INTEGER      ITEMAX,ITERHO,NEQ   ,ACT   ,OPT   , LDCOPT,IRET
      REAL*8       RHOMIN,RHOMAX,RHOEXM,RHOEXP,RHOEXC
      REAL*8       RHOM  ,RHOOPT, RHO
      REAL*8       F0, FM, F, FOPT, FCVG
      REAL*8       R8MAEM
      REAL*8       MEM(2,10), PARMUL, RATCVG,SENS,RHOPT1
      CHARACTER*8  K8BID
      LOGICAL      OPTI,STITE
      LOGICAL      ISFONC,REAROT
      CHARACTER*19 CNFINS(2),CNDIRS(2)
      CHARACTER*24 DEPPLU,SIGPLU,VARPLU,COMPLU
      INTEGER      JDDEPL   
      CHARACTER*24 SIGPLT,VARPLT,DEPPLT,VALPLT(8,2)
      CHARACTER*24 K24BID,K24BLA
      CHARACTER*24 CODERE,DEFICO    
      CHARACTER*19 VEFINT,VEDIRI
      CHARACTER*19 CNFINT,CNDIRI,CNFEXT
      CHARACTER*19 DEPDET,DDEPLA,DEPDEL    
      CHARACTER*19 SOLALT(30)
      CHARACTER*19 NMCHEX
      LOGICAL      LBID
      REAL*8       R8BID          
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... RECHERCHE LINEAIRE' 
      ENDIF 
C
C --- FONCTIONNALITES ACTIVEES
C
      REAROT = ISFONC(FONACT,'REAROT')              
C
C --- INITIALISATIONS
C
      K24BLA = ' '
      DEFICO = ' '
      RHOEXC = 0.D0
      PARMUL = 3.D0    
      FOPT   = R8MAEM()
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- PARAMETRES RECHERCHE LINEAIRE
C
      IF (DELTAT .LT. PARMET(13)) THEN
        ITEMAX = NINT(PARMET(12))
      ELSE
        ITEMAX = NINT(PARMET(10))
      END IF   
      RHOMIN = PARMET(14)
      RHOMAX = PARMET(15)
      RHOEXM = -PARMET(16)
      RHOEXP = PARMET(16)      
      RATCVG = PARMET(11) 
      IF (ITEMAX .GT. 1000) THEN
        CALL ASSERT(.FALSE.)
      ENDIF             
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C    
      CALL DESAGG(VALPLU,DEPPLU,SIGPLU,VARPLU,COMPLU,
     &            K24BID,K24BID,K24BID,K24BID)
      DDEPLA = NMCHEX(SOLALG,'SOLALG','DDEPLA')
      DEPDEL = NMCHEX(SOLALG,'SOLALG','DEPDEL')
      VEFINT = NMCHEX(VEELEM,'VEELEM','CNFINT')
      VEDIRI = NMCHEX(VEELEM,'VEELEM','CNDIRI')
      CNFEXT = NMCHEX(VEASSE,'VEASSE','CNFEXT')      
      CNFINT = NMCHEX(VEASSE,'VEASSE','CNFINT')
      CNDIRI = NMCHEX(VEASSE,'VEASSE','CNDIRI')    
C
C --- ACCES VARIABLES
C        
      CALL JEVEUO(DDEPLA(1:19)//'.VALE','E',JDDEPL)     
C
C --- PREPARATION DES ZONES TEMPORAIRES POUR ITERATION COURANTE
C
      CNFINS(1) =  CNFINT
      CNFINS(2) = '&&NMRECH.RESI'
      CNDIRS(1) =  CNDIRI
      CNDIRS(2) = '&&NMRECH.DIRI'
      DEPDET    = '&&CNPART.CHP1'
      DEPPLT    = '&&CNPART.CHP2'      
      SIGPLT    = '&&NMRECH.SIGP'
      VARPLT    = '&&NMRECH.VARP'
      CALL VTZERO(DEPDET)
      CALL VTZERO(DEPPLT)
      CALL COPISD('CHAMP_GD','V',VARPLU,VARPLT)
      CALL COPISD('CHAMP_GD','V',SIGPLU,SIGPLT)   
      CALL VTCREB('&&NMRECH.RESI',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&NMRECH.DIRI',NUMEDD,'V','R',NEQ)   
C
C --- CONSTRUCTION DES VARIABLES CHAPEAUX
C      
      CALL AGGLOM(DEPPLT,SIGPLU,VARPLU,COMPLU,K24BLA,
     &            K24BLA,K24BLA,K24BLA, 4, VALPLT(1,1))
      CALL AGGLOM(DEPPLT,SIGPLT,VARPLT,COMPLU,K24BLA,
     &            K24BLA,K24BLA,K24BLA, 4, VALPLT(1,2))
      CALL NMCHSO(SOLALG,'SOLALG','DEPDEL',DEPDET,SOLALT)    
C     
C --- CALCUL DE F(RHO=0)
C    
      CALL NMRECZ(NUMEDD,CNDIRI,CNFINT,CNFEXT,DDEPLA,
     &            F0    )

      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... FONCTIONNELLE INITIALE: ',F0 
      ENDIF          
      
      FCVG = ABS(RATCVG * F0) 
C                 
C --- INITIALISATION ET DIRECTION DE DESCENTE      
C
      IF (METHOD(7).EQ.'CORDE') THEN
        SENS = 1.D0
        RHOM = 0.D0
        FM   = F0
      ELSEIF (METHOD(7).EQ.'MIXTE') THEN
        IF (F0.LE.0) THEN
          SENS = 1
        ELSE
          SENS = -1
        ENDIF 
        CALL ZBINIT(SENS*F0,PARMUL,RHOEXC,10,MEM)     
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- BOUCLE DE RECHERCHE LINEAIRE
C 
      RHO  = SENS
      ACT  = 1

      DO 20 ITERHO = 0, ITEMAX
C        
C --- CALCUL DE L'INCREMENT DE DEPLACEMENT TEMPORAIRE
C 
        CALL NMMAJI(NUMEDD,REAROT,SDNURO,RHO   ,DEPDEL,
     &              DDEPLA,DEPDET)
        CALL NMMAJI(NUMEDD,REAROT,SDNURO,RHO   ,DEPPLU,
     &              DDEPLA,DEPPLT)  
C
C --- AFFICHAGE
C        
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ITERATION <',ITERHO,'>'
          WRITE (IFM,*) '<MECANONLINE> ...... INCREMENT DEPL.'
          CALL NMDEBG('VECT',DEPPLT,6)
          WRITE (IFM,*) '<MECANONLINE> ...... INCREMENT DEPL. TOTAL'
          CALL NMDEBG('VECT',DEPDET,6) 
        ENDIF     
C      
C --- REACTUALISATION DES FORCES INTERIEURES
C 
        CALL NMTIME('INIT' ,'TMP',SDTIME,LBID  ,R8BID )
        CALL NMTIME('DEBUT','TMP',SDTIME,LBID  ,R8BID )     
        CALL NMFINT(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,CARCRI,FONACT,ITERAT,
     &              SDDYNA,DEFICO,VALMOI,VALPLT(1,ACT),POUGD ,
     &              SOLALT,VEASSE,LDCCVG,CODERE,VEFINT) 
        CALL NMTIME('FIN'      ,'TMP',SDTIME,LBID  ,R8BID )
        CALL NMTIME('FORC_INTE','TMP',SDTIME,LBID  ,R8BID ) 
C
C --- ASSEMBLAGE DES FORCES INTERIEURES
C      
        CALL NMAINT(NUMEDD,FONACT,DEFICO,VEELEM,VEASSE,
     &              VEFINT,CNFINS(ACT))            
C      
C --- REACTUALISATION DES REACTIONS D'APPUI BT.LAMBDA
C
        CALL NMDIRI(MODELE,NUMEDD,MATE  ,CARELE,LISCHA,
     &              SDDYNA,VALPLT,VEDIRI)
        CALL NMADIR(NUMEDD,FONACT,DEFICO,VEASSE,VEDIRI,
     &              CNDIRS(ACT))
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... FORCES INTERNES'     
          CALL NMDEBG('VECT',CNFINS(ACT),6) 
          WRITE (IFM,*) '<MECANONLINE> ...... REACTIONS D''APPUI'
          CALL NMDEBG('VECT',CNDIRS(ACT),6) 
         ENDIF
C
C --- ECHEC A L'INTEGRATION DE LA LOI DE COMPORTEMENT
C
        IF (LDCCVG.LT.0) THEN
C        
C --- S'IL EXISTE DEJA UN RHO OPTIMAL, ON LE CONSERVE
C
          IF (ITERHO.GT.0) GOTO 100
          GOTO 9999
        END IF
C        
C --- CALCUL DE F(RHO)
C
        CALL NMRECZ(NUMEDD,CNDIRS(ACT),CNFINS(ACT),CNFEXT,DDEPLA,
     &              F    )        
             
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ... FONCTIONNELLE COURANTE: ',F 
        ENDIF             
C
C --- CALCUL DU RHO OPTIMAL
C        
        IF (METHOD(7).EQ.'CORDE') THEN
          CALL NMRECH(FM    ,F     ,FOPT  ,FCVG  ,RHOMIN,
     &                RHOMAX,RHOEXM,RHOEXP,RHOM  ,RHO   ,
     &                RHOOPT,LDCOPT,LDCCVG,OPT   ,ACT   ,     
     &                OPTI  ,STITE)    
     
        ELSEIF (METHOD(7).EQ.'MIXTE') THEN
          CALL NMREBO(F     ,MEM   ,SENS  ,RHO   ,RHOOPT,
     &                LDCOPT,LDCCVG,FOPT  ,FCVG  ,OPT   ,
     &                ACT   ,OPTI  ,STITE)  
          IF (ITERHO.EQ.0)THEN
            RHOPT1 = RHO
          ENDIF
          IF (RHO.GT.RHOMAX .OR. RHO.LT.RHOMIN)THEN
            GOTO 90
          ENDIF   
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF  
        IF (STITE) THEN 
          GOTO 100
        ENDIF
 20   CONTINUE
      ITERHO = ITEMAX
C      
 90   CONTINUE      
      IF (METHOD(7).EQ.'MIXTE') THEN
        ITERHO = 1
        RHOOPT = RHOPT1
      ENDIF      
C
C --- STOCKAGE DU RHO OPTIMAL ET DES CHAMPS CORRESPONDANTS
C
 100  CONTINUE
C       
C --- AJUSTEMENT DE LA DIRECTION DE DESCENTE 
C     
      CALL DAXPY(NEQ  ,RHOOPT-1.D0,ZR(JDDEPL),1,ZR(JDDEPL),1) 
C                     
C --- RECUPERATION DES VARIABLES EN T+ SI NECESSAIRE 
C     
      IF (OPT.NE.1) THEN
        CALL COPISD('CHAMP_GD','V',SIGPLT,SIGPLU)
        CALL COPISD('CHAMP_GD','V',VARPLT,VARPLU)
        CALL COPISD('CHAMP_GD','V',CNFINS(OPT),CNFINT)
        CALL COPISD('CHAMP_GD','V',CNDIRS(OPT),CNDIRI)
      END IF
C      
C --- INFORMATIONS SUR LA RECHERCHE LINEAIRE     
C 
      CONV(10) = ITERHO
      CONV(11) = RHOOPT 
      LDCCVG   = LDCOPT

 9999 CONTINUE
C
      CALL DETRSD('CHAMP', '&&NMRECH.RESI')
      CALL DETRSD('CHAMP', '&&NMRECH.DIRI')      
      CALL JEDEMA()      
      
      END
