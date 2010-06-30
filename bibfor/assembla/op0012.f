      SUBROUTINE OP0012()
C======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
C
C                       OPERATEUR ASSE_MATRICE
C======================================================================
C----------------------------------------------------------------------
C     VARIABLES LOCALES
C----------------------------------------------------------------------
      CHARACTER*8 NU,MATAS,CHARGE,KBID,SYME,SYM2,KMPIC
      CHARACTER*16 TYPM,OPER
      CHARACTER*19 MATEL,SOLVEU
      CHARACTER*24 LCHCI,LMATEL
      CHARACTER*72 KBIDON
      INTEGER ITYSCA,NBCHC,NBMAT,JLIMAT,JLCHCI,IBID,K,J,NBCHAR
      INTEGER JRECC,ICO,IEXI,IRET,ISLVK,ILIMAT
C-----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------------------------------------------------------------------
      CALL JEMARQ()
C
C
C
C---- ARGUMENT IMPR
      CALL INFMAJ

C---- RECUPERATION DES ARGUMENTS ET DU CONCEPT
      CALL GETRES(MATAS,TYPM,OPER)
      IF (TYPM(16:16).EQ.'R') ITYSCA = 1
      IF (TYPM(16:16).EQ.'C') ITYSCA = 2


C---- RECUPERATION DES MATRICES ELEMENTAIRES ---
      CALL GETVID(' ','MATR_ELEM',0,1,0,KBIDON,NBMAT)
      NBMAT = -NBMAT
      LMATEL='&&OP0012.LMATEL'
      CALL WKVECT(LMATEL,'V V K24',NBMAT,JLIMAT)
      CALL GETVID(' ','MATR_ELEM',0,1,NBMAT,ZK24(JLIMAT),IBID)


C---- RECUPERATION DES CHARGES CINEMATIQUES ---
      LCHCI='&&OP0012.LCHARCINE'
      CALL GETVID(' ','CHAR_CINE',0,1,0,KBIDON,NBCHC)
      NBCHC = -NBCHC
C     -- LES SD_CHAR_XXX PEUVENT CONTENIR UNE SD_CHAR_CINE :
      DO 1, K=1,NBMAT
        MATEL=ZK24(JLIMAT-1+K)
        CALL ASSERT(ZK24(JLIMAT-1+K)(9:24).EQ.' ')
        CALL JEEXIN(MATEL//'.RECC',IEXI)
        IF (IEXI.GT.0) THEN
          CALL JEVEUO(MATEL//'.RECC','L',JRECC)
          CALL JELIRA(MATEL//'.RECC','LONMAX',NBCHAR,KBID)
          DO 2, J=1,NBCHAR
            CHARGE=ZK8(JRECC-1+J)
            CALL JEEXIN(CHARGE//'.ELIM      .AFCK',IEXI)
            IF (IEXI.GT.0) NBCHC=NBCHC+1
 2        CONTINUE
        ENDIF
 1    CONTINUE

      IF (NBCHC.GT.0) THEN
        CALL WKVECT(LCHCI,'V V K24',NBCHC,JLCHCI)
        CALL GETVID(' ','CHAR_CINE',0,1,NBCHC,ZK24(JLCHCI),ICO)
        DO 3, K=1,NBMAT
          MATEL=ZK24(JLIMAT-1+K)
          CALL JEEXIN(MATEL//'.RECC',IEXI)
          IF (IEXI.GT.0) THEN
            CALL JEVEUO(MATEL//'.RECC','L',JRECC)
            CALL JELIRA(MATEL//'.RECC','LONMAX',NBCHAR,KBID)
            DO 4, J=1,NBCHAR
              CHARGE=ZK8(JRECC-1+J)
              CALL JEEXIN(CHARGE//'.ELIM      .AFCK',IEXI)
              IF (IEXI.GT.0) THEN
                ICO=ICO+1
                ZK24(JLCHCI-1+ICO)=CHARGE//'.ELIM'
              ENDIF
 4          CONTINUE
          ENDIF
 3      CONTINUE
      END IF


C---- MOT CLE : NUME_DDL
      CALL GETVID(' ','NUME_DDL',0,1,1,NU,IBID)

C---- ASSEMBLAGE PROPREMENT DIT
      SYME = ' '
      CALL GETVTX(' ','SYME',1,1,1,SYME,IBID)
      IF (SYME.EQ.'OUI') THEN
        CALL DISMOI('F','SOLVEUR',NU,'NUME_DDL',IBID,SOLVEU,IRET)
        CALL JEVEUO(SOLVEU(1:19)//'.SLVK','E',ISLVK)
        SYM2   = ZK24(ISLVK+5-1)(1:8)
        ZK24(ISLVK+5-1)='OUI'
        CALL ASMATR(NBMAT,ZK24(JLIMAT),' ',NU,SOLVEU,
     &              LCHCI,'ZERO','G',ITYSCA,MATAS)
        ZK24(ISLVK+5-1)=SYM2(1:3)
        CALL JEVEUO(MATAS//'           .LIME','E',ILIMAT)
        DO 5, K=1,NBMAT
          ZK24(ILIMAT-1+K)=ZK24(JLIMAT-1+K)
 5      CONTINUE
      ELSE
        CALL ASMATR(NBMAT,ZK24(JLIMAT),' ',NU,' ',
     &              LCHCI,'ZERO','G',ITYSCA,MATAS)

      ENDIF


C     -- SI MATAS N'EST PAS MPI_COMPLET, ON LA COMPLETE :
      CALL DISMOI('F','MPI_COMPLET',MATAS,'MATR_ASSE',IBID,KMPIC,IBID)
      CALL ASSERT((KMPIC.EQ.'OUI').OR.(KMPIC.EQ.'NON'))
      IF (KMPIC.EQ.'NON')  CALL SDMPIC('MATR_ASSE',MATAS)




C     -- MENAGE :
      CALL JEDETR(LCHCI)
      CALL JEDETR(LMATEL)

      CALL JEDEMA()
      END
