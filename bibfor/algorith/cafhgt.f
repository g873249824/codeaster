        SUBROUTINE CAFHGT(OPTION,THMC,HYDR,IMATE,NDIM,DIMDEF,
     +                  DIMCON,NVIMEC,NVITH,YAMEC,YATE,ADDEP1,
     +                  ADDEP2,ADCP11,ADCP12,ADCP21,ADDEME,
     +                  ADDETE,CONGEP,DSDE,P1,P2,GRAP1,GRAP2,
     +                  T,GRAT,PHI,PVP,RHO11,H11,H12,T0,SAT,
     +                  RV0,G1F,J1D,J1F,J1C,J2,J3,G2,PESA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
C RESPONSABLE UFBHHLL C.CHAVANT
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C TOLE CRP_20
C TOLE CRP_21
C
C **********************************************************************
C **********************************************************************
C CLONE CE CALCFH POUR LES LOIS DU CERMES QUI N FIGURENT PLUS
C          DANS CALCFH
C **********************************************************************
C
C  VARIABLES IN / OUT
C
      IMPLICIT NONE
      CHARACTER*16    OPTION,THMC,HYDR
      INTEGER         NDIM,DIMDEF,DIMCON,NVIMEC,NVITH,IMATE
      INTEGER         ADDEME,ADDEP1,ADDEP2,ADDETE
      INTEGER         ADCP11,ADCP12,ADCP21,YAMEC,YATE
      REAL*8          CONGEP(1:DIMCON)
      REAL*8          DSDE(1:DIMCON,1:DIMDEF),PESA(3)
      REAL*8          P1,GRAP1(3),P2,GRAP2(3),T,GRAT(3)
      REAL*8          PHI,PVP,H11,H12,RHO11
      REAL*8          TLANW,TLANA
C
C  VARIABLES LOCALES
C
C
      INTEGER ELA,CJS,ENLGAT,ESUGAT
C
      INTEGER         I
      REAL*8          LAMBD1(5),LAMBD2(5),F(5),VISCO,DVISCO,KREL,DKREL
      REAL*8          R,MAMOLG,MAMOLV,CLIQ,ALPLIQ
      REAL*8          RHO12,RHO21,SAT,DSATP1
C    
      REAL*8   DTV,DPV,DTW,DPW,RV0,HUMR,T0
      REAL*8   COEFG,SIGR,SIGT,COMPW,DSIGT,KINTG
      REAL*8   DATM,DDATT,DDATP2
      REAL*8   DRVDTT,FACTOR,DFACP2,DFACT,HFG
      REAL*8   DRV0DT,DHDSR,DHDN,DHDT,ATMP,HENRY,XKW
      REAL*8   G1F,J1D,J1F,J1C,J2,J3,G2
C
C  DECLARATION POUR RECUPERER LES CONSTANTES MATERIAU
C      
      INTEGER         NLIQ,NGAZ,NVAP,NCON,NHOM,NPAR,NSAT,J,NRESMA
      INTEGER         NCONU
      PARAMETER     ( NLIQ=8,NGAZ=6,NVAP=4,NCON=15,NHOM=7,NSAT=2,NPAR=4)
      PARAMETER     (NCONU = 11)
C  NRESMA = MAX DE NLIQ,NGAZ,NVAP,,NCON,NHOM,NSAT,NPAR
      PARAMETER     ( NRESMA = 18)
      REAL*8          LIQ(NLIQ),GAZ(NGAZ),VAP(NVAP),COND(NCON),HOM(NHOM)
      REAL*8          VALPAR(NPAR),SATUR(NSAT)
      CHARACTER*2     CODRET(NRESMA)
      CHARACTER*8     NCRA1(NLIQ),NCRA2(NGAZ),NCRA3(NVAP)
      CHARACTER*8     NCRA4(NCONU),NCRA5(NHOM),NCRA6(NSAT)
      CHARACTER*8     NOMPAR(NPAR)
C
      INTEGER      NDIFF,NINIG,NCOF
      PARAMETER    (NDIFF=4,NINIG=2,NCOF=1)
      REAL*8       VDIFF(NDIFF),INIGAT(NINIG),COFGAT(NCOF)
      CHARACTER*8  BGCR6(NDIFF),BGCR3(NINIG),BGCR9(NCOF)
C 
C VARIABLES LOCALES PERMETTANT D'EXPRIMER LES DERIVEES DES
C GRADIENTS DES PRESSIONS DE GAZ ET DE VAPEUR
C
C ON UTILISE LES CONVENTIONS SUIVANTES :
C    
C  D = DERIVEE   G = GRADIENT   P = PRESSION VAPEUR
C  C = PVP/PGZ   P1,P2,T 
C 
C   CVP=PVP/PGZ , GP = GRADIENT DE PVP , GC = GRADIENT DE CVP
      REAL*8 CVP,GP(3),GC(3)
C   DERIVEES DE PVP PAR RAPPORT A P1, P2, T
      REAL*8 DPP1,DPP2,DPT
C   DERIVEES DE CVP PAR RAPPORT A P1, P2, T
      REAL*8 DCP1,DCP2,DCT
C   DERIVEES DE RHO11 PAR RAPPORT A P1, P2, T
      REAL*8 DR11P1,DR11P2,DR11T
C   DERIVEES DE RHO12 PAR RAPPORT A P1, P2, T
      REAL*8 DR12P1,DR12P2,DR12T
C   DERIVEES DE RHO21 PAR RAPPORT A P1, P2, T
      REAL*8 DR21P1,DR21P2,DR21T
C   DERIVEES DU TERME AUXILIAIRE PAR RAPPORT A P1, P2, T
C   TERME AUX = RHO12*(H12-H11)/T
      REAL*8 DAUXP1,DAUXP2,DAUXT
C  DERIVEES DU GRADIENT DE PVP PAR RAPPORT A P1, P2, T
      REAL*8 DGPP1(3),DGPP2(3),DGPT(3)
C  DERIVEES DU GRADIENT DE CVP PAR RAPPORT A P1, P2, T
      REAL*8 DGCP1(3),DGCP2(3),DGCT(3)
C  DERIVEES DU GRADIENT DE PVP PAR RAPPORT AUX GRADIENTS DE P1,P2,T
      REAL*8 DGPGP1,DGPGP2,DGPGT
C  DERIVEES DU GRADIENT DE CVP PAR RAPPORT AUX GRADIENTS DE P1,P2,T
      REAL*8 DGCGP1,DGCGP2,DGCGT
C 
C
      DATA NCRA1 / 'RHO','UN_SUR_K','ALPHA','CP',
     &             'VISC','D_VISC_T','LAMBDA','D_LAMBDA' /
      DATA NCRA2 / 'MASS_MOL','CP','VISC','D_VISC_T',
     >             'LAMBDA','D_LAMBDA'/
      DATA NCRA3 / 'MASS_MOL','CP','VISC','D_VISC_T' /
      DATA NCRA4 / 'PERM_IN','PERM_LIQ','D_PERM_L','PERM_GAZ',
     &             'D_PERM_S','D_PERM_P','FICK','D_FICK_T','D_FICK_G',
     &             'LAMBDA','D_LAMBDA'/  
      DATA NCRA5 / 'R_GAZ','RHO','CP','BIOT_COE',
     >             'PESA_X','PESA_Y','PESA_Z' /
      DATA NCRA6 / 'SATU_PRE','D_SATU_P' /
      DATA NOMPAR / 'TEMP','SAT','PORO','PGAZ'/
C
      DATA BGCR3 /'DEGR_SATU','PRES_ATMO'/
      DATA BGCR6 /'SIGMA_T','D_SIGMA_T','PERM_G_INTR','CHAL_VAPO'/
      DATA BGCR9 /'COEF_HENRY'/
C
C     QUELQUES INITIALISATIONS
C
      DO 1 I = 1 , 3
       DGPP1(I)=0.D0
       DGPP2(I)=0.D0
       DGPT(I) =0.D0
       DGCP1(I)=0.D0
       DGCP2(I)=0.D0
       DGCT(I)=0.D0
       GC(I)=0.D0
       GP(I)=0.D0
 1    CONTINUE
       DGPGP1=0.D0
       DGPGP2=0.D0
       DGPGT=0.D0
       DGCGP1=0.D0
       DGCGP2=0.D0
       DGCGT=0.D0
       DPP1=0.D0
       DPP2=0.D0
       DPT=0.D0
       DCP1=0.D0
       DCP2=0.D0
       DCT=0.D0
C **********************************************************************
C   RECUPERATION DES COEFFICIENTS 
C

      CALL RCVALA(IMATE,'THM_DIFFU',1,'ABSC',P1,
     &            NHOM,NCRA5,HOM,CODRET,'FM')
      R      =HOM(1)
      PESA(1)=HOM(5)
      PESA(2)=HOM(6)
      PESA(3)=HOM(7)
      IF (((THMC.EQ.'LIQU_VAPE_GAZ').OR.(THMC.EQ.'LIQU_GAZ')).OR.
     &    (THMC.EQ.'LIQU_GAZ_ATM')) THEN
          IF (HYDR.EQ.'HYDR_UTIL') THEN
             CALL RCVALA(IMATE,'THM_DIFFU',1,'PCAP',P1,NSAT,
     >                   NCRA6,SATUR,CODRET,'FM')
             SAT=SATUR(1)
             DSATP1=SATUR(2)             
          ELSE
              CALL SATURA(HYDR,P1,SAT,DSATP1) 
          ENDIF
      ELSE
       IF ((THMC.NE.'LIQU_NSAT_GAT')) THEN
        SAT = 1.D0
        DSATP1=0.D0
       ENDIF
      ENDIF
      VALPAR(1)=T
      VALPAR(3)=PHI
      
      IF ((THMC.EQ.'GAZ').OR.(THMC.EQ.'LIQU_SATU')
     &          .OR.(THMC.EQ.'LIQU_SATU_GAT')) THEN
         VALPAR(2)=1.D0
      ELSE
         VALPAR(2)=SAT
      ENDIF
      VALPAR(4)=P2
C
      IF (HYDR.EQ.'HYDR_UTIL') THEN
          CALL RCVALA(IMATE,'THM_DIFFU',NPAR,NOMPAR,VALPAR,
     &             NCONU,NCRA4,COND,CODRET,'FM')
          CALL RCVALA(IMATE,'THM_LIQU',NPAR,NOMPAR,VALPAR,
     &             2,NCRA1(7),COND(12),CODRET,'FM')
          CALL RCVALA(IMATE,'THM_GAZ',NPAR,NOMPAR,VALPAR,
     &             2,NCRA2(5),COND(14),CODRET,'FM')
      ELSE
          CALL PERMEA(IMATE,HYDR,PHI,T,SAT,NCON,COND)
      ENDIF
      
      IF (THMC.EQ.'LIQU_SATU') THEN
         CALL RCVALA(IMATE,'THM_LIQU',1,'TEMP',T,NLIQ,NCRA1,
     &               LIQ,CODRET,'FM')
         CLIQ=LIQ(2)
         ALPLIQ=LIQ(3)
         VISCO=LIQ(5)
         DVISCO=LIQ(6)
         KREL=1.D0
         DKREL=0.D0
      ENDIF
      IF (THMC.EQ.'LIQU_SATU_GAT') THEN
         CALL RCVALA(IMATE,'THM_LIQU',1,'TEMP',T,NLIQ,NCRA1,
     &               LIQ,CODRET,'FM')
         CLIQ=LIQ(2)
         ALPLIQ=LIQ(3)
         VISCO=LIQ(5)
         DVISCO=LIQ(6)
         KREL=1.D0
         DKREL=0.D0
            CALL RCVALA(IMATE,'THM_AIR_DISS',0,' ',0.D0,NCOF,BGCR9,
     &               COFGAT,CODRET,'FM')
            HENRY=COFGAT(1)
C
C     CALCUL DE LA COMPRESSIBILITE DU FLUIDE
C
      COMPW=CLIQ
      IF(COMPW.GT.0.D0) GO TO 10
      IF(SAT.GE.0.999D0) GO TO 10
      CALL RCVALA(IMATE,'THM_INIT',0,' ',0.D0,NINIG,BGCR3,
     &               INIGAT,CODRET,'FM')
      ATMP = INIGAT(2)
      COMPW=(1.D0-SAT+SAT*HENRY)*ATMP/(ATMP+P1)**2.D0
10    CONTINUE
C
      ENDIF
C      
      IF (THMC.EQ.'GAZ') THEN
         CALL RCVALA(IMATE,'THM_GAZ',1,'TEMP',T,NGAZ,NCRA2,
     &               GAZ,CODRET,'FM')
         MAMOLG=GAZ(1)
         VISCO=GAZ(3)
         DVISCO=GAZ(4)
         KREL=1.D0
         DKREL=0.D0
      ENDIF
      IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
         CALL RCVALA(IMATE,'THM_LIQU',1,'TEMP',T,NLIQ,NCRA1,
     &               LIQ,CODRET,'FM')
         CLIQ=LIQ(2)
         ALPLIQ=LIQ(3)
         VISCO=LIQ(5)
         DVISCO=LIQ(6)
         KREL=COND(2)
         DKREL=COND(3)*DSATP1
      ENDIF
C
      IF ((THMC.EQ.'LIQU_VAPE_GAZ').OR.(THMC.EQ.'LIQU_GAZ')) THEN
         CALL RCVALA(IMATE,'THM_LIQU',1,'TEMP',T,NLIQ,NCRA1,
     &               LIQ,CODRET,'FM')
         CALL RCVALA(IMATE,'THM_VAPE_GAZ',1,'TEMP',T,NVAP,NCRA3,
     &               VAP,CODRET,'FM')
         CALL RCVALA(IMATE,'THM_GAZ',1,'TEMP',T,NGAZ,NCRA2,
     &               GAZ,CODRET,'FM')
         CLIQ=LIQ(2)
         ALPLIQ=LIQ(3)
         MAMOLG=GAZ(1)
         IF (THMC.EQ.'LIQU_VAPE_GAZ') MAMOLV=VAP(1)
         KREL=COND(2)
         DKREL=COND(3)*DSATP1
         VISCO=LIQ(5)
         DVISCO=LIQ(6)
C
         F(1)=COND(7)
         F(2)=0.D0
         F(3)=0.D0
         F(4)=COND(9)
         F(5)=COND(8)
C
C  LAMBD2(1) = CONDUC_HYDRO_GAZ
C  LAMBD2(2) = D(CONDUC_HYDRO_GAZ)/DP1
C  LAMBD2(3) = D(CONDUC_HYDRO_GAZ)/DP2
C  LAMBD2(4) = D(CONDUC_HYDRO_GAZ)/DT
C
         LAMBD2(1)=COND(1)*COND(4)/GAZ(3)
         LAMBD2(2)=0.D0
         LAMBD2(3)=COND(1)*COND(5)*DSATP1/GAZ(3)
         LAMBD2(4)=COND(1)*COND(6)/GAZ(3)
         LAMBD2(5)=-COND(1)*COND(4)/GAZ(3)/GAZ(3)*GAZ(4)         
      ENDIF
C
      IF ((THMC.EQ.'LIQU_NSAT_GAT')) THEN
C
         CALL RCVALA(IMATE,'THM_LIQU',1,'TEMP',T,NLIQ,NCRA1,
     &               LIQ,CODRET,'FM')
         CALL RCVALA(IMATE,'THM_VAPE_GAZ',1,'TEMP',T,NVAP,NCRA3,
     &               VAP,CODRET,'FM')
         CALL RCVALA(IMATE,'THM_GAZ',1,'TEMP',T,NGAZ,NCRA2,
     &               GAZ,CODRET,'FM')
         CLIQ=LIQ(2)
         ALPLIQ=LIQ(3)
         VISCO=LIQ(5)
         DVISCO=LIQ(6)
         TLANW=LIQ(7)
         MAMOLG=GAZ(1)
         TLANA=GAZ(5)
         MAMOLV=VAP(1)
         CALL RCVALA(IMATE,'THM_DIFFU',NPAR,NOMPAR,VALPAR,
     &             NCONU,NCRA4,COND,CODRET,'FM')
         KREL=COND(2)
         DKREL=COND(3)*(G1F-G2)
            CALL RCVALA(IMATE,'THM_AIR_DISS',0,' ',0.D0,NCOF,BGCR9,
     &               COFGAT,CODRET,'FM')
            HENRY=COFGAT(1)
            CALL RCVALA(IMATE,'THM_INIT',0,' ',0.D0,NINIG,BGCR3,
     &               INIGAT,CODRET,'FM')
            ATMP = INIGAT(2)
          CALL RCVALA(IMATE,'THM_DIFFU',1,'PSIG',T,NDIFF,
     &            BGCR6,VDIFF,CODRET,'FM')
         SIGT =VDIFF(1)
         DSIGT=VDIFF(2)
         CALL RCVALA(IMATE,'THM_DIFFU',NPAR,NOMPAR,VALPAR,NDIFF,
     &            BGCR6,VDIFF,CODRET,'FM')
         KINTG=VDIFF(3)
         HFG=VDIFF(4)
         CALL RCVALA(IMATE,'THM_DIFFU',1,'PSIG',T0,NDIFF,
     &            BGCR6,VDIFF,CODRET,'FM')
         SIGR =VDIFF(1)
         LAMBD2(1)=KINTG*COND(4)/GAZ(3)
         LAMBD2(2)=0.D0
         LAMBD2(3)=KINTG*COND(5)*(G1F-G2)/GAZ(3)
         LAMBD2(4)=KINTG*COND(6)/GAZ(3)
         LAMBD2(5)=-KINTG*COND(4)/GAZ(3)/GAZ(3)*GAZ(4)
C
          XKW= COND(1)*KREL/VISCO       
            CALL  MCONDT(PHI,SAT,T,P1,P2,R,MAMOLV,MAMOLG,
     &                 RHO12,RHO21,RV0,
     &                 RHO11,ATMP,XKW,DTV,
     &                 DPV,DTW,DPW,DATM,DDATT,DDATP2,
     &                 DRV0DT,DHDSR,DHDN,DHDT,DRVDTT,FACTOR,
     &                 DFACP2,DFACT,COEFG,
     &                 HUMR,HFG,SIGR,SIGT,DSIGT,TLANW,TLANA)
C
      ENDIF
C
C
C
C
      LAMBD1(1)=COND(1)*KREL/VISCO
      LAMBD1(2)=0.D0
      LAMBD1(3)=COND(1)*DKREL/VISCO
      LAMBD1(4)=0.D0
      LAMBD1(5)=-COND(1)*KREL/VISCO/VISCO*DVISCO   
C
C **********************************************************************
C  CALCUL DES MASSES VOLUMIQUES, PRESSION DE VAPEUR, GRADIENTS DE VAPEUR
C
C
      IF (THMC.EQ.'LIQU_VAPE_GAZ') THEN
         RHO12=MAMOLV*PVP/R/T
         RHO21=MAMOLG*(P2-PVP)/R/T
         CVP=PVP/P2
         DO 100 I=1,NDIM
            GP(I)=RHO12/RHO11*(GRAP2(I)-GRAP1(I))
            IF (YATE.EQ.1) THEN
               GP(I)=GP(I)+RHO12*(H12-H11)/T*GRAT(I)
            ENDIF
            GC(I)=GP(I)/P2-PVP/P2/P2*GRAP2(I)
 100     CONTINUE
      ENDIF
      IF (THMC.EQ.'LIQU_GAZ') THEN
         RHO21=MAMOLG*P2/R/T
         RHO12=0.D0
         DR12P1=0.D0
         DR12P2=0.D0
         DR12T=0.D0
         CVP=0.D0
      ENDIF
C
C **********************************************************************
C CALCUL DES DERIVEES DES PRESSIONS DE VAPEUR 
C
      IF ((OPTION(1:16).EQ.'RIGI_MECA_TANG').OR.
     &   (OPTION(1:9).EQ.'FULL_MECA')) THEN
         IF (THMC.EQ.'LIQU_VAPE_GAZ') THEN
            DPP1=-RHO12/RHO11
            DPP2=RHO12/RHO11
            IF (YATE.EQ.1) THEN
               DPT=RHO12*(H12-H11)/T
            ENDIF
            DCP1=DPP1/P2
            DCP2=DPP2/P2-PVP/P2/P2
            IF (YATE.EQ.1) THEN
               DCT=DPT/P2
            ENDIF
         ENDIF
      ENDIF
C
C **********************************************************************
C CALCUL DES DERIVEES DES MASSES VOLUMIQUES ET DU TERME AUXILIAIRE
C
      IF ((OPTION(1:16).EQ.'RIGI_MECA_TANG').OR.
     &   (OPTION(1:9).EQ.'FULL_MECA')) THEN
         IF (THMC.EQ.'LIQU_SATU') THEN
            DR11P1=RHO11*CLIQ
            IF (YATE.EQ.1) THEN
               DR11T=-3.D0*ALPLIQ*RHO11
            ENDIF
         ENDIF
         IF (THMC.EQ.'LIQU_SATU_GAT') THEN
            DR11P1=RHO11*COMPW
            IF (YATE.EQ.1) THEN
               DR11T=-3.D0*ALPLIQ*RHO11
            ENDIF
         ENDIF
         IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
            DR11P1=-RHO11*CLIQ
            IF (YATE.EQ.1) THEN
               DR11T=-3.D0*ALPLIQ*RHO11
            ENDIF
         ENDIF
         IF (THMC.EQ.'GAZ') THEN
            DR11P1=RHO11/P1
            IF (YATE.EQ.1) THEN
               DR11T=-RHO11/T
            ENDIF
         ENDIF
         IF (THMC.EQ.'LIQU_GAZ') THEN
            DR11P1=-RHO11*CLIQ
            DR11P2= RHO11*CLIQ
            DR11T=-3.D0*ALPLIQ*RHO11
            DR21P1= 0.D0
            DR21P2= RHO21/P2
            DR21T=-RHO21/T
         ENDIF
         IF (THMC.EQ.'LIQU_VAPE_GAZ') THEN
            DR11P1=-RHO11*CLIQ
            DR11P2= RHO11*CLIQ
     
            DR12P1=RHO12/PVP*DPP1
            DR12P2=RHO12/PVP*DPP2
     
            DR21P1=RHO21/(P2-PVP)*(-DPP1)
            DR21P2=RHO21/(P2-PVP)*(1.D0-DPP2)
     
            IF (YATE.EQ.1) THEN
               DR11T=-3.D0*ALPLIQ*RHO11
               DR12T=RHO12*(DPT/PVP-1.D0/T)
               DR21T=RHO21*(-DPT/(P2-PVP)-1.D0/T)
C    
C TERME AUXILIAIRE 

               DAUXP1=(H12-H11)/T*DR12P1
     &                  +RHO12/T*(DSDE(ADCP12+NDIM+1,ADDEP1)
     &                  -DSDE(ADCP11+NDIM+1,ADDEP1))
               DAUXP2=(H12-H11)/T*DR12P2
     &                  +RHO12/T*(DSDE(ADCP12+NDIM+1,ADDEP2)
     &                  -DSDE(ADCP11+NDIM+1,ADDEP2))
               DAUXT=(H12-H11)/T*DR12T
     &                  +RHO12/T*(DSDE(ADCP12+NDIM+1,ADDETE)-
     &                   DSDE(ADCP11+NDIM+1,ADDETE))-RHO12*(H12-H11)/T/T
            ENDIF
C
C
C **********************************************************************
C CALCUL DES DERIVEES DE GRADPVP ET GRADCVP
C
            DO 101 I=1,NDIM
               DGPP1(I)=(GRAP2(I)-GRAP1(I))/RHO11*DR12P1
               DGPP1(I)=DGPP1(I)-(GRAP2(I)-GRAP1(I))*RHO12/RHO11/RHO11
     &                           *DR11P1
               DGPP2(I)=(GRAP2(I)-GRAP1(I))/RHO11*DR12P2
               DGPP2(I)=DGPP2(I)-(GRAP2(I)-GRAP1(I))*RHO12/RHO11/RHO11
     &                           *DR11P2
               IF (YATE.EQ.1) THEN
                  DGPP1(I)=DGPP1(I)+DAUXP1*GRAT(I)
                  DGPP2(I)=DGPP2(I)+DAUXP2*GRAT(I)
                  DGPT(I)=(GRAP2(I)-GRAP1(I))/RHO11*DR12T
     &                           +DAUXT*GRAT(I)
                  DGPT(I)=DGPT(I)-(GRAP2(I)-GRAP1(I))*RHO12/RHO11/RHO11
     &                           *DR11T
               ENDIF
               DGPGP1=-RHO12/RHO11
               DGPGP2=RHO12/RHO11
               IF (YATE.EQ.1) THEN
                  DGPGT=RHO12*(H12-H11)/T
               ENDIF
C **********************************************************************
C DERIVEES DE GRADCVP
C
               DGCP1(I)=DGPP1(I)/P2
     &                     -GRAP2(I)/P2/P2*DPP1
               DGCP2(I)=DGPP2(I)/P2
     &                     -GP(I)/P2/P2-GRAP2(I)/P2/P2*DPP2
     &                     +2.D0*PVP*GRAP2(I)/P2/P2/P2
               IF (YATE.EQ.1) THEN
                  DGCT(I)=DGPT(I)/P2
     &                     -GRAP2(I)/P2/P2*DPT
               ENDIF
               DGCGP1=DGPGP1/P2
               DGCGP2=DGPGP2/P2-PVP/P2/P2
               IF (YATE.EQ.1) THEN
                  DGCGT=DGPGT/P2
               ENDIF     
 101        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_NSAT_GAT') THEN
C
C  CALCUL DES DERIVEES DES MASSES VOLUMIQUES
C
            DR11P1=RHO11*CLIQ
            DR11P2=0.D0

            DR12P1=RV0*(DHDN*(J1F-J2)+DHDSR*(G1F-G2))
            DR12P2=RV0*(-DHDN*(J1F-J2)-DHDSR*(G1F-G2))

            DR21P1=-DR12P1
            DR21P2=MAMOLG/R/T-DR12P2

            IF (YATE.EQ.1) THEN
               DR11T=-3.D0*ALPLIQ*RHO11
               DR12T=DRV0DT*(HUMR+RV0*DHDT)
               DR21T=-P2*MAMOLG/R/T/T-DR12T
            ENDIF
         ENDIF
      ENDIF  
C
C
C **********************************************************************
C CALCUL DES FLUX HYDRAULIQUES
C
      IF ((OPTION(1:9).EQ.'RAPH_MECA').OR.
     &   (OPTION(1:9).EQ.'FULL_MECA')) THEN 
         IF (((THMC.EQ.'LIQU_SATU').OR.(THMC.EQ.'GAZ')).OR.
     &        (THMC.EQ.'LIQU_GAZ_ATM')
     &        .OR.(THMC.EQ.'LIQU_SATU_GAT')) THEN
            DO 102 I=1,NDIM
              IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
                 CONGEP(ADCP11+I)=RHO11*LAMBD1(1)
     &                         *(GRAP1(I)+RHO11*PESA(I))
              ELSE 
                 CONGEP(ADCP11+I)=RHO11*LAMBD1(1)
     &                         *(-GRAP1(I)+RHO11*PESA(I))
              ENDIF
 102        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_VAPE_GAZ') THEN
            DO 103 I=1,NDIM
               CONGEP(ADCP11+I)=RHO11*LAMBD1(1)
     &                          *(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
               CONGEP(ADCP12+I)=RHO12*LAMBD2(1)
     &                          *(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
     &                          -RHO12*(1.D0-CVP)*F(1)*GC(I)
               CONGEP(ADCP21+I)=RHO21*LAMBD2(1)
     &                          *(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
     &                          +RHO21*CVP*F(1)*GC(I)
 103        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_NSAT_GAT') THEN
            DO 113 I=1,NDIM
               CONGEP(ADCP11+I)=RHO11*(-DTW*GRAT(I)
     &              -DPW*(GRAP1(I))+RHO11*LAMBD1(1)*PESA(I))
               CONGEP(ADCP12+I)=RHO11*(-DTV*GRAT(I)
     &              -DPV*(GRAP1(I)-GRAP2(I)))
               CONGEP(ADCP21+I)=RHO21*LAMBD2(1)
     &               *(-GRAP2(I)+RHO21*PESA(I))
     &              +RHO21*HENRY*(-DTW*GRAT(I)
     &              -DPW*(GRAP1(I))+RHO11*LAMBD1(1)*PESA(I))
 113        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_GAZ') THEN
            DO 104 I=1,NDIM
               CONGEP(ADCP11+I)=RHO11*LAMBD1(1)
     &                          *(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
               CONGEP(ADCP21+I)=RHO21*LAMBD2(1)
     &                          *(-GRAP2(I)+RHO21*PESA(I))
 104        CONTINUE
         ENDIF
      ENDIF
C
C
      IF ((OPTION(1:16).EQ.'RIGI_MECA_TANG').OR.
     &   (OPTION(1:9).EQ.'FULL_MECA')) THEN
         IF ((THMC.EQ.'LIQU_SATU').OR.(THMC.EQ.'GAZ').OR.
     &        (THMC.EQ.'LIQU_GAZ_ATM')
     &          .OR.(THMC.EQ.'LIQU_SATU_GAT')) THEN
            DO 108 I=1,NDIM
               IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
                  DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +DR11P1*LAMBD1(1)*(GRAP1(I)+RHO11*PESA(I))
                  DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +RHO11*LAMBD1(3)*(GRAP1(I)+RHO11*PESA(I))
                  DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +RHO11*LAMBD1(1)*(DR11P1*PESA(I))
                  DSDE(ADCP11+I,ADDEP1+I)=DSDE(ADCP11+I,ADDEP1+I)
     &             +RHO11*LAMBD1(1)
               ELSE
                 DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +DR11P1*LAMBD1(1)*(-GRAP1(I)+RHO11*PESA(I))
                 DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +RHO11*LAMBD1(3)*(-GRAP1(I)+RHO11*PESA(I))
                 DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &             +RHO11*LAMBD1(1)*(DR11P1*PESA(I))
                 DSDE(ADCP11+I,ADDEP1+I)=DSDE(ADCP11+I,ADDEP1+I)
     &             -RHO11*LAMBD1(1)
               ENDIF
               IF (YAMEC.EQ.1) THEN
                  DO 107 J=1,3
                     IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
                        DSDE(ADCP11+I,ADDEME+NDIM-1+I)=
     &                     DSDE(ADCP11+I,ADDEME+NDIM-1+I)
     &                     +RHO11*LAMBD1(2)*(GRAP1(I)+RHO11*PESA(I))
                     ELSE
                       DSDE(ADCP11+I,ADDEME+NDIM-1+I)=
     &                     DSDE(ADCP11+I,ADDEME+NDIM-1+I)
     &                     +RHO11*LAMBD1(2)*(-GRAP1(I)+RHO11*PESA(I))
                     ENDIF                        
 107              CONTINUE
               ENDIF
C       
               IF (YATE.EQ.1) THEN 
                  IF (THMC.EQ.'LIQU_GAZ_ATM') THEN
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +DR11T*LAMBD1(1)*(GRAP1(I)+RHO11*PESA(I))
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +RHO11*LAMBD1(5)*(GRAP1(I)+RHO11*PESA(I))
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +RHO11*LAMBD1(1)*(DR11T*PESA(I))
                  ELSE
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +DR11T*LAMBD1(1)*(-GRAP1(I)+RHO11*PESA(I))
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +RHO11*LAMBD1(5)*(-GRAP1(I)+RHO11*PESA(I))
                    DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &               +RHO11*LAMBD1(1)*(DR11T*PESA(I))
                  ENDIF        
               ENDIF
 108        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_VAPE_GAZ'.OR.
     >       THMC.EQ.'LIQU_GAZ') THEN
            DO 105 I=1,NDIM
C     
C DERIVEE DU FLUX LIQUIDE
C
               DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &           +DR11P1*LAMBD1(1)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
     &           +RHO11*LAMBD1(1)*(DR11P1*PESA(I))
     &           +RHO11*LAMBD1(3)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
               DSDE(ADCP11+I,ADDEP2)=DSDE(ADCP11+I,ADDEP2)
     &           +DR11P2*LAMBD1(1)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
     &           +RHO11*LAMBD1(1)*(DR11P2*PESA(I))
     &           +RHO11*LAMBD1(4)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
               DSDE(ADCP11+I,ADDEP1+I)=DSDE(ADCP11+I,ADDEP1+I)
     &           +RHO11*LAMBD1(1)
               DSDE(ADCP11+I,ADDEP2+I)=DSDE(ADCP11+I,ADDEP2+I)
     &           -RHO11*LAMBD1(1)
C
C DERIVEE DU FLUX DE VAPEUR
C 
               IF (THMC.EQ.'LIQU_VAPE_GAZ') THEN              
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           +DR12P1*LAMBD2(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))    
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           +RHO12*LAMBD2(3)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           +RHO12*LAMBD2(1)*((DR12P1+DR21P1)*PESA(I))
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           -DR12P1*(1.D0-CVP)*F(1)*GC(I)
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           +RHO12*(DCP1)*F(1)*GC(I)
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           -RHO12*(1.D0-CVP)*F(3)*GC(I)
                DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           -RHO12*(1.D0-CVP)*F(1)*DGCP1(I)
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           +DR12P2*LAMBD2(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           +RHO12*LAMBD2(4)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           +RHO12*LAMBD2(1)*((DR12P2+DR21P2)*PESA(I))
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           -DR12P2*(1.D0-CVP)*F(1)*GC(I)
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           +RHO12*(DCP2)*F(1)*GC(I)
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           -RHO12*(1.D0-CVP)*F(4)*GC(I)
                DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           -RHO12*(1.D0-CVP)*F(1)*DGCP2(I)
                DSDE(ADCP12+I,ADDEP1+I)=DSDE(ADCP12+I,ADDEP1+I)
     &           -RHO12*(1.D0-CVP)*F(1)*DGCGP1
                DSDE(ADCP12+I,ADDEP2+I)=DSDE(ADCP12+I,ADDEP2+I)
     &           -RHO12*LAMBD2(1)-RHO12*(1.D0-CVP)*F(1)*DGCGP2
               ENDIF
C       
C DERIVEE DU FLUX D'AIR SEC
C
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +DR21P1*LAMBD2(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +RHO21*LAMBD2(3)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +RHO21*LAMBD2(1)*((DR12P1+DR21P1)*PESA(I))
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +DR21P1*CVP*F(1)*GC(I)
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +RHO21*(DCP1)*F(1)*GC(I)
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +RHO21*CVP*F(3)*GC(I)
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &           +RHO21*CVP*F(1)*DGCP1(I)
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +DR21P2*LAMBD2(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +RHO21*LAMBD2(4)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +RHO21*LAMBD2(1)*((DR12P2+DR21P2)*PESA(I))
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +DR21P2*CVP*F(1)*GC(I)
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +RHO21*(DCP2)*F(1)*GC(I)
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +RHO21*CVP*F(4)*GC(I)
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &           +RHO21*CVP*F(1)*DGCP2(I)
               DSDE(ADCP21+I,ADDEP1+I)=DSDE(ADCP21+I,ADDEP1+I)
     &           +RHO21*CVP*F(1)*DGCGP1
               DSDE(ADCP21+I,ADDEP2+I)=DSDE(ADCP21+I,ADDEP2+I)
     &           -RHO21*LAMBD2(1)+RHO21*CVP*F(1)*DGCGP2
C
C TERMES COMPLEMENTAIRES DE MECANIQUE ET THERMIQUE
C      
               IF (YAMEC.EQ.1) THEN
                  DO 106 J=1,3
                     DSDE(ADCP11+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP11+I,ADDEME+NDIM-1+J)
     &               +RHO11*LAMBD1(2)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
                     DSDE(ADCP12+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP12+I,ADDEME+NDIM-1+J)
     &                +RHO12*LAMBD2(2)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                     DSDE(ADCP12+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP12+I,ADDEME+NDIM-1+J)
     &                 -RHO12*(1.D0-CVP)*F(2)*GC(I)
                     DSDE(ADCP21+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP21+I,ADDEME+NDIM-1+J)
     &                +RHO21*LAMBD2(2)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                     DSDE(ADCP21+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP21+I,ADDEME+NDIM-1+J)
     &                +RHO21*CVP*F(2)*GC(I)
 106              CONTINUE
C           
               ENDIF
C       
               IF (YATE.EQ.1) THEN
                  DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &              +DR11T*LAMBD1(1)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
     &              +RHO11*LAMBD1(5)*(-GRAP2(I)+GRAP1(I)+RHO11*PESA(I))
     &              +RHO11*LAMBD1(1)*DR11T*PESA(I)
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              +DR12T*LAMBD1(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              +RHO12*LAMBD1(5)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              +RHO12*LAMBD1(1)*((DR12T+DR21T)*PESA(I))
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              -DR12T*(1.D0-CVP)*F(1)*GC(I)
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              +RHO12*DCT*F(1)*GC(I)
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              -RHO12*(1.D0-CVP)*F(5)*GC(I)
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &              -RHO12*(1.D0-CVP)*F(1)*DGCT(I)
                  DSDE(ADCP12+I,ADDETE+I)=DSDE(ADCP12+I,ADDETE+I)
     &              -RHO12*(1.D0-CVP)*F(1)*DGCGT
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +DR21T*LAMBD1(1)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +RHO21*LAMBD1(5)*(-GRAP2(I)+(RHO12+RHO21)*PESA(I))
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +RHO21*LAMBD1(1)*((DR12T+DR21T)*PESA(I))
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +DR21T*CVP*F(1)*GC(I)
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +RHO21*DCT*F(1)*GC(I)
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +RHO21*CVP*F(5)*GC(I)
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              +RHO21*CVP*F(1)*DGCT(I)
                  DSDE(ADCP21+I,ADDETE+I)=DSDE(ADCP21+I,ADDETE+I)
     &              +RHO21*CVP*F(1)*DGCGT
               ENDIF
C            
 105        CONTINUE
         ENDIF
         IF (THMC.EQ.'LIQU_NSAT_GAT') THEN
            DO 115 I=1,NDIM
C     
C DERIVEE DU FLUX LIQUIDE
C
C         DM11/DP1
               DSDE(ADCP11+I,ADDEP1)=DSDE(ADCP11+I,ADDEP1)
     &           -RHO11*((LAMBD1(3)*(P1)*DSIGT/SIGR
     &                   +LAMBD1(1)*DSIGT/SIGR)*GRAT(I)
     &           +LAMBD1(3)*SIGT/SIGR*(GRAP1(I))
     &           -(RHO11*LAMBD1(3)+LAMBD1(1)*DR11P1)*PESA(I))
     &           -DR11P1*(DTW*GRAT(I)+DPW*(GRAP1(I))
     &             -2.D0*RHO11*LAMBD1(1)*PESA(I))     

C         DM11/DP2
               DSDE(ADCP11+I,ADDEP2)=DSDE(ADCP11+I,ADDEP2)
C         DM11/DGRAD(P1)
               DSDE(ADCP11+I,ADDEP1+I)=DSDE(ADCP11+I,ADDEP1+I)
     &           -RHO11*DPW
C         DM11/DGRAD(P2)
               DSDE(ADCP11+I,ADDEP2+I)=DSDE(ADCP11+I,ADDEP2+I)
C O.K.
C
C DERIVEE DU FLUX DE VAPEUR
C
C         DM12/DP1               
               DSDE(ADCP12+I,ADDEP1)=DSDE(ADCP12+I,ADDEP1)
     &           +(J2-J1F)*DATM*DRV0DT*COEFG*FACTOR*(HUMR+DHDN*PHI)
     &                    *GRAT(I)
     &           +((J2-J1F)*DATM*FACTOR*SIGT/SIGR*MAMOLV/R/T/RHO11
     &                    *(RHO12+RV0*DHDN*PHI)
     &           +RHO12*DATM*FACTOR*PHI*SIGT/SIGR*MAMOLV/R/T
     &                    *DR11P1/RHO11/RHO11)*(GRAP1(I)-GRAP2(I))
C        DM12/DP2
               DSDE(ADCP12+I,ADDEP2)=DSDE(ADCP12+I,ADDEP2)
     &           -(RHO12*SIGT/SIGR*MAMOLV/R/T/RHO11*(PHI*FACTOR*DDATP2
     &              +DATM*PHI*DFACP2+DATM*FACTOR*(J2-J1F))
     &           +DR12P2*SIGT/SIGR*MAMOLV/R/T/RHO11*DATM*PHI*FACTOR)
     &                    *(GRAP1(I)-GRAP2(I))
     &           -(HUMR*COEFG*DRV0DT*(PHI*FACTOR*DDATP2
     &              +DATM*PHI*DFACP2+DATM*FACTOR*(J2-J1F))
     &             +DATM*FACTOR*PHI*DHDN*(J2-J1F)*COEFG*DRV0DT)
     &                    *GRAT(I)
C        DM12/GRAD(P1) 
               DSDE(ADCP12+I,ADDEP1+I)=DSDE(ADCP12+I,ADDEP1+I)
     &           -RHO11*DPV
C        DM12/GRAD(P2)
               DSDE(ADCP12+I,ADDEP2+I)=DSDE(ADCP12+I,ADDEP2+I)
     &           +RHO11*DPV
C       
C DERIVEE DU FLUX D'AIR SEC
C
C      DM21/DP1
               DSDE(ADCP21+I,ADDEP1)=DSDE(ADCP21+I,ADDEP1)
     &         -(LAMBD2(3)*RHO21+LAMBD2(1)*DR21P1)*(GRAP2(I)
     &         -RHO21*PESA(I))
     &         +HENRY*RHO21/RHO11*(-RHO11*((LAMBD1(3)*(P1)*
     &              DSIGT/SIGR+LAMBD1(1)*DSIGT/SIGR)*GRAT(I)
     &           +LAMBD1(3)*SIGT/SIGR*(GRAP1(I))
     &           -(RHO11*LAMBD1(3)+LAMBD1(1)*DR11P1)*PESA(I))
     &           -DR21P1*(DTW*GRAT(I)+DPW*(GRAP1(I))
     &             -2.D0*RHO11*LAMBD1(1)*PESA(I))) 
C      DM21/DP2
               DSDE(ADCP21+I,ADDEP2)=DSDE(ADCP21+I,ADDEP2)
     &          -(LAMBD2(4)*RHO21+LAMBD2(1)*DR21P2)
     &         *(GRAP2(I)-RHO21*PESA(I))
C      DM21/DGRADP1
               DSDE(ADCP21+I,ADDEP1+I)=DSDE(ADCP21+I,ADDEP1+I)
     &           -RHO21*HENRY*DPW
C      DM21/DGRADP2
               DSDE(ADCP21+I,ADDEP2+I)=DSDE(ADCP21+I,ADDEP2+I)
     &           -RHO21*LAMBD2(1)
C
C TERMES COMPLEMENTAIRES DE MECANIQUE ET THERMIQUE
C      
               IF (YAMEC.EQ.1) THEN
                  DO 116 J=1,3
C      DM11/D(EPSILON)
                     DSDE(ADCP11+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP11+I,ADDEME+NDIM-1+J)
     &                    -RHO11*LAMBD1(2)*(((P1)*DSIGT/SIGR)*GRAT(I)
     &                    +SIGT/SIGR*(GRAP1(I))
     &                    -RHO11*PESA(I))

C      DM12/D(EPSILON)
                     DSDE(ADCP12+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP12+I,ADDEME+NDIM-1+J)
     &                -J1D*DATM*DRV0DT*COEFG*FACTOR*(HUMR+DHDN*PHI)
     &                    *GRAT(I)
     &                -J1D*DATM*FACTOR*SIGT/SIGR*MAMOLV/R/T/RHO11
     &                    *(RHO12+RV0*DHDN*PHI)*(GRAP1(I)-GRAP2(I)) 
C      DM21/D(EPSILON)
                     DSDE(ADCP21+I,ADDEME+NDIM-1+J)=
     &               DSDE(ADCP21+I,ADDEME+NDIM-1+J)
     &        -(LAMBD2(2)*RHO21)*(GRAP2(I)-RHO21*PESA(I))
     &        -HENRY*RHO21*LAMBD1(2)*(((P1)*DSIGT/SIGR)*GRAT(I)
     &                    +SIGT/SIGR*(GRAP1(I))
     &                    -RHO11*PESA(I))
 116              CONTINUE
C           
               ENDIF
C       
               IF (YATE.EQ.1) THEN
C       DM11/DT
                  DSDE(ADCP11+I,ADDETE)=DSDE(ADCP11+I,ADDETE)
     &                 -RHO11*((LAMBD1(5)*(P1)*DSIGT/SIGR)*GRAT(I)
     &                 +(LAMBD1(5)*SIGT/SIGR
     &                        +LAMBD1(1)*DSIGT/SIGR)*(GRAP1(I))
     &                 -(RHO11*LAMBD1(5)+LAMBD1(1)*DR11T)*PESA(I))
     &                 -DR11T*(DTW*GRAT(I)+DPW*(GRAP1(I))
     &                 -2.D0*RHO11*LAMBD1(1)*PESA(I))
C      DM11/DGRADT
                  DSDE(ADCP11+I,ADDETE+I)=DSDE(ADCP11+I,ADDETE+I)
     &                 -RHO11*DTW
C       DM12/DT
                  DSDE(ADCP12+I,ADDETE)=DSDE(ADCP12+I,ADDETE)
     &             -(RHO12*SIGT/SIGR*MAMOLV/R/T/RHO11*(PHI*FACTOR*DDATT
     &              +DATM*FACTOR*(J3-J1C))
     &             +DR12T*SIGT/SIGR*MAMOLV/R/T/RHO11*DATM*PHI*FACTOR
     &             -DATM*PHI*FACTOR*RHO12*SIGT/SIGR*MAMOLV/R/T*DR11T
     &             /RHO11/RHO11+DATM*PHI*FACTOR*RHO12*MAMOLV/R/T/RHO11
     &                   *DSIGT/SIGR)*(GRAP1(I)-GRAP2(I))
     &             -(HUMR*COEFG*DRV0DT*(PHI*FACTOR*DDATT
     &              +DATM*FACTOR*(J3-J1C))
     &             +DATM*FACTOR*PHI*COEFG*(DRV0DT*DHDT+HUMR*DRVDTT))
     &                    *GRAT(I)  
C       DM12/DGRAD(T)
                  DSDE(ADCP12+I,ADDETE+I)=DSDE(ADCP12+I,ADDETE+I)
     &               -RHO11*DTV  
C       DM21/DT
                  DSDE(ADCP21+I,ADDETE)=DSDE(ADCP21+I,ADDETE)
     &              -(LAMBD2(5)*RHO21+LAMBD2(1)*DR21T)*(GRAP2(I)
     &              -RHO21*PESA(I))
     &              +HENRY*RHO21/RHO11*(-RHO11*((LAMBD1(5)*(P1)*
     &                 DSIGT/SIGR)*GRAT(I)+(LAMBD1(5)*SIGT/SIGR
     &                        +LAMBD1(1)*DSIGT/SIGR)*(GRAP1(I))
     &                 -(RHO11*LAMBD1(5)+LAMBD1(1)*DR11T)*PESA(I))
     &                 -DR21T*(DTW*GRAT(I)+DPW*(GRAP1(I))
     &                 -2.D0*RHO11*LAMBD1(1)*PESA(I)))  
C       DM21/DGRAD(T)

                  DSDE(ADCP21+I,ADDETE+I)=DSDE(ADCP21+I,ADDETE+I)
     &              -RHO21*HENRY*DTW
               ENDIF
C            
 115        CONTINUE
         ENDIF
      ENDIF
C
      END
