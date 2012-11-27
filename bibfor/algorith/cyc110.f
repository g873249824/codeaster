      SUBROUTINE CYC110 ( NOMRES, MAILLA, NBSECT )
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      IMPLICIT NONE
C-----------------------------------------------------------------------
C MODIF ALGORITH  DATE 27/11/2012   AUTEUR BERRO H.BERRO 
C
C  BUT:  CREATION D'UN MAILLAGE SQUELETTE POUR LA SOUS-STRUCTURATION
C        CYCLIQUE
C
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UT DU RESULTAT OPERATEUR COURANT
C NOMA    /I/: NOM DU MAILLAGE
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
C
C
      INTEGER      LIGNE(2)
      REAL*8       DEPI,R8DEPI
      CHARACTER*3  KNUSEC
      CHARACTER*6  KCHIFF
      CHARACTER*8  K8BID,NOMRES,MAILLA,GRMCOU,NOMCOU
      CHARACTER*16 MCGRM,MOTFAC,MCMAIL
      INTEGER      IARG
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,IATYMA ,IBID ,ICOMP ,IGD ,IOCTOU ,IRET
      INTEGER ITCON ,J ,K ,LDCONE ,LDCOO ,LDDESC ,LDDIME
      INTEGER LDGRMA ,LDREF ,LDSKIN ,LDTYP ,LLCONA ,LLCOO ,LLCOX
      INTEGER LLTITR ,LLTYP ,LTNMGR ,LTNMMA ,LTNUMA ,LTNUNO ,NBCON
      INTEGER NBGR ,NBID ,NBMA ,NBMATO ,NBNO ,NBNOTO ,NBSECT
      INTEGER NBSKMA ,NBSKNO ,NBTEMP ,NBTOUT ,NBUF ,NTACON ,NTEMNA
      INTEGER NTEMNO ,NUMA ,NUMMA ,NUMNO ,NUNEW
      REAL*8 TETA ,TETSEC ,XANC ,XNEW ,YANC ,YNEW ,ZANC
      REAL*8 ZNEW
C-----------------------------------------------------------------------
      CALL JEMARQ()
      DEPI = R8DEPI()
C
C
C--------------INITIALISATION DES DIVERS MOTS-CLE FACTEUR---------------
C
      MOTFAC = 'SECTEUR'
      MCMAIL = 'MAILLE'
      MCGRM  = 'GROUP_MA'
C
C-------TRAITEMENT DES MAILLES DONNEES EN ENTREE------------------------
C
      NBMA = 0
      LTNMMA = 1
      CALL GETVTX ( MOTFAC, MCMAIL, 1,IARG,0, K8BID, NBMA )
      IF (NBMA.LT.0) THEN
        NBMA = -NBMA
        CALL WKVECT('&&CYC110.NOM.MA','V V K8',NBMA,LTNMMA)
        CALL GETVTX(MOTFAC,MCMAIL,1,IARG,NBMA,ZK8(LTNMMA),NBID)
      END IF
C
C-------TRAITEMENT DES GROUPES DE MAILLES EN ENTREE---------------------
C
      NBUF = 0
      LTNMGR = 1
      CALL GETVTX ( MOTFAC, MCGRM, 1,IARG,0, K8BID, NBGR )
      IF (NBGR.LT.0) THEN
        NBGR = -NBGR
        CALL WKVECT('&&CYC110.NOM.GRMA','V V K8',NBGR,LTNMGR)
        CALL GETVTX(MOTFAC,MCGRM,1,IARG,NBGR,ZK8(LTNMGR),NBID)
        CALL COMPMA(MAILLA,NBGR,ZK8(LTNMGR),NBUF)
      END IF
