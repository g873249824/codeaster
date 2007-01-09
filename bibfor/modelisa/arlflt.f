      SUBROUTINE ARLFLT(NOM0,BC,NOM1)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*10 NOM0
      CHARACTER*10 NOM1 
      REAL*8       BC(2,*)    
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C FILTRAGE DES MAILLES SITUEES DANS LA BOITE DE LA ZONE DE RECOUVREMENT
C
C ----------------------------------------------------------------------
C
C
C IN  NOM0   : NOM SD DOMAINE A FILTRER
C IN  BC     : BOITE ENGLOBANT LA ZONE DE RECOUVREMENT
C OUT NOM1   : NOM SD DOMAINE FILTRE
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*16 NOMBOI,NOMBO0
      CHARACTER*24 NGRMA0,NGRMA 
C      
C ----------------------------------------------------------------------
C 
C
C --- LECTURE DES DONNEES
C
      NOMBO0 = NOM0(1:10)//'.BOITE'
      NGRMA0 = NOM0(1:10)//'.GROUPEMA'
      NOMBOI = NOM1(1:10)//'.BOITE'
      NGRMA  = NOM1(1:10)//'.GROUPEMA'      
C
C --- FILTRAGE DES MAILLES UTILES.
C
      CALL BOITFI(NOMBO0,NGRMA0,BC    ,NGRMA,NOMBOI)
C     
      END
