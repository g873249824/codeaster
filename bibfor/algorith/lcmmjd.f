        SUBROUTINE LCMMJD( TAUR,MATERF,IFA,NMAT,
     &    NBCOMM,DT,IR,IS,NBSYS,NFS,NSG,HSR,VIND,DY,
     &    DPDTAU,DPRDAS,DHRDAS,HR,DPR,SGNR,IRET)
        IMPLICIT NONE
        INTEGER IFA,NMAT,NBCOMM(NMAT,3),NUMHSR,NFS,NSG
        REAL*8 TAUR,MATERF(NMAT*2),RR,DT,VIND(36),DY(12)
        REAL*8 DPDTAU,DPRDAS,HSR(NSG,NSG),HR
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/09/2012   AUTEUR PROIX J-M.PROIX 
C TOLE CRP_21 CRS_1404
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
C RESPONSABLE PROIX J-M.PROIX
C ======================================================================
C  CALCUL DES DERIVEES DES VARIABLES INTERNES DES LOIS MONOCRISTALLINES
C  POUR LA LOI D'ECOULEMENT  DD-CFC
C       IN  TAUR    :  SCISSION REDUITE
C           MATERF  :  PARAMETRES MATERIAU
C           IFA     :  NUMERO DE FAMILLE
C           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           DT      :  INCREMENT DE TEMPS
C           IR,IS   :  NUMEROS DE SYSTEMES DE GLISSEMENT
C           NBSYS   :  NOMBRE DE SYSTEMES DE GLISSEMENT (12 POUR CFC)
C           HSR     :  MATRICE D'INTERACTION
C           VIND,DY :  VARIABLES INTERNES A T ET SOLUTION A T+DT
C     OUT:
C           DPDTAU  :  dpr/dTaur
C           DPRDAS  :  dpr/dAlphas
C           DHRDAS  :  dHr/dAlphaS
C     ----------------------------------------------------------------
      REAL*8 B,N,A,GAMMA0,R8B,DPR,DTRDAS,CRITR,EXPBP(NSG)
      REAL*8 CEFF,DCDALS,SOMS3,SOMS2,SOMS1
      REAL*8 DHRDAS,TAUF,Y,BETA,MU,SOMAAL,ARS,SGNR,T3
      REAL*8 ALPHAP(12)
      INTEGER IFL,IS,NBSYS,IR,IRET,NUECOU,IEI,IU,I,IS3,IR3
      CHARACTER*16 K16B
      INTEGER IRR,DECIRR,NBSYST,DECAL
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL
C     ----------------------------------------------------------------

      IFL=NBCOMM(IFA,1)+NMAT
      NUECOU=NINT(MATERF(IFL))
      IEI=NBCOMM(IFA,3)+NMAT
      IRET=0

      IF (NUECOU.NE.5) THEN
         CALL ASSERT(.FALSE.)
      ENDIF
C             MATRICE JACOBIENNE DU SYSTEME :
C  R1 = D-1*SIGMA - (D_M-1*SIGMA_M)-(DEPS-DEPS_TH)+Somme(ms*Dps*S)=0
C  R2 = dALPHA - Dps*h(alphas)
C avec S=sgn(TAUR)
C
C ON VEUT CALCULER :
C     d(Dps)/dTAUR
      DPDTAU=0.D0
C     d(R1)/dalphas
      HR=0.D0
C     d(R2)/d(alphar)
      DHRDAS=0.D0
C     DPSDAR=d(Dp_s)/d(Alpha_r)
      DPRDAS=0.D0

      TAUF  =MATERF(IFL+1)
      GAMMA0=MATERF(IFL+2)
      A     =MATERF(IFL+3)
      B     =MATERF(IFL+4)
      N     =MATERF(IFL+5)
      Y     =MATERF(IFL+6)
      BETA  =MATERF(IEI+2)
      MU    =MATERF(IEI+4)
      K16B=' '
