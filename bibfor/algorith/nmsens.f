      SUBROUTINE NMSENS(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &                  LISCHA,FONACT,SOLVEU,NUMINS,CARCRI,
     &                  COMREF,DEFICO,RESOCO,RESOCU,PARCON,
     &                  MATASS,MAPREC,SDSENS,SDDYNA,SDDISC,
     &                  VALINC,SOLALG,VEELEM,VEASSE,MEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*19 LISCHA,SOLVEU,MATASS,MAPREC
      CHARACTER*19 SDDISC,SDDYNA 
      CHARACTER*24 MODELE,NUMEDD,MATE  ,CARELE,COMPOR
      CHARACTER*24 SDSENS,CARCRI,COMREF
      CHARACTER*24 DEFICO,RESOCO,RESOCU
      CHARACTER*19 MEASSE(*),VEASSE(*)
      CHARACTER*19 VEELEM(*)      
      CHARACTER*19 SOLALG(*),VALINC(*)
      REAL*8       PARCON(*)
      INTEGER      NUMINS
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME )
C
C CALCUL DE SENSIBILITE
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMPOR : CARTE COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  LISCH2 : NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  NUMINS : NUMERO D'INSTANT
C IN  SOLVEU : SOLVEUR
C IN  COMREF : VARI_COM DE REFERENCE
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  RESOCU : SD RESOLUTION LIAISON_UNILATER
C IN  PARCON : PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  MAPREC : NOM DE LA MATRICE DE PRECONDITIONNEMENT (GCPC)
C IN  SDCRIT : INFORMATIONS RELATIVES A LA CONVERGENCE
C IN  SDDISC : SD DISCRETISATION
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDSENS : SD SENSIBILITE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NVEA,NVAL
      PARAMETER    (NVEA=32,NVAL=18)
C
      INTEGER      TYPESE
      INTEGER      IFM,NIV
      INTEGER      JDEPLS,JDEPMS,JVITPS,JACCPS
      INTEGER      NEQ,NMAX,IRET
      LOGICAL      NDYNLO,LSTAT,LDYNA
      REAL*8       NDYNRE,COEVIT,COEACC
      CHARACTER*8  NOPASE,K8BID
      CHARACTER*13 INPSCO
      CHARACTER*19 DEPMOS,SIGMOS,VARMOS,VITMOS,ACCMOS
      CHARACTER*19 DEPPLS,SIGPLS,VARPLS,VITPLS,ACCPLS      
      CHARACTER*19 VALINS(NVAL),VEASSS(NVEA)
      CHARACTER*24 STYPSE
      INTEGER      NRPASE,NBPASE,NMSENN
      CHARACTER*24 SENSIN
      INTEGER      JSENSI
      CHARACTER*19 CNCINE,CNPILO,CNDONN
      CHARACTER*19 DEPSO1,DEPSO2,K19BLA
      CHARACTER*19 CNBUDS,CNDYNS,CNMODS,VEBUDS   
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      K19BLA    = ' '
      LSTAT     = NDYNLO(SDDYNA,'STATIQUE')
      LDYNA     = NDYNLO(SDDYNA,'DYNAMIQUE')
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
      CALL NMCHEX(VEASSE,'VEASSE','CNCINE',CNCINE)
      CNDONN    = '&&CNCHAR.DONN'
      CNPILO    = '&&CNCHAR.PILO'          
      CALL VTZERO(CNDONN) 
      CALL VTZERO(CNPILO)  
      CALL NMCHAI('VEASSE','LONMAX',NMAX  )
      CALL ASSERT(NMAX.EQ.NVEA)
      CALL NMCHAI('VALINC','LONMAX',NMAX  )
      CALL ASSERT(NMAX.EQ.NVAL)            
C
C --- VECT_ASSE DEDIES SENSIBILITE
C
      CALL NMCHA0('VEASSE','ALLINI',' ',VEASSS)
      CALL NMCHA0('VALINC','ALLINI',' ',VALINS) 
      CNBUDS    = '&&NMSENS.CNBUDS'
      CNDYNS    = '&&NMSENS.CNDYNS'   
      CNMODS    = '&&NMSENS.CNMODS'  
      VEBUDS    = '&&NMSENS.VEBUDS'           
      CALL VTCREB(CNBUDS,NUMEDD,'V','R',NEQ) 
      CALL VTCREB(CNDYNS,NUMEDD,'V','R',NEQ)
      CALL VTCREB(CNMODS,NUMEDD,'V','R',NEQ)
      CALL NMCHSO(VEASSE,'VEASSE','      ',K19BLA,VEASSS)
      CALL NMCHSO(VEASSS,'VEASSE','CNDYNA',CNDYNS,VEASSS)
      CALL NMCHSO(VEASSS,'VEASSE','CNMODC',CNMODS,VEASSS)   
      CALL NMCHSO(VALINC,'VALINC','      ',K19BLA,VALINS)
C      
C --- NOMBRE PARAMETRES SENSIBLES
C
      NBPASE = NMSENN(SDSENS)
