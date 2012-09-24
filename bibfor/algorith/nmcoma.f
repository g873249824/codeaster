      SUBROUTINE NMCOMA(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &                  PARMET,METHOD,LISCHA,NUMEDD,NUMFIX,
     &                  SOLVEU,COMREF,SDDISC,SDDYNA,SDIMPR,
     &                  SDSTAT,SDTIME,NUMINS,ITERAT,FONACT,
     &                  DEFICO,RESOCO,VALINC,SOLALG,VEELEM,
     &                  MEELEM,MEASSE,VEASSE,MAPREC,MATASS,
     &                  CODERE,FACCVG,LDCCVG,SDNUME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2012   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      REAL*8        PARMET(*)
      CHARACTER*16  METHOD(*)
      INTEGER       FONACT(*)
      CHARACTER*(*) MODELZ
      CHARACTER*24  MATE,CARELE
      CHARACTER*24  SDIMPR,SDTIME,SDSTAT
      CHARACTER*24  COMPOR,CARCRI,NUMEDD,NUMFIX
      CHARACTER*19  SDDISC,SDDYNA,LISCHA,SOLVEU,SDNUME
      CHARACTER*24  COMREF,CODERE
      CHARACTER*19  MEELEM(*),VEELEM(*)
      CHARACTER*19  SOLALG(*),VALINC(*)
      CHARACTER*19  MEASSE(*),VEASSE(*)
      INTEGER       NUMINS,ITERAT,IBID
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  MAPREC,MATASS
      INTEGER       FACCVG,LDCCVG
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CALCUL DE LA MATRICE GLOBALE EN CORRECTION
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  DEFICO : SD DEF. CONTACT
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  NUMINS : NUMERO D'INSTANT
C IN  ITERAT : NUMERO D'ITERATION
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C OUT LFINT  : .TRUE. SI FORCES INTERNES CALCULEES
C OUT MATASS : MATRICE DE RESOLUTION ASSEMBLEE
C OUT MAPREC : MATRICE DE RESOLUTION ASSEMBLEE - PRECONDITIONNEMENT
C OUT FACCVG : CODE RETOUR FACTORISATION MATRICE GLOBALE
C                -1 : PAS DE FACTORISATION
C                 0 : CAS DU FONCTIONNEMENT NORMAL
C                 1 : MATRICE SINGULIERE
C                 2 : ERREUR LORS DE LA FACTORISATION
C                 3 : ON NE SAIT PAS SI SINGULIERE
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                -1 : PAS D'INTEGRATION DU COMPORTEMENT
C                 0 : CAS DU FONCTIONNEMENT NORMAL
C                 1 : ECHEC DE L'INTEGRATION DE LA LDC
C                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
C                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
C
C ----------------------------------------------------------------------
C
      LOGICAL      REASMA,LCAMOR
      LOGICAL      LDYNA,LAMOR,LSUIV,LCRIGI,LCFINT,LARIGI
      LOGICAL      NDYNLO,ISFONC
      CHARACTER*16 METCOR,METPRE
      CHARACTER*16 OPTRIG,OPTAMO
      CHARACTER*19 VEFINT,CNFINT
      CHARACTER*24 MODELE
      LOGICAL      RENUME
      INTEGER      IFM,NIV
      INTEGER      NBMATR
      CHARACTER*6  LTYPMA(20)
      CHARACTER*16 LOPTME(20),LOPTMA(20)
      LOGICAL      LASSME(20),LCALME(20)
C
C ----------------------------------------------------------------------
C
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL MATRICE'
      ENDIF
C
C --- INTIIALISATIONS
C
      CALL NMCMAT('INIT','      ',' ',' ',.FALSE.,
     &            .FALSE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LCALME,LASSME)
      MODELE = MODELZ
      FACCVG = -1
      LDCCVG = -1
      RENUME = .FALSE.
      LCAMOR = .FALSE.
      CALL NMCHEX(VEELEM,'VEELEM','CNFINT',VEFINT)
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT)
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LAMOR  = NDYNLO(SDDYNA,'MAT_AMORT')
      LSUIV  = ISFONC(FONACT,'FORCE_SUIVEUSE')
C
C --- CHOIX DE REASSEMBLAGE DE LA MATRICE GLOBALE
C
      CALL NMCHRM('CORRECTION',
     &            PARMET,METHOD,FONACT,SDDISC,SDDYNA,
     &            NUMINS,ITERAT,DEFICO,METPRE,METCOR,
     &            REASMA)
C
C --- CHOIX DE REASSEMBLAGE DE L'AMORTISSEMENT
C
      IF (LAMOR) THEN
        CALL NMCHRA(SDDYNA,OPTAMO,LCAMOR)
      ENDIF
