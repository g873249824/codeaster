      SUBROUTINE TE0055(OPTION,NOMTE)
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
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)

C     BUT: CALCUL DU SECOND MEMBRE ELEMENTAIRE EN THERMIQUE CORRESPON-
C          DANT A UNE SOURCE VOLUMIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'CHAR_THER_SOUR_R '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE,OPTION
      REAL*8       DFDX(27),DFDY(27),DFDZ(27),POIDS
      INTEGER      IPOIDS,IVF,IDFDE,IGEOM
      INTEGER      JGANO,NNO,KP,NPG1,I,IVECTT,ISOUR



      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PSOURCR','L',ISOUR)
      CALL JEVECH('PVECTTR','E',IVECTT)

      DO 20 I = 1,NNO
        ZR(IVECTT-1+I) = 0.0D0
   20 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 40 KP = 1,NPG1

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
CCDIR$ IVDEP
        DO 30 I = 1,NNO
          ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                     POIDS*ZR(ISOUR-1+KP)*ZR(IVF+L+I-1)
   30   CONTINUE

   40 CONTINUE

      END
