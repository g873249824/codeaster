      SUBROUTINE EF0415(NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/12/2012   AUTEUR DELMAS J.DELMAS 
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
C     CALCUL DE EFGE_ELNO
C     ------------------------------------------------------------------
C TOLE CRP_20
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 NOMTE

C-----------------------------------------------------------------------
      INTEGER I,IC,ICHG,ICOMP,ICOMPO,II
      INTEGER INTE,INTSN,INTSR,IRET,ISOM
      INTEGER J,JCARA,JEFFG,JGEOM,JJ
      INTEGER K,K1,KPGS,L
      INTEGER LZI,LZR,NBCOU,NCMP
      INTEGER NPGE,NPGT
      INTEGER NSO
      REAL*8 HIC,S,ZERO,ZIC,ZMIN
C-----------------------------------------------------------------------
      PARAMETER(NPGE=3)
      PARAMETER(NPGT=10)
      INTEGER ICOU,JMAT,JNBSPI
      INTEGER NB1,NB2,NPGSR,NPGSN
      REAL*8 VECTA(9,2,3),VECTN(9,3),VECTPT(9,2,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 EPAIS
      REAL*8 MATEVN(2,2,NPGT),MATEVG(2,2,NPGT)
      REAL*8 SIGM(6,270),SIGMA(6,120),EFFGC(8,9),EFFGT(8,9)
      REAL*8 PK2(6,270)
      LOGICAL LGREEN

      ZERO=0.0D0
      LGREEN=.FALSE.
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESI',' ',LZI)
      NB1=ZI(LZI-1+1)
      NB2=ZI(LZI-1+2)
      NPGSR=ZI(LZI-1+3)
      NPGSN=ZI(LZI-1+4)
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ',LZR)
      IF (NOMTE.EQ.'MEC3QU9H') THEN
        NSO=4
      ELSEIF (NOMTE.EQ.'MEC3TR7H') THEN
        NSO=3
      ENDIF

      CALL JEVECH('PGEOMER','L',JGEOM)
      CALL JEVECH('PCACOQU','L',JCARA)

C
      CALL COSIRO(NOMTE,'PCONTRR','UI','G',ICHG,'S')

      CALL TECACH('ONN','PCOMPOR',1,ICOMPO,IRET)

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU=ZI(JNBSPI-1+1)

      IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_12')
      IF (NBCOU.GT.10) CALL U2MESS('F','ELEMENTS_13')
      EPAIS=ZR(JCARA)
      ZMIN=-EPAIS/2.D0
      HIC=EPAIS/NBCOU
      CALL VECTAN(NB1,NB2,ZR(JGEOM),ZR(LZR),VECTA,VECTN,VECTPT)
      KPGS=0
      DO 40 ICOU=1,NBCOU
        DO 30 INTE=1,NPGE
          IF (INTE.EQ.1) THEN
            ZIC=ZMIN+(ICOU-1)*HIC
          ELSEIF (INTE.EQ.2) THEN
            ZIC=ZMIN+HIC/2.D0+(ICOU-1)*HIC
          ELSE
            ZIC=ZMIN+HIC+(ICOU-1)*HIC
          ENDIF

          DO 20 INTSN=1,NPGSN
            KPGS=KPGS+1
            K1=6*((INTSN-1)*NPGE*NBCOU+(ICOU-1)*NPGE+INTE-1)
            DO 10 I=1,6
              SIGM(I,KPGS)=ZR(ICHG-1+K1+I)
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE
      NCMP=6
      IF (LGREEN) THEN
C
C ---   AFFECTATION DES CONTRAINTES DE PIOLA-KIRCHHOFF DE
C ---   SECONDE ESPECE :
C       --------------
        DO 60 I=1,6
          DO 50 J=1,KPGS
            PK2(I,J)=SIGM(I,J)
   50     CONTINUE
   60   CONTINUE
C
C ---   TRANSFORMATION DES CONTRAINTES DE PIOLA-KIRCHHOFF DE
C ---   SECONDE ESPECE PK2 EN CONTRAINTES DE CAUCHY :
C       -------------------------------------------
        CALL PK2CAU(NOMTE,NCMP,PK2,SIGM)
      ENDIF
C
C --- DETERMINATION DES REPERES  LOCAUX DE L'ELEMENT AUX POINTS
C --- D'INTEGRATION ET STOCKAGE DE CES REPERES DANS LE VECTEUR .DESR
C     --------------------------------------------------------------
      K=0
      DO 90 INTSR=1,NPGSR
        CALL VECTGT(0,NB1,ZR(JGEOM),ZERO,INTSR,ZR(LZR),EPAIS,VECTN,
     &              VECTG,VECTT)

        DO 80 J=1,3
          DO 70 I=1,3
            K=K+1
            ZR(LZR+2000+K-1)=VECTT(I,J)
   70     CONTINUE
   80   CONTINUE
   90 CONTINUE

C--- EXTRAPOLATION VERS LES NOEUDS SOMMETS
C
      CALL JEVETE('&INEL.'//NOMTE//'.B',' ',JMAT)

      DO 130 ICOU=1,NBCOU
        DO 120 IC=1,NCMP
          DO 110 I=1,NPGE*NSO
            L=NPGE*NPGSN*(I-1)
            S=0.D0
            DO 100 J=1,NPGE*NPGSN
              JJ=(ICOU-1)*NPGE*NPGSN+J
              S=S+ZR(JMAT-1+L+J)*SIGM(IC,JJ)
  100       CONTINUE
            II=(ICOU-1)*NPGE*NSO+I
            SIGMA(IC,II)=S
  110     CONTINUE
  120   CONTINUE
  130 CONTINUE

C --- DETERMINATION DES MATRICE DE PASSAGE DES REPERES INTRINSEQUES
C --- AUX NOEUDS ET AUX POINTS D'INTEGRATION DE L'ELEMENT
C --- AU REPERE UTILISATEUR :
C     ---------------------
      CALL VDREPE(NOMTE,MATEVN,MATEVG)

      DO 150 I=1,NB2
        DO 140 J=1,8
          EFFGT(J,I)=0.D0
  140   CONTINUE
  150 CONTINUE
      DO 180 IC=1,NBCOU
        J=(IC-1)*NPGE*NSO+1
        ZIC=ZMIN+(IC-1)*HIC
        CALL VDEFGN(NOMTE,NB2,HIC,ZIC,SIGMA(1,J),EFFGC)
        DO 170 ISOM=1,NB2
          DO 160 ICOMP=1,8
            EFFGT(ICOMP,ISOM)=EFFGT(ICOMP,ISOM)+EFFGC(ICOMP,ISOM)
  160     CONTINUE
  170   CONTINUE
  180 CONTINUE

C --- PASSAGE DU VECTEUR DES EFFORTS GENERALISES DEFINI AUX NOEUDS
C --- DE L'ELEMENT DU REPERE INTRINSEQUE AU REPERE UTILISATEUR :
C     --------------------------------------------------------
      CALL JEVECH('PEFFORR','E',JEFFG)
      CALL VDEFRO(NB2,MATEVN,EFFGT,ZR(JEFFG))

      END
