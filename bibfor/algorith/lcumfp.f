       SUBROUTINE LCUMFP (FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,COMPOR,
     &                    TINSTM,TINSTP,EPSM,DEPS,SIGM,
     &                    VIM,OPTION,SIGP,VIP,DSIDEP,CRIT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/10/2008   AUTEUR MICHEL S.MICHEL 
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
C RESPONSABLE YLEPAPE Y.LEPAPE
C TOLE CRP_20
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER          NDIM,IMATE,KPG,KSP
      CHARACTER*8     TYPMOD(*)
      CHARACTER*16    COMPOR(3),OPTION(2)
      CHARACTER*(*)    FAMI
      REAL*8           TINSTM,TINSTP
      REAL*8           EPSM(6),DEPS(6),SIGM(6),SIGP(6),VIM(*),VIP(*)
      REAL*8           DSIDEP(6,6),CRIT(*)

C---&s---1---------2---------3---------4---------5---------6---------7--
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION MECANIQUE   (--> IFOU SOUS CASTEM)
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT : RELCOM ET DEFORM
C IN  TINSTM  : INSTANT AU CALCUL PRECEDENT
C IN  TINSTP  : INSTANT DU CALCUL
C IN  DEPS    : INCREMENT DE DEFORMATION TOTALE
C IN  SIGM    : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : (1) OPTION DEMANDEE:RIGI_MECA_TANG, FULL_MECA ,RAPH_MECA
C               (2) MODELE MECA DE COUPLAGE EVENTUEL (MAZARS OU EIB)
C OUT SIGP    : CONTRAINTES A L'INSTANT ACTUEL
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIDEP  : MATRICE CARREE
C
C ANCIENNE ROUTINE CASTEM FLU     SOURCE    BENBOU   02/02/7
C UMLVFP SOURCE YLP septembre 2002
C_______________________________________________________________________
C
C ROUTINE CALCULANT :
C
C    - CONTRAINTES FINALES          : SIGP (NSTRS)
C    - VARIABLES INTERNES FINALES   : VIP (NVARI)
C_______________________________________________________________________
C
C STRUCTURE DES PARAMETRES MATERIAU ET AUTRE
C PARAMETRES ELASTIQUES
C     CMAT(1)     = YOUN : MODULE D YOUNG
C     CMAT(2)     = XNU  : COEFFICIENT DE POISSON ELASTIQUE
C PARAMETRES DU FLUAGE PROPRE
C     CMAT(3)     = KRS   : RIGIDITE SPHERIQUE APPARENTE SQUELETTE
C     CMAT(4)     = ETARS : VISCOSITE SPHERIQUE APPARENTE EAU LIBRE
C     CMAT(5)     = KIS   : RIGIDITE SPHERIQUE APPARENTE HYDRATES
C     CMAT(6)     = ETAIS : VISCOSITE SPHERIQUE APPARENTE EAU LIEE
C     CMAT(7)     = KRD   : RIGIDITE DEVIATORIQUE APPARENTE
C     CMAT(8)     = ETARD : VISCOSITE DEVIATORIQUE APPARENTE EAU LIBRE
C     CMAT(9)     = ETAID : VISCOSITE DEVIATORIQUE APPARENTE EAU LIEE
C LES DEUX PARAMETRES SUIVANTS CONCERNENT UNIQUEMENT
C LE FLUAGE DE DESSICCATION
C     CMAT(10)    = RDES : COEFFICIENT UMLV FLUAGE DESSICCATION
C     CMAT(11)    = VDES : COEFFICIENT UMLV/BAZANT FLUAGE DESSICCATION
C OBSOLETE (CONCERNE UNIQUEMENT CASTEM) --> TYPMOD (CODE_ASTER)
C     CMAT(12)    = IFOU : HYPOTHESE DE CALCUL AUX ELEMENTS FINIS
C                     -2 : CONTRAINTES PLANES
C                     -1 : DEFORMATION PLANE
C                      0 : AXISYMETRIQUE
C                      2 : TRIDIMENSIONEL
C PAR PRINCIPE CMAT(13) = 2
C     CMAT(13)    = IFPO : OPTION SUR LE MODELE FLUAGE PROPRE
C                      0 : PAS DE FLUAGE PROPRE
C                      1 : PAS D INFUENCE DE L HUMIDITE REALTIVE
C                      2 : INFLUENCE DE L HUMIDITE RELATIVE
C OBSOLETE --> DEBRANCHE
C     CMAT(14)    = IDES : OPTION SUR LE MODELE FLUAGE DESSICCATION
C                      0 : PAS PRIS EN COMPTE
C                      1 : MODELE BAZANT
C                      2 : MODELE UMLV
C     CMAT(15)    = ICOU : OPTION COUPLAGE MECANIQUE/FLUAGE
C                      0 : PAS DE COUPLAGE (CALCUL CHAINE)
C                      1 : COUPLAGE FORT
C_______________________________________________________________________
C
C  STRUCTURE DES CONTRAINTES : SIGM,SIGP ( X = M ou P )
C    IFOU = -2 : CONTRAINTES PLANES
C      - SIGX(1) = SIGMA_XX
C      - SIGX(2) = SIGMA_YY
C      - SIGX(3) = SIGMA_XY
C      - (SIGX(4) = SIGMA_ZZ = 0)
C
C    IFOU = -1 : DEFORMATION PLANE
C      - SIGX(1) = SIGMA_XX
C      - SIGX(2) = SIGMA_YY
C      - SIGX(3) = SIGMA_ZZ
C      - SIGX(4) = SIGMA_XY
C
C    IFOU = 0  : AXISYMETRIQUE
C      - SIGX(1) = SIGMA_RR
C      - SIGX(2) = SIGMA_ZZ
C      - SIGX(3) = SIGMA_TT
C      - SIGX(4) = SIGMA_RZ
C
C    IFOU = 2  : TRIDIMENSIONEL
C      - SIGX(1) = SIGMA_XX
C      - SIGX(2) = SIGMA_YY
C      - SIGX(3) = SIGMA_ZZ
C      - SIGX(4) = SIGMA_XY
C      - SIGX(5) = SIGMA_ZX
C      - SIGX(6) = SIGMA_YZ
C_______________________________________________________________________
C
C  STRUCTURE DE L'INCREMENT DEFORMATION TOTALE : DEPS (NSTRS)
C
C    IFOU = -2 : CONTRAINTES PLANES
C      - DEPS(1) = DEPSILON_XX
C      - DEPS(2) = DEPSILON_YY
C      - DEPS(3) = DEPSILON_XY
C      - DEPS(4) = DEPSILON_ZZ
C
C    IFOU = -1 : DEFORMATION PLANE
C      - DEPS(1) = DEPSILON_XX
C      - DEPS(2) = DEPSILON_YY
C      - DEPS(3) = DEPSILON_XY
C      - (DEPS(4) = DEPSILON_ZZ = 0)
C
C    IFOU = 0  : AXISYMETRIQUE
C      - DEPS(1) = DEPSILON_RR
C      - DEPS(2) = DEPSILON_ZZ
C      - DEPS(3) = DEPSILON_TT
C      - DEPS(4) = DEPSILON_RZ
C
C    IFOU = 2  : TRIDIMENSIONEL
C      - DEPS(1) = SIGMA_XX
C      - DEPS(2) = SIGMA_YY
C      - DEPS(3) = SIGMA_ZZ
C      - DEPS(4) = SIGMA_XY
C      - DEPS(5) = SIGMA_ZX
C      - DEPS(6) = SIGMA_YZ
C_______________________________________________________________________
C
C  STRUCTURE DES VARIABLES INTERNES : VIM,VIP ( X = I ou F )
C
C     VIX(1)     = ERSP  : DEFORMATION DE FLUAGE REV SPHERIQUE
C     VIX(2)     = EISP  : DEFORMATION DE FLUAGE IRR SPHERIQUE
C     VIX(3)     = ERD11 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 11
C     VIX(4)     = EID11 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 11
C     VIX(5)     = ERD22 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 22
C     VIX(6)     = EID22 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 22
C     VIX(7)     = ERD33 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 33
C     VIX(8)     = EID33 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 33
C     VIX(9)     = EFD11 : DEFORMATION DE FLUAGE DE DESSICCATION  11
C     VIX(10)    = EFD22 : DEFORMATION DE FLUAGE DE DESSICCATION  22
C     VIX(11)    = EFD33 : DEFORMATION DE FLUAGE DE DESSICCATION  33
C     VIX(12)    = ERD12 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 12
C     VIX(13)    = EID12 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 12
C     VIX(14)    = ERD23 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 23
C     VIX(15)    = EID23 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 23
C     VIX(16)    = ERD31 : DEFORMATION DE FLUAGE REV DEVIATORIQUE 31
C     VIX(17)    = EID31 : DEFORMATION DE FLUAGE IRE DEVIATORIQUE 31
C     VIX(18)    = EFD12 : DEFORMATION DE FLUAGE DE DESSICCATION  12
C     VIX(19)    = EFD23 : DEFORMATION DE FLUAGE DE DESSICCATION  23
C     VIX(20)    = EFD31 : DEFORMATION DE FLUAGE DE DESSICCATION  31
C     VIX(21)    = INDICATEUR DU FLUAGE SPHERIQUE (0 ou 1)
C     VARIABLES INTERNES UTILISEES SI COUPLAGE AVEC ENDO_ISOT_BETON
C     VIX(22)    = ENDOMMAGEMENT D DONNE PAR EIB
C     VIX(23)    = INDICATEUR D'ENDOMMAGEMENT DE EIB
C     VARIABLES INTERNES UTILISEES SI COUPLAGE AVEC MAZARS
C     VIX(22)    = ENDOMMAGEMENT D DONNE PAR MAZARS
C     VIX(23)    = INDICATEUR D'ENDOMMAGEMENT DE EIB
C     VIX(24)    = TEMPERATURE MAXIMALE ATTEINTE PAR LE MATERIAU
C     VIX(25)    = VALEUR DE EPSEQ (UTILE POUR POSTTRAITER)
C_______________________________________________________________________
C
      CHARACTER*16    COMPOZ(1)
      REAL*8  DET
      INTEGER IRET
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION DE NOMPAR
C      CHARACTER*8     NOMRES(16),NOMPAR(3)
      CHARACTER*8     NOMRES(16)
      CHARACTER*2     CODRET(16)
      REAL*8         CFPS,CFPD
C     NSTRS --> 6 NVARI --> 20
      INTEGER I,J,K,L,NSTRS,IFOU,ISPH
      REAL*8  TDT
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION DE ALPHAP
C      REAL*8  ALPHAP,YOUN,XNU,DEUMU,TROIK
      REAL*8  YOUN,XNU
C MODIFI DU 18 AOUT 2004 - YLP AJOUT CARACTERISTIQUES DU RETRAIT
      REAL*8  BENDO,KDESS
      REAL*8  KRS,ETARS,KIS,ETAIS,KRD,ETARD,ETAID
C MODIFI DU 25 AOUT 2004 - YLP AJOUT VARIABLE DE DESSICCATION DE BAZANT
      REAL*8  ETAFD
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION
C DE VALPAM ET VALPAP
C      REAL*8  VALPAM(3),VALPAP(3),SIGM(6),DEPS(6)
      REAL*8  CMAT(15),DEP(6,12)
      REAL*8  AN(6),BN(6,6),CN(6,6),VALRES(16)
      REAL*8  HYGRM,HYGRP,RBID
C MODIFI DU 18 AOUT 2004 - YLP AJOUT DE LA DEFORMATION DE RETRAIT
      REAL*8  MATN(6,6),INVN(6,6),EPS(6),EPSF(6)
      REAL*8  EPSRM,EPSRP,EPSFM(6)
C MODIFI OCT 2004 - SMP AJOUT DILATATION THERMIQUE
C      REAL*8 ALPHA
C MODIFI AVR 2005 - SMP CORRECTION RETRAIT SI COUPLAGE AVEC EIB
      REAL*8   KRON(6), EPSME(6),EPSE(6)
C MODIFI MARS 2006 "NOUVELLE" VARIABLE DE COMMANDE HYDR ET SECH
      REAL*8   HYDRM,HYDRP,SECHM,SECHP,SREF,TM,TP,TREF
C      INTEGER  IER
C MODIFI JUIN 2007
      REAL*8   EPSTHP,EPSTHM
      INTEGER  IRET1,IRET2

C MODIFI 20 OCT 2008 - M.B.
      REAL*8   TMAXP, TMAXM, YOUNM, XNUM
      REAL*8   SIGELM(6), SIGELP(6), EPSEL(6)
      INTEGER  IISNAN
      DATA     KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
C
C   CALCUL DE L'INTERVALLE DE TEMPS
C
      TDT = TINSTP-TINSTM
C
C   DIMENSION
C
      NSTRS = 2*NDIM

C   TYPE DE CALCUL
C
      IF (TYPMOD(1) .EQ. 'C_PLAN') THEN
        IFOU = -2
        GOTO 1
      ELSEIF (TYPMOD(1) .EQ. 'D_PLAN') THEN
        IFOU = -1
        GOTO 1
      ELSEIF (TYPMOD(1) .EQ. 'AXIS') THEN
        IFOU = 0
        GOTO 1
      ELSE
        IFOU = 2
      ENDIF
1     CONTINUE

C
C   INITIALISATION DU FLUAGE SPHERIQUE PROPRE
C
      ISPH = 1
                     
C RECUPERATION DES VALEURS DE TEMPERATURE
C
C      CALL VERIFT(FAMI,KPG,KSP,'+',IMATE,'ELAS',1,EPSTHP,IRET1)
C      CALL VERIFT(FAMI,KPG,KSP,'-',IMATE,'ELAS',1,EPSTHM,IRET2)
      CALL RCVARC('F','TEMP','-',FAMI,KPG,KSP,TM,IRET)
      CALL RCVARC('F','TEMP','+',FAMI,KPG,KSP,TP,IRET)
      CALL RCVARC('F','TEMP','REF',FAMI,KPG,KSP,TREF,IRET)
      

C  ------- LECTURE DES CARACTERISTIQUES ELASTIQUES
C  MB: LA DEPENDENCE DES PARAMETRES PAR RAPPORT A LA TEMPERATURE
C  CHANGE PAR RAPPORT A LA LOI D ENDOMMAGEMENT (COUPLAGE)

      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3) = 'ALPHA'
      NOMRES(4) = 'ALPHA'

      IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN

        CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',1,'TEMP',0.D0,2,
     &              NOMRES,VALRES,CODRET, 'FM')
        CALL U2MESS('I', 'COMPOR1_60')
        
        CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',1,'TEMP',0.D0,1,
     &               NOMRES(3),VALRES(3),CODRET(3), ' ') 
        VALRES(4) = VALRES(3)  
        CODRET(4) = CODRET(3)
        
      ELSEIF (OPTION(2).EQ.'MAZARS') THEN
        TMAXM = VIM(24)
        TMAXP = MAX(TMAXM, TP)
 
        CALL RCVALB(FAMI,1,1,'-',IMATE,' ','ELAS',1,'TEMP',TMAXM,2,
     &              NOMRES,VALRES,CODRET, 'FM')
        YOUNM   = VALRES(1)
        XNUM    = VALRES(2)     

        CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',1,'TEMP',TMAXP,2,
     &              NOMRES,VALRES,CODRET, 'FM')    
     
        CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',1,
     &                'TEMP',TMAXM,1,NOMRES(3),VALRES(3),CODRET(3),' ')
        CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',1,
     &                'TEMP',TMAXP,1,NOMRES(4),VALRES(4),CODRET(4),'0')
        CALL U2MESS('I', 'COMPOR1_61')
        
      ELSE
        CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',0.D0,2,
     &               NOMRES,VALRES,CODRET, 'FM' )     
      ENDIF
      
      YOUN   = VALRES(1)
      XNU    = VALRES(2)

