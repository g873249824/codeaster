      SUBROUTINE OP0168()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 18/03/2013   AUTEUR BERRO H.BERRO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     OPERATEUR  EXTR_MODE
C     ------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
C-----------------------------------------------------------------------
      INTEGER I ,IBID ,IFR ,IMPR ,IORD ,IPREC ,IRET
      INTEGER IUNIFI ,J ,JADR ,JME ,JNOM ,JOR ,JORDR
      INTEGER K ,LMOD ,LMODE ,LVALI ,LVALK ,LVALR ,N1
      INTEGER N10 ,N2 ,N3 ,N4 ,N5 ,N6 ,N7
      INTEGER N8 ,N9 ,NBFILT ,NBME ,NBMODE ,NBMODT ,NBMODU
      INTEGER NBMR ,NBPARA ,NBPARI ,NBPARK ,NBPARR ,NDIMT ,NEQ
      INTEGER NPARI ,NPARK ,NPARR ,NUME ,NUME1 ,NUME2
      REAL*8 CUMULX ,CUMULY ,CUMULZ ,DX ,DY ,DZ ,FREMAX
      REAL*8 FREMIN ,FREQ ,R8VIDE ,SEUIL ,UNDF
C-----------------------------------------------------------------------
      PARAMETER   ( NBPARI=1 , NBPARR=15 , NBPARK=3, NBPARA=19 )
      INTEGER       LPAR(3)
      INTEGER VALI(2)
      REAL*8        R8B, PREC, ZERO, MASTOT
      CHARACTER*1   K1B, TYPMOD
      CHARACTER*3   OUINON
      CHARACTER*8   K8B, MODEOU, MODEIN
      CHARACTER*16  TYPCON, NOMCMD, CRITFI, NOMPAR(3), NOMSY, NOMPAV
      CHARACTER*19  NUMEDD
      CHARACTER*24  MASSE, AMOR, RAIDE, REFD, MASSI, AMORI, RAIDI, KMODE
      CHARACTER*24 VALK
      CHARACTER*24  KVEC, KVALI, KVALR, KVALK, NOPARA(NBPARA)
      COMPLEX*16    C16B
      INTEGER      IARG
C     ------------------------------------------------------------------
      DATA  REFD  / '                   .REFD' /
      DATA  KVEC  / '&&OP0168.VAL_PROPRE' /
      DATA  KVALI / '&&OP0168.GRAN_MODAL_I' /
      DATA  KVALR / '&&OP0168.GRAN_MODAL_R' /
      DATA  KVALK / '&&OP0168.GRAN_MODAL_K_' /
      DATA NOMPAR / 'MASS_EFFE_UN_DX' , 'MASS_EFFE_UN_DY' ,
     &              'MASS_EFFE_UN_DZ' /
      DATA  NOPARA /        'NUME_MODE'       ,
     &  'NORME'           , 'TYPE_MODE'       , 'NOEUD_CMP'       ,
     &  'FREQ'            , 'OMEGA2'          , 'AMOR_REDUIT'     ,
     &  'MASS_GENE'       , 'RIGI_GENE'       , 'AMOR_GENE'       ,
     &  'MASS_EFFE_DX'    , 'MASS_EFFE_DY'    , 'MASS_EFFE_DZ'    ,
     &  'FACT_PARTICI_DX' , 'FACT_PARTICI_DY' , 'FACT_PARTICI_DZ' ,
     &  'MASS_EFFE_UN_DX' , 'MASS_EFFE_UN_DY' , 'MASS_EFFE_UN_DZ' /
C     ------------------------------------------------------------------
C
      CALL JEMARQ ( )
      CALL INFMAJ()
C
      ZERO = 0.D0
      UNDF = R8VIDE( )
      CALL GETRES( MODEOU, TYPCON, NOMCMD )
      IFR = IUNIFI('RESULTAT')
