      SUBROUTINE CFLEQA(NOMA  ,DEFICO,NZOCO ,NNOQUA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMA
      INTEGER      NZOCO
      CHARACTER*24 DEFICO
      INTEGER      NNOQUA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES MAILLEES - LECTURE DONNEES - QUAD8)
C
C NOMBRE TOTAL DE NOEUDS QUADRATIQUES
C      
C ----------------------------------------------------------------------
C
C 
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : NOM SD CONTACT DEFINITION
C IN  NZOCO  : NOMBRE TOTAL DE ZONES DE CONTACT
C OUT NNOQUA : NOMBRE TOTAL DE NOEUDS QUADRATIQUES DES SURFACES
C
C
C
C
      CHARACTER*24 PZONE
      INTEGER      JZONE
      CHARACTER*24 CONTMA
      INTEGER      JMACO
      INTEGER      JDECMA,NUMMAI,POSMAI
      INTEGER      ISURF,IZONE,IMA,NUTYP,ISUCO
      INTEGER      NBSURF,NBMA
      INTEGER      IATYMA,ITYPMA
      CHARACTER*8  NOMTM
      INTEGER      NBNOMI
      LOGICAL      MMINFL,LVERI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()    
C 
C --- ACCES AUX STRUCTURES DE DONNEES DE CONTACT
C 
      CONTMA = DEFICO(1:16)//'.MAILCO' 
      PZONE  = DEFICO(1:16)//'.PZONECO'
      CALL JEVEUO(CONTMA,'L',JMACO)  
      CALL JEVEUO(PZONE, 'L',JZONE) 
C
C --- INITIALISATIONS
C 
      NNOQUA = 0
      NBNOMI = 0
      CALL JEVEUO(NOMA(1:8)//'.TYPMAIL','L',IATYMA)             
C
C --- DECOMPTE DES NOEUDS MILIEUX POUR CHAQUE SURFACE
      
      DO 10 IZONE = 1,NZOCO
C      
        LVERI  = MMINFL(DEFICO,'VERIF',IZONE )
        IF (LVERI) THEN
          GOTO 21
        ENDIF
C
C ----- NOMBRE DE SURFACES DE CONTACT
C        
        NBSURF = ZI(JZONE+IZONE) - ZI(JZONE+IZONE-1)
        CALL ASSERT(NBSURF.EQ.2)      
C      
        DO 20 ISUCO = 1,NBSURF
      
          ISURF  = NBSURF*(IZONE-1)+ISUCO
          
          CALL CFNBSF(DEFICO,ISURF ,'MAIL',NBMA  ,JDECMA)
              
          DO 30 IMA = 1,NBMA 
C
C --------- NUMERO MAILLE COURANTE
C
            POSMAI = JDECMA+IMA
            NUMMAI = ZI(JMACO+POSMAI-1)
C
C --------- TYPE MAILLE COURANTE
C          
            ITYPMA = IATYMA - 1 + NUMMAI
            NUTYP  = ZI(ITYPMA)       
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP ),NOMTM )
C
C --------- NOMBRE DE NOEUDS MILIEUX A STOCKER A PART SUR LA MAILLE
C 
            IF  (NOMTM(1:5).EQ.'QUAD9') THEN 
              NBNOMI = 0                       
            ELSEIF  (NOMTM(1:5).EQ.'TRIA7') THEN 
              NBNOMI = 0
            ELSEIF  (NOMTM(1:5).EQ.'QUAD8') THEN 
              NBNOMI = 4    
            ELSEIF  (NOMTM(1:5).EQ.'TRIA6') THEN 
              NBNOMI = 0                
            ELSE
              NBNOMI = 0         
            ENDIF          
C
C --------- NOMBRE _TOTAL_ DE NOEUDS MILIEUX A STOCKER A PART
C
            NNOQUA = NNOQUA + NBNOMI
C
  30      CONTINUE
  20    CONTINUE 
  21    CONTINUE
  10  CONTINUE 
C
      CALL JEDEMA()
      END
