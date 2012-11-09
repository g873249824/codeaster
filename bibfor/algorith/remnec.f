      SUBROUTINE REMNEC(NOMRES,TYPESD,BASMOD,MODCYC,NUMSEC)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      IMPLICIT NONE
C-----------------------------------------------------------------------
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C
C  BUT:      < RESTITUTI0N MAC-NEAL ECLATEE >
C
C   RESTITUER LES RESULTATS ISSUS D'UN CALCUL CYCLIQUE
C          AVEC DES INTERFACES DE TYPE MAC-NEAL
C     => RESULTAT COMPOSE DE TYPE MODE_MECA ALLOUE PAR LA
C   ROUTINE
C-----------------------------------------------------------------------
C
C NOMRES  /I/: NOM UT DU CONCEPT RESULTAT A REMPLIR
C TYPESD  /I/: NOM K16 DU TYPE DE LA STRUCTURE DE DONNEE
C BASMOD  /I/: NOM UT DE LA BASE MODALE EN AMONT DU CALCUL CYCLIQUE
C MODCYC  /I/: NOM UT DU RESULTAT ISSU DU CALCUL CYCLIQUE
C NUMSEC  /I/: NUMERO DU SECTEUR  SUR LEQUEL RESTITUER
C
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*8   NOMRES,BASMOD,MODCYC,KBID,K8B
      CHARACTER*16  DEPL,TYPESD,TYPSUP(1)
      CHARACTER*19  CHAMVA,NUMDDL,MATRIX,MASS
      CHARACTER*24  FLEXDR,FLEXGA,FLEXAX,TETGD,TETAX
      CHARACTER*24  VALK(2)
      COMPLEX*16    DEPHC
      REAL*8        PARA(2),DEPI,R8DEPI,FACT,GENEK,BETA
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IAD ,IBIB ,IBID ,ICOMP ,IDDI ,IDI
      INTEGER IDIA ,IDIAM ,IDICOU ,IER ,II ,INUM ,IORC
      INTEGER IORMO ,J ,JJ ,LDFRE ,LDKGE ,LDMGE ,LDOM2
      INTEGER LDOMO ,LDOTM ,LDTYD ,LLCHAM ,LLDESC ,LLDIAM ,LLFREQ
      INTEGER LLMOC ,LLNSEC ,LLNUMI ,LLREF ,LMASS ,LTETAX ,LTETGD
      INTEGER LTFLAX ,LTFLDR ,LTFLGA ,LTORF ,LTORTO ,LTVECO ,LTVERE
      INTEGER LTVEZT ,MDIAPA ,NBDAX ,NBDDG ,NBDDR ,NBDIA ,NBMOC
      INTEGER NBMOD ,NBMOR ,NBORC ,NBSEC ,NBTMP ,NEQ ,NUMA
      INTEGER NUMD ,NUMG ,NUMSEC
      REAL*8 AAA ,BBB ,BETSEC
C-----------------------------------------------------------------------
      DATA DEPL   /'DEPL            '/
      DATA TYPSUP /'MODE_MECA       '/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      DEPI = R8DEPI()
C
C----------------VERIFICATION DU TYPE DE STRUCTURE RESULTAT-------------
C
      IF(TYPESD.NE.TYPSUP(1))THEN
        VALK (1) = TYPESD
        VALK (2) = TYPSUP(1)
        CALL U2MESG('F', 'ALGORITH14_4',2,VALK,0,0,0,0.D0)
      ENDIF
