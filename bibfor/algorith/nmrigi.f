      SUBROUTINE NMRIGI(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &                  SDDYNA,FONACT,ITERAT,VALMOI,VALPLU,
     &                  POUGD ,SOLALG,LISCHA,COMREF,MEELEM,
     &                  VEELEM,OPTIOZ,LDCCVG,CODERE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE   
      CHARACTER*(*) OPTIOZ       
      CHARACTER*(*) MODELZ
      CHARACTER*(*) MATE
      CHARACTER*24  COMPOR,CARCRI,CARELE
      INTEGER       ITERAT,LDCCVG
      CHARACTER*19  SDDYNA,LISCHA
      CHARACTER*24  COMREF,CODERE
      CHARACTER*24  VALMOI(8),VALPLU(8),POUGD(8)
      CHARACTER*19  MEELEM(*),VEELEM(*),SOLALG(*)
      LOGICAL       FONACT(*)          
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CALCUL DES MATR_ELEM DE RIGIDITE
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  OPTRIG : OPTION DE CALCUL POUR MERIMO
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  ITERAT : NUMERO D'ITERATION
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  POUGD  : VARIABLE CHAPEAU POUR POUR POUTRES EN GRANDES ROTATIONS
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                0 : CAS DE FONCTIONNEMENT NORMAL
C                1 : ECHEC DE L'INTEGRATION DE LA LDC
C                3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
C      
C ----------------------------------------------------------------------
C
      CHARACTER*19 NMCHEX,VEFINT,MERIGI      
      CHARACTER*1  BASE     
      CHARACTER*24 MODELE 
      CHARACTER*16 OPTRIG
      LOGICAL      TABRET(0:10)
C      
C ----------------------------------------------------------------------
C
         
C
C --- INITIALISATIONS
C
      BASE   = 'V'
      MODELE = MODELZ
      LDCCVG = 0
      OPTRIG = OPTIOZ
C
C --- VECT_ELEM ET MATR_ELEM
C
      VEFINT = NMCHEX(VEELEM,'VEELEM','CNFINT')
      MERIGI = NMCHEX(MEELEM,'MEELEM','MERIGI')
C
C --- INCREMENT DE DEPLACEMENT NUL EN PREDICTION
C      
      IF (OPTRIG(1:9).EQ.'RIGI_MECA') THEN
        CALL NMDEP0('ON ',SOLALG)
      ENDIF           
C
C --- CALCUL DES MATR_ELEM DE RIGIDITE
C      
      CALL MERIMO(BASE  ,MODELE,CARELE,MATE    ,COMREF,
     &            COMPOR,LISCHA,CARCRI,ITERAT+1,FONACT,
     &            SDDYNA,VALMOI,VALPLU,POUGD   ,SOLALG,
     &            MERIGI,VEFINT,OPTRIG,TABRET  ,CODERE)
      IF (TABRET(0)) THEN
        IF ( TABRET(3) ) THEN
          LDCCVG = 3
        ELSE
          LDCCVG = 1
        ENDIF
        IF ( TABRET(1) ) THEN
          LDCCVG = 1
        ENDIF
      ENDIF 
C
C --- REMISE INCREMENT DE DEPLACEMENT 
C      
      IF (OPTRIG(1:9).EQ.'RIGI_MECA') THEN
        CALL NMDEP0('OFF',SOLALG)
      ENDIF                
C
      END