C
C --- ACCES SD SENSIBILITE
C
      SENSIN = SDSENS(1:16)//'.INPSCO '
      CALL JEVEUO(SENSIN,'L',JSENSI)
      INPSCO = ZK16(JSENSI+1-1)(1:13)
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO1',DEPSO1)
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO2',DEPSO2)        
C
C --- BOUCLE SUR LES PARAMETRES SENSIBLES
C
      DO 10 NRPASE = 1,NBPASE
        CALL NMNSLE(SDSENS,NRPASE,'NOPASE',NOPASE)
        CALL NMNSLE(SDSENS,NRPASE,'DEPPLU',DEPPLS)
        CALL NMNSLE(SDSENS,NRPASE,'DEPMOI',DEPMOS)
        CALL NMNSLE(SDSENS,NRPASE,'SIGPLU',SIGPLS)
        CALL NMNSLE(SDSENS,NRPASE,'SIGMOI',SIGMOS)
        CALL NMNSLE(SDSENS,NRPASE,'VARPLU',VARPLS)
        CALL NMNSLE(SDSENS,NRPASE,'VARMOI',VARMOS)
        CALL METYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)
        IF (LDYNA) THEN
          CALL NMNSLE(SDSENS,NRPASE,'VITPLU',VITPLS)
          CALL NMNSLE(SDSENS,NRPASE,'VITMOI',VITMOS)
          CALL NMNSLE(SDSENS,NRPASE,'ACCPLU',ACCPLS)
          CALL NMNSLE(SDSENS,NRPASE,'ACCMOI',ACCMOS)
        ENDIF
C
C --- CONSTRUCTION CHAMPS SENSIBLES
C 
        CALL NMCHSO(VALINS,'VALINC','DEPPLU',DEPPLS,VALINS)
        CALL NMCHSO(VALINS,'VALINC','DEPMOI',DEPMOS,VALINS)
        CALL NMCHSO(VALINS,'VALINC','VITPLU',VITPLS,VALINS)
        CALL NMCHSO(VALINS,'VALINC','ACCPLU',ACCPLS,VALINS)
        CALL NMCHSO(VALINS,'VALINC','SIGPLU',SIGPLS,VALINS)
        CALL NMCHSO(VALINS,'VALINC','VARPLU',VARPLS,VALINS)       
C
C --- CALCUL DU CHARGEMENT SENSIBLE
C
        IF (LSTAT) THEN
          CALL NMCHSE('SENS',NRPASE,MODELE,NUMEDD,MATE  ,
     &                CARELE,COMPOR,LISCHA,CARCRI,NUMINS,
     &                SDDISC,PARCON,DEFICO,RESOCO,RESOCU,
     &                COMREF,VALINC,SOLALG,VEELEM,MEASSE,
     &                VEASSS,SDSENS,TYPESE,VALINS,VEBUDS,
     &                CNBUDS,CNDYNS,CNMODS,SDDYNA)
        ELSEIF (LDYNA) THEN
          CALL NMCHSE('SEDY',NRPASE,MODELE,NUMEDD,MATE  ,
     &                CARELE,COMPOR,LISCHA,CARCRI,NUMINS,
     &                SDDISC,PARCON,DEFICO,RESOCO,RESOCU,
     &                COMREF,VALINC,SOLALG,VEELEM,MEASSE,
     &                VEASSS,SDSENS,TYPESE,VALINS,VEBUDS,
     &                CNBUDS,CNDYNS,CNMODS,SDDYNA)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- CALCUL DU SECOND MEMBRE
C
        CALL NMASSS(SDDYNA,VEASSS,TYPESE,CNBUDS,CNDYNS,
     &              CNMODS,CNDONN)
C
C --- RESOLUTION
C
        CALL NMRESO(FONACT,CNDONN,CNPILO,CNCINE,SOLVEU,
     &              MAPREC,MATASS,DEPSO1,DEPSO2)
        CALL COPISD('CHAMP_GD','V',DEPSO1,DEPPLS)     
C
C --- MISE A JOUR DES CHAMPS VITESSE ET ACCELERATION DERIVES
C
        CALL JEVEUO(DEPPLS(1:19)//'.VALE','E',JDEPLS)
        IF (LDYNA) THEN
          COEVIT = NDYNRE(SDDYNA,'COEF_VITE')
          COEACC = NDYNRE(SDDYNA,'COEF_ACCE')
          CALL JEVEUO(VITPLS(1:19)//'.VALE','E',JVITPS )
          CALL DAXPY(NEQ, COEVIT, ZR(JDEPLS), 1, ZR(JVITPS), 1)
          CALL JEVEUO(ACCPLS(1:19)//'.VALE','E',JACCPS )
          CALL DAXPY(NEQ, COEACC, ZR(JDEPLS), 1, ZR(JACCPS), 1)
        END IF
C
C --- MISE A JOUR DU CHAMP DE DEPLACEMENT DERIVE
C
        CALL JEVEUO(DEPMOS(1:19)//'.VALE','L',JDEPMS)
        CALL DAXPY(NEQ, 1.D0, ZR(JDEPMS), 1, ZR(JDEPLS), 1)
C
C --- INTEGRATION DE LA LOI DE COMPORTEMENT DERIVEE
C
        CALL NSLDC (MODELE,MATE  ,CARELE,COMPOR,SDSENS,
     &              INPSCO,NRPASE,TYPESE,NOPASE,STYPSE)
C
C --- REACTUALISATION 
C
        CALL COPISD('CHAMP_GD','V',DEPPLS,DEPMOS)
        CALL COPISD('CHAMP_GD','V',SIGPLS,SIGMOS)
        CALL COPISD('CHAMP_GD','V',VARPLS,VARMOS)
        IF (LDYNA) THEN
          CALL COPISD('CHAMP_GD','V',VITPLS,VITMOS)
          CALL COPISD('CHAMP_GD','V',ACCPLS,ACCMOS)
        ENDIF
10    CONTINUE
C
C --- MENAGE
C
      CALL DETRSD('CHAMP',CNBUDS)
      CALL DETRSD('CHAMP',CNMODS)
      CALL DETRSD('CHAMP',CNDYNS)
C
      CALL JEDEMA()
      END
