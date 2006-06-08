      FUNCTION NMCRI1(DP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
      REAL*8 NMCRI1,DP
C ----------------------------------------------------------------------
C    BUT:  EVALUER LA FONCTION DONT ON CHERCHE LE ZERO
C          POUR LA PLASTICITE DE VON_MISES ISOTROPE C_PLAN
C
C     IN:  DP     : DEFORMATION PLASTIQUE CUMULEE
C    OUT:  NMCRI1 : CRITERE NON LINEAIRE A RESOUDRE EN DP
C                   (DONT ON CHERCHE LE ZERO)
C                   ICI ON SUPPOSE LE CRITERE DE VON_MISES EN C_PLAN
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      REAL*8 G ,DX, RPP
C
C----- COMMONS NECESSAIRES A VON_MISES ISOTROPE C_PLAN :
C      COMMONS COMMUNS A NMCRI1 ET NMISOT
      COMMON /RCONM1/DEUXMU,NU,E,SIGY,RPRIM,PM,SIGEL,TP2,LINE
      COMMON /KCONM1/IMATE2, JPROL2, JVALE2,NBVAL2
      REAL*8         DEUXMU,NU,E,SIGY,RPRIM,PM,SIGEL(6),TP2,LINE
      INTEGER        IMATE2, JPROL2, JVALE2,NBVAL2
      REAL*8         DRDP,AIRERP,DUM
C
C DEB-------------------------------------------------------------------
C
      IF (LINE.GE.0.5D0) THEN
        RPP = SIGY +RPRIM*(PM+DP)
      ELSE
        CALL RCFONC('V','TRACTION',JPROL2,JVALE2,NBVAL2,DUM,DUM,DUM,
     &              PM+DP,RPP,DRDP,AIRERP,DUM,DUM)
      END IF
C
      DX = 3.D0*(1.D0-2.D0*NU)*SIGEL(3)*DP/(E*DP+2.D0*(1.D0-NU)*RPP)
C
      G = (SIGEL(1)-DEUXMU/3.D0*DX)**2 + (SIGEL(2)-DEUXMU/3.D0*DX)**2
     &  + (SIGEL(3)+DEUXMU/3.D0*2.D0*DX)**2 + SIGEL(4)**2
C
      NMCRI1= 1.5D0*DEUXMU*DP - SQRT(1.5D0*G) + RPP
C
 9999 CONTINUE
      END
