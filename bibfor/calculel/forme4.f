      SUBROUTINE FORME4(M,TYPEMA,W,NNO,NCMP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 25/07/2001   AUTEUR RATEAU G.RATEAU 
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

C ----------------------------------------------------------------------
C     CALCUL DES DERIVEES QUATRIEMES DES FONCTIONS DE FORME
C ----------------------------------------------------------------------
C     VARIABLES D'ENTREE
C     REAL*8      M(*)      : POINT SUR MAILLE DE REFERENCE (X,[Y],[Z])
C     CHARACTER*8 TYPEMA     : TYPE DE LA MAILLE
C       
C     VARIABLES DE SORTIE
C     REAL*8      W(NCMP,NNO): FONCTION DE FORME EN M
C                             ( D4W1/DX2DY2, [D4W1/DX2DZ2], 
C                              [D4W1/DY2DZ2], D4W2/DX2DY2 ...)
C     INTEGER     NNO        : NOMBRE DE NOEUDS
C     INTEGER     NCMP       : NOMBRE DE COMPOSANTES
C
C     VARIABLES
      CHARACTER*8 TYPEMA
      REAL*8      M(*),W(*)
      INTEGER     NNO,NCMP

      IF (TYPEMA(1:5).EQ.'QUAD9') THEN              
        NCMP = 1
        W(1) = 1.D0
        W(2) = 1.D0
        W(3) = 1.D0
        W(4) = 1.D0
        W(5) = -2.D0
        W(6) = -2.D0
        W(7) = -2.D0
        W(8) = -2.D0
        W(9) = 4.D0
        NNO = 9
      ELSE
        GOTO 10
      ENDIF

      GOTO 20

 10   CONTINUE

      CALL UTMESS('F','FORME4','MAILLE '//TYPEMA//' INDISPONIBLE')
      
 20   CONTINUE

      END
