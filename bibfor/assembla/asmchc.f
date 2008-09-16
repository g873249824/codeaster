      SUBROUTINE ASMCHC(MATAS)
      IMPLICIT NONE
      CHARACTER*(*) MATAS
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 16/09/2008   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C OBJET :
C        TRAITEMENT DES CHARGES CINEMATIQUES DANS UNE MATRICE ASSEMBLEE
C        CALCUL DES OBJETS  .CCLL,  .CCVA,  .CCJJ
C-----------------------------------------------------------------------
C VAR  MATAS   K*19    : NOM DE LA MATR_ASSE
C-----------------------------------------------------------------------
      CHARACTER*32 JEXNUM
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC,DCMPLX
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------------------------------------------------------------------
C     VARIABLES LOCALES
C----------------------------------------------------------------------
      CHARACTER*1 BASE
      CHARACTER*8 KBID
      CHARACTER*14 NU
      CHARACTER*19 MAT,NOMSTO
      INTEGER TYPMAT,IELIM,JELIM,KDEB,KFIN,NCCVA,KKELI
      INTEGER JSMHC,JSMDI,JVALM,JVALM2,JCCVA,JCCLL,NELIM
      INTEGER JREFA,IRET2,JNEQU,IEQ,K,JEQ,DECIEL,NTERM,NEQ,IER
      INTEGER IRET,NBLOCM,JCCJJ,JREMP,DECJEL,IREMP,JCCID,KETA,IBID
      LOGICAL NONSYM
C----------------------------------------------------------------------
      CALL JEMARQ()
      MAT = MATAS
