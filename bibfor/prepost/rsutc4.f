      SUBROUTINE RSUTC4 ( RESU,MOTFAC,IOCC,DIMLIS,LISCH,NBCH,ACCENO )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER            IOCC, DIMLIS, NBCH
      LOGICAL            ACCENO
      CHARACTER*(*)      RESU, LISCH(*), MOTFAC

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C
C
C ======================================================================
C----------------------------------------------------------------------

C     TRAITER LES MOTS CLE :
C        /  TOUT_CHAM (='OUI' PAR DEFAUT)
C        /  NOM_CHAM = (NOCH1,NOCH2,...)
C     ET ETABLIR LA LISTE DES NOMS SYMBOLIQUES A TRAITER.

C IN  : RESU    : K19  : SD_RESULTAT
C IN  : MOTFAC  : K16  : NOM DU MOT CLE FACTEUR (OU ' ')
C IN  : IOCC    : I    : NUMERO D'OCCURRENCE DE MOTFAC (OU 1)
C IN  : DIMLIS  : I    : LONGUEUR DE LISCH
C OUT : LISCH   : L_K16: LISTE DES NOMS TROUVES
C OUT : NBCH    : I    : NOMBRE DE CHAMPS TROUVES (OU -NBCH SI
C                        SI LISCH EST TROP COURTE)
C OUT : ACCENO  : L : .TRUE. : L'UTILISATEUR A UTILISE NOM_CHAM
C                     .FALSE. : L'UTILISATEUR N'A PAS UTILISE NOM_CHAM
C                               (=> TOUT_CHAM PAR DEFAUT)

C----------------------------------------------------------------------


      CHARACTER*19 RESU2
      CHARACTER*1 K1BID
      CHARACTER*16 K16BID
      INTEGER NBNOSY,JL1,ISY,N2,JL2,IBID,K,KK,INDK16
      INTEGER      IARG

      RESU2 = RESU

C     --- ON REGARDE LA LISTE DES CHAMPS POSSIBLES POUR RESU:
      CALL JELIRA(RESU2//'.DESC','NOMUTI',NBNOSY,K1BID)
      CALL WKVECT('&&RSUTC4.LITOU','V V K16',NBNOSY,JL1)
      DO 10 ISY = 1,NBNOSY
        CALL JENUNO(JEXNUM(RESU2//'.DESC',ISY),ZK16(JL1-1+ISY))
   10 CONTINUE

      ACCENO = .FALSE.

      CALL GETVTX(MOTFAC,'NOM_CHAM',IOCC,IARG,0,K16BID,N2)
      N2 = -N2
      IF (N2.GT.0) THEN
        CALL WKVECT('&&RSUTC4.LICH','V V K16',N2,JL2)
        CALL GETVTX(MOTFAC,'NOM_CHAM',IOCC,IARG,N2,ZK16(JL2),IBID)
        DO 20,K = 1,N2
          KK = INDK16(ZK16(JL1),ZK16(JL2-1+K),1,NBNOSY)
          IF (KK.EQ.0) THEN
            CALL U2MESK('F','PREPOST4_77',1,ZK16(JL2-1+K))
          END IF
   20   CONTINUE
        NBCH = N2
        DO 30,K = 1,MIN(NBCH,DIMLIS)
          LISCH(K) = ZK16(JL2-1+K)
   30   CONTINUE
        ACCENO = .TRUE.

      ELSE
        NBCH = NBNOSY
        DO 40,K = 1,MIN(NBCH,DIMLIS)
          LISCH(K) = ZK16(JL1-1+K)
   40   CONTINUE
      END IF

      IF (NBCH.GT.DIMLIS) NBCH = -NBCH

      CALL JEDETR('&&RSUTC4.LITOU')
      CALL JEDETR('&&RSUTC4.LICH')

      END
