      SUBROUTINE NMASSV(TYPVEZ,
     &                  MODELZ,LISCHA,MATE  ,CARELE,COMPOR,
     &                  NUMEDD,INSTAM,INSTAP,RESOCO,RESOCU,
     &                  SDDYNA,VALMOI,COMREF,VALPLU,SOLALG,
     &                  POUGD ,MEASSE,VECELZ,VECASZ)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2009   AUTEUR COURTOIS M.COURTOIS 
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
      CHARACTER*(*) MODELZ,TYPVEZ    
      CHARACTER*19  LISCHA
      REAL*8        INSTAM,INSTAP
      CHARACTER*19  SDDYNA
      CHARACTER*24  MATE  ,CARELE,COMPOR,NUMEDD,COMREF
      CHARACTER*24  RESOCO,RESOCU
      CHARACTER*24  VALMOI(8),VALPLU(8),POUGD (8)
      CHARACTER*19  SOLALG(*)
      CHARACTER*19  MEASSE(*)
      CHARACTER*(*) VECASZ,VECELZ
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C ASSEMBLAGE DES VECTEURS ELEMENTAIRES
C      
C ----------------------------------------------------------------------
C
C
C IN  TYPVEC : TYPE DE CALCUL VECT_ELEM
C IN  MODELE : MODELE
C IN  LISCHA : LISTE DES CHARGES
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C IN  NUMEDD : NUME_DDL
C IN  INSTAM : INSTANT MOINS
C IN  INSTAP : INSTANT PLUS
C IN  SDDYNA : SD DYNAMIQUE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  RESOCU : SD POUR LA RESOLUTION LIAISON_UNILATER
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  COMREF : VARI_COM DE REFERENCE
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  VECELE : VECT_ELEM A ASSEMBLER 
C OUT VECASS : VECT_ASSE CALCULEE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      REAL*8       R8BID
      CHARACTER*19 NMCHEX
      CHARACTER*19 SSTRU
      CHARACTER*19 VECELE
      CHARACTER*24 VAONDE,VADIDO,VAFEDO,VALAMP,VAIMPE 
      CHARACTER*24 VAFEPI,VAFSDO     
      CHARACTER*8  MODELE
      CHARACTER*24 K24BID,VECASS
      CHARACTER*24 DEPMOI,VITPLU,ACCPLU,DEPPLU,ACCMOI
      CHARACTER*24 DEPKM1,VITKM1,ACCKM1,ROMKM1,ROMK,VITMOI
      CHARACTER*24 CHARGE,INFOCH,FOMULT,FOMUL2
      CHARACTER*16 TYPVEC
      INTEGER      JIMPE,JVAANC
      LOGICAL      LVALM,LVALP,LPOUG,NDYNLO,LTHETA
      INTEGER      IFM,NIV
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C      
      TYPVEC = TYPVEZ
      MODELE = MODELZ
      VECASS = VECASZ  
      VECELE = VECELZ                        
C                
      CHARGE = LISCHA(1:19)//'.LCHA'
      INFOCH = LISCHA(1:19)//'.INFC'        
      FOMULT = LISCHA(1:19)//'.FCHA' 
      FOMUL2 = LISCHA(1:19)//'.FCSS'        
C
C --- INDICATEUR PRESENCE VARIABLES CHAPEAUX
C
      LVALM     = .FALSE.
      LVALP     = .FALSE.
      LPOUG     = .FALSE.
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      IF (VALMOI(1)(1:1).NE.' ') THEN   
        CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,
     &              VITMOI,ACCMOI,K24BID,K24BID)
        LVALM = .TRUE.
      ENDIF     
      IF (VALPLU(1)(1:1).NE.' ') THEN   
        CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &              VITPLU,ACCPLU,K24BID,K24BID)
        LVALP = .TRUE.
      ENDIF         
      IF (POUGD(1)(1:1).NE.' ') THEN   
        CALL DESAGG(POUGD ,DEPKM1,VITKM1,ACCKM1,ROMKM1,
     &              ROMK  ,K24BID,K24BID,K24BID)                 
        LPOUG = .TRUE.
      ENDIF                         
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE><VECT> ASSEMBLAGE DES VECT_ELEM' //
     &                ' DE TYPE <',TYPVEC,'>' 
      ENDIF                     
