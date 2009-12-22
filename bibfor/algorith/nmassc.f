      SUBROUTINE NMASSC(FONACT,SDDYNA,ETA   ,VEASSE,CNPILO,
     &                  CNDONN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
      REAL*8       ETA
      CHARACTER*19 CNPILO,CNDONN
      INTEGER      FONACT(*)
      CHARACTER*19 SDDYNA
      CHARACTER*19 VEASSE(*)           
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CORRECTION)
C
C CALCUL DU SECOND MEMBRE POUR LA CORRECTION
C
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  ETA    : PARAMETRE DE PILOTAGE
C OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
C OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
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
      INTEGER      I,NBVEC
      CHARACTER*19 CNFFDO,CNDFDO,CNFVDO,CNVADY 
      CHARACTER*19 CNFFPI,CNDFPI         
      CHARACTER*19 CNDIRI,CNFINT
      REAL*8       COEF(8)
      CHARACTER*19 VECT(8)
      REAL*8       NDYNRE,COEEQU 
      LOGICAL      NDYNLO,LDYNA     
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
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL SECOND MEMBRE'
      ENDIF
C
C --- INITIALISATIONS
C
      CNFFDO = '&&CNCHAR.FFDO'
      CNFFPI = '&&CNCHAR.FFPI'
      CNDFDO = '&&CNCHAR.DFDO'
      CNDFPI = '&&CNCHAR.DFPI'
      CNFVDO = '&&CNCHAR.FVDO' 
      CNVADY = '&&CNCHAR.FVDY'         
      CALL NMCHEX(VEASSE,'VEASSE','CNDIRI',CNDIRI) 
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT) 
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')              
C
C --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (NEUMANN)      
C
      CALL NMASFI(FONACT,SDDYNA,VEASSE,CNFFDO,CNFFPI)
C
C --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (DIRICHLET)      
C
      CALL NMASDI(FONACT,VEASSE,CNDFDO,CNDFPI)  
C      
C --- CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES    (NEUMANN)     
C
      CALL NMASVA(SDDYNA,VEASSE,CNFVDO)
C      
C --- CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES DYNAMIQUES (NEUMANN)
C
      IF (LDYNA) THEN
        COEEQU = NDYNRE(SDDYNA,'COEF_MPAS_EQUI_COUR') 
        CALL NDASVA('CORR',SDDYNA,VEASSE,CNVADY)      
      ENDIF 
C
C --- CHARGEMENTS DONNES
C            
      NBVEC   = 5
      COEF(1) = 1.D0
      COEF(2) = 1.D0
      COEF(3) = -1.D0
      COEF(4) = -ETA
      COEF(5) = -1.D0      
      VECT(1) = CNFFDO
      VECT(2) = CNFVDO 
      VECT(3) = CNFINT
      VECT(4) = CNDFPI
      VECT(5) = CNDIRI   
      IF (LDYNA) THEN
        NBVEC = 6
        COEF(6) = COEEQU
        VECT(6) = CNVADY
      ENDIF
      
      IF (NBVEC.GT.8) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
      DO 10 I = 1,NBVEC
        CALL VTAXPY(COEF(I),VECT(I),CNDONN)      
 10   CONTINUE    
C
C --- CHARGEMENTS PILOTES
C      
      NBVEC   = 2
      COEF(1) = 1.D0
      COEF(2) = 1.D0        
      VECT(1) = CNFFPI
      VECT(2) = CNDFPI  
      IF (NBVEC.GT.8) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
      DO 15 I = 1,NBVEC
        CALL VTAXPY(COEF(I),VECT(I),CNPILO)      
 15   CONTINUE         
C     
      CALL JEDEMA()
      END
