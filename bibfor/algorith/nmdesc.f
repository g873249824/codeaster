      SUBROUTINE NMDESC(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &                  COMREF,COMPOR,LISCHA,RESOCO,METHOD,
     &                  SOLVEU,PARMET,CARCRI,FONACT,NUMINS,
     &                  ITERAT,SDDISC,SDIMPR,SDSTAT,SDTIME,
     &                  SDDYNA,SDNUME,SDERRO,MATASS,MAPREC,
     &                  DEFICO,VALINC,SOLALG,ETA   ,MEELEM,
     &                  MEASSE,VEASSE,VEELEM,LERRIT)
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
      INTEGER      NUMINS, ITERAT
      REAL*8       PARMET(*), ETA
      CHARACTER*16 METHOD(*)
      CHARACTER*19 MATASS,MAPREC
      CHARACTER*24 SDIMPR,SDTIME,SDSTAT
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA,SDNUME
      CHARACTER*24 NUMEDD,NUMFIX
      CHARACTER*24 MODELE,MATE  ,CARELE,COMREF,COMPOR,CARCRI
      CHARACTER*24 DEFICO,RESOCO,SDERRO
      INTEGER      FONACT(*)
      CHARACTER*19 MEELEM(*),VEELEM(*)
      CHARACTER*19 SOLALG(*),VALINC(*)
      CHARACTER*19 MEASSE(*),VEASSE(*)
      LOGICAL      LERRIT
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DE LA DIRECTION DE DESCENTE
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
C IN  LISCHA : L_CHARGES
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  SDERRO : SD GESTION DES ERREURS
C IN  SDNUME : SD NUMEROTATION
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  NUMINS : NUMERO D'INSTANT
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN  ETA    : PARAMETRE DE PILOTAGE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLE
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C OUT LERRIT : .TRUE. SI ERREUR PENDANT L'ITERATION
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*24 CODERE
      CHARACTER*19 CNCINE,DEPDEL,CNDONN,CNPILO,CNCIND
      INTEGER      FACCVG,LDCCVG
      REAL*8       R8BID
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      CNDONN = '&&CNCHAR.DONN'
      CNPILO = '&&CNCHAR.PILO'
      CNCIND = '&&CNCHAR.CINE'
      CALL VTZERO(CNDONN)
      CALL VTZERO(CNPILO)
      CALL VTZERO(CNCIND)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> CALCUL DIRECTION DE DESCENTE...'
      ENDIF
C
C --- INITIALISATIONS CODES RETOURS
C
      LDCCVG = -1
      FACCVG = -1
      CODERE = '&&NMDESC.CODERE'
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL NMCHEX(VEASSE,'VEASSE','CNCINE',CNCINE)
      CALL NMCHEX(SOLALG,'SOLALG','DEPDEL',DEPDEL)
C
C --- CALCUL DE LA MATRICE GLOBALE
C
      CALL NMCOMA(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &            PARMET,METHOD,LISCHA,NUMEDD,NUMFIX,
     &            SOLVEU,COMREF,SDDISC,SDDYNA,SDIMPR,
     &            SDSTAT,SDTIME,NUMINS,ITERAT,FONACT,
     &            DEFICO,RESOCO,VALINC,SOLALG,VEELEM,
     &            MEELEM,MEASSE,VEASSE,MAPREC,MATASS,
     &            CODERE,FACCVG,LDCCVG,SDNUME)
C
C --- ERREUR SANS POSSIBILITE DE CONTINUER
C
      IF ((FACCVG.EQ.1).OR.(FACCVG.EQ.2)) GOTO 9999
      IF (LDCCVG.EQ.1) GOTO 9999
C
C --- PREPARATION DU SECOND MEMBRE
C
      CALL NMASSC(FONACT,SDDYNA,ETA   ,VEASSE,CNPILO,
     &            CNDONN)
C
C --- ACTUALISATION DES CL CINEMATIQUES
C
      CALL COPISD('CHAMP_GD','V',CNCINE,CNCIND)
      CALL NMACIN(FONACT,MATASS,DEPDEL,CNCIND)
C
C --- RESOLUTION
C
      CALL NMRESD(FONACT,SDDYNA,SDSTAT,SDTIME,SOLVEU,
     &            NUMEDD,R8BID ,MAPREC,MATASS,CNDONN,
     &            CNPILO,CNCIND,SOLALG)
C
9999  CONTINUE
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
      CALL JEDEMA()
      END
