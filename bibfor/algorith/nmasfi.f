      SUBROUTINE NMASFI(FONACT,SDDYNA,VEASSE,CNFFDO,CNFFPI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2008   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      CHARACTER*19 CNFFDO,CNFFPI
      CHARACTER*19 VEASSE(*)
      LOGICAL      FONACT(*)
      CHARACTER*19 SDDYNA
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DES COMPOSANTES DU VECTEUR SECOND MEMBRE
C  - CHARGEMENT DE TYPE NEUMANN
C  - CHARGEMENT FIXE AU COURS DU PAS DE TEMPS
C  - CHARGEMENT DONNE ET PILOTE
C      
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  SDDYNA : SD DYNAMIQUE 
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE  
C OUT CNFFDO : VECT_ASSE DE TOUTES LES FORCES FIXES DONNES
C OUT CNFFPI : VECT_ASSE DE TOUTES LES FORCES FIXES PILOTES
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

      INTEGER      IFM,NIV   
      INTEGER      IFDO
      INTEGER      N
      CHARACTER*19 CNDONN(20)
      REAL*8       CODONN(20)
      REAL*8       NDYNRE,COEEXT,COEEX2 
      CHARACTER*19 CNFEDO,CNLAME,CNONDP,CNGRFL,CNFEPI
      CHARACTER*19 NMCHEX,CNSSTF,NDYNKK
      LOGICAL      ISFONC,NDYNLO,LLAPL
      LOGICAL      LONDE,LPILO,LSSTF,LGRFL,LMPAS,LDYNA
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL NEUMANN CONSTANT' 
      ENDIF
C
C --- FONCTIONNALITES ACTIVEES
C     
      LONDE  = NDYNLO(SDDYNA,'ONDE_PLANE')  
      LLAPL  = ISFONC(FONACT,'LAPLACE')
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LGRFL  = NDYNLO(SDDYNA,'FORCE_FLUIDE') 
      LSSTF  = ISFONC(FONACT,'SOUS_STRUC')      
      LMPAS  = NDYNLO(SDDYNA,'MULTI_PAS')  
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')   
C
C --- INITIALISATIONS
C
      IFDO   = 0       
      CALL VTZERO(CNFFDO)
      CALL VTZERO(CNFFPI)
C
C --- COEFFICIENTS POUR MULTI-PAS
C     
      IF (LDYNA) THEN
        COEEXT = NDYNRE(SDDYNA,'COEF_MPAS_FEXT_PREC')  
        COEEX2 = NDYNRE(SDDYNA,'COEF_MPAS_FEXT_COUR')               
      ELSE
        COEEXT = 1.D0
        COEEX2 = 1.D0
      ENDIF                       
C
C --- FORCES DONNEES
C
      CNFEDO       = NMCHEX(VEASSE,'VEASSE','CNFEDO')
      IFDO         = IFDO+1 
      CNDONN(IFDO) = CNFEDO
      CODONN(IFDO) = COEEX2       
C
C --- CHARGEMENTS FORCES DE LAPLACE   
C   
      IF (LLAPL) THEN 
        CNLAME       = NMCHEX(VEASSE,'VEASSE','CNLAPL')
        IFDO         = IFDO+1 
        CNDONN(IFDO) = CNLAME
        CODONN(IFDO) = COEEX2
      ENDIF   
C      
C --- CHARGEMENTS ONDE_PLANE       
C      
      IF (LONDE) THEN 
        CNONDP       = NMCHEX(VEASSE,'VEASSE','CNONDP')
        IFDO         = IFDO+1 
        CNDONN(IFDO) = CNONDP
        CODONN(IFDO) = -1.D0*COEEX2
      ENDIF  
C        
C --- FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION 
C      
      IF (LSSTF) THEN
        CNSSTF       = NMCHEX(VEASSE,'VEASSE','CNSSTF') 
        IFDO         = IFDO+1 
        CNDONN(IFDO) = CNSSTF
        CODONN(IFDO) = 1.D0     
      ENDIF 
C        
C --- FORCES FLUIDES
C      
      IF (LGRFL) THEN
        CNGRFL       = NMCHEX(VEASSE,'VEASSE','CNGRFL') 
        IFDO         = IFDO+1 
        CNDONN(IFDO) = CNGRFL
        CODONN(IFDO) = COEEX2      
      ENDIF
C
C --- AJOUT FORCES EXTERNES PAS PRECEDENT
C      
      IF (LMPAS) THEN 
        CNFEDO       = NDYNKK(SDDYNA,'CNFEDO')
        IFDO         = IFDO+1 
        CNDONN(IFDO) = CNFEDO
        CODONN(IFDO) = COEEXT 
        IF (LLAPL) THEN 
          CNLAME       = NDYNKK(SDDYNA,'CNLAPL')
          IFDO         = IFDO+1 
          CNDONN(IFDO) = CNLAME
          CODONN(IFDO) = COEEXT 
        ENDIF    
        IF (LONDE) THEN 
          CNONDP       = NDYNKK(SDDYNA,'CNONDP')
          IFDO         = IFDO+1 
          CNDONN(IFDO) = CNONDP
          CODONN(IFDO) = COEEXT
        ENDIF      
        IF (LGRFL) THEN     
          CNGRFL       = NDYNKK(SDDYNA,'CNGRFL')
          IFDO         = IFDO+1 
          CNDONN(IFDO) = CNGRFL
          CODONN(IFDO) = -1.D0*COEEXT         
        ENDIF  
      ENDIF                                
C
C --- VECTEUR RESULTANT FORCES DONNEES
C       
      DO 10 N = 1,IFDO
        CALL VTAXPY(CODONN(N),CNDONN(N),CNFFDO)  
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ......... FORC. DONNEES' 
          WRITE (IFM,*) '<MECANONLINE> .........  ',N,' - COEF: ',
     &                 CODONN(N)
          CALL NMDEBG('VECT',CNDONN(N),IFM)
        ENDIF            
 10   CONTINUE   
C
C --- VECTEUR RESULTANT FORCES PILOTEES
C
      IF (LPILO) THEN       
        CNFEPI       = NMCHEX(VEASSE,'VEASSE','CNFEPI')
        CNFFPI       = CNFEPI 
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ......... FORC. PILOTEES' 
          WRITE (IFM,*) '<MECANONLINE> .........  ',1,' - COEF: ',
     &                 1.D0
          CALL NMDEBG('VECT',CNFFPI,IFM)
        ENDIF           
      ENDIF         
C
      CALL JEDEMA()
      END
