      SUBROUTINE NMINIT(RESULT,MODELE,NUMEDD,MATE  ,COMPOR,
     &                  CARELE,PARMET,LISCHA,MAPREC,SOLVEU,
     &                  CARCRI,NUMINS,SDDISC,SDNURO,DEFICO,
     &                  SDCRIT,COMREF,ZFON  ,FONACT,PARCON,
     &                  PARCRI,LISCH2,MAILLA,LISINS,SDPILO,
     &                  SDDYNA,SDIMPR,SDSUIV,SDSENS,SDOBSE,
     &                  SDTIME,SDERRO,DEFICU,RESOCU,RESOCO,
     &                  VALMOI,VALPLU,POUGD ,SOLALG,MEASSE,
     &                  VEELEM,MEELEM,VEASSE)
C
C MODIF ALGORITH  DATE 07/10/2008   AUTEUR ABBAS M.ABBAS 
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
      REAL*8       PARCON(*),PARCRI,PARMET(*)
      INTEGER      NUMINS
      CHARACTER*8  RESULT,MAILLA
      CHARACTER*14 SDPILO,SDOBSE
      CHARACTER*19 SOLVEU,SDNURO,SDDISC,SDCRIT
      CHARACTER*19 LISCHA,LISCH2,SDDYNA
      CHARACTER*19 MAPREC,LISINS
      CHARACTER*24 MODELE,COMPOR,NUMEDD
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 CARCRI
      CHARACTER*24 MATE,CARELE
      CHARACTER*24 VALMOI(8),VALPLU(8),POUGD(8)
      CHARACTER*19 VEELEM(*),MEELEM(*)
      CHARACTER*19 VEASSE(*),MEASSE(*)
      CHARACTER*19 SOLALG(*)
      CHARACTER*24 SDIMPR,SDSUIV,SDSENS,SDTIME,SDERRO
      CHARACTER*24 DEFICU,RESOCU
      CHARACTER*24 COMREF
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
C OUT LISCH2 : NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C              RESULTAT
C
C
C ----------------------------------------------------------------------
C
      INTEGER      IRET,IBID
      REAL*8       R8BID3(3)      
      INTEGER      DERNIE
      REAL*8       DIINST,INSTIN
      CHARACTER*24 K24BID,COMMOI
      CHARACTER*2  CODRET
      LOGICAL      REAROT,LACC0,LPILO,LMPAS,LEXGE,LSSTF,LERRT
      LOGICAL      ISFONC,NDYNLO
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
      LACC0  = .FALSE.
C
C --- CREATION DE LA STRUCTURE DE DONNEE GESTION DU TEMPS
C
      CALL NMCRTI(SDTIME) 
C
C --- CREATION DE LA STRUCTURE DE DONNEE GESTION DES ERREURS
C
      CALL NMCRER(SDERRO)           
C
C --- NUMEROTATION ET CREATION DU PROFIL DE LA MATRICE
C
      CALL NMPROF(MODELE,RESULT,LISCHA,SOLVEU,SDTIME,
     &            NUMEDD)
C
C --- CREATION DE VARIABLES "CHAPEAU" POUR STOCKER LES NOMS
C
      CALL NMCHAP(SDSENS,SDDYNA,VALMOI,VALPLU,POUGD ,
     &            SOLALG,MEELEM,VEELEM,VEASSE,MEASSE)
C
C --- CREATION DE LA STRUCTURE DE DONNEE RESULTAT DU CONTACT
C
      CALL CFCRSD(MAILLA,LISCHA,NUMEDD,DEFICO,RESOCO)
C
C --- CREATION DE LA STRUCTURE DE LIAISON_UNILATERALE
C
      CALL CUCRSD(MAILLA,LISCHA,NUMEDD,DEFICU,RESOCU)
C
C --- INITIALISATIONS LIEES AUX POUTRES EN GRANDS DEPLACEMENTS
C
      CALL NUROTA(NUMEDD(1:14),COMPOR(1:19),SDNURO,REAROT)
C
C --- FONCTIONNALITES ACTIVEES
C
      CALL NMFONC(ZFON  ,PARCRI,PARMET,SOLVEU,MODELE,
     &            DEFICO,DEFICU,LISCHA,REAROT,SDSENS,
     &            SDDYNA,FONACT)
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LMPAS  = NDYNLO(SDDYNA,'MULTI_PAS')
      LEXGE  = NDYNLO(SDDYNA,'EXPL_GENE')
      LSSTF  = ISFONC(FONACT,'SOUS_STRUC')
      LERRT  = ISFONC(FONACT,'ERRE_TEMPS')      
C
C --- CREATION DES VECTEURS D'INCONNUS
C
      CALL NMCRCH(NUMEDD,FONACT,SDDYNA,SDSENS,DEFICO,
     &            VALMOI,VALPLU,POUGD ,SOLALG,VEASSE)    
C
C --- CONSTRUCTION DU CHAM_NO ASSOCIE AU PILOTAGE
C
      IF (LPILO) THEN
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
     &            SOLALG,LACC0 ,INSTIN)
