      SUBROUTINE ECLPGR()
      IMPLICIT   NONE
C MODIF CALCULEL  DATE 28/01/2003   AUTEUR DURAND C.DURAND 
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
C   - TRAITEMENT DU MOT CLE CREA_RESU/ECLA_PG

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

C ----------------------------------------------------------------------
C     VARIABLES NECESSAIRES A L'APPEL DE ECLATY :
C     ON COMPREND LE SENS DE CES VARIABLES EN REGARDANT ECLATY
      INTEGER MXNBN2,MXNBPG,MXNBPI,MXNBTE,MXNBNO
C     MXNBN2 : MAX DU NOMBRE DE NOEUDS D'UN SOUS-ELEMENT (HEXA8)
      PARAMETER (MXNBN2=8)
C     MXNBNO : MAX DU NOMBRE DE NOEUDS D'UN TYPE_ELEM (HEXA27)
      PARAMETER (MXNBNO=27)
C     MXNBPG : MAX DU NOMBRE DE POINTS DE GAUSS D'UN TYPE_ELEM
      PARAMETER (MXNBPG=27)
C     MXNBPI : MAX DU NOMBRE DE POINT_I (HEXA A 27 POINTS DE GAUSS)
C     MXNBPI = 4X4X4
      PARAMETER (MXNBPI=64)
C     MXNBTE : MAX DU NOMBRE DE TERMES DE LA C.L. DEFINISSANT 1 POINT_I
C              AU PLUS LES 8 SOMMETS D'UN HEXA8
      PARAMETER (MXNBTE=8)
      INTEGER CONNX(MXNBN2,MXNBPG),NSOMM1(MXNBPI,MXNBTE)
      INTEGER NTERM1(MXNBPI),NBNO2(MXNBPG),KK
      REAL*8 CSOMM1(MXNBPI,MXNBTE),PREC
      INTEGER TYMA(MXNBPG)
C ----------------------------------------------------------------------
      LOGICAL EXISDG
      INTEGER K,NBGREL,TE,TYPELE,NPG1,NPOINI,IDECA2
      INTEGER IGR,IAMACO,ILMACO,IALIEL,ILLIEL,NBELEM,JCNSL2
      INTEGER IBID,NBPG,INO,IRET,I,NBGR,INOGL,IAINS1,IAINS2
      INTEGER NUMGLM,IPG,IAMOL1,JCELV1,JCNSV2,NBSY,MXCMP,NP,NC
      INTEGER IMA,NBELGR,NBNOMA,JVAL2,NBNO,NDDL,IDDL,ADIEL,MXSY,ISY
      INTEGER IIPG,JCELD1,IANOL1,MOLOC1,NCMPMX,NBORDR,NDIM,IORDR,JORDR
      PARAMETER (MXSY=5,MXCMP=100)
      INTEGER NUDDL(MXCMP),IACMP,NCMPM1,ICOEF1,IEL
      CHARACTER*8 MO1,MA1,MA2,KBID,RESU,EVO1,NOMG1,NOMG2,CRIT
      CHARACTER*16 TYPRES,NOMCMD,NOMTE,NOMSY1,NOMSY2,LICHAM(MXSY)
      CHARACTER*16 TYPRE2
      CHARACTER*19 LIGREL,CH1,CH2S,CH2,PRCHNO
C     FONCTIONS FORMULES :
C     NBNOMA(IMA)=NOMBRE DE NOEUDS DE LA MAILLE IMA
      NBNOMA(IMA) = ZI(ILMACO-1+IMA+1) - ZI(ILMACO-1+IMA)
C     NUMGLM(IMA,INO)=NUMERO GLOBAL DU NOEUD INO DE LA MAILLE IMA
C                     IMA ETANT UNE MAILLE DU MAILLAGE.
      NUMGLM(IMA,INO) = ZI(IAMACO-1+ZI(ILMACO+IMA-1)+INO-1)
