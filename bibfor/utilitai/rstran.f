      SUBROUTINE RSTRAN(INTERP,RESU,MOTCLE,IOCC,KINST,KRANG,NBINST,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) INTERP,MOTCLE
      CHARACTER*19 RESU,KINST,KRANG
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 14/10/2008   AUTEUR PELLET J.PELLET 
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

C     POUR INTERP = 'NON'
C        RECUPERATION DES INSTANTS ET DES NUMEROS DE RANGEMENT ASSOCIES
C        DANS LA STRUCTURE DE DONNEES "RESU"
C     POUR INTERP = 'LIN', 'LOG', ...
C        RECUPERATION DES INSTANTS UTILISATEURS
C     ------------------------------------------------------------------
C IN  : INTERP : TYPE D'INTERPOLATION
C IN  : RESU   : NOM DE LA STRUCTURE DE DONNEES
C IN  : MOTCLE : MOT CLE FACTEUR
C IN  : IOCC   : NUMERO D'OCCURENCE
C IN  : KINST  : NOM JEVEUX POUR STOCKER LES INSTANTS
C IN  : KRANG  : NOM JEVEUX POUR STOCKER LES NUMEROS DE RANGEMENT
C OUT : NBINST : NOMBRE D'INSTANTS TROUVES
C OUT : IER    : CODE RETOUR, = 0    : OK
C                             = 100  : PLUSIEURS CHAMPS TROUVES
C                             = 110  : AUCUN CHAMP TROUVE
C                             SINON  : NOOK
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      INTEGER VALI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      REAL*8 VALR
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
C     -----  FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*4 TYPE
      CHARACTER*8 K8B,CRIT
      CHARACTER*16 NOMCMD
      CHARACTER*19 LISTR
      CHARACTER*8 KVAL
      COMPLEX*16 CVAL
C     ------------------------------------------------------------------

      CALL JEMARQ()
      IER = 0
      NBINST = 0
      TYPE = 'R8  '
      CALL GETRES(K8B,K8B,NOMCMD)
      CALL GETVR8(MOTCLE,'PRECISION',IOCC,1,1,EPSI,N)
      CALL GETVTX(MOTCLE,'CRITERE',IOCC,1,1,CRIT,N)

