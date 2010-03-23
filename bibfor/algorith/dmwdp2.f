      FUNCTION DMWDP2(RHO11,SAT,BIOT,PHI,CS,CLIQ,DP11P2,EMMAG,EM)
      IMPLICIT NONE
      REAL*8        RHO11,SAT,BIOT,PHI,CS,CLIQ,DP11P2,DMWDP2
      REAL*8        EM
      REAL*8        DPHIP2
      LOGICAL       EMMAG        
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/03/2010   AUTEUR ANGELINI O.ANGELINI 
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
C --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L EAU PAR RAPPORT ---
C --- A LA PRESSION DE GAZ ---------------------------------------------
C ======================================================================
      IF(EMMAG) THEN   
       DPHIP2 = EM
       DMWDP2 = RHO11 *(PHI*DPHIP2+PHI*CLIQ*DP11P2)
      ELSE
       DMWDP2 = RHO11*SAT*(PHI*CLIQ*DP11P2+(BIOT-PHI)*CS)
      ENDIF
C ======================================================================
      END
