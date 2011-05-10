      SUBROUTINE OP0070()
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/05/2011   AUTEUR TARDIEU N.TARDIEU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C
C COMMANDE:  STAT_NON_LINE ET DYNA_NON_LINE
C
C ----------------------------------------------------------------------
C
C
C --- PARAMETRES DE MECA_NON_LINE
C
      INTEGER      ZPMET ,ZPCRI ,ZCONV
      INTEGER      ZPCON ,ZNMETH,ZLICC
      PARAMETER   (ZPMET  = 30,ZPCRI  = 12,ZCONV = 21)
      PARAMETER   (ZPCON  = 10,ZNMETH = 7 ,ZLICC = 5)
      REAL*8       PARMET(ZPMET),PARCRI(ZPCRI),CONV(ZCONV)
      REAL*8       PARCON(ZPCON)
      CHARACTER*16 METHOD(ZNMETH)
      INTEGER      LICCVG(ZLICC),FONACT(100)
      INTEGER      ZMEELM,ZMEASS,ZVEELM,ZVEASS
      PARAMETER    (ZMEELM=9 ,ZMEASS=4 ,ZVEELM=22,ZVEASS=32)
      INTEGER      ZSOLAL,ZVALIN
      PARAMETER    (ZSOLAL=17,ZVALIN=18)
C
C --- GESTION CODES RETOURS
C
      LOGICAL      MAXREL,ERROR
      LOGICAL      MTCPUI,MTCPUP
      LOGICAL      ITEMAX,CONVER,FINPAS,LEVDRI
      INTEGER      ACTION
C
      LOGICAL      FORCE ,LBID,LNOPRE
C
C --- GESTION BOUCLES
C
      INTEGER      NIVEAU,NUMINS,ITERAT
      INTEGER      INCRUN
C
C --- GESTION ERREUR
C
      INTEGER      LENOUT
      CHARACTER*16 COMPEX
C
      INTEGER      IBID
C
      REAL*8       ETA   ,R8BID
C
      CHARACTER*8  RESULT,MAILLA
C
      CHARACTER*16 K16BID
      CHARACTER*19 LISCHA,LISCH2
      CHARACTER*19 SOLVEU,MAPREC,MATASS
      CHARACTER*24 MODELE,MATE  ,CARELE,COMPOR
      CHARACTER*24 NUMEDD,NUMFIX
      CHARACTER*24 CARCRI,COMREF,CODERE
C
C --- FONCTIONNALITES ACTIVEES
C
      LOGICAL      LSENS,LERRT,LBOUCL
      LOGICAL      LEXPL,LMPAS,LIMPEX,LCONT
C
C --- FONCTIONS
C
      LOGICAL      ISFONC,DIDERN,NDYNLO
      INTEGER      ETAUSR
C
C --- STRUCTURES DE DONNEES
C
      CHARACTER*24 SDIMPR,SDSENS,SDTIME,SDERRO
      CHARACTER*19 SDPILO,SDNUME,SDDYNA,SDDISC,SDCRIT
      CHARACTER*19 SDSUIV,SDOBSE,SDPOST
      CHARACTER*24 DEFICO,RESOCO,DEFICU,RESOCU
C
C --- VARIABLES CHAPEAUX
C
      CHARACTER*19 VALINC(ZVALIN),SOLALG(ZSOLAL)
C
C --- MATR_ELEM, VECT_ELEM ET MATR_ASSE
C
      CHARACTER*19 MEELEM(ZMEELM),VEELEM(ZVEELM)
      CHARACTER*19 MEASSE(ZMEASS),VEASSE(ZVEASS)
