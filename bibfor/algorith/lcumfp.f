       SUBROUTINE LCUMFP (NDIM,TYPMOD,IMATE,COMPOR,TINSTM,
     &                    TINSTP,SECHM,SECHP,EPSM,DEPS,SIGM,
     &                    VIM,OPTION,SIGP,VIP,DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C NSTRS
C CMAT
C NMAT
C ANCIENNE ROUTINE CASTEM FLU     SOURCE    BENBOU   02/02/7
C UMLVFP SOURCE YLP septembre 2002
C_______________________________________________________________________
C
C
C ROUTINE CALCULANT :
C
C    - CONTRAINTES FINALES          : SIGP (NSTRS)
C    - VARIABLES INTERNES FINALES   : VIP (NVARI)
C
C_______________________________________________________________________
C
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
C LE FLUAGE DE DESSICCATION --> DEBRANCHES
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
C
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
C
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
C
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
C_______________________________________________________________________
C
      IMPLICIT NONE
      CHARACTER*16    COMPOR(3),OPTION(2), COMPOZ(1)
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION DE NOMPAR
C      CHARACTER*8     NOMRES(16),NOMPAR(3)
      CHARACTER*8     NOMRES(16)
      CHARACTER*8     TYPMOD(*)
      CHARACTER*2     CODRET(16)
      REAL*8         CFPS,CFPD,CHI,COEF1
      REAL*8         VIM(23),VIP(23)
C     NSTRS --> 6
C     NVARI --> 20
      INTEGER I,J,K,L,NSTRS,NDIM,IFOU,IMATE,ISPH
      LOGICAL LGTEST
      REAL*8  TDT,TINSTP,TINSTM
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION 
C DE ALPHAP
C      REAL*8  ALPHAP,YOUN,XNU,DEUMU,TROIK
      REAL*8  YOUN,XNU
      REAL*8  KRS,ETARS,KIS,ETAIS,KRD,ETARD,ETAID
C MODIFI DU 6 JANVIER 2003 - YLP SUPPRESION DE LA DECLARATION 
C DE VALPAM ET VALPAP
C      REAL*8  VALPAM(3),VALPAP(3),SIGM(6),DEPS(6)
      REAL*8  SIGM(6),DEPS(6),EPSM(6)
      REAL*8  SIGP(6),CMAT(15),DEP(6,12),DSIDEP(6,6)
      REAL*8  AN(6),BN(6,6),CN(6,6),VALRES(16)
      REAL*8  HYGRM,HYGRP,RBID,XI
      REAL*8  SECHM,SECHP,ZERO
      REAL*8  MATN(6,6),INVN(6,6),RTEMP,EPS(6),EPSF(6),EPSFM(6)

C
C   CALCUL DE L'INTERVALLE DE TEMPS
C
      TDT = TINSTP-TINSTM
      ZERO=0.D0
C
C   DIMENSION
C      
      NSTRS = 2*NDIM 
C
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


C RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
C
      NOMRES(1)='E'
      NOMRES(2)='NU'
      CALL RCVALA(IMATE,' ','ELAS',1,'TEMP',0.D0,2,
     &             NOMRES,VALRES,CODRET, 'F ' )
      YOUN   = VALRES(1)
      XNU    = VALRES(2)
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
    
      CALL RCVALA(IMATE,' ','BETON_UMLV_FP',0,' ',RBID,7,NOMRES,
     &                               VALRES,CODRET,'F ')
      KRS     = VALRES(1)
      ETARS   = VALRES(2)
      KIS     = VALRES(3)
      ETAIS   = VALRES(4)
      KRD     = VALRES(5)
      ETARD   = VALRES(6)
      ETAID   = VALRES(7)
C
C  ------- CARACTERISTIQUES HYGROMETRIE H
C
      NOMRES(1)='FONC_DESORP'
      CALL RCVALA(IMATE,' ','ELAS',1,'SECH',SECHM,1,
     &               NOMRES(1),VALRES(1),CODRET(1), 'F ')
         IF  (CODRET(1) .NE. 'OK')  THEN
             CALL UTMESS ('F','RCVALA_01',
     &        'IL FAUT DECLARER FONC_DESORP
     &          SOUS ELAS_FO POUR LE FLUAGE PROPRE  
     &          AVEC SECH COMME PARAMETRE')
         ENDIF
      HYGRM=VALRES(1)
      CALL RCVALA(IMATE,' ','ELAS',1,'SECH',SECHP,1,
     &               NOMRES(1),VALRES(1),CODRET(1), 'F ')
         IF  (CODRET(1) .NE. 'OK')  THEN
             CALL UTMESS ('F','RCVALA_01',
     &        'IL FAUT DECLARER FONC_DESORP
     &          SOUS ELAS_FO POUR LE FLUAGE PROPRE  
     &          AVEC SECH COMME PARAMETRE')
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
C LES CHAMPS 10 ET 11 NE SONT PAS RENSEIGNES : 
C ILS CORRESPONDENT AU FLUAGE DE DESSICCATION QUI A ETE DEBRANCHE.
      CMAT(12)    = IFOU
      CMAT(13)    = 2
      CMAT(14)    = 0
      CMAT(15)    = 1
      
C
C
C   DANS LE CAS OU LE TEST DE DEFORMATION DE FLUAGE PROPRE
C        IRREVE A ECHOUE : ISPH = 0
C
  10  CONTINUE
C 
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

      CALL LCUMVI(VIM,EPSFM)
C_______________________________________________________________________
C
C CALCUL DES MATRICES DES DEFORMATIONS DE FLUAGE TOTAL
C
C   DFLUT(N+1) = AN + BN * SIGMA(N) + CN * SIGMA(N+1)
C
      IF (TDT.NE.0.D0) THEN
        IF (OPTION(1)(1:9).EQ.'RIGI_MECA') THEN
          ISPH=VIM(21)
        ENDIF
        CALL LCUMMD(VIM,20,CMAT,15,NSTRS,ISPH,TDT,
     &               HYGRM,HYGRP,
     &               AN,BN,CN,CFPS,CFPD)
      ENDIF
C
      IF ((OPTION(1)(1:9).EQ.'FULL_MECA').OR.
     &    (OPTION(1)(1:9).EQ.'RAPH_MECA')) THEN
C_______________________________________________________________________
C
C CALCUL DES CONTRAINTES ELASTIQUES
C_______________________________________________________________________
C
C  CONSTRUCTION DE LA MATRICE D ELASTICITE DE HOOKE
C  ET CALCUL DE L INCREMENT DE DEFORMATION ELASTIQUE : DEP(NSTRS,NSTRS)
C
        IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
          COMPOZ(1)='ENDO_ISOT_BETON'
          CALL LCLDSB(NDIM,TYPMOD,IMATE,COMPOZ,EPSM,DEPS,VIM(22),0.D0, 
     &            0.D0,0.D0,'RAPH_COUP       ',RBID,VIP(22),DEP)
C        ELSE IF (OPTION(2).EQ.'MAZARS') THEN
C          CALL LCMAZA()
        ELSE
          CALL LCUMME(YOUN,XNU,IFOU,DEP)
        ENDIF
C
C  CALCUL DE L INCREMENT DE CONTRAINTES PRENANT EN COMPTE
C                LE FLUAGE PROPRE ET DE DESSICCATION
C
        CALL LCUMEF(DEP,AN,BN,CN,EPSM,DEPS,EPSFM,SIGM,NSTRS,SIGP)
C
C_______________________________________________________________________
C
C SAUVEGARDE DES VARIABLES INTERNES FINALES
C_______________________________________________________________________
C
         CALL LCUMSF(SIGM,SIGP,NSTRS,VIM,20,CMAT,15,
     &                ISPH,TDT,HYGRM,HYGRP,VIP)
     
         VIP(21)=1
C
C  TEST DE LA CROISSANCE SUR LA DEFORMATION DE FLUAGE PROPRE SPHERIQUE
C
        IF (ISPH.EQ.2) THEN
          ISPH = 0
          GOTO 10
        ENDIF

      ENDIF

C_______________________________________________________________________
C
C CONSTRUCTION DE LA MATRICE TANGENTE
C_______________________________________________________________________
C
      IF ((OPTION(1)(1:9).EQ.'FULL_MECA').OR.
     &     (OPTION(1)(1:9).EQ.'RIGI_MECA')) THEN
C    FULL_MECA | RIGI_MECA_
        IF (OPTION(1)(1:9).EQ.'RIGI_MECA') THEN
          IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
            COMPOZ(1)='ENDO_ISOT_BETON'
            CALL LCLDSB(NDIM,TYPMOD,IMATE,COMPOZ,EPSM,RBID,VIM(22),0.D0,
     &                 0.D0,0.D0,'RIGI_COUP       ',RBID,RBID,DEP)
C          ELSE IF (OPTION(2).EQ.'MAZARS') THEN
C            CALL LCMAZA()
          ELSE
            CALL LCUMME(YOUN,XNU,IFOU,DEP)
          ENDIF
        ENDIF
        CALL R8INIR(36,0.D0,MATN,1)
        DO 30 I=1,NSTRS
          MATN(I,I)=1.D0
 30     CONTINUE

        DO 31 I=1,NSTRS
          DO 31 J=1,NSTRS
            DO 31 K=1,NSTRS
              MATN(I,J)=MATN(I,J)+CN(I,K)*DEP(K,J)
31      CONTINUE
  
        CALL R8INIR(36,0.D0,INVN,1)
        
        DO 36 I=1,NSTRS
          INVN(I,I)=1.D0
 36     CONTINUE
 
        LGTEST=.TRUE.
        CALL MGAUSS(MATN,INVN,6,NSTRS,NSTRS,ZERO,LGTEST)
        IF (.NOT.LGTEST) THEN
          CALL UTMESS ('F','LCUMFP','ERREUR DANS LE CALCUL DE LA 
     &          MATRICE TANGENTE')
        ENDIF
              
        CALL R8INIR(36,0.D0,DSIDEP,1)
              
        DO 37 I=1,NSTRS
          DO 37 J=1,NSTRS
            DO 37 K=1,NSTRS
              DSIDEP(I,J)=DSIDEP(I,J)+INVN(K,J)*DEP(I,K)
 37     CONTINUE

        IF (OPTION(2).EQ.'ENDO_ISOT_BETON') THEN
          IF (OPTION(1).EQ.'RIGI_MECA_TANG') THEN
            IF (NINT(VIM(23)).EQ.1) THEN
              CALL LCEIBT(NSTRS,EPSM,EPSFM,DEP,INVN,CN,DSIDEP)
            ENDIF
          ELSE IF ((OPTION(1).EQ.'RAPH_MECA').OR.
     &              (OPTION(1).EQ.'FULL_MECA')) THEN
            IF (NINT(VIP(23)).EQ.1) THEN
              CALL R8COPY(NSTRS,EPSM,1,EPS,1)
              CALL R8AXPY(NSTRS,1.D0,DEPS,1,EPS,1)
              CALL LCUMVI(VIP,EPSF)
              CALL LCEIBT(NSTRS,EPS,EPSF,DEP,INVN,CN,DSIDEP)
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
     &           - 1.D0/DSIDEP(3,3)*DSIDEP(K,3)*DSIDEP(3,L)
137         CONTINUE
136       CONTINUE
        ENDIF
      ENDIF

      END
