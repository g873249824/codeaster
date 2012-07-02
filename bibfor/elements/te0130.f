      SUBROUTINE TE0130(OPTION,NOMTE)
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
C.......................................................................
      IMPLICIT NONE
C
C     BUT: CALCUL DES MATRICES TANGENTES ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU TERME D'ECHANGE
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'MTAN_THER_COEF_R'
C          OPTION : 'MTAN_THER_RAYO_R'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      INCLUDE 'jeveux.h'
      CHARACTER*16       NOMTE,OPTION
      REAL*8             NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC,THETA
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER            NDIM,NNO,NDI,IPG,NPG2,IMATTT,IECH,IRAY
      INTEGER            ITEMP,IDEC,JDEC,KDEC,LDEC,NNOS
      REAL*8             HECH,SIGMA,EPSIL,TPG,TZ0,R8T0
C
C-----------------------------------------------------------------------
      INTEGER I ,IJ ,INO ,ITEMPS ,J ,JGANO ,JNO 

C-----------------------------------------------------------------------
      TZ0  = R8T0()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG2,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
      NDI = NNO*(NNO+1)/2
C
      IF     (OPTION(11:14).EQ.'COEF') THEN
         CALL JEVECH('PCOEFHR','L',IECH)
         HECH  = ZR(IECH)
      ELSEIF (OPTION(11:14).EQ.'RAYO') THEN
         CALL JEVECH('PRAYONR','L',IRAY)
         CALL JEVECH('PTEMPEI','L',ITEMP)
         SIGMA = ZR(IRAY)
         EPSIL = ZR(IRAY+1)
      ENDIF
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      THETA = ZR(ITEMPS+2)
C
      DO 10 I = 1,NDI
         ZR(IMATTT+I-1) = 0.0D0
10    CONTINUE
C
C    CALCUL DES PRODUITS VECTORIELS OMI X OMJ
C
      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
          DO 2 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
              SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
              SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
              SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
2         CONTINUE
1     CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 IPG=1,NPG2
        KDEC = (IPG-1)*NNO*NDIM
        LDEC = (IPG-1)*NNO
C
        NX = 0.0D0
        NY = 0.0D0
        NZ = 0.0D0
C
C   CALCUL DE LA NORMALE AU POINT DE GAUSS IPG
C
        DO 102 I=1,NNO
        IDEC = (I-1)*NDIM
          DO 102 J=1,NNO
          JDEC = (J-1)*NDIM
C
          NX = NX + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
          NY = NY + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
          NZ = NZ + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
C
102     CONTINUE
C
C   CALCUL DU JACOBIEN AU POINT DE GAUSS IPG
C
        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
C
        IF     (OPTION(11:14).EQ.'COEF') THEN
          DO 103 I=1,NNO
CCDIR$ IVDEP
            DO 104 J=1,I
            IJ = (I-1)*I/2 + J
C
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) + JAC * THETA *
     &      ZR(IPOIDS+IPG-1) * HECH *
     &      ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1)
C
104         CONTINUE
103       CONTINUE
        ELSEIF (OPTION(11:14).EQ.'RAYO') THEN
          TPG = 0.D0
          DO 105 I=1,NNO
            TPG = TPG + ZR(ITEMP+I-1) * ZR(IVF+LDEC+I-1)
105       CONTINUE
          DO 106 I=1,NNO
CCDIR$ IVDEP
            DO 107 J=1,I
            IJ = (I-1)*I/2 + J
C
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) + JAC * THETA *
     &      ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1) *
     &      ZR(IPOIDS+IPG-1) * 4.D0 * SIGMA * EPSIL * (TPG+TZ0)**3
C
107         CONTINUE
106       CONTINUE
        ENDIF
C
101     CONTINUE
      END
