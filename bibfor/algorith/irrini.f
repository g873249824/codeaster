      SUBROUTINE IRRINI (FAMI, KPG, KSP, TYPESS, ESSAI, MOD,
     &                   NMAT, MATERF, YD,  DEPS, DY  )

      IMPLICIT NONE

      INTEGER TYPESS, NMAT, KPG, KSP
      REAL*8  ESSAI, MATERF(NMAT,2), YD(*), DEPS(6),DY(*)
      CHARACTER*8 MOD
      CHARACTER*(*) FAMI

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/12/2007   AUTEUR FLEJOU J-L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE FLEJOU J-L.FLEJOU
C       IRRAD3M : CALCUL SOLUTION ESSAI DY = ( DSIG DX1 DX2 DP (DEPS3))
C                               AVEC     Y  = ( SIG  X1  X2  P  (EPS3))
C       IN  ESSAI  :  VALEUR DE LA SOLUTION D ESSAI
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION MATER
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           YD     :  VARIABLES A T   = ( SIG  VIN  (EPS3)  )
C       VAR DEPS   :  INCREMENT DE DEFORMATION
C           TYPESS :  TYPE DE SOLUTION D ESSAI
C                               0 = NUL(0)
C                               1 = ELASTIQUE
C                               2 = EXPLICITE (=-1 INITIALEMENT)
C                               3 = ESSAI
C       OUT DY     :  SOLUTION ESSAI  = ( DSIG DVIN (DEPS3) )
C     ----------------------------------------------------------------
      COMMON /TDIM/   NDT , NDI
C     ----------------------------------------------------------------
      REAL*8 HOOK(6,6),DEV(6),S,DFDS(6),VTMP1(6),VTMP2(6)
      REAL*8 DPHI,ID3D(6),NUN, SIG(6), P, ETAI
      REAL*8 K,N,P0,AI0,ETAIS,AG, IRRAD, IRRAF, ZETAF, ZETAG
      REAL*8 DETAI, DPI, DP, DG, YY, XX, ZZ, DSIG
      REAL*8 PENPE,PE,PK
      INTEGER NDT, NDI, IRET, I
      DATA ID3D /1.D0, 1.D0, 1.D0, 0.D0, 0.D0, 0.D0/

      IF ( TYPESS .EQ. -1 ) TYPESS = 2
      CALL LCEQVN ( NDT , YD(1)       , SIG )
      P    = YD(NDT+1)
      ETAI = YD(NDT+2)

C     PARAMETRES MATERIAUX
      AI0   = MATERF(4,2)
      ETAIS = MATERF(5,2)
      AG    = MATERF(6,2)
      K     = MATERF(7,2)
      N     = MATERF(8,2)
      P0    = MATERF(9,2)
      ZETAF = MATERF(12,2)
      PENPE = MATERF(13,2)
      PK    = MATERF(14,2)
      PE    = MATERF(15,2)
      ZETAG = MATERF(17,2)

C     POUR LES CONTRAINTES PLANES
      NUN   = MATERF(2,1) / (1.D0-MATERF(2,1))

      TYPESS=1
C     SOLUTION NULLE ( TYPESS=0) OU ELASTIQUE ( TYPESS=1)
      IF ( TYPESS .EQ. 0 .OR. TYPESS .EQ. 1 ) THEN
         CALL LCINVN( NDT+4 , 0.D0 , DY )
         IF(MOD(1:6).EQ.'C_PLAN') THEN
            DEPS(3) = 0.D0
            DY(NDT+5)=0.D0
         ENDIF

         IF ( TYPESS.EQ.1) THEN
            CALL LCOPLI ( 'ISOTROPE' , MOD , MATERF(1,1) , HOOK )
            CALL LCPRMV (HOOK,DEPS,DY)
         ENDIF

