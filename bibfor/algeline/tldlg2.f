      SUBROUTINE TLDLG2(LMAT  ,NPREC ,NMRIG ,NOMSOL,INPN  ,
     &                  BASE)
C  
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      INTEGER      LMAT,NPREC,NMRIG,INPN
      CHARACTER*1  BASE
      CHARACTER*19 NOMSOL

C
C ----------------------------------------------------------------------
C
C  RECHERCHE DE MODES DE CORPS RIGIDE PAR DECOMPOSITION DE GAUSS
C
C ----------------------------------------------------------------------
C
C
C          POUR LE PROBLEME AUX VALEURS PROPRES :
C                        (K) X = 0
C          LA MATRICE (K) EST REELLE SYMETRIQUE
C          LES VALEURS PROPRES ET LES VECTEURS PROPRES SONT REELS
C          ON DECOMPOSE (K) SOUS LA FORME
C                        (  KEE   KER  )
C                        (  TKER  KRR  )
C          AVEC DIM DE KRR = NOMBRE DE MODES DE CORPS RIGIDE DE (K)
C          ET KEE INVERSIBLE
C          LES MODES DE CORPS RIGIDE SONT LES VECTEURS DE LA MATRICE
C                   (  KEE(-1)KER  )
C                   (     -ID(R)    )
C          ET OBTENUS AVEC DES ROUTINES DEVELOPPPEES POUR TRAITER LES
C          BLOCAGES CINEMATIQUES
C  
C IN  LMAT   : DESCRIPTEUR DE LA MATRICE
C                DONT ON CHERCHE LES MODES RIGIDES
C IN  NPREC  : SI DIFFERENT DE 0,NIVEAU DE PERTE DE DECIMALES A PARTIR
C                DUQUEL ON CONSIDERE QU'UN PIVOT EST NUL.SI 0, CE SERA 8
C OUT NMRIG  : NOMBRE DE MODES DE CORPS RIGIDE
C OUT NOMSOL : NOM DE LA MATRICE DES MODES DE CORPS RIGIDE
C                ATTENTION, CONVENTION DE NOM: SI NOMSOL(9:14)='.FETI.'
C                ALORS RECHERCHE DE CORPS RIGIDE POUR FETI
C I/O INPN   : VECTEUR DES INDICES DE PIVOTS NULS
C IN  BASE   : BASE SUR LAQUELLE EST CREE LA MATR_ASSE
C
C  SI FETI: LA MATRICE DE TRAVAIL RESSORT FACTORISEE AU MOINS PARTIEL
C           LEMENT. OBJET .VALF REMPLI
C
C     ASTER INFORMATIONS:
C       17/05/04 (OB): MODIF. POUR MODES DE CORPS RIGIDES FETI
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*8  NOMNO,NOMCMP,TARDIF,METRES,RENUM
      CHARACTER*14 NU
      CHARACTER*19 NOMA19,NOMB19,LIGREL
      CHARACTER*24 INFOFE
      CHARACTER*40 INFOBL
      COMPLEX*16 CBID
      INTEGER NDECI,ISINGU,NOM,NEQ,TYPVAR,TYPSYM,NAUX,MADR
      INTEGER LMATB,NDIGI2,NPIVOT
      INTEGER IFM,NIV
      INTEGER PASS,I,IEQ,J,JEQ,ILIS,IOUIA,NADR,IBID,LXSOL
      INTEGER LCINE,IDEC1,K,IDECI,IDECJ,COMPT,IINF,LADR1,LADR2
      INTEGER JDIGS,JREFAB,JCCID
      REAL*8 EPSB,D1,ANORM,MOYDIA
      LOGICAL LFETI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

C EXTRACTION DES DONNEES DE LA MATRICE LMAT
      NOM = ZI(LMAT+1)
      NEQ = ZI(LMAT+2)
      TYPVAR = ZI(LMAT+3)
      TYPSYM = ZI(LMAT+4)
      NOMA19 = ZK24(NOM) (1:19)
      CALL DISMOI('F','NOM_NUME_DDL',NOMA19,'MATR_ASSE',IBID,NU,IBID)

C TEST POUR SAVOIR SI METHODE DE RESOLUTION FETI
      IF (NOMSOL(9:14).EQ.'.FETI.') THEN
        LFETI = .TRUE.
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE = ZK24(IINF)
        CALL INFMUE()
        CALL INFNIV(IFM,NIV)
      ELSE
        LFETI = .FALSE.
        INFOFE = 'FFFFFFFF'
      END IF
      METRES = 'MULT_FRO'
      RENUM = 'METIS'


