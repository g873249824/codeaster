      SUBROUTINE SSPACE(LRAID,LMATRA,LMASS,NEQ,NBVEC,NFREQ,LPROD,ITEMAX,
     &                  NPERM,TOL,TOLDYN,VECT,VALPRO,NITJAC,NITBAT)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER LRAID,LMATRA,LMASS,LVEC,NEQ,NBVEC,NFREQ
      INTEGER LPROD(NEQ),ITEMAX,NPERM,NITJAC,NITBAT
      REAL*8 TOL,TOLDYN,VALPRO(NBVEC),VECT(NEQ,NBVEC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 20/01/2004   AUTEUR NICOLAS O.NICOLAS 
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
C     ------------------------------------------------------------------
C BUT : RESOLUTION DU PROBLEME GENERALISE AUX VALEURS PROPRES PAR UNE
C       METHODE D ITERATIONS SIMULTANEES EN SOUS-ESPACE
C       CHOIX DES VECTEURS INITIAUX ET PREPARATION DES MATRICES
C       REDUITES POUR UTILISER L ALGORITHME DE RECHERCHE DE VALEURS
C       PROPRES BASE SUR LA DECOMPOSITION DE JACOBI

C     IN  : LRAID  : DESCRIPTEUR DE LA MATRICE DE RAIDEUR DECALEE
C     IN  : LMATRA : DESCRIPTEUR DE CETTE MEME MATRICE MAIS DECOMPOSEE
C     IN  : LMASS  : DESCRIPTEUR DE LA MATRICE DE MASSE
C     IN  : NEQ    : DIMENSION DU PROBLEME COMPLET
C     IN  : NBVEC  : NOMBRE DE VECTEURS INITIAUX
C     IN  : NFREQ  : NOMBRE DE FREQUENCES DEMANDEES
C     IN  : LPROD  : TABLEAUX DES DDL A UTILISER (ACTIFS + LAGRANGES)
C     IN  : ITEMAX : NOMBRE MAX D'ITERATIONS SUR LE SOUS ESPACE
C     IN  : NPERM  : NOMBRE MAX D'ITERATIONS DE LA METHODE DE JACOBI
C     IN  : TOL    : PRECISION DE CONVERGENCE
C     IN  : TOLDYN : PRECISION DE PETITESSE DYNAMIQUE
C     OUT : VECT  : VECTEURS PROPRES DU SYSTEME COMPLET
C     OUT : VALPRO : VALEURS PROPRES
C     OUT : NITJAC : NOMBRE MAXIMAL ATTEINT D'ITERATIONS DANS JACOBI
C     OUT : NITBAT : NOMBRE MAXIMAL ATTEINT D'ITERATIONS DE BATHE ET W.

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER IABLO,NBBLOC,IADIA,IDEB,TYPE,IORDRE
      LOGICAL ICONVF
      CHARACTER*24 VALE
      COMPLEX*16 CBID
C     ------------------------------------------------------------------
      DATA VALE/'                   .VALE'/

C     ------------------------------------------------------------------
C     ------   PREMIERE DECLARATION DE VARIABLES AUXILLIAIRES   --------
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CALL WKVECT('&&SSPACE.IPOS','V V I',NEQ,IIPOS)
      CALL WKVECT('&&SSPACE.FPOS','V V I',NBVEC,IFPOS)
      CALL WKVECT('&&SSPACE.RDIAK','V V R',NEQ,IRDIAK)
      CALL WKVECT('&&SSPACE.RDIAM','V V R',NEQ,IRDIAM)
      CALL WKVECT('&&SSPACE.VECT','V V R',NEQ,IVECT)

C     ------------------------------------------------------------------
C     -----   CONSTRUCTION DES VECTEURS INITIAUX DU SOUS ESPACE   ------
C     ------------------------------------------------------------------

C     - ON CHERCHE LA DIAGONALE DE LA RAIDEUR ET ON REMPLIT ZR(IRDIAK) -

      CALL MTDSC2(ZK24(ZI(LRAID+1)),'ADIA','L',IADIA)
      CALL MTDSC2(ZK24(ZI(LRAID+1)),'ABLO','L',IABLO)
      NBBLOC = ZI(LRAID+13)
      VALE(1:19) = ZK24(ZI(LRAID+1))
      IDEB = 1
      DO 20 IBLOC = 1,NBBLOC
        IL = ZI(IABLO+IBLOC)
        CALL JEVEUO(JEXNUM(VALE,IBLOC),'L',IAA)
        DO 10 JJ = IDEB,IL
          ZR(IRDIAK+JJ-1) = ZR(IAA+ZI(IADIA+JJ-1)-1)
   10   CONTINUE
        IDEB = IL
        CALL JELIBE(JEXNUM(VALE,IBLOC))
   20 CONTINUE

C     - ON CHERCHE LA DIAGONALE DE LA MASSE ET ON REMPLIT ZR(IRDIAM) -

      CALL MTDSC2(ZK24(ZI(LMASS+1)),'ADIA','L',IADIA)
      CALL MTDSC2(ZK24(ZI(LMASS+1)),'ABLO','L',IABLO)
      NBBLOC = ZI(LMASS+13)
      VALE(1:19) = ZK24(ZI(LMASS+1))
      IDEB = 1
      DO 40 IBLOC = 1,NBBLOC
        IL = ZI(IABLO+IBLOC)
        CALL JEVEUO(JEXNUM(VALE,IBLOC),'L',IAA)
        DO 30 JJ = IDEB,IL
          ZR(IRDIAM+JJ-1) = ZR(IAA+ZI(IADIA+JJ-1)-1)
   30   CONTINUE
        IDEB = IL
        CALL JELIBE(JEXNUM(VALE,IBLOC))
   40 CONTINUE

C     --- ON CHERCHE LES PLUS PETITS RAPPORTS K/M ---

      CALL SSTRIV(ZR(IRDIAK),ZR(IRDIAM),LPROD,ZI(IIPOS),NEQ)

C     --- ON INITIALISE LES VECTEURS ---

      DO 50 I = 1,NEQ
        VECT(I,1) = ZR(IRDIAM+I-1)*LPROD(I)
   50 CONTINUE

      ICOMP = 0
      DO 70 I = 2,NBVEC - 1
   60   CONTINUE
        IF (LPROD(ZI(IIPOS+I+ICOMP-1-1)).EQ.0) THEN
          ICOMP = ICOMP + 1
          GO TO 60
        ELSE
          VECT(ZI(IIPOS+I+ICOMP-1-1),I) = 1.D0
        END IF
   70 CONTINUE

      DSEED = 123457.D0
      CALL GGUBS(DSEED,NEQ,VECT(1,NBVEC))
      DO 80 I = 1,NEQ
        VECT(I,NBVEC) = VECT(I,NBVEC)*LPROD(I)
   80 CONTINUE

C     ------------------------------------------------------------------
C     ------   DEUXIEME DECLARATION DE VARIABLES AUXILLIAIRES   --------
C     -- DESTRUCTION D'UNE PARTIE DES PREMIERES VARIABLES AUXILLIAIRES -
C     ------------------------------------------------------------------

      CALL WKVECT('&&SSPACE.AR','V V R',NBVEC* (NBVEC+1)/2,IAR)
      CALL WKVECT('&&SSPACE.BR','V V R',NBVEC* (NBVEC+1)/2,IBR)
      CALL WKVECT('&&SSPACE.VECPRO','V V R',NBVEC*NBVEC,IVECPR)
      CALL WKVECT('&&SSPACE.TEMPOR','V V R',NBVEC,ITEMPO)
      CALL WKVECT('&&SSPACE.TOLVEC','V V R',NBVEC,ITOLVE)
      CALL WKVECT('&&SSPACE.JACOBI','V V R',NBVEC,IJAC)

C     ------------------------------------------------------------------
C     -------------------   PROCESSUS ITERATIF   -----------------------
C     ------------------------------------------------------------------

      NITJAC = 0
      NITBAT = 0
      ICONV = 0
      ICONVF = .FALSE.
      ITER = 0
C     --- NOMBRE DE FREQUENCES CONVERGEES SOUHAITEES
      NFRCV = NFREQ + (NBVEC-NFREQ)/2

   90 CONTINUE

      ITER = ITER + 1

C     --- CALCUL DE LA MATRICE SYMETRIQUE DE RAIDEUR PROJETEE ---
C     ---       ON NE STOCKE QUE LA MOITIE DE LA MATRICE      ---

      II = 0
      DO 140 JJ = 1,NBVEC
        DO 100 KK = 1,NEQ
          ZR(IVECT+KK-1) = VECT(KK,JJ)*LPROD(KK)
  100   CONTINUE
        CALL RLDLGG(LMATRA,ZR(IVECT),CBID,1)
        DO 120 LL = JJ,NBVEC
          ART = 0.D0
          DO 110 KK = 1,NEQ
            ART = ART + VECT(KK,LL)*ZR(IVECT+KK-1)*LPROD(KK)
  110     CONTINUE
          II = II + 1
          ZR(IAR+II-1) = ART
  120   CONTINUE
        DO 130 KK = 1,NEQ
          VECT(KK,JJ) = ZR(IVECT+KK-1)*LPROD(KK)
  130   CONTINUE
  140 CONTINUE

C     --- CALCUL DE LA MATRICE SYMETRIQUE DE MASSE PROJETEE ---
C     ---       ON NE STOCKE QUE LA MOITIE DE LA MATRICE    ---

      II = 0
      DO 180 JJ = 1,NBVEC
        CALL MRMULT('ZERO',LMASS,VECT(1,JJ),'R',ZR(IVECT),1)
        DO 160 LL = JJ,NBVEC
          BRT = 0.0D0
          DO 150 KK = 1,NEQ
            BRT = BRT + VECT(KK,LL)*ZR(IVECT+KK-1)*LPROD(KK)
  150     CONTINUE
          II = II + 1
          ZR(IBR+II-1) = BRT
  160   CONTINUE
        IF (ICONV.LE.0) THEN
          DO 170 KK = 1,NEQ
            VECT(KK,JJ) = ZR(IVECT+KK-1)
  170     CONTINUE
        END IF
  180 CONTINUE

C     --- ALGORITHME DE JACOBI SUR LES MATRICES PROJETEES ---
C     --- CLASSEMENT PAR ORDRE CROISSANT DES VALEURS PROPRES  ---
C     ---   ET DONC DES VECTEURS PROPRES DU SYSTEME PROJETE   ---

      TYPE = 1
      IORDRE = 0
      CALL JACOBI(NBVEC,NPERM,TOL,TOLDYN,ZR(IAR),ZR(IBR),ZR(IVECPR),
     &            VALPRO,ZR(IJAC),NITJA,TYPE,IORDRE)
      IF (NITJA.GT.NITJAC) THEN
        NITJAC = NITJA
      END IF

  190 CONTINUE

C     --- CALCUL DES VECTEURS PROPRES DU SYSTEME COMPLET ---

      CALL VPRECO(NBVEC,NEQ,ZR(IVECPR),VECT)

C     --- TEST DE CONVERGENCE SUR LES VALEURS PROPRES ---
C     ---        SEULEMENT LES NFREQ PREMIERES        ---

      IF (ICONV.LE.0) THEN
        DO 200 I = 1,NFRCV
          ZR(ITOLVE+I-1) = ABS(VALPRO(I)-ZR(ITEMPO+I-1))
  200   CONTINUE
        DO 210 I = 1,NFRCV
          IF (ZR(ITOLVE+I-1).GT.TOL*ABS(VALPRO(I))) THEN
            IF (I.GT.NFREQ) THEN
              ICONVF = .TRUE.
            END IF
            GO TO 220
          END IF
  210   CONTINUE
        ICONV = 1
        ICONVF = .TRUE.
        GO TO 90
  220   CONTINUE
        IF (ITER.LT.ITEMAX) GO TO 230
        ICONV = 2
        GO TO 90
  230   CONTINUE
        DO 240 I = 1,NFRCV
          ZR(ITEMPO+I-1) = VALPRO(I)
  240   CONTINUE
        GO TO 90
      END IF

  250 CONTINUE

C     --- CLASSEMENT PAR ORDRE CROISSANT DES VALEURS PROPRES ---
C     ---   ET DONC DES VECTEURS PROPRES DU SYSTEME COMPLET  ---

      NITBAT = ITER
      CALL VPORDI(1,0,NBVEC,VALPRO,VECT,NEQ,ZI(IFPOS))
      IF (.NOT.ICONVF) THEN
        CALL UTMESS('A','SSPACE',
     &           'METHODE DE BATHE ET WILSON : CONVERGENCE NON ATTEINTE'
     &              )
      END IF

C     ------------------------------------------------------------------
C     ------------- DESTRUCTION DES VARIABLES AUXILLIAIRES -------------
C     ------------------------------------------------------------------

      CALL JEDETC('V','&&SSPACE',1)

      CALL JEDEMA()
      END
