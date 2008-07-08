      SUBROUTINE NMINIT(RESULT,MODELE,NUMEDD,MATE  ,COMPOR,
     &                  CARELE,PARMET,LISCHA,MAPREC,SOLVEU,
     &                  CARCRI,SDDISC,INERTE,
     &                  SDNURO,DEFICO,CRITNL,
     &                  COMREF,CNVCFO,CNVCF1,ZFON  ,FONACT,
     &                  CNVFRE,PARCON,PARCRI,LISCH2,MAILLA,
     &                  LISINS,INSTAM,SDPILO,SDDYNA,SDIMPR,
     &                  SDSUIV,SDSENS,SDOBSE,SDTIME,DEFICU,
     &                  RESOCU,RESOCO,VALMOI,VALPLU,POUGD ,
     &                  SECMBR,DEPALG,MEASSE,VEELEM,MEELEM,
     &                  CNFINT,CNDIRI)
C
C MODIF ALGORITH  DATE 07/07/2008   AUTEUR LAVERNE J.LAVERNE 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21 CRP_20
C
      IMPLICIT NONE
      INTEGER      ZFON
      LOGICAL      FONACT(ZFON)
      REAL*8       PARCON(*),PARCRI,INSTAM,PARMET(*)
      CHARACTER*8  RESULT,MAILLA
      CHARACTER*14 SDPILO,SDOBSE
      CHARACTER*16 INERTE
      CHARACTER*19 SOLVEU,SDNURO,SDDISC,CRITNL
      CHARACTER*19 LISCHA,LISCH2,SDDYNA
      CHARACTER*19 MAPREC,CNVFRE,LISINS
      CHARACTER*24 MODELE,COMPOR,NUMEDD
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 CARCRI
      CHARACTER*24 MATE,CARELE
      CHARACTER*24 VALMOI(8),VALPLU(8),POUGD(8),SECMBR(8),DEPALG(8)
      CHARACTER*19 VEELEM(30),MEELEM(8)
      CHARACTER*19 MEASSE(8)
      CHARACTER*24 SDIMPR,SDSUIV,SDSENS,SDTIME
      CHARACTER*24 DEFICU,RESOCU
      CHARACTER*24 COMREF
      CHARACTER*19 CNVCFO,CNVCF1
      CHARACTER*19 CNFINT,CNDIRI
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C INITIALISATIONS
C
C ----------------------------------------------------------------------
C
C
C       IN RESULT K8   NOM UTILISATEUR DU RESULTAT DE STAT_NON_LINE
C       IN MODELE K24  MODELE MECANIQUE
C      OUT NUMEDD K24  NOM DE LA NUMEROTATION MECANIQUE
C       IN MATE   K24  NOM DU CHAMP DE MATERIAU
C       IN COMPOR K24  CARTE COMPORTEMENT
C       IN CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN/JXOUT MEMASS K24  MATRICES ELEMENTAIRES DE MASSE
C IN/JXOUT MASSE  K19  MATRICES DE MASSE ASSEMBLEE
C IN/JXOUT MEDIRI K24  MATRICES ELEMENTAIRES DE RIGIDITE DIRICHLET
C       IN LISCHA K19  SD L_CHARGE
C IN/JXOUT DEPPLU K24  DEPLACEMENT INSTANT PLUS
C IN/JXOUT DEPMOI K24  DEPLACEMENTS INITIAUX
C IN/JXOUT SIGPLU K24  CONTRAINTES INSTANT PLUS
C IN/JXOUT SIGMOI K24  CONTRAINTES  INITIALES
C IN/JXOUT VARPLU K24  VARIABLES INSTANT PLUS
C IN/JXOUT VARMOI K24  VARIABLES INTERNES INITIALES
C IN/JXOUT VALMOI K24  VARIABLE CHAPEAU ETAT INITAL
C IN/JXOUT VITPLU K24  VITESSE INSTANT PLUS
C IN/JXOUT ACCPLU K24  ACCELERATION INSTANT PLUS
C IN/JXOUT MAPREC K19  MATRICE PRECONDITIONNEMENT
C      IN  SOLVEU K19  NOM DU SOLVEUR DE NEWTON
C IN/JXOUT DEPENT K24  CHAMP MULTI APPUI
C IN/JXOUT VITENT K24  CHAMP MULTI APPUI
C IN/JXOUT ACCENT K24  CHAMP MULTI APPUI
C IN/JXOUT CARCRI K24  CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN/JXOUT COMMOI K24  VARIABLES DE COMMANDE INSTANT MOINS
C IN/JXOUT COMPLU K24  VARIABLES DE COMMANDE INSTANT PLUS
C IN/JXOUT VARDEP K24  VARIABLES INTERNES MODELISATION NON LOCALE
C IN/JXOUT LAGDEP K24  MULTIPLICATEURS MODELISATION NON LOCALE
C IN/JXOUT VARIGV K24  GRADIENT VARIABLE MODELISATION NON LOCALE
C IN/JXOUT CNFEDO K24  CHARGEMENT FORCES FIXES
C IN/JXOUT CNFEPI K24  CHARGEMENT FORCES PILOTEES
C IN/JXOUT CNDIDO K24  CHARGEMENT DIRICHLETS FIXES
C IN/JXOUT CNDIPI K24  CHARGEMENT DIRICHLET PILOTES
C IN/JXOUT CNFSPI K24  CHARGEMENT FORCES SUIVEUSES
C IN/JXOUT CNDIDI K24  DIRICHLET DIFFERENTIEL B_DIDI.U_REF
C IN/JXOUT CNCINE K24  CHARGES CINEMATIQUES
C IN/JXOUT DEPKM1 K24  DEPLACEMENT ITERATION MOINS
C IN/JXOUT VITKM1 K24  VITESSE ITERATION MOINS
C IN/JXOUT ACCKM1 K24  ACCELERATION ITERATION MOINS
C IN/JXOUT ROMKM1 K24  VECTEUR ROTATION ITERATION MOINS
C IN/JXOUT ROMK   K24  VECTEUR ROTATION ITERATION COURANTE
C IN/JXOUT DDEPLA K24  INCREMENT DEPLACEMENT
C IN/JXOUT FONDEP K24  NOM DE LA FONCTION DEPLACEMENT
C IN/JXOUT FONVIT K24  NOM DE LA FONCTION VITESSE
C IN/JXOUT FONACC K24  NOM DE LA FONCTION ACCELERATION
C IN/JXOUT SDDISC K24  INFOS SUR DISCRETISATION TEMPORELLE
C IN/JXOUT SDNURO   K19  NUMEROTATION DES DDL DE GRANDES ROTATIONS
C      OUT REAROT  L   .TRUE. S'IL Y A DES DDL DE GRANDES ROTATIONS
C IN/JXOUT VARDEM K24  VARIABLES NON LOCALES INITIALES
C IN/JXOUT LAGDEM K24  MULTIPLICATEURS DE LAGRANGE NON LOCAUX INITIAUX
C IN/JXOUT SDPILO K14  SD ASSOCIEE AU PILOTAGE
C      OUT DEFICO K24  SD DE DEFINITION DU CONTACT
C IN/JXOUT RESOCO K24  SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN       DEFICU K24  SD DEF. LIAISON_UNILATERALE
C IN       RESOCU K24  SD RES. LIAISON_UNILATERALE
C IN/JXOUT SDIMPR K24  SD AFFICHAGE
C IN/JXOUT SDSUIV K24  SD SUIVI DES DDLS
C IN/JXOUT CRITNL K19  SD ARCHIVAGE DES PARAMETRES A CONVERGENCE
C       IN ZFON    I   LONGUEUR DU VECTEUR FONACT
C      OUT FONACT  L   FONCTIONNALITES SPECIFIQUES ACTIVEES (CF NMFONC)
C       IN CMD    K16  NOM DE LA COMMANDE
C                         STAT_NON_LINE
C                         DYNA_NON_LINE
C IN/JXOUT CNVFRE K19  FORCE DE REFERENCE POUR CONVERGENCE EN REFERENCE
C       IN PARCON  R8  PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C                         SI PARCRI(6)=RESI_CONT_RELA != R8VIDE()
C                             1 : SIGM_REFE
C                             2 : FLUX_THER_REFE
C                             3 : FLUX_HYD1_REFE
C                             4 : FLUX_HYD2_REFE
C                             6 : VARI_REFE
C                             7 : EFFORT
C                             8 : MOMENT
C                             9 : DEPL_REFE
C       IN PARCRI  R8  PARCRI(6) = RESI_CONT_RELA : R8VIDE SI NON ACTIF
C       IN INERTE K16  DEMANDE SUR L'INDICATEUR TEMPOREL
C       IN NBPASE  I   NOMBRE DE PARAMETRES SENSIBLES
C       IN INPSCO K13  SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C IN/JXOUT LISCH2 K19  NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C                       RESULTAT
C       IN  SDDYNA K19 SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C      OUT  NBOBSE   NOMBRE DE PAS A OBSERVER
C      OUT  NUINS0   NUMERO DU PREMIER INSTANT DE CALCUL DANS LISTE
C                      D'INSTANT D'OBSERVATION
C      OUT  LOBSER   BOOLEEN OBSERVATION
C       IN  INSTAM   PREMIER INSTANT DE CALCUL
C       IN  RESULT   NOM UTILISATEUR DU RESULTAT
C      OUT  NUOBSE   ??
C      OUT  NOMTAB   NOM DE LA TABLE RESULTAT DE L'OBSERVATION
C      OUT  MAILL2   MAILLAGE OBSERVATION (?)
C      OUT  NBOBAR   LONGUEUR DU CHAMP OBSERVE
C      OUT  LISINS   LISTE D'INSTANTS DE L'OBSERVATION
C IN/JXOUT  LISOBS   SD LISTE OBSERVATION
C      OUT  INSTAM   INSTANT INITIAL
C
      INTEGER      NEQ,IRET,IBID
      INTEGER      DERNIE
      REAL*8       R8BID ,DIINST,INSTIN
      CHARACTER*2  CODRET
      CHARACTER*16 OPMASS
      CHARACTER*8  K8BID
      CHARACTER*24 K24BL8(8),K24BID
      LOGICAL      NDYNLO,ISFONC,LMACR,REAROT,LACC0,LBID
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> INITIALISATION DU CALCUL'
      ENDIF
