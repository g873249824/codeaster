      SUBROUTINE NIFINT(NDIM,NNO1,NNO2,NNO3,NPG,IW,VFF1,VFF2,VFF3,
     &   IDFF1,IDFF2,DFF1,DFF2,VU,VG,VP,
     &   GEOMI,TYPMOD,OPTION,MATE,COMPOR,LGPG,CRIT,INSTM,INSTP,
     &   DDLM,DDLD,ANGMAS,SIGM,VIM,SIGP,VIP,VECT,MATR,
     &   CODRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2012   AUTEUR SFAYOLLE S.FAYOLLE 
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
C TOLE CRP_21

      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  TYPMOD(*)
      CHARACTER*16 COMPOR(*),OPTION
      INTEGER MATE,NDIM,NPG,NNO1,NNO2,NNO3,IW,IDFF1,IDFF2,CODRET,LGPG
      INTEGER VU(3,27),VG(27),VP(27)
      REAL*8 VFF1(NNO1,NPG),VFF2(NNO2,NPG),VFF3(NNO3,NPG),CRIT(*)
      REAL*8 INSTM,INSTP,ANGMAS(7)
      REAL*8 GEOMI(NDIM,NNO1),DDLM(*),DDLD(*),SIGM(2*NDIM,NPG)
      REAL*8 SIGP(2*NDIM,NPG),VIM(LGPG,NPG),VIP(LGPG,NPG)
      REAL*8 DFF1(NNO1,4),DFF2(NNO2,3)
      REAL*8 VECT(*),MATR(*)
C-----------------------------------------------------------------------
C          CALCUL DES OPTIONS DE MECANIQUE NON LINEAIRE
C           GRANDES DEFORMATIONS QUASI-INCOMPRESSIBLES
C          3D/D_PLAN/AXIS
C          ROUTINE APPELEE PAR TE0454
C-----------------------------------------------------------------------
C IN NDIM     : DIMENSION DE L'ESPACe
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AU GONFLEMENT
C IN  NNO3    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES AU GONFLEMENT
C IN  VFF3    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C IN  IDFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  IDFF2   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C OUT DFF1    : DERIVEE FONCTION DE FORME (PT DE GAUSS COURANT) A T+
C OUT DFF2    : DERIVEE FONCTION DE FORME (PT DE GAUSS COURANT)
C IN  VU
C IN  VG
C IN  VP
C IN  GEOMI   : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  MATE    : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTM   : INSTANT PRECEDENT
C IN  INSTP   : INSTANT DE CALCUL
C IN  DDLM    : DEGRES DE LIBERTE A L'INSTANT PRECEDENT
C IN  DDLD    : INCREMENT DES DEGRES DE LIBERTE
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT VECT    : FORCES INTERNES
C OUT MATR    : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
C OUT CODRET  : CODE RETOUR
C-----------------------------------------------------------------------


      INTEGER K2RET
      LOGICAL AXI,GRAND,RESI,RIGI,NONLOC
      INTEGER NDDL,NDU,VIJ(3,3),OS,KK
      INTEGER LIJ(3,3)
      INTEGER G,IA,NA,RA,SA,IB,NB,RB,SB,JA,JB,IJA,KL,COD(27)
      REAL*8 RAC2
      REAL*8 GEOMM(3*27),GEOMP(3*27),DEPLM(3*27),DEPLD(3*27)
      REAL*8 GM,GD,GP,PM,PD,PP,R,W,WM,WP,JM,JD,JP
      REAL*8 FM(3,3),FD(3,3),EPSM(6),EPSD(6),CORM,CORD,FTD(3,3),FTM(3,3)
      REAL*8 SIGMAM(6),TAUP(6),TAUHY,TAUDV(6),TAULDC(6)
      REAL*8 DSIDEP(6,3,3),H(3,3),D(6,3,3),HHY,HDV(3,3),DHY(6)
      REAL*8 GRADGP(3),C,PRESM(27),PRESD(27),GONFM(27),GONFD(27)
      REAL*8 DDOT,TAMPON(10),T1,T2,ID(3,3),KR(6),RBID
      REAL*8 AM,AP,BP,BOA,AA,BB,DAA,DBB,DBOA,D2BOA

      PARAMETER (GRAND = .TRUE.)
      DATA    KR   /1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA    ID   /1.D0, 0.D0, 0.D0,
     &              0.D0, 1.D0, 0.D0,
     &              0.D0, 0.D0, 1.D0/
      DATA    VIJ  / 1, 4, 5,
     &               4, 2, 6,
     &               5, 6, 3 /
C-----------------------------------------------------------------------

C - INITIALISATION

      RAC2 = SQRT(2.D0)
      AXI  = TYPMOD(1).EQ.'AXIS'
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'
      NDDL = NNO1*NDIM + NNO2 + NNO3
      NDU  = NDIM
      IF (AXI) NDU = 3

C    REACTUALISATION DE LA GEOMETRIE ET EXTRACTION DES CHAMPS
      DO 10 NA = 1,NNO1
        DO 11 IA = 1,NDIM
          GEOMM(IA+NDIM*(NA-1)) = GEOMI(IA,NA) + DDLM(VU(IA,NA))
          GEOMP(IA+NDIM*(NA-1)) = GEOMM(IA+NDIM*(NA-1))+DDLD(VU(IA,NA))
          DEPLM(IA+NDIM*(NA-1)) = DDLM(VU(IA,NA))
          DEPLD(IA+NDIM*(NA-1)) = DDLD(VU(IA,NA))
 11     CONTINUE
 10   CONTINUE
      DO 20 RA = 1,NNO2
        GONFM(RA) = DDLM(VG(RA))
        GONFD(RA) = DDLD(VG(RA))
 20   CONTINUE
      DO 30 SA = 1,NNO3
        PRESM(SA) = DDLM(VP(SA))
        PRESD(SA) = DDLD(VP(SA))
 30   CONTINUE

      IF (RESI) CALL R8INIR(NDDL,0.D0,VECT,1)
      IF (RIGI) CALL R8INIR(NDDL*NDDL,0.D0,MATR,1)
      CALL R8INIR(6 ,0.D0,SIGMAM,1)
      CALL R8INIR(6 ,0.D0,TAUP,1)
      CALL R8INIR(54,0.D0,DSIDEP,1)

C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 1000 G = 1,NPG

C      LONGUEUR CARACTERISTIQUE -> PARAMETRE C
        C=0.D0
        CALL RCVALA(MATE,' ','NON_LOCAL',0,' ',0.D0,
     &              1,'C_GONF',C,K2RET,0)
        NONLOC = K2RET.EQ.0 .AND. C.NE.0.D0

C      CALCUL DES DEFORMATIONS
        CALL DFDMIP(NDIM,NNO1,AXI,GEOMI,G,IW,VFF1(1,G),IDFF1,R,W,DFF1)
        CALL NMEPSI(NDIM,NNO1,AXI,GRAND,VFF1(1,G),R,DFF1,DEPLM,FM,EPSM)
        CALL DFDMIP(NDIM,NNO1,AXI,GEOMM,G,IW,VFF1(1,G),IDFF1,R,WM,DFF1)
        CALL NMEPSI(NDIM,NNO1,AXI,GRAND,VFF1(1,G),R,DFF1,DEPLD,FD,EPSD)
        CALL DFDMIP(NDIM,NNO1,AXI,GEOMP,G,IW,VFF1(1,G),IDFF1,R,WP,DFF1)

        CALL NMMALU(NNO1,AXI,R,VFF1(1,G),DFF1,LIJ)
        JM = FM(1,1)*(FM(2,2)*FM(3,3)-FM(2,3)*FM(3,2))
     &     - FM(2,1)*(FM(1,2)*FM(3,3)-FM(1,3)*FM(3,2))
     &     + FM(3,1)*(FM(1,2)*FM(2,3)-FM(1,3)*FM(2,2))
        JD = FD(1,1)*(FD(2,2)*FD(3,3)-FD(2,3)*FD(3,2))
     &     - FD(2,1)*(FD(1,2)*FD(3,3)-FD(1,3)*FD(3,2))
     &     + FD(3,1)*(FD(1,2)*FD(2,3)-FD(1,3)*FD(2,2))
        JP = JM*JD

C      PERTINENCE DES GRANDEURS
        IF (JD.LE.1.D-2 .OR. JD.GT.1.D2) THEN
          CODRET = 1
          GOTO 9999
        END IF


C      CALCUL DE LA PRESSION ET DU GONFLEMENT AU POINT DE GAUSS
        GM = DDOT(NNO2,VFF2(1,G),1,GONFM,1)
        GD = DDOT(NNO2,VFF2(1,G),1,GONFD,1)
        GP = GM + GD

        PM = DDOT(NNO3,VFF3(1,G),1,PRESM,1)
        PD = DDOT(NNO3,VFF3(1,G),1,PRESD,1)
        PP = PM + PD

C     CALCUL DES FONCTIONS A, B,... DETERMINANT LA RELATION LIANT G ET J
        CALL NIRELA(1,JP,GM,GP,AM,AP,BP,BOA,AA,BB,DAA,DBB,DBOA,D2BOA)

C      PERTINENCE DES GRANDEURS
        IF (JD.LE.1.D-2 .OR. JD.GT.1.D2) THEN
          CODRET = 1
          GOTO 9999
        END IF
        IF (ABS(AP/AM).GT.1.D2) THEN
          CODRET = 1
          GOTO 9999
        END IF

C      CALCUL DU GRADIENT DU GONFLEMENT POUR LA REGULARISATION
        IF (NONLOC) THEN
          CALL DFDMIP(NDIM,NNO2,AXI,GEOMI,G,IW,VFF2(1,G),IDFF2,R,W,DFF2)
          DO 100 KL = 1,NDIM
            GRADGP(KL) = DDOT(NNO2,DFF2(1,KL),1,GONFM,1)
     &               + DDOT(NNO2,DFF2(1,KL),1,GONFD,1)
 100      CONTINUE
        END IF

C     CALCUL DES DEFORMATIONS ENRICHIES
        CORM = (AM/JM)**(1.D0/3.D0)
        CALL DCOPY(9,FM,1,FTM,1)
        CALL DSCAL(9,CORM,FTM,1)

        CORD = (AP/AM/JD)**(1.D0/3.D0)
        CALL DCOPY(9,FD,1,FTD,1)
        CALL DSCAL(9,CORD,FTD,1)

C -   APPEL A LA LOI DE COMPORTEMENT

C      POUR LES LOIS QUI NE RESPECTENT PAS ENCORE LA NOUVELLE INTERFACE
C      ET QUI UTILISENT ENCORE LA CONTRAINTE EN T-
        CALL DCOPY(NDIM*2,SIGM(1,G),1,SIGMAM,1)

        COD(G) = 0
        CALL NMCOMP('RIGI',G,1,3,TYPMOD,MATE,COMPOR,CRIT,
     &             INSTM,INSTP,9,FTM,FTD,
     &             6,SIGMAM,VIM(1,G),OPTION,ANGMAS,10,TAMPON,
     &             TAUP,VIP(1,G),54,DSIDEP,1,RBID,COD(G))

        IF (COD(G).EQ.1) THEN
          CODRET = 1
          IF (.NOT. RESI) CALL U2MESS('F','ALGORITH14_75')
          GOTO 9999
        ENDIF

C      SUPPRESSION DES RACINES DE 2
        IF (RESI) CALL DSCAL(3,1/RAC2,TAUP(4),1)

C      MATRICE TANGENTE SANS LES RACINES DE 2
        IF (RIGI) THEN
          CALL DSCAL(9,1/RAC2,DSIDEP(4,1,1),6)
          CALL DSCAL(9,1/RAC2,DSIDEP(5,1,1),6)
          CALL DSCAL(9,1/RAC2,DSIDEP(6,1,1),6)
        END IF


C - CONTRAINTE ET FORCES INTERIEURES

        IF (RESI) THEN

C        CONTRAINTE DE CAUCHY A PARTIR DE KIRCHHOFF
          CALL DCOPY(2*NDIM,TAUP,1,SIGP(1,G),1)
          CALL DSCAL(2*NDIM,1.D0/JP,SIGP(1,G),1)

C        CONTRAINTE HYDROSTATIQUE ET DEVIATEUR
          TAUHY = (TAUP(1)+TAUP(2)+TAUP(3))/3.D0
          DO 200 KL = 1,6
            TAUDV(KL) = TAUP(KL) - TAUHY*KR(KL)
 200      CONTINUE

C        VECTEUR FINT:U
          DO 300 NA=1,NNO1
            DO 310 IA=1,NDU
              KK = VU(IA,NA)
              T1 = 0.D0
              DO 320 JA = 1,NDU
                T2 = TAUDV(VIJ(IA,JA)) + PP*BB*ID(IA,JA)
                T1 = T1 + T2*DFF1(NA,LIJ(IA,JA))
 320          CONTINUE
              VECT(KK) = VECT(KK) + W*T1
 310        CONTINUE
 300      CONTINUE

C        VECTEUR FINT:G
          T2 = TAUHY*AA - PP*DBOA
          DO 350 RA=1,NNO2
            KK = VG(RA)
            T1 = VFF2(RA,G)*T2
            VECT(KK) = VECT(KK) + W*T1
 350      CONTINUE

          IF (NONLOC) THEN
            DO 355 RA=1,NNO2
              KK = VG(RA)
              T1 = C*DDOT(NDIM,GRADGP,1,DFF2(RA,1),NNO2)
              VECT(KK) = VECT(KK) + W*T1
 355        CONTINUE
          END IF

C        VECTEUR FINT:P
          T2 = BP - BOA
          DO 370 SA=1,NNO3
            KK = VP(SA)
            T1 = VFF3(SA,G)*T2
            VECT(KK) = VECT(KK) + W*T1
 370      CONTINUE

        END IF


C - MATRICE TANGENTE

        IF (RIGI) THEN

          IF (.NOT. RESI) THEN
            CALL DCOPY(2*NDIM,SIGM(1,G),1,TAUP,1)
            CALL DSCAL(2*NDIM,JM,TAUP,1)
          END IF

C        CALCUL DU TENSEUR DE CONTRAINTE
          TAUHY = (TAUP(1)+TAUP(2)+TAUP(3))/3.D0
          DO 380 KL = 1,6
            TAULDC(KL) = TAUP(KL) + (PP*BB-TAUHY)*KR(KL)
 380      CONTINUE

C        PROJECTIONS DEVIATORIQUES ET HYDROSTATIQUES DE LA MAT. TANG.
          DO 400 IA = 1,3
          DO 410 JA = 1,3
            H(IA,JA)=(DSIDEP(1,IA,JA)+DSIDEP(2,IA,JA)
     &               +DSIDEP(3,IA,JA))/3.D0
            DO 420 KL = 1,6
              D(KL,IA,JA) = DSIDEP(KL,IA,JA) - KR(KL)*H(IA,JA)
 420        CONTINUE
 410      CONTINUE
 400      CONTINUE

          HHY = (H(1,1)+H(2,2)+H(3,3))/3.D0
          DO 450 IA = 1,3
          DO 455 JA = 1,3
            HDV(IA,JA) = H(IA,JA) - HHY*ID(IA,JA)
 455      CONTINUE
 450      CONTINUE
          DO 460 KL = 1,6
            DHY(KL) = (D(KL,1,1)+D(KL,2,2)+D(KL,3,3))/3.D0
 460      CONTINUE

          DO 500 NA = 1,NNO1
          DO 510 IA = 1,NDU
            OS = (VU(IA,NA)-1)*NDDL

C          TERME K:UU
            DO 520 NB = 1,NNO1
            DO 530 IB = 1,NDU
              KK = OS+VU(IB,NB)
              T1 = 0.D0
              DO 550 JA = 1,NDU
              DO 560 JB = 1,NDU
                IJA = VIJ(IA,JA)
                T2 = D(IJA,IB,JB)-DHY(IJA)*ID(IB,JB)
                T1 =  T1 + DFF1(NA,LIJ(IA,JA))*T2*DFF1(NB,LIJ(IB,JB))
 560          CONTINUE
 550          CONTINUE

              T2 = PP*JP*DBB
              T1 = T1 + DFF1(NA,LIJ(IA,IA))*T2*DFF1(NB,LIJ(IB,IB))

C            RIGIDITE GEOMETRIQUE
              DO 570 JB = 1,NDU
                T1 = T1 - DFF1(NA,LIJ(IA,IB))*DFF1(NB,LIJ(IB,JB))
     &                    *TAULDC(VIJ(IA,JB))
 570          CONTINUE
              MATR(KK) = MATR(KK) + W*T1
 530        CONTINUE
 520        CONTINUE


C          TERME K:UG
            DO 600 RB = 1,NNO2
              KK = OS + VG(RB)
              T1 = 0.D0
              DO 610 JA = 1,NDU
                T2 = DHY(VIJ(IA,JA))*AA
                T1 = T1 + DFF1(NA,LIJ(IA,JA))*T2*VFF2(RB,G)
 610          CONTINUE
              MATR(KK) = MATR(KK) + W*T1
 600        CONTINUE

C          TERME K:UP
            DO 650 SB = 1,NNO3
              KK = OS + VP(SB)
              T1 = DFF1(NA,LIJ(IA,IA))*BB*VFF3(SB,G)
              MATR(KK) = MATR(KK) + W*T1
 650        CONTINUE
 510      CONTINUE
 500      CONTINUE

          DO 700 RA = 1,NNO2
            OS = (VG(RA)-1)*NDDL

C          TERME K:GU
            DO 710 NB = 1,NNO1
            DO 715 IB = 1,NDU
              KK = OS + VU(IB,NB)
              T1 = 0.D0
              DO 720 JB = 1,NDU
                T1 = T1 + VFF2(RA,G)*AA*HDV(IB,JB)*DFF1(NB,LIJ(IB,JB))
 720          CONTINUE
              MATR(KK) = MATR(KK) + W*T1
 715        CONTINUE
 710        CONTINUE

C          TERME K:GG
            DO 730 RB = 1,NNO2
              KK = OS + VG(RB)
              T2 = HHY*AA**2 - PP*D2BOA + TAUHY*DAA
              T1 = VFF2(RA,G)*T2*VFF2(RB,G)
              MATR(KK) = MATR(KK) + W*T1
 730        CONTINUE

            IF (NONLOC) THEN
              DO 735 RB = 1,NNO2
                KK = OS + VG(RB)
                T1 = C*DDOT(NDIM,DFF2(RA,1),NNO2,DFF2(RB,1),NNO2)
                MATR(KK) = MATR(KK) + W*T1
 735          CONTINUE
            END IF

C          TERME K:GP
            DO 740 SB = 1,NNO3
              KK = OS + VP(SB)
              T1 = - VFF2(RA,G)*DBOA*VFF3(SB,G)
              MATR(KK) = MATR(KK) + W*T1
 740        CONTINUE
 700      CONTINUE

          DO 750 SA = 1,NNO3
            OS = (VP(SA)-1)*NDDL

C          TERME K:PU
            DO 760 NB = 1,NNO1
            DO 765 IB = 1,NDU
              KK = OS + VU(IB,NB)
              T1 = VFF3(SA,G)*BB*DFF1(NB,LIJ(IB,IB))
              MATR(KK) = MATR(KK) + W*T1
 765        CONTINUE
 760        CONTINUE

C          TERME K:PG
            DO 780 RB = 1,NNO2
              KK = OS + VG(RB)
              T1 = - VFF3(SA,G)*DBOA*VFF2(RB,G)
              MATR(KK) = MATR(KK) + W*T1
 780        CONTINUE

 750      CONTINUE

        END IF

 1000 CONTINUE

C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NPG,CODRET)

 9999 CONTINUE
      END
