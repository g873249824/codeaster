      SUBROUTINE TE0132 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2004   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES MATRICES TANGENTES ELEMENTAIRES
C                          OPTION : 'MTAN_THER_FLUXNL'
C                          ELEMENTS DE FACE 3D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
      CHARACTER*8        ELREFE
      REAL*8             NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC
      REAL*8             THETA,TPG,ALPHAP,RBID
      INTEGER        JIN,NDIM,NNO,NPG1,NPG2,JVAL,IPOIDS,IVF,IDFDX,IDFDY
      INTEGER            IGEOM,IFLUX,ITEMPI,ITEMPS,IMATTT,INO,JNO,IJ,LI
      INTEGER            NNOS,JGANO
C DEB ------------------------------------------------------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG2,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PFLUXNL','L',IFLUX)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      THETA  = ZR(ITEMPS+2)
C
C    CALCUL DES PRODUITS VECTORIELS OMI   OMJ
C
      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
        DO 2 JNO = 1,NNO
          J = IGEOM + 3*(JNO-1) -1
          SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
          SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
          SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
 2      CONTINUE
 1    CONTINUE
C
      DO 101 IPG=1,NPG2
        KDEC = (IPG-1)*NNO*NDIM
        LDEC = (IPG-1)*NNO
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
          NX = NX + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
          NY = NY + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
          NZ = NZ + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
 102    CONTINUE
C
C   CALCUL DU JACOBIEN AU POINT DE GAUSS IPG
C
        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
C
        TPG = 0.D0
        DO 103 I=1,NNO
          TPG = TPG + ZR(ITEMPI+I-1) * ZR(IVF+LDEC+I-1)
 103    CONTINUE
        CALL FODERI (ZK8(IFLUX),TPG,RBID,ALPHAP)
        DO 104 I=1,NNO
CCDIR$ IVDEP
          DO 104 J=1,I
            IJ = (I-1)*I/2 + J
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) - JAC* THETA*
     &      ZR(IPOIDS+IPG-1) * ALPHAP *
     &      ZR(IVF+LDEC+I-1) * ZR(IVF+LDEC+J-1)
 104    CONTINUE
 101  CONTINUE
C FIN ------------------------------------------------------------------
      END
