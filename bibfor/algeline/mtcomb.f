      SUBROUTINE MTCOMB(NBCOMB,TYPCST,CONST,TYPMAT,LIMAT,TYPRES,
     +                  MATREZ,DDLEXC,BASZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           NBCOMB
      CHARACTER*(*)    TYPCST(*),   TYPMAT(*),    TYPRES,  DDLEXC
      CHARACTER*(*)     MATREZ, BASZ
      CHARACTER*24     LIMAT(NBCOMB)
      REAL*8                          CONST(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 25/09/2002   AUTEUR VABHHTS J.PELLET 
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
C                      .VALE
C                      .VALI (SI ILS EXISTENT)
C                      .CONL
C    ET NON PAS DES .VALF QUI SONT DES OBJETS D'UNE MATR_ASSE
C    DECOMPOSEE PAR LA METHODE MULTI_FRONTALE
C
C     -----------------------------------------------------------------
C IN  I  NBCOMB = NOMBRE DE MATRICES A COMBINER
C IN  K* TYPCST = TYPE DES CONSTANTES (R OU C OU I)
C IN  R  CONST  = TABLEAU DE R*8    DES COEFICIENTS
C IN  K* TYPMAT = TYPE DES MATRICES   (R OU C)
C IN  K24 LIMAT = LISTE DES NOMS DES MATR_ASSE A COMBINER
C IN  K* TYPRES = TYPE DES MATRICES   (R OU C)
C IN  I  LRES   = POINTEUR DE MATRICE RESULTAT
C IN  K* DDLEXC = NOM DU DDL A EXCLURE (CONCRETEMENT IL S'AGIT
C                                         DES LAGRANGE : "LAGR" )
C
C     -----------------------------------------------------------------
C     PRECAUTIONS D'EMPLOI:
C         1) LA MATRICE RESULTAT DOIT EXISTER
C         2) LA MATRICE RESULTAT NE DOIT PAS ETRE AUSSI A DROITE DE
C            L'OPERATEUR
C     -----------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32  JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C     -----------------------------------------------------------------
C     LGBLOC = LONGUEUR DES BLOCS
C     NBLIC  = NOMBRE DE BLOCS DU .VALI
      INTEGER               LGBLOC, NBLIC
C     -----------------------------------------------------------------
      CHARACTER*1   BASE, CLAS, CLASI
      CHARACTER*4   ETAMAT, ETAMA1
      CHARACTER*8   K8BID
      CHARACTER*19  MATRES,MATI,MAT1
C     -----------------------------------------------------------------
C
C --- VERIFICATION DE LA COHERENCE DES MATRICES A COMBINER
C
      CALL JEMARQ()
C
      BASE   = BASZ
      MATRES = MATREZ
C
C --- RECUPERATION DE LA LISTE DES NOMS DE MATR_ASSE A COMBINER :
C     ---------------------------------------------------------
C
C --- CONSTRUCTION ET AFFECTATION DU TABLEAU DESTINE A CONTENIR
C --- LES POINTEURS DES DESCRIPTEURS DES MATR_ASSE A COMBINER :
C     -------------------------------------------------------
      CALL WKVECT('&&MTCOMB.LISPOINT','V V I',NBCOMB,IDLIMA)
