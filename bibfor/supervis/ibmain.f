      SUBROUTINE IBMAIN( LLDBG )
      IMPLICIT NONE
      LOGICAL             LLDBG
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 23/11/2010   AUTEUR COURTOIS M.COURTOIS 
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
C TOLE CRP_7
C     ENSEMBLE DES INITIALISATIONS POUR L'EXECUTION D'UN JOB
C     ------------------------------------------------------------------
C     ROUTINE(S) UTILISEE(S) :
C         LXINIT  LXUNIT  LXDELI
C         IB0MAI  
C     ------------------------------------------------------------------
C     ------- COMMUN DEBUG SUPERVISEUR ---------------------------------
      LOGICAL         LDBG
      INTEGER         IFV
      COMMON /CXSU00/ LDBG , IFV
C     ------------------------------------------------------------------
      EXTERNAL LXDELI
C     ------------------------------------------------------------------
C     DEFINITION DES UNITES DE LECTURE/ECRITURE COMMANDE UTILISATEUR
      INTEGER    IRDUSR,    LRECL
      PARAMETER (IRDUSR=1 , LRECL=80)
C     ------------------------------------------------------------------
      CHARACTER*8 CMDUSR
      INTEGER     ISSUIV, ISUI
C
      CMDUSR = 'CMD   01'
C
      LDBG=LLDBG
C     --- BUFFERISATION EN CAS DE SUIVI INTERACTIF
      ISUI=-1
      IF ( ISSUIV(ISUI) .GT. 0) THEN
          CALL FASTER()
      ENDIF
C
C     --- INITIALISATION DE L'ANALYSEUR LEXICAL ET DE L'UNITE DE LECTURE
      CALL LXINIT( LXDELI )
      CALL LXUNIT( IRDUSR, LRECL, 0, CMDUSR )
C
C     --- INITIALISATION DE L"INTERCEPTION DE CERTAINS SIGNAUX    
      CALL INISIG()

C     --- INITIALISATION DE JEVEUX   ---
      CALL IB0MAI()
C
      END
