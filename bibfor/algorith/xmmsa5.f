      SUBROUTINE XMMSA5(NDIM ,IPGF  ,IMATE ,SAUT ,LAMB ,
     &                  ND   ,TAU1 ,TAU2  ,COHES ,JOB  ,
     &                  RELA ,ALPHA,DSIDEP,DELTA ,P    ,
     &                  AM   ,R)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER     NDIM,IPGF,IMATE
      REAL*8      SAUT(3),AM(3),DSIDEP(6,6)
      REAL*8      TAU1(3),TAU2(3),ND(3)
      REAL*8      ALPHA(3),P(3,3)
      REAL*8      COHES(3),RELA,R
      CHARACTER*8 JOB
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C
C ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
C
C --- CALCUL DU SAUT DE DEPLACEMENT EQUIVALENT [[UEG]]
C
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  IPGF   : NUM�RO DU POINTS DE GAUSS
C IN  IMATE  : ADRESSE DE LA SD MATERIAU
C IN  SAUT   : SAUT DE DEPLACEMENT
C IN  ND     : NORMALE � LA FACETTE ORIENT�E DE ESCL -> MAIT
C                 AU POINT DE GAUSS
C IN  TAU1   : TANGENTE A LA FACETTE AU POINT DE GAUSS
C IN  TAU2   : TANGENTE A LA FACETTE AU POINT DE GAUSS
C IN  COHES  : VARIABLE INTERNE COHESIVE
C IN  JOB    : 'SAUT_EQ', 'MATRICE' OU 'VECTEUR'
C IN  RELA   : LOI COHESIVE 1:CZM_EXP_REG 2:CZM_LIN_REG
C OUT ALPHA  : SAUT DE DEPLACEMENT EQUIVALENT
C OUT DSIDEP : MATRICE TANGENTE DE CONTACT PENALISE ET DE FISSURATION
C OUT SIGMA  : CONTRAINTE
C OUT PP     : ND X ND
C OUT DNOR   : SAUT DEPLACEMENT NORMAL DANS LA BASE FIXE
C OUT DTANG  : SAUT DEPLACEMENT TANGENTIEL DANS LA BASE FIXE
C OUT P      : MATRICE DE PROJECTION SUR LE PLAN TANGENT
C OUT AM     : SAUT INSTANT - BASE LOCALE : AM(1) = SAUT NORMAL
C                                           AM(2) = SAUT TANGENTIEL
C
C
      INTEGER      I,IER

      REAL*8       VIM(9),VIP(9),LAMB(3)
      REAL*8       DELTA(6),SQRNOR,SQRTAN,R8PREM,EPS

      CHARACTER*16 OPTION
C
C ----------------------------------------------------------------------
C
C --- INIIALISATIONS
C
      CALL VECINI(3,0.D0,AM)
      CALL MATINI(3,3,0.D0,P)
      CALL MATINI(6,6,0.D0,DSIDEP)
      CALL VECINI(6,0.D0,DELTA)
      CALL VECINI(9,0.D0,VIM)
      CALL VECINI(9,0.D0,VIP)
C
C --- ON CONSTRUIT P MATRICE DE PASSAGE BASE FIXE --> BASE COVARIANTE
C
      DO 1 I=1,NDIM
         P(1,I) = ND(I)
1     CONTINUE
      DO 2 I=1,NDIM
         P(2,I) = TAU1(I)
2     CONTINUE
      IF(NDIM.EQ.3) THEN
       DO 3 I=1,NDIM
         P(3,I) = TAU2(I)
3      CONTINUE     
      ENDIF
C
C --- CALCUL SAUT DE DEPLACEMENT EN BASE LOCALE {AM}=[P]{SAUT}
C --- ON UTILISE L UTILITAIRE PRMAVE : PRODUIT MATRICE-VECTEUR
C
      CALL PRMAVE(0,P,3,NDIM,NDIM,SAUT,NDIM,AM,NDIM,IER)
C
C --- INVERSION DE CONVENTIONS ENTRE X-FEM ET ROUTINE COMPORTEMENT
C
      DO 4 I=1,NDIM
         AM(I) = -AM(I)
4     CONTINUE
C
C SI ON VEUT SIMPLEMENT LE SAUT LOCAL, ON S ARRETE ICI
C
      IF(JOB.NE.'SAUT_LOC') THEN
C
C --- CALCUL VECTEUR ET MATRICE TANGENTE EN BASE LOCALE
C
      VIM(4) = COHES(1)
      VIM(2) = COHES(2)
C
C --- PREDICTION: COHES(3)=1, CORRECTION: COHES(3)=2
C
      IF(COHES(3).EQ.1.D0) THEN
        OPTION='RIGI_MECA_TANG'
      ELSE IF(COHES(3).EQ.2.D0) THEN
        OPTION='FULL_MECA'
      ELSE
        OPTION='FULL_MECA'
      ENDIF
C
C VIM = VARIABLES INTERNES UTILISEES DANS LCEJEX
C.............VIM(1): SEUIL, PLUS GRANDE NORME DU SAUT
C
           IF(RELA.EQ.3.D0) THEN
             CALL LCEITC('RIGI',IPGF,1,IMATE,OPTION,LAMB,AM,
     &                  DELTA,DSIDEP,VIM,VIP,R)
           ELSE IF(RELA.EQ.4.D0) THEN
             CALL LCEIOU('RIGI',IPGF,1,IMATE,OPTION,LAMB,AM,
     &                  DELTA,DSIDEP,VIM,VIP,R)

           ENDIF
C
C VARIABLES INTERNES ACTUALISEES
C
         ALPHA(1) = VIP(4)
         ALPHA(2) = VIP(2)
C SI ACTUALISATION: NOUVEAU PAS DONC PREDICTION EN PERSPECTIVE
C SINON, DESCENTE
C
         IF(JOB.EQ.'ACTU_VI') THEN
            ALPHA(3) = 1.D0
         ELSE IF(JOB.EQ.'MATRICE') THEN
            ALPHA(3) = 2.D0
         ENDIF
C
       ENDIF
      END
