      SUBROUTINE BRSEFF(K0,MU0,E0S,E0D,SIGEFF)

C     ROUTINE ANCIENNEMENT NOMMEE SIGMA_EFF

C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

        IMPLICIT REAL*8(A-Z)
        REAL*8 E0D(6),SIGEFF(6)
        INTEGER I

C       CLASSEMENT DES CONTRAINTES ET DES DEFORMATION:*
C      I=1,3 => SIGMA II
C      I=4   => SIGMA 12
C      I=5   => SIGMA 13
C      I=6   => SIGMA 23


C       TENSEUR DES CONTRAINTES EFFECTIVES DANS LA PATE (NIVEAU P1)

C       CONTRAINTE SPH�RIQUE
      SIGS=K0*E0S
C     PARTIE DEVIATORIQUE , ATTENTION LES EOD SONT EN FAIT DES GAMMA ...
      DO 10 I=1,3
       SIGEFF(I)=SIGS+MU0*E0D(I)
 10   CONTINUE
C     LES TROIS TERMES HORS DIAGONALES SONT ENCORE DES GAMMA...
      DO 20 I=4,6
       SIGEFF(I)=MU0*E0D(I)
 20   CONTINUE

      END
