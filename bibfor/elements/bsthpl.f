      SUBROUTINE BSTHPL ( NOMTE, BSIGTH, INDITH )
      IMPLICIT  NONE
      INCLUDE 'jeveux.h'
      REAL*8                     BSIGTH(24)
      LOGICAL                            INDITH
      CHARACTER*8         NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/10/2012   AUTEUR SELLENET N.SELLENET 
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
C      CALCUL DU BSIGMA POUR LES CONTRAINTES THERMIQUES
C      (I.E. BT*D*ALPHA(T-TREF)) POUR LES ELEMENTS
C                                DE PLAQUE (DKT,DKQ,DST,DSQ,Q4G)
C     ------------------------------------------------------------------
C     IN  NOMTE  : NOM DU TYPE D'ELEMENT
C     OUT BSIGTH : BT*SIGMA POUR LES CONTRAINTES THERMIQUES
C     OUT INDITH : LOGICAL = .TRUE.  YA DES DEFORMATIONS THERMIQUES
C                          = .FALSE. SINON
C     ------------------------------------------------------------------
      INTEGER       I, JGEOM, NNO, IRET
      REAL*8        PGL(3,3), XYZL(3,4),
     &              SIGTH(32), ZERO
      CHARACTER*16  TYPELE
C     ------------------------------------------------------------------
C
C --- INITIALISATIONS :
C     ---------------
      ZERO = 0.0D0
      INDITH = .FALSE.
      TYPELE = NOMTE
C
      DO 10 I = 1, 24
        BSIGTH(I) = ZERO
  10  CONTINUE
C

C --- RECUPERATION DES COORDONNEES DES NOEUDS DE L'ELEMENT :
C     ----------------------------------------------------
      CALL JEVECH('PGEOMER','L',JGEOM)
C
      IF (NOMTE.EQ.'MEDKTR3 ' .OR. 
     &    NOMTE.EQ.'MEDSTR3 ' .OR.
     &    NOMTE.EQ.'MEDKTG3 ' .OR.
     &    NOMTE.EQ.'MET3TR3 ' .OR.
     &    NOMTE.EQ.'MET3GG3') THEN
         NNO = 3
         CALL DXTPGL(ZR(JGEOM),PGL)
      ELSE IF (NOMTE.EQ.'MEDKQU4 ' .OR.
     &         NOMTE.EQ.'MEDKQG4 ' .OR.
     &         NOMTE.EQ.'MEDSQU4 ' .OR.
     &         NOMTE.EQ.'MEQ4QU4 ' .OR.
     &         NOMTE.EQ.'MEQ4GG4 ' ) THEN
         NNO = 4
         CALL DXQPGL(ZR(JGEOM),PGL,'S',IRET)
      ELSE
         CALL U2MESK('F','ELEMENTS_14',1,NOMTE)
      END IF
C
C --- DETERMINATION DES COORDONNEES LOCALES XYZL DES NOEUDS
C --- DE L'ELEMENT :
C     ------------
      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)
C
C --- CALCUL DES EFFORTS GENERALISES D'ORIGNIE THERMIQUE AUX POINTS
C --- D'INTEGRATION :
C     -------------
      CALL DXEFGT(PGL,SIGTH)
C
C --- CALCUL DE BT*SIGTH :
C     ------------------
      CALL DXBSIG(TYPELE,XYZL,PGL,SIGTH,BSIGTH)
C
C
      END
