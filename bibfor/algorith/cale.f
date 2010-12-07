      SUBROUTINE CALE(NDIM,FD,ID,FDM,FDMT,PRODF,EDPN1)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER NDIM,I,J
      REAL*8 FD(3,3),DET
      
C ----------------------------------------------------------------
C   NDIM    : DIMENSION DE L'ESPACE
C   FD      : TENSEUR DE DEFORMATION ENTRE CONFIGURATION T- ET T+ 
C   ID     :  MATRICE IDENTITE DE DIMENSION 3 

C   SORTIE:
C   FDM     : INVERSE DU TENSEUR DEFORMATION ENTRE CONFIG T- ET T+ 
C   FDMT    : TRANSPOSEE DE INVERSE DU TENSEUR DE DEFORMATION 
C             ENTRE CONFIGURATION T- ET T+ 
C   PRODF   : TENSEUR PRODUIT ENTRE FDMT ET FDM 
C   EDPN1   : 
 
C-----------------------------------------------------------------
C
C       CALCUL DE EDPN1
C
C-----------------------------------------------------------------
      REAL*8 ID(3,3),FDM(3,3)
      REAL*8 FDMT(3,3),PRODF(3,3)
      REAL*8 EDPN1(3,3)  
      
C----------------------INTIALISATION DES MATRICES ----------------
      CALL R8INIR(9,0.D0,FDM,1)
      CALL R8INIR(9,0.D0,FDMT,1)
      CALL R8INIR(9,0.D0,PRODF,1)
      CALL R8INIR(9,0.D0,EDPN1,1)

C--------------------------------CALCUL DE e_(n+1)----------------

C      CALCUL DE L'INVERSE DE FD = FDM : SUBROUTINE INVERSE
       CALL MATINV('S',3,FD,FDM,DET)
        
C      CALCUL DE LA MATRICE TRANSPOSEE DE L'INVERSE DE FD : 
C      SUBROUTINE TRANSPOSEE
       CALL LCTR2M(3,FDM,FDMT)
C       DO 70 I = 1,3
C       DO 80 J = 1,3
C        FDMT(I,J) = FDM(J,I)
C 80     CONTINUE
C 70    CONTINUE 
 
       CALL PMAT(3,FDMT,FDM,PRODF)

C      CALCUL DE e_(N+1)
       DO 75 I = 1,3
        DO 85 J = 1,3
         EDPN1(I,J) = 0.5D0*(ID(I,J)-PRODF(I,J))
 85     CONTINUE
 75    CONTINUE 
       END  
