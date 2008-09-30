      SUBROUTINE NMASVA(PHASE ,FONACT,SDDYNA,DEFICO,VEASSE,
     &                  CNVADO)
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
C
      IMPLICIT NONE
      CHARACTER*4  PHASE
      LOGICAL      FONACT(*)
      CHARACTER*24 DEFICO
      CHARACTER*19 CNVADO
      CHARACTER*19 VEASSE(*)
      CHARACTER*19 SDDYNA
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES AU COURS DU TEMPS
C      
C ----------------------------------------------------------------------
C
C
C IN  PHASE  : 'PRED' OU 'CORR'
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  SDDYNA : SD DYNAMIQUE 
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE  
C OUT CNVADO : VECT_ASSE DE TOUS LES CHARGEMENTS VARIABLES DONNES
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
      INTEGER      IFDO,N
      CHARACTER*19 CNVARI(20)
      REAL*8       COVARI(20)
      REAL*8       COEEQU,COEEXT,COEEX2,COEINT
      REAL*8       NDYNRE
      CHARACTER*19 CNFSDO,CNDYNA,CNMODA,CNIMPE
      CHARACTER*19 NMCHEX,NDYNKK
      CHARACTER*19 CNFINT
      LOGICAL      NDYNLO,LDYNA,LIMPE,LAMMO,LMPAS
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL CHARGEMENT VARIABLE' 
      ENDIF
C
C --- FONCTIONNALITES ACTIVEES
C     
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LIMPE  = NDYNLO(SDDYNA,'IMPE_ABSO')
      LAMMO  = NDYNLO(SDDYNA,'AMOR_MODAL')
      LMPAS  = NDYNLO(SDDYNA,'MULTI_PAS')
C
C --- INITIALISATIONS
C
      IFDO   = 0    
      CALL VTZERO(CNVADO)
C
C --- COEFFICIENTS POUR MULTI-PAS
C 
      IF (LDYNA) THEN  
        COEEQU = NDYNRE(SDDYNA,'COEF_MPAS_EQUI_COUR')
        COEEXT = NDYNRE(SDDYNA,'COEF_MPAS_FEXT_PREC')   
        COEEX2 = NDYNRE(SDDYNA,'COEF_MPAS_FEXT_COUR')
        COEINT = NDYNRE(SDDYNA,'COEF_MPAS_FINT_PREC')           
      ELSE
        COEEXT = 1.D0
        COEEQU = 1.D0 
        COEEX2 = 1.D0         
        COEINT = 1.D0      
      ENDIF                
C
C --- CALCUL DES FORCES EXTERIEURES VARIABLES
C
      CNFSDO       = NMCHEX(VEASSE,'VEASSE','CNFSDO') 
      IFDO         = IFDO+1 
      CNVARI(IFDO) = CNFSDO
      COVARI(IFDO) = COEEX2 
C
C --- AJOUT FORCES SUIVEUSES PAS PRECEDENT
C      
      IF (LMPAS) THEN
        CNFSDO = NDYNKK(SDDYNA,'CNFSDO')
        IFDO         = IFDO+1 
        CNVARI(IFDO) = CNFSDO
        COVARI(IFDO) = COEEXT        
      ENDIF        
C
C --- CALCUL DES FORCES DYNAMIQUES      
C      
      IF (LDYNA) THEN 
        CNDYNA       = NMCHEX(VEASSE,'VEASSE','CNDYNA')
        IFDO         = IFDO+1 
        CNVARI(IFDO) = CNDYNA
        COVARI(IFDO) = -1.D0*COEEQU
        IF (LAMMO) THEN
          IF (PHASE.EQ.'PRED') THEN
            CNMODA = NMCHEX(VEASSE,'VEASSE','CNMODP')
          ELSEIF (PHASE.EQ.'CORR') THEN  
            CNMODA = NMCHEX(VEASSE,'VEASSE','CNMODC')
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
          IFDO         = IFDO+1 
          CNVARI(IFDO) = CNMODA
          COVARI(IFDO) = -1.D0*COEEQU
        ENDIF 
        IF (LIMPE) THEN
          IF (PHASE.EQ.'PRED') THEN
            CNIMPE = NMCHEX(VEASSE,'VEASSE','CNIMPP')
          ELSEIF (PHASE.EQ.'CORR') THEN  
            CNIMPE = NMCHEX(VEASSE,'VEASSE','CNIMPC')
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF        
          IFDO         = IFDO+1 
          CNVARI(IFDO) = CNIMPE
          COVARI(IFDO) = -1.D0*COEEQU
        ENDIF     
      ENDIF  
C
C --- AJOUT FORCES INTERNES PAS PRECEDENT
C      
      IF (LMPAS) THEN
        CNFINT = NDYNKK(SDDYNA,'CNFINT')
        IFDO         = IFDO+1 
        CNVARI(IFDO) = CNFINT
        COVARI(IFDO) = -1.D0*COEINT        
      ENDIF  
C        
C --- VECTEUR RESULTANT CHARGEMENT DONNE
C       
      DO 10 N = 1,IFDO
        CALL VTAXPY(COVARI(N),CNVARI(N),CNVADO)
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ......... FORC. VARIABLE' 
          WRITE (IFM,*) '<MECANONLINE> .........  ',N,' - COEF: ',
     &                   COVARI(N)
          CALL NMDEBG('VECT',CNVARI(N),IFM)
        ENDIF           
 10   CONTINUE       
C
      CALL JEDEMA()
      END
