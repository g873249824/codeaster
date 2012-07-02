      SUBROUTINE VPRECO(NBVECT,NEQ,VECRED,VECT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER         NBVECT,NEQ
      REAL*8          VECT(NEQ,NBVECT), VECRED(NBVECT,NBVECT)
C     ------------------------------------------------------------------
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
C     EFFECTUE LE PROLONGEMENT DES VECTEURS PROPRES : CALCUL DES
C     VECTEURS PROPRES DU SYSTEME COMPLET A PARTIR DES VECTEURS
C     PROPRES DU SYSTEME  REDUIT ET D'UNE MATRICE DE PASSAGE
C     (VECTEURS DE LANCZOS )
C     ------------------------------------------------------------------
C     NBVECT : IN  : NOMBRE DE MODES
C     NEQ    : IN  : NOMBRE D'INCONNUES
C     VECRED : IN  : MATRICE MODALE (CARREE) DU SYSTEME REDUIT
C     VECT   : IN  : MATRICE DE PASSAGE (RECTANGULAIRE)
C              OUT : MATRICE MODALE (RECTANGULAIRE) DU SYSTEME COMPLET
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,ILIG ,J ,K ,L 
      REAL*8 RT 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL WKVECT('&&VPRECO.ILIG','V V R',NBVECT,ILIG)
C
      DO 10 I = 1, NEQ
         DO 20 J = 1, NBVECT
            ZR(ILIG+J-1) = VECT(I,J)
 20      CONTINUE
         DO 30 K = 1, NBVECT
            RT = 0.D0
            DO 40 L = 1, NBVECT
               RT = RT + ZR(ILIG+L-1) * VECRED(L,K)
 40         CONTINUE
            VECT(I,K) = RT
 30      CONTINUE
 10   CONTINUE
C
      CALL JEDETR('&&VPRECO.ILIG')
C
      CALL JEDEMA()
      END
