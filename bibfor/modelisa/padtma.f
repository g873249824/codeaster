      SUBROUTINE PADTMA(COOR1,COOR2,NBNOTT,ICOUPL,DMIN)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8     COOR1(*),COOR2(*),D
      INTEGER    ICOUPL(*),NBNOTT(3)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C     BUT: CALCULER LA DISTANCE ENTRE 2 MAILLES ET DONNER LE TABLEAU
C          D'INDIRECTION ENTRE LES NUM.DES NOEUDS QUI DESCRIT LE
C          VIS A VIS ENTRE LES 2 MAILLES REALISANT CETTE DISTANCE MINI.
C                  NBNOTT(1)
C  DMIN = MIN     ( +    DIST(N1(I),N2(PERM(I)) )
C         PERM E P I=1
C     P= ENSEMBLE DES PERMUTATIONS DE (1,2,...,NBNO) ENGENDREES PAR
C        LES COUPLAGES POSSIBLES(D'APRES LEUR ORIENTATION)DES 2 MAILLES
C ARGUMENTS
C IN   COOR1  R(*): COORDONNEES DES NBNO 1ERS NOEUDS DE LA MAILLE 1
C                   POUR INO = 1,NBNO
C                   COOR1(3*(INO-1)+1)= X1(NO(INO,MA1))
C                   COOR1(3*(INO-1)+2)= X2(NO(INO,MA1))
C                   COOR1(3*(INO-1)+3)= X3(NO(INO,MA1)) ( EN 2D 0)
C IN   COOR2  R(*): COORDONNEES DES NBNO 1ERS NOEUDS DE LA MAILLE 2
C                   POUR INO = 1,NBNO
C                   COOR2(3*(INO-1)+1)= X1(NO(INO,MA2))
C                   COOR2(3*(INO-1)+2)= X2(NO(INO,MA2))
C                   COOR2(3*(INO-1)+3)= X3(NO(INO,MA2)) ( EN 2D 0)
C IN   NBNOTT I   : (1) NOMBRE DE NOEUDS SOMMETS DE LA MAILLE A EXTRAIRE
C                   (2) NOMBRE DE NOEUDS SUR LES ARRETES
C                   (3) NOMBRE DE NOEUDS INTERIEURS
C OUT  ICOUPL I(*): PERMUTATION QUI REALISE LE MIN COMPLETEE JUSQU'AU
C                   NOMBRE TOTAL DE NOEUDS<=> VIS A VIS ENTRE LES 2
C                   MAILLES
C OUT  DMIN   R   : DISTANCE ENTRE LES 2 MAILLES
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      REAL*8  X1(3),XN1(3),XN2(3),X2(3),X3(3),X4(3)
      INTEGER IPERM(106)
C --- DATA DES PERMUTATIONS REPRESENTANT LES VIS A VIS
      DATA IPERM /1,2,3,              2,1,3,
     &            1,2,3,4,5,6,        2,3,1,5,6,4,        3,1,2,6,4,5,
     &            1,3,2,6,5,4,        3,2,1,5,4,6,        2,1,3,4,6,5,
     &            1,2,3,4,5,6,7,8,    2,3,4,1,6,7,8,5,
     &            3,4,1,2,7,8,5,6,    4,1,2,3,8,5,6,7,
     &            2,1,4,3,5,8,7,6,    3,2,1,4,6,5,8,7,
     &            4,3,2,1,7,6,5,8,    1,4,3,2,8,7,6,5       /
C --- DEBUT
C --- ORIENTATION DES MAILLES
      NBSOM = NBNOTT(1)
      NBNO = NBNOTT(1)+NBNOTT(2)+NBNOTT(3)
      IF (NBSOM.EQ.2) THEN
        KDEB1 = 0
        KDEB2 = 3
        NNO = 3
        DO 1 I=1,3
          XN1(I) = COOR1(3+I)-COOR1(I)
          XN2(I) = COOR2(3+I)-COOR2(I)
1       CONTINUE
      ELSE IF (NBSOM.LE.4) THEN
        IF(NBSOM.EQ.3) THEN
          KDEB1 = 6
          KDEB2 = 24
          NNO = 6
        ELSE
          KDEB1 = 42
          KDEB2 = 74
          NNO = 8
        ENDIF
        DO 2 I=1,3
          X1(I) = COOR1(3+I)-COOR1(I)
          X2(I) = COOR1(6+I)-COOR1(3+I)
          X3(I) = COOR2(3+I)-COOR2(I)
          X4(I) = COOR2(6+I)-COOR2(3+I)
2       CONTINUE
        XN1(1) = X1(2)*X2(3)-X1(3)*X2(2)
        XN1(2) = X1(3)*X2(1)-X1(1)*X2(3)
        XN1(3) = X1(1)*X2(2)-X1(2)*X2(1)
        XN2(1) = X3(2)*X4(3)-X3(3)*X4(2)
        XN2(2) = X3(3)*X4(1)-X3(1)*X4(3)
        XN2(3) = X3(1)*X4(2)-X3(2)*X4(1)
      ELSE
       CALL U2MESS('F','MODELISA6_7')
      ENDIF
      S=0.D0
      DO 3 I = 1,3
        S= S+ XN1(I)*XN2(I)
3     CONTINUE
      IF (S.GT.0) THEN
        KDEB0 = KDEB1
      ELSE IF (S.LT.0) THEN
        KDEB0 = KDEB2
      ELSE
        CALL U2MESS('F','MODELISA6_8')
      ENDIF
      DMIN = 99999999.D0
      NBPERM = NBSOM
      IF (NBSOM.EQ.2) NBPERM = NBSOM-1
      DO 4 N = 1,NBPERM
        KDEB =KDEB0 + (N-1)*NNO
        D = 0.D0
        DO 5 J=1,NBSOM
          K = IPERM(KDEB+J)
          D = D + PADIST( 3, COOR1(3*(J-1)+1), COOR2(3*(K-1)+1) )
5       CONTINUE
        IF ( D.LT.DMIN) THEN
          DMIN = D
          IDEB = KDEB
        ENDIF
4     CONTINUE
C --- VIS A VIS DES NOEUDS DES ARRETES ET INTERIEURS
        DO 6 I = 1,NBNO
          ICOUPL(I) = IPERM(IDEB+I)
6       CONTINUE
      END
