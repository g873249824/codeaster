      SUBROUTINE MMMTMF(PHASEP,NDIM  ,NNM   ,NNL   ,NBCPS ,
     &                  WPG   ,JACOBI,FFM   ,FFL   ,TAU1  ,
     &                  TAU2  ,MPROJT,RESE  ,NRESE ,LAMBDA,
     &                  COEFFF,MATRMF)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/04/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*9  PHASEP
      INTEGER      NDIM,NNM,NNL,NBCPS
      REAL*8       FFM(9),FFL(9)
      REAL*8       WPG,JACOBI
      REAL*8       TAU1(3),TAU2(3)
      REAL*8       RESE(3),NRESE           
      REAL*8       MPROJT(3,3)
      REAL*8       LAMBDA
      REAL*8       COEFFF       
      REAL*8       MATRMF(27,18)       
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DE LA MATRICE DEPL_MAIT/LAGR_F
C
C ----------------------------------------------------------------------
C
C
C IN  PHASEP : PHASE DE CALCUL
C              'CONT'      - CONTACT
C              'CONT_PENA' - CONTACT PENALISE
C              'ADHE'      - ADHERENCE
C              'ADHE_PENA' - ADHERENCE PENALISE
C              'GLIS'      - GLISSEMENT
C              'GLIS_PENA' - GLISSEMENT PENALISE
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NBCPS  : NB DE DDL DE LAGRANGE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  NNL    : NOMBRE DE NOEUDS DE LAGRANGE 
C IN  TAU1   : PREMIER VECTEUR TANGENT
C IN  TAU2   : SECOND VECTEUR TANGENT
C IN  MPROJT : MATRICE DE PROJECTION TANGENTE
C IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
C IN  FFL    : FONCTIONS DE FORMES LAGR. 
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT 
C               GTK = LAMBDAF + COEFFR*VITESSE
C IN  NRESE  : RACINE DE LA NORME DE RESE
C IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C OUT MATRMF : MATRICE ELEMENTAIRE DEPL_M/LAGR_F
C
C ----------------------------------------------------------------------
C
      INTEGER   INOF,INOM,ICMP,IDIM,I,J,K,II,JJ,NBCPF  
      REAL*8    A(2,3),B(2,3)
      REAL*8    H1(3),H2(3)
      REAL*8    H(3,2)
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      CALL MATINI( 2, 3,0.D0,A     )
      CALL MATINI( 2, 3,0.D0,B     )
      CALL MATINI( 3, 2,0.D0,H     )
      CALL VECINI(3,0.D0,H1)
      CALL VECINI(3,0.D0,H2)
      NBCPF  = NBCPS - 1
C     
C --- MATRICE [A] = [T]t*[P]
C      
      IF (PHASEP(1:4).EQ.'ADHE') THEN
        DO 4  I = 1,NDIM
          DO 5  K = 1,NDIM
            A(1,I) = TAU1(K)*MPROJT(K,I) + A(1,I)
  5       CONTINUE
  4     CONTINUE
        DO 6  I = 1,NDIM
          DO 7  K = 1,NDIM
            A(2,I) = TAU2(K)*MPROJT(K,I) + A(2,I)
  7       CONTINUE
  6     CONTINUE
      ENDIF
C
C --- VECTEUR PROJ. BOULE SUR TANGENTES: {H1} = [K].{T1}
C       
      IF (PHASEP(1:4).EQ.'GLIS') THEN
        CALL MKKVEC(RESE  ,NRESE ,NDIM  ,TAU1  ,H1    )
        CALL MKKVEC(RESE  ,NRESE ,NDIM  ,TAU2  ,H2    )
C
C ----- MATRICE [H] = [{H1}{H2}]
C
        DO 16 IDIM = 1,3
          H(IDIM,1) = H1(IDIM)
          H(IDIM,2) = H2(IDIM)
 16     CONTINUE
C
C ----- MATRICE [B] = [P]*[H]t
C        
        DO 23 ICMP = 1,NBCPF
          DO 24 J = 1,NDIM
            DO 25  K = 1,NDIM
              B(ICMP,J) = H(K,ICMP)*MPROJT(K,J)+B(ICMP,J)
  25        CONTINUE
  24      CONTINUE
  23    CONTINUE
      ENDIF        
C
C --- CALCUL DES TERMES      
C      
      IF (PHASEP(1:4).EQ.'ADHE') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
C       ON NE FAIT RIEN / LA MATRICE EST NULLE        
        ELSE
          DO 284 INOF = 1,NNL
            DO 283 INOM = 1,NNM
              DO 282 ICMP = 1,NBCPF
                DO 281 IDIM = 1,NDIM
                  JJ = NBCPF*(INOF-1)+ICMP
                  II = NDIM*(INOM-1)+IDIM
                  MATRMF(II,JJ) = MATRMF(II,JJ)+
     &                            WPG*FFL(INOF)*FFM(INOM)*JACOBI*
     &                            LAMBDA*COEFFF*A(ICMP,IDIM)

 281            CONTINUE
 282          CONTINUE
 283        CONTINUE
 284      CONTINUE          
        ENDIF
      ELSEIF (PHASEP(1:4).EQ.'GLIS') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
C       ON NE FAIT RIEN / LA MATRICE EST NULLE
        ELSE
          DO 184 INOF = 1,NNL
            DO 183 INOM = 1,NNM
              DO 182 ICMP = 1,NBCPF
                DO 181 IDIM = 1,NDIM
                  JJ = NBCPF*(INOF-1)+ICMP
                  II = NDIM*(INOM-1)+IDIM
                  MATRMF(II,JJ) = MATRMF(II,JJ)+
     &                            WPG*FFL(INOF)*FFM(INOM)*JACOBI*
     &                            LAMBDA*COEFFF*B(ICMP,IDIM)
 181            CONTINUE
 182          CONTINUE
 183        CONTINUE
 184      CONTINUE
        ENDIF      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END
