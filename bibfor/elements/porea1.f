      SUBROUTINE POREA1(NNO,NC,DEPLM,DEPLP,GEOM,
     &                  GAMMA,VECTEU,PGL,XL,ANGP)
      IMPLICIT    NONE
      INCLUDE 'jeveux.h'
      INTEGER     NNO,NC
      REAL*8      DEPLM(NNO*NC),DEPLP(NNO*NC),GEOM(3,NNO),GAMMA

      REAL*8      PGL(3,3),XL,ANGP(3)
      LOGICAL     VECTEU
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/04/2013   AUTEUR FLEJOU J-L.FLEJOU 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C     CALCUL DE LA MATRICE DE PASSAGE GLOBALE/LOCALE EN TENANT COMPTE
C     DE LA GEOMETRIE REACTUALISEE POUR LES POUTRES AINSI QUE LA
C     LONGUEUR DE LA POUTRE
C     POUR LES OPTIONS FULL_MECA RAPH_MECA ET RIGI_MECA_TANG
C
C --- ------------------------------------------------------------------
C
C IN  NNO    : NOMBRE DE NOEUDS
C IN  NC     : NOMBRE DE COMPOSANTE DU CHAMP DE DEPLACEMENTS
C IN  DEPLM  : DEPLACEMENT AU TEMPS -
C IN  DEPLP  : INCREMENT DE DEPLACEMENT AU TEMPS +
C IN  GEOM   : COORDONNEES DES NOEUDS
C IN  GAMMA  : ANGLE DE VRILLE AU TEMPS -
C IN  VECTEU : TRUE SI FULL_MECA OU RAPH_MECA
C OUT PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
C OUT XL     : LONGUEUR DE L'ELEMENT
C OUT ANGP   : ANGLES NAUTIQUES ACTUALISEE
C              ATTENTION ANGP(3) EST DIFFERENT DE GAMMA1 QUI A SERVIT
C              POUR CALCUL PGL
C --- ------------------------------------------------------------------
C
C     VARIABLES LOCALES
      INTEGER  I,IBID
      REAL*8   UTG(14),XUG(6),XD(3),XL2,ALFA1,BETA1,ALFA0,BETA0
      REAL*8   XUGM(6),DGAMMA,TET1,TET2,GAMMA1,DDOT,XDM(3)
      REAL*8   ANG1(3),R8RDDG
C
      INTEGER IADZI,IAZK24
      CHARACTER*24 VALKM(2)
      REAL*8       VALRM
C
      CALL ASSERT(NNO.EQ.2)
C
C     CALCUL DU VECTEUR XLOCAL AU TEMPS T-
      DO 20 I = 1,3
         XUG(I)   = DEPLM(I)    + GEOM(I,1)
         XUG(I+3) = DEPLM(I+NC) + GEOM(I,2)
20    CONTINUE
      CALL VDIFF(3,XUG(4),XUG(1),XD)
C     CALCUL DES DEUX PREMIERS ANGLES NAUTIQUES AU TEMPS T-
      CALL ANGVX(XD,ALFA0,BETA0)
C
C     DEPLACEMENT TOTAL A T+
      DO 110 I = 1,NNO*NC
         UTG(I) = DEPLM(I) + DEPLP(I)
110    CONTINUE
C     CALCUL DU VECTEUR XLOCAL AU TEMPS T+
      DO 120 I = 1,3
         XUG(I)   = UTG(I)    + GEOM(I,1)
         XUG(I+3) = UTG(I+NC) + GEOM(I,2)
120   CONTINUE
      CALL VDIFF(3,XUG(4),XUG(1),XD)
C     CALCUL DES DEUX PREMIERS ANGLES NAUTIQUES AU TEMPS T+
      CALL ANGVX(XD,ALFA1,BETA1)
C     SI DIFF(ANGLE) > PI/8
      IF ( ABS(ALFA0 - ALFA1).GT. 0.3927D+00 ) THEN
         CALL TECAEL(IADZI,IAZK24)
         VALKM(1) = ZK24(IAZK24+3-1)
         VALKM(2) = 'ALPHA'
         VALRM    = (ALFA0 - ALFA1)*R8RDDG()
         CALL U2MESG('A','ELEMENTS_38',2,VALKM,0,IBID,1,VALRM)
      ENDIF
      IF ( ABS(BETA0 - BETA1).GT. 0.3927D+00 ) THEN
         CALL TECAEL(IADZI,IAZK24)
         VALKM(1) = ZK24(IAZK24+3-1)
         VALKM(2) = 'BETA'
         VALRM    = (BETA0 - BETA1)*R8RDDG()
         CALL U2MESG('A','ELEMENTS_38',2,VALKM,0,IBID,1,VALRM)
      ENDIF
C
C     LONGUEUR DE L'ELEMENT AU TEMPS T+
      XL2=DDOT(3,XD,1,XD,1)
      XL = SQRT(XL2)
      IF (VECTEU) THEN
C        CALCUL DU VECTEUR XLOCAL AU TEMPS T-
         DO 130 I = 1,3
            XUGM(I  ) = GEOM(I,1) + DEPLM(I)
            XUGM(I+3) = GEOM(I,2) + DEPLM(NC+I)
130      CONTINUE
         CALL VDIFF(3,XUGM(4),XUGM(1),XDM)
C        MISE A JOUR DU 3EME ANGLE NAUTIQUE AU TEMPS T+
         CALL GAREAC(XDM,XD,DGAMMA)
C        SI DGAMMA > PI/8
         IF ( ABS(DGAMMA).GT. 0.3927D+00 ) THEN
            CALL TECAEL(IADZI,IAZK24)
            VALKM(1) = ZK24(IAZK24+3-1)
            VALKM(2) = 'GAMMA'
            VALRM    = DGAMMA*R8RDDG()
            CALL U2MESG('A','ELEMENTS_38',2,VALKM,0,IBID,1,VALRM)
         ENDIF
      ELSE
         DGAMMA = 0.D0
      ENDIF
C
      TET1   = DDOT(3,UTG(4),1,XD,1)
      TET2   = DDOT(3,UTG(NC+4),1,XD,1)
      TET1   = TET1/XL
      TET2   = TET2/XL
      GAMMA1 = GAMMA + DGAMMA + (TET1+TET2)/2.D0
C     SAUVEGARDE DES ANGLES NAUTIQUES
      ANGP(1) = ALFA1
      ANGP(2) = BETA1
      ANGP(3) = GAMMA + DGAMMA
C     MATRICE DE PASSAGE GLOBAL -> LOCAL
      ANG1(1) = ALFA1
      ANG1(2) = BETA1
      ANG1(3) = GAMMA1
      CALL MATROT ( ANG1 , PGL )
      END
