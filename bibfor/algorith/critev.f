      SUBROUTINE CRITEV(EPSP,EPSD,ETA,LAMBDA,DEUXMU,FPD,SEUIL,RD,
     &            CRIT,CRITP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/05/2007   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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


      IMPLICIT NONE
      REAL*8             EPSP(7), EPSD(7),ETA,LAMBDA,DEUXMU,FPD,SEUIL,RD
      REAL*8             CRIT,CRITP
C ----------------------------------------------------------------------
C     CALCUL DU CRITERE DE ENDO_ISOT_BETON F(ETA) ET DE SA DERIVEE
C     EN NON LOCAL GRAD_EPSI
C
C IN EPSP    : DEFORMATIONS DUES AUX CHARGEMENTS ANTERIEURS ET FIXES
C IN EPSD    : DEFORMATIONS PROPORTIONNELLES A ETA
C IN ETA     : INTENSITE DU PILOTAGE
C IN LAMBDA  : |
C IN DEUXMU  : | COEFFICIENTS DE LAME
C IN FPD     : PARTIE DEPENDANTE DE D DANS LA FORCE THERMO
C             VAUT (1+GAMMA)/(1+GAMMA*D)**2
C IN SEUIL   : SEUIL DU CRITERE
C OUT CRIT   : VALEUR DU CRITERE POUR ETA DONNEE EN ENTREE
C OUT CRITP  : VALEUR DE LA DERIVEE DU CRITERE POUR ETA DONNEE EN ENTREE
C ----------------------------------------------------------------------

      INTEGER     K,I
      REAL*8      TR(6),VECP(3,3)
      REAL*8      EPM(3),TRE,RAC2,PHI
      REAL*8      TREPS,TREPSM,TREPSD,SIGEL(3),PPEPS(6),DFDE(6)


      REAL*8      DDOT

      RAC2=SQRT(2.D0)

C -- ON DIAGONALISE LE TENSEUR DE DEFORMATION
      TR(1) = EPSP(1)+ETA*EPSD(1)
      TR(2) = EPSP(4)+ETA*EPSD(4)
      TR(3) = EPSP(5)+ETA*EPSD(5)
      TR(4) = EPSP(2)+ETA*EPSD(2)
      TR(5) = EPSP(6)+ETA*EPSD(6)
      TR(6) = EPSP(3)+ETA*EPSD(3)

      CALL DIAGP3(TR,VECP,EPM)

      PHI = EPSP(7)+ETA*EPSD(7)

C -- CALCUL DU CRITERE

      TREPS = EPM(1)+EPM(2)+EPM(3)
      IF (TREPS.GT.0.D0) THEN
        DO 70 K=1,3
          SIGEL(K) = LAMBDA*TREPS
 70     CONTINUE
      ELSE
        DO 71 K=1,3
          SIGEL(K) = 0.D0 
 71     CONTINUE      
      ENDIF
      DO 25 K=1,3
        IF (EPM(K).GT.0.D0) THEN
          SIGEL(K) = SIGEL(K) + DEUXMU*EPM(K)
        ENDIF
 25   CONTINUE

      CRIT= FPD * 0.5D0 * DDOT(3,EPM,1,SIGEL,1)+PHI - RD- SEUIL

      DO 48 I=1,3
        IF (EPM(I).LT.0.D0) THEN
          TR(I)=0.D0
        ELSE
          TR(I)=EPM(I)
        ENDIF
        TR(I+3)=0.D0
48    CONTINUE

C -- CALCUL DE LA DERIVEE DU CRITERE
      
      CALL BPTOBG(TR,PPEPS,VECP)
      CALL R8INIR(6,0.D0,DFDE,1)
      TRE=EPM(1)+EPM(2)+EPM(3)
      
      IF (TRE.GT.0.D0) THEN
        DO 50 I=1,3
          DFDE(I)=FPD*LAMBDA*TRE
50      CONTINUE
      ENDIF
      DO 51 I=1,3
        DFDE(I)=DFDE(I)+DEUXMU*FPD*PPEPS(I)
51    CONTINUE
      DO 52 I=4,6
        DFDE(I)=DEUXMU*FPD*PPEPS(I)*RAC2
        EPSD(I)=EPSD(I)*RAC2
52    CONTINUE

      CRITP=DDOT(6,DFDE,1,EPSD,1)+EPSD(7)

      DO 53 I=4,6
        EPSD(I)=EPSD(I)/RAC2
53    CONTINUE
      
      END
