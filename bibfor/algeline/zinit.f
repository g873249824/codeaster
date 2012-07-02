      SUBROUTINE ZINIT (N, ZA, ZX, INCX)
      IMPLICIT NONE
      INTEGER    N, INCX
      COMPLEX    *16 ZA, ZX(*)
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
C-----------------------------------------------------------------------
C    INITIALISATION D'UN VECTEUR COMPLEXE A UNE VALEUR ZA.
C-----------------------------------------------------------------------
C IN  : N    : LONGUEUR DU VECTEUR X.
C     : ZA   : COMPLEXE.
C I/O : ZX   : VECTEUR COMPLEXE DE LONGUEUR N*INCX.
C              ZINIT REMPLACE X(I) PAR ZA POUR I=1,...,N.
C     : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE ZX.
C              X(I) EST DEFINI PAR ZX(1+(I-1)*INCX).INCX DOIT ETRE
C              PLUS GRAND QUE ZERO.
C-----------------------------------------------------------------------
      INTEGER    I, NINCX
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      IF (N .GT. 0) THEN
         IF (INCX .NE. 1) THEN
C
            NINCX = N*INCX
            DO 10  I=1, NINCX, INCX
               ZX(I) = ZA
   10       CONTINUE
         ELSE
C
            DO 20  I=1, N
               ZX(I) = ZA
   20       CONTINUE
         END IF
      END IF
      END