C   
C --- FORCES NODALES
C     
      IF (TYPVEC.EQ.'CNFNOD') THEN     
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- DEPLACEMENTS DIRICHLET FIXE 
C
      ELSEIF (TYPVEC.EQ.'CNDIDO') THEN        
        CALL ASASVE(VECELE,NUMEDD,'R',VADIDO)
        CALL ASCOVA('D',VADIDO,FOMULT,'INST', INSTAP, 'R',VECASS)
C
C --- DEPLACEMENTS DIRICHLET DIFFERENTIEL
C
      ELSEIF (TYPVEC.EQ.'CNDIDI') THEN       
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- DEPLACEMENTS DIRICHLET PILOTE
C
      ELSEIF (TYPVEC.EQ.'CNDIPI') THEN  
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- FORCES DE LAPLACE
C
      ELSEIF (TYPVEC.EQ.'CNLAPL') THEN   
        CALL ASASVE(VECELE,NUMEDD,'R',VALAMP)
        CALL ASCOVA('D',VALAMP,FOMULT,'INST',INSTAP,'R',VECASS)
C
C --- FORCES ONDES PLANES 
C
      ELSEIF (TYPVEC.EQ.'CNONDP') THEN 
        CALL ASASVE(VECELE,NUMEDD,'R',VAONDE)
        CALL ASCOVA('D',VAONDE,' ','INST',R8BID,'R',VECASS)     
C
C --- FORCES IMPEDANCES
C    
      ELSEIF (TYPVEC(1:9).EQ.'CNIMPP') THEN  
        CALL ASASVE(VECELE,NUMEDD,'R',VAIMPE)
        CALL JEVEUO(VAIMPE,'L',JVAANC)
        CALL JEVEUO(ZK24(JVAANC)(1:19)//'.VALE','L',JIMPE)
        CALL COPISD('CHAMP_GD','V',ZK24(JVAANC),VECASS)
      ELSEIF (TYPVEC(1:9).EQ.'CNIMPC') THEN  
        CALL ASASVE(VECELE,NUMEDD,'R',VAIMPE)
        CALL JEVEUO(VAIMPE,'L',JVAANC)
        CALL JEVEUO(ZK24(JVAANC)(1:19)//'.VALE','L',JIMPE)
        CALL COPISD('CHAMP_GD','V',ZK24(JVAANC),VECASS)        
C
C --- FORCES FIXES MECANIQUES DONNEES
C      
      ELSEIF (TYPVEC.EQ.'CNFEDO') THEN      
        CALL ASASVE(VECELE,NUMEDD,'R',VAFEDO)
        CALL ASCOVA('D',VAFEDO,FOMULT,'INST',INSTAP,'R',VECASS)    
C
C --- FORCES SENSIBILITE COMPORTEMENT
C
      ELSEIF (TYPVEC.EQ.'CNMSME') THEN 
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)   
C
C --- FORCES PILOTEES
C             
      ELSEIF (TYPVEC.EQ.'CNFEPI') THEN 
        CALL ASASVE(VECELE,NUMEDD,'R',VAFEPI)
        CALL ASCOVA('D',VAFEPI,FOMULT,'INST',INSTAP,'R',VECASS)  
C        
C --- FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION 
C
      ELSEIF (TYPVEC.EQ.'CNSSTF') THEN    
        CALL ASSVSS('V'   ,VECASS,VECELE,NUMEDD,' ',
     &              'ZERO',1     ,FOMUL2,INSTAP)        
C
C --- FORCES SUIVEUSES
C     
      ELSEIF (TYPVEC.EQ.'CNFSDO') THEN
        CALL ASASVE(VECELE,NUMEDD,'R',VAFSDO)
        CALL ASCOVA('D',VAFSDO,FOMULT,'INST',INSTAP,'R',VECASS)         
C     
C --- FORCE DE REFERENCE
C
      ELSEIF (TYPVEC.EQ.'CNREFE') THEN      
        CALL ASSMIV('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C     
C --- FORCE DE REFERENCE POUR VARIABLES DE COMMANDE INITIALES
C
      ELSEIF (TYPVEC.EQ.'CNVCF1') THEN            
        CALL ASSVEC ('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1) 
C     
C --- FORCE DE REFERENCE POUR VARIABLES DE COMMANDE COURANTES
C
      ELSEIF (TYPVEC.EQ.'CNVCF0') THEN               
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- FORCES DE CONTACT CONTINU 
C
      ELSEIF (TYPVEC.EQ.'CNCTCC') THEN        
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)       
C
C --- FORCES DE FROTTEMENT CONTINU 
C
      ELSEIF (TYPVEC.EQ.'CNCTCF') THEN               
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- FORCES DE CONTACT XFEM
C
      ELSEIF (TYPVEC.EQ.'CNXFEC') THEN       
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)       
C
C --- FORCES DE FROTTEMENT XFEM
C
      ELSEIF (TYPVEC.EQ.'CNXFEF') THEN    
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1) 
C
C --- FORCES DE CONTACT XFEM GRANDS GLISSEMENTS
C
      ELSEIF (TYPVEC.EQ.'CNXFTC') THEN        
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)       
C
C --- FORCES DE FROTTEMENT XFEM GRANDS GLISSEMENTS
C
      ELSEIF (TYPVEC.EQ.'CNXFTF') THEN     
        CALL ASSVEC('V',VECASS,1,VECELE,1.D0,NUMEDD,' ','ZERO',1)
