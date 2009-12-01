      FUNCTION NMCRI8(DQP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/07/99   AUTEUR JMBHH01 J.M.PROIX 
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
C
C     ARGUMENTS:
C     ----------
      REAL*8 NMCRI8,DQP
C ----------------------------------------------------------------------
C    BUT:  EVALUER LA FONCTION DONT ON CHERCHE LE ZERO
C          POUR LES LOI DE VMIS_POU
C
C     IN:  DQ  : ACCROISSEMENT DE COURBURE PLASTIQUE
C    OUT:  NMCRI8 : VALEUR DU CRITERE  DE CONVERGENCE DE L'EQUATION NON
C                   LINEAIRE A RESOUDRE
C                   (DONT ON CHERCHE LE ZERO)
C
C----- COMMONS NECESSAIRES A VMIS_POU
C      COMMONS COMMUNS A NMCRI8 ET NMCRI7 ET NMVMPI

      COMMON/RCPOU8/DP,RP,EI,NP2,MM,DQ,ME,MP,ALPHA,BETA,QP,AQ

      REAL*8 DP,RP,EI,NP2,MM,DQ,ME,MP,ALPHA,BETA,QP,AQ,POUAQP

      AQ = POUAQP(QP+DQP,ALPHA,BETA,ME,MP)

      NMCRI8 = DQP*(RP+EI*DP*NP2*AQ)-DP*NP2*AQ*ABS(MM+EI*DQ)

      END
