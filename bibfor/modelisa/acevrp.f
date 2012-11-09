      SUBROUTINE ACEVRP(NBOCC,NOMA,NOEMAX,NOEMAF,IER)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER      NBOCC,NOEMAX,IER
      CHARACTER*8  NOMA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C     AFFE_CARA_ELEM
C     VERIFICATION DES DIMENSIONS POUR LES RAIDEURS REPARTIES
C ----------------------------------------------------------------------
C IN  : NBOCC  : NOMBRE D'OCCURENCE
C IN  : NOMA   : NOM DU MAILLAGE
C OUT : NOEMAX : NOMBRE TOTAL DE NOEUDS MAX
C ----------------------------------------------------------------------
      CHARACTER*24 MAGRMA, MANOMA
      CHARACTER*8  K8B
      INTEGER      IARG
C-----------------------------------------------------------------------
      INTEGER I ,IDGM ,IDNO2 ,II ,IJ ,IN ,INOE
      INTEGER IOC ,LDGM ,LDNM ,NB ,NBGR ,NBGRMX ,NBV
      INTEGER NM ,NN ,NOEMA2 ,NOEMAF
C-----------------------------------------------------------------------
      CALL JEMARQ()
      NBGRMX = 0
      MAGRMA = NOMA//'.GROUPEMA'
      MANOMA = NOMA//'.CONNEX'
      DO 10 IOC = 1,NBOCC
C        --- ON RECUPERE UNE LISTE DE GROUP_MA ---
       CALL GETVEM(NOMA,'GROUP_MA','RIGI_PARASOL','GROUP_MA',
     +                IOC,IARG,0,K8B,NBGR)
       NBGR = -NBGR
       NBGRMX = MAX(NBGRMX,NBGR)
 10   CONTINUE
      CALL WKVECT('&&ACEVRP.GROUP_MA','V V K8',NBGRMX,IDGM)
      NOEMAX = 0
      NOEMAF = 0
      DO 11 IOC = 1,NBOCC
       NOEMA2 = 0
       CALL GETVEM(NOMA,'GROUP_MA','RIGI_PARASOL','GROUP_MA',
     +                IOC,IARG,0,K8B,NBGR)
       NBGR = -NBGR
       CALL GETVEM(NOMA,'GROUP_MA','RIGI_PARASOL','GROUP_MA',
     +                IOC,IARG,NBGR,ZK8(IDGM),NBV)
C
C        --- ON ECLATE LES GROUP_MA ---
       DO 20 I = 1,NBGR
         CALL JELIRA(JEXNOM(MAGRMA,ZK8(IDGM+I-1)),'LONUTI',NB,K8B)
         CALL JEVEUO(JEXNOM(MAGRMA,ZK8(IDGM+I-1)),'L',LDGM)
         DO 22 IN = 0,NB-1
           CALL JELIRA(JEXNUM(MANOMA,ZI(LDGM+IN)),'LONMAX',NM,K8B)
           CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
           DO 24 NN = 1, NM
              INOE = ZI(LDNM+NN-1)
              NOEMA2 = MAX(NOEMA2,INOE)
 24        CONTINUE
 22      CONTINUE
 20    CONTINUE
       NOEMAF = MAX(NOEMAF,NOEMA2)
       CALL WKVECT('&&ACEVRP.PARNO2','V V I',NOEMA2,IDNO2)
       DO 41 I = 1,NBGR
         CALL JELIRA(JEXNOM(MAGRMA,ZK8(IDGM+I-1)),'LONUTI',NB,K8B)
         CALL JEVEUO(JEXNOM(MAGRMA,ZK8(IDGM+I-1)),'L',LDGM)
         DO 43 IN = 0,NB-1
           CALL JELIRA(JEXNUM(MANOMA,ZI(LDGM+IN)),'LONMAX',NM,K8B)
           CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
           DO 45 NN = 1, NM
              INOE = ZI(LDNM+NN-1)
              ZI(IDNO2+INOE-1) = ZI(IDNO2+INOE-1) + 1
 45        CONTINUE
 43      CONTINUE
 41    CONTINUE
       II = 0
       DO 51 IJ = 1, NOEMA2
         IF (ZI(IDNO2+IJ-1).EQ.0) GOTO 51
         II = II + 1
 51    CONTINUE
       NOEMA2 = II
       NOEMAX = NOEMAX + NOEMA2
       CALL JEDETR('&&ACEVRP.PARNO2')
 11   CONTINUE
      CALL JEDETR('&&ACEVRP.GROUP_MA')
C
      CALL JEDEMA()
      END
