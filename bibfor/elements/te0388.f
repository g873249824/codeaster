      SUBROUTINE TE0388(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16       NOMTE,OPTION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/03/2003   AUTEUR VABHHTS J.PELLET 
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
C.......................................................................
C
C     BUT: CALCUL DES MATRICES ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU TERME D'ECHANGE ENTRE 2 PAROIS (FACE)
C          D'ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'MTAN_THER_PARO_R'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER            NDIM,NNO,NDI,IPG,NPG1,IMATTT,IHECHP
      INTEGER            IDEC,JDEC,KDEC,LDEC,NBPG(10),NBELR
      REAL*8             NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC,THETA,H
      REAL*8             MAT(45)
      CHARACTER*8        ELREFE,LIREFE(2)
      CHARACTER*24       CHVAL,CHCTE
C     ------------------------------------------------------------------
C
      CALL ELREF2(NOMTE,2,LIREFE,NBELR)
      CALL ASSERT(NBELR.EQ.2)
      ELREFE = LIREFE(2)

      CHCTE = '&INEL.'//ELREFE//'.CARACTE'
      CALL JEVETE(CHCTE,' ',JIN)
      NDIM = ZI(JIN+1-1)
      NNO = ZI(JIN+2-1)
      NBFPG = ZI(JIN+3-1)
      NDI = NNO*(NNO+1)/2
      DO 111 I = 1,NBFPG
         NBPG(I) = ZI(JIN+3-1+I)
  111 CONTINUE
      NPG1 = NBPG(1)
C
      CHVAL = '&INEL.'//ELREFE//'.FFORMES'
      CALL JEVETE(CHVAL,' ',JVAL)
C
      IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      IVF    = IPOIDS + NPG1
      IDFDX  = IVF    + NPG1 * NNO
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PHECHPR','L',IHECHP)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      THETA = ZR(ITEMPS+2)
C
      DO 10 I = 1,NDI
         MAT(I) = 0.0D0
10    CONTINUE
C
C    CALCUL DES PRODUITS VECTORIELS OMI * OMJ
C
      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
        DO 2 JNO = 1,NNO
          J = IGEOM + 3*(JNO-1) -1
          SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
          SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
          SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
2       CONTINUE
1     CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 IPG=1,NPG1
        KDEC = (IPG-1)*NNO*NDIM
        LDEC = (IPG-1)*NNO
        H = ZR(IHECHP+IPG-1)
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
        DO 103 I=1,NNO
CCDIR$ IVDEP
          DO 104 J=1,I
            IJ = (I-1)*I/2 + J
            MAT(IJ) = MAT(IJ) + JAC * THETA *
     &      ZR(IPOIDS+IPG-1) * H * ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1)
C
104       CONTINUE
103     CONTINUE
C
101   CONTINUE
C
C --- CALCUL LA MATRICE SUR LA MAILLE DE COUPLAGE
C            ! MAT -MAT!
C     MATTT =!      MAT!
      K1 = 0
      K2= NNO*(NNO+1)/2
      DO 200 I = 1,NNO
        K3 = K2 + NNO
CCDIR$ IVDEP
        DO 201 J = 1,I
          K1=K1+1
          K2=K2+1
          K3=K3+1
          ZR(IMATTT-1+K1) =  MAT(K1)
          ZR(IMATTT-1+K2) = -MAT(K1)
          ZR(IMATTT-1+K3) =  MAT(K1)
201     CONTINUE
        DO 202 J=I+1,NNO
          K2=K2+1
          K4=I+J*(J-1)/2
          ZR(IMATTT-1+K2) = -MAT(K4)
202     CONTINUE
        K2 = K3
200   CONTINUE
      END
