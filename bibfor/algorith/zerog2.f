      SUBROUTINE ZEROG2(X,Y,Z,I)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/04/2002   AUTEUR VABHHTS J.PELLET 
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

      IMPLICIT NONE
      REAL*8   X(3),Y(3),Z(3)
C ----------------------------------------------------------------------
C  RESOLUTION D'EQUATIONS SCALAIRES PAR APPROXIMATION P2
C ----------------------------------------------------------------------
C VAR X(1) SOLUTION GAUCHE COURANTE TQ Y(1)<0
C VAR X(2) SOLUTION DROITE COURANTE TQ Y(2)>0
C VAR X(3) SOLUTION X(N-1) PUIS SOLUTION EN X(N)
C VAR X(4) SOLUTION X(N)   PUIS SOLUTION EN X(N+1)
C VAR Y(I) VALEUR DE LA FONCTION EN X(I)
C VAR Z(I) VALEUR DE LA DERIVEE DE LA FONCTION EN X(I)
C ----------------------------------------------------------------------

      INTEGER  NRAC,I
      REAL*8   RAC(2),A,B,C,X0,Y0,Z0,X1,Y1
      REAL*8   INFINI, R8MAEM

C    TEST DES PRE-CONDITIONS
      IF (Y(1).GT.0 .OR. Y(2).LT.0) CALL UTMESS('F','ZEROG2',
     &  'PRECONDITIONS NON REMPLIES')

      IF (Y(3).LT.0.D0) THEN
        X(1)=X(3)
        Y(1)=Y(3)
        Z(1)=Z(3)
      ELSE
        X(2)=X(3)
        Y(2)=Y(3)
        Z(2)=Z(3)
      ENDIF  

C    CONSTRUCTION D'UN NOUVEL ESTIME
      IF (X(1).EQ.X(2))
     &  CALL UTMESS('F','ZEROG2','PRECISION MACHINE DEPASSEE')
      IF (MOD(I,2).EQ.0) THEN
        X0=X(1)
        X1=X(2)
        Y0=Y(1)
        Y1=Y(2)
        Z0=Z(1)
      ELSE
        X0=X(2)
        X1=X(1)
        Y0=Y(2)
        Y1=Y(1)
        Z0=Z(2)
      ENDIF
      A=(Y1-Y0-Z0*(X1-X0))/(X1-X0)**2
      B=Z0-2*A*X0
      C=Y0+A*X0**2-Z0*X0
      CALL ZEROP2(B/A, C/A, RAC, NRAC)
      
      IF (((X(1)-RAC(1))*(X(2)-RAC(1))).LT.0.D0) THEN
        X(3)=RAC(1)
      ELSE
        X(3)=RAC(2)
      ENDIF
              
 9999 CONTINUE
      END
