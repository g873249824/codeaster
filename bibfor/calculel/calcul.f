      SUBROUTINE CALCUL(STOP,OPTIO,LIGRLZ,NIN,LCHIN,LPAIN,NOU,LCHOU,
     &                  LPAOU,BASE)
      IMPLICIT NONE

C MODIF CALCULEL  DATE 28/06/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C TOLE CRP_20
C     ARGUMENTS:
C     ----------
      INTEGER NIN,NOU
      CHARACTER*(*) BASE,OPTIO
      CHARACTER*(*) LCHIN(*),LCHOU(*),LPAIN(*),LPAOU(*),LIGRLZ
C ----------------------------------------------------------------------
C     ENTREES:
C        STOP   :  /'S' : ON S'ARRETE SI AUCUN ELEMENT FINI DU LIGREL
C                         NE SAIT CALCULER L'OPTION.
C                  /'C' : ON CONTINUE SI AUCUN ELEMENT FINI DU LIGREL
C                         NE SAIT CALCULER L'OPTION. IL N'EXISTE PAS DE
C                         CHAMP "OUT" DANS CE CAS.
C        OPTIO  :  NOM D'1 OPTION
C        LIGRLZ :  NOM DU LIGREL SUR LEQUEL ON DOIT FAIRE LE CALCUL
C        NIN    :  NOMBRE DE CHAMPS PARAMETRES "IN"
C        NOU    :  NOMBRE DE CHAMPS PARAMETRES "OUT"
C        LCHIN  :  LISTE DES NOMS DES CHAMPS "IN"
C        LCHOU  :  LISTE DES NOMS DES CHAMPS "OUT"
C        LPAIN  :  LISTE DES NOMS DES PARAMETRES "IN"
C        LPAOU  :  LISTE DES NOMS DES PARAMETRES "OUT"
C        BASE   :  'G' , 'V' OU 'L'

C     SORTIES:
C       ALLOCATION ET CALCUL DES OBJETS CORRESPONDANT AUX CHAMPS "OUT"

C ----------------------------------------------------------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII03/IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII05/IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
      CHARACTER*16 OPTION,NOMTE,NOMTM,PHENO,MODELI
      COMMON /CAKK01/OPTION,NOMTE,NOMTM,PHENO,MODELI
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      INTEGER NBOBJ,IAINEL,ININEL
      COMMON /CAII09/NBOBJ,IAINEL,ININEL
      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      INTEGER CAINDZ(512),CAPOIZ
      COMMON /CAII12/CAINDZ,CAPOIZ
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI,IEXI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
C-----------------------------------------------------------------------
      LOGICAL LFETMO,LFETTS,LFETTD,LDIST,LFETI,LFETIC,DBG,LDGREL
      REAL*8 RBID,TEMP1(6),TEMP2(6)
      CHARACTER*8  LPAIN2(NIN),LPAOU2(NOU)
      CHARACTER*19 LCHIN2(NIN),LCHOU2(NOU),NOCHOU
      CHARACTER*19 LIGREL
      CHARACTER*24 K24B,INFOFE,VALK(2),KFEL
      CHARACTER*1 STOP
      INTEGER IACHII,IACHIK,IACHIX,IADSGD,IBID,NBPROC,IFETI1,JPARAL
      INTEGER IALIEL,IAMACO,IAMLOC,IAMSCO,IANOOP,IANOTE,IAOBTR,IDD
      INTEGER IAOPDS,IAOPMO,IAOPNO,IAOPPA,IAOPTT,IMA,IFCPU,RANG,IFM,NIV
      INTEGER IER,ILLIEL,ILMACO,ILMLOC,ILMSCO,ILOPMO,IINF,IRET1,IFEL1
      INTEGER ILOPNO,IRET,IUNCOD,IUNIFI,J,LGCO,IFEL2,IRET2,ILIMPI
      INTEGER NPARIO,NBOBMX,NPARIN,NBSD,JNUMSD,N1,JNOLIG,JNUGSD
      INTEGER NBGREL,TYPELE,NBELEM,NUCALC,VALI(4)
      INTEGER NBOBTR,NVAL,INDIK8
      CHARACTER*32 JEXNOM,JEXNUM,PHEMOD
      INTEGER OPT,AFAIRE,INPARA
      INTEGER IEL,NUMC,NUMAIL,K,JRESL
      INTEGER I,IPAR,NIN2,NIN3,NOU2,NOU3,JTYPMA
      CHARACTER*1 BASE2,KBID
      CHARACTER*8 NOMPAR,CAS,EXIELE,K8BID,PARTIT
      CHARACTER*10 K10B
      CHARACTER*16 K16BID, CMDE
      CHARACTER*20 K20B1, K20B2, K20B3, K20B4


