      REAL*8 FUNCTION GAMDEV ( ALPHA )
      IMPLICIT NONE
      REAL*8   ALPHA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/07/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     GENERATION D'UNE REALISATION D'UNE VARIABLE ALEATOIRE X
C     A VALEUR RELLES, DE LOI GAMMA DE PARAMETRE ALPHA>1.
C
C     PROCEDURE DUE A : AHRENS J.H., DIETER U., "COMPUTER METHOD
C     FOR SAMPLING FROM GAMMA, BETA, POISSON AND BINOMIAL DISTRIBUTION",
C     COMPUTING, 12, 223-246, 1974;
C
C     IN: ALPHA    PARAMETRE ALPHA DE LA LOI GAMMA
C ----------------------------------------------------------------------
      REAL*8   BETA, BETA2, F0, C1, C2, GAMMA2, UN
      REAL*8   V, U, Y, UNIF, PI, GAMM1, VREF, R8PI
C DEB ------------------------------------------------------------------
C      
      PI = R8PI()
      UN = 1.D0
      
      IF (ALPHA .LE. 1.D0) THEN
         CALL UTMESS('F','GAMDEV','ERREUR_GAMDEV : ALPHA < 1')
      ENDIF
      
      GAMMA2 = ALPHA-1.D0
      GAMM1  = 1D0/GAMMA2
      BETA   = SQRT(2D0*ALPHA-1.D0)
      BETA2  = 1D0/BETA**2
      F0 = 0.5D0+(1D0/PI)*ATAN2(-GAMMA2/BETA,UN)
      C1 = 1D0-F0
      C2 = F0-0.5D0
      VREF = 0D0
      V = -1D0
C      
 1    CONTINUE
      IF (-V .GT. VREF) THEN
         CALL GETRAN ( U )
         Y = BETA*TAN(PI*(U*C1+C2))+GAMMA2
         CALL GETRAN ( UNIF )
         IF (UNIF.LT.0)  CALL UTMESS('F','GAMDEV',' UNIF < 0 ')
         V = -LOG(UNIF)
         VREF = LOG(1+BETA2*((Y-GAMMA2)**2))+GAMMA2*LOG(Y*GAMM1)-Y
     +                                      +GAMMA2
         GOTO 1
      ENDIF
C      
      GAMDEV = Y
      IF (V.LT.0) THEN 
         CALL UTDEBM('A','GAMDEV',' GAMDEV(ALPHA) < 0 ')
         CALL UTIMPR('L','   GAMDEV(ALPHA) = ', 1, GAMDEV )
         CALL UTFINM
      ENDIF
C
      END
