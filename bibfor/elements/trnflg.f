      SUBROUTINE TRNFLG (NBX,VECTPT,VECL,VECG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
      IMPLICIT NONE
C
      INTEGER NBX
      REAL*8 VECL(*),VECG(*),VECTPT(9,3,3)
C
C     CONSTRUCTION DE LA MATRICE VECG = PLGT * VECL
C
C-----------------------------------------------------------------------
      INTEGER I1 ,IB 
C-----------------------------------------------------------------------
      DO 10 IB=1,NBX
C
         I1=6*(IB-1)
C
C     LES TERMES DE FORCE
C
      IF (IB.LE.NBX-1) THEN
         VECG(I1+1)=VECL(I1+1)
         VECG(I1+2)=VECL(I1+2)
         VECG(I1+3)=VECL(I1+3)
C
C     LES TERMES DE MOMENT = TPI * MLOCAL  (  TPI = TI  )
C    
         VECG(I1+4)=VECTPT(IB,1,1)*VECL(I1+4)+VECTPT(IB,2,1)*VECL(I1+5)
     &                                       +VECTPT(IB,3,1)*VECL(I1+6)
         VECG(I1+5)=VECTPT(IB,1,2)*VECL(I1+4)+VECTPT(IB,2,2)*VECL(I1+5)
     &                                       +VECTPT(IB,3,2)*VECL(I1+6)
         VECG(I1+6)=VECTPT(IB,1,3)*VECL(I1+4)+VECTPT(IB,2,3)*VECL(I1+5)
     &                                       +VECTPT(IB,3,3)*VECL(I1+6)
      ELSE
         VECG(I1+1)=VECTPT(IB,1,1)*VECL(I1+1)+VECTPT(IB,2,1)*VECL(I1+2)
     &                                       +VECTPT(IB,3,1)*VECL(I1+3)
         VECG(I1+2)=VECTPT(IB,1,2)*VECL(I1+1)+VECTPT(IB,2,2)*VECL(I1+2)
     &                                       +VECTPT(IB,3,2)*VECL(I1+3)
         VECG(I1+3)=VECTPT(IB,1,3)*VECL(I1+1)+VECTPT(IB,2,3)*VECL(I1+2)
     &                                       +VECTPT(IB,3,3)*VECL(I1+3)
      ENDIF
 10   CONTINUE
C
      END
