      SUBROUTINE EF213D(NPG, A, NNO, IVF, IDFDE, NNO1, VFF1, DFF1)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================

      IMPLICIT NONE
      INTEGER  A(8, 3), NNO1, NNO, IVF, IDFDE, NPG
      REAL*8   VFF1(NNO1, NPG), DFF1(3, NNO1, NPG)

C ----------------------------------------------------------------------
C    CALCUL DES FONCTIONS DE FORME P1 A PARTIR DES FONCTIONS P2  3D
C ----------------------------------------------------------------------
C IN  NPG    NOMBRE DE POINTS DE GAUSS
C IN  A      TABLEAU DE CORRESPONDANCE SOMMET -> NOEUDS MILIEUX
C IN  NNO    NOMBRE DE NOEUDS P2
C IN  VFF2   VALEUR  DES FONCTIONS DE FORME P2
C IN  DFF2   DERIVEE DES FONCTIONS DE FORME P2
C IN  NNO1   NOMBRE DE NOEUDS P1
C OUT VFF1   VALEUR  DES FONCTIONS DE FORME P1
C OUT DFF1   DERIVEE DES FONCTIONS DE FORME P1
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER    KP, K, N, N1, N2, N3


      DO 10 K = 1, NPG

        KP = 3*NNO*(K-1)

        DO 20 N = 1, NNO1

          N1 = A(N,1)
          N2 = A(N,2)
          N3 = A(N,3)

          VFF1(N,K)    = ZR(IVF-1+(K-1)*NNO+ N) 
     &                 + ZR(IVF-1+(K-1)*NNO+N1)/2.D0
     &                 + ZR(IVF-1+(K-1)*NNO+N2)/2.D0
     &                 + ZR(IVF-1+(K-1)*NNO+N3)/2.D0

          DFF1(1,N,K)  = ZR(IDFDE-1+KP+3*( N-1)+1)
     &                 + ZR(IDFDE-1+KP+3*(N1-1)+1)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N2-1)+1)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N3-1)+1)/2.D0

          DFF1(2,N,K)  = ZR(IDFDE-1+KP+3*( N-1)+2)
     &                 + ZR(IDFDE-1+KP+3*(N1-1)+2)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N2-1)+2)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N3-1)+2)/2.D0

          DFF1(3,N,K)  = ZR(IDFDE-1+KP+3*( N-1)+3)
     &                 + ZR(IDFDE-1+KP+3*(N1-1)+3)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N2-1)+3)/2.D0
     &                 + ZR(IDFDE-1+KP+3*(N3-1)+3)/2.D0


 20     CONTINUE
 10   CONTINUE

      END
