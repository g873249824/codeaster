      SUBROUTINE MTCMBL(NBCOMB,TYPCST,CONST,TYPMAT,LIMAT,TYPRES,
     &                  MATREZ,DDLEXC,BASZ,NUMEDD,FACSYM)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NBCOMB
      CHARACTER*(*) TYPCST(NBCOMB),TYPMAT(NBCOMB),TYPRES,DDLEXC
      CHARACTER*(*) MATREZ,BASZ,NUMEDD
      CHARACTER*24 LIMAT(NBCOMB)
      REAL*8 CONST(NBCOMB)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 04/04/2006   AUTEUR VABHHTS J.PELLET 
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
C     COMBINAISON LINEAIRE DE MATRICES
C       *  LES MATRICES SONT SUPPOSEES AVOIR LE MEME TYPE DE STOCKAGE
C          (EN LIGNE DE CIEL OU MORSE)
C          ELLES S'APPUIENT SUR LE MEME MAILLAGE (I.E. LE PROF_CHNO
C          EST LE MEME)
C          MAIS LES LONGUEURS DES LIGNES  PEUVENT ETRE DIFFERENTES
C          D'UNE MATRICE A L'AUTRE.
C          D'AUTRE PART ELLES PEUVENT ETRE A ELEMENTS REELS OU
C          COMPLEXES
C       *  LES SCALAIRES SONT REELS OU COMPLEXES
C     L'OPERATION DE COMBINAISON LINEAIRE N'A DE SENS QUE
C     POUR DES MATRICES QUI NE SONT PAS DECOMPOSEES.
C     C'EST POURQUOI ON FAIT LA COMBINAISON LINEAIRE DES :
C                      .VALM
C                      .CCVA (SI ILS EXISTENT)
C                      .CONL
C    ET NON PAS DES .VALF QUI SONT DES OBJETS D'UNE MATR_ASSE
C    DECOMPOSEE PAR LA METHODE MULTI_FRONTALE
C
C---------------------------------------------------------------------
C IN  I  NBCOMB = NOMBRE DE MATRICES A COMBINER
C IN  V(K1) TYPCST = TYPE DES CONSTANTES (R OU C OU I)
C IN  V(R)  CONST  = TABLEAU DE R*8    DES COEFICIENTS
C IN  V(K1) TYPMAT = TYPE DES MATRICES   (R OU C)
C IN  V(K19) LIMAT = LISTE DES NOMS DES MATR_ASSE A COMBINER
C IN  K1 TYPRES = TYPE DES MATRICES   (R OU C)
C IN/JXOUT K19 MATREZ = NOM DE LA MATR_ASSE RESULTAT
C        CETTE MATRICE DOIT AVOIR ETE CREEE AU PREALABLE (MTDEFS)
C IN  K* DDLEXC = NOM DU DDL A EXCLURE (CONCRETEMENT IL S'AGIT
C                                         DES LAGRANGE : "LAGR" )
C IN  K14 NUMEDD = NOM DU NUME_DDL SUR LEQUEL S'APPUIERA
C                  LA MATR_ASSE MATREZ
C        SI NUMEDD  =' ', LE NOM DU NUME_DDL SERA OBTENU PAR GCNCON
C        SI NUMEDD /=' ', ON PRENDRA NUMEDD COMME NOM DE NUME_DDL
C IN  L FACSYM    /.TRUE. : ON FAIT LA FACTORISATION SYMBOLIQUE
C                           DE LA MATRICE (MLTPRE)
C                 /.FALSE. : ON NE LA FAIT PAS
C---------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL,FACSYM
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
      CHARACTER*1 BASE,CLAS,CLASI
      CHARACTER*8 KBID
      CHARACTER*19 MATEMP,MATI,MAT1,MATRES
C     -----------------------------------------------------------------
      INTEGER JREFA,JREFAI,INDICE,IER
      LOGICAL REUTIL

C
C --- VERIFICATION DE LA COHERENCE DES MATRICES A COMBINER
C
      CALL JEMARQ()

      BASE = BASZ
      MATRES = MATREZ

C --- RECUPERATION DE LA LISTE DES NOMS DE MATR_ASSE A COMBINER :
C     ---------------------------------------------------------

