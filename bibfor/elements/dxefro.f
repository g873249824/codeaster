      SUBROUTINE DXEFRO ( NE , T2EV , EDGLE , EDGLC )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/01/95   AUTEUR G8BHHAC A.Y.PORTABILITE 
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
      INTEGER  NE
      REAL*8   T2EV(2,2)
      REAL*8   EDGLE(*)
      REAL*8   EDGLC(*)
C     ------------------------------------------------------------------
C     PASSAGE DES EFFORTS OU DEFORMATIONS GENERALISES DU REPERE
C     INTRINSEQUE DE L'ELEMENT AU REPERE LOCAL DE LA COQUE
C     ------------------------------------------------------------------
C     IN  NE    I      NOMBRE DE POINTS A TRAITER
C     IN  T2EV  R 2,2  MATRICE DE PASSAGE ELEMENT - VARIETE
C     IN  EDGLE R  8   NXX NYY NXY MXX MYY MXY VX VY
C     OUT EDGLC R  8   NXX NYY NXY MXX MYY MXY VX VY
C  OU IN  EDGLE R  8   EXX EYY EXY KXX KYY KXY GAX GAY
C     OUT EDGLE R  8   EXX EYY EXY KXX KYY KXY GAX GAY
C     ------------------------------------------------------------------
      REAL*8        NLE(4) , MLE(4) , XAB(2,2)
      REAL*8        NLC(4) , MLC(4)
C
      DO 120 I = 1 , NE
        NLE(1) = EDGLE(1+8*(I-1))
        NLE(2) = EDGLE(3+8*(I-1))
        NLE(3) = EDGLE(3+8*(I-1))
        NLE(4) = EDGLE(2+8*(I-1))
C
        MLE(1) = EDGLE(4+8*(I-1))
        MLE(2) = EDGLE(6+8*(I-1))
        MLE(3) = EDGLE(6+8*(I-1))
        MLE(4) = EDGLE(5+8*(I-1))
C
        CALL UTBTAB ('ZERO', 2,2,NLE,T2EV,XAB,NLC)
        CALL UTBTAB ('ZERO', 2,2,MLE,T2EV,XAB,MLC)
C
        EDGLC(1+8*(I-1)) = NLC(1)
        EDGLC(2+8*(I-1)) = NLC(4)
        EDGLC(3+8*(I-1)) = NLC(2)
C
        EDGLC(4+8*(I-1)) = MLC(1)
        EDGLC(5+8*(I-1)) = MLC(4)
        EDGLC(6+8*(I-1)) = MLC(2)
C
        EDGLC(7+8*(I-1)) = EDGLE(7+8*(I-1)) * T2EV(1,1) +
     &                     EDGLE(8+8*(I-1)) * T2EV(2,1)
        EDGLC(8+8*(I-1)) = EDGLE(7+8*(I-1)) * T2EV(1,2) +
     &                     EDGLE(8+8*(I-1)) * T2EV(2,2)
  120 CONTINUE
      END
