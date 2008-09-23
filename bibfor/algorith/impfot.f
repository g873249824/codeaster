      SUBROUTINE IMPFOT(UNITE,TIME,CHAINE)
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
C
      IMPLICIT NONE
      INTEGER       UNITE
      REAL*8        TIME
      CHARACTER*(*) CHAINE
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE - UTILITAIRE)
C
C IMPRESSION D'UN TEMPS SUR UNE UNITE LOGICIELLE
C      
C ----------------------------------------------------------------------
C      
C
C IN  UNITE  : UNITE LOGICIELLE D'IMPRESSION
C IN  TIME   : TEMPS EN SECONDES A AFFICHER
C OUT CHAINE : CHAINE DE SORTIE SI UNITE = 0
C
C ----------------------------------------------------------------------
C
      REAL*8       SECOND     
      INTEGER      MINUT,HEURE   
C
C ----------------------------------------------------------------------
C
      IF (TIME.LT.60.0D0) THEN
        WRITE(CHAINE,10) TIME
      ELSE 
        IF (TIME.LE.3600.D0) THEN
          MINUT  = NINT(TIME/60)
          SECOND = ABS(TIME - (MINUT*60))
          WRITE(CHAINE,20) MINUT,SECOND
        ELSE
          HEURE  = NINT(TIME/3600)
          MINUT  = NINT((TIME - (HEURE*3600))/60)
          SECOND = ABS(TIME - (HEURE*3600) - (MINUT*60))
          WRITE(CHAINE,30) HEURE,MINUT,SECOND
        ENDIF  
      ENDIF

 10   FORMAT (F6.3,' S')
 20   FORMAT (I2,' M ',F6.3,' S') 
 30   FORMAT (I8,' H ',I2,' M ',F6.3,' S') 
 

      END
