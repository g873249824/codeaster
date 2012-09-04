      SUBROUTINE NUELRF ( ELREFE, NUJNI )
      IMPLICIT  NONE
      CHARACTER*8  ELREFE
      INTEGER      NUJNI
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C BUT :  DONNER LE NUMERO DE LA ROUTINE JNI00I ASSOCIEE
C        A UN ELREFE
C IN  ELREFE : NOM DE L'ELREFE
C OUT NUJNI  : NUMERO DE LA ROUTINE JNI00I
C.......................................................................
C
C     D'ABORD LES ELREFA :
C     --------------------
      IF (ELREFE.EQ.'HE8' .OR. ELREFE.EQ.'H20' .OR. ELREFE.EQ.'H27' .OR.
     &    ELREFE.EQ.'PE6' .OR. ELREFE.EQ.'P15' .OR. ELREFE.EQ.'TE4' .OR.
     &    ELREFE.EQ.'T10' .OR. ELREFE.EQ.'PY5' .OR. ELREFE.EQ.'P13' .OR.
     &    ELREFE.EQ.'QU4' .OR. ELREFE.EQ.'QU8' .OR. ELREFE.EQ.'QU9' .OR.
     &    ELREFE.EQ.'TR3' .OR. ELREFE.EQ.'TR6' .OR. ELREFE.EQ.'TR7' .OR.
     &    ELREFE.EQ.'SE2' .OR. ELREFE.EQ.'SE3' .OR. ELREFE.EQ.'SE4' .OR.
     &    ELREFE.EQ.'PO1' .OR. ELREFE.EQ.'P18') THEN
        NUJNI = 2
C
      ELSE IF (ELREFE.EQ.'CABPOU') THEN
        NUJNI = 92
      ELSE IF (ELREFE.EQ.'THCOSE2') THEN
        NUJNI = 91
      ELSE IF (ELREFE.EQ.'THCOSE3') THEN
        NUJNI = 91
      ELSE IF (ELREFE(1:4).EQ.'POHO') THEN
        NUJNI = 15
      ELSE IF (ELREFE.EQ.'MEC3QU9H') THEN
        NUJNI = 80
      ELSE IF (ELREFE.EQ.'MEC3TR7H') THEN
        NUJNI = 80
C
C     -- POUR LES ELREFE VIDES :
      ELSE IF (ELREFE(1:2).EQ.'V_') THEN
        NUJNI = 1
C
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      END