C
C --- INITIALISATIONS
C
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)
      LACC0     = .FALSE.
      K24BL8(1) = ' '
C
C --- NUMEROTATION ET CREATION DU PROFIL DE LA MATRICE
C
      CALL NMPROF(MODELE,RESULT,LISCHA,SOLVEU,NUMEDD)
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- CREATION DE VARIABLES "CHAPEAU" POUR STOCKER LES NOMS
C
      CALL NMCHAP(SDSENS,SDDYNA,VALMOI,VALPLU,POUGD ,
     &            SECMBR,DEPALG,MEELEM,VEELEM,MEASSE)
C
C --- CREATION DES VECTEURS D'INCONNUS
C
      CALL NMCRCH(NUMEDD,SDDYNA,SDSENS,POUGD ,DEPALG,
     &            VEELEM)
C
C --- CREATION DE LA STRUCTURE DE DONNEE GESTION DU TEMPS
C
      CALL NMTIME('CREA',' ',SDTIME,LBID  ,R8BID )
C
C --- CREATION DE LA STRUCTURE DE DONNEE RESULTAT DU CONTACT
C
      CALL CFCRSD(MAILLA,LISCHA,NUMEDD,NEQ   ,DEFICO,
     &            RESOCO)
C
C --- CREATION DE LA STRUCTURE DE LIAISON_UNILATERALE
C
      CALL CUCRSD(MAILLA,LISCHA,NUMEDD,NEQ   ,DEFICU,
     &            RESOCU)
