      SUBROUTINE TE0051(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
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

C     BUT: CALCUL DES MATRICES DE RIGIDITE ELEMENTAIRES EN THERMIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'RIGI_THER'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

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

      PARAMETER (NBRES=3)
      CHARACTER*8 NOMRES(NBRES)
      CHARACTER*2 CODRET(NBRES)
      CHARACTER*16 NOMTE,OPTION,PHENOM
      REAL*8 VALRES(NBRES),LAMBDA,THETA,FLULOC(3),FLUGLO(3)
      REAL*8 VALPAR(NBRES),LAMBOR(3),ORIG(3),DIRE(3)
      REAL*8 P(3,3),DFDX(27),DFDY(27),DFDZ(27),POIDS
      REAL*8 POINT(3),ANGL(3)
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO,NNO,KP,NPG1,I,J,IMATTT,ITEMPS
      LOGICAL ANISO,GLOBAL

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PMATTTR','E',IMATTT)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      THETA = ZR(ITEMPS+2)

      VALPAR(1) = ZR(ITEMPS)
      CALL RCCOMA(ZI(IMATE),'THER',PHENOM,CODRET)

      IF (PHENOM.EQ.'THER') THEN
        NOMRES(1) = 'LAMBDA'
        CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,1,NOMRES,VALRES,
     &              CODRET,'FM')
        LAMBDA = VALRES(1)
        ANISO = .FALSE.
      ELSE IF (PHENOM.EQ.'THER_ORTH') THEN
        NOMRES(1) = 'LAMBDA_L'
        NOMRES(2) = 'LAMBDA_T'
        NOMRES(3) = 'LAMBDA_N'
        CALL RCVALA(ZI(IMATE),PHENOM,1,'INST',VALPAR,3,NOMRES,VALRES,
     &              CODRET,'FM')
        LAMBOR(1) = VALRES(1)
        LAMBOR(2) = VALRES(2)
        LAMBOR(3) = VALRES(3)
        ANISO = .TRUE.
      ELSE
        CALL UTMESS('F','TE0051','COMPORTEMENT NON TROUVE')
      END IF

      GLOBAL = .FALSE.
      IF (ANISO) THEN
        CALL JEVECH('PCAMASS','L',ICAMAS)
        IF (ZR(ICAMAS).GT.0.D0) THEN
          GLOBAL = .TRUE.
          ANGL(1) = ZR(ICAMAS+1)*R8DGRD()
          ANGL(2) = ZR(ICAMAS+2)*R8DGRD()
          ANGL(3) = ZR(ICAMAS+3)*R8DGRD()
          CALL MATROT(ANGL,P)
        ELSE
          ALPHA = ZR(ICAMAS+1)*R8DGRD()
          BETA = ZR(ICAMAS+2)*R8DGRD()
          DIRE(1) = COS(ALPHA)*COS(BETA)
          DIRE(2) = SIN(ALPHA)*COS(BETA)
          DIRE(3) = -SIN(BETA)
          ORIG(1) = ZR(ICAMAS+4)
          ORIG(2) = ZR(ICAMAS+5)
          ORIG(3) = ZR(ICAMAS+6)
        END IF
      END IF

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 50 KP = 1,NPG1

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

        IF (.NOT.GLOBAL .AND. ANISO) THEN
          POINT(1) = 0.D0
          POINT(2) = 0.D0
          POINT(3) = 0.D0
          DO 20 NUNO = 1,NNO
            POINT(1) = POINT(1) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-3)
            POINT(2) = POINT(2) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-2)
            POINT(3) = POINT(3) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-1)
   20     CONTINUE
          CALL UTRCYL(POINT,DIRE,ORIG,P)
        END IF

        DO 40 I = 1,NNO
          IF (.NOT.ANISO) THEN
            FLUGLO(1) = LAMBDA*DFDX(I)
            FLUGLO(2) = LAMBDA*DFDY(I)
            FLUGLO(3) = LAMBDA*DFDZ(I)
          ELSE
            FLUGLO(1) = DFDX(I)
            FLUGLO(2) = DFDY(I)
            FLUGLO(3) = DFDZ(I)
            N1 = 1
            N2 = 3
            CALL UTPVGL(N1,N2,P,FLUGLO,FLULOC)
            FLULOC(1) = LAMBOR(1)*FLULOC(1)
            FLULOC(2) = LAMBOR(2)*FLULOC(2)
            FLULOC(3) = LAMBOR(3)*FLULOC(3)
            N1 = 1
            N2 = 3
            CALL UTPVLG(N1,N2,P,FLULOC,FLUGLO)
          END IF

          DO 30 J = 1,I
            IJ = (I-1)*I/2 + J
            ZR(IMATTT+IJ-1) = ZR(IMATTT+IJ-1) +
     &                        THETA*POIDS* (FLUGLO(1)*DFDX(J)+
     &                        FLUGLO(2)*DFDY(J)+FLUGLO(3)*DFDZ(J))
   30     CONTINUE
   40   CONTINUE

   50 CONTINUE

      END