C     -- CETTE ROUTINE SERT A DES SD != TRAN_GENE
      CALL JEEXIN(RESU//'.INST',IER1)
      IF (IER1.GT.0) THEN
        CALL JEVEUO(RESU//'.INST','L',LINST)
        CALL JELIRA(RESU//'.INST','LONMAX',NBI,K8B)
      ELSE
        CALL RSLIPA(RESU,'INST','&&RSTRAN.LIINST',LINST,NBI)
      ENDIF

      CALL JEEXIN(RESU//'.ORDR',IRET)
      IF (IRET.EQ.0) THEN
        CALL ASSERT(.FALSE.)
        CALL WKVECT('&&RSTRAN.ORDR','V V I',NBI,JORDR)
        DO 10 I = 1,NBI
          ZI(JORDR+I-1) = I
   10   CONTINUE
      ELSE
        CALL JEVEUO(RESU//'.ORDR','L',JORDR)
        CALL JELIRA(RESU//'.ORDR','LONUTI',NBI2,K8B)
        CALL ASSERT(NBI.EQ.NBI2)
      END IF

C     --- RECHERCHE A PARTIR D'UN NUMERO D'ORDRE ---

      CALL GETVIS(MOTCLE,'NUME_ORDRE',IOCC,1,0,IBID,NNO)
      IF (NNO.NE.0) THEN
        NBINST = -NNO
        CALL WKVECT(KRANG,'V V I',NBINST,JRANG)
        CALL WKVECT(KINST,'V V R8',NBINST,JINST)
        CALL WKVECT('&&RSTRAN.NUME','V V I',NBINST,JBID)
        CALL GETVIS(MOTCLE,'NUME_ORDRE',IOCC,1,NBINST,ZI(JBID),NNO)
        DO 40 I = 0,NBINST - 1
          DO 20 IORD = 0,NBI - 1
            IF (ZI(JBID+I).EQ.ZI(JORDR+IORD)) GO TO 30
   20     CONTINUE
          IER = IER + 110
          VALI = ZI(JBID+I)
          CALL U2MESG('A','UTILITAI8_17',0,' ',1,VALI,0,0.D0)
          GO TO 40
   30     CONTINUE
          ZI(JRANG+I) = IORD + 1
          ZR(JINST+I) = ZR(LINST+IORD)
   40   CONTINUE
        GO TO 100
      END IF

C     --- RECHERCHE A PARTIR D'UN INSTANT ---

      CALL GETVR8(MOTCLE,'INST',IOCC,1,0,RBID,LT)
      IF (LT.EQ.0) THEN
        CALL GETVID(MOTCLE,'LIST_INST',IOCC,1,1,LISTR,LLI)
        IF (LLI.NE.0) THEN
          CALL JEVEUO(LISTR//'.VALE','L',LACCR)
          CALL JELIRA(LISTR//'.VALE','LONMAX',NBINST,K8B)
        ELSE
          GO TO 80
        END IF
      ELSE
        NBINST = -LT
        CALL WKVECT('&&RSTRAN.INSTANTS','V V R',NBINST,LACCR)
        CALL GETVR8(MOTCLE,'INST',IOCC,1,NBINST,ZR(LACCR),L)
      END IF
      CALL WKVECT(KRANG,'V V I',NBINST,JRANG)
      CALL WKVECT(KINST,'V V R8',NBINST,JINST)
      DO 70 I = 0,NBINST - 1
        TUSR = ZR(LACCR+I)
        IF (INTERP(1:3).NE.'NON') THEN
          ZI(JRANG+I) = I + 1
          ZR(JINST+I) = TUSR
          GO TO 70
        END IF
        CALL RSINDI(TYPE,LINST,1,JORDR,IVAL,TUSR,KVAL,CVAL,EPSI,CRIT,
     &              NBI,NBTROU,NUTROU,1)
        IF (NBTROU.EQ.0) THEN
          IER = IER + 110
          VALR = TUSR
          CALL U2MESG('A','UTILITAI8_18',0,' ',0,0,1,VALR)
          GO TO 70
        ELSE IF (NBTROU.NE.1) THEN
          IER = IER + 100
          VALR = TUSR
          VALI = -NBTROU
          CALL U2MESG('F','UTILITAI8_19',0,' ',1,VALI,1,VALR)
          GO TO 70
        END IF
        DO 50 IORD = 0,NBI - 1
          IF (NUTROU.EQ.ZI(JORDR+IORD)) GO TO 60
   50   CONTINUE
   60   CONTINUE
        ZI(JRANG+I) = IORD + 1
        ZR(JINST+I) = ZR(LINST+IORD)
   70 CONTINUE
      GO TO 100

C     --- PAR DEFAUT ---

   80 CONTINUE
      CALL GETVTX(MOTCLE,'TOUT_INST',IOCC,1,1,K8B,NTO)
      CALL GETVTX(MOTCLE,'TOUT_ORDRE',IOCC,1,1,K8B,NTO)
      NBINST = NBI
      CALL WKVECT(KRANG,'V V I',NBINST,JRANG)
      CALL WKVECT(KINST,'V V R8',NBINST,JINST)
      DO 90 IORD = 0,NBINST - 1
        ZI(JRANG+IORD) = IORD + 1
        ZR(JINST+IORD) = ZR(LINST+IORD)
   90 CONTINUE

  100 CONTINUE
      CALL JEDETR('&&RSTRAN.ORDR')
      CALL JEDETR('&&RSTRAN.NUME')
      CALL JEDETR('&&RSTRAN.INSTANTS')
      CALL JEDETR('&&RSTRAN.LIINST')

      CALL JEDEMA()
      END
