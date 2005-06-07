      SUBROUTINE XMAFR2(NLI,NLJ,TAU1,TAU2,B,ABC)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/01/2005   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      REAL*8     TAU1(3,6),TAU2(3,6),B(3,3),ABC(2,2)
      INTEGER    NLI,NLJ

C ----------------------------------------------------------------------
C                      
C                CALCUL DES MATRICES DE FROTTEMENT UTILES

C IN    NLI,NLJ     : NUM�RO DES POINTS D'INTERSECTION O� ON VEUT TAU
C IN    TAU1,TAU2   : VECTEURS DU PLAN TANGENT DE LA BASE COVARIANTE
C                     AUX POINTS D'INTERSECTION
C IN    B           : MATRICE (Id-KN)

C OUT   ABC         : PRODUIT MATRICE TAU(NLI).(Id-KN).TAU(NLJ)

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL,EXIGEO
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)


C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER    NDIM,I,J,K
      REAL*8     A(2,3),BC(3,2),C(3,2)

C  CALCUL DE A.B.C AVEC A=(TAU1) EN NLI ET C=(TAU1 TAU2) EN NLJ
C                         (TAU2)    

C     MATRICES A ET C
      DO 10 J=1,3
        A(1,J)=TAU1(J,NLI)
        A(2,J)=TAU2(J,NLI)
        C(J,1)=TAU1(J,NLJ)
        C(J,2)=TAU2(J,NLJ)
 10   CONTINUE
 
C     PRODUIT B.C
      DO 20 I=1,3
        DO 21 J=1,2
          BC(I,J)=0.D0
          DO 22 K=1,3
            BC(I,J)=BC(I,J)+B(I,K)*C(K,J)
 22       CONTINUE
 21     CONTINUE 
 20   CONTINUE 
 
C     PRODUIT A.BC
      DO 30 I=1,2
        DO 31 J=1,2
          ABC(I,J)=0.D0
          DO 32 K=1,3
            ABC(I,J)=ABC(I,J)+A(I,K)*BC(K,J)
 32       CONTINUE
 31     CONTINUE 
 30   CONTINUE 
  
      END
