      SUBROUTINE SURFCP(CHAR  ,IFM   )
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF DEBUG  DATE 18/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      CHARACTER*8 CHAR
      INTEGER     IFM      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - AFFICHAGE DONNEES)
C
C AFFICHAGE LES INFOS CONTENUES DANS LA SD CONTACT POUR TOUTES LES
C FORMULATIONS
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  IFM    : UNITE D'IMPRESSION
C
C
C
C
      INTEGER      CFDISI,IFORM,ICONT,IFROT
      CHARACTER*24 DEFICO
      INTEGER      REACCA,REACBS,REACBG,ILISS,REACMX
      INTEGER      NBREAG,NBREAF
      REAL*8       CFDISR,RESIGE,RESIFR
      LOGICAL      CFDISL,LMAIL,LSTOP
      INTEGER      IRESOC,IRESOF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'             
C
C --- INITIALISATIONS
C    
      IFORM  = CFDISI(DEFICO,'FORMULATION')
      ICONT  = CFDISI(DEFICO,'ALGO_CONT')
      IFROT  = CFDISI(DEFICO,'ALGO_FROT')
      LMAIL  = CFDISL(DEFICO,'FORMUL_MAILLEE')
      LSTOP  = CFDISL(DEFICO,'STOP_INTERP')
      IRESOC = CFDISI(DEFICO,'ALGO_RESO_CONT')
      IRESOF = CFDISI(DEFICO,'ALGO_RESO_FROT')
C      
      NBREAG = CFDISI(DEFICO,'NB_ITER_GEOM')
      REACBG = CFDISI(DEFICO,'ITER_GEOM_MAXI') 
      RESIGE = CFDISR(DEFICO,'RESI_GEOM')
C      
      REACCA = CFDISI(DEFICO,'ITER_CONT_MULT')
      REACMX = CFDISI(DEFICO,'ITER_CONT_MAXI')
C     
      NBREAF = CFDISI(DEFICO,'NB_ITER_FROT')
      REACBS = CFDISI(DEFICO,'ITER_FROT_MAXI')  
      RESIFR = CFDISR(DEFICO,'RESI_FROT')
      ILISS  = CFDISI(DEFICO,'LISSAGE')         
C
C --- IMPRESSIONS POUR L'UTILISATEUR
C 
      WRITE (IFM,*)      
      WRITE (IFM,*) '<CONTACT> INFOS GENERALES'
      WRITE (IFM,*)           
C 
C --- IMPRESSIONS POUR LES PARAMETRES CONSTANTS
C      
      IF (IFORM.EQ.1) THEN
        WRITE (IFM,*) '<CONTACT> FORMULATION DISCRETE (MAILLEE)'
      ELSEIF (IFORM.EQ.2) THEN
        WRITE (IFM,*) '<CONTACT> FORMULATION CONTINUE (MAILLEE)'
      ELSEIF (IFORM.EQ.3) THEN
        WRITE (IFM,*) '<CONTACT> FORMULATION XFEM (NON MAILLEE)'
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
 
      WRITE (IFM,1070) 'ALGO_CONT       ',ICONT     
      WRITE (IFM,1070) 'ALGO_FROT       ',IFROT

      IF (IFORM.EQ.2) THEN
        WRITE (IFM,1070) 'ALGO_RESO_CONT  ',IRESOC     
        WRITE (IFM,1070) 'ALGO_RESO_FROT  ',IRESOF
      ENDIF
      
      IF (LMAIL) THEN
        IF (LSTOP) THEN
          WRITE (IFM,*) '<CONTACT> ...... STOP SI MODE VERIF ET'//
     &                  ' INTERPENETRATION'
        ELSE
          WRITE (IFM,*) '<CONTACT> ...... ALARME SI MODE VERIF ET'//
     &                  ' INTERPENETRATION'
        ENDIF
      ENDIF
      
      
      IF (NBREAG.EQ.0) THEN
        WRITE (IFM,*) '<CONTACT> ...... PAS DE REAC. GEOM.'
      ELSEIF (NBREAG.EQ.-1) THEN
        WRITE (IFM,*) '<CONTACT> ...... REAC. GEOM. AUTO.'
      ELSE
        WRITE (IFM,*) '<CONTACT> ...... REAC. GEOM. MANUEL: ',NBREAG
      ENDIF
      WRITE (IFM,1070) 'ITER_GEOM_MAXI  ',REACBG
      WRITE (IFM,1071) 'RESI_GEOM       ',RESIGE

      WRITE (IFM,1070) 'ITER_CONT_MULT  ',REACCA 
      WRITE (IFM,1070) 'ITER_CONT_MAXI  ',REACMX     
       
      IF (NBREAF.EQ.-1) THEN
        WRITE (IFM,*) '<CONTACT> ...... REAC. FROT. AUTO.'
      ELSE
        WRITE (IFM,*) '<CONTACT> ...... REAC. FROT. MANUEL: ',NBREAF
      ENDIF 
       
      WRITE (IFM,1070) 'ITER_FROT_MAXI  ',REACBS  
      WRITE (IFM,1071) 'RESI_FROT       ',RESIFR
      
      WRITE (IFM,1070) 'LISSAGE         ',ILISS    
C
 1070 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',I5)   
 1071 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',E12.5) 

      CALL JEDEMA
      END
