       SUBROUTINE  PIPEPE(PILO  ,NDIM  ,NNO   ,NPG   ,IPOIDS,
     &                    IVF   ,IDFDE ,GEOM  ,TYPMOD,MATE  ,
     &                    COMPOR,LGPG  ,DEPLM ,SIGM  ,VIM   ,
     &                    DDEPL ,DEPL0 ,DEPL1 ,COPILO,DFDI  ,
     &                    ELGEOM,IBORNE,ICTAU )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21
C
       IMPLICIT NONE

      INCLUDE 'jeveux.h'
       INTEGER       NDIM,NNO,NPG
       INTEGER       MATE,IPOIDS,IVF,IDFDE
       INTEGER       LGPG, IBORNE, ICTAU
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  PILO, COMPOR(*)
       REAL*8        GEOM(NDIM,*),DEPLM(*),DDEPL(*)
       REAL*8        SIGM(2*NDIM,NPG), VIM(LGPG,NPG)
       REAL*8        DEPL0(*), DEPL1(*)
       REAL*8        COPILO(5,NPG), DFDI(*),ELGEOM(10,*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (PILOTAGE)
C
C CALCUL  DES COEFFICIENTS DE PILOTAGE POUR PRED_ELAS/DEFORMATION
C
C ----------------------------------------------------------------------
C
C
C IN  PILO   : MODE DE PILOTAGE: DEFORMATION, PRED_ELAS
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG    : NOMBRE DE POINTS DE GAUSS
C IN  IPOIDS : POIDS DES POINTS DE GAUSS
C IN  IVF    : VALEUR DES FONCTIONS DE FORME
C IN  IDFDE  : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM   : COORDONEES DES NOEUDS
C IN  TYPMOD : TYPE DE MODELISATION
C IN  MATE   : MATERIAU CODE
C IN  COMPOR : COMPORTEMENT
C IN  LGPG   : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C             CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  DEPLM  : DEPLACEMENT EN T-
C IN  DDEPL  : INCREMENT DE DEPLACEMENT A L'ITERATION NEWTON COURANTE
C IN  SIGM   : CONTRAINTES DE CAUCHY EN T-
C IN  VIM    : VARIABLES INTERNES EN T-
C IN  DEPL0  : CORRECTION DE DEPLACEMENT POUR FORCES FIXES
C IN  DEPL1  : CORRECTION DE DEPLACEMENT POUR FORCES PILOTEES
C IN  DFDI   : DERIVEE DES FONCTIONS DE FORME
C IN  ELGEOM : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
C              DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
C              FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
C IN  IBORNE : ADRESSE JEVEUX POUR BORNES PILOTAGE
C IN  ICTAU  : ADRESSE JEVEUX POUR PARAMETRE PILOTAGE
C OUT COPILO : COEFFICIENTS A0 ET A1 POUR CHAQUE POINT DE GAUSS
C
C

C
C
      INTEGER  KPG,K,NDIMSI
      REAL*8   FM(3,3),EPSM(6),EPSP(6),EPSD(6)
      REAL*8   RAC2,R8VIDE
      REAL*8   ETAMIN, ETAMAX, TAU, SIGMA(6)
C
C ----------------------------------------------------------------------
C
      CALL MATFPE(-1)
C
C --- INITIALISATIONS
C
      RAC2   = SQRT(2.D0)
      NDIMSI = 2*NDIM
          
      CALL R8INIR(6,0.D0,SIGMA,1)
      CALL R8INIR(NPG*5,R8VIDE(),COPILO,1)
C
C --- TRAITEMENT DE CHAQUE POINT DE GAUSS
C
      DO 10 KPG=1,NPG
C
C --- CALCUL DES DEFORMATIONS 
C     
        CALL PIPDEF(NDIM  ,NNO   ,KPG   ,IPOIDS,IVF   ,
     &              IDFDE ,GEOM  ,TYPMOD,COMPOR,DEPLM ,
     &              DDEPL ,DEPL0 ,DEPL1 ,DFDI  ,FM    ,
     &              EPSM  ,EPSP  ,EPSD  )
     
C --- PILOTAGE PAR L'INCREMENT DE DEFORMATION

        IF (PILO .EQ. 'DEFORMATION') THEN
        
          CALL PIDEFO(NDIM  ,NPG   ,KPG   ,COMPOR,FM    ,
     &                EPSM  ,EPSP  ,EPSD  ,COPILO)


C --- PILOTAGE PAR LA PREDICTION ELASTIQUE

        ELSEIF (PILO .EQ. 'PRED_ELAS') THEN
          TAU    = ZR(ICTAU)
          ETAMIN = ZR(IBORNE+1)
          ETAMAX = ZR(IBORNE)  

          CALL DCOPY(NDIMSI,SIGM(1,KPG),1,SIGMA,1)
          DO 70 K = 4, NDIMSI
            SIGMA(K) = SIGMA(K)*RAC2
 70       CONTINUE

          CALL PIELAS(NDIM  ,NPG   ,KPG   ,COMPOR,TYPMOD,
     &                MATE  ,ELGEOM,LGPG  ,VIM   ,EPSM  ,
     &                EPSP  ,EPSD  ,SIGMA ,ETAMIN,ETAMAX,
     &                TAU   ,COPILO)
        ELSE
          CALL ASSERT(.FALSE.)  
        ENDIF

 10   CONTINUE
 
      CALL MATFPE(1) 
 
      END
