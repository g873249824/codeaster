       SUBROUTINE TE0447 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
       IMPLICIT NONE
      INCLUDE 'jeveux.h'

       CHARACTER*16        OPTION , NOMTE


C     BUT: CALCUL DES DEFORMATIONS AUX POINTS DE GAUSS
C          DES ELEMENTS INCOMPRESSIBLES 2D

C          OPTION : 'EPSI_ELGA'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      LOGICAL       AXI, GRAND
      INTEGER       KPG,KSIG, NNO, NNOS, NPG, IPOIDS, IVF,  NDIM, NCMP
      INTEGER       IDFDE, IDEPL, IGEOM, IDEFO, KK, JGANO
      REAL*8        POIDS, DFDI(81), F(3,3), R, EPS(6), VPG(36)
      REAL*8        TMP
C ......................................................................

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      NCMP = 2*NDIM
      AXI   = NOMTE(3:4).EQ.'AX'
      GRAND = .FALSE.
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PDEFOPG','E',IDEFO)

      CALL R8INIR(6,0.D0,EPS,1)
      CALL R8INIR(36,0.D0,VPG,1)

      DO 10 KPG = 1, NPG

        CALL NMGEOM(NDIM,NNO,AXI,GRAND,ZR(IGEOM),KPG,IPOIDS,IVF,IDFDE,
     &              ZR(IDEPL),.TRUE.,POIDS,DFDI,F,EPS,R)

C       RECUPERATION DE LA DEFORMATION
        DO 20 KSIG=1,NCMP
          IF (KSIG.LE.3) THEN
            TMP=1.D0
          ELSE
            TMP = SQRT(2.D0)
          ENDIF
          VPG(NCMP*(KPG-1)+KSIG)=EPS(KSIG)/TMP
 20     CONTINUE
 10   CONTINUE

C     AFFECTATION DU VECTEUR EN SORTIE
      DO 30 KK = 1,NPG*NCMP
          ZR(IDEFO+KK-1)= VPG(KK)
 30   CONTINUE
C
      END
