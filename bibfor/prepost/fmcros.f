      SUBROUTINE FMCROS(NBFONC,NBPTOT,SIGM,RD0,RTAU0,RCRIT,
     +                    RPHMAX,RTAUA)
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      INTEGER           NBFONC,NBPTOT
      REAL*8              RPHMAX,RTAUA,SIGM(NBFONC*NBPTOT)
      REAL*8                             RD0,RTAU0,RCRIT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     -----------------------------------------------------------------
C     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
C     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
C     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
C     RD0     : IN  : VALEUR DE D0
C     RTAU0   : IN  : VALEUR DE TAU0
C     RCRIT   : OUT : VALEUR DU CRITERE
C     RPHMAX  : OUT : VALEUR DE LA PRESSION HYDROSTATIQUE MAXIMALE
C     RTAUA   : OUT : VALEUR DE L4AMPLITUDE DE CISSION
C     -----------------------------------------------------------------
C     ------------------------------------------------------------------
      REAL*8    RA,RB
C
C------- CALCUL DE L'AMPLITUDE DE CISSION
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL FMAMPC(NBFONC,NBPTOT,SIGM,RTAUA)
C
C------- CALCUL DE LA PRESSION HYDROSTATIQUE MAXIMALE -----
C
      CALL FMPRHM(NBFONC,NBPTOT,SIGM,RPHMAX)
C
C------- CALCUL DU CRITERE
C
      RA    = (RTAU0-RD0/SQRT(3.D0))/(RD0/3.D0)
      RB    =   RTAU0
      RCRIT =  RTAUA + RA * RPHMAX - RB
C
      END