C     -- FONCTIONS FORMULES :
C     NUMAIL(IGR,IEL)=NUMERO DE LA MAILLE ASSOCIEE A L'ELEMENT IEL
      NUMAIL(IGR,IEL)=ZI(IALIEL-1+ZI(ILLIEL-1+IGR)-1+IEL)

C DEB-------------------------------------------------------------------

      CALL JEMARQ()
      CALL UTTCPU('CPU.CALC.1','DEBUT',' ')
      CALL UTTCPU('CPU.CALC.2','DEBUT',' ')
      CALL INFNIV(IFM,NIV)
      LIGREL=LIGRLZ
      IACTIF=1
      BASE2=BASE
      OPTION=OPTIO
      DBG=.FALSE.
      LFETMO=.FALSE.
      LFETTS=.FALSE.
      LFETTD=.FALSE.
      LFETIC=.FALSE.


C     -- S'IL N'Y A PAS D'ELEMENTS FINIS DANS LE MODELE, ON SORT
C        TOUT DE SUITE :
      CALL DISMOI('F','EXI_ELEM',LIGREL,'LIGREL',IBID,EXIELE,IBID)
      CALL DISMOI('F','PARTITION',LIGREL,'LIGREL',IBID,PARTIT,IBID)
      IF (EXIELE.NE.'OUI') THEN
        IF (STOP.EQ.'S') THEN
          CALL U2MESK('F','CALCULEL2_25',1,LIGREL)
        ELSE
          GOTO 120
        ENDIF
      ENDIF


      DO 10 I=1,512
        CAINDZ(I)=1
   10 CONTINUE
      CALL MECOEL()

      IF (DBG) THEN
        WRITE(6,*) ' '
        WRITE(6,*) '&&CALCUL OPTION=',OPTION
      ENDIF

      CALL JEVEUO('&CATA.TE.TYPEMA','L',JTYPMA)
      CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',OPTION),OPT)
      IF (OPT.LE.0) CALL U2MESK('F','CALCULEL_29',1,OPTION)

C     -- POUR SAVOIR L'UNITE LOGIQUE OU ECRIRE LE FICHIER ".CODE" :
      CALL GETVLI(CAS)
      IUNCOD = IUNIFI('CODE')
      IF (IUNCOD.GT.0)
     +   CALL GETRES(K8BID, K16BID, CMDE)

C     0.1- CAS D'UN CALCUL "FETI" :
C          CALCUL DE : LFETMO,LFETTS,LFETTD,LFETIC,INFOFE
C     -----------------------------------------------------------------
      INFOFE='FFFFFFFFFFFFFFFFFFFFFFFF'
      CALL JEEXIN('&FETI.MAILLE.NUMSD',IRET)
      LFETI=(IRET.GT.0)
      IF (LFETI) THEN
C       - CALCUL DU RANG ET DU NBRE DE PROC
        CALL FETMPI(2,IBID,IBID,1,RANG,IBID,K24B,K24B,K24B,RBID)
        CALL FETMPI(3,IBID,IBID,1,IBID,NBPROC,K24B,K24B,K24B,RBID)
