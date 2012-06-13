      SUBROUTINE TE0365(OPTION,NOMTE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16  OPTION,NOMTE
C
C ----------------------------------------------------------------------
C
C  CALCUL DES SECONDS MEMBRES DE CONTACT ET DE FROTTEMENT DE COULOMB STD
C        AVEC LA METHODE CONTINUE
C
C  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
C           'CHAR_MECA_FROT' (CALCUL DU SECOND MEMBRE DE
C                              FROTTEMENT STANDARD )
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C
C
C
      INTEGER      IDDL
      INTEGER      NNE,NNM,NNL
      INTEGER      NDDL,NDIM,NBCPS,NBDM
      INTEGER      JVECT
      INTEGER      IRESOF
      INTEGER      NDEXFR
      REAL*8       NORM(3),TAU1(3),TAU2(3)
      REAL*8       MPROJT(3,3)
      REAL*8       RESE(3),NRESE
      REAL*8       WPG,JACOBI
      REAL*8       COEFFF,LAMBDA,LAMBDS
      REAL*8       COEFAC,COEFAF
      REAL*8       JEUSUP
      REAL*8       DLAGRC,DLAGRF(2)
      REAL*8       JEU,DJEU(3),DJEUT(3)
      REAL*8       PRFUSU,CWEAR
      CHARACTER*8  TYPMAE,TYPMAM
      CHARACTER*9  PHASEP
      LOGICAL      LAXIS,LELTF
      LOGICAL      LPENAC,LPENAF
      LOGICAL      LOPTF,LUSURE,LDYNA,LFOVIT,LCONT
      LOGICAL      LADHE
      LOGICAL      DEBUG
      REAL*8       FFE(9),FFM(9),FFL(9)
C
      REAL*8       VECTCC(9)
      REAL*8       VECTFF(18)
      REAL*8       VECTEE(27),VECTMM(27)
      REAL*8       VTMP(81)
C
      CHARACTER*24 TYPELT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL VECINI(81,0.D0,VTMP  )
      CALL VECINI( 9,0.D0,VECTCC)
      CALL VECINI(18,0.D0,VECTFF)
      CALL VECINI(27,0.D0,VECTEE)
      CALL VECINI(27,0.D0,VECTMM)
      DEBUG  = .FALSE.
C
C --- TYPE DE MAILLE DE CONTACT
C
      TYPELT = 'POIN_ELEM'
      LOPTF  = OPTION.EQ.'CHAR_MECA_FROT'
C
C --- PREPARATION DES CALCULS - INFOS SUR LA MAILLE DE CONTACT
C
      CALL MMELEM(NOMTE ,NDIM  ,NDDL  ,TYPMAE,NNE   ,
     &            TYPMAM,NNM   ,NNL   ,NBCPS ,NBDM  ,
     &            LAXIS ,LELTF )
C
C --- PREPARATION DES CALCULS - LECTURE DES COEFFICIENTS
C
      CALL MMMLCF(COEFFF,COEFAC,COEFAF,LPENAC,LPENAF,
     &            IRESOF,LAMBDS)
C
C --- PREPARATION DES CALCULS - LECTURE FONCTIONNALITES AVANCEES
C
      CALL MMMLAV(LUSURE,LDYNA ,LFOVIT,PRFUSU,CWEAR ,
     &            JEUSUP,NDEXFR,COEFAC,COEFAF)
C
C --- PREPARATION DES DONNEES
C
      IF (TYPELT.EQ.'POIN_ELEM') THEN
C
C ----- CALCUL DES QUANTITES
C
        CALL MMVPPE(TYPMAE,TYPMAM,NDIM  ,NNE   ,NNM   ,
     &              NNL   ,NBDM  ,LAXIS ,LDYNA ,LFOVIT,
     &              PRFUSU,JEUSUP,FFE   ,FFM   ,FFL   ,
     &              NORM  ,TAU1  ,TAU2  ,MPROJT,JACOBI,
     &              WPG   ,DLAGRC,DLAGRF,JEU   ,DJEU  ,
     &              DJEUT )
C
C ----- CHOIX DU LAGRANGIEN DE CONTACT
C
        CALL MMLAGC(LAMBDS,DLAGRC,IRESOF,LAMBDA)
C
C ----- STATUTS
C
        CALL MMMSTA(NDIM  ,LELTF ,LPENAF,LOPTF ,DJEUT ,
     &              DLAGRF,COEFAF,COEFFF,TAU1  ,TAU2  ,
     &              LCONT ,LADHE ,LAMBDA,RESE  ,NRESE )
C
C ----- PHASE DE CALCUL
C
        CALL MMMPHA(LOPTF ,LCONT ,LADHE ,NDEXFR,LPENAC,
     &              LPENAF,PHASEP)
C
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CALCUL FORME FAIBLE FORCE DE CONTACT/FROTTEMENT
C
      IF (TYPELT.EQ.'POIN_ELEM') THEN
        CALL MMVFPE(PHASEP,NDIM  ,NNE   ,NNM   ,NORM  ,
     &              TAU1  ,TAU2  ,MPROJT,WPG   ,FFE   ,
     &              FFM   ,JACOBI,JEU   ,COEFAC,COEFAF,
     &              LAMBDA,COEFFF,DLAGRC,DLAGRF,DJEU  ,
     &              RESE  ,NRESE ,VECTEE,VECTMM)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CALCUL FORME FAIBLE LOI DE CONTACT/FROTTEMENT
C
      IF (TYPELT.EQ.'POIN_ELEM') THEN
        CALL MMVAPE(PHASEP,LELTF ,NDIM  ,NNL   ,NBCPS ,
     &              COEFAC,COEFAF,COEFFF,FFL   ,WPG   ,
     &              JEU   ,JACOBI,LAMBDA,TAU1  ,TAU2  ,
     &              MPROJT,DLAGRC,DLAGRF,DJEU  ,RESE  ,
     &              VECTCC,VECTFF)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- MODIFICATIONS EXCLUSION
C
      CALL MMMVEX(NNL   ,NBCPS ,NDEXFR,VECTFF)
C
C --- ASSEMBLAGE FINAL
C
      CALL MMMVAS(NDIM  ,NNE   ,NNM   ,NNL   ,NBDM  ,
     &            NBCPS ,VECTEE,VECTMM,VECTCC,VECTFF,
     &            VTMP)
C
C --- RECUPERATION DES VECTEURS 'OUT' (A REMPLIR => MODE ECRITURE)
C
      CALL JEVECH('PVECTUR','E',JVECT )
C
C --- RECOPIE VALEURS FINALES
C
      DO 60 IDDL = 1,NDDL
        ZR(JVECT-1+IDDL) = VTMP(IDDL)
        IF (DEBUG) THEN
          IF (VTMP(IDDL).NE.0.D0) THEN
            WRITE(6,*) 'TE0365: ',IDDL,VTMP(IDDL)
          ENDIF
        ENDIF
60    CONTINUE
C
      CALL JEDEMA()
      END
