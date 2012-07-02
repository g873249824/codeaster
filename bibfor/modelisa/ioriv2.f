      FUNCTION IORIV2(NUM,N,NOEUD,VECT,COOR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C.======================================================================
      IMPLICIT NONE
C
C     IORIV2  --  ORIENTATION D'UNE MAILLE PAR RAPPORT A UN VECTEUR
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NUM          IN/OUT  K*     NUMEROTATION DE LA MAILLE
C    N              IN    K*     NOMBRE DE NOEUDS DE LA MAILLE
C
C   CODE RETOUR IORIV2 : 0 SI LA MAILLE NE CONTIENT PAS LE NOEUD
C                       -1 OU 1 SINON (SELON QU'IL AIT OU NON
C                                      FALLU REORIENTER)
      INTEGER N,NUM(N)
      REAL*8 VECT(3),COOR(3,*)
C
C     DONNEES POUR TRIA3,TRIA6,TRIA7,QUAD4,QUAD8,QUAD9
C     NOMBRE DE SOMMETS EN FONCTION DU NOMBRE DE NOEUDS DE L'ELEMENT
      INTEGER NSOM(9)
C-----------------------------------------------------------------------
      INTEGER I ,I1 ,I2 ,I3 ,IORIV2 ,K ,L
      INTEGER N1 ,N2 ,N3 ,NOEUD ,NSO
      REAL*8 SCAL ,X1 ,X2 ,X3 ,XA ,XB ,XN
      REAL*8 Y1 ,Y2 ,Y3 ,YA ,YB ,YN ,Z1
      REAL*8 Z2 ,Z3 ,ZA ,ZB ,ZN,X,Y,Z
C-----------------------------------------------------------------------
      DATA NSOM /0,0,3,4,0,3,3,4,4/
C
      X(I)=COOR(1,I)
      Y(I)=COOR(2,I)
      Z(I)=COOR(3,I)
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
      NSO=NSOM(N)
C     BOUCLE SUR LES SOMMETS
      IORIV2=0
      DO 10 I=1,NSO
      IF (NUM(I).EQ.NOEUD) THEN
        I1=I
        I2=I-1
        IF (I.EQ.1) I2=NSO
        I3=I+1
        IF (I.EQ.NSO) I3=1
        N1=NUM(I1)
        N2=NUM(I2)
        N3=NUM(I3)
        X1=X(N1)
        Y1=Y(N1)
        Z1=Z(N1)
        X2=X(N2)
        Y2=Y(N2)
        Z2=Z(N2)
        X3=X(N3)
        Y3=Y(N3)
        Z3=Z(N3)
        XA=X2-X1
        YA=Y2-Y1
        ZA=Z2-Z1
        XB=X3-X1
        YB=Y3-Y1
        ZB=Z3-Z1
C     VECTEUR NORMAL AU PLAN TANGENT AU NOEUD
        XN=YA*ZB-YB*ZA
        YN=ZA*XB-ZB*XA
        ZN=XA*YB-XB*YA
        SCAL=XN*VECT(1)+YN*VECT(2)+ZN*VECT(3)
        IF (SCAL.LT.0) THEN
          IORIV2= 1
        ELSE IF (SCAL.GT.0) THEN
          IORIV2=-1
        ELSE
          CALL U2MESS('F','MODELISA4_76')
        ENDIF
      ENDIF
   10 CONTINUE
      IF (IORIV2.LT.0) THEN
C       ON PERMUTE LES SOMMETS
        K=NUM(2)
        L=NUM(NSO)
        NUM(2)=L
        NUM(NSO)=K
C       ON PERMUTE LES NOEUDS INTERMEDIAIRES
        IF (N.NE.NSO) THEN
          DO 200 I=1,NSO/2
            K=NUM(NSO+I)
            L=NUM(2*NSO+1-I)
            NUM(NSO+I)=L
            NUM(2*NSO+1-I)=K
  200     CONTINUE
        ENDIF
      ENDIF
C
      END
