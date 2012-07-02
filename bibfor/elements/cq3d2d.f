      SUBROUTINE CQ3D2D(NNO,COOR3D,COTETA,SITETA,COOR2D)
      IMPLICIT NONE
      INTEGER NNO
      REAL*8 COOR3D(*),COTETA,SITETA,COOR2D(*)
C ......................................................................
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
C .  - FONCTION REALISEE:  CALCUL DES COORDONNEES 2-D D'UN TRIANGLE    .
C .     OU D'UN QUADRANGLE                                             .
C .     A PARTIR DE SES COORDONNEES 3-D. PASSAGE DANS LE REPERE DU PLAN.
C .     DU TRIANGLE OU DU QUADRANGLE                                   .
C .     AVEC TETA=ANGLE ENTRE L'AXE X ET LE COTE A1A2.                 .
C .                                                                    .
C .  - ARGUMENTS:                                                      .
C .                                                                    .
C .       DONNEES :        NNO     -->  NOMBRE DE NOEUDS               .
C .                      COOR3D    -->  COORD. 3-D DES NOEUDS          .
C .                      COTETA    -->  COSINUS ANGLE TETA             .
C .                      SITETA    -->  SINUS ANGLE TETA               .
C .                                                                    .
C .       RESULTATS :    COOR2D    <--  COORD. 2-D DES NOEUDS          .
C ......................................................................
C
      REAL*8 NA1A2,NA1A3,NA1A4,PSCAL,PPSCAL,QPSCAL,SIGAMA,SIDLTA
      REAL*8 VA1A3(3),VA1A2(3),VA1A4(3)
      REAL*8 PVEC1,PVEC2,PVEC3,QVEC1,QVEC2,QVEC3,NORME,PNORME,QNORME
      REAL*8 GAMMA,DELTA,ALPHA,ALPHA1,ALPHA2
      REAL*8 TRIGOM
C
C-----------------------------------------------------------------------
      INTEGER I 
      REAL*8 TETA 
C-----------------------------------------------------------------------
      IF ((NNO.EQ.3).OR.(NNO.EQ.6).OR.(NNO.EQ.7)) THEN
C
C     CAS TRIANGLES A 3, 6, OU 7 NOEUDS
C
      NA1A2 = 0.D0
      NA1A3 = 0.D0
C
      DO 10 I = 1,3
        VA1A2(I) = COOR3D(3+I) - COOR3D(I)
        VA1A3(I) = COOR3D(6+I) - COOR3D(I)
        NA1A2 = NA1A2 + VA1A2(I)**2
        NA1A3 = NA1A3 + VA1A3(I)**2
   10 CONTINUE
      NA1A2 = SQRT(NA1A2)
      NA1A3 = SQRT(NA1A3)
      PVEC1 = VA1A2(2)*VA1A3(3) - VA1A2(3)*VA1A3(2)
      PVEC2 = VA1A2(3)*VA1A3(1) - VA1A2(1)*VA1A3(3)
      PVEC3 = VA1A2(1)*VA1A3(2) - VA1A2(2)*VA1A3(1)
      NORME = SQRT(PVEC1**2+PVEC2**2+PVEC3**2)
C
      COOR2D(1) = 0.D0
      COOR2D(2) = 0.D0
      COOR2D(3) = NA1A2*COTETA
      COOR2D(4) = -NA1A2*SITETA
C
      PSCAL = 0.D0
      DO 20 I = 1,3
        PSCAL = PSCAL + VA1A2(I)*VA1A3(I)
   20 CONTINUE
C
      SIGAMA = NORME/ (NA1A2*NA1A3)
      IF (SIGAMA.GT.1.D0) SIGAMA = 1.D0
      GAMMA = TRIGOM('ASIN',SIGAMA)
      IF (PSCAL.LT.0.D0) GAMMA = 4.D0*ATAN2(1.D0,1.D0) - GAMMA
      TETA = TRIGOM('ASIN',SITETA)
      IF (COTETA.LT.0.D0) TETA = 4.D0*ATAN2(1.D0,1.D0) - TETA
      ALPHA = GAMMA - TETA
C
      COOR2D(5) = NA1A3*COS(ALPHA)
      COOR2D(6) = NA1A3*SIN(ALPHA)
C
      IF ((NNO.EQ.6).OR.(NNO.EQ.7)) THEN
        DO 30 I = 1,2
          COOR2D(I+6) = (COOR2D(I+2)+COOR2D(I))/2.D0
          COOR2D(I+8) = (COOR2D(I+4)+COOR2D(I+2))/2.D0
          COOR2D(I+10) = (COOR2D(I)+COOR2D(I+4))/2.D0
   30   CONTINUE
      END IF
