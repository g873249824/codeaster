      SUBROUTINE OP0197 ( IER )
      IMPLICIT NONE
      INTEGER             IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 14/11/2006   AUTEUR SALMONA L.SALMONA 
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
C TOLE CRP_20
C     RECA_WEIBULL        ---------
C                         COMMANDE OPTIMISATION WEIBULL : RECALAGE DES
C                         PARAMETRES DE LA METHODE.
C     RECA_WEIBULL        ---------
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32      JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      INTEGER      NBPARR, NBPARK, NBPARS, NBPART, INFO, KK
      PARAMETER    ( NBPARR = 4, NBPARK = 3, NBPARS=3, NBPART=3 )
      CHARACTER*6  CHTEMP
      CHARACTER*8  TAPAIT, K8BID, CARA, TYPARR(NBPARR), TYPARS(NBPARS),
     &             TYPART(NBPART), TABTRI, TYPARK(NBPARK), TABOUT,RESU,
     &             CHCOP1,CHCOP2
      CHARACTER*8  NOPASE
      CHARACTER*16 OPTCAL(2), METHOD, NOMCMD, NOMRC, CONCEP, PARCAL(2),
     &             NOPARR(NBPARR), NOPARK(NBPARK), NOPARS(NBPARS),
     &             NOPART(NBPART), K16BID
      CHARACTER*19 NOMRES
      CHARACTER*24 COLLEC, MATE ,NOOBJ
      INTEGER      NBRESU, IFM, N1, NIV, ITEMP, ICHMAT, IRESU, IMOD,
     &             NBINS, IINST, ITABW, NBITE, NITMAX, ISIG, I, IBID,
     &             NBMTCM, NBMTRC, NBCAL, NBVAL, ITPS, IT,
     &             ISEG, NCHAR, JCHA, ITABR, VALI(NBPARR), INUR, IX, IY,
     &             NRUPT, IWEIK, IWEIR, IPRO, IRENT, ISIGK, ISIGKP,
     &             ISIGI, NTEMP, ITPSI, ITPRE, NTPSI, IPTH,INOPA,ITYPA,
     &             IVAPA, IKVAL, IKVAK, IMC, IAINST, PREOR, DEROR,
     &             NBOLD, ICHCO, ANOMM1, ANOMM2
      REAL*8       MINI, MINIP, VINI, EPSI, MK, MKP, SIGINT, R8BID,
     &             VALR(NBPARR), TEST, PROINT, MAXCS, TPSMIN, TPSMAX
      COMPLEX*16   C16B
      LOGICAL      CALM, CALS, IMPR, DEPT, RECM, RECS
C
      DATA NOPARR / 'NURES', 'INST','SIGMA_WEIBULL','PROBA_WEIBULL'/
      DATA TYPARR / 'I','R','R','R' /
      DATA NOPARK / 'ITER_K', 'M(K)','SIGU(K)' /
      DATA TYPARK / 'I','R','R' /
      DATA NOPARS / 'SIGMA_WEIBULL', 'PROBA_THE', 'PROBA_EXP'/
      DATA TYPARS / 'R','R','R'/
      DATA NOPART / 'TEMP','M', 'SIGMA_U'/
      DATA TYPART / 'R','R','R' /
      DATA CHCOP1 / '&&OPTIW1' /
      DATA CHCOP2/ '&&OPTIW2' /
C     ------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
      IER = 0
C     ------------------------------------------------------------------
      CALL GETRES (NOMRES,CONCEP,NOMCMD)
C
C --- RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV(IFM,NIV)
C
C     LECTURE DES MOTS-CLES DE RECA_WEIBULL
C
      IMPR = .FALSE.
      CALL GETVIS ( ' ','INFO' ,1,1,1,INFO  , N1)
      IF (INFO.EQ.2) IMPR = .TRUE.
      CALL GETVTX ( ' ','OPTION',1,1,1,OPTCAL(1),N1)
      CALL GETVTX ( ' ','CORR_PLAST',1,1,1,OPTCAL(2),N1)
      CALL GETVTX ( ' ','METHODE',0,1,1,METHOD,N1)
      CALL GETVIS ( ' ','ITER_GLOB_MAXI',0,1,1,NITMAX,N1)
      CALL GETVR8 ( ' ','INCO_GLOB_RELA',0,1,1,EPSI,N1)
      CALL GETVTX (' ','LIST_PARA',0,1,0,K8BID,N1)
      NBCAL = -N1
      CALL GETVTX(' ','LIST_PARA',0,1,NBCAL,PARCAL,N1)
