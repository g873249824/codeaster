      SUBROUTINE FOEC2F(IUNI,V,NBCOUP,N1,N2,NOMPAR,NOMRES)
      IMPLICIT NONE
      INTEGER           IUNI,  NBCOUP,N1,N2
      REAL*8                 V(2*NBCOUP)
      CHARACTER*(*)                         NOMPAR,NOMRES
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     ECRITURE DES COUPLES (PARAMETRE, RESULTAT) D'UNE FONCTION,
C     DU N1-IEME AU N2-IEME
C     ------------------------------------------------------------------
C     ARGUMENTS D'ENTREE:
C        IUNI  : NUMERO D'UNITE LOGIQUE D'ECRITURE
C        VEC   : VECTEUR DES VALEURS (PARAMETRES ET RESULTATS)
C        NBCOUP: NOMBRE DE COUPLES DE VALEURS
C        N1, N2: NUMEROS DE DEBUT ET FIN DE LA LISTE
C        NOMPAR: NOM DU PARAMETRE
C        NOMRES: NOM DU RESULTAT
C     ------------------------------------------------------------------
      CHARACTER*8  GVA, GFO
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,J 
C-----------------------------------------------------------------------
      N1=MIN(N1,NBCOUP)
      N2=MIN(N2,NBCOUP)
C
      GVA = NOMPAR
      GFO = NOMRES
      WRITE(IUNI, 100 )
     +    ( ('<-PARAMETRE-><-RESULTAT->  ')  , J=1,3  ) ,
     +    ( ('  '//GVA//'     '//GFO//'    '), I=1,3  )
      WRITE(IUNI,101) (V(I),V(NBCOUP+I),I=N1,N2 )
C
 100  FORMAT(/,1X,3A,/,1X,3A )
 101  FORMAT( 3(1X,1PD12.5,1X,1PD12.5,1X) )
C
      END
