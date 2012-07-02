      SUBROUTINE ZERLAG(VECT,NBDDL,IDEEQ)
C-----------------------------------------------------------------------
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
C
C  BUT: ANNULER LES DDL DE LAGRANGE DANS UN VECTEUR (.VALE D'UN CHAMNO)
      IMPLICIT NONE
C
C-----------------------------------------------------------------------
C
C VECT     /M/: VECTEUR DU CHAMNO
C NBDDL    /I/: NOMBRE DE DEGRES DE LIBERTE
C IDEEQ    /I/: VECTEUR DEEQ DU NUMDDL ASSOCIE AU CHAMNO
C
C-----------------------------------------------------------------------
      REAL*8   VECT(NBDDL)
      INTEGER  IDEEQ(2,NBDDL)
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,ITYP ,NBDDL 
C-----------------------------------------------------------------------
      DO 10 I = 1,NBDDL
         ITYP = IDEEQ(2,I)
         IF(ITYP.LE.0) VECT(I)=0.D0
 10   CONTINUE
C
      END
