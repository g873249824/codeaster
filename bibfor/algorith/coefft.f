        SUBROUTINE COEFFT( NCOE,  COTHE, COEFF, DCOTHE, DCOEFF,
     &                     X,     DTIME, COEFT, E,      NU,
     &                     ALPHA, NMAT, COEL )
        IMPLICIT NONE
C       ===============================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/09/2007   AUTEUR DURAND C.DURAND 
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
C       ---------------------------------------------------------------
C       INTEGRATION DE LOIS DE COMPORTEMENT ELASTO-VISCOPLASTIQUE PAR
C       UNE METHODE DE RUNGE KUTTA AVEC REDECOUPAGE AUTOMATIQUE DU PAS 
C       DE TEMPS : CALCUL DES PARAMETRES MATERIAU A UN INSTANT DONNE 
C       ---------------------------------------------------------------
C       IN  NCOE   :  NOMBRE DE COEFFICIENTS MATERIAU INELASTIQUE 
C           COTHE  :  COEFFICIENTS MATERIAU ELASTIQUE A T 
C           COEFF  :  COEFFICIENTS MATERIAU INELASTIQUE A T 
C           DCOTHE :  INTERVALLE COEFFICIENTS MATERIAU ELAST POUR DT 
C           DCOEFF :  INTERVALLE COEFFICIENTS MATERIAU INELAST POUR DT 
C           X      :  INSTANT COURANT
C           DTIME  :  INTERVALLE DE TEMPS
C           NMAT   :  NOMNRE MAXI DE COEF MATERIAU
C       OUT COEFT  :  COEFFICIENTS MATERIAU INELASTIQUE A T+DT 
C           E,NU,
C           ALPHA  :  COEFFICIENTS MATERIAU ELASTIQUE A T+DT 
C           COEL   :  COEFFICIENTS  ELASTIQUES ORTHOTROPES A T+DT 
C       ---------------------------------------------------------------
        INTEGER NMAT,NCOE,I
        REAL*8 NU,E
        REAL*8 COTHE(NMAT),DCOTHE(NMAT),COEL(NMAT)
        REAL*8 SIGI(6),EPSD(6),DETOT(6),HSDT,DTIME,X,ALPHA
        REAL*8 COEFF(NCOE),DCOEFF(NCOE),COEFT(NCOE)
C
        HSDT=X/DTIME
        
        CALL R8INIR(NMAT, 0.D0, COEL, 1)
        
        IF (COTHE(NMAT).EQ.0) THEN
           E=COTHE(1)+HSDT*DCOTHE(1)
           NU=COTHE(2)+HSDT*DCOTHE(2)
           ALPHA=COTHE(3)+HSDT*DCOTHE(3)           
           DO 12 I=1,2
              COEL(I)=COTHE(I)+HSDT*DCOTHE(I)
   12      CONTINUE
           COEL(NMAT)=0.D0
        ELSEIF (COTHE(NMAT).EQ.1) THEN 
           DO 11 I=1,NMAT
              COEL(I)=COTHE(I)+HSDT*DCOTHE(I)
   11      CONTINUE
           COEL(NMAT)=1.D0
C          E et NU  sont utiles pour les r�gles de localisation
C          pou calculer Mu. On prend la moyenne des Gij           
           E=1.D0/COEL(36+22)
           E=E+(1.D0/COEL(36+29))
           E=E+(1.D0/COEL(72))
           E=E/3.D0
           E=E*2.D0
           NU=0.D0
        ENDIF
           
        DO 10 I=1,NCOE
          COEFT(I)=COEFF(I)+HSDT*DCOEFF(I)
   10   CONTINUE
        END
