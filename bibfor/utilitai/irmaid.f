      SUBROUTINE IRMAID(MATR,IFC,VERSIO)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER VERSIO
      CHARACTER*(*) MATR
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
C     IMPRESSION D'UN CONCEPT MATR_ASSE AU FORMAT "IDEAS"

C     ATTENTION: AFIN D'AVOIR UNE PLUS GRANDE PRECISION, LES VALEURS
C                SONT IMPRIMES AU FORMAT D20.12 AU LIEU DE D13.5
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
      CHARACTER*32 JEXNOM,JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER NBELEM,DIGDEL
      REAL*8 MP(18,18),MC(324)
      CHARACTER*8 K8B,GRAN,SCAL,SCALAI
      CHARACTER*14 NUME
      CHARACTER*16 OPTION,OPTIO2
      CHARACTER*19 LIGREL
      CHARACTER*24 NOLI,DESC
C     ------------------------------------------------------------------

      CALL JEMARQ()

      CALL MTDSCR(MATR)
      CALL DISMOI('F','NOM_NUME_DDL',MATR,'MATR_ASSE',IBID,NUME,IE)
      CALL JEVEUO(MATR(1:8)//'           .&INT','E',LMAT)
      CALL ASSERT(LMAT.NE.0)

      NEQ = ZI(LMAT+2)
      TYPVAR = ZI(LMAT+3)
      TYPSYM = ZI(LMAT+4)
      CALL JEVEUO(NUME//'.SMOS.SMHC','L',JSMHC)
      CALL JEVEUO(NUME//'.SMOS.SMDI','L',JSMDI)

      CALL WKVECT('&&&&IRMAID.LAGR','V V I',NEQ,LDDL)
      CALL PTEDDL('NUME_DDL',NUME,1,'LAGR    ',NEQ,ZI(LDDL))
      NBDDL = 0
      DO 10 I = 1,NEQ
        IF (ZI(LDDL+I-1).EQ.0) NBDDL = NBDDL + 1
   10 CONTINUE

      CALL WKVECT('&&IRMAID.MATRICE','V V R',NBDDL*NBDDL,JMATR)

C     --- MATRICE SYMETRIQUE REELLE ---

      IF (TYPVAR.EQ.1) THEN
        IF (TYPSYM.EQ.1) THEN
          CALL MATRPL(MATR,ZI(JSMHC),ZI(JSMDI),NEQ,
     &                ZI(LDDL),ZR(JMATR),NBDDL)
        ELSE
          CALL U2MESS('F','UTILITAI2_41')
        END IF
      ELSE
        CALL U2MESS('F','UTILITAI2_42')
      END IF

      CALL DISMOI('F','SUR_OPTION',MATR,'MATR_ASSE',IBD,OPTION,IE)
      IF (OPTION.EQ.'RIGI_MECA') THEN
        IMAT = 9
      ELSE IF (OPTION.EQ.'MASS_MECA') THEN
        IMAT = 6
      ELSE IF (OPTION.EQ.'AMOR_MECA') THEN
        IMAT = 7
      ELSE
        CALL ASSERT(.FALSE.)
      END IF

      M2 = NBDDL*NBDDL
      IF (VERSIO.EQ.5) THEN
        ITYP = 4
        IFOR = 1
        ICOL = 2
        WRITE (IFC,'(A)') '    -1'
        WRITE (IFC,'(A)') '   252'
        WRITE (IFC,'(I10)') IMAT
        WRITE (IFC,'(5I10)') ITYP,IFOR,NBDDL,NBDDL,ICOL
        WRITE (IFC,'(1P,4D20.12)') (ZR(JMATR+I),I=0,M2-1)
        WRITE (IFC,'(A)') '    -1'
      END IF

      CALL JEDETR('&&IRMAID.MATRICE')
      CALL JEDETR('&&&&IRMAID.LAGR')

      CALL JEDEMA()
      END
