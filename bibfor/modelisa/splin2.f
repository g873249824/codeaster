      SUBROUTINE SPLIN2(X,Y,D2Y,N,PTX,D2YPTX,IRET)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/05/98   AUTEUR H1BAXBG M.LAINET 
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
C-----------------------------------------------------------------------
C DESCRIPTION : INTERPOLATION SPLINE CUBIQUE
C -----------
C               ETANT DONNEE LA TABULATION DE LA FONCTION Y(I) = F(X(I))
C               EN N POINTS DE DISCRETISATION X(I)
C               ETANT DONNEE LA TABULATION DE LA DERIVEE SECONDE DE LA
C               FONCTION INTERPOLEE D2Y(I), CALCULEE EN AMONT PAR LA
C               ROUTINE SPLINE
C               ETANT DONNE UN POINT PTX
C               CETTE ROUTINE CALCULE LA VALEUR D2YPTX DE
C               L'INTERPOLATION SPLINE CUBIQUE DE LA DERIVEE
C               SECONDE DE LA FONCTION AU POINT PTX
C
C IN     : X      : REAL*8 , VECTEUR DE DIMENSION N
C                   CONTIENT LES POINTS DE DISCRETISATION X(I)
C IN     : Y      : REAL*8 , VECTEUR DE DIMENSION N
C                   CONTIENT LES VALEURS DE LA FONCTION AUX POINTS X(I)
C IN     : D2Y    : REAL*8 , VECTEUR DE DIMENSION N
C                   CONTIENT LES VALEURS DE LA DERIVEE SECONDE DE LA
C                   FONCTION INTERPOLEE AUX POINTS X(I)
C IN     : N      : INTEGER , SCALAIRE
C                   NOMBRE DE POINTS DE DISCRETISATION
C IN     : PTX    : REAL*8 , SCALAIRE
C                   VALEUR DU POINT OU L'ON SOUHAITE CALCULER LA DERIVEE
C                   SECONDE DE LA FONCTION INTERPOLEE
C OUT    : D2YPTX : REAL*8 , SCALAIRE
C                   VALEUR DE LA DERIVEE SECONDE DE LA FONCTION
C                   INTERPOLEE AU POINT PTX
C OUT    : IRET   : INTEGER , SCALAIRE , CODE RETOUR
C                   IRET = 0  OK
C                   IRET = 1  DEUX POINTS CONSECUTIFS DE LA
C                             DISCRETISATION X(I) SONT EGAUX
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
C
      REAL*8     X(*), Y(*), D2Y(*), PTX, D2YPTX
      INTEGER    N, IRET
C
C VARIABLES LOCALES
C -----------------
      INTEGER    K, KINF, KSUP
      REAL*8     A, B, H
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      IRET = 0
C
      KINF = 1
      KSUP = N
  10  CONTINUE
      IF ( KSUP-KINF.GT.1 ) THEN
         K = (KSUP+KINF)/2
         IF ( X(K).GT.PTX ) THEN
            KSUP = K
         ELSE
            KINF = K
         ENDIF
         GO TO 10
      ENDIF
C
      H = X(KSUP)-X(KINF)
      IF ( H.EQ.0.0D0 ) THEN
         IRET = 1
         GO TO 9999
      ENDIF
      A = (X(KSUP)-PTX)/H
      B = (PTX-X(KINF))/H
      D2YPTX = A * D2Y(KINF) + B * D2Y(KSUP)
C
9999  CONTINUE
C
C --- FIN DE SPLIN2.
      END