C
      DO 10 I = 1, NBCOMB
        CALL MTDSCR(LIMAT(I))
        CALL JEVEUO(LIMAT(I)(1:19)//'.&INT','E',ZI(IDLIMA+I-1))
   10 CONTINUE
C
      CALL JELIRA(LIMAT(1)(1:19)//'.REFA','DOCU',IBID,ETAMA1)
C
      IER1 = 0
      DO 20 I = 2, NBCOMB
         CALL VRREFE (LIMAT(1), LIMAT(I), IER)
         IF (IER.NE.0) THEN
           IER1 = 1
         ENDIF
         CALL JELIRA(LIMAT(I)(1:19)//'.REFA','DOCU',IBID,
     +               ETAMAT)
         IF (ETAMAT.NE.ETAMA1) THEN
              CALL UTMESS('F','MTCOMB','LES MATRICES A COMBINER'//
     +                     ' NE SONT PAS DANS LE MEME ETAT'//
     +                     ' REFERENCE PAR LE CHAMP DOCU DU .REFA')
         ENDIF
  20  CONTINUE
C
C --- COMBINAISON LINEAIRE DES .VALE DES MATRICES :
C     ===========================================
C ---   CAS OU LES MATRICES A COMBINER ONT LE MEME PROFIL :
C       -------------------------------------------------
      IF (IER1.EQ.0) THEN
        CALL MTDSCR(MATRES)
        CALL JEVEUO(MATRES//'.&INT','E',LRES)
        CALL CBVALE(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,LRES,
     +              DDLEXC)
C ---   CAS OU LES MATRICES A COMBINER N'ONT PAS LE MEME PROFIL :
C       -------------------------------------------------------
      ELSE
        CALL PROLMA(MATRES, LIMAT, NBCOMB, BASE,' ',.TRUE.)
        CALL MTDSCR(MATRES)
        CALL JEVEUO(MATRES//'.&INT','E',LRES)
        CALL CBVAL2(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,
     +              LRES,DDLEXC)
      ENDIF
C
C --- AFFECTATION DE L'ETAT DE LA PREMIERE MATRICE A COMBINER
C --- A LA MATRICE RESULTAT
C --- CET ETAT NE PEUT ETRE QUE 'ASSE' PUISQUE L'ON NE FAIT PAS
C --- DE COMBINAISON LINEAIRE DE MATRICES DECOMPOSEES :
C     -----------------------------------------------
      CALL JEECRA(MATRES//'.REFA','DOCU',IBID,ETAMA1)
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
      CALL JELIRA(MATRES//'.REFA','CLAS',IBID,CLAS)
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
         CALL VERELI(NBCOMB, ZI(IDLIMA), IER)
         IF (IER.NE.0) THEN
              CALL UTMESS('F','MTCOMB','LES ELIM_DDL DES MATRICES'//
     +                     ' A COMBINER NE SONT PAS COHERENTS')
         ENDIF
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
         NBLIC = ZI(ZI(IDLIMA)+18)
C
C --- RECOPIE DE LA S.D. ELIM_DDL (SAUF LE .VALI)
C --- DE LA PREMIERE MATRICE A COMBINER SUR LA S.D. ELIM_DDL
C --- DE LA MATRICE RESULTAT :
C     ----------------------
         CALL JEDUPO(MAT1//'.CONI',CLAS, MATRES//'.CONI',.TRUE.)
         CALL JEDUPO(MAT1//'.LLIG',CLAS, MATRES//'.LLIG',.TRUE.)
         CALL JEDUPO(MAT1//'.ALIG',CLAS, MATRES//'.ALIG',.TRUE.)
         CALL JEDUPO(MAT1//'.ABLI',CLAS, MATRES//'.ABLI',.TRUE.)
C
         IF ( TYPRES(1:1) .EQ. 'R' ) THEN
             CALL JECREC(MATRES//'.VALI',CLAS//' V R','NU','DISPERSE',
     +                   'CONSTANT',NBLIC)
         ELSEIF ( TYPRES(1:1) .EQ. 'C' ) THEN
             CALL JECREC(MATRES//'.VALI',CLAS//' V C','NU','DISPERSE',
     +                   'CONSTANT',NBLIC)
         ENDIF
C
C --- LONGUEUR D'UN BLOC :
C     ------------------
         IF (ZI(ZI(IDLIMA)+6).EQ.1) THEN
             LGBLOC = ZI(ZI(IDLIMA)+14)
         ELSEIF (ZI(ZI(IDLIMA)+6).EQ.2) THEN
            CALL JEVEUO(MATRES//'.ABLI','L',IDABLI)
            CALL JEVEUO(MATRES//'.ALIG','L',IDALIG)
            CALL JEVEUO(MATRES//'.LLIG','L',IDLLIG)
            IMPFIN = ZI(IDABLI+NBLIC)
            ILOC = ZI(IDALIG+IMPFIN-1)
            IND = 2+3*(IMPFIN-1)
            JDEB = ZI(IDLLIG+IND+1-1)
            JFIN = ZI(IDLLIG+IND+2-1)
            LGBLOC = ILOC+JFIN-JDEB
         ENDIF
C
C --- CREATION DE LA COLLECTION .VALI DE LA MATRICE RESULTAT
C --- (AVEC LA BONNE LONGUEUR DE BLOC) :
C     --------------------------------
         IBLIC = 1
         CALL JECROC(JEXNUM(MATRES//'.VALI',IBLIC))
         CALL JEECRA(JEXNUM(MATRES//'.VALI',IBLIC),'LONMAX',LGBLOC,
     +                K8BID)
         DO 30 IBLIC = 2, NBLIC
            CALL JECROC(JEXNUM(MATRES//'.VALI',IBLIC))
  30    CONTINUE
C
C --- COMBINAISON LINEAIRE DES .VALI DES MATRICES :
C     -------------------------------------------
        CALL CBVALI(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,
     +              LRES)
C
C --- REMISE A 1 DES TERMES DIAGONAUX DES LIGNES ELIMINEES DU .VALE :
C     -------------------------------------------------------------
        CALL CIDIA1(TYPRES,LRES)
C
      ENDIF
C
C --- CONSTRUCTION DU DESCRIPTEUR DE LA MATRICE RESULTAT :
C     ==================================================
      CALL MTDSCR(MATRES)
      CALL JEVEUO(MATRES(1:19)//'.&INT','E',LRES)
C
C --- COMBINAISON LINEAIRE DES .CONL DES MATRICES SI NECESSAIRE :
C     =========================================================
      IF (DDLEXC.NE.'LAGR') THEN
        CALL MTCONL(NBCOMB,TYPCST,CONST,TYPMAT,ZI(IDLIMA),TYPRES,LRES)
      ELSE
        CALL JEDETR(ZK24(ZI(LRES+1))(1:19)//'.CONL')
      END IF
C
      CALL JEDETR('&&MTCOMB.LISPOINT')
C
      CALL JEDEMA()
      END
