      SUBROUTINE PANBNO(ITYP,NBNOTT)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           ITYP,NBNOTT(3)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/09/2010   AUTEUR REZETTE C.REZETTE 
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
C     BUT: CALCULER LE NOMBRE DE NOEUDS SOMMETS,ARRETES,INTERIEURS
C     D'UNE MAILLE D'UN TYPE DONNE.
C
C ARGUMENTS
C IN   ITYP   I   : NUMERO DU TYPMAIL
C OUT  NBNOTT I(3): (1) NBRE DE NOEUDS SOMMETS
C                   (2) NBRE DE NOEUDS ARRETES
C                   (3) NBRE DE NOEUDS INTERIEURS
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8 NOMTM
      INTEGER IDNBNO,NBNTOT
C --- DEBUT
      CALL JEMARQ()
      CALL JEVEUO(JEXNUM('&CATA.TM.NBNO',ITYP),'L',IDNBNO)
      NBNTOT = ZI(IDNBNO)
      CALL JENUNO(JEXNUM('&CATA.TM.NBNO',ITYP),NOMTM)
      NBNOTT(2) = 0
      NBNOTT(3) = 0
      IF (NOMTM(1:4).EQ.'POI1') THEN
        NBNOTT(1) = 1
      ELSE IF (NOMTM(1:3).EQ.'SEG') THEN
        NBNOTT(1) = 2
        NBNOTT(2) = NBNTOT-2
      ELSE IF (NOMTM(1:3).EQ.'TRI') THEN
        NBNOTT(1) = 3
        IF (NBNTOT.EQ.6) NBNOTT(2) = 3
      ELSE IF (NOMTM(1:3).EQ.'QUA') THEN
        NBNOTT(1) = 4
        IF (NBNTOT.GE.8) NBNOTT(2) = 4
        IF (NBNTOT.EQ.9) NBNOTT(3) = 1
      ELSE IF (NOMTM(1:5).EQ.'TETRA') THEN
        NBNOTT(1) = 4
        IF (NBNTOT.EQ.10) NBNOTT(2) = 6
      ELSE IF (NOMTM(1:5).EQ.'PENTA') THEN
        NBNOTT(1) = 6
        IF (NBNTOT.EQ.15) NBNOTT(2) = 9
        IF (NBNTOT.EQ.18) NBNOTT(3) = 3
      ELSE IF (NOMTM(1:5).EQ.'PYRAM') THEN
        NBNOTT(1) = 5
        IF (NBNTOT.EQ.13) NBNOTT(2) = 8
      ELSE IF (NOMTM(1:4).EQ.'HEXA') THEN
        NBNOTT(1) = 8
        IF (NBNTOT.GE.20) NBNOTT(2) = 12
        IF (NBNTOT.EQ.27) NBNOTT(3) = 7
      ELSE
        CALL U2MESK('F','MODELISA6_20',1,NOMTM)
      ENDIF
      IF (NBNTOT.NE.(NBNOTT(1)+NBNOTT(2)+NBNOTT(3))) THEN
        CALL U2MESS('F','MODELISA6_21')
      ENDIF
      CALL JEDEMA()
      END
