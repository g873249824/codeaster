      SUBROUTINE MATRKB(NB1,NDIMX,NDDLX,NDDLET,KTDC,ALPHA,RIG1,COEF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
C
      INTEGER NB1 , NB2
      INTEGER NDIMX,NDDLX,NDDLET
C     REAL*8 KTDC(NDDLE,NDDLE),RIG1(NDDLET,NDDLET)
C     REAL*8 ALPHA,COEF
C
      REAL*8 KTDC(NDIMX,NDIMX),RIG1(NDDLX,NDDLX)
      REAL*8 ALPHA,COEF
C
      REAL*8 RIGRL ( 2 , 2 )
      REAL*8 XMIN
      REAL*8 R8PREM
C
      INTEGER I1 , I2 , I , IB , IR , IN , II
      INTEGER J1 , J2 , J , JB ,           JJ , JR
      INTEGER      KOMPTI,KOMPTJ
C
C
C
C     RECHERCHE DU MINIMUM DE LA MATRICE KTDC = INF DES TERMES DIAGONAUX
C
C
      XMIN = 1.D0 / R8PREM ( )
C
      NB2 = NB1 + 1
C
      DO 402 IN = 1 , NB2
C
C------- ON CONSTRUIT RIGRL
C
         IF ( IN . LE . NB1 ) THEN
C
C----------- NOEUDS DE SERENDIP
             DO 431 JJ = 1 , 2
                JR   = 5 * ( IN - 1 ) + JJ + 3
                DO 441 II = 1 , 2
                    IR    = 5 * ( IN - 1 ) + II + 3
                    RIGRL ( II , JJ ) = KTDC ( IR , JR )
 441            CONTINUE
 431         CONTINUE
C
         ELSE
C
C----------- SUPERNOEUD
             DO 451 JJ = 1 , 2
                JR   = 5 * NB1        + JJ
                DO 461 II = 1 , 2
                    IR    = 5 * NB1        + II
                    RIGRL ( II , JJ ) = KTDC ( IR , JR )
 461            CONTINUE
 451         CONTINUE
C
         ENDIF
C
C-------    ON COMPARE LES DEUX PREMIERS TERMES DIAGONAUX DE RIGRL
C
            IF ( RIGRL ( 1 , 1 ) .LT. XMIN ) XMIN = RIGRL ( 1 , 1 )
            IF ( RIGRL ( 2 , 2 ) .LT. XMIN ) XMIN = RIGRL ( 2 , 2 )
C
 402  CONTINUE
C
C
         COEF=ALPHA * XMIN
C
C     RAIDEUR ASSOCIEE A LA ROTATION FICTIVE = COEF = ALPHA * INF
C
      DO 20 I=1,NDDLET
      DO 30 J=1,NDDLET
         RIG1(I,J)=0.D0
 30   CONTINUE
 20   CONTINUE
C
C     CONSTRUCTION DE KBARRE = KTILD EXTENDU  :  (NDDLET,NDDLET)
C
      KOMPTI=-1
      KOMPTJ=-1
C
      NB2=NB1+1
C
      DO 40 IB=1,NB2
         KOMPTI=KOMPTI+1
      DO 50 JB=1,NB2
         KOMPTJ=KOMPTJ+1
      IF ((IB.LE.NB1).AND.(JB.LE.NB1)) THEN
      DO 60  I=1,5
         I1=5*(IB-1)+I
         I2=I1+KOMPTI
      DO 70  J=1,5
         J1=5*(JB-1)+J
         J2=J1+KOMPTJ
         RIG1(I2,J2)=KTDC(I1,J1)
 70   CONTINUE
 60   CONTINUE
C
      ELSE IF ((IB.LE.NB1).AND.(JB.EQ.NB2)) THEN
      DO 95  I=1,5
         I1=5*(IB-1)+I
         I2=I1+KOMPTI
      DO 100 J=1,2
         J1=5*NB1+J
         J2=J1+KOMPTJ
         RIG1(I2,J2)=KTDC(I1,J1)
 100  CONTINUE
 95   CONTINUE
C
      ELSE IF ((IB.EQ.NB2).AND.(JB.LE.NB1)) THEN
      DO 85  I=1,2
         I1=5*NB1+I
         I2=I1+KOMPTI
      DO 90  J=1,5
         J1=5*(JB-1)+J
         J2=J1+KOMPTJ
         RIG1(I2,J2)=KTDC(I1,J1)
 90   CONTINUE
 85   CONTINUE
C
      ELSE IF ((IB.EQ.NB2).AND.(JB.EQ.NB2)) THEN
      DO 105 I=1,2
         I1=5*NB1+I
         I2=I1+KOMPTI
      DO 110 J=1,2
         J1=5*NB1+J
         J2=J1+KOMPTJ
         RIG1(I2,J2)=KTDC(I1,J1)
 110  CONTINUE
 105  CONTINUE
C
      ENDIF
C
 50   CONTINUE
C
      IF (IB.LE.NB1) THEN
         RIG1(6*IB,6*IB)=COEF
      ELSE
         RIG1(NDDLET,NDDLET)=COEF
      ENDIF
C
         KOMPTJ=-1
 40   CONTINUE
C
      END
