      SUBROUTINE OP0194()
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 10/09/2012   AUTEUR SELLENET N.SELLENET 
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
C ----------------------------------------------------------------------
C
C      OPERATEUR :     CALC_META
C
C ----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
C
      CHARACTER*6 NOMPRO
      PARAMETER(NOMPRO='OP0194')
C
      INTEGER      IBID, IRET, N1, N2, N3, NUM, NUMPHA
      INTEGER      NBORDT, NBTROU, IER,JOPT,NBOPT,NB,NCHAR,IOPT
      INTEGER      NBORDR,JORDR,NUORD,VALI,IARG
C
      REAL*8       INST, PREC
      REAL*8       VALR,R8B
C
      COMPLEX*16   C16B
      CHARACTER*4  CTYP
      CHARACTER*8  K8B, CRIT, TEMPER, MODELE,CARA
      CHARACTER*16 TYSD, OPTION
      CHARACTER*19 KORDRE,KCHA
      CHARACTER*24 COMPOR, CHMETA, PHASIN, MATE, K24BID
      CHARACTER*24 VALK
      CHARACTER*24 LESOPT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      LESOPT='&&'//NOMPRO//'.LES_OPTION'
      KORDRE='&&'//NOMPRO//'.NUME_ORDRE'
      KCHA = '&&'//NOMPRO//'.CHARGES   '
C
      CALL GETVID(' ','RESULTAT',1,IARG,1,TEMPER,N1)
      CALL GETTCO(TEMPER,TYSD)

      CALL RSORAC(TEMPER,'LONUTI',IBID,R8B,K8B,C16B,R8B,K8B,NBORDR,1,
     &            IBID)
      CALL WKVECT(KORDRE,'V V I',NBORDR,JORDR)
      CALL RSORAC(TEMPER,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &            ZI(JORDR),NBORDR,IBID)
      NUORD = ZI(JORDR)

      CALL MEDOM1(MODELE,MATE,CARA,KCHA,NCHAR,CTYP,TEMPER,NUORD)

      CALL GETVTX ( ' ', 'OPTION', 1,IARG,0, K8B, NB )
      NBOPT = -NB
      CALL WKVECT ( LESOPT, 'V V K16', NBOPT, JOPT )
      CALL GETVTX (' ', 'OPTION'  , 1,IARG, NBOPT, ZK16(JOPT), NB)
      CALL MODOPT(TEMPER,MODELE,LESOPT,NBOPT)
      CALL JEVEUO(LESOPT,'L',JOPT)

      DO 660 IOPT=1,NBOPT
C
        OPTION=ZK16(JOPT+IOPT-1)

        IF (OPTION.EQ.'META_ELNO') THEN

        CALL MTDORC(MODELE,COMPOR,K24BID)

C ----- ETAT INITIAL
        NUMPHA = 0
        CALL GETVID('ETAT_INIT','META_INIT_ELNO',1,IARG,1,CHMETA,N3)
        IF (N3.GT.0) THEN
          PHASIN = '&&SMEVOL_ZINIT'
          CALL CHPVER('F',CHMETA(1:19),'CART','VAR2_R',IER)
          CALL COPISD('CHAMP_GD','V',CHMETA,PHASIN(1:19))
        ELSE
          CALL GETVID('ETAT_INIT','EVOL_THER',1,IARG,1,TEMPER,N1)
          CALL GETVIS('ETAT_INIT','NUME_INIT',1,IARG,1,NUM,N2)
          IF (N2.EQ.0) THEN
            CALL GETVR8 ( 'ETAT_INIT', 'INST_INIT', 1,IARG,1, INST, N3)
            CALL GETVR8 ( 'ETAT_INIT', 'PRECISION', 1,IARG,1, PREC, N3)
            CALL GETVTX ( 'ETAT_INIT', 'CRITERE'  , 1,IARG,1, CRIT, N3)
            NBORDT = 1
            CALL RSORAC ( TEMPER, 'INST', IBID, INST, K8B, C16B, PREC,
     &                    CRIT, NUM, NBORDT, NBTROU )
            IF (NBTROU.EQ.0) THEN
              VALK = TEMPER
              VALR = INST
              CALL U2MESG('F', 'UTILITAI6_51',1,VALK,0,0,1,VALR)
            ELSE IF (NBTROU.GT.1) THEN
              VALK = TEMPER
              VALR = INST
              VALI = NBTROU
              CALL U2MESG('F', 'UTILITAI6_52',1,VALK,1,VALI,1,VALR)
            ENDIF
          ENDIF
          CALL RSEXCH ('F',TEMPER, 'META_ELNO', NUM, PHASIN, IRET )
          NUMPHA = NUM
        ENDIF

        CALL SMEVOL(TEMPER(1:8),MODELE,MATE,COMPOR,OPTION,PHASIN,NUMPHA)

        CALL JEDETC('G','&&NMDORC',1)

      ELSE
C         PASSAGE CALC_CHAMP
        CALL CALCOP(OPTION,LESOPT,TEMPER,TEMPER,KORDRE,NBORDR,
     &              KCHA,NCHAR,CTYP,TYSD,IRET)
        IF (IRET.EQ.0)GOTO 660

      ENDIF

  660 CONTINUE

      CALL JEDEMA()
      END
