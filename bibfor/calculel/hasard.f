      SUBROUTINE HASARD(GRAIN0,GRAIN1,GRAINS,NGRAIN)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 02/04/2002   AUTEUR RATEAU G.RATEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C A_UTIL
C ----------------------------------------------------------------------
C             GENERATEUR PSEUDO-ALEATOIRE UNIFORME D'ENTIER
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE / SORTIE
C INTEGER  GRAIN0          :  GRAIN0 <= 0 : UTILISEE POUR L'INIT. 
C                                           GRAIN0 DOIT ETRE IMPAIR
C INTEGER  GRAIN1          :  NOMBRE PSEUDO-ALEATOIRE COMPRIS 
C                             ENTRE 1 ET 2147483647
C INTEGER  GRAINS(NGRAIN)  :  VECTEUR DE STOCKAGE DES GRAINES
C INTEGER  NGRAIN          :  DIMENSION DE GRAINS (NGRAIN = 32)
C ----------------------------------------------------------------------
C                             G <- A*G MOD[M]
C                          M = 2**31 - 1 = A*Q + R
C                        LA PERIODE MAXIMALE VAUT M-1
C                 ELLE EST ATTEINTE SSI A MOD[M] EST PREMIER
C ----------------------------------------------------------------------

      IMPLICIT NONE

C --- PARAMETRES
      INTEGER    A,M,Q,R
      PARAMETER (A = 16807)
      PARAMETER (M = 2147483647)
      PARAMETER (Q = 127773)
      PARAMETER (R = 2836)

      INTEGER    ITER0
      PARAMETER (ITER0 = 8)

C --- VARIABLES
      INTEGER  GRAIN0,GRAIN1,GRAINS(*),NGRAIN,NMOD,I,J

      NMOD = 1 + (M-1)/NGRAIN

C --- INITIALISATION

      IF ((GRAIN0.LE.0).OR.(GRAIN1.LE.0)) THEN
        GRAIN0 = -GRAIN0
        IF (GRAIN0.LT.1) GRAIN0 = 1
        DO 10 I = ITER0+NGRAIN, 1, -1 
          J = GRAIN0 / Q 
          GRAIN0 = A*(GRAIN0 - J*Q) - J*R
          IF (GRAIN0.LT.0) GRAIN0 = GRAIN0 + M
          IF (I.LE.NGRAIN) GRAINS(I) = GRAIN0
 10     CONTINUE
        GRAIN1 = GRAIN0
      ENDIF

C --- ITERATION COURANTE

      I = GRAIN0 / Q
      GRAIN0 = A*(GRAIN0 - I*Q) - I*R
      IF (GRAIN0.LT.0) GRAIN0 = GRAIN0 + M

      I = 1 + GRAIN1 / NMOD
      GRAIN1 = GRAINS(I)
      GRAINS(I) = GRAIN0

      END