C
C ----------------------------------------------------------------------
C
      DATA SDPILO, SDOBSE    /'&&OP0070.PILO.','&&OP0070.OBSE.'/
      DATA SDIMPR, SDSUIV    /'&&OP0070.IMPR.','&&OP0070.SUIV.'/
      DATA SDSENS, SDPOST    /'&&OP0070.SENS.','&&OP0070.POST.'/
      DATA SDTIME, SDERRO    /'&&OP0070.TIME.','&&OP0070.ERRE.'/
      DATA SDNUME            /'&&OP0070.NUME.ROTAT'/
      DATA SDDISC            /'&&OP0070.DISC.'/
      DATA SDCRIT            /'&&OP0070.CRIT.'/
      DATA LISCHA            /'&&OP0070.LISCHA'/
      DATA CARCRI            /'&&OP0070.PARA_LDC'/
      DATA SOLVEU            /'&&OP0070.SOLVEUR'/
      DATA DEFICO, RESOCO    /'&&OP0070.DEFIC','&&OP0070.RESOC'/
      DATA DEFICU, RESOCU    /'&&OP0070.DEFUC', '&&OP0070.RESUC'/
      DATA COMREF            /'&&OP0070.COREF'/
      DATA MAPREC            /'&&OP0070.MAPREC'/
      DATA CODERE            /'&&OP0070.CODERE'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C -- TITRE
C
      CALL TITRE ()
      CALL INFMAJ()
      CALL INIDBG()
C
C ======================================================================
C     RECUPERATION DES OPERANDES ET INITIALISATION
C ======================================================================
C
C --- ON STOCKE LE COMPORTEMENT EN CAS D'ERREUR AVANT MNL : COMPEX
C --- PUIS ON PASSE DANS LE MODE "VALIDATION DU CONCEPT EN CAS D'ERREUR"
C
      CALL ONERRF(' ',COMPEX,LENOUT)
      CALL ONERRF('EXCEPTION+VALID',K16BID,IBID  )
C
C --- NOM DE LA SD RESULTAT
C
      CALL GETRES(RESULT,K16BID,K16BID)
C
C --- PREMIERES INITALISATIONS
C
      CALL NMINI0(ZPMET ,ZPCRI ,ZCONV ,ZPCON ,ZNMETH,
     &            ZLICC ,FONACT,PARMET,PARCRI,CONV  ,
     &            PARCON,METHOD,LICCVG,ETA   ,NUMINS,
     &            MTCPUI,MTCPUP,FINPAS,MATASS,ZMEELM,
     &            ZMEASS,ZVEELM,ZVEASS,ZSOLAL,ZVALIN)
C
C --- LECTURE DES OPERANDES DE LA COMMANDE
C
      CALL NMDATA(RESULT,MODELE,MATE  ,CARELE,COMPOR,
     &            LISCHA,SOLVEU,METHOD,PARMET,PARCRI,
     &            PARCON,CARCRI,SDDYNA,SDSENS,SDPOST,
     &            SDERRO)
C
C --- ETAT INITIAL ET CREATION DES STRUCTURES DE DONNEES
C
      CALL NMINIT(RESULT,MODELE,NUMEDD,NUMFIX,MATE  ,
     &            COMPOR,CARELE,PARMET,LISCHA,MAPREC,
     &            SOLVEU,CARCRI,NUMINS,SDDISC,SDNUME,
     &            DEFICO,SDCRIT,COMREF,FONACT,PARCON,
     &            PARCRI,METHOD,LISCH2,MAILLA,SDPILO,
     &            SDDYNA,SDIMPR,SDSUIV,SDSENS,SDOBSE,
     &            SDTIME,SDERRO,SDPOST,DEFICU,RESOCU,
     &            RESOCO,VALINC,SOLALG,MEASSE,VEELEM,
     &            MEELEM,VEASSE,CODERE)
C
C --- PREMIER INSTANT
C
      NUMINS = 1
      INCRUN = 1
C
C --- QUELQUES FONCTIONNALITES ACTIVEES
C
      LSENS  = ISFONC(FONACT,'SENSIBILITE')
      LERRT  = ISFONC(FONACT,'ERRE_TEMPS')
      LIMPEX = ISFONC(FONACT,'IMPL_EX')
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE')
      LMPAS  = NDYNLO(SDDYNA,'MULTI_PAS')
      LCONT  = ISFONC(FONACT,'CONTACT')
      LBOUCL = ISFONC(FONACT,'BOUCLE_EXTERNE')