C
C--------------------------RECUPERATION DU .DESC------------------------
C
      CALL JEVEUO(MODCYC//'.CYCL_DESC','L',LLDESC)
      NBMOD = ZI(LLDESC)
      NBDDR = ZI(LLDESC+1)
      NBDAX = ZI(LLDESC+2)
C
C-------------------RECUPERATION DU NOMBRE DE SECTEUR-------------------
C
      CALL JEVEUO(MODCYC//'.CYCL_NBSC','L',LLNSEC)
      NBSEC  = ZI(LLNSEC)
      MDIAPA = INT(NBSEC/2)*(1-NBSEC+(2*INT(NBSEC/2)))
C
C------------------RECUPERATION DES NOMBRES DE DIAMETRES MODAUX---------
C
      CALL JEVEUO(MODCYC//'.CYCL_DIAM','L',LLDIAM)
      CALL JELIRA(MODCYC//'.CYCL_DIAM','LONMAX',NBDIA,K8B)
      NBDIA = NBDIA / 2
C
C-----------------RECUPERATION DU NOMBRE DE DDL PHYSIQUES---------------
C
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      NUMDDL = ZK24(LLREF+3)
      MATRIX = ZK24(LLREF)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8B,IER)
C
C-------------RECUPERATION DES FREQUENCES ------------------------------
C
      CALL JEVEUO(MODCYC//'.CYCL_FREQ','L',LLFREQ)
C
C----------------RECUPERATION MATRICE DE MASSE--------------------------
C
C      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      MASS = ZK24(LLREF+1)
      CALL MTEXIS ( MASS, IER )
      IF(IER.EQ.0) THEN
        VALK (1) = MASS(1:8)
        CALL U2MESG('F', 'ALGORITH12_39',1,VALK,0,0,0,0.D0)
      ENDIF
      CALL MTDSCR(MASS)
      CALL JEVEUO(MASS(1:19)//'.&INT','E',LMASS)
C
C------------------ALLOCATION DES VECTEURS DE TRAVAIL-------------------
C
      CALL WKVECT('&&REMNEC.VEC.TRAVC','V V C',NEQ,LTVEZT)
      CALL WKVECT('&&REMNEC.VEC.COMP' ,'V V C',NEQ,LTVECO)
      CALL WKVECT('&&REMNEC.VEC.REEL' ,'V V R',NEQ,LTVERE)
C
C-----------------RECUPERATION DES NUMERO D'INTERFACE-------------------
C
      CALL JEVEUO(MODCYC//'.CYCL_NUIN','L',LLNUMI)
      NUMD = ZI(LLNUMI)
      NUMG = ZI(LLNUMI+1)
      NUMA = ZI(LLNUMI+2)
C
C-------------CALCUL DES MATRICES DE FLEXIBILITE RESIDUELLE-------------
C
      KBID = ' '
      CALL BMNODI(BASMOD,KBID,'         ',NUMD,0,IBIB,NBDDR)
      FLEXDR = '&&REMNEC.FLEX.DROITE'
      CALL WKVECT(FLEXDR,'V V R',NBDDR*NEQ,LTFLDR)
      IBID = 0
      CALL FLEXIB(BASMOD,NBMOD,ZR(LTFLDR),NEQ,NBDDR,IBID,NUMD)
C
      FLEXGA = '&&REMNEC.FLEX.GAUCHE'
      CALL WKVECT(FLEXGA,'V V R',NBDDR*NEQ,LTFLGA)
      CALL FLEXIB(BASMOD,NBMOD,ZR(LTFLGA),NEQ,NBDDR,IBID,NUMG)
C
      IF(NUMA.GT.0) THEN
        FLEXAX = '&&REMNEC.FLEX.AXE'
        KBID   = ' '
        CALL BMNODI(BASMOD,KBID,'         ',NUMA,0,IBID,NBDAX)
        CALL WKVECT(FLEXAX,'V V R',NBDAX*NEQ,LTFLAX)
        CALL FLEXIB(BASMOD,NBMOD,ZR(LTFLAX),NEQ,NBDDR,IBID,NUMA)
      ENDIF
C
C--------------CALCUL DES MATRICES DE CHANGEMENT DE BASE TETA-----------
C
      TETGD = '&&REMNEC.TETGD'
      CALL WKVECT(TETGD,'V V R',NBDDR*NBDDR,LTETGD)
      CALL CTETGD(BASMOD,NUMD,NUMG,NBSEC,ZR(LTETGD),NBDDR)
C
      IF(NUMA.GT.0) THEN
        TETAX = '&&REMNEC.TETAX'
        CALL WKVECT(TETAX,'V V R',NBDAX*NBDAX,LTETAX)
        CALL CTETGD(BASMOD,NUMA,NUMG,NBSEC,ZR(LTETAX),NBDAX)
      ENDIF
C
C--------------------CLASSEMENT DES MODES PROPRES-----------------------
C               COMPTAGE DU NOMBRE DE MODES PHYSIQUES
C
      NBMOC = 0
      NBMOR = 0
      DO 5 IDDI=1,NBDIA
        NBTMP = ZI(LLDIAM+NBDIA+IDDI-1)
        NBMOC = NBMOC + NBTMP
        IDIA  = ZI(LLDIAM+IDDI-1)
        IF(IDIA.EQ.0 .OR. IDIA.EQ.MDIAPA) THEN
          NBMOR = NBMOR + NBTMP
        ELSE
          NBMOR = NBMOR + 2*NBTMP
        ENDIF
 5    CONTINUE
      CALL WKVECT('&&REMNEC.ORDRE.FREQ','V V I',NBMOC,LTORF)
      CALL WKVECT('&&REMNEC.ORDRE.TMPO','V V I',NBMOC,LTORTO)
      CALL ORDR8(ZR(LLFREQ),NBMOC,ZI(LTORTO))
C
C
C-----------------ALLOCATION STRUCTURE DE DONNEES-----------------------
C
      CALL RSCRSD('G',NOMRES,TYPESD,NBMOR)
C
C-------DETERMINATION DES FUTUR NUMERO ORDRES DE MODES REELS------------
C
      NBORC = 0
      DO 6 II=1,NBMOC
        IORMO  = ZI(LTORTO+II-1)
        ICOMP  = 0
        IDICOU = 0
        DO 7 JJ=1,NBDIA
          ICOMP = ICOMP + ZI(LLDIAM+NBDIA+JJ-1)
          IF(ICOMP.GE.IORMO .AND. IDICOU.EQ.0) IDICOU = JJ
 7      CONTINUE
        NBORC = NBORC + 1
        ZI(LTORF+IORMO-1) = NBORC
        IDIAM = ZI(LLDIAM+IDICOU-1)
        IF(IDIAM.NE.0 .AND. IDIAM.NE.MDIAPA) NBORC = NBORC + 1
 6    CONTINUE
      CALL JEDETR('&&REMNEC.ORDRE.TMPO')
C
C---------------------RECUPERATION DES MODES COMPLEXES------------------
C
      CALL JEVEUO(MODCYC//'.CYCL_CMODE','L',LLMOC)
C
C--------------------------RESTITUTION----------------------------------
C
      NBDDG = NBMOD + NBDDR + NBDAX
      ICOMP = 0
      INUM  = 0
C
C --- BOUCLE SUR LES NOMBRE DE DIAMETRES
C
      DO 10 IDI=1,NBDIA
C
C ----- CALCUL DEPHASAGE DU SECTEUR DEMANDE
C
        IDIAM  = ZI(LLDIAM+IDI-1)
        BETA   = (DEPI/NBSEC)*IDIAM
        BETSEC = (NUMSEC-1)*BETA
        AAA    = COS(BETSEC)
        BBB    = SIN(BETSEC)
        DEPHC  = DCMPLX(AAA,BBB)
C
C ----- BOUCLE SUR MODES DU NOMBRE DE DIAMETRE COURANT
C
        DO 15 I=1,ZI(LLDIAM+NBDIA+IDI-1)
C
          ICOMP = ICOMP + 1
          INUM  = INUM + 1
          IORC  = ZI(LTORF+ICOMP-1)
          IAD   = LLMOC + ((ICOMP-1)*NBDDG)
C
C ------- CALCUL MODE COMPLEXE SECTEUR DE BASE
C
          CALL REMNBN ( BASMOD,NBMOD,NBDDR,NBDAX,FLEXDR,FLEXGA,FLEXAX,
     &                  TETGD,TETAX,ZC(IAD),ZC(LTVECO),NEQ,BETA)
C
C ------- CALCUL MASSE GENERALISEE
C
          CALL GENECY ( ZC(LTVECO),ZC(LTVECO),NEQ,LMASS,PARA,NBSEC,
     &                  BETA,BETA,ZC(LTVEZT))
C
          DO 20 J=1,NEQ
            ZC(LTVECO+J-1) = ZC(LTVECO+J-1)*DEPHC
            ZR(LTVERE+J-1) = DBLE(ZC(LTVECO+J-1))
 20       CONTINUE
C
C ------- RESTITUTION DU MODE PROPRES REEL (PARTIE RELLE)
C
          CALL RSEXCH(' ',NOMRES,DEPL,INUM,CHAMVA,IER)
          CALL VTCREM(CHAMVA,MATRIX,'G','R')
          CALL JEVEUO(CHAMVA//'.VALE','E',LLCHAM)
          CALL RSADPA(NOMRES,'E',1,'FREQ'     ,INUM,0,LDFRE,K8B)
          CALL RSADPA(NOMRES,'E',1,'RIGI_GENE',INUM,0,LDKGE,K8B)
          CALL RSADPA(NOMRES,'E',1,'MASS_GENE',INUM,0,LDMGE,K8B)
          CALL RSADPA(NOMRES,'E',1,'OMEGA2'   ,INUM,0,LDOM2,K8B)
          CALL RSADPA(NOMRES,'E',1,'NUME_MODE',INUM,0,LDOMO,K8B)
          CALL RSADPA(NOMRES,'E',1,'TYPE_MODE',INUM,0,LDOTM,K8B)
C
          FACT  = 1.D0 / (PARA(1)**0.5D0)
          GENEK = (ZR(LLFREQ+ICOMP-1)*DEPI)**2
          CALL DAXPY(NEQ,FACT,ZR(LTVERE),1,ZR(LLCHAM),1)
          ZR(LDFRE) = ZR(LLFREQ+ICOMP-1)
          ZR(LDKGE) = GENEK
          ZR(LDMGE) = 1.D0
          ZR(LDOM2) = GENEK
          ZI(LDOMO) = IORC
          ZK16(LDOTM) = 'MODE_DYN'
C
C ------- SPECIFIQUE A BASE_MODALE
C
          CALL RSADPA(NOMRES,'E',1,'TYPE_DEFO',INUM,0,LDTYD,K8B)
          ZK16(LDTYD) = 'PROPRE          '
C
          CALL RSNOCH(NOMRES,DEPL,INUM)
C
C ------- EVENTUELLE RESTITUTION DE LA PARTIE IMAGINAIRE
C
          IF(IDIAM.NE.0 .AND. IDIAM.NE.MDIAPA) THEN
C
            DO 30 J=1,NEQ
              ZR(LTVERE+J-1) = DIMAG(ZC(LTVECO+J-1))
 30         CONTINUE
            IORC = IORC + 1
            INUM = INUM + 1
C
            CALL RSEXCH(' ',NOMRES,DEPL,INUM,CHAMVA,IER)
            CALL VTCREM(CHAMVA,MATRIX,'G','R')
            CALL JEVEUO(CHAMVA//'.VALE','E',LLCHAM)
C
            CALL RSADPA(NOMRES,'E',1,'FREQ'     ,INUM,0,LDFRE,K8B)
            CALL RSADPA(NOMRES,'E',1,'RIGI_GENE',INUM,0,LDKGE,K8B)
            CALL RSADPA(NOMRES,'E',1,'MASS_GENE',INUM,0,LDMGE,K8B)
            CALL RSADPA(NOMRES,'E',1,'OMEGA2'   ,INUM,0,LDOM2,K8B)
            CALL RSADPA(NOMRES,'E',1,'NUME_MODE',INUM,0,LDOMO,K8B)
            CALL RSADPA(NOMRES,'E',1,'TYPE_MODE',INUM,0,LDOTM,K8B)
C
            FACT  = 1.D0 / (PARA(2)**0.5D0)
            GENEK = (ZR(LLFREQ+ICOMP-1)*DEPI)**2
            CALL DAXPY(NEQ,FACT,ZR(LTVERE),1,ZR(LLCHAM),1)
            ZR(LDFRE) = ZR(LLFREQ+ICOMP-1)
            ZR(LDKGE) = GENEK
            ZR(LDMGE) = 1.D0
            ZR(LDOM2) = GENEK
            ZI(LDOMO) = IORC
            ZK16(LDOTM) = 'MODE_DYN'
C
            CALL RSADPA(NOMRES,'E',1,'TYPE_DEFO',INUM,0,LDTYD,K8B)
            ZK16(LDTYD) = 'PROPRE          '
C
            CALL RSNOCH(NOMRES,DEPL,INUM)
C
          ENDIF
C
 15     CONTINUE
C
 10   CONTINUE
C
      CALL JEDETR ( '&&REMNEC.VEC.TRAVC'  )
      CALL JEDETR ( '&&REMNEC.VEC.COMP'   )
      CALL JEDETR ( '&&REMNEC.VEC.REEL'   )
      CALL JEDETR ( '&&REMNEC.FLEX.DROITE')
      CALL JEDETR ( '&&REMNEC.FLEX.GAUCHE')
      CALL JEDETR ( '&&REMNEC.TETGD'      )
      CALL JEDETR ( '&&REMNEC.ORDRE.FREQ' )
      IF(NUMA.GT.0) THEN
        CALL JEDETR ( '&&REMNEC.FLEX.AXE')
        CALL JEDETR ( '&&REMNEC.TETAX'   )
      ENDIF
C
      CALL JEDEMA()
      END
