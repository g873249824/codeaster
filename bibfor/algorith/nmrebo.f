      SUBROUTINE NMREBO(F     ,MEM   ,SENS  ,RHO   ,RHOOPT,
     &                  LDCOPT,LDCCVG,FOPT  ,FCVG  ,OPT   ,
     &                  ACT   ,RHOMIN,RHOMAX,RHOEXM,RHOEXP,
     &                  STITE ,ECHEC)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/03/2010   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      REAL*8       MEM(2,*),SENS
      REAL*8       RHO,RHOOPT
      LOGICAL      ECHEC,STITE
      INTEGER      LDCOPT,LDCCVG
      REAL*8       F,FOPT,FCVG 
      INTEGER      OPT,ACT
      REAL*8       RHOMIN,RHOMAX,RHOEXM,RHOEXP
              
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
C
C RECHERCHE LINEAIRE AVEC LA METHODE MIXTE: BORNES + UNIDIRECTIONNEL
C      
C ----------------------------------------------------------------------
C
C
C  IN  RHO    : SOLUTION COURANTE
C  IN  F      : VALEUR DE LA FONCTION EN RHO
C  I/O MEM    : COUPLES (RHO,F) ARCHIVES - GESTION INTERNE PAR ZEITER
C  I/O RHOOPT : VALEUR OPTIMALE DU RHO 
C  I/O FOPT   : VALEUR OPTIMALE DE LA FONCTIONNELLE
C  OUT RHONEW : NOUVEL ITERE
C  OUT ECHEC  : .TRUE. SI LA RECHERCHE A ECHOUE
C      
C ----------------------------------------------------------------------
C
      REAL*8  RHONEG,RHOPOS 
      REAL*8  PARMUL,FNEG  ,FPOS  
      INTEGER DIMCPL,NBCPL
      LOGICAL BPOS  ,LOPTI
      COMMON /ZBPAR/ RHONEG,RHOPOS,
     &               PARMUL,FNEG  ,FPOS  ,
     &               DIMCPL,NBCPL ,BPOS  ,LOPTI
C     
      REAL*8  RHONEW
C      
C ----------------------------------------------------------------------
C
      STITE = .FALSE.
      ECHEC = .FALSE.
      CALL ZBITER(SENS*RHO,SENS*F,RHOOPT,FOPT  ,MEM   ,
     &            RHONEW,ECHEC )
C
C --- GESTION DES BORNES
C
      CALL ZBINTE(RHONEW,RHOMIN,RHOMAX,RHOEXM,RHOEXP)  
      CALL ZBINTE(RHOOPT,RHOMIN,RHOMAX,RHOEXM,RHOEXP)
C      
C --- PRISE EN COMPTE D'UN RESIDU OPTIMAL SI NECESSAIRE
C
      IF (LOPTI) THEN
        LDCOPT = LDCCVG
        OPT    = ACT
        ACT    = 3 - ACT
        IF (ABS(FOPT) .LT. FCVG) THEN
          STITE = .TRUE.
        ENDIF
      ENDIF
C
      RHO    = RHONEW * SENS
   
      END