C
C     CALM,CALS : SIGNIFIE QUE M OU/ET SIGMA ONT CONVERGES
C     RECM,RECS : SIGNIFIE QUE M OU/ET SIGMA SONT A RECALER
C
      CALM = .TRUE.
      CALS = .TRUE.
      RECM = .FALSE.
      RECS = .FALSE.
      DO 10 I=1,NBCAL
        IF (PARCAL(I)(1:1).EQ.'M') THEN
          CALM = .FALSE.
          RECM = .TRUE.
        END IF
        IF (PARCAL(I)(1:9).EQ.'SIGM_REFE') THEN
          CALS = .FALSE.
          RECS = .TRUE.
        END IF
 10   CONTINUE
C
C     --- LECTURE DES BASES DE RESULTATS (MOT-CLE RESU) ---
C
      CALL GETFAC('RESU',NBRESU)
C
      CALL WKVECT('&&OP0197.KVALRC'   ,'V V K24',NBRESU,IKVAL)
      CALL WKVECT('&&OP0197.KVALRCK'   ,'V V K24',NBRESU,IKVAK)
      CALL WKVECT('&&OP0197.MODELE'   ,'V V K8',NBRESU,IMOD)
      CALL WKVECT('&&OP0197.TEMPE_RESU','V V R',NBRESU,ITEMP)
      CALL WKVECT('&&OP0197.TEMPE_SIGU','V V R',NBRESU,ITPSI)
      CALL WKVECT('&&OP0197.INDTP_NURE','V V I',NBRESU,ITPRE)
      CALL WKVECT('&&OP0197.NBINS_RESU','V V I',NBRESU,IRENT)
      CALL WKVECT('&&OP0197.NOM_CHMAT','V V K8',NBRESU,ICHMAT)
      CALL WKVECT('&&OP0197.SIGMA_I','V V R',NBRESU,ISIGI)
      CALL WKVECT('&&OP0197.SIGMA_K','V V R',NBRESU,ISIGK)
      CALL WKVECT('&&OP0197.SIGMA_KP','V V R',NBRESU,ISIGKP)
      COLLEC = '&&OP0197.INST_RUPT'
      CALL JECREC(COLLEC,'V V R','NU','DISPERSE','VARIABLE',NBRESU)
      TABOUT = 'TABLE1'
      TABTRI = 'TABLE2'
C
      NRUPT = 0
      NTEMP = 0
      NTPSI = 0
      DO 100 IRESU = 1 , NBRESU
C
        CALL GETVID('RESU','MODELE',IRESU,1,1,ZK8(IMOD-1+IRESU),N1)
        CALL GETVID('RESU','CHAM_MATER',IRESU,1,1,ZK8(ICHMAT-1+IRESU),
     &               N1)
        CALL GETVR8('RESU','TEMPE',IRESU,1,0,R8BID,N1)
        IF (N1.NE.0) THEN
          NTEMP = NTEMP+1
          CALL GETVR8('RESU','TEMPE',IRESU,1,1,ZR(ITEMP-1+IRESU),
     &                N1)
          NTPSI = NTPSI+1
          ZR(ITPSI-1+NTPSI) = ZR(ITEMP-1+IRESU)
          ZI(ITPRE-1+IRESU) = NTPSI
          DO 120 I=1,NTPSI-1
            IF ( ZR(ITEMP-1+IRESU) .EQ. ZR(ITPSI-1+I) ) THEN
               NTPSI = NTPSI-1
               ZI(ITPRE-1+IRESU) = I
            END IF
120       CONTINUE
        ELSE
          ZI(ITPRE-1+IRESU) = 1
        END IF
