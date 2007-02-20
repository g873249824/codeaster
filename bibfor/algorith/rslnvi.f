        SUBROUTINE RSLNVI ( MOD , NDT , NDI , NR , NVI )
        IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR MICHEL S.MICHEL 
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
C       ----------------------------------------------------------------
C       ROUSSELIER : NOMBRE DE COMPOSANTES DES CONTRAINTES ET
C                    NOMBRE VARIABLES
C       ----------------------------------------------------------------
C       IN  MOD    :  TYPE DE MODELISATION
C       OUT NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
C           NDI    :  NB DE COMPOSANTES DIRECTES TENSEURS
C           NR     :  NB DE COMPOSANTES SYSTEME NL
C           NVI    :  NB DE VARIABLES INTERNES
C       ----------------------------------------------------------------
        INTEGER         NDT , NDI  , NR , NVI
        CHARACTER*8     MOD
C       ----------------------------------------------------------------
C
C -     NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
C
      IF      ( MOD(1:2) .EQ.'3D' ) THEN
                NDT = 6
                NDI = 3
                NR  = NDT+2
      ELSE IF ( MOD(1:6) .EQ. 'D_PLAN' .OR.
     &          MOD(1:4) .EQ. 'AXIS'        ) THEN
                NDT = 4
                NDI = 3
                NR  = NDT+2
      ELSE IF ( MOD(1:6) .EQ. 'C_PLAN' ) THEN
                NDT = 4
                NDI = 3
                NR  = NDT+3
                CALL U2MESS('F','ALGORITH10_51')
      ELSE IF ( MOD(1:2) .EQ. '1D' )THEN
                NDT = 3
                NDI = 3
                NR  = NDT+2
      ENDIF
      NVI = 5
C
      END
