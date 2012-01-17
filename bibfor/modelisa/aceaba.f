      SUBROUTINE ACEABA(NOMA,NOMO,LMAX,NBARRE,NBOCC,MCLF,
     &                  NBTEL,NTYELE,IVR,IFM,JDLM)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           LMAX,NBARRE,NBOCC,NBTEL,IFM,JDLM
      INTEGER           NTYELE(*),IVR(*)
      CHARACTER*8       NOMA,NOMO
      CHARACTER*(*)     MCLF
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/01/2012   AUTEUR CHEIGNON E.CHEIGNON 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------
C     AFFE_CARA_ELEM
C     AFFECTATION DES CARACTERISTIQUES POUR L'ELEMENT BARRE
C ----------------------------------------------------------------------
C IN  : NOMA   : NOM DU MAILLAGE
C IN  : NOMO   : NOM DU MODELE
C IN  : LMAX   : NOMBRE MAX DE MAILLE OU GROUPE DE MAILLE
C IN  : NBARRE : NOMBRE DE BARRE DU MODELE
C IN  : NBOCC  : NOMBRE D'OCCURENCES DU MOT CLE BARRE
C IN  : NBTEL  : NOMBRE TOTAL D'ELEMENT
C IN  : NTYELE : TABLEAU DES TYPES D'ELEMENTS
C IN  : IVR    : TABLEAU DES INDICES DE VERIFICATION
C IN  : JDLM   : ADRESSE DES MAILLES
C ----------------------------------------------------------------------
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
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      CHARACTER*1  K1BID
      CHARACTER*6  KIOC
      CHARACTER*8  K8B, NOMU, NOMMAI, FCX
      CHARACTER*16 K16B, SEC, CONCEP, CMD
      CHARACTER*19 CARTBA, CARTBG, CARTBF,TABCAR
      CHARACTER*24 TMPNBA, TMPVBA, TMPNBG, TMPVBG, TMPGEN,NOMSEC,TYPCA
      CHARACTER*24 TMPNBF ,TMPVBF, TMPGEF, MODMAI, MLGGMA, MLGNMA
      CHARACTER*16 VMESSK(2)
      INTEGER      IARG
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL GETRES(NOMU,CONCEP,CMD)
C
      CALL WKVECT('&&ACEABA.TAB_PARA','V V I',10,JPARA)
      CALL ACEDAT('BARRE',0,ZI(JPARA),K16B,K8B,K8B,K8B)
      NTYPSE = ZI(JPARA+1)
      NBO    = ZI(JPARA+2)
      NBCAR  = ZI(JPARA+3)
      NBVAL  = ZI(JPARA+4)
      NDIM   = ZI(JPARA+6) * NTYPSE
      CALL WKVECT('&&ACEABA.TYP_SECT','V V K16',NTYPSE,JSECT)
      CALL WKVECT('&&ACEABA.EXPBAR'  ,'V V K8 ',NBO   ,JEXP )
      CALL WKVECT('&&ACEABA.TABBAR'  ,'V V K8 ',NBO   ,JTAB )
      CALL WKVECT('&&ACEABA.CARBAR'  ,'V V K8 ',NDIM  ,JCAR )
      CALL ACEDAT('BARRE',1,ZI(JPARA),ZK16(JSECT),ZK8(JEXP),ZK8(JTAB),
     &                                                      ZK8(JCAR))
      CALL WKVECT('&&ACEABA.CARA','V V K8',NBCAR,JCARA)
      CALL WKVECT('&&ACEABA.VALE','V V R8',NBVAL,JVALE)
C
      MODMAI = NOMO//'.MAILLE'
      MLGNMA = NOMA//'.NOMMAI'
      MLGGMA = NOMA//'.GROUPEMA'
      IER = 0
      CALL JELIRA(MLGNMA,'NOMMAX',NBMAIL,K1BID)
      CALL JEEXIN(MODMAI,IXMA)
      IF (IXMA.NE.0) CALL JEVEUO(MODMAI,'L',JDME)
C
C --- CONSTRUCTION DES CARTES
      TMPGEN = NOMU//'.BARRE'
      CARTBA = NOMU//'.CARGENBA'
      CARTBG = NOMU//'.CARGEOBA'
      TMPNBA = CARTBA//'.NCMP'
      TMPVBA = CARTBA//'.VALV'
      TMPNBG = CARTBG//'.NCMP'
      TMPVBG = CARTBG//'.VALV'

      TMPGEF = NOMU//'.VENT'
      CARTBF = NOMU//'.CVENTCXF'
      TMPNBF = CARTBF//'.NCMP'
      TMPVBF = CARTBF//'.VALV'
