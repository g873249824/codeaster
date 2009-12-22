      SUBROUTINE NMACVA(VEASSE,CNVADO)
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
      CHARACTER*19 CNVADO
      CHARACTER*19 VEASSE(*)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES POUR L'ACCELERATION 
C INITIALE
C      
C ----------------------------------------------------------------------
C
C
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
      CHARACTER*19 CNFSDO
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
C --- INITIALISATIONS
C
      IFDO   = 0    
      CALL VTZERO(CNVADO)              
C
C --- CALCUL DES FORCES EXTERIEURES VARIABLES
C
      CALL NMCHEX(VEASSE,'VEASSE','CNFSDO',CNFSDO) 
      IFDO         = IFDO+1 
      CNVARI(IFDO) = CNFSDO
      COVARI(IFDO) = 1.D0          
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
