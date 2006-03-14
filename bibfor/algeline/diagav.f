      SUBROUTINE DIAGAV(NOMA19,NEQ,TYPVAR,EPS)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
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
C     BUT : AJOUTER L'OBJET .DIGS A UNE MATR_ASSE
C           ET CALCULER UN EPSILON NUMERIQUE POUR LA FACTORISATION
C     IN  : NOMA19 : MATR_ASSE QUE L'ON COMPLETERA PAR L'OBJET .DIGS
C     IN  : NEQ    : NOMBRE D'EQUATIONS
C     IN  : TYPVAR : REEL/COMPLEXE
C     OUT : EPS    : 'EPSILON' TEL QU'UN TERME DIAGONAL APRES
C                    FACTORISATION SERA CONSIDERE COMME NUL
C     ------------------------------------------------------------------
      CHARACTER*19 NOMA19
      CHARACTER*14 NU
      REAL*8 EPS,DIAMAX,DIAMIN,R8GAEM,R8MAEM
      INTEGER NEQ,TYPVAR,IFM,NIV,IRET,IADIGS,IBID
      INTEGER JSXDI,JSCBL,JSCDE,NBBLOC,IBLOC,IAVALE,IDERN,IPREM,I
C     ------------------------------------------------------------------
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
      CHARACTER*32 JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)


C     -- ALLOCATION ET CALCUL DE L'OBJET .DIGS :
C        CET OBJET CONTIENDRA LES TERMES DIAGONAUX
C        AVANT ET APRES FACTORISATION :
C        (1->NEQ : AVANT , NEQ+1 ->2*NEQ : APRES )
C     -----------------------------------------
      CALL JEDETR(NOMA19//'.DIGS')
      CALL WKVECT(NOMA19//'.DIGS','V V R',2*NEQ,IADIGS)
      CALL DISMOI('F','NOM_NUME_DDL',NOMA19,'MATR_ASSE',IBID,NU,IBID)


C     CAS STOCKAGE MORSE DISPONIBLE (OBJET .VALM):
C     ---------------------------------------------
      CALL JEEXIN(NOMA19//'.VALM',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(NU//'.SMOS.SMDI','L',JSXDI)
        CALL JEVEUO(JEXNUM(NOMA19//'.VALM',1),'L',IAVALE)
        IF (TYPVAR.EQ.1) THEN
          DO 40 I = 1,NEQ
            ZR(IADIGS-1+I) = ABS(ZR(IAVALE-1+ZI(JSXDI+I-1)))
   40     CONTINUE
        ELSE IF (TYPVAR.EQ.2) THEN
          DO 50 I = 1,NEQ
            ZR(IADIGS-1+I) = ABS(ZC(IAVALE-1+ZI(JSXDI+I-1)))
   50     CONTINUE
        ELSE
          CALL UTMESS('F','DIAGAV','STOP 2')
        END IF
        GO TO 9998
      END IF


C     CAS STOCKAGE MORSE INDISPONIBLE (OBJET .VALM):
C     ---------------------------------------------
      CALL ASSERT((NOMA19.EQ.'&&OP0070.RESOC.MATR').OR.
     &            (NOMA19.EQ.'&&OP0070.RESUC.MATR'))
      CALL JEVEUO(NU//'.SLCS.SCDI','L',JSXDI)
      CALL JEVEUO(NU//'.SLCS.SCBL','L',JSCBL)
      CALL JEVEUO(NU//'.SLCS.SCDE','L',JSCDE)
      NBBLOC = ZI(JSCDE-1+3)
      DO 30 IBLOC = 1,NBBLOC
        CALL JEVEUO(JEXNUM(NOMA19//'.UALF',IBLOC),'L',IAVALE)
        IDERN = ZI(JSCBL-1+IBLOC+1)
        IF (IDERN.GT.NEQ) CALL UTMESS('F','DIAGAV','STOP1')
        IPREM = ZI(JSCBL-1+IBLOC) + 1
        IF (TYPVAR.EQ.1) THEN
          DO 10 I = IPREM,IDERN
            ZR(IADIGS-1+I) = ABS(ZR(IAVALE-1+ZI(JSXDI+I-1)))
   10     CONTINUE
        ELSE IF (TYPVAR.EQ.2) THEN
          DO 20 I = IPREM,IDERN
            ZR(IADIGS-1+I) = ABS(ZC(IAVALE-1+ZI(JSXDI+I-1)))
   20     CONTINUE
        ELSE
          CALL UTMESS('F','DIAGAV','STOP 1')
        END IF
        CALL JELIBE(JEXNUM(NOMA19//'.UALF',IBLOC))
   30 CONTINUE



9998  CONTINUE
C     -- CALCUL DE EPS :
C     ------------------
C     ON AVAIT PENSE CALCULER EPS COMME:
C     1.D-15 FOIS LE TERME DIAGONAL MIN (/=0)
C     MAIS IL ARRIVE QU'AVEC MULT_FRONT ON PASSE EN
C     DESSOUS SANS QUE CELA FASSE D'OVERFLOW
C     DONC ON PREND UNE VALEUR ARBITRAIRE :
      EPS = 1.D0/R8GAEM()

   60 CONTINUE

      IF(NIV.GT.1) THEN
        DIAMAX = 0.D0
        DIAMIN = R8MAEM()
        DO 70 I = 1,NEQ
           DIAMAX = MAX(DIAMAX,ZR(IADIGS-1+I))
           IF (ZR(IADIGS-1+I).NE.0.D0)
     +         DIAMIN = MIN(DIAMIN,ZR(IADIGS-1+I))
   70   CONTINUE
        WRITE (IFM,*) '<FACTOR> AVANT FACTORISATION :'
        WRITE (IFM,*) '<FACTOR>   NB EQUATIONS : ',NEQ
        WRITE (IFM,*) '<FACTOR>   TERME DIAGONAL MAXIMUM :  ',DIAMAX
        WRITE (IFM,*) '<FACTOR>   TERME DIAGONAL (NON NUL) MINIMUM : ',
     &                 DIAMIN
        WRITE (IFM,*) '<FACTOR>   EPSILON CHOISI  : ',EPS
      END IF

      CALL JEDEMA()
      END
