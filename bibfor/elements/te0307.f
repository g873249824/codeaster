      SUBROUTINE TE0307(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'RESI_THER_COEH_F'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

C-----------------------------------------------------------------------
      INTEGER ICODE ,ITEMP ,JGANO ,NBRES ,NDIM ,NNOS 
      REAL*8 THETA 
C-----------------------------------------------------------------------
      PARAMETER (NBRES=3)
      CHARACTER*8 NOMPAR(NBRES)
      REAL*8 VALPAR(NBRES),POIDS,R,Z,NX,NY,TPG
      REAL*8 COENP1
      INTEGER NNO,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM
      INTEGER ITEMPS,IVERES,I,L,LI,ICOEFH
      LOGICAL  LTEATT, LAXI



      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMP)
      CALL JEVECH('PCOEFHF','L',ICOEFH)
      CALL JEVECH('PRESIDU','E',IVERES)

      THETA = ZR(ITEMPS+2)
      DO 30 KP = 1,NPG
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)
        R = 0.D0
        Z = 0.D0
        TPG = 0.D0
        DO 10 I = 1,NNO
          L = (KP-1)*NNO + I
          R   =   R + ZR(IGEOM+2*I-2)*ZR(IVF+L-1)
          Z   =   Z + ZR(IGEOM+2*I-1)*ZR(IVF+L-1)
          TPG = TPG +   ZR(ITEMP+I-1)*ZR(IVF+L-1)
   10   CONTINUE
        IF (LAXI) POIDS = POIDS*R
        VALPAR(1) = R
        NOMPAR(1) = 'X'
        VALPAR(2) = Z
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'INST'
        VALPAR(3) = ZR(ITEMPS)
        CALL FOINTE('FM',ZK8(ICOEFH),3,NOMPAR,VALPAR,COENP1,ICODE)
CCDIR$ IVDEP
        DO 20 I = 1,NNO
          LI = IVF + (KP-1)*NNO + I - 1
          ZR(IVERES+I-1) = ZR(IVERES+I-1) -
     &                     POIDS*ZR(LI)*THETA*COENP1*TPG
   20   CONTINUE
   30 CONTINUE
      END
