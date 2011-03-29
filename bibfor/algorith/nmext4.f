      SUBROUTINE NMEXT4(NOMA  ,CHAMP ,NOMCHA,NBCMP ,NBMA  ,
     &                  NBPI  ,NBSPI ,EXTRGA,EXTRCH,EXTRCP,
     &                  LISTMA,LISTPI,LISTSP,LISTCP,CHGAUS,
     &                  CHELGA,CHELES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/03/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      INTEGER       NBCMP,NBMA,NBPI,NBSPI
      CHARACTER*8   NOMA
      CHARACTER*16  NOMCHA
      CHARACTER*8   EXTRCP,EXTRCH,EXTRGA
      CHARACTER*24  LISTMA,LISTPI,LISTSP,LISTCP
      CHARACTER*19  CHAMP,CHGAUS,CHELGA
      CHARACTER*19  CHELES
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (OBSERVATION - UTILITAIRE)
C
C EXTRAIRE LES VALEURS - CAS DES CHAMPS AUX POITNS DE GAUSS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  CHAMP  : CHAMP OBSERVE
C IN  NOMCHA : NOM DU CHAMP
C IN  NBCMP  : NOMBRE DE COMPOSANTES DANS LA SD
C IN  NBMA   : NOMBRE DE MAILLES DANS LA SD
C IN  NBPI   : NOMBRE DE POINTS D'INTEGRATION 
C IN  NBSPI  : NOMBRE DE SOUS-POINTS D'INTEGRATION
C IN  EXTRGA : TYPE D'EXTRACTION SUR UNE MAILLE
C IN  EXTRCH : TYPE D'EXTRACTION SUR LE CHAMP
C IN  EXTRCP : TYPE D'EXTRACTION SUR LES COMPOSANTES
C IN  LISTMA : LISTE CONTENANT LES MAILLES
C IN  LISTCP : LISTE DES COMPOSANTES
C IN  LISTPI : LISTE CONTENANT LES POINTS D'EXTRACTION
C IN  LISTSP : LISTE CONTENANT LES SOUS-POINTS D'EXTRACTION
C IN  CHELGA : VECTEUR DE TRAVAIL CHAMPS AUX ELEMENTS
C IN  CHGAUS : VECTEUR DE TRAVAIL CHAMPS AUX POINTS DE GAUSS
C IN  CHELES : CHAM_ELEM_S REDUIT DE <CHAMP>
C
C ----------------------------------------------------------------------
C
      CALL ASSERT(.FALSE.)
C
      END