C
C-----------CAS DE LA RESTITUTION DU MAILLAGE EN ENTIER-----------------
C
      CALL GETVTX ( MOTFAC, 'TOUT', 1,IARG,0, K8BID, IOCTOU )
      IF (IOCTOU.LT.0) THEN
        IOCTOU = 1
        CALL DISMOI('F','NB_MA_MAILLA',MAILLA,'MAILLAGE',NBTOUT,K8BID,
     &              IRET)
      END IF
C
C----------NOMBRE DE MAILLES (AVEC REPETITION EVENTUELLE)---------------
C
      IF (IOCTOU.EQ.1) THEN
        NBSKMA = NBTOUT
      ELSE
        NBSKMA = NBMA + NBUF
      END IF
C
C--------ALLOCATION DU VECTEUR DES NUMERO DE MAILLES--------------------
C
      CALL WKVECT('&&CYC110.NUM.SK.MAIL','V V I',NBSKMA,LTNUMA)
C
C
C-------RECUPERATION NUMERO DES MAILLES DONNEES EN ARGUMENTS------------
C
      IF (IOCTOU.EQ.1) THEN
        DO 5 I = 1,NBTOUT
          ZI(LTNUMA+I-1) = I
    5   CONTINUE
      ELSE
        CALL RECUMA(MAILLA,NBMA,NBGR,ZK8(LTNMMA),ZK8(LTNMGR),NBSKMA,
     &              ZI(LTNUMA))
      END IF
C
C----------------DESTRUCTION DES OBJETS CADUQUES------------------------
C
      IF (NBGR.GT.0) CALL JEDETR('&&CYC110.NOM.GRMA')
      IF (NBMA.GT.0) CALL JEDETR('&&CYC110.NOM.MA')
C
C-----------------------SUPPRESSION DES DOUBLES-------------------------
C
      IF (NBSKMA.NE.0) CALL UTTRII(ZI(LTNUMA),NBSKMA)
