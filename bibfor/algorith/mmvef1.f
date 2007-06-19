      SUBROUTINE MMVEF1 (NBDM,NBCPS,NDIM,NNE,NNM,INDM,INI1,INI2,INI3,
     &                   HPG,FFPC,FFPR,JACOBI,RESE,DEPLE,LAMBDA,
     &                   TYALGF,COEFFA,COEFFS,COEFFP,
     &                   COEFFF,TAU1,TAU2,NORM, VTMP)
      IMPLICIT NONE
      INTEGER  NDIM,NNE,NNM,NBDM,NBCPS,INDM,INI1,INI2,INI3,TYALGF
      REAL*8   HPG,FFPC(9),FFPR(9),JACOBI  
      REAL*8   LAMBDA,COEFFF,COEFFA,COEFFS,COEFFP 
      REAL*8   RESE(3),DEPLE(6),TAU1(3),TAU2(3),NORM(3),VTMP(81)  
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2007   AUTEUR VIVAN L.VIVAN 
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
C TOLE CRP_21
C
C ROUTINE APPELLEE PAR : TE0365
C ----------------------------------------------------------------------
C
C CALCUL DU SECOND MEMBRE POUR LE FROTTEMENT
C CAS AVEC CONTACT
C
C IN  NBDM   : NB DE DDL DE LA MAILLE ESCLAVE
C IN  NBCPS  : NB DE DDL DE LAGRANGE
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  INDM   : NOMBRE DE NOEUDS EXCLUS PAR SANS GROUP_NO 
C IN  INI1   : NUMERO DU PREMIER NOEUD A EXCLURE PAR SANS_GROUP_NO
C IN  INI2   : NUMERO DU DEUXIEME NOEUD A EXCLURE PAR SANS_GROUP_NO
C IN  INI3   : NUMERO DU TROISIEME NOEUD A EXCLURE PAR SANS_GROUP_NO
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFPC   : FONCTIONS DE FORME DU POINT DE CONTACT
C IN  FFPR   : FONCTIONS DE FORME DE LA PROJECTION DU POINT DE CONTACT
C IN  DEPLE  : DEPLACEMENTS DE LA SURFACE ESCLAVE
C IN  RESE   : VECTEUR ADHERENCE
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  LAMBDA : VALEUR DU SEUIL_INIT
C IN  COEFFA : COEF_REGU_FROT
C IN  COEFFS : COEF_STAB_FROT
C IN  COEFFP : COEF_PENA_FROT
C IN  TYALGF : TYPE D'ALGORITHME DE FROTTEMENT
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  TAU1   : PREMIERE TANGENTE
C IN  TAU2   : SECONDE TANGENTE
C IN  NORM   : VALEUR DE LA NORMALE AU POINT DE CONTACT
C I/O VTMP   : VECTEUR SECOND MEMBRE ELEMENTAIRE DE CONTACT/FROTTEMENT
C ----------------------------------------------------------------------
      INTEGER   I, J, K, II
      REAL*8    C(3,3), VECTT(3), INTER(2)
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C
      DO 305 I = 1,3
        DO 306 J = 1,3
          C(I,J) = 0.D0
 306    CONTINUE
        VECTT(I) = 0.D0
 305  CONTINUE
      INTER(1)=0.D0
      INTER(2)=0.D0         
C        
C --- CALCUL DE C(I,J)
C
      DO 120 I = 1,NDIM
        DO 110 J = 1,NDIM
          C(I,J) = -1.D0*NORM(I)*NORM(J)
  110   CONTINUE
  120 CONTINUE
      DO 130 I = 1,NDIM
        C(I,I) = 1 + C(I,I)
  130 CONTINUE    
C
C --- CALCUL DE RESE.C(*,I)
C
      DO 170 I = 1,NDIM
        DO 160 K = 1,NDIM
          VECTT(I) = RESE(K)*C(K,I) + VECTT(I)
  160   CONTINUE
  170 CONTINUE
C  
C --- DDL DE DEPLACEMENT DE LA SURFACE CINEMATIQUE
C
      DO 190 I = 1,NNE
        DO 180 J = 1,NDIM
          II = (I-1)*NBDM+J
          VTMP(II) = -JACOBI*HPG*COEFFF*LAMBDA*VECTT(J)*FFPC(I)
  180   CONTINUE
  190 CONTINUE
C
C --- DDL DES DEPLACEMENTS DE LA SURFACE GEOMETRIQUE
C
      DO 210 I = 1,NNM
        DO 200 J = 1,NDIM
          II = NNE*NBDM+(I-1)*NDIM+J           
          VTMP(II) = JACOBI*HPG*COEFFF*LAMBDA*VECTT(J)*FFPR(I)
  200   CONTINUE
  210 CONTINUE
C
C --- DDL DES MULTIPLICATEURS DE FROTTEMENT (DE LA SURFACE CINEMATIQUE)
C
      IF (NDIM.EQ.2) THEN
        DO 228 I = 1,2
           INTER(1) = (DEPLE(NDIM+1+1)*TAU1(I)-RESE(I))*TAU1(I)+INTER(1)
  228   CONTINUE
      ELSE IF (NDIM.EQ.3)THEN
        DO 233 I = 1,3
          INTER(1)=(DEPLE(NDIM+1+1)*TAU1(I)+
     &              DEPLE(NDIM+3)*TAU2(I)-RESE(I))*TAU1(I)+INTER(1)
          INTER(2)=(DEPLE(NDIM+1+1)*TAU1(I)+
     &              DEPLE(NDIM+3)*TAU2(I)-RESE(I))*TAU2(I)+INTER(2)
  233   CONTINUE
      END IF
          
      IF (TYALGF .NE. 1)  COEFFA = COEFFS
          
      DO 3211 I = 1,NNE
        DO 3201 J = 1,NBCPS-1
          II = (I-1)*NBDM+NDIM+1+J
          IF ((INDM.EQ.3.D0).AND.(J.EQ.1)) THEN
            IF ((I.EQ.INI1).OR.(I.EQ.INI2).OR.(I.EQ.INI3)) THEN
              VTMP(II) = 0.D0
            ELSE
              VTMP(II) =
     &        JACOBI*HPG*COEFFF*INTER(J)*LAMBDA*FFPC(I)/COEFFA
            END IF 
          ELSEIF ((INDM.EQ.2.D0).AND.(J.EQ.1)) THEN
            IF ((I.EQ.INI1).OR.(I.EQ.INI2)) THEN
              VTMP(II) = 0.D0
            ELSE
              VTMP(II) =
     &        JACOBI*HPG*COEFFF*INTER(J)*LAMBDA*FFPC(I)/COEFFA
            END IF 
          ELSEIF ((INDM.EQ.1.D0).AND.(J.EQ.1)) THEN
            IF (I.EQ.INI1) THEN
              VTMP(II) = 0.D0
            ELSE
              VTMP(II) =
     &        JACOBI*HPG*COEFFF*INTER(J)*LAMBDA*FFPC(I)/COEFFA
            END IF 
          ELSE
            VTMP(II) =
     &      JACOBI*HPG*COEFFF*INTER(J)*LAMBDA*FFPC(I)/COEFFA
          END IF
 3201   CONTINUE
 3211 CONTINUE
C
      END
