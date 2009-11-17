      SUBROUTINE LCEDGA (FAMI,KPG,KSP,NDIM,IMAT,COMPOR,CRIT,TYPMOD,
     &                   INSTAM,INSTAP,COORD,EPSM2,DEPS2,SIGM2,VIM,
     &                   OPTION,SIGP,VIP,DSIDEP,IRET)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/11/2009   AUTEUR DURAND C.DURAND 

      INTEGER        NDIM,IMAT,IRET,KPG,KSP
      CHARACTER*16  COMPOR(*),OPTION
      CHARACTER*8   TYPMOD(2)
      CHARACTER*(*)  FAMI
      REAL*8         CRIT(3),INSTAM,INSTAP,COORD(3)
      REAL*8         EPSM2(6),DEPS2(6)
      REAL*8         SIGM2(6),VIM(2),SIGP(6),VIP(2)
      REAL*8         DSIDEP(6,6)

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

C ----------------------------------------------------------------------
C     MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
C     INTEGRATION DU MODELE PAR UNE METHODE DE NEWTON
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMAT    : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT : RELCOM ET DEFORM
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT DU CALCUL PRECEDENT
C IN  INSTAP  : INSTANT DU CALCUL
C IN  COORD   : COORDONNEES DU POINT DE GAUSS
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  EPSM2   : DEFORMATIONS A L'INSTANT DU CALCUL PRECEDENT*SQRT(2)
C IN  DEPS2   : INCREMENT DE DEFORMATION*SQRT(2)
C IN  SIGM2   : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT*SQRT(2)
C IN  VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA

C OUT SIGP    : CONTRAINTES A L'INSTANT ACTUEL*SQRT(2)
C OUT VIP     : DEUX VARIABLES INTERNES A L'INSTANT ACTUEL
C               VIP(1)=DEFORMATION PLASTIQUE CUMULEE
C               VIP(2)= INDICE D ELASTICITE MEME SI SANS SEUIL
C OUT DSIDEP  : MATRICE CARREE
C     IRET    : CODE RETOUR DE LA RESOLUTION DE L'EQUATION SCALAIRE
C                              IRET=0 => PAS DE PROBLEME
C                              IRET=1 => ECHEC
C               ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C               L'ORDRE :  XX YY ZZ SQRT(2)XY SQRT(2)XZ SQRT(2)YZ
C ----------------------------------------------------------------------

      INTEGER  I,J,K,NZ,NDIMSI
      INTEGER  IRE2
      INTEGER  ITER,ITEMAX
      REAL*8   TM,TP,TREF,TEMP,DT            
      REAL*8   PHASE(3),PHASM(3),ZALPHA
      REAL*8   ZERO,PREC,R8PREM,RBID
      REAL*8   KRON(6)
      REAL*8   MUM,MU,TROISK,ALPHA,ANIC(6,6),ANI(6,6)
      REAL*8   M(3),N(3),GAMMA(3),EPSTH,YOUNG,NU
      REAL*8   EPSM(2*NDIM),DEPS(2*NDIM),SIGM(2*NDIM)
      REAL*8   TREPSM,TRDEPS,TRSIGM,TRSIGP
      REAL*8   DVDEPS(2*NDIM),DVEPEL(2*NDIM),DVEPTR(2*NDIM)
      REAL*8   DVSIGM(2*NDIM),DVSITR(2*NDIM),DVSIGP(2*NDIM)
      REAL*8   EQSITR,EQEPTR
      REAL*8   PM,DP
      REAL*8   Y(2*NDIM+1),G(2*NDIM+1),MAXG,DGDY(2*NDIM+1,2*NDIM+1)
      REAL*8   VECT(2*NDIM),MAT(2*NDIM+1,2*NDIM+1)
      REAL*8   EDGEQU
      REAL*8   R1(2*NDIM+1,2*NDIM),H1(2*NDIM,2*NDIM)
      
      CHARACTER*1 C1
      CHARACTER*8 ZIRC(2)      
      LOGICAL      RESI,RIGI            
      DATA          KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA          ZIRC /'ALPHPUR','ALPHBETA'/

C LEXIQUE SUR LE NOM DES VARIABLES VALABLES DANS TOUTES LES ROUTINES
C INDICE I QUAND SOMMATION SUR LA DIMENSION DE L ESPACE
C INDICE K QUAND SOMMATION SUR LES TROIS PHASES
C TRX POUR LA TRACE DE X/3
C DVX POUR LA PARTIE DEVIATORIQUE DE X
C EQX POUR EQUIVALENT AU SENS DE HILL

