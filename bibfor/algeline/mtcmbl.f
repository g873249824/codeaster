      SUBROUTINE MTCMBL(NBCOMB,TYPCST,CONST,LIMAT,
     &                  MATREZ,DDLEXC,NUMEDD)
      IMPLICIT NONE
      INTEGER NBCOMB
      CHARACTER*(*) TYPCST(NBCOMB),DDLEXC
      CHARACTER*(*) MATREZ,NUMEDD
      CHARACTER*(*) LIMAT(NBCOMB)
      REAL*8 CONST(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 19/06/2006   AUTEUR VABHHTS J.PELLET 
C RESPONSABLE VABHHTS J.PELLET
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
C     COMBINAISON LINEAIRE DE MATRICES  :
C     -------------------------------------
C     MAT_RES= SOMME(ALPHA_I*MAT_I)

C       *  LES MATRICES (MAT_I) DOIVENT AVOIR LA MEME NUMEROTATION DES
C           DDLS MAIS ELLES PEUVENT AVOIR DES CONNECTIVITES DIFFERENTES
C          (I.E. DES STOCKAGES DIFFERENTS)
C       *  LES MATRICES (MAT_I) SONT REELLES OU COMPLEXES
C       *  LES MATRICES (MAT_I) SONT SYMETRIQUES OU NON
C       *  LES COEFFICIENTS (ALPHA_I) SONT REELS OU COMPLEXES
C       *  ON PEUT MELANGER MATRICES REELLES ET COMPLEXES ET LES TYPES
C          (R/C) DES COEFFICIENTS. ON PEUT FAIRE PAR EXEMPLE :
C          MAT_RES= ALPHA_R1*MAT_C1 + ALPHA_C2*MAT_R2
C       *  MAT_RES DOIT ETRE ALLOUEE AVANT L'APPEL A MTCMBL
C          CELA VEUT DIRE QUE SON TYPE (R/C) EST DEJA DETERMINE.
C       *  SI TYPE(MAT_RES)=R ET QUE CERTAINS (MAT_I/ALPHA_I) SONT C,
C          CELA VEUT SIMPLEMENT DIRE QUE MAT_RES CONTIENDRA LA PARTIE
C          REELLE DE LA COMBINAISON LINEAIRE (QUI EST COMPLEXE)
C
C---------------------------------------------------------------------
C IN  I  NBCOMB = NOMBRE DE MATRICES A COMBINER
C IN  V(K1) TYPCST = TYPE DES CONSTANTES (R/C)
C IN  V(R)  CONST  = TABLEAU DE R*8    DES COEFICIENTS
C     ATTENTION : CONST PEUT ETRE DE DIMENSION > NBCOMB CAR
C                 LES COEFS COMPLEXES SONT STOCKES SUR 2 REELS
C IN  V(K19) LIMAT = LISTE DES NOMS DES MATR_ASSE A COMBINER
C IN/JXOUT K19 MATREZ = NOM DE LA MATR_ASSE RESULTAT
C        CETTE MATRICE DOIT AVOIR ETE CREEE AU PREALABLE (MTDEFS)
C IN  K* DDLEXC = NOM DU DDL A EXCLURE ("LAGR"/" " )

C SI LES MATRICES COMBINEES N'ONT PAS LE MEME STOCKAGE, IL FAUT
C CREER UN NOUVEAU NUME_DDL POUR CE STOCKAGE :
C IN/JXOUT  K14 NUMEDD = NOM DU NUME_DDL SUR LEQUEL S'APPUIERA MATREZ
C        SI NUMEDD ==' ', LE NOM DU NUME_DDL SERA OBTENU PAR GCNCON
C        SI NUMEDD /=' ', ON PRENDRA NUMEDD COMME NOM DE NUME_DDL
C---------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     -----------------------------------------------------------------
      CHARACTER*1 BASE,BAS2,TYPRES
      CHARACTER*8 KBID,TYPMAT
      CHARACTER*19 MATEMP,MAT1,MATRES,MATI
C     -----------------------------------------------------------------
      INTEGER JREFAR,JREFA1,JREFAI,IER,IBID,IDLIMA,IER1
      INTEGER I,LRES,NBLOC,JREFA
      LOGICAL REUTIL,SYMR,SYMI,IDENOB
C     -----------------------------------------------------------------
      CALL JEMARQ()
      MATRES = MATREZ
      MAT1=LIMAT(1)
      CALL ASSERT(NBCOMB.GT.0)
      CALL JELIRA(MATRES//'.REFA','CLAS',IBID,BASE)
      CALL JELIRA(MATRES//'.VALM','TYPE',IBID,TYPRES)
      CALL JELIRA(MATRES//'.VALM','NMAXOC',NBLOC,KBID)
      CALL ASSERT(NBLOC.EQ.1.OR.NBLOC.EQ.2)
      CALL JEVEUO(MATRES//'.REFA','L',JREFAR)
      CALL ASSERT(ZK24(JREFAR-1+9) (1:1).EQ.'M')
      SYMR = ZK24(JREFAR-1+9) .EQ. 'MS'
      IF (SYMR) CALL ASSERT(NBLOC.EQ.1)

      CALL ASSERT(DDLEXC.EQ.' '.OR.DDLEXC.EQ.'LAGR')
      CALL WKVECT('&&MTCMBL.LISPOINT','V V I',NBCOMB,IDLIMA)
      REUTIL=.FALSE.
      DO 10 I = 1,NBCOMB
        CALL ASSERT(TYPCST(I).EQ.'R'.OR.TYPCST(I).EQ.'C')
        MATI=LIMAT(I)
C       CALL VERISD('MATR_ASSE',MATI)
        CALL JEVEUO(MATI//'.REFA','L',JREFAI)
        IF (ZK24(JREFAI-1+3).EQ.'ELIMF') CALL MTMCHC(MATI,'ELIML')
        CALL MTDSCR(MATI)
        CALL JEVEUO(MATI//'.&INT','E',ZI(IDLIMA+I-1))
        CALL JELIRA(MATI//'.VALM','TYPE',IBID,TYPMAT)
        CALL JELIRA(MATI//'.VALM','NMAXOC',NBLOC,KBID)
        CALL JEVEUO(MATI//'.REFA','L',JREFAI)
        SYMI = ZK24(JREFAI-1+9) .EQ. 'MS'
        CALL ASSERT(NBLOC.EQ.1.OR.NBLOC.EQ.2)
        IF (SYMI) CALL ASSERT(NBLOC.EQ.1)
        IF ((.NOT.SYMI).AND.SYMR) CALL UTMESS('F','MTCMBL',
     &   'ON NE PEUT PAS COMBINER UNE MATRICE NON SYMETRIQUE '
     &   //'DANS UNE MATRICE SYMETRIQUE.')
        IF (MATI.EQ.MATRES) REUTIL=.TRUE.
C       CALL VERISD('MATRICE',MATI)
   10 CONTINUE


C     -- SI LA MATRICE RESULTAT EST L'UNE DE CELLES A COMBINER,
C        IL NE FAUT PAS LA DETRUIRE !
C     ------------------------------------------------------------
      IF (REUTIL) THEN
        MATEMP='&&MTCMBL.MATEMP'
        CALL MTDEFS(MATEMP,MATRES,'V',TYPRES)
      ELSE
        MATEMP = MATRES
      ENDIF
      CALL JELIRA(MATEMP//'.REFA','CLAS',IBID,BAS2)


C --- VERIFI. DE LA COHERENCE DES NUMEROTATIONS DES MATRICES A COMBINER
C     ------------------------------------------------------------------
      CALL JEVEUO(MAT1//'.REFA','L',JREFA1)
      IER1 = 0
      DO 20 I = 2,NBCOMB
        MATI=LIMAT(I)
        CALL JEVEUO(MATI//'.REFA','L',JREFAI)
        IF (ZK24(JREFA1-1+2).NE.ZK24(JREFAI-1+2)) IER1 = 1
        IF (ZK24(JREFA1-1+2).NE.ZK24(JREFAI-1+2)) IER1 = 1
        IF (ZK24(JREFA1-1+1).NE.ZK24(JREFAI-1+1)) THEN
          CALL UTMESS('F','MTCMBL','LES MATRICES A COMBINER NE '//
     &                'SONT PAS CONSTRUITES SUR LE MEME MAILLAGE')
        END IF
        IF (.NOT.IDENOB(MAT1//'.CCID',MATI//'.CCID'))
     &     CALL UTMESS('F','MTCMBL','CHARGES CINEMATIQUES DIFFERENTES.')
   20 CONTINUE



C --- 2) COMBINAISON LINEAIRE DES .VALM DES MATRICES :
C     ================================================

C ---   CAS OU LES MATRICES A COMBINER ONT LE MEME PROFIL :
C       -------------------------------------------------
      IF (IER1.EQ.0) THEN
        CALL MTDSCR(MATEMP)
        CALL JEVEUO(MATEMP//'.&INT','E',LRES)
        CALL CBVALE(NBCOMB,TYPCST,CONST,ZI(IDLIMA),TYPRES,LRES,
     &              DDLEXC)

C ---   CAS OU LES MATRICES A COMBINER N'ONT PAS LE MEME PROFIL :
C       -------------------------------------------------------
      ELSE
        CALL PROSMO(MATEMP,LIMAT,NBCOMB,BASE,NUMEDD,SYMR,TYPRES)
        CALL MTDSCR(MATEMP)
        CALL JEVEUO(MATEMP//'.&INT','E',LRES)
        CALL CBVAL2(NBCOMB,TYPCST,CONST,ZI(IDLIMA),TYPRES,LRES,
     &              DDLEXC)
      END IF

C
C --- DDL ELIMINES :
C     ===================
      CALL JEVEUO(MATEMP//'.REFA','L',JREFA)
      CALL JEDETR(MATEMP//'.CCID')
      CALL JEDETR(MATEMP//'.CCVA')
      CALL JEDETR(MATEMP//'.CCLL')
      CALL JEDETR(MATEMP//'.CCJJ')
      CALL JEDUP1(MAT1//'.CCID',BAS2,MATEMP//'.CCID')
      CALL JEEXIN(MATEMP//'.CCID',IER)
      IF (IER.GT.0) ZK24(JREFA-1+3)='ELIML'




C --- CONSTRUCTION DU DESCRIPTEUR DE LA MATRICE RESULTAT :
C     ==================================================
      CALL MTDSCR(MATEMP)
      CALL JEVEUO(MATEMP(1:19)//'.&INT','E',LRES)

C --- COMBINAISON LINEAIRE DES .CONL DES MATRICES SI NECESSAIRE :
C     =========================================================
      IF (DDLEXC.NE.'LAGR') THEN
        CALL MTCONL(NBCOMB,TYPCST,CONST,ZI(IDLIMA),TYPRES,LRES)
      ELSE
        CALL JEDETR(ZK24(ZI(LRES+1))(1:19)//'.CONL')
      END IF

      IF (REUTIL) THEN
        CALL COPISD('MATR_ASSE',BASE,MATEMP,MATRES)
        CALL DETRSD('MATR_ASSE',MATEMP)
      ENDIF

      CALL JEDETR('&&MTCMBL.LISPOINT')

      CALL JEDEMA()
C     CALL VERISD('MATRICE',MATRES)
      END
