      SUBROUTINE CRVRC2()
      IMPLICIT  NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/10/2008   AUTEUR TORKHANI M.TORKHANI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     COMMANDE:  CREA_RESU
C     CREE UNE STRUCTURE DE DONNEE DE TYPE "EVOL_THER"  CONTENANT
C     LA TEMPERATURE SUR LES COUCHES DES COQUES MULTICOUCHE A PARTIR
C     D'UN EVOL_THER CONTENANT TEMP/TEMP_INF/TEMP_SUP
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER IBID,IER,NBFAC,N1,NBINST,KINST,JORDR1,IORDR
      INTEGER NBIN,IRET,JINST
      REAL*8 RBID ,VINST
      COMPLEX*16 CBID
      CHARACTER*8 KBID,RESU,MODELE,CARELE,PAOUT,LPAIN(10)
      CHARACTER*16 TYPE,OPER
      CHARACTER*19 LIGRMO,CHOUT,RESU1,CHTEMP
      CHARACTER*24 K24,CHCARA(18),LCHIN(10)
      LOGICAL EXICAR

C----------------------------------------------------------------------
      CALL JEMARQ()

      CALL GETFAC('PREP_VRC2',NBFAC)
      IF (NBFAC.EQ.0) GOTO 20
      CALL ASSERT(NBFAC.EQ.1)


      CALL GETRES(RESU,TYPE,OPER)
      CALL GETVID('PREP_VRC2','MODELE',1,1,1,MODELE,N1)
      CALL GETVID('PREP_VRC2','CARA_ELEM',1,1,1,CARELE,N1)
      CALL GETVID('PREP_VRC2','EVOL_THER',1,1,1,RESU1,N1)


      CALL JELIRA(RESU1//'.ORDR','LONUTI',NBINST,KBID)
      CALL JEVEUO(RESU1//'.ORDR','L',JORDR1)
      CALL ASSERT(NBINST.GT.0)
      CALL RSCRSD('G',RESU,'EVOL_THER',NBINST)


      LIGRMO = MODELE//'.MODELE'
      PAOUT = 'PTEMPCR'
      CALL MECARA(CARELE,EXICAR,CHCARA)

      LPAIN(1) = 'PNBSP_I'
      LCHIN(1) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(2) = 'PTEMPER'
      LPAIN(3) = 'PCACOQU'
      LCHIN(3) = CHCARA(7)
      NBIN = 3

C     -- BOUCLE SUR LES INSTANTS :
C     --------------------------------
      DO 10,KINST = 1,NBINST
        IORDR = ZI(JORDR1+KINST-1)
        CALL RSEXCH(RESU1,'TEMP',IORDR,CHTEMP,IRET)
        CALL ASSERT(IRET.EQ.0)
        LCHIN(2) = CHTEMP

        CALL RSEXCH(RESU,'TEMP',IORDR,CHOUT,IRET)
        CALL CESVAR(CARELE,' ',LIGRMO,CHOUT)
        CALL CALCUL('S','PREP_VRC',LIGRMO,NBIN,LCHIN,LPAIN,1,CHOUT,
     &              PAOUT,'G')
        CALL DETRSD('CHAM_ELEM_S',CHOUT)
        CALL RSNOCH(RESU,'TEMP',IORDR,' ')
        CALL RSADPA(RESU1,'L',1,'INST',IORDR,0,JINST,KBID)
        VINST=ZR(JINST)
        CALL RSADPA(RESU,'E',1,'INST',IORDR,0,JINST,KBID)
        ZR(JINST) = VINST

   10 CONTINUE


   20 CONTINUE
      CALL JEDEMA()
      END
