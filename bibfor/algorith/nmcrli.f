      SUBROUTINE NMCRLI(FONACT,INSTIN,LISINS,SDDISC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/12/2011   AUTEUR GENIAUT S.GENIAUT 
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
      IMPLICIT     NONE
      CHARACTER*19 SDDISC,LISINS
      REAL*8       INSTIN
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION
C
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  INSTIN : INSTANT INITIAL QUAND ETAT_INIT
C                R8VIDE SI NON DEFINI
C IN  LISINS : LISTE D'INSTANTS (SD_LISTR8 OU SD_LIST_INST)
C OUT SDDISC : SD DISCRETISATION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      JINST
      INTEGER      NUMINI,NUMFIN
      INTEGER      I,IBID,IOCC
      INTEGER      N1
      INTEGER      NBTEMP,NBINST,NBPAR
      REAL*8       TOLE
      REAL*8       DIINST,R8BID
      REAL*8       DTMIN,DT0,R8VIDE
      LOGICAL      LINSTI,LINSEI
      CHARACTER*8  K8BID,RESULT
      CHARACTER*24 TPSIPO
      CHARACTER*24 TPSPIL,TPSDIN,TPSITE,TPSBCL
      INTEGER      JPIL,JNIVTP,JITER,JBCLE
      CHARACTER*24 LISIFR,LISDIT
      CHARACTER*24 TPSINF
      INTEGER      IFM,NIV
      CHARACTER*16 TYPECO,MOTFAC,K16BID,TYPRES,NOMCMD
      CHARACTER*19 PROVLI
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION SD DISCRETISATION'
      ENDIF
C
C --- INITIALISATIONS
C
      LINSTI = .FALSE.
      IOCC   = 1
      MOTFAC = 'INCREMENT'
      PROVLI = '&&NMCRLI.PROVLI'
C
C --- NOM SDS DE LA SDLIST
C
      LISIFR = LISINS(1:8)//'.LIST.INFOR'
      LISDIT = LISINS(1:8)//'.LIST.DITR'
C
C --- NOM SDS DE LA SDDISC
C
      TPSDIN = SDDISC(1:19)//'.DINI'
      TPSBCL = SDDISC(1:19)//'.BCLE'
      TPSITE = SDDISC(1:19)//'.ITER'
      TPSIPO = SDDISC(1:19)//'.LIPO'
C
      TPSPIL = SDDISC(1:19)//'.EPIL'
      TPSINF = SDDISC(1:19)//'.LINF'
C
C --- OBJETS NIVEAUX DE BOUCLE
C --- 1 - ITERAT (NEWTON)
C --- 2 - NUMINS (PAS DE TEMPS)
C --- 3 - NIVEAU (BOUCLE CONTACT/XFEM)
C --- 4 - PREMIE (0 SI TOUT PREMIER, 1 SINON)
C
      CALL WKVECT(TPSBCL,'V V I',4,JBCLE)
C
C --- OBJET CHOIX DE LA SOLUTION EQUATION DE PILOTAGE
C
      CALL WKVECT(TPSPIL,'V V I',2,JPIL )
      ZI(JPIL)   = 1
      ZI(JPIL+1) = 1
C
C --- LECTURE DE LA LISTE D'INSTANTS
C
      CALL GETTCO(LISINS,TYPECO)
C
C --- CREATION LISTE D'INSTANT PROVISOIRE ET TPSINF
C
      IF (TYPECO.EQ.'LISTR8_SDASTER') THEN
        CALL NMCRLM(LISINS,SDDISC,PROVLI,TPSINF)
      ELSEIF (TYPECO.EQ.'LIST_INST') THEN
        CALL JEDUP1(LISDIT,'V',PROVLI)
        CALL JEDUP1(LISIFR,'V',TPSINF)
      ENDIF
C
C --- INFOS LISTE D'INSTANTS
C
      CALL UTDIDT('L'   ,SDDISC,'LIST',IBID  ,'DTMIN' ,
     &            DTMIN ,IBID  ,K8BID )
      CALL UTDIDT('L'   ,SDDISC,'LIST',IBID  ,'NBINST',
     &            R8BID ,NBINST,K8BID )
C
C --- ACCES LISTE D'INSTANTS PROVISOIRE
C
      CALL JEVEUO(PROVLI,'L',JINST)
C
C --- TOLERANCE POUR RECHERCHE DANS LISTE D'INSTANTS
C
      CALL GETVR8(MOTFAC,'PRECISION'     ,1,IARG,1,TOLE,N1)
      TOLE   = ABS(DTMIN) * TOLE
C
C --- L'INSTANT DE L'ETAT INITIAL EXISTE-T-IL ?
C
      IF (INSTIN.EQ.R8VIDE()) THEN
        LINSEI = .FALSE.
      ELSE
        LINSEI = .TRUE.
      ENDIF
C
C --- DETERMINATION DU NUMERO D'ORDRE INITIAL
C
      CALL NMDINI(MOTFAC,IOCC  ,PROVLI,INSTIN,LINSEI,
     &            TOLE  ,NBINST,LINSTI,NUMINI)
C
C --- DETERMINATION DU NUMERO D'ORDRE FINAL
C
      CALL NMDIFI(MOTFAC,IOCC  ,PROVLI,TOLE  ,NBINST,
     &            NUMFIN)
C
C --- VERIFICATION SENS DE LA LISTE
C
      IF (NUMINI.GE.NUMFIN) THEN
        CALL U2MESS('F','DISCRETISATION_92')
      ENDIF
C
C --- RETAILLAGE DE LA LISTE D'INSTANT PROVISOIRE -> SDDISC.DITR
C
      CALL NMCRLS(SDDISC,PROVLI,NUMINI,NUMFIN,LINSTI,
     &            INSTIN,NBTEMP,DTMIN )
C
C --- INDICATEUR DU NIVEAU DE SUBDIVISION DES PAS DE TEMPS
C
      CALL WKVECT(TPSDIN,'V V I' ,NBTEMP,JNIVTP)
      DO 30 I = 1, NBTEMP
        ZI(JNIVTP+I-1) = 1
 30   CONTINUE
C
C --- VECTEUR POUR STOCKER ITERAT NEWTON
C
      CALL WKVECT(TPSITE,'V V I' ,NBTEMP,JITER)
C
C --- ENREGISTREMENT DES INFORMATIONS
C
      DT0    = DIINST(SDDISC,1) - DIINST(SDDISC,0)
C
      CALL UTDIDT('E'   ,SDDISC,'LIST',IBID,'DT-'   ,
     &            DT0   ,IBID  ,K8BID )
      CALL UTDIDT('E'   ,SDDISC,'LIST',IBID,'NBINST',
     &            R8BID ,NBTEMP,K8BID )
      CALL UTDIDT('E'   ,SDDISC,'LIST',IBID,'DTMIN' ,
     &            DTMIN ,IBID  ,K8BID )
C
C --- STOCKAGE DE LA LISTE DES INSTANTS DE PASSAGE OBLIGATOIRES (JALONS)
C
      CALL JEDUPO(SDDISC(1:19)//'.DITR','V',TPSIPO,.FALSE.)
C
C --- CREATION DE LA TABLE DES PARAMETRES CALCULES
C
      CALL GETRES(RESULT,TYPRES,NOMCMD)
      IF (NOMCMD.NE.'CALC_POINT_MAT') THEN
        CALL NMCRPC(RESULT)
      ENDIF
C
      CALL JEDETR(PROVLI)
      CALL JEDEMA()

      END
