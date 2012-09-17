      SUBROUTINE OBTLIG(SDTABL,SEPCOL,LIGNE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      INCLUDE       'jeveux.h'
      CHARACTER*24  SDTABL
      CHARACTER*1   SEPCOL
      CHARACTER*255 LIGNE
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (GESTION STRUCTS - TABLEAU POUR IMPRESSION)
C
C CREATION D'UNE LIGNE VIDE AVEC LES SEPARATEURS DE COLONNES
C
C ----------------------------------------------------------------------
C
C
C IN  SDTABL : STRUCT TABLEAU POUR IMPRESSION
C IN  SEPCOL : SEPARATEUR COLONNE
C OUT LIGNE  : LIGNE
C
C ----------------------------------------------------------------------
C
      CHARACTER*24  SLCOLO,SDCOLO
      INTEGER       ICOLO,NBCOLO
      INTEGER       LARCOL,LARLIG,LARCUM
      LOGICAL       LACTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LIGNE  = ' '
C
C --- LISTE DES COLONNES DISPONIBLES
C
      CALL OBGETO(SDTABL,'COLONNES_DISPOS',SLCOLO)
C
C --- NOMBRE DE COLONNES TOTAL
C
      CALL OBGETI(SLCOLO,'NBRE_STRUCTS'   ,NBCOLO)
C
C --- LARGEUR D'UNE LIGNE
C
      CALL OBGETI(SDTABL,'LARGEUR_LIGNE'  ,LARLIG)
C
C --- MESURE LARGEUR
C
      LIGNE(1:1) = SEPCOL
      LARCUM     = 1
      DO 10 ICOLO = 1,NBCOLO
        CALL OBLGOI(SLCOLO,ICOLO ,SDCOLO)
        CALL OBLGAI(SLCOLO,ICOLO ,LACTI )
        IF (LACTI) THEN
          CALL OBGETI(SDCOLO,'LARGEUR',LARCOL)
          LARCUM = LARCUM + LARCOL + 1
          LIGNE(LARCUM:LARCUM) = SEPCOL
        ENDIF
 10   CONTINUE
C
C --- VERIF
C 
      CALL ASSERT(LARCUM.EQ.LARLIG)
C
      CALL JEDEMA()

      END