C
C ======================================================================
C     BOUCLE SUR LES PAS DE TEMPS
C ======================================================================
C
 200  CONTINUE
C
      CALL JERECU('V')
      CALL NMTIME('DEBUT','PAS',SDTIME,LBID  ,R8BID )
C
C --- DECOUPE INITIALE DU PAS DE TEMPS
C
      CALL NMDCIN(SDDISC,SDCRIT,NUMINS)
C
C --- INITIALISATION DES CHAMPS D'INCONNUES POUR LE NOUVEAU PAS DE TEMPS
C
      CALL NMNPAS(MODELE,MAILLA,MATE  ,CARELE,LISCHA,
     &            FONACT,SDDISC,SDSENS,SDDYNA,SDNUME,
     &            NUMEDD,NUMINS,CONV  ,DEFICO,RESOCO,
     &            VALINC,SOLALG)
C
C --- CALCUL DES CHARGEMENTS CONSTANTS AU COURS DU PAS DE TEMPS
C
      CALL NMCHAR('FIXE',' '   ,
     &            MODELE,NUMEDD,MATE  ,CARELE,COMPOR,
     &            LISCHA,CARCRI,NUMINS,SDDISC,PARCON,
     &            FONACT,DEFICO,RESOCO,RESOCU,COMREF,
     &            VALINC,SOLALG,VEELEM,MEASSE,VEASSE,
     &            SDSENS,SDDYNA)
C
C ======================================================================
C    BOUCLE POUR CONTACT
C ======================================================================
C
      IF (LBOUCL) THEN
        NIVEAU = 4
      ELSE
        NIVEAU = -1
      ENDIF
C
  101 CONTINUE
C
      ITERAT = 0
C
      CALL NMIBLE(NIVEAU,
     &            NUMINS,MODELE,MAILLA,DEFICO,RESOCO,
     &            FONACT,NUMEDD,SDDYNA,SDDISC,SDTIME,
     &            ITERAT,VALINC,SOLALG,LNOPRE)
C
C --- ON SAUTE LA PREDICTION
C
      IF (LNOPRE) THEN
        GOTO 300
      ENDIF
C
C --- PREDICTION D'UNE DIRECTION DE DESCENTE
C
      CALL NMPRED(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &            COMREF,COMPOR,LISCHA,METHOD,SOLVEU,
     &            FONACT,PARMET,CARCRI,SDDISC,SDTIME,
     &            SDNUME,NUMINS,VALINC,SOLALG,LICCVG,
     &            MATASS,MAPREC,DEFICO,RESOCO,RESOCU,
     &            SDDYNA,CODERE,MEELEM,MEASSE,VEELEM,
     &            VEASSE)
C
C --- PREMIER INSTANT PASSE
C
      CALL DIBCLE(SDDISC,'PREMIE','E',INCRUN)
C
C ======================================================================
C     BOUCLE SUR LES ITERATIONS DE NEWTON
C ======================================================================
C
 300  CONTINUE
C
      CALL NMTIME('DEBUT','ITE',SDTIME,LBID  ,R8BID )
C
C --- CALCUL PROPREMENT DIT DE L'INCREMENT DE DEPLACEMENT
C --- EN CORRIGEANT LA (LES) DIRECTIONS DE DESCENTE
C --- SI CONTACT OU PILOTAGE OU RECHERCHE LINEAIRE
C
      CALL NMDEPL(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &            COMPOR,LISCHA,FONACT,PARMET,CARCRI,
     &            MAILLA,METHOD,NUMINS,ITERAT,MATASS,
     &            SDDISC,SDDYNA,SDNUME,SDPILO,SDTIME,
     &            DEFICO,RESOCO,DEFICU,RESOCU,VALINC,
     &            SOLALG,VEELEM,VEASSE,ETA   ,LICCVG,
     &            CONV  )
