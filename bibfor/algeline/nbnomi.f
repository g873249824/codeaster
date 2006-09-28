      FUNCTION NBNOMI(NOMTYZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) NOMTYZ
      INTEGER NBNOMI
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C     BUT : NOMBRE DE NOEUDS MILIEUX POUR UN TYPE D'ELEMENT DONNE
C IN  K* NOMTYP : NOM DU TYPE D'ELEMENT
C-----------------------------------------------------------------------
C
      CHARACTER*8 NOMTYP
C
      NOMTYP = NOMTYZ
      NBNOMI = 0
C
      IF (NOMTYP(1:5).EQ.'TRIA6') THEN
         NBNOMI = 3
      ELSEIF (NOMTYP(1:5).EQ.'TRIA7') THEN
         NBNOMI = 4
      ELSEIF (NOMTYP(1:5).EQ.'TRIA9') THEN
         NBNOMI = 6
      ELSEIF (NOMTYP(1:5).EQ.'QUAD8') THEN
         NBNOMI = 4
      ELSEIF (NOMTYP(1:5).EQ.'QUAD9') THEN
         NBNOMI = 5
      ELSEIF (NOMTYP(1:6).EQ.'QUAD12') THEN
         NBNOMI = 8
      ELSEIF (NOMTYP(1:5).EQ.'SEG3') THEN
         NBNOMI = 1
      ELSE
        CALL U2MESS('F','ELEMENTS_16')
      ENDIF
C
      END
