      SUBROUTINE CALSIG( FAMI,KPG,KSP,EIN,MOD,COMP,VINI,
     &                   X,DTIME,EPSD,DETOT,NMAT,COEL,SIGI)
      IMPLICIT NONE
C     ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/06/2012   AUTEUR PROIX J-M.PROIX 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ----------------------------------------------------------------
C     INTEGRATION DE LOIS DE COMPORTEMENT ELASTO-VISCOPLASTIQUE
C     PAR UNE METHODE DE RUNGE KUTTA
C     A MODIFER SI ELASTCITE ORTHOTROPE
C     CALCUL DES CONTRAINTES A PARTIR DES CHAMPS DE DEFORMATION
C     ----------------------------------------------------------------
C     IN  FAMI    :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C         KPG,KSP :  NUMERO DU (SOUS)POINT DE GAUSS
C         EIN     :  DEFORMATION INELASTIQUE
C         MOD     :  TYPE DE MODELISATION
C         COMP    :  COMPORTEMENT
C         VINI    :  VARIABLES INTERNES
C         X       :  INSTANT COURANT
C         DTIME   :  INTERVALLE DE TEMPS
C         EPSD    :  DEFORMATION TOTALE A T
C         DETOT   :  INCREMENT DE DEFORMATION TOTALE
C         NMAT    :  NOMBRE MAXI DE COEFFICIENTS MATERIAU
C         COEL    :  COEFFICENT DE L'OPERATEUR D'ELASTICITE ORTHOTROPE
C     OUT SIGI    :  CONTRAINTES A L'INSTANT COURANT
C     ----------------------------------------------------------------
      CHARACTER*(*) FAMI
      CHARACTER*8 MOD
      CHARACTER*16 LOI,COMP(*)
      INTEGER KPG,KSP,ICP,NMAT,IRET,IRET1,IRET2,IRET3
      REAL*8 NU,COEL(NMAT),HOOK(6,6),ALPHAL,ALPHAT,ALPHAN,ETHL,ETHT
      REAL*8 EIN(6),XSDT,X,DTIME,ETH,ALPHA,TPERD,DTPER,TPEREF,ETHN,DMG
      REAL*8 EEL(6),SIGI(6),EPSD(6),DETOT(6),DEMU,E,TREEL,TF,E0,VINI(*)
C     ----------------------------------------------------------------

      CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TPERD,IRET1)
      CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TF,IRET2)
      CALL RCVARC(' ','TEMP','REF',FAMI,KPG,KSP,TPEREF,IRET3)

      IRET=IRET1+IRET2+IRET3

      LOI=COMP(1)

      XSDT=X/DTIME

      IF (COEL(NMAT).EQ.0) THEN
      
         E=COEL(1)
         E0=E
         DMG=0.D0
C        ENDOMMAGEMNT EVENTUEL
         IF (LOI(1:9).EQ.'VENDOCHAB') THEN
            DMG=VINI(9)
         ELSE  IF (LOI(1:8).EQ.'HAYHURST') THEN
            DMG=VINI(11)
         END IF
         E=E0*(1.D0-DMG)
         NU=COEL(2)
         ALPHA=COEL(3)
         IF (IRET.EQ.0) THEN
           DTPER = TF-TPERD
           ETH=ALPHA*(TPERD+XSDT*DTPER-TPEREF)
         ELSE
           ETH=0.D0
         ENDIF
         DO 10 ICP=1,6
           EEL(ICP)=EPSD(ICP)+DETOT(ICP)*XSDT-EIN(ICP)-ETH
           IF (ICP.EQ.3) ETH=0.0D0
   10    CONTINUE
C
C --     CAS DES CONTRAINTES PLANES
C
         IF(MOD(1:6).EQ.'C_PLAN') THEN
           EEL(3)=-NU*(EEL(1)+EEL(2))/(1.0D0-NU)
         ENDIF
C
         DEMU=E/(1.0D0+NU)
         TREEL=(EEL(1)+EEL(2)+EEL(3))
         TREEL=NU*DEMU*TREEL/(1.0D0-NU-NU)
         DO 11 ICP=1,6
           SIGI(ICP)=DEMU*EEL(ICP)+TREEL
           IF (ICP.EQ.3) TREEL=0.0D0
   11    CONTINUE

      ELSEIF(COEL(NMAT).EQ.1) THEN

            CALL LCOPLI ( 'ORTHOTRO' , MOD , COEL , HOOK )
            ALPHAL = COEL(73)
            ALPHAT = COEL(74)
            ALPHAN = COEL(75)
            IF (IRET.EQ.0) THEN
              ETHL=ALPHAL*(TPERD+XSDT*DTPER-TPEREF)
              ETHN=ALPHAT*(TPERD+XSDT*DTPER-TPEREF)
              ETHT=ALPHAN*(TPERD+XSDT*DTPER-TPEREF)
            ELSE
              ETHL=0.D0
              ETHN=0.D0
              ETHT=0.D0
            ENDIF
            EEL(1) = EPSD(1)+DETOT(1)*XSDT-EIN(1)-ETHL
            EEL(2) = EPSD(2)+DETOT(2)*XSDT-EIN(2)-ETHN
            EEL(3) = EPSD(3)+DETOT(3)*XSDT-EIN(3)-ETHT
            EEL(4) = EPSD(4)+DETOT(4)*XSDT-EIN(4)
            EEL(5) = EPSD(5)+DETOT(5)*XSDT-EIN(5)
            EEL(6) = EPSD(6)+DETOT(6)*XSDT-EIN(6)

            CALL LCPRMV ( HOOK    , EEL , SIGI  )

      ENDIF
      END
