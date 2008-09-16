      SUBROUTINE CRVRC1()
      IMPLICIT  NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/09/2008   AUTEUR PELLET J.PELLET 
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
C     D'UN CHAMP DE FONCTIONS (INST,EPAIS)
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

      INTEGER IBID,IER,NBFAC,N1,nbinst,kinst,jinst,jlinst
      INTEGER nbin,iret
      REAL*8 RBID,vinst
      COMPLEX*16 CBID
      CHARACTER*8 KBID,RESU,MODELE,CARELE,PAOUT,LPAIN(10),TEMPEF
      CHARACTER*16 TYPE,OPER
      CHARACTER*19 ligrmo,chout,chinst
      CHARACTER*24 K24,CHCARA(15),LCHIN(10)
      LOGICAL EXICAR

C----------------------------------------------------------------------
      CALL JEMARQ()

      CALL GETFAC('PREP_VRC1',NBFAC)
      IF (NBFAC.EQ.0) GOTO 20
      CALL ASSERT(NBFAC.EQ.1)


      CALL GETRES(RESU,TYPE,OPER)
      CALL GETVID('PREP_VRC1','MODELE',1,1,1,MODELE,N1)
      CALL GETVID('PREP_VRC1','CARA_ELEM',1,1,1,CARELE,N1)
      CALL GETVID('PREP_VRC1','CHAM_GD',1,1,1,TEMPEF,N1)


C     -- INSTANTS DE L'EVOL_THER :
      CALL GETVR8('PREP_VRC1','INST',1,1,0,RBID,N1)
      CALL ASSERT(N1.LT.0)
      NBINST = -N1
      CALL WKVECT('&&CRVRC1.LINST','V V R',NBINST,JLINST)
      CALL GETVR8('PREP_VRC1','INST',1,1,NBINST,ZR(JLINST),N1)
      CALL RSCRSD('G',RESU,'EVOL_THER',NBINST)


      LIGRMO = MODELE//'.MODELE'
      PAOUT = 'PTEMPCR'
      CHINST = '&&CRVRC1.CHINST'
      CALL MECARA(CARELE,EXICAR,CHCARA)

      LPAIN(1) = 'PNBSP_I'
      LCHIN(1) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(2) = 'PTEMPEF'
      LCHIN(2) = TEMPEF
      LPAIN(3) = 'PINST_R'
      LCHIN(3) = CHINST
      LPAIN(4) = 'PCACOQU'
      LCHIN(4) = CHCARA(7)
      NBIN = 4

C     -- BOUCLE SUR LES INSTANTS :
C     --------------------------------
      DO 10,KINST = 1,NBINST
        VINST = ZR(JLINST-1+KINST)
        CALL MECACT('V',CHINST,'MODELE',LIGRMO,'INST_R',1,'INST',IBID,
     &              VINST,CBID,KBID)
        CALL RSEXCH(RESU,'TEMP',KINST,CHOUT,IRET)

        CALL CESVAR(CARELE,' ',LIGRMO,CHOUT)
        CALL CALCUL('S','PREP_VRC',LIGRMO,NBIN,LCHIN,LPAIN,1,CHOUT,
     &              PAOUT,'G')
        CALL DETRSD('CHAM_ELEM_S',CHOUT)
        CALL RSNOCH(RESU,'TEMP',KINST,' ')
        CALL RSADPA(RESU,'E',1,'INST',KINST,0,JINST,KBID)
        ZR(JINST) = VINST
        CALL DETRSD('CHAMP',CHINST)
   10 CONTINUE


      CALL JEDETR('&&CRVRC1.LINST')


   20 CONTINUE
      CALL JEDEMA()
      END
