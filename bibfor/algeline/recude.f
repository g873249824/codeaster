      SUBROUTINE RECUDE(CAELEM,PHIE,EP)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 05/07/2011   AUTEUR MACOCCO K.MACOCCO 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C-----------------------------------------------------------------------
C  RECUPERATION DU DIAMETRE EXTERIEUR ET INTERIEUR D'UNE STRUCTURE
C  TUBULAIRE A PARTIR DES DONNEES FOURNIES PAR UN CONCEPT
C  DE TYPE CARA_ELEM
C  APPELANT : SPECT1 OU FLUST1, FLUST2, MDITMI VIA MDCONF
C-----------------------------------------------------------------------
C  IN : CAELEM : NOM DU CONCEPT DE TYPE CARA_ELEM
C  OUT: PHIE   : DIAMETRE EXTERIEUR DU TUBE
C  OUT: EP   :   EPAISSEUR DU TUBE
C-----------------------------------------------------------------------
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
C
      CHARACTER*19 CAELEM
      REAL*8       PHIE,EP
C
      CHARACTER*8  NOMCMP(4)
      CHARACTER*19 CARTE
      CHARACTER*24 CARAD
      DATA NOMCMP  /'R1      ','EP1     ','R2      ','EP2     '/
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CARTE = CAELEM(1:8)//'.CARGEOPO'
C
      CARAD = CAELEM(1:8)//'.CARGEOPO  .DESC'
C
      CALL JEVEUO(CARAD,'L',ICARD)
      IASSMX = ZI(ICARD+1)
      IASSEF = ZI(ICARD+2)
C
      NBGD = 4
      CALL WKVECT('&&RECUDE.TEMP.VRES','V V R',NBGD*IASSEF,IVALRE)
      CALL RECUGD(CARTE,NOMCMP,ZR(IVALRE),NBGD,IASSEF,IASSMX)
C
      PHIE2 = 0.D0
      DO 10 IA = 1,IASSEF
        LR1 = IVALRE + 4* (IA-1)
        IF (ZR(LR1).NE.ZR(LR1+2)) THEN
          CALL U2MESS('F','ALGELINE3_31')
        ENDIF
C    PAR HYPOTHESE, LA VALEUR EST NULLE S'IL NE S'AGIT
C    PAS D'UN SEGMENT
        IF (ZR(LR1).EQ.0.D0) GOTO 10
C
        IF (IA.NE.1.AND.PHIE2.NE.0.D0) THEN
          IF (ZR(LR1).NE.PHIE2) THEN
            CALL U2MESS('F','ALGELINE3_31')
          ENDIF
        ENDIF
C
        PHIE2 = ZR(LR1)
        EP    = ZR(LR1+1)
   10 CONTINUE
C
      PHIE=2.D0*PHIE2
      IF (PHIE.EQ.0.D0) THEN
        CALL U2MESS('F','ALGELINE3_32')
      ENDIF
C
      CALL JEDETR('&&RECUDE.TEMP.VRES')
      CALL JEDEMA()
C
      END
