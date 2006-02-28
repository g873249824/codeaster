      SUBROUTINE MLFC16(NOMMAT,NPIVOT,NEQ,TYPSYM,EPS)
      IMPLICIT NONE
      CHARACTER*(*) NOMMAT
      INTEGER NPIVOT,NEQ,IRET
      REAL*8 EPS
      INTEGER TYPSYM
      LOGICAL PILMEM
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 28/02/2006   AUTEUR VABHHTS J.PELLET 
C RESPONSABLE JFBHHUC C.ROSE
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
C     FACTORISATION DE GAUSS PAR LA MULTIFRONTALE
C     D'UNE MATRICE SYMETRIQUE A COEFFICIENTS REELS
C     DEVELOPPEMENT MAJEUR DU 14/02/00
C     I) VERSION MONOPROCESSEUR  OU PARALLELE MLTFC1 OU MLTFCB
C     II)GESTION DE LA MEMOIRE:
C     SI LA PILE TIENT ENTIERE EN MEMOIRE: MLTFC1
C     SINON APPEL A MLTFCB
C     MLTFC1 TRAVAILLE DE 1 A SBLOC-1, SUIVANT LE MODE
C     HABITUEL (3 BLOCS PERMANENTS EN MEMOIRE)
C     MLTFCB TRAVAILLE DE 1 A NBLOC, SUIVANT UN
C     MODE PLUS ECONOME EN MEMOIRE (2 BLOCS)
C     MAIS PLUS COUTEUX EN APPELS A JEVEUX
C     ------------------------------------------------------------------
C
C     IN  NOMMAT  :    : NOM UTILISATEUR DE LA MATRICE A FACTORISER
C
C     VAR PIVOT   : IS :
C     : EN SORTIE : NPIVOT  = 0 ==> R.A.Z.
C     :    NPIVOT  > 0 ==> MATRICE SINGULIERE
C     POUR L'EQUATION DE NUMERO NPIVOT
C     :    NPIVOT  < 0 ==> -NPIVOT TERMES DIAGONAUX < 0
C
C     IN  NEQ     : IS : NOMBRE TOTAL D'EQUATION
C
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      INTEGER IBID,IERD
      INTEGER K,NC,IERR,IER1
      CHARACTER*1  BASE
      CHARACTER*14 NU
      CHARACTER*19 NOMA19,SOLV19
      CHARACTER*24 NMPRVR,NMPRVI,NMPRV2,NMPRI2,NMPRCL,NMPRCU,NMPRT1
      CHARACTER*24 NOMLOC,FACTOL,FACTOU,NOMADI,NOMPIL,NMPRT2
      CHARACTER*24 NOMDIA,NMPILU,NOMPR1,NOMPR2
      CHARACTER*24 NOMP01,NOMP02,NOMP03,NOMP04,NOMP05,
     %     NOMP06,NOMP07,NOMP08,NOMP09,NOMP10,NOMP11,NOMP12,NOMP13,
     %     NOMP14,NOMP15,NOMP16,NOMP17,NOMP18,NOMP19,NOMP20
      INTEGER LDIAG,LONG,IFAC,SNI,SNI2,ISND,ADFAC0,ADFAC
      INTEGER TABPR,TABPI
      CHARACTER*32 JEXNUM
C     -------------------------------------------------- POINTEURS
      INTEGER POINTI,MATI,TEMPI
      INTEGER DIAG,SUPND,PARENT
      INTEGER SEQ,FILS,FRERE,ADRESS,LFRONT,NBLIGN,LGSN
      INTEGER NBASS,DECAL,LOCAL
      INTEGER ADPILE,LGBLOC,PILE
      INTEGER NCBLOC,ADINIT
C     -------------------------------------------------- VARIABLES
      INTEGER ANC,NOUV,TABI2,TABR2,I,J,TRAV1,TRAV2
      INTEGER LONMAT,NBSN
      INTEGER LGPILE,NBLOC,MXMATE,LN,ADBL1,ADBL2,MXABS
      INTEGER IB,DESC,IT(5),MI,MA,MXBLOC,IER,SBLOC,LTEMPR,NB
      REAL*8 TEMPS(6)
      INTEGER NPROC,IFM,NIV,LPMAX,IADIGS,MLNBPR,JSLVK
C     NB : ORDRE DES MATRICES CL ET CU (LES PRODUITS MATRICE*MATRICE)
C     96 EST OPTIMUM POUR EV68, 32 EST OPTIMUM POUR PENTIUM 4
      INTEGER CL,CU,LLBLOC,JREFA