C
C  -------CALCUL DES DEFORMATIONS THERMIQUES
C
      IF ((OPTION(2).EQ.'MAZARS').OR.
     &      (OPTION(2).EQ.'ENDO_ISOT_BETON')) THEN
        IF ( (IISNAN(TREF).EQ.1).OR.(CODRET(3).NE.'OK')
     &        .OR.(CODRET(4).NE.'OK') ) THEN
          CALL U2MESS('F','CALCULEL_15')          
        ELSE
          IF (IISNAN(TM).EQ.0) THEN
            EPSTHM = VALRES(3) * (TM - TREF)
          ELSE
            EPSTHM = 0.D0        
          ENDIF
          IF (IISNAN(TP).EQ.0) THEN
            EPSTHP = VALRES(4) * (TP - TREF)
          ELSE
            EPSTHP = 0.D0        
          ENDIF          
        ENDIF
      ELSE

        CALL VERIFT(FAMI,KPG,KSP,'+',IMATE,'ELAS',1,EPSTHP,IRET1)
        CALL VERIFT(FAMI,KPG,KSP,'-',IMATE,'ELAS',1,EPSTHM,IRET2)  
      ENDIF


C
C MODIFI DU 18 AOUT 2004 - AJOUT RETRAIT
C
C  ------- CARACTERISTIQUES DE RETRAIT ENDOGENE ET DE DESSICCATION
C
      NOMRES(1)='B_ENDOGE'
      NOMRES(2)='K_DESSIC'
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',0.D0,2,
     &             NOMRES,VALRES,CODRET, 'FM' )
      BENDO=VALRES(1)
      KDESS=VALRES(2)

            