C
C --- SI ECHEC DU PILOTAGE
C
      IF (LICCVG(1).EQ.1) THEN
        GOTO 4000
      ENDIF
C
C --- SI EXPLICITE: PAS DE CORRECTION
C
      IF (LEXPL) THEN
        GOTO 4000
      ENDIF
C
C --- CALCUL DES FORCES APRES CORRECTION
C
      CALL NMFCOR(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &            COMPOR,LISCHA,FONACT,PARMET,CARCRI,
     &            METHOD,NUMINS,ITERAT,SDDISC,SDDYNA,
     &            SDSENS,SDTIME,SDNUME,DEFICO,RESOCO,
     &            RESOCU,PARCON,VALINC,SOLALG,VEELEM,
     &            VEASSE,MEELEM,MEASSE,LICCVG)
C
C --- SUIVI DE DDL
C
      CALL NMSUIV(MAILLA,SDSUIV,SDIMPR,SDDYNA,VALINC,
     &            VEASSE,RESOCO)
C
C --- ESTIMATION DE LA CONVERGENCE
C
 4000 CONTINUE
C
      CALL NMCONV(MAILLA,MATE  ,NUMEDD,FONACT,SDDYNA,
     &            SDIMPR,SDDISC,SDCRIT,SDERRO,SDTIME,
     &            PARMET,COMREF,MATASS,NUMINS,ITERAT,
     &            CONV  ,ETA   ,PARCRI,DEFICO,RESOCO,
     &            LICCVG,VALINC,SOLALG,MEASSE,VEASSE,
     &            ITEMAX,CONVER,ERROR ,FINPAS,MAXREL)
C
C --- VERIFICATION DES EVENT-DRIVEN
C
      CALL NMEVDR(SDDISC,CONVER,VALINC,LICCVG,LEVDRI,
     &            ACTION)
C
C --- ON A CONVERGE ON FINIT LE PAS DE TEMPS
C
540   CONTINUE
C
      IF (CONVER .OR. LIMPEX) THEN
        CALL NMTIME('FIN','ITE',SDTIME,LBID  ,R8BID )
        GOTO 550
      ENDIF
C
C --- CA NE SE PASSE PAS BIEN... ACTION
C         0 ON TENTE DE REDECOUPER
C         1 ON RECOMMENCE
C
      IF (ITEMAX .OR. ERROR .OR. LEVDRI)  THEN
        IF (ACTION.EQ.1) THEN
          CALL NMTIME('FIN','ITE',SDTIME,LBID,R8BID)
          CALL NMTIME('FIN','PAS',SDTIME,LBID,R8BID)
          GOTO 600
        ELSE IF (ACTION.EQ.0) THEN
          GOTO 500
        ENDIF
      ENDIF
C
C --- ON CONTINUE LES ITERATIONS DE NEWTON : CALCUL DE LA DESCENTE
C
      CALL NMDESC(MODELE,NUMEDD,NUMFIX,MATE  ,CARELE,
     &            COMREF,COMPOR,LISCHA,RESOCO,METHOD,
     &            SOLVEU,PARMET,CARCRI,FONACT,NUMINS,
     &            ITERAT,SDDISC,SDTIME,SDDYNA,SDNUME,
     &            MATASS,MAPREC,DEFICO,VALINC,SOLALG,
     &            ETA   ,LICCVG,MEELEM,MEASSE,VEASSE,
     &            VEELEM)
C
      CALL NMTIME('FIN','ITE',SDTIME,LBID  ,R8BID )
      ITERAT = ITERAT + 1
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
      IF ( ETAUSR().EQ.1 ) THEN
         GOTO 1000
      ENDIF
C
C --- TEMPS DISPONIBLE POUR FAIRE UNE NOUVELLE ITERATION DE NEWTON ?
C
      CALL NMTIME('MES','ITE',SDTIME,MTCPUI,R8BID )
      IF (MTCPUI) THEN
        GOTO 1000
      ELSE
        GOTO 300
      ENDIF
