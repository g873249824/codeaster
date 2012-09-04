      SUBROUTINE CESEXI(STOP,JCESD,JCESL,IMA,IPT,ISPT,ICMP,IAD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*1 STOP
      INTEGER JCESD,JCESL,IMA,IPT,ISPT,ICMP,IAD
C ------------------------------------------------------------------
C BUT : OBTENIR L'ADRESSE D'UNE CMP D'UN CHAM_ELEM_S
C ------------------------------------------------------------------
C     ARGUMENTS:
C STOP    IN  K1: COMPORTEMENT EN CAS D'ERREUR (CMP NON STOCKABLE) :
C                 'S' : ON S'ARRETE EN ERREUR FATALE
C                 'C' : ON CONTINUE ET ON REND IAD =0
C JCESD   IN  I : ADRESSE DE L'OBJET CHAM_ELEM_S.CESD
C JCESL   IN  I : ADRESSE DE L'OBJET CHAM_ELEM_S.CESL
C IMA     IN  I : NUMERO DE LA MAILLE
C IPT     IN  I : NUMERO DU POINT
C ISPT    IN  I : NUMERO DU SOUS-POINT
C ICMP    IN  I : NUMERO DE LA CMP
C IAD     OUT I : POSITION DE LA CMP DANS LES OBJETS .CESV ET .CESL

C  IAD=0  => LES ARGUMENTS IMA,IPT,ISPT OU ICMP SONT HORS BORNES
C  IAD<0  => LA POSITION DE LA CMP EST -IAD (MAIS LA CMP N'EST PAS
C             AFFECTEE POUR L'INSTANT (I.E. ZL(JCESL-1-IAD)=.FALSE.)
C  IAD>0  => LA POSITION DE LA CMP EST +IAD (LA CMP EST DEJA
C             AFFECTEE (I.E. ZL(JCESL-1+IAD)=.TRUE.)
      CHARACTER*24 VALK(4)
C     ------------------------------------------------------------------
      INTEGER NBMA,NPT,NSPT,NCMP,DECAL,IAD1
      CHARACTER*8 K8MAIL,K8PT,K8SPT,K8CMP
C     ------------------------------------------------------------------


      NBMA = ZI(JCESD-1+1)
      IF ((IMA.LE.0) .OR. (IMA.GT.NBMA)) GO TO 10

      NPT = ZI(JCESD-1+5+4* (IMA-1)+1)
      NSPT = ZI(JCESD-1+5+4* (IMA-1)+2)
      NCMP = ZI(JCESD-1+5+4* (IMA-1)+3)
      DECAL = ZI(JCESD-1+5+4* (IMA-1)+4)

      IF ((IPT.LE.0) .OR. (IPT.GT.NPT)) GO TO 10
      IF ((ISPT.LE.0) .OR. (ISPT.GT.NSPT)) GO TO 10
      IF ((ICMP.LE.0) .OR. (ICMP.GT.NCMP)) GO TO 10


      IAD1 = DECAL + (IPT-1)*NSPT*NCMP + (ISPT-1)*NCMP + ICMP

      IF (ZL(JCESL-1+IAD1)) THEN
        IAD = IAD1
      ELSE
        IAD = -IAD1
      END IF
      GO TO 60

   10 CONTINUE

      IF (STOP.EQ.'C') THEN
        IAD = 0

      ELSE IF (STOP.EQ.'S') THEN

        CALL CODENT(IMA,'D',K8MAIL)
        CALL CODENT(IPT,'D',K8PT)
        CALL CODENT(ISPT,'D',K8SPT)
        CALL CODENT(ICMP,'D',K8CMP)

        IF ((IMA.LE.0) .OR. (IMA.GT.NBMA)) GO TO 20
        IF ((IPT.LE.0) .OR. (IPT.GT.NPT)) GO TO 30
        IF ((ISPT.LE.0) .OR. (ISPT.GT.NSPT)) GO TO 40
        IF ((ICMP.LE.0) .OR. (ICMP.GT.NCMP)) GO TO 50


   20   CONTINUE
        CALL U2MESK('F','CALCULEL_68',1,K8MAIL)

   30   CONTINUE
         VALK(1) = K8PT
         VALK(2) = K8MAIL
         CALL U2MESK('F','CALCULEL_69', 2 ,VALK)

   40   CONTINUE
         VALK(1) = K8SPT
         VALK(2) = K8MAIL
         VALK(3) = K8PT
         CALL U2MESK('F','CALCULEL_70', 3 ,VALK)

   50   CONTINUE
         VALK(1) = K8CMP
         VALK(2) = K8MAIL
         VALK(3) = K8PT
         VALK(4) = K8SPT
         CALL U2MESK('F','CALCULEL_71', 4 ,VALK)


      ELSE
        CALL ASSERT(.FALSE.)
      END IF

   60 CONTINUE
      END
