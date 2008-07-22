      FUNCTION DSPDP1(NET,BISHOP,SIGNE,BIOT,SAT)
      IMPLICIT      NONE
      REAL*8        SIGNE,BIOT,SAT,DSPDP1
      LOGICAL NET,BISHOP
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/07/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C --- CALCUL DE LA DERIVEE DE LA CONTRAINTE DE PRESSION PAR RAPPORT ----
C --- A LA PRESSION CAPILLAIRE -----------------------------------------
C ======================================================================
      IF(BISHOP) THEN
       DSPDP1 = SIGNE*BIOT*SAT
      ELSE IF(NET) THEN
       DSPDP1 = 0.D0
      ELSE
       CALL U2MESS('F','ALGORITH17_4')
      ENDIF
C ======================================================================
      END