C
C --- INITIALISATIONS LIEES AUX POUTRES EN GRANDS DEPLACEMENTS
C
      CALL NUROTA(NUMEDD(1:14),COMPOR(1:19),SDNURO,REAROT)
C
C --- FONCTIONNALITES ACTIVEES
C
      CALL NMFONC(ZFON  ,PARCRI,SOLVEU,MODELE,DEFICO,
     &            DEFICU,LISCHA,REAROT,SDSENS,SDDYNA,
     &            FONACT)
C
C --- CONSTRUCTION DU CHAM_NO ASSOCIE AU PILOTAGE
C
      IF (NDYNLO(SDDYNA,'STATIQUE')) THEN
        CALL NMDOPI(MODELE,NUMEDD,SDPILO)
      ENDIF
C
C --- CONSTRUCTION DU CHAM_ELEM_S ASSOCIE AU COMPORTEMENT
C
      CALL NMDOCO(MODELE,CARELE,COMPOR)
C
C --- LECTURE ETAT_INIT
C
      CALL NMDOET(RESULT,MODELE,COMPOR,CARELE,FONACT,
     &            NUMEDD,SDSENS,SDPILO,SDDYNA,VALMOI,
     &            VALPLU,DEPALG,LACC0 ,INSTIN)
C
C --- CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
      CALL DIINIT(MAILLA,RESULT,MATE  ,CARELE,SDDYNA,
     &            INSTIN,SDDISC,DERNIE,LISINS,SDOBSE,
     &            SDSUIV)
C
C --- CREATION DE LA SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE
C
      CALL NMCRCV(CRITNL)
C
C --- CREATION DE LA SD EVOL_NOLI
C
      CALL NMNOLI(COMPOR,SDDISC,CARCRI,INERTE,
     &            CRITNL,FONACT,DERNIE,
     &            MODELE,MAILLA,MATE  ,SDSENS,CARELE,
     &            LISCH2,RESOCO,SDDYNA)
C
C --- CREATION DU CHAM_NO DE REFERENCE POUR DIRICHLET DIFFERENTIEL
C
      CALL NMDIDI(MODELE,NUMEDD,LISCHA,VALMOI,VEELEM,
     &            SECMBR)
