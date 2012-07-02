      FUNCTION PBFLKZ(I,Z,LONG,LN,KCALCU)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
C RESOLUTION DU PROBLEME FLUIDE INSTATIONNAIRE : CALCUL DE LA VALEUR EN
C Z DE LA SOLUTION PARTICULIERE CORRESPONDANT A LA IEME LIGNE DE LA
C MATRICE KCALCU(3,4), DANS LE CAS OU UMOY <> 0
C APPELANT : PBFLGA, PBFLSO
C-----------------------------------------------------------------------
C  IN : I      : INDICE DE LIGNE DE LA MATRICE KCALCU
C  IN : Z      : COTE
C  IN : LONG   : LONGUEUR DU DOMAINE DE RECOUVREMENT DES DEUX COQUES
C  IN : LN     : NOMBRE D'ONDES
C  IN : KCALCU : MATRICE RECTANGULAIRE A COEFFICIENTS CONSTANTS
C                PERMETTANT DE CALCULER UNE SOLUTION PARTICULIERE DU
C                PROBLEME FLUIDE INSTATIONNAIRE, LORSQUE UMOY <> 0
C-----------------------------------------------------------------------
C
      COMPLEX*16   PBFLKZ
      INTEGER      I
      REAL*8       Z,LONG,LN
      COMPLEX*16   KCALCU(3,4)
C
      COMPLEX*16   J,JU
C
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      REAL*8 U 
C-----------------------------------------------------------------------
      J  = DCMPLX(0.D0,1.D0)
      U  = Z*LN/LONG
      JU = J*U
      PBFLKZ = KCALCU(I,1) * DCMPLX(EXP(JU))
     &       + KCALCU(I,2) * DCMPLX(EXP(-1.D0*JU))
     &       + KCALCU(I,3) * DCMPLX(EXP(U))
     &       + KCALCU(I,4) * DCMPLX(EXP(-1.D0*U))
C
      END
