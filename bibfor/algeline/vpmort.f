      SUBROUTINE VPMORT(NEQ,X,     Y,       MY,       IMODE)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           NEQ,                          IMODE
      REAL*8                X(NEQ),Y(NEQ,*),MY(NEQ,*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 06/01/95   AUTEUR G8BHHAC A.Y.PORTABILITE 
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
C     M-ORTHOGONALISATION DU VECTEUR X AVEC LES PRECEDENTS
C     ------------------------------------------------------------------
      REAL*8 R8VAL, R8NORM
C     ------------------------------------------------------------------
      DO 10 IPREC = 1, IMODE - 1
         R8VAL  = 0.D0
         R8NORM = 0.D0
         DO 20 IEQ = 1, NEQ
            R8VAL  = R8VAL  + X(IEQ) * MY(IEQ,IPREC)
            R8NORM = R8NORM + Y(IEQ,IPREC) * MY(IEQ,IPREC)
   20    CONTINUE
         R8VAL = -R8VAL/R8NORM
         DO 30 IEQ= 1, NEQ
            X(IEQ) = X(IEQ) + R8VAL * Y(IEQ,IPREC)
   30    CONTINUE
   10 CONTINUE
      END
