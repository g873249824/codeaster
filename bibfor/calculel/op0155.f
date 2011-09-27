      SUBROUTINE OP0155()
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 26/09/2011   AUTEUR SELLENET N.SELLENET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C ======================================================================
C     COMMANDE :  POST_CHAMP
C ----------------------------------------------------------------------
      IMPLICIT NONE
C   ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER IFM,NIV,N0,IRET,JORDR,NBORDR,IE,NUORDR
      INTEGER I,J,JNOMPA,IADIN,IADOU,NBAC,NBPA,NBPARA
      CHARACTER*1  K1BID
      CHARACTER*16 CRIT,TYPESD,K16B,NOPARA
      CHARACTER*8 RESU,NOMRES
      CHARACTER*3 TYPE
      CHARACTER*19 RESU19,NOMR19
      REAL*8 PREC
      CHARACTER*24 NOMPAR
      INTEGER      IARG
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C

      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

      CALL GETRES(NOMRES,TYPESD,K16B)
      CALL GETVID(' ','RESULTAT',1,IARG,1,RESU,N0)
      RESU19=RESU

C     -- SELECTION DES NUMERO D'ORDRE :
C     ---------------------------------
      PREC=-1.D0
      CRIT=' '
      CALL GETVR8(' ','PRECISION',0,IARG,1,PREC,IE)
      CALL GETVTX(' ','CRITERE',0,IARG,1,CRIT,IE)
      CALL RSUTNU(RESU19,' ',0,'&&OP0155.NUME_ORDRE',NBORDR,PREC,CRIT,
     &            IRET)
      CALL ASSERT(IRET.EQ.0)
      CALL ASSERT(NBORDR.GT.0)
      CALL JEVEUO('&&OP0155.NUME_ORDRE','L',JORDR)


C     -- 1. ON CREE LA SD_RESULTAT NOMRES :
C     ---------------------------------------------
      CALL RSCRSD('G',NOMRES,TYPESD,NBORDR)


C     -- 2. MOTS CLES EXTR_XXXX :
C     ----------------------------
      CALL W155EX(NOMRES,RESU,NBORDR,ZI(JORDR))


C     -- 3. MOT CLE MIN_MAX_SP :
C     ----------------------------
      CALL W155MX(NOMRES,RESU,NBORDR,ZI(JORDR))


C     -- 4. RECOPIE DES PARAMETRES DE RESU VERS NOMRES :
C     --------------------------------------------------
      NOMPAR='&&OP0155'//'.NOMS_PARA'
      CALL RSNOPA(RESU,2,NOMPAR,NBAC,NBPA)
      NBPARA=NBAC+NBPA
      CALL JEVEUO(NOMPAR,'L',JNOMPA)
      NOMR19 = NOMRES
      CALL JEVEUO(NOMR19//'.ORDR','L',JORDR)
      CALL JELIRA(NOMR19//'.ORDR','LONUTI',NBORDR,K1BID)

      DO 20 I=1,NBORDR
        NUORDR=ZI(JORDR-1+I)
        DO 10 J=1,NBPARA
          NOPARA=ZK16(JNOMPA-1+J)
          CALL RSADPA(RESU,'L',1,NOPARA,NUORDR,1,IADIN,TYPE)
          CALL RSADPA(NOMRES,'E',1,NOPARA,NUORDR,1,IADOU,TYPE)
          IF (TYPE(1:1).EQ.'I') THEN
            ZI(IADOU)=ZI(IADIN)
          ELSEIF (TYPE(1:1).EQ.'R') THEN
            ZR(IADOU)=ZR(IADIN)
          ELSEIF (TYPE(1:1).EQ.'C') THEN
            ZC(IADOU)=ZC(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K80') THEN
            ZK80(IADOU)=ZK80(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K32') THEN
            ZK32(IADOU)=ZK32(IADIN)
          ELSEIF (TYPE(1:3).EQ.'K24') THEN
            ZK24(IADOU)=ZK24(IADIN)
            IF (NOPARA(1:5).EQ.'EXCIT' .AND.
     &          ZK24(IADIN)(1:2).NE.'  ') THEN
              ZK24(IADOU)=NOMRES//ZK24(IADIN)(9:)
              CALL COPISD(' ','G',ZK24(IADIN)(1:19),ZK24(IADOU)(1:19))
            ENDIF
          ELSEIF (TYPE(1:3).EQ.'K16') THEN
            ZK16(IADOU)=ZK16(IADIN)
          ELSEIF (TYPE(1:2).EQ.'K8') THEN
            ZK8(IADOU)=ZK8(IADIN)
          ENDIF
   10   CONTINUE
   20 CONTINUE
      CALL JEDETR(NOMPAR)



      CALL JEDETR('&&OP0155.NUME_ORDRE')
      CALL JEDEMA()
      END