C
C     --- RECUPERATION DU NOMBRE DE MODES A EXTRAIRE ---
      KMODE = '&&OP0168.MODE.RETENU'
      NBMR = 0
      NDIMT = 0
      CALL GETFAC ( 'FILTRE_MODE' , NBFILT )
      IF ( NBFILT .NE. 0 ) THEN
         CALL WKVECT('&&OP0168.NOM_MODE','V V K8',NBFILT,JNOM)
         CALL JECREC(KMODE,'V V I','NU','DISPERSE','VARIABLE',NBFILT)
         DO 10 I = 1 , NBFILT
            CALL GETVID ( 'FILTRE_MODE', 'MODE', I,IARG,1, MODEIN, N1 )
            CALL JELIRA ( MODEIN//'           .ORDR','LONUTI',IRET,K8B)
            IF ( IRET .EQ. 0 ) GOTO 10
            NBMR = NBMR + 1
C
            IF ( NBMR .EQ. 1 ) THEN
C      --- MATRICES DE REFERENCE DES MODES ---
               REFD(1:8) = MODEIN
               CALL JEVEUO ( REFD, 'L', LMODE )
               RAIDE = ZK24(LMODE)
               MASSE = ZK24(LMODE+1)
               AMOR  = ZK24(LMODE+2)
               NUMEDD  = ZK24(LMODE+3)
               CALL VPCREA ( 0,MODEOU, MASSE, AMOR, RAIDE,NUMEDD,IBID )
            ENDIF
C
            ZK8(JNOM+NBMR-1) = MODEIN
            REFD(1:8) = MODEIN
            CALL JEVEUO(REFD,'L',LMODE)
            RAIDI = ZK24(LMODE)
            MASSI = ZK24(LMODE+1)
            AMORI = ZK24(LMODE+2)
            IF ( MASSI.NE.MASSE .OR. AMORI.NE.AMOR .OR. RAIDI.NE.RAIDE )
     &           CALL U2MESS('F','ALGELINE3_9')
C
            CALL RSORAC(MODEIN,'LONUTI',IBID,R8B,K8B,C16B,R8B,K8B,
     &                                                  NBMODT,1,IBID)
            CALL WKVECT('&&OP0168.NUME_ORDRE','V V I',NBMODT,JOR)
            CALL RSORAC(MODEIN,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &                                            ZI(JOR),NBMODT,IBID)
C
            CALL JECROC(JEXNUM(KMODE,NBMR))
            CALL JEECRA(JEXNUM(KMODE,NBMR),'LONMAX',NBMODT,' ')
            CALL JEVEUO(JEXNUM(KMODE,NBMR),'E',JORDR)
C
            CALL GETVTX('FILTRE_MODE','TOUT_ORDRE',I,IARG,1,OUINON,N1)
            IF ( N1 .NE. 0  .AND.  OUINON .EQ. 'OUI' ) THEN
               NBMODE = NBMODT
               DO 12 J = 1 , NBMODE
                  ZI(JORDR+J-1) = ZI(JOR+J-1)
 12            CONTINUE
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               GOTO 10
            ENDIF
C
            CALL GETVIS('FILTRE_MODE','NUME_ORDRE',I,IARG,0,IBID,N2)
            IF ( N2 .NE. 0 ) THEN
               NBMODU = -N2
               CALL WKVECT('&&OP0168.NUME_MODE','V V I',NBMODU,JME)
               CALL GETVIS('FILTRE_MODE','NUME_ORDRE',I,IARG,
     &                                             NBMODU,ZI(JME),N2)
               NBMODE = 0
               DO 20 J = 1 , NBMODU
                  DO 22 K = 1 , NBMODT
                     IF ( ZI(JME+J-1) .EQ. ZI(JOR+K-1) ) THEN
                        NBMODE = NBMODE + 1
                        ZI(JORDR+NBMODE-1) = ZI(JME+J-1)
                        GOTO 20
                     ENDIF
 22               CONTINUE
               VALK = MODEIN
               VALI (1) = ZI(JME+J-1)
              CALL U2MESG('A', 'ALGELINE4_55',1,VALK,1,VALI,0,0.D0)
 20            CONTINUE
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_MODE' )
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               GOTO 10
            ENDIF
C
            CALL GETVIS('FILTRE_MODE','NUME_MODE',I,IARG,0,IBID,N3)
            IF ( N3 .NE. 0 ) THEN
               NBMODU = -N3
               CALL WKVECT('&&OP0168.NUME_MODE','V V I',NBMODU,JME)
               CALL GETVIS('FILTRE_MODE','NUME_MODE',I,IARG,
     &                                             NBMODU,ZI(JME),N3)
               NBMODE = 0
               DO 30 J = 1 , NBMODT
                  IORD = ZI(JOR+J-1)
                  CALL RSADPA(MODEIN,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
                  NUME = ZI(JADR)
                  DO 32 K = 1 , NBMODU
                     IF ( NUME . EQ. ZI(JME+K-1) ) THEN
                        NBMODE = NBMODE + 1
                        ZI(JORDR+NBMODE-1) = IORD
                     ENDIF
 32               CONTINUE
 30            CONTINUE
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_MODE' )
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               GOTO 10
            ENDIF
C
            CALL GETVIS('FILTRE_MODE','NUME_MODE_EXCLU',I,IARG,0,
     &                  IBID,N4)
            IF ( N4 .NE. 0 ) THEN
               NBME = -N4
               CALL WKVECT('&&OP0168.NUME_MODE','V V I',NBME,JME)
               CALL GETVIS('FILTRE_MODE','NUME_MODE_EXCLU',I,IARG,
     &                                                NBME,ZI(JME),N4)
               NBMODE = 0
               DO 40 J = 1 , NBMODT
                  IORD = ZI(JOR+J-1)
                  CALL RSADPA(MODEIN,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
                  NUME = ZI(JADR)
                  DO 42 K = 1 , NBME
                     IF ( NUME . EQ. ZI(JME+K-1) ) GOTO 40
 42               CONTINUE
                  NBMODE = NBMODE + 1
                  ZI(JORDR+NBMODE-1) = IORD
 40            CONTINUE
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               CALL JEDETR ( '&&OP0168.NUME_MODE' )
               GOTO 10
            ENDIF
C
            CALL GETVR8('FILTRE_MODE','FREQ_MIN',I,IARG,0,R8B,N5)
            IF ( N5 .NE. 0 ) THEN
               CALL GETVR8('FILTRE_MODE','FREQ_MIN' ,I,IARG,1,FREMIN,N5)
               CALL GETVR8('FILTRE_MODE','FREQ_MAX' ,I,IARG,1,FREMAX,N5)
               CALL GETVR8('FILTRE_MODE','PRECISION',I,IARG,1,PREC  ,N5)
               FREMIN = FREMIN - PREC
               FREMAX = FREMAX + PREC
               NBMODE = 0
               DO 50 J = 1 , NBMODT
                  IORD = ZI(JOR+J-1)
                  CALL RSADPA(MODEIN,'L',1,'FREQ',IORD,0,JADR,K8B)
                  FREQ = ZR(JADR)
                  IF ( FREQ.GE.FREMIN .AND. FREQ.LE.FREMAX) THEN
                     NBMODE = NBMODE + 1
                     ZI(JORDR+NBMODE-1) = IORD
                  ENDIF
 50            CONTINUE
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               GOTO 10
            ENDIF
C
            CALL GETVTX('FILTRE_MODE','CRIT_EXTR',I,IARG,0,K8B,N6)
            IF ( N6 .NE. 0 ) THEN
               CALL GETVTX('FILTRE_MODE','CRIT_EXTR',I,IARG,1,CRITFI,N6)
               CALL GETVR8('FILTRE_MODE','SEUIL'  ,I,IARG,1,SEUIL ,N7)
               CALL GETVR8('FILTRE_MODE','SEUIL_X'  ,I,IARG,1,SEUIL ,N8)
               CALL GETVR8('FILTRE_MODE','SEUIL_Y'  ,I,IARG,1,SEUIL ,N9)
               CALL GETVR8('FILTRE_MODE','SEUIL_Z',I,IARG,1,
     &                     SEUIL ,N10)
               NBMODE = 0
               IF ( CRITFI .EQ. 'MASS_EFFE_UN'.AND.
     &             TYPCON(1:9).EQ.'MODE_MECA' ) THEN
                 DO 60 J = 1 , NBMODT
                   IORD = ZI(JOR+J-1)
                   CALL RSADPA(MODEIN,'L',3,NOMPAR,IORD,0,LPAR,K8B)
                   DX = ZR(LPAR(1))
                   DY = ZR(LPAR(2))
                   DZ = ZR(LPAR(3))
                   IF (DX.EQ.UNDF.OR.DY.EQ.UNDF.OR.DZ.EQ.UNDF) THEN
                     CALL U2MESS('F','ALGELINE3_10')
                   ENDIF
                   IF (N7.NE.0) THEN
                     IF (DX.GE.SEUIL.OR.DY.GE.SEUIL.OR.DZ.GE.SEUIL) THEN
                       NBMODE = NBMODE + 1
                       ZI(JORDR+NBMODE-1) = IORD
                     ENDIF
                   ELSEIF (N8.NE.0) THEN
                     IF (DX.GE.SEUIL) THEN
                       NBMODE = NBMODE + 1
                       ZI(JORDR+NBMODE-1) = IORD
                     ENDIF
                   ELSEIF (N9.NE.0) THEN
                     IF (DY.GE.SEUIL) THEN
                       NBMODE = NBMODE + 1
                       ZI(JORDR+NBMODE-1) = IORD
                     ENDIF
                   ELSEIF (N10.NE.0) THEN
                     IF (DZ.GE.SEUIL) THEN
                       NBMODE = NBMODE + 1
                       ZI(JORDR+NBMODE-1) = IORD
                     ENDIF
                   ENDIF

 60              CONTINUE
               ENDIF
               IF ( CRITFI .EQ. 'MASS_GENE' ) THEN
                 MASTOT = ZERO
                 DO 61 J = 1 , NBMODT
                   IORD = ZI(JOR+J-1)
                   NOMPAV = 'MASS_GENE'
                   CALL RSADPA(MODEIN,'L',1,NOMPAV,IORD,0,LPAR,K8B)
                   MASTOT = MASTOT + ZR(LPAR(1))
 61              CONTINUE
                 DO 62 J = 1 , NBMODT
                   IORD = ZI(JOR+J-1)
                   NOMPAV = 'MASS_GENE'
                   CALL RSADPA(MODEIN,'L',1,NOMPAV,IORD,0,LPAR,K8B)
                   DX = ZR(LPAR(1))/MASTOT
                   IF (DX.GE.SEUIL) THEN
                     NBMODE = NBMODE + 1
                     ZI(JORDR+NBMODE-1) = IORD
                   ENDIF
 62              CONTINUE
               ENDIF
               CALL JEECRA(JEXNUM(KMODE,NBMR),'LONUTI',NBMODE,' ')
               NDIMT = NDIMT + NBMODE
               CALL JEDETR ( '&&OP0168.NUME_ORDRE' )
               GOTO 10
            ENDIF
 10      CONTINUE
      ENDIF
C
C     --- STOCKAGE ---
C
      IF (NDIMT.EQ.0)
     &   CALL U2MESS('F','ALGELINE3_11')
      CALL RSCRSD('G', MODEOU, TYPCON, NDIMT )
      IPREC = 0
      NOMSY = 'DEPL'
      DO 100 I = 1 , NBMR
         CALL JEMARQ()
         CALL JERECU('V')
         MODEIN = ZK8(JNOM+I-1)
         CALL JELIRA(JEXNUM(KMODE,I),'LONUTI',NBMODE,K1B)
         IF ( NBMODE .EQ. 0 ) THEN
               VALK = MODEIN
            CALL U2MESG('A', 'ALGELINE4_56',1,VALK,0,0,0,0.D0)
            GOTO 102
         ENDIF
         CALL JEVEUO(JEXNUM(KMODE,I),'L',JORDR)
         CALL VPRECU ( MODEIN, NOMSY, NBMODE, ZI(JORDR), KVEC,
     &                 NBPARA, NOPARA, KVALI, KVALR, KVALK,
     &                 NEQ, NBMODE, TYPMOD, NPARI, NPARR, NPARK )
         CALL ASSERT(NPARI.EQ.NBPARI)
         CALL ASSERT(NPARR.EQ.NBPARR)
         CALL ASSERT(NPARK.EQ.NBPARK)
         CALL JEVEUO ( KVEC , 'L', LMOD  )
         CALL JEVEUO ( KVALI, 'L', LVALI )
         CALL JEVEUO ( KVALR, 'L', LVALR )
         CALL JEVEUO ( KVALK, 'L', LVALK )
         IF ( TYPMOD .EQ. 'R' ) THEN
            CALL VPSTOR ( -1, TYPMOD, MODEOU, NBMODE, NEQ, ZR(LMOD),
     &              C16B, NBMODE, NBPARI, NBPARR, NBPARK, NOPARA,'    ',
     &                    ZI(LVALI), ZR(LVALR), ZK24(LVALK), IPREC )
         ELSEIF ( TYPMOD .EQ. 'C' ) THEN
            CALL VPSTOR ( -1, TYPMOD, MODEOU, NBMODE, NEQ, R8B,
     &          ZC(LMOD), NBMODE, NBPARI, NBPARR, NBPARK, NOPARA,'    ',
     &                    ZI(LVALI), ZR(LVALR), ZK24(LVALK), IPREC )
         ELSE
            CALL U2MESK('F','ALGELINE2_44',1,TYPMOD)
         ENDIF
         IPREC = IPREC + NBMODE
         CALL JEDETR ( KVEC )
         CALL JEDETR ( KVALI )
         CALL JEDETR ( KVALR )
         CALL JEDETR ( KVALK )
 102     CONTINUE
         CALL JEDEMA()
 100  CONTINUE
C
C     --- ON ALARME SI NUME_MODE IDENTIQUE ---
C
      CALL RSORAC(MODEOU,'LONUTI',IBID,R8B,K8B,C16B,R8B,K8B,
     &                                                  NBMODE,1,IBID)
      CALL WKVECT('&&OP0168.NUME_ORDRE','V V I',NBMODE,JORDR)
      CALL RSORAC(MODEOU,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &                                          ZI(JORDR),NBMODE,IBID)
      DO 200 J = 1 , NBMODE
         IORD = ZI(JORDR+J-1)
         CALL RSADPA(MODEOU,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
         NUME1 = ZI(JADR)
         DO 210 K = J+1 , NBMODE
            IORD = ZI(JORDR+K-1)
            CALL RSADPA(MODEOU,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
            NUME2 = ZI(JADR)
            IF ( NUME1 .EQ. NUME2 ) THEN
               VALI (1) = IBID
               VALI (2) = IORD
               CALL U2MESG('A', 'ALGELINE4_57',0,' ',2,VALI,0,0.D0)
            ENDIF
 210     CONTINUE
 200  CONTINUE
C
C     --- LES IMPRESSIONS ---
C
      CALL GETFAC ( 'IMPRESSION' , IMPR )
      IF ( IMPR .NE. 0 ) THEN
         WRITE(IFR,800)
         WRITE(IFR,900) MODEOU, TYPCON, NOMCMD
         CALL GETVTX('IMPRESSION','CUMUL'  ,1,IARG,1,OUINON,N1)
         CALL GETVTX('IMPRESSION','CRIT_EXTR',1,IARG,1,CRITFI,N2)

         CALL RSVPAR (MODEOU,1,'MASS_EFFE_UN_DX',IBID,UNDF,K8B,IRET)
         CALL RSADPA (MODEOU,'L',1,'MASS_EFFE_UN_DX',1,0,JADR,K8B)

         IF ( IRET.NE.100 .AND. CRITFI .EQ. 'MASS_EFFE_UN'.AND.
     &          TYPCON(1:9).EQ.'MODE_MECA' ) THEN
            IF ( OUINON .EQ. 'OUI' ) THEN
               WRITE(IFR,1000)
               WRITE(IFR,1010)
            ELSE
               WRITE(IFR,1100)
               WRITE(IFR,1110)
            ENDIF
            CUMULX = 0.D0
            CUMULY = 0.D0
            CUMULZ = 0.D0
            DO 300 J = 1 , NBMODE
               IORD = ZI(JORDR+J-1)
               CALL RSADPA(MODEOU,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
               NUME = ZI(JADR)
               CALL RSADPA(MODEOU,'L',1,'FREQ',IORD,0,JADR,K8B)
               FREQ = ZR(JADR)
               CALL RSADPA(MODEOU,'L',3,NOMPAR,IORD,0,LPAR,K8B)
               DX = ZR(LPAR(1))
               DY = ZR(LPAR(2))
               DZ = ZR(LPAR(3))
               IF (DX.EQ.UNDF.OR.DY.EQ.UNDF.OR.DZ.EQ.UNDF) THEN
                  CALL U2MESS('F','ALGELINE3_10')
               ENDIF
               CUMULX = CUMULX + DX
               CUMULY = CUMULY + DY
               CUMULZ = CUMULZ + DZ
               IF ( OUINON .EQ. 'OUI' ) THEN
                  WRITE(IFR,1020) IORD, NUME, FREQ, DX, CUMULX,
     &                            DY, CUMULY, DZ, CUMULZ
               ELSE
                  WRITE(IFR,1120) IORD, NUME, FREQ, DX, DY, DZ
               ENDIF
 300        CONTINUE
         ENDIF
         IF ( CRITFI .EQ. 'MASS_GENE') THEN
            IF ( OUINON .EQ. 'OUI' ) THEN
               WRITE(IFR,1200)
               WRITE(IFR,1210)
            ELSE
               WRITE(IFR,1300)
               WRITE(IFR,1310)
            ENDIF
            CUMULX = 0.D0
            DO 301 J = 1 , NBMODE
               IORD = ZI(JORDR+J-1)
               CALL RSADPA(MODEOU,'L',1,'NUME_MODE',IORD,0,JADR,K8B)
               NUME = ZI(JADR)
               CALL RSADPA(MODEOU,'L',1,'FREQ',IORD,0,JADR,K8B)
               FREQ = ZR(JADR)
               NOMPAV = 'MASS_GENE'
               CALL RSADPA(MODEOU,'L',1,NOMPAV,IORD,0,LPAR,K8B)
               DX = ZR(LPAR(1))
               CUMULX = CUMULX + DX
               IF ( OUINON .EQ. 'OUI' ) THEN
                  WRITE(IFR,1220) IORD, NUME, FREQ, DX, CUMULX
               ELSE
                  WRITE(IFR,1320) IORD, NUME, FREQ, DX
               ENDIF
 301        CONTINUE
         ENDIF
         WRITE(IFR,800)
      ENDIF
C
      CALL TITRE()
C
 800  FORMAT('----------------------------------------------------------
     &------------------------------------------------------------------
     &--')
 900  FORMAT('CONCEPT ', A8, ' DE TYPE ', A11,
     &       ' ISSU DE L OPERATEUR ', A16)
 1000 FORMAT(/,50X,'M A S S E      E F F E C T I V E      ',
     &              'U N I T A I R E')
 1010 FORMAT('NUME_ORDRE  NUME_MODE     FREQUENCE   ',
     &'MASS_EFFE_UN_DX   CUMUL_DX    MASS_EFFE_UN_DY   CUMUL_DY',
     &'    MASS_EFFE_UN_DZ   CUMUL_DZ')
 1020 FORMAT(1P,4X,I6,5X,I6,7(3X,D12.5))
 1100 FORMAT(/,45X,'MASSE  EFFECTIVE  UNITAIRE')
 1110 FORMAT('NUME_ORDRE  NUME_MODE     FREQUENCE',
     &       '  MASS_EFFE_UN_DX  MASS_EFFE_UN_DY  MASS_EFFE_UN_DZ')
 1120 FORMAT(1P,4X,I6,5X,I6,3X,D12.5,3(3X,D12.5,2X))
 1200 FORMAT(/,18X,'MASSE  GENERALISEE')
 1210 FORMAT('NUME_ORDRE  NUME_MODE     FREQUENCE',
     &       '      MASS_GENE  CUMUL_MASS_GENE')
 1220 FORMAT(1P,4X,I6,5X,I6,3X,D12.5,2(3X,D12.5))
 1300 FORMAT(/,18X,'MASSE  GENERALISEE')
 1310 FORMAT('NUME_ORDRE  NUME_MODE     FREQUENCE',
     &       '      MASS_GENE  ')
 1320 FORMAT(1P,4X,I6,5X,I6,3X,D12.5,3X,D12.5)
C
      CALL JEDEMA ( )
      END
