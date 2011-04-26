      SUBROUTINE RENUU1(COIN,LONGI,ORDO,LONGO,NBCO,NEWN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C     ARGUMENTS:
C     ----------
      INTEGER LONGI,LONGO,COIN(*),ORDO(*),NBCO(*),NEWN(*)
C ----------------------------------------------------------------------
C     BUT:     ORDONNER LA LISTE DE NOEUDS COIN(*) DE LONGUEUR LONGI
C           DANS LA LISTE ORDO(*) :
C              UN NOEUD I EST PLACE AVANT UN NOEUD J SI SON NOMBRE DE
C           CONNECTIVITE EST INFERIEUR A CELUI DE J.
C
C              LES NOEUDS DEJA RENUMEROTES NE SONT PAS TRAITES
C           (CE SONT LES NOEUDS DONT LE .NEWN EST DEJA >0)
C           LA LISTE DES NOEUDS ORDONNES PEUT DONC ETRE DE LONGUEUR
C           MOINDRE QUE COIN : LONGO <= LONGI)
C
C     IN : LONGI : LONGUEUR UTILE DE COIN
C          COIN(*) : LISTE DES NOEUDS A ORDONNER.
C          NBCO(I) : NOMBRE DE NOEUDS CONNECTES AU NOEUD I.
C          NEWN(I) : NOUVEAU NUMERO DU NOEUD I (0 SI PAS RENUMEROTE).
C
C     OUT: LONGO : LONGUEUR UTILE DE ORDO
C          ORDO(*) : LISTE DES NOEUDS REORDONNES.
C
C ----------------------------------------------------------------------
C DEB-------------------------------------------------------------------
C
      LONGO=0
      DO 1, I=1,LONGI
         IF (NEWN(COIN(I)).GT.0) GO TO 1
         LONGO=LONGO+1

C        -- ON PLACE LE 1ER EN 1ER :
         IF (LONGO.EQ.1) THEN
            ORDO(1)= COIN(I)
            GO TO 1
         END IF
C
         DO 2, J=1,LONGO-1
C           -- ON INSERE COIN(I) :
            IF (NBCO(COIN(I)).LE.NBCO(ORDO(J))) THEN
               DO 3, K= LONGO-1,J,-1
                  ORDO(K+1)= ORDO(K)
 3             CONTINUE
               ORDO(J)= COIN(I)
               GO TO 1
            END IF
 2       CONTINUE
         ORDO(LONGO)= COIN(I)
 1    CONTINUE
C
      END