C     CALL CHEKSD('SD_MATR_ASSE',MAT,IRET)
      CALL JEEXIN(MAT//'.CCVA',IER)
      CALL ASSERT(IER.EQ.0)
      CALL JEEXIN(MAT//'.CCID',IER)
      IF (IER.EQ.0) GOTO 9999

      CALL JELIRA(MAT//'.REFA','CLAS',IBID,BASE)
      CALL JEVEUO(MAT//'.REFA','E',JREFA)
      NU = ZK24(JREFA-1+2)(1:14)
      CALL JEVEUO(NU//'.NUME.NEQU','L',JNEQU)
      NEQ = ZI(JNEQU)


C     -- ON DETRUIT LES OBJETS S'ILS EXISTENT DEJA :
      CALL ASSERT(ZK24(JREFA-1+3).NE.'ELIMF')
      CALL JEDETR(MAT//'.CCLL')
      CALL JEDETR(MAT//'.CCVA')
      CALL JEDETR(MAT//'.CCJJ')

C     -- CALCUL DE ELIM(*) ET NELIM :
C     -----------------------------------
C     ELIM    I(*)    : TABLEAU ENTIER DE DIM = NEQ DONNANT LES
C                       LES NUMEROS DES EQUATIONS A ELIMINER ET LEUR
C                       NUMERO D'ELIMINATION
C                       ZI(KKELI-1+IEQ) = / 0      -> PAS ELIMINE
C                                         / IELIM  -> ELIMINE
C     NELIM   I       : NOMBRE D'EQUATIONS DE LA MATRICE A ELIMINER
      CALL WKVECT('&&ASMCHC.ELIM','V V I',NEQ,KKELI)
      CALL JEVEUO(MAT//'.CCID','L',JCCID)
      NELIM=0
      DO 1, IEQ=1,NEQ
         KETA=ZI(JCCID-1+IEQ)
         CALL ASSERT(KETA.EQ.1 .OR. KETA.EQ.0)
         IF (KETA.EQ.1) THEN
            NELIM=NELIM+1
            ZI(KKELI-1+IEQ)=NELIM
         ELSE
            ZI(KKELI-1+IEQ)=0
         ENDIF
1     CONTINUE



      IF (NELIM.EQ.0) GO TO 9999
C     -----------------------------------------------------------------

      NOMSTO = NU//'.SMOS'


      CALL JEEXIN(NOMSTO//'.SMHC',IRET2)
      CALL ASSERT(IRET2.GT.0)
      CALL JEVEUO(NOMSTO//'.SMHC','L',JSMHC)
      CALL JEVEUO(NOMSTO//'.SMDI','L',JSMDI)



C     -- CALCUL DE .CCLL :
C     -----------------------------------------
      CALL WKVECT(MAT//'.CCLL',BASE//' V I ',3*NELIM,JCCLL)

      KFIN=0
      DO 21 IEQ = 1,NEQ
        KDEB = KFIN + 1
        KFIN = ZI(JSMDI-1+IEQ)
        IELIM = ZI(KKELI-1+IEQ)

        IF (IELIM.NE.0) THEN
          ZI(JCCLL-1+3*(IELIM-1)+1) = IEQ
          DO 11, K=KDEB, KFIN - 1
            JEQ = ZI(JSMHC-1+K)
            JELIM = ZI(KKELI-1+JEQ)
            IF (JELIM.EQ.0)
     &         ZI(JCCLL-1+3*(IELIM-1)+2)=ZI(JCCLL-1+3*(IELIM-1)+2) +1
   11     CONTINUE

        ELSE
          DO 12 K = KDEB,KFIN - 1
            JEQ = ZI(JSMHC-1+K)
            JELIM = ZI(KKELI-1+JEQ)
            IF (JELIM.NE.0)
     &         ZI(JCCLL-1+3*(JELIM-1)+2)=ZI(JCCLL-1+3*(JELIM-1)+2) +1
   12     CONTINUE
        END IF
   21 CONTINUE


C     -- CALCUL DE NCCVA ET .CCLL(3*(I-1)+3) :
C     -----------------------------------------
      DECIEL=0
      DO 13,IELIM=1,NELIM
        NTERM=ZI(JCCLL-1+3*(IELIM-1)+2)
        ZI(JCCLL-1+3*(IELIM-1)+3)=DECIEL
        DECIEL=DECIEL+NTERM
 13   CONTINUE
      NCCVA=MAX(DECIEL,1)


C     -- RECUPERATION DE .VALM
C        CALCUL DE TYPMAT ET NONSYM :
C     ------------------------------------
      CALL JELIRA(JEXNUM(MAT//'.VALM',1),'TYPE',IRET,KBID)
      TYPMAT = 1
      IF (KBID(1:1).EQ.'C') TYPMAT = 2
      NONSYM=.FALSE.
      CALL JELIRA(MAT//'.VALM','NMAXOC',NBLOCM,KBID)
      CALL ASSERT(NBLOCM.EQ.1 .OR. NBLOCM.EQ.2)
      IF (NBLOCM.EQ.2) NONSYM=.TRUE.
      CALL JEVEUO(JEXNUM(MAT//'.VALM',1),'E',JVALM)
      IF (NONSYM) CALL JEVEUO(JEXNUM(MAT//'.VALM',2),'E',JVALM2)


C     -- ALLOCATION DE .CCVA ET .CCJJ :
C     ------------------------------------
      CALL WKVECT(MAT//'.CCVA',BASE//' V '//KBID(1:1),NCCVA,JCCVA)
      CALL WKVECT(MAT//'.CCJJ',BASE//' V I',NCCVA,JCCJJ)


C     -- REMPLISSAGE DE .CCJJ ET .CCVA :
C     -----------------------------------------

      CALL WKVECT('&&ASMCHC.REMPLIS','V V I',NELIM,JREMP)
      KFIN=0
      DO 121 IEQ = 1,NEQ
        KDEB = KFIN + 1
        KFIN = ZI(JSMDI-1+IEQ)
        IELIM = ZI(KKELI-1+IEQ)

        IF (IELIM.NE.0) THEN
          DECIEL=ZI(JCCLL-1+3*(IELIM-1)+3)
          DO 111, K=KDEB, KFIN - 1
            JEQ = ZI(JSMHC-1+K)
            JELIM = ZI(KKELI-1+JEQ)
            IF (JELIM.EQ.0) THEN
               ZI(JREMP-1+IELIM)=ZI(JREMP-1+IELIM)+1
               IREMP=ZI(JREMP-1+IELIM)
               ZI(JCCJJ-1+DECIEL+IREMP)=JEQ
               IF (TYPMAT.EQ.1) THEN
                 IF (NONSYM) THEN
                   IF (JEQ.GE.IEQ) THEN
                     ZR(JCCVA-1+DECIEL+IREMP)= ZR(JVALM-1+K)
                   ELSE
                     ZR(JCCVA-1+DECIEL+IREMP)= ZR(JVALM2-1+K)
                   ENDIF
                 ELSE
                   ZR(JCCVA-1+DECIEL+IREMP)= ZR(JVALM-1+K)
                 ENDIF
               ELSE
                 IF (NONSYM) THEN
                   IF (JEQ.GE.IEQ) THEN
                     ZC(JCCVA-1+DECIEL+IREMP)= ZC(JVALM-1+K)
                   ELSE
                     ZC(JCCVA-1+DECIEL+IREMP)= ZC(JVALM2-1+K)
                   ENDIF
                 ELSE
                   ZC(JCCVA-1+DECIEL+IREMP)= ZC(JVALM-1+K)
                 ENDIF
               ENDIF
            ENDIF
  111     CONTINUE

        ELSE
          DO 112 K = KDEB,KFIN - 1
            JEQ = ZI(JSMHC-1+K)
            JELIM = ZI(KKELI-1+JEQ)
            DECJEL=ZI(JCCLL-1+3*(JELIM-1)+3)
            IF (JELIM.NE.0) THEN
               ZI(JREMP-1+JELIM)=ZI(JREMP-1+JELIM)+1
               IREMP=ZI(JREMP-1+JELIM)
               ZI(JCCJJ-1+DECJEL+IREMP)=IEQ
               IF (TYPMAT.EQ.1) THEN
                 IF (NONSYM) THEN
                   IF (JEQ.GE.IEQ) THEN
                     ZR(JCCVA-1+DECJEL+IREMP)= ZR(JVALM-1+K)
                   ELSE
                     ZR(JCCVA-1+DECJEL+IREMP)= ZR(JVALM2-1+K)
                   ENDIF
                 ELSE
                   ZR(JCCVA-1+DECJEL+IREMP)= ZR(JVALM-1+K)
                 ENDIF
               ELSE
                 IF (NONSYM) THEN
                   IF (JEQ.GE.IEQ) THEN
                     ZC(JCCVA-1+DECJEL+IREMP)= ZC(JVALM-1+K)
                   ELSE
                     ZC(JCCVA-1+DECJEL+IREMP)= ZC(JVALM2-1+K)
                   ENDIF
                 ELSE
                   ZC(JCCVA-1+DECJEL+IREMP)= ZC(JVALM-1+K)
                 ENDIF
               ENDIF
            ENDIF
  112     CONTINUE
        END IF

  121 CONTINUE



C---  "SIMPLIFICATION" DE .VALM : 1. SUR LA DIAGONALE ET 0. EN DEHORS
C---------------------------------------------------------------------
      KFIN=0
      DO 221 IEQ = 1,NEQ
        KDEB = KFIN + 1
        KFIN = ZI(JSMDI-1+IEQ)
        IELIM = ZI(KKELI-1+IEQ)

        IF (IELIM.NE.0) THEN
          IF (TYPMAT.EQ.1) THEN
            ZR(JVALM-1+KFIN)=1.D0
            IF (NONSYM) ZR(JVALM2-1+KFIN)=1.D0
          ELSE
            ZC(JVALM-1+KFIN)=DCMPLX(1.D0,0.D0)
            IF (NONSYM) ZC(JVALM2-1+KFIN)=DCMPLX(1.D0,0.D0)
          ENDIF
        ENDIF

        IF (IELIM.NE.0) THEN
          DO 211, K=KDEB, KFIN -1
            IF (TYPMAT.EQ.1) THEN
              ZR(JVALM-1+K)=0.D0
              IF (NONSYM) ZR(JVALM2-1+K)=0.D0
            ELSE
              ZC(JVALM-1+K)=DCMPLX(0.D0,0.D0)
              IF (NONSYM) ZC(JVALM2-1+K)=DCMPLX(0.D0,0.D0)
            ENDIF
  211     CONTINUE

        ELSE
          DO 212 K = KDEB, KFIN -1
            JEQ = ZI(JSMHC-1+K)
            JELIM = ZI(KKELI-1+JEQ)
            IF (JELIM.NE.0) THEN
              IF (TYPMAT.EQ.1) THEN
                ZR(JVALM-1+K)=0.D0
                IF (NONSYM) ZR(JVALM2-1+K)=0.D0
              ELSE
                ZC(JVALM-1+K)=DCMPLX(0.D0,0.D0)
                IF (NONSYM) ZC(JVALM2-1+K)=DCMPLX(0.D0,0.D0)
              ENDIF
            ENDIF
  212     CONTINUE
        END IF

  221 CONTINUE

      ZK24(JREFA-1+3)='ELIMF'




 9999 CONTINUE
      CALL JEDETR('&&ASMCHC.REMPLIS')
      CALL JEDETR('&&ASMCHC.ELIM')
C     CALL CHEKSD('sd_matr_asse',MAT,IRET)
      CALL JEDEMA()
      END