C DEB ------------------------------------------------------------------
      CALL JEMARQ()


      CALL GETRES(RESU,TYPRE2,NOMCMD)
      CALL GETVID('ECLA_PG','RESU_INIT',1,1,1,EVO1,IBID)
      CALL GETTCO(EVO1,TYPRES)
      IF (TYPRES.NE.TYPRE2) CALL UTMESS('F','CREA_RESU',
     &        'LE TYPE DE RESU_INIT EST DIFFERENT DE CELUI DU RESULTAT.'
     &                           )

      CALL GETVID('ECLA_PG','MAILLAGE',1,1,1,MA2,IBID)
      CALL GETVID('ECLA_PG','MODELE_INIT',1,1,1,MO1,IBID)
      CALL GETVTX('ECLA_PG','NOM_CHAM',1,1,MXSY,LICHAM,NBSY)

      CALL DISMOI('F','NOM_MAILLA',MO1,'MODELE',IBID,MA1,IBID)
      CALL JEVEUO(MA2//'.CONNEX','L',IAMACO)
      CALL JEVEUO(JEXATR(MA2//'.CONNEX','LONCUM'),'L',ILMACO)
      LIGREL = MO1//'.MODELE'
      CALL JEVEUO(LIGREL//'.LIEL','L',IALIEL)
      CALL JEVEUO(JEXATR(LIGREL//'.LIEL','LONCUM'),'L',ILLIEL)


C     -- CREATION DE LA SD RESULTAT : RESU
C     ------------------------------------
      CALL GETVR8('ECLA_PG','PRECISION',1,1,1,PREC,NP)
      CALL GETVTX('ECLA_PG','CRITERE',1,1,1,CRIT,NC)
      CALL RSUTNU(EVO1,'ECLA_PG',1,'&&ECLPGR.NUME_ORDRE',NBORDR,PREC,
     &            CRIT,IRET)
      IF (NBORDR.EQ.0) CALL UTMESS('F','ECLPGR','LA LISTE DE NUMEROS'//
     &                             ' D ORDRE EST VIDE.')
      CALL JEVEUO('&&ECLPGR.NUME_ORDRE','L',JORDR)

      IF (RESU.NE.EVO1) CALL RSCRSD(RESU,TYPRES,NBORDR)



C     -- ON CALCULE LES CHAM_NO RESULTATS :
C     --------------------------------------
      DO 90,ISY = 1,NBSY

C       -- ON SUPPOSE QUE TOUS LES INSTANTS ONT LE MEME PROFIL :
C          PRCHNO
        PRCHNO = '12345678.PROF_CHNO'
        CALL GCNCON('_',PRCHNO(1:8))

        DO 80,I = 1,NBORDR
          IORDR = ZI(JORDR+I-1)

C         -- DETERMINATION DE NOMSY1,NOMSY2,NOMG1,NOMG2
C         ---------------------------------------------------
          NOMSY1 = LICHAM(ISY)
          CALL RSEXCH(EVO1,NOMSY1,IORDR,CH1,IRET)
          IF (IRET.GT.0) GO TO 80

          CALL DISMOI('F','NOM_GD',CH1,'CHAMP',IBID,NOMG1,IBID)
          IF (NOMG1(5:6).NE.'_R') CALL UTMESS('F','ECLPGR',
     & 'LES SEULS CHAMPS AUTORISES POUR ECLA_PG SONT LES CHAMPS '
     & //'REELS.')
          NOMG2 = NOMG1
          IF (NOMG1.EQ.'VARI_R') NOMG2 = 'VAR2_R'

C      -- ON STOCKE LE CHAMP CREE SOUS LE MEME NOM QUE LE
C      -- CHAMP D'ORIGINE :
C         NOMSY2=NOMG1(1:4)//'_ELGA'
          NOMSY2 = NOMSY1

          CALL DISMOI('F','NB_CMP_MAX',NOMG2,'GRANDEUR',NCMPMX,KBID,
     &                IBID)
          CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMG2),'L',IACMP)


C         -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
          CALL CELVER(CH1,'NBSPT_1','COOL',KK)
          IF (KK.EQ.1) THEN
            CALL UTMESS('I','ECLPGR','LE CHAMP: '//NOMSY1
     &      //' A DES ELEMENTS AYANT DES SOUS-POINTS.'
     &      //' CES ELEMENTS NE SERONT PAS TRAITES.')
            CALL CELCEL('PAS_DE_SP',CH1,'V','&&ECLPGR.CH1')
            CH1= '&&ECLPGR.CH1'
          END IF

          CALL JEVEUO(CH1//'.CELV','L',JCELV1)
          CALL JEVEUO(CH1//'.CELD','L',JCELD1)
          CALL JEVEUO(CH1//'.CELK','L',IANOL1)
          IF (ZK24(IANOL1-1+1) (1:19).NE.LIGREL) CALL UTMESS('F',
     &    'ECLPGR','LIGREL INCOHERENT.'
     &    //' CAUSE POSSIBLE 1 : ERREUR DE MODELE_INIT'
     &    //' CAUSE POSSIBLE 2 : CALC_ELEM SUR UNE LISTE DE MAILLES.')

          IF (ZK24(IANOL1-1+3) (1:4).NE.'ELGA') CALL UTMESS('F',
     &    'ECLPGR','LES SEULS CHAMPS AUTORISES SONT ELGA.')
          CALL RSEXCH(RESU,NOMSY2,IORDR,CH2,IRET)


C       -- CREATION D'UN CHAM_NO_S : CH2S
C       -----------------------------------------------------
C         -- LA 1ERE FOIS, ON CREE CH2S :
          IF (I.EQ.1) THEN
            CH2S = '&&ECLPGR.CH2S'
            NCMPM1 = NCMPMX
            CALL CNSCRE(MA2,NOMG2,NCMPM1,ZK8(IACMP),'V',CH2S)
          ELSE
            CALL JEUNDF(CH2S//'.CNSV')
            CALL JEUNDF(CH2S//'.CNSL')
          END IF
          CALL JEVEUO(CH2S//'.CNSV','E',JCNSV2)
          CALL JEVEUO(CH2S//'.CNSL','E',JCNSL2)



C       -- REMPLISSAGE DU CHAM_NO :
C       ---------------------------
          IPG = 0
          NBGR = NBGREL(LIGREL)
          DO 70,IGR = 1,NBGR
            MOLOC1 = ZI(JCELD1-1+ZI(JCELD1-1+4+IGR)+2)
            IF (MOLOC1.EQ.0) GO TO 70
            ICOEF1 = MAX(1,ZI(JCELD1-1+4))

            CALL ASSERT(.NOT.((NOMG1.NE.'VARI_R').AND.(ICOEF1.GT.1)))

            CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',MOLOC1),'L',IAMOL1)
            CALL ASSERT(ZI(IAMOL1-1+1).EQ.3)
            NBPG = ZI(IAMOL1-1+4)

C           -- ON VERIFIE QUE C'EST UN CHAMP "ELGA/IDEN" :
C           ----------------------------------------------
            CALL ASSERT(.NOT.((NBPG.LT.0).OR.(NBPG.GT.10000)))

C           -- ON ECLATE LE TYPE_ELEM :
C           ---------------------------
            TE = TYPELE(LIGREL,IGR)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)
            CALL ECLATY(NOMTE,'FAMI_PG1',NDIM,NPG1,NPOINI,NTERM1,NSOMM1,
     &                  CSOMM1,TYMA,NBNO2,CONNX,MXNBN2,MXNBNO,MXNBPG,
     &                  MXNBPI,MXNBTE)
            IF (NPG1.NE.0) THEN
              IF (NBPG.NE.NPG1) CALL UTMESS('F','ECLPGR',
     &  'LE TYPE_ELEM: '//NOMTE//' N''A PAS LE NOMBRE DE POINTS DE'
     &  //' GAUSS DECLARE DANS LA ROUTINE ECLAU1. NOM_CHAM='//NOMSY1)
            ELSE
C            -- ON IGNORE LES AUTRES ELEMENTS :
              NBPG = 0
              GO TO 70
            END IF
            NBELGR = NBELEM(LIGREL,IGR)

C            -- QUELLES SONT LES CMPS PORTEES PAR LES POINTS DE GAUSS ?
C            ----------------------------------------------------------
            IF (NOMG1.EQ.'VARI_R') THEN
              NDDL = ICOEF1
              DO 10,K = 1,NDDL
                NUDDL(K) = K
   10         CONTINUE
            ELSE
              NDDL = 0
              DO 20,K = 1,NCMPM1
                IF (EXISDG(ZI(IAMOL1-1+4+1),K)) THEN
                  NDDL = NDDL + 1
                  NUDDL(NDDL) = K
                END IF
   20         CONTINUE
            END IF


C          -- BOUCLE SUR TOUS LES POINTS DE GAUSS DU GREL :
C          ------------------------------------------------
            DO 60,IEL = 1,NBELGR
              IF (NOMG1.EQ.'VARI_R') NDDL = ZI(JCELD1-1+
     &            ZI(JCELD1-1+4+IGR)+4+4* (IEL-1)+2)

              DO 50,IIPG = 1,NBPG
                IPG = IPG + 1
C            -- AU POINT DE GAUSS IPG CORRESPOND LA MAILLE NUMERO IPG
C               DANS MA2.
                IMA = IPG
                NBNO = NBNOMA(IMA)
                IF (NBNO.GT.27) CALL UTMESS('F','ECLPGR',
     &                               'NOMBRE DE NOEUDS > 27 ')
                DO 40,INO = 1,NBNO
                  INOGL = NUMGLM(IMA,INO)
                  DO 30,IDDL = 1,NDDL
                    IDECA2 = NCMPM1* (INOGL-1) + NUDDL(IDDL)
                    JVAL2 = JCNSV2 - 1 + IDECA2
                    ZL(JCNSL2-1+IDECA2) = .TRUE.
                    ADIEL = ZI(JCELD1-1+ZI(JCELD1-1+4+IGR)+4+4* (IEL-1)+
     &                      4)
                    ZR(JVAL2) = ZR(JCELV1-1+ADIEL-1+NDDL* (IIPG-1)+IDDL)


C                -- POUR FACILITER LE TRAVAIL DE GIBI, ON PERTURBE UN
C                   PEU LES VALEURS :
                    ZR(JVAL2) = (1.D0+DBLE(INO)/5000.D0)*ZR(JVAL2)
   30             CONTINUE
   40           CONTINUE
   50         CONTINUE
   60       CONTINUE
   70     CONTINUE


C         -- ON TRANSFORME CH2S  EN VRAI CHAM_NO :
C         ----------------------------------------
          CALL CNSCNO(CH2S,PRCHNO,'G',CH2)

          CALL RSNOCH(RESU,NOMSY2,IORDR,' ')
          CALL JELIBE(CH1//'.CELV')
          CALL JELIBE(CH1//'.CELD')
          CALL JELIBE(CH1//'.CELK')
          CALL DETRSD('CHAMP_GD','&&ECLPGR.CH1')
   80   CONTINUE
        CALL DETRSD('CHAM_NO_S',CH2S)
   90 CONTINUE


C       -- ON RECOPIE LE PARAMETRE "INST" :
C       -----------------------------------
      DO 100,I = 1,NBORDR
        IORDR = ZI(JORDR+I-1)
        CALL RSADPA(EVO1,'L',1,'INST',IORDR,0,IAINS1,KBID)
        CALL RSADPA(RESU,'E',1,'INST',IORDR,0,IAINS2,KBID)
        ZR(IAINS2) = ZR(IAINS1)
  100 CONTINUE

      CALL JEDETC('V','&&ECLPGR',1)

  110 CONTINUE
      CALL JEDEMA()
      END