C POUR DEBRANCHER TEST DE MOORE-PENROSE
      INFOFE(9:9) = 'F'


C MONITORING ET TESTS
      IF (NIV.GE.2) THEN
        WRITE (IFM,*)
     &    '<TLDLG2> RECHERCHE DE MODES RIGIDES DE LA MATRICE :',NOMA19
        WRITE (IFM,*) '<TLDLG2>DESCRIPTION DE LA MATRICE ',NOMA19,':'
      END IF

      IF (TYPSYM.EQ.1) THEN
        IF (NIV.GE.2) WRITE (IFM,*) '<TLDLG2> MATRICE SYMETRIQUE'

      ELSE
        IF (NIV.GE.2) WRITE (IFM,*) '<TLDLG2> MATRICE NON-SYMETRIQUE'
        CALL U2MESS('F','ALGELINE3_46')
      END IF

      IF (TYPVAR.EQ.1) THEN
        IF (NIV.GE.2) WRITE (IFM,*) '<TLDLG2> MATRICE REELLE'

      ELSE
        IF (NIV.GE.2) WRITE (IFM,*) '<TLDLG2> MATRICE COMPLEXE'
        CALL U2MESS('F','ALGELINE3_47')
      END IF

      IF (NIV.GE.2) WRITE (IFM,*) '<TLDLG2> METHODE MULT_FRONT'



C PERTE DE DECIMALES POUR LAQUELLE ON CONSIDERE LE PIVOT NUL.
C DEFAUT: 8
      IF (NPREC.EQ.0) THEN
        NDIGI2 = 8
      ELSE
        NDIGI2 = NPREC
      END IF

      NMRIG = 0

C CE VECTEUR CONTIENDRA DES 0,ET LE NUMERO,LA OU ON A BLOQUE
      CALL WKVECT('&&TLDLG2.POSMODRI','V V I ',NEQ,IOUIA)

