      SUBROUTINE TE0257(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)

C     BUT: CALCUL DES MATRICES DE MASSE  ELEMENTAIRES EN MECANIQUE
C          ELEMENTS 1D DE COUPLAGE ACOUSTICO-MECANIQUE

C          OPTION : 'MASS_MECA '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      CHARACTER*2 CODRET
      CHARACTER*16 NOMTE,OPTION
      REAL*8 A(3,3,3,3),NX,NY,RHO,NORM(2),POIDS
      INTEGER IGEOM,IMATE,I,J,K,L,IK,IJKL,LDEC,KCO,INO,JNO
      INTEGER NNO,NPG,KP,NDIM,NNOS,JGANO
      INTEGER IPOIDS,IVF,IDFDE,IMATUU

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PMATUUR','E',IMATUU)

      CALL RCVALA(ZI(IMATE),' ','FLUIDE',0,' ',R8B,1,'RHO',RHO,
     &             CODRET,'FM')

C     INITIALISATION DE LA MATRICE

      DO 40 K = 1,3
        DO 30 L = 1,3
          DO 20 I = 1,NNO
            DO 10 J = 1,I
              A(K,L,I,J) = 0.D0
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 90 KP = 1,NPG
        LDEC = (KP-1)*NNO

        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)

        NORM(1) = NX
        NORM(2) = NY

        IF (NOMTE(3:4).EQ.'AX') THEN
          R = 0.D0
          DO 50 I = 1,NNO
            R = R + ZR(IGEOM+2* (I-1))*ZR(IVF+LDEC+I-1)
   50     CONTINUE
          POIDS = POIDS*R
        END IF

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C       CALCUL DU TERME PHI*(U.N DS)       C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        DO 80 INO = 1,NNO
          DO 70 JNO = 1,INO
            DO 60 KCO = 1,2

              A(KCO,3,INO,JNO) = A(KCO,3,INO,JNO) +
     &                           POIDS*NORM(KCO)*RHO*ZR(IVF+LDEC+INO-1)*
     &                           ZR(IVF+LDEC+JNO-1)




   60       CONTINUE
   70     CONTINUE
   80   CONTINUE

   90 CONTINUE

      DO 120 INO = 1,NNO
        DO 110 JNO = 1,INO
          DO 100 KCO = 1,2
            A(3,KCO,INO,JNO) = A(KCO,3,INO,JNO)
  100     CONTINUE
  110   CONTINUE
  120 CONTINUE


C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

      IJKL = 0
      IK = 0
      DO 160 K = 1,3
        DO 150 L = 1,3
          DO 140 I = 1,NNO
            IK = ((3*I+K-4)* (3*I+K-3))/2
            DO 130 J = 1,I
              IJKL = IK + 3* (J-1) + L
              ZR(IMATUU+IJKL-1) = A(K,L,I,J)




  130       CONTINUE
  140     CONTINUE
  150   CONTINUE
  160 CONTINUE

      END
