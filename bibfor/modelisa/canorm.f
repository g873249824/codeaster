      SUBROUTINE CANORM(COOR,NORMAL,NDIM,ITYP,INORM)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER NDIM,ITYP,INORM
      REAL*8 COOR(*),NORMAL(3)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
C     BUT : CALCUL DE LA NORMALE A UNE MAILLE  EN UN NOEUD
C     AVEC OU SANS NORMALISATION DE CE VECTEUR
C
C IN  COOR    R8 : TABLEAU DES COORDONNEES DES NBNO NOEUDS DE LA MAILLE
C                  DE DIMENSION (3*NBNO)
C IN  NDIM    I  : DIMENSION DU MODELE (2 SI COORD_2D OU 3 SI COORD_3D)
C IN  ITYP    I  : TYPE DE LA MAILLE
C IN  INORM   I  : INDICATEUR DE NORMALISATION
C                  INORM = 0 PAS DE NORMALISATION
C                  INORM = 1 NORMALISATION
C OUT NORMALE R8 : NORMALE CALCULEE
C
C ROUTINES APPELLEES :
C     NORMEV     PROVEC
C     JENUNO     JEXNUM



      REAL*8 XX(3),YY(3),NORME,SURF,VECT(3)
      CHARACTER*8 NOMTM

C DEBUT ----------------------------------------------------------------

      CALL JENUNO(JEXNUM('&CATA.TM.NBNO',ITYP),NOMTM)
      IF (NOMTM(1:3).EQ.'SEG') THEN
        IF (NDIM.EQ.3) THEN
            NORMAL(1) = COOR(4) - COOR(1)
            NORMAL(2) = COOR(5) - COOR(2)
            NORMAL(3) = COOR(6) - COOR(3)
            IF (INORM.EQ.1) THEN
              CALL NORMEV(NORMAL,NORME)
             ELSE
              CALL U2MESS('F','MODELISA3_20')
            END IF
C          ELSE
C            NORMAL(1) = COOR(5) - COOR(2)
C            NORMAL(2) = COOR(1) - COOR(4)
C            NORMAL(3) = 0.0D0
C            IF (INORM.EQ.1) THEN
C              CALL NORMEV(NORMAL,NORME)
C            END IF
C
C          END IF

        ELSE
          NORMAL(1) = COOR(5) - COOR(2)
          NORMAL(2) = COOR(1) - COOR(4)
          NORMAL(3) = 0.0D0
          IF (INORM.EQ.1) THEN
            CALL NORMEV(NORMAL,NORME)
          END IF

        END IF

      ELSE IF (NOMTM(1:4).EQ.'TRIA') THEN
        IF (NDIM.EQ.2) THEN
          CALL U2MESS('F','MODELISA3_21')

        ELSE
          DO 10 J = 1,3
            XX(J) = COOR(3+J) - COOR(J)
            YY(J) = COOR(6+J) - COOR(3+J)
   10     CONTINUE
          CALL PROVEC(XX,YY,NORMAL)
          DO 20 J = 1,3
            NORMAL(J) = NORMAL(J)/2.0D0
   20     CONTINUE
          IF (INORM.EQ.1) THEN
            CALL NORMEV(NORMAL,NORME)
          END IF

        END IF

      ELSE IF (NOMTM(1:4).EQ.'QUAD') THEN
        IF (NDIM.EQ.2) THEN
          CALL U2MESS('F','MODELISA3_22')

        ELSE

C     PRODUIT VECTORIEL (N1N3) * (N2N4) POUR CALCULER LE VECTEUR NORMAL

          DO 30 J = 1,3
            XX(J) = COOR(6+J) - COOR(J)
            YY(J) = COOR(9+J) - COOR(3+J)
   30     CONTINUE
          CALL PROVEC(XX,YY,NORMAL)
          CALL NORMEV(NORMAL,NORME)
          IF (INORM.EQ.0) THEN

C     ON CALCULE UNE APPROXIMATION DE LA SURFACE
C     DANS L'ORDRE
C     (N1N2) * (N1N3)
C     (N1N3) * (N1N4)
C     (N2N3) * (N2N4)
C     (N2N4) * (N2N1)

            SURF = 0.0D0
            DO 40 J = 1,3
              XX(J) = COOR(3+J) - COOR(J)
              YY(J) = COOR(6+J) - COOR(J)
   40       CONTINUE
            CALL PROVEC(XX,YY,VECT)
            CALL NORMEV(VECT,NORME)
            SURF = SURF + NORME
            DO 50 J = 1,3
              XX(J) = COOR(6+J) - COOR(J)
              YY(J) = COOR(9+J) - COOR(J)
   50       CONTINUE
            CALL PROVEC(XX,YY,VECT)
            CALL NORMEV(VECT,NORME)
            SURF = SURF + NORME
            DO 60 J = 1,3
              XX(J) = COOR(6+J) - COOR(3+J)
              YY(J) = COOR(9+J) - COOR(3+J)
   60       CONTINUE
            CALL PROVEC(XX,YY,VECT)
            CALL NORMEV(VECT,NORME)
            SURF = SURF + NORME
            DO 70 J = 1,3
              XX(J) = COOR(9+J) - COOR(3+J)
              YY(J) = COOR(J) - COOR(3+J)
   70       CONTINUE
            CALL PROVEC(XX,YY,VECT)
            CALL NORMEV(VECT,NORME)
            SURF = SURF + NORME
            SURF = SURF/4.0D0
            DO 80 J = 1,3
              NORMAL(J) = NORMAL(J)*SURF
   80       CONTINUE
          END IF

        END IF

      END IF


C FIN ------------------------------------------------------------------
      END