C
C --- RE-CREATION DU NUME_DDL OU PAS
C
      CALL NMRENU(MODELZ,FONACT,NUMEDD,LISCHA,SOLVEU,
     &            RESOCO,RENUME)
C
C --- OPTION DE CALCUL POUR MERIMO
C
      CALL NMCHOI('CORRECTION',
     &            SDDYNA,SDDISC,FONACT,METPRE,METCOR,
     &            REASMA,LCAMOR,OPTRIG,LCRIGI,LARIGI,
     &            LCFINT)
C
C --- CALCUL DES FORCES INTERNES
C
      IF (LCFINT) THEN
        CALL NMFINT(MODELE,MATE  ,CARELE,COMREF,COMPOR,
     &              CARCRI,FONACT,ITERAT,SDDYNA,SDSTAT,
     &              SDTIME,VALINC,SOLALG,LDCCVG,CODERE,
     &              VEFINT)
      ENDIF
C
C --- ERREUR SANS POSSIBILITE DE CONTINUER
C
      IF (LDCCVG.EQ.1) GOTO 9999
C
C --- ASSEMBLAGE DES FORCES INTERNES
C
      IF (LCFINT) THEN
        LCFINT = .FALSE.
        CALL NMAINT(NUMEDD,FONACT,DEFICO,VEASSE,VEFINT,
     &              CNFINT,SDNUME)
      ENDIF
C
C --- CALCUL DES MATR_ELEM CONTACT/XFEM_CONTACT
C
      CALL NMCHCC(FONACT,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LASSME,LCALME)
C
C --- ASSEMBLAGE DES MATR-ELEM DE RIGIDITE
C
      IF (LARIGI) THEN
        CALL NMCMAT('AJOU','MERIGI',OPTRIG,' ',.FALSE.,
     &              LARIGI,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &              LCALME,LASSME)
      ENDIF
C
C --- CALCUL DES MATR-ELEM D'AMORTISSEMENT DE RAYLEIGH A CALCULER
C --- NECESSAIRE SI MATR_ELEM RIGIDITE CHANGE !
C
      IF (LCAMOR) THEN
        CALL NMCMAT('AJOU','MEAMOR',OPTAMO,' ',.TRUE.,
     &            .TRUE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LCALME,LASSME)
      ENDIF
C
C --- CALCUL DES MATR-ELEM DES CHARGEMENTS SUIVEURS
C
      IF (LSUIV) THEN
        CALL NMCMAT('AJOU','MESUIV',' ',' ',.TRUE.,
     &              .FALSE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &              LCALME,LASSME)
      ENDIF
C
C --- RE-CREATION MATRICE MASSE SI NECESSAIRE (NOUVEAU NUME_DDL)
C
      IF (RENUME) THEN
        IF (LDYNA) THEN
          CALL NMCMAT('AJOU','MEMASS',' ',' ',.FALSE.,
     &                .TRUE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &                LCALME,LASSME)
        ENDIF
        IF (.NOT.REASMA) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- CALCUL ET ASSEMBLAGE DES MATR_ELEM DE LA LISTE
C
      IF (NBMATR.GT.0) THEN
        CALL NMXMAT(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,FONACT,NUMINS,ITERAT,
     &              VALINC,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,SOLVEU,NUMEDD,NUMFIX,SDSTAT,
     &              SDTIME,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &              LCALME,LASSME,LCFINT,MEELEM,MEASSE,
     &              VEELEM,LDCCVG,CODERE)
      ENDIF
C
C --- ERREUR SANS POSSIBILITE DE CONTINUER
C
      IF (LDCCVG.EQ.1) GOTO 9999
C
C --- CALCUL DE LA MATRICE ASSEMBLEE GLOBALE
C
      IF (REASMA) THEN
        CALL NMMATR('CORRECTION',
     &              FONACT,LISCHA,SOLVEU,NUMEDD,SDDYNA,
     &              SDDISC,DEFICO,RESOCO,MEELEM,MEASSE,
     &              MATASS)
      ENDIF
C
C --- AFFICHAGE
C
      IF (REASMA) THEN
        CALL NMIMCK(SDIMPR,'MATR_ASSE',METCOR,.TRUE.)
      ELSE
        CALL NMIMCK(SDIMPR,'MATR_ASSE',METCOR,.FALSE.)
      ENDIF
C
C --- FACTORISATION DE LA MATRICE ASSEMBLEE GLOBALE
C
      IF (REASMA) THEN
        CALL NMTIME(SDTIME,'INI','FACTOR')
        CALL NMTIME(SDTIME,'RUN','FACTOR')
        CALL PRERES(SOLVEU,'V',FACCVG,MAPREC,MATASS,IBID,-9999)
        CALL NMTIME(SDTIME,'END','FACTOR')
        CALL NMRINC(SDSTAT,'FACTOR')
      ENDIF
C
 9999 CONTINUE
C
      END
