      SUBROUTINE IRDEPL(CHAMNO,PARTIE,IFI,FORM,TITRE,NOMSD,NOMSYM,
     &             NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,
     &             LCOR,NBNOT,NUMNOE,NBCMP,NOMCMP,
     &             LSUP,BORSUP,LINF,BORINF,LMAX,LMIN,LRESU, FORMR,
     &             NIVE )
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*(*)     CHAMNO,    FORM,TITRE,NOMSD,NOMSYM
      CHARACTER*(*)            NOMCMP(*), FORMR, PARTIE
      INTEGER      NBNOT,IFI,NUMNOE(*),NBCMP,NIVE
      INTEGER      NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM
      LOGICAL      LCOR,                                    LCHAM1
      LOGICAL      LSUP,       LINF,       LMAX,LMIN
      LOGICAL                                         LRESU
      REAL*8            BORSUP,     BORINF
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 21/06/2010   AUTEUR MACOCCO K.MACOCCO 
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
C TOLE CRP_21
C        IMPRESSION D'UN CHAMNO A COMPOSANTES REELLES OU COMPLEXES
C         AU FORMAT IDEAS, ENSIGHT, ...
C     ENTREES:
C        CHAMNO : NOM DU CHAMNO A ECRIRE
C        PARTIE : IMPRESSION DE LA PARTIE COMPLEXE OU REELLE DU CHAMP
C        IFI    : NUMERO LOGIQUE DU FICHIER DE SORTIE
C        FORM   : FORMAT DES SORTIES: IDEAS, ENSIGHT, RESULTAT
C        TITRE  : TITRE POUR IMPRESSION IDEAS OU ENSIGHT
C        NOMSD  : NOM DU RESULTAT D'OU PROVIENT LE CHAMNO A IMPRIMER.
C        NOMSYM : NOM SYMBOLIQUE
C        NUMORD : NUMERO DE CALCUL, MODE,  CAS DE CHARGE
C        NUORD1 : NUMERO DU PREMIER DES NUMEROS D'ORDRE A IMPRIMER
C                 (POUR FORMAT 'ENSIGHT')
C        NORDEN : NOMBRE DE NUMEROS D'ORDRE A IMPRIMER
C                 (POUR FORMAT 'ENSIGHT')
C        IORDEN : INDICE DE NUMORD DANS LA LISTE DES NUMEROS D'ORDRE
C                 A IMPRIMER (POUR FORMAT 'ENSIGHT')
C        NBCHAM : NOMBRE DE CHAMPS A IMPRIMER (POUR FORMAT 'ENSIGHT')
C        ICHAM  : INDICE DU CHAMP DANS LA LISTE DES CHAMPS A IMPRIMER
C                 (POUR FORMAT 'ENSIGHT')
C        LCHAM1 : INDIQUE SI LE CHAMP EST LE PREMIER DES CHAMPS
C                 A IMPRIMER POUR LE NUMERO D'ORDRE NUMORD
C                 (POUR FORMAT 'ENSIGHT')
C        LCOR   : IMPRESSION DES COORDONNEES  .TRUE. IMPRESSION
C        NBNOT  : NOMBRE DE NOEUDS A IMPRIMER
C        NUMNOE : NUMEROS DES NOEUDS A IMPRIMER
C        NBCMP  : NOMBRE DE COMPOSANTES A IMPRIMER AU FORMAT RESULTAT
C        NOMCMP : NOMS DES COMPOSANTES A IMPRIMER AU FORMAT RESULTAT
C        LSUP   : =.TRUE. INDIQUE PRESENCE D'UNE BORNE SUPERIEURE
C        BORSUP : VALEUR DE LA BORNE SUPERIEURE
C        LINF   : =.TRUE. INDIQUE PRESENCE D'UNE BORNE INFERIEURE
C        BORINF : VALEUR DE LA BORNE INFERIEURE
C        LMAX   : =.TRUE. INDIQUE IMPRESSION VALEUR MAXIMALE
C        LMIN   : =.TRUE. INDIQUE IMPRESSION VALEUR MINIMALE
C        LRESU  : =.TRUE. INDIQUE IMPRESSION D'UN CONCEPT RESULTAT
C        FORMR  : FORMAT D'ECRITURE DES REELS SUR "RESULTAT"
C        NIVE   : NIVEAI IMPRESSION CASTEM 3 OU 10
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER      ZI
      REAL*8       ZR
      COMPLEX*16   ZC
      LOGICAL      ZL,EXISDG
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM,JEXATR
      CHARACTER*80 ZK80
