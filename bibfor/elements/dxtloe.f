      SUBROUTINE DXTLOE(FLEX,MEMB,MEFL,CTOR,COUPMF,DEPL,ENER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'
      LOGICAL COUPMF
      REAL*8 FLEX(*),MEMB(*),MEFL(*),CTOR
      REAL*8 DEPL(*),ENER(*)
C-----------------------------------------------------
C     CALCUL DE L'ENERGIE DE DEFORMATION OU CINETIQUE
C            SUR UNE MAILLE QUADRANGLE
C     IN  FLEX   : MATRICE DE FLEXION CARREE
C     IN  MEMB   : MATRICE DE MEMBRANE CARREE
C     IN  MEFL   : MATRICE MEMBRANE - FLEXION CARREE
C     IN  CTOR   : COEFF DE TORSION
C     IN  DEPL   : DEPLACEMENT DANS LE REPERE LOCAL
C     OUT ENER   : 3 TERMES POUR ENER_POT (EPOT_ELEM) OU
C                           POUR ENER_CIN (ECIN_ELEM)
C-----------------------
      INTEGER IF(45),JF(45)
      INTEGER IM(21),JM(21)
      INTEGER IFM(36),JFM(36)
      INTEGER IMF(18),JMF(18)
      INTEGER JZ(3)
      INTEGER KM(6),KF(9)
      REAL*8 COEF
      REAL*8 CF(45),CFM(36),CMF(18)
      REAL*8 DEPLM(6),DEPLF(9)
      REAL*8 MATLOC(171),MATF(45),MATM(21)
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,K 
C-----------------------------------------------------------------------
      DATA CF/1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,1.D0,
     +     2*-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,
     +     2*1.D0,-1.D0,1.D0,2*-1.D0,1.D0,2*-1.D0,2*1.D0,-1.D0,2*1.D0,
     +     -1.D0,2*1.D0,-1.D0,1.D0/
      DATA CFM/2*1.D0,2*-1.D0,2*1.D0,2*1.D0,2*-1.D0,2*1.D0,2*1.D0,
     +     2*-1.D0,2*1.D0,2*1.D0,2*-1.D0,2*1.D0,2*1.D0,2*-1.D0,2*1.D0,
     +     2*1.D0,2*-1.D0,2*1.D0/
      DATA CMF/1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,-1.D0,2*1.D0,
     +     -1.D0,2*1.D0,-1.D0,1.D0/
C     ------------------------------------------------------------------
      DATA JF/6,9,10,13,14,15,39,40,41,45,48,49,50,54,55,58,59,60,64,65,
     +     66,108,109,110,114,115,116,120,123,124,125,129,130,131,135,
     +     136,139,140,141,145,146,147,151,152,153/
      DATA IF/1,19,21,10,12,11,28,30,29,31,46,48,47,49,51,37,39,38,40,
     +     42,41,55,57,56,58,60,59,61,73,75,74,76,78,77,79,81,64,66,65,
     +     67,69,68,70,72,71/
C     ------------------------------------------------------------------
      DATA JM/1,2,3,22,23,28,29,30,35,36,79,80,85,86,91,92,93,98,99,104,
     +     105/
      DATA IM/1,7,8,13,14,15,19,20,21,22,25,26,27,28,29,31,32,33,34,35,
     +     36/
C     ------------------------------------------------------------------
      DATA JFM/4,5,7,8,11,12,37,38,46,47,56,57,43,44,52,53,62,63,106,
     +     107,121,122,137,138,112,113,127,128,143,144,118,119,133,134,
     +     149,150/
      DATA IFM/1,2,13,14,7,8,19,20,31,32,25,26,21,22,33,34,27,28,37,38,
     +     49,50,43,44,39,40,51,52,45,46,41,42,53,54,47,48/
C     ------------------------------------------------------------------
      DATA JMF/24,25,26,31,32,33,81,82,83,94,95,96,87,88,89,100,101,102/
      DATA IMF/3,15,9,4,16,10,5,17,11,6,18,12,23,35,29,24,36,30/
C     ------------------------------------------------------------------
      DATA JZ/21,78,171/
C     ------------------------------------------------------------------
      DATA KM/1,2,7,8,13,14/
      DATA KF/3,4,5,9,10,11,15,16,17/
C     ------------------------------------------------------------------
C                          ---- RAZ MATLOC
      DO 10 I = 1,171
        MATLOC(I) = 0.D0
   10 CONTINUE
C                          ---- TERMES DE FLEXION
      DO 20 K = 1,45
        MATLOC(JF(K)) = CF(K)*FLEX(IF(K))
        MATF(K) = MATLOC(JF(K))
   20 CONTINUE
C                          ---- TERMES DE MEMBRANE
      DO 30 K = 1,21
        MATLOC(JM(K)) = MEMB(IM(K))
        MATM(K) = MATLOC(JM(K))
   30 CONTINUE
C                          ---- TERMES DE COUPLAGE FLEXION/MEMBRANE
      DO 40 K = 1,36
        MATLOC(JFM(K)) = CFM(K)*MEFL(IFM(K))
   40 CONTINUE
C                          ---- TERMES DE COUPLAGE MEMBRANE/FLEXION
      DO 50 K = 1,18
        MATLOC(JMF(K)) = CMF(K)*MEFL(IMF(K))
   50 CONTINUE
C                          ---- TERMES DE ROTATION / Z
      COEF = CTOR*MIN(FLEX(11),FLEX(21),FLEX(41),FLEX(51),FLEX(71),
     +       FLEX(81))
      MATLOC(JZ(1)) = COEF
      MATLOC(JZ(2)) = COEF
      MATLOC(JZ(3)) = COEF
C     ------------------------------------------------------------------
      CALL UTVTSV('ZERO',18,MATLOC,DEPL,ENER(1))
      IF (COUPMF) THEN
        ENER(2) = 0.D0
        ENER(3) = 0.D0
      ELSE
C        --------- ENER EN MEMBRANE ----------
        DO 60 K = 1,6
          DEPLM(K) = DEPL(KM(K))
   60   CONTINUE
        CALL UTVTSV('ZERO',6,MATM,DEPLM,ENER(2))
C        --------- ENER EN FLEXION ----------
        DO 70 K = 1,9
          DEPLF(K) = DEPL(KF(K))
   70   CONTINUE
        CALL UTVTSV('ZERO',9,MATF,DEPLF,ENER(3))
      END IF
      ENER(1) = 0.5D0*ENER(1)
      IF (ABS(ENER(1)).GT.1.D-6) THEN
        ENER(2) = 0.5D0*ENER(2)/ENER(1)
        ENER(3) = 0.5D0*ENER(3)/ENER(1)
      ELSE
        ENER(2) = 0.D0
        ENER(3) = 0.D0
      END IF
      END