C CREATION DE LA MATRICE TAMPON
      NOMB19 = '&&TLDLG2.COPIEMATA '
      CALL COPISD('MATR_ASSE','V',NOMA19,NOMB19)
      CALL MTDSCR(NOMB19)
      CALL JEVEUO(NOMB19//'.REFA','E',JREFAB)
      CALL JEVEUO(NOMB19//'.&INT','E',LMATB)
C  CREATION DE L'OBJET .DIGS: DIAGONALE AVANT ET APRES
      CALL DIAGAV(NOMB19,NEQ,TYPVAR,EPSB)
      CALL JEVEUO(NOMB19//'.DIGS','L',JDIGS)


C RECHERCHE DES PIVOTS NULS-------------------------------------------

        IF (TYPVAR.EQ.1) THEN
          IF (TYPSYM.EQ.1) THEN
C          DEBUT BOUCLE: TANT QUE 'IL EXISTE PIVOT NUL'
   50       CONTINUE
            PASS = 0
C FACTORISATION DE B: SI NPIVOT.NE.0 ALORS KI SINGULIERE ET NPIVOT
C CONTIENT LE NUMERO DE LIGNE DU PREMIER PIVOT .LT. EPSB
            CALL MULFR8(NOMB19,NPIVOT,NEQ,TYPSYM,EPSB,RENUM)
C DEBUT TEST PIVOT VRAIMENT NUL-------------------
            IF (NPIVOT.GE.1) THEN
              ISINGU = NPIVOT
              IF (NIV.GE.2) WRITE (IFM,*)
     &            '<TLDLG2> PIVOT VRAIMENT NUL A LA LIGNE ',ISINGU
              CALL DISMOI('F','NOM_NUME_DDL',NOMA19,'MATR_ASSE',IBID,NU,
     &                    IBID)
              IF (NU.NE.' ') THEN
                CALL RGNDAS('NUME_DDL',NU,ISINGU,NOMNO,NOMCMP,TARDIF,
     &                      LIGREL,INFOBL)
                IF (NIV.GE.2) THEN
                  WRITE (IFM,*) '<TLDLG2> NOEUD ',NOMNO,' CMP ',NOMCMP
                  WRITE (IFM,*) '         TARDIF ',TARDIF,'INFOBL ',
     &              INFOBL
                END IF

              ELSE
                CALL U2MESK('A','ALGELINE3_48',1,NOMA19)
              END IF
C FIN EXTRACTION DE RENSEIGNEMENTS SUR DDL DU PIVOT NUL
              IF (LFETI) ZI(INPN+NMRIG) = ISINGU
              PASS = 1
              NMRIG = NMRIG + 1
              ZI(IOUIA-1+ISINGU) = NMRIG
C FIN TEST PIVOT VRAIMENT NUL---------------------
            ELSE
C DEBUT BOUCLE TESTS Q-NULLITE DE PIVOT-----------

              DO 60 IEQ = 1,NEQ
                D1 = ZR(JDIGS-1+IEQ)/ZR(JDIGS+NEQ-1+IEQ)
                IF (D1.GT.0.D0) THEN
                  NDECI = INT(LOG10(D1))
                  ISINGU = IEQ

                ELSE
                  NDECI = 0
                END IF
C DEBUT TEST NULLITE DE PIVOT
                IF (NDECI.GE.NDIGI2) THEN

C EXTRACTION DE RENSEIGNEMENTS SUR DDL DU PIVOT NUL
                  IF (NIV.GE.2) THEN
                    WRITE (IFM,*)
     &                '<TLDLG2> PIVOT QUASIMENT NUL A LA LIGNE ',ISINGU
                    WRITE (IFM,*)
     &                '<TLDLG2> NOMBRE DE DECIMALES PERDUES : ',NDECI
                  END IF

                  CALL DISMOI('F','NOM_NUME_DDL',NOMA19,'MATR_ASSE',
     &                        IBID,NU,IBID)
                  IF (NU.NE.' ') THEN
                    CALL RGNDAS('NUME_DDL',NU,ISINGU,NOMNO,NOMCMP,
     &                          TARDIF,LIGREL,INFOBL)
                    IF (NIV.GE.2) THEN
                      WRITE (IFM,*) '<TLDLG2> NOEUD ',NOMNO,' CMP ',
     &                  NOMCMP
                      WRITE (IFM,*) '         TARDIF ',TARDIF,'INFOBL ',
     &                  INFOBL
                    END IF

                  ELSE
                    CALL U2MESK('A','ALGELINE3_48',1,NOMA19)
                  END IF
C FIN EXTRACTION DE RENSEIGNEMENTS SUR DDL DU PIVOT NUL
                  IF (LFETI) ZI(INPN+NMRIG) = ISINGU
                  PASS = 1
                  NMRIG = NMRIG + 1
                  ZI(IOUIA-1+ISINGU) = NMRIG
                END IF

   60         CONTINUE
C FIN BOUCLE TESTS DE Q-NULLITE DU PIVOT----------

            END IF

            IF (PASS.NE.0) THEN
              GO TO 70

            ELSE
              GO TO 80

            END IF

   70       CONTINUE

C REINITIALISATION DE B-------------------------------------

            CALL DETRSD('MATR_ASSE',NOMB19)
            NOMB19 = '&&TLDLG2.COPIEMATA '
            CALL COPISD('MATR_ASSE','V',NOMA19,NOMB19)
            CALL MTDSCR(NOMB19)
C           -- BLOCAGE 'CINEMATIQUE' DU/DES DDL A PIVOT NUL
            CALL JEVEUO(NOMB19//'.REFA','E',JREFAB)
            IF (ZK24(JREFAB-1+3).EQ.'ELIMF') CALL MTMCHC(NOMB19,'ELIML')
            CALL ASSERT (ZK24(JREFAB-1+3).NE.'ELIMF')
            IF (ZK24(JREFAB-1+3).EQ.'ELIML') THEN
               CALL JEVEUO(NOMB19//'.CCID','E',JCCID)
            ELSE
               CALL WKVECT(NOMB19//'.CCID','V V I',NEQ+1,JCCID)
            ENDIF
            DO 77, IEQ=1,NEQ
               IF (ZI(IOUIA-1+IEQ).GT.0) ZI(JCCID-1+IEQ)=1
 77         CONTINUE
            ZI(JCCID-1+NEQ+1)=NMRIG
            ZK24(JREFAB-1+3)='ELIML'
            CALL MTMCHC(NOMB19,'ELIMF')
            CALL DIAGAV(NOMB19,NEQ,TYPVAR,EPSB)
            CALL JEVEUO(NOMB19//'.DIGS','L',JDIGS)
            GO TO 50

   80       CONTINUE
          END IF
        END IF

C FIN RECHERCHE DES PIVOTS NULS---------------------------------------

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C TESTS NOMBRES DE MODES DE CORPS RIGIDE
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IF (NIV.GE.1) THEN
        WRITE (IFM,9000)
        WRITE (IFM,*) '<TLDLG2> NB DE MODES DE CORPS RIGIDES'//
     &    ' DETECTES: ',NMRIG
      END IF

      IF (NMRIG.GE.7) CALL U2MESS('A','ALGELINE3_49')

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C SI FETI: COPIE DE LA FACTORISEE TEMPORAIRE NOMB19.VALF DANS CELLE
C  DEFINITIVE NOMA19.VALF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IF (LFETI) THEN
        CALL JEEXIN(NOMA19//'.VALF',IBID)
        IF (IBID.GT.0) THEN
          CALL U2MESK('F','ALGELINE3_50',1,NOMA19)
        ELSE
          CALL JEDUPO(NOMB19//'.VALF',BASE,NOMA19//'.VALF',.FALSE.)
        END IF
      END IF


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DEBUT CALCUL DE MODES DE CORPS RIGIDE
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IF (NMRIG.NE.0) THEN
        CALL MTDSCR(NOMB19)
        CALL JEVEUO(NOMB19//'.&INT','E',LMATB)

C CONSTRUCTION DES SECONDS MEMBRES DU TYPE (KER -ID(R)) DANS ---------
C ZR(LXSOL, LXSOL+NEQ .... LXSOL+(NMRIG-1)*NEQ) POUR R VARIANT -------
C DE 1 A NMRIG                                                --------

C ALLOCATION DES VECTEURS AUXILIAIRES ET SOLUTION
        CALL WKVECT(NOMSOL,'V V R ',NEQ*NMRIG,LXSOL)
        CALL WKVECT('&&TLDLG2.TLSECCIN','V V R ',NEQ*NMRIG,LCINE)

C REMPLISSAGE POUR AVOIR FI=0 ET U0=-1 (NOTATION CSMBGG)
        ILIS = 1
        DO 90 JEQ = 1,NEQ
          IF (ZI(IOUIA+JEQ-1).NE.0) THEN
            ZR(LCINE+ (ILIS-1)*NEQ+JEQ-1) = -1.D0
            ILIS = ILIS + 1
          END IF

   90   CONTINUE

C-----------------------------------------------------------
C CSMBGG : CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES
C DDLS IMPOSEES LORSQU'ILS SONT TRAITEES PAR ELIMINATION
C        ! K    K   ! E POUR ESSENTIEL, R POUR REDONDANT
C K  =   !  EE   ER !
C        !  T       !
C        ! K    K   !
C        !  RE   RR !
C  LE TRAITEMENT PAR ELIMINATION CONSISTE A RESOUDRE
C    ! K    0 !   ! X  !   ! FI  -K  U0!
C    !  EE    !   !  E !   !      ER   !
C    !        ! * !    ! = !           ! <=> K'(R) X(R) = F'(R)
C    ! 0    1 !   ! X  !   ! 0     U0  !
C    !        !   !  R !   !           !
C ZR(LXSOL+(R-1)*NEQ) = F'(R)

        DO 100 ILIS = 1,NMRIG
          CALL CSMBGG(LMATB,ZR(LXSOL+ (ILIS-1)*NEQ),
     &                ZR(LCINE+ (ILIS-1)*NEQ),CBID,CBID,'R')
  100   CONTINUE

C SCALING VIA ALPHA DES COMPOSANTES DU SECOND MEMBRE DUES AUX LAGRANGES
C SYSTEME: K * U= ALPHA * F ---> K * U/ALPHA = F
C SCALING INUTILE CAR LE SECOND MEMBRE N'EST PAS LE SECOND MEMBRE
C INITIAL, VOIRE CONDUISANT A UN RESULTAT FAUX SI ON ELIMINE UN DDL
C CONCERNE PAR UNE RELATION DE LAGRANGE (AFFE_CHAR_MECA)
C ZR(LXSOL) CONTIENT U/ALPHA
        CALL RLDLG3(METRES,LMATB,ZR(LXSOL),CBID,NMRIG)
C LA ENCORE, SCALING
C SCALING DES COMPOSANTES DE ZR(LXSOL) POUR CONTENIR LA SOL. REELLE U
      END IF

      CALL DETRSD('MATR_ASSE',NOMB19)

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C VERIFICATION DES MODES DE CORPS RIGIDES ET DE LA PSEUDO-INVERSE
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IF ((INFOFE(6:6).EQ.'T') .AND. LFETI) THEN

        IF (NMRIG.NE.0) THEN
C VALEUR ABSOLUE MOYENNE DE LA DIAGONALE
          MOYDIA = 0.D0
          DO 110 IEQ = 1,NEQ
            MOYDIA = MOYDIA + ABS(ZR(JDIGS-1+IEQ))
  110     CONTINUE
          WRITE (IFM,*) '<TLDLG2> MOYENNE DES TERMES DIAGONAUX ',
     &      MOYDIA/NEQ

C NORME L1(K*UI) / NORME L1(KII)
          NAUX = NEQ*NMRIG
          CALL WKVECT('&&TLDLG2.VERIFMCR','V V R',NAUX,LADR1)
          CALL MRMULT('ZERO',LMAT,ZR(LXSOL),'R',ZR(LADR1),NMRIG)
          DO 130 I = 1,NMRIG
            ANORM = 0.D0
            DO 120 J = 1,NEQ
              ANORM = ANORM + ABS(ZR(LADR1+ (I-1)*NMRIG+J-1))
  120       CONTINUE
            ANORM = 100.D0*ANORM/MOYDIA
            WRITE (IFM,*) '<TLDLG2> TEST K*MCR(J)/K (EN %) ',I,ANORM
  130     CONTINUE
          CALL JEDETR('&&TLDLG2.VERIFMCR')
        END IF
C VERIF CONDITION DE MOORE-PENROSE
C CALCUL DE (KIDD)- * FIDD PAR MULT_FRONT
C A RESERVER AU DEVELOPPEUR POUR LA MISE AU POINT OU LA MAINTENANCE
C CORRECTIVE CAR TRES COUTEUX EN MEMOIRE ET CPU
        IF (INFOFE(9:9).EQ.'T') THEN
          NAUX = NEQ*NEQ
          CALL WKVECT('&&TLDLG2.VERIFPSI1','V V R',NAUX,LADR2)
          CALL WKVECT('&&TLDLG2.VERIFPSI2','V V R',NAUX,MADR)
          NAUX = NEQ* (NEQ+1)/2
          CALL WKVECT('&&TLDLG2.VERIFPSI3','V V R',NAUX,NADR)
          CALL COPMA2(NOMA19,ZR(LADR2),ZR(MADR))
          CALL RLTFR8(NOMA19,NEQ,ZR(MADR),NEQ,TYPSYM)
          IF (NMRIG.NE.0) THEN
            DO 150 I = 1,NMRIG
              IDEC1 = ZI(INPN+I-1)
              DO 140 J = 1,NEQ
                ZR(MADR-1+ (J-1)*NEQ+IDEC1) = 0.D0
  140         CONTINUE
  150       CONTINUE
          END IF

          IDEC1 = NADR
          ANORM = 0.D0
          COMPT = 0
          DO 180 J = 1,NEQ
            IDECJ = (J-1)*NEQ + MADR - 1
            DO 170 I = J,NEQ
              IDECI = LADR2 - 1 + I
              MOYDIA = ZR(IDECI+ (J-1)*NEQ)
              ZR(IDEC1) = -MOYDIA
              DO 160 K = 1,NEQ
                ZR(IDEC1) = ZR(IDEC1) + ZR(IDECI+ (K-1)*NEQ)*ZR(IDECJ+K)
  160         CONTINUE
              IF (ABS(MOYDIA).NE.0.D0) THEN
                ANORM = ANORM + ABS(ZR(IDEC1)/MOYDIA)
                COMPT = COMPT + 1
              END IF

              IDEC1 = IDEC1 + 1
  170       CONTINUE
  180     CONTINUE
          ANORM = 100.D0*ANORM/COMPT
          WRITE (IFM,*) '<TLDLG2> TEST K*(K)+*K-K/K (EN %) ',ANORM
          WRITE (IFM,*) '<TLDLG2> NBRE TERMES TOTAUX/NEGLIGES ',NAUX,
     &      NAUX - COMPT
          CALL JEDETR('&&TLDLG2.VERIFPSI1')
          CALL JEDETR('&&TLDLG2.VERIFPSI2')
          CALL JEDETR('&&TLDLG2.VERIFPSI3')
        END IF

      END IF


C NETTOYAGE ET SORTIE-------------------------------------------------
  190 CONTINUE
      IF (NIV.GE.1) WRITE (IFM,9010)
      CALL JEDETC(' ','&&TLDLG2',1)
      IF (LFETI) CALL INFBAV()
      CALL JEDEMA()

 9000 FORMAT (72X,/)
 9010 FORMAT (72 ('-'),/)
      END
