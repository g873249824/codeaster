      SUBROUTINE TE0178(OPTION,NOMTE)
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
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
      IMPLICIT REAL*8 (A-H,O-Z)
C                          D'AMORTISSEMENT ACOUSTIQUE SUR DES ARETES
C                          D'ELEMENTS 2D
C                          OPTION : 'AMOR_ACOU'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      COMPLEX*16 RHOSZ
      CHARACTER*16 OPTION,NOMTE
      CHARACTER*2 CODRET
      CHARACTER*8 ELREFE
      REAL*8 POIDS,R,NX,NY,THETA,RHO
      INTEGER NNO,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM
      INTEGER IMATTT,K,I,J,IJ,L,LI,LJ
      INTEGER IMATE,IIMPE

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
      CALL JEVECH('PIMPEDC','L',IIMPE)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PMATTTC','E',IMATTT)

      MATER = ZI(IMATE)
      CALL RCVALA(MATER,'FLUIDE',0,' ',R8B,1,'RHO',RHO,CODRET,'FM')

      IF (ZC(IIMPE).NE. (0.D0,0.D0)) THEN
        RHOSZ = RHO/ZC(IIMPE)
      ELSE
        GO TO 50
      END IF

      DO 40 KP = 1,NPG
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)
        IF (NOMTE(3:4).EQ.'AX') THEN
          R = 0.D0
          DO 10 I = 1,NNO
            L = (KP-1)*NNO + I
            R = R + ZR(IGEOM+2*I-2)*ZR(IVF+L-1)
   10     CONTINUE
          POIDS = POIDS*R
        END IF
        IJ = IMATTT - 1
        DO 30 I = 1,NNO
          LI = IVF + (KP-1)*NNO + I - 1
          DO 20 J = 1,I
            LJ = IVF + (KP-1)*NNO + J - 1
            IJ = IJ + 1
            ZC(IJ) = ZC(IJ) + POIDS*RHOSZ*ZR(LI)*ZR(LJ)
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE
   50 CONTINUE
      END
