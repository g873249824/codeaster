      SUBROUTINE TE0129 ( OPTION , NOMTE )
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
C                          OPTION : 'RESI_THER_FLUXNL'
C                          ELEMENTS DE FACE 3D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
      REAL*8             NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC
      REAL*8             THETA,TPG,ALPHA,RBID
      INTEGER            NDIM,NNO,NPG1,IPOIDS,IVF,IDFDX,IDFDY
      INTEGER            IGEOM,IFLUX,ITEMPI,ITEMPS,INO,JNO,IVERES
      INTEGER            NNOS,JGANO
      CHARACTER*8        COEF

      CALL JEMARQ()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PFLUXNL','L',IFLUX )
      CALL JEVECH('PRESIDU','E',IVERES)
C
      THETA  = ZR(ITEMPS+2)
      COEF   = ZK8(IFLUX)
      IF ( COEF(1:7) .EQ. '&FOZERO' ) GOTO 999
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
      DO 101 KP=1,NPG1
        KDEC = (KP-1)*NNO*NDIM
        LDEC = (KP-1)*NNO
        NX = 0.0D0
        NY = 0.0D0
        NZ = 0.0D0
C
C   CALCUL DE LA NORMALE AU POINT DE GAUSS KP
C
        DO 102 I=1,NNO
          IDEC = (I-1)*NDIM
          DO 102 J=1,NNO
            JDEC = (J-1)*NDIM
            NX = NX+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SX(I,J)
            NY = NY+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SY(I,J)
            NZ = NZ+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SZ(I,J)
 102    CONTINUE
C
C   CALCUL DU JACOBIEN AU POINT DE GAUSS KP
C
        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
C
        TPG  = 0.D0
        DO 103 I=1,NNO
          TPG  = TPG  + ZR(ITEMPI+I-1) * ZR(IVF+LDEC+I-1)
 103    CONTINUE
        CALL FODERI (COEF,TPG,ALPHA,RBID  )
C
C ----- ON RAJOUTE DANS LE RESIDU LE TERME (1-THETA)*ALPHAP QUI NE
C ----- FIGURE PAS DANS LE 2ND MEMBRE LINEAIRE
C
CCDIR$ IVDEP
        DO 104 I=1,NNO
          ZR(IVERES+I-1) = ZR(IVERES+I-1) - ZR(IPOIDS+KP-1)*JAC*
     &                THETA*ALPHA*ZR(IVF+LDEC+I-1)
 104    CONTINUE
 101  CONTINUE
 999  CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
