      SUBROUTINE TE0266(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
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
C
C     BUT:
C       CALCUL DES FLUX DE TEMPERATURE AUX POINTS DE GAUSS
C       ELEMENTS 2D AXI
C       OPTION : 'FLUX_ELGA'
C
C ---------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'

C
      INTEGER ICODRE
      INTEGER NNO,KP,I,K,ITEMPE,ITEMP,IFLUX,IHARM,NH
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER NPG,NNOS,JGANO,NDIM,KPG,SPT,J,NBCMP

      REAL*8 VALRES,FLUXR,FLUXZ,FLUXT
      REAL*8 DFDR(9),DFDZ(9),POIDS,XH,R

      CHARACTER*8 FAMI,POUM
C
C-----------------------------------------------------------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PHARMON','L',IHARM)
      NH = ZI(IHARM)
      XH = DBLE(NH)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMP)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PFLUXPG','E',IFLUX)
C
      FAMI='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      NBCMP=3
      CALL RCVALB (FAMI,KPG,SPT,POUM, ZI(IMATE),' ','THER',1,'INST',
     &             ZR(ITEMP),1,'LAMBDA', VALRES, ICODRE, 1)
C
       DO 101 KP=1,NPG
          K = (KP-1)*NNO
          CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDR,DFDZ,POIDS)
C
          R = 0.D0
          DO 102 I=1,NNO
            R = R + ZR(IGEOM+2*I-2) * ZR(IVF+K+I-1)
102       CONTINUE
C
          FLUXR = 0.0D0
          FLUXZ = 0.0D0
          FLUXT = 0.0D0
          DO 110 J=1,NNO
             FLUXR = FLUXR + ZR(ITEMPE+J-1)*DFDR(J)
             FLUXZ = FLUXZ + ZR(ITEMPE+J-1)*DFDZ(J)
             FLUXT = FLUXT - ZR(ITEMPE+J-1)*ZR(IVF+K+J-1)*XH/R
 110      CONTINUE
C
         ZR(IFLUX+(KP-1)*NBCMP-1+1) = -VALRES*FLUXR
         ZR(IFLUX+(KP-1)*NBCMP-1+2) = -VALRES*FLUXZ
         ZR(IFLUX+(KP-1)*NBCMP-1+3) = -VALRES*FLUXT
C
 101  CONTINUE
C
      END
