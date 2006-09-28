      SUBROUTINE IRDECA(IFI,NBNO,PRNO,NUEQ,NEC,DG,NCMPMX,VALE,NOMGD,
     &              NCMPGD,NOMSYM,NUMNOE,LRESU,NBCPUT,NCMPUT,
     &              NIVE )
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER        IFI, NBNO, PRNO(*), NUEQ(*), NEC, DG(*),
     &               NCMPMX, NUMNOE(*), NBCPUT , NIVE
      REAL*8         VALE(*)
      CHARACTER*(*)  NOMGD, NCMPGD(*), NCMPUT(*)
      CHARACTER*(*)  NOMSYM
      LOGICAL        LRESU
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C--------------------------------------------------------------------
C        ECRITURE D'UN CHAM_NO SUR FICHIER CASTEM, DATASET TYPE 55
C        A VALEURS REELLES
C      ENTREE:
C         IFI   : UNITE LOGIQUE DU FICHIER CASTEM
C         NBNO  : NOMBRE DE NOEUDS DU MAILLAGE
C         PRNO  : OBJET .PRNO DU PROF_CHNO
C         NUEQ  : OBJET .NUEQ DU PROF_CHNO
C         NEC   : NOMBRE D'ENTIERS-CODES
C         DG    : ENTIERS CODES
C         NCMPMX: NOMBRE MAXI DE CMP DE LA GRANDEUR NOMGD
C         VALE  : VALEURS DU CHAM_NO
C         NOMGD : NOM DE LA GRANDEUR  DEPL_R, TEMP_R, SIEF_R, EPSI_R,...
C         NCMPGD: NOMS DES CMP DE LA GRANDEUR
C         NOMSYM: NOM SYMBOLIQUE
C         NUMNOE: NUMERO DES NOEUDS
C         LRESU : =.TRUE. IMPRESSION D4UN CONCEPT RESULTAT
C         NBCPUT: NOMBRE DE CMP DEMANDE PAR L'UTILISATEUR
C         NCMPUT: NOMS DES CMP DEMANDE PAR L'UTILISATEUR
C         NIVE  : NIVEAU IMPRESSION CASTEM 3 OU 10
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,EXISTE,EXISDG
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C     ------------------------------------------------------------------
      CHARACTER*8   NOMVAR(30)
      CHARACTER*8   BLANC,NOMCO
      INTEGER       NBCMP,IPCMP(30),IUTIL
      LOGICAL       LTABL(150)
C
C  --- INITIALISATIONS ----
C
      CALL JEMARQ()

      IF (NCMPMX.GT.150) CALL U2MESS('F','PREPOST2_18')
C
      IF (.NOT.LRESU) THEN
         CALL JEVEUO ( '&&OP0039.LAST', 'E', JLAST )
         INUM = ZI(JLAST-1+4) + 1
      ELSE
         INUM = 0
      ENDIF
      DO 1 I=1,NCMPMX
         LTABL(I)=.FALSE.
   1  CONTINUE
      IAD   = 1
      NBCMP = 0
      BLANC = '      '
C
C RECHERCHE DU NOMBRE DE SOUS OBJETS ET DES COMPOSANTES ASSOCIEES
C
      DO 2 INNO = 1,NBNO
        INO = NUMNOE(INNO)
        DO 3 IEC=1,NEC
          DG(IEC)=PRNO((INO-1)*(NEC+2)+2+IEC)
 3      CONTINUE
C
C        NCMP : NOMBRE DE CMPS SUR LE NOEUD INO
C        IVAL : ADRESSE DU DEBUT DU NOEUD INO DANS .NUEQ
C
        IVAL = PRNO((INO-1)* (NEC+2)+1)
        NCMP = PRNO((INO-1)* (NEC+2)+2)
        IF (NCMP.EQ.0) GO TO 2
C
        IF ( NBCPUT .NE. 0 ) THEN
          DO 30 ICM = 1,NBCPUT
            DO 32 ICMP = 1,NCMPMX
               IF ( NCMPUT(ICM) .EQ. NCMPGD(ICMP) ) THEN
                  LTABL(ICMP)= .TRUE.
                  GO TO 30
               ENDIF
  32        CONTINUE
            CALL UTDEBM('A','IRDECA',' ON NE TROUVE PAS LA COMPOSANTE')
            CALL UTIMPK('S',' ',1,NCMPUT(ICM))
            CALL UTIMPK('S',' DANS LA GRANDEUR ',1,NOMGD)
            CALL UTFINM
 30       CONTINUE
        ELSE
          DO 4 ICMP = 1,NCMPMX
             IF (EXISDG(DG,ICMP)) LTABL(ICMP)= .TRUE.
 4        CONTINUE
        ENDIF
 2    CONTINUE
C
      DO 5 I=1,NCMPMX
        IF (LTABL(I)) THEN
          IF(NCMPGD(I).EQ.'DX') THEN
           NBCMP = NBCMP+1
           NOMVAR(IAD)='UX'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSEIF(NCMPGD(I).EQ.'DY') THEN
           NBCMP= NBCMP+1
           NOMVAR(IAD)='UY'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSEIF(NCMPGD(I).EQ.'DZ') THEN
           NBCMP= NBCMP+1
           NOMVAR(IAD)='UZ'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSEIF(NCMPGD(I).EQ.'DRX') THEN
           NBCMP= NBCMP+1
           NOMVAR(IAD)='RX'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSEIF(NCMPGD(I).EQ.'DRY') THEN
           NBCMP= NBCMP+1
           NOMVAR(IAD)='RY'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSEIF(NCMPGD(I).EQ.'DRZ') THEN
           NBCMP= NBCMP+1
           NOMVAR(IAD)='RZ'
           IPCMP(IAD)= I
           IAD = IAD+1
          ELSE
           NBCMP = NBCMP+1
           NOMCO = NCMPGD(I)
           IUTIL = LXLGUT(NOMCO)
           IF(IUTIL.LE.4) THEN
             NOMVAR(IAD) = NOMCO
           ELSE
             NOMVAR(IAD) = NOMCO(1:2)
     &                   //NOMCO((IUTIL-1):IUTIL)
           ENDIF
           IPCMP(IAD)= I
           IAD = IAD+1
          ENDIF
        ENDIF
  5   CONTINUE