C
C --- CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
      CALL DIINIT(MAILLA,RESULT,MATE  ,CARELE,SDDYNA,
     &            INSTIN,SDDISC,DERNIE,LISINS,SDOBSE,
     &            SDSUIV)
C
C --- CREATION DE LA SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE
C
      CALL NMCRCV(SDCRIT)
C
C --- CREATION DU CHAMP DES VARIABLES DE COMMANDE DE REFERENCE
C
      CALL NMVCRE(MODELE,MATE  ,CARELE,COMREF)        
C
C --- CREATION SD POUR ALGORITHMES DE CONTACT
C
      CALL CFMXME(MAILLA,FONACT,NUMEDD,SDDYNA,DEFICO,
     &            RESOCO)
C
C --- PRE-CALCUL DES MATR_ELEM CONSTANTES AU COURS DU CALCUL
C
      CALL NMINMC(FONACT,LISCHA,SDDYNA,MODELE,COMPOR,
     &            SOLVEU,NUMEDD,DEFICO,RESOCO,CARCRI,
     &            MATE  ,CARELE,SDDISC,MEELEM,MEASSE)
C
C --- INSTANT INITIAL
C
      NUMINS = 0
      INSTIN = DIINST(SDDISC,NUMINS)
C
C --- EXTRACTION VARIABLES DE COMMANDES AU TEMPS T-
C
      CALL DESAGG(VALMOI,K24BID,K24BID,K24BID,COMMOI,
     &            K24BID,K24BID,K24BID,K24BID)      
      CALL NMVCLE(MODELE,MATE  ,CARELE,LISCHA,INSTIN,
     &            COMMOI,CODRET)   
C
C --- CALCUL ET ASSEMBLAGE DES VECT_ELEM CONSTANTS AU COURS DU CALCUL
C 
      CALL NMINVC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &            SDDISC,SDDYNA,VALMOI,VALPLU,POUGD ,
     &            SOLALG,LISCHA,COMREF,DEFICO,RESOCO,
     &            RESOCU,NUMEDD,FONACT,PARCON,VEELEM,
     &            SDSENS,VEASSE,MEASSE)   
C
C --- INITIALISATION CALCUL PAR SOUS-STRUCTURATION
C
      IF (LSSTF) THEN
        CALL NMLSSV('INIT',LISCHA,IBID  )
      ENDIF       
C
C --- CALCUL DE L'ACCELERATION INITIALE
C
      IF (LACC0) THEN
        CALL NMCHAR('ACCI',' ',
     &              MODELE,NUMEDD,MATE  ,CARELE,COMPOR,
     &              LISCHA,CARCRI,NUMINS,SDDISC,PARCON,
     &              FONACT,DEFICO,RESOCO,RESOCU,COMREF,
     &              VALMOI,VALPLU,POUGD ,SOLALG,VEELEM,
     &              MEASSE,VEASSE,SDSENS,SDDYNA)
        CALL ACCEL0(MODELE,NUMEDD,FONACT,LISCHA,DEFICO,
     &              RESOCO,MAPREC,SOLVEU,VALMOI,SDDYNA,
     &              SDPILO,SDTIME,MEELEM,MEASSE,VEELEM,
     &              VEASSE,SOLALG)
      ENDIF
C
C --- CREATION DE LA SD AFFICHAGE
C
      CALL IMPINI(SDIMPR,SDSUIV,FONACT,PARCRI)
C
C --- AFFICHAGE: INITIALISATION
C
      CALL NMIMPR('INIT',' ',' ',0.D0,0)    
C
C --- PRE-CALCUL DES MATR_ASSE CONSTANTES AU COURS DU CALCUL
C
      CALL NMINMA(FONACT,LISCHA,SDDYNA,SOLVEU,NUMEDD,
     &            DEFICO,MEELEM,MEASSE)   
C
C --- CREATION DE LA SD EVOL_NOLI
C
      CALL NMNOLI(COMPOR,SDDISC,CARCRI,SDCRIT,FONACT,
     &            DERNIE,MODELE,MAILLA,MATE  ,SDSENS,
     &            CARELE,LISCH2,DEFICO,RESOCO,SDDYNA) 
C
C --- LECTURE DONNES PROJECTION MDOALE EN EXPLICITE
C        
      IF (LEXGE) THEN

      ENDIF    
C
C --- CREATION DE LA TABLE DES GRANDEURS
C
      IF (LERRT) THEN
        CALL CETULE(MODELE,R8BID3,IRET  )
      ENDIF        
C
C --- CALCUL DU SECOND MEMBRE INITIAL POUR MULTI-PAS
C
      IF (LMPAS) THEN
        CALL NMIHHT(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &              LISCHA,CARCRI,COMREF,FONACT,SDDYNA,
     &              SDSENS,DEFICO,RESOCO,RESOCU,VALMOI,
     &              VALPLU,POUGD ,SDDISC,PARCON,SOLALG,
     &              VEELEM,VEASSE)
      ENDIF
C  
 1000 CONTINUE        
C
      CALL JEDEMA()
      END
