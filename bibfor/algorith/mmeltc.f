      CHARACTER*16 FUNCTION MMELTC(ITYP)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
      INTEGER      ITYP  
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C DONNE LE TYPE_ELEM DE L'ELEMENT DE CONTACT ITYP
C      
C ----------------------------------------------------------------------
C
C
C IN  ITYP   : NUMERO DU TYPE
C OUT MMELTC : NOM DU TYPE ELEMENT 
C
C
C ----------------------------------------------------------------------
C
      INTEGER      NBTYP
      PARAMETER   (NBTYP=30)
      INTEGER      K
      CHARACTER*16 NOMTC(NBTYP)
C
      DATA (NOMTC(K),K=1,NBTYP) /
     &      'COS2S2','COS3S3','COS2S3','COS3S2','COT3T3',
     &      'COT3T6','COT6T3','COT6T6','COQ4Q4','COQ4Q8',
     &      'COQ8Q4','COQ8Q8','COQ4T3','COT3Q4','COT6Q4',
     &      'COQ4T6','COT6Q8','COQ8T6','COT6Q9','COQ9T6',
     &      'COQ8T3','COT3Q8','COQ8Q9','COQ9Q8','COQ9Q4',
     &      'COQ4Q9','COQ9T3','COT3Q9','COQ9Q9','COP2P2'/
C
C ----------------------------------------------------------------------
C
      MMELTC = '                '
      IF ((ITYP.LE.0).OR.(ITYP.GT.NBTYP)) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        MMELTC = NOMTC(ITYP)
      ENDIF  
C
      END
