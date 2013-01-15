      SUBROUTINE TE0007 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DE L'OPTION FORC_NODA
C                       EN 2D POUR ELEMENTS NON LOCAUX A GRAD. DE DEF.
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
      REAL*8             NHARM, BSIGM(18),GEO(18)
      INTEGER            NBSIGM
      LOGICAL            LTEATT
C DEB ------------------------------------------------------------------
C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
C-----------------------------------------------------------------------
      INTEGER I ,ICOMP ,ICONTM ,IDEPL ,IDFDE ,IGEOM ,IPOIDS
      INTEGER IRETC ,IRETD ,IVECTU ,IVF ,JGANO ,KP ,KU
      INTEGER N ,NBSIG ,NDIM ,NDIMSI ,NNO ,NNOS ,NPG

      REAL*8 ZERO
C-----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C --- INITIALISATIONS :
C     -----------------
      ZERO  = 0.0D0
      NHARM = ZERO

C - SPECIFICATION DE LA DIMENSION

      IF (LTEATT(' ','AXIS','OUI')) THEN
        NDIM = 2
      ELSE IF (LTEATT(' ','C_PLAN','OUI')) THEN
        NDIM = 2
      ELSE IF (LTEATT(' ','D_PLAN','OUI')) THEN
        NDIM = 2
      ENDIF

      NDIMSI = NDIM*2
C
C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM()
C
C ---- PARAMETRES EN ENTREE
C      --------------------
C ----     COORDONNEES DES CONNECTIVITES
      CALL JEVECH('PGEOMER','L',IGEOM)
C ----     CONTRAINTES AUX POINTS D'INTEGRATION
      CALL JEVECH('PCONTMR','L',ICONTM)
C
C         CHAMPS POUR LA REACTUALISATION DE LA GEOMETRIE
      DO 90 I = 1,NDIM*NNO
         GEO(I)  =ZR(IGEOM-1+I)
90    CONTINUE
      CALL TECACH('ONN','PDEPLMR','L',1,IDEPL,IRETD)
      CALL TECACH('ONN','PCOMPOR','L',1,ICOMP,IRETC)
      IF ((IRETD.EQ.0).AND.(IRETC.EQ.0)) THEN
         IF (ZK16(ICOMP+2)(1:6).NE.'PETIT ') THEN
            DO 80 I = 1,NDIM*NNO
               GEO(I)  =GEO(I)  + ZR(IDEPL-1+I)
80          CONTINUE
         ENDIF
      ENDIF
C ---- PARAMETRES EN SORTIE
C      --------------------
C ----     VECTEUR DES FORCES INTERNES (BT*SIGMA)
      CALL JEVECH('PVECTUR','E',IVECTU)
C

C ---- CALCUL DU VECTEUR DES FORCES INTERNES (BT*SIGMA) :
C      --------------------------------------------------
      CALL BSIGMC (  NNO, NDIM, NBSIG, NPG, IPOIDS, IVF, IDFDE,
     +              ZR(IGEOM), NHARM, ZR(ICONTM), BSIGM )
C
C ---- AFFECTATION DU VECTEUR EN SORTIE :
C      ----------------------------------
       DO 10 N=1,NNOS
         DO 20 I=1,NDIM
               KU = (NDIMSI + NDIM)*(N-1) + I
               KP = NDIM*(N-1) + I
           ZR(IVECTU+KU-1) = BSIGM(KP)
20       CONTINUE
         DO 30 I=1,NDIMSI
               KU = (NDIMSI + NDIM)*(N-1) + I + NDIM
               ZR(IVECTU+KU-1) = 0.D0
30       CONTINUE
10     CONTINUE
       DO 40 N=NNOS+1,NNO
         DO 50 I=1,NDIM
           KU = (NDIMSI + NDIM)*NNOS + NDIM*(N-NNOS-1) + I
           KP = NDIM*(N-1) + I
           ZR(IVECTU+KU-1) = BSIGM(KP)
50       CONTINUE
40     CONTINUE
C
C FIN ------------------------------------------------------------------
      END
