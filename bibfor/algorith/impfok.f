      SUBROUTINE IMPFOK(MESSAG,LONG,UNITE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/09/2005   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      CHARACTER*(*) MESSAG
      INTEGER       LONG
      INTEGER       UNITE
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : 
C ----------------------------------------------------------------------
C
C CREATION D'UNE CHAINE FORMATEE DANS UN CHAINE
C
C IN  MESSAG : CHAINE A FORMATER
C IN  LONG   : LONGUEUR DE FORMATAGE DE LA CHAINE
C                 SI ZERO, PAS DE FORMATAGE
C IN  UNITE  : UNITE D'IMPRESSION 
C
C ----------------------------------------------------------------------
C
      INTEGER          ZLIG
      PARAMETER       (ZLIG = 255)
      CHARACTER*6      FORMA
C
C ----------------------------------------------------------------------
C
      IF (LONG.EQ.0) THEN
        FORMA = '(A)'
      ELSEIF (LONG.GT.ZLIG) THEN
        CALL UTMESS('F','IMPFOK',
     &               'DEPASSEMENT DE CAPACITE AFFICHAGE (DVLP)')
      ELSE  
        WRITE(FORMA,1001) LONG
      ENDIF
      IF (UNITE.EQ.0) THEN
        CALL UTMESS('F','IMPFOK',
     &              'UNITE LOGIQUE INVALIDE (DVLP)') 
      ELSE
        WRITE(UNITE,FORMA) MESSAG(1:LONG)        
      ENDIF

 1001 FORMAT ('(A',I3,')')

      END
