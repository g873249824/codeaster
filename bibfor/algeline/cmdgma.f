      SUBROUTINE CMDGMA ( MAILLA)
      IMPLICIT NONE
      CHARACTER*(*)       MAILLA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 16/06/2003   AUTEUR CIBHHLV L.VIVAN 
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
C     OPERATEUR CREA_MAILLAGE   MOT CLE FACTEUR "DETR_GROUP_MA"
C     ------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER LIMIT,LONG,NDETR,NUGR,IGMA,N1,IRET,NGRMA,IANUGR,IALIGR
      INTEGER I,JVG,JGG,NBMA,II,ADETR,NGRMAN
      CHARACTER*1   K1B
      CHARACTER*8   MA,NOMG
C     ------------------------------------------------------------------

      CALL JEMARQ ( )

      MA = MAILLA
      CALL JELIRA(MA//'.GROUPEMA','NMAXOC',NGRMA,K1B)
      CALL WKVECT ('&&CMDGMA.NUGRMA_A_DETR','V V I',NGRMA,IANUGR)

      CALL GETVIS('DETR_GROUP_MA','NB_MAILLE',1,1,1,LIMIT,N1)
C     --------------------------------------------------------
      IF (LIMIT.GT.0) THEN
        DO 1,IGMA=1,NGRMA
          CALL JEEXIN(JEXNUM(MA//'.GROUPEMA',IGMA),IRET)
          IF (IRET.GT.0) THEN
            CALL JELIRA(JEXNUM(MA//'.GROUPEMA',IGMA),'LONMAX',LONG,K1B)
            IF (LONG.LE.LIMIT) ZI(IANUGR-1+IGMA)=1
          END IF
1       CONTINUE
      END IF

      CALL GETVEM(MA,'GROUP_MA','DETR_GROUP_MA','GROUP_MA',
     +                1,1,0,ZK8(1),NDETR)
C     ----------------------------------------------------------
      IF (NDETR.LT.0) THEN
        NDETR=-NDETR
        CALL WKVECT ('&&CMDGMA.LIGRMA_A_DETR','V V K8',NDETR,IALIGR)
        CALL GETVEM(MA,'GROUP_MA','DETR_GROUP_MA','GROUP_MA',
     +                  1,1,NDETR,ZK8(IALIGR),N1)
        DO 2,IGMA=1,NDETR
          CALL JENONU(JEXNOM(MA//'.GROUPEMA',ZK8(IALIGR-1+IGMA)),NUGR)
          IF (NUGR.GT.0)  ZI(IANUGR-1+NUGR)=1
2       CONTINUE
      END IF


C     -- DESTRUCTION DES GROUPES DE MAILLES :
C     ---------------------------------------
C
      ADETR = 0
      DO 10, I= 1 , NGRMA
         IF (ZI(IANUGR-1+I).NE.0) ADETR = ADETR + 1
 10   CONTINUE

      NGRMAN = NGRMA - ADETR

      CALL JEDUPO(MA//'.GROUPEMA','V','&&CMDGMA.GROUPEMA',.FALSE.)
      CALL JEDETR(MA//'.GROUPEMA')

      CALL JECREC(MA//'.GROUPEMA','G V I','NOM','DISPERSE',
     +                                          'VARIABLE',NGRMAN)

      DO 3, I=1,NGRMA
        CALL JEEXIN(JEXNUM('&&CMDGMA.GROUPEMA',I),IRET)
        IF (IRET.LE.0) GO TO 3
        IF (ZI(IANUGR-1+I).EQ.0) THEN
          CALL JENUNO(JEXNUM('&&CMDGMA.GROUPEMA',I),NOMG)
          CALL JECROC(JEXNOM(MA//'.GROUPEMA',NOMG))
          CALL JEVEUO(JEXNUM('&&CMDGMA.GROUPEMA',I),'L',JVG)
          CALL JELIRA(JEXNUM('&&CMDGMA.GROUPEMA',I),'LONMAX',NBMA,K1B)
          CALL JEECRA(JEXNOM(MA//'.GROUPEMA',NOMG),'LONMAX',NBMA,' ')
          CALL JEVEUO(JEXNOM(MA//'.GROUPEMA',NOMG),'E',JGG)
          DO 4,II=1,NBMA
            ZI(JGG-1+II)=ZI(JVG-1+II)
 4        CONTINUE
        END IF
 3    CONTINUE

      CALL JEDETR('&&CMDGMA.NUGRMA_A_DETR')
      CALL JEDETR('&&CMDGMA.LIGRMA_A_DETR')
      CALL JEDETR('&&CMDGMA.GROUPEMA')

      CALL JEDEMA ( )
      END
