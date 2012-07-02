      SUBROUTINE CFROTT(VISC,RUG,HMOY,UMOY,CF0,MCF0)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
C CALCUL DU COEFFICIENT DE FROTTEMENT VISQUEUX
C-----------------------------------------------------------------------
C  IN : VISC : VISCOSITE CINEMATIQUE DU FLUIDE
C  IN : RUG  : RUGOSITE ABSOLUE DE PAROI DES COQUES
C  IN : HMOY : JEU ANNULAIRE MOYEN
C  IN : UMOY : VITESSE DE L'ECOULEMENT MOYEN
C OUT : CF0  : COEFFICIENT DE FROTTEMENT VISQUEUX
C OUT : MCF0 : EXPOSANT VIS-A-VIS DU NOMBRE DE REYNOLDS
C-----------------------------------------------------------------------
      REAL*8 VISC,RUG
      REAL*8 HMOY,UMOY,CF0,MCF0
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      REAL*8 CORR ,RE ,REL 
C-----------------------------------------------------------------------
      IF (VISC.LT.1.D-10) THEN
        MCF0 = 0.D0
        CF0  = 0.D0
        GOTO 100
      ENDIF
C
      RE  = 2.D0*HMOY*UMOY/VISC
      REL = (17.85D0/RUG*2.D0*HMOY)**1.143D0
C
      CORR = 1.5D0
C
      IF (RE.LT.2000.D0) THEN
        MCF0 = -1.D0
        CF0  = 16.D0*(RE**MCF0)*CORR
      ELSE IF (RE.LT.4000.D0) THEN
        MCF0 = 0.55D0
        CF0  = 1.2D-4*(RE**MCF0)*CORR
      ELSE IF (RE.LT.100000.D0) THEN
        IF (RE.LT.REL) THEN
          MCF0 = -0.25D0
          CF0  = 0.079D0*(RE**MCF0)*CORR
        ELSE
          MCF0 = 0.D0
          CF0  = 0.079D0*(REL**(-0.25D0))*CORR
        ENDIF
      ELSE IF (RE.LT.REL) THEN
        MCF0 = -0.87D0/(DBLE(LOG10(RE))-0.91D0)
        CF0  = 0.25D0/((1.8D0*DBLE(LOG10(RE))-1.64D0)**2)*CORR
      ELSE
        MCF0 = 0.D0
        CF0  = 0.25D0/((1.8D0*DBLE(LOG10(REL))-1.64D0)**2)*CORR
      ENDIF
C
 100  CONTINUE
      END
