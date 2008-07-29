      INTEGER FUNCTION XXMMVD(VECT) 
C    
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 28/07/2008   AUTEUR LAVERNE J.LAVERNE 
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
      CHARACTER*5 VECT
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (UTILITAIRE)
C
C RETOURNE LA LONGUEUR FIXE DES VECTEURS DE LA SD SDXFEM
C
C ----------------------------------------------------------------------
C
C
C IN  VECT   : NOM DU VECTEUR DONT ON VEUT LA DIMENSION
C
C ----------------------------------------------------------------------
C
      INTEGER   ZXCAR,ZXIND
      PARAMETER (ZXCAR=11,ZXIND=6) 
      INTEGER   ZXBAS
      PARAMETER (ZXBAS=12)  
      LOGICAL    LVECT                       
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      LVECT=.FALSE.
      IF (VECT.EQ.'ZXCAR') THEN
        XXMMVD = ZXCAR  
      ELSEIF (VECT.EQ.'ZXIND') THEN
        XXMMVD = ZXIND  
      ELSEIF (VECT.EQ.'ZXBAS') THEN
        XXMMVD = ZXBAS                          
      ELSE
        CALL ASSERT(LVECT)
      ENDIF  
C
      CALL JEDEMA()
      END