C
C  ------- CARACTERISTIQUES FLUAGE PROPRE UMLV
C
      NOMRES(1)='K_RS'
      NOMRES(2)='ETA_RS'
      NOMRES(3)='K_IS'
      NOMRES(4)='ETA_IS'
      NOMRES(5)='K_RD'
      NOMRES(6)='ETA_RD'
      NOMRES(7)='ETA_ID'

      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','BETON_UMLV_FP',0,' ',
     &            RBID,7,NOMRES,VALRES,CODRET,'F ')
      KRS     = VALRES(1)
      ETARS   = VALRES(2)
      KIS     = VALRES(3)
      ETAIS   = VALRES(4)
      KRD     = VALRES(5)
      ETARD   = VALRES(6)
      ETAID   = VALRES(7)
 
C
C ------- CARACTERISTIQUE FLUAGE DE DESSICATION DE BAZANT
C
      NOMRES(8)='ETA_FD'
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','BETON_UMLV_FP',0,' ',
     &            RBID,8,NOMRES,VALRES,CODRET,'  ')
C     FLUAGE DE DESSICCATION NON ACTIVE
      IF (CODRET(8) .NE. 'OK') THEN
        CMAT(14) = 0
        ETAFD = -1.0D0
C     FLUAGE DE DESSICCATION ACTIVE
      ELSE
        CMAT(14) = 1
        ETAFD = VALRES(8)
      ENDIF


