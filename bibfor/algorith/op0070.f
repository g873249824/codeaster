      SUBROUTINE OP0070 (IER)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/05/2004   AUTEUR SMICHEL S.MICHEL-PONNELLE 
C ======================================================================
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
C RESPONSABLE JMBHH01 J.M.PROIX
C TOLE CRP_20
C
      IMPLICIT NONE
C
      INTEGER            IER
C ----------------------------------------------------------------------
C     COMMANDE:  STAT_NON_LINE
C
C IN  LICCVG : LICCVG(1) : PILOTAGE
C                        =  0 CONVERGENCE
C                        =  1 PAS DE CONVERGENCE
C                        = -1 BORNE ATTEINTE
C              LICCVG(2) : INTEGRATION DE LA LOI DE COMPORTEMENT
C                        = 0 OK
C                        = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
C                        = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
C              LICCVG(3) : TRAITEMENT DU CONTACT 
C                        = 0 OK
C                        = 1 ECHEC (ITER > 2*NBLIAI+1)
C              LICCVG(4) : MATRICE DE CONTACT
C                        = 0 OK
C                        = 1 MATRICE DE CONTACT SINGULIERE
C              LICCVG(5) : MATRICE DU SYSTEME (MATASS)
C                        = 0 OK
C                        = 1 MATRICE SINGULIERE
C
C  OUT: IER =      NOMBRE D'ERREURS RENCONTREES
C ----------------------------------------------------------------------
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
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0070' )
C
      LOGICAL      ECHLDC, ITEMAX, CONVER, FINPAS, FINTPS, FONACT(4)
      LOGICAL      DIDERN, ECHCON(2), REAROT, LAMORT, LBID,   LIMPED
      LOGICAL      PREMIE, LONDE,  ECHEQU, LOBSER
      LOGICAL      LREAC(4)
C
      INTEGER      LICCVG(5), MAXB(4), VECONT(2)
      INTEGER      IFM,    NIV,    NEQ,    IRET,   IBID,   I 
      INTEGER      NUMINS, ITERAT, KNOEU,  KMAIL,  KPOIN
      INTEGER      JDEPDE, JDEPP,  JDDEPL, IECPCO, JARCH
      INTEGER      COMGEO, CSEUIL, COBCA,  INDRO,  ISNNEM, NBMODS
      INTEGER      NMODAM, NREAVI, NONDP,  KCHAM,  KCOMP
      INTEGER      KNUCM,  NBOBSE, NUINS0
      INTEGER      NBOBAR, NUOBSE, NBPASE, NIVEAU
      INTEGER      NRPASE, IAUX,   JAUX , IFLAMB,  DININS
C
      REAL*8       PARMET(30), PARCRI(11), CONV(21), ETA, ETAN, R8VIDE
      REAL*8       DIINST,     INSTAM,     INSTAP,   INST(3),   ALPHA
      REAL*8       V0VIT,      V0ACC,      A0VIT,    A0ACC,     COEVIT
      REAL*8       COEACC,     DELTA,      TPS1(4),  TPS2(4),   TPS3(4)
      REAL*8       PARCON(5),  TPS1M
C
      CHARACTER*8  RESULT, MODEDE, MAILLA, SCONEL, MCONEL, K8BID
      CHARACTER*8  MAILL2, BASENO
C
      CHARACTER*13 INPSCO,K13BID
      CHARACTER*14 PILOTE
C
      CHARACTER*16 METHOD(6), OPTION, CMD, K16BID
C
      CHARACTER*19 LISCHA, SOLVEU, SOLVDE, PARTPS, CRITNL
      CHARACTER*19 CNRESI, CNDIRI, CNVCFO, CNFEXT, CNVFRE
      CHARACTER*19 NURO,   CARTCF, LIGRCF, CNSINR, FOINER
      CHARACTER*19 MAPREC, LISOBS, NOMTAB, AUTOC1, AUTOC2
      CHARACTER*19 MATRIX(2)
C
      CHARACTER*24 MODELE, NUMEDD, MATE  , CARELE, COMPOR, CARCRI
      CHARACTER*24 NUMEDE, DEFICO, RESOCO, K24BLA, K24BID, TEMPLU
      CHARACTER*24 DEPMOI, SIGMOI, VARMOI, VARDEM, LAGDEM, MEMASS
      CHARACTER*24 DEPPLU, SIGPLU, VARPLU, VARDEP, LAGDEP, DEPDEL
      CHARACTER*24 COMMOI, COMPLU, COMREF, DDEPLA, DEPOLD, DEPPIL(2)
      CHARACTER*24 CNFEDO, CNFEPI, CNDIDO, CNDIPI, CNFSDO, CNFSPI
      CHARACTER*24 CNDIDI, CNCINE, MEDIRI, DEPENT, VITENT, ACCENT
      CHARACTER*24 VITMOI, ACCMOI, DEPENM, VITENM, ACCENM, VARIGV
      CHARACTER*24 DEPKM1, VITKM1, ACCKM1, VITPLU, ACCPLU, ROMKM1
      CHARACTER*24 ROMK,   MAESCL, OLDGEO, NEWGEO, DEPGEO, DEPLAM      
      CHARACTER*24 STADYN, MASSE,  AMORT,  VALMOD, BASMOD, CHONDP
      CHARACTER*24 FONDEP, FONVIT, FONACC, MULTAP, PSIDEL
      CHARACTER*24 VALMOI(8), VALPLU(8), SECMBR(8), POUGD(8), MULTIA(8)
      CHARACTER*24 LISINS, VITINI, ACCINI
