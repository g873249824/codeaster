      SUBROUTINE AIDCON ( NBOCC, IMPR, IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             NBOCC, IMPR, IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
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
C     ECRITURE DE CE QUI EST RELATIF AUX CONCEPTS CREER OU A CREER
C     ------------------------------------------------------------------
C IN  NBOCC : IS : NOMBRE D'OCCURRENCE ...
C IN  IMPR  : IS : UNITE LOGIQUE D'ECRITURE
C VAR IER   : IS : CODE RETOUR ( ON L'INCREMENTE SANS L'INITIALISER)
C     ------------------------------------------------------------------
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8   CODE
      CHARACTER*24  CNOM  , DESCRI
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      NBVAL = 10
      CNOM = '&&AIDCON'//'.LISTE_CONCEPT '
      CALL WKVECT( CNOM, 'V V K16', NBVAL, LLIST)
      DO 100 IOCC = 1, NBOCC
         CALL GETVTX('CONCEPT','NOM',IOCC,1,0,ZK16(LLIST),NBCMD)
         IF ( -NBCMD .GT. NBVAL ) THEN
            CALL JEDETR( CNOM )
            NBVAL = -NBCMD
            CALL WKVECT( CNOM, 'V V K16', NBVAL, LLIST)
         ENDIF
         CALL GETVTX('CONCEPT','NOM',IOCC,1,NBVAL,ZK16(LLIST),NBCMD)
         DO 10 I = 0, NBCMD-1
            IF ( ZK16(LLIST+I).EQ.'*' .AND. NBCMD.NE.1) THEN
               CALL U2MESS('I','UTILITAI_3')
            ENDIF
  10     CONTINUE
C
         CALL GETVTX('CONCEPT','OPTION',IOCC,1,1,DESCRI,L)
         IF ( ZK16(LLIST) .EQ. '*' ) THEN
            IF ( DESCRI .EQ. 'TOUT_TYPE' ) THEN
               CALL GCECCO('AIDE',IMPR,CODE,' ')
            ELSEIF ( DESCRI .EQ. 'CREER' ) THEN
               CALL GCECCO('AIDE',IMPR,CODE,' ')
            ELSEIF ( DESCRI .EQ. 'A_CREER' ) THEN
               CALL GCECCO('AIDE',IMPR,CODE,' ')
            ELSE
               CALL U2MESK('I','UTILITAI_4',1,DESCRI(1:8))
            ENDIF
         ELSE
            LDEB = LLIST
            LFIN = LLIST+NBCMD-1
            DO 20 ICMD = LDEB, LFIN
               IF ( DESCRI .EQ. 'TOUT_TYPE' ) THEN
                  IF (ZK80(ICMD)(1:8).NE.' ')
     &               CALL GCECCO('AIDE',IMPR,CODE,ZK80(ICMD)(1:8))
               ELSE
                  CALL U2MESK('I','UTILITAI_4',1,DESCRI(1:8))
                  GOTO 100
               ENDIF
  20        CONTINUE
         ENDIF
 100  CONTINUE
      CALL JEDETR( CNOM )
      CALL JEDEMA()
      END
