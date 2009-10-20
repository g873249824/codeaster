      SUBROUTINE ZBOPTI(RHO   ,F     ,RHOOPT,FOPT  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/10/2009   AUTEUR ABBAS M.ABBAS 
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
      REAL*8   RHO,F,RHOOPT,FOPT
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
C
C REACTUALISATION DE LA SOLUTION OPTIMALE
C      
C ----------------------------------------------------------------------
C 
C IN  RHO    : SOLUTION COURANTE
C IN  F      : VALEUR DE LA FONCTION EN RHO
C OUT RHOOPT : SOLUTION OPTIMALE
C I/O FOPT   : VALEUR DE LA FONCTION EN RHOOPT
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
C ----------------------------------------------------------------------
C        
       IF (ABS(F).LT.ABS(FOPT)) THEN
         RHOOPT = RHO
         FOPT   = F
         LOPTI  = .TRUE.
       END IF

       END 
