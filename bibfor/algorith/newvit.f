      SUBROUTINE NEWVIT( NEQ , C1 , C2 , V0 , A0 , V1 , A1 )
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
C**********************************************************************
      IMPLICIT NONE
C
C
C     INPUT:
C        NEQ   : NOMBRE D'EQUATIONS (D.D.L. ACTIFS)
C        C1,C2 : CONSTANTES DE CALCUL
C        V0    : VECTEUR VITESSE      INITIALE (NEQ)
C        A0    : VECTEUR ACCELERATION INITIALE (NEQ)
C        A1    : VECTEUR ACCELERATION SOLUTION (NEQ)
C
C     OUTPUT:
C        V1    : VECTEUR VITESSE      SOLUTION (NEQ)
C
C  CALCUL DE LA VITESSE     : VITSOL = V0 + C1*A0 + C2*ACCSOL
C
C
C----------------------------------------------------------------------
C   E.D.F DER   JACQUART G. 47-65-49-41      LE 19 JUILLET 1990
C**********************************************************************
C
      REAL *8         V0(*) , A0(*), V1(*) , A1(*)
      REAL *8         C1 , C2
C-----------------------------------------------------------------------
      INTEGER NEQ 
C-----------------------------------------------------------------------
      CALL DCOPY( NEQ , V0 , 1 ,  V1 , 1  )
      CALL DAXPY( NEQ , C1 , A0 , 1 , V1 , 1 )
      CALL DAXPY( NEQ , C2 , A1 , 1 , V1 , 1 )
      END
