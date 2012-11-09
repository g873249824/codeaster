      SUBROUTINE RIGMI1(NOMA,NOGR,IFREQ,NFREQ,IFMIS,RIGMA,RIGMA2,RIGTO)
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER      IFMIS
      INTEGER      IFREQ, NFREQ
      CHARACTER*8  NOMA, NOGR
      REAL*8       RIGMA(*), RIGMA2(*), RIGTO(*)
C      REAL*8       FREQ, RIGMA(*), RIGTO(*)
C     ------------------------------------------------------------------
C
      CHARACTER*8  K8B
      CHARACTER*8   NOMMAI
      CHARACTER*24 MLGNMA, MAGRMA, MANOMA, TABRIG

C
C-----------------------------------------------------------------------
      INTEGER I1 ,IDNO ,IFR ,II ,IJ ,IM ,IN
      INTEGER INOE ,IPARNO ,IRET ,IUNIFI ,JRIG ,LDGM ,LDNM
      INTEGER NB ,NBMODE ,NBNO ,NOEMAX
      REAL*8 R1 ,R2 ,R3
C-----------------------------------------------------------------------
      CALL JEMARQ()
      IFR = IUNIFI('RESULTAT')
C
      MAGRMA = NOMA//'.GROUPEMA'
      MANOMA = NOMA//'.CONNEX'
      MLGNMA = NOMA//'.NOMMAI'
      NOEMAX = 0
C

      CALL JELIRA(JEXNOM(MAGRMA,NOGR),'LONUTI',NB,K8B)
      CALL JEVEUO(JEXNOM(MAGRMA,NOGR),'L',LDGM)
      DO 22 IN = 0,NB-1
         CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
         INOE = ZI(LDNM)
         NOEMAX = MAX(NOEMAX,INOE)
 22   CONTINUE
C
C        TABLEAU DE PARTICIPATION DES NOEUDS DE L INTERFACE
C
      CALL WKVECT('&&RIGMI1.PARNO','V V I',NOEMAX,IPARNO)

      CALL JELIRA(JEXNOM(MAGRMA,NOGR),'LONUTI',NB,K8B)
      CALL JEVEUO(JEXNOM(MAGRMA,NOGR),'L',LDGM)
      DO 23 IN = 0,NB-1
         CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
         INOE = ZI(LDNM)
         ZI(IPARNO+INOE-1) = ZI(IPARNO+INOE-1) + 1
 23   CONTINUE
C
      NBNO = 0
      DO 25 IJ = 1, NOEMAX
         IF (ZI(IPARNO+IJ-1).EQ.0) GOTO 25
         NBNO = NBNO + 1
  25  CONTINUE
C
      CALL WKVECT('&&RIGMI1.NOEUD','V V I',NBNO,IDNO)
      II = 0
      DO 26 IJ = 1, NOEMAX
         IF (ZI(IPARNO+IJ-1).EQ.0) GOTO 26
         II = II + 1
         ZI(IDNO+II-1) = IJ
  26  CONTINUE
C
C     LECTURE DES RIGIDITES ELEMENTAIRES
C
      TABRIG = '&&ACEARM.RIGM'
      CALL JEEXIN(TABRIG,IRET)
      IF (IRET.EQ.0) CALL IRMIIM(IFMIS,IFREQ,NFREQ,NBNO,TABRIG)
      CALL JEVEUO(TABRIG,'L',JRIG)
      NBMODE = 3*NBNO
      IM = 0
      I1 = 0
C      CALL JELIRA(JEXNOM(MAGRMA,NOGR),'LONUTI',NB,K8B)
C      CALL JEVEUO(JEXNOM(MAGRMA,NOGR),'L',LDGM)
      DO 33 IN = 0,NB-1
         IM = ZI(LDGM+IN)
         CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
         DO 37 II = 1, NBNO
            IF (ZI(LDNM).EQ.ZI(IDNO+II-1)) I1 = II
 37      CONTINUE
         RIGMA(3*IN+1) = ZR(JRIG+(3*I1-3)*NBMODE+3*I1-3)
         RIGMA(3*IN+2) = ZR(JRIG+(3*I1-2)*NBMODE+3*I1-2)
         RIGMA(3*IN+3) = ZR(JRIG+(3*I1-1)*NBMODE+3*I1-1)
 33   CONTINUE
C
      DO 34 IN = 0,NB-1
         IM = ZI(LDGM+IN)
         CALL JEVEUO(JEXNUM(MANOMA,ZI(LDGM+IN)),'L',LDNM)
         DO 38 II = 1, NBNO
            IF (ZI(LDNM).EQ.ZI(IDNO+II-1)) I1 = II
 38      CONTINUE
         R1 = RIGMA(3*IN+1)
         R2 = RIGMA(3*IN+2)
         R3 = RIGMA(3*IN+3)

         RIGTO(3*(IM-1)+1) = R1 + RIGTO(3*(IM-1)+1)
         RIGTO(3*(IM-1)+2) = R2 + RIGTO(3*(IM-1)+2)
         RIGTO(3*(IM-1)+3) = R3 + RIGTO(3*(IM-1)+3)

         R1 = RIGTO(3*(IM-1)+1) + RIGMA2(3*(I1-1)+1)
         R2 = RIGTO(3*(IM-1)+2) + RIGMA2(3*(I1-1)+2)
         R3 = RIGTO(3*(IM-1)+3) + RIGMA2(3*(I1-1)+3)

         RIGMA(3*IN+1) = R1
         RIGMA(3*IN+2) = R2
         RIGMA(3*IN+3) = R3
         CALL JENUNO(JEXNUM(MLGNMA,IM),NOMMAI)
         WRITE(IFR,1000) NOMMAI,R1,R2,R3
 34   CONTINUE
C
 1000 FORMAT(2X,'_F ( MAILLE=''',A8,''',',1X,'CARA= ''K_T_D_N'' , ',
     +      /7X,'VALE=(',1X,3(1X,1PE12.5,','),1X,'),',
     +      /'   ),')

      CALL JEDETR('&&RIGMI1.PARNO')
      CALL JEDETR('&&RIGMI1.NOEUD')
C
      CALL JEDEMA()
      END
