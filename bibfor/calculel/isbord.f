      LOGICAL FUNCTION ISBORD(NOMMAI,TYPEMA,DIME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8 NOMMAI
      CHARACTER*8 TYPEMA
      INTEGER     DIME
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C RETOURNE .TRUE. SI UNE MAILLE EST UNE MAILLE DE BORD
C
C ----------------------------------------------------------------------
C
C IN  NOMMAI : NOM DE LA MAILLE
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  TYPEMA : TYPE DE MAILLE
C      
C ----------------------------------------------------------------------
C
      ISBORD = .FALSE.
C
      IF (DIME.EQ.2) THEN
        IF (TYPEMA(1:3).EQ.'POI') THEN
          ISBORD = .TRUE.
        ENDIF
      ELSEIF (DIME.EQ.3) THEN   
        IF ((TYPEMA(1:3).EQ.'POI').OR.
     &      (TYPEMA(1:3).EQ.'SEG'))  THEN
          ISBORD = .TRUE.
        ENDIF
      ELSE  
        CALL ASSERT(.FALSE.)
      ENDIF
C     WRITE(6,*) 'ISBORD:',NOMMAI,TYPEMA,ISBORD      
      END
