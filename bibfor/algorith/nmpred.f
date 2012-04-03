      SUBROUTINE NMPRED(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &                  COMREF,COMPOR,LISCHA,METHOD,SOLVEU,
     &                  FONACT,PARMET,CARCRI,SDIMPR,SDSTAT,
     &                  SDTIME,SDDISC,SDNUME,SDERRO,NUMINS,
     &                  VALINC,SOLALG,MATASS,MAPREC,DEFICO,
     &                  RESOCO,RESOCU,SDDYNA,MEELEM,MEASSE,
     &                  VEELEM,VEASSE,LERRIT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER      FONACT(*)
      INTEGER      NUMINS
      REAL*8       PARMET(*)
      CHARACTER*16 METHOD(*)
      CHARACTER*19 MATASS,MAPREC
      CHARACTER*24 SDIMPR,SDTIME,SDSTAT
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA,SDNUME
      CHARACTER*24 MODELE,MATE  ,CARELE,COMREF,COMPOR
      CHARACTER*24 NUMEDD,NUMFIX
      CHARACTER*24 CARCRI,SDERRO
      CHARACTER*24 DEFICO,RESOCO,RESOCU
      CHARACTER*24 SDSENS
      CHARACTER*19 MEELEM(*),VEELEM(*)
      CHARACTER*19 MEASSE(*),VEASSE(*)
      CHARACTER*19 SOLALG(*),VALINC(*)
      LOGICAL      LERRIT
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C PHASE DE PREDICTION
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARIABLES DE COMMANDE DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN  SOLVEU : SOLVEUR
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  SDIMPR : SD AFFICHAGE
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDERRO : GESTION DES ERREURS
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  DEFICO : SD DEFINITION CONTACT
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  RESOCU : SD RESOLUTION LIAISON_UNILATER
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDSENS : SD SENSIBILITE
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  MAPREC : NOM DE LA MATRICE DE PRECONDITIONNEMENT (GCPC)
C IN  SDNUME : SD NUMEROTATION
C OUT LERRIT  : .TRUE. SI ERREUR PENDANT PREDICTION
C
C ----------------------------------------------------------------------
C
      INTEGER      IFM,NIV
      INTEGER      FACCVG,LDCCVG
      CHARACTER*24 CODERE
C
C ----------------------------------------------------------------------
C
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> CALCUL DE PREDICTION'
      ENDIF
C
C --- INITIALISATION CODES RETOURS
C
      CODERE = '&&NMPRED.CODERE'
      FACCVG = -1
      LDCCVG = -1
C
C --- PREDICTION PAR LINEARISATION DU SYSTEME
C
      IF (METHOD(5).EQ.'ELASTIQUE' .OR. METHOD(5).EQ.'TANGENTE') THEN
        CALL NMPRTA(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &              COMREF,COMPOR,LISCHA,METHOD,SOLVEU,
     &              FONACT,PARMET,CARCRI,SDIMPR,SDSTAT,
     &              SDTIME,SDDISC,NUMINS,VALINC,SOLALG,
     &              MATASS,MAPREC,DEFICO,RESOCO,RESOCU,
     &              SDDYNA,SDSENS,MEELEM,MEASSE,VEELEM,
     &              VEASSE,SDNUME,LDCCVG,FACCVG,CODERE)
C
C --- PREDICTION PAR EXTRAPOLATION DU PAS PRECEDENT OU PAR DEPLACEMENT
C --- CALCULE
C
      ELSEIF ((METHOD(5) .EQ. 'EXTRAPOLE').OR.
     &        (METHOD(5) .EQ. 'DEPL_CALCULE')) THEN
        CALL NMPRDE(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &              COMREF,COMPOR,LISCHA,METHOD,SOLVEU,
     &              FONACT,PARMET,CARCRI,SDIMPR,SDSTAT,
     &              SDTIME,SDDISC,NUMINS,VALINC,SOLALG,
     &              MATASS,MAPREC,DEFICO,RESOCO,SDDYNA,
     &              MEELEM,MEASSE,VEELEM,VEASSE,LDCCVG,
     &              FACCVG,CODERE)
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- TRANSFORMATION DES CODES RETOURS EN EVENEMENTS
C
      CALL NMCRET(SDERRO,'LDC',LDCCVG)
      CALL NMCRET(SDERRO,'FAC',FACCVG)
C
C --- EVENEMENT ERREUR ACTIVE ?
C
      CALL NMLTEV(SDERRO,'ERRI','NEWT',LERRIT)
C
      END
