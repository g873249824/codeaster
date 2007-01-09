      SUBROUTINE TMACOQ(TYPEMA,DIME  ,LCOQUE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8 TYPEMA
      INTEGER     DIME,LCOQUE
C      
C ----------------------------------------------------------------------
C
C CONSTRUCTION DE BOITES ENGLOBANTES POUR UN GROUPE DE MAILLES
C
C DONNE LE TYPE DE MAILLE VOLUMIQUE ASSOCIE A UN TYPE DE MAILLE COQUE
C
C ----------------------------------------------------------------------
C
C
C I/O TYPEMA : TYPE DE MAILLE
C IN  DIME   : DIMENSION DE L'ESPACE
C OUT LCOQUE : = 0  TYPEMA N'EST PAS UNE MAILLE DE COQUE
C                      TYPEMA INCHANGE
C              = 1  TYPEMA EST UNE MAILLE DE COQUE
C                      TYPEMA = TYPE DE MAILLE VOLUM. ASSOCIE
C
C ----------------------------------------------------------------------
C    
      IF (DIME.EQ.2) THEN
        IF (TYPEMA(1:3).EQ.'SEG') THEN 
          TYPEMA = 'QUAD6'
          LCOQUE = 1
        ELSE
          LCOQUE = 0
        ENDIF
      ELSEIF (DIME.EQ.3) THEN
        IF (TYPEMA(1:4).EQ.'TRIA') THEN
          LCOQUE = 1
          IF (TYPEMA(5:5).EQ.'3') THEN
            TYPEMA = 'PENTA6'
          ELSEIF (TYPEMA(5:5).EQ.'6') THEN
            TYPEMA = 'PENTA12'
          ELSEIF (TYPEMA(5:5).EQ.'7') THEN
            TYPEMA = 'PENTA14'
          ELSE 
            WRITE(6,*) 'MAILLE INCONNUE: ',TYPEMA
            CALL ASSERT(.FALSE.)              
          ENDIF
        ELSEIF (TYPEMA(1:4).EQ.'QUAD') THEN
          LCOQUE = 1
          IF (TYPEMA(5:5).EQ.'4') THEN
            TYPEMA = 'HEXA8'
          ELSEIF (TYPEMA(5:5).EQ.'8') THEN
            TYPEMA = 'HEXA16'
          ELSEIF (TYPEMA(5:5).EQ.'9') THEN
            TYPEMA = 'HEXA18'
          ELSE 
            WRITE(6,*) 'MAILLE INCONNUE: ',TYPEMA
            CALL ASSERT(.FALSE.)  
          ENDIF
        ELSE
          LCOQUE = 0
        ENDIF
      ELSE
        WRITE(6,*) 'DIMENSION INCONNUE: ',DIME
        CALL ASSERT(.FALSE.) 
      ENDIF
      END
