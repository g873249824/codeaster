      SUBROUTINE TE0171(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/01/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C     BUT: CALCUL DES MATRICES DE MASSE ELEMENTAIRES EN MECANIQUE
C          ELEMENTS  DE FLUIDE ISOPARAMETRIQUES 3D

C          OPTION : 'MASS_MECA '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES),FAMI,POUM

      INTEGER ICODRE(NBRES),KPG,SPT
      CHARACTER*16 NOMTE,OPTION
      REAL*8   VALRES(NBRES),A(2,2,27,27)
      REAL*8   DFDX(27),DFDY(27),DFDZ(27),POIDS,RHO,CELER
      INTEGER  IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER  JGANO,NNO,NDIM,KP,NPG1,IK,IJKL,I,J,L,IMATUU

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PMATUUR','E',IMATUU)

      NOMRES(1) = 'RHO'
      NOMRES(2) = 'CELE_R'
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      CALL RCVALB(FAMI,KPG,SPT,POUM,ZI(IMATE),' ','FLUIDE',0,' ',R8BID,
     &            2,NOMRES,VALRES,  ICODRE,1)
      RHO = VALRES(1)
      CELER = VALRES(2)

      DO 50 K = 1,2
        DO 40 L = 1,2
          DO 30 I = 1,NNO
            DO 20 J = 1,I
              A(K,L,I,J) = 0.D0
   20       CONTINUE
   30     CONTINUE
   40   CONTINUE
   50 CONTINUE


C    BOUCLE SUR LES POINTS DE GAUSS

      DO 80 KP = 1,NPG1

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    TERME EN -RHO*(GRAD(PHI)**2)          C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        DO 70 I = 1,NNO
          DO 60 J = 1,I
            A(2,2,I,J) = A(2,2,I,J) - POIDS*
     &                   (DFDX(I)*DFDX(J)+DFDY(I)*DFDY(J)+
     &                   DFDZ(I)*DFDZ(J))*RHO

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C    TERME EN   (P*PHI)/(CEL**2)       C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

            A(1,2,I,J) = A(1,2,I,J) + POIDS*ZR(IVF+L+I-1)*ZR(IVF+L+J-1)/
     &                   CELER/CELER
   60     CONTINUE

   70   CONTINUE

   80 CONTINUE

      DO 100 I = 1,NNO
        DO 90 J = 1,I
          A(2,1,I,J) = A(1,2,I,J)
   90   CONTINUE
  100 CONTINUE

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

      DO 140 K = 1,2
        DO 130 L = 1,2
          DO 120 I = 1,NNO
            IK = ((2*I+K-3)* (2*I+K-2))/2
            DO 110 J = 1,I
              IJKL = IK + 2* (J-1) + L
              ZR(IMATUU+IJKL-1) = A(K,L,I,J)
  110       CONTINUE
  120     CONTINUE
  130   CONTINUE
  140 CONTINUE

      END
