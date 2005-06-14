      SUBROUTINE DXBMAT ( NOMTE, LZR, XYZL , PGL , IGAU, JACGAU, BMAT)
      IMPLICIT  NONE
      CHARACTER*16 NOMTE
      INTEGER      LZR, IGAU
      REAL*8       XYZL(3,1) , PGL(3,1), BMAT(8,1), JACGAU
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2004   AUTEUR CIBHHLV L.VIVAN 
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
C     ------------------------------------------------------------------
C --- CALCUL DE LA MATRICE (B) RELIANT LES DEFORMATIONS DU PREMIER 
C --- ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION D'INDICE IGAU  
C --- POUR LES ELEMENTS : DST, DKT, DSQ, DKQ, Q4G 
C --- (I.E. (EPS_1) = (B)*(UN))
C --- D'AUTRE_PART, ON CALCULE LE PRODUIT NOTE JACGAU = JACOBIEN*POIDS
C     ------------------------------------------------------------------
C     IN  NOMTE         : NOM DU TYPE D'ELEMENT
C     IN  LZR           : ADRESSE DU VECTEUR .DESR DEFINISSANT UN 
C                         CERTAIN NOMBRE DE QUANTITES GEOMETRIQUES
C                         SUR L'ELEMENT
C     IN  XYZL(3,NBNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
C                         DANS LE REPERE LOCAL DE L'ELEMENT
C     IN  PGL(3,3)      : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                         LOCAL
C     IN  IGAU          : INDICE DU POINT D'INTEGRATION
C     OUT JACGAU        : PRODUIT JACOBIEN*POIDS AU POINT D'INTEGRATION
C                         COURANT
C     OUT BMAT(6,1)     : MATRICE (B) AU POINT D'INTEGRATION COURANT
C     ------------------------------------------------------------------
C
C
      IF(NOMTE(1:8).EQ.'MEDKTR3 '.OR.NOMTE(1:8).EQ.'MEGRDKT '.OR.
     &   NOMTE(1:9).EQ.'MEDKTG3 ') THEN
          CALL DKTB(LZR, IGAU, JACGAU, BMAT)
C
      ELSEIF (NOMTE(1:8) .EQ.'MEDSTR3 ') THEN
          CALL DSTB(LZR, PGL, IGAU, JACGAU, BMAT)
C
      ELSEIF (NOMTE(1:8) .EQ.'MEDKQU4 ' .OR. 
     &        NOMTE(1:8) .EQ.'MEDKQG4 ' ) THEN
          CALL DKQB(LZR, XYZL, IGAU, JACGAU, BMAT)
C
      ELSEIF (NOMTE(1:8) .EQ.'MEDSQU4 ') THEN
          CALL DSQB( NOMTE, LZR, XYZL, PGL, IGAU, JACGAU, BMAT)
C
      ELSEIF (NOMTE(1:8) .EQ.'MEQ4QU4 ') THEN
          CALL Q4GB(LZR, XYZL, IGAU, JACGAU, BMAT)
C
      ELSE
         CALL UTMESS('F','DXBMAT','LE TYPE D''ELEMENT : '//NOMTE(1:8)
     +               //'N''EST PAS PREVU.')
      ENDIF
C
      END
