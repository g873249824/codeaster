      SUBROUTINE DMAHSM(IND1,NB1,INTSR,XR,VECTN,VECTG,
     &                  VECTT,DVECTG,DVECTT,DHSFM,DHSS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/12/2007   AUTEUR DESROCHES X.DESROCHES 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NB1,INTE,INTSR
      REAL*8 XR(*),VECTN(9,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 DVECTG(2,3),DVECTT(3,3),DHSFM(3,9),DHSS(2,9)
C
C     IND1= 0     0 : CALCULS AUX PTS D'INTEGRATION REDUIT    
C
      CALL DVECT(IND1,NB1,INTSR,XR,VECTN,
     &            VECTG,VECTT,DVECTG,DVECTT)
C     IND2= 1  --->  CALCUL DE DHSS ( 0 SINON )
C
      IND2= 1
C
      CALL DHFMSS(IND2,VECTT,DVECTT,DHSFM,DHSS)
C
      END
