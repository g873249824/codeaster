      SUBROUTINE PMFD01(NOMA,CARELE,VNBFIB,VPOINT,VCARFI,VNBFIG,
     &                  CESDEC,NGMXEL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 15/01/2008   AUTEUR PELLET J.PELLET 
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
C ----------------------------------------------------------------------
C     COMMANDE AFFE_CARA_ELEM
C       FABRICATION DE 2 CHAM_ELEM_S/'ELEM' :
C          - CARELE//'.CANBSP'
C          - CARELE//'.CAFIBR'

C       TRAITEMENT DES MOTS CLES AFFE_SECT ET AFFE_FIBRE
C       TRANSFORMATION DES OBJETS VNBFIB,VPOINT,VCARFI
C       + PRISE EN COMPTE DE CESDEC

C ----------------------------------------------------------------------
      IMPLICIT NONE
      CHARACTER*8 NOMA,CARELE,MODELE
      CHARACTER*24 VNBFIB,VPOINT,VCARFI,VNBFIG
      CHARACTER*19 CESDEC
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
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER JNBFIB,JPOINT,JCARFI,JCES1D,JCES1V,JCES1L,JNBFIG
      INTEGER IAD,ICMP,NCARFI,POINT,IMA,NBFIB,IBID,NBMA
      INTEGER NB1,ISPT,NNCP,IFIB,IG,NBGF,NBFIG,NUG,IPOS,IRET
      CHARACTER*1 KBID,KI1
      CHARACTER*2 KI2
      CHARACTER*19 CES1,LICHS(2),CES3,LIGRMO,CEL
      LOGICAL LCUMUL(2),EXIPMF
      REAL*8 LCOEFR(2)
      CHARACTER*8  LICMP(2+99)
      COMPLEX*16 CBID
      INTEGER NGMXEL,NBCP,JSP

C     ------------------------------------------------------------------

      CALL JEMARQ()
      NBCP=2+NGMXEL

      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,KBID,IBID)
      CALL GETVID(' ','MODELE',0,1,1,MODELE,IBID)
      LIGRMO = MODELE//'.MODELE'

      CALL GETFAC('MULTIFIBRE',NB1)

      EXIPMF = (NB1.GT.0)

C     1. IL N'EXISTE PAS D'ELEMENTS PMF :
C     -------------------------------------------
      IF (.NOT.EXIPMF) THEN
        CEL = CARELE//'.CANBSP'
        CALL CESCEL(CESDEC,LIGRMO,'TOU_INI_ELEM',' ','NON',NNCP,'G',CEL,
     &              'A',IRET)
        IF (IRET.EQ.0) GO TO 50
        CALL U2MESK('F','CALCULEL_6',1,MODELE)

      END IF


C     2. IL EXISTE DES ELEMENTS PMF :
C     --------------------------------------
      CALL JEVEUO(VNBFIB,'L',JNBFIB)
      CALL JEVEUO(VPOINT,'L',JPOINT)
      CALL JEVEUO(VCARFI,'L',JCARFI)
      CALL JEVEUO(VNBFIG,'L',JNBFIG)