C *******************
C 1 - INITIALISATION
C *******************

      RESI   = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI   = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'
      
      IF(NDIM.EQ.2) THEN
        NDIMSI=4
      ELSE
        NDIMSI=6
      ENDIF

      ZERO=100.D0*R8PREM()
      DT = INSTAP-INSTAM
      IRET = 0

      CALL RCVARC('F','TEMP','-',FAMI,KPG,KSP,TM,IRE2)
      CALL RCVARC('F','TEMP','REF',FAMI,1,1,TREF,IRE2)
      CALL RCVARC('F','TEMP','+',FAMI,KPG,KSP,TP,IRE2)

C 1.1 - NOMBRE DE PHASES

      NZ=3

C 1.2 - RECUPERATION DES PHASES METALLURGIQUES

      IF (RESI) THEN

        TEMP=TP
        C1='+'
        DO 5 K=1,NZ-1
          CALL RCVARC(' ',ZIRC(K),'+',FAMI,KPG,KSP,PHASE(K),IRE2)
          IF (IRE2.EQ.1) PHASE(K)=0.D0
          CALL RCVARC(' ',ZIRC(K),'-',FAMI,KPG,KSP,PHASM(K),IRE2)
          IF (IRE2.EQ.1) PHASM(K)=0.D0
 5      CONTINUE

      ELSE

        TEMP=TM
        C1='-'
        DO 10 K=1,NZ-1
          CALL RCVARC(' ',ZIRC(K),'-',FAMI,KPG,KSP,PHASE(K),IRE2)
          IF (IRE2.EQ.1) PHASE(K)=0.D0
 10     CONTINUE

      ENDIF        

      ZALPHA=PHASE(1)+PHASE(2)
      PHASE(NZ)=1.D0-ZALPHA

C 1.3 - TEST SUR LES PHASES

      DO 15 K=1,NZ
        IF (PHASE(K).LE.ZERO) PHASE(K)=0.D0
        IF (PHASE(K).GE.1.D0)  PHASE(K)=1.D0
 15    CONTINUE       
      IF (ZALPHA.LE.ZERO) ZALPHA=0.D0
      IF (ZALPHA.GE.1.D0)  ZALPHA=1.D0

C **************************************
C 2 - RECUPERATION DES CARACTERISTIQUES
C **************************************
C ATTENTION CAR LA MATRICE D ANISOTROPIE EST DONNEE DANS LE 
C REPERE (R - T - Z) DONC IL FAUT FAIRE UN CHANGEMENT DE REPERE
C EN AXI C EST SIMPLE CAR IL SUFFIT D INVERSER LES TERMES 2 ET 3

      CALL EDGMAT (FAMI,KPG,KSP,IMAT,C1,ZALPHA,TEMP,DT,
     1             MUM,MU,TROISK,ALPHA,ANIC,M,N,GAMMA)

C CHANGEMENT DE REPERE DE LA MATRICE D ANISOTROPIE

      CALL EDGREP (TYPMOD,COORD,ANIC,ANI)

      IF (RESI) THEN

C ******************************************************
C 3 - PREPARATION DE L ALGORITHME
C     SEPARATION DES PARTIES SPHERIQUE ET DEVIATORIQUE
C     DE LA CONTRAINTE
C     SEULE LA PARTIE DEVIATORIQUE EST INCONNUE
C *****************************************************

C 3.1 - JE PREFERE REPASSER LES CONTRAINTES ET DEFORMATIONS
C       SANS LE SQRT(2)

        DO 20 I=1,NDIMSI
          SIGM(I)=SIGM2(I)
          EPSM(I)=EPSM2(I)
          DEPS(I)=DEPS2(I)
          IF (I.GE.4) THEN
            SIGM(I)=SIGM2(I)/SQRT(2.D0)
            EPSM(I)=EPSM2(I)/SQRT(2.D0)
            DEPS(I)=DEPS2(I)/SQRT(2.D0)            
          ENDIF
 20     CONTINUE

C 3.2 - TRACE

        EPSTH   = ALPHA*(TEMP-TREF)
        TRDEPS  = (DEPS(1)+DEPS(2)+DEPS(3))/3.D0
        TREPSM  = (EPSM(1)+EPSM(2)+EPSM(3))/3.D0
        TRSIGM = (SIGM(1)+SIGM(2)+SIGM(3))/3.D0
        TRSIGP = TROISK*(TREPSM+TRDEPS-EPSTH)
        
C 3.3 - DEVIATEUR DE LA CONTRAINTE ESSAI CONNUE DVSITR

        DO 25 I=1,NDIMSI
          DVDEPS(I)   = DEPS(I) - TRDEPS * KRON(I)
          DVSIGM(I)   = SIGM(I) - TRSIGM * KRON(I)
 25     CONTINUE

        DO 30 I=1,NDIMSI
          DVSITR(I) = MU*DVSIGM(I)/MUM + 2.D0*MU*DVDEPS(I)
 30     CONTINUE

