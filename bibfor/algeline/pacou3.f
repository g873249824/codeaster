      SUBROUTINE PACOU3(XOLD,FOLD,G,P,X,F,FVEC,STPMAX,CHECK,TOLX,VECR1,
     +                  VECR2,TYPFLU,VECR3,AMOR,MASG,VECR4,VECR5,VECI1,
     +                  VG,INDIC,NBM,NMODE,N)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_21
C
C ARGUMENTS
C ---------
      INCLUDE 'jeveux.h'
      REAL*8 F,FOLD,STPMAX,TOLX,AMOR(*)
      REAL*8 G(*),P(*),X(*),XOLD(*),FVEC(*),VG,MASG(*)
      REAL*8 VECR1(*),VECR2(*),VECR3(*),VECR4(*),VECR5(*)
      INTEGER VECI1(*)
      LOGICAL CHECK,FIRST
      CHARACTER*8 TYPFLU
C
C
C ALF ASSURE UNE DECROISSANCE SUFFISANTE DE LA VALEUR DE LA FONCTION.
C-----------------------------------------------------------------------
      INTEGER I ,INDIC ,N ,NBM ,NMODE 
      REAL*8 A ,ALAM ,ALAM2 ,ALAMIN ,ALF ,B ,DISC 
      REAL*8 F2 ,FOLD2 ,RHS1 ,RHS2 ,SLOPE ,SUM ,TEMP 
      REAL*8 TEST ,TMPLAM 
C-----------------------------------------------------------------------
      PARAMETER (ALF=1.0D-4)
      REAL*8 PACOU2
C ******************   DEBUT DU CODE EXECUTABLE   **********************
C
      CHECK = .FALSE.
C
      SUM = 0.00D0
      DO 11 I = 1,N
        SUM = SUM + P(I)*P(I)
   11 CONTINUE
      SUM = SQRT(SUM)
C
      IF (SUM.GT.STPMAX) THEN
        DO 12 I = 1,N
          P(I) = P(I)*STPMAX/SUM
   12   CONTINUE
      END IF
C
      SLOPE = 0.0D0
      DO 13 I = 1,N
        SLOPE = SLOPE + G(I)*P(I)
   13 CONTINUE
C
      TEST = 0.0D0
      DO 14 I = 1,N
        TEMP = ABS(P(I))/MAX(ABS(XOLD(I)),1.0D0)
        IF (TEMP.GT.TEST) TEST = TEMP
   14 CONTINUE
C
      ALAMIN = TOLX/TEST
      ALAM = 1.0D0
      FIRST = .TRUE.
C
    1 CONTINUE
      DO 15 I = 1,N
        X(I) = XOLD(I) + ALAM*P(I)
   15 CONTINUE
C
      F = PACOU2(X,FVEC,VECR1,VECR2,TYPFLU,VECR3,AMOR,MASG,VECR4,VECR5,
     +           VECI1,VG,INDIC,NBM,NMODE,N)
      IF (ALAM.LT.ALAMIN) THEN
        DO 16 I = 1,N
          X(I) = XOLD(I)
   16   CONTINUE
        CHECK = .TRUE.
        GOTO 9999

      ELSE IF (F.LE.FOLD+ALF*ALAM*SLOPE) THEN
        GOTO 9999

      ELSE
        IF (FIRST) THEN
          TMPLAM = -SLOPE/ (2.0D0* (F-FOLD-SLOPE))
          FIRST = .FALSE.

        ELSE
          RHS1 = F - FOLD - ALAM*SLOPE
          RHS2 = F2 - FOLD2 - ALAM2*SLOPE
          A = (RHS1/ALAM**2-RHS2/ALAM**2)/ (ALAM-ALAM2)
          B = (-ALAM2*RHS1/ALAM**2+ALAM*RHS2/ALAM2**2)/ (ALAM-ALAM2)
          IF (ABS(A).LE.1.0D-30) THEN
            TMPLAM = -SLOPE/ (2.0D0*B)

          ELSE
            DISC = B*B - 3.0D0*A*SLOPE
            TMPLAM = (-B+SQRT(DISC))/ (3.0D0*A)
          END IF

          IF (TMPLAM.GT.0.5D0*ALAM) TMPLAM = 0.5D0*ALAM
        END IF

      END IF
C
      ALAM2 = ALAM
      F2 = F
      FOLD2 = FOLD
      ALAM = MAX(TMPLAM,0.1D0*ALAM)
      GO TO 1
C
 9999 CONTINUE
      END
