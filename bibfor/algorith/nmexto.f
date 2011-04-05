      SUBROUTINE NMEXTO(TYPCPT,TYPCHA,EXTRCP,EXTRGA,EXTRCH,
     &                  NBNO  ,NBMA  ,NBCMP ,NBPI  ,NBSPI ,
     &                  NCOMPT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2011   AUTEUR ABBAS M.ABBAS 
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
      INTEGER       NCOMPT
      CHARACTER*4   TYPCHA,TYPCPT     
      INTEGER       NBNO,NBMA,NBCMP,NBPI,NBSPI
      CHARACTER*8   EXTRCP,EXTRGA,EXTRCH
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (EXTRACTION - UTILITAIRE)
C
C DECOMPTE DES POINTS D'EXTRACTION
C
C ----------------------------------------------------------------------
C
C
C IN  TYPCPT : TYPE DE DECOMPTE
C      'COMP' : NOMBRE DE COMPOSANTES
C      'POIN' : NOMBRE DE POINTS
C      'LIEU' : NOMBRE DE LIEUX
C IN  TYPCHA : TYPE DU CHAMP 'NOEU' OU 'ELGA'
C IN  EXTRCP : TYPE D'EXTRACTION SUR LES COMPOSANTES
C               ' ' POUR LES VALEURS OU NOM DE LA FORMULE
C IN  EXTRGA : TYPE D'EXTRACTION SUR UNE MAILLE
C IN  EXTRCH : TYPE D'EXTRACTION SUR LE CHAMP
C IN  NBNO   : LONGUEUR DE LA LISTE DES NOEUDS (-1 SI TOUS NOEUDS)
C IN  NBMA   : LONGUEUR DE LA LISTE DES MAILLES (-1 SI TOUTES MAILLES)
C IN  NBPI   : NOMBRE DE POINTS D'INTEGRATION 
C IN  NBSPI  : NOMBRE DE SOUS-POINTS D'INTEGRATION 
C IN  NCMP   : NOMBRE DE COMPOSANTES 
C OUT NCOMPT : NOMBRE D'EXTRACTIONS
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      NCOMPT  = 0
C
C --- COMPTAGE
C      
      IF (TYPCPT.EQ.'COMP') THEN
        IF (EXTRCP.EQ.' ') THEN
          NCOMPT  = NBCMP
        ELSE
          NCOMPT  = 1
        ENDIF
      ELSEIF (TYPCPT.EQ.'POIN') THEN   
        IF (TYPCHA.EQ.'ELGA') THEN
          IF (EXTRGA.EQ.'VALE') THEN
            NCOMPT = NBPI*NBSPI
          ELSEIF ((EXTRGA.EQ.'MIN').OR.
     &            (EXTRGA.EQ.'MAX').OR.
     &            (EXTRGA.EQ.'MOY')) THEN
            NCOMPT = 1      
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (TYPCHA.EQ.'NOEU') THEN
          NCOMPT = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (TYPCPT.EQ.'LIEU') THEN 
        IF (TYPCHA.EQ.'NOEU') THEN
          IF (EXTRCH.EQ.'VALE') THEN
            NCOMPT = NBNO  
          ELSEIF ((EXTRCH.EQ.'MIN').OR.
     &            (EXTRCH.EQ.'MAX').OR.
     &            (EXTRCH.EQ.'MOY')) THEN
            NCOMPT = 1
          ELSE
            CALL ASSERT(.FALSE.)  
          ENDIF
        ELSEIF (TYPCHA.EQ.'ELGA') THEN
          IF (EXTRCH.EQ.'VALE') THEN
            NCOMPT = NBMA 
          ELSEIF ((EXTRCH.EQ.'MIN').OR.
     &            (EXTRCH.EQ.'MAX').OR.
     &            (EXTRCH.EQ.'MOY')) THEN
            NCOMPT = 1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END