C
C-----------RECUPERATION DU NOMBRE A LA LOUCHE DES NOEUDS---------------
C
      NBTEMP = 0
      DO 10 I = 1,NBSKMA
        NUMA = ZI(LTNUMA+I-1)
        CALL JELIRA(JEXNUM(MAILLA//'.CONNEX',NUMA),'LONMAX',NBNO,K8BID)
        NBTEMP = NBTEMP + NBNO
   10 CONTINUE
C
      NBSKNO = NBTEMP
      NTACON = NBTEMP
C
C
C---------ALLOCATION DU VECTEUR TEMPORAIRE DES NUMEROS DE NOEUDS--------
C
      CALL WKVECT('&&CYC110.NUM.SK.NOE','V V I',NBSKNO,LTNUNO)
C
C----------RECUPERATION DES NUMEROS DES NOEUDS--------------------------
C
      ICOMP = 0
      DO 20 I = 1,NBSKMA
        NUMA = ZI(LTNUMA+I-1)
        CALL JELIRA(JEXNUM(MAILLA//'.CONNEX',NUMA),'LONMAX',NBNO,K8BID)
        CALL JEVEUO(JEXNUM(MAILLA//'.CONNEX',NUMA),'L',LLCOX)
        DO 30 J = 1,NBNO
          ICOMP = ICOMP + 1
          ZI(LTNUNO+ICOMP-1) = ZI(LLCOX+J-1)
   30   CONTINUE

   20 CONTINUE
C
C
C------------------------SUPPRESSION DES DOUBLES------------------------
C
      IF (NBSKNO.NE.0) CALL UTTRII(ZI(LTNUNO),NBSKNO)
C
C----------------RECUPERATION DU NOMBRE DE SECTEURS---------------------
C           ET CALCUL TAILLE CONNECTIVITE TOTALE
C
C
      NTACON = NTACON*NBSECT
C
C
C---------------DETERMINATION DU NOMBRE DE NOEUDS TOTAL-----------------
C                 ET INCREMENTS DIVERS
C
      NBMATO = NBSKMA*NBSECT
      NBNOTO = NBSKNO*NBSECT
C
C
C------------ALLOCATION DES DIVERS OBJETS DU CONCEPT MAILLAGE-----------
C
      CALL WKVECT(NOMRES//'           .TITR','G V K80',1,LLTITR)
C
C
C
      CALL WKVECT(NOMRES//'.DIME','G V I',6,LDDIME)
C
      CALL JECREO(NOMRES//'.NOMMAI','G N K8')
      CALL JEECRA(NOMRES//'.NOMMAI','NOMMAX',NBMATO,K8BID)
C
      CALL JECREC(NOMRES//'.CONNEX','G V I','NU',
     &            'CONTIG','VARIABLE',NBMATO)
      CALL JEECRA(NOMRES//'.CONNEX','LONT',NTACON,K8BID)
C
      CALL WKVECT(NOMRES//'.TYPMAIL','G V I',NBMATO,IBID)
C
C
      CALL JECREO(NOMRES//'.NOMNOE','G N K8')
      CALL JEECRA(NOMRES//'.NOMNOE','NOMMAX',NBNOTO,K8BID)
C
C
      CALL JECREC(NOMRES//'.GROUPEMA','G V I','NO',
     &            'DISPERSE','VARIABLE',NBSECT)
C
C
      CALL WKVECT(NOMRES//'.COORDO    .REFE','G V K24',4,LDREF)
      CALL WKVECT(NOMRES//'.COORDO    .DESC','G V I',3,LDDESC)
      CALL JEECRA(NOMRES//'.COORDO    .DESC','DOCU',IBID,'CHNO')
      CALL WKVECT(NOMRES//'.COORDO    .VALE','G V R',3*NBNOTO,LDCOO)
C
C
C-----------------ALLOCATION OBJET SUPPLEMENTAIRE-----------------------
C
      CALL WKVECT(NOMRES//'.INV.SKELETON','G V I',NBNOTO*2,LDSKIN)
C
C------------------REMPLISSAGE .REFE ET .DESC ET TITRE -----------------
C
      ZK80(LLTITR) = 'MAILLAGE SQUELETTE SOUS-STRUCTURATION CYCLIQUE'
C
      ZK24(LDREF) = MAILLA
      ZK24(LDREF) = NOMRES
C
C
      CALL DISMOI('F','NUM_GD','GEOM_R','GRANDEUR',IGD,K8BID,IRET)
      ZI(LDDESC) = IGD
      ZI(LDDESC+1) = -3
      ZI(LDDESC+2) = 14
C
C-----------------------REMPLISSAGE DU .DIME----------------------------
C
      ZI(LDDIME) = NBNOTO
      ZI(LDDIME+1) = 0
      ZI(LDDIME+2) = NBMATO
      ZI(LDDIME+3) = 0
      ZI(LDDIME+4) = 0
      ZI(LDDIME+5) = 3
C
C
C
C--------------------BOUCLE SUR LES SECTEURS----------------------------
C
      TETSEC = DEPI/NBSECT
C
      NTEMNA = 0
      NTEMNO = 0
      ITCON = 0
C
C
      CALL JEVEUO(NOMRES//'.TYPMAIL','E',LDTYP)
      CALL JEVEUO(NOMRES//'.CONNEX','E',LDCONE)
C
C
C    REQUETTE COORDONNEES ANCIEN MAILLAGE
C
      CALL JEVEUO(MAILLA//'.COORDO    .VALE','L',LLCOO)
C
      DO 50 I = 1,NBSECT
        TETA = TETSEC* (I-1)
C
C  CREATION NOM DES GROUPES
C
        CALL CODENT( I , 'D0' , KNUSEC  )
        GRMCOU = 'MASEC'//KNUSEC
        CALL JECROC(JEXNOM(NOMRES//'.GROUPEMA',GRMCOU))
        CALL JEECRA(JEXNOM(NOMRES//'.GROUPEMA',GRMCOU),'LONMAX',
     &        MAX(1,NBSKMA), K8BID)
        CALL JEECRA(JEXNOM(NOMRES//'.GROUPEMA',GRMCOU),'LONUTI',NBSKMA,
     &              K8BID)
        CALL JEVEUO(JEXNOM(NOMRES//'.GROUPEMA',GRMCOU),'E',LDGRMA)
C
C   BOUCLE SUR NOEUD GENERIQUES SECTEUR
C
        DO 60 J = 1,NBSKNO
          NUMNO = ZI(LTNUNO+J-1)
          NTEMNO = NTEMNO + 1
          CALL CODENT( NTEMNO , 'D0' , KCHIFF  )
          NOMCOU = 'NO'//KCHIFF
          CALL JECROC(JEXNOM(NOMRES//'.NOMNOE',NOMCOU))
C
C
          ZI(LDSKIN+NTEMNO-1) = I
          ZI(LDSKIN+NBNOTO+NTEMNO-1) = NUMNO
C
C
          XANC = ZR(LLCOO+3* (NUMNO-1))
          YANC = ZR(LLCOO+3* (NUMNO-1)+1)
          ZANC = ZR(LLCOO+3* (NUMNO-1)+2)
C
          XNEW = XANC*COS(TETA) - SIN(TETA)*YANC
          YNEW = YANC*COS(TETA) + SIN(TETA)*XANC
          ZNEW = ZANC
C
          ZR(LDCOO+ (NTEMNO-1)*3) = XNEW
          ZR(LDCOO+ (NTEMNO-1)*3+1) = YNEW
          ZR(LDCOO+ (NTEMNO-1)*3+2) = ZNEW
C
   60   CONTINUE
C
C    BOUCLE SUR LES ELEMENTS DU SECTEUR
C
        DO 70 J = 1,NBSKMA
          NUMMA = ZI(LTNUMA+J-1)
          NTEMNA = NTEMNA + 1
          CALL CODENT( NTEMNA , 'D0' , KCHIFF  )
          NOMCOU = 'MA'//KCHIFF
C
C
C
          ZI(LDGRMA+J-1) = NTEMNA
C
          CALL JELIRA(JEXNUM(MAILLA//'.CONNEX',NUMMA),'LONMAX',NBCON,
     &                K8BID)
          CALL JECROC(JEXNOM(NOMRES//'.NOMMAI',NOMCOU))
          CALL JENONU(JEXNOM(NOMRES//'.NOMMAI',NOMCOU),IBID)
          CALL JEECRA(JEXNUM(NOMRES//'.CONNEX',IBID),'LONMAX',NBCON,
     &                K8BID)
          CALL JEECRA(JEXNUM(NOMRES//'.CONNEX',IBID),'LONUTI',NBCON,
     &                K8BID)
          CALL JEVEUO(JEXNUM(MAILLA//'.CONNEX',NUMMA),'L',LLCONA)
C
          DO 80 K = 1,NBCON
            ITCON = ITCON + 1
            LIGNE(1) = I
            LIGNE(2) = ZI(LLCONA+K-1)
            CALL TRNULI(ZI(LDSKIN),NBNOTO,2,LIGNE,NUNEW)
            ZI(LDCONE+ITCON-1) = NUNEW
   80     CONTINUE
C
          CALL JEVEUO(MAILLA//'.TYPMAIL','L',IATYMA)
          LLTYP=IATYMA-1+NUMMA
          ZI(LDTYP+NTEMNA-1) = ZI(LLTYP)
C
   70   CONTINUE
C
C
C
   50 CONTINUE
C
C-------------SAUVEGARDE ET DESTRUCTION DES OBJETS EVENTUELS------------
C
C
      CALL JEDETR('&&CYC110.NUM.SK.MAIL')
      CALL JEDETR('&&CYC110.NUM.SK.NOE')
C
C
      CALL JEDEMA()
      END