C        SOLUTION EXPLICITE
      ELSE IF (TYPESS.EQ.2) THEN
         CALL LCOPLI ( 'ISOTROPE' , MOD , MATERF(1,1) , HOOK )
         CALL RCVARC('F','IRRA','-',FAMI,KPG,KSP,IRRAD,IRET)
         CALL RCVARC('F','IRRA','+',FAMI,KPG,KSP,IRRAF,IRET)
C        ARRET DANS IRRMAT SI  IRRAD .GT. IRRAF*1.00001
         IF ( IRRAD .GT. IRRAF ) THEN
            DPHI = 0.0D0
         ELSE
            DPHI = IRRAF - IRRAD
         ENDIF

         CALL LCDEVI(SIG,DEV)
         CALL LCNRVE ( DEV  , S )
         S =  SQRT ( 1.5D0 ) * S

C DETAI
         DETAI=ZETAF*S*DPHI
C DPI
         IF ((ETAI+DETAI).LT.ETAIS) THEN
            DPI = 0.D0
         ELSE IF ( ETAI.GE.ETAIS) THEN
            DPI = AI0*DETAI
         ELSE
            DPI = AI0*(DETAI - ETAIS + ETAI)
         ENDIF
C DG
         DG=AG*DPHI*ZETAG

C DP
         IF ( S .EQ. 0.D0)THEN
            DP   = 0.D0
            DO 1, I=1,6
               DFDS(I) = 0.D0
 1          CONTINUE
         ELSE
            CALL LCPRSV(1.5D0/S,DEV,DFDS)
            CALL LCPRSV(DPI,DFDS,VTMP1)
            CALL LCDIVE(DEPS,VTMP1,VTMP1)
            CALL LCPRSV(DG,ID3D,VTMP2)
            CALL LCDIVE(VTMP1,VTMP2,VTMP1)
            CALL LCPRMV(HOOK,VTMP1,VTMP1)
            CALL LCPRSC(DFDS,VTMP1,YY)

            IF      ( P .LT. PK ) THEN
               ZZ = 0.0D0
            ELSE IF ( P .LT. PE ) THEN
               ZZ = PENPE
            ELSE
               ZZ = N*K*(P+P0)**(N-1.0D0)
            ENDIF
            CALL LCPRMV(HOOK,DFDS,VTMP1)
            CALL LCPRSC(DFDS,VTMP1,XX)

            XX=XX+ZZ

            DP= YY/XX
         ENDIF

C - (DEPS(3))
         IF(MOD(1:6).EQ.'C_PLAN')THEN
            DEPS(3) = NUN * ((DP+DPI)*(DFDS(1)+DFDS(2))+
     &              2.D0*DG-DEPS(1)-DEPS(2))+ DFDS(3)*(DP+DPI)+DG
         ENDIF

C DSIG
         CALL LCPRSV((DPI+DP),DFDS,VTMP1)
         CALL LCDIVE(DEPS,VTMP1,VTMP1)
         CALL LCPRSV(DG,ID3D,VTMP2)
         CALL LCDIVE(VTMP1,VTMP2,VTMP1)
         CALL LCPRMV(HOOK,VTMP1,DSIG)
C - DY
         CALL LCEQVN ( NDT , DSIG   , DY(1) )
         DY(NDT+1)=DP
         DY(NDT+2)=DETAI
         DY(NDT+3)=DPI
         DY(NDT+4)=DG
         IF(MOD(1:6).EQ.'C_PLAN')THEN
            DY(NDT+5) = DEPS(3)
            DY(3)     = 0.D0
         ENDIF

C - SOLUTION INITIALE = VALEUR ESSAI POUR TOUTES LES COMPOSANTES
C
      ELSEIF ( TYPESS .EQ. 3 ) THEN
         CALL LCINVN ( NDT+4  , ESSAI , DY )
         IF ( MOD(1:6).EQ.'C_PLAN' )THEN
            DEPS(3) = ESSAI
            DY(3) = 0.D0
         ENDIF
      ENDIF
C
      END
