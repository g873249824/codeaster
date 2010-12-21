      SUBROUTINE GERPAS( FAMI, KPG, KSP,
     &                   COMP,    MOD,    IMAT, MATCST,NBCOMM,
     &                   CPMONO, NBPHAS, NVI,     NMAT,  Y,
     &                   PAS,  ITMAX,   EPS,    TOLY,  COTHE, COEFF,
     &                   DCOTHE,DCOEFF,E,NU,ALPHA,COEL,PGL, ANGMAS,
     &                   SIGI,    EPSD,   DETOT, X , HSR)
      IMPLICIT NONE
C     ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21 CRS_1404
C
C     INTEGRATION DE LOIS DE COMPORTEMENT ELASTO-VISCOPLASTIQUE
C     PAR UNE METHODE DE RUNGE KUTTA
C
C     GESTION AUTOMATIQUE DES PAS DE TEMPS
C     -
C       IN   FAMI :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C         KPG,KSP :  NUMERO DU (SOUS)POINT DE GAUSS
C         LOI     :  NOM DU MODELE DE COMPORTEMENT
C         MOD     :  TYPE DE MODELISATION
C         IMAT    :  CODE DU MATERIAU CODE
C         MATCST  : 'OUI' SI MATERIAU CST ENTRE T ET T+DT
C                   'NAP' SI LE PARAMETRE K_D EST UNE NAPPE
C                   'NON' SINON
C         N       :  NOMBRE DE VARIABLES INTERNES
C         NMAT    :  NOMBRE DE PARAMETRES MATERIAU
C         Y       :  VARIABLES INTERNES
C         PAS     :  INTERVALLE DE TEMPS TF-TD
C         EPS     :  PARAMETRE DE CONVERGENCE CRIT(3) POUR RK21CO
C         TOLY    :  CRITERE DE CONVERGENCE POUR GERPAS
C         COTHE   :  COEFFICIENTS MATERIAU ELAS A T
C         COEFF   :  COEFFICIENTS MATERIAU INELAS A T
C         DCOTHE  :  COEFFICIENTS MATERIAU ELAS A T+DT
C         DCOEFF  :  COEFFICIENTS MATERIAU INELAS A T+DT
C         E       :  COEFFICIENT MODULE D'YOUNG
C         NU      :  COEFFICIENT DE POISSON
C         ALPHA   :  COEFFICIENT DE DILATATION THERMIQUE
C         SIGI    :  CONTRAINTES A L'INSTANT COURANT
C         EPSD    :  DEFORMATION TOTALE A T
C         DETOT   :  INCREMENT DE DEFORMATION TOTALE
C     OUT X       :  INSTANT COURANT
C     -
      INTEGER  NMAT,IMAT,NBCOMM(NMAT,3),NE,NY,NA,NVI,KPOK,IP,I,II
      INTEGER  NBPHAS,NBFSYM,KPG,KSP,ITMAX,IRET
C     NOMBRE MAXI DE FAMILLES DE SYSTEMES DE GLISSEMENT / MONOCRISTAL
      PARAMETER (NBFSYM=5)
C      POUR GAGNER EN TEMPS CPU
      REAL*8 TOUTMS(NBPHAS,NBFSYM,24,6)
      CHARACTER*16 LOI,COMP(*),CPMONO(5*NMAT+1)
      CHARACTER*8  MOD
      CHARACTER*3  MATCST
      CHARACTER*(*) FAMI
      REAL*8 E, NU, ALPHA, COEL(NMAT),HSR(5,24,24)
      REAL*8 X, PAS, H, TOLY, XOUT, XR, W, WZ, DMG0
      REAL*8 DMG1,EPS
      REAL*8 COTHE(NMAT),DCOTHE(NMAT)
      REAL*8 COEFF(NMAT),DCOEFF(NMAT)
      REAL*8 SIGI(6),EPSD(6),DETOT(6),PGL(3,3),ANGMAS(3)
C     TABLEAUX AUTOMATIQUES F90
      REAL*8 Y(NVI),WK(3*NVI),YMFS(NVI)
      REAL*8 MAXOUT,MAXDOM
      PARAMETER     ( MAXDOM = 9.90D-01  )
C
      LOI=COMP(1)
      IF (LOI(1:8).EQ.'POLYCRIS') THEN
         CALL CALCMS( NBPHAS,NBFSYM,NBCOMM,CPMONO,NMAT,PGL,
     &                COEFF,ANGMAS,TOUTMS )
      ENDIF
C
      DMG1=0.0D0
      IRET=0
