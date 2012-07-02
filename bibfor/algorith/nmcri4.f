      FUNCTION NMCRI4 (DP)
C ----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 NMCRI4
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C     EVALUATION DE LA FONCTION NON LINEAIRE DONT ON CHERCHE LE ZERO
C     POUR LA VISCOELASTICITE DES ELEMENTS DE POUTRE.
C ----------------------------------------------------------------------
C
C     IN  :  EFF    : EFFORT NORMAL
C     OUT :  NMCRI4 : VALEUR DE LA FONCTION DE EFF DONT ON CHERCHE LE 0.
C
C **************** COMMON COMMUN A NMCRI4 ET NMFGAS  *******************
C
      COMMON /RCONM4/ YOU,CFLUAG,SIGE,PMM,SDT
      INTEGER    NCOEFF
C-----------------------------------------------------------------------
      REAL*8 DP 
C-----------------------------------------------------------------------
      PARAMETER (NCOEFF = 7)
      REAL*8   CFLUAG(NCOEFF),YOU,SIGE,PMM,SDT
      REAL*8   T1,T2,P1
C
C ********************* DEBUT DE LA SUBROUTINE *************************
C
      IF ((ABS(SIGE)-YOU*DP).LE.0.D0) THEN
         T1 = 0.D0
      ELSE
         T1 = (ABS(SIGE)-YOU*DP) ** CFLUAG(1)
      ENDIF
      P1 = CFLUAG(1)*CFLUAG(3)
      IF ((PMM+DP).LE.0.D0) THEN
         T2 = 0.D0
      ELSE
         T2 = (PMM+DP)**P1
      ENDIF
      NMCRI4 = DP * T2 * YOU - T1 * SDT * YOU
C
C ----------------------------------------------------------------------
C
      END
