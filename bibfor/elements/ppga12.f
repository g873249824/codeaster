      SUBROUTINE PPGA12(NDIM,NNO,NPG,POIDS,VFF,GEOM,PG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/11/2011   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INTEGER NDIM,NNO,NPG
      REAL*8  VFF(NNO,NPG), GEOM(NDIM,NNO),PG(NDIM+1,NPG),POIDS(NPG)
      REAL*8  LTMP,LREF
      PARAMETER(LREF=2.D0)
C ----------------------------------------------------------------------
C  POSITION ET POIDS DES POINTS DE GAUSS POUR ELEMENTS DE DIM 1 ET 2
C  *           *                   **                         *    *
C ----------------------------------------------------------------------
C IN  NDIM    DIMENSION DE L'ESPACE
C IN  NNO     NOMBRE DE NOEUDS
C IN  NPG     NOMBRE DE POINTS DE GAUSS
C IN  POIDS   POIDS DES POINTS DE GAUSS DE L'ELEMENT DE REFERENCE
C IN  VFF     VALEUR DES FONCTIONS DE FORME
C IN  GEOM    COORDONNEES DES NOEUDS
C OUT PG      COORDONNEES DES POINTS DE GAUSS + POIDS
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      INTEGER G,I,J
      REAL*8  L,NORM
      REAL*8  U(3),V(3)
C ----------------------------------------------------------------------
      CALL JEMARQ()

C     1. CALCUL DES COORDONNEES DES POINTS DE GAUSS
C     =============================================

      DO 10 G = 1,NPG
         DO 20 I = 1,NDIM+1
            PG(I,G) = 0.D0
 20      CONTINUE
 10   CONTINUE

      DO 30 G = 1,NPG
         DO 40 I = 1,NDIM
            DO 50 J = 1,NNO
               PG(I,G) = PG(I,G) + GEOM(I,J)*VFF(J,G)
 50         CONTINUE
 40      CONTINUE
 30   CONTINUE

      IF(NNO.EQ.1)GOTO 9999

C     2. CALCUL DU POIDS (=POIDS_REF(G)*LONGUEUR_ELE/LONGUEUR_REF)
C     ==================
C
C     -- CALCUL DE LA LONGUEUR DE L'ELEMENT
      LTMP=0.D0
      DO 60 J = 1,NDIM
         LTMP=LTMP+(GEOM(J,1)-GEOM(J,2))**2
 60   CONTINUE
      L=SQRT(LTMP)
C
C     2.1  SEG 2
C     ----------
      IF(NNO.EQ.2)THEN

C     RIEN A FAIRE

C     2.2  SEG 3
C     ----------
      ELSEIF(NNO.EQ.3)THEN
C
          DO 70 I = 1,3
             U(I)=0.D0
             V(I)=0.D0
 70       CONTINUE

          DO 80 I = 1,NDIM
             U(I)=GEOM(I,2)-GEOM(I,1)
             V(I)=GEOM(I,3)-GEOM(I,1)
 80       CONTINUE

          CALL NORMEV(U,NORM)
          CALL NORMEV(V,NORM)

          NORM=U(1)*V(1)+U(2)*V(2)+U(3)*V(3)

C         -- SI LES 3 POINTS NE SONT PAS ALIGNES :
          IF(NORM.LT.0.999D0)THEN
             CALL ASSERT(.FALSE.)
          ENDIF
C
      ELSE
          CALL ASSERT(.FALSE.)
      ENDIF

C     -- CALCUL DU POIDS DE L'ELEMENT
      DO 100 G = 1,NPG
         PG(NDIM+1,G) = POIDS(G)*L/LREF
 100  CONTINUE

9999  CONTINUE

      CALL JEDEMA()

      END
