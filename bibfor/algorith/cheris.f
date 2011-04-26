      SUBROUTINE CHERIS(NB,IVEC,I,IRAN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT:  CHERCHER LE RANG D'UN ENTIER DANS UNE LISTE D'ENTIER
C
C-----------------------------------------------------------------------
C
C NB       /I/: NOMBRE D'ENTIER DE LA LISTE
C IVEC     /I/: VECTEUR DES ENTIERS
C I        /I/: ENTIER A TROUVER
C IRAN     /O/: RANG DE L'ENTIER
C
C-----------------------------------------------------------------------
C
      INTEGER IVEC(NB)
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      IRAN=0
      DO 10 J=1,NB
        IF(IVEC(J).EQ.I) IRAN=J
 10   CONTINUE
C
      END
