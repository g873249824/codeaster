      SUBROUTINE NMEQUI(ETA   ,FONACT,SDDYNA,FOINER,VEASSE,
     &                  CNFEXT,CNFINT)     
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
      REAL*8        ETA
      INTEGER       FONACT(*)
      CHARACTER*19  SDDYNA
      CHARACTER*19  VEASSE(*)
      CHARACTER*19  FOINER,CNFEXT,CNFINT    
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C RESULTANTE DES EFFORTS POUR ESTIMATION DE L'EQUILIBRE
C      
C ----------------------------------------------------------------------
C
C
C IN  SDDYNA : SD DYNAMIQUE
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  ETA    : COEFFICIENT DE PILOTAGE
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  FOINER : VECTEUR DES FORCES D'INERTIE POUR CONVERGENCE
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      NDYNIN
      LOGICAL      NDYNLO,LDYNA,LSTAT
      LOGICAL      LNEWMA,LTHETD,LTHETV,LKRENK,LDEPL,LVITE           
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> CALCUL DES FORCES POUR '//
     &                'ESTIMATION DE L''EQUILIBRE' 
      ENDIF 
C
C --- FONCTIONNALITES ACTIVEES
C    
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')   
C
C --- INITIALISATIONS
C 
      LNEWMA = .FALSE.
      LTHETV = .FALSE.
      LTHETD = .FALSE.
C
C --- FONCTIONNALITES ACTIVEES
C    
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LSTAT  = NDYNLO(SDDYNA,'STATIQUE')
      IF (LDYNA) THEN
        LNEWMA = NDYNLO(SDDYNA,'FAMILLE_NEWMARK') 
        LTHETD = NDYNLO(SDDYNA,'THETA_METHODE_DEPL') 
        LTHETV = NDYNLO(SDDYNA,'THETA_METHODE_VITE') 
        LKRENK = NDYNLO(SDDYNA,'KRENK')
        IF (LKRENK) THEN 
          LDEPL = NDYNIN(SDDYNA,'FORMUL_DYNAMIQUE').EQ.1
          LVITE = NDYNIN(SDDYNA,'FORMUL_DYNAMIQUE').EQ.2
        ENDIF
      ENDIF 
C      
C --- VECTEURS EN SORTIE 
C     
      IF (LSTAT.OR.LNEWMA) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNFEXT',CNFEXT)
        CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT)
      ELSEIF (LTHETV.OR.(LKRENK.AND.LVITE).OR.LTHETD
     &   .OR.(LKRENK.AND.LDEPL)) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNFEXT',CNFEXT)
        CNFINT = '&&CNPART.CHP3'                  
      ELSE
        CALL ASSERT(.FALSE.)  
      ENDIF    
C
C --- CALCUL DES TERMES
C           
      IF (LSTAT.OR.LNEWMA) THEN
        CALL NMFEXT(ETA   ,FONACT,SDDYNA,VEASSE,CNFEXT)
      ELSEIF (LTHETV.OR.(LKRENK.AND.LVITE).OR.LTHETD
     & .OR.(LKRENK.AND.LDEPL)) THEN
        CALL NDTHET(FONACT,SDDYNA,FOINER,VEASSE,CNFINT,
     &              CNFEXT)
      ELSE
        CALL ASSERT(.FALSE.)  
      ENDIF      

C
      CALL JEDEMA()
      END
