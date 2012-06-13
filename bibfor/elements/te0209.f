      SUBROUTINE TE0209(OPTION,NOMTE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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

C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_PARO_R'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER NNO,NNOS,JGANO,NDIM,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM
      INTEGER IVECTT,I,L,LI,IHECHP,ITEMPS,ITEMP,NBELR
      REAL*8 POIDS,POIDS1,POIDS2,COEFH
      REAL*8 R1,R2,NX,NY,TPG,THETA
      CHARACTER*8 LIREFE(2)
      LOGICAL  LTEATT, LAXI
C     ------------------------------------------------------------------

      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.

      CALL ELREF2(NOMTE,2,LIREFE,NBELR)
      CALL ASSERT(NBELR.EQ.2)
      CALL ELREF4(LIREFE(2),'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,
     &            JGANO)


      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PHECHPR','L',IHECHP)
      COEFH = ZR(IHECHP)
      CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PVECTTR','E',IVECTT)

      THETA = ZR(ITEMPS+2)

      DO 30 KP = 1,NPG
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS1)
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM+2*NNO),NX,
     &              NY,POIDS2)
        R1 = 0.D0
        R2 = 0.D0
        TPG = 0.D0
        DO 10 I = 1,NNO
          L = (KP-1)*NNO + I
          R1 = R1 + ZR(IGEOM+2*I-2)*ZR(IVF+L-1)
          R2 = R2 + ZR(IGEOM+2* (NNO+I)-2)*ZR(IVF+L-1)
          TPG = TPG + (ZR(ITEMP+NNO+I-1)-ZR(ITEMP+I-1))*ZR(IVF+L-1)
   10   CONTINUE
        IF (LAXI) THEN
          POIDS1 = POIDS1*R1
          POIDS2 = POIDS2*R2
        END IF
        POIDS = (POIDS1+POIDS2)/2
CCDIR$ IVDEP
        DO 20 I = 1,NNO
          LI = IVF + (KP-1)*NNO + I - 1
          ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                     POIDS*ZR(LI)*COEFH* (1.0D0-THETA)*TPG
          ZR(IVECTT+I-1+NNO) = ZR(IVECTT+I-1+NNO) -
     &                         POIDS*ZR(LI)*COEFH* (1.0D0-THETA)*TPG
   20   CONTINUE
   30 CONTINUE
      END