C       - ON PROFILE OU PAS ?
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE=ZK24(IINF)
        IF (INFOFE(11:11).EQ.'T') THEN
          LFETIC=.TRUE.
          CALL UTTCPR ('CPU.CALC.2',6,TEMP1)
        ENDIF

C       - SI PARALLELISME ET OPTION.NE.'NSPG_NBVA',
C       - ON VA TARIR LE FLOT DE DONNEES
        IF ((NBPROC.GT.1) .AND. (OPTION(1:9).NE.'NSPG_NBVA')) THEN
          IF (LIGREL(9:15).EQ.'.MODELE') THEN
C         -    FETI PARALLELE SUR LIGREL DE MODELE
C         -    ON VA DONC TRIER PAR MAILLE PHYSIQUE
            LFETMO=.TRUE.
            CALL JEVEUO('&FETI.MAILLE.NUMSD','L',IFETI1)
            IFETI1=IFETI1-1
          ELSE
C         -    PROBABLEMENT FETI PARALLELE SUR LIGREL TARDIF
C         -    DANS LE DOUTE, ON S'ABSTIENT ET ON FAIT TOUT
            KFEL=LIGREL(1:19)//'.FEL1'
            CALL JEEXIN(KFEL,IRET1)
            IF (IRET1.NE.0) THEN
C         -   LIGREL A MAILLES TARDIVES
              CALL JELIRA(KFEL,'LONMAX',NBSD,K8BID)
              CALL JEVEUO(KFEL,'L',IFEL1)
              CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
              DO 20 IDD=1,NBSD
                IF (ZI(ILIMPI+IDD).EQ.1) THEN
C         -   LE SOUS-DOMAINE IDD EST CONCERNE PAR CE PROC
                  IF (ZK24(IFEL1+IDD-1)(1:19).EQ.LIGREL(1:19)) THEN
C         -   LIGREL TARDIF CONCENTRE SUR LE SOUS DOMAINE IDD
C         -   IL FAUT TOUT FAIRE
                    LFETTS=.TRUE.
                  ELSEIF (ZK24(IFEL1+IDD-1)(1:19).NE.' ') THEN
C         -   LIGREL TARDIF DUPLIQUE, NOTAMMENT, SUR LE SOUS DOMAINE IDD
C             POINTE PAR UN .FEL2 (AUTRE QUE LIGREL DE CONTACT INIT)
                    KFEL=LIGREL(1:19)//'.FEL2'
                    CALL JEEXIN(KFEL,IRET2)
                    IF (IRET2.NE.0) THEN
C         -   ON VA TRIER PAR MAILLE TARDIVE, SINON ON FAIT TOUT PAR
C         -   PRUDENCE
                      LFETTD=.TRUE.
                      CALL JEVEUO(KFEL,'L',IFEL2)
                    ENDIF
                  ENDIF
                ENDIF
   20         CONTINUE
            ENDIF
          ENDIF
          IF ((LFETMO.AND.LFETTS) .OR. (LFETMO.AND.LFETTD) .OR.
     &        (LFETTS.AND.LFETTD)) CALL U2MESS('F','CALCULEL6_75')
        ENDIF

C       -- MONITORING FETI :
        IF (INFOFE(1:1).EQ.'T') THEN
          WRITE (IFM,*)'<FETI/CALCUL> RANG ',RANG
          WRITE (IFM,*)'<FETI/CALCUL> LIGREL/OPTION ',LIGREL,' ',OPTION
          IF (LFETMO) THEN
            WRITE (IFM,*)'<FETI/CALCUL> LIGREL DE MODELE'
          ELSEIF (LFETTS) THEN
            WRITE (IFM,*)'<FETI/CALCUL> LIGREL TARDIF NON DUPLIQUE'
          ELSEIF (LFETTD) THEN
            WRITE (IFM,*)'<FETI/CALCUL> LIGREL TARDIF DUPLIQUE'
          ELSE
            IF (NBPROC.GT.1)WRITE (IFM,*)'<FETI/CALCUL> AUTRE LIGREL'
          ENDIF
        ENDIF
      ENDIF



