      SUBROUTINE SIGELP(SIGMA,DSIGMA,SIGEL,DSIGP,STOT,STEST,ITYPE,S0,
     &                  SELAS,SSTAR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2003   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C--------------------------------------------------------
C ELEMENT SHB8-PS A.COMBESCURE, S.BAGUET INSA LYON 2003 /
C-------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 SIGMA(*),DSIGMA(*),STOT(*),SIGEL(*),DSIGP(*)
      REAL*8 XMAT(2)
      INTEGER IBOU
C      DATA UN/1.0D0/,ZERO/0.0D0/


      IBOU = 6
C      IMAPLA = 1

CCCCCCCCCCCCCCC CALCUL DE L INTERSECTION AVEC LE CONVEXE

C      CALL ZDANUL(SIGEL,6)
C      CALL ZDANUL(DSIGP,6)
      CALL R8INIR(6,0.D0,SIGEL,1)
      CALL R8INIR(6,0.D0,DSIGP,1)
      
      AA = VONMIS(DSIGMA)
      BB = VNMS12(DSIGMA,SIGMA)
      AA = AA*AA
C      AA1 = AA
C      BB1 = BB
      TST = STEST*STEST
C      C = S0*S0
      CC = S0*S0 - SELAS*SELAS

   10 CONTINUE
      IF (ABS(AA).GT.TST) GO TO 70

CCCCCCCCCC  AA EST NUL UNE SEULE SOLUTION

      IF (ABS(BB).GT.TST) GO TO 40

CCCCCCCCCC   BB EST NUL <=> DSIGMA=0 SIGMA0=STOT

   20 CONTINUE
      XX = SELAS/ (S0+1.0D-20)
C      SIGEL=SIGMA*XX
C      CALL AEQBX(SIGEL,SIGMA,XX,IBOU)
C      DSIGP=SIGMA-SIGEL
C      CALL AEQBPC(DSIGP,SIGMA,SIGEL,UN,-UN,IBOU)
      DO 30 I = 1,IBOU
        SIGEL(I) = SIGMA(I)*XX
        DSIGP(I) = SIGMA(I) - SIGEL(I)
   30 CONTINUE
      SEL = 0.D0
      SPLA = 1.D0
      GO TO 140
   40 CONTINUE

CCCCCCCCCCCCCCAS BB NON NUL

      SEL = CC/ (2.D0*BB)
      GO TO 50
C      SIGEL=SIGMA+DSIGMA*SEL
C  333 CALL AEQBPC(SIGEL,SIGMA,DSIGMA,UN,SEL,IBOU)
   50 CONTINUE
      CALL LCEQVN(IBOU,SIGMA,SIGEL)
      CALL R8AXPY(IBOU,SEL,DSIGMA,1,SIGEL,1)
      SPLA = 1.D0 - SEL
      DO 60 I = 1,IBOU
        DSIGP(I) = DSIGMA(I)*SPLA
   60 CONTINUE
C      CALL AEQBX(DSIGP,DSIGMA,SPLA,IBOU)
      GO TO 140
   70 CONTINUE

CCCCCCCCCCCCCC  AA NON NUL ON A 2 SOLUTIONS

      IF (ABS(CC).GT.TST) GO TO 80

CCCCCCCCCCCCCC 1 SEULE SOLUTION CC NUL

      SEL = 0.D0
      GO TO 50
   80 CONTINUE

CCCCCCCCCCCC   2 SOLUTIONS

      DD = 4.D0*BB*BB - 4.D0*AA*CC
      B = 2.D0*BB
      IF (AA*CC.GT.0.D0) GO TO 90

CCCC          CC EST NEGATIF ON A 2 SOLUTIONS 1 NEGATIVE 1 POSITIVE
C      LA BONNE EST LA POSITIVE

      SEL = (-B+SQRT(DD))/ (2.D0*AA)
      GO TO 50
   90 CONTINUE

CCCCCCCC    ON A 2 SOLUTIONS POSITIVES OU NEGATIVES

      IF (DD.GT.0.D0) GO TO 130
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCC LA DROITE S0 STOT NE COUPE PAS LE CONVEXE   C
C              ON CHERCHE LE POINT DU CONVEXE LE          C
CCC             PLUS PRES DE STOT ON L APPELLE SIGEL      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
  100 CONTINUE
      XX = SELAS/ (SSTAR+1.D-20)
C      CALL AEQBX(SIGEL,STOT,XX,IBOU)
      DO 110 I = 1,IBOU
        SIGEL(I) = STOT(I)*XX
  110 CONTINUE
      SEL = 0.D0
      SPLA = 1.D0
C      CALL AEQBPC(DSIGP,STOT,SIGEL,UN,-UN,IBOU)
      DO 120 I = 1,IBOU
        DSIGP(I) = STOT(I) - SIGEL(I)
  120 CONTINUE
      GO TO 140
  130 CONTINUE

CCCCCCCCCCCCCCCCCCC   ON A 2 SOLUTIONS POSITIVES OU NEGATIVES

      SEL = (-B+SQRT(DD))/ (2.D0*AA)
      GO TO 50
  140 CONTINUE
  150 CONTINUE
      END
