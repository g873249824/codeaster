      SUBROUTINE AXIAL (ANTISY,   VECAX)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C FONCTION: FORME LE VECTEUR AXIAL 'VECAX' CORRESPONDANT A LA MATRICE
C           ANTISYMETRIQUE 'ANTISY'.
C
C     IN  : ANTISY    : MATRICE ANTISYMETRIQUE D'ORDRE 3
C
C     OUT : VECAX     : VECTEUR D'ORDRE 3
C ------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 ANTISY(3,3),VECAX(3)
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      VECAX(1) = ANTISY(3,2)
      VECAX(2) = ANTISY(1,3)
      VECAX(3) = ANTISY(2,1)
      END
