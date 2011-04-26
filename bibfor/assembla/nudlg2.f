      SUBROUTINE NUDLG2(NU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE

C     ARGUMENTS:
C     ----------
      CHARACTER*(*) NU
C ----------------------------------------------------------------------
C     BUT : CREER L'OBJET NU.DLG2 PERMETTANT D'ASSOCIER LES
C           LAGRANGES 1 ET 2 D'UN NUME_DDL (SUR LA BASE VOLATILE)

C     IN:
C        NU     (K14) : NOM D'UN NUME_DDL
C
C     INOUT : NU EST ENRICHI DE L'OBJET .DLG2
C
C        .DLG2 = V I LONG=NEQ
C        POUR IEQ1=1,NEQ :
C         .DLG2(IEQ1) = 0 => IEQ CORRESPOND A UN DDL PHYSIQUE
C         .DLG2(IEQ1) = IEQ2 => IEQ CORRESPOND A UN DDL DE LAGRANGE
C                               ET IEQ2 EST L'AUTRE LAGRANGE QUI LUI
C                               EST ASSOCIE.
C                               DANS CE CAS .DLG2(IEQ2)=IEQ1
C ----------------------------------------------------------------------

C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXATR
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER NEQ,ILI,IER,NBLIGR,IEXI,JPRNO,JDLG2
      INTEGER IMA,NN,ZZNSUP,N1,N2,N3,N4,ZZNEMA
      INTEGER J1NEMA,J2NEMA,NBMA
      INTEGER IEQ2,IEQ3,NUEQ2,NUEQ3,NEC,IBID,JNUEQ,J
      CHARACTER*19 LIGR19
      CHARACTER*14 NU14
      CHARACTER*8 NOGD
      CHARACTER*1 KBID

C     -- ZZNSUP : NOMBRE DE NOEUDS DE LA MAILLE TARDIVE
      ZZNSUP(ILI,IMA) = ZI(J2NEMA+IMA) -  ZI(J2NEMA+IMA-1) - 1

C     -- ZZNEMA : NUMERO DES NOEUDS DE LA MAILLE TARDIVE
      ZZNEMA(ILI,IMA,J) = ZI(J1NEMA-1+ ZI(J2NEMA+IMA-1)+J-1)



      CALL JEMARQ()
      NU14=NU

      CALL JEEXIN(NU14//'.NUME.DLG2',IEXI)
      IF (IEXI.GT.0) GOTO 9999

      CALL DISMOI('F','NB_EQUA',NU14,'NUME_DDL',NEQ,KBID,IER)
      CALL DISMOI('F','NOM_GD',NU14,'NUME_DDL',IBID,NOGD,IER)
      CALL DISMOI('F','NB_EC',NOGD,'GRANDEUR',NEC,KBID,IER)
      CALL JELIRA(NU14//'.NUME.PRNO','NMAXOC',NBLIGR,KBID)
      CALL JEVEUO(NU14//'.NUME.NUEQ','L',JNUEQ)


C     - ALLOCATION ET CALCUL DE .DLG2:
      CALL WKVECT(NU14//'.NUME.DLG2','V V I',NEQ,JDLG2)


      DO 31 ILI=2,NBLIGR
        CALL JENUNO(JEXNUM(NU14//'.NUME.LILI',ILI),LIGR19)
        CALL JEEXIN(LIGR19//'.LGNS',IEXI)
        IF (IEXI.EQ.0) GOTO 31

        CALL JEVEUO(LIGR19//'.NEMA','L',J1NEMA)
        CALL JELIRA(LIGR19//'.NEMA','NUTIOC',NBMA,KBID)
        CALL JEVEUO(JEXATR(LIGR19//'.NEMA','LONCUM'),'L',J2NEMA)

        CALL JELIRA(JEXNUM(NU14//'.NUME.PRNO',ILI),'LONMAX',N4,KBID)
        IF (N4.EQ.0) GOTO 31
        CALL JEVEUO(JEXNUM(NU14//'.NUME.PRNO',ILI),'L',JPRNO)
        DO 21 IMA=1,NBMA
          NN=ZZNSUP(ILI,IMA)
          IF (NN.EQ.3) THEN
            N1=ZZNEMA(ILI,IMA,1)
            N2=ZZNEMA(ILI,IMA,2)
            N3=ZZNEMA(ILI,IMA,3)
            IF (((N1.GT.0).AND.(N2.LT.0)) .AND. (N3.LT.0)) THEN
C             L'ELEMENT IMA EST UN SEG3 DE DUALISATION (PHYS,LAG1,LAG2)
C             N2 ET N3 SONT 2 LAGRANGES APPARIES
              IEQ2=ZI(JPRNO-1+(-N2-1)*(NEC+2)+1)
              IEQ3=ZI(JPRNO-1+(-N3-1)*(NEC+2)+1)
              NUEQ2 = ZI(JNUEQ-1+IEQ2)
              NUEQ3 = ZI(JNUEQ-1+IEQ3)
              ZI(JDLG2-1+NUEQ2)=NUEQ3
              ZI(JDLG2-1+NUEQ3)=NUEQ2
            ENDIF
          ENDIF
   21   CONTINUE
   31 CONTINUE




 9999 CONTINUE
      CALL JEDEMA()
      END
