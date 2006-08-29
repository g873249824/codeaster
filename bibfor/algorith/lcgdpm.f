      SUBROUTINE LCGDPM (FAMI,KPG,KSP,NDIM,IMAT,COMPOR,CRIT,
     &                   INSTAM,INSTAP,TM,TP,TREF,FM,DF,SIGM,VIM,
     &                   OPTION,SIGP,VIP,DSIGDF,IRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2006   AUTEUR CIBHHPD L.SALMONA 
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
C TOLE CRP_20
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER            NDIM,IMAT,IRET,KPG,KSP
      CHARACTER*16       COMPOR(3),OPTION
      CHARACTER*(*)      FAMI
      REAL*8             CRIT(3),INSTAM,INSTAP
      REAL*8             TM,TP,TREF
      REAL*8             DF(3,3),FM(3,3)
      REAL*8             VIM(8),VIP(8)
      REAL*8             SIGM(*),SIGP(*),DSIGDF(6,3,3)

C.......................................................................
C       INTEGRATION DE LA LOI DE COMPORTEMENT PLASTIQUE ISOTROPE
C              EN GRANDES DEFORMATIONS DE TYPE SIMO-MIEHE
C.......................................................................
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  INSTAM  : INSTANT DU CALCUL PRECEDENT
C IN  INSTAP  : INSTANT DU CALCUL
C IN  TM      : TEMPERATURE A L INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DF      : INCREMENT DU GRADIENT DE LA TRANSFORMATION
C IN  FM      : GRADIENT DE LA TRANSFORMATION A L INSTANT PRECEDENT
C IN  SIGM    : CONTRAINTES DE CAUCHY A L INSTANT PTECEDENT
C IN  VIM     : VARIABLES INTERNES A L INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C OUT SIGP    : CONTRAINTES DE CAUCHY A L'INSTANT ACTUEL
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIGDF  : DERIVEE DE SIGMA PAR RAPPORT A F
C
C          ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C          L'ORDRE :  XX,YY,ZZ,XY,XZ,YZ
C.......................................................................

      INTEGER JPROL,JVALE,NBVAL(5),MAXVAL,TEST,NZ
      INTEGER I,J1,K,MODE,ITER,M,NBR
      REAL*8  R8BID,PHASM(5),PHASP(5)
      REAL*8  VALRES(20),ZALPHM,ZALPHP,ZAUSTM,ZAUSTP
      REAL*8  TTRGM,TTRGP,FMELM,FMELP
      REAL*8  EPSTHM,EPSTHP,EPSTH,DT,PLASTI
      REAL*8  EM,EP,NUM,NUP,MUM,MUP,MU,TROIKM,TROIKP,TROISK
      REAL*8  ALPHSY,SIGY,H0M(5),H0P(5),HM,HP,RB,PENTE(5),SIG(5)
      REAL*8  DZ(5),DZ1(5),DZ2(5),THETA(8),VI(5),RMOY
      REAL*8  ETA(5),N(5),UNSURN(5),C(5),M1(5),N0(5),EX,CM,MM,CR
      REAL*8  DVIN(5),DS,A,RM,R(5),TRANS,KPT(5),ZVARIM,ZVARIP,DELTAZ
      REAL*8  JM,J,DJ,DFB(3,3)
      REAL*8  TAUM(6),TAUP(6),TAU(6),TRTAUM,TRTAUP,TRTAU
      REAL*8  DVTAUM(6),DVTAUP(6),DVTAU(6),EQTAUM,EQTAU
      REAL*8  BEM(6)
      REAL*8  BEL(6),DVBEL(6),TRBEL
      REAL*8  DVTEL(6),EQTEL
      REAL*8  DP,SEUIL,MUTILD,DV
      REAL*8  JE2,JE3,XM,XP,SOL(3)
      REAL*8  COEFF1,COEFF2,COEFF3,COEFF4,COEFF5,COEFF6,COEFF7
      REAL*8  COEFF8,COEFF9
      REAL*8  MAT0(3,3),MAT1(3,3),MAT2(6,3,3),MAT3(3,3)
      CHARACTER*2 FB2,CODRET(20)
      CHARACTER*8 NOMRES(20),NOMCLE(5),ACIER(4)
      REAL*8      KR(6),PDTSCA(6)
      INTEGER     IND(3,3)
      DATA        KR/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA        PDTSCA/1.D0,1.D0,1.D0,2.D0,2.D0,2.D0/
      DATA        IND/1,4,5,
     &                4,2,6,
     &                5,6,3/
      DATA ACIER /'PFERRITE','PPERLITE','PBAINITE','PMARTENS'/

C SIGNIFICATION DES VARIABLES LOCALES
C
C  FB(I,J)=(J**(-1/3))*F(I,J)
C  GPM(I,J) : DEFORMATION PLASTIQUE LAGRANGIENNE A L'INSTANT PRECEDENT
C  B(I,J)=FB(I,K)*GPM(K,L)*FB(J,L)
C  BETR(1)=B(1,1), BETR(2)=B(2,2),...,BETR(6)=B(2,3)=B(3,2)
C
C TENSEUR DE DEFORMATION ELASTIQUE EULERIEN : BE
C TENSEUR DE DEFORMATION PLASTIQUE LAGRANGIEN : GP
C TAU : TENSEUR DE KIRSHHOFF



C NOMBRE DE PHASE
      NZ=5
C RECUPERATION DES CARACTERISTIQUES

C 1 - ELASTIQUE ET THERMIQUE

      IF(COMPOR(1)(1:4) .EQ. 'ELAS'  .OR.
     &   COMPOR(1)(1:4) .EQ. 'META' ) THEN
       NOMRES(1)='E'
       NOMRES(2)='NU'
       NOMRES(3)='F_ALPHA'
       NOMRES(4)='C_ALPHA'
       NOMRES(5)='PHASE_REFE'
       NOMRES(6)='EPSF_EPSC_TREF'
       CALL RCVALA(IMAT,' ','ELAS_META',1,'TEMP',TM,6,NOMRES,VALRES,
     &             CODRET,'F ')

C RECUPERATION DES PHASES METALLURGIQUES ( A T+ ET T- )
       DO 1 I=1,4
         CALL RCVARC(' ',ACIER(I),'-',FAMI,KPG,KSP,
     &        PHASM(I),IRET)
         IF (IRET.EQ.1) PHASM(I)=0.D0
         CALL RCVARC(' ',ACIER(I),'+',FAMI,KPG,KSP,
     &        PHASP(I),IRET)
         IF (IRET.EQ.1) PHASP(I)=0.D0
 1     CONTINUE

       ZALPHM=PHASM(1)+PHASM(2)+PHASM(3)+PHASM(4)
       ZAUSTM=1.D0-ZALPHM
       PHASM(5)=ZAUSTM
       TTRGM=TM-TREF

       EPSTHM=ZAUSTM*(VALRES(4)*TTRGM-(1.D0-VALRES(5))*VALRES(6))
     &       +ZALPHM*(VALRES(3)*TTRGM+VALRES(5)*VALRES(6))

       EM=VALRES(1)
       NUM=VALRES(2)
       MUM=EM/(2.D0*(1.D0+NUM))
       TROIKM = EM/(1.D0-2.D0*NUM)
       CALL RCVALA(IMAT,' ','ELAS_META',1,'TEMP',TP,6,NOMRES,
     &             VALRES,CODRET,'F ')
       ZALPHP=PHASP(1)+PHASP(2)+PHASP(3)+PHASP(4)
       ZAUSTP=1.D0-ZALPHP
       PHASP(5)=ZAUSTP
       TTRGP=TP-TREF
       EPSTHP=ZAUSTP*(VALRES(4)*TTRGP-(1.D0-VALRES(5))*VALRES(6))
     &       +ZALPHP*(VALRES(3)*TTRGP+VALRES(5)*VALRES(6))
       EP=VALRES(1)
       NUP=VALRES(2)
       MUP=EP/(2.D0*(1.D0+NUP))
       TROIKP=EP/(1.D0-2.D0*NUP)
       DT=INSTAP-INSTAM
      ENDIF

C 2 - PLASTIQUE
C 2.1 - RECUPERATION DE LA COURBE DE TRACTION
C 2.1.1 - LOI DES MELANGES A INSTANT M ET P

      IF(COMPOR(1)(1:4).EQ.'META') THEN
       PLASTI=VIM(6)
       IF(COMPOR(1)(1:6).EQ.'META_P') THEN
        NOMRES(1) ='F1_SY'
        NOMRES(2) ='F2_SY'
        NOMRES(3) ='F3_SY'
        NOMRES(4) ='F4_SY'
        NOMRES(5) ='C_SY'
        NOMRES(6) ='SY_MELANGE'
       ENDIF
       IF(COMPOR(1)(1:6).EQ.'META_V') THEN
       NOMRES(1) ='F1_S_VP'
       NOMRES(2) ='F2_S_VP'
        NOMRES(3) ='F3_S_VP'
        NOMRES(4) ='F4_S_VP'
        NOMRES(5) ='C_S_VP'
        NOMRES(6) ='S_VP_MEL'
       ENDIF
       CALL RCVALA(IMAT,' ','ELAS_META',1,'META',ZALPHM,1,
     &             NOMRES(6),FMELM,CODRET(6),'  ')
       CALL RCVALA(IMAT,' ','ELAS_META',1,'META',ZALPHP,1,
     &             NOMRES(6),FMELP,CODRET(6),'  ')
       IF (CODRET(6).NE.'OK') THEN
        FMELM = ZALPHM
       FMELP = ZALPHP
       ENDIF

C 2.1.2 - CALCUL DE SIGY

       CALL RCVALA(IMAT,' ','ELAS_META',1,'TEMP',TP,5,
     &             NOMRES,VALRES,CODRET,'F ')

       IF(ZALPHP.GT.0.D0) THEN
        ALPHSY=PHASP(1)*VALRES(1)+PHASP(2)*VALRES(2)+PHASP(3)*VALRES(3)
     &        + PHASP(4)*VALRES(4)
        ALPHSY = ALPHSY/ZALPHP
       ELSE
        ALPHSY = 0.D0
       ENDIF
       SIGY = (1.D0-FMELP)*VALRES(5)+FMELP*ALPHSY

C 2.2 - CALCUL POUR LE CAS NON LINEAIRE DE HM

       IF(COMPOR(1)(1:10).EQ.'META_P_INL' .OR.
     &    COMPOR(1)(1:10).EQ.'META_V_INL' )THEN
        NOMCLE(1)='SIGM_F1 '
        NOMCLE(2)='SIGM_F2 '
        NOMCLE(3)='SIGM_F3 '
        NOMCLE(4)='SIGM_F4 '
        NOMCLE(5)='SIGM_C  '
        DO 5 K=1,5
         CALL RCTRAC(IMAT,'META_TRACTION',NOMCLE(K),TM,
     &               JPROL,JVALE,NBVAL(K),R8BID)
         CALL RCFONC('V','META_TRACTION',JPROL,JVALE,NBVAL(K),
     &      R8BID,R8BID,R8BID,VIM(K),R8BID,H0M(K),R8BID,R8BID,R8BID)

   5    CONTINUE

        IF(ZALPHM.GT.0.D0) THEN
         HM=PHASM(1)*H0M(1)+PHASM(2)*H0M(2)+PHASM(3)*H0M(3)
     &     +PHASP(4)*H0M(4)
         HM = HM/ZALPHM
        ELSE
         HM = 0.D0
        ENDIF
        HM = (1-FMELM)*H0M(5)+FMELM*HM
       ENDIF

C 2.3 - CALCUL POUR LE CAS LINEAIRE DE HM ET HP

       IF(COMPOR(1)(1:9).EQ.'META_P_IL' .OR.
     &    COMPOR(1)(1:9).EQ.'META_V_IL' )THEN
        NOMRES(7) ='F1_D_SIGM_EPSI'
        NOMRES(8) ='F2_D_SIGM_EPSI'
        NOMRES(9) ='F3_D_SIGM_EPSI'
        NOMRES(10) ='F4_D_SIGM_EPSI'
        NOMRES(11) ='C_D_SIGM_EPSI'

C 2.3.1 - CALCUL DE HM

        CALL RCVALA(IMAT,' ','META_ECRO_LINE',1,'TEMP',TM,5,
     &              NOMRES(7),VALRES(7),CODRET(7),'F ')

        H0M(1)=VALRES(7)*EM/(EM-VALRES(7))
        H0M(2)=VALRES(8)*EM/(EM-VALRES(8))
        H0M(3)=VALRES(9)*EM/(EM-VALRES(9))
        H0M(4)=VALRES(10)*EM/(EM-VALRES(10))
        H0M(5)=VALRES(11)*EM/(EM-VALRES(11))
        IF(ZALPHM.GT.0.D0) THEN
         HM=PHASM(1)*H0M(1)+PHASM(2)*H0M(2)+PHASM(3)*H0M(3)
     &     +PHASP(4)*H0M(4)
         HM = HM/ZALPHM
        ELSE
         HM = 0.D0
        ENDIF
        HM = (1.D0-FMELM)*H0M(5)+FMELM*HM

C 2.3.2 - CALCUL DE HP

        CALL RCVALA(IMAT,' ','META_ECRO_LINE',1,'TEMP',TP,5,
     &              NOMRES(7),VALRES(7),CODRET(7),'F ')

        H0P(1)=VALRES(7)*EP/(EP-VALRES(7))
        H0P(2)=VALRES(8)*EP/(EP-VALRES(8))
        H0P(3)=VALRES(9)*EP/(EP-VALRES(9))
        H0P(4)=VALRES(10)*EP/(EP-VALRES(10))
        H0P(5)=VALRES(11)*EP/(EP-VALRES(11))

        IF(ZALPHP.GT.0.D0) THEN
         HP=PHASP(1)*H0P(1)+PHASP(2)*H0P(2)+PHASP(3)*H0P(3)
     &     +PHASP(4)*H0P(4)
         HP = HP/ZALPHP
        ELSE
         HP  = 0.D0
        ENDIF
        HP   = (1.D0-FMELP)*H0P(5)+FMELP*HP
       ENDIF

C 3 - CALCUL DE VIM+DG-DS

       DO 10 K=1,4
        DZ(K)= PHASP(K)-PHASM(K)
        IF (DZ(K).GE.0.D0) THEN
         DZ1(K)=DZ(K)
         DZ2(K)=0.D0
        ELSE
         DZ1(K)=0.D0
         DZ2(K)=-DZ(K)
        ENDIF
 10    CONTINUE

C 3.1 - COEFFICIENTS CONCERNANT LA RESTAURATION D ECROUISSAGE

       IF(COMPOR(1)(1:12).EQ.'META_P_IL_RE'  .OR.
     &    COMPOR(1)(1:15).EQ.'META_P_IL_PT_RE' .OR.
     &    COMPOR(1)(1:12).EQ.'META_V_IL_RE'    .OR.
     &    COMPOR(1)(1:15).EQ.'META_V_IL_PT_RE' .OR.
     &    COMPOR(1)(1:13).EQ.'META_P_INL_RE'   .OR.
     &    COMPOR(1)(1:16).EQ.'META_P_INL_PT_RE'.OR.
     &    COMPOR(1)(1:13).EQ.'META_V_INL_RE'   .OR.
     &    COMPOR(1)(1:16).EQ.'META_V_INL_PT_RE') THEN
        NOMRES(1) ='C_F1_THETA'
        NOMRES(2) ='C_F2_THETA'
        NOMRES(3) ='C_F3_THETA'
        NOMRES(4) ='C_F4_THETA'
        NOMRES(5) ='F1_C_THETA'
        NOMRES(6) ='F2_C_THETA'
        NOMRES(7) ='F3_C_THETA'
        NOMRES(8) ='F4_C_THETA'
        CALL RCVALA(IMAT,' ','META_RE',1,'TEMP ',TP,8,
     &              NOMRES,VALRES,CODRET,'F ')
        DO 20 I=1,8
         THETA(I)=VALRES(I)
 20     CONTINUE
       ELSE
        DO 30 I=1,8
         THETA(I)=1.D0
 30     CONTINUE
       ENDIF

C 3.2 - COEFFICIENTS DE VISCOSITE (PAS OBLIGATOIRE)

       IF (COMPOR(1)(1:6) .EQ. 'META_V') THEN
        NOMRES(1) = 'F1_ETA'
        NOMRES(2) = 'F2_ETA'
        NOMRES(3) = 'F3_ETA'
        NOMRES(4) = 'F4_ETA'
        NOMRES(5) = 'C_ETA'

        NOMRES(6) = 'F1_N'
        NOMRES(7) = 'F2_N'
        NOMRES(8) = 'F3_N'
        NOMRES(9) = 'F4_N'
        NOMRES(10) = 'C_N'

        NOMRES(11) ='F1_C'
        NOMRES(12) ='F2_C'
        NOMRES(13) ='F3_C'
        NOMRES(14) ='F4_C'
        NOMRES(15) ='C_C'

        NOMRES(16) = 'F1_M'
        NOMRES(17) = 'F2_M'
        NOMRES(18) = 'F3_M'
        NOMRES(19) = 'F4_M'
        NOMRES(20) = 'C_M'

        CALL RCVALA(IMAT,' ','META_VISC',1,'TEMP',TP,20,NOMRES,
     &              VALRES,CODRET,FB2)
        DO  29 I=1,NZ
           ETA(I) = VALRES(I)
           N(I) = VALRES(NZ+I)
           UNSURN(I)=1/N(I)
           IF (CODRET(2*NZ+I) .NE. 'OK') VALRES(2*NZ+I)=0.D0
           C(I) =VALRES(2*NZ+I)
           IF (CODRET(3*NZ+I) .NE. 'OK') VALRES(3*NZ+I)=20.D0
           M1(I) = VALRES(3*NZ+I)
 29     CONTINUE
       ELSE
        DO 39 I=1,NZ
           ETA(I) = 0.D0
           N(I)= 20.D0
           UNSURN(I)= 1.D0
           C(I) = 0.D0
           M1(I) = 20.D0
 39     CONTINUE
       ENDIF

C 3.4 - CALCUL DE VIM=VIM+DVIN (VIM+DG)

       IF(ZAUSTP.GT.0.D0)THEN
        DVIN(5)=0.D0
        DO 70 K=1,4
         DVIN(5)=DVIN(5)+DZ2(K)*THETA(4+K)*VIM(K)/ZAUSTP
     &          -DZ2(K)*VIM(5)/ZAUSTP
 70     CONTINUE
        VIM(5)=VIM(5)+DVIN(5)
        RMOY=ZAUSTP*VIM(5)
       ELSE
        DVIN(5)  = 0.D0
        VIM(5)   = 0.D0
        RMOY=0.D0
       ENDIF

       DO 80 K=1,4
        IF (PHASP(K).GT.0.D0)THEN
         DVIN(K)=DZ1(K)*THETA(K)*VIM(5)/PHASP(K)-
     &           DZ1(K)*VIM(K)/PHASP(K)
         VIM(K)=VIM(K)+DVIN(K)
         RMOY=RMOY+PHASP(K)*VIM(K)
        ELSE
         DVIN(K)=0.D0
         VIM(K)=0.D0
        ENDIF
 80    CONTINUE

C      RESTAURATION ECROUISSAGE VISQUEUSE
       CM=ZAUSTP*C(5)
       DO 49 I=1,4
          CM=CM+PHASP(I)*C(I)
 49    CONTINUE

       MM=ZAUSTP*M1(5)
       DO 59 I=1,4
          MM=MM+PHASP(I)*M1(I)
 59    CONTINUE
       CR=CM*RMOY
       IF (CR .LE. 0.D0) THEN
        DS=0.D0
       ELSE
        DS= DT*((CM*RMOY)**MM)
       ENDIF

C 4 - CALCUL DE RM (ON INCLUT LE SIGY)

C 4.1 - RM POUR LE CAS LINEAIRE

       IF(COMPOR(1)(1:9).EQ.'META_P_IL'.OR.
     &    COMPOR(1)(1:9).EQ.'META_V_IL') THEN

        IF(VIM(5).GE.DS)THEN
         A=(1.D0-FMELP)*H0P(5)*(VIM(5)-DS)
        ELSE
         A=0.D0
        ENDIF
        IF(ZALPHP.GT.0.D0)THEN
         DO 90 K=1,4
          IF(VIM(K).GE.DS)THEN
           A=A+(FMELP/ZALPHP)*(PHASP(K)*H0P(K)*(VIM(K)-DS))
          ENDIF
 90      CONTINUE
        ENDIF
        RM=A+SIGY
       ENDIF

C 4.2 - CALCUL DE RM ET DE HP DANS LE CAS NON LINEAIRE

       IF(COMPOR(1)(1:10).EQ.'META_P_INL' .OR.
     &    COMPOR(1)(1:10).EQ.'META_V_INL' )THEN

        DO 92 K=1,5
         VI(K)=VIM(K)-DS
         IF(VI(K).LT.0.D0) THEN
          VI(K)=0.D0
         ENDIF
  92    CONTINUE
        DO 93 K=1,5

         CALL RCTRAC(IMAT,'META_TRACTION',NOMCLE(K),TP,
     &               JPROL,JVALE,NBVAL(K),R8BID)

         CALL RCFONC('V','META_TRACTION',JPROL,JVALE,NBVAL(K),
     &    R8BID,R8BID,R8BID,VI(K),R(K),H0P(K),R8BID,R8BID,R8BID)

  93    CONTINUE
        MAXVAL=NBVAL(1)
        IF(NBVAL(3).GT.MAXVAL) MAXVAL=NBVAL(3)
        IF(NBVAL(4).GT.MAXVAL) MAXVAL=NBVAL(4)
        IF(NBVAL(5).GT.MAXVAL) MAXVAL=NBVAL(5)

        IF(ZALPHP.GT.0.D0) THEN
         HP=PHASP(1)*H0P(1)+PHASP(2)*H0P(2)+PHASP(3)*H0P(3)
     &     +PHASP(4)*H0P(4)
         HP=HP/ZALPHP
         RM=PHASP(1)*R(1)+PHASP(2)*R(2)+PHASP(3)*R(3)
     &     +PHASP(4)*R(4)
         RM=RM/ZALPHP
        ELSE
         HP    =0.D0
         RM    =0.D0
        ENDIF
        HP = (1.D0-FMELP)*H0P(5)+FMELP*HP
        RM = (1.D0-FMELP)*R(5)+FMELP*RM + SIGY
       ENDIF
      ELSE
       RM =0.D0
       PLASTI=0.D0
      ENDIF

C 5 - PLASTICITE DE TRANSFORMATION (PAS OBLIGATOIRE)

      TRANS=0.D0
      IF(COMPOR(1)(1:12).EQ.'META_P_IL_PT'    .OR.
     &   COMPOR(1)(1:15).EQ.'META_P_IL_PT_RE' .OR.
     &   COMPOR(1)(1:12).EQ.'META_V_IL_PT'    .OR.
     &   COMPOR(1)(1:15).EQ.'META_V_IL_PT_RE' .OR.
     &   COMPOR(1)(1:13).EQ.'META_P_INL_PT'   .OR.
     &   COMPOR(1)(1:16).EQ.'META_P_INL_PT_RE'.OR.
     &   COMPOR(1)(1:13).EQ.'META_V_INL_PT'   .OR.
     &   COMPOR(1)(1:16).EQ.'META_V_INL_PT_RE' ) THEN

       NOMRES(1)='F1_K'
       NOMRES(2)='F2_K'
       NOMRES(3)='F3_K'
       NOMRES(4)='F4_K'
       NOMRES(5)='F1_D_F_META'
       NOMRES(6)='F2_D_F_META'
       NOMRES(7)='F3_D_F_META'
       NOMRES(8)='F4_D_F_META'
       CALL RCVALA(IMAT,' ','META_PT',1,'TEMP',TP,4,
     &             NOMRES ,VALRES ,CODRET ,'F ')
       DO 91 I=1,4
        KPT(I) =VALRES(I)
 91    CONTINUE
       DO 94 I=1,4
        ZVARIM=PHASM(I )
        ZVARIP=PHASP(I )
        DELTAZ=(ZVARIP-ZVARIM)
        IF(DELTAZ.GT.0) THEN
         J1=4+I
         CALL RCVALA(IMAT,' ','META_PT',1,'META',ZALPHP,1,
     &               NOMRES(J1),VALRES(J1),CODRET(J1),'F ')
         TRANS=TRANS+KPT(I)*VALRES(J1)*(ZVARIP-ZVARIM)
        ENDIF
 94    CONTINUE
      ENDIF

C 6 - DEBUT DE L ALGORITHME
C 6.1 - JM=DET(FM),DJ=DET(DF),J=JM*DJ ET DFB

      JM=FM(1,1)*(FM(2,2)*FM(3,3)-FM(2,3)*FM(3,2))
     &  -FM(2,1)*(FM(1,2)*FM(3,3)-FM(1,3)*FM(3,2))
     &  +FM(3,1)*(FM(1,2)*FM(2,3)-FM(1,3)*FM(2,2))

      DJ=DF(1,1)*(DF(2,2)*DF(3,3)-DF(2,3)*DF(3,2))
     &  -DF(2,1)*(DF(1,2)*DF(3,3)-DF(1,3)*DF(3,2))
     &  +DF(3,1)*(DF(1,2)*DF(2,3)-DF(1,3)*DF(2,2))

      J=JM*DJ

      DO 100 I=1,3
       DO 110 J1=1,3
        IF (DJ.LE.0.D0) THEN
          IRET = 1
          GOTO 9999
        ELSE
          DFB(I,J1)=(DJ**(-1.D0/3.D0))*DF(I,J1)
        ENDIF
 110   CONTINUE
 100  CONTINUE

C 6.2 - CONTRAINTES DE KIRSHHOFF A L INSTANT PRECEDENT

      TAUM(5)=0.D0
      TAUM(6)=0.D0
      DO 120 I=1,2*NDIM
       TAUM(I)=JM*SIGM(I)
 120  CONTINUE

      TRTAUM=TAUM(1)+TAUM(2)+TAUM(3)
      EQTAUM=0.D0
      DO 130 I=1,6
       DVTAUM(I)=TAUM(I)-KR(I)*TRTAUM/3.D0
       EQTAUM=EQTAUM+PDTSCA(I)*(DVTAUM(I)**2.D0)
 130  CONTINUE
      EQTAUM=SQRT(1.5D0*EQTAUM)

C 6.3 - DEFORMATIONS ELASTIQUES A L INSTANT PRECEDENT :
C BEM=DVTAUM/MUM+KR*TRBEM/3.D0

      IF (COMPOR(1)(1:4).EQ.'ELAS') THEN
       XM = (JM**(-2.D0/3.D0))*(1.D0-2.D0*VIM(1)/3.D0)
      ELSE
       XM = (JM**(-2.D0/3.D0))*(1.D0-2.D0*VIM(8)/3.D0)
      ENDIF
      DO 140 I=1,6
       BEM(I)=DVTAUM(I)/MUM+KR(I)*XM
 140  CONTINUE

C 6.4 - BEL(I,J)=DFB(I,K)*BEM(K,L)*DFB(J,L)

      DO 150 I=1,3
       DO 160 J1=1,3
        BEL(IND(I,J1))=0.D0
        DO 170 K=1,3
         DO 180 M=1,3
          BEL(IND(I,J1))=BEL(IND(I,J1))
     &    +DFB(I,K)*BEM(IND(K,M))*DFB(J1,M)
 180     CONTINUE
 170    CONTINUE
 160   CONTINUE
 150  CONTINUE

C 6.5 - TRACE ET PARTIE DEVIATORIQUE DU TENSEUR BEL

      TRBEL=BEL(1)+BEL(2)+BEL(3)

      DO 190 I=1,6
       DVBEL(I)=BEL(I)-KR(I)*TRBEL/3.D0
 190  CONTINUE

C 6.6 - CONTRAINTE ELASTIQUE (PARTIE DEVIATORIQUE)

      DO 200 I=1,6
       DVTEL(I)=MUP*DVBEL(I)
 200  CONTINUE

C 6.7 - CONTRAINTE EQUIVALENTE ELASTIQUE ET SEUIL

      EQTEL=0.D0
      DO 210 I=1,6
       EQTEL=EQTEL+PDTSCA(I)*DVTEL(I)*DVTEL(I)
 210  CONTINUE
      EQTEL=SQRT(1.5D0*EQTEL)
      SEUIL=EQTEL-(1.D0+MUP*TRANS*TRBEL)*RM
      DP=0.D0

C 6.8 - TRACE DU TENSEUR DE KIRSHHOFF (CONNUE CAR NE DEPEND QUE DE J)

      TRTAUP=(TROIKP*((J*J)-1.D0)/6.D0)
     &      -(TROIKP*EPSTHP*(J+(1.D0/J))/2.D0)

C 6.9 - CORRECTION PLASTIQUE

      IF(OPTION(1:9).EQ.'RAPH_MECA'.OR.
     &   OPTION(1:9).EQ.'FULL_MECA') THEN

C 6.9.1 - COMPORTEMENT ELASTIQUE - CALCUL DE SIGMA A T+DT

       IF(COMPOR(1)(1:4).EQ.'ELAS') THEN
        DO 220 I=1,6
         TAUP(I)=DVTEL(I)+KR(I)*TRTAUP
 220    CONTINUE
        IF(NDIM.EQ.2)THEN
         DO 230 I=1,4
          SIGP(I)=TAUP(I)/J
 230     CONTINUE
        ELSE
         DO 240 I=1,6
          SIGP(I)=TAUP(I)/J
 240     CONTINUE
        ENDIF

C 6.9.2 - COMPORTEMENT PLASTIQUE
C 6.9.2.1 - CALCUL DE DP

       ELSE IF (COMPOR(1)(1:4).EQ.'META') THEN
        IF (SEUIL.LT.0.D0) THEN
         VIP(6)=0.D0
         DP=0.D0
        ELSE
         VIP(6)=1.D0
         MUTILD=2.D0*MUP*TRBEL/3.D0
         CALL NZCALC(CRIT,PHASP,NZ,FMELP,SEUIL,DT,TRANS
     &                  ,HP,MUTILD,ETA,UNSURN,DP,IRET)
         IF(IRET.EQ.1) GOTO 9999
C 6.9.2.1.1 DANS LE CAS NON LINEAIRE
C VERIFICATION QU ON EST DANS LE BON INTERVALLE

         IF(COMPOR(1)(1:10).EQ.'META_P_INL' .OR.
     &      COMPOR(1)(1:10).EQ.'META_V_INL' )THEN
          TEST=1
          MAXVAL=MAXVAL+2
          DO 252 ITER=1,MAXVAL
           IF(TEST.EQ.0)GOTO 252
           IF((TEST.EQ.1).AND.(ITER.EQ.MAXVAL))THEN
            CALL UTMESS('F','LGDPM','PAS POSSIBLE')
           ENDIF
           IF(ZAUSTP.GT.0.D0)THEN
            VIP(5)=VIM(5)-DS+DP
            IF(VIP(5).LT.0.D0) VIP(5)=0.D0
            PENTE(5)=H0P(5)
            CALL RCTRAC(IMAT,'META_TRACTION',NOMCLE(5),TP,
     &                  JPROL,JVALE,NBVAL(5),R8BID)
            CALL RCFONC('V','META_TRACTION',JPROL,JVALE,NBVAL(5),
     &       R8BID,R8BID,R8BID,VIP(5),R(5),H0P(5),R8BID,R8BID,R8BID)

            IF(((H0P(5)-PENTE(5)).LE.1.D-03).AND.
     &         ((H0P(5)-PENTE(5)).GE.-1.D-03)) THEN
             TEST=0
            ELSE
             TEST=1
            ENDIF
            SEUIL=EQTEL-(1.D0+MUP*TRANS*TRBEL)*
     &           (1.D0-FMELP)*(R(5)-H0P(5)*DP)
            HP=(1.D0-FMELP)*H0P(5)
           ELSE
            SEUIL=EQTEL
            HP=0.D0
           ENDIF
           DO 251 K=1,4
            IF(PHASP(K).GT.0.D0)THEN
             VIP(K)=VIM(K)-DS+DP
             IF(VIP(K).LT.0.D0) VIP(K)=0.D0
             PENTE(K)=H0P(K)
             CALL RCTRAC(IMAT,'META_TRACTION',NOMCLE(K),TP,
     &                   JPROL,JVALE,NBVAL(K),R8BID)
             CALL RCFONC('V','META_TRACTION',JPROL,JVALE,NBVAL(K),
     &       R8BID,R8BID,R8BID,VIP(K),R(K),H0P(K),R8BID,R8BID,R8BID)

             IF(((H0P(K)-PENTE(K)).LE.1.D-03).AND.
     &         ((H0P(K)-PENTE(K)).GE.-1.D-03)) THEN
              TEST=0
             ELSE
              TEST=1
             ENDIF
             SEUIL=SEUIL-(1.D0+MUP*TRANS*TRBEL)
     &            *FMELP*PHASP(K)*(R(K)-H0P(K)*DP)/ZALPHP
             HP=HP+FMELP*PHASP(K)*H0P(K)/ZALPHP
            ENDIF
  251      CONTINUE
           SEUIL = SEUIL - (1.D0+MUP*TRANS*TRBEL)*SIGY
           IF(TEST.EQ.1)THEN
            CALL NZCALC(CRIT,PHASP,NZ,FMELP,SEUIL,DT,TRANS
     &                  ,HP,MUTILD,ETA,UNSURN,DP,IRET)
            IF(IRET.EQ.1) GOTO 9999
           ENDIF
  252     CONTINUE
         ENDIF
        ENDIF

C 6.9.2.2 - CALCUL DE SIGMA A T+DT

        PLASTI=VIP(6)
        DO 250 I=1,6
         IF(EQTEL.GT.0.D0)THEN
          DVTAUP(I)=DVTEL(I)-MUP*DP*TRBEL*DVTEL(I)/EQTEL
          DVTAUP(I)=DVTAUP(I)/(1.D0+MUP*TRANS*TRBEL)
         ELSE
          DVTAUP(I)=DVTEL(I)/(1.D0+MUP*TRANS*TRBEL)
         ENDIF
         TAUP(I)=DVTAUP(I)+KR(I)*TRTAUP
 250    CONTINUE
        IF(NDIM.EQ.2)THEN
         DO 260 I=1,4
          SIGP(I)=TAUP(I)/J
 260     CONTINUE
        ELSE
         DO 270 I=1,6
          SIGP(I)=TAUP(I)/J
 270     CONTINUE
        ENDIF

C 6.9.2.3 - CALCUL DE RI A T+DT ET R=(1-F)*R(VIP5)+F*Z(K)*R(VIPK)/ZFPBM

        IF(ZAUSTP.GT.0.D0)THEN
         VIP(5)=VIM(5)-DS+DP
         IF(VIP(5).LT.0.D0) VIP(5)=0.D0
         IF(COMPOR(1)(1:9).EQ.'META_P_IL'.OR.
     &      COMPOR(1)(1:9).EQ.'META_V_IL')THEN
          VIP(7)=(1-FMELP)*H0P(5)*VIP(5)
         ENDIF
         IF(COMPOR(1)(1:10).EQ.'META_P_INL'.OR.
     &      COMPOR(1)(1:10).EQ.'META_V_INL')THEN
          VIP(7)=(1-FMELP)*R(5)
         ENDIF
        ELSE
         VIP(5)=0.D0
         VIP(7)=0.D0
        ENDIF

        DO 280 K=1,4
         IF(PHASP(K).GT.0.D0)THEN
          VIP(K)=VIM(K)-DS+DP
          IF(VIP(K).LT.0.D0) VIP(K)=0.D0
          IF(COMPOR(1)(1:9).EQ.'META_P_IL'.OR.
     &       COMPOR(1)(1:9).EQ.'META_V_IL')THEN
           VIP(7)=VIP(7)+FMELP*PHASP(K)*H0P(K)*VIP(K)/ZALPHP
          ENDIF
          IF(COMPOR(1)(1:10).EQ.'META_P_INL'.OR.
     &       COMPOR(1)(1:10).EQ.'META_V_INL')THEN
           VIP(7)=VIP(7)+FMELP*PHASP(K)*R(K)/ZALPHP
          ENDIF
         ELSE
          VIP(K)  = 0.D0
         ENDIF
 280    CONTINUE
       ENDIF
      ENDIF

C 7 - MATRICE TANGENTE DSIGDF
C DEFINITION DE DIFFERENTS COEFFICIENTS POUR CALCULER DSIGDF

      IF(OPTION(1:14).EQ.'RIGI_MECA_TANG'.OR.
     &   OPTION(1:9) .EQ.'FULL_MECA') THEN
      IF(OPTION(1:14).EQ.'RIGI_MECA_TANG') THEN
       MU=MUM
       EPSTH=EPSTHM
       TROISK=TROIKM
       TRANS=0.D0
       DO 300 I=1,6
        TAU(I)=TAUM(I)
 300   CONTINUE
      ELSE
       MU=MUP
       EPSTH=EPSTHP
       TROISK=TROIKP
       DO 310 I=1,6
        TAU(I)=TAUP(I)
 310   CONTINUE
      ENDIF

      MAT0(1,1)=DF(2,2)*DF(3,3)-DF(2,3)*DF(3,2)
      MAT0(2,2)=DF(1,1)*DF(3,3)-DF(1,3)*DF(3,1)
      MAT0(3,3)=DF(1,1)*DF(2,2)-DF(1,2)*DF(2,1)
      MAT0(1,2)=DF(3,1)*DF(2,3)-DF(2,1)*DF(3,3)
      MAT0(2,1)=DF(1,3)*DF(3,2)-DF(1,2)*DF(3,3)
      MAT0(1,3)=DF(2,1)*DF(3,2)-DF(3,1)*DF(2,2)
      MAT0(3,1)=DF(1,2)*DF(2,3)-DF(1,3)*DF(2,2)
      MAT0(2,3)=DF(3,1)*DF(1,2)-DF(1,1)*DF(3,2)
      MAT0(3,2)=DF(2,1)*DF(1,3)-DF(1,1)*DF(2,3)

      DO 330 I=1,3
       DO 340 J1=1,3
        MAT1(I,J1)=0.D0
        DO 350 K=1,3
         MAT1(I,J1)=MAT1(I,J1)+DFB(I,K)*BEM(IND(K,J1))
 350    CONTINUE
 340   CONTINUE
 330  CONTINUE

      DO 360 I=1,3
       DO 370 J1=1,3
        DO 380 M=1,3
         DO 390 K=1,3
          MAT2(IND(I,J1),M,K)=KR(IND(I,M))*MAT1(J1,K)
     &                       +KR(IND(J1,M))*MAT1(I,K)
 390     CONTINUE
 380    CONTINUE
 370   CONTINUE
 360  CONTINUE

      EQTAU=0.D0
      TRTAU=(TAU(1)+TAU(2)+TAU(3))/3.D0
      DO 391 I=1,6
       DVTAU(I)=TAU(I)-TRTAU*KR(I)
       EQTAU=EQTAU+PDTSCA(I)*(DVTAU(I)**2.D0)
 391  CONTINUE
      EQTAU=SQRT(1.5D0*EQTAU)
      IF(EQTAU.GT.0.D0)THEN
       COEFF1=1.D0+MU*TRANS*TRBEL+MU*DP*TRBEL/EQTAU
      ELSE
       COEFF1=1.D0+MU*TRANS*TRBEL
      ENDIF
      COEFF2=(DJ**(-1.D0/3.D0))*MU/(COEFF1*J)
      COEFF3=-2.D0*MU/(3.D0*COEFF1*J*DJ)
      COEFF4=(TROISK*J/3.D0)-TROISK*EPSTH
     &      *(1.D0-(J**(-2.D0)))/2.D0
      COEFF4=COEFF4/DJ

      DO 400 I=1,6
       DO 410 M=1,3
        DO 420 K=1,3
         DSIGDF(I,M,K)=MAT2(I,M,K)-2.D0*KR(I)*MAT1(M,K)/3.D0
         DSIGDF(I,M,K)=COEFF2*DSIGDF(I,M,K)
     &                +COEFF3*DVBEL(I)*MAT0(M,K)
     &                +COEFF4*KR(I)*MAT0(M,K)
     &                -TAU(I)*MAT0(M,K)/(J*DJ)
 420    CONTINUE
 410   CONTINUE
 400  CONTINUE

      IF(PLASTI.EQ.0.D0)THEN
       COEFF5=-2.D0*TRANS*COEFF2
       COEFF6=2.D0*TRANS*MU*TRBEL/(3.D0*J*DJ*COEFF1)
       DO 430 I=1,6
        DO 440 M=1,3
         DO 450 K=1,3
          DSIGDF(I,M,K)=DSIGDF(I,M,K)+COEFF5*DVTAU(I)*MAT1(M,K)
     &                 +COEFF6*DVTAU(I)*MAT0(M,K)
 450     CONTINUE
 440    CONTINUE
 430   CONTINUE
      ELSE
        MODE=2
        DO 121 I=1,NZ
          IF (ETA(I) .GT. 0.D0) MODE=1
 121    CONTINUE
          IF (MODE .EQ. 1) THEN
            DO 178 I=1,NZ
              N0(I) = (1-N(I))/N(I)
 178        CONTINUE
            IF (DP .GT. 0.D0) THEN
              DV= (1-FMELP)*(ETA(5)/N(5)/DT)*((DP/DT)**N0(5))
              DO 179 I=1,NZ-1
                IF (PHASP(I) .GT. 0.D0)
     &            DV= DV+FMELP*(PHASP(I)/ZALPHP)*(ETA(I)/N(I)/DT)*
     &               ((DP/DT)**N0(I))
 179          CONTINUE
            ELSE
              DV =0.D0
            ENDIF
            IF(OPTION(1:9).EQ.'FULL_MECA')THEN
              RB=HP+DV
            ELSE
              RB=0.D0
            ENDIF
        ELSE
         MODE=2
         IF(OPTION(1:9).EQ.'FULL_MECA')THEN
          RB=HP
         ELSE
          RB=HM
         ENDIF
        ENDIF
       IF((OPTION(1:9).EQ.'FULL_MECA').OR.
     &    ((OPTION(1:14).EQ.'RIGI_MECA_TANG').AND.
     &     (MODE.EQ.2))) THEN

        COEFF5=MU*TRBEL+RB*(1.D0+MU*TRANS*TRBEL)
        COEFF6=-3.D0*MU*TRBEL*(EQTAU-RB*DP)/((EQTAU**3.D0)*COEFF5)
        COEFF6=COEFF6*COEFF2
        COEFF7=-2.D0*COEFF1*RB*(EQTAU*TRANS+DP)/(EQTAU*COEFF5)
        COEFF7=COEFF7*COEFF2
        COEFF8=0.D0
        DO 451 I=1,6
         COEFF8=COEFF8+PDTSCA(I)*DVTAU(I)*DVBEL(I)
  451   CONTINUE
        COEFF9=COEFF1*RB*(EQTAU*TRANS+DP)/EQTAU
     &        +3.D0*MU*COEFF8*(EQTAU-RB*DP)/(2.D0*(EQTAU**3.D0))
        COEFF9=-COEFF9*COEFF3*TRBEL/COEFF5

        DO 455 I=1,3
         DO 456 J1=1,3
          MAT3(I,J1)=0.D0
          DO 457 K=1,3
           MAT3(I,J1)=MAT3(I,J1)+DVTAU(IND(I,K))*MAT1(K,J1)
  457     CONTINUE
  456    CONTINUE
  455   CONTINUE
        DO 460 I=1,6
         DO 470 M=1,3
          DO 480 K=1,3
           DSIGDF(I,M,K)=DSIGDF(I,M,K)+COEFF6*DVTAU(I)*MAT3(M,K)
     &                  +COEFF7*DVTAU(I)*MAT1(M,K)
     &                  +COEFF9*DVTAU(I)*MAT0(M,K)
 480      CONTINUE
 470     CONTINUE
 460    CONTINUE
       ENDIF
      ENDIF
      ENDIF

C CORRECTION SUR TRBE

      IF(OPTION(1:9).EQ.'RAPH_MECA'.OR.
     &  OPTION(1:9).EQ.'FULL_MECA') THEN

       TRTAU=TAUP(1)+TAUP(2)+TAUP(3)
       EQTAU=0.D0
       DO 500 I=1,6
        DVTAU(I)=TAUP(I)-KR(I)*TRTAU/3.D0
        EQTAU=EQTAU+PDTSCA(I)*(DVTAU(I)**2.D0)
 500   CONTINUE
       EQTAU=SQRT(1.5D0*EQTAU)
       JE2=(EQTAU**2.D0)/(3.D0*(MUP**2.D0))
       JE3=DVTAU(1)*(DVTAU(2)*DVTAU(3)-DVTAU(6)*DVTAU(6))
     &   -DVTAU(4)*(DVTAU(4)*DVTAU(3)-DVTAU(5)*DVTAU(6))
     &   +DVTAU(5)*(DVTAU(4)*DVTAU(6)-DVTAU(5)*DVTAU(2))
       JE3=JE3/(MUP**3.D0)
      
       CALL ZEROP3(0.D0,-JE2,JE3-1.D0,SOL,NBR)
       IF (NBR.LE.1) THEN
        XP=SOL(1)
       ELSE
        XP=SOL(1)
        DO 510 I=2,NBR       
         IF ((ABS(SOL(I)-XM)).LT.(ABS(SOL(I-1)-XM))) XP=SOL(I)
 510    CONTINUE
       ENDIF       
       IF (COMPOR(1)(1:4).EQ.'ELAS') THEN
        VIP(1) = 3.D0*(1.D0-(J**(2.D0/3.D0))*XP)/2.D0
       ELSE
        VIP(8) = 3.D0*(1.D0-(J**(2.D0/3.D0))*XP)/2.D0
       ENDIF
           
      ENDIF
            
 9999 CONTINUE      
      
      END
