      SUBROUTINE RSMODE(RESU)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*(*) RESU
C RESPONSABLE PELLET J.PELLET
C***********************************************************************
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ======================================================================
C
C     FONCTION  :
C     SI LES CHAM_NO (DEPL_R) DE LA SD RESU NE SONT PAS NUMEROTES
C     COMME LE NUME_DDL DU .REFD, ON LES RENUMEROTE.
C
C    IN/JXVAR : RESU  NOM DU CONCEPT SD_RESULTAT
C-----------------------------------------------------------------------
      INTEGER IRET,IBID,NEQ,IORDR,ISYMB,JORDR,JREFD,K,KRANG
      INTEGER NBNOSY,NBORDR,IEXI,NBVAL,JLIPRF
      CHARACTER*1 KBID,TYP1
      CHARACTER*8 RESU8,NOMGD,MA1,MA2
      CHARACTER*19 RESU19,MATR
      CHARACTER*14 NU
      CHARACTER*16 NOMSYM
      CHARACTER*19 PRCHNO,CHAMPT,NOMCHA,PRCHN1
      CHARACTER*24 VALK(5)
C-----------------------------------------------------------------------
C
C
      CALL JEMARQ()
      RESU19=RESU
      RESU8=RESU
      CALL JEEXIN(RESU19//'.REFD',IEXI)
      IF (IEXI.EQ.0)GOTO 50

      CALL JEVEUO(RESU19//'.REFD','L',JREFD)
      NU=' '
      IF (ZK24(JREFD-1+4).NE.' ') THEN
        NU=ZK24(JREFD-1+4)(1:14)
      ELSE
        DO 10,K=1,3
          IF (ZK24(JREFD-1+K).NE.' ') THEN
            MATR=ZK24(JREFD-1+K)(1:19)
            CALL DISMOI('F','NOM_NUME_DDL',MATR,'MATR_ASSE',IBID,NU,
     &                  IRET)
            GOTO 20

          ENDIF
   10   CONTINUE
   20   CONTINUE
      ENDIF
      IF (NU.EQ.' ')GOTO 50

      PRCHN1=NU//'.NUME'
      CALL DISMOI('F','NOM_MAILLA',NU,'NUME_DDL',IBID,MA1,IRET)

      CHAMPT='&&RSMODE.CHAMPT'

      CALL JEVEUO(RESU19//'.ORDR','L',JORDR)
      CALL JELIRA(RESU19//'.ORDR','LONUTI',NBORDR,KBID)
      CALL JELIRA(RESU19//'.DESC','NOMUTI',NBNOSY,KBID)

      DO 40 ISYMB=1,NBNOSY
        CALL JENUNO(JEXNUM(RESU19//'.DESC',ISYMB),NOMSYM)

        DO 30 KRANG=1,NBORDR
          IORDR=ZI(JORDR-1+KRANG)
          CALL RSEXCH(' ',RESU,NOMSYM,IORDR,NOMCHA,IRET)
          IF (IRET.NE.0)GOTO 30

          CALL DISMOI('F','NOM_GD',NOMCHA,'CHAM_NO',IBID,NOMGD,IRET)
          IF (NOMGD(1:5).NE.'DEPL_') GOTO 30

          CALL DISMOI('F','PROF_CHNO',NOMCHA,'CHAM_NO',IBID,PRCHNO,IRET)
          IF (PRCHNO.EQ.PRCHN1)GOTO 30

          CALL DISMOI('F','NOM_MAILLA',NOMCHA,'CHAM_NO',IBID,MA2,IRET)
          IF (MA1.NE.MA2) THEN
             VALK(1)=RESU
             VALK(2)=MA1
             VALK(3)=NU
             VALK(4)=MA2
             CALL U2MESK('F','UTILITAI_29',4,VALK)
          ENDIF

C        -- SI LE CHAMP NOMCHA N'A PAS LA BONNE NUMEROTATION,
C           IL FAUT LA MODIFIER :
          CALL JELIRA(NOMCHA//'.VALE','TYPE',IBID,TYP1)
          CALL VTCREB(CHAMPT,NU,'V',TYP1,NEQ)
          CALL VTCOPY(NOMCHA,CHAMPT)
          CALL DETRSD('CHAM_NO',NOMCHA)
          CALL COPISD('CHAMP','G',CHAMPT,NOMCHA)
          CALL DETRSD('CHAM_NO',CHAMPT)
   30   CONTINUE
   40 CONTINUE


C     -- IL FAUT ENCORE DETRUIRE LES PROF_CHNO QUI ONT ETE CREES
C        INUTILEMENT SUE LA BASE GLOBALE (POUR SDVERI=OUI)
      IF (RESU.NE.NU(1:8)) THEN
        CALL JELSTC('G',RESU8//'.PRFCN',1,0,KBID,NBVAL)
        IF (NBVAL.LT.0) THEN
          NBVAL=-NBVAL
          CALL WKVECT('&&RSMODES.LIPRFCN','V V K24',NBVAL,JLIPRF)
          CALL JELSTC('G',RESU8//'.PRFCN',1,NBVAL,ZK24(JLIPRF),NBVAL)
          DO 41, K=1,NBVAL
            CALL DETRSD('PROF_CHNO',ZK24(JLIPRF-1+K)(1:19))
   41     CONTINUE
        ENDIF
      ENDIF

   50 CONTINUE
      CALL JEDEMA()
      END
