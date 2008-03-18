      SUBROUTINE RSNOCH(NOMSD,NOMSY,IORDR,CHNOTZ)
      IMPLICIT NONE
      INTEGER IORDR
      CHARACTER*(*) NOMSD,NOMSY,CHNOTZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 18/03/2008   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE VABHHTS J.PELLET

C  BUT : NOTER LE NOM D'UN CHAMP19 DANS UNE SD_RESULTAT
C        ON VERIFIE QUE :
C           - LE CHAMP CHNOTZ EXISTE
C           - LA PLACE EST LICITE (NOMSY OK ET IORDR<=NBORDR_MAX)
C        ON NE VERIFIE PAS QUE :
C           - LA PLACE EST LIBRE (.TACH EST " ")
C             (BECAUSE NORM_MODE/CALC_ELEM EN ECRASEMENT ...)
C ----------------------------------------------------------------------
C IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
C IN  : NOMSY  : NOM SYMBOLIQUE DU CHAMP A NOTER.
C IN  : IORDR  : NUMERO D'ORDRE DU CHAMP A NOTER.
C IN  : CHNOTZ : NOM DU CHAMP A NOTER.
C                SI CHNOTZ=' ', ON PREND LE NOM DONNE PAR RSEXCH.
C ----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      CHARACTER*16 NOMS2
      CHARACTER*19 NOMD2,CHNOTE
      CHARACTER*24 VALK(2)
      CHARACTER*8  REPK
      CHARACTER*1  K1BID
      INTEGER NORMAX,IRETOU,NORDR,IRANG,JORDR,IRET,IBID,JTACH
C ----------------------------------------------------------------------

      CALL JEMARQ()

      NOMS2 = NOMSY
      NOMD2 = NOMSD
      CHNOTE = CHNOTZ


C     -- CALCUL ET VALIDATION DU NUMERO DE RANGEMENT :IRANG
C     -----------------------------------------------------
      CALL JELIRA(NOMD2//'.ORDR','LONMAX',NORMAX,K1BID)
      CALL RSUTRG(NOMD2,IORDR,IRETOU)
      IF (IRETOU.EQ.0) THEN
        CALL JELIRA(NOMD2//'.ORDR','LONUTI',NORDR,K1BID)
        IRANG = NORDR + 1
        IF (IRANG.GT.NORMAX) CALL U2MESS('F','UTILITAI4_42')
        CALL JEECRA(NOMD2//'.ORDR','LONUTI',IRANG,' ')
        CALL JEVEUO(NOMD2//'.ORDR','E',JORDR)
        ZI(JORDR-1+IRANG) = IORDR
      ELSE
        IRANG = IRETOU
      END IF


C     -- ON VERIFIE LE NOM SYMBOLIQUE :
C     -------------------------------------------
      CALL JENONU(JEXNOM(NOMD2//'.DESC',NOMS2),IRET)
      IF (IRET.EQ.0) THEN
        VALK(1) = NOMS2
        VALK(2) = NOMD2
        CALL U2MESK('F','UTILITAI4_43', 2 ,VALK)
      ENDIF

C     -- SI LE NOM DU CHAMP (CHNOTE) N'EST PAS DONNE, ON PREND CELUI
C        QUE RSEXCH LUI DONNERAIT :
C     ---------------------------------------------------------------
      IF (CHNOTE.EQ.' ') CALL RSEXCH(NOMD2,NOMS2,IORDR,CHNOTE,IRET)


C     -- ON VERIFIE L'EXISTANCE DE CHNOTE :
C     -------------------------------------------
      CALL EXISD('CHAMP_GD',CHNOTE,IRET)
      IF (IRET.EQ.0) CALL U2MESK('F','UTILITAI_55',1,CHNOTE)


C     --- ON STOCKE LE NOM DU CHAMP :
C     ------------------------------
      CALL JENONU(JEXNOM(NOMD2//'.DESC',NOMS2),IBID)
      CALL JEVEUO(JEXNUM(NOMD2//'.TACH',IBID),'E',JTACH)

      ZK24(JTACH+IRANG-1) (1:19) = CHNOTE


C     -- POUR COMMUNIQUER ENTRE PROC LES CHAM_ELEM INCOMPLETEMENT
C        CALCULES :
      CALL DISMOI('F','TYPE_CHAMP',CHNOTE,'CHAMP',IBID,REPK,IRET)
      IF (REPK(1:2).EQ.'EL') CALL SDMPIC('CHAM_ELEM',CHNOTE)

      CALL JEDEMA()
      END
