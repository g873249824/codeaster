      SUBROUTINE DEELPO(CAELEM,NOMA,NUMAIL,PHIE)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RECUPERATION DU DIAMETRE EXTERIEUR D'UN ELEMENT DE POUTRE
C-----------------------------------------------------------------------
C  IN : CAELEM : NOM DU CONCEPT DE TYPE CARA_ELEM
C  IN : NOMA   : NOM DU CONCEPT DE TYPE MAILLAGE
C  IN : NUMAIL : NUMERO DE LA MAILLE CORRESPONDANTE
C  OUT: PHIE   : DIAMETRE EXTERIEUR SUR L'ELEMENT
C-----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      CHARACTER*8  CAELEM,NOMA
      INTEGER      NUMAIL
      REAL*8       PHIE
C
      REAL*8       R8PREM
      CHARACTER*1  K1BID
      CHARACTER*8  NOMCMP(2),NOMAIL
      CHARACTER*19 CARTE
      CHARACTER*24 CADESC,CAVALE,CALIMA,GPMAMA,NOMAMA
C
C-----------------------------------------------------------------------
      INTEGER IAS ,IASBON ,IASEDI ,IASMAX ,ICAD ,ICAV ,ICMP 
      INTEGER ICODE ,IGPMA ,IGRAND ,ILIMA ,IMA ,INOMCP ,IRANG1 
      INTEGER IRANG2 ,IRANV1 ,IRANV2 ,IRET ,ITAB ,NBCMP ,NBMA 
      INTEGER NUENTI ,NUMA 
      REAL*8 DIFR ,R1 ,R2 ,TOLR 
C-----------------------------------------------------------------------
      DATA NOMCMP /'R1      ','R2      '/
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C
C-----1.ACCES AUX OBJETS UTILES
C
      GPMAMA = NOMA//'.GROUPEMA'
C
      CARTE  = CAELEM//'.CARGEOPO'
      CADESC = CARTE//'.DESC'
      CAVALE = CARTE//'.VALE'
      CALIMA = CARTE//'.LIMA'
      CALL JEEXIN(CADESC,IRET)
      IF (IRET.EQ.0) CALL U2MESS('F','ALGELINE_33')
      CALL JEVEUO(CADESC,'L',ICAD)
      CALL JEVEUO(CAVALE,'L',ICAV)
C
C
C-----2.DETERMINATION DU NUMERO D'ASSOCIATION CORRESPONDANT DANS LA
C       CARTE
C
      IASMAX = ZI(ICAD+1)
      IASEDI = ZI(ICAD+2)
      IASBON = 0
C
      DO 10 IAS = 1,IASEDI
C
        ICODE = ZI(ICAD+3+2*(IAS-1))
        NUENTI = ZI(ICAD+3+2*(IAS-1)+1)
C
        IF (ICODE.EQ.2) THEN
          CALL JEVEUO(JEXNUM(GPMAMA,NUENTI),'L',IGPMA)
          CALL JELIRA(JEXNUM(GPMAMA,NUENTI),'LONMAX',NBMA,K1BID)
          DO 20 IMA = 1,NBMA
            NUMA = ZI(IGPMA+IMA-1)
            IF (NUMA.EQ.NUMAIL) THEN
              IASBON = IAS
              GOTO 40
            ENDIF
  20      CONTINUE
C
        ELSE IF (ICODE.EQ.3) THEN
          CALL JEVEUO(JEXNUM(CALIMA,NUENTI),'L',ILIMA)
          CALL JELIRA(JEXNUM(CALIMA,NUENTI),'LONMAX',NBMA,K1BID)
          DO 30 IMA = 1,NBMA
            NUMA = ZI(ILIMA+IMA-1)
            IF (NUMA.EQ.NUMAIL) THEN
              IASBON = IAS
              GOTO 40
            ENDIF
  30      CONTINUE
        ENDIF
C
  10  CONTINUE
  40  CONTINUE
      IF (IASBON.EQ.0) THEN
        NOMAMA = NOMA//'.NOMMAI'
        CALL JENUNO(JEXNUM(NOMAMA,NUMAIL),NOMAIL)
        CALL U2MESK('F','ALGELINE_34',1,NOMAIL)
      ENDIF
C
C
C-----3.EXTRACTION DES RAYONS EXTERIEURS AUX DEUX EXTREMITES DE
C       L'ELEMENT
C       SI LE RAYON EXTERIEUR EST CONSTANT SUR L'ELEMENT, ON DEDUIT
C       LE DIAMETRE EXTERIEUR
C
      IGRAND = ZI(ICAD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',IGRAND),'LONMAX',NBCMP,K1BID)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP','CAGEPO'),'L',INOMCP)
      IRANG1 = 0
      IRANG2 = 0
      DO 50 ICMP = 1,NBCMP
        IF (ZK8(INOMCP+ICMP-1).EQ.NOMCMP(1)) IRANG1 = ICMP
        IF (ZK8(INOMCP+ICMP-1).EQ.NOMCMP(2)) IRANG2 = ICMP
  50  CONTINUE
      IF (IRANG1.EQ.0 .OR. IRANG2.EQ.0) CALL U2MESS('F','ALGELINE_35')
C
      CALL WKVECT('&&DEELPO.TEMP.TABL','V V I',NBCMP,ITAB)
      ICODE = ZI(ICAD+3+2*IASMAX+IASBON-1)
      CALL DEC2PN(ICODE,ZI(ITAB),NBCMP)
      IRANV1 = 0
      DO 61 ICMP = 1,IRANG1
        IF (ZI(ITAB+ICMP-1).EQ.1) IRANV1 = IRANV1 + 1
  61  CONTINUE
      IRANV2 = 0
      DO 62 ICMP = 1,IRANG2
        IF (ZI(ITAB+ICMP-1).EQ.1) IRANV2 = IRANV2 + 1
  62  CONTINUE
      IF (IRANV1.EQ.0 .OR. IRANV2.EQ.0) CALL U2MESS('F','ALGELINE_36')
C
      R1 = ZR(ICAV+NBCMP*(IASBON-1)+IRANV1-1)
      R2 = ZR(ICAV+NBCMP*(IASBON-1)+IRANV2-1)
      IF (R1.EQ.0.D0 .OR. R2.EQ.0.D0) CALL U2MESS('F','ALGELINE_37')
      TOLR = R8PREM()
      DIFR = DBLE(ABS(R1-R2))
      IF (DIFR.GT.R1*TOLR) CALL U2MESS('F','ALGELINE_38')
C
      PHIE = 2.D0*R1
C
      CALL JEDETR('&&DEELPO.TEMP.TABL')
      CALL JEDEMA()
C
      END