C
C ----------------------------------------------------------------------
C
      DATA LISCHA, PARTPS    /'&&OP0070.LISCHA', '&&OP0070.PARTPS'/
      DATA CRITNL, CARCRI    /'&&OP0070.CRITERE','&&OP0070.PARA_LDC'/
      DATA SOLVEU, SOLVDE    /'&&OP0070.SOLVEUR','&&OP0070.SOLVDE'/
      DATA PILOTE, RESOCO    /'&&OP0070.PILOT',  '&&OP0070.RESOC'/
      DATA DEPDEL, DDEPLA    /'&&OP0070.DEPDEL', '&&OP0070.DDEPLA'/
      DATA DEPPIL            /'&&OP0070.DEPPIL0','&&OP0070.DEPPIL1'/
      DATA DEPOLD, DEFICO    /'&&OP0070.DEPOLD', '&&OP0070.DEFIC'/
      DATA VITMOI, ACCMOI    /'&&OP0070.VITMOI', '&&OP0070.ACCMOI'/
      DATA DEPKM1,VITKM1     /'&&OP0070.DEPKM1', '&&OP0070.VITKM1'/
      DATA ACCKM1            /'&&OP0070.ACCKM1'/
      DATA VITPLU, ACCPLU    /'&&OP0070.VITPLU', '&&OP0070.ACCPLU'/
      DATA VITINI, ACCINI    /'&&OP0070.VITINI', '&&OP0070.ACCINI'/
      DATA DEPENT,VITENT     /'&&OP0070.DEPENT', '&&OP0070.VITENT'/
      DATA ACCENT            /'&&OP0070.ACCENT'/
      DATA ROMKM1,ROMK       /'&&OP0070.ROMKM1', '&&OP0070.ROMK  '/
      DATA DEPENM,VITENM     /'&&OP0070.DEPENM', '&&OP0070.VITENM'/
      DATA ACCENM            /'&&OP0070.ACCENM'/
      DATA NURO              /'&&OP0070.NUME.ROTATION'/
      DATA DEPGEO, DEPLAM    /'&&OP0070.DEPGEO', '&&OP0070.DEPLAM'/
      DATA LIGRCF, CARTCF    /'&&OP0070.LIMECF', '&&OP0070.CARTCF'/
      DATA NEWGEO            /'&&OP0070.ACTUGEO'/
      DATA VARDEM, VARDEP    /'&&OP0070.VARDEM', '&&OP0070.VARDEP'/
      DATA LAGDEM, LAGDEP    /'&&OP0070.LAGDEM', '&&OP0070.LAGDEP'/
      DATA VARIGV            /'&&OP0070.VARIGV'/
      DATA COMMOI, COMPLU    /'&&OP0070.COMOI' , '&&OP0070.COPLU' /
      DATA COMREF            /'&&OP0070.COREF'/
      DATA CNFEDO, CNFEPI    /'&&OP0070.CNFEDO', '&&OP0070.CNFEPI'/
      DATA CNFSDO, CNFSPI    /'&&OP0070.CNFSDO', '&&OP0070.CNFSPI'/
      DATA CNDIDO, CNDIPI    /'&&OP0070.CNDIDO', '&&OP0070.CNDIPI'/
      DATA CNDIDI, CNCINE    /'&&OP0070.CNDIDI', '&&OP0070.CNCINE'/
      DATA CNRESI, CNDIRI    /'&&OP0070.CNRESI', '&&OP0070.CNDIRI'/
      DATA CNFEXT, MEDIRI    /'&&OP0070.CNFEXT', '&&MEDIRI.LISTE_RESU'/
      DATA CNVCFO, CNVFRE    /'&&OP0070.CNVCFO', '&&OP0070.CNVFRE'/
      DATA MEMASS, FOINER    /'&&OP0070.MEMASS', '&&OP0070.FOINER'/
      DATA AMORT , MASSE     /'&&OP0070.MAMORT', '&&OP0070.MMASSE'/
      DATA STADYN            /'&&OP0070.STA_DYN'/
      DATA MCONEL, SCONEL    /'&&CFMMEL', '&&CFMVEL'/
      DATA FONDEP, FONVIT    /'&&FONDEP', '&&FONVIT'/
      DATA FONACC, PSIDEL    /'&&FONACC', '&&PSIDEL'/
      DATA MULTAP, VALMOD    /'&&MULTAP', '&&VALMOD'/
      DATA BASMOD            /'&&BASMOD'/
      DATA AUTOC1            /'&&OP0070.REAC.AUTO1'/
      DATA AUTOC2            /'&&OP0070.REAC.AUTO2'/
      DATA CNSINR            /' '/
      DATA K24BLA            /' '/

C ----------------------------------------------------------------------
      CALL JEMARQ()

C -- INITIALISATIONS UTILES

      INPSCO = '&&'//NOMPRO//'_PSCO'
      COMGEO = 0
      CSEUIL = 0
      COBCA  = 0
      NMODAM = 0
      NBMODS = 0
      COEVIT = 0.D0
      COEACC = 0.D0
      ETA    = 0.D0
      LONDE  = .FALSE.
      LIMPED = .FALSE.
      LAMORT = .FALSE.
      LBID   = .FALSE.
      K8BID  = ' '   
      K13BID = ' '   
      K24BID = ' '   

