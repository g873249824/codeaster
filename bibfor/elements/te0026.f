      SUBROUTINE TE0026(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/09/2003   AUTEUR VABHHTS J.PELLET 
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

C     BUT: CALCUL DES MATRICES DE RIGIDITE_GEOMETRIQUE EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'RIGI_MECA_GE '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................


      CHARACTER*16 NOMTE,OPTION
      REAL*8 A(3,3,27,27)
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS
      INTEGER IPOIDS,IVF,IDFDE,IDFDN,IDFDK,IGEOM
      INTEGER JGANO,NNO,KP,NPG1,I,J,IMATUU

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------


      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      IDFDN = IDFDE + 1
      IDFDK = IDFDN + 1
      DO 10 I = 1,1
   10 CONTINUE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTRR','L',ICONTR)

      CALL JEVECH('PMATUUR','E',IMATUU)

      DO 50 K = 1,3
        DO 40 L = 1,3
          DO 30 I = 1,NNO
            DO 20 J = 1,I
              A(K,L,I,J) = 0.D0
   20       CONTINUE
   30     CONTINUE
   40   CONTINUE
   50 CONTINUE


C    BOUCLE SUR LES POINTS DE GAUSS

      DO 80 KP = 1,NPG1

        K = (KP-1)*NNO*3
        IC = ICONTR + (KP-1)*6
        CALL DFDM3D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     &              ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS)

        DO 70 I = 1,NNO
          DO 60 J = 1,I

            A(1,1,I,J) = A(1,1,I,J) + POIDS*
     &                   (ZR(IC)*DFDX(I)*DFDX(J)+ZR(IC+1)*DFDY(I)*
     &                   DFDY(J)+ZR(IC+2)*DFDZ(I)*DFDZ(J)+
     &                   ZR(IC+3)* (DFDX(I)*DFDY(J)+DFDY(I)*DFDX(J))+
     &                   ZR(IC+4)* (DFDZ(I)*DFDX(J)+DFDX(I)*DFDZ(J))+
     &                   ZR(IC+5)* (DFDY(I)*DFDZ(J)+DFDZ(I)*DFDY(J)))

   60     CONTINUE
   70   CONTINUE

   80 CONTINUE

      DO 100 I = 1,NNO
        DO 90 J = 1,I
          A(2,2,I,J) = A(1,1,I,J)
          A(3,3,I,J) = A(1,1,I,J)
   90   CONTINUE
  100 CONTINUE

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

      DO 140 K = 1,3
        DO 130 L = 1,3
          DO 120 I = 1,NNO
            IK = ((3*I+K-4)* (3*I+K-3))/2
            DO 110 J = 1,I
              IJKL = IK + 3* (J-1) + L
              ZR(IMATUU+IJKL-1) = A(K,L,I,J)
  110       CONTINUE
  120     CONTINUE
  130   CONTINUE
  140 CONTINUE

      END
