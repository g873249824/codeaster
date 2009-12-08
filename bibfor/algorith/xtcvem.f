      SUBROUTINE XTCVEM(PHASE ,MODELE,RESOCO,DEPMOI,DEPDEL,
     &                  VEXFTE)
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
      CHARACTER*4   PHASE      
      CHARACTER*19  VEXFTE
      CHARACTER*24  MODELE,RESOCO
      CHARACTER*24  DEPMOI,DEPDEL
C     
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION OBJETS)
C
C CALCUL DES VECTEURS ELEMENTAIRES DES ELEMENTS DE CONTACT/FROTTEMENT 
C DANS LE CADRE D'X-FEM 'GRANDS GLISSEMENTS'
C      
C ----------------------------------------------------------------------
C   
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  PHASE  : CONTACT OU FROTTEMENT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  DEPMOI : CHAM_NO DES DEPLACEMENTS A L'INSTANT PRECEDENT
C IN  MODELE : NOM DU MODELE
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C OUT VEXFTE : VECT_ELEM DE CONTACT OU DE FROTTEMENT
C
C ----------------------------------------------------------------------
C
      CHARACTER*16 OPTION
      CHARACTER*8  NOMO
C
C ----------------------------------------------------------------------
C
      NOMO   = MODELE
C
      IF (PHASE.EQ.'CONT') THEN
        OPTION = 'CHAR_MECA_CONT'
      ELSEIF (PHASE.EQ.'FROT') THEN
        OPTION = 'CHAR_MECA_FROT'           
      ELSE    
        CALL ASSERT(.FALSE.)
      ENDIF      
C
C --- CALCUL DU VECT_ELEM
C
      CALL XMTCVE(OPTION,NOMO  ,DEPMOI,DEPDEL,RESOCO,
     &            VEXFTE)
C
      END