C -- TITRE

      CALL TITRE ()
      CALL INFMAJ
      CALL INFNIV (IFM,NIV)

C ======================================================================
C               RECUPERATION DES OPERANDES ET INITIALISATION
C ======================================================================

C -- QUELLE COMMANDE APPELLE CETTE OP (STA OU DYN)

      CALL GETRES ( RESULT, K16BID, CMD )

C
C -- LECTURE DES OPERANDES DE LA COMMANDE (DEBUT)
C
      BASENO = '&&'//NOMPRO
      CALL NMLECT (RESULT, MODELE, MATE  , CARELE, COMPOR,
     &             LISCHA, METHOD, SOLVEU, PARMET, PARCRI,
     &             CARCRI, MODEDE, SOLVDE, NBPASE, BASENO,
     &             INPSCO, PARCON )
     
C -- DEFINITION DES NOMS DES CHAMPS 
      IAUX = 0
      JAUX = 4
      CALL PSNSLE(INPSCO,IAUX,JAUX,DEPPLU)
      JAUX = 5
      CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOI)
      JAUX = 8
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGPLU)
      JAUX = 9
      CALL PSNSLE(INPSCO,IAUX,JAUX,SIGMOI)
      JAUX = 10
      CALL PSNSLE(INPSCO,IAUX,JAUX,VARPLU)
      JAUX = 11
      CALL PSNSLE(INPSCO,IAUX,JAUX,VARMOI)
      IF (CMD(1:4).EQ.'DYNA') THEN
        JAUX = 14
        CALL PSNSLE(INPSCO,IAUX,JAUX,VITPLU)
        JAUX = 16
        CALL PSNSLE(INPSCO,IAUX,JAUX,ACCPLU)
        JAUX = 18
        CALL PSNSLE(INPSCO,IAUX,JAUX,DEPENT)
        JAUX = 20
        CALL PSNSLE(INPSCO,IAUX,JAUX,VITENT)
        JAUX = 22
        CALL PSNSLE(INPSCO,IAUX,JAUX,ACCENT)
      END IF


C -- CREATION DE VARIABLES "CHAPEAU" POUR STOCKER LES NOMS
C      VALMOI : ETAT EN T-
C      VALPLU : ETAT EN T+
C      SECMBR : CHARGEMENTS
C      POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C      MULTIA : INFOS MULTI-APPUI

      CALL AGGLOM (DEPMOI, SIGMOI, VARMOI, COMMOI,
     &             K24BLA, K24BLA, K24BLA, K24BLA, 4, VALMOI)
      CALL AGGLOM (DEPPLU, SIGPLU, VARPLU, COMPLU,
     &             VARDEP, LAGDEP, VARIGV, K24BLA, 7, VALPLU)
      CALL AGGLOM (CNFEDO, CNFEPI, CNDIDO, CNDIPI,
     &             CNFSDO, CNFSPI, CNDIDI, CNCINE, 8, SECMBR)
      CALL AGGLOM (DEPKM1, VITKM1, ACCKM1, VITPLU,
     &             ACCPLU, ROMKM1, ROMK  , DDEPLA, 8, POUGD )
      CALL AGGLOM (FONDEP, FONVIT, FONACC, MULTAP,
     &             PSIDEL, K24BLA, K24BLA, K24BLA, 5, MULTIA )


