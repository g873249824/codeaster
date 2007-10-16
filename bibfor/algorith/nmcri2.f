      FUNCTION NMCRI2(DP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C
C     ARGUMENTS:
C     ----------
      REAL*8 NMCRI2,DP
C ----------------------------------------------------------------------
C   BUT: EVALUER LA FONCTION DONT ON CHERCHE LE ZERO POUR LA PLASTICITE 
C         DE VON_MISES ISOTROPE AVEC ECROUISSAGE EN PUISSANCE
C
C    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
C   OUT: NMCRI2 : CRITERE NON LINEAIRE A RESOUDRE EN DP
C                   (DONT ON CHERCHE LE ZERO)
C                   ICI ON SUPPOSE LE CRITERE DE VON_MISES 
C                   AVEC ECROUISSAGE ISOTROPE EN PUISSANCE
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      REAL*8 G ,DX, RPP
C
C----- COMMONS NECESSAIRES A VON_MISES ISOTROPE PUISSANCE :
C      COMMONS COMMUNS A NMCRI2 ET NMISOT
      COMMON /RCONM1/DEUXMU,NU,E,SIGY,RPRIM,PM,SIGEL,LINE
      COMMON /KCONM1/IMATE2, JPROL2, JVALE2,NBVAL2
      REAL*8         DEUXMU,NU,E,SIGY,RPRIM,PM,SIGEL(6),LINE
      INTEGER        IMATE2, JPROL2, JVALE2,NBVAL2
      REAL*8         DRDP,AIRERP,DUM
      COMMON /RCONM2/ALFAFA,UNSURN,SIELEQ
      REAL*8         ALFAFA,UNSURN,SIELEQ
C
C DEB-------------------------------------------------------------------
C
      NMCRI2= SIGY*(E/ALFAFA/SIGY*(PM+DP))**UNSURN + 1.5D0*DEUXMU*DP
     &           + SIGY - SIELEQ
C
 9999 CONTINUE
      END
