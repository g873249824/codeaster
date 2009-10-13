      SUBROUTINE ARLMDI(DIME  ,CINE1 ,CINE2 ,DIM1  ,DIM2  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/10/2009   AUTEUR CAO B.CAO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*8   CINE1,CINE2
      INTEGER       DIME
      INTEGER       DIM1,DIM2
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C DIMENSION DES MATRICES PONCTUELLES DANS LA MATRICE MORSE
C
C ----------------------------------------------------------------------
C
C
C IN  DIME   : DIMENSION DE L'ESPACE GLOBAL
C IN  CINE1  : CINEMATIQUE DU PREMIER GROUPE DE MAILLE
C IN  CINE2  : CINEMATIQUE DU DEUXIEME GROUPE DE MAILLE
C OUT DIM1   : DIMENSION 1
C OUT DIM2   : DIMENSION 2
C
C ----------------------------------------------------------------------
C
      IF (DIME.EQ.3) THEN
        IF (CINE1(1:6).EQ.'SOLIDE') THEN
          DIM1 = 9
          IF (CINE2(1:6).EQ.'SOLIDE') THEN
            DIM2 = DIM1
          ELSEIF (CINE2(1:5).EQ.'COQUE') THEN
            DIM2 = 18
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (CINE1(1:5).EQ.'COQUE') THEN
          DIM1 = 30
          IF (CINE2(1:6).EQ.'SOLIDE') THEN
            DIM2 = 15
          ELSEIF (CINE2(1:5).EQ.'COQUE') THEN
            DIM2 = DIM1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (DIME.EQ.2) THEN
        IF (CINE1(1:6).EQ.'SOLIDE') THEN
          DIM1 = 4
          IF (CINE2(1:6).EQ.'SOLIDE') THEN
            DIM2 = DIM1
          ELSEIF (CINE2(1:5).EQ.'COQUE') THEN
            DIM2 = 6
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (CINE1(1:5).EQ.'COQUE') THEN
          DIM1 = 9
          IF (CINE2(1:6).EQ.'SOLIDE') THEN
            DIM2 = 6
          ELSEIF (CINE2(1:5).EQ.'COQUE') THEN
            DIM2 = DIM1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (CINE1(1:8).EQ.'SOLIDEMI') THEN
          DIM1 = 9
          IF (CINE2(1:6).EQ.'SOLIDEMI') THEN
            DIM2 = 9
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C

      END
