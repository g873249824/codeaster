      SUBROUTINE NMRTIM(SDTIME,TIMERZ,TIME  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) TIMERZ
      CHARACTER*24  SDTIME
      REAL*8        TIME
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C MESURE DE STATISTIQUES - SAUVEGARDE DES TEMPS
C
C ----------------------------------------------------------------------
C
C
C IN  SDTIME : SD TIMER
C IN  TIMER  : NOM DU TIMER
C              'PAS'               TIMER PAS DE TEMPS
C              'ITE'               TIMER ITERATION DE NEWTON
C              'ARC'               TIMER ARCHIVAGE
C              'POST_TRAITEMENT'   TIMER POST_PROCESSING
C              'FACTOR'            TIMER FACTORISATION
C              'SOLVE'             TIMER RESOLUTION
C              'INTEGRATION'       TIMER INTEG. LDC
C              'ASSE_MATR'         TIMER ASSEMBLAGE MATRICES
C              'CONT_GEOM'         TIMER APPARIEMENT CONTACT
C              'CTCD_ALGO'         TIMER RESOLUTION CONTACT DISCRET
C              'CTCC_CONT'         TIMER RESOLUTION CONTACT CONTINU
C              'CTCC_FROT'         TIMER RESOLUTION FROTTEMENT CONTINU
C              'CTCC_MATR'         TIMER CALCUL MATRICE CONTINU
C              'SECO_MEMB'         TIMER CALCUL SECOND MEMBRE
C              'PAS_LOST'          TEMPS PERDU DANS PAS (DECOUPE)
C IN  TIME   : VALEUR DU TEMPS MESURE
C
C
C
C
      CHARACTER*24 TIMET,TIMEP,TIMEN
      INTEGER      JTIMET,JTIMEP,JTIMEN
      CHARACTER*24 TIMER 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()            
C                      
C --- INITIALISATIONS
C                
      TIMER  = TIMERZ
C
C --- ACCES SDTIME: TOTAL/PAS/NEWTON
C
      TIMET  = SDTIME(1:19)//'.TIMT'
      TIMEP  = SDTIME(1:19)//'.TIMP'
      TIMEN  = SDTIME(1:19)//'.TIMN'
      CALL JEVEUO(TIMET ,'E',JTIMET)
      CALL JEVEUO(TIMEP ,'E',JTIMEP)
      CALL JEVEUO(TIMEN ,'E',JTIMEN) 
