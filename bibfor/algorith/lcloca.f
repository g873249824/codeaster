      SUBROUTINE LCLOCA(COEFT,COEL,NMAT,NBCOMM,NPHAS,SIGI,VINI,
     &                  IPHAS,LOCA,SIGG)

      IMPLICIT NONE
      INTEGER NPHAS,NMAT,NBCOMM(NMAT,3),NVI,IPHAS
      REAL*8 VINI(*),COEFT(NMAT),COEL(NMAT)
      REAL*8 SIGI(6),LCNRTS,ALPHA,SIGG(6)
      CHARACTER*16 LOCA
      REAL*8 MU,DEV(6),NORME,DEVP(6),R8MIEM,EVPCUM
      INTEGER IEVPG,I
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/09/2004   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE JMBHH01 J.M.PROIX
C ======================================================================
C       IN  
C          COEFT    : COEF MATERIAU 
C          COEFL    : COEF ELASTIQUES 
C           NMAT    : NOMBRE  MAXI DE COEF MATERIAU 
C         NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C         CPMONO :  NOMS DES LOIS MATERIAU PAR FAMILLE
C           PGL   : MATRICE DE PASSAGE GLOBAL LOCAL
C           NVI     :  NOMBRE DE VARIABLES INTERNES
C           VINI    :  VARIABLES INTERNES A T
C           SIGI    :  CONTRAINTES A L'INSTANT COURANT
C     OUT:
C           SIGG    : TENSEUR DES CONTRAINTES POUR LA PHASE IPHAS
C INTEGRATION DES LOIS POLYCRISTALLINES PAR UNE METHODE DE RUNGE KUTTA
C
C     CETTE ROUTINE PERMET D'APPLIQUER LA METHODE DE LOCALISATION
C
C     7 variables : tenseur EVP + Norme(EVP) 
C    description des variables internes :
C    pour chaque phase 
C        6 variables : beta ou epsilonp par phase
C    pour chaque phase 
C        pour chaque systeme de glissement
C              3 variables Alpha, Gamma, P
C    1 variable : indic
C ======================================================================

      MU=COEL(1)/2.D0/(1.D0+COEL(2))
      
C --  METHODE LOCALISATION
      IF (LOCA.EQ.'BZ') THEN
         CALL LCDEVI(SIGI,DEV)
         NORME = LCNRTS( DEV ) 
         EVPCUM=VINI(7)
         IF (NORME.GT.R8MIEM()) THEN
            ALPHA=NORME/(NORME+1.5D0*MU*EVPCUM)
         ELSE            
            ALPHA=0.D0
         ENDIF
C        EVP - EVPG(IPHAS)      
         IEVPG=7+6*(IPHAS-1)   
         DO 1 I=1,6
            SIGG(I)=SIGI(I)+ALPHA*MU*(VINI(I)-VINI(IEVPG+I))
1        CONTINUE         

      ELSEIF (LOCA.EQ.'BETA') THEN
      
C        EVP - EVPG(IPHAS)      
         IEVPG=7+6*(IPHAS-1)   
         DO 2 I=1,6
            SIGG(I)=SIGI(I)+MU*(VINI(I)-VINI(IEVPG+I))
2        CONTINUE         


      ELSE
         CALL UTMESS('F','LCLOCA','LA METHODE DE LOCALISATION '//LOCA
     &               //' EST INDISPONIBLE ACTUELLEMENT')
      ENDIF
      END
