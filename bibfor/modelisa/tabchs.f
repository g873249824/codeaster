      SUBROUTINE TABCHS(TABIN,TYPCHS,BASE,NOMGD,MA,MO,OPTION,CHS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 19/01/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     TRAITEMENT DE COMMANDE:   CREA_CHAMP / OPTION: 'EXTR' / TABLE
C
C     CREATION D'UN CHAMP SIMPLE A PARTIR D'UNE TABLE
C
C
C     IN : TABIN  : NOM DE LA TABLE
C     IN : TYPCHS : TYPE DU CHAMP SIMPLE (NOEU/ELEM/ELNO/ELGA)
C     IN : BASE   : BASE DE CREATION (G/V)
C     IN : NOMGD  : NOM DE LA GRANDEUR
C     IN : MA     : NOM DU MAILLAGE
C     IN : MO     : NOM DU MODELE   (UTILISE SI TYPCHS == 'EL..')
C     IN : OPTION : OPTION DE CALCUL(UTILISE SI TYPCHS == 'EL..')
C     IN/OUT : CHS: NOM DU CHAMP SIMPLE A CREER

      IMPLICIT   NONE

C     ------------------------------------------------------------------
C 0.1. ==> ARGUMENT
C
C
      CHARACTER*1  BASE
      CHARACTER*4  TYCHS
      CHARACTER*8  NOMGD,MA,MO
      CHARACTER*16 OPTION,TYPCHS
      CHARACTER*19 CHS,TABIN

C
C 0.2. ==> COMMUNS
C
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CHARACTER*32      JEXNOM, JEXNUM,JEXATR
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C      ==> VARIABLES LOCALES
       INTEGER JTBNP,JTBLP,NCMP,JCMP,JCNSL,JCNSV,I,NCMPMX
       INTEGER VALI(2),NBLIG,ISP,JSP,NBSP1
       INTEGER K,IRET,JIND,J,JOBJ1,JOBJ2,JOBJ3,ILI,INOEU,NUNO,ICMP
       INTEGER JTMP,NBVAL,IBID,NBCOMP,IMAI,IPOI,ISPT,JPG,JREPE,IGREL
       INTEGER JMA,JPT,JTYPMA,NUMA,NBPT,JOBJ4,JSSPT,NBMA,JCESD,NBSSP
       INTEGER JCESL,JCESV,JCESC,JOBJP,IAD,JOBJS,IOPT,NBGREL,IMA
       INTEGER NBMAGL,NUMTE,NUMGD,IPARA,IMOLOC,JMOL,NBIN,NBOUT
       INTEGER NBELEM,NBGR,IAOPTE,IANBLC,LGCO,IPOUT,IAOPMO,IOPTTE
       CHARACTER*1 BASV,KBID
       PARAMETER(BASV='V')
       CHARACTER*8 K8B,NONO,TYPE,KTYP,NOMA,NOMPAR
       CHARACTER*16 TYCH,NOMTE
       CHARACTER*19 LIGREL
       CHARACTER*24 OBJNO,OBJLG,OBJR,OBJTMP,PARA,OBJMA,OBJPT,OBJ4
       CHARACTER*24 VALK(3)
       CHARACTER*24 OBJMAI,OBJPOI,OBJSSP,MODLOC
       LOGICAL EXIST


      CALL JEMARQ()

      CALL JEVEUO(TABIN//'.TBNP','L',JTBNP)
      NBLIG=ZI(JTBNP-1+2)
      CALL JEVEUO(TABIN//'.TBLP','L',JTBLP)


C     ------------------------
C ---  CHAMP AUX NOEUDS (NOEU)
C     ------------------------
C
      IF (TYPCHS.EQ. 'NOEU')THEN

C ---    VERIFICATIONS:
C        (V1) PRESENCE DU PARAMETRE NOEUD DANS LA TABLE
         PARA='NOEUD'
         TYPE='K8'
         CALL TBEXIP(TABIN,PARA,EXIST,TYPE)
         IF(.NOT.EXIST)THEN
                   VALK (1) = PARA
                   VALK (2) = TABIN(1:8)
                   VALK (3) = ' '
            CALL U2MESG('F', 'MODELISA8_98',3,VALK,0,0,0,0.D0)
         ENDIF

C        (V2) ON VERIFIE QUE LES NOEUDS FOURNIS DANS LA TABLE
C        APPARTIENNENT AU MAILLAGE
         OBJTMP='&&WORK0'
         CALL TBEXVE(TABIN,PARA,OBJTMP,BASV,NBVAL,TYPE)
         CALL JEVEUO(OBJTMP,'L',JTMP)
         CALL VERIMA(MA,ZK8(JTMP),NBVAL,PARA)


C        (V3) ABSENCE DU PARAMETRE MAILLE DANS LA TABLE
         PARA='MAILLE'
         TYPE='K8'
         CALL TBEXIP(TABIN,PARA,EXIST,TYPE)
         IF(EXIST)THEN
                   VALK (1) = PARA
                   VALK (2) = TABIN(1:8)
                   VALK (3) = ' '
            CALL U2MESG('F', 'MODELISA8_99',3,VALK,0,0,0,0.D0)
         ENDIF

         K=1
         NCMP=ZI(JTBNP)-1
         CALL WKVECT('&&WORK1','V V K24',NCMP,JCMP)
         CALL WKVECT('&&WORK2','V V I',NCMP,JIND)
         DO 10 I=1,NCMP+1
            IF(ZK24(JTBLP+4*(I-1))(1:5).NE.'NOEUD')THEN
               ZK24(JCMP+K-1)=ZK24(JTBLP+4*(I-1))
               ZI(JIND+K-1)=I
               K=K+1
            ELSE
               INOEU=I
            ENDIF
 10      CONTINUE

C        (V4) ON VERIFIE QUE LE NOM ET LE TYPE DES COMPOSANTES
C        DE LA TABLE CORRESPONDENT A LA GRANDEUR LUE
         CALL VERIGD(NOMGD,ZK24(JCMP),NCMP,IRET)
         CALL ASSERT(IRET.EQ.0)

C ---    CREATION DU CHAM_S
         CALL CNSCRE(MA,NOMGD,NCMP,ZK24(JCMP),BASE,CHS)

C ---    REMPLISSAGE DU CHAM_S
         CALL JEVEUO(CHS//'.CNSV','E',JCNSV)
         CALL JEVEUO(CHS//'.CNSL','E',JCNSL)
C
         OBJNO=ZK24(JTBLP+4*(INOEU-1)+2)
         CALL JEVEUO(OBJNO,'L',JOBJ1)
         DO 30 ICMP=1,NCMP
            OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
            CALL JEVEUO(OBJLG,'L',JOBJ2)
            OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
            CALL JEVEUO(OBJR,'L',JOBJ3)
            DO 40 ILI=1,NBLIG
               IF(ZI(JOBJ2+ILI-1).EQ.1)THEN
                  NONO=ZK8(JOBJ1+ILI-1)
                  CALL JENONU(JEXNOM(MA//'.NOMNOE',NONO),NUNO)
                  ZR(JCNSV+(NUNO-1)*NCMP+ICMP-1)=ZR(JOBJ3+ILI-1)
                  ZL(JCNSL+(NUNO-1)*NCMP+ICMP-1)=.TRUE.
               ENDIF
 40         CONTINUE
 30      CONTINUE



      ELSEIF (TYPCHS(1:2).EQ. 'EL')THEN
C
C     ------------------------------------
C ---  CHAMP PAR ELEMENTS (ELNO,ELGA,ELEM)
C     ------------------------------------

C ---  VERIFICATIONS:

C        (V1) PRESENCE DU PARAMETRE MAILLE DANS LA TABLE
         PARA='MAILLE'
         TYPE='K8'
         CALL TBEXIP(TABIN,PARA,EXIST,TYPE)
         IF(.NOT.EXIST)THEN
                   VALK (1) = PARA
                   VALK (2) = TABIN(1:8)
                   VALK (3) = ' '
            CALL U2MESG('F', 'MODELISA9_1',3,VALK,0,0,0,0.D0)
         ENDIF

C        (V2) PRESENCE DU PARAMETRE POINT DANS LA TABLE (ELNO/ELGA)
C             ABSENCE DU PARAMETRE POINT DANS LA TABLE (ELEM)
         PARA='POINT'
         TYPE='I'
         CALL TBEXIP(TABIN,PARA,EXIST,TYPE)
         IF(EXIST)THEN
            IF(TYPCHS.EQ.'ELEM')THEN
                   VALK (1) = PARA
                   VALK (2) = TABIN(1:8)
                   VALK (3) = ' '
               CALL U2MESG('F', 'MODELISA9_2',3,VALK,0,0,0,0.D0)
            ENDIF
         ELSE
           IF(TYPCHS.EQ.'ELNO' .OR. TYPCHS.EQ.'ELGA')THEN
                   VALK (1) = PARA
                   VALK (2) = TABIN(1:8)
                   VALK (3) = TYPCHS
              CALL U2MESG('F', 'MODELISA9_3',3,VALK,0,0,0,0.D0)
           ENDIF
        ENDIF

C        (V4) ON VERIFIE QUE LES MAILLES FOURNIES DANS LA TABLE
C        APPARTIENNENT AU MAILLAGE
         OBJMA='&&WORK0'
         PARA='MAILLE'
         CALL TBEXVE(TABIN,PARA,OBJMA,BASV,NBVAL,TYPE)
         CALL JEVEUO(OBJMA,'L',JMA)
         CALL VERIMA(MA,ZK8(JMA),NBVAL,PARA)

C        (V5) POUR LES CHAMPS ELNO ON VERIFIE SI LE NUMERO DE NOEUD
C             EST POSSIBLE :
         IF(TYPCHS.EQ.'ELNO')THEN
            CALL JEVEUO(MA//'.TYPMAIL','L',JTYPMA)
            OBJPT='&&WORK3'
            PARA='POINT'
            CALL TBEXVE(TABIN,PARA,OBJPT,BASV,NBVAL,TYPE)
            CALL JEVEUO(OBJPT,'L',JPT)
            DO 45 I=1,NBVAL
               CALL JENONU(JEXNOM(MA//'.NOMMAI',ZK8(JMA+I-1)),NUMA)
               CALL JENUNO( JEXNUM( '&CATA.TM.NOMTM',
     &              ZI(JTYPMA+NUMA-1)),KTYP)
               CALL DISMOI('F','NBNO_TYPMAIL',KTYP,'TYPE_MAILLE',
     &              NBPT,K8B,IRET)
               IF(ZI(JPT+I-1).GT.NBPT)THEN
                   VALK (1) = TABIN
                   VALK (2) = ZK8(JMA)
                   VALI (1) = ZI(JPT+I-1)
                   VALI (2) = NBPT
                  CALL U2MESG('F', 'MODELISA9_5',2,VALK,2,VALI,0,0.D0)
               ENDIF
 45         CONTINUE
         ENDIF

C        -- ON CALCULE LA LISTE DES NOMS DES CMPS (&&WORK1)
C        -- ON CALCULE IMAI,IPOI,ISPT
         IMAI=0
         IPOI=0
         ISPT=0
         K=1
         NCMP=ZI(JTBNP)
         CALL WKVECT('&&WORK1','V V K24',NCMP,JCMP)
         CALL WKVECT('&&WORK2','V V I',NCMP,JIND)
         DO 50 I=1,NCMP
            IF( ZK24(JTBLP+4*(I-1))(1:6).NE.'MAILLE'
     &      .AND.ZK24(JTBLP+4*(I-1))(1:5).NE.'POINT'
     &      .AND.ZK24(JTBLP+4*(I-1))(1:10).NE.'SOUS_POINT')THEN
               ZK24(JCMP+K-1)=ZK24(JTBLP+4*(I-1))
               ZI(JIND+K-1)=I
               K=K+1
            ELSE
              IF( ZK24(JTBLP+4*(I-1))(1:6).EQ.'MAILLE')IMAI=I
              IF( ZK24(JTBLP+4*(I-1))(1:5).EQ.'POINT')IPOI=I
              IF( ZK24(JTBLP+4*(I-1))(1:10).EQ.'SOUS_POINT')ISPT=I
            ENDIF
 50      CONTINUE
         NCMP=K-1

C        (V6) ON VERIFIE QUE LE NOM ET LE TYPE DES COMPOSANTES
C        DE LA TABLE CORRESPONDENT A LA GRANDEUR LUE
         CALL VERIGD(NOMGD,ZK24(JCMP),NCMP,IRET)
         CALL ASSERT(IRET.EQ.0)

C ---   CREATION DU CHAM_ELEM_S

        CALL ASSERT(IMAI.GT.0)
        OBJMAI=ZK24(JTBLP+4*(IMAI-1)+2)
        CALL JEVEUO(OBJMAI,'L',JOBJ1)
        IF(IPOI.GT.0)THEN
           OBJPOI=ZK24(JTBLP+4*(IPOI-1)+2)
           CALL JEVEUO(OBJPOI,'L',JOBJP)
        ENDIF
        IF(ISPT.GT.0)THEN
           OBJSSP=ZK24(JTBLP+4*(ISPT-1)+2)
           CALL JEVEUO(OBJSSP,'L',JOBJS)
        ENDIF


C       CALCUL DU NOMBRE DE SOUS_POINT PAR ELEMENT (&&SP_TOT):
        CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,K8B,IRET)
        IF (ISPT.GT.0) THEN
          CALL WKVECT('&&SP_TOT','V V I',NBMA,JSP)
          NBSSP=1
          DO 55 ILI=1,NBLIG
             NBSP1=ZI(JOBJS+ILI-1)
             CALL ASSERT(NBSP1.GT.0)
             NBSSP=MAX(NBSSP,NBSP1)
             NOMA=ZK8(JOBJ1+ILI-1)
             CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
             CALL ASSERT(NUMA.GT.0)
             ZI(JSP-1+NUMA)=MAX(ZI(JSP-1+NUMA),NBSP1)
 55       CONTINUE
        ELSE
          NBSSP=1
          ISP=1
        ENDIF


C       CALCUL DU NOMBRE DE POINTS DE GAUSS PAR ELEMENT (&&PG_TOT):
        IF(TYPCHS.EQ.'ELGA')THEN
           CALL WKVECT('&&PG_TOT','V V I',NBMA,JPG)
           CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),NUMGD)
           CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',OPTION),IOPT)
           CALL JEVEUO(JEXNUM('&CATA.OP.DESCOPT',IOPT),'L',IPARA)
           NBIN=ZI(IPARA+1)
           NBOUT=ZI(IPARA+2)
           DO 60 I=1,NBOUT
              IF(NUMGD.EQ.ZI(IPARA+NBIN+4+I-1))THEN
                 IPOUT=I
              ENDIF
 60        CONTINUE

           CALL JEVEUO('&CATA.TE.OPTTE','L',IAOPTE)
           CALL JEVEUO('&CATA.TE.NBLIGCOL','L',IANBLC)
           LGCO = ZI(IANBLC)
           CALL DISMOI('F','NOM_LIGREL',MO,'MODELE',IBID,LIGREL,IBID)
           CALL JEVEUO(LIGREL//'.REPE','L',JREPE)
           DO 65 IMA=1,NBMA
              ZI(JPG-1+IMA)=0
 65        CONTINUE

           NBGR=NBGREL(LIGREL)
           DO 70 I=1,NBGR
              CALL JEVEUO(JEXNUM(LIGREL//'.LIEL',I),'L',IGREL)
              CALL JELIRA(JEXNUM(LIGREL//'.LIEL',I),'LONMAX',NBMAGL,
     &             KBID)
              NUMTE=ZI(IGREL+NBMAGL-1)
              CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUMTE),NOMTE)
              IOPTTE = ZI(IAOPTE-1+ (NUMTE-1)*LGCO+IOPT)
              IF(IOPTTE.EQ.0)GOTO 70
              CALL JEVEUO(JEXNUM('&CATA.TE.OPTMOD',IOPTTE),'L',IAOPMO)
              IMOLOC = ZI(IAOPMO+3+ZI(IAOPMO+1)+IPOUT-1)
              CALL JENUNO(JEXNUM('&CATA.TE.NOMMOLOC',IMOLOC),MODLOC)
              CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',IMOLOC),'L',JMOL)
              NBPT=MOD(ZI(JMOL-1+4),10000)
              DO 80 J=1,NBMAGL-1
                 IMA = ZI(IGREL+J-1)
                 ZI(JPG-1+IMA)=NBPT
 80           CONTINUE
 70        CONTINUE
        ENDIF


C       CREATION DU CHAM_ELEM_S VIERGE :
        IF (NBSSP.EQ.1) THEN
          IF(TYPCHS.EQ.'ELNO'.OR.TYPCHS.EQ.'ELEM')THEN
             CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,
     &            ZK24(JCMP),-1,-1,-NCMP)
          ELSEIF(TYPCHS.EQ.'ELGA')THEN
             CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,
     &            ZK24(JCMP),ZI(JPG),-1,-NCMP)
          ENDIF
        ELSE
          IF(TYPCHS.EQ.'ELNO'.OR.TYPCHS.EQ.'ELEM')THEN
             CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,
     &            ZK24(JCMP),-1,ZI(JSP),-NCMP)
          ELSEIF(TYPCHS.EQ.'ELGA')THEN
             CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,
     &            ZK24(JCMP),ZI(JPG),ZI(JSP),-NCMP)
          ENDIF
        ENDIF




C ---   REMPLISSAGE DU CHAM_S
        CALL JEVEUO(CHS//'.CESD','L',JCESD)
        CALL JEVEUO(CHS//'.CESV','E',JCESV)
        CALL JEVEUO(CHS//'.CESL','E',JCESL)
        CALL JEVEUO(CHS//'.CESC','L',JCESC)


        IF(TYPCHS.EQ.'ELNO')THEN
        DO 90 ICMP=1,NCMP
          OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
          CALL JEVEUO(OBJLG,'L',JOBJ2)
          OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
          CALL JEVEUO(OBJR,'L',JOBJ3)

         DO 95 ILI=1,NBLIG
             IF(ZI(JOBJ2+ILI-1).EQ.1)THEN
                IF (ISPT.GT.0) ISP=ZI(JOBJS+ILI-1)
                NOMA=ZK8(JOBJ1+ILI-1)
                CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
                CALL CESEXI('S',JCESD,JCESL,NUMA,ZI(JOBJP+ILI-1),ISP,
     &               ICMP,IAD)
                IF(IAD.GT.0)THEN
                   VALK (1) = TABIN(1:8)
                   VALK (2) = NOMA
                   VALI (1) = ZI(JOBJP+ILI-1)
                   VALI (2) = ISP
                   CALL U2MESG('F', 'MODELISA9_6',2,VALK,2,VALI,0,0.D0)
                ELSE
                   IAD=-IAD
                ENDIF
                ZR(JCESV+IAD-1)=ZR(JOBJ3+ILI-1)
                ZL(JCESL+IAD-1)=.TRUE.
             ENDIF
 95       CONTINUE
 90    CONTINUE


      ELSEIF(TYPCHS.EQ.'ELGA')THEN
        CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NCMPMX,KBID,IBID)

        DO 100 ICMP=1,NCMP
          OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
          CALL JEVEUO(OBJLG,'L',JOBJ2)
          OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
          CALL JEVEUO(OBJR,'L',JOBJ3)

          DO 105 ILI=1,NBLIG
             IF(ZI(JOBJ2+ILI-1).EQ.1)THEN
                IF (ISPT.GT.0) ISP=ZI(JOBJS+ILI-1)
                NOMA=ZK8(JOBJ1+ILI-1)
                CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
                CALL CESEXI('C',JCESD,JCESL,NUMA,ZI(JOBJP+ILI-1),
     &              ISP,ICMP,IAD)
                IF(IAD.GE.0)THEN
                  VALK (1) = TABIN(1:8)
                  VALK (2) = NOMA
                  VALI (1) = ZI(JOBJP+ILI-1)
                  VALI (2) = ISP
                  IF(IAD.GT.0)THEN
                    CALL U2MESG('F','MODELISA9_6',2,VALK,2,VALI,0,0.D0)
                  ELSE
                    CALL U2MESG('F','MODELISA9_33',2,VALK,2,VALI,0,0.D0)
                  ENDIF
                ELSE
                  IAD=-IAD
                ENDIF
                ZR(JCESV+IAD-1)=ZR(JOBJ3+ILI-1)
                ZL(JCESL+IAD-1)=.TRUE.
             ENDIF
 105       CONTINUE
 100    CONTINUE


      ELSEIF(TYPCHS.EQ.'ELEM')THEN
         DO 110 ICMP=1,NCMP
          OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
          CALL JEVEUO(OBJLG,'L',JOBJ2)
          OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
          CALL JEVEUO(OBJR,'L',JOBJ3)

          DO 115 ILI=1,NBLIG
             IF(ZI(JOBJ2+ILI-1).EQ.1)THEN
                IF (ISPT.GT.0) ISP=ZI(JOBJS+ILI-1)
                NOMA=ZK8(JOBJ1+ILI-1)
                CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
                CALL CESEXI('S',JCESD,JCESL,NUMA,1,ISP,
     &               ICMP,IAD)
                IF(IAD.GT.0)THEN
                   VALK (1) = TABIN(1:8)
                   VALK (2) = NOMA
                   VALI (1) = ISP
                   CALL U2MESG('F', 'MODELISA9_7',2,VALK,1,VALI,0,0.D0)
                ELSE
                   IAD=-IAD
                ENDIF
                ZR(JCESV+IAD-1)=ZR(JOBJ3+ILI-1)
                ZL(JCESL+IAD-1)=.TRUE.
             ENDIF
 115      CONTINUE
 110   CONTINUE

      ENDIF

      ENDIF

      CALL JEDETR('&&WORK0')
      CALL JEDETR('&&WORK1')
      CALL JEDETR('&&WORK2')
      CALL JEDETR('&&WORK3')
      CALL JEDETR('&&PG_TOT')

      CALL JEDEMA()
      END
