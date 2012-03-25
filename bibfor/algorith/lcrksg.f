      SUBROUTINE LCRKSG(COMP,NVI,VINF,FD,DF,NMAT,COEFL,SIGI)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/03/2012   AUTEUR PROIX J-M.PROIX 
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
C     ----------------------------------------------------------------
C     INTEGRATION DE LOIS DE COMPORTEMENT PAR UNE METHODE DE RUNGE KUTTA
C     CALCUL DES CONTRAINTES A PARTIR DES DEFORMATIONS EN GRANDES DEF
C     ----------------------------------------------------------------
C     IN  COMP    :  COMPORTEMENT
C         NVI     :  NOMBRE DE VARIABLES INETRNES DU SYSTEME NL (NVI-12)
C         VINF    :  V.I.
C         FD      :  GRADIENT DE TRANSFORMATION  A T
C         DF      :  INCREMENT DE GRADIENT DE TRANSFORMATION
C         NMAT    :  NOMBRE MAXI DE COEFFICIENTS MATERIAU
C         COEFEL  :  COEFFICENT DE L'OPERATEUR D'ELASTICITE 
C     OUT SIGI    :  CONTRAINTES A L'INSTANT COURANT
C     ----------------------------------------------------------------
      CHARACTER*8 MOD
      CHARACTER*16 LOI,COMP(*)
      INTEGER NMAT,NVI,NS
      REAL*8 HOOK(6,6),SIGI(6),FD(9),DF(9),COEFL(NMAT)
      REAL*8 VINF(*),FP(3,3),FPM(3,3),FE(3,3),DETP,F(3,3),EPSGL(6)
C     ----------------------------------------------------------------

      LOI  = COMP(1)
C     PAS DE CONTRAINTES PLANES NI DE 1D. 3D = D_PLAN = AXIS      
      MOD='3D'
      IF (LOI(1:8).EQ.'MONOCRIS') THEN
         IF (COMP(3)(1:4).EQ.'SIMO') THEN
         
C           OPERATEUR D'ELASTICITE DE HOOKE
            IF (COEFL(NMAT).EQ.0) THEN
               CALL LCOPLI('ISOTROPE',MOD,COEFL,HOOK)
            ELSEIF (COEFL(NMAT).EQ.1) THEN
               CALL LCOPLI('ORTHOTRO',MOD,COEFL,HOOK)
            ENDIF
C           SPECIFIQUE MONICRISTAL : RECUP DE FP   
C           Attention, NVI represente ici 6+3*NS+9         
            CALL DCOPY(9,VINF(NVI-9+1),1,FP,1)
            CALL MATINV('S',3,FP,FPM,DETP)
            
C           F=FE.FP  => FP = DF.F-.(FP)**-1
            CALL PMAT(3,DF,FD,F)
            CALL PMAT(3,F,FPM,FE)
            CALL LCGRLA ( FE,EPSGL)
            CALL LCPRMV ( HOOK,EPSGL,SIGI)
            
         ENDIF
      ENDIF
      
      END
