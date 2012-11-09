      SUBROUTINE TE0251(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES MATRICES TANGENTES ELEMENTAIRES
C                          OPTION : 'MTAN_THER_FLUXNL'
C                          ELEMENTS DE FACE 2D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT

C ......................................................................

      REAL*8 POIDS,R,NX,NY,THETA,ALPHAP,RBID,TPG
      REAL*8 MRIGT(9,9),COORSE(18)
      INTEGER NNO,NNOS,NDIM,KP,NPG,IPOIDS,IVF,IDFDE,JGANO
      INTEGER IMATTT,I,J,IJ,L,LI,LJ,IBID
      INTEGER C(6,9),ISE,NSE,NNOP2
      INTEGER IGEOM,IFLUX,ITEMPI,ITEMPS
      LOGICAL  LTEATT, LAXI
      CHARACTER*8        ELREFE, ALIAS8


      CALL ELREF1(ELREFE)
C
      IF ( LTEATT(' ','LUMPE','OUI')) THEN
         CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)
         IF (ALIAS8(6:8).EQ.'SE3')  ELREFE='SE2'
      END IF
C
      CALL ELREF4(ELREFE,'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,
     +            IVF,IDFDE,JGANO)

      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PFLUXNL','L',IFLUX)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)

      IF (ZK8(IFLUX) (1:7).EQ.'&FOZERO') GO TO 120
      THETA = ZR(ITEMPS+2)

      CALL CONNEC(NOMTE,NSE,NNOP2,C)

      DO 20 I = 1,NNOP2
        DO 10 J = 1,NNOP2
          MRIGT(I,J) = 0.D0
   10   CONTINUE
   20 CONTINUE

C --- CALCUL ISO-P2 : BOUCLE SUR LES SOUS-ELEMENTS -------

      DO 90 ISE = 1,NSE

        DO 40 I = 1,NNO
          DO 30 J = 1,2
            COORSE(2* (I-1)+J) = ZR(IGEOM-1+2* (C(ISE,I)-1)+J)
   30     CONTINUE
   40   CONTINUE

        DO 80 KP = 1,NPG
          CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,COORSE,NX,NY,POIDS)
          R = 0.D0
          TPG = 0.D0
          DO 50 I = 1,NNO
            L = (KP-1)*NNO + I
            R = R + COORSE(2* (I-1)+1)*ZR(IVF+L-1)
            TPG = TPG + ZR(ITEMPI-1+C(ISE,I))*ZR(IVF+L-1)
   50     CONTINUE
          IF (LAXI) POIDS = POIDS*R
          CALL FODERI(ZK8(IFLUX),TPG,RBID,ALPHAP)
          IJ = IMATTT - 1
          DO 70 I = 1,NNO
            LI = IVF + (KP-1)*NNO + I - 1
CCDIR$ IVDEP
            DO 60 J = 1,I
              LJ = IVF + (KP-1)*NNO + J - 1
              IJ = IJ + 1
              MRIGT(C(ISE,I),C(ISE,J)) = MRIGT(C(ISE,I),C(ISE,J)) -
     &                                   POIDS*THETA*ALPHAP*ZR(LI)*
     &                                   ZR(LJ)
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE
   90 CONTINUE

C MISE SOUS FORME DE VECTEUR

      IJ = IMATTT - 1
      DO 110 I = 1,NNOP2
        DO 100 J = 1,I
          IJ = IJ + 1
          ZR(IJ) = MRIGT(I,J)
  100   CONTINUE
  110 CONTINUE
  120 CONTINUE
      END
