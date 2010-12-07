      SUBROUTINE DPLADG(YATE,RHO11,RHO12,R,T,KH,CONGEM,DIMCON,ADCP11,
     &                  NDIM,PADP,DP11P1,DP11P2,
     &                  DP21P1,DP21P2,DP11T,DP21T)
      IMPLICIT NONE
      INTEGER       YATE,ADCP11,NDIM,DIMCON
      REAL*8        RHO11,RHO12,R,T,KH,CONGEM(DIMCON),PADP
      REAL*8        DP11P1,DP11P2,DP21P1,DP21P2
      REAL*8        DP11T,DP21T
      REAL*8        ZERO
      PARAMETER ( ZERO=0.D0)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/03/2010   AUTEUR ANGELINI O.ANGELINI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C ======================================================================
C --- CALCUL DES DERIVEES PARTIELLES DES PRESSIONS ---------------------
C --- UNIQUEMENT DANS LE CAS LIQU_AD_GAZ --------------------------
C ======================================================================
      REAL*8        L
      DP11P1 = 1.D0/((RHO12*R*T/RHO11/KH)-1.D0)
      DP11P2 = (R*T/KH - 1.D0)/((RHO12*R*T/RHO11/KH)-1.D0)
      DP21P1 = ZERO
      DP21P2 = 1.D0 
CC      DP22P1 = -1- DP11P1
CC      DP22P2 = 1- DP11P2
      IF ((YATE.EQ.1.D0)) THEN
         L = -CONGEM(ADCP11+NDIM+1)
         DP11T = (-L*R*RHO12/KH+PADP/T)/((RHO12*R*T/RHO11/KH)-1.D0)
         DP21T =  ZERO
CC         DP22T =  - DP11T
      ENDIF
C ======================================================================
      END