C
C  ------- CARACTERISTIQUES HYGROMETRIE H
C
      NOMRES(1)='FONC_DES'
      CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ','ELAS',0,' ',
     &            RBID,1,NOMRES(1),VALRES(1),CODRET(1), 'F ')        
      IF  (CODRET(1) .NE. 'OK')  THEN
         CALL U2MESS('F','ALGORITH4_94')
      ENDIF
      HYGRM=VALRES(1)
      CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ','ELAS',0,' ',
     &            RBID,1,NOMRES(1),VALRES(1),CODRET(1), 'F ')
         IF  (CODRET(1) .NE. 'OK')  THEN
             CALL U2MESS('F','ALGORITH4_94')
         ENDIF
      HYGRP=VALRES(1)
             

C
C CONSTRUCTION DU VECTEUR CMAT CONTENANT LES CARACTERISTIQUES MECANIQUES
C
C     CMAT(1)     = YOUN   : MODULE D YOUNG
C     CMAT(2)     = XNU    : COEFFICIENT DE POISSON ELASTIQUE
C     CMAT(3)     = KRS   : RIGIDITE SPHERIQUE APPARENTE SQUELETTE
C     CMAT(4)     = ETARS : VISCOSITE SPHERIQUE APPARENTE EAU LIBRE
C     CMAT(5)     = KIS   : RIGIDITE SPHERIQUE APPARENTE HYDRATES
C     CMAT(6)     = ETAIS : VISCOSITE SPHERIQUE APPARENTE EAU LIEE
C     CMAT(7)     = KRD   : RIGIDITE DEVIATORIQUE APPARENTE
C     CMAT(8)     = ETARD : VISCOSITE DEVIATORIQUE APPARENTE EAU LIBRE
C     CMAT(9)     = ETAID : VISCOSITE DEVIATORIQUE APPARENTE EAU LIEE
C
      CMAT(1)     = YOUN
      CMAT(2)     = XNU
      CMAT(3)     = KRS
      CMAT(4)     = ETARS
      CMAT(5)     = KIS
      CMAT(6)     = ETAIS
      CMAT(7)     = KRD
      CMAT(8)     = ETARD
      CMAT(9)     = ETAID
