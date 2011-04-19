      SUBROUTINE NMFOGV(NDIM,NNO1,NNO2,NNO3,NPG,IW,VFF1,VFF2,VFF3,
     &  IDFDE1,IDFDE2,GEOM,TYPMOD,MAT,DDL,SIGM,VECT)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
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

       IMPLICIT NONE

       CHARACTER*8   TYPMOD(*)

       INTEGER NDIM,NNO1,NNO2,NNO3,NPG,IDFDE1,IDFDE2,IW,MAT
       REAL*8  VFF1(NNO1,NPG),VFF2(NNO2,NPG),VFF3(NNO3,NPG)
       REAL*8  GEOM(NDIM,NNO1)
       REAL*8  SIGM(2*NDIM+1,NPG),DDL(*),VECT(*)
C ----------------------------------------------------------------------
C
C     FORC_NODA POUR GRAD_VARI (2D ET 3D)
C
C IN  NDIM    : DIMENSION DES ELEMENTS 
C IN  NNO1    : NOMBRE DE NOEUDS (FAMILLE U)
C IN  VFF1    : VALEUR DES FONCTIONS DE FORME (FAMILLE U)
C IN  IDFDE1  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE U)
C IN  NNO2    : NOMBRE DE NOEUDS (FAMILLE E)
C IN  VFF2    : VALEUR DES FONCTIONS DE FORME (FAMILLE E)
C IN  IDFDE2  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE E)
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : POIDS DES POINTS DE GAUSS DE REFERENCE (INDICE)
C IN  GEOM    : COORDONNEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODEELISATION
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C OUT VECT    : FORCES INTERIEURES    (RAPH_MECA   ET FULL_MECA_*)
C MEM DFDI2   :
C ----------------------------------------------------------------------
      
      INTEGER K2(2)
      CHARACTER*8 NOM(2)
      
      LOGICAL GRAND,AXI,NAX
      INTEGER NDDL,NDIMSI,G,N,I,KL,KK
      INTEGER IU(3,27),IA(8),IL(8)
      REAL*8  RAC2,C,RAUG,VAL(2)
      REAL*8  DFDI1(27,3)
      REAL*8  AV,MU,AG(3),BP
      REAL*8  R,WG,B(6,3,27)
      REAL*8  SIGMA(6),T1,T2,T3

      REAL*8  DFDI2(8*3)

      DATA  NOM /'C_GRAD_V','PENA_LAG'/
C ----------------------------------------------------------------------



C - INITIALISATION

      RAC2   = SQRT(2.D0)
      GRAND  = .FALSE.
      AXI    = TYPMOD(1) .EQ. 'AXIS'
      NDDL   = NNO1*NDIM + NNO2*2
      NDIMSI = 2*NDIM

      CALL R8INIR(NDDL,0.D0,VECT,1)

      CALL RCVALA(MAT,' ','NON_LOCAL',0,' ',0.D0,2,NOM,VAL,K2,2)
      C    = VAL(1)
      RAUG = VAL(2)
      

      CALL NMGVDD(NDIM,NNO1,NNO2,IU,IA,IL)


C - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 1000 G=1,NPG

C      CALCUL DES ELEMENTS GEOMETRIQUES DE L'EF POUR U

        CALL DFDMIP(NDIM,NNO1,AXI,GEOM,G,IW,VFF1(1,G),IDFDE1,R,WG,DFDI1)
        NAX=.FALSE.
        CALL NMMABU(NDIM,NNO1,NAX,GRAND,DFDI1,B)
        IF (AXI) THEN
          DO 50 N=1,NNO1
            B(3,1,N) = VFF1(N,G)/R
 50       CONTINUE
        ENDIF

C      CALCUL DES ELEMENTS GEOMETRIQUES DE L'EF POUR A ET L

        CALL DFDMIP(NDIM,NNO2,AXI,GEOM,G,IW,VFF2(1,G),IDFDE2,R,WG,DFDI2)

        AV = 0
        MU = 0
        DO 150 N = 1,NNO2
          AV = AV + VFF2(N,G)*DDL(IA(N))
          MU = MU + VFF3(N,G)*DDL(IL(N))
 150    CONTINUE
 
    
        DO 200 I = 1,NDIM
          AG(I) = 0
          DO 202 N = 1,NNO2
            AG(I) = AG(I) + DFDI2(NNO2*(I-1)+N)*DDL(IA(N))
 202      CONTINUE
 200    CONTINUE  

        DO 210 KL = 1,3
          SIGMA(KL) = SIGM(KL,G)
 210    CONTINUE
        DO 220 KL = 4,NDIMSI
          SIGMA(KL) = SIGM(KL,G)*RAC2
 220    CONTINUE          
        BP = SIGM(NDIMSI+1,G)
        
        
C      VECTEUR FINT:U
        DO 300 N=1,NNO1
          DO 310 I=1,NDIM
            KK = IU(I,N)
            T1 = 0
            DO 320 KL = 1,NDIMSI
              T1 = T1 + SIGMA(KL)*B(KL,I,N)
 320        CONTINUE
            VECT(KK) = VECT(KK) + WG*T1
 310      CONTINUE
 300    CONTINUE

C      VECTEUR FINT:A 
        DO 350 N=1,NNO2
          T1 = VFF2(N,G)*RAUG*(AV-BP)
          T2 = VFF2(N,G)*MU
          T3 = 0
          DO 370 I = 1,NDIM
            T3 = T3 + C*DFDI2(NNO2*(I-1)+N)*AG(I)
 370      CONTINUE
          KK = IA(N)
          VECT(KK) = VECT(KK) + WG*(T3+T2+T1)
 350    CONTINUE

C      VECTEUR FINT:L
        DO 400 N=1,NNO3
          T1 = VFF3(N,G)*(AV-BP)
          KK = IL(N)
          VECT(KK) = VECT(KK) + WG*T1
 400    CONTINUE

 1000 CONTINUE


      END
