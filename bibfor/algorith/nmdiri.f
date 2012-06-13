      SUBROUTINE NMDIRI(MODELE,MATE  ,CARELE,LISCHA,SDDYNA,
     &                  DEPL  ,VITE  ,ACCE  ,VEDIRI)
C  
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE     
      INCLUDE 'jeveux.h'
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE,MATE,CARELE
      CHARACTER*19  VEDIRI,SDDYNA
      CHARACTER*19  DEPL,VITE,ACCE
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DES VECT_ELEM POUR LES REACTIONS D'APPUI BT.LAMBDA
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  LISCHA : LISTE DES CHARGES
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  SDDYNA : SD DYNAMIQUE
C OUT VEDIRI : VECT_ELEM DES REACTIONS D'APPUI BT.LAMBDA
C
C
C
C
      LOGICAL      NDYNLO,LSTAT,LDEPL,LVITE,LACCE
      INTEGER      NDYNIN
      CHARACTER*19 VECLAG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVEES
C    
      LSTAT  = NDYNLO(SDDYNA,'STATIQUE')
      IF (LSTAT) THEN
        LDEPL = .TRUE.
        LVITE = .FALSE.
        LACCE = .FALSE.
      ELSE
        LDEPL  = NDYNIN(SDDYNA,'FORMUL_DYNAMIQUE').EQ.1
        LVITE  = NDYNIN(SDDYNA,'FORMUL_DYNAMIQUE').EQ.2
        LACCE  = NDYNIN(SDDYNA,'FORMUL_DYNAMIQUE').EQ.3  
      ENDIF               
C
C --- QUEL VECTEUR D'INCONNUES PORTE LES LAGRANGES ?
C      
      IF (LDEPL) THEN
        VECLAG = DEPL
      ELSEIF (LVITE) THEN
        VECLAG = VITE
C       VILAINE GLUTE POUR L'INSTANT      
        VECLAG = DEPL
      ELSEIF (LACCE) THEN
        VECLAG = ACCE
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF    
C
C --- CALCUL DES VECT_ELEM POUR LES REACTIONS D'APPUI BT.LAMBDA 
C
      CALL VEBTLA('V',MODELE,MATE  ,CARELE,VECLAG,LISCHA,
     &            VEDIRI)   
C
      CALL JEDEMA()
      END