C     CALCUL de l'�crouissage RR=TAUr_Forest
      CALL LCMMFI(MATERF(NMAT+1),IFA,NMAT,NBCOMM,K16B,IR,
     &      NBSYS,VIND,DECAL,DY,NFS,NSG,HSR,1,EXPBP,RR)
      IF (IRET.GT.0)  GOTO 9999

C     CALCUL de l'�coulement dpr et du crit�re
      CALL LCMMFE(TAUR,MATERF(NMAT+1),MATERF(1),IFA,
     &  NMAT,NBCOMM,K16B,IR,NBSYS,VIND,DY,RR,R8B,R8B,DT,R8B,R8B,
     &  DPR,CRITR,SGNR,NFS,NSG,HSR,IRET)
      IF (IRET.GT.0)  GOTO 9999


C     1. d(Dp_s)/d(Tau_s)
      IF (DPR.GT.0.D0) THEN
        IF (ABS(TAUR).GT.0.D0) THEN
         DPDTAU=N*(DPR+GAMMA0*DT)/TAUR
       ENDIF
      ENDIF

      DO 55 IU=1,NBSYS
         ALPHAP(IU)=VIND(DECAL+3*(IU-1)+1)+DY(IU)
 55   CONTINUE

      CALL LCMMDC(MATERF(NMAT+1),IFA,NMAT,NBCOMM,ALPHAP,IS,CEFF,DCDALS)

      CALL LCMMDH(MATERF(NMAT+1),IFA,NMAT,NBCOMM,ALPHAP,NFS,NSG,HSR,
     &            NBSYS,IR,NUECOU,HR,SOMS1,SOMS2,SOMS3)


      SOMAAL=0.D0
      DO 56 I=1,12
         IF (ALPHAP(I).GT.0.D0) THEN
            SOMAAL=SOMAAL+HSR(IR,I)*ALPHAP(I)
         ENDIF
 56   CONTINUE
      SOMAAL=SQRT(SOMAAL)
      DTRDAS=0.D0

      IF (ALPHAP(IS).GT.0.D0) THEN
         IF (SOMAAL.GT.0.D0) THEN
            DTRDAS=CEFF/2.D0/SOMAAL*HSR(IR,IS)
         ENDIF
      ENDIF
      DTRDAS=DTRDAS + DCDALS*SOMAAL
      DTRDAS=MU*DTRDAS

C     2. d(Dp_r)/d(Omega_s)

      IF (DPR.GT.0.D0) THEN
      DPRDAS=-N*(DPR+GAMMA0*DT)/(TAUF+RR)*DTRDAS
      ENDIF

      ARS=HSR(IR,IS)
      IF (ARS*ALPHAP(IS).GT.0.D0) THEN
      T3=ARS/2.D0/SQRT(ARS*ALPHAP(IS))
      ENDIF

      DHRDAS=0.D0
C     IS APPARTIENT-IL A FOREST(IR) ?
C     division entiere
      IS3=(IS-1)/3
      IR3=(IR-1)/3
      IF (IS3.NE.IR3) THEN
         IF (ALPHAP(IS).GT.0.D0) THEN
         DHRDAS=DHRDAS + A*(SQRT(ARS)/SOMS1)
         ENDIF
      ENDIF

      IF (SOMS1.GT.0.D0) THEN
      DHRDAS=DHRDAS-A*T3*SOMS2/SOMS1/SOMS1
      ENDIF
C     IS APPARTIENT-IL A COPLA(IR) ?
       IF(IS3.EQ.IR3) THEN
         IF (ARS*ALPHAP(IS).GT.0.D0) THEN
         DHRDAS=DHRDAS+B*T3*CEFF
         ENDIF
      ENDIF

      DHRDAS=DHRDAS+B*SOMS3*DCDALS

C     3. d(h_r)/d(Omega_s)
      IF (IS.EQ.IR) DHRDAS=DHRDAS-Y/BETA

 9999 CONTINUE

      END
