      SUBROUTINE TABCHS(TABIN,TYPCHS,BASE,NOMGD,MA,CHS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
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
C     IN/JXOUT : CHS: NOM DU CHAMP SIMPLE A CREER

C TOLE  CRP_20
      IMPLICIT   NONE

C     ------------------------------------------------------------------
C 0.1. ==> ARGUMENT
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM,JEXATR
      CHARACTER*1  BASE
      CHARACTER*8 NOMGD,MA
      CHARACTER*16 TYPCHS
      CHARACTER*19 CHS,TABIN

C
C 0.2. ==> COMMUNS
C
C
C      ==> VARIABLES LOCALES
      INTEGER JTBNP,JTBLP,NCMP,JCMP,JCNSL,JCNSV,I
      INTEGER VALI(2),NBLIG,ISP,JSP
      INTEGER NBVAL,IBID
      INTEGER NUNO,NUMA,NBMA,JCESD,NBSSP
      INTEGER JCESL,JCESV,JCESC,IAD
      INTEGER NBCOL,NBNO,KSP,KPT,JCON1,JCON2
      INTEGER JCOLMA,JCOLNO,JCOLPT,JCOLSP,INDIIS,IPT
      INTEGER ICMP,ILI,IRET,JIND,JOBJ2,JOBJ3,JPG
      CHARACTER*8 K8B,NONO,TSCA,NOMA
      CHARACTER*24 OBJLG,OBJR,OBJTMP
       CHARACTER*24 VALK(3)
      LOGICAL LMAIL,LNOEU,LPOIN,LSPOIN
C ---------------------------------------------------------------------


      CALL JEMARQ()

      CALL JEVEUO(TABIN//'.TBNP','L',JTBNP)
      NBCOL=ZI(JTBNP-1+1)
      NBLIG=ZI(JTBNP-1+2)
      CALL JEVEUO(TABIN//'.TBLP','L',JTBLP)

      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,K8B,IRET)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL ASSERT(TSCA.EQ.'R')
      CALL JEVEUO(MA//'.CONNEX','L',JCON1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCON2)


C     1. VERIFICATION DES PARAMETRES DE LA TABLE :
C     --------------------------------------------
      CALL TBEXIP(TABIN,'MAILLE',LMAIL,TSCA)
      CALL TBEXIP(TABIN,'NOEUD',LNOEU,TSCA)
      CALL TBEXIP(TABIN,'POINT',LPOIN,TSCA)
      CALL TBEXIP(TABIN,'SOUS_POINT',LSPOIN,TSCA)

      VALK(1)=TABIN(1:8)
      VALK(2)=TYPCHS

C     PRESENCE DU PARAMETRE MAILLE
      IF (TYPCHS.EQ.'EL' .AND. .NOT.LMAIL) CALL U2MESK('F',
     &    'MODELISA9_1',2,VALK)

C     PRESENCE/ABSENCE POUR CHAMPS NOEU :
      IF (TYPCHS.EQ.'NOEU') THEN
        IF (.NOT.LNOEU) CALL U2MESK('F','MODELISA9_1',2,VALK)
        IF (LMAIL .OR. LPOIN .OR. LSPOIN) CALL U2MESK('F','MODELISA9_1',
     &      2,VALK)
      ENDIF

C     PRESENCE/ABSENCE POUR CHAMPS ELGA :
      IF (TYPCHS.EQ.'ELGA') THEN
        IF (.NOT.LPOIN .OR. LNOEU) CALL U2MESK('F','MODELISA9_1',2,VALK)
      ENDIF

C     PRESENCE/ABSENCE POUR CHAMPS ELNO :
      IF (TYPCHS.EQ.'ELNO') THEN
        IF (.NOT.LPOIN .AND. .NOT.LNOEU) CALL U2MESK('F','MODELISA9_1',
     &      2,VALK)
        IF (LPOIN .AND. LNOEU) CALL U2MESK('F','MODELISA9_1',2,VALK)
      ENDIF

C     PRESENCE/ABSENCE POUR CHAMPS ELEM :
      IF (TYPCHS.EQ.'ELEM') THEN
        IF (LPOIN .OR. LNOEU) CALL U2MESK('F','MODELISA9_1',2,VALK)
         ENDIF


C     2. RECUPERATION DES COLONNES DE LA TABLE :
C     -------------------------------------------
C     -- 2.1 COLONNE 'NOEUD' :
      IF (LNOEU) THEN
C        ON VERIFIE QUE LES NOEUDS FOURNIS DANS LA TABLE
C        APPARTIENNENT AU MAILLAGE
        OBJTMP='&&TABCHS.NOEUD'
        CALL TBEXVE(TABIN,'NOEUD',OBJTMP,'V',NBVAL,TSCA)
        CALL JEVEUO(OBJTMP,'L',JCOLNO)
        CALL VERIMA(MA,ZK8(JCOLNO),NBVAL,'NOEUD')
      ENDIF

C     -- 2.2 COLONNE 'MAILLE' :
      IF (LMAIL) THEN
C        ON VERIFIE QUE LES MAILLES FOURNIES DANS LA TABLE
C        APPARTIENNENT AU MAILLAGE
        OBJTMP='&&TABCHS.MAILLE'
        CALL TBEXVE(TABIN,'MAILLE',OBJTMP,'V',NBVAL,TSCA)
        CALL JEVEUO(OBJTMP,'L',JCOLMA)
        CALL VERIMA(MA,ZK8(JCOLMA),NBVAL,'MAILLE')
      ENDIF

C     -- 2.3 COLONNE 'POINT' :
      IF (LPOIN) THEN
        OBJTMP='&&TABCHS.POINT'
        CALL TBEXVE(TABIN,'POINT',OBJTMP,'V',NBVAL,TSCA)
        CALL JEVEUO(OBJTMP,'L',JCOLPT)
      ENDIF

C     -- 2.4 COLONNE 'SOUS_POINT' :
      IF (LSPOIN) THEN
        OBJTMP='&&TABCHS.SPOINT'
        CALL TBEXVE(TABIN,'SOUS_POINT',OBJTMP,'V',NBVAL,TSCA)
        CALL JEVEUO(OBJTMP,'L',JCOLSP)
      ENDIF


C     -- ON REPERE LES COLONNES QUI CORRESPONDENT AUX CMPS.
C        CE SONT CELLES QUI NE SONT PAS : MAILLE, NOEUD, ...
      CALL WKVECT('&&TABCHS.NCMP1','V V K24',NBCOL,JCMP)
      CALL WKVECT('&&TABCHS.NCMP2','V V I',NBCOL,JIND)
      NCMP=0
      DO 10 I=1,NBCOL
        IF (ZK24(JTBLP+4*(I-1)).NE.'MAILLE' .AND.
     &      ZK24(JTBLP+4*(I-1)).NE.'NOEUD' .AND.
     &      ZK24(JTBLP+4*(I-1)).NE.'POINT' .AND.
     &      ZK24(JTBLP+4*(I-1)).NE.'SOUS_POINT') THEN
          NCMP=NCMP+1
          ZK24(JCMP+NCMP-1)=ZK24(JTBLP+4*(I-1))
          ZI(JIND+NCMP-1)=I
            ENDIF
 10      CONTINUE

C     ON VERIFIE QUE LE NOM ET LE TYPE DES COMPOSANTES
C        DE LA TABLE CORRESPONDENT A LA GRANDEUR LUE
         CALL VERIGD(NOMGD,ZK24(JCMP),NCMP,IRET)
      IF (IRET.NE.0) THEN
        CALL U2MESK('F','MODELISA9_2',NCMP,ZK24(JCMP))
      ENDIF



      IF (TYPCHS.EQ.'NOEU') THEN
C     ------------------------------------

C ---    CREATION DU CHAM_NO_S
         CALL CNSCRE(MA,NOMGD,NCMP,ZK24(JCMP),BASE,CHS)

C ---    REMPLISSAGE DU CHAM_S
         CALL JEVEUO(CHS//'.CNSV','E',JCNSV)
         CALL JEVEUO(CHS//'.CNSL','E',JCNSL)
C
         DO 30 ICMP=1,NCMP
            OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
            CALL JEVEUO(OBJLG,'L',JOBJ2)
            OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
            CALL JEVEUO(OBJR,'L',JOBJ3)
          DO 20 ILI=1,NBLIG
            IF (ZI(JOBJ2+ILI-1).EQ.1) THEN
              NONO=ZK8(JCOLNO+ILI-1)
                  CALL JENONU(JEXNOM(MA//'.NOMNOE',NONO),NUNO)
              CALL ASSERT(NUNO.GT.0)
                  ZR(JCNSV+(NUNO-1)*NCMP+ICMP-1)=ZR(JOBJ3+ILI-1)
                  ZL(JCNSL+(NUNO-1)*NCMP+ICMP-1)=.TRUE.
               ENDIF
   20     CONTINUE
 30      CONTINUE



      ELSEIF (TYPCHS(1:2).EQ.'EL') THEN
C     ------------------------------------

        IF (TYPCHS.EQ.'ELNO') THEN
C          POUR LES CHAMPS ELNO :
C           - SI LNOEU, ON CALCULE '&&TABCHS.POINT'
C           - ON VERIFIE QUE LE NUMERO DE POINT EST POSSIBLE
          IF (LNOEU) THEN
            CALL ASSERT(.NOT.LPOIN)
            CALL WKVECT('&&TABCHS.POINT','V V I',NBLIG,JCOLPT)
           ENDIF
          DO 40 ILI=1,NBLIG
            NOMA=ZK8(JCOLMA+ILI-1)
            CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
            NBNO=ZI(JCON2-1+NUMA+1)-ZI(JCON2-1+NUMA)
            IF (LPOIN) THEN
              IPT=ZI(JCOLPT-1+ILI)
            ELSE
              CALL ASSERT(LNOEU)
              NONO=ZK8(JCOLNO-1+ILI)
              CALL JENONU(JEXNOM(MA//'.NOMNOE',NONO),NUNO)
              IPT=INDIIS(ZI(JCON1-1+ZI(JCON2-1+NUMA)),NUNO,1,NBNO)
              ZI(JCOLPT-1+ILI)=IPT
            ENDIF
            IF (IPT.EQ.0 .OR. IPT.GT.NBNO) THEN
              VALK(1)=TABIN
              VALK(2)=NOMA
              VALK(3)=NONO
              VALI(1)=IPT
              VALI(2)=NBNO
              CALL U2MESG('F','MODELISA9_5',3,VALK,2,VALI,0,0.D0)
        ENDIF
   40     CONTINUE
        ENDIF


C       CALCUL DU NOMBRE DE SOUS_POINT PAR ELEMENT (&&TABCHS.SP_TOT):
C       CALCUL DE NBSSP : MAX DU NOMBRE DE SOUS_POINT
        IF (LSPOIN) THEN
          CALL WKVECT('&&TABCHS.SP_TOT','V V I',NBMA,JSP)
          NBSSP=1
          DO 50 ILI=1,NBLIG
            KSP=ZI(JCOLSP+ILI-1)
            CALL ASSERT(KSP.GT.0)
            NBSSP=MAX(NBSSP,KSP)
            NOMA=ZK8(JCOLMA+ILI-1)
             CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
             CALL ASSERT(NUMA.GT.0)
            ZI(JSP-1+NUMA)=MAX(ZI(JSP-1+NUMA),KSP)
   50     CONTINUE
        ELSE
          NBSSP=1
        ENDIF


C       CALCUL DU NOMBRE DE POINTS DE GAUSS PAR ELEMENT
C       (&&TABCHS.PG_TOT):
        IF (TYPCHS.EQ.'ELGA') THEN
          CALL WKVECT('&&TABCHS.PG_TOT','V V I',NBMA,JPG)
          DO 60 ILI=1,NBLIG
            KPT=ZI(JCOLPT+ILI-1)
            CALL ASSERT(KPT.GT.0)
            NOMA=ZK8(JCOLMA+ILI-1)
            CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)
            ZI(JPG-1+NUMA)=MAX(ZI(JPG-1+NUMA),KPT)
 60        CONTINUE
        ENDIF


C       CREATION DU CHAM_ELEM_S VIERGE :
        IF (NBSSP.EQ.1) THEN
          IF (TYPCHS.EQ.'ELNO' .OR. TYPCHS.EQ.'ELEM') THEN
            CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,ZK24(JCMP),-1,-1,
     &                  -NCMP)
          ELSEIF (TYPCHS.EQ.'ELGA') THEN
            CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,ZK24(JCMP),
     &                  ZI(JPG),-1,-NCMP)
          ENDIF
        ELSE
          IF (TYPCHS.EQ.'ELNO' .OR. TYPCHS.EQ.'ELEM') THEN
            CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,ZK24(JCMP),-1,
     &                  ZI(JSP),-NCMP)
          ELSEIF (TYPCHS.EQ.'ELGA') THEN
            CALL CESCRE(BASE,CHS,TYPCHS,MA,NOMGD,NCMP,ZK24(JCMP),
     &                  ZI(JPG),ZI(JSP),-NCMP)
          ENDIF
        ENDIF


C ---   REMPLISSAGE DU CHAM_S
        CALL JEVEUO(CHS//'.CESD','L',JCESD)
        CALL JEVEUO(CHS//'.CESV','E',JCESV)
        CALL JEVEUO(CHS//'.CESL','E',JCESL)
        CALL JEVEUO(CHS//'.CESC','L',JCESC)


        DO 80 ICMP=1,NCMP
          OBJLG=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+3)
          CALL JEVEUO(OBJLG,'L',JOBJ2)
          OBJR=ZK24(JTBLP+4*(ZI(JIND+ICMP-1)-1)+2)
          CALL JEVEUO(OBJR,'L',JOBJ3)

          DO 70 ILI=1,NBLIG
            IF (ZI(JOBJ2+ILI-1).EQ.0)GOTO 70

            NOMA=ZK8(JCOLMA+ILI-1)
            CALL JENONU(JEXNOM(MA//'.NOMMAI',NOMA),NUMA)

            IPT=1
            IF (LPOIN)IPT=ZI(JCOLPT+ILI-1)

            ISP=1
            IF (LSPOIN)ISP=ZI(JCOLSP+ILI-1)

            NONO=' '
            IF (LNOEU) THEN
              NONO=ZK8(JCOLNO+ILI-1)
              IPT=ZI(JCOLPT+ILI-1)
                ENDIF

            CALL CESEXI('S',JCESD,JCESL,NUMA,IPT,ISP,ICMP,IAD)
            CALL ASSERT(IAD.NE.0)
            IF (IAD.LT.0) THEN
                   IAD=-IAD
            ELSE
              VALK(1)=TABIN(1:8)
              VALK(2)=NOMA
              VALK(3)=NONO
              VALI(1)=IPT
              VALI(2)=ISP
              CALL U2MESG('F','MODELISA9_6',3,VALK,2,VALI,0,0.D0)
                ENDIF
                ZR(JCESV+IAD-1)=ZR(JOBJ3+ILI-1)
                ZL(JCESL+IAD-1)=.TRUE.
   70     CONTINUE
   80   CONTINUE
      ENDIF

      CALL JEDETR('&&TABCHS.MAILLE')
      CALL JEDETR('&&TABCHS.NOEUD')
      CALL JEDETR('&&TABCHS.POINT')
      CALL JEDETR('&&TABCHS.SPOINT')
      CALL JEDETR('&&TABCHS.NCMP1')
      CALL JEDETR('&&TABCHS.NCMP2')
      CALL JEDETR('&&TABCHS.PG_TOT')
      CALL JEDETR('&&TABCHS.SP_TOT')

      CALL JEDEMA()
      END
