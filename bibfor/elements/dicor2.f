      SUBROUTINE DICOR2 (K0,P1,P2,DUR,DRYR,DXU,DRYU,FEQ,NU,MU,
     &                   UU,TT,SI1,DNSDU,DMSDT,DNSDT,VARIP1,VARIP2,SI2)
C ----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 K0(78),P1,P2,DUR,DRYR,DXU,DRYU,FEQ,NU,MU,UU,TT,SI1(12)
      REAL*8 DNSDU,DMSDT,DNSDT,VARIP1,VARIP2,SI2(12)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 10/01/95   AUTEUR D6BHHIV I.VAUTIER 
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
C
C     UTILITAIRE POUR LE COMPORTEMENT CORNIERE.
C
C ----------------------------------------------------------------------
C
C IN  : K0     : COEFFICIENTS DE RAIDEUR TANGENTE
C       P1     : VARIABLE INTERNE
C       P2     : VARIABLE INTERNE
C       DUR    : INCREMENT DE DEPLACEMENT
C       DRYR   : INCREMENT DE ROTATION
C       DXU    :
C       DRYU   :
C       FEQ    : FORCE EQUIVALENTE
C       NU     : EFFORT LIMITE ULTIME
C       MU     : MOMENT LIMITE ULTIME
C       UU     :
C       TT     :
C       SI1    : EFFORTS GENERALISES PRECEDENTS
C
C OUT : DNSDU  :
C       DMSDT  :
C       DNSDT  :
C       VARIP1 : VARIABLE INTERNE
C       VARIP2 : VARIABLE INTERNE
C       SI2    : EFFORTS GENERALISES COURANTS
C
C ----------------------------------------------------------------------
      VARIP1 = P1
      VARIP2 = 1.D0
      DNSDU = FEQ*NU/DXU/P2
      IF (DUR.EQ.0.D0) DNSDU = K0(1)
      DMSDT = FEQ*MU/DRYU/P2
      IF (DRYR.EQ.0.D0) DMSDT = K0(15)
      DNSDT = 0.D0
      SI2(7) = DNSDU*UU
      SI2(11) = DMSDT*TT
      SI2(1) = -SI1(7)
      SI2(5) = -SI1(11)
C ----------------------------------------------------------------------
C
 9999 CONTINUE
      END
