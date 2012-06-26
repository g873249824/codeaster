      SUBROUTINE APVEPA(SDAPPA)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/06/2012   AUTEUR ABBAS M.ABBAS 
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
      INCLUDE      'jeveux.h'
      CHARACTER*19 SDAPPA      
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT
C
C VERIFICATIONS DE L'APPARIEMENT
C
C ----------------------------------------------------------------------
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C      
C ----------------------------------------------------------------------
C
      INTEGER      IFM,NIV    
      INTEGER      NBZONE,NTPT,NBPT
      INTEGER      TYPAPP
      INTEGER      IZONE,IP,I
      INTEGER      NONAPP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<APPARIEMENT> VERIFICATION DE L''APPARIEMENT' 
      ENDIF  
C
C --- INITIALISATIONS
C
      IP     = 1
      NONAPP = 1
      CALL APPARI(SDAPPA,'APPARI_NBZONE',NBZONE)
      CALL APPARI(SDAPPA,'APPARI_NTPT'  ,NTPT  ) 
C
C --- BOUCLE SUR LES ZONES
C
      DO 10 IZONE = 1,NBZONE  
C
C ----- INFORMATION SUR LA ZONE 
C   
        CALL APZONI(SDAPPA,IZONE ,'NBPT'  ,NBPT  )     
C
C ----- BOUCLE SUR LES POINTS
C
        DO 20 I = 1,NBPT
          CALL APINFI(SDAPPA,'APPARI_TYPE'     ,IP    ,TYPAPP )  
          IF (TYPAPP.LE.0) THEN
            NONAPP = NONAPP + 1
          ENDIF        
          IP     = IP + 1
  20    CONTINUE
  10  CONTINUE
C
      IF (NONAPP.EQ.IP) THEN
        CALL U2MESS('A','APPARIEMENT_1')
      ENDIF
C
      CALL JEDEMA()
C 
      END
