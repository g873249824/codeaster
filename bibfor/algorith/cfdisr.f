      FUNCTION CFDISR(DEFICZ,QUESTZ)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/07/2012   AUTEUR ABBAS M.ABBAS 
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
      INCLUDE 'jeveux.h'
      REAL*8        CFDISR
      CHARACTER*(*) DEFICZ
      CHARACTER*(*) QUESTZ
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES)
C
C RETOURNE DES INFOS DIVERSES POUR LE CONTACT (REEL)
C
C ----------------------------------------------------------------------
C
C      
C IN  DEFICO  : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  QUESTI  : QUESTION (PARAMETRE INTERROGE)
C   'RESI_ABSO'     PARAMETRE METHODE GCP
C   'COEF_RESI'     PARAMETRE METHODE GCP  
C
C
C
C
      CHARACTER*24 DEFICO,QUESTI
      CHARACTER*24 PARACR
      INTEGER      JPARCR,IZONE
      REAL*8       MMINFR   
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      DEFICO = DEFICZ
      QUESTI = QUESTZ    
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C 
      PARACR = DEFICO(1:16)//'.PARACR'       
      CALL JEVEUO(PARACR,'L',JPARCR)     
C
      IF (QUESTI.EQ.'RESI_GEOM')   THEN
        CFDISR = ZR(JPARCR+1-1)

      ELSEIF (QUESTI.EQ.'RESI_FROT')   THEN
        CFDISR = ZR(JPARCR+2-1)
                     
      ELSEIF (QUESTI.EQ.'RESI_ABSO')     THEN
        CFDISR = ZR(JPARCR+4-1)
        
      ELSEIF (QUESTI.EQ.'COEF_RESI')     THEN
        CFDISR = ZR(JPARCR+5-1)

      ELSEIF (QUESTI.EQ.'ALARME_JEU')    THEN
        IZONE  = 1
        CFDISR = MMINFR(DEFICO,'ALARME_JEU',IZONE )
                              
      ELSEIF (QUESTI.EQ.'PROJ_NEWT_RESI')THEN
        CFDISR = 1D-4  
  
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      END
