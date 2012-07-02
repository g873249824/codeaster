      SUBROUTINE TE0325(OPTION,NOMTE)
      IMPLICIT NONE

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
C
C     BUT: CALCUL DES VECTEURS ELEMENTAIRES DE FLUX FLUIDE EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 2D
C
C          OPTION : 'CHAR_THER_ACCE_R 'OU 'CHAR_THER_ACCE_X'
C                    OU 'CHAR_THER_ACCE_Y'OU 'CHAR_THER_ACCE_Z'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      INCLUDE 'jeveux.h'
      INTEGER            ICODRE(1),KPG,SPT
      CHARACTER*8        FAMI,POUM
      CHARACTER*16       NOMTE,OPTION
      REAL*8             JAC,NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9)
      REAL*8             NORM(3)
      REAL*8             ACLOC(3,9),ACC(3,9),FLUFN(9)
      INTEGER            IPOIDS,IVF,IDFDX,IDFDY,IGEOM
      INTEGER            NDIM,NNO,IPG,NPG1,IVECTT,IMATE
      INTEGER            IDEC,JDEC,KDEC,LDEC,NNOS,JGANO
C
C
C-----------------------------------------------------------------------
      INTEGER I ,IACCE ,IDIM ,INO ,ITEMP ,J ,JNO
      INTEGER K ,MATER
      REAL*8 R8B ,RHO
C-----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PVECTTR','E',IVECTT)
C
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      MATER = ZI(IMATE)
      CALL RCVALB(FAMI,KPG,SPT,POUM,MATER,' ','THER',0,' ',
     &            R8B,1,'RHO_CP',RHO,ICODRE,1)

      IF (OPTION(16:16).EQ.'R') THEN
         CALL JEVECH('PACCELR','L',IACCE)
      ELSEIF ( OPTION(16:16).EQ.'X' .OR. OPTION(16:16).EQ.'Y' .OR.
     &         OPTION(16:16).EQ.'Z' ) THEN
         CALL JEVECH('PTEMPER','L',ITEMP)
      ENDIF

C ON RECUPERE LE CHAMNO DE DEPL (MODAL)

      K = 0
      DO 10 I=1,NNO
         IF ( OPTION(16:16) .EQ. 'R' ) THEN
            DO 20 IDIM=1,3
               K=K+1
               ACLOC(IDIM,I) = ZR(IACCE+K-1)
20          CONTINUE
         ELSEIF ( OPTION(16:16) .EQ. 'X') THEN
            K=K+1
            ACLOC(1,I) = ZR(ITEMP+K-1)
            ACLOC(2,I) = 0.D0
            ACLOC(3,I) = 0.D0
         ELSEIF (OPTION(16:16).EQ.'Y') THEN
            K=K+1
            ACLOC(1,I) = 0.D0
            ACLOC(2,I) = ZR(ITEMP+K-1)
            ACLOC(3,I) = 0.D0
         ELSEIF (OPTION(16:16).EQ.'Z') THEN
            K=K+1
            ACLOC(1,I) = 0.D0
            ACLOC(2,I) = 0.D0
            ACLOC(3,I) = ZR(ITEMP+K-1)
         ENDIF
10    CONTINUE
C
      DO 11 I = 1,NNO
         ZR(IVECTT+I-1) = 0.D0
11    CONTINUE
C
C     CALCUL DES PRODUITS VECTORIELS OMI X OMJ
C
      DO 21 INO = 1,NNO
         I = IGEOM + 3*(INO-1) -1
         DO 22 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
            SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
            SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
            SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
22       CONTINUE
21    CONTINUE
C
C     BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 IPG=1,NPG1
         KDEC=(IPG-1)*NNO*NDIM
         LDEC=(IPG-1)*NNO
C
         NX = 0.0D0
         NY = 0.0D0
         NZ = 0.0D0
C        --- ON CALCULE L ACCEL AU POINT DE GAUSS
         DO 102 I=1,NNO
            IDEC = (I-1)*NDIM
            DO 104 J=1,NNO
            JDEC = (J-1)*NDIM
C
          NX = NX + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SX(I,J)
          NY = NY + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SY(I,J)
          NZ = NZ + ZR(IDFDX+KDEC+IDEC) * ZR(IDFDY+KDEC+JDEC) * SZ(I,J)
C
104       CONTINUE
102      CONTINUE
C
        ACC(1,IPG)=0.0D0
        ACC(2,IPG)=0.0D0
        ACC(3,IPG)=0.0D0
        DO 105 I=1,NNO
           ACC(1,IPG) = ACC(1,IPG) + ACLOC(1,I)*ZR(IVF+LDEC+I-1)
           ACC(2,IPG) = ACC(2,IPG) + ACLOC(2,I)*ZR(IVF+LDEC+I-1)
           ACC(3,IPG) = ACC(3,IPG) + ACLOC(3,I)*ZR(IVF+LDEC+I-1)
105      CONTINUE
C
C        CALCUL DU JACOBIEN AU POINT DE GAUSS IPG
C
         JAC = SQRT (NX*NX + NY*NY + NZ*NZ)
          NORM(1) = NX/JAC
          NORM(2) = NY/JAC
          NORM(3) = NZ/JAC
          FLUFN(IPG) = 0.D0
C CALCUL DU FLUX FLUIDE NORMAL AU POINT DE GAUSS
          FLUFN(IPG) = ACC(1,IPG)*NORM(1) + ACC(2,IPG)*NORM(2)
     &                +ACC(3,IPG)*NORM(3)
C
        DO 103 I=1,NNO
           ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + JAC*ZR(IPOIDS+IPG-1)*
     &                            FLUFN(IPG) * RHO * ZR(IVF+LDEC+I-1)
103     CONTINUE
101   CONTINUE
C
      END