C
C ---- ECRITURE DE L'EN-TETE -----
C
      IBID  = 2
      IUN   = 1
      IZERO = 0
      WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
      IF (LRESU) THEN
        IF(NIVE.EQ.3) THEN
         WRITE (IFI,'(A,I4,A,I5,A,I5)')  ' PILE NUMERO',IBID,
     &   'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
        ELSE IF (NIVE.EQ.10) THEN
         WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',IBID,
     &   'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
        ENDIF
      ELSE
       IF (NIVE.EQ.3) THEN
        WRITE (IFI,'(A,I4,A,I5,A,I5)')  ' PILE NUMERO',IBID,
     &   'NBRE OBJETS NOMMES',IUN,'NBRE OBJETS',IUN
       ELSE IF (NIVE.EQ.10) THEN
        WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',IBID,
     &   'NBRE OBJETS NOMMES',IUN,'NBRE OBJETS',IUN
       ENDIF
C ECRITURE DES OBJETS NOMMES
        WRITE(IFI,'(1X,A8)') NOMSYM
        IF (NIVE.EQ.3) WRITE(IFI,'(I5)') INUM
        IF (NIVE.EQ.10) WRITE(IFI,'(I8)') INUM
      ENDIF
C
      IF (NIVE.EQ.3) WRITE(IFI,'(I5,I5,I5)') IUN,NBCMP,IBID
      IF (NIVE.EQ.10) WRITE(IFI,'(I8,I8,I8,I8)') IUN,NBCMP,IBID,IUN
      CALL WKVECT('&&IRDECA.BID','V V I',NCMPMX,IBI)
      CALL WKVECT('&&IRDECA.NOM','V V K8',NBCMP,INOM)
      IF(NIVE.EQ.3)  WRITE(IFI,'(16(I5))') IUN,NBNO,NBCMP
      IF(NIVE.EQ.10)  WRITE(IFI,'(10(I8))') IUN,NBNO,NBCMP
      IZERO = 0
      DO 10 I=1,NBCMP
       ZI(IBI-1+I) = IZERO
       ZK8(INOM-1+I) = NOMVAR(I)
 10   CONTINUE
      WRITE(IFI,'(16(1X,A4))') (ZK8(INOM-1+I)(1:4),I=1,NBCMP)
      IF (NIVE.EQ.3) WRITE(IFI,'(16(I5))') (ZI(IBI-1+I),I=1,NBCMP)
      IF (NIVE.EQ.10) WRITE(IFI,'(10(I8))') (ZI(IBI-1+I),I=1,NBCMP)
      IF (LRESU) THEN
        WRITE(IFI,'(1X,A71)') NOMSYM
      ELSE
        WRITE(IFI,'(1X,A71)') NOMGD
      ENDIF
      WRITE(IFI,'(1X,A)') BLANC
      IF (NIVE.EQ.10) WRITE(IFI, '(I8)') IZERO

C --- ALLOCATION DES TABLEAUX DE TRAVAIL ---
C
      CALL WKVECT('&&IRDECA.VALE','V V R',NCMPMX*NBNO,IRVAL)
C
C ---- BOUCLE SUR LES DIVERSES GRANDEURS CASTEM ----
      DO 25 IC = 1,NCMPMX*NBNO
        ZR(IRVAL-1+IC) = 0.0D0
   25 CONTINUE
      IADR = IRVAL - 1
      DO 12 INNO = 1,NBNO
        INO = NUMNOE(INNO)
        DO 17 IEC=1,NEC
          DG(IEC)=PRNO((INO-1)*(NEC+2)+2+IEC)
  17    CONTINUE
        IVAL = PRNO((INO-1)* (NEC+2)+1)
        NCMP = PRNO((INO-1)* (NEC+2)+2)
        IF (NCMP.EQ.0) GO TO 12
C
        ICOMPT = 0
        DO 14 ICMP =1,NCMPMX
          IF (EXISDG(DG,ICMP)) THEN
            ICOMPT = ICOMPT+1
            DO 13 ICMC=1,NBCMP
             ICMCCA = IPCMP (ICMC)
             IF(ICMP.EQ.ICMCCA) THEN
              IADR = IRVAL-1+(ICMC-1)*NBNO
              ZR(IADR+INO) = VALE(NUEQ(IVAL-1+ICOMPT))
              GO TO 14
             ENDIF
   13       CONTINUE
          ENDIF
   14   CONTINUE
   12 CONTINUE
      WRITE(IFI,'(3(1X,E21.13E3))') (ZR(IRVAL-1+I),I=1,NBCMP*NBNO)
      IF(.NOT.LRESU) ZI(JLAST-1+4)=INUM
      CALL JEDETR('&&IRDECA.VALE')
      CALL JEDETR('&&IRDECA.BID')
      CALL JEDETR('&&IRDECA.NOM')
      CALL JEDEMA()
      END