C MODIFI FD BAZANT
      CMAT(11)    = ETAFD
      CMAT(12)    = IFOU
      CMAT(13)    = 2
C MODIFI 25/08/04 YLP - ACTIVATION DU FLUAGE DE DESSICATION DE BAZANT
C CMAT(14)=IDES 0 --> 1
C      CMAT(14)    = 1
      CMAT(15)    = 1
C
C   DANS LE CAS OU LE TEST DE DEFORMATION DE FLUAGE PROPRE
C        IRREVE A ECHOUE : ISPH = 0
C
  10  CONTINUE
C
C INITIALISATION DES VARIABLES
C
      CFPS = 0.D0
      CFPD = 0.D0
C MODIFI DU 6 JANVIER 2003 - YLP NSTRS -->  6
C      DO 11 I=1,NSTRS
      DO 11 I=1,6
        AN(I)    = 0.D0
C        DO 12 J=1,NSTRS
        DO 12 J=1,6
          DEP(I,J) = 0.D0
          BN(I,J)  = 0.D0
          CN(I,J)  = 0.D0
12      CONTINUE
11    CONTINUE


C_______________________________________________________________________
C
C CALCUL DES MATRICES DES DEFORMATIONS DE FLUAGE TOTAL
C   DFLUT(N+1) = AN + BN * SIGMA(N) + CN * SIGMA(N+1)
C_______________________________________________________________________
     
      IF (TDT.NE.0.D0) THEN
        IF (OPTION(1)(1:9).EQ.'RIGI_MECA') THEN
          ISPH=VIM(21)
        ENDIF
        CALL LCUMMD(VIM,20,CMAT,15,SIGM,NSTRS,ISPH,TDT,
     &               HYGRM,HYGRP,
     &               AN,BN,CN,CFPS,CFPD)
      ENDIF
      
           
