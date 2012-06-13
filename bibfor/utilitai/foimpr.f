      SUBROUTINE FOIMPR(NOMF,IMPR,IUL,IND,FONINS)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      CHARACTER*(*)     NOMF,             FONINS
      INTEGER                IMPR,IUL,IND
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C     ROUTINE D'IMPRESSION D'UNE FONCTION SUR UN FICHIER
C     ----------------------------------------------------------------
C
      CHARACTER*8   K8B
      CHARACTER*19  NOMFON, NOMF1, LISTR
      CHARACTER*24  PROL, VALE, PARA
      CHARACTER*24  NOMPAR, NOMRES, TITR
      INTEGER       NBPU
      CHARACTER*8   NOMPU
C     ------------------------------------------------------------------
      CALL JEMARQ()
      IF ( IMPR .LE. 0) GOTO 9999
      IF ( IUL .LE. 0 ) THEN
         CALL U2MESS('A','UTILITAI2_7')
         GOTO 9999
      ENDIF
      LISTR = FONINS
      NOMF1 = '&&FOIMPR'
C
C     --- NOM DE LA FONCTION A EDITER ---
      NOMFON = NOMF
      PROL   = NOMFON//'.PROL'
      VALE   = NOMFON//'.VALE'
      PARA   = NOMFON//'.PARA'
      TITR   = NOMFON//'.TITR'
C
C     --- IMPRESSION DU TITRE ---
      WRITE(IUL,'(/,80(''-''))')
      CALL JEEXIN(TITR,IRET)
      IF (IRET .NE. 0 ) THEN
         CALL JEVEUO(TITR,'L',LTITR)
         CALL JELIRA(TITR,'LONMAX',NBTITR,K8B)
         DO 10 I= 1, NBTITR
            WRITE(IUL,*) ZK80(LTITR+I-1)
  10     CONTINUE
      ENDIF
