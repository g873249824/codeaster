      SUBROUTINE CFDECO(RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/09/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*24 RESOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - POST-TRAITEMENT)
C
C SAUVEGARDE DES VECTEURS DE JEU
C
C ----------------------------------------------------------------------
C
C ON SAUVEGARDE LE JEU POUR PERMETTRE LA SUBDIVISION DU PAS DE TEMPS
C EN GEOMETRIE INITIALE (REAC_GEOM='SANS')
C
C RECUPERATION EVENTUELLE DANS REAJEU
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 JEUITE,JEUSAV
C
C ----------------------------------------------------------------------
C
      JEUITE = RESOCO(1:14)//'.JEUITE'
      JEUSAV = RESOCO(1:14)//'.JEUSAV'
      CALL JEDUPO(JEUITE,'V',JEUSAV,.FALSE.)
C 
      END
