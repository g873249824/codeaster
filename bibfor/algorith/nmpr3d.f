      SUBROUTINE NMPR3D(MODE,NNO,NPG,POIDSG,VFF,DFF,GEOM,P,
     &                  VECT,MATC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

      IMPLICIT NONE

      INTEGER MODE,NNO,NPG
      REAL*8  POIDSG(NPG),VFF(NNO,NPG),DFF(2,NNO,NPG)
      REAL*8  GEOM(3,NNO),P(*)
      REAL*8  VECT(3,NNO),MATC(3,NNO,3,NNO)

C.......................................................................
C     MODE=1 : CALCUL DU SECOND MEMBRE POUR DES EFFORTS DE PRESSION
C     MODE=2 : CALCUL DE LA RIGIDITE DUE A LA PRESSION (SI SUIVEUSE)
C.......................................................................
C IN  MODE    SELECTION SECOND MEMBRE (1) OU BIEN RIGIDITE (2)
C IN  NNO     NOMBRE DE NOEUDS
C IN  NPG     NOMBRE DE POINTS D'INTEGRATION
C IN  POIDSG  POIDS DES POINTS D'INTEGRATION
C IN  VFF     VALEUR DES FONCTIONS DE FORME AUX POINTS D'INTEGRATION
C IN  DFF     DERIVEE DES F. DE FORME (ELEMENT DE REFERENCE)
C IN  GEOM    COORDONNEES DES NOEUDS
C IN  P       PRESSION AUX POINTS D'INTEGRATION
C OUT VECT    VECTEUR SECOND MEMBRE                      (MODE = 1)
C OUT MATC    MATRICE CARREE NON SYMETRIQUE DE RIGIDITE  (MODE = 2)
C.......................................................................

      INTEGER KPG,N,I,M,J
      REAL*8  COVA(3,3),METR(2,2),JAC,CNVA(3,2)
      REAL*8  T1,T2,T3,T,ACV(2,2)


C    INITIALISATION
      IF (MODE.EQ.1) CALL R8INIR(NNO*3,0.D0,VECT,1)
      IF (MODE.EQ.2) CALL R8INIR(NNO*NNO*9,0.D0,MATC,1)

C    INTEGRATION AUX POINTS DE GAUSS

      DO 100 KPG = 1,NPG


C      CALCUL DES ELEMENTS GEOMETRIQUES DIFFERENTIELS
        CALL SUBACO(NNO,DFF(1,1,KPG),GEOM,COVA)
        CALL SUMETR(COVA,METR,JAC)

C      CALCUL DU SECOND MEMBRE
        IF (MODE.EQ.1) THEN
          DO 10 N = 1,NNO
          DO 11 I = 1,3
              VECT(I,N) = VECT(I,N) - POIDSG(KPG)*JAC * P(KPG)
     &                    * COVA(I,3)*VFF(N,KPG)
 11       CONTINUE
 10       CONTINUE


C      CALCUL DE LA RIGIDITE
        ELSE IF (MODE.EQ.2) THEN
          CALL SUBACV(COVA,METR,JAC,CNVA,ACV)
          DO 20 N=1,NNO
          DO 21 I=1,3
            DO 30 M=1,NNO
            DO 31 J=1,3
              T1 = (DFF(1,N,KPG)*CNVA(I,1) + DFF(2,N,KPG)*CNVA(I,2)) *
     &             VFF(M,KPG)*COVA(J,3)
              T2 = DFF(1,N,KPG)*COVA(I,3) * VFF(M,KPG)*CNVA(J,1)
              T3 = DFF(2,N,KPG)*COVA(I,3) * VFF(M,KPG)*CNVA(J,2)
              T  = POIDSG(KPG) * P(KPG) * JAC * (T1 - T2 - T3)
              MATC(I,N,J,M) = MATC(I,N,J,M) + T
 31         CONTINUE
 30         CONTINUE
 21       CONTINUE
 20       CONTINUE
        ELSE
          CALL U2MESS('F','ALGORITH8_26')
        END IF

 100  CONTINUE

      END