C
      MAXOUT=MAXDOM-(EPS)
      NE=0
      NY=NVI
      NA=NY+NVI
      KPOK=1
      X=0.0D0
      H=PAS
      IP=0

      DO 10 I=1,NVI
        YMFS(I)=MAX(TOLY,ABS(Y(I)))
   10 CONTINUE

      XOUT=PAS
   40 CONTINUE
      IF ((X+H).GE.XOUT) THEN
        H=XOUT-X
        IP=1
      ENDIF

      DO 50 I=1,NVI
        WK(NY+I)=Y(I)
   50 CONTINUE

      XR=X
   60 CONTINUE

      CALL RK21CO(FAMI,KPG,KSP,
     &            COMP,MOD,IMAT,MATCST,NBCOMM,CPMONO,NBFSYM,TOUTMS,
     &            NVI,NMAT,Y,KPOK,WK(NE+1),WK(NA+1),H,PGL,NBPHAS,
     &            COTHE,COEFF,DCOTHE,DCOEFF,E,NU,ALPHA,COEL,X,PAS,
     &            SIGI,EPSD,DETOT,HSR,ITMAX,EPS,IRET)
      IF (IRET.GT.0) THEN
          GOTO 9999
      ENDIF


      W=ABS(WK(1))/YMFS(1)
      DO 70 I=2,NVI
        WZ=ABS(WK(I))/YMFS(I)
        IF (WZ.GT.W) W=WZ
   70 CONTINUE

      IF (W.LE.EPS) THEN

         KPOK=1

         IF (IP.EQ.1) THEN

            GOTO 9999

         ELSE

            IF (LOI(1:9).EQ.'VENDOCHAB') THEN
C              TRAITEMENT VENDOCHAB
C              TEST SUR LE NIVEU DE DOMMAGE--
               IF (Y(9).GE.MAXDOM) THEN
                  DMG0=(Y(9)-WK(NE+9))-(WK(NA+9)*H)
                  IF (DMG0.GE.MAXOUT) THEN
                     DO 99 II=1,NVI
                        Y(II)=(Y(II)-WK(NE+II))-(WK(NA+II)*H)
   99                CONTINUE
                     GOTO 9999
                  ELSE
                     H=(MAXOUT-DMG0)/((WK(NE+9)/H)+WK(NA+9))
                     IF (H.GT.PAS) H=PAS
                     GOTO 40
                  ENDIF
               ELSE
C                 FIN TEST SUR LE NIVEU DE DOMMAGE
                  W=W/ABS(EPS)
                  W=MAX(W,1.0D-05)
                  H=H*W**(-2.0D-01)*9.0D-01
                  IF (H.GT.PAS) H=PAS
                  GOTO 40
               ENDIF
C              FIN TRAITEMENT VENDOCHAB

            ELSE
C              IP.NE.1
               W=W/ABS(EPS)
               W=MAX(W,1.0D-05)
               H=H*W**(-2.0D-01)*9.0D-01
               IF (H.GT.PAS) H=PAS
               GOTO 40

            ENDIF

         ENDIF

      ELSE

C      W.GT.EPS : NON CV

         KPOK=0
         DO 80 I=1,NVI
           Y(I)=WK(NY+I)
   80    CONTINUE
         X=XR
         IP=0

         IF (LOI(1:9).EQ.'VENDOCHAB') THEN
C           TRAITEMENT VENDOCHAB
            DMG1=Y(9)
C           TEST SUR LE NIVEU DE DOMMAGE--
            IF (DMG1.GE.MAXDOM) THEN
               DMG0=(DMG1-WK(NE+9))-(WK(NA+9)*H)
               H=(MAXOUT-DMG0)/((WK(NE+9)/H)+WK(NA+9))
               IF (H.LT.1.0D-20) THEN
                  CALL U2MESS('S','ALGORITH3_83')
               ENDIF
               GOTO 60
            ELSE
               W=W/ABS(EPS)
               W=MIN(W,1.0D08)
               H=H*W**(-2.0D-01)*9.0D-01
               IF (H.LT.1.0D-20) THEN
                  CALL U2MESS('S','ALGORITH3_83')
               ENDIF
               GOTO 60
            ENDIF
C           FIN TEST SUR LE NIVEU DE DOMMAGE

         ELSE

            W=W/ABS(EPS)
            W=MIN(W,1.0D08)
            H=H*W**(-2.0D-01)*9.0D-01
            IF (H.LT.1.0D-20) THEN
               CALL U2MESS('S','ALGORITH3_83')
            ENDIF
C           INSTRUCTION SUIVANTE INUTILE. VAUDRAIT MIEUX SORTIR
C           AVEC UN CODE RETOUR POSITIF POUR REDECOUPAGE GLOBAL
            GOTO 60
         ENDIF

      ENDIF

 9999 CONTINUE

      END
