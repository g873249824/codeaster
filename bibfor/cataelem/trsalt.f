      SUBROUTINE TRSALT(
     *FIN,ICLASS,IVAL,CVAL,
     *MOT1,O1,MOT2,O2,O3,IRTETI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CATAELEM  DATE 12/05/97   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     INCLUDE($CIMPERR)
C
      COMMON /CIMP/ IMP,IULMES,IULIST,IULVIG
C
C     EXCLUDE($CIMPERR)
C
C
C     TRANSITION AVEC ALTERNATIVE
C
C
C     ICLASS,IVAL,CVAL ---> CE QUI A ETET LU
C
C     RETOURNE FIN = O1 OU O2   SUIVANT QUE CVAL VAUT
C       :        MOT1   OU MOT2
C     RETOURNE FIN = O3 SI ICLASS = -1 ( EOF OU FIN)
C
C
C     O1 02 ETATS DE SORTIE LIES A LA RENCONTRE DES MOTS CLES
C
C     SI OI <0  ERREUR
C
C     FIN : ETAT DE SORTIE
C
C     SI ERREUR RETURN SUR ETIQUETTE *
C
      CHARACTER*(*) MOT1,MOT2
      INTEGER FIN,O1,O2,O3
      CHARACTER*(*) CVAL
      IRTETI = 0
       IF (ICLASS.EQ.-1) THEN
         FIN =O3
         GOTO 100
       ELSE
        IF (ICLASS.EQ.3) THEN
         IF (CVAL(1:IVAL).EQ.MOT1) THEN
          FIN = O1
          GOTO 100
         ELSE IF(CVAL(1:IVAL).EQ.MOT2) THEN
          FIN = O2
          GOTO 100
         ELSE
          FIN = -1
          GOTO 100
         ENDIF
        ELSE
         FIN = -1
         GOTO 100
        ENDIF
       ENDIF
  100 CONTINUE
      IF ( FIN.LT.0) THEN
       WRITE(IULMES,*) ' ERREUR TRASLT '
       WRITE(IULMES,*) ' ALTERNATIVE ENTRE LES DEUX MOTS :'
       WRITE(IULMES,*) MOT1
       WRITE(IULMES,*) MOT2
         CALL UTMESS('F','TRSALT','PB. LECTURE CATALOGUES.')
       IRTETI = 1
       GOTO 9999
      ELSE
       IRTETI = 0
       GOTO 9999
      ENDIF
 9999 CONTINUE
      END
