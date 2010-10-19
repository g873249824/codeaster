      SUBROUTINE PECAGE(RESU,MODELE,NBOCC)
      IMPLICIT   NONE
      INTEGER NBOCC
      CHARACTER*(*) RESU,MODELE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 19/10/2010   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     OPERATEUR   POST_ELEM
C     TRAITEMENT DU MOT CLE-FACTEUR "CARA_GEOM"
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
      INTEGER MXVALE,NBPARR,IBID,IRET,LVALE,IOCC,NT,NG,NM,NBGRMA,JGR,IG,
     &        NBMA,JAD,NBMAIL,JMA,IM,NUME,NDIM,NS1,NS2,IE,NBPARC,NP,IFM,
     &        NIV,IORIG,NRE,NR,I,ICAGE
      PARAMETER (MXVALE=29,NBPARR=44)
      REAL*8 VALPAR(NBPARR),R8B,XYP(2),ORIG(3),ZERO,R8VIDE
      CHARACTER*3 SYMEX,SYMEY,TYPARR(NBPARR)
      CHARACTER*8 K8B,NOMA,LPAIN(15),LPAOUT(5),VALEK(2)
      CHARACTER*16 OPTION,NOPARR(NBPARR)
      CHARACTER*19 CHELEM
      CHARACTER*24 LCHIN(15),LCHOUT(1),LIGREL,MLGGMA,MLGNMA
      CHARACTER*24 CHGEOM,CHCARA(18),CHHARM
      COMPLEX*16 C16B
      LOGICAL NSYMX,NSYMY,EXIGEO
C     ------------------------------------------------------------------
      DATA NOPARR/'LIEU','ENTITE','AIRE_M','CDG_X_M','CDG_Y_M','IX_G_M',
     &     'IY_G_M','IXY_G_M','Y_MAX','Z_MAX','Y_MIN','Z_MIN','R_MAX',
     &     'AIRE','CDG_X','CDG_Y','IX_G','IY_G','IXY_G','IY_PRIN_G',
     &     'IZ_PRIN_G','ALPHA','X_P','Y_P','IX_P','IY_P','IXY_P','CT',
     &     'AY','AZ','EY','EZ','PCTX','PCTY','JG','KY','KZ','IXR2',
     &     'IYR2','IYR2_PRIN_G','IZR2_PRIN_G','IXR2_P','IYR2_P',
     &     'MAILLAGE'/
      DATA TYPARR/'K8','K8','R','R','R','R','R','R','R','R','R','R','R',
     &     'R','R','R','R','R','R','R','R','R','R','R','R','R','R','R',
     &     'R','R','R','R','R','R','R','R','R','R','R','R','R','R','R',
     &     'K8'/
C     ------------------------------------------------------------------

      CALL JEMARQ()
      IORIG = 0
      ICAGE = 1

C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)

      OPTION = 'CARA_GEOM'
C      CALL MECHAM ( OPTION, MODELE, NCHAR, LCHAR, CARA, NH,
C     &                              CHGEOM, CHCARA, CHHARM, IRET )
C      IF ( IRET .NE. 0 ) GOTO 9999
      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      ZERO = 0.0D0
      ORIG(1) = ZERO
      ORIG(2) = ZERO
      ORIG(3) = ZERO
      NOMA = CHGEOM(1:8)
      MLGNMA = NOMA//'.NOMMAI'
      MLGGMA = NOMA//'.GROUPEMA'
      NDIM = 3
      CALL DISMOI('F','Z_CST',MODELE,'MODELE',IBID,K8B,IE)
      IF (K8B(1:3).EQ.'OUI') NDIM = 2

      CALL EXLIM3('CARA_GEOM','V',MODELE,LIGREL)