C 3.4 - CONTRAINTE EQUIVALENTE ESSAI CONNUE EQSITR
        
        EQSITR = EDGEQU (NDIMSI,DVSITR,ANI)
        EQEPTR = EQSITR/(2.D0*MU)
        PM=VIM(1)

C ************************
C 4 - RESOLUTION
C ************************
C 4.1 - SI LA CONTRAINTE EQUIVALENTE ESSAI EST NULLE
C       ALORS SIGP=DVSITR + TRSIGP ET VIP(1)=VIM(1)

        IF (EQEPTR.LE.1.D-05) THEN

          DO 35 I = 1,NDIMSI
            SIGP(I) = DVSITR(I)+TRSIGP*KRON(I)
 35       CONTINUE
          VIP(1)=VIM(1)
          VIP(2)=0.D0
          
        ELSE

C 4.2 - SYSTEME NON LINEAIRE A RESOUDRE EN [DVEPEL,DP]
C       TEL QUE DVSIGP=2*MU*DVEPEL
C       DVEPEL PLUTOT QUE DVSIGP CAR MEME UNITE QUE DP 
C       G(Y)=0 
C       DIM=NDIMSI+1
C       Y(1)=DVEPEL(1)
C       Y(2)=DVEPEL(2)
C       Y(3)=DVEPEL(3) 
C       Y(4)=DVEPEL(4)
C       Y(5)=DVEPEL(5) (EN 3D)
C       Y(6)=DVEPEL(6) (EN 3D)
C       Y(DIM) = DP
C       POUR I ET J = 1 A NDIMSI
C       G(I)=Y(I)+Y(DIM)*ANI(I,J)*Y(J)/EQEPSEL-DVEPTR(I)
C       G(DIM)=EQEPSEL-GAMMA(K)*((PM+Y(DIM))**M(K))*(Y(DIM)**N(K))
C
C       CE SYSTEME EST RESOLU PAR UNE METHODE DE NEWTON
C       DG(I)/DY(J)*DY(J)=-G(I) => DY(I)=-(DG(I)/DY(J)**-1)*G(J)
C
C      L INVERSION DU SYSTEME EST FAITE DANS MGAUSS 
C      MGAUSS RESOUD AX=B
C      EN ENTREE A ET B
C      EN SORTIE (A**-1)*B STOCKEE DANS B
C      CORRESPONDANCE A=DG/DY
C                     B=-G D OU G=-G EN FAIT
C                     X=DY

C 4.2.1 - INITIALISATION DE LA METHODE DE NEWTON
C         CALCUL DE LA SOLUTION DU MODELE EDGAR
C         CORRESPONDANT A LA MATRICE ANI ISOTROPE
C         ON SE RAMENE A UNE SEULE EQUATION EN DP

          ITEMAX=NINT(CRIT(1))
          PREC=CRIT(3)
                    
          CALL EDGINI(ITEMAX,PREC,PM,EQSITR,MU,GAMMA,M,N,DP,IRE2)
          IF (IRE2.GT.0) THEN
            IRET  = 1
            GOTO 998
          ENDIF
          
          DO 40 I=1,NDIMSI
            DVSIGP(I) = (1.D0-3.D0*MU*DP/EQSITR)*DVSITR(I) 
            DVEPEL(I)= DVSIGP(I)/(2.D0*MU)
            Y(I)=DVEPEL(I)
 40       CONTINUE         
          Y(NDIMSI+1)=DP

C 4.2.2 - CALCUL DE G SA DERIVEE ET LE CRITERE D ARRET
C         LE CRITERE D ARRET EST LE MAX DE G

          CALL EDGANI (NDIMSI+1,Y,PM,DVSITR,EQSITR,MU,ANI,GAMMA,M,N,
     1                 G,MAXG,DGDY)

C 4.2.3 - ITERATION DE NEWTON
C ATTENTION SI W MATRICE DGDY MODIFIE
          
          DO 50 ITER = 1, ITEMAX
            IF (MAXG.LE.PREC) GOTO 999

            CALL MGAUSS('NFSP',DGDY,G,NDIMSI+1,NDIMSI+1,1,RBID,IRE2)

            IF (IRE2.GT.0) THEN
              IRET  = 1
              GOTO 998
            ENDIF
            
            DO 55 I=1,NDIMSI+1
              Y(I)=Y(I)+G(I)
              IF (I.LE.NDIMSI) DVSIGP(I)=2.D0*MU*Y(I)
  55        CONTINUE

            IF (Y(NDIMSI+1).LE.0.D0) THEN
              IRET  = 1
              GOTO 998
            ENDIF

            CALL EDGANI (NDIMSI+1,Y,PM,DVSITR,EQSITR,MU,ANI,GAMMA,M,N,
     1                   G,MAXG,DGDY)

 50       CONTINUE
          
          IRET  = 1
          GOTO 998

 999      CONTINUE
                    
