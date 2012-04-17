      SUBROUTINE ECCOOK(ACOOK,BCOOK,CCOOK,NPUIS,MPUIS,
     &               EPSP0,TROOM,TMELT,TP,DINST,PM,DP,RP,RPRIM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/11/2011   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE
C
C     ARGUMENTS:
C     ----------
      REAL*8 ACOOK,BCOOK,CCOOK,NPUIS,MPUIS,
     &               EPSP0,TROOM,TMELT,TP,DINST,PM,DP,RP,RPRIM
C ----------------------------------------------------------------------
C BUT: EVALUER LA FONCTION D'ECROUISSAGE ISOTROPE AVEC
C      LA LOI DE JOHNSON-COOK
C    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
C   OUT: RP     : R(PM+DP)
C   OUT: RPRIM  : R'(PM+DP)
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      REAL*8 P0
C
      P0=1.D-9
      IF ((PM+DP).LE.P0) THEN
        RP= (ACOOK+BCOOK*(P0)**NPUIS)
        RPRIM=NPUIS*BCOOK*(P0)**(NPUIS-1.D0)
      ELSE
        RP=(ACOOK+BCOOK*(PM+DP)**NPUIS)
        RPRIM=NPUIS*BCOOK*(PM+DP)**(NPUIS-1.D0)
        IF (DP/DINST.GT.EPSP0) THEN
          RPRIM=RPRIM+CCOOK*(RPRIM*LOG(DP/DINST/EPSP0)+RP/DP)
          RP=RP*(1.D0+CCOOK*LOG(DP/DINST/EPSP0))
        ENDIF
        IF ((TP.GT.TROOM) .AND. (TROOM.GE.-0.5D0)) THEN
          RP=RP*(1.D0-((TP-TROOM)/(TMELT-TROOM))**MPUIS)
          RPRIM=RPRIM*(1.D0-((TP-TROOM)/(TMELT-TROOM))**MPUIS)
        ENDIF
      ENDIF
C
      END
