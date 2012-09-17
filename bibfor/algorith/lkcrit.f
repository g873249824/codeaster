      FUNCTION LKCRIT(AMAT,MMAT,SMAT,GAMCJS,SIGC,H0EXT,RCOS3T,
     +                INVAR,SII)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/09/2012   AUTEUR FOUCAULT A.FOUCAULT 
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
      IMPLICIT NONE
      INTEGER  DIMPAR
      REAL*8   LKCRIT,AMAT,MMAT,SMAT,GAMCJS,SIGC,H0EXT,RCOS3T,INVAR
      REAL*8   SII
C =================================================================
C --- FONCTION ADAPTEE AU POST-TRAITEMENT DE LA LOI LETK, QUI -----
C --- CALCULE LA POSITION D'UN ETAT DE CONTRAINTE PAR -------------
C --- RAPPORT A UN SEUIL VISCOPLASTIQUE ---------------------------
C =================================================================
      REAL*8   UN,DEUX,TROIS,SIX,KSEUIL,H0C,H0E,ASEUIL,BSEUIL
      REAL*8   DSEUIL,FACT1,FACT2,FACT3,LKHLOD,UCRIT,HTHETA,HLODE
      PARAMETER( UN     =  1.0D0   )
      PARAMETER( DEUX   =  2.0D0   )
      PARAMETER( TROIS  =  3.0D0   )
      PARAMETER( SIX    =  6.0D0   )
C =================================================================
C --- CALCUL DES CRITERES D'ECROUISSAGE ---------------------------
C =================================================================
      KSEUIL = (DEUX/TROIS)**(UN/DEUX/AMAT)
      H0C    = (UN - GAMCJS)**(UN/SIX)
      H0E    = (UN + GAMCJS)**(UN/SIX)
      ASEUIL = - MMAT * KSEUIL/SQRT(SIX)/SIGC/H0C
      BSEUIL = MMAT * KSEUIL/TROIS/SIGC
      DSEUIL = SMAT * KSEUIL
C =================================================================
      FACT1  = (H0C + H0EXT)/DEUX
      FACT2  = (H0C - H0EXT)/DEUX
      HLODE  =  LKHLOD(GAMCJS,RCOS3T)
      FACT3  = (DEUX*HLODE-(H0C+H0E))/(H0C-H0E) 
      HTHETA =  FACT1+FACT2*FACT3
C =================================================================
      UCRIT  = ASEUIL*SII*HTHETA + BSEUIL*INVAR+DSEUIL
      IF (UCRIT .LT. 0.0D0) THEN
         UCRIT=0.0D0
         PRINT *, '<LKCRIT> UCRIT NON DEFINI'
      ENDIF
      LKCRIT = SII*HTHETA - SIGC*H0C*(UCRIT)**AMAT
      END
