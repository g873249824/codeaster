      SUBROUTINE CALND1(IC,NP1,NP2,NP3,NBM,NBNL,
     &                  CHOC,ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &                  TYPCH,NBSEG,PHII,DEPG,DIST2)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/05/2000   AUTEUR KXBADNG T.KESTENS 
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
C TOLE  CRP_21
C-----------------------------------------------------------------------
C DESCRIPTION : CALCUL DE LA FONCTION TEST NUMERATEUR DE L'EXPRESSION
C -----------   DE L'INCREMENT TEMPOREL
C
C               APPELANT : NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER   IC, NP1, NP2, NP3, NBM, NBNL
      REAL*8    CHOC(5,*), ALPHA(2,*), BETA(2,*), GAMMA(2,*), ORIG(6,*),
     &          RC(NP3,*), THETA(NP3,*)
      INTEGER   TYPCH(*), NBSEG(*)
      REAL*8    PHII(NP2,NP1,*), DEPG(*), DIST2
C
C VARIABLES LOCALES
C -----------------
      REAL*8    XLOC(3), XGLO(3),XXGLO(3)
      REAL*8    XORIG(3), SINA, COSA, SINB, COSB, SING, COSG
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL  FTEST2, GLOLOC, PROJMG
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C  1. CONVERSION DDLS GENERALISES -> DDLS PHYSIQUES
C     ---------------------------------------------
      CALL PROJMG(NP1,NP2,IC,NBM,PHII,DEPG,XGLO)
C
C  2. PASSAGE REPERE GLOBAL -> LOCAL
C     ------------------------------
      XORIG(1) = ORIG(1,IC)
      XORIG(2) = ORIG(2,IC)
      XORIG(3) = ORIG(3,IC)
      XXGLO(1) = XGLO(1) + ORIG(4,IC)
      XXGLO(2) = XGLO(2) + ORIG(5,IC)
      XXGLO(3) = XGLO(3) + ORIG(6,IC)
      SINA = ALPHA(1,IC)
      COSA = ALPHA(2,IC)
      SINB = BETA(1,IC)
      COSB = BETA(2,IC)
      SING = GAMMA(1,IC)
      COSG = GAMMA(2,IC)
      CALL GLOLOC(XXGLO,XORIG,SINA,COSA,SINB,COSB,SING,COSG,XLOC)
C
C  3. CALCUL DE LA FONCTION TEST
C     --------------------------
      CALL FTEST2(NP3,RC,THETA,XLOC,IC,TYPCH,NBSEG,DIST2)
C
C --- FIN DE CALND1.
      END
