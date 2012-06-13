      SUBROUTINE TE0569 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16        OPTION , NOMTE
C
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM,I,J
      INTEGER            NDIM,NNO,IPG,NPG1,INO,JNO,IJ,KPG,SPT
      INTEGER            IDEC,JDEC,KDEC,LDEC,IMATE,IMATUU
      INTEGER            MATER,LL,K,L,NNOS,JGANO
      REAL*8             JAC,NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9)
      REAL*8             VALRES(3),E,NU,LAMBDA,MU,RHO
      REAL*8             RHOCP,RHOCS
      REAL*8             TAUX,TAUY,TAUZ
      REAL*8             NUX,NUY,NUZ,SCAL,VNX,VNY,VNZ
      REAL*8             VITUNI(3,3),VECT(9,3,27)
      REAL*8             MATR(27,27)
      REAL*8             VTX,VTY,VTZ,R8B
      INTEGER ICODRE(3)
      CHARACTER*8        NOMRES(3),FAMI,POUM
C     ------------------------------------------------------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH ( 'PGEOMER', 'L', IGEOM )
      CALL JEVECH ( 'PMATERC', 'L', IMATE )
      CALL JEVECH ( 'PMATUUR', 'E', IMATUU  )
C
      MATER=ZI(IMATE)
      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='RHO'
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      CALL RCVALB(FAMI,KPG,SPT,POUM,MATER,' ','ELAS',0,' ',R8B,3,
     &           NOMRES,VALRES,ICODRE,1)
      E = VALRES(1)
      NU = VALRES(2)
      RHO = VALRES(3)

      LAMBDA = E*NU/(1.D0+NU)/(1.D0-2.D0*NU)
      MU = E/2.D0/(1.D0+NU)

      RHOCP = SQRT((LAMBDA+2.D0*MU)*RHO)
      RHOCS = SQRT(MU*RHO)

C     VITESSE UNITAIRE DANS LES 3 DIRECTIONS

      VITUNI(1,1) = 1.D0
      VITUNI(1,2) = 0.D0
      VITUNI(1,3) = 0.D0

      VITUNI(2,1) = 0.D0
      VITUNI(2,2) = 1.D0
      VITUNI(2,3) = 0.D0

      VITUNI(3,1) = 0.D0
      VITUNI(3,2) = 0.D0
      VITUNI(3,3) = 1.D0

      DO 310 I = 1,NNO
        DO 310 J = 1,3
          DO 310 K = 1,3*NNO
            VECT(I,J,K) = 0.D0
310   CONTINUE
C
C     --- CALCUL DES PRODUITS VECTORIELS OMI X OMJ ---
C
      DO 30 INO = 1 , NNO
        I = IGEOM + 3*(INO-1) -1
        DO 30 JNO = 1,NNO
          J = IGEOM + 3*(JNO-1) -1
          SX(INO,JNO) = ZR(I+2)*ZR(J+3) - ZR(I+3)*ZR(J+2)
          SY(INO,JNO) = ZR(I+3)*ZR(J+1) - ZR(I+1)*ZR(J+3)
          SZ(INO,JNO) = ZR(I+1)*ZR(J+2) - ZR(I+2)*ZR(J+1)
 30       CONTINUE
C
C     --- BOUCLE SUR LES POINTS DE GAUSS ---
C
      DO 100 IPG = 1,NPG1
         KDEC = (IPG-1)*NNO*NDIM
         LDEC = (IPG-1)*NNO

         NX = 0.0D0
         NY = 0.0D0
         NZ = 0.0D0
C
C        --- CALCUL DE LA NORMALE AU POINT DE GAUSS IPG ---
C
         DO 102 I = 1,NNO
           IDEC = (I-1)*NDIM
           DO 102 J = 1,NNO
              JDEC = (J-1)*NDIM
           NX = NX + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
           NY = NY + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
           NZ = NZ + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
 102       CONTINUE
C
C        --- LE JACOBIEN EST EGAL A LA NORME DE LA NORMALE ---
C
         JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
C
C        --- CALCUL DE LA NORMALE UNITAIRE ---
C
          NUX = NX / JAC
          NUY = NY / JAC
          NUZ = NZ / JAC
C
C        --- CALCUL DE V.N ---
C
          DO 100 I = 1,NNO
            DO 100 J = 1,3
              SCAL = NUX*ZR(IVF+LDEC+I-1)*VITUNI(J,1)
              SCAL = SCAL+NUY*ZR(IVF+LDEC+I-1)*VITUNI(J,2)
              SCAL = SCAL+NUZ*ZR(IVF+LDEC+I-1)*VITUNI(J,3)
C
C        --- CALCUL DE LA VITESSE NORMALE ET DE LA VITESSE TANGENCIELLE
C
              VNX = NUX*SCAL
              VNY = NUY*SCAL
              VNZ = NUZ*SCAL

              VTX = ZR(IVF+LDEC+I-1)*VITUNI(J,1)
              VTY = ZR(IVF+LDEC+I-1)*VITUNI(J,2)
              VTZ = ZR(IVF+LDEC+I-1)*VITUNI(J,3)

              VTX = VTX - VNX
              VTY = VTY - VNY
              VTZ = VTZ - VNZ
C
C        --- CALCUL DU VECTEUR CONTRAINTE
C
              TAUX = RHOCP*VNX + RHOCS*VTX
              TAUY = RHOCP*VNY + RHOCS*VTY
              TAUZ = RHOCP*VNZ + RHOCS*VTZ
C
C        --- CALCUL DU VECTEUR ELEMENTAIRE
C
              DO 100 L = 1,NNO
                LL = 3*L-2
                VECT(I,J,LL) = VECT(I,J,LL) +
     &              TAUX*ZR(IVF+LDEC+L-1)*JAC*ZR(IPOIDS+IPG-1)
                VECT(I,J,LL+1) = VECT(I,J,LL+1) +
     &              TAUY*ZR(IVF+LDEC+L-1)*JAC*ZR(IPOIDS+IPG-1)
                VECT(I,J,LL+2) = VECT(I,J,LL+2) +
     &              TAUZ*ZR(IVF+LDEC+L-1)*JAC*ZR(IPOIDS+IPG-1)
100             CONTINUE

       DO 400 I = 1,NNO
         DO 400 J = 1,3
           DO 400 K = 1,3*NNO
             MATR(3*(I-1)+J,K) = VECT(I,J,K)
400    CONTINUE
C
C       --- PASSAGE AU STOCKAGE TRIANGULAIRE
C
       DO 210 I = 1,3*NNO
         DO 210 J =1,I
           IJ = (I-1)*I/2+J
           ZR(IMATUU+IJ-1) = MATR(I,J)
210        CONTINUE

       END
