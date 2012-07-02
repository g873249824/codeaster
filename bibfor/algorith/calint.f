      SUBROUTINE  CALINT(I,J,VECT1,NBPTS,VECT2,LONG,TT)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER            I,J,      NBPTS
      REAL*8                              VECT2(NBPTS)
      COMPLEX*16         VECT1(LONG)
C     ----------------------------------------------------------------
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
C      A PARTIR DES VALEURS DE FONCTIONS CALCULE L'INTERSPECTRE  OU
C           L'AUTOSPECTRE
C     ----------------------------------------------------------------
C     IN  : VECT1 : VECTEUR DES VALEURS DES FONCTIONS DANS LE DOMAINE
C                   FREQUENTIEL
C     OUT : VECT2 : VALEURS DES AUTOSPECTRES ET INTERSPECTRES
C           NBPTS : NOMBRE DE POINTS DE LA DISCRETISATION FREQUENTIELLE
C           TT    : TEMPS TOTAL DE L'EVOLUTION TEMPORELLE
C
C-----------------------------------------------------------------------
      INTEGER K ,LONG ,LVECT1 ,LVECT2 ,NPT ,NPT2 
      REAL*8 TT 
C-----------------------------------------------------------------------
      NPT= NBPTS
      NPT2 = NPT/2
      DO 10 K=1,NPT2
        LVECT1 = (I-1)*NPT2+ K
        LVECT2 = (J-1)*NPT2+ K
        VECT2(K) =(DBLE(VECT1(LVECT1)*DCONJG(VECT1(LVECT2))))/TT
        VECT2(NPT2+K)=(DIMAG(VECT1(LVECT1)*DCONJG(VECT1(LVECT2))))/TT
   10 CONTINUE
      END
