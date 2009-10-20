      SUBROUTINE NMRECH(FM    ,F     ,FOPT  ,FCVG  ,RHOMIN,
     &                  RHOMAX,RHOEXM,RHOEXP,RHOM  ,RHO   ,   
     &                  RHOOPT,LDCOPT,LDCCVG,OPT   ,ACT   ,
     &                  STITE )         
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/10/2009   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      REAL*8       RHOMIN,RHOMAX,RHOEXM,RHOEXP
      REAL*8       RHOM,RHO,RHOOPT
      REAL*8       FM, F, FOPT,FCVG
      LOGICAL      STITE
      INTEGER      LDCOPT,LDCCVG
      INTEGER      OPT,ACT
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE CORDE)
C
C RECHERCHE LINEAIRE AVEC LA METHODE CORDE
C      
C ----------------------------------------------------------------------
C
C
C
C I/O FM     : VALEUR PRECEDENTE DE LA FONCTIONNELLE
C IN  F      : VALEUR COURANTE DE LA FONCTIONNELLE
C I/O FOPT   : VALEUR OPTIMALE DE LA FONCTIONNELLE
C IN  FCVG   : VALEUR DONNANT LA VALEUR DE LA FONCTIONNELLE POUR QUE
C              L'ALGO CONVERGE
C I/O RHOM   : VALEUR PRECEDENTE DU COEF. RECH. LINE.
C IN  RHO    : VALEUR COURANTE DU COEF. RECH. LINE.
C I/O RHOOPT : VALEUR OPTIMALE DU COEF. RECH. LINE.
C IN  LDCCVG : CODE RETOUR INTEGRATION COMPORTEMENT
C OUT LDCOPT : CODE RETOUR INTEGRATION COMPORTEMENT QUAND COEF. RECH.
C              LINE. OPTIMAL
C I/O ACT    : INDICE DE LA SOLUTION (DEUX QUAND PILOTAGE)
C OUT OPT    : INDICE DE LA SOLUTION QUAND COEF. RECH.
C              LINE. OPTIMAL
C OUT STITE  : .TRUE. SI ALGO. A CONVERGE
C IN  RHOMIN : BORNE INFERIEURE DE RECHERCHE 
C IN  RHOMAX : BORNE SUPERIEURE DE RECHERCHE 
C IN  RHOEXM : INTERVALLE [RHOEXM,RHOEXP] POUR EXCLUSION 
C IN  RHOEXP : INTERVALLE [RHOEXM,RHOEXP] POUR EXCLUSION 

C
C ----------------------------------------------------------------------
C
      REAL*8       RHOTMP
      REAL*8       R8PREM
C
C ----------------------------------------------------------------------
C
      STITE = .FALSE.
C      PRISE EN COMPTE D'UN RESIDU OPTIMAL SI NECESSAIRE
      IF (ABS(F) .LT. FOPT) THEN
        RHOOPT = RHO
        LDCOPT = LDCCVG
        FOPT   = ABS(F)
        OPT    = ACT
        ACT    = 3 - ACT
        IF (ABS(F) .LT. FCVG) THEN
          STITE = .TRUE.
          GOTO 100
        ENDIF  
      END IF


C -- CALCUL DE RHO(N+1) PAR METHODE DE SECANTE AVEC BORNES

      RHOTMP = RHO
      IF (ABS(F-FM).GT.R8PREM()) THEN
        RHO  = (F*RHOM-FM*RHO)/(F-FM)
        CALL ZBINTE(RHO   ,RHOMIN,RHOMAX,RHOEXM,RHOEXP)
      ELSE IF (F*(RHO-RHOM)*(F-FM) .LE. 0.D0) THEN
        RHO = RHOMAX
      ELSE
        RHO = RHOMIN
      END IF
      RHOM   = RHOTMP
      FM     = F
        
 100  CONTINUE       
         
      END