C
C --- ENREGISTREMENT DES TEMPS
C      
      IF (TIMER.EQ.'PAS') THEN
        ZR(JTIMET+1-1) = ZR(JTIMET+1-1) + TIME
        ZR(JTIMEP+1-1) = ZR(JTIMEP+1-1) + TIME
        
      ELSEIF (TIMER.EQ.'ITE') THEN
        ZR(JTIMET+2-1) = ZR(JTIMET+2-1) + TIME
        ZR(JTIMEP+2-1) = ZR(JTIMEP+2-1) + TIME
        ZR(JTIMEN+2-1) = ZR(JTIMEN+2-1) + TIME
      
      ELSEIF (TIMER.EQ.'ARC') THEN
        ZR(JTIMET+3-1) = ZR(JTIMET+3-1) + TIME
        ZR(JTIMEP+3-1) = ZR(JTIMEP+3-1) + TIME
        ZR(JTIMEN+3-1) = ZR(JTIMEN+3-1) + TIME
        
      ELSEIF (TIMER.EQ.'FACTOR') THEN
        ZR(JTIMET+4-1) = ZR(JTIMET+4-1) + TIME
        ZR(JTIMEP+4-1) = ZR(JTIMEP+4-1) + TIME
        ZR(JTIMEN+4-1) = ZR(JTIMEN+4-1) + TIME
        
      ELSEIF (TIMER.EQ.'SOLVE') THEN
        ZR(JTIMET+5-1) = ZR(JTIMET+5-1) + TIME
        ZR(JTIMEP+5-1) = ZR(JTIMEP+5-1) + TIME
        ZR(JTIMEN+5-1) = ZR(JTIMEN+5-1) + TIME
        
      ELSEIF (TIMER.EQ.'INTEGRATION') THEN
        ZR(JTIMET+6-1) = ZR(JTIMET+6-1) + TIME
        ZR(JTIMEP+6-1) = ZR(JTIMEP+6-1) + TIME
        ZR(JTIMEN+6-1) = ZR(JTIMEN+6-1) + TIME
        
      ELSEIF (TIMER.EQ.'CONT_GEOM') THEN
        ZR(JTIMET+7-1) = ZR(JTIMET+7-1) + TIME
        ZR(JTIMEP+7-1) = ZR(JTIMEP+7-1) + TIME
        ZR(JTIMEN+7-1) = ZR(JTIMEN+7-1) + TIME

      ELSEIF (TIMER.EQ.'CTCC_MATR') THEN
        ZR(JTIMET+8-1) = ZR(JTIMET+8-1) + TIME
        ZR(JTIMEP+8-1) = ZR(JTIMEP+8-1) + TIME
        ZR(JTIMEN+8-1) = ZR(JTIMEN+8-1) + TIME

      ELSEIF (TIMER.EQ.'CTCC_CONT') THEN
        ZR(JTIMET+9-1) = ZR(JTIMET+9-1) + TIME
        ZR(JTIMEP+9-1) = ZR(JTIMEP+9-1) + TIME
        ZR(JTIMEN+9-1) = ZR(JTIMEN+9-1) + TIME      
   
      ELSEIF (TIMER.EQ.'CTCC_FROT') THEN
        ZR(JTIMET+10-1) = ZR(JTIMET+10-1) + TIME
        ZR(JTIMEP+10-1) = ZR(JTIMEP+10-1) + TIME
        ZR(JTIMEN+10-1) = ZR(JTIMEN+10-1) + TIME
       
      ELSEIF (TIMER.EQ.'CTCD_ALGO') THEN
        ZR(JTIMET+11-1) = ZR(JTIMET+11-1) + TIME
        ZR(JTIMEP+11-1) = ZR(JTIMEP+11-1) + TIME
        ZR(JTIMEN+11-1) = ZR(JTIMEN+11-1) + TIME

      ELSEIF (TIMER.EQ.'POST_TRAITEMENT') THEN
        ZR(JTIMET+12-1) = ZR(JTIMET+12-1) + TIME
        ZR(JTIMEP+12-1) = ZR(JTIMEP+12-1) + TIME
        ZR(JTIMEN+12-1) = ZR(JTIMEN+12-1) + TIME

      ELSEIF (TIMER.EQ.'CTCC_PREP') THEN
        ZR(JTIMET+13-1) = ZR(JTIMET+13-1) + TIME
        ZR(JTIMEP+13-1) = ZR(JTIMEP+13-1) + TIME
        ZR(JTIMEN+13-1) = ZR(JTIMEN+13-1) + TIME

      ELSEIF (TIMER.EQ.'SECO_MEMB') THEN
        ZR(JTIMET+14-1) = ZR(JTIMET+14-1) + TIME
        ZR(JTIMEP+14-1) = ZR(JTIMEP+14-1) + TIME
        ZR(JTIMEN+14-1) = ZR(JTIMEN+14-1) + TIME

      ELSEIF (TIMER.EQ.'ASSE_MATR') THEN
        ZR(JTIMET+15-1) = ZR(JTIMET+15-1) + TIME
        ZR(JTIMEP+15-1) = ZR(JTIMEP+15-1) + TIME
        ZR(JTIMEN+15-1) = ZR(JTIMEN+15-1) + TIME

      ELSEIF (TIMER.EQ.'PAS_LOST') THEN
        ZR(JTIMET+16-1) = ZR(JTIMET+16-1) + TIME
        ZR(JTIMEP+16-1) = ZR(JTIMEP+16-1) + TIME
        ZR(JTIMEN+16-1) = ZR(JTIMEN+16-1) + TIME
                          
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
