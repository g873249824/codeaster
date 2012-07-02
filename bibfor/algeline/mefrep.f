      SUBROUTINE MEFREP(NBZ,NBMOD,NBCYL,NBGRP,NUMGRP,Z,FREQ0,RHO,VISC,
     &                  RINT,PHIX,PHIY,DCENT,MATMA)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER NBZ,NBMOD,NBCYL,NBGRP,NUMGRP(*)
      REAL*8  Z(*),FREQ0(*),RHO(*),VISC(*),RINT(*),PHIX(*),PHIY(*),
     &        DCENT(*),MATMA(*)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C ----------------------------------------------------------------------
C     CALCUL DE L'AMORTISSEMENT AJOUTE DU AU FLUIDE AU REPOS
C     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST
C ----------------------------------------------------------------------
C     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
C     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
C     DE TUBES SOUS ECOULEMENT AXIAL"
C-----------------------------------------------------------------------
C IN  : NBZ    : NOMBRE DE POINTS DE DISCRETISATION
C IN  : NBMOD  : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
C IN  : NBCYL  : NOMBRE DE CYLINDRES DU FAISCEAU
C IN  : NBGRP  : NOMBRE DE GROUPES D'EQUIVALENCE
C IN  : NUMGRP : INDICES DES GROUPES D'EQUIVALENCE
C IN  : Z      : COORDONNEES 'Z' DES POINTS DE DISCRETISATION DANS LE
C                REPERE AXIAL
C IN  : FREQ0  : FREQUENCES MODALES EN FLUIDE AU REPOS AVANT PRISE EN
C                COMPTE DE L'AMORTISSEMENT FLUIDE AU REPOS
C IN  : RHO    : MASSE VOLUMIQUE DU FLUIDE AUX POINTS DE DISCRETISATION
C IN  : VISC   : VISCOSITE DU FLUIDE AUX POINTS DE DISCRETISATION
C IN  : RINT   : RAYONS DES CYLINDRES
C IN  : PHIX   : DEFORMEES MODALES INTERPOLEES DANS LE PLAN AXIAL
C IN  : PHIY   : DEFORMEES MODALES INTERPOLEES DANS LE PLAN AXIAL
C IN  : VNXX   : COEFFICIENT INTERVENANT DANS L EXPRESSION DES EFFORTS
C                VISQUEUX NORMAUX SUIVANT XX
C IN  : VNXY   : COEFFICIENT INTERVENANT DANS L EXPRESSION DES EFFORTS
C                VISQUEUX NORMAUX SUIVANT XY
C IN  : VNYX   : COEFFICIENT INTERVENANT DANS L EXPRESSION DES EFFORTS
C                VISQUEUX NORMAUX SUIVANT YX
C IN  : VNYY   : COEFFICIENT INTERVENANT DANS L EXPRESSION DES EFFORTS
C                VISQUEUX NORMAUX SUIVANT YY
C IN/ : MATMA  : VECTEUR CONTENANT LES MATRICES MODALES, MASSE,RIGIDITE,
C OUT            AMORTISSEMENT - EN SORTIE LES AMORTISSEMENTS MODAUX
C                SONT PERTURBES PAR LA CONTRIBUTION DU FLUIDE AU REPOS
C-----------------------------------------------------------------------
C ----------------------------------------------------------------------
      INTEGER      IMOD,IGRP,JGRP,ICYL,NCYL
      REAL*8       AMOR,RAYO
      REAL*8       MEFIN1
C ----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER IFCT ,IPPXX ,IPPXY ,IPPYX ,IPPYY ,IVNXX ,IVNXY 
      INTEGER IVNYX ,IVNYY ,NZ 
      REAL*8 PI ,R8PI 
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C
C --- DECALAGES DES TABLEAUX DE COEFFICIENTS ET DES MATRICES EN AIR
C --- DANS LE VECTEUR DCENT
C
      IPPXX = NBCYL + NBCYL + NBCYL*NBCYL + NBCYL*NBCYL
      IPPXY = IPPXX + NBCYL*NBGRP
      IPPYX = IPPXY + NBCYL*NBGRP
      IPPYY = IPPYX + NBCYL*NBGRP
      IVNXX = IPPYY + NBCYL*NBGRP
      IVNXY = IVNXX + NBCYL*NBGRP
      IVNYX = IVNXY + NBCYL*NBGRP
      IVNYY = IVNYX + NBCYL*NBGRP
C
      CALL WKVECT('&&MEFREP.TEMP.FCT','V V R',NBZ,IFCT)
C
      PI = R8PI()
C
      DO 1 NZ = 1,NBZ
         ZR(IFCT+NZ-1) = RHO(NZ)*SQRT(VISC(NZ))
1     CONTINUE
C
C
      DO 2 IMOD = 1,NBMOD
         AMOR = 0.D0
         DO 21 IGRP = 1,NBGRP
            DO 211 ICYL = 1,NBCYL
               IF (NUMGRP(ICYL).EQ.IGRP) THEN
                   RAYO = RINT(ICYL)
               ENDIF
211         CONTINUE
            DO 212 JGRP = 1,NBGRP
               NCYL = 0
               IF (IGRP.EQ.JGRP) THEN
                 DO 2121 ICYL = 1,NBCYL
                  IF (NUMGRP(ICYL).EQ.IGRP) THEN
                     NCYL = NCYL-1
                  ENDIF
2121             CONTINUE
               ENDIF
C
              AMOR = AMOR-RAYO*
     &  ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &      MEFIN1(NBZ,NBGRP,IMOD,IGRP,IMOD,JGRP,Z,PHIX,PHIX,ZR(IFCT)) +
     &      DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &      MEFIN1(NBZ,NBGRP,IMOD,IGRP,IMOD,JGRP,Z,PHIX,PHIY,ZR(IFCT)) +
     &      DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &      MEFIN1(NBZ,NBGRP,IMOD,IGRP,IMOD,JGRP,Z,PHIY,PHIX,ZR(IFCT)) +
     &    ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &      MEFIN1(NBZ,NBGRP,IMOD,IGRP,IMOD,JGRP,Z,PHIY,PHIY,ZR(IFCT)) )
212         CONTINUE
21       CONTINUE
         AMOR = 4.D0*PI*SQRT(PI*FREQ0(IMOD))*AMOR
         MATMA(2*NBMOD+IMOD) = MATMA(2*NBMOD+IMOD)+AMOR
C
2     CONTINUE
C
      CALL JEDETC('V','&&MEFREP',1)
      CALL JEDEMA()
      END
