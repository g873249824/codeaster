        SUBROUTINE LCINVM ( A, INVA )
        IMPLICIT REAL*8 (A-H,O-Z)
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
C       ----------------------------------------------------------------
C       INVERSION D UNE MATRICE EN FONCTION DE LA MODELISATION
C       3D   : A = A11, A22, A33, RAC2 A12, RAC2 A13, RAC2 A23
C       D_PLAN OU AXIS A = A11, A22, A33, RAC2 A12
C       IN  A      :  MATRICE
C       OUT INVA   :  INVERSE DE A (SOUS FORME VECTORIELLE AVEC RAC2)
C       ----------------------------------------------------------------
        INTEGER         N , ND
        REAL*8          A(6), INVA(6), DET, INVRC2
        COMMON /TDIM/   N , ND
C
        INVRC2 = 1.D0 / SQRT(2.D0)
        CALL LCDETE(A,DET)

        IF(N .EQ. 6) THEN
        INVA(1) = ( A(2)*A(3)-0.5D0*A(6)*A(6) ) / DET
        INVA(2) = ( A(1)*A(3)-0.5D0*A(5)*A(5) ) / DET
        INVA(3) = ( A(1)*A(2)-0.5D0*A(4)*A(4) ) / DET
        INVA(4) = ( INVRC2*A(5)*A(6)-A(4)*A(3) ) / DET
        INVA(5) = ( INVRC2*A(4)*A(6)-A(5)*A(2) ) / DET
        INVA(6) = ( INVRC2*A(4)*A(5)-A(6)*A(1) ) / DET
        ENDIF

        IF(N .EQ. 4) THEN
        INVA(1) = A(2)*A(3) / DET
        INVA(2) = A(1)*A(3) / DET
        INVA(3) = ( A(1)*A(2)-0.5D0*A(4)*A(4) ) / DET
        INVA(4) = -A(4)*A(3) / DET
        ENDIF

        END