C     ------------------------------------------------------------------
C
      CHARACTER*1  K1BID, TYPE 
      INTEGER      GD,DATE(9),IMODE,LGCH16,LGCONC,LGNMA1,LGNMA2
      INTEGER      IFIEN1   ,IFIEN2   ,IFIEN3
      PARAMETER   (IFIEN1=31,IFIEN2=32,IFIEN3=33)
      INTEGER      JVALE,NUTI
      LOGICAL      LMAYAE,LMASU,EXIFAV
      CHARACTER*8  NOMSDR,NOMMA,NOMACM,NOMGD,CBID,FORMA,FORMCM
      CHARACTER*16 NOMCMD,TSD,NOSY16
      CHARACTER*19 CHAMN
      CHARACTER*24 NOMNU,NOLILI
      CHARACTER*24 FICH
      CHARACTER*24 VALK(4)
      CHARACTER*80 TITMAI,BIDON
      REAL*8       FREQ
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CHAMN  = CHAMNO(1:19)
      FORMA  = FORM
      NOSY16 = NOMSYM
      NBCMPT=0
      CALL JEVEUO(CHAMN//'.REFE','L',IAREFE)
C     --- NOM DU MAILLAGE
      NOMMA = ZK24(IAREFE-1+1) (1:8)
C     --- NOM DU PROFIL AUX NOEUDS ASSOCIE S'IL EXISTE
      NOMNU = ZK24(IAREFE-1+2)
C
      CALL JELIRA(CHAMN//'.VALE','TYPE',IBID,TYPE)
      IF (TYPE(1:1).EQ.'R') THEN
          ITYPE = 1
      ELSE IF (TYPE(1:1).EQ.'C') THEN
          ITYPE = 2
      ELSE IF (TYPE(1:1).EQ.'I') THEN
          ITYPE = 3
      ELSE IF (TYPE(1:1).EQ.'K') THEN
          ITYPE = 4
      ELSE 
          CALL GETRES(CBID,CBID,NOMCMD)
          CALL U2MESK('A','PREPOST_97',1,TYPE(1:1))
          GOTO 9999
      END IF
C
      CALL JEVEUO(CHAMN//'.VALE','L',IAVALE)
C
      CALL JEVEUO(CHAMN//'.DESC','L',IADESC)
      GD = ZI(IADESC-1+1)
      NUM = ZI(IADESC-1+2)
C
      CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',GD),NOMGD)
C
C     --- NOMBRE D'ENTIERS CODES POUR LA GRANDEUR NOMGD
      NEC = NBEC(GD)
C
      CALL JEEXIN('&&IRDEPL.ENT_COD',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&IRDEPL.ENT_COD')
      CALL WKVECT('&&IRDEPL.ENT_COD','V V I',NEC,IAEC)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,K1BID)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',IAD)
      CALL WKVECT('&&IRDEPL.NUM_CMP','V V I',NCMPMX,JNCMP)
C
      IF(NBCMP.NE.0) THEN
C       - NOMBRE ET NOMS DES COMPOSANTES DE LA LISTE DES COMPOSANTES
C         DONT ON DEMANDE L'IMPRESSION PRESENTES DANS LA GRANDEUR NOMGD
        CALL IRCCMP(' ',NOMGD,NCMPMX,ZK8(IAD),NBCMP,NOMCMP,NBCMPT,JNCMP)
C       - SI SELECTION SUR LES COMPOSANTES ET AUCUNE PRESENTE DANS LE
C       - CHAMP A IMPRIMER ALORS IL N'Y A RIEN A FAIRE
        IF (NBCMPT.EQ.0) GO TO 9997
      ENDIF
C
C     --- SI LE CHAMP EST A REPRESENTATION CONSTANTE: RIEN DE SPECIAL
C
C     --- SI LE CHAMP EST DECRIT PAR UN "PRNO":
      IF(NUM.GE.0) THEN
        CALL JEVEUO(NOMNU(1:19)//'.NUEQ','L',IANUEQ)
        CALL JENONU(JEXNOM(NOMNU(1:19)//'.LILI','&MAILLA'),IBID)
        CALL JEVEUO(JEXNUM(NOMNU(1:19)//'.PRNO',IBID),'L',IAPRNO)
      ENDIF
C
C     --- NOMBRE DE NOEUDS DU MAILLAGE: NBNO
      CALL DISMOI('F','NB_NO_MAILLA',NOMMA,'MAILLAGE',NBNO,CBID,IER)

C     --- CREATION LISTES DES NOMS ET DES NUMEROS DES NOEUDS A IMPRIMER
      CALL WKVECT('&&IRDEPL.NOMNOE','V V K8',NBNO,JNO)
      CALL WKVECT('&&IRDEPL.NUMNOE','V V I',NBNO,JNU)
      IF( NBNOT .EQ. 0 ) THEN
C       - IL N'Y A PAS EU DE SELECTION SUR ENTITES TOPOLOGIQUES EN
C         OPERANDE DE IMPR_RESU => ON PREND TOUS LES NOEUDS DU MAILLAGE
        DO 11 INO = 1,NBNO
          CALL JENUNO(JEXNUM(NOMMA//'.NOMNOE',INO),ZK8(JNO-1+INO))
          ZI(JNU-1+INO)  = INO
          NBNOT2= NBNO
   11   CONTINUE
C
      ELSE
C       - IL Y A EU SELECTION SUR DES ENTITES TOPOLOGIQUES => ON NE
C         PREND QUE LES NOEUDS DEMANDES (APPARTENANT A UNE LISTE DE
C         NOEUDS, DE MAILLES, DE GPES DE NOEUDS OU DE GPES DE MAILLES)
        DO 12 INO=1,NBNOT
          ZI(JNU-1+INO) = NUMNOE(INO)
          CALL JENUNO(JEXNUM(NOMMA//'.NOMNOE',NUMNOE(INO)),
     &                                                  ZK8(JNO-1+INO))
   12   CONTINUE
        NBNOT2= NBNOT
      ENDIF
C --- RECHERCHE DES COORDONNEES ET DE LA DIMENSION -----
      IF (LCOR) THEN
        CALL DISMOI('F','DIM_GEOM_B',NOMMA,'MAILLAGE',NDIM,CBID,IER)
C	
        CALL JEVEUO(NOMMA//'.COORDO    .VALE','L',JCOOR)
      ENDIF
C
      IF (FORM.EQ.'RESULTAT') THEN
        IF (ITYPE.EQ.1.AND.NUM.GE.0) THEN
          CALL IRCNRL(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),ZK8(IAD),ZK8(JNO),LCOR,NDIM,ZR(JCOOR),
     &       ZI(JNU),NBCMPT,ZI(JNCMP),LSUP,BORSUP,LINF,BORINF,LMAX,
     &       LMIN,FORMR)
        ELSEIF (ITYPE.EQ.1.AND.NUM.LT.0) THEN
          CALL IRCRRL(IFI,NBNOT2,ZI(IADESC),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),ZK8(IAD),ZK8(JNO),LCOR,NDIM,ZR(JCOOR),
     &       ZI(JNU),NBCMPT,ZI(JNCMP),LSUP,BORSUP,LINF,BORINF,LMAX,
     &       LMIN,FORMR)
        ELSE IF (ITYPE.EQ.2.AND.NUM.GE.0) THEN
          CALL IRCNC8(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZC(IAVALE),ZK8(IAD),ZK8(JNO),LCOR,NDIM,ZR(JCOOR),
     &       ZI(JNU),NBCMPT,ZI(JNCMP),LSUP,BORSUP,LINF,BORINF,LMAX,
     &       LMIN,FORMR)
        ELSE IF (ITYPE.EQ.2.AND.NUM.LT.0) THEN
          CALL U2MESK('E','PREPOST2_35',1,FORMA)
        ELSE IF ((ITYPE.EQ.3).OR.(ITYPE.EQ.4)) THEN  
          CALL IMPRSD('CHAMP',CHAMNO,IFI,NOMSD) 
        END IF
C
      ELSE IF (FORM(1:6).EQ.'CASTEM') THEN
C
C ------ AU FORMAT CASTEM, PAS DE MINUSCULES
C        LE NOM DU CHAM_GD EST DANS LA VARIABLE NOMSYM
        IF ( .NOT. LRESU )  CALL LXCAPS ( NOSY16 )
C
        IF (ITYPE.EQ.1.AND.NUM.GE.0) THEN
          CALL IRDECA(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),NOMGD,ZK8(IAD),NOSY16,ZI(JNU),
     &       LRESU,NBCMP,NOMCMP,NIVE)
        ELSEIF (ITYPE.EQ.1.AND.NUM.LT.0) THEN
          CALL IRDRCA(IFI,NBNOT2,ZI(IADESC),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),NOMGD,ZK8(IAD),NOSY16,ZI(JNU),
     &       LRESU,NBCMP,NOMCMP,NIVE)
        ELSEIF (ITYPE.EQ.2.AND.NUM.GE.0) THEN
          CALL JELIRA(CHAMN//'.VALE','LONUTI',NUTI,K1BID)
          CALL WKVECT('&&IRDEPL.VALE','V V R',NUTI,JVALE)
C
          IF ( PARTIE.EQ.'REEL') THEN
            DO 10 I=1,NUTI
              ZR(JVALE-1+I)=DBLE(ZC(IAVALE-1+I))
  10        CONTINUE
          ELSE IF (PARTIE.EQ.'IMAG') THEN
            DO 20 I=1,NUTI
              ZR(JVALE-1+I)=DIMAG(ZC(IAVALE-1+I))
  20        CONTINUE
          ELSE
            CALL U2MESS('F','PREPOST2_4')
          ENDIF
          CALL IRDECA(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZR(JVALE),NOMGD,ZK8(IAD),NOSY16,ZI(JNU),
     &       LRESU,NBCMP,NOMCMP,NIVE)
        ELSE
           VALK(1) = CHAMN
           VALK(2) = FORMA
           CALL U2MESK('E','PREPOST2_36', 2 ,VALK)
        END IF
C
      ELSE IF (FORM(1:5).EQ.'IDEAS') THEN
C  ---  ON CHERCHE SI MAILLAGE IDEAS ---
        LMASU=.FALSE.
        CALL JEEXIN(NOMMA//'           .TITR',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(NOMMA//'           .TITR','L',JTITR)
          CALL JELIRA(NOMMA//'           .TITR','LONMAX',NBTITR,K1BID)
          IF(NBTITR.GE.1) THEN
            TITMAI=ZK80(JTITR-1+1)
            IF(TITMAI(10:31).EQ.'AUTEUR=INTERFACE_IDEAS') THEN
              LMASU=.TRUE.
            ENDIF
          ENDIF
        ENDIF
C
        IF (ITYPE.EQ.1.AND.NUM.GE.0) THEN
          CALL IRDESR(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),ZK8(IAD),TITRE,ZK8(JNO),NOMSD,
     &       NOMSYM,NUMORD,ZI(JNU),LMASU,NBCMP,ZI(JNCMP),NOMCMP)
        ELSEIF (ITYPE.EQ.1.AND.NUM.LT.0) THEN
          CALL IRDRSR(IFI,NBNOT2,ZI(IADESC),NEC,ZI(IAEC),
     &       NCMPMX,ZR(IAVALE),ZK8(IAD),TITRE,ZK8(JNO),NOMSD,
     &       NOMSYM,NUMORD,ZI(JNU),LMASU,NBCMP,ZI(JNCMP),NOMCMP)
        ELSE IF (ITYPE.EQ.2.AND.NUM.GE.0) THEN
          CALL IRDESC(IFI,NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &       NCMPMX,ZC(IAVALE),ZK8(IAD),TITRE,ZK8(JNO),NOMSD,
     &       NOMSYM,NUMORD,ZI(JNU),LMASU)
        ELSE IF (ITYPE.EQ.2.AND.NUM.LT.0) THEN
          CALL U2MESK('E','PREPOST2_35',1,FORMA)
        END IF
C
      ELSE IF (FORM(1:7).EQ.'ENSIGHT') THEN
C       - AU FORMAT 'ENSIGHT' ON VERIFIE LA COHERENCE ENTRE LE
C         NOM DU MAILLAGE AUQUEL EST ASSOCIE LE CHAM_NO ET LE NOM DU
C         MAILLAGE DONT ON DEMANDE L'IMPRESSION.
        LMAYAE=.FALSE.
        CALL GETRES(CBID,CBID,NOMCMD)
        CALL GETFAC('RESU',NOCC)
        DO 14 IOCC=1,NOCC
          CALL GETVID('RESU','MAILLAGE',IOCC,1,1,NOMACM,NM)
          IF(NM.NE.0) CALL GETVTX(' ','FORMAT',1,1,1,FORMCM,N)
          IF(FORMCM(1:7).EQ.'ENSIGHT') THEN
            LMAYAE=.TRUE.
            GO TO 15
          ENDIF
  14    CONTINUE
  15    CONTINUE
        IF(LMAYAE.AND.(NOMACM.NE.NOMMA)) THEN
          LGCH16=LXLGUT(NOSY16)
          LGNMA1=LXLGUT(NOMMA)
          LGNMA2=LXLGUT(NOMACM)
          IF(.NOT.LRESU) THEN
             VALK(1) = NOMMA(1:LGNMA1)
             VALK(2) = NOSY16(1:LGCH16)
             VALK(3) = NOMACM(1:LGNMA2)
             CALL U2MESK('A','PREPOST2_37', 3 ,VALK)
          ELSE
            NOMSDR=NOMSD
            LGCONC=LXLGUT(NOMSDR)
             VALK(1) = NOMMA(1:LGNMA1)
             VALK(2) = NOSY16(1:LGCH16)
             VALK(3) = NOMSDR(1:LGCONC)
             VALK(4) = NOMACM(1:LGNMA2)
             CALL U2MESK('A','PREPOST2_38', 4 ,VALK)
          ENDIF
        ENDIF
        FICH='./RESU_ENSIGHT/lisez-moi'
        INQUIRE(FILE=FICH,ERR=16,IOSTAT=IOS1,EXIST=EXIFAV)
  16    CONTINUE
        IF((IOS1.EQ.0).AND.(.NOT.EXIFAV)) THEN
          OPEN(UNIT=IFIEN1,ERR=17,STATUS='NEW',FILE=FICH,IOSTAT=IOS2)
  17      CONTINUE
          IF(IOS2.EQ.0) THEN
            WRITE(IFIEN1,'(A)') '********** AVERTISSEMENT **********'
            WRITE(IFIEN1,'(A)') ' '
            WRITE(IFIEN1,'(A)') ' VERIFIEZ QUE LE MAILLAGE QUI A ETE'//
     &           ' IMPRIME (FICHIER ".geo") ET'
            WRITE(IFIEN1,'(A)') ' LE MAILLAGE ASSOCIE AUX CHAMPS DE'//
     &           'GRANDEURS SONT IDENTIQUES.'
            WRITE(IFIEN1,'(A)') ' '
            WRITE(IFIEN1,'(A)') ' SI CE N''EST PAS LE CAS IL PEUT Y'//
     &           ' AVOIR INCOHERENCE POUR EnSight'
            WRITE(IFIEN1,'(A)') ' ENTRE LE FICHIER DE GEOMETRIE ET'//
     &           ' LES FICHIERS DE VALEURS.'
            IF(LMAYAE.AND.(NOMACM.NE.NOMMA)) THEN
              WRITE(IFIEN1,'(A)') ' '
              WRITE(IFIEN1,'(A)') ' **********************************'
              IF(.NOT.LRESU) THEN
                WRITE(IFIEN1,'(A)') ' ICI, PAR EXEMPLE, LE MAILLAGE '//
     &                NOMMA(1:LGNMA1)//' ASSOCIE AU CHAM_GD '//
     &                NOSY16(1:LGCH16)
                WRITE(IFIEN1,'(A)') ' DIFFERE DU MAILLAGE '//
     &               NOMACM(1:LGNMA2)//' DONNE EN OPERANDE DE LA'//
     &               ' COMMANDE !! ATTENTION !!'
              ELSE
                NOMSDR=NOMSD
                WRITE(IFIEN1,'(A)') ' ICI, PAR EXEMPLE, LE MAILLAGE '//
     &               NOMMA(1:LGNMA1)//' ASSOCIE AU CHAMP '//
     &               NOSY16(1:LGCH16)//' DU CONCEPT '//NOMSDR(1:LGCONC)
                WRITE(IFIEN1,'(A)') ' DIFFERE DU MAILLAGE '//
     &               NOMACM(1:LGNMA2)//' DONNE EN OPERANDE DE LA'//
     &               ' COMMANDE !! ATTENTION !!'
              ENDIF
            ENDIF
            CLOSE(IFIEN1)
          ELSE
            GO TO 99
          ENDIF
        ENDIF
C
        IF (ITYPE.EQ.1.AND.NUM.GE.0) THEN
          CALL IRDEER(IFIEN1,IFIEN2,
     &          NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &          NCMPMX,NBCMPT,ZI(JNCMP),
     &          ZR(IAVALE),NOMGD,ZK8(IAD),NOMSD,NOMSYM,
     &          NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,LRESU)
        ELSEIF (ITYPE.EQ.1.AND.NUM.LT.0) THEN
          CALL IRDRER(IFIEN1,IFIEN2,
     &          NBNOT2,ZI(IADESC),NEC,ZI(IAEC),
     &          NCMPMX,NBCMPT,ZI(JNCMP),
     &          ZR(IAVALE),NOMGD,ZK8(IAD),NOMSD,NOMSYM,
     &          NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,LRESU)
        ELSEIF (ITYPE.EQ.2.AND.NUM.GE.0) THEN
          CALL IRDEEC(IFIEN1,IFIEN2,IFIEN3,
     &          NBNOT2,ZI(IAPRNO),ZI(IANUEQ),NEC,ZI(IAEC),
     &          NCMPMX,NBCMPT,ZI(JNCMP),
     &          ZC(IAVALE),NOMGD,ZK8(IAD),NOMSD,NOMSYM,
     &          NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,LRESU)
        ELSEIF (ITYPE.EQ.2.AND.NUM.LT.0) THEN
          CALL IRDREC(IFIEN1,IFIEN2,IFIEN3,
     &          NBNOT2,ZI(IADESC),NEC,ZI(IAEC),
     &          NCMPMX,NBCMPT,ZI(JNCMP),
     &          ZC(IAVALE),NOMGD,ZK8(IAD),NOMSD,NOMSYM,
     &          NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,LRESU)
        ENDIF
      ENDIF
      GOTO 9998
 99   CONTINUE
      CALL U2MESK('E','PREPOST2_39',1,FICH)
      GOTO 9998
 9997 CONTINUE
      LGCH16=LXLGUT(NOSY16)
      IF(.NOT.LRESU) THEN
          VALK(1) = NOSY16(1:LGCH16)
          VALK(2) = NOMGD
          CALL U2MESK('A','PREPOST2_40', 2 ,VALK)
      ELSE
         NOMSDR=NOMSD
         LGCONC=LXLGUT(NOMSDR)
          VALK(1) = NOSY16(1:LGCH16)
          VALK(2) = NOMSDR(1:LGCONC)
          VALK(3) = NOMGD
          CALL U2MESK('A','PREPOST2_41', 3 ,VALK)
      ENDIF
 9998 CONTINUE
      CALL JEDETR('&&IRDEPL.ENT_COD')
      CALL JEDETR('&&IRDEPL.NUM_CMP')
      CALL JEDETR('&&IRDEPL.NOMNOE')
      CALL JEDETR('&&IRDEPL.NUMNOE')
      CALL JEDETR('&&IRDEPL.VALE')
 9999 CONTINUE
      CALL JEDEMA()
      END