C_______________________________________________________________________
C 
C RECUPERATION DE L HYDRATATION E DU SECHAGE
C CALCUL DE LA SIGMA ELASTIQUE AU TEMP M POUR COUPLAGE AVEC MAZARS
C  MODIFIE 20 SEPT 2008 M.BOTTONI 
C_______________________________________________________________________


      CALL LCUMVI('FT',VIM,EPSFM)   
         
      
      IF ((OPTION(1)(1:9).EQ.'FULL_MECA').OR.
     &    (OPTION(1)(1:9).EQ.'RAPH_MECA')) THEN

C MODIFI DU 18 AOUT 2004 YLP - CORRECTION DE LA DEFORMATION DE FLUAGE
C PAR LES DEFORMATIONS DE RETRAIT 

        
          CALL RCVARC(' ','HYDR','+',FAMI,KPG,KSP,HYDRP,IRET)
          IF ( IRET.NE.0) HYDRP=0.D0
          CALL RCVARC(' ','HYDR','-',FAMI,KPG,KSP,HYDRM,IRET)
          IF ( IRET.NE.0) HYDRM=0.D0
          CALL RCVARC(' ','SECH','+',FAMI,KPG,KSP,SECHP,IRET)
          IF ( IRET.NE.0) SECHP=0.D0
          CALL RCVARC(' ','SECH','-',FAMI,KPG,KSP,SECHM,IRET)
          IF ( IRET.NE.0) SECHM=0.D0
          CALL RCVARC(' ','SECH','REF',FAMI,KPG,KSP,SREF,IRET)
          IF ( IRET.NE.0) SREF=0.D0

          EPSRM = KDESS*(SECHM-SREF)-BENDO*HYDRM + EPSTHM
          EPSRP = KDESS*(SECHP-SREF)-BENDO*HYDRP + EPSTHP        