C     2.1. CREATION DU CHAMP CARELE//'.CANBSP' :
C     --------------------------------------
      CES1 = '&&PMFD01.CES1'
      LICMP(1)='NBFIBR'
      LICMP(2)='NBGRFI'
      IF(NGMXEL.LE.9)THEN
        DO 2 IG=1,NGMXEL
          CALL CODENT(IG,'G',KI1)
          LICMP(2+IG)='NUG'//KI1
  2     CONTINUE
      ELSEIF(NGMXEL.LE.99)THEN
        DO 3 IG=1,9
          CALL CODENT(IG,'G',KI1)
          LICMP(2+IG)='NUG'//KI1
  3     CONTINUE
        DO 4 IG=10,NGMXEL
          CALL CODENT(IG,'G',KI2)
          LICMP(2+IG)='NUG'//KI2
  4     CONTINUE
      ENDIF
      CALL CESCRE('V',CES1,'ELEM',NOMA,'NBSP_I',NBCP,LICMP,-1,-1,-NBCP)
      CALL JEVEUO(CES1//'.CESD','L',JCES1D)
      CALL JEVEUO(CES1//'.CESL','E',JCES1L)
      CALL JEVEUO(CES1//'.CESV','E',JCES1V)
      DO 10,IMA = 1,NBMA
        DO 12 ICMP=1,NBCP
          CALL CESEXI('C',JCES1D,JCES1L,IMA,1,1,ICMP,IAD)
          CALL ASSERT(IAD.LT.0)
          ZL(JCES1L-1-IAD) = .TRUE.
          ZI(JCES1V-1-IAD) = ZI(JNBFIB-1+(IMA-1)*NBCP+ICMP)
   12   CONTINUE
   10 CONTINUE

C --- 2.1.2. FUSION DE CES1 AVEC CESDEC :
C     --------------------------------------
      LICHS(1) = CES1
      LICHS(2) = CESDEC
      LCUMUL(1) = .TRUE.
      LCUMUL(2) = .TRUE.
      LCOEFR(1) = 1.D0
      LCOEFR(2) = 1.D0
      CES3 = '&&PMFD01.CES3'
      CALL CESFUS(2,LICHS,LCUMUL,LCOEFR,CBID,.FALSE.,'V',CES3)
      CALL DETRSD('CHAM_ELEM_S',CES1)

      CEL = CARELE//'.CANBSP'
      CALL CESCEL(CES3,LIGRMO,'TOU_INI_ELEM',' ','NON',NNCP,'G',CEL,'F',
     &            IBID)
      CALL DETRSD('CHAM_ELEM_S',CES3)


C     2.2. CREATION DU CHAMP CARELE//'.CAFIBR' :
C     -----------------------------------------
C     NCARFI = NOMBRE DE CARACTERISTIQUES PAR FIBRE
      NCARFI = 3

C on fait un vecteur uniquement avec les nb de fibres
      CALL WKVECT('&&PMFD01.NBSP','V V I',NBMA,JSP)
      DO 70 IMA=1,NBMA
        ZI(JSP-1+IMA)=ZI(JNBFIB+(IMA-1)*NBCP)
  70  CONTINUE

      LICMP(1)='XG'
      LICMP(2)='YG'
      LICMP(3)='AIRE'
      CALL CESCRE('V',CES1,'ELEM',NOMA,'CAFI_R',3,LICMP,-1,
     &            ZI(JSP),-3)
      CALL JEVEUO(CES1//'.CESD','L',JCES1D)
      CALL JEVEUO(CES1//'.CESL','E',JCES1L)
      CALL JEVEUO(CES1//'.CESV','E',JCES1V)
      DO 40,IMA = 1,NBMA
        IPOS=JNBFIB+(IMA-1)*NBCP
        NBGF=ZI(IPOS+1)
        ISPT=0
        DO 37 IG=1,NBGF
          NUG = ZI(IPOS+1+IG)
          NBFIG = ZI(JNBFIG-1+NUG)
          POINT = ZI(JPOINT-1+NUG)
          DO 35,IFIB = 1,NBFIG
            ISPT=ISPT+1
            DO 30,ICMP = 1,NCARFI
              CALL CESEXI('C',JCES1D,JCES1L,IMA,1,ISPT,ICMP,IAD)
C              CALL ASSERT(IAD.LT.0)
              ZL(JCES1L-1-IAD) = .TRUE.
              ZR(JCES1V-1-IAD)=ZR(JCARFI-1+POINT-1+(IFIB-1)*NCARFI+ICMP)
   30       CONTINUE
   35     CONTINUE
   37   CONTINUE
   40 CONTINUE

      CEL = CARELE//'.CAFIBR'
      CALL CESCEL(CES1,LIGRMO,'TOU_INI_ELEM',' ','NON',NNCP,'G',CEL,'F',
     &            IBID)
      CALL DETRSD('CHAM_ELEM_S',CES1)


   50 CONTINUE
      CALL JEDEMA()
      END
