      FUNCTION PHASE(H)
      IMPLICIT NONE
C     ------------------------------------------------------------------
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
C     RENVOIT LA PHASE DE H COMPRISE ENTRE 0. ET 2PI
C     ------------------------------------------------------------------
      COMPLEX*16 H
      REAL*8 X,Y,PHASE,PI
C-----------------------------------------------------------------------
      REAL*8 R8PI 
C-----------------------------------------------------------------------
      PI=R8PI()
      X=DBLE(H)
      Y=DIMAG(H)
      PHASE=0.D0
      IF((X.GT.0.D0).AND.(Y.GE.0.D0)) PHASE=ATAN2(Y,X)
      IF((X.LT.0.D0).AND.(Y.GE.0.D0)) PHASE=ATAN2(Y,X)+PI
      IF((X.LT.0.D0).AND.(Y.LE.0.D0)) PHASE=ATAN2(Y,X)+PI
      IF((X.GT.0.D0).AND.(Y.LE.0.D0)) PHASE=ATAN2(Y,X)+2.D0*PI
      IF((X.EQ.0.D0).AND.(Y.LT.0.D0)) PHASE=3.D0*PI/2.D0
      IF((X.EQ.0.D0).AND.(Y.GT.0.D0)) PHASE=PI/2.D0
      IF((X.EQ.0.D0).AND.(Y.EQ.0.D0)) PHASE=0.D0
      END
