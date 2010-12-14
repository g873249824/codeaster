      SUBROUTINE TE0170(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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

C     BUT: CALCUL DES MATRICES DE RIGIDITE  ELEMENTAIRES EN MECANIQUE
C          ELEMENTS DE FLUIDE ISOPARAMETRIQUES 3D

C          OPTION : 'RIGI_MECA '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES)
      CHARACTER*2 CODRET(NBRES)
      CHARACTER*16 NOMTE,OPTION
      REAL*8 VALRES(NBRES),A(2,2,27,27)
      REAL*8 B(54,54),UL(54),C(1485)
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS,RHO,CELER
      INTEGER   IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER   JGANO,NNO,KP,NPG2,IK,IJKL,I,J,IMATUU,JCRET

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------


      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION.EQ.'RAPH_MECA' .OR.
     &    OPTION.EQ.'RIGI_MECA_TANG') THEN
        CALL JEVECH('PCOMPOR','L',ICOMPO)
        IF (ZK16(ICOMPO+3).EQ.'COMP_ELAS') THEN
          CALL U2MESS('F','ELEMENTS2_90')
        END IF
      END IF

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG2,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)

      CALL JEVECH('PMATERC','L',IMATE)
      NOMRES(1) = 'RHO'
      NOMRES(2) = 'CELE_R'
      CALL RCVALA(ZI(IMATE),' ','FLUIDE',0,' ',R8BID,2,NOMRES,VALRES,
     &           CODRET, 'FM')
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

      DO 80 KP = 1,NPG2

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C      TERME EN (P**2)/ (RHO*(CEL**2))  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        DO 70 I = 1,NNO
          DO 60 J = 1,I
            A(1,1,I,J) = A(1,1,I,J) + POIDS*ZR(IVF+L+I-1)*ZR(IVF+L+J-1)/
     &                   RHO/CELER/CELER
   60     CONTINUE

   70   CONTINUE

   80 CONTINUE

C PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)

      DO 120 K = 1,2
        DO 110 L = 1,2
          DO 100 I = 1,NNO
            IK = ((2*I+K-3)* (2*I+K-2))/2
            DO 90 J = 1,I
              IJKL = IK + 2* (J-1) + L
              C(IJKL) = A(K,L,I,J)
   90       CONTINUE
  100     CONTINUE
  110   CONTINUE
  120 CONTINUE
      NNO2 = NNO*2
      NT2 = NNO* (NNO2+1)

      IF (OPTION(1:9).NE.'FULL_MECA' .AND.
     &    OPTION(1:9).NE.'RIGI_MECA') GO TO 150
      IF (OPTION.EQ.'RIGI_MECA_HYST') THEN
        CALL JEVECH('PMATUUC','E',IMATUU)
        DO 130 I = 1,NT2
          ZC(IMATUU+I-1) = DCMPLX(C(I),0.D0)
  130   CONTINUE
      ELSE
        CALL JEVECH('PMATUUR','E',IMATUU)
        DO 140 I = 1,NT2
          ZR(IMATUU+I-1) = C(I)
  140   CONTINUE
      END IF
  150 CONTINUE
      IF (OPTION(1:9).NE.'FULL_MECA' .AND.
     &    OPTION.NE.'RAPH_MECA' .AND.
     &    OPTION.NE.'FORC_NODA') GO TO 210
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      DO 160 I = 1,NNO2
        ZR(IVECTU+I-1) = 0.D0
        UL(I) = ZR(IDEPLM+I-1) + ZR(IDEPLP+I-1)
  160 CONTINUE

      NN = 0
      DO 180 N1 = 1,NNO2
        DO 170 N2 = 1,N1
          NN = NN + 1
          B(N1,N2) = C(NN)
          B(N2,N1) = C(NN)
  170   CONTINUE
  180 CONTINUE
      DO 200 N1 = 1,NNO2
        DO 190 N2 = 1,NNO2
          ZR(IVECTU+N1-1) = ZR(IVECTU+N1-1) + B(N1,N2)*UL(N2)
  190   CONTINUE
  200 CONTINUE

  210 CONTINUE
      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION.EQ.'RAPH_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = 0
      END IF

      END
