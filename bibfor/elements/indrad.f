      SUBROUTINE INDRAD(OPTION,NORME,MODELE,LIGREL,CHSIG1,CHSIG2,CHVAR1,
     &                  CHVAR2,CHELEM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
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
C.======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)

C      INDRAD  -- CALCUL DES INDICATEURS LOCAUX DE DECHARGE
C                 ET DE PERTE DE RADIALITE POUR LES NORMES :
C              VMIS      : SECOND INVARIANT DU TENSEUR DES CONTRAINTES
C                          DEVIATORIQUES
C              TOTAL     : SECOND INVARIANT DU TENSEUR DES CONTRAINTES
C              VMIS_CINE : SECOND INVARIANT DU DEVIATEUR DU TENSEUR
C                          SIGMA - X
C                          OU SIGMA EST LE TENSEUR DES CONTRAINTES
C                          ET X     EST LE TENSEUR DE RAPPEL
C              TOTAL_CINE: SECOND INVARIANT DU TENSEUR SIGMA - X

C    ON NOTE SIGMA2 = SIGMA(M,T+DT)
C            SIGMA1 = SIGMA(M,T)
C            DSIGMA = SIGMA2 - SIGMA1

C    A)LES INDICATEURS LOCAUX DE DECHARGE :
C      I = (NORME(SIGMA2) - NORME(SIGMA1)/NORME(SIGMA2)
C               SONT CALCULES :
C     .AUX POINTS D'INTEGRATION POUR L'OPTION  'DCHA_ELGA_SIGM'
C     .AUX NOEUDS DES ELEMENTS  POUR L'OPTION  'DCHA_ELNO_SIGM'

C    B)LES INDICATEURS LOCAUX DE PERTE DE RADIALITE :
C      I = 1 - ABS(DSIGMA : SIGMA1)/(NORME(DSIGMA)*NORME(SIGMA1))
C               SONT CALCULES :
C     .AUX POINTS D'INTEGRATION POUR L'OPTION  'RADI_ELGA_SIGM'
C     .AUX NOEUDS DES ELEMENTS  POUR L'OPTION  'RADI_ELNO_SIGM'

C   ARGUMENT        E/S  TYPE         ROLE
C    OPTION         IN     K*      OPTION DE CALCUL :
C                                    'DCHA_ELGA_SIGM'
C                                    'DCHA_ELNO_SIGM'
C                                    'RADI_ELGA_SIGM'
C                                    'RADI_ELNO_SIGM'
C    NORME          IN     K*      NORME UTILISEE :
C                                     'VMIS'
C                                     'TOTAL'
C                                     'VMIS_CINE'
C                                     'TOTAL_CINE'
C    MODELE         IN     K*      NOM DU MODELE SUR-LEQUEL ON FAIT
C                                  LE CALCUL
C    LIGREL         IN     K*      LIGREL DU MODELE
C    CHSIG1         IN     K*      NOM DU CHAMP DES CONTRAINTES AUX
C                                  POINTS D'INTEGRATION A L'INSTANT T
C    CHSIG2         IN     K*      NOM DU CHAMP DES CONTRAINTES AUX
C                                  POINTS D'INTEGRATION A L'INSTANT T+DT
C    CHVAR1         IN     K*      NOM DU CHAMP DES VARIABLES INTERNES
C                                  (ICI LE TENSEUR DE RAPPEL) AUX
C                                  POINTS D'INTEGRATION A L'INSTANT T
C    CHVAR2         IN     K*      NOM DU CHAMP DES VARIABLES INTERNES
C                                  (ICI LE TENSEUR DE RAPPEL) AUX
C                                  POINTS D'INTEGRATION A L'INSTANT T+DT
C    CHELEM         OUT    K*      NOM DU CHAMP DES INDICATEURS LOCAUX

C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
      CHARACTER*(*) OPTION,NORME,MODELE,LIGREL,CHSIG1,CHSIG2
      CHARACTER*(*) CHVAR1,CHVAR2,CHELEM
      REAL*8 SIGMA(1),SIGNO(1)
C -----  VARIABLES LOCALES
      CHARACTER*8 LPAIN(5),LPAOUT(1)
      CHARACTER*24 LCHIN(5),LCHOUT(1),CARTE
      COMPLEX*16 CBID
C.========================= DEBUT DU CODE EXECUTABLE ==================

C ---- INITIALISATIONS
C      ---------------
      ZERO = 0.0D0
      CARTE = '&&INDRAD.NORME'

C ---- CONSTITUTION D'UNE CARTE DESTINEE A RESTITUER LE NOM DE LA
C ---- NORME CHOISIE POUR LES INDICATEURS :
C      ----------------------------------
      CALL MECACT('V',CARTE,'MODELE',LIGREL,'NEUT_K24',1,'Z1',0,ZERO,
     &            CBID,NORME)

C ---- CALCUL DES INDICATEURS LOCAUX DE DECHARGE ET DE PERTE DE
C ---- RADIALITE :
C      ---------
      LPAIN(1) = 'PCONTMR'
      LCHIN(1) = CHSIG1
      LPAIN(2) = 'PCONTPR'
      LCHIN(2) = CHSIG2
      LPAIN(3) = 'PVARIMR'
      LCHIN(3) = CHVAR1
      LPAIN(4) = 'PVARIPR'
      LCHIN(4) = CHVAR2
      LPAIN(5) = 'PNEUK24'
      LCHIN(5) = CARTE
      NBIN = 5
      LPAOUT(1) = 'PVARIMO'
      LCHOUT(1) = CHELEM

      CALL CALCUL('S',OPTION,LIGREL,NBIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &            'G','OUI')

      CALL DETRSD('CHAMP_GD','&&INDRAD.NORME')
C.============================ FIN DE LA ROUTINE ======================
      END