C     --- CALCUL DE L'OPTION ---
      CHELEM = '&&PECAGE.CARA_GEOM'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAOUT(1) = 'PCARAGE'
      LCHOUT(1) = CHELEM

      CALL CALCUL('S',OPTION,LIGREL,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')

      NSYMX = .FALSE.
      NSYMY = .FALSE.
      CALL GETVTX('CARA_GEOM','SYME_X',1,1,1,SYMEX,NS1)
      CALL GETVTX('CARA_GEOM','SYME_Y',1,1,1,SYMEY,NS2)
      IF (SYMEX.EQ.'OUI') NSYMX = .TRUE.
      IF (SYMEY.EQ.'OUI') NSYMY = .TRUE.
      CALL GETVR8('CARA_GEOM','ORIG_INER',1,1,2,XYP,NP)

C     --- CREATION DE LA TABLE ---

      IF (NDIM.EQ.2) THEN
        CALL TBCRSD(RESU,'G')
        CALL TBAJPA(RESU,NBPARR,NOPARR,TYPARR)
      ELSE
        CALL U2MESS('F','UTILITAI3_48')
      END IF
      NBPARC = NBPARR - 1
      CALL TBAJLI(RESU,1,NOPARR(NBPARR),IBID,R8B,C16B,NOMA,0)

      CALL WKVECT('&&PECAGE.TRAV1','V V R',MXVALE,LVALE)
      DO 40 IOCC = 1,NBOCC

        CALL GETVTX('CARA_GEOM','TOUT'    ,IOCC,1,0,K8B,NT)
        CALL GETVTX('CARA_GEOM','GROUP_MA',IOCC,1,0,K8B,NG)
        CALL GETVTX('CARA_GEOM','MAILLE'  ,IOCC,1,0,K8B,NM)

        DO 10 I = 1 , NBPARR
           VALPAR(I) = R8VIDE()
 10     CONTINUE
        VALEK(1) = '????????'
        VALEK(2) = '????????'

        IF (NT.NE.0) THEN
          CALL PEMICA(CHELEM,MXVALE,ZR(LVALE),0,IBID,ORIG,IORIG,ICAGE)
          CALL PECAG2(NDIM,NSYMX,NSYMY,NP,XYP,ZR(LVALE),VALPAR)
          CALL PECAG3(NDIM,NSYMX,NSYMY,NOMA,'TOUT',0,K8B,VALPAR)
          VALEK(1) = NOMA
          VALEK(2) = 'TOUT'
          CALL TBAJLI(RESU,NBPARC,NOPARR,IBID,VALPAR,C16B,VALEK,0)
        END IF

        IF (NG.NE.0) THEN
          NBGRMA = -NG
          CALL WKVECT('&&PECAGE_GROUPM','V V K8',NBGRMA,JGR)
          CALL GETVTX('CARA_GEOM','GROUP_MA',IOCC,1,NBGRMA,ZK8(JGR),NG)
          VALEK(2) = 'GROUP_MA'
          DO 20 IG = 1,NBGRMA
            CALL JEEXIN(JEXNOM(MLGGMA,ZK8(JGR+IG-1)),IRET)
            IF (IRET.EQ.0) THEN
              CALL U2MESK('A','UTILITAI3_46',1,ZK8(JGR+IG-1))
              GO TO 20
            END IF
            CALL JELIRA(JEXNOM(MLGGMA,ZK8(JGR+IG-1)),'LONUTI',NBMA,K8B)
            IF (NBMA.EQ.0) THEN
              CALL U2MESK('A','UTILITAI3_47',1,ZK8(JGR+IG-1))
              GO TO 20
            END IF
            CALL JEVEUO(JEXNOM(NOMA//'.GROUPEMA',ZK8(JGR+IG-1)),'L',JAD)
            CALL PEMICA(CHELEM,MXVALE,ZR(LVALE),NBMA,ZI(JAD),ORIG,IORIG,
     &                  ICAGE)
            CALL PECAG2(NDIM,NSYMX,NSYMY,NP,XYP,ZR(LVALE),VALPAR)
            CALL PECAG3(NDIM,NSYMX,NSYMY,NOMA,'GROUP_MA',1,
     &                  ZK8(JGR+IG-1),VALPAR)
            VALEK(1) = ZK8(JGR+IG-1)
            CALL TBAJLI(RESU,NBPARC,NOPARR,IBID,VALPAR,C16B,VALEK,0)
   20     CONTINUE
          CALL JEDETR('&&PECAGE_GROUPM')
        END IF

        IF (NM.NE.0) THEN
          NBMAIL = -NM
          CALL WKVECT('&&PECAGE_MAILLE','V V K8',NBMAIL,JMA)
          CALL GETVTX('CARA_GEOM','MAILLE',IOCC,1,NBMAIL,ZK8(JMA),NM)
          VALEK(2) = 'MAILLE'
          DO 30 IM = 1,NBMAIL
            CALL JEEXIN(JEXNOM(MLGNMA,ZK8(JMA+IM-1)),IRET)
            IF (IRET.EQ.0) THEN
              CALL U2MESK('A','UTILITAI3_49',1,ZK8(JMA+IM-1))
              GO TO 30
            END IF
            CALL JENONU(JEXNOM(MLGNMA,ZK8(JMA+IM-1)),NUME)
            CALL PEMICA(CHELEM,MXVALE,ZR(LVALE),1,NUME,ORIG,IORIG,ICAGE)
            CALL PECAG2(NDIM,NSYMX,NSYMY,NP,XYP,ZR(LVALE),VALPAR)
            CALL PECAG3(NDIM,NSYMX,NSYMY,NOMA,'MAILLE',NBMAIL,ZK8(JMA),
     &                  VALPAR)
            VALEK(1) = ZK8(JMA+IM-1)
            CALL TBAJLI(RESU,NBPARC,NOPARR,IBID,VALPAR,C16B,VALEK,0)
   30     CONTINUE

          CALL JEDETR('&&PECAGE_MAILLE')
        END IF
   40 CONTINUE

      CALL JEDETC('V','&&PECAGE',1)

   50 CONTINUE
      CALL JEDEMA()
      END
