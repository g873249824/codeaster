        FUNCTION LCIV2S ( A )
      IMPLICIT NONE
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C       ----------------------------------------------------------------
C       SECOND INVARIANT TENSEUR CONTRAINTE(3X3) SOUS FORME VECTEUR(6X1)
C       IN  A      :   TENSEUR
C                                             T  1/2
C       OUT EQUIV  :  EQUIVALENT DE A = (3/2 D D)
C                     AVEC          D = A - 1/3 TR(A) I
C       ----------------------------------------------------------------
        INTEGER         N , ND
        REAL*8          A(6)  , DEV(6)
        REAL*8          LCIV2S , LCNRTS
        COMMON /TDIM/   N , ND
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
        CALL LCDEVI ( A  ,  DEV )
        LCIV2S = LCNRTS ( DEV )
        END
