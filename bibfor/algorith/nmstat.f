      SUBROUTINE NMSTAT(PHASE ,FONACT,SDSTAT,SDTIME,DEFICO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      CHARACTER*1   PHASE
      CHARACTER*24  SDTIME,SDSTAT
      CHARACTER*24  DEFICO
      INTEGER       FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C AFFICHAGE DE STATISTIQUES DIVERSES
C
C ----------------------------------------------------------------------
C
C
C IN  PHASE  : TYPE DE STATISTIQUES
C               'N' SUR L'ITERATION DE NEWTON COURANTE
C               'P' SUR LE PAS COURANT
C               'T' SUR TOUT LE TRANSITOIRE  
C IN  SDSTAT : SD STATISTIQUES
C IN  SDTIME : SD TIME
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  FONACT : FONCTIONNALITES ACTIVES
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      ISFONC,LCTCD,LALLV,LCONT,LCTCC
      LOGICAL      CFDISL,LCTCG,LBOUCC,LBOUCF,LFROT
      LOGICAL      LMVIB,LFLAM,LPOST
      REAL*8       TPSCOG
      REAL*8       TPSCDA
      REAL*8       TPSCCC,TPSCCM,TPSCCF,TPSCCP
      INTEGER      IBID
      INTEGER      CTCCIT,NBLIAC,NBLIAF,CTCGEO,CTCFRO,CTCMAT,CTCCPR
      REAL*8       TPSFAC,TPSSOL,TPSINT,TPSMOY
      REAL*8       TPS,TPSRST,TPSPST,TPS2MB,TPSASM,TPSLST
      REAL*8       EFFICA
      INTEGER      NBRFAC,NBRINT,NBRSOL,NBRFET,NBRREL
      INTEGER      NBITER,NBINST
      INTEGER      VALI(5)
      CHARACTER*24 TPSCVT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVES
C
      LMVIB  = ISFONC(FONACT,'MODE_VIBR' )
      LFLAM  = ISFONC(FONACT,'CRIT_FLAMB')
      LPOST  = LMVIB.OR.LFLAM
      LCONT  = ISFONC(FONACT,'CONTACT'   )
      IF (LCONT) THEN
        LCTCG  = CFDISL(DEFICO,'GEOM_BOUCLE')
        LALLV  = CFDISL(DEFICO,'ALL_VERIF')
        LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
        LCTCC  = ISFONC(FONACT,'CONT_CONTINU')
        LBOUCF = ISFONC(FONACT,'BOUCLE_EXT_FROT')
        LBOUCC = ISFONC(FONACT,'BOUCLE_EXT_CONT')
        LFROT  = CFDISL(DEFICO,'FROTTEMENT')
      ELSE
        LCTCG  = .FALSE.
        LALLV  = .FALSE.
        LCTCD  = .FALSE.
        LCTCC  = .FALSE.
        LBOUCC = .FALSE.
        LBOUCF = .FALSE.
        LFROT  = .FALSE.      
      ENDIF
C
C --- INITIALISATIONS
C
      TPS    = 0.D0
      TPSFAC = 0.D0
      TPSSOL = 0.D0
      TPSINT = 0.D0
      TPSCDA = 0.D0
      TPSCOG = 0.D0
      TPSCCC = 0.D0
      TPSCCM = 0.D0
      TPSCCF = 0.D0
      TPSRST = 0.D0
      TPSPST = 0.D0
      TPSCCP = 0.D0
      TPS2MB = 0.D0
      TPSASM = 0.D0
      TPSLST = 0.D0
      
      CTCCIT = 0
      NBLIAC = 0
      NBLIAF = 0
      CTCGEO = 0
      CTCFRO = 0
      CTCMAT = 0
      NBRFAC = 0
      NBRINT = 0
      NBRSOL = 0
      CTCCPR = 0
      NBRFET = 0
      NBRREL = 0
      NBITER = 0
      NBINST = 0
C
C --- TEMPS TOTAL DANS LA PHASE
C
      CALL NMTIMR(SDTIME,'TEMPS_PHASE',PHASE ,TPS   )
C
C --- TEMPS PERDU
C
      IF (PHASE.EQ.'T') THEN
        CALL NMTIMR(SDTIME,'PAS_LOST',PHASE ,TPSLST)
      ENDIF
C
C --- TEMPS DES OPERATIONS DANS LA PHASE
C
      CALL NMTIMR(SDTIME,'FACTOR'     ,PHASE ,TPSFAC)
      CALL NMTIMR(SDTIME,'SOLVE'      ,PHASE ,TPSSOL)
      CALL NMTIMR(SDTIME,'INTEGRATION',PHASE ,TPSINT)
      CALL NMTIMR(SDTIME,'SECO_MEMB'  ,PHASE ,TPS2MB)
      CALL NMTIMR(SDTIME,'ASSE_MATR'  ,PHASE ,TPSASM)
C
C --- COMPTEURS D'OPERATIONS
C
      CALL NMRVAI(SDSTAT,'FACTOR'        ,PHASE ,NBRFAC)
      CALL NMRVAI(SDSTAT,'SOLVE'         ,PHASE ,NBRSOL)
      CALL NMRVAI(SDSTAT,'INTEGRATION'   ,PHASE ,NBRINT)
      CALL NMRVAI(SDSTAT,'FETI_ITER'     ,PHASE ,NBRFET)
      CALL NMRVAI(SDSTAT,'RECH_LINE_ITER',PHASE ,NBRREL)
C     
      IF ((PHASE.EQ.'P').OR.(PHASE.EQ.'T')) THEN
        CALL NMRVAI(SDSTAT,'ITE',PHASE ,NBITER)
      ENDIF
C     
      IF (PHASE.EQ.'T') THEN
        CALL NMRVAI(SDSTAT,'PAS'    ,PHASE ,NBINST)
      ENDIF
C
C --- BOUCLE GEOMETRIQUE DE CONTACT
C
      IF (LCTCG) THEN
        CALL NMTIMR(SDTIME,'CONT_GEOM',PHASE ,TPSCOG)
        CALL NMRVAI(SDSTAT,'CONT_GEOM',PHASE ,CTCGEO)
      ENDIF
C
C --- AUTRES INFOS SUR LE CONTACT
C
      IF (LCONT.AND.(.NOT.LALLV)) THEN
        CALL NMRVAI(SDSTAT,'CONT_NBLIAC'   ,PHASE ,NBLIAC)
        IF (LFROT) THEN
          CALL NMRVAI(SDSTAT,'CONT_NBLIAF'   ,PHASE ,NBLIAF)
        ENDIF
        IF (LCTCD) THEN
          CALL NMRVAI(SDSTAT,'CTCD_ALGO_ITER',PHASE ,CTCCIT)
          CALL NMTIMR(SDTIME,'CTCD_ALGO'     ,PHASE ,TPSCDA)
        ELSEIF (LCTCC) THEN
          CALL NMRVAI(SDSTAT,'CTCC_CONT'     ,PHASE ,CTCCIT)
          CALL NMRVAI(SDSTAT,'CTCC_FROT'     ,PHASE ,CTCFRO)
          CALL NMRVAI(SDSTAT,'CTCC_MATR'     ,PHASE ,CTCMAT)
          CALL NMRVAI(SDSTAT,'CTCC_PREP'     ,PHASE ,CTCCPR)
          CALL NMTIMR(SDTIME,'CTCC_FROT'     ,PHASE ,TPSCCF)
          CALL NMTIMR(SDTIME,'CTCC_CONT'     ,PHASE ,TPSCCC)
          CALL NMTIMR(SDTIME,'CTCC_MATR'     ,PHASE ,TPSCCM)
          CALL NMTIMR(SDTIME,'CTCC_PREP'     ,PHASE ,TPSCCP)
        ENDIF
      ENDIF
C
C --- POST-TRAITEMENT (FLAMBEMENT)
C
      IF (LPOST) THEN
        CALL NMTIMR(SDTIME,'POST_TRAITEMENT',PHASE ,TPSPST)
      ENDIF
C
C --- TEMPS RESTANT (NON MESURE)
C
      TPSRST = TPS    -
     &         TPSINT - TPSFAC - TPSSOL - TPS2MB - TPSASM -
     &         TPSCOG -
     &         TPSCDA -
     &         TPSCCF - TPSCCC - TPSCCM - TPSCCP
C
      IF (TPSRST.LE.0.D0) TPSRST = 0.D0     
C
C --- AFFICHAGE FIN DU PAS
C
      IF (PHASE.EQ.'P') THEN
        TPSMOY = TPS/NBITER
        CALL IMPFOT(TPS   ,TPSCVT)
        CALL U2MESK('I','MECANONLINE7_1',1,TPSCVT) 
        CALL IMPFOT(TPSMOY,TPSCVT)
        CALL U2MESG('I','MECANONLINE7_2',1,TPSCVT,1,NBITER,0,0.D0)
        CALL IMPFOT(TPSASM,TPSCVT)
        CALL U2MESK('I','MECANONLINE7_13',1,TPSCVT)     
        CALL IMPFOT(TPSFAC,TPSCVT)
        CALL U2MESG('I','MECANONLINE7_3',1,TPSCVT,1,NBRFAC,0,0.D0)
        CALL IMPFOT(TPS2MB,TPSCVT)
        CALL U2MESK('I','MECANONLINE7_12',1,TPSCVT)
        CALL IMPFOT(TPSINT,TPSCVT)
        CALL U2MESG('I','MECANONLINE7_4',1,TPSCVT,1,NBRINT,0,0.D0)
        CALL IMPFOT(TPSSOL,TPSCVT)
        CALL U2MESG('I','MECANONLINE7_5',1,TPSCVT,1,NBRSOL,0,0.D0)
C
C ----- CONTACT DISCRET
C
        IF ((LCTCD).AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCDA,TPSCVT)
          CALL U2MESG('I','MECANONLINE7_10',1,TPSCVT,1,CTCCIT,0,0.D0)
        ENDIF
C
C ----- CONTACT CONTINU
C
        IF ((LCTCC).AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCCM,TPSCVT)
          CALL U2MESG('I','MECANONLINE7_20',1,TPSCVT,1,CTCMAT,0,0.D0)
          CALL IMPFOT(TPSCCP,TPSCVT)
          CALL U2MESG('I','MECANONLINE7_24',1,TPSCVT,1,CTCCPR,0,0.D0)
          IF (LBOUCF) THEN
            CALL IMPFOT(TPSCCF,TPSCVT)
            CALL U2MESG('I','MECANONLINE7_22',1,TPSCVT,1,CTCFRO,0,0.D0)
          ENDIF
          IF (LBOUCC) THEN
            CALL IMPFOT(TPSCCC,TPSCVT)
            CALL U2MESG('I','MECANONLINE7_23',1,TPSCVT,1,CTCCIT,0,0.D0)
          ENDIF       
        ENDIF
C
C ----- CONTACT - BOUCLE GEOMETRIQUE
C
        IF (LCTCG.AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCOG,TPSCVT)
          CALL U2MESG('I','MECANONLINE7_11',1,TPSCVT,1,CTCGEO,0,0.D0)   
        ENDIF
C
C ----- TEMPS POST-TRAITEMENT
C
        IF (LPOST) THEN
          CALL IMPFOT(TPSPST,TPSCVT)
          CALL U2MESK('I','MECANONLINE7_7',1,TPSCVT)
        ENDIF
C
C ----- TEMPS RESTANTS
C
        CALL IMPFOT(TPSRST,TPSCVT)
        CALL U2MESK('I','MECANONLINE7_6',1,TPSCVT)
C
C ----- STATISTIQUES RECHERCHE LINEAIRE + FETI
C
        IF ( NBRREL.NE.0) THEN
          CALL U2MESI('I','MECANONLINE7_8',1,NBRREL)
        ENDIF
        IF ( NBRFET.NE.0) THEN
          CALL U2MESI('I','MECANONLINE7_9',1,NBRFET)
        ENDIF
C
C ----- STATISTIQUES SUR LE CONTACT
C
        IF ((LCONT).AND.(.NOT.LALLV)) THEN
          CALL U2MESS('I','MECANONLINE7_30')
          CALL U2MESI('I','MECANONLINE7_31',1,NBLIAC)
          IF (LFROT) THEN
            CALL U2MESI('I','MECANONLINE7_32',1,NBLIAF)
          ENDIF
        ENDIF
C
C --- AFFICHAGE DE LA CONSOMMATION MEMOIRE
C        
        CALL IMPMEM()
      ENDIF
C
C --- AFFICHAGE FIN DU TRANSITOIRE
C
      IF (PHASE.EQ.'T') THEN
        VALI(1) = NBINST
        VALI(2) = NBITER
        VALI(3) = NBRFAC
        VALI(4) = NBRINT
        VALI(5) = NBRSOL
        CALL U2MESI('I','MECANONLINE8_1',5,VALI)
C
C ----- STATISTIQUES RECHERCHE LINEAIRE + FETI
C
        IF ( NBRREL.NE.0) THEN
          CALL U2MESI('I','MECANONLINE8_2',1,NBRREL)
        ENDIF
        IF ( NBRFET.NE.0) THEN
          CALL U2MESI('I','MECANONLINE8_3',1,NBRFET)
        ENDIF
C
C ----- STATISTIQUES SUR LE CONTACT
C        
        IF ((LCONT).AND.(.NOT.LALLV)) THEN
          CALL U2MESS('I','MECANONLINE8_30')
        ENDIF           
C
C ----- CONTACT - BOUCLE GEOMETRIQUE
C
        IF (LCTCG.AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCOG,TPSCVT)
          CALL U2MESI('I','MECANONLINE8_11',1,CTCGEO)
        ENDIF
C
C ----- CONTACT DISCRET
C
        IF ((LCTCD).AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCDA,TPSCVT)
          CALL U2MESI('I','MECANONLINE8_10',1,CTCCIT)
        ENDIF
C
C ----- CONTACT CONTINU
C
        IF ((LCTCC).AND.(.NOT.LALLV)) THEN
          IF (LBOUCF) THEN
            CALL U2MESI('I','MECANONLINE8_22',1,CTCFRO)
          ENDIF
          IF (LBOUCC) THEN
            CALL U2MESI('I','MECANONLINE8_23',1,CTCCIT)
          ENDIF
        ENDIF
C
C ----- NOMBRE DE LIAISONS
C
        IF ((LCONT).AND.(.NOT.LALLV)) THEN
          CALL U2MESI('I','MECANONLINE8_31',1,NBLIAC)
          IF (LFROT) THEN
            CALL U2MESI('I','MECANONLINE8_32',1,NBLIAF)
          ENDIF
        ENDIF
C
C ----- TEMPS PASSE
C
        CALL IMPFOT(TPS   ,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_50',1,TPSCVT)
        IF (TPSLST.NE.0.D0) THEN
          CALL IMPFOT(TPSLST,TPSCVT)
          EFFICA = 100.D0*(TPS-TPSLST)/TPS
          CALL U2MESG('I','MECANONLINE8_70',1,TPSCVT,0,IBID,1,EFFICA)
        ENDIF
        CALL IMPFOT(TPSASM,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_51',1,TPSCVT)
        CALL IMPFOT(TPS2MB,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_52',1,TPSCVT)    
        CALL IMPFOT(TPSFAC,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_53',1,TPSCVT)
        CALL IMPFOT(TPSINT,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_54',1,TPSCVT)
        CALL IMPFOT(TPSSOL,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_55',1,TPSCVT)    
C
C ----- CONTACT DISCRET
C
        IF ((LCTCD).AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCDA,TPSCVT)
          CALL U2MESK('I','MECANONLINE8_56',1,TPSCVT)
        ENDIF
C
C ----- CONTACT CONTINU
C
        IF ((LCTCC).AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCCM,TPSCVT)
          CALL U2MESK('I','MECANONLINE8_57',1,TPSCVT)
          CALL IMPFOT(TPSCCP,TPSCVT)
          CALL U2MESK('I','MECANONLINE8_58',1,TPSCVT)
          IF (LBOUCF) THEN
            CALL IMPFOT(TPSCCF,TPSCVT)
            CALL U2MESK('I','MECANONLINE8_59',1,TPSCVT)
          ENDIF
          IF (LBOUCC) THEN
            CALL IMPFOT(TPSCCC,TPSCVT)
            CALL U2MESK('I','MECANONLINE8_60',1,TPSCVT)
          ENDIF       
        ENDIF
C
C ----- CONTACT - BOUCLE GEOMETRIQUE
C
        IF (LCTCG.AND.(.NOT.LALLV)) THEN
          CALL IMPFOT(TPSCOG,TPSCVT)
          CALL U2MESK('I','MECANONLINE8_61',1,TPSCVT)   
        ENDIF
C
C ----- TEMPS POST-TRAITEMENT
C
        IF (LPOST) THEN
          CALL IMPFOT(TPSPST,TPSCVT)
          CALL U2MESK('I','MECANONLINE8_62',1,TPSCVT)
        ENDIF
C
C ----- TEMPS RESTANTS
C
        CALL IMPFOT(TPSRST,TPSCVT)
        CALL U2MESK('I','MECANONLINE8_63',1,TPSCVT)

      ENDIF
C
C --- RE-INIT STAT
C
      CALL NMRINI(SDTIME,SDSTAT,PHASE )
C
      CALL JEDEMA()
      END