C
C --- EN L'ABSENCE DE CONVERGENCE ON CHERCHE A SUBDIVISER LE PAS
C --- DE TEMPS SI L'UTILISATEUR A FAIT LA DEMANDE
C
 500  CONTINUE
C
C ======================================================================
C     FIN DES ITERATIONS DE NEWTON
C ======================================================================
C
C
C --- GESTION DE LA DECOUPE DU PAS DE TEMPS
C
      CALL NMDECO(PARCRI,SDDISC,ITERAT,SDTIME,NUMINS,
     &            ITEMAX,ERROR ,ACTION)
C
C --- ACTION
C       0 ARRET DU CALCUL
C       1 NOUVEAU PAS DE TEMPS
C       2 ON FAIT DES ITERATIONS DE NEWTON EN PLUS
C       3 ON FINIT LE PAS DE TEMPS
C
      IF (ACTION.EQ.1) THEN
        GOTO 600
      ELSEIF (ACTION.EQ.2) THEN
        GOTO 540
      ELSEIF (ACTION.EQ.3) THEN
        CALL U2MESS('A','MECANONLINE2_37')
        GOTO 550
      ELSE
        GOTO 1000
      ENDIF
C
 550  CONTINUE

C ======================================================================
C  FIN DU PAS DE TEMPS
C ======================================================================

      CALL NMTBLE(NIVEAU,
     &            MODELE,MAILLA,MATE  ,DEFICO,RESOCO,
     &            FONACT,MAXREL,SDIMPR,SDTIME,SDDYNA,
     &            VALINC)

      IF (NIVEAU.GT.0) THEN
        GOTO 101
      ENDIF
C
C ======================================================================
C  FIN BOUCLE POUR CONTACT METHODE CONTINUE
C ======================================================================
C
C
C --- FIN MESURE TEMPS PAS DE TEMPS
C
      CALL NMTIME('FIN','PAS',SDTIME,LBID  ,R8BID)
C
C ======================================================================
C  POST-TRAITEMENTS
C ======================================================================
C      
C
C --- CALCUL EVENTUEL DE L'INDICATEUR D'ERREUR TEMPORELLE
C
      IF (LERRT) THEN
        CALL NMETCA(MODELE,MAILLA,MATE  ,SDDISC,SDERRO,
     &              NUMINS,VALINC)
      ENDIF
C
C --- POST_TRAITEMENT DU CONTACT
C
      IF (LCONT) THEN
        CALL CFMXPO(MAILLA,MODELE,DEFICO,RESOCO,NUMINS,
     &              SDDISC,SOLALG,VALINC,VEASSE)
      ENDIF
C
C --- CALCUL DE POST-TRAITEMENT: FLAMBEMENT ET MODES VIBRATOIRES
C
      CALL NMPOST(MODELE,NUMEDD,NUMFIX,CARELE,COMPOR,
     &            SOLVEU,NUMINS,MATE  ,COMREF,LISCHA,
     &            DEFICO,RESOCO,PARMET,FONACT,CARCRI,
     &            ITERAT,SDDISC,SDTIME,VALINC,SOLALG,
     &            MEELEM,MEASSE,VEELEM,SDDYNA,SDPOST)
C
C --- CALCUL DE SENSIBILITE
C
      IF (LSENS) THEN
        CALL NMSENS(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &              LISCHA,FONACT,SOLVEU,NUMINS,CARCRI,
     &              COMREF,DEFICO,RESOCO,RESOCU,PARCON,
     &              MATASS,MAPREC,SDSENS,SDDYNA,SDDISC,
     &              VALINC,SOLALG,VEELEM,VEASSE,MEASSE)
      ENDIF
C
C --- OBSERVATION EVENTUELLE
C
      CALL NMOBSV(MAILLA,SDDISC,SDOBSE,SDDYNA,RESOCO,
     &            VALINC,VEASSE,NUMINS)      
C
C --- ARCHIVAGE DES RESULTATS
C
      FINPAS = FINPAS .OR. DIDERN(SDDISC, NUMINS)
