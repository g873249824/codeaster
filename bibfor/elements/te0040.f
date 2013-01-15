      SUBROUTINE TE0040(OPTION,NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ----------------------------------------------------------------
C     CALCUL DES OPTIONS DES ELEMENTS DE COQUE 3D
C     OPTIONS : EPSI_ELNO
C               SIEF_ELNO
C               SIGM_ELNO
C          -----------------------------------------------------------
C
C
C
C
C-----------------------------------------------------------------------
      INTEGER I ,IC ,ICMP ,ICOMPO ,II ,IINPG ,INO
      INTEGER INTE ,INTSN ,INTSR ,IOUTNO ,IRET ,ISP ,J
      INTEGER JCARA ,JGEOM ,JJ ,K ,K1 ,KPGS ,L
      INTEGER LZI ,LZR ,NBCOU ,NCMP ,NPGE ,NPGT ,NSO

      REAL*8 S ,ZERO
C-----------------------------------------------------------------------
      PARAMETER(NPGE=3)
      PARAMETER(NPGT=10)

      INTEGER ICOU,NORDO,JMAT,JNBSPI
      INTEGER NB1,NB2,NPGSR,NPGSN

      REAL*8 VECTA(9,2,3),VECTN(9,3),VECTPT(9,2,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 EPAIS
      REAL*8 MATEVN(2,2,NPGT),MATEVG(2,2,NPGT)
      REAL*8 MATPG(6,270),MATNO(6,120),MATGN(6,120)
      REAL*8 PK2(6,270),MATGNU(6,120),SIGNO(6,120)

      LOGICAL LGREEN
C
C ----------------------------------------------------------------------
C
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
      IF (OPTION.EQ.'EPSI_ELNO') THEN
        CALL JEVECH('PDEFOPG','L',IINPG)
        CALL JEVECH('PDEFONO','E',IOUTNO)
C
      ELSE IF ((OPTION.EQ.'SIEF_ELNO') .OR.
     &         (OPTION.EQ.'SIGM_ELNO')) THEN
        CALL COSIRO(NOMTE,'PCONTRR','L','UI','G',IINPG,'S')
        CALL JEVECH('PSIEFNOR','E',IOUTNO)
        CALL TECACH('ONN','PCOMPOR','L',1,ICOMPO,IRET)
        IF (ICOMPO.NE.0) THEN
          IF (ZK16(ICOMPO+2).EQ.'GROT_GDEP') THEN
            LGREEN = .TRUE.
          ENDIF
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU=ZI(JNBSPI-1+1)

      IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_12')
      IF (NBCOU.GT.10) CALL U2MESS('F','ELEMENTS_13')

      EPAIS=ZR(JCARA)

      CALL VECTAN(NB1,NB2,ZR(JGEOM),ZR(LZR),VECTA,VECTN,VECTPT)

      KPGS=0
      DO 40 ICOU=1,NBCOU
        DO 30 INTE=1,NPGE
          DO 20 INTSN=1,NPGSN
            KPGS=KPGS+1
            K1=6*((INTSN-1)*NPGE*NBCOU+(ICOU-1)*NPGE+INTE-1)
            DO 10 I=1,6
              MATPG(I,KPGS)=ZR(IINPG-1+K1+I)
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE

      NCMP=6

      IF (LGREEN) THEN
C
C --- AFFECTATION DES CONTRAINTES DE PIOLA-KIRCHHOFF DE
C --- SECONDE ESPECE :
C     --------------
        DO 60 I=1,6
          DO 50 J=1,KPGS
            PK2(I,J)=MATPG(I,J)
   50     CONTINUE
   60   CONTINUE
C
C --- TRANSFORMATION DES CONTRAINTES DE PIOLA-KIRCHHOFF DE
C --- SECONDE ESPECE PK2 EN CONTRAINTES DE CAUCHY :
C     -------------------------------------------
        CALL PK2CAU(NOMTE,NCMP,PK2,MATPG)
      ENDIF
C
C ---  DETERMINATION DES REPERES  LOCAUX DE L'ELEMENT AUX POINTS
C ---  D'INTEGRATION ET STOCKAGE DE CES REPERES DANS LE VECTEUR .DESR
C      --------------------------------------------------------------
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

C---  EXTRAPOLATION VERS LES NOEUDS SOMMETS
C
      CALL JEVETE('&INEL.'//NOMTE//'.B',' ',JMAT)

      DO 130 ICOU=1,NBCOU
        DO 120 IC=1,NCMP
          DO 110 I=1,NPGE*NSO
            L=NPGE*NPGSN*(I-1)
            S=0.D0
            DO 100 J=1,NPGE*NPGSN
              JJ=(ICOU-1)*NPGE*NPGSN+J
              S=S+ZR(JMAT-1+L+J)*MATPG(IC,JJ)
  100       CONTINUE
            II=(ICOU-1)*NPGE*NSO+I
            MATNO(IC,II)=S
  110     CONTINUE
  120   CONTINUE
  130 CONTINUE

C --- DETERMINATION DES MATRICE DE PASSAGE DES REPERES INTRINSEQUES
C --- AUX NOEUDS ET AUX POINTS D'INTEGRATION DE L'ELEMENT
C --- AU REPERE UTILISATEUR :
C     ---------------------
      CALL VDREPE(NOMTE,MATEVN,MATEVG)

C --- PASSAGE DU VECTEUR DES CONTRAINTES DEFINI AUX NOEUDS
C --- DE L'ELEMENT DU REPERE INTRINSEQUE AU REPERE UTILISATEUR :
C     --------------------------------------------------------
C
      DO 210 ICOU=1,NBCOU
        DO 200 NORDO=-1,1

          ISP=NPGE*(ICOU-1)+NORDO+2

          DO 150 I=1,NCMP
            DO 140 J=1,NSO
              JJ=NSO*(NORDO+1)+NSO*NPGE*(ICOU-1)+J
              MATGN(I,J)=MATNO(I,JJ)
  140       CONTINUE
            IF (NOMTE.EQ.'MEC3QU9H') THEN
              MATGN(I,5)=(MATGN(I,1)+MATGN(I,2))/2.D0
              MATGN(I,6)=(MATGN(I,2)+MATGN(I,3))/2.D0
              MATGN(I,7)=(MATGN(I,3)+MATGN(I,4))/2.D0
              MATGN(I,8)=(MATGN(I,4)+MATGN(I,1))/2.D0
              MATGN(I,9)=(MATGN(I,1)+MATGN(I,2)+MATGN(I,3)+MATGN(I,4))/
     &               4.D0
             ELSEIF (NOMTE.EQ.'MEC3TR7H') THEN
              MATGN(I,4)=(MATGN(I,1)+MATGN(I,2))/2.D0
              MATGN(I,5)=(MATGN(I,2)+MATGN(I,3))/2.D0
              MATGN(I,6)=(MATGN(I,3)+MATGN(I,1))/2.D0
              MATGN(I,7)=(MATGN(I,1)+MATGN(I,2)+MATGN(I,3))/3.D0
            ENDIF
  150     CONTINUE

          IF (LGREEN) THEN
            CALL VDSIRO(NB2,1,MATEVN,'IU','N',MATGN,MATGNU)
            CALL CAURTG(NOMTE,NCMP,MATGNU,SIGNO)
          ELSE
            CALL VDSIRO(NB2,1,MATEVN,'IU','N',MATGN,SIGNO)
          ENDIF

          IF (OPTION.EQ.'EPSI_ELNO') THEN
            DO 170 ICMP=1,NCMP
              DO 160 INO=1,NB2
                ZR(IOUTNO-1+(INO-1)*NCMP*NBCOU*NPGE+(ISP-1)*NCMP+ICMP)=
     &                                                   MATGN(ICMP,INO)
  160         CONTINUE
  170       CONTINUE
          ELSE IF ((OPTION.EQ.'SIEF_ELNO') .OR.
     &             (OPTION.EQ.'SIGM_ELNO')) THEN
            DO 190 ICMP=1,NCMP
              DO 180 INO=1,NB2
                ZR(IOUTNO-1+(INO-1)*NCMP*NBCOU*NPGE+(ISP-1)*NCMP+ICMP)=
     &                                                   SIGNO(ICMP,INO)
  180         CONTINUE
  190       CONTINUE
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF

  200   CONTINUE
  210 CONTINUE

      END
