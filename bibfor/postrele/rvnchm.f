      SUBROUTINE RVNCHM(MAILLA,TM,NBM,NUMND,NOMND)
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*24 NUMND,NOMND
      CHARACTER*8  MAILLA
      INTEGER      TM(*),NBM
C
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C     ------------------------------------------------------------------
C     ORIENTATION D' UN CHEMIN DE MAILLE 1D
C     ------------------------------------------------------------------
C IN  MAILLA : K : NOM DU MAILLAGE
C IN  TM     : I : TABLE DES MAILLES DU CHEMIN
C IN  NBM    : I : NBR DE MAILLES DU CHEMIN
C OUT NUMND  : K :NOM DE LA TABLE DES NUM DE NOEUDS (ORDRE DE PARCOURS)
C OUT NOMND  : K :NOM DE LA TABLE DES NOM DE NOEUDS (ORDRE DE PARCOURS)
C     ------------------------------------------------------------------
C
C
      CHARACTER*24 NLNBNM
      CHARACTER*15 CONNEX,NREPND
      CHARACTER*16 TYPMAI
      CHARACTER*8  KTYPM
      INTEGER      ACONEC,IM,M,N1,N2,NDER,NBPT,NBN
      INTEGER      ANBNM,PT,ANUMND,ANOMND,ATYPM,IATYMA
C
C====================== CORPS DE LA ROUTINE ===========================
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CONNEX = MAILLA//'.CONNEX'
      NREPND = MAILLA//'.NOMNOE'
      TYPMAI = MAILLA//'.TYPMAIL'
      NLNBNM = '&&RVNCHM.NB.NOEUD.MAILLE'
      CALL WKVECT(NLNBNM,'V V I',NBM,ANBNM)
      NBPT = 1
      PT   = 1
      DO 200, IM = 1, NBM, 1
         CALL JEVEUO(TYPMAI,'L',IATYMA)
         ATYPM=IATYMA-1+TM(IM)
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(ATYPM)),KTYPM)
         IF ( KTYPM .EQ. 'SEG2' ) THEN
            NBN = 2
         ELSE
            NBN = 3
         ENDIF
         NBPT             = NBPT + NBN -1
         ZI(ANBNM + IM-1) = NBN
200   CONTINUE
      CALL WKVECT(NUMND,'V V I',NBPT,ANUMND)
      CALL WKVECT(NOMND,'V V K8',NBPT,ANOMND)
      CALL JEVEUO(JEXNUM(CONNEX,TM(1)),'L',ACONEC)
      IF ( NBM .LE. 0 ) THEN
         CALL U2MESS('F','POSTRELE_24')
      ELSE IF ( NBM .EQ. 1 ) THEN
         NDER = ZI(ACONEC + 1-1)
      ELSE
         N1 = ZI(ACONEC + 1-1)
         N2 = ZI(ACONEC + 2-1)
         CALL JEVEUO(JEXNUM(CONNEX,TM(2)),'L',ACONEC)
         IF ( (N1 .EQ. ZI(ACONEC)) .OR. (N1 .EQ. ZI(ACONEC+1))) THEN
            NDER = N2
         ELSE IF ( (N2.EQ.ZI(ACONEC)).OR.(N2.EQ.ZI(ACONEC+1))) THEN
            NDER = N1
         ELSE
            CALL U2MESS('F','POSTRELE_25')
         ENDIF
      ENDIF
      ZI(ANUMND + PT-1) = NDER
      CALL JENUNO(JEXNUM(NREPND,NDER),ZK8(ANOMND + PT-1))
      PT = PT + 1
      DO 100, IM = 1, NBM, 1
         M = TM(IM)
         CALL JEVEUO(JEXNUM(CONNEX,M),'L',ACONEC)
         N1 = ZI(ACONEC + 1-1)
         N2 = ZI(ACONEC + 2-1)
         IF ( ZI(ANBNM + IM-1) .EQ. 3 ) THEN
            ZI(ANUMND + PT-1) = ZI(ACONEC + 3-1)
            CALL JENUNO(JEXNUM(NREPND,ZI(ACONEC+3-1)),ZK8(ANOMND+PT-1))
            PT = PT + 1
         ENDIF
         IF ( N1 .EQ. NDER ) THEN
            NDER = N2
         ELSE
            NDER = N1
         ENDIF
         ZI(ANUMND + PT-1) = NDER
         CALL JENUNO(JEXNUM(NREPND,NDER),ZK8(ANOMND + PT-1))
         PT = PT + 1
100   CONTINUE
      CALL JEDETR(NLNBNM)
      CALL JEDEMA()
      END