C
C --- CONVERGENCE SUR CRITERE EN CONTRAINTE GENERALISEE
C
      IF (ISFONC(FONACT,'RESI_REFE')) THEN
        CALL NMREFE(MODELE,COMPOR,NUMEDD,MATE  ,CARELE,
     &              VALMOI,PARCON,CNVFRE)
      ENDIF
C
C --- CREATION SD POUR ALGORITHMES DE CONTACT
C
      CALL CFMXME(MAILLA,FONACT,NUMEDD,NEQ   ,DEFICO,
     &            RESOCO)
C
C --- MATRICE DE RIGIDITE ASSOCIEE AUX LAGRANGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CALCUL MATRICE DE'//
     &                ' RIGIDITE ASSOCIEE AUX LAGRANGE'
      ENDIF
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')
      CALL NMCALM(MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &            R8BID ,R8BID ,CARCRI,K24BL8,K24BL8,
     &            DEPALG,'MEDIRI',' ' ,'V'   ,LMACR ,
     &            MEELEM)
C
C --- MATRICE DE MASSE
C
      IF (NDYNLO(SDDYNA,'DYNAMIQUE')) THEN
        IF (NDYNLO(SDDYNA,'EXPLICITE')) THEN
          IF(NDYNLO(SDDYNA,'MASS_DIAG'))THEN
            OPMASS='MASS_MECA_EXPLI'
          ELSE
            OPMASS='MASS_MECA'
          ENDIF
        ELSE
          OPMASS='MASS_MECA'
        ENDIF
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ... CALCUL MATRICE MASSE'
        ENDIF
        CALL NMCALM(MODELE  ,LISCHA,MATE  ,CARELE,COMPOR,
     &              INSTIN  ,R8BID ,CARCRI,K24BL8,K24BL8,
     &              DEPALG,'MEMASS',OPMASS,'V'   ,LMACR ,
     &              MEELEM)
      ENDIF
C
C --- INSTANT INITIAL
C
      INSTAM = DIINST(SDDISC, 0)
C
C --- CALCUL DE L'ACCELERATION INITIALE
C
      IF (LACC0) THEN
        CALL NMVCOM('VREF',R8BID ,MODELE,MATE  ,CARELE,
     &              LISCHA,K24BL8,COMREF,CODRET)
        CALL NMVCOM('VMOI',0.D0  ,MODELE,MATE  ,CARELE,
     &              LISCHA,VALMOI,K24BID,CODRET)
        CALL NMVCOM('VPLU',INSTAM,MODELE,MATE  ,CARELE,
     &              LISCHA,VALPLU,K24BID,CODRET)
        CALL ACCEL0(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &              LISCHA,INSTIN,MAPREC,SOLVEU,PARMET,
     &              CARCRI,FONACT,RESOCO,COMREF,1     ,
     &              SDDISC,SDDYNA,SDSENS,VALMOI,VALPLU,
     &              DEPALG,POUGD ,SECMBR,MEELEM,MEASSE,
     &              VEELEM)
      ENDIF
C
C --- CREATION DE LA SD AFFICHAGE
C
      CALL IMPINI(SDIMPR,SDSUIV,FONACT)
C
C --- AFFICHAGE: INITIALISATION
C
      CALL NMIMPR('INIT',' ',' ',0.D0,0)
C
C --- INITIALISATION EXPLICITE MODAL
C
      IF (NDYNLO(SDDYNA,'EXPLICITE')) THEN
        CALL MXMOAM(SDDYNA,RESULT,INSTAM)
        IF (REAROT) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- CALCUL DES FORCES NODALES LIEES AUX VAR. COMMANDES
C
      CALL NMVCOM('VMOI',INSTAM,MODELE,MATE  ,CARELE,
     &            LISCHA,VALMOI,K24BID,CODRET)
      CALL NMVCOM('VREF',R8BID ,MODELE,MATE  ,CARELE,
     &            LISCHA,K24BL8,COMREF,CODRET)
      CALL NMFCOM('INIT',INSTAM,R8BID ,MODELE,NUMEDD,
     &            MATE  ,CARELE,COMPOR,LISCHA,VALMOI,
     &            VALPLU,COMREF,CNVCFO,CNVCF1,CODRET)

C
C --- RECUPERATION POUR HHT COMPLET
C          
      IF ( NDYNLO(SDDYNA,'HHT_COMPLET')) THEN
        CALL NMIHHT(MODELE,NUMEDD,MATE  ,COMPOR,
     &              CARELE,PARMET,LISCHA,SOLVEU,
     &              CARCRI,
     &              COMREF,ZFON,FONACT,
     &              INSTAM,SDDYNA,SDSENS,
     &              RESOCO,VALMOI,VALPLU,POUGD,
     &              SECMBR,DEPALG,VEELEM,MEASSE,MEELEM,
     &              CNFINT,CNDIRI)
      ENDIF
C
      CALL JEDEMA()
      END
