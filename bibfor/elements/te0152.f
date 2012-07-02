      SUBROUTINE TE0152(OPTION,NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     CALCULE DES TERMES PROPRES A UN STRUCTURE
C     OPTION : 'MASS_INER'              (ELEMENTS FLUIDES 3D)
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER L ,LCASTR ,NBRES ,NDIM ,NNOS 
      REAL*8 R8BID ,RHO ,XXI ,YYI ,ZERO ,ZZI 
C-----------------------------------------------------------------------
      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES),FAMI,POUM

      INTEGER ICODRE(NBRES)
      REAL*8 VALRES(NBRES)
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS,VOLUME
      REAL*8 X(27),Y(27),Z(27),XG,YG,ZG,MATINE(6),R8PREM
      INTEGER IPOIDS,IVF,IDFDE,IGEOM
      INTEGER JGANO,NNO,KP,NPG,I,J,IMATE,KPG,SPT
C     ------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      ZERO = 0.D0
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      NOMRES(1) = 'RHO'
      NOMRES(2) = 'CELE_R'
      CALL RCVALB(FAMI,KPG,SPT,POUM,ZI(IMATE),' ','FLUIDE',0,' ',R8BID,
     &            2,NOMRES,VALRES,ICODRE,  1)
      RHO = VALRES(1)
      IF(RHO.LE.R8PREM()) THEN
        CALL U2MESS('F','ELEMENTS5_45')
      ENDIF

      DO 20 I = 1,NNO
        X(I) = ZR(IGEOM+3* (I-1))
        Y(I) = ZR(IGEOM+3*I-2)
        Z(I) = ZR(IGEOM+3*I-1)
   20 CONTINUE

      CALL JEVECH('PMASSINE','E',LCASTR)
      DO 30 I = 0,3
        ZR(LCASTR+I) = ZERO
   30 CONTINUE
      DO 40 I = 1,6
        MATINE(I) = ZERO
   40 CONTINUE

C     --- BOUCLE SUR LES POINTS DE GAUSS
      VOLUME = 0.D0
      DO 70 KP = 1,NPG
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

        VOLUME = VOLUME + POIDS
        DO 60 I = 1,NNO
C           --- CDG ---
          ZR(LCASTR+1) = ZR(LCASTR+1) + POIDS*X(I)*ZR(IVF+L+I-1)
          ZR(LCASTR+2) = ZR(LCASTR+2) + POIDS*Y(I)*ZR(IVF+L+I-1)
          ZR(LCASTR+3) = ZR(LCASTR+3) + POIDS*Z(I)*ZR(IVF+L+I-1)
C           --- INERTIE ---
          XXI = 0.D0
          YYI = 0.D0
          ZZI = 0.D0
          DO 50 J = 1,NNO
            XXI = XXI + X(I)*ZR(IVF+L+I-1)*X(J)*ZR(IVF+L+J-1)
            YYI = YYI + Y(I)*ZR(IVF+L+I-1)*Y(J)*ZR(IVF+L+J-1)
            ZZI = ZZI + Z(I)*ZR(IVF+L+I-1)*Z(J)*ZR(IVF+L+J-1)
            MATINE(2) = MATINE(2) + POIDS*X(I)*ZR(IVF+L+I-1)*Y(J)*
     &                  ZR(IVF+L+J-1)
            MATINE(4) = MATINE(4) + POIDS*X(I)*ZR(IVF+L+I-1)*Z(J)*
     &                  ZR(IVF+L+J-1)
            MATINE(5) = MATINE(5) + POIDS*Y(I)*ZR(IVF+L+I-1)*Z(J)*
     &                  ZR(IVF+L+J-1)
   50     CONTINUE
          MATINE(1) = MATINE(1) + POIDS* (YYI+ZZI)
          MATINE(3) = MATINE(3) + POIDS* (XXI+ZZI)
          MATINE(6) = MATINE(6) + POIDS* (XXI+YYI)
   60   CONTINUE
   70 CONTINUE

      XG = ZR(LCASTR+1)/VOLUME
      YG = ZR(LCASTR+2)/VOLUME
      ZG = ZR(LCASTR+3)/VOLUME
      ZR(LCASTR) = VOLUME*RHO
      ZR(LCASTR+1) = XG
      ZR(LCASTR+2) = YG
      ZR(LCASTR+3) = ZG

C     ---ON DONNE LES INERTIES EN G ---
      ZR(LCASTR+4) = MATINE(1)*RHO - ZR(LCASTR)* (YG*YG+ZG*ZG)
      ZR(LCASTR+5) = MATINE(3)*RHO - ZR(LCASTR)* (XG*XG+ZG*ZG)
      ZR(LCASTR+6) = MATINE(6)*RHO - ZR(LCASTR)* (XG*XG+YG*YG)
      ZR(LCASTR+7) = MATINE(2)*RHO - ZR(LCASTR)* (XG*YG)
      ZR(LCASTR+8) = MATINE(4)*RHO - ZR(LCASTR)* (XG*ZG)
      ZR(LCASTR+9) = MATINE(5)*RHO - ZR(LCASTR)* (YG*ZG)

      END
