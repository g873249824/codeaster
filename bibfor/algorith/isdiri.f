      LOGICAL FUNCTION ISDIRI(LISCHA,SOUTYP)     
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
      CHARACTER*19  LISCHA
      CHARACTER*4   SOUTYP
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C DIT SI ON A DES CHARGEMENTS DE TYPE DIRICHLET
C      
C ----------------------------------------------------------------------
C
C
C IN  LISCHA : SD L_CHARGES
C IN  SOUTYP : TYPE DE CHARGE
C                'DUAL' - PAR DUALISATION (AFFE_CHAR_MECA)
C                'ELIM' - PAR ELIMINATION (AFFE_CHAR_CINE)
C                'TOUT' - PAR DUALISATION ET ELIMINATION
C
C
C
C
      INTEGER      ICHAR
      LOGICAL      LELIM,LDUAL,ISCHAR         
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C      
      ICHAR  = 0
      LELIM  = ISCHAR(LISCHA,'DIRI','ELIM',ICHAR )
      LDUAL  = ISCHAR(LISCHA,'DIRI','DUAL',ICHAR )
      IF (SOUTYP.EQ.'TOUT') THEN
        ISDIRI = LELIM.OR.LDUAL
      ELSEIF (SOUTYP.EQ.'ELIM') THEN
        ISDIRI = LELIM  
      ELSEIF (SOUTYP.EQ.'DUAL') THEN
        ISDIRI = LDUAL
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF             
C
      CALL JEDEMA()
      END