C
C --- CONDITIONS DE DIRICHLET VIA AFFE_CHAR_CINE (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNCINE') THEN      
        CALL NMCVCI(CHARGE,INFOCH,FOMULT,NUMEDD,DEPMOI,
     &              INSTAP,VECASS)    
C
C --- FORCES ISSUES DES MACRO-ELEMENTS (PAS DE VECT_ELEM)
C --- VECT_ASSE(MACR_ELEM) = MATR_ASSE(MACR_ELEM) * VECT_DEPL
C     
      ELSEIF (TYPVEC.EQ.'CNSSTR') THEN  
        IF (.NOT.LVALP) CALL ASSERT(.FALSE.)
        SSTRU = NMCHEX(MEASSE,'MEASSE','MESSTR')    
        CALL NMMACV(DEPPLU,SSTRU,VECASS)            
C        
C --- FORCES ISSUES DES VARIABLES DE COMMANDE (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNVCPR') THEN  
        IF (.NOT.LVALM) CALL ASSERT(.FALSE.)
        IF (.NOT.LVALP) CALL ASSERT(.FALSE.)        
        CALL NMVCPR(MODELE,LISCHA,NUMEDD,MATE  ,CARELE, 
     &              COMREF,COMPOR,VALMOI,VALPLU,VECASS)     
C
C --- FORCE D'EQUILIBRE DYNAMIQUE (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNDYNA') THEN
        LTHETA = NDYNLO(SDDYNA,'THETA_METHODE')
        IF (LTHETA) THEN
          CALL NDFDYN(SDDYNA,MEASSE,VITMOI,ACCMOI,VECASS)
        ELSE
          CALL NDFDYN(SDDYNA,MEASSE,VITPLU,ACCPLU,VECASS)
        ENDIF
C
C --- FORCES D'AMORTISSEMENT MODAL EN PREDICTION (PAS DE VECT_ELEM)
C 
      ELSEIF (TYPVEC.EQ.'CNMODP') THEN 
        IF (.NOT.LVALP) CALL ASSERT(.FALSE.)
        IF (.NOT.LPOUG) CALL ASSERT(.FALSE.)
        CALL NMAMOD('PRED',NUMEDD,SDDYNA,VITPLU,VITKM1,
     &              VECASS)
C
C --- FORCES D'AMORTISSEMENT MODAL EN CORRECTION (PAS DE VECT_ELEM)
C 
      ELSEIF (TYPVEC.EQ.'CNMODC') THEN 
        IF (.NOT.LVALP) CALL ASSERT(.FALSE.)
        IF (.NOT.LPOUG) CALL ASSERT(.FALSE.)
        CALL NMAMOD('CORR',NUMEDD,SDDYNA,VITPLU,VITKM1,
     &              VECASS)     
C
C --- FORCES DE FROTTEMENT DISCRET (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNCTDF') THEN 
        CALL CFFOFR(NUMEDD,RESOCO,VECASS)
C
C --- FORCES DE CONTACT DISCRET (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNCTDC') THEN 
        CALL CFFOCO(NUMEDD,RESOCO,VECASS)      
C
C --- FORCES DE LIAISON_UNILATER (PAS DE VECT_ELEM)
C
      ELSEIF (TYPVEC.EQ.'CNUNIL') THEN 
        CALL CUFOCO(NUMEDD,RESOCU,VECASS)                    
C
      ELSE  
        CALL ASSERT(.FALSE.)
      ENDIF
C
 999  CONTINUE
C
C --- DEBUG
C
      IF (NIV.EQ.2) THEN
        CALL NMDEBG('VECT',VECASS,IFM   )
      ENDIF 
C
      CALL JEDEMA()      
C
      END