C
C -- LECTURE DES OPERANDES DE LA COMMANDE (FIN)
C
      IF (CMD(1:4).EQ.'DYNA') 
     &   CALL NDLECT(MODELE, MATE,  LISCHA, STADYN, LAMORT,
     &               ALPHA, DELTA,  V0VIT,  V0ACC,  A0VIT, 
     &               A0ACC, NBMODS, NMODAM, VALMOD, BASMOD,
     &               NREAVI, LIMPED, LONDE, CHONDP, NONDP,
     &               MULTIA)
           
      CALL DISMOI ('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)


C -- MATRICE DE RIGIDITE ASSOCIEE AUX LAGRANGE

      CALL MEDIME (MODELE,LISCHA,MEDIRI)


C -- ETAT INITIAL ET CREATION DES STRUCTURES DE DONNEES

      CALL NMINIT(RESULT, MODELE, MODEDE, NUMEDD, MATE,
     &            SOLVDE, NUMEDE, COMPOR, CARELE, MEMASS,
     &            MEDIRI, LISCHA, DEPMOI, VALMOI, VITPLU,
     &            ACCPLU, MAPREC, SOLVEU, CARCRI, PARTPS,
     &            NURO,   REAROT, VARDEM, LAGDEM, CNDIDI,
     &            PILOTE, DEFICO, RESOCO, CRITNL, FONACT,
     &            CMD,    DEPENT, VITENT, ACCENT, NBMODS,
     &            CNVFRE, PARCON, PARCRI(6), 
     &            NBPASE, INPSCO)
     
      INSTAM = DIINST(PARTPS, 0)
      

  
C -- SAISIE DE LA LISTE DES INSTANTS D'OBSERVATION

      CALL INIOBS(NBOBSE, NUINS0, LOBSER, INSTAM, RESULT,
     &            NUOBSE, NOMTAB, KCHAM,  KCOMP,  KNUCM, 
     &            KNOEU,  KMAIL,  KPOIN,  MAILL2, NBOBAR, 
     &            LISINS, LISOBS)


C -- PARAMETRES D'IMPRESSION

      CALL NMIMPR('INIT',' ',' ',0.D0,0)


C -- CREATION DES VECTEURS D'INCONNUS 

      CALL NMCRCH(CMD,    DEPPLU, DEPDEL, DEPOLD, DDEPLA, DEPPIL, 
     &            DEPLAM, DEPKM1, VITKM1, ACCKM1, ROMKM1, ROMK  ,
     &            FOINER, DEPENT, VITENT, ACCENT, DEPENM, VITENM,
     &            ACCENM, VITMOI, ACCMOI, DEPGEO, VITPLU, ACCPLU,
     &            NEQ,    NUMEDD, NBPASE, INPSCO, NBMODS, VITINI,
     &            ACCINI)


C -- MAILLAGE SOUS-TENDU PAR LE MODELE

      CALL DISMOI ('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)


C -- TRAITEMENT DES VARIABLES DE COMMANDE

C    VERIFICATION DE LA COHERENCE MATERIAU / VARIABLES PRESENTES
      CALL NMVCVE(MATE,LISCHA)

C    LECTURE DES VARIABLES DE COMMANDE DE L'INSTANT INITIAL
      CALL NMVCLE(MODELE,MATE,LISCHA,INSTAM,COMMOI)

C    LECTURE DES VALEURS DE REFERENCE DES VARIABLES DE COMMANDE
      CALL NMVCRE(MODELE,MATE,LISCHA,COMREF)

      INDRO = ISNNEM()
      IF (REAROT) CALL JEVEUO (NURO//'.NDRO','L',INDRO)


C -- INITIALISATION DES INDICATEURS DE CONVERGENCE DU CONTACT
      LICCVG(1) = 0
      LICCVG(2) = 0
      LICCVG(3) = 0
      LICCVG(4) = 0
      LICCVG(5) = 0

C ======================================================================
C                   BOUCLE SUR LES PAS DE TEMPS
C ======================================================================

      CALL UTTCPU (1,'INIT',4,TPS1)
      CALL UTTCPU (2,'INIT',4,TPS2)
      CALL UTTCPU (3,'INIT',4,TPS3)

      NUMINS = 1
C ======================================================================
C                REPRISE DE LA BOUCLE EN TEMPS 
C ======================================================================
      PREMIE = .TRUE.
 200  CONTINUE
C
      TPS1M = TPS1(3)
      CALL UTTCPU (1,'DEBUT',4,TPS1)

 210  CONTINUE
      
      IF ((DININS(PARTPS,NUMINS-1)-DININS(PARTPS,NUMINS)).GT.1) THEN
        CALL DIDECO(PARTPS, NUMINS, IRET)
        IF (IRET.EQ.0) THEN
          GOTO 210
        ELSE
          CALL UTMESS('F',NOMPRO,'ERREUR DANS DECOUPE INITIALE DES PAS')
        ENDIF
      ENDIF     
      INSTAP = DIINST(PARTPS, NUMINS)

C -- DOIT-ON FAIRE UNE OBSERVATION

      CALL LOBS(NBOBSE, NUINS0, LOBSER, INSTAP,
     &          NUOBSE, LISINS, LISOBS)

      CALL MISAZL(DEPMOI,DEFICO)      
      CALL NMIMPR('TITR',' ',' ',INSTAP,0)
      DO 10 I = 1 , 21
         CONV(I) = R8VIDE()
 10   CONTINUE

C -- INITIALISATION DU CONTACT POUR LE NOUVEAU PAS DE TEMPS 

      CALL INICNT(NUMINS, NEQ, DEFICO, FONACT, VECONT, LREAC,NUMEDD,
     &                                                  AUTOC1, AUTOC2)

C ======================================================================
C        EVALUATION DES CHAMPS POUR LE NOUVEAU PAS DE TEMPS
C ======================================================================


C -- ESTIMATIONS INITIALES DES VARIABLES INTERNES ET DES MULTIPLICATEURS

      CALL COPISD('CHAMP_GD','V',VARMOI,VARPLU)
      IF (MODEDE.NE.' ') CALL COPISD('CHAMP_GD','V',VARDEM,VARDEP)
      IF (MODEDE.NE.' ') CALL COPISD('CHAMP_GD','V',LAGDEM,LAGDEP)


C -- INITIALISATION DES DEPLACEMENTS, VITESSES 

      CALL COPISD('CHAMP_GD','V',DEPMOI,DEPPLU)
      CALL JEVEUO (DEPDEL(1:19)//'.VALE','E',JDEPDE)
      CALL JEVEUO (DEPPLU(1:19)//'.VALE','E',JDEPP )
      CALL JEVEUO (DDEPLA(1:19)//'.VALE','E',JDDEPL)
      CALL INITIA (NEQ,REAROT,ZI(INDRO),ZR(JDEPP),ZR(JDEPDE))
      IF (CMD(1:4).EQ.'DYNA') 
     &    CALL DINIT (NEQ,V0VIT,V0ACC,A0VIT,A0ACC,ALPHA,DELTA,INSTAM,
     &                 INSTAP,COEVIT,COEACC,DEPPLU,POUGD,DEPENT,VITENT,
     &                 ACCENT,MULTIA,NBMODS,NBPASE,INPSCO)


C -- LECTURE DES VARIABLES DE COMMANDE A L'INSTANT COURANT
      CALL NMVCLE(MODELE(1:8), MATE  , LISCHA, INSTAP, COMPLU)

C -- ESTIMATION D'UNE FORCE DE REFERENCE LIEE AUX VAR. COMMANDES EN T+
      CALL NMVCFO(MODELE(1:8), NUMEDD, MATE  , CARELE, COMREF,
     &            COMPLU, CNVCFO)

C -- ADHERENCE DES POUTRES
      CALL NMVCEX('TEMP',COMPLU,TEMPLU)

C -- PARAMETRES DE L'INSTANT DE CALCUL (SUIVANT SCHEMA D'INTEGRATION)

      INST(1) = INSTAP
      INST(2) = INSTAP - INSTAM
      INST(3) = PARMET(30)

C -- CALCUL DES CHARGEMENTS EXTERIEURS

      CALL NMCHAR ('FIXE', MODELE, NUMEDD, MATE  , CARELE,
     &             K24BLA, LISCHA, K24BLA, INST  , DEPMOI,
     &             DEPDEL, LBID,   VITKM1, ACCKM1, K24BID, 
     &             K24BID, K24BID, K24BID, IBID,   K24BID, 
     &             K24BID, IBID,   LBID,   LONDE,  NONDP,
     &             CHONDP, TEMPLU, 0,      0,      K13BID,
     &             K8BID,  SECMBR)


C -- CALCUL DU CONTACT FROTTEMENT AVEC LA METHODE CONTACT ECP
C -- LES BOUCLES NECESSAIRES SONT TRAITEES PAR
C --      NMICBLE AVANT NEWTON-RAPHSON
C --      NMTBLE  APRES NEWTON-RAPHSON
C -- ET COMMUNIQUENT PAR LA VARIABLE NIVEAU

      MAESCL = DEFICO(1:16)//'.MAESCL'
      CALL JEEXIN(MAESCL,IECPCO)
      IF (IECPCO.EQ.0) THEN
        NIVEAU = -1
      ELSE
        NIVEAU=4
      ENDIF
      
  101 CONTINUE
  
      CALL NMIBLE(NIVEAU, 
     &            PREMIE, MAILLA, DEFICO, OLDGEO, NEWGEO,
     &            DEPMOI, DEPGEO, MAXB,   DEPLAM,
     &            COMGEO, CSEUIL, COBCA, 
     &            NEQ   , DEPDEL, DDEPLA, DEPPLU, LIGRCF,
     &            CARTCF, MODELE, LISCHA, SOLVEU, NUMEDD, 
     &            MCONEL, SCONEL, MEMASS, MASSE, VITPLU,
     &            ACCPLU, VITINI, ACCINI, CMD)


C ======================================================================
C   PHASE DE PREDICTION : INTERPRETEE COMME UNE DIRECTION DE DESCENTE
C ======================================================================

C -- PREDICTION D'UNE DIRECTION DE DESCENTE

      CALL NMPRED(MODELE, NUMEDD, MATE,   CARELE,  COMREF,
     &            COMPOR, LISCHA, MEDIRI, METHOD,  SOLVEU,
     &            PARMET, CARCRI, PILOTE, PARTPS,  NUMINS,
     &            INST  , DEPOLD, VALMOI, POUGD ,  VALPLU,
     &            SECMBR, DEPPIL, LICCVG, STADYN,
     &            LAMORT, VITPLU, ACCPLU, MASSE,   AMORT,
     &            CMD,    PREMIE, MEMASS, DEPENT,  VITENT,
     &            COEVIT, COEACC, VITKM1, NMODAM,  VALMOD,
     &            BASMOD, LIMPED, LONDE,  NONDP,   CHONDP)

      PREMIE = .FALSE.

C ======================================================================
C              ITERATIONS DE LA METHODE DE NEWTON-RAPHSON
C ======================================================================

C -- REPRISE DE LA BOUCLE D'ITERATIONS DE NEWTON-RAPHSON

      ITERAT = 0
 300  CONTINUE
      CALL UTTCPU (2,'DEBUT',4,TPS2)



C -- CALCUL PROPREMENT DIT DE L'INCREMENT DE DEPLACEMENT
C -- EN CORRIGEANT LA (LES) DIRECTIONS DE DESCENTE
C -- SI CONTACT OU PILOTAGE OU RECHERCHE LINEAIRE
C -- DES FORCES INTERIEURES (RHO SI RL, ETA SI PILOTAGE)
C -- DES RIGI_ELEM (SI DEMANDE)

      ETAN = ETA
      CALL NMDEPL(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &            COMPOR, LISCHA, CNFEXT, PARMET, CARCRI,
     &            MODEDE, NUMEDE, SOLVDE, PARCRI, POUGD ,
     &            ITERAT, VALMOI, RESOCO, VALPLU, CNRESI,
     &            CNDIRI, REAROT, NURO  , METHOD, NUMINS,
     &            OPTION, CONV,   STADYN, DEPENT, VITENT,
     &            LAMORT, MEMASS, MASSE,  AMORT,  COEVIT, 
     &            COEACC, INDRO , SECMBR, INSTAP, INSTAM,
     &            CMD,    ETAN  , PARTPS, PREMIE, FONACT, 
     &            DEPKM1, VITKM1, ACCKM1, VITPLU, ACCPLU,
     &            ROMKM1, ROMK,   PILOTE, DEPDEL, DEPPIL,
     &            DEPOLD, IECPCO, LIGRCF, CARTCF, MCONEL,
     &            SCONEL, MAILLA, DEPPLU, DEFICO, CNCINE,
     &            SOLVEU, LREAC,  ETA   , LICCVG, DDEPLA) 
      IF (LICCVG(1).EQ.1) GOTO 4000

C -- CALCUL DES FORCES SUIVEUSES

      CALL NMCHAR ('SUIV', MODELE, NUMEDD, MATE  , CARELE,
     &             COMPOR, LISCHA, CARCRI, INST  , DEPMOI,
     &             DEPDEL, LAMORT, VITPLU, ACCPLU, K24BID, 
     &             K24BID, K24BID, K24BID, IBID,   K24BID, 
     &             K24BID, IBID,   LBID,   LBID,   IBID,
     &             K24BID, TEMPLU, 0,      0,      K13BID,
     &             K8BID, SECMBR)
     
      IF (CMD(1:4).EQ.'DYNA') THEN
         CALL NMCHAR ('INER', MODELE, NUMEDD, MATE  , CARELE,
     &                COMPOR, LISCHA, CARCRI, INST  , DEPMOI,
     &                DEPDEL, LAMORT, VITPLU, ACCPLU, MASSE,
     &                AMORT,  VITPLU, VITENT, NMODAM, VALMOD,
     &                BASMOD, NREAVI, LIMPED, LONDE,  NONDP,
     &                CHONDP, TEMPLU, 0,      0,      K13BID,
     &                K8BID, SECMBR)
      ENDIF


C -- FORCES D'INERTIE POUR L'ESTIMATION DE LA CONVERGENCE

      CALL NDINER(MASSE,VITPLU,FOINER,CMD,INST,A0VIT)


C -- ESTIMATION DE LA CONVERGENCE ET SUIVI DU CALCUL (IMPRESSION)

      CALL NMFEXT (NUMEDD, ETA , SECMBR,RESOCO,DEFICO,CNFEXT)

      IF (IECPCO.GT.0)  LREAC(4) = .FALSE.

 4000 CONTINUE
      CALL NMCONV (CNRESI, CNDIRI, CNFEXT, CNVCFO, PARCRI,
     &             ITERAT, ETA   , CONV  , LICCVG, ITEMAX,
     &             CONVER, ECHLDC, ECHEQU, ECHCON, FINPAS,
     &             CRITNL, NUMINS, FOINER, PARTPS, PARMET,
     &             NEQ,    DEPDEL, AUTOC1, AUTOC2, VECONT,
     &             LREAC,  CNVFRE)

C -- ON SORT DU PAS DE TEMPS SI : 
C -- 1 - ON A CONVERGE 
C -- 2 - LE NOMBRE D'ITERATIONS MAXIMAL EST ATTEINT 
C -- 3 - SI LA MATRICE EST SINGULIERE 
C -- 4 - S'IL Y A ECHEC DANS L'INTEGRATION DE LA LOI DE COMPORTEMENT 
C -- 5 - S'IL Y A ECHEC DANS LE TRAITEMENT DU CONTACT 
C -- 6 - S'IL Y A ECHEC DANS LE PILOTAGE

      IF ( CONVER    .OR.
     &     ITEMAX    .OR.
     &     ECHEQU    .OR.
     &     ECHLDC    .OR.
     &     ECHCON(1) .OR. ECHCON(2) )  GOTO 500

C -- SINON ON CONTINUE LES ITERATIONS DE NEWTON 

C ======================================================================
C              CALCUL DE LA DIRECTION DE DESCENTE 
C ======================================================================

      CALL NMDESC(MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &            COMPOR, LISCHA, MEDIRI, RESOCO, METHOD,
     &            SOLVEU, PARMET, CARCRI, PILOTE, PARTPS,
     &            NUMINS, ITERAT, VALMOI, POUGD , DEPDEL,
     &            VALPLU, SECMBR, CNRESI, DEPPIL ,ETA   ,
     &            LICCVG, DEFICO, STADYN, PREMIE, CMD,
     &            DEPENT, VITENT, LAMORT, MEMASS, MASSE,
     &            AMORT,  COEVIT, COEACC)


C -- TEMPS DISPONIBLE POUR FAIRE UNE NOUVELLE ITERATION DE NEWTON ?

      CALL UTTCPU (2,'FIN',4,TPS2)
      ITERAT = ITERAT + 1
      IF (2.D0*TPS2(4).LE.0.95D0*TPS2(1)-TPS3(4)) THEN
       GOTO 300
      ELSE

C -- ARRET PAR MANQUE DE TEMPS CPU - ARCHIVAGE DU PAS DE TEMPS PRECEDENT
       IF (NUMINS.NE.1) THEN
        CALL JEVEUO(PARTPS // '.DIAL','L',JARCH)
        IF (.NOT.ZL(JARCH+NUMINS-1)) THEN
          CALL NMARCH (RESULT, NUMINS-1, PARTPS, .TRUE., COMPOR,
     &                CRITNL, VALMOI, CNSINR, CMD ,VITMOI, ACCMOI,
     &                NBMODS,DEPENM,VITENM,ACCENM,.TRUE.)
        ENDIF
       ENDIF
       CALL UTDEBM ('S',NOMPRO,'ARRET PAR MANQUE DE TEMPS CPU')
       CALL UTIMPI ('S',' AU NUMERO D''INSTANT : ',1,NUMINS)
       CALL UTIMPI ('S',' LORS DE L''ITERATION : ',1,ITERAT)
       CALL UTIMPR ('L',' TEMPS MOYEN PAR ITERATION : ',1,TPS2(4))
       CALL UTIMPR ('L',' TEMPS CPU RESTANT: ',1,TPS2(1))
       CALL UTFINM ()
      ENDIF

C ======================================================================
C                      FIN DES ITERATIONS DE NEWTON
C ======================================================================

 500  CONTINUE
      CALL UTTCPU (2,'FIN',4,TPS2)
      IF (CONVER) GOTO 550

C    EN L'ABSENCE DE CONVERGENCE ON CHERCHE A SUBDIVISER LE PAS DE TEMPS
      CALL DIDECO(PARTPS, NUMINS, IRET)
      IF (IRET.EQ.0)  THEN
       CALL UTTCPU (1,'FIN',4,TPS1)
       FINTPS = TPS1(4) .GT. 0.90D0*TPS1(1)
       GOTO 600
      END IF

C    ECHEC DANS LE DEROULEMENT DU CALCUL SANS POUVOIR SUBDIVISER PLUS
C     ECHLDC OU ECHEQU OU ECHCON(1) OU ECHCON(2) OU ITEMAX


      IF (ECHLDC)
     &   CALL UTEXCP(23,NOMPRO,'ARRET PAR ECHEC DE '
     &  // 'L''INTEGRATION DE LA LOI DE COMPORTEMENT')

      IF (ECHEQU) CALL UTMESS('S',NOMPRO,'ARRET POUR CAUSE DE '
     &  // 'MATRICE NON INVERSIBLE')

      IF (ECHCON(1)) CALL UTMESS('S',NOMPRO,'ARRET PAR ECHEC DE '
     &  // 'TRAITEMENT DU CONTACT')

      IF (ECHCON(2)) CALL UTMESS('S',NOMPRO,'ARRET SUR MATRICE DE '
     &  // 'CONTACT SINGULIERE')

      IF (NINT(PARCRI(4)).EQ.1) THEN
        CALL UTMESS('A',NOMPRO,'ATTENTION, ARRET=NON DONC POURSUITE'
     &                // ' DU CALCUL SANS AVOIR EU CONVERGENCE')
        GOTO 550
      END IF

      IF (NINT(PARCRI(4)).EQ.0)
     &   CALL UTEXCP(22,NOMPRO,'ARRET : ABSENCE DE CONVERGENCE '
     &          //'AVEC LE NOMBRE D''ITERATIONS REQUIS')

      CALL UTMESS('F','OP0070_1','ERREUR DVP')

C -- FIN DE BOUCLE DE CONTACT ECP

 550  CONTINUE
      IF (IECPCO.NE.0) THEN
        CALL NMTBLE(NIVEAU, 
     &              MAILLA, DEFICO, OLDGEO, NEWGEO,
     &              DEPMOI, DEPGEO, MAXB,   DEPLAM,
     &              COMGEO, CSEUIL, COBCA, 
     &              DEPPLU)
      ELSE 
        NIVEAU = 0
      ENDIF 
      
      IF (NIVEAU.GT.0) GOTO 101
      
      
C     TEMPS DISPONIBLE
      CALL UTTCPU (1,'FIN',4,TPS1)
      FINTPS = TPS1(4) .GT. 0.90D0*TPS1(1)
      CALL NMIMPR('    ','TPS_PAS',' ',TPS1(3)-TPS1M,0)
      
C
C ======================================================================
C                       ARCHIVAGE ET ACTUALISATION
C ======================================================================


C -- ECRITURE DES NOEUDS EN CONTACT SI ON A CONVERGE

      IF (IECPCO.EQ.0 .AND. .NOT.ECHCON(1) .AND. .NOT.ECHCON(2)) THEN
        CALL RESUCO (NUMINS,INSTAP,DEFICO,RESOCO,DEPDEL,DDEPLA,
     &               MAILLA,CNSINR,ITERAT)
      ENDIF
      
C -- SELON SI L'ON DOIT OBSERVER OU NON

      IF ( LOBSER ) THEN   
         CALL DYOBAR ( NOMTAB, MAILL2, NBOBAR, NUOBSE, INSTAP, 
     &                 ZK16(KCHAM), ZK8(KCOMP), ZI(KNUCM),
     &                 ZK8(KNOEU), ZK8(KMAIL), ZI(KPOIN), 
     &                 VALPLU, VITPLU, ACCPLU, NBMODS,
     &                 DEPENT,VITENT,ACCENT)
      ENDIF      

C -- ARCHIVAGE DES RESULTATS

      FINPAS = FINPAS .OR. DIDERN(PARTPS, NUMINS)
      
      CALL UTTCPU (3,'DEBUT',4,TPS3)
      CALL NMARCH (RESULT, NUMINS, PARTPS, FINTPS.OR.FINPAS, COMPOR,
     &             CRITNL, VALPLU, CNSINR, CMD ,VITPLU, ACCPLU,
     &             NBMODS,DEPENT,VITENT,ACCENT,NBPASE.EQ.0)

      CALL UTTCPU (3,'FIN',4,TPS3)

C -- CALCUL DE SENSIBILITE
      IF (NBPASE.GT.0) THEN
        MATRIX(1)='&&MATASS'
        CALL NMSENS (MODELE,NEQ,NUMEDD,MATE,COMPOR,CARELE,LISCHA,
     &                    COEVIT,COEACC,LAMORT,MASSE,AMORT,NMODAM ,
     &                    VALMOD,BASMOD,LIMPED,NBMODS,
     &                    CMD,SOLVEU,MATRIX,PARTPS,INST,
     &                    NUMINS,SECMBR,NBPASE,INPSCO)
      ENDIF
      
C -- CALCUL DE FLAMBEMENT EN STAT,  ET SANS CONTACT

      IF (CMD(1:4).NE.'DYNA') THEN
      
        CALL GETFAC('CRIT_FLAMB',IFLAMB)

        IF (IFLAMB.GT.0) THEN
        
        CALL NMFLAM(MODELE,NUMEDD,CARELE,COMPOR,SOLVEU,NUMINS,
     &                  VALPLU,RESULT,MATE,COMREF,
     &           LISCHA,MEDIRI,RESOCO,METHOD,PARMET,CARCRI,
     &           ITERAT,POUGD,DEPDEL,PARTPS,
     &           DEFICO,STADYN,PREMIE,CMD,DEPENT,VITENT,LAMORT,
     &           MEMASS,MASSE,AMORT,COEVIT,COEACC,LICCVG)
     
        ENDIF
      ENDIF

C -- DERNIER INSTANT DE CALCUL ?

      IF (FINPAS) GOTO 900


C -- REACTUALISATION

C    POUR UNE PREDICTION PAR EXTRAPOLATION DES INCREMENTS DU PAS D'AVANT
      CALL COPISD('CHAMP_GD','V',DEPDEL,DEPOLD)

C    ETAT AU DEBUT DU NOUVEAU PAS DE TEMPS

      CALL COPISD('CHAMP_GD','V',DEPPLU,DEPMOI)
      CALL COPISD('CHAMP_GD','V',SIGPLU,SIGMOI)
      CALL COPISD('CHAMP_GD','V',VARPLU,VARMOI)
      CALL COPISD('VARI_COM','V',COMPLU,COMMOI)
      IF (MODEDE.NE.' ') CALL COPISD('CHAMP_GD','V',VARDEP,VARDEM)
      IF (MODEDE.NE.' ') CALL COPISD('CHAMP_GD','V',LAGDEP,LAGDEM)
      
      IF (CMD(1:4).EQ.'DYNA') THEN
       CALL COPISD('CHAMP_GD','V',VITPLU,VITMOI)
       CALL COPISD('CHAMP_GD','V',ACCPLU,ACCMOI)
       IF (NBMODS.NE.0) THEN
        CALL COPISD('CHAMP_GD','V',DEPENT,DEPENM)
        CALL COPISD('CHAMP_GD','V',ACCENT,ACCENM)
        CALL COPISD('CHAMP_GD','V',VITENT,VITENM)
       ENDIF
      ENDIF            
      INSTAM = INSTAP
      NUMINS = NUMINS + 1

C -- TEMPS DISPONIBLE POUR FAIRE UN NOUVEAU PAS DE TEMPS ?

 600  CONTINUE

      IF (FINTPS) THEN
        CALL UTDEBM ('S',NOMPRO,'ARRET PAR MANQUE DE TEMPS CPU')
        CALL UTIMPI ('S',' AU NUMERO D''INSTANT : ',1,NUMINS)
        CALL UTIMPR ('L',' TEMPS MOYEN PAR INCREMENT DE CHARGE : ',1,
     &               TPS1(4))
        CALL UTIMPR ('L',' TEMPS CPU RESTANT : ',1,TPS1(1))
        CALL UTFINM ()
      END IF

      GOTO 200

C ======================================================================
C                   FIN DE LA BOUCLE SUR LES PAS DE TEMPS
C ======================================================================

 900  CONTINUE
      CALL JEDETC ('V','.CODI',20)
      CALL JEDETC ('V','&&',1)
      CALL JEDETC ('V','_',1)
      CALL JEDETC ('V',RESULT,1)
      CALL JEDETC ('V','.MATE_CODE',9)
      CALL JEDETR (DEFICO(1:16)//'.DDLCO')
      CALL JEDETR (DEFICO(1:16)//'.PDDLCO')
      
C -- DESTRUCTION DES OBJETS OBSERVATION

      IF ( NBOBSE .NE. 0 ) THEN
         CALL JEDETR ( '&&DYOBSE.MAILLA'   )
         CALL JEDETR ( '&&DYOBSE.NOM_CHAM' )
         CALL JEDETR ( '&&DYOBSE.NOM_CMP ' )
         CALL JEDETR ( '&&DYOBSE.NUME_CMP' )
         CALL JEDETR ( '&&DYOBSE.NOEUD'    )
         CALL JEDETR ( '&&DYOBSE.MAILLE'   )
         CALL JEDETR ( '&&DYOBSE.POINT'    )
      ENDIF

      CALL JEDEMA()
      END
