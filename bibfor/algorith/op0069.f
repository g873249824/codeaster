      SUBROUTINE OP0069 (IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/08/2004   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C RESPONSABLE BOYERE E.BOYERE
C
      IMPLICIT NONE
C
      INTEGER            IER
C ----------------------------------------------------------------------
C     COMMANDE:  DYNA_TRAN_EXPLI
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
      PARAMETER ( NOMPRO = 'OP0069' )
C
      LOGICAL      ECHLDC, ITEMAX,  FINPAS, FINTPS, FONACT(4)
      LOGICAL      DIDERN, ECHCON(2), REAROT, LAMORT, LBID,   LIMPED
      LOGICAL      PREMIE, LONDE,  ECHEQU, LOBSER
      LOGICAL      LREAC(4)
      LOGICAL      LMODAL
C
      INTEGER      LICCVG(5), MAXB(4), VECONT(2)
      INTEGER      IFM,    NIV,    NEQ,    IRET,   IBID,   I 
      INTEGER      NUMINS, ITERAT, KNOEU,  KMAIL,  KPOIN
      INTEGER      JDEPDE, JDEPP,  JDDEPL, IECPCO, JARCH
      INTEGER      JVITM, JACCM, JVITP, JACCP
      INTEGER      COMGEO, CSEUIL, COBCA,  INDRO,  ISNNEM, NBMODS
      INTEGER      NMODAM, NREAVI, NONDP,  KCHAM,  KCOMP
      INTEGER      KNUCM,  NBOBSE, NUINS0
      INTEGER      NBOBAR, NUOBSE, NBPASE, NIVEAU
      INTEGER      NRPASE, IAUX,   JAUX
C
      REAL*8       PARMET(30), PARCRI(11), CONV(21), ETA, ETAN, R8VIDE
      REAL*8       DIINST,     INSTAM,     INSTAP,   INST(3),   ALPHA
      REAL*8       V0VIT,      V0ACC,      A0VIT,    A0ACC,     COEVIT
      REAL*8       COEACC,     DELTA,      TPS1(4),  TPS2(4),   TPS3(4)
      REAL*8       PARCON(5)
      REAL*8       COEVI2, COEAC2, R8BID
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
      CHARACTER*19 CNRESI, CNDIRI, CNVCFO,  CNVFRE
      CHARACTER*19 NURO,   CARTCF, LIGRCF, CNSINR, FOINER
      CHARACTER*19 MAPREC, LISOBS, NOMTAB, AUTOC1, AUTOC2
      CHARACTER*19 MATRIX(2)
      CHARACTER*19 CNVCPR, LISCH2
C
      CHARACTER*24 MODELE, NUMEDD, MATE  , CARELE, COMPOR, CARCRI
      CHARACTER*24 NUMEDE, DEFICO, RESOCO, K24BLA, K24BID, TEMPLU
      CHARACTER*24 DEPMOI, SIGMOI, VARMOI, VARDEM, LAGDEM, MEMASS
      CHARACTER*24 DEPPLU, SIGPLU, VARPLU, VARDEP, LAGDEP, DEPDEL
      CHARACTER*24 COMMOI, COMPLU, COMREF, DDEPLA, DEPOLD, DEPPIL(2)
      CHARACTER*24 CNFEDO, CNFEPI, CNDIDO, CNDIPI, CNFSDO, CNFSPI
      CHARACTER*24 CNDIDI, CNCINE, MEDIRI, DEPENT, VITENT, ACCENT
      CHARACTER*24 VITMOI, ACCMOI, DEPENM, VITENM, ACCENM
      CHARACTER*24 DEPKM1, VITKM1, ACCKM1, VITPLU, ACCPLU, ROMKM1
      CHARACTER*24 ROMK,   MAESCL, OLDGEO, NEWGEO, DEPGEO, DEPLAM      
      CHARACTER*24 STADYN, MASSE,  AMORT,  VALMOD, BASMOD, CHONDP
      CHARACTER*24 FONDEP, FONVIT, FONACC, MULTAP, PSIDEL
      CHARACTER*24 VALMOI(8), VALPLU(8), SECMBR(8), POUGD(8), MULTIA(8)
      CHARACTER*24 LISINS
      CHARACTER*24 MASGEN, BASMOI, MERIGI, NOOBJ
C
C ----------------------------------------------------------------------
C
      DATA LISCHA, PARTPS    /'&&OP0069.LISCHA', '&&OP0069.PARTPS'/
      DATA CRITNL, CARCRI    /'&&OP0069.CRITERE','&&OP0069.PARA_LDC'/
      DATA SOLVEU, SOLVDE    /'&&OP0069.SOLVEUR','&&OP0069.SOLVDE'/
      DATA PILOTE, RESOCO    /'&&OP0069.PILOT',  '&&OP0069.RESOC'/
      DATA DEPDEL, DDEPLA    /'&&OP0069.DEPDEL', '&&OP0069.DDEPLA'/
      DATA DEPPIL            /'&&OP0069.DEPPIL0','&&OP0069.DEPPIL1'/
      DATA DEPOLD, DEFICO    /'&&OP0069.DEPOLD', '&&OP0069.DEFIC'/
      DATA VITMOI, ACCMOI    /'&&OP0069.VITMOI', '&&OP0069.ACCMOI'/
      DATA DEPKM1,VITKM1     /'&&OP0069.DEPKM1', '&&OP0069.VITKM1'/
      DATA ACCKM1            /'&&OP0069.ACCKM1'/
      DATA ROMKM1,ROMK       /'&&OP0069.ROMKM1', '&&OP0069.ROMK  '/
      DATA DEPENM,VITENM     /'&&OP0069.DEPENM', '&&OP0069.VITENM'/
      DATA ACCENM            /'&&OP0069.ACCENM'/
      DATA NURO              /'&&OP0069.NUME.ROTATION'/
      DATA DEPGEO, DEPLAM    /'&&OP0069.DEPGEO', '&&OP0069.DEPLAM'/
      DATA LIGRCF, CARTCF    /'&&OP0069.LIMECF', '&&OP0069.CARTCF'/
      DATA NEWGEO            /'&&OP0069.ACTUGEO'/
      DATA VARDEM, VARDEP    /'&&OP0069.VARDEM', '&&OP0069.VARDEP'/
      DATA LAGDEM, LAGDEP    /'&&OP0069.LAGDEM', '&&OP0069.LAGDEP'/
      DATA COMMOI, COMPLU    /'&&OP0069.COMOI' , '&&OP0069.COPLU' /
      DATA COMREF            /'&&OP0069.COREF'/
      DATA CNFEDO, CNFEPI    /'&&OP0069.CNFEDO', '&&OP0069.CNFEPI'/
      DATA CNFSDO, CNFSPI    /'&&OP0069.CNFSDO', '&&OP0069.CNFSPI'/
      DATA CNDIDO, CNDIPI    /'&&OP0069.CNDIDO', '&&OP0069.CNDIPI'/
      DATA CNDIDI, CNCINE    /'&&OP0069.CNDIDI', '&&OP0069.CNCINE'/
      DATA CNRESI, CNDIRI    /'&&OP0069.CNRESI', '&&OP0069.CNDIRI'/
      DATA MEDIRI            /'&&MEDIRI.LISTE_RESU'/
      DATA CNVCFO, CNVFRE    /'&&OP0069.CNVCFO', '&&OP0069.CNVFRE'/
      DATA MEMASS, FOINER    /'&&OP0069.MEMASS', '&&OP0069.FOINER'/
      DATA AMORT , MASSE     /'&&OP0069.MAMORT', '&&OP0069.MMASSE'/
      DATA STADYN            /'&&OP0069.STA_DYN'/
      DATA MCONEL, SCONEL    /'&&CFMMEL', '&&CFMVEL'/
      DATA FONDEP, FONVIT    /'&&FONDEP', '&&FONVIT'/
      DATA FONACC, PSIDEL    /'&&FONACC', '&&PSIDEL'/
      DATA MULTAP, VALMOD    /'&&MULTAP', '&&VALMOD'/
      DATA BASMOD            /'&&BASMOD'/
      DATA MASGEN, BASMOI    /'&&MASGEN', '&&BASMOI'/
      DATA MERIGI            /'&&MEMRIG.LISTE_RESU'/
      DATA AUTOC1            /'&&OP0069.REAC.AUTO1'/
      DATA AUTOC2            /'&&OP0069.REAC.AUTO2'/
      DATA K24BLA            /' '/

C ----------------------------------------------------------------------
      CALL JEMARQ()
C
C               12   345678   90123
      INPSCO = '&&'//NOMPRO//'_PSCO'
      COMGEO = 0
      CSEUIL = 0
      COBCA  = 0
      NMODAM = 0
      NBMODS = 0
      LONDE  = .FALSE.
      LIMPED = .FALSE.
      LAMORT = .FALSE.

C -- TITRE

      CALL TITRE ()
      CALL INFMAJ
      CALL INFNIV (IFM,NIV)
C
C     DETERMINATION DU NOM DE LA SD INFO_CHARGE 
C             12345678    90123    45678901234   
      NOOBJ ='12345678'//'.1234'//'.EXCIT01234'      
      CALL GNOMSD(NOOBJ,10,13)
      LISCH2 = NOOBJ(1:19)
C ======================================================================
C               RECUPERATION DES OPERANDES ET INITIALISATION
C ======================================================================

C -- QUELLE COMMANDE APPELLE CETTE OP (STA OU DYN)

      CALL GETRES (K8BID,K16BID,CMD)

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


C -- CREATION DE VARIABLES "CHAPEAU" POUR STOCKER LES NOMS
C      VALMOI : ETAT EN T-
C      VALPLU : ETAT EN T+
C      SECMBR : CHARGEMENTS
C      POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C      MULTIA : INFOS MULTI-APPUI

      CALL AGGLOM (DEPMOI, SIGMOI, VARMOI, COMMOI,
     &             K24BLA, K24BLA, K24BLA, K24BLA, 4, VALMOI)
      CALL AGGLOM (DEPPLU, SIGPLU, VARPLU, COMPLU,
     &             VARDEP, LAGDEP, K24BLA, K24BLA, 6, VALPLU)
      CALL AGGLOM (CNFEDO, CNFEPI, CNDIDO, CNDIPI,
     &             CNFSDO, CNFSPI, CNDIDI, CNCINE, 8, SECMBR)
      CALL AGGLOM (DEPKM1, VITKM1, ACCKM1, VITPLU,
     &             ACCPLU, ROMKM1, ROMK  , DDEPLA, 8, POUGD )
      CALL AGGLOM (FONDEP, FONVIT, FONACC, MULTAP,
     &             PSIDEL, K24BLA, K24BLA, K24BLA, 5, MULTIA )


C
C -- LECTURE DES OPERANDES DE LA COMMANDE (FIN)
C
      CALL NDLECT   (MODELE, MATE,  LISCHA, STADYN, LAMORT,
     &               ALPHA, DELTA,  V0VIT,  V0ACC,  A0VIT, 
     &               A0ACC, NBMODS, NMODAM, VALMOD, BASMOD,
     &               NREAVI, LIMPED, LONDE, CHONDP, NONDP,
     &               MULTIA, R8BID,IBID)
           
      CALL MXMOAM(MASGEN,BASMOI,LMODAL)
           
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
     &            NBPASE, INPSCO, LISCH2)
     
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
     &            NEQ,    NUMEDD, NBPASE, INPSCO, NBMODS, K24BID,
     &            K24BID)


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
C - DYNA_TRAN_EXPLI : PAS D'ECHEC SUR LE CONTACT
      ECHCON(1)=.FALSE.
      ECHCON(2)=.FALSE.

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
      FINPAS=.FALSE.
 200  CONTINUE
