      SUBROUTINE INTEGA(NPGF,
     &                  JAC,POIDSF,VECTX,VECTY,VECTZ,
     &                  MAT11,MAT22,MAT33,MAT12,MAT13,MAT23,NX,NY,NZ,
     &                  INTE)
      IMPLICIT NONE
      INTEGER NPGF
      REAL*8 JAC(9),POIDSF(9)
      REAL*8 VECTX(9),VECTY(9),VECTZ(9)
      REAL*8 MAT11(9),MAT22(9),MAT33(9),MAT12(9),MAT13(9),MAT23(9)
      REAL*8 NX(9),NY(9),NZ(9)
      REAL*8 INTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2009   AUTEUR GNICOLAS G.NICOLAS 
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
C
C     BUT:
C         CALCUL DES TERMES PAR POINT DE GAUSS POUR UNE INTEGRATION
C         DE GAUSS DU TYPE :
C              (
C              |     (VECT-MAT.N)**2 DFACE
C              )FACE
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   NPGF   : NOMBRE DE POINTS D'INTEGRATION
C IN   JAC    : VECTEUR DES JACOBIENS DE LA TRANSFORMATION AUX NOEUDS
C IN   POIDSF : VECTEUR DES POIDS AUX NOEUDS POUR LA FACE
C IN   VECTX  : COMPOSANTES EN X DU VECTEUR AUX NOEUDS
C IN   VECTY  : COMPOSANTES EN Y DU VECTEUR AUX NOEUDS
C IN   VECTZ  : COMPOSANTES EN Z DU VECTEUR AUX NOEUDS
C IN   MATIJ  : COMPOSANTES IJ DE LA MATRICE AUX NOEUDS
C IN   NX     : COMPOSANTES EN X DES NORMALES AUX NOEUDS
C IN   NY     : COMPOSANTES EN Y DES NORMALES AUX NOEUDS
C IN   NZ     : COMPOSANTES EN Z DES NORMALES AUX NOEUDS
C
C      SORTIE :
C-------------
C OUT  INTE  : TERME INTEGRE POUR UNE FACE
C
C ......................................................................
      INTEGER IPGF
C ----------------------------------------------------------------------
C
      INTE=0.0D0
C
      DO 10 , IPGF = 1 , NPGF
C
       INTE=INTE+((VECTX(IPGF)-MAT11(IPGF)*NX(IPGF)
     &            -MAT12(IPGF)*NY(IPGF)-MAT13(IPGF)*NZ(IPGF))**2
     &           +(VECTY(IPGF)-MAT12(IPGF)*NX(IPGF)
     &            -MAT22(IPGF)*NY(IPGF)-MAT23(IPGF)*NZ(IPGF))**2
     &           +(VECTZ(IPGF)-MAT13(IPGF)*NX(IPGF)
     &            -MAT23(IPGF)*NY(IPGF)-MAT33(IPGF)*NZ(IPGF))**2)
     &            *POIDSF(IPGF)*JAC(IPGF)
C
  10  CONTINUE
C
      END
