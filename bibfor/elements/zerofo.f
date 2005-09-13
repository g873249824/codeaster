      SUBROUTINE ZEROFO(F,F0,XAP,EPSI,NITMAX,SOLU,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/09/2005   AUTEUR LEBOUVIE F.LEBOUVIER 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ARGUMENTS:
C     ----------
      REAL*8 F,F0,XAP,EPSI,SOLU
      INTEGER NITMAX,IRET
      EXTERNAL F
C TOLE CRP_7
C ----------------------------------------------------------------------
C     BUT:
C         TROUVER UNE RACINE DE L'EQUATION F(X)=0
C         ON SUPPOSE QUE LA FONCTION F EST CROISSANTE ET QUE F(0)<0
C
C     IN:
C         F  : FONCTION DONT ON CHERCHE LE "ZERO"
C         F0 : VALEUR DE F AU POINT 0 (CETTE VALEUR EST DONNEE ET NON
C              CALCULEE PAR LE PROGRAMME PAR ECONOMIE).
C         XAP: APPROXIMATION DE LA SOLUTION.
C        EPSI: TOLERANCE ABSOLU SUR LE ZERO CHERCHE : ABS(F(SOLU))<EPSI
C      NITMAX: NOMBRE MAXI D'ITERATIONS AUTORISEES.
C
C     OUT:
C         SOLU: VALEUR DE LA RACINE CHERCHEE.
C     IRET    : CODE RETOUR DE LA RECHERCHE DE ZERO
C               IRET=0 => PAS DE PROBLEME
C               IRET=1 => ECHEC DANS LA RECHERCHE DE ZERO
C
C ----------------------------------------------------------------------
      REAL*8 FY,FZ,X,Y,Z,A,B
      INTEGER N,NIT
C DEB-------------------------------------------------------------------
C
C     INITIALISATIONS
C
      N = 1
      X = 0.D0
      FX = F0
      IF (ABS(FX).LT.EPSI) THEN
         Z=0.D0
         GO TO 90
      ENDIF
      Y = XAP
      FY = F(Y)
C
C     DEBUT DES ITERATIONS
C
   10 CONTINUE
      IF (FY.GT.0.D0) THEN
        A = X
        B = Y
   20   CONTINUE
        Z = Y - (Y-X)*FY/(FY-FX)
        IF (((Z-A)*(Z-B)).GT.0.D0) THEN
          Z = (A+B)/2.D0
        ENDIF
C
        N = N + 1
        FZ = F(Z)
        IF (ABS(FZ).LT.EPSI) GO TO 90
        IF (N.GT.NITMAX) GO TO 98
        IF (FZ.LT.0.D0) THEN
          A = Z
        ELSE
          B = Z
        ENDIF
        X = Y
        FX = FY
        Y = Z
C        FY = F(Z)
        FY = FZ
        GO TO 20
      ELSE
        IF (FY.LT.FX) GO TO 99
        Z = Y - (Y-X)*FY/(FY-FX)
        N = N + 1
        X = Y
        FX = FY
        Y = Z
        FY = F(Z)
C
        IF (ABS(FY).LT.EPSI) GO TO 90
        IF (N.GT.NITMAX) GO TO 98
      ENDIF
      GO TO 10
C
   90 CONTINUE
      SOLU=Z
      GO TO 9999
C
   98 CONTINUE
      IRET=1
      GOTO 9999
C
   99 CONTINUE
C      CALL UTMESS('I','ZEROFO','ECHEC DE LA RECHERCHE DE ZERO')
C      CALL UTMESS('I','ZEROFO','ON CHANGE DE METHODE')

      CALL ZEROFC(F,X,Y,NITMAX,EPSI,SOLU,IRET,NIT)
      IF (IRET.NE.0) THEN
      ENDIF
C
 9999 CONTINUE
      END
