      SUBROUTINE TE0285 ( OPTION , NOMTE )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16        OPTION , NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/04/2013   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DES OPTIONS: 'MASS_INER' ELEMENTS 2-D AXI D-PLAN, C-PLAN
C                         'CARA_GEOM' ELEMENTS 2-D D-PLAN
C
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C     ------------------------------------------------------------------
C
      INTEGER            NDIM,NNO,NNOS,KP,NPG,I,J,K,LCASTR,JGANO
      INTEGER            IPOIDS,IVF,IDFDE,IGEOM,IMATE
      REAL*8             RHO, XG, YG, DEPI, R8DEPI, ZERO, R8PREM
      REAL*8             DFDX(9),DFDY(9),POIDS,R,X(9),Y(9)
      REAL*8             MATINE(6), R8B, XXI, XYI, YYI, VOLUME
      REAL*8             IXRP2, IYRP2, XP(9),YP(9),XPG,YPG
      INTEGER ICODRE
      CHARACTER*8        ELREFE
      CHARACTER*16       PHENOM
      LOGICAL            LTEATT
C     ------------------------------------------------------------------
C
      CALL ELREF1(ELREFE)

      ZERO = 0.D0
      DEPI = R8DEPI()
C
      CALL ELREF4(' ','MASS',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      IF (OPTION.EQ.'MASS_INER') THEN
         CALL JEVECH('PMATERC','L',IMATE)
         CALL RCCOMA(ZI(IMATE),'ELAS',1,PHENOM,ICODRE)
C
         IF ( PHENOM .EQ. 'ELAS'          .OR.
     &     PHENOM .EQ. 'ELAS_ISTR'     .OR.
     &     PHENOM .EQ. 'ELAS_ORTH'   )  THEN
            CALL RCVALB('FPG1',1,1,'+',ZI(IMATE),' ',PHENOM,0,' ',R8B,
     &                 1, 'RHO', RHO, ICODRE, 1)
            IF(RHO.LE.R8PREM()) THEN
              CALL U2MESS('F','ELEMENTS5_45')
            ENDIF
            CALL JEVECH('PMASSINE','E',LCASTR)
         ELSE
           CALL U2MESS('F','ELEMENTS_50')
         ENDIF
      ELSEIF (OPTION.EQ.'CARA_GEOM') THEN
C
C       POUR LE CALCUL DES CARA_GEOM DE SECTION DE POUTRE RHO=1
         RHO=1.D0
         CALL JEVECH('PCARAGE','E',LCASTR)
      ELSE
C          OPTION DE CALCUL NON VALIDE
           CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      DO 10 I=1,NNO
         X(I)  =  ZR(IGEOM-2+2*I)
         Y(I)  =  ZR(IGEOM-1+2*I)
         XP(I) = ZERO
         YP(I) = ZERO
 10   CONTINUE
C
      DO 20 I = 0,3
         ZR(LCASTR+I) = ZERO
 20   CONTINUE
      DO 22 I = 1,6
         MATINE(I) = ZERO
 22   CONTINUE
C
C     --- BOUCLE SUR LES POINTS DE GAUSS ---
      VOLUME = ZERO
      DO 100 KP = 1,NPG
         K = (KP-1) * NNO
         CALL DFDM2D ( NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS )
         IF ( LTEATT(' ','AXIS','OUI') ) THEN
            R = ZERO
            DO 102 I = 1,NNO
                R = R + ZR(IGEOM-2+2*I)*ZR(IVF+K+I-1)
102         CONTINUE
            POIDS = POIDS*R
         ENDIF
         VOLUME = VOLUME + POIDS
         DO 104 I = 1,NNO
C           --- CDG ---
            ZR(LCASTR+1) = ZR(LCASTR+1)+POIDS*X(I)*ZR(IVF+K+I-1)
            ZR(LCASTR+2) = ZR(LCASTR+2)+POIDS*Y(I)*ZR(IVF+K+I-1)
C           --- INERTIE ---
            XXI = 0.D0
            XYI = 0.D0
            YYI = 0.D0
            DO 106 J =  1,NNO
               XXI = XXI + X(I)*ZR(IVF+K+I-1)*X(J)*ZR(IVF+K+J-1)
               XYI = XYI + X(I)*ZR(IVF+K+I-1)*Y(J)*ZR(IVF+K+J-1)
               YYI = YYI + Y(I)*ZR(IVF+K+I-1)*Y(J)*ZR(IVF+K+J-1)
 106        CONTINUE
            MATINE(1) = MATINE(1) + POIDS*YYI
            MATINE(2) = MATINE(2) + POIDS*XYI
            MATINE(3) = MATINE(3) + POIDS*XXI
 104     CONTINUE
 100  CONTINUE
C
         IF ( LTEATT(' ','AXIS','OUI') ) THEN
         XG = ZERO
         YG = ZR(LCASTR+2) / VOLUME
         ZR(LCASTR)   = DEPI * VOLUME * RHO
         ZR(LCASTR+3) = YG
         ZR(LCASTR+1) = ZERO
         ZR(LCASTR+2) = ZERO
C
C        --- ON DONNE LES INERTIES AU CDG ---
         MATINE(6) = MATINE(3) * RHO * DEPI
         MATINE(1) = MATINE(1) * RHO * DEPI + MATINE(6)/2.D0
     &                                      - ZR(LCASTR)*YG*YG
         MATINE(2) = ZERO
         MATINE(3) = MATINE(1)
C
      ELSE
         ZR(LCASTR)   = VOLUME * RHO
         ZR(LCASTR+1) = ZR(LCASTR+1) / VOLUME
         ZR(LCASTR+2) = ZR(LCASTR+2) / VOLUME
         ZR(LCASTR+3) = ZERO
C
C        --- ON DONNE LES INERTIES AU CDG ---
         XG = ZR(LCASTR+1)
         YG = ZR(LCASTR+2)
         MATINE(1) = MATINE(1)*RHO - ZR(LCASTR)*YG*YG
         MATINE(2) = MATINE(2)*RHO - ZR(LCASTR)*XG*YG
         MATINE(3) = MATINE(3)*RHO - ZR(LCASTR)*XG*XG
         MATINE(6) = MATINE(1) + MATINE(3)
      ENDIF
      ZR(LCASTR+4) = MATINE(1)
      ZR(LCASTR+5) = MATINE(3)
      ZR(LCASTR+6) = MATINE(6)
      ZR(LCASTR+7) = MATINE(2)
      ZR(LCASTR+8) = MATINE(4)
      ZR(LCASTR+9) = MATINE(5)

      IF (OPTION.EQ.'CARA_GEOM') THEN
C
C --- CALCUL DE IXRP2 = SOMME((Y*(X**2 + Y**2).DS) ET
C --- CALCUL DE IYRP2 = SOMME((X*(X**2 + Y**2).DS) :
C     --------------------------------------------
         DO 110 I = 1, NNO
            XP(I) = X(I) - XG
            YP(I) = Y(I) - YG
  110    CONTINUE
C
         IXRP2 = ZERO
         IYRP2 = ZERO
C
         DO 120 KP = 1,NPG
            K = (KP-1) * NNO
            CALL DFDM2D (NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
C
            XPG = ZERO
            YPG = ZERO
            DO 130 I = 1,NNO
               XPG = XPG + XP(I)*ZR(IVF+K+I-1)
               YPG = YPG + YP(I)*ZR(IVF+K+I-1)
 130        CONTINUE
C
            IXRP2 = IXRP2 + XPG*(XPG*XPG + YPG*YPG)*POIDS
            IYRP2 = IYRP2 + YPG*(XPG*XPG + YPG*YPG)*POIDS
C
 120     CONTINUE
C
         ZR(LCASTR+10) = IXRP2
         ZR(LCASTR+11) = IYRP2

      ENDIF
C
      END