C --- CONSTRUCTION ET AFFECTATION DU TABLEAU DESTINE A CONTENIR
C --- LES POINTEURS DES DESCRIPTEURS DES MATR_ASSE A COMBINER :
C     -------------------------------------------------------
      CALL WKVECT('&&MTCMBL.LISPOINT','V V I',NBCOMB,IDLIMA)
      REUTIL=.FALSE.
      DO 10 I = 1,NBCOMB
        CALL MTDSCR(LIMAT(I))
        CALL JEVEUO(LIMAT(I)(1:19)//'.&INT','E',ZI(IDLIMA+I-1))
        IF (LIMAT(I).EQ.MATRES) REUTIL=.TRUE.
C       CALL VERISD('MATRICE',LIMAT(I))
   10 CONTINUE

C     -- SI LA MATRICE RESULTAT EST L'UNE DE CELLES A COMBINER,
C        IL NE FAUT PAS LA DETRUIRE !
      IF (REUTIL) THEN
        MATEMP='&&MTCMBL.MATEMP'
        CALL MTDEFS(MATEMP,LIMAT(1),'V',TYPMAT)
      ELSE
        MATEMP = MATRES
      ENDIF


      CALL JEVEUO(LIMAT(1) (1:19)//'.REFA','L',JREFA)
      IER1 = 0
      DO 20 I = 2,NBCOMB
        CALL JEVEUO(LIMAT(I) (1:19)//'.REFA','L',JREFAI)
        IF (ZK24(JREFA-1+2).NE.ZK24(JREFAI-1+2)) IER1 = 1
        IF (ZK24(JREFA-1+2).NE.ZK24(JREFAI-1+2)) IER1 = 1
        IF (ZK24(JREFA-1+1).NE.ZK24(JREFAI-1+1)) THEN
          CALL UTMESS('F','MTCMBL','LES MATRICES A COMBINER NE '//
     &                'SONT PAS CONSTRUITES SUR LE MEME MAILLAGE')
        END IF

   20 CONTINUE


C --- COMBINAISON LINEAIRE DES .VALM DES MATRICES :
C     ===========================================

C ---   CAS OU LES MATRICES A COMBINER ONT LE MEME PROFIL :
C       -------------------------------------------------
      IF (IER1.EQ.0) THEN
        CALL MTDSCR(MATEMP)
        CALL JEVEUO(MATEMP//'.&INT','E',LRES)
        CALL CBVALE(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,LRES,
     &              DDLEXC)

C ---   CAS OU LES MATRICES A COMBINER N'ONT PAS LE MEME PROFIL :
C       -------------------------------------------------------
      ELSE
        CALL JEDETR(MATEMP//'.VALM')
        CALL PROSMO(MATEMP,LIMAT,NBCOMB,BASE,NUMEDD,FACSYM)
        CALL MTDSCR(MATEMP)
        CALL JEVEUO(MATEMP//'.&INT','E',LRES)
        CALL CBVAL2(NBCOMB,CONST,TYPMAT,ZI(IDLIMA),TYPRES,LRES,DDLEXC)
      END IF

C
C --- TRAITEMENT DE LA S.D. ELIM_DDL
C --- I.E. C'EST LE CAS OU IL Y A DES DDLS ELIMINES DANS LES
C --- MATRICES A COMBINER :
C     ===================
C --- DESTRUCTION DE LA S.D. ELIM_DDL DE LA MATRICE RESULTAT
C --- SI CETTE S.D. EXISTE :
C     --------------------
      CALL DETELI(LRES)
C
      CALL JELIRA(MATEMP//'.REFA','CLAS',IBID,CLAS)
C
C --- NOMBRE DE DDLS ELIMINES DE LA PREMIERE MATRICE A COMBINER :
C     ---------------------------------------------------------
      NIMP = ZI(ZI(IDLIMA)+7)
C
      IF (NIMP.NE.0) THEN
C
C --- ON VERIFIE QUE LES S.D. ELIM_DDL DES MATRICES A COMBINER
C --- SONT IDENTIQUES :
C     ---------------
        CALL VERELI(NBCOMB,ZI(IDLIMA),IER)
        IF (IER.NE.0) THEN
          CALL UTMESS('F','MTCMBL','LES ELIM_DDL DES MATRICES'//
     &                ' A COMBINER NE SONT PAS COHERENTS')
        END IF
C
C --- NOM DE LA PREMIERE MATRICE A COMBINER :
C     -------------------------------------
        MAT1 = ZK24(ZI(ZI(IDLIMA)+1))
C
C --- BASE SUR LAQUELLE SE TROUVE LA PREMIERE MATRICE A COMBINER :
C     ----------------------------------------------------------
        CALL JELIRA(MAT1//'.REFA','CLAS',IBID,CLASI)
C
C --- NOMBRE DE BLOCS :
C     ---------------
C
C --- RECOPIE DE LA S.D. ELIM_DDL (SAUF LE .CCVA)
C --- DE LA PREMIERE MATRICE A COMBINER SUR LA S.D. ELIM_DDL
C --- DE LA MATRICE RESULTAT :
C     ----------------------
        CALL JEDUPO(MAT1//'.CCID',CLAS,MATEMP//'.CCID',.TRUE.)
        CALL JEDUPO(MAT1//'.CCLL',CLAS,MATEMP//'.CCLL',.TRUE.)
        CALL JEDUPO(MAT1//'.CCJJ',CLAS,MATEMP//'.CCJJ',.TRUE.)


C --- CREATION DU .CCVA DE LA MATRICE RESULTAT :
C     ----------------------------------------
        CALL JELIRA(MATEMP//'.CCJJ','LONMAX',NCCVA,KBID)
        CALL WKVECT(MATEMP//'.CCVA',CLAS//' V '//TYPRES(1:1),NCCVA,IBID)

C --- COMBINAISON LINEAIRE DES .CCVA DES MATRICES :
C     -------------------------------------------
        CALL CBVALI(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,LRES)
C
C --- REMISE A 1 DES TERMES DIAGONAUX DES LIGNES ELIMINEES DU .VALE :
C     -------------------------------------------------------------
        CALL CIDIA1(TYPRES,LRES)
C
      END IF
C
C --- CONSTRUCTION DU DESCRIPTEUR DE LA MATRICE RESULTAT :
C     ==================================================
      CALL MTDSCR(MATEMP)
      CALL JEVEUO(MATEMP(1:19)//'.&INT','E',LRES)
C
C --- COMBINAISON LINEAIRE DES .CONL DES MATRICES SI NECESSAIRE :
C     =========================================================
      IF (DDLEXC.NE.'LAGR') THEN
        CALL MTCONL(NBCOMB,TYPCST,CONST,ZI(IDLIMA),TYPRES,LRES)

      ELSE
        CALL JEDETR(ZK24(ZI(LRES+1)) (1:19)//'.CONL')
      END IF

      IF (REUTIL) THEN
        CALL COPISD('MATR_ASSE','V',MATEMP,MATRES)
        CALL DETRSD('MATR_ASSE',MATEMP)
      ENDIF

      CALL JEDETR('&&MTCMBL.LISPOINT')

      CALL JEDEMA()
C     CALL VERISD('MATRICE',MATRES)
      END
