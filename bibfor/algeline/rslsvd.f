      SUBROUTINE RSLSVD(NM,M,N,A,W,U,V,NB,B,EPS,IERR,RVNM)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 26/05/98   AUTEUR H1BAXBG M.LAINET 
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
C
C DESCRIPTION :   RESOLUTION D'UN SYSTEME LINEAIRE RECTANGULAIRE (M,N)
C -----------                          A(X) = B
C                 AU SENS DES MOINDRES CARRES, PAR DECOMPOSITION AUX
C                 VALEURS SINGULIERES DE LA MATRICE A
C
C IN     : NM   : INTEGER , SCALAIRE
C                 PREMIERE DIMENSION DES TABLEAUX A, U ET V, DECLAREE
C                 DANS L'APPELANT, NM >= MAX(M,N)
C IN     : M    : INTEGER , SCALAIRE
C                 NOMBRE DE LIGNES DES MATRICES A ET U
C IN     : N    : INTEGER , SCALAIRE
C                 NOMBRE DE COLONNES DES MATRICES A ET U
C                  = ORDRE DE LA MATRICE V
C IN     : A    : REAL*8 , TABLEAU DE DIMENSION(NM,N)
C                 CONTIENT LA MATRICE RECTANGULAIRE A
C                 LE CONTENU EST INCHANGE EN SORTIE
C OUT    : W    : REAL*8 , VECTEUR DE DIMENSION N
C                 CONTIENT LES N VALEURS SINGULIERES DE A, ORDONNEES
C                 PAR MODULE DECROISSANT
C OUT    : U    : REAL*8 , TABLEAU DE DIMENSION (NM,N)
C                 CONTIENT LA MATRICE U, MATRICE (M,N) A COLONNES
C                 ORTHOGONALES
C OUT    : V    : REAL*8 , TABLEAU DE DIMENSION (NM,N)
C                 CONTIENT LA MATRICE V, MATRICE CARREE D'ORDRE N
C                 ORTHOGONALE
C IN     : NB   : INTEGER , SCALAIRE
C                 NOMBRE DE SECONDS MEMBRES, I.E. NOMBRE DE COLONNES DE
C                 LA MATRICE B
C IN/OUT : B    : REAL*8 , TABLEAU DE DIMENSION (NM,NB)
C                 EN ENTREE : LES VECTEURS COLONNES CORRESPONDENT AUX
C                 SECONDS MEMBRES (VECTEURS D'ORDRE M)
C                 EN SORTIE : LES VECTEURS COLONNES CORRESPONDENT AUX
C                 SOLUTIONS (VECTEURS D'ORDRE N)
C IN     : EPS  : REAL*8 , SCALAIRE
C                 CRITERE DE PRECISION
C OUT    : IERR : INTEGER , SCALAIRE , CODE RETOUR
C                 IERR = 0   OK
C                 IERR = K   LA K-IEME VALEUR SINGULIERE N'A PAS ETE
C                            DETERMINEE APRES 30 ITERATIONS
C                 IERR = -1  MATRICE A DE RANG NUL
C IN/OUT : RVNM : REAL*8 , VECTEUR DE DIMENSION NM
C                 VECTEUR DE TRAVAIL
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER     NM, M, N, NB, IERR
      REAL*8      A(NM,N), W(N), U(NM,N), V(NM,N), B(NM,NB), EPS,
     &            RVNM(NM)
C
C VARIABLES LOCALES
C -----------------
      INTEGER     IB, J, RG
      REAL*8      ALPHAJ
      LOGICAL     MATUV
C
      REAL*8      R8DOT
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   DECOMPOSITION AUX VALEURS SINGULIERES DE LA MATRICE A
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      MATUV = .TRUE.
      CALL CALSVD(NM,M,N,A(1,1),W(1),
     &            MATUV,U(1,1),MATUV,V(1,1),IERR,RVNM(1))
      IF ( IERR.NE.0 ) GO TO 9999
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   POST-TRAITEMENTS AU CALCUL DE LA DECOMPOSITION AUX VALEURS
C     SINGULIERES DE LA MATRICE A :
C     LES VALEURS SINGULIERES SONT REORDONNEES PAR MODULE DECROISSANT
C     SIMULTANEMENT ON EFFECTUE LES PERMUTATIONS ADEQUATES DES COLONNES
C     DES MATRICES U ET V
C     DETERMINATION DU RANG DE LA MATRICE A
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      CALL POSSVD(NM,M,N,W(1),MATUV,U(1,1),MATUV,V(1,1),EPS,RG,RVNM(1))
      IF ( RG.EQ.0 ) THEN
         IERR = -1
         GO TO 9999
      ENDIF
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 3   CALCUL DES SOLUTIONS DU SYSTEME
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      DO 10 IB = 1, NB
         CALL R8INIR(N,0.0D0,RVNM(1),1)
         DO 20 J = 1, RG
            ALPHAJ = R8DOT(M,U(1,J),1,B(1,IB),1) / W(J)
            CALL R8AXPY(N,ALPHAJ,V(1,J),1,RVNM(1),1)
  20     CONTINUE
         CALL R8COPY(N,RVNM(1),1,B(1,IB),1)
  10  CONTINUE
C
9999  CONTINUE
C
C --- FIN DE RSLSVD.
      END