C     0.2- CAS D'UN CALCUL "DISTRIBUE" :
C     -- CALCUL DE LDIST :
C          .TRUE.  : LES CALCULS ELEMENTAIRES SONT DISTRIBUES (PAS FETI)
C          .FALSE. : SINON
C     -- CALCUL DE LDGREL :
C          .TRUE.  : LES CALCULS ELEMENTAIRES SONT DISTRIBUES PAR GREL
C     -- SI LDIST  == .TRUE. : CALCUL DE  RANG ET JNUMSD
C     -------------------------------------------------------------
      LDIST=.FALSE.
      LDGREL=.FALSE.
      CALL JEEXIN(PARTIT//'.NUPROC.MAILLE',IRET)
      IF ((IRET.NE.0).AND.(.NOT.LFETI)) THEN
        LDIST=.TRUE.
        CALL MPICM0(RANG,NBPROC)
        CALL JEVEUO(PARTIT//'.NUPROC.MAILLE','L',JNUMSD)
        CALL JELIRA(PARTIT//'.NUPROC.MAILLE','LONMAX',N1,KBID)
        IF (ZI(JNUMSD-1+N1).NE.NBPROC) THEN
          VALI(1)=ZI(JNUMSD-1+N1)
          VALI(2)=NBPROC
          CALL U2MESI('F','CALCULEL_13',2,VALI)
        ENDIF
        CALL JEEXIN(PARTIT//'.NUPROC.LIGREL',IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(PARTIT//'.NUPROC.LIGREL','L',JNOLIG)
          IF (ZK24(JNOLIG-1+1).EQ.LIGREL) THEN
            LDGREL=.TRUE.
            CALL JEVEUO(PARTIT//'.NUPROC.GREL','L',JNUGSD)
          ENDIF
        ENDIF
      ENDIF


C     0.4- DEBCA1 MET DES OBJETS EN MEMOIRE (ET COMMON):
C     -----------------------------------------------------------------
      CALL DEBCA1(OPTION,LIGREL)

C     1- SI AUCUN TYPE_ELEMENT DU LIGREL NE SAIT CALCULER L'OPTION,
C     -- ON VA DIRECTEMENT A LA SORTIE :
C     -------------------------------------------------------------
      AFAIRE=0
      IER=0
      NBGR=NBGREL(LIGREL)
      DO 30,J=1,NBGR
        NUTE=TYPELE(LIGREL,J)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTE),NOMTE)
        NOMTM=ZK8(JTYPMA-1+NUTE)
        NUMC=NUCALC(OPT,NUTE,0)

C        -- SI LE NUMERO DU TEOOIJ EST NEGATIF :
        IF (NUMC.LT.0) THEN
          VALK(1)=NOMTE
          VALK(2)=OPTION
          IF (NUMC.EQ.-1) THEN
            CALL U2MESK('F','CALCULEL_30',2,VALK)
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ENDIF

        AFAIRE=MAX(AFAIRE,NUMC)
   30 CONTINUE
      CALL ASSERT(IER.LE.0)
      IF (AFAIRE.EQ.0) THEN
        IF (STOP.EQ.'S') THEN
          CALL U2MESK('F','CALCULEL_34',1,OPTION)
        ELSE
          GOTO 120

        ENDIF
      ENDIF

C     2- ON REND PROPRES LES LISTES : LPAIN,LCHIN,LPAOU,LCHOU :
C        EN NE GARDANT QUE LES PARAMETRES DU CATALOGUE DE L'OPTION
C        QUI SERVENT A AU MOINS UN TYPE_ELEMENT
C     ---------------------------------------------------------
C     TEST SUR ERREUR PROGRAMMEUR : TROP DE CHAMPS "IN"
      CALL ASSERT(NIN.LE.80)
      NIN3=ZI(IAOPDS-1+2)
      NOU3=ZI(IAOPDS-1+3)

      NIN2=0
      DO 50,I=1,NIN
        NOMPAR=LPAIN(I)
        IPAR=INDIK8(ZK8(IAOPPA),NOMPAR,1,NIN3)
        IF (IPAR.GT.0) THEN
          DO 40,J=1,NBGR
            NUTE=TYPELE(LIGREL,J)
            IPAR=INPARA(OPT,NUTE,'IN ',NOMPAR)

            IF (IPAR.EQ.0)GOTO 40
            CALL EXISD('CHAMP_GD',LCHIN(I),IRET)
            IF (IRET.EQ.0)GOTO 40
            NIN2=NIN2+1
            LPAIN2(NIN2)=LPAIN(I)
            LCHIN2(NIN2)=LCHIN(I)
            GOTO 50

   40     CONTINUE
        ENDIF
   50 CONTINUE

C     -- VERIF PAS DE DOUBLONS DANS LPAIN2 :
      CALL KNDOUB(8,LPAIN2,NIN2,IRET)
      CALL ASSERT(IRET.EQ.0)

      NOU2=0
      DO 70,I=1,NOU
        NOMPAR=LPAOU(I)
        IPAR=INDIK8(ZK8(IAOPPA+NIN3),NOMPAR,1,NOU3)
        IF (IPAR.GT.0) THEN
          DO 60,J=1,NBGR
            NUTE=TYPELE(LIGREL,J)
            IPAR=INPARA(OPT,NUTE,'OUT',NOMPAR)

            IF (IPAR.EQ.0)GOTO 60
            NOU2=NOU2+1
            LPAOU2(NOU2)=LPAOU(I)
            LCHOU2(NOU2)=LCHOU(I)
C           -- ON INTERDIT LA CREATION DU CHAMP ' ' :
            CALL ASSERT(LCHOU2(NOU2).NE.' ')
            GOTO 70

   60     CONTINUE
        ENDIF
   70 CONTINUE
C     -- VERIF PAS DE DOUBLONS DANS LPAOU2 :
      CALL KNDOUB(8,LPAOU2,NOU2,IRET)
      CALL ASSERT(IRET.EQ.0)

C     3- DEBCAL FAIT DES INITIALISATIONS ET MET LES OBJETS EN MEMOIRE :
C     -----------------------------------------------------------------
      CALL DEBCAL(OPTION,LIGREL,NIN2,LCHIN2,LPAIN2,NOU2,LCHOU2)
      IF (DBG) CALL CALDBG(OPTION,'IN',NIN2,LCHIN2,LPAIN2)

C     4- ALLOCATION DES RESULTATS ET DES CHAMPS LOCAUX:
C     -------------------------------------------------
      CALL ALRSLT(OPT,LIGREL,NOU2,LCHOU2,LPAOU2,BASE2,LDIST,LFETI)
      CALL ALCHLO(OPT,LIGREL,NIN2,LPAIN2,LCHIN2,NOU2,LPAOU2)

C     5- AVANT BOUCLE SUR LES GREL :
C     QUELQUES ACTIONS HORS BOUCLE GREL DUES A CALVOI==1 :
C     -----------------------------------------------------
      CALL EXTRAI(NIN2,LCHIN2,LPAIN2,OPT,NUTE,LIGREL,'INIT')

C     6- BOUCLE SUR LES GREL :
C     -------------------------------------------------
      DO 100 IGR=1,NBGR

C       -- SI PARALLELISME='GROUP_ELEM' : ON PEUT PARFOIS TOUT "SAUTER"
        IF (LDGREL) THEN
          IF (ZI(JNUGSD-1+IGR).GE.0) THEN
            IF (ZI(JNUGSD-1+IGR).NE.RANG) THEN
              GOTO 100
            ENDIF
          ENDIF
        ENDIF

        NUTE=TYPELE(LIGREL,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTE),NOMTE)
        NOMTM=ZK8(JTYPMA-1+NUTE)
        CALL DISMOI('F','PHEN_MODE',NOMTE,'TYPE_ELEM',IBID,PHEMOD,IBID)
        PHENO=PHEMOD(1:16)
        MODELI=PHEMOD(17:32)
        CALL JELIRA(JEXNUM('&CATA.TE.CTE_ATTR',NUTE),'LONMAX',LCTEAT,
     &              KBID)
        IF (LCTEAT.GT.0) THEN
          CALL JEVEUO(JEXNUM('&CATA.TE.CTE_ATTR',NUTE),'L',JCTEAT)
        ELSE
          JCTEAT=0
        ENDIF
        NBELGR=NBELEM(LIGREL,IGR)
        NUMC=NUCALC(OPT,NUTE,0)
        CALL ASSERT(NUMC.GE.-10)
        CALL ASSERT(NUMC.LE.9999)

        IF (NUMC.GT.0) THEN

C         -- EN MODE PARALLELE
C         -- SI FETI OU CALCUL DISTRIBUE , ON VA REMPLIR
C         -- LE VECTEUR AUXILIAIRE '&CALCUL.PARALLELE'
          IF (LFETMO .OR. LFETTD .OR. LDIST) THEN
            CALL WKVECT('&CALCUL.PARALLELE','V V L',NBELGR,JPARAL)
            DO 80 IEL=1,NBELGR
              IMA=NUMAIL(IGR,IEL)
              IF (LFETMO) THEN
C               - LIGREL DE MODELE, ON TAG EN SE BASANT SUR
C                '&FETI.MAILLE.NUMSD'
                IF (IMA.LE.0) CALL U2MESS('F','CALCULEL6_76')
                IF (ZI(IFETI1+IMA).GT.0)ZL(JPARAL-1+IEL)=.TRUE.
              ELSEIF (LFETTD) THEN
                IF (IMA.GE.0) CALL U2MESS('F','CALCULEL6_76')
                IDD=ZI(IFEL2+2*(-IMA-1)+1)
C               - MAILLE TARDIVES, ON TAG EN SE BASANT SUR .FEL2
C                 (VOIR NUMERO.F)
                IF (IDD.GT.0) THEN
C                 - MAILLE NON SITUEE A L'INTERFACE
                  IF (ZI(ILIMPI+IDD).EQ.1)ZL(JPARAL-1+IEL)=.TRUE.
                ELSEIF (IDD.EQ.0) THEN
C                 - MAILLE D'UN AUTRE PROC, ON NE FAIT RIEN
C                   ZL(JPARAL-1+IEL) INITIALISE A .FALSE.
                ELSEIF (IDD.LT.0) THEN
C                 - MAILLE A L'INTERFACE, ON NE S'EMBETE PAS ET ON FAIT
C                    TOUT (C'EST DEJA ASSEZ COMPLIQUE COMME CELA !)
                  ZL(JPARAL-1+IEL)=.TRUE.
                ENDIF
              ELSEIF (LDIST) THEN
C              - LIGREL DE MODELE, ON TAG EN SE BASANT SUR
C               PARTIT//'.NUPROC.MAILLE'
                IF (((IMA.LT.0).AND.(RANG.EQ.0)) .OR.
     &              ((IMA.GT.0).AND.(ZI(JNUMSD-1+IMA).EQ.RANG)))
     &              ZL(JPARAL-1+IEL)=.TRUE.
              ENDIF
   80       CONTINUE

C           -- MONITORING
            IF (INFOFE(2:2).EQ.'T')  CALL UTIMSD(IFM,2,.FALSE.,
     &          .TRUE.,'&CALCUL.PARALLELE',1,' ')

          ENDIF

C         6.1 INITIALISATION DES TYPE_ELEM :
          CALL INIGRL(LIGREL,IGR,NBOBJ,ZI(IAINEL),ZK24(ININEL),NVAL)

C         6.2 ECRITURE AU FORMAT ".CODE" DU COUPLE (OPTION,TYPE_ELEM)
          IF (IUNCOD.GT.0) THEN
            K10B  = CAS
            K20B1 = '&&CALCUL'
            K20B2 = OPTION
            K20B3 = NOMTE
            K20B4 = CMDE
            WRITE (IUNCOD, 1000) K10B, K20B1, K20B2, K20B3, K20B4
          ENDIF

C         6.3 PREPARATION DES CHAMPS "IN"
          CALL EXTRAI(NIN2,LCHIN2,LPAIN2,OPT,NUTE,LIGREL,' ')

C         6.4 MISE A ZERO DES CHAMPS "OUT"
          CALL ZECHLO(OPT,NUTE)

C         6.5 ON ECRIT UNE VALEUR "UNDEF" AU BOUT DE
C             TOUS LES CHAMPS LOCAUX "IN" ET "OUT":
          CALL CAUNDF('ECRIT',OPT,NUTE)

C         6.6 ON FAIT LES CALCULS ELEMENTAIRES:
          IF (DBG)
     &      WRITE (6,*)'&&CALCUL OPTION= ',OPTION,' ',NOMTE,' ',NUMC
          CALL VRCDEC()
          CALL TE0000(NUMC,OPT,NUTE)

C         6.7 ON VERIFIE LA VALEUR "UNDEF" DES CHAMPS LOCAUX "OUT" :
          CALL CAUNDF('VERIF',OPT,NUTE)

C         6.8 ON RECOPIE DES CHAMPS LOCAUX DANS LES CHAMPS GLOBAUX:
          CALL MONTEE(OPT,LIGREL,NOU2,LCHOU2,LPAOU2,' ')
C         IMPRESSIONS DE DEBUG POUR DETERMINER LES TEXXXX COUPABLES :
          IF (DBG) CALL CALDBG(OPTION,'OUTG',NOU2,LCHOU2,LPAOU2)

          CALL JEDETR('&CALCUL.PARALLELE')
        ENDIF
  100 CONTINUE
C     ---FIN BOUCLE IGR

C     7- APRES BOUCLE SUR LES GREL :
C     QUELQUES ACTIONS HORS BOUCLE GREL DUES A CALVOI==1 :
C     -----------------------------------------------------
      CALL MONTEE(OPT,LIGREL,NOU2,LCHOU2,LPAOU2,'FIN')

C     -- POUR DEBUGGAGE, ON TRACE LE CHAMP RESULTAT
C      CALL IMPRSD('CHAMP',LCHOU2(1),6,'IMPRSD FIN DE CALCUL')

      IF (DBG) CALL CALDBG(OPTION,'OUTF',NOU2,LCHOU2,LPAOU2)

C     8- ON DETRUIT LES OBJETS VOLATILES CREES PAR CALCUL:
C     ----------------------------------------------------
      DO 110,I=1,NBOBTR
        CALL JEDETR(ZK24(IAOBTR-1+I))
  110 CONTINUE
      CALL JEDETR('&&CALCUL.OBJETS_TRAV')

  120 CONTINUE
      IACTIF=0


C     9- MESURE DU TEMPS CONSOMME :
C     ----------------------------------
      CALL UTTCPU('CPU.CALC.1','FIN',' ')
      CALL UTTCPU('CPU.CALC.2','FIN',' ')

      IF (LFETIC) THEN
        CALL UTTCPR ('CPU.CALC.2',6,TEMP2)
        CALL JEVEUO('&FETI.INFO.CPU.ELEM','E',IFCPU)
        ZR(IFCPU+RANG)=ZR(IFCPU+RANG)+
     &                 (TEMP2(5)-TEMP1(5))+(TEMP2(6)-TEMP1(6))
      ENDIF

      CALL JEDEMA()
C
 1000 FORMAT(1X,A10,A20,1X,A20,A20,A20)
C
      END