C
C --- CREATION D UN OBJET TAMPON (SURDIMENSIONNE A NBO*NBARRE)  :
      CALL JECREC(TMPGEN,'V V R','NO','CONTIG','CONSTANT',NBARRE)
      CALL JEECRA(TMPGEN,'LONMAX',NBO,' ')
      CALL JECREC(TMPGEF,'V V K8','NO','CONTIG','CONSTANT',NBARRE)
      CALL JEECRA(TMPGEF,'LONMAX',1,' ')
      CALL WKVECT('&&ACEABA.BARRE','V V K8',LMAX,JDLS)
C
C --- LECTURE ET STOCKAGE DES DONNEES  DANS L OBJET TAMPON
      DO 10 IOC = 1 , NBOCC
         CALL CODENT(IOC,'G',KIOC)
         CALL GETVEM(NOMA,'GROUP_MA','BARRE','GROUP_MA',
     &           IOC,IARG,LMAX,ZK8(JDLS),NG)
         CALL GETVEM(NOMA,'MAILLE','BARRE','MAILLE',
     &         IOC,IARG,LMAX,ZK8(JDLS),NM)
         CALL GETVTX('BARRE','SECTION',IOC,IARG,1,
     &               SEC       ,NSEC)
         CALL GETVID('BARRE','TABLE_CARA',IOC,IARG,
     &               1,TABCAR,NTAB)
         IF (NTAB.EQ.1)THEN
           CALL GETVTX('BARRE','NOM_SEC',IOC,IARG,1,
     &                 NOMSEC,NNOSEC)
           CALL ASSERT(NNOSEC.EQ.1)
             CALL JEVEUO(TABCAR//'.TBNP','L',ITBNP)
C            NOMBRE DE CARACTERISTIQUES
             NBCOLO = ZI(ITBNP)
C            ON RECHERCHE NOMSEC DANS LA 1ER COLONNE
             CALL JEVEUO(TABCAR//'.TBLP','L',ITBLP)
             TYPCA=ZK24(ITBLP+1)
             IF (TYPCA(1:2).NE.'K8'.AND.TYPCA(1:3).NE.'K24')
     &                       CALL U2MESK('F','MODELISA8_17',1,TABCAR)
             CALL JEVEUO(ZK24(ITBLP+2),'L',ITABL)
             NBLIGN = ZI(ITBNP+1)
             IF (TYPCA.EQ.'K8')THEN
               DO 95 I=1,NBLIGN
                 IF (ZK8(ITABL-1+I).EQ.NOMSEC) THEN
                   IISEC=I
                   GOTO 97
                 ENDIF
 95            CONTINUE
             ELSE
               DO 94 I=1,NBLIGN
                 IF (ZK24(ITABL-1+I)(1:8).EQ.NOMSEC) THEN
                   IISEC=I
                   GOTO 97
                 ENDIF
 94            CONTINUE
             ENDIF
             VMESSK(1)=TABCAR
             VMESSK(2)=NOMSEC
             CALL U2MESK('F','MODELISA8_18',2,VMESSK)
 97          CONTINUE

             DO 96 I=1,NBCOLO-1
               IF (ZK24(ITBLP+4*I+1).NE.'R') GOTO 96
               IF (ZK24(ITBLP+4*I).NE.'A') THEN
                 GOTO 96
               ELSE
                 ZK8(JCARA) = ZK24(ITBLP+4*I)
                 CALL JEVEUO(ZK24(ITBLP+4*I+2),'L',IVECT)
                 ZR(JVALE)=ZR(IVECT-1+IISEC)
                 GOTO 98
               ENDIF
 96          CONTINUE
 98          CONTINUE
         ELSE
           CALL GETVTX('BARRE','CARA',IOC,IARG,NBCAR,
     &               ZK8(JCARA),NCAR)
           CALL GETVR8('BARRE','VALE',IOC,IARG,NBVAL,
     &               ZR(JVALE) ,NVAL)
           CALL ASSERT(NCAR.GT.0)
         ENDIF
         FCX = '.'
         CALL GETVID('BARRE','FCX'       ,IOC,IARG,1    ,FCX ,NFCX)
C
         IF (SEC.EQ.ZK16(JSECT  )) ISEC = 0
         IF (SEC.EQ.ZK16(JSECT+1)) ISEC = 1
         IF (SEC.EQ.ZK16(JSECT+2)) ISEC = 2
C
C ---    "GROUP_MA" = TOUTES LES MAILLES POSSIBLES DE LA LISTE DES
C                                                    GROUPES DE MAILLES
         IF (NG.GT.0) THEN
            DO 40 I = 1 , NG
               CALL JEVEUO(JEXNOM(MLGGMA,ZK8(JDLS+I-1)),'L',JDGM)
               CALL JELIRA(JEXNOM(MLGGMA,ZK8(JDLS+I-1)),'LONUTI',
     &                                              NBMAGR,K1BID)
               DO 42 J = 1,NBMAGR
                  NUMMAI = ZI(JDGM+J-1)
                  CALL JENUNO(JEXNUM(MLGNMA,NUMMAI),NOMMAI)
                  NUTYEL = ZI(JDME+NUMMAI-1)
                  DO 44 K = 1 , NBTEL
                     IF (NUTYEL.EQ.NTYELE(K)) THEN
                        CALL AFFBAR(TMPGEN,TMPGEF,FCX,
     &                            NOMMAI,ISEC,ZK8(JCARA),
     &                            ZR(JVALE),ZK8(JEXP),NBO,KIOC,IER)
                        GOTO 42
                     ENDIF
 44               CONTINUE
                  VMESSK(1) = MCLF
                  VMESSK(2) = NOMMAI
                  CALL U2MESK('F','MODELISA_8',2,VMESSK)
 42            CONTINUE
 40         CONTINUE
         ENDIF
C
C ---    "MAILLE" = TOUTES LES MAILLES POSSIBLES DE LA LISTE DE MAILLES
         IF (NM.GT.0) THEN
            DO 50 I = 1 , NM
               NOMMAI = ZK8(JDLS+I-1)
               CALL JENONU(JEXNOM(MLGNMA,NOMMAI),NUMMAI)
               NUTYEL = ZI(JDME+NUMMAI-1)
               DO 52 J = 1 , NBTEL
                  IF (NUTYEL.EQ.NTYELE(J)) THEN
                     CALL AFFBAR(TMPGEN,TMPGEF,FCX,
     &                         NOMMAI,ISEC,ZK8(JCARA),
     &                         ZR(JVALE),ZK8(JEXP),NBO,KIOC,IER)
                     GOTO 50
                  ENDIF
 52            CONTINUE
               VMESSK(1) = MCLF
               VMESSK(2) = NOMMAI
               CALL U2MESK('F','MODELISA_8',2,VMESSK)
 50         CONTINUE
         ENDIF
C
 10   CONTINUE
      IF (IER.NE.0) THEN
         CALL U2MESS('F','MODELISA_7')
      ENDIF
C
      CALL JELIRA(TMPGEN,'NUTIOC',NBAAFF,K1BID)
C
C --- IMPRESSION DES VALEURS AFFECTEES DANS LE TAMPON SI DEMANDE
      IF (IVR(3).EQ.1) THEN
C ---    IMPRESSION DES DONNEES GENERALES
         WRITE(IFM,2000)
         DO 64 I = 1 , NBAAFF
            CALL JENUNO(JEXNUM(TMPGEN,I),NOMMAI)
            CALL JEVEUO(JEXNUM(TMPGEN,I),'L',JDGE)
            ISEC = NINT(ZR(JDGE+NBO-1))
            WRITE(IFM,2001)NOMMAI,ZR(JDGE),ISEC
 64      CONTINUE
C ---    IMPRESSION DES DONNEES GEOMETRIQUES
         IDW = 0
         DO 66 I = 1,NBAAFF
            CALL JENUNO(JEXNUM(TMPGEN,I),NOMMAI)
            CALL JEVEUO(JEXNUM(TMPGEN,I),'L',JDGE)
            ISEC = NINT(ZR(JDGE+NBO-1))
            IF (ISEC.EQ.1) THEN
               IF (IDW.EQ.0) THEN
                  WRITE(IFM,2010)
                  IDW = 1
               ENDIF
               WRITE(IFM,2012)NOMMAI,(ZR(JDGE+J-1),J=2,5),ISEC
            ELSEIF (ISEC.EQ.2) THEN
               IF (IDW.EQ.0) THEN
                  WRITE(IFM,2020)
                  IDW = 1
               ENDIF
               WRITE(IFM,2022)NOMMAI,(ZR(JDGE+J-1),J=6,7),ISEC
            ENDIF
            CALL JENUNO(JEXNUM(TMPGEF,I),NOMMAI)
            CALL JEVEUO(JEXNUM(TMPGEF,I),'L',JDGEF)
            WRITE(IFM,*) 'CX : ', ZK8(JDGEF)
 66      CONTINUE
      ENDIF
 2000   FORMAT(/,3X,
     &  '<SECTION> VALEURS DE TYPE GENERALE AFFECTEES AUX BARRES'
     &  ,//,3X,'MAILLE   A              TSEC')
 2001   FORMAT(3X,A8,1X,D11.5,1X,I6)
 2010   FORMAT(/,3X,
     &  '<SECTION> VALEURS DE TYPE GEOMETRIQUE AFFECTEES AUX BARRES'
     &  ,//,3X,'MAILLE   HY          HZ          EPY         EPZ',
     &                  '            TSEC')
 2012   FORMAT(3X,A8,1X,4(D11.5,1X),I6)
 2020   FORMAT(/,3X,
     &  '<SECTION> VALEURS DE TYPE GEOMETRIQUE AFFECTEES AUX BARRES'
     &  ,//,3X,'MAILLE   R           EP             TSEC')
 2022   FORMAT(3X,A8,1X,2(D11.5,1X),I6)
C
C --- ALLOCATION DES CARTES
      CALL ALCART('G',CARTBA,NOMA,'CAGNBA')
      CALL ALCART('G',CARTBG,NOMA,'CAGEBA')
      CALL JEVEUO(TMPNBA,'E',JDCBA)
      CALL JEVEUO(TMPVBA,'E',JDVBA)
      CALL JEVEUO(TMPNBG,'E',JDCBG)
      CALL JEVEUO(TMPVBG,'E',JDVBG)
      CALL JEVEUO(TMPNBF,'E',JDCBAF)
      CALL JEVEUO(TMPVBF,'E',JDVBAF)
C
C --- AFFECTATIONS DES DONNEES GENERALES
      ZK8(JDCBA) = ZK8(JTAB)
C     POUR LA CARTE DE VENT ==> FCXP
      ZK8(JDCBAF) = 'FCXP'
      DO 70 I = 1 , NBAAFF
         CALL JENUNO(JEXNUM(TMPGEN,I),NOMMAI)
         CALL JENONU(JEXNOM(MLGNMA,NOMMAI),NUMMAI)
         ZI(JDLM+NUMMAI-1) = -1
         CALL JEVEUO(JEXNUM(TMPGEN,I),'L',JDGE)
         ZR(JDVBA) = ZR(JDGE)
         CALL JEVEUO(JEXNUM(TMPGEF,I),'L',JDGEF)
         ZK8(JDVBAF) = ZK8(JDGEF)
         CALL NOCART(CARTBA,3,' ','NOM',1,NOMMAI,0,' ',1)
         CALL NOCART(CARTBF,3,' ','NOM',1,NOMMAI,0,' ',1)
 70   CONTINUE
C
C --- AFFECTATIONS DONNEES GEOMETRIQUES (ON AFFECTE TOUTES LES CMPS)
      DO 74 I = 1 , 6
         ZK8(JDCBG+I-1) = ZK8(JTAB+I)
 74   CONTINUE
      DO 76 J = 1 , NBAAFF
         CALL JENUNO(JEXNUM(TMPGEN,J),NOMMAI)
         CALL JEVEUO(JEXNUM(TMPGEN,J),'L',JDGE)
         ISEC = NINT(ZR(JDGE+NBO-1))
         IF (ISEC.EQ.0) THEN
C ---       GENERALE
            DO 78 I = 1 , 6
               ZR (JDVBG+I-1) = 0.D0
 78         CONTINUE
            CALL NOCART(CARTBG,3,' ','NOM',1,NOMMAI,0,' ',6)
         ELSE
C ---       RECTANGLE OU CERCLE
            DO 80 I = 1 , 6
               ZR (JDVBG+I-1) = ZR(JDGE+I)
 80         CONTINUE
            CALL NOCART(CARTBG,3,' ','NOM',1,NOMMAI,0,' ',6)
         ENDIF
 76   CONTINUE
C
C --- COMPACTAGE DES CARTES
C
C --- NETTOYAGE
      CALL JEDETR('&&ACEABA.BARRE')
      CALL JEDETR('&&ACEABA.TAB_PARA')
      CALL JEDETR('&&ACEABA.TYP_SECT')
      CALL JEDETR('&&ACEABA.EXPBAR')
      CALL JEDETR('&&ACEABA.TABBAR')
      CALL JEDETR('&&ACEABA.CARBAR')
      CALL JEDETR('&&ACEABA.CARA')
      CALL JEDETR('&&ACEABA.VALE')
      CALL JEDETR(TMPGEN)
      CALL JEDETR(TMPGEF)
      CALL JEDETR(TMPNBA)
      CALL JEDETR(TMPVBA)
      CALL JEDETR(TMPNBG)
      CALL JEDETR(TMPVBG)
C
      CALL JEDEMA()
      END
