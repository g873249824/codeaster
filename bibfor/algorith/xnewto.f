        SUBROUTINE XNEWTO(ELP,NAME,NUM,NNO,NDIM,JPTINT,JTABCO,JTABLS,
     &                                    IPP,IP,S,ITEMAX,EPSMAX,KSI)
      IMPLICIT NONE

      INTEGER      NUM,NDIM,IPP,IP,NNO
      REAL*8       KSI(NDIM),S
      INTEGER      ITEMAX,JPTINT,JTABCO,JTABLS
      REAL*8       EPSMAX
      CHARACTER*6  NAME
      CHARACTER*8  ELP

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2010   AUTEUR PELLET J.PELLET 
C TOLE CRS_1404
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C             ALGORITHME DE NEWTON POUR CALCULER LES COORDONNEES
C                DE REFERENCE D'UN POINT PT MILIEU D'UNE ARETE
C
C     ENTREE
C       NUM     : NUMERO DE LA FONCTION A RESOUDRE (DANS XDELT1)
C       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
C       COORSG  : COORDONNEES DES 3 NOEUDS DE L'ARETE
C       S       : ABSCISSE CURVILIGNE DU POINT SUR L'ARETE
C       ITEMAX  : NOMBRE MAXI D'ITERATIONS DE NEWTON
C       EPSMAX  : RESIDU POUR CONVERGENCE DE NEWTON
C
C     SORTIE
C       KSI     : COORDONNEES DE REFERENCE DU POINT
C     --------------------------------------------------------------
C
      REAL*8       EPS
      REAL*8       TEST,EPSREL,EPSABS,REFE
      INTEGER      ITER,I
      REAL*8       ZERO
      PARAMETER    (ZERO=0.D0)
      REAL*8       DIST,DMIN,R8GAEM
      REAL*8       DELTA(NDIM),KSIM(NDIM)
C
C ------------------------------------------------------------------

      CALL JEMARQ()

C --- POINT DE DEPART
C
      CALL VECINI(NDIM,ZERO,KSI)
      CALL VECINI(NDIM,ZERO,DELTA)
      ITER   = 0
      EPSABS = EPSMAX/100.D0
      EPSREL = EPSMAX
      DMIN   = R8GAEM()
C
C --- DEBUT DE LA BOUCLE
C
 20   CONTINUE
C-------------------------

C     FAIRE TANT QUE

C
C --- CALCUL DE LA QUANTITE A MINIMISER
C
      IF (NAME .EQ. 'XMILFI') THEN
        CALL XDELT2(ELP,NNO,NDIM,KSI,JPTINT,JTABCO,JTABLS,IPP,IP,DELTA)
      ELSEIF (NAME.EQ. 'XINVAC') THEN
        CALL XDELT1(NUM,NDIM,KSI(1),JTABCO,S,DELTA)
      ENDIF
C
C --- ACTUALISATION
C
      DO 30 I=1, NDIM
      KSI(I) = KSI(I) - DELTA(I)
 30   CONTINUE

      ITER = ITER + 1

      DO 40 I=1, NDIM
      DIST = DELTA(I)*DELTA(I)
 40   CONTINUE
      DIST  = SQRT(DIST)

      IF (DIST.LE.DMIN) THEN
        DO 50 I=1, NDIM
        KSIM(I) = KSI(I)
 50     CONTINUE
      ENDIF
C
C --- CALCUL DE LA REFERENCE POUR TEST DEPLACEMENTS
C
      REFE   = ZERO
      DO 60 I=1, NDIM
      REFE = REFE + KSI(I)*KSI(I)
 60   CONTINUE
      IF (REFE.LE.EPSREL) THEN
        REFE = 1.D0
        EPS  = EPSABS
      ELSE
        EPS  = EPSREL
      ENDIF
C
C --- CALCUL POUR LE TEST DE CONVERGENCE
C
      TEST   = ZERO
      DO 70 I=1, NDIM
      TEST = TEST + DELTA(I)*DELTA(I)
 70   CONTINUE
      TEST = SQRT(TEST/REFE)
C
C --- EVALUATION DE LA CONVERGENCE
C
      IF ((TEST.GT.EPS) .AND. (ITER.LT.ITEMAX)) THEN
        GOTO 20
      ELSEIF ((ITER.GE.ITEMAX).AND.(TEST.GT.EPS)) THEN
        CALL U2MESS('F','XFEM_67')
        DO 80 I=1, NDIM
        KSI(I) = KSIM(I)
 80   CONTINUE
      ENDIF
C
C --- FIN DE LA BOUCLE
C
      DO 90 I=1, NDIM
      KSI(I)=KSI(I)-DELTA(I)
 90   CONTINUE

      CALL JEDEMA()
      END