C - MB: CALCUL DE LA DEFORMATION ELASTIQUE AU TEMP M 
C    (LA SEULE QUI CONTRIBUE A FAIRE EVOLUER L'ENDOMMAGEMENT) 
C    POUR LE COUPLAGE AVEC MAZARS

        IF (OPTION(2).EQ.'MAZARS') THEN
          CALL R8INIR(6, 0.D0, EPSEL,1)
          DO 35 K=1,NSTRS  
            EPSEL(K) = EPSM(K) - EPSRM * KRON(K) - EPSFM(K)
35        CONTINUE
       

C  -  ON CALCUL LES CONTRAINTES ELASTIQUES AU TEMP M
C          CALL SIGELA (NDIM,'LAMBD',LAMBDA,DEUXMU,EPSEL,SIGELM)

            CALL SIGELA (TYPMOD,NDIM,YOUNM,XNUM,EPSEL,SIGELM)

        ENDIF

         
C ________________________________________________________________

C  1. CONSTRUCTION DE LA MATRICE D ELASTICITE DE HOOKE POUR MAZARS 
C     OU UMLV SANS COUPLAGE, OU DE LA MATRICE ELASTO-ENDOMMAGEE POUR EIB
C  2. MISE A JOUR DE L ENDOMMAGEMENT ET DES SIGMA POUR EIB
C ________________________________________________________________


        IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
          COMPOZ(1)='ENDO_ISOT_BETON'
C    MATRICE ELASTO-ENDOMMAGEE ET MISE A JOUR DE L ENDOMMAGEMENT
          CALL LCLDSB(FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,COMPOZ,EPSM,
     &        DEPS,VIM(22),TM,TP,TREF,'RAPH_COUP       ',
     &        RBID,VIP(22),DEP,CRIT) 
        ELSE
C    MATRICE D ELASTICITE DE HOOKE POUR MAZARS ET UMLV SANS COUPLAGE
          CALL LCUMME(YOUN,XNU,IFOU,DEP)

        ENDIF


C ________________________________________________________________
C   MODIFIE MB 20 OCT 2008 
C
C  1. MISE A JOUR DES SIGMA POUR EIB ET UMLV SANS COUPLAGE
C     CALCUL DES SIGMA ELASTIQUES POUR MAZARS 
C      (LCUMEF)
C  2. MISE A JOUR DES VARIABLES INTERNES FINALES DE FLUAGE
C      (LCUMSF)
C ________________________________________________________________

C  PRISE EN COMPTE DU FLUAGE PROPRE ET DE DESSICCATION
C   MODIFI DU 18 AOUT 2004 YLP - CORRECTION DE LA DEFORMATION DE FLUAGE
C   PAR LES DEFORMATIONS DE RETRAIT 

        IF (OPTION(2).EQ.'MAZARS') THEN
          CALL LCUMEF(DEP,AN,BN,CN,EPSM,EPSRM,EPSRP,
     &                DEPS,EPSFM,SIGELM,NSTRS,SIGELP)
          CALL LCUMSF(SIGELM,SIGELP,NSTRS,VIM,20,CMAT,15,
     &                ISPH,TDT,HYGRM,HYGRP,VIP) 
     
        ELSE

          CALL LCUMEF(DEP,AN,BN,CN,EPSM,EPSRM,EPSRP,
     &                DEPS,EPSFM,SIGM,NSTRS,SIGP)     
          CALL LCUMSF(SIGM,SIGP,NSTRS,VIM,20,CMAT,15,
     &                ISPH,TDT,HYGRM,HYGRP,VIP)             
       ENDIF

    
        VIP(21)=1

C
C  TEST DE LA CROISSANCE SUR LA DEFORMATION DE FLUAGE PROPRE SPHERIQUE
C
        IF (ISPH.EQ.2) THEN
          ISPH = 0
          GOTO 10
        ENDIF



C___________________________________________________________
C
C  MB: MISE A JOUR DE L ENDOMMAGEMENT ET DES SIGMA POUR MAZARS
C_________________________________________________________
      

        IF (OPTION(2).EQ.'MAZARS') THEN

          CALL LCMAZA (FAMI,KPG,KSP,NDIM, TYPMOD, IMATE,COMPOR,EPSM,
     &             DEPS, VIM(22), TM,TP,TREF,'RAPH_COUP       ',
     &             SIGP, VIP, RBID)
        ENDIF
             
C FIN DE (IF RAPH_MECA ET FULL_MECA)        
      ENDIF




  
      
C_______________________________________________________________________
C
C CONSTRUCTION DE LA MATRICE TANGENTE
C_______________________________________________________________________
C
      IF ((OPTION(1)(1:9).EQ.'FULL_MECA').OR.
     &     (OPTION(1)(1:9).EQ.'RIGI_MECA')) THEN     
C      FULL_MECA | RIGI_MECA_

C - MB: SI COUPLAGE AVEC MAZARS, ON UTILISE POUR LE COUPLAGE
C       LA MATRICE TANGENTE DE CETTE LOI
        IF (OPTION(2).EQ.'MAZARS') THEN   
        
          IF (OPTION(1)(1:9).EQ.'FULL_MECA') 
     &     OPTION(1) = 'RIGI_COUP       '
     
            CALL  LCMAZA (FAMI,KPG,KSP,NDIM, TYPMOD, IMATE, COMPOR,
     &                     EPSM,DEPS, VIM(22), TM,TP,TREF,
     &                     OPTION, RBID, VIP, DSIDEP)
        ELSE

          IF (OPTION(1)(1:9).EQ.'RIGI_MECA') THEN      
            IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
              COMPOZ(1)='ENDO_ISOT_BETON'
              CALL LCLDSB(FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,COMPOZ,EPSM,
     &                  RBID,VIM(22),TM,TP,TREF,'RIGI_COUP       ',
     &                  RBID,RBID,DEP,CRIT)
C          ELSE IF (OPTION(2).EQ.'MAZARS') THEN
C            CALL LCMAZA()
            ELSE
              CALL LCUMME(YOUN,XNU,IFOU,DEP)
            ENDIF
          ENDIF
          CALL R8INIR(36,0.D0,MATN,1)
          DO 30 I=1,NSTRS
            MATN(I,I)=1.D0
 30       CONTINUE

          DO 31 I=1,NSTRS
            DO 31 J=1,NSTRS
              DO 31 K=1,NSTRS
                MATN(I,J)=MATN(I,J)+CN(I,K)*DEP(K,J)
31        CONTINUE

          CALL R8INIR(36,0.D0,INVN,1)

          DO 36 I=1,NSTRS
            INVN(I,I)=1.D0
 36       CONTINUE

          CALL MGAUSS('NFVP',MATN,INVN,6,NSTRS,NSTRS,DET,IRET)

          CALL R8INIR(36,0.D0,DSIDEP,1)

          DO 37 I=1,NSTRS
            DO 37 J=1,NSTRS
              DO 37 K=1,NSTRS
                DSIDEP(I,J)=DSIDEP(I,J)+INVN(K,J)*DEP(I,K)
 37       CONTINUE

          IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
            IF (OPTION(1).EQ.'RIGI_MECA_TANG') THEN
              CALL RCVARC(' ','HYDR','+',FAMI,KPG,KSP,HYDRP,IRET)
              IF ( IRET.NE.0) HYDRP=0.D0
              CALL RCVARC(' ','HYDR','-',FAMI,KPG,KSP,HYDRM,IRET)
              IF ( IRET.NE.0) HYDRM=0.D0
              CALL RCVARC(' ','SECH','+',FAMI,KPG,KSP,SECHP,IRET)
              IF ( IRET.NE.0) SECHP=0.D0
              CALL RCVARC(' ','SECH','-',FAMI,KPG,KSP,SECHM,IRET)
              IF ( IRET.NE.0) SECHM=0.D0
              CALL RCVARC(' ','SECH','REF',FAMI,KPG,KSP,SREF,IRET)
              IF ( IRET.NE.0) SREF=0.D0
              IF (NINT(VIM(23)).EQ.1) THEN
                EPSRM = KDESS*(SECHM-SREF)-BENDO*HYDRM + EPSTHM
                DO 40 I=1,NSTRS
                  EPSME(I)=EPSM(I)-EPSRM*KRON(I)
 40             CONTINUE
                CALL LCEIBT(NSTRS,EPSME,EPSFM,DEP,INVN,CN,DSIDEP)
              ENDIF
            ELSE IF ((OPTION(1).EQ.'RAPH_MECA').OR.
     &               (OPTION(1).EQ.'FULL_MECA')) THEN
              IF (NINT(VIP(23)).EQ.1) THEN
                CALL DCOPY(NSTRS,EPSM,1,EPS,1)
                CALL DAXPY(NSTRS,1.D0,DEPS,1,EPS,1)
                DO 45 I=1,NSTRS
                  EPSE(I)=EPSM(I)+DEPS(I)-EPSRP*KRON(I)
 45             CONTINUE
                CALL LCUMVI('FT',VIP,EPSF)
                CALL LCEIBT(NSTRS,EPSE,EPSF,DEP,INVN,CN,DSIDEP)
              ENDIF
            ENDIF
C        ELSE IF (OPTION(2).EQ.'MAZARS') THEN
          ENDIF
C----------- CORRECTION POUR LES CONTRAINTES PLANES :
          IF (IFOU .EQ. -2) THEN
            DO 136 K=1,NSTRS
              IF (K.EQ.3) GO TO 136
              DO 137 L=1,NSTRS
                IF (L.EQ.3) GO TO 137
                DSIDEP(K,L)=DSIDEP(K,L)
     &             - 1.D0/DSIDEP(3,3)*DSIDEP(K,3)*DSIDEP(3,L)
137           CONTINUE
136         CONTINUE
          ENDIF
          

C FIN CHOIX MAZARS
        ENDIF 

C FIN RIGI_MECA/FULL_MECA        
      ENDIF
      
      END
