      SUBROUTINE ZBPROJ(RHO,ECHEC)
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
      REAL*8   RHO
      LOGICAL  ECHEC
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
C
C PROJECTION DE LA SOLUTION SUR LES BORNES ADMISSIBLES 
C REACTUALISATION DES BORNES ADMISSIBLES
C      
C ----------------------------------------------------------------------
C 
C  I/O RHO      : SOLUTION COURANTE
C  OUT ECHEC : .TRUE. SI LA RECHERCHE DE RACINE A ECHOUE
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
C
C --- BORNE MIN
C       
      IF (RHO.LT.RHONEG) THEN
        IF (BPOS) THEN
          RHO   = (RHONEG+RHOPOS)/2
        ELSE
          ECHEC = .TRUE.
        ENDIF
      ENDIF
C
C --- BORNE MAX
C       
      IF (BPOS) THEN
        IF (RHO.GT.RHOPOS) THEN
          RHO = (RHONEG+RHOPOS)/2
        ENDIF
      ENDIF
C
      END 