C     ------------------------------------------------------------------
      DATA NOMPR1/'&&MLFC16.PROVISOI.REELS1'/
      DATA NOMPR2/'&&MLFC16.PROVISOI.REELS2'/
      DATA NMPRVI/'&&MLFC16.PROVISOI_ENTIE '/
      DATA NMPRV2/'&&MLFC16.PROVISOI.REELS '/
      DATA NMPRI2/'&&MLFC16.PROVISOI.ENTIE '/
      DATA NMPRVR/'&&MLFC16.PROVISOI_REELS '/
      DATA NMPRCL/'&&MLFC16.PROVISOI_REELS3'/
      DATA NMPRCU/'&&MLFC16.PROVISOI_REELS4'/
      DATA NMPRT1/'&&MLFC16.PROVISOI_REELS5'/
      DATA NMPRT2/'&&MLFC16.PROVISOI_REELS6'/
C
      DATA FACTOL/'                   .VALF'/
      DATA FACTOU/'                   .WALF'/
C
      DATA NOMPIL/'&&MLFC16.PILE_MATRICE_FR'/
      DATA NMPILU/'&&MLFC16.PILE_MATRICU_FR'/
      DATA NOMDIA/'                   .&VDI'/
C     ------------------------------------------------------------------
      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)
C----------------------------------------------------------------------
      NB=LLBLOC()
      NB=NB/2
      NOMA19 = NOMMAT
      NPIVOT = 0
      CALL DISMOI('F','NOM_NUME_DDL',NOMMAT,'MATR_ASSE',IBID,NU,IERD)


