      SUBROUTINE DCPL2C(MOM,DEPS,PLAMO1,PLAMO2,DC1,DC2,
     &                  DTG,ZEROG,DCPL2,ZERO)
      IMPLICIT NONE
      COMMON /TDIM/ N, ND
      REAL*8 DCPL2(3,2), MOM(3),    DEPS(6),   PLAMO1(3),   PLAMO2(3)
      REAL*8 DC1(3,3),   DC2(3,3),  DTG(6,6),  ZEROG,       LAMBDA(2,2)
      REAL*8 F1,         F2,        DF(3,2),   TDF(2,3)
      REAL*8 A(2),       B1(2),     B2(2),     DENOM,       DF1(3)
      REAL*8 DF2(3),     AUX,       D1,        D2,          PLAMOM(3)
      REAL*8 DC(3,3),    POINT1(3), POINT2(3), NEXMOM(3),   S
      REAL*8 ZERO,       TMP(3)
      REAL*8 TMP1(3),    MATMP(3,6),R1,        R2
      REAL*8 TMP2(3),    FPLAS
      INTEGER I,J,K, N, ND
C-----------------------------------------------------------------------
C CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/12/2004   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C     BUT  :  CALCULS DE LAMBDA1, DE LAMBDA2  ET DE L'INCREMENT DE
C             COURBURE PLASTIQUE QUAND LE CRITERE DE PLASTICITE VAUT 2 
C             PAR UNE METHODE EXPLICITE 
C
C IN    R  MOM    : MOMENT - MOMENT DE RAPPEL
C       R  DC1    : MATRICE ELASTIQUE + CONSTANTE DE PRAGER (FLEXION +)
C       R  DC2    : MATRICE ELASTIQUE + CONSTANTE DE PRAGER (FLEXION -)
C       R  DEPS   : INCREMENT DE DEFORMATION (MEMBRANE, COURBURE)
C       R  DTG    : MATRICE TANGENTE
C       R  PLAMO1 : MOMENTS LIMITES ELASTIQUES EN FLEXION POSITIVE
C       R  PLAMO2 : MOMENTS LIMITES ELASTIQUES EN FLEXION NEGATIVE 
C        
C OUT   R  DCPL2  : INCREMENT DE COURBURE PLASTIQUE
C-----------------------------------------------------------------------
C
      N = 3
C
      CALL LCDIVE(MOM,PLAMO1,TMP)
C     NORME EUCLIDIENNE DE TMP : D1
      CALL LCNRVE(TMP,D1)
      CALL LCDIVE(MOM,PLAMO2,TMP)
C     NORME EUCLIDIENNE DE TMP : D2
      CALL LCNRVE(TMP,D2)
C      
C     SI LE MOMENT EST TROP PRES DU SOMMET DU CONE
C     --------------------------------------------
      IF ((D1.LT.50.D0*ZEROG).OR.(D2.LT.50.D0*ZEROG))THEN
         IF(D1.LT.D2)THEN
C           IDENTIFICATION DE PLAMOM A PLAMO1
            N=3
            CALL LCEQVE(PLAMO1,PLAMOM)
            CALL DCOPY(9,DC1,1,DC,1)
C
         ELSE
C           IDENTIFICATION DE PLAMOM A PLAMO2
            N=3
            CALL LCEQVE(PLAMO2,PLAMOM)
            CALL DCOPY(9,DC2,1,DC,1)
C
         ENDIF
         POINT1(1)=PLAMO1(1)
         POINT1(2)=PLAMO2(2)
         POINT1(3)=0.D0
         POINT2(1)=PLAMO2(1)
         POINT2(2)=PLAMO1(2)
         POINT2(3)=0.D0
C
         CALL LCDIVE(POINT1,PLAMOM,TMP1)
         CALL LCDIVE(POINT2,PLAMOM,TMP2)
C        NORME EUCLIDIENNE DE TMP1 : R1
         N=3
         CALL LCNRVE(TMP1,R1)
C        NORME EUCLIDIENNE DE TMP2 : R2
         CALL LCNRVE(TMP2,R2)
         IF(R1.LT.R2)THEN
C           IDENTIFICATION DE NEXMOM A POINT1
            CALL LCEQVE(POINT1,NEXMOM)
         ELSE
C           IDENTIFICATION DE NEXMOM A POINT2
            CALL LCEQVE(POINT2,NEXMOM)
         ENDIF
         CALL DCPNMF(MOM,DEPS,DC,DTG,NEXMOM,TMP)
C
         CALL INITMA(3,2,DCPL2)
         IF(D1.LT.D2)THEN
            DO 10 I=1,3
               DCPL2(I,1)=TMP(I)
 10        CONTINUE
         ELSE
            DO 20 I=1,3
               DCPL2(I,2)=TMP(I)
 20        CONTINUE
         ENDIF
         GOTO 9999
      ENDIF
C
C     CALCUL CONSIDERANT LES PREMIERS ORDRES F1(M,M) F2(M,M)
C     ------------------------------------------------------
      CALL DFPLAS(MOM,PLAMO1,DF1)
      CALL DFPLAS(MOM,PLAMO2,DF2)
      DO 30 I=1,3
         DF(I,1)=DF1(I)
         DF(I,2)=DF2(I)
 30   CONTINUE
      DO 40 I=1,3
         TDF(1,I)=DF(I,1)
         TDF(2,I)=DF(I,2)
 40   CONTINUE
C     EXTRACTION DU BLOC INFERIEUR 3x6 DE DTG : MATMP
      CALL EXTMAT(DTG,6,3,6,'IG',MATMP)
C
      CALL PRMRVE(MATMP,3,6,DEPS,TMP)    
      CALL PRMRVE(TDF,2,3,TMP,A) 
      N=3
      CALL PMAVEC('ZERO',3,DC1,DF1,TMP)
      CALL PRMRVE(TDF,2,3,TMP,B1)
      CALL PMAVEC('ZERO',3,DC2,DF2,TMP)
C
      CALL PRMRVE(TDF,2,3,TMP,B2)
      DENOM=B1(1)*B2(2)-B1(2)*B2(1)
      AUX=B1(1)**2+B2(1)**2+B1(2)**2+B2(2)**2
C
      CALL INITMA(2,2,LAMBDA)
      F1=FPLAS(MOM,PLAMO1)+A(1)
      F2=FPLAS(MOM,PLAMO2)+A(2)
      IF(ABS(DENOM).LT.ZERO*AUX)THEN
         DENOM=B1(1)+B2(2)+B1(2)+B2(1)
         IF(ABS(DENOM).LT.ZERO*SQRT(AUX))THEN
C           DCPL2 = 0
            CALL INITMA(3,2,DCPL2)
            GOTO 9999
         ENDIF
         LAMBDA(1,1)=(F1+F2)/DENOM
         LAMBDA(2,2)=LAMBDA(1,1)
      ELSE
         LAMBDA(1,1)=(F1*B2(2)-F2*B2(1))/DENOM
         LAMBDA(2,2)=(F2*B1(1)-F1*B1(2))/DENOM
      ENDIF
      DO 50 K=1,2
         DO 60 I=1,3
            S=0.D0
            DO 70 J=1,2
               S=S+DF(I,J)*LAMBDA(J,K)
 70         CONTINUE
            DCPL2(I,K)=S
 60      CONTINUE
 50   CONTINUE
C
9999  CONTINUE
C
      END