C
      CALL UTTCPU (1,'DEBUT',4,TPS1)
      INSTAP = DIINST(PARTPS, NUMINS)

C -- DOIT-ON FAIRE UNE OBSERVATION

      CALL LOBS(NBOBSE, NUINS0, LOBSER, INSTAP,
     &          NUOBSE, LISINS, LISOBS)

      CALL MISAZL(DEPMOI,DEFICO)      
      CALL NMIMPR('TITR',' ',' ',INSTAP,0)
      WRITE(IFM,9000) INSTAP
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
      CALL DINIT (NEQ,V0VIT,V0ACC,A0VIT,A0ACC,ALPHA,DELTA,INSTAM,
     &                 INSTAP,COEVIT,COEACC,DEPPLU,POUGD,DEPENT,VITENT,
     &                 ACCENT,MULTIA,NBMODS,NBPASE,INPSCO,
     &                 IBID,R8BID,IBID,CMD,DEFICO)


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


C -------------------------------------------------------
C - DYNA_TRAN_EXPLI : ETAPE DE CALCUL DES PREDICTEURS
C               {DUn+1}=DT*{Vn}+DT*DT/2*{An}
C               {Un+1}={Un}+{DUn+1}

      CALL JEVEUO(VITMOI(1:19)//'.VALE','L',JVITM)
      CALL JEVEUO(ACCMOI(1:19)//'.VALE','L',JACCM)
      CALL JEVEUO (DEPDEL(1:19)//'.VALE','E',JDEPDE)
      CALL JEVEUO (DEPPLU(1:19)//'.VALE','E',JDEPP )
      COEVI2 = INST(2)
      COEAC2 = COEVI2*COEVI2/2.D0
      DO 11 I = 1 , NEQ
         ZR(JDEPDE+I-1) = COEVI2*ZR(JVITM+I-1)+COEAC2*ZR(JACCM+I-1)
         ZR(JDEPP+I-1) = ZR(JDEPP+I-1)+ZR(JDEPDE+I-1)
 11   CONTINUE
C -------------------------------------------------------
C -- CALCUL DES CHARGEMENTS EXTERIEURS

      CALL NMCHAR ('FIXE', MODELE, NUMEDD, MATE  , CARELE,
     &             K24BLA, LISCHA, K24BLA, INST  , DEPMOI,
     &             DEPDEL, LBID,   K24BID, K24BID, K24BID, 
     &             K24BID, K24BID, K24BID, IBID,   K24BID, 
     &             K24BID, IBID,   LBID,   LONDE,  NONDP,
     &             CHONDP,
     &             TEMPLU, 0, 0, K13BID, K8BID, SECMBR)


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
     &            MCONEL, SCONEL, K24BID, K24BID, K24BID,
     &            K24BID, K24BID, K24BID, K16BID, INST)

C ======================================================================
C CALCUL DU SECOND MEMBRE (Fext - Fint)
C ======================================================================

      ETA = 0.D0

      CALL MXFIFE(MODELE, NUMEDD, MATE,   CARELE,    COMREF,
     &            COMPOR, LISCHA, MEDIRI, METHOD,    SOLVEU,
     &            PARMET, CARCRI, PARTPS,    NUMINS,
     &            INST  , VALMOI, POUGD ,    VALPLU,
     &            SECMBR, DEPDEL,   LICCVG,    STADYN,
     &            LAMORT, VITMOI, ACCMOI, MASSE,     AMORT,
     &            CMD,    PREMIE, MEMASS, DEPENT,    VITENT,
     &            COEVIT, COEACC, VITMOI, NMODAM,    VALMOD,
     &            BASMOD, NREAVI, LIMPED, LONDE,     NONDP,
     &            CHONDP, MATRIX, MERIGI, CNVCPR)

      PREMIE = .FALSE.

C =============================================================
C  CALCUL DE L'ACCELERATION ET ACTUALISATION DES COORDONNEES     
C =============================================================

C IL Y A SYSTEMATIQUEMENT CONVERGENCE :

      ITERAT = 0
      OPTION = 'RAPH_MECA'

      CALL NMFINT (MODELE, NUMEDD, MATE  , CARELE, COMREF,
     &                 COMPOR, LISCHA, CARCRI, POUGD , ITERAT,
     &                 MODEDE, NUMEDE, SOLVDE, PARMET, PARCRI,
     &                 VALMOI, DEPDEL, RESOCO, VALPLU, CNRESI,
     &                 CNDIRI, LICCVG(2), OPTION, CONV, STADYN,
     &                 DEPENT, VITENT)
C ------------> CALCUL DES ACCELERATIONS : 
C               {An+1}=[M-1]*({Fext}-{Fint})
      CALL MXCACC(SOLVEU, SECMBR, CNRESI, ACCPLU, ETA, MATRIX, CNVCPR,
     &            LMODAL, MASGEN, BASMOI)
C ------------> MISE A JOUR DES VITESSES :
C               {Vn+1}={Vn}+DT/2*({An}+{An+1})
C                       {Un}={Un+1}
C                       {An}={An+1}
C                       {Vn}={Vn+1}
      CALL MXMAJD(NEQ, REAROT, NURO, COEVI2, VITMOI, ACCMOI,
     &            VITPLU, ACCPLU)
     





C -- TEMPS DISPONIBLE POUR FAIRE UNE NOUVELLE ITERATION DE NEWTON ?
C -- ARRET PAR MANQUE DE TEMPS CPU - ARCHIVAGE DU PAS DE TEMPS PRECEDENT
C - A REFAIRE !!!



C -- FIN DE BOUCLE DE CONTACT ECP

      IF (IECPCO.NE.0) THEN
        CALL NMTBLE(NIVEAU, 
     &              MAILLA, DEFICO, OLDGEO, NEWGEO,
     &              DEPMOI, DEPGEO, MAXB,   DEPLAM,
     &              COMGEO, CSEUIL, COBCA, 
     &              DEPPLU,INST)
      ELSE 
        NIVEAU = 0
      ENDIF 
      
      IF (NIVEAU.GT.0) GOTO 101
      
      
C     TEMPS DISPONIBLE
      CALL UTTCPU (1,'FIN',4,TPS1)
      FINTPS = TPS1(4) .GT. 0.90D0*TPS1(1)
      
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
     &             NBMODS,DEPENT,VITENT,ACCENT,NBPASE.EQ.0,MODELE,MATE,
     &             CARELE,LISCH2)
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

C     COPIE DE LA SD INFO_CHARGE DANS LA BASE GLOBALE
      CALL COPISD(' ','G',LISCHA,LISCH2)

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

 9000 FORMAT ('INSTANT DE CALCUL : ',1PE16.9)

      CALL JEDEMA()
      END