C
C     --- CAS D'UNE FONCTION "FORMULE" ---
      CALL JEEXIN(NOMFON//'.NOVA',IRET)
      IF ( IRET.NE.0 .AND. IND.NE.0 ) THEN
         CALL JEVEUO(NOMFON//'.NOVA','L',LNOVA)
         CALL JELIRA(NOMFON//'.NOVA','LONUTI',NBNOVA,K8B)
         IF ( NBNOVA .NE. 1 ) THEN
         CALL U2MESS('A','UTILITAI2_8')
            GOTO 9999
         ENDIF
         CALL JEVEUO(LISTR//'.VALE','L',JVAL)
         CALL JELIRA(LISTR//'.VALE','LONUTI',NBVAL,K8B)
         NBV = 2 * NBVAL
         CALL WKVECT(NOMF1//'.VALE','V V R8',NBV,LVAL1)
         LFON1 = LVAL1 + NBVAL
         DO 100 IVAL = 0, NBVAL-1
            ZR(LVAL1+IVAL) = ZR(JVAL+IVAL)
            CALL FOINTE('F ',NOMFON,NBNOVA,ZK8(LNOVA),ZR(LVAL1+IVAL),
     &                                           ZR(LFON1+IVAL),IRET)
 100     CONTINUE
C
         CALL ASSERT(LXLGUT(NOMF1).LE.24)
         CALL WKVECT(NOMF1//'.PROL','V V K24',6,LPROL1)
         ZK24(LPROL1)   = 'FONCTION'
         ZK24(LPROL1+1) = 'LIN LIN '
         ZK24(LPROL1+2) = ZK8(LNOVA)
         ZK24(LPROL1+3) = 'TOUTRESU'
         ZK24(LPROL1+4) = 'EE'
         ZK24(LPROL1+5) = NOMF1
C
         CALL FOEC1F(IUL,NOMFON,ZK24(LPROL1),NBVAL,'RIEN')
         IF (IMPR.GE.2) THEN
            IDEB = 1
            IFIN = MIN( 10 ,NBVAL )
            IF (IMPR.GE.3)  IFIN = NBVAL
            NOMPAR = ZK24(LPROL1+2)
            NOMRES = ZK24(LPROL1+3)
            CALL FOEC2F(IUL,ZR(LVAL1),NBVAL,IDEB,IFIN,NOMPAR,NOMRES)
         ENDIF
         CALL JEDETR(NOMF1//'.PROL')
         CALL JEDETR(NOMF1//'.VALE')
         GOTO 9999
      ENDIF
C
C     --- INFORMATIONS COMPLEMENTAIRES POUR L'EDITION ---
      CALL JEVEUO(PROL,'L',LPROL)
      NOMPAR = ZK24(LPROL+2)
      NOMRES = ZK24(LPROL+3)
C
      IF (ZK24(LPROL).EQ.'CONSTANT'.OR.ZK24(LPROL).EQ.'FONCTION') THEN
C
C        --- NOMBRE DE VALEURS DE LA FONCTION ---
         IF (IND.NE.0) THEN
            CALL JELIRA(LISTR//'.VALE','LONUTI',NBVAL,K8B)
         ELSE
            CALL JELIRA(VALE,'LONUTI',NBVAL,K8B)
            NBVAL= NBVAL/2
         ENDIF
C
         CALL FOEC1F(IUL,NOMFON,ZK24(LPROL),NBVAL,'RIEN')
         IF (IMPR.GE.2) THEN
            CALL JEVEUO(VALE,'L',LVAL)
            IF (IND.NE.0) THEN
               CALL JEVEUO(LISTR//'.VALE','L',JVAL)
               NBV2 = 2 * NBVAL
               CALL WKVECT(NOMF1//'.VALE','V V R8',NBV2,LVAL)
               LFON = LVAL + NBVAL
               DO 200 IVAL = 0, NBVAL-1
                  ZR(LVAL+IVAL) = ZR(JVAL+IVAL)
                  CALL FOINTE('F ',NOMFON,1,NOMPAR,ZR(LVAL+IVAL),
     &                                        ZR(LFON+IVAL),IRET)
 200           CONTINUE
            ENDIF
            IDEB = 1
            IFIN = MIN( 10 ,NBVAL )
            IF (IMPR.GE.3)  IFIN = NBVAL
            CALL FOEC2F(IUL,ZR(LVAL),NBVAL,IDEB,IFIN,NOMPAR,NOMRES)
            IF (IND.NE.0) THEN
               CALL JEDETR(NOMF1//'.PROL')
               CALL JEDETR(NOMF1//'.VALE')
            ENDIF
         ENDIF
C
      ELSEIF ( ZK24(LPROL) .EQ. 'NAPPE   ' ) THEN
C
         PARA = NOMFON//'.PARA'
         CALL JELIRA(PARA,'LONMAX',NBFONC,K8B)
         CALL FOEC1N(IUL,NOMFON,ZK24(LPROL),NBFONC,'RIEN')
         IF (IMPR.GE.2) THEN
            CALL JEVEUO(PARA,'L',LVAL)
            CALL ASSERT(IND.EQ.0)
            CALL FOEC2N(IUL,ZK24(LPROL),ZR(LVAL),VALE,NBFONC,IMPR)
         ENDIF
C
      ELSEIF (ZK24(LPROL).EQ.'FONCT_C ' ) THEN
C
         NBPU = 1
         NOMPU = ' '
         CALL JELIRA(VALE,'LONUTI',NBVAL,K8B)
         NBVAL= NBVAL/3
         CALL FOEC1C(IUL,NOMFON,ZK24(LPROL),NBVAL,'RIEN')
         IF (IMPR.GE.2) THEN
            CALL JEVEUO(VALE,'L',LVAL)
            IF (IND.NE.0) THEN
               CALL JEVEUO(LISTR//'.VALE','L',JVAL)
               CALL JELIRA(LISTR//'.VALE','LONUTI',NBVAL,K8B)
               NBV2 = 3 * NBVAL
               CALL WKVECT(NOMF1//'.VALE','V V R8',NBV2,LVAL)
               LFON = LVAL + NBVAL
               II = 0
               DO 300 IVAL = 0, NBVAL-1
                  ZR(LVAL+IVAL) = ZR(JVAL+IVAL)
                  CALL FOINTC('F',NOMFON,NBPU,NOMPU,ZR(LVAL+IVAL),
     &                        RESURE,RESUIM,IRET)
                  ZR(LFON+II) = RESURE
                  II = II + 1
                  ZR(LFON+II) = RESUIM
                  II = II + 1
 300           CONTINUE
            ENDIF
            IDEB = 1
            IFIN = MIN( 10 ,NBVAL )
            IF (IMPR.GE.3)  IFIN = NBVAL
            CALL FOEC2C(IUL,ZR(LVAL),NBVAL,IDEB,IFIN,NOMPAR,NOMRES)
            IF (IND.NE.0) THEN
               CALL JEDETR(NOMF1//'.PROL')
               CALL JEDETR(NOMF1//'.VALE')
            ENDIF
          ENDIF
C
      ELSEIF (ZK24(LPROL).EQ.'INTERPRE' ) THEN
         CALL U2MESK('A','UTILITAI2_10',1,ZK24(LPROL))
C
      ELSE
         CALL U2MESK('A','UTILITAI2_11',1,ZK24(LPROL))
C
      ENDIF
 9999 CONTINUE
      CALL JEDEMA()
      END
