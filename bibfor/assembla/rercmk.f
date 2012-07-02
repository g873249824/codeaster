      SUBROUTINE RERCMK(NU,MO,MA,NLILI,NM,NL,NBNTT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
C
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*8 MO,MA
      CHARACTER*14 NU
      INTEGER NLILI, NM, NL, NBNTT
C ----------------------------------------------------------------------
C     BUT:  CETTE ROUTINE SERT A RENUMEROTER LES NOEUDS D'UN NUME_DDL
C           SUIVANT L'ALGORITHME DE REVERSE-CUTHILL-MAC-KEE.
C     IN:
C     ---
C       NU : NOM DU NUME_DDL QUE L'ON RENUMEROTE
C       MO : NOM DU MODELE SOUS-JACENT AU NUME_DDL
C       MA : NOM DU MAILLAGE SOUS-JACENT AU NUME_DDL
C       NLILI: NOMBRE DE LIGREL DE L'OBJET .LILI
C       NM   : NOMBRE DE NOEUDS PHYSIQUES DU MAILLAGE
C       NL   : NOMBRE DE NOEUDS DE LAGRANGE DU MAILLAGE
C       NBNTT: NOMBRE DE NOEUDS MAXI (NUME_DDL)
C
C     OUT:
C     ----
C
C      ON REMPLIT LES VECTEURS NU//'.NEWN' ET NU//'.OLDN'
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*8 KBID,EXIELE
      CHARACTER*24 NOMLI2
      CHARACTER*19 NOMLIG
C
C-----------------------------------------------------------------------
      INTEGER I ,IACOIN ,IACONX ,IAEXI1 ,IAGREL ,IALCOI ,IALIEL
      INTEGER IAMAIL ,IANBCO ,IANBNO ,IANEMA ,IANEW1 ,IANEWN ,IAOLD1
      INTEGER IAOLDN ,IAORDO ,IASSSA ,IBID ,ICO ,ICOL ,ICUMUL
      INTEGER IEL ,IERD ,IFM ,IGREL ,IINEW ,IINO ,IIO1
      INTEGER IIO2 ,ILCONX ,ILI ,ILLIEL ,ILNEMA ,IMA ,INO
      INTEGER IREMPL ,IRET ,J ,JJNO ,JNO ,JRANG ,K
      INTEGER L1 ,L2 ,LL1 ,LL2 ,LONGI ,LONGO ,N1I
      INTEGER N1J ,N2I ,N2J ,NBCO ,NBCOMP ,NBEL ,NBGREL
      INTEGER NBI ,NBMA ,NBNM ,NBNMRE ,NBNOMA ,NBNOT ,NBNTRE
      INTEGER NBSMA ,NBSSA ,NEWNNO ,NIV,INDIIS
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV(IFM,NIV)
C----------------------------------------------------------------------
      NBNOMA= NM+NL
C
C     -- ALLOCATION DES OBJETS .NEW1 ET .OLD1  (PROVISOIRES) :
C        CES OBJETS REPRESENTENT LA RENUMEROTATION DE TOUS LES NOEUDS
C     ---------------------------------------------------------------
      CALL WKVECT('&&RERCMK.NEW1','V V I',NBNTT,IANEW1)
      CALL WKVECT('&&RERCMK.OLD1','V V I',NBNTT,IAOLD1)
C
C     ---------------------------------------------------------------
C        ON CALCULE LA DIMENSION DE LA TABLE DE CONNECTIVITE INVERSE:
C             (EN FAIT, ON SUR-DIMENSIONNE)
C     ---------------------------------------------------------------
C
C     -- ORDO EST UNE TABLE DE TRAVAIL QUI DOIT POUVOIR CONTENIR
C        UNE LIGNE DE CONNECTIVITE INVERSE.
      CALL WKVECT('&&RERCMK.ORDO','V V I',NBNTT,IAORDO)
C
      CALL WKVECT('&&RERCMK.LCOI','V V I',NBNTT,IALCOI)
C     -- .LCOI(INO) CONTIENDRA L'ADRESSE DANS .COIN DE LA LISTE
C        DES NOEUDS CONNECTES A INO (C'EST LE VECTEUR CUMULE DE .EXI1)
C        C'EST EN QUELQUE SORTE LE POINTEUR DE LONGUEUR CUMULEE DE .COIN
C
      CALL WKVECT('&&RERCMK.NBCO','V V I',NBNTT,IANBCO)
C     -- .NBCO(INO) CONTIENDRA AU FUR ET A MESURE DE LA CONSTRUCTION
C         DE LA TABLE DE CONNECTIVITE INVERSE, LE NOMBRE REEL DE NOEUDS
C         CONNECTES A INO.
C
C
C
C     -----------------------------------------------------------------
C        RECUPERATION DE .EXI1
C        ALLOCATION DE LA TABLE DE CONNECTIVITE INVERSE: .COIN
C        REMPLISSAGE DU "POINTEUR DE LONGUEUR" .LCOI
C     -----------------------------------------------------------------
C
      CALL JEVEUO(NU//'.EXI1','L',IAEXI1)
C
      ICUMUL=0
C     -- NBNTRE EST LE NOMBRE TOTAL DE NOEUDS A RENUMEROTER
      NBNTRE=0
C
      ZI(IALCOI-1+1)= 1
      DO 5  , INO=1,NBNTT-1
        ICUMUL= ICUMUL+ZI(IAEXI1+INO)
        ZI(IALCOI-1+INO+1)= ZI(IALCOI-1+INO)+ZI(IAEXI1+INO)
        IF(ZI(IAEXI1+INO).GT.0) NBNTRE= NBNTRE+1
 5    CONTINUE
C
      ICUMUL= ICUMUL+ZI(IAEXI1+NBNTT)
      IF(ZI(IAEXI1+NBNTT).GT.0) NBNTRE= NBNTRE+1
C
      CALL WKVECT('&&RERCMK.COIN','V V I',ICUMUL,IACOIN)
C
C
C     -----------------------
C     --REMPLISSAGE DE .COIN:
C     -----------------------
C
      CALL DISMOI('F','NB_MA_MAILLA',MO,'MODELE',NBMA,KBID,IERD)
      IF (NBMA.GT.0) THEN
        CALL JEVEUO(MA//'.CONNEX','L',IACONX)
        CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ILCONX)
      END IF
C
C
C     -- 1ERE ETAPE : (SUPER)MAILLES DU MAILLAGE:
C     -------------------------------------------
      CALL DISMOI('F','NB_SS_ACTI',MO,'MODELE',NBSSA,KBID,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
      IF (NBSSA.GT.0) THEN
        CALL JEVEUO(MO//'.MODELE    .SSSA','L',IASSSA)
      ELSE
        GO TO 12
      END IF
C
      DO 11, IMA = 1, NBSMA
        IF(ZI(IASSSA-1+IMA).EQ.1) THEN
          CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',IAMAIL)
          CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NBNM,KBID)
          DO 13, I=1,NBNM
            INO=ZI(IAMAIL-1+I)
            IINO=INO
            IF (INO.LE.0)
     & CALL U2MESS('F','ASSEMBLA_36')
            DO 14, J=I+1,NBNM
              JNO=ZI(IAMAIL-1+J)
              JJNO=JNO
              JRANG= INDIIS(ZI(IACOIN+ZI(IALCOI-1+IINO)-1)
     &            ,JJNO,1,ZI(IANBCO-1+IINO))
C
              IF (JRANG.EQ.0) THEN
                IREMPL=ZI(IANBCO-1+IINO) +1
                ZI(IANBCO-1+IINO)=IREMPL
                ZI(IACOIN+ZI(IALCOI-1+IINO)-1+ IREMPL-1)= JJNO
C
                IREMPL=ZI(IANBCO-1+JJNO) +1
                ZI(IANBCO-1+JJNO)=IREMPL
                ZI(IACOIN+ZI(IALCOI-1+JJNO)-1+ IREMPL-1)= IINO
              END IF
 14         CONTINUE
 13       CONTINUE
        END IF
 11   CONTINUE
C
 12   CONTINUE
C
C
C     -- 2EME ETAPE : MAILLES TARDIVES (OU NON) DES LIGRELS
C                     (MODELE + LISTE DE CHARGES)
C     -----------------------------------------------------
C
      NBNOT=0
      DO 30 , ILI=2,NLILI
        CALL JENUNO(JEXNUM(NU//'.NUME.LILI',ILI),NOMLI2)
        NOMLIG=NOMLI2(1:19)
        CALL DISMOI('F','EXI_ELEM',NOMLIG,'LIGREL',IBID,EXIELE,IERD)
        IF (EXIELE(1:3).EQ.'NON') GO TO 30
C
        CALL JEVEUO(NOMLIG//'.LIEL','L',IALIEL)
        CALL JEVEUO(JEXATR(NOMLIG//'.LIEL','LONCUM'),'L',ILLIEL)
        CALL JELIRA(NOMLIG//'.LIEL','NMAXOC',NBGREL,KBID)
C
        CALL JEEXIN(NOMLIG//'.NEMA',IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(NOMLIG//'.NEMA','L',IANEMA)
          CALL JEVEUO(JEXATR(NOMLIG//'.NEMA','LONCUM'),'L',ILNEMA)
        END IF
C
        DO 31, IGREL = 1, NBGREL
          NBEL= ZI(ILLIEL-1+IGREL+1)-ZI(ILLIEL-1+IGREL) -1
          IAGREL= IALIEL + ZI(ILLIEL-1+IGREL) -1
          DO 32,IEL= 1, NBEL
            IMA= ZI(IAGREL -1 +IEL)
            IF (IMA.GT.0) THEN
              NBNM= ZI(ILCONX-1+IMA+1)-ZI(ILCONX-1+IMA)
              IAMAIL= IACONX + ZI(ILCONX-1+IMA) -1
            ELSE
              NBNM= ZI(ILNEMA-1-IMA+1)-ZI(ILNEMA-1-IMA) -1
              IAMAIL = IANEMA + ZI(ILNEMA-1-IMA) -1
            END IF
C
            DO 33, I=1,NBNM
              INO=ZI(IAMAIL-1+I)
              IINO= INO
              IF (INO.LT.0)  IINO=NBNOMA+NBNOT-INO
C
              DO 34, J=I+1,NBNM
                JNO=ZI(IAMAIL-1+J)
                JJNO= JNO
                IF (JNO.LT.0)  JJNO=NBNOMA+NBNOT-JNO
C
                JRANG= INDIIS(ZI(IACOIN+ZI(IALCOI-1+IINO)-1)
     &              ,JJNO,1,ZI(IANBCO-1+IINO))
C
                IF (JRANG.EQ.0) THEN
                  IREMPL=ZI(IANBCO-1+IINO) +1
                  ZI(IANBCO-1+IINO)=IREMPL
                  ZI(IACOIN+ZI(IALCOI-1+IINO)-1+ IREMPL-1)= JJNO
C
                  IREMPL=ZI(IANBCO-1+JJNO) +1
                  ZI(IANBCO-1+JJNO)=IREMPL
                  ZI(IACOIN+ZI(IALCOI-1+JJNO)-1+ IREMPL-1)= IINO
                END IF
 34           CONTINUE
 33         CONTINUE
 32       CONTINUE
 31     CONTINUE
C
        CALL JEVEUO(NOMLIG//'.NBNO','L',IANBNO)
        NBNOT= NBNOT+ZI(IANBNO)
 30   CONTINUE
C
C
C
C     --CALCUL DES OBJETS .NEW1 ET .OLD1 :
C     ------------------------------------
C
      IINEW=0
C
C     -- NBCOMP COMPTE LE NOMBRE DE COMPOSANTES CONNEXES DU MODELE
      NBCOMP=0
 50   CONTINUE
      NBCOMP= NBCOMP+1
C
C     --ON INITIALISE L'ALGORITHME PAR LE NOEUD I QUI A LA CONNECTIVITE
C     -- LA PLUS FAIBLE (PARMI CEUX RESTANT A RENUMEROTER):
C     "I= MIN(NBCO)"
C     ----------------------------------------------------------------
      I=0
      DO 51, K=1,NBNTT
         IF (ZI(IAEXI1+K).EQ.0) GO TO 51
         IF (ZI(IANEW1-1+K).NE.0) GO TO 51
         IF (I.EQ.0) THEN
            I=K
         ELSE
            IF (ZI(IANBCO-1+K).LT.ZI(IANBCO-1+I)) I=K
         END IF
 51   CONTINUE
      CALL ASSERT(I.NE.0)
C
      IINEW=IINEW+1
      ZI(IANEW1-1+I)=IINEW
      ZI(IAOLD1-1+IINEW)=I
C     -- SI ON A RENUMEROTE TOUS LES NOEUDS ATTENDUS, ON SORT :
      IF (IINEW.EQ.NBNTRE) GOTO 200
      ICO=IINEW
C
 100  CONTINUE
      LONGI= ZI(IANBCO-1+I)
      CALL RENUU1(ZI(IACOIN-1+ZI(IALCOI-1+I)),LONGI,ZI(IAORDO),LONGO,
     &            ZI(IANBCO),ZI(IANEW1))
      DO 101, J=1,LONGO
         IINEW=IINEW+1
         ZI(IANEW1-1+ZI(IAORDO-1+J))=IINEW
         ZI(IAOLD1-1+IINEW)=ZI(IAORDO-1+J)
C        -- SI ON A RENUMEROTE TOUS LES NOEUDS ATTENDUS, ON SORT :
         IF (IINEW.EQ.NBNTRE) GOTO 200
  101 CONTINUE
      ICO=ICO+1
      I=ZI(IAOLD1-1+ICO)
      IF (I.EQ.0) THEN
        GO TO 50
      ELSE
        GO TO 100
      END IF
C
  200 CONTINUE
C
C     -- ON COMPACTE .OLD1 DANS .NEWN ET .OLDN
C     POUR NE CONSERVER QUE LES NOEUDS PHYSIQUES :
C     --------------------------------------------
      CALL JEVEUO(NU//'.OLDN','E',IAOLDN)
      CALL JEVEUO(NU//'.NEWN','E',IANEWN)
C
      ICOL=0
      DO 2, I=1,NBNTT
        IIO1 = ZI(IAOLD1-1+I)
        IF(IIO1.EQ.0) GO TO 3
        IF(IIO1.GT.NM) THEN
          ICOL=ICOL+1
        ELSE
          IIO2=I-ICOL
          IF ((IIO1.LT.1).OR.(IIO1.GT.NM))
     & CALL U2MESS('F','ASSEMBLA_38')
          IF ((IIO2.LT.1).OR.(IIO2.GT.NM))
     & CALL U2MESS('F','ASSEMBLA_38')
          ZI(IANEWN-1+IIO1)=I-ICOL
        END IF
 2    CONTINUE
 3    CONTINUE
C     -- NBNMRE EST LE NOMBRE DE NOEUDS PHYSIQUES A RENUMEROTER
      NBNMRE= IIO2
C
C     -- ON FINIT EN "REVERSANT" LE TOUT :
C     ------------------------------------
      DO 300, I= 1,NM
         IF (ZI(IANEWN-1+I).EQ.0) GO TO 300
         NEWNNO = NBNMRE+1-ZI(IANEWN-1+I)
         ZI(IANEWN-1+I)= NEWNNO
         ZI(IAOLDN-1+NEWNNO)= I
 300  CONTINUE
C
C
C     -- ON ECRIT LES LARGEURS DE BANDE MOYENNES AVANT ET APRES:
C     ----------------------------------------------------------
      IF (NIV.GE.1) THEN
        WRITE(IFM,*) '--- RENUMEROTATION DES NOEUDS DU MODELE (RCMK) :'
        WRITE(IFM,*) '   --- NOMBRE DE COMPOSANTES CONNEXES DU MODELE :'
     &  ,NBCOMP
      ENDIF
C
      NBI=0
      LL1=0
      LL2=0
      DO 600, I= 1,NM
         IF (ZI(IAEXI1+I).EQ.0) GO TO 600
         NBI= NBI+1
         NBCO= ZI(IANBCO-1+I)
         L1=1
         L2=1
         DO 601, J=1,NBCO
            N1I=I
            N1J=ZI(IACOIN-2+ZI(IALCOI-1+I)+J)
            IF (N1J.GT.NM) GO TO 601
            L1= MAX(L1,(N1I-N1J)+1)
C
            N2I= ZI(IANEWN-1+N1I)
            N2J= ZI(IANEWN-1+N1J)
            L2= MAX(L2,(N2I-N2J)+1)
 601     CONTINUE
         LL1=LL1+L1
         LL2=LL2+L2
 600  CONTINUE
      IF (NIV.GE.1) THEN
       WRITE(IFM,*)'   --- HAUTEUR DE COLONNE MOYENNE (EN NOEUDS)'
       WRITE(IFM,*)'        (EN NE TENANT COMPTE QUE DES NOEUDS '
     &                       //'PHYSIQUES)'
       WRITE(IFM,FMT='(A30,1PD10.3)')'        AVANT RENUMEROTATION:',
     &             DBLE(LL1)/NBI
       WRITE(IFM,FMT='(A30,1PD10.3)')'        APRES RENUMEROTATION:',
     &             DBLE(LL2)/NBI
C
        IF(LL1.LE.LL2) THEN
        WRITE(IFM,*)'   --- LA NOUVELLE NUMEROTATION OBTENUE PAR '
     &   //'L ALGORITHME "RCMK" NE SEMBLE PAS'
        WRITE(IFM,*)'       MEILLEURE QUE L ORIGINALE. ELLE L''EST'
     &   //' PEUT ETRE QUAND MEME DU FAIT DE LA '
        WRITE(IFM,*)'       PRISE EN COMPTE DES RELATIONS LINEAIRES'
     &  // ' ENTRE NOEUDS.'
        END IF
      ENDIF
C
      CALL JEDETR('&&RERCMK.NEW1')
      CALL JEDETR('&&RERCMK.OLD1')
      CALL JEDETR('&&RERCMK.ORDO')
      CALL JEDETR('&&RERCMK.LCOI')
      CALL JEDETR('&&RERCMK.NBCO')
      CALL JEDETR('&&RERCMK.COIN')
C
      CALL JEDEMA()
      END
