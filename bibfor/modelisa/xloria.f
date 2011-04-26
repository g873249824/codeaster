      SUBROUTINE XLORIA(CARA,GEOFIS,NOEUD,VECT1,VECT2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
      REAL*8      NOEUD(3),VECT1(3),VECT2(3),CARA(10)
      CHARACTER*16 GEOFIS
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (CREATION DES SD)
C
C CONSTRUCTION AUTOMATIQUE DES DONNEES ORIENTATION FOND DE FISSURE -
C (CREATION XCARFO AUTOMATIQUE)
C
C ----------------------------------------------------------------------
C
C OUT CARA   : NOM DE LA SD FISS_XFEM
C                 FISS//'.CARAFOND'
C    CARA(1-3) = VECT_ORIE AUTOMATIQUE
C    CARA(4-6) = POINT_ORIG AUTOMATIQUE
C    CARA(7-9) = INUTILE POUR L'ORIENTATION AUTOMATIQUE
C    CARA(10)  = INFO SUR ORIENTATION (UTILISATEUR=0, AUTO=1)
C
C IN  GEOFIS,DGA,NOEUD,VECT1,VECT2
C
C ----------------------------------------------------------------------

      INTEGER      I
      REAL*8       NORME,VECT3(3)

      CALL R8INIR(10, 0.D0, CARA, 1)

      CARA(10) = 1.D0

      IF (GEOFIS.EQ.'ELLIPSE'.OR.GEOFIS.EQ.'CYLINDRE'.OR.
     &    GEOFIS.EQ.'RECTANGLE') THEN

        CALL NORMEV(VECT1,NORME)
        CALL NORMEV(VECT2,NORME)
        CALL PROVEC(VECT1,VECT2,VECT3)

        DO 10 I = 1,3
          CARA(I)   = VECT3(I)
          CARA(I+3) = NOEUD(I)
 10     CONTINUE

      ELSEIF (GEOFIS.EQ.'DEMI_PLAN') THEN

        CALL NORMEV(VECT1,NORME)
        CALL NORMEV(VECT2,NORME)

        DO 11 I = 1,3
          CARA(I)   = VECT1(I)
          CARA(I+3) = NOEUD(I) - VECT2(I)
 11     CONTINUE

      ENDIF

      END