C
C      --- LECTURE DE LA LISTE D'INSTANTS DE RUPTURE (TRI CROISSANT)
C
        CALL GETVR8('RESU','LIST_INST_RUPT',IRESU,1,0,R8BID,N1)
        NBINS = -N1
        CALL JECROC(JEXNUM(COLLEC,IRESU))
        CALL JEECRA(JEXNUM(COLLEC,IRESU),'LONMAX',NBINS,' ')
        CALL JEVEUO(JEXNUM(COLLEC,IRESU),'E',IINST)
        CALL GETVR8('RESU','LIST_INST_RUPT',IRESU,1,NBINS,ZR(IINST),N1)
        NBOLD = NBINS
        CALL UTTRIR(NBINS,ZR(IINST),0.D0)
        IF (NBINS.NE.NBOLD) THEN
           CALL U2MESS('F','UTILITAI3_28')
        END IF
        ZI(IRENT+IRESU-1) = NBINS
        NRUPT = NRUPT + NBINS
        CALL JEECRA(JEXNUM(COLLEC,IRESU),'LONUTI',NBINS,' ')
        IF (NBINS.LE.1) THEN
           CALL U2MESS('F','UTILITAI3_29')
        END IF
C
C       ON TESTE SI LES INSTANTS DE RUPTURE MIN ET MAX SONT
C       DANS LES INSTANTS DE CALCUL
C
        CALL GETVID ('RESU','EVOL_NOLI',IRESU,1,1,RESU,N1)
        CALL RSORAC (RESU,'PREMIER',IBID,R8BID,K8BID,C16B,0.D0,
     &               'ABSOLU',PREOR,1,IBID)
        CALL RSORAC (RESU,'DERNIER',IBID,R8BID,K8BID,C16B,0.D0,
     &               'ABSOLU',DEROR,1,IBID)
        CALL RSADPA ( RESU,'L',1,'INST',PREOR,0,IAINST,K8BID)
        TPSMIN = ZR(IAINST)
        CALL RSADPA ( RESU,'L',1,'INST',DEROR,0,IAINST,K8BID)
        TPSMAX = ZR(IAINST)
        IF (ZR(IINST).LT.TPSMIN) THEN
           CALL UTDEBM('S','OP0197','LE PREMIER INSTANT DE RUPTURE '
     &          //'N''EST PAS DANS LA LISTE DES INSTANTS DE CALCUL')
           CALL UTIMPR('L','PREMIER INSTANT DE RUPTURE = ',1,ZR(IINST))
           CALL UTIMPR('L','PREMIER INSTANT DE CALCUL = ',1,TPSMIN)
           CALL UTFINM()
        END IF
        IF (ZR(IINST+NBINS-1).GT.TPSMAX) THEN
           CALL UTDEBM('S','OP0197','LE DERNIER INSTANT DE RUPTURE '
     &          //'N''EST PAS DANS LA LISTE DES INSTANTS DE CALCUL')
           CALL UTIMPR('L','DERNIER INSTANT DE RUPTURE = ',1,
     &          ZR(IINST+NBINS-1))
           CALL UTIMPR('L','DERNIER INSTANT DE CALCUL = ',1,TPSMAX)
           CALL UTFINM()
        END IF
C
 100  CONTINUE
C
C     --- ON REGARDE SI LE RECALAGE DOIT S'EFFECTUER EN FONCTION
C     --- DE LA TEMPERATURE : SIGU(T)
C
      IF (NTEMP.GT.0) THEN
C
       IF (NTEMP.NE.NBRESU) THEN
         CALL U2MESS('F','UTILITAI3_30')
       ELSE
         IF (NBRESU.GT.1) THEN
           DEPT = .FALSE.
           IF (NTPSI.GT.1) DEPT = .TRUE.
         ELSE
           DEPT = .FALSE.
         END IF
       END IF
C
      ELSE
       DEPT = .FALSE.
       NTPSI = 1
      END IF
C
C     --- CREATION DES TABLES DE RESULTATS
C
      CALL TBCRSD(NOMRES,'G')
C
      IF (METHOD(1:9).EQ.'REGR_LINE') THEN
        CALL TBAJPA (NOMRES, NBPARS, NOPARS, TYPARS )
      ELSE
        CALL TBAJPA (NOMRES, 2, NOPARS, TYPARS )
      END IF
      IF (DEPT) THEN
        CALL TBAJPA (NOMRES, NBPART, NOPART, TYPART )
      ELSE
        CALL TBAJPA (NOMRES, 2, NOPART(2), TYPART(2) )
      END IF
C
      CALL WKVECT('&&OP0197.NOPARK','V V K16',NTPSI+2,INOPA)
      CALL WKVECT('&&OP0197.VALPAR','V V R'  ,NTPSI+1,IVAPA)
      CALL WKVECT('&&OP0197.TYPARK','V V K8' ,NTPSI+2,ITYPA)
      ZK16(INOPA)   = NOPARK(1)
      ZK16(INOPA+1) = NOPARK(2)
      ZK8(ITYPA)   = TYPARK(1)
      ZK8(ITYPA+1) = TYPARK(2)
      DO 110 I=1,NTPSI
        IF (NTEMP.EQ.0) THEN
           ZK16(INOPA+1+I) = NOPARK(3)
        ELSE
           IBID = INT(ZR(ITPSI-1+I))
           CALL CODENT(IBID,'G',CHTEMP)
           ZK16(INOPA+1+I) = NOPARK(3)(1:7)//'_T:'//CHTEMP
        END IF
        ZK8(ITYPA+1+I) = TYPARK(3)
110   CONTINUE
      TAPAIT = '&&PAR_IT'
      CALL TBCRSD(TAPAIT,'V')
      CALL TBAJPA(TAPAIT, NTPSI+2, ZK16(INOPA), ZK8(ITYPA) )
C
C     --- RECHERCHE DE LA RC WEIBULL POUR CHAQUE BASE RESULTAT
C
      NOMRC = 'WEIBULL         '
      DO 115 IRESU=1,NBRESU
C
        CALL JELIRA(ZK8(ICHMAT-1+IRESU)//'.CHAMP_MAT .VALE',
     &                    'LONMAX',NBMTCM,K8BID)
        CALL WKVECT('&&OP0197.L_NOM_MAT','V V K8',NBMTCM,ANOMM1)
        CALL CHMRCK(ZK8(ICHMAT-1+IRESU),NOMRC,NBMTCM,ZK8(ANOMM1),NBMTRC)
        ZK24(IKVAK-1+IRESU)(1:8)  = ZK8(ANOMM1)
        ZK24(IKVAK-1+IRESU)(9:24) = '.WEIBULL   .VALK'
        ZK24(IKVAL-1+IRESU)(1:8)  = ZK8(ANOMM1)
        ZK24(IKVAL-1+IRESU)(9:24) = '.WEIBULL   .VALR'
C
        CALL JEDETR ( '&&OP0197.L_NOM_MAT' )
        CALL JEVEUO ( ZK24(IKVAK-1+IRESU), 'L', IWEIK )
        CALL JEVEUO ( ZK24(IKVAL-1+IRESU), 'L', IWEIR )
        CALL JELIRA ( ZK24(IKVAK-1+IRESU),'LONMAX',IMC,K8BID)

        DO 117 I=1,IMC
          IF (ZK8(IWEIK + I-1).EQ.'M       ') THEN
              MINI=ZR(IWEIR + I-1)
          ENDIF
          IF (ZK8(IWEIK + I-1).EQ.'VOLU_REF') THEN
              VINI=ZR(IWEIR + I-1)
          ENDIF
          IF (ZK8(IWEIK + I-1).EQ.'SIGM_REF') THEN
              ZR(ISIGI-1+IRESU)=ZR(IWEIR + I-1)
          ENDIF
117     CONTINUE

        IF (IRESU.GT.1) THEN
          IF (MINI.NE.MINIP) THEN
           CALL U2MESS('F','UTILITAI3_31')
          END IF
          IF (ZR(ISIGI-1+IRESU).NE.ZR(ISIGI-2+IRESU)) THEN
           CALL U2MESS('F','UTILITAI3_32')
          END IF
        END IF
        MINIP = MINI
C
115   CONTINUE
      CALL UTDEBM('I','OP0197','PARAMETRES INITIAUX DE WEIBULL')
      CALL UTIMPR('L','EXPOSANT DE LA LOI      =',1,MINI)
      CALL UTIMPR('L','VOLUME DE REFERENCE     =',1,VINI)
      CALL UTIMPR('L','CONTRAINTE DE REFERENCE =',1,ZR(ISIGI))
      CALL UTFINM
C
      CALL WKVECT('&&OP0197.NOM_TABLPE','V V K16',NBRESU,ITABW)
      CALL WKVECT('&&OP0197.NOM_TABLIN','V V K16',NBRESU,ITABR)
      CALL WKVECT('&&OP0197.PROBW','V V R',NRUPT,IX)
      CALL WKVECT('&&OP0197.SIGMW','V V R',NRUPT,IY)
      CALL WKVECT('&&OP0197.PROTH','V V R',NRUPT,IPTH)
C
C     --- INITIALISATION DES PARAMETRES AUX VALEURS DE DEPART
C
      NBITE = 0
      MK  = MINI
      MKP = MINI
      DO 201 IRESU=1,NTPSI
       ZR(ISIGK+IRESU-1)  = ZR(ISIGI+IRESU-1)
       ZR(ISIGKP+IRESU-1) = ZR(ISIGI+IRESU-1)
201   CONTINUE
C
200   CONTINUE
C
C     --- NOUVELLE ITERATION DE RECALAGE
C
       NBITE = NBITE + 1
C
       IF (IMPR) THEN
         WRITE(IFM,*) '***************************'
         WRITE(IFM,*) 'ITERATION DE RECALAGE NO ',NBITE
         WRITE(IFM,*) '***************************'
       END IF
C
       MK = MKP
       DO 203 IRESU=1,NTPSI
         ZR(ISIGK+IRESU-1)  = ZR(ISIGKP+IRESU-1)
203    CONTINUE
C
       DO 300 IRESU = 1, NBRESU
C
C        CALCUL POUR CHAQUE RESU DES CONTRAINTES DE WEIBULL ---
C
C       --- SURCHARGE DES PARAMETRES DE LA RC WEIBULL
C        --- PAR SIGU(K) ET M(K)
C
        CALL JELIRA(ZK8(ICHMAT-1+IRESU)//'.CHAMP_MAT .VALE',
     &                    'LONMAX',NBMTCM,K8BID)
        CALL WKVECT('&&OP0197.L_NOM_MAT','V V K8',NBMTCM,ANOMM2)
        CALL CHMRCK(ZK8(ICHMAT-1+IRESU),NOMRC,NBMTCM,ZK8(ANOMM2),NBMTRC)
        CALL JELIRA ( ZK24(IKVAK-1+IRESU),'LONMAX',IMC,K8BID)
C
C       DUPLICATION DE LA SD CHAM_MATER POUR LA SURCHARGE
C
        CALL COPISD(' ','V',ZK8(ICHMAT-1+IRESU),CHCOP1)
        CALL JEVEUO(CHCOP1//'.CHAMP_MAT .VALE','E',ICHCO)
        DO 301 I=1,NBMTCM
          IF (ZK8(ICHCO+I-1).EQ.ZK8(ANOMM2)) THEN
            CALL COPISD(' ','V',ZK8(ANOMM2),CHCOP2)
            ZK8(ICHCO+I-1) = CHCOP2
          END IF
301     CONTINUE
C
        CALL JEDETR ( '&&OP0197.L_NOM_MAT' )
        CALL JEVEUO (CHCOP2//'.WEIBULL   .VALR', 'E', IWEIR )
        CALL JEVEUO (CHCOP2//'.WEIBULL   .VALK', 'L', IWEIK )
C
        DO 302 I=1,IMC
          IF (ZK8(IWEIK + I-1).EQ.'M       ') THEN
              ZR(IWEIR + I-1) = MK
          ENDIF
          IF (ZK8(IWEIK + I-1).EQ.'VOLU_REF') THEN
              ZR(IWEIR + I-1) = VINI
          ENDIF
          IF (ZK8(IWEIK + I-1).EQ.'SIGM_REF') THEN
              ZR(IWEIR + I-1) = ZR(ISIGK+ZI(ITPRE-1+IRESU)-1)
          ENDIF
302     CONTINUE
C
        CALL JEDETC('V','.MATE_CODE',9)
        CALL JEDETC('V','.CODI',20)
        MATE = ' '
        CALL RCMFMC ( CHCOP1, MATE )
C

C       DETERMINATION DU NOM DES 2 TABLES A CREER:
        NOOBJ ='12345678.TB00000   .TBNP'
        CALL GNOMSD(NOOBJ,12,16)
        ZK16(ITABW-1+IRESU)=NOOBJ(1:16)
        READ(NOOBJ(12:16),'(I5)') KK
        KK=KK+1
        CALL CODENT(KK,'D0',NOOBJ(12:16))
        ZK16(ITABR-1+IRESU)=NOOBJ(1:16)
C
        NCHAR = 0
        CALL WKVECT('&&OP0197.CHARGES','V V K8',1,JCHA)
C
        IF (IMPR) THEN
         WRITE(IFM,*) '*******************'
         WRITE(IFM,*) '**** RESULTAT NO ',IRESU
         WRITE(IFM,*) '*******************'
         WRITE(IFM,*)
     &    'ETAPE 1 > CALCUL DES SIGMA WEIBULL : APPEL PEWEIB'
        END IF
C
C        --- CALCUL DES SIGMA_WEIBULL
C
        CALL PEWEIB(ZK16(ITABW-1+IRESU),ZK8(IMOD-1+IRESU),MATE,
     &              CARA,CHCOP1,NCHAR,ZK8(JCHA),0,1,IRESU,NOMCMD)
        CALL JEDETR ('&&TE0331')
        CALL JEDETR ( '&&OP0197.CHARGES' )
C
C       --- INTERPOLATION SUR LA BASE DE CALCUL DES VALEURS
C       --- DES CONTRAINTES DE WEIBULL AUX INSTANTS DE RUPTURE
C
        CALL TBEXVE(ZK16(ITABW-1+IRESU),'SIGMA_WEIBULL',
     &                  '&&OP0197.NOM_VECSIG','V',NBVAL,K8BID)
        CALL TBEXVE(ZK16(ITABW-1+IRESU),'PROBA_WEIBULL',
     &                  '&&OP0197.NOM_VECPRO','V',NBVAL,K8BID)
        CALL TBEXVE(ZK16(ITABW-1+IRESU),'INST',
     &                  '&&OP0197.NOM_INSSIG','V',NBVAL,K8BID)
        CALL JELIRA(JEXNUM(COLLEC,IRESU),'LONUTI',NBINS,K8BID)
        CALL JEVEUO(JEXNUM(COLLEC,IRESU),'L',IINST)
        CALL JEVEUO('&&OP0197.NOM_VECSIG','L',ISIG)
        CALL JEVEUO('&&OP0197.NOM_VECPRO','L',IPRO)
C
        IF (IMPR) THEN
          WRITE(IFM,*) 'TABLEAU DES SIGMA WEIBULL : '
          DO 305 IT=1,NBVAL
            WRITE(IFM,*) 'SIGW(',IT,') = ',ZR(ISIG+IT-1)
 305      CONTINUE
          WRITE(IFM,*) 'TABLEAU DES PROBA WEIBULL : '
          DO 306 IT=1,NBVAL
            WRITE(IFM,*) 'PRW(',IT,') = ',ZR(IPRO+IT-1)
 306      CONTINUE
        END IF
C
        CALL JEVEUO('&&OP0197.NOM_INSSIG','L',ITPS)
C
        CALL TBCRSD(ZK16(ITABR-1+IRESU),'V')
        CALL TBAJPA (ZK16(ITABR-1+IRESU), NBPARR, NOPARR, TYPARR )
C
        IF (IMPR) WRITE(IFM,*) 'ETAPE 2 > INTERPOLATION SIGMA WEIBULL'
        DO 310 IT = 1,NBINS
         IF (IMPR) WRITE(IFM,*) 'INTERPOLATION NO ',IT,
     &                          ' / TEMPS = ',ZR(IINST+IT-1)
         CALL INTERP(ZR(ITPS),ZR(ISIG),NBVAL,ZR(IINST+IT-1),SIGINT,ISEG)
         CALL INTERP(ZR(ITPS),ZR(IPRO),NBVAL,ZR(IINST+IT-1),PROINT,ISEG)
         VALI(1) = IRESU
         VALR(1) = ZR(IINST+IT-1)
         VALR(2) = SIGINT
         VALR(3) = PROINT
         CALL TBAJLI (ZK16(ITABR-1+IRESU), NBPARR, NOPARR,
     &                VALI, VALR, C16B, K8BID, 0 )
         IF (IMPR) WRITE(IFM,*) 'SIGMA WEIBULL :',SIGINT
  310   CONTINUE
C
        CALL JEDETR ( '&&OP0197.NOM_VECPRO' )
        CALL JEDETR ( '&&OP0197.NOM_VECSIG' )
        CALL JEDETR ( '&&OP0197.NOM_INSSIG' )
C
        CALL JEDETC('V',CHCOP1,1)
        CALL JEDETC('V',CHCOP2,1)
C
300   CONTINUE
C
C  ---   FUSION DES TABLES DE CONTRAINTES DE WEIBULL POUR
C  ---   TOUTES LES BASES DE RESULATS
C
      CALL TBFUTB ( TABOUT, 'G', NBRESU, ZK16(ITABR),' ',' ',
     &              IBID, R8BID, C16B, K8BID )

C  ---   TRI DE LA TABLE DES CONTRAINTES DE WEIBULL

      CALL TBTRTB(TABOUT,'G',TABTRI,1,NOPARR(3),'CR',0.D0,'ABSOLU  ')
      CALL TBEXVE(TABTRI,'NURES','&&OP0197.NOM_NURES','V',NRUPT,K8BID)
      CALL JEVEUO('&&OP0197.NOM_NURES','L',INUR)
      CALL TBEXVE(TABTRI,'SIGMA_WEIBULL',
     &            '&&OP0197.NOM_VECSIG','V',NRUPT,K8BID)
      CALL JEVEUO('&&OP0197.NOM_VECSIG','L',ISIG)
      CALL TBEXVE(TABTRI,'PROBA_WEIBULL',
     &            '&&OP0197.NOM_VECPRO','V',NRUPT,K8BID)
      CALL JEVEUO('&&OP0197.NOM_VECPRO','L',IPRO)
      CALL DETRSD('TABLE',TABTRI)
      CALL DETRSD('TABLE',TABOUT)
C
      IF (IMPR) THEN
        WRITE(IFM,*) 'ETAPE 3 > FUSION ET TRI DES SIGMA WEIBULL'
        DO 307 IT=1,NRUPT
            WRITE(IFM,*) 'SIGW(',IT,') = ',ZR(ISIG+IT-1)
 307    CONTINUE
        WRITE(IFM,*) 'ETAPE 4 > OPTIMISATION DES PARAMETRES'
      END IF
C
C  ---   CALCUL DE M ET SIGMA-U AU RANG K+1 PAR UNE
C        DES DEUX METHODES DE RECALAGE
C
      CALL OPTIMW (METHOD,NRUPT,ZR(IX),ZR(IY),ZR(IPTH),ZR(ISIG),
     &             ZI(IRENT),ZI(INUR),NBRESU,CALM,CALS,MK,ZR(ISIGK),
     &             MKP,ZR(ISIGKP),IMPR,IFM,DEPT,ZI(ITPRE),NTPSI)
C
C  ---   STOCKAGE DANS LA TABLE TABL_PARA_ITER
C        TABLE PARAMETRES MODELE A L'ITERATION K : K,M(K),SIGU(K)
C
      VALI(1) = NBITE
      ZR(IVAPA) = MKP
      DO 11 IRESU=1,NTPSI
         ZR(IVAPA+IRESU) = ZR(ISIGKP+IRESU-1)
 11   CONTINUE
      CALL TBAJLI (TAPAIT, NTPSI+2, ZK16(INOPA),
     &             VALI, ZR(IVAPA), C16B, K8BID, 0 )
C
C  ---   CALCUL CRITERE DE CONVERGENCE (MK,MK+1,SUK,SUK+1)
C
      MAXCS = 0.D0
      DO 12 IRESU=1,NTPSI
        IF ((ABS((ZR(ISIGKP+IRESU-1) - ZR(ISIGK+IRESU-1) )/
     &       ZR(ISIGK+IRESU-1))) .GT. MAXCS ) THEN
            MAXCS = ABS((ZR(ISIGKP+IRESU-1) - ZR(ISIGK+IRESU-1))
     &                  / ZR(ISIGK+IRESU-1))
        END IF
 12   CONTINUE
C
      IF ((ABS((MKP-MK)/MK)) .LE. EPSI ) CALM = .TRUE.
      IF (MAXCS .LE. EPSI ) CALS = .TRUE.
C
C     SI SIGMA A CONVERGE ALORS QUE M RESTE A CALER
C     ALORS ON CONTINUE A CALER M ET SIGMA
C
      IF ((RECM.AND.RECS).AND.(CALS.AND.(.NOT.CALM))) CALS = .FALSE.
C
      TEST = MAX((ABS((MKP-MK)/MK)),MAXCS)
      IF (IMPR) THEN
        WRITE(IFM,*) 'CONVERGENCE POUR M-K : ',ABS((MKP-MK)/MK)
        WRITE(IFM,*) 'CONVERGENCE POUR SIGMA-K : ',MAXCS
        IF (CALM) WRITE(IFM,*) ' --> LE PARAMETRE M EST CALE'
        IF (CALS) WRITE(IFM,*) ' --> LE PARAMETRE SIGMA EST CALE'
      END IF
C
C        STOCKAGE DANS LA TABLE TABL_PROBA_SIGW
C        TABLE PROBA-SIGMA EXPERIENCE/THEORIE : SIGW(I),PF(SIGW),PF(I)
C
      IF (CALM.AND.CALS) THEN
C
        DO 308 IT=1,NRUPT
          VALR(1) = ZR(ISIG+IT-1)
          VALR(2) = ZR(IPRO+IT-1)
          IF (METHOD(1:9).EQ.'REGR_LINE') THEN
             VALR(3) = ZR(IPTH+IT-1)
             CALL TBAJLI (NOMRES, NBPARS, NOPARS,
     &                    IBID, VALR, C16B, K8BID, 0 )
          ELSE
             CALL TBAJLI (NOMRES, 2, NOPARS,
     &                    IBID, VALR, C16B, K8BID, 0 )
          END IF
 308    CONTINUE
C
      END IF

      CALL JEDETR ( '&&OP0197.NOM_VECSIG' )
      CALL JEDETR ( '&&OP0197.NOM_VECPRO' )
      CALL JEDETR ( '&&OP0197.NOM_NURES' )

C
C
C  ---   STOCKAGE DANS LA TABLE TABL_PARA_TEMP
C        TABLE PARAMETRES FONCTION TEMPERATURE : T,M,SIGU(T)
C
      IF (CALM.AND.CALS) THEN
C
       DO 311 IRESU=1,NTPSI
          VALR(1) = ZR(ITPSI+IRESU-1)
          VALR(2) = MKP
          VALR(3) = ZR(ISIGKP+IRESU-1)
          IF (DEPT) THEN
            CALL TBAJLI (NOMRES, NBPART, NOPART,
     &                   IBID, VALR, C16B, K8BID, 0 )
          ELSE
            CALL TBAJLI (NOMRES, 2, NOPART(2),
     &                   IBID, VALR(2), C16B, K8BID, 0 )
          END IF
 311   CONTINUE
C
      END IF
C
C     ---  BOUCLAGE SI NON CONVERGENCE
C          ET NOMBRE D'ITERATIONS MAX NON ATTEINT
C
      IF (((.NOT.CALM).OR.(.NOT.CALS)).AND.NBITE.LT.NITMAX) GOTO 200
      IF (NBITE.EQ.NITMAX) THEN
        CALL U2MESS('F','UTILITAI2_53')
      END IF
C
      CALL UTDEBM('I','OP0197','STATISTIQUES RECALAGE :')
      CALL UTIMPI('L','NOMBRE D''ITERATIONS =',1,NBITE)
      CALL UTIMPR('L','CONVERGENCE ATTEINTE =',1,TEST)
      CALL UTFINM
C
      NOPASE = '        '
      CALL TBIMPR ( TAPAIT, NOPASE, 'EXCEL', IFM, NTPSI+2, ZK16(INOPA),
     &              0, K16BID, '1PE12.5', ' ')
C
      CALL JEDEMA()
      END