C
      CALL NMTIME('DEBUT','ARC',SDTIME,LBID  ,R8BID )
C
      FORCE  = MTCPUP.OR.FINPAS
      CALL ONERRF(COMPEX,K16BID,IBID  )
      CALL NMARCH(NUMINS,MODELE,MATE  ,CARELE,FONACT,
     &            COMPOR,CARCRI,SDDISC,SDPOST,SDCRIT,
     &            SDERRO,SDSENS,SDDYNA,SDPILO,DEFICO,
     &            RESOCO,VALINC,LISCH2,FORCE )
      CALL ONERRF('EXCEPTION+VALID',K16BID,IBID  )
C
      CALL NMTIME('FIN','ARC',SDTIME,LBID  ,R8BID )      
C
C --- ADAPTATION DU NOUVEAU PAS DE TEMPS
C
      CALL NMADAT(SDDISC,NUMINS,ITERAT,VALINC,FINPAS)
C
C --- MISE A JOUR DES CHAMPS POUR NOUVEAU PAS DE TEMPS
C
      CALL NMFPAS(FONACT,SDDYNA,SDPILO,ETA   ,VALINC,
     &            SOLALG)
      NUMINS = NUMINS + 1
C
 600  CONTINUE
C
C --- TEMPS DISPONIBLE POUR FAIRE UN NOUVEAU PAS DE TEMPS ?
C
      CALL NMTIME('MES','PAS',SDTIME,MTCPUP,R8BID )
C
C --- IMPRESSION STATISTIQUES POUR LE PAS DE TEMPS
C
      CALL NMSTAT('PAS',FONACT,SDTIME,SDDYNA,NUMINS,
     &            DEFICO,RESOCO)
C
C --- DERNIER INSTANT DE CALCUL ? -> ON SORT DE STAT_NON_LINE
C
      IF (FINPAS) THEN
        GOTO 900
      ENDIF
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
      IF ( ETAUSR().EQ.1 ) THEN
         GOTO 1000
      ENDIF
C
C --- PLUS ASSEZ DE TEMPS -> ON SORT PROPREMENT
C
      IF (MTCPUP) THEN
        GOTO 1000
      ENDIF
C
C --- SAUVEGARDE DU SECOND MEMBRE SI MULTI_PAS EN DYNAMIQUE
C
      IF (LMPAS) THEN
        CALL NMCHSV(FONACT,VEASSE,SDDYNA)
      ENDIF

      GOTO 200

C ======================================================================
C     GESTION DES ERREURS
C ======================================================================

1000  CONTINUE
C
C --- ON COMMENCE PAR ARCHIVER LE PAS DE TEMPS PRECEDENT
C
      IF (NUMINS.NE.1) THEN
        FORCE = .TRUE.
        CALL NMARCH(NUMINS-1,MODELE,MATE,CARELE,FONACT,
     &              COMPOR,CARCRI,SDDISC,SDPOST,SDCRIT,
     &              SDERRO,SDSENS,SDDYNA,SDPILO,DEFICO,
     &              RESOCO,VALINC,LISCH2,FORCE )
      ENDIF
C
C --- GESTION DES ERREURS ET EXCEPTIONS
C
      CALL NMERRO(MTCPUI,MTCPUP,ITEMAX,NUMINS,ITERAT,
     &            SDERRO,SDTIME)

C ======================================================================
C     SORTIE
C ======================================================================

 900  CONTINUE
C
C --- IMPRESSION STATISTIQUES FINALES
C
      CALL NMSTAT('FIN' ,FONACT,SDTIME,SDDYNA,NUMINS,
     &            DEFICO,RESOCO)
C
C --- ON REMET LE MECANISME D'EXCEPTION A SA VALEUR INITIALE
C
      CALL ONERRF(COMPEX,K16BID,IBID  )
C
C --- MENAGE
C
      CALL NMMENG(FONACT,MATASS,SOLVEU)
C
      CALL JEDEMA()

      END
