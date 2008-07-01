      SUBROUTINE OP0015(IER)
      IMPLICIT NONE
      INTEGER IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 30/06/2008   AUTEUR PELLET J.PELLET 
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
C     OPERATEUR RESOUDRE
C     ------------------------------------------------------------------
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
      INTEGER IBID,IFM,NIV,NB,J1,IRET,MXITER
      CHARACTER*8 XSOL,SECMBR,MATR,VCINE,MATF,KBID,METRES
      CHARACTER*16 CONCEP,NOMCMD
      CHARACTER*19 SOLVE1,SOLVE2
      COMPLEX*16   CBID
      REAL*8       EPS,RBID
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
C
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

      CALL GETRES(XSOL,CONCEP,NOMCMD)

      CALL GETVID('  ','MATR',0,1,1,MATR,NB)
      CALL ASSERT(NB.EQ.1)

      MATF=' '
      CALL GETVID(' ','MATR_PREC',0,1,1,MATF,NB)

      CALL GETVID('  ','CHAM_NO',0,1,1,SECMBR,NB)
      CALL ASSERT(NB.EQ.1)
      CALL CHPVER('F',SECMBR,'NOEU','*',IER)

      VCINE = ' '
      CALL GETVID('  ','CHAM_CINE',0,1,1,VCINE,NB)
      IF (NB.EQ.1) CALL CHPVER('F',VCINE,'NOEU','*',IER)


C     --- CREATION D'1 SOLVEUR TEMPORAIRE : SOLVE2 (SAUF SI MUMPS)
      CALL DISMOI('F','SOLVEUR',MATR,'MATR_ASSE',IBID,SOLVE1,IBID)
      CALL JEVEUO(SOLVE1//'.SLVK','E',J1)
      METRES=ZK24(J1-1+1)
      IF (METRES.NE.'MUMPS') THEN
        SOLVE2='&&OP0015.SOLVEUR'
        CALL COPISD('SOLVEUR','V',SOLVE1,SOLVE2)
      ELSE
C       -- MUMPS VERIFIE QUE LE SOLVEUR LORS DE RESOUD EST LE MEME
C          QUE CELUI DE PRERES. ON EST DONC OBLIGES DE LE MODIFIER
        SOLVE2=SOLVE1
      ENDIF

C     -- MODIFICATION DU SOLVEUR DU FAIT DE CERTAINS MOTS CLES :
      CALL GETVR8(' ','RESI_RELA',0,1,1,EPS,NB)
      IF (NB.EQ.1) THEN
        CALL JEVEUO(SOLVE2//'.SLVR','E',J1)
        ZR(J1-1+2)=EPS
      ENDIF
      CALL GETVIS(' ','NMAX_ITER',0,1,1,MXITER,NB)
      IF (NB.EQ.1) THEN
        CALL JEVEUO(SOLVE2//'.SLVI','E',J1)
        ZI(J1-1+2)=MXITER
      ENDIF

C     -- APPEL A LA ROUTINE RESOUD :
      CALL RESOUD(MATR,MATF,SECMBR,SOLVE2,VCINE,'G',XSOL,
     &                  ' ',0,RBID,CBID)

      IF (METRES.NE.'MUMPS') CALL DETRSD('SOLVEUR',SOLVE2)



9999  CONTINUE
      CALL TITRE
      CALL JEDEMA()
      END
