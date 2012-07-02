      SUBROUTINE MATRO2 ( ANGL , GAMARC , THETA , PGL1 , PGL2 )
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     ------------------------------------------------------------------
C     CALCUL DE LA MATRICE ROTATION A PARTIR DES ANGLES NAUTIQUES
C            ET DE L'ORIENTATION DE LA POUTRE COURBE
C            ET DE LA POSITION DES NOEUDS DE LA POUTRE COURBE
C
C     LES ANGLES NAUTIQUES SONT ALPHA, BETA, GAMMA
C     L'ANGLE DE LA POUTRE COURBE EST GAMARC
C     REPERE INITIAL (X0,Y0,Z0) ---> REPERE FINAL (XP,YP,ZP) :
C     (X0,Y0,Z0)     >    (X1,Y1,Z0)    >    (X,Y1,Z2)    >   (X,Y,Z)
C                  APLHA              BETA             GAMARC
C                            (X,Y,Z)    >    (X,YP,ZP)
C                                     GAMMA
C
C     IN      ALPHA  : ROTATION SENS DIRECT AUTOUR DE ZO
C             BETA   : ROTATION SENS ANTI-DIRECT AUTOUR DE Y1
C             GAMMA  : ROTATION SENS DIRECT AUTOUR DE X
C             GAMARC : ROTATION SENS DIRECT AUTOUR DE X
C             THETA  : DEMI-ANGLE AU SOMMET
C
C     OUT     PGL1   : MATRICE PASSAGE REPERE GLOBAL > FINAL  NOEUD 1
C     OUT     PGL2   : MATRICE PASSAGE REPERE GLOBAL > FINAL  NOEUD 2
C     ------------------------------------------------------------------
      REAL*8  ANGL(*) , ANG1(3) , PGL1(3,3) , PGL2(3,3)
      REAL*8  M21, M31, M22, M32, M23, M33
      REAL*8  RO(3,3), NI(3,3), NF(3,3)
C
C-----------------------------------------------------------------------
      REAL*8 COSA ,COSB ,COSG ,COSGAR ,GAMARC ,SINA ,SINB 
      REAL*8 SING ,SINGAR ,THETA 
C-----------------------------------------------------------------------
      COSA = COS( ANGL(1) )
      SINA = SIN( ANGL(1) )
      COSB = COS( ANGL(2) )
      SINB = SIN( ANGL(2) )
      COSG = COS( ANGL(3) )
      SING = SIN( ANGL(3) )
      COSGAR = COS( GAMARC )
      SINGAR = SIN( GAMARC )
C
      M21 = SINGAR*SINB*COSA - COSGAR*SINA
      M31 = SINGAR*SINA + COSGAR*SINB*COSA
      M22 = COSGAR*COSA + SINGAR*SINB*SINA
      M32 = COSGAR*SINB*SINA - COSA*SINGAR
      M23 = SINGAR*COSB
      M33 = COSGAR*COSB
C
      RO(1,1) =  COSB*COSA
      RO(2,1) =  M21*COSG + M31*SING
      RO(3,1) = -M21*SING + M31*COSG
C
      RO(1,2) =  COSB *SINA
      RO(2,2) =  M22*COSG + M32*SING
      RO(3,2) = -M22*SING + M32*COSG
C
      RO(1,3) = -SINB
      RO(2,3) =  M23*COSG + M33*SING
      RO(3,3) = -M23*SING + M33*COSG
C
C     --- MATRICE AU NOEUD FINAL ---
      ANG1(1) = -THETA
      ANG1(2) = 0.D0
      ANG1(3) = 0.D0
      CALL MATROT ( ANG1 , NF )
      CALL PMAT(3,NF,RO,PGL2)
C
C     --- MATRICE AU NOEUD INITIAL ---
      ANG1(1) = THETA
      CALL MATROT ( ANG1 , NI )
      CALL PMAT(3,NI,RO,PGL1)
C
      END