C 4.2.3 - CALCUL DE SIGMA ET P
          
          DO 60 I = 1,NDIMSI
            SIGP(I) = DVSIGP(I)+TRSIGP*KRON(I)
 60       CONTINUE  
          DP=Y(NDIMSI+1)
          VIP(1)=VIM(1)+DP
          VIP(2)=1.D0
        ENDIF
      
      ENDIF          

C *******************************
C 5 - MATRICE TANGENTE DSIGDE
C *******************************
C SI RIGI               => MATRICE ELASTIQUE A TM
C SI FULL MAIS VIP(2)=0 => MATRICE ELASTIQUE A TP
C SI FULL MAIS VIP(2)=1 => MATRICE COHERENTE A TP

      IF (RIGI) THEN
        IF ((OPTION(1:4).EQ.'RIGI').OR.
     1    ((OPTION(1:4).EQ.'FULL').AND.(VIP(2).EQ.0.D0)))THEN

          DO 70 I=1,NDIMSI
            DO 75 J=1,NDIMSI
              DSIDEP(I,J)=0.D0
 75         CONTINUE
 70       CONTINUE
          
          DO 80 I=1,NDIMSI
            IF (I.LE.3) DSIDEP(I,I)=(4.D0*MU/3.D0)+TROISK/3.D0
            IF (I.GT.3) DSIDEP(I,I)=2.D0*MU
 80       CONTINUE          
          
          DO 90 I=1,3
            DO 95 J=1,3
              IF (I.NE.J) DSIDEP(I,J)=(-2.D0*MU/3.D0)+TROISK/3.D0
 95         CONTINUE
 90       CONTINUE
        ENDIF
        
        IF ((OPTION(1:4).EQ.'FULL').AND.(VIP(2).EQ.1.D0))THEN        

          DO 200 J=1,NDIMSI
            DO 201 I=1,NDIMSI+1
              R1(I,J)=0.D0
 201        CONTINUE
            R1(J,J)=1.D0
 200      CONTINUE           
            
          DO 202 I=1,NDIMSI+1
            DO 203 K=1,NDIMSI+1
              MAT(I,K)=DGDY(I,K)
              IF (K.GE.4) MAT(I,K)=MAT(I,K)/2.D0
 203        CONTINUE
 202      CONTINUE
            
          CALL MGAUSS('NFSP',MAT,R1,NDIMSI+1,NDIMSI+1,NDIMSI,RBID,IRE2)
          IF (IRE2.GT.0) THEN
            IRET  = 1
            GOTO 998
          ENDIF
          
          DO 204 J=1,NDIMSI  
            DO 205 I=1,NDIMSI
              H1(I,J)=R1(I,J)
 205        CONTINUE
 204      CONTINUE          

C ON COMPLETE 

          DO 206 I=1,NDIMSI
            VECT(I)=H1(I,1)+H1(I,2)+H1(I,3)
            VECT(I)=-2.D0*MU*VECT(I)
            IF (I.LE.3) VECT(I)=VECT(I)+TROISK
            VECT(I)=VECT(I)/3.D0
 206      CONTINUE
          
          DO 207 I=1,NDIMSI
            DO 208 J=1,NDIMSI
               H1(I,J)=2.D0*MU*H1(I,J)
               IF (J.LE.3) H1(I,J)=H1(I,J)+VECT(I)
 208        CONTINUE
 207      CONTINUE

C ON AFFECTE H1 A DSIDEP AVEC LES RACINE DE 2 POUR I NE J

         DO 400 I=1,NDIMSI
            DO 410 J=1,NDIMSI
              DSIDEP(I,J)=H1(I,J)              
         IF ((I.EQ.J).AND.(I.GE.4)) DSIDEP(I,J)=2.D0*DSIDEP(I,J)/4.D0
              IF ((I.NE.J).AND.((I.GE.4).OR.(J.GE.4))) THEN
                DSIDEP(I,J)=SQRT(2.D0)*DSIDEP(I,J)/2.D0
              ENDIF
 410        CONTINUE
 400      CONTINUE         
        ENDIF                      
      ENDIF

C *************************************
C 6 - ON REPASSE SIGP AVEC LE SQRT(2)
C *************************************
      
      IF (RESI) THEN
        DO 160 I=4,NDIMSI
          SIGP(I)=SIGP(I)*SQRT(2.D0)
 160    CONTINUE
      ENDIF
      
 998  CONTINUE     
      
      END
