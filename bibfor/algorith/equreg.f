      SUBROUTINE EQUREG(IMATE,OPTION,COMPOR,REGULA,DIMDEF,DIMCON,DEFGEP,
     +                  NDIM,CONTP,R,DRDE)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2010   AUTEUR PELLET J.PELLET 
C TOLE CRS_1404
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ======================================================================
       IMPLICIT      NONE
       INTEGER       IMATE,DIMDEF,DIMCON,REGULA(6),NDIM
       REAL*8        DEFGEP(DIMDEF),CONTP(DIMCON),R(DIMCON)
       REAL*8        DRDE(DIMCON,DIMDEF)
       CHARACTER*16  OPTION,COMPOR(*)
C ======================================================================
C --- BUT : ROUTINE POUR LA RESOLUTION DES LOI DE COMPORTEMENTS --------
C ---       SECOND GRADIENT --------------------------------------------
C ======================================================================
C --- VARIABLES LOCALES ------------------------------------------------
C ======================================================================
      INTEGER   I,J
      REAL*8    SIGP(NDIM*NDIM*NDIM)
      REAL*8    DSDE2G(NDIM*NDIM*NDIM,NDIM*NDIM*NDIM)
C ======================================================================
C --- APPEL A LA RESOLUTION MECANIQUE DE LA LOI REGULARISANTE ----------
C ======================================================================
      CALL REG2GR(IMATE,COMPOR,NDIM,REGULA,DIMDEF,DEFGEP,SIGP,DSDE2G)
      CALL REGCGE(DIMDEF,DIMCON,REGULA,NDIM,DEFGEP,SIGP,R)
C ======================================================================
C --- CALCUL DES DERIVEES DES CONTRAINTES GENERALISEES -----------------
C ======================================================================
      CALL REGDER(DIMDEF,DIMCON,NDIM,REGULA,DSDE2G,DRDE)
C ======================================================================
C --- RECUPERATION DU VECTEUR CONTRAINTES ------------------------------
C ======================================================================
      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     +    OPTION(1:9).EQ.'FULL_MECA') THEN
         DO 40 I=1,DIMCON
            CONTP(I)=R(I)
 40      CONTINUE
      ENDIF
C ======================================================================
      END
