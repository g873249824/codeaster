      SUBROUTINE XMMCO1(NDIM ,NNO,DSIDEP,PP  ,P  ,
     &                  ND   ,NFH,DDLS  ,JAC ,FFP,
     &                  SINGU,RR ,TAU1  ,TAU2,MMAT)  

      IMPLICIT NONE
      INTEGER     NDIM,NNO,NFH,DDLS,SINGU
      REAL*8      MMAT(204,204),DSIDEP(6,6)
      REAL*8      FFP(27),JAC,ND(3)
      REAL*8      PP(3,3),P(3,3),RR

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/02/2011   AUTEUR MASSIN P.MASSIN 
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

C TOLE CRP_21
C
C ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
C
C --- CALCUL DES MATRICES DE COHESION 
C      
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
C IN  DSIDEP : 
C IN  PP     : 
C IN  P      : 
C IN  ND     : DIRECTION NORMALE
C IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
C IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
C IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
C IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
C IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
C IN  RR     : DISTANCE AU FOND DE FISSURE
C IN  TAU1   : PREMIERE DIRECTION TANGENTE
C IN  AM     : 
C I/O MMAT   : MATRICE ELEMENTAITRE DE CONTACT/FROTTEMENT 
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER I,J
      REAL*8  DDT1(3,3),DDT2(3,3),DDT3(3,3),DDT4(3,3)
      REAL*8  TAU1(3),TAU2(3)
C
C ----------------------------------------------------------------------

C     INITIALISATION
      CALL MATINI(3,3,0.D0,DDT1)
      CALL MATINI(3,3,0.D0,DDT2)
      CALL MATINI(3,3,0.D0,DDT3)
      CALL MATINI(3,3,0.D0,DDT4)

C           II.2.3. CALCUL DES MATRICES DE COHESION 
C        ..............................
                  
        DO 216 I = 1,NDIM
          DO 217 J = 1,NDIM
            DDT1(I,J)=DSIDEP(1,1)*ND(I)*ND(J)
            IF(NDIM.EQ.2) THEN
               DDT2(I,J)=DSIDEP(1,2)*ND(I)*TAU1(J)
     &          +DSIDEP(2,1)*TAU1(I)*ND(J)
            ELSE IF(NDIM.EQ.3) THEN
               DDT2(I,J)=DSIDEP(1,2)*ND(I)*TAU1(J)
     &                  +DSIDEP(1,3)*ND(I)*TAU2(J)
     &                  +DSIDEP(2,1)*TAU1(I)*ND(J)
     &                  +DSIDEP(3,1)*TAU2(I)*ND(J)               
            ENDIF     
               DDT3(I,J)=DDT2(I,J)
            IF(NDIM.EQ.2) THEN
               DDT4(I,J)=DSIDEP(2,2)*TAU1(I)*TAU1(J)
            ELSE IF(NDIM.EQ.3) THEN
               DDT4(I,J)=DSIDEP(2,2)*TAU1(I)*TAU1(J)
     &                  +DSIDEP(2,3)*TAU1(I)*TAU2(J)
     &                  +DSIDEP(3,2)*TAU2(I)*TAU1(J)
     &                  +DSIDEP(3,3)*TAU2(I)*TAU2(J)          
            ENDIF          
 217      CONTINUE
 216    CONTINUE

       CALL MATCOX(NDIM,PP,DDT1,DDT2,DDT3,DDT4,P,
     &             NNO,NFH*NDIM,DDLS,JAC,FFP,SINGU,RR,
     &             MMAT)  
C 
      END