C     -- SI LE STOCKAGE STOC_MLTF N'EXISTE PAS, ON LE CREE :
      CALL JEEXIN(NU//'.MLTF.ADNT',IRET)
      IF (IRET.EQ.0) THEN
         CALL JELIRA(NU//'.SMOS.SMDI','CLAS',IBID,BASE)
         CALL DISMOI('F','SOLVEUR',NOMMAT,'MATR_ASSE',IBID,SOLV19,IERD)
         CALL JEVEUO(SOLV19//'.SLVK','L',JSLVK)
         CALL ASSERT(ZK24(JSLVK-1+1).EQ.'MULT_FRO')
         CALL MLTPRE(NU,BASE,ZK24(JSLVK-1+4))
      ENDIF

      NOMLOC = NU//'.MLTF.LOCL'
      NOMADI = NU//'.MLTF.ADNT'
      CALL MLNMIN(NU,NOMP01,NOMP02,NOMP03,NOMP04,NOMP05,
     %     NOMP06,NOMP07,NOMP08,NOMP09,NOMP10,NOMP11,NOMP12,NOMP13,
     %     NOMP14,NOMP15,NOMP16,NOMP17,NOMP18,NOMP19,NOMP20)
      IERR = 0
      FACTOL(1:19) = NOMMAT
      FACTOU(1:19) = NOMMAT
      CALL JEVEUO(NOMADI,'L',ADINIT)

      CALL JEVEUO(NOMP01,'L',DESC)
      CALL JEVEUO(NOMP16,'L',LGBLOC)
      CALL JEVEUO(NOMP08,'L',LGSN)

      NEQ = ZI(DESC)
      NOMDIA(1:19) = NOMMAT
      NBSN = ZI(DESC+1)
      NBLOC = ZI(DESC+2)
      LGPILE = ZI(DESC+3)
      IF (TYPSYM.EQ.0) LGPILE = 2*LGPILE
      LONMAT = ZI(DESC+4)
      CALL JELIBE(NOMP01)

C
      CALL MLTASC(NBLOC,ZI(LGBLOC),ZI(ADINIT),NOMMAT,LONMAT,FACTOL,
     +     FACTOU,TYPSYM)
      CALL JELIBE(NOMADI)
C
C     RECUPERATION DU NOMBRE DE PROCESSEURS
      NPROC = MLNBPR()
      CALL JEDISP(2,IT)

      MXBLOC = 0
      DO 20 I = 1,NBLOC
         MXBLOC = MAX(MXBLOC,ZI(LGBLOC+I-1))
 20   CONTINUE
      MI = MIN(MXBLOC,LGPILE)
      MA = MAX(MXBLOC,LGPILE)
      LPMAX = ZI(LGSN)
      MXMATE= LPMAX*(LPMAX+1)/2
      DO 10 I = 1,NBSN-1
         LN = ZI(LGSN+I)
         MXMATE = MAX(MXMATE,LN*(LN+1)/2)
         LPMAX = MAX(LPMAX,LN)
 10   CONTINUE
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) ' AVANT FACTORISATION '//'LONGUEURS DISPONIBLES ',
     +        IT(1),'ET ',IT(2),'LONGUEUR DE LA PILE ',LGPILE,
     +        ', PLUS GRAND BLOC DE FACTOL ',MXBLOC
         WRITE (IFM,*) 'PLUS GRAND BLOC DE MATRICES FRONTALES: ',MXMATE
         WRITE (IFM,*) ' NOMBRE DE PROCESSEURS : ',NPROC
         WRITE (IFM,*) ' TYPSYM : ',TYPSYM
      END IF
      PILMEM = MI .LE. IT(2) .AND. MA .LE. IT(1) .OR. (MI+MA) .LE. IT(1)
C     ON RESERVE LES PLACES DONT ON AURA BESOIN DANS LA FACTORISATION
C     (NOMPR1 ET NOMPR2) AVANT D'ALLOUER LES POINTEURS ENTIERS,
C     AFIN QU ILS NE SE PLACENT PAS AU MILIEU DUNE GRANDE ZONE.
      IF(PILMEM) THEN
C     ON ALLOUE LA PILE
         CALL WKVECT(NOMPIL,' V V C ',LGPILE,PILE)
         IF (NIV.EQ.2)       WRITE (IFM,*) ' => PILE TOUT EN MEMOIRE '
         CALL WKVECT(NOMPR1, ' V V C ',MXBLOC,ADBL1)
      ELSE
        IF (NIV.EQ.2)   WRITE (IFM,*) ' => PILE EN COLLECTION DISPERSEE'
         MXABS=MAX(MXBLOC,MXMATE)
         CALL WKVECT(NOMPR1, ' V V C ',MXBLOC,ADBL1)
         CALL WKVECT(NOMPR2, ' V V C ',MXABS,ADBL2)
      ENDIF
C

C--------------------------------------------------------------------
      CALL JEVEUO(NOMLOC,'L',LOCAL)
      CALL JEVEUO(NOMP03 ,'L',ADRESS)
      CALL JEVEUO(NOMP04 ,'L',SUPND)
      CALL JEVEUO(NOMP06 ,'L',FILS)
      CALL JEVEUO(NOMP07 ,'L',FRERE)
      CALL JEVEUO(NOMP08 ,'L',LGSN)
      CALL JEVEUO(NOMP09 ,'L',LFRONT)
      CALL JEVEUO(NOMP10 ,'L',NBASS)
      CALL JEVEUO(NOMP13 ,'L',ADPILE)
      CALL JEVEUO(NOMP14,'L',ANC)
      CALL JEVEUO(NOMP15 ,'L',NBLIGN)
      CALL JEVEUO(NOMP16 ,'L',LGBLOC)
      CALL JEVEUO(NOMP17 ,'L',NCBLOC)
      CALL JEVEUO(NOMP18 ,'L',DECAL)
      CALL JEVEUO(NOMP20 ,'L',SEQ)
      LTEMPR=NB*LPMAX*NPROC
      CALL WKVECT(NMPRT1,' V V C ',LTEMPR,TRAV1)
      CALL WKVECT(NMPRT2,' V V C ',LTEMPR,TRAV2)
      CALL WKVECT(NMPRCL,' V V C ',NPROC*NB**2,CL)
      CALL WKVECT(NMPRCU,' V V C ',NPROC*NB**2,CU)
      CALL WKVECT(NMPRV2,' V V C ',NEQ,TABR2)
      CALL WKVECT(NMPRVI,' V V I ',NEQ,TEMPI)
      CALL WKVECT(NMPRI2,' V V I ',NEQ,TABI2)
      CALL UTTCPU(7,'DEBUT',6,TEMPS)
C     3.2)                               ASSEMBLAGE ET FACTORISATION
C     APPEL A MLTFAS1
      IF (PILMEM) THEN
         CALL JEDETR(NOMPR1)
         CALL MLTCC1(NBLOC,ZI(NCBLOC),ZI(DECAL),
     +        ZI(SUPND),
     +        ZI(FILS),ZI(FRERE),ZI(SEQ),ZI(LGSN),ZI(LFRONT),
     +        ZI(ADRESS),ZI(LOCAL),ZI(ADPILE),ZI(NBASS),
     +        ZC(PILE),LGPILE,ZI(TEMPI),ZC(TRAV1),ZC(TRAV2),
     +        FACTOL,FACTOU,TYPSYM,ZI(TABI2),EPS,IERR,NB,ZC(CL),ZC(CU))
         IF (IERR.GT.0) GO TO 9998

      ELSE
         CALL JEDETR(NOMPR1)
         CALL JEDETR(NOMPR2)
C     ON ALLOUERA UNE COLLECTION DISPERSEE DANS MLTFCB
         SBLOC=1
         CALL MLTCCB(NBLOC,ZI(NCBLOC),ZI(DECAL),NBSN,
     +        ZI(SUPND),
     +        ZI(FILS),ZI(FRERE),ZI(SEQ),ZI(LGSN),ZI(LFRONT),
     +        ZI(ADRESS),ZI(LOCAL),ZI(ADPILE),ZI(NBASS),
     +        ZI(TEMPI),ZC(TRAV1),ZC(TRAV2),FACTOL,FACTOU,
     +        TYPSYM,ZI(TABI2),NOMPIL,NMPILU,EPS,IERR,SBLOC,NB,
     %        ZC(CL),ZC(CU))
         IF (IERR.GT.0) GO TO 9998
      END IF
      CALL JELIBE(NOMLOC)
C     RECUPERATION DE LA DIAGONALE 'APRES':
C     VERSION MODIFIEE POUR L' APPEL A DGEMV (PRODUITS MATRICE-VECTEUR)
C     LE STOCKAGE DES COLONNES DE LA FACTORISEE EST MODIFIE
C
C     --- CREATION/RAPPEL D'UN TABLEAU POUR STOCKER LA DIAGONALE ---
      CALL JEEXIN(NOMDIA,IER)
      IF (IER.EQ.0) THEN
         CALL JECREO(NOMDIA,'V V C')
         CALL JEECRA(NOMDIA,'LONMAX',NEQ,'  ')
      END IF
      CALL JEVEUO(NOMDIA,'E',LDIAG)
      ISND = 0
      DO 50 IB = 1,NBLOC
         CALL JEVEUO(JEXNUM(FACTOL,IB),'L',IFAC)
         ADFAC0 = IFAC - 1

         DO 40 NC = 1,ZI(NCBLOC+IB-1)
            ISND = ISND + 1
            SNI = ZI(SEQ+ISND-1)
            LONG =ZI(ADRESS+SNI)  - ZI(ADRESS+SNI-1)
            DO 30 K = 1,ZI(LGSN+SNI-1)
               ADFAC = ADFAC0 + (K-1)*LONG + K
               ZC(LDIAG-1+ZI(SUPND-1+SNI)+K-1) = ZC(ADFAC)
 30         CONTINUE
            ADFAC0 = ADFAC0 + LONG*ZI(LGSN+SNI-1)
 40      CONTINUE
         CALL JELIBE(JEXNUM(FACTOL,IB))
 50   CONTINUE
C     PIVOTS NEGATIFS :
      DO 60 I = 1,NEQ
         IF (ABS(ZC(LDIAG+I-1)).LT.0.D0) NPIVOT = NPIVOT - 1
 60   CONTINUE
      CALL JEVEUO(NOMA19//'.DIGS','E',IADIGS)
      DO 70 I = 1,NEQ
         J = ZI(ANC-1+I)
         ZR(IADIGS-1+NEQ+J) = ABS(ZC(LDIAG+I-1))
 70   CONTINUE
      CALL JELIBE(NOMA19//'.DIGS')



C     MATRICE SINGULIERE :
 9998 CONTINUE
      IF (IERR.NE.0) THEN
         NPIVOT = ZI(ANC-1+IERR)
      END IF

      CALL JEVEUO(NOMA19//'.REFA','E',JREFA)
      ZK24(JREFA-1+8)='DECT'


      CALL UTTCPU(7,'FIN  ',6,TEMPS)
      IF (NIV.EQ.2) THEN
         WRITE (IFM,*) ' FACTORISATION DE LA MATRICE.'//'TEMPS CPU',
     +        TEMPS(3),' + TEMPS CPU SYSTEME ',TEMPS(6)
      END IF
      CALL JEDETR(NMPRT1)
      CALL JEDETR(NMPRT2)
      CALL JEDETR(NMPRCL)
      CALL JEDETR(NMPRCU)
      CALL JEDETR(NMPRI2)
      CALL JEDETR(NMPRV2)
      CALL JEDETR(NMPRVR)
      CALL JEDETR(NMPRVI)
      CALL JEDETR(NOMPIL)
      CALL JEDETR(NMPILU)
      CALL JELIBE(NOMP01)
      CALL JELIBE(NOMP03)
      CALL JELIBE(NOMP04)
      CALL JELIBE(NOMP06)
      CALL JELIBE(NOMP07)
      CALL JELIBE(NOMP08)
      CALL JELIBE(NOMP09)
      CALL JELIBE(NOMP10)
      CALL JELIBE(NOMP13)
      CALL JELIBE(NOMP14)
      CALL JELIBE(NOMP15)
      CALL JELIBE(NOMP16)
      CALL JELIBE(NOMP17)
      CALL JELIBE(NOMP18)
      CALL JELIBE(NOMP19)
      CALL JELIBE(NOMP20)
      CALL JEDEMA()
      END