C
      IF (NNO.EQ.7) THEN
          COOR2D(13)  = (COOR2D(1)+COOR2D(3)+COOR2D(5))/3.D0
          COOR2D(14)  = (COOR2D(2)+COOR2D(4)+COOR2D(6))/3.D0
      ENDIF
C
      ELSE IF ((NNO.EQ.4).OR.(NNO.EQ.8).OR.(NNO.EQ.9)) THEN
C
C     CAS QUADRANGLES A 4, 8 OU 9 NOEUDS
C
      NA1A2 = 0.D0
      NA1A3 = 0.D0
      NA1A4 = 0.D0
C
      DO 50 I = 1,3
        VA1A2(I) = COOR3D(3+I) - COOR3D(I)
        VA1A3(I) = COOR3D(6+I) - COOR3D(I)
        VA1A4(I) = COOR3D(9+I) - COOR3D(I)
C
        NA1A2 = NA1A2 + VA1A2(I)**2
        NA1A3 = NA1A3 + VA1A3(I)**2
        NA1A4 = NA1A4 + VA1A4(I)**2
   50 CONTINUE
      NA1A2 = SQRT(NA1A2)
      NA1A3 = SQRT(NA1A3)
      NA1A4 = SQRT(NA1A4)
C
      PVEC1 = VA1A2(2)*VA1A3(3) - VA1A2(3)*VA1A3(2)
      PVEC2 = VA1A2(3)*VA1A3(1) - VA1A2(1)*VA1A3(3)
      PVEC3 = VA1A2(1)*VA1A3(2) - VA1A2(2)*VA1A3(1)
C
      QVEC1 = VA1A2(2)*VA1A4(3) - VA1A2(3)*VA1A4(2)
      QVEC2 = VA1A2(3)*VA1A4(1) - VA1A2(1)*VA1A4(3)
      QVEC3 = VA1A2(1)*VA1A4(2) - VA1A2(2)*VA1A4(1)
C
      PNORME = SQRT(PVEC1**2+PVEC2**2+PVEC3**2)
C
      QNORME = SQRT(QVEC1**2+QVEC2**2+QVEC3**2)
C
      COOR2D(1) = 0.D0
      COOR2D(2) = 0.D0
      COOR2D(3) = NA1A2*COTETA
      COOR2D(4) = -NA1A2*SITETA
C
      PPSCAL = 0.D0
      QPSCAL = 0.D0
      DO 60 I = 1,3
        PPSCAL = PPSCAL + VA1A2(I)*VA1A3(I)
        QPSCAL = QPSCAL + VA1A2(I)*VA1A4(I)
   60 CONTINUE
C
      SIGAMA = PNORME/ (NA1A2*NA1A3)
      IF (SIGAMA.GT.1.D0) SIGAMA = 1.D0
      GAMMA = TRIGOM('ASIN',SIGAMA)
      IF (PPSCAL.LT.0.D0) GAMMA = 4.D0*ATAN2(1.D0,1.D0) - GAMMA
C
      SIDLTA = QNORME/ (NA1A2*NA1A4)
      IF (SIDLTA.GT.1.D0) SIDLTA = 1.D0
      DELTA = TRIGOM('ASIN',SIDLTA)
      IF (QPSCAL.LT.0.D0) DELTA = 4.D0*ATAN2(1.D0,1.D0) - DELTA
C
      TETA = TRIGOM('ASIN',SITETA)
      IF (COTETA.LT.0.D0) TETA = 4.D0*ATAN2(1.D0,1.D0) - TETA
C
      ALPHA1 = GAMMA - TETA
      ALPHA2 = DELTA - TETA
C
      COOR2D(5) = NA1A3*COS(ALPHA1)
      COOR2D(6) = NA1A3*SIN(ALPHA1)
C
      COOR2D(7) = NA1A4*COS(ALPHA2)
      COOR2D(8) = NA1A4*SIN(ALPHA2)
C
      IF ((NNO.EQ.8).OR.(NNO.EQ.9)) THEN
        DO 70 I = 1,2
          COOR2D(I+8) = (COOR2D(I+2)+COOR2D(I))/2.D0
          COOR2D(I+10) = (COOR2D(I+4)+COOR2D(I+2))/2.D0
          COOR2D(I+12) = (COOR2D(I+6)+COOR2D(I+4))/2.D0
          COOR2D(I+14) = (COOR2D(I)+COOR2D(I+6))/2.D0
   70   CONTINUE
      END IF
C
      IF (NNO.EQ.9) THEN
          COOR2D(17) = (COOR2D(1)+COOR2D(3)+COOR2D(5)+COOR2D(7))/4.D0
          COOR2D(18) = (COOR2D(2)+COOR2D(4)+COOR2D(6)+COOR2D(8))/4.D0
      ENDIF
C
      ENDIF
C
      END
