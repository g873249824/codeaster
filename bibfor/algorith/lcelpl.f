        SUBROUTINE LCELPL(MOD,LOI,NMAT,MATERD,MATERF,TIMED,TIMEF,
     &                    DEPS,NVI,VIND,VINF,NR,YD,YF,SIGD,SIGF,DRDY)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRS_1404
C
C ----------------------------------------------------------------
C   MISE A JOUR DES VARIABLES INTERNES EN ELASTICITE
C
C   POST-TRAITEMENTS SPECIFIQUES AUX LOIS
C
C   CAS GENERAL :
C      VINF = VIND
C      VINF(NVI) = 0.0
C ----------------------------------------------------------------
C  IN
C     MOD    :  TYPE DE MODELISATION
C     LOI    :  NOM DE LA LOI
C     NMAT   :  DIMENSION MATER ET DE NBCOMM
C     MATERD :  COEF MATERIAU A T
C     MATERF :  COEF MATERIAU A T+DT
C     TIMED  :  INSTANT T
C     TIMEF  :  INSTANT T+DT
C     IDPLAS :  INDICATEUR PLASTIQUE
C     NVI    :  NOMBRE VARIABLES INTERNES
C     VIND   :  VARIABLES INTERNES A T
C     SIGD   :  CONTRAINTES A T
C     SIGF   :  CONTRAINTES A T+DT
C     NR     :  NB EQUATION SYSTEME INTEGRE A RESOUDRE
C     YD     :  VECTEUR SOLUTION A T 
C     YF     :  VECTEUR SOLUTION A T+DT 
C  OUT
C     VINF   :  VARIABLES INTERNES A T+DT
C     DRDY   :  MATRICE JACOBIENNE POUR BETON_BURGER_FP
C ----------------------------------------------------------------
C     ------------------------------------------------------------
      COMMON /TDIM/   NDT  , NDI
C     ------------------------------------------------------------
      CHARACTER*16 LOI
      INTEGER      NMAT,NVI,NR,I,J,NDI,NDT
      REAL*8       MATERD(NMAT,2),MATERF(NMAT,2)
      REAL*8       VINF(NVI),VIND(NVI),DY(NR),DRDY(NR,NR)
      REAL*8       TIMED,TIMEF,DT,YD(NR),YF(NR)
      REAL*8       DEPS(6),SIGF(6),SIGD(6)
      CHARACTER*8  MOD
C ----------------------------------------------------------------
      IF (LOI(1:7).EQ.'IRRAD3M') THEN
         CALL IRRLNF(NMAT,MATERF,VIND,0.0D0,VINF)
      ELSEIF ( LOI(1:15)  .EQ. 'BETON_BURGER_FP') THEN
         DT = TIMEF-TIMED
         CALL BURLNF(NVI,VIND,NMAT,MATERD,MATERF,DT,
     &               NR,YD,YF,VINF,SIGF)
         DO 10 I = 1, NR
           DY(I) = YF(I)-YD(I)
           DO 20 J = 1, NR
             DRDY(I,J) = 0.D0
 20        CONTINUE
 10      CONTINUE
         CALL BURJAC ( MOD, NMAT, MATERD,MATERF,NVI,VIND,
     &                 TIMED,TIMEF,YD,YF,DY,NR,DRDY)
      ELSEIF(LOI(1:4).EQ.'LETK')THEN
         CALL LCEQVN( NVI-3, VIND , VINF )
         VINF(5) = 0.D0
         VINF(6) = 0.D0
         VINF(7) = 0.D0
      ELSEIF(LOI(1:6).EQ.'HUJEUX')THEN
C --- PAS DE MODIFICATION PARTICULIERE
C --- CAS DIFFERENT DE LA GENERALITE        
      ELSE
C
C --- CAS GENERAL :
C        VINF  = VIND ,  ETAT A T+DT = VINF(NVI) = 0 = ELASTIQUE
         CALL LCEQVN( NVI-1, VIND , VINF )
         VINF(NVI) = 0.0D0
      ENDIF

      END
