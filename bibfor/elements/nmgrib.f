      SUBROUTINE NMGRIB(NNO,GEOM,DFF,DIR11,B,JAC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/03/2004   AUTEUR PBADEL P.BADEL 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER NNO
      REAL*8  GEOM(3,NNO),DFF(2,NNO),DIR11(3)
      REAL*8  B(3,NNO)
      
C ----------------------------------------------------------------------
C CALCUL DE LA MATRICE B ET JACOBIEN POUR LES GRILLES SECONDE GENERATION
C ----------------------------------------------------------------------

      INTEGER I,J,N,ALPHA,BETA,GAMMA
      REAL*8 COVA(3,3),METR(2,2),JAC,CNVA(3,2),A(2,2),R1(3),PROJN
      

      CALL SUBACO(NNO,DFF,GEOM,COVA)
      CALL SUMETR(COVA,METR,JAC)
      CALL SUBACV(COVA,METR,JAC,CNVA,A)
      
      CALL R8INIR(3,0.D0,R1,1)
      CALL R8INIR(3*NNO,0.D0,B,1)
      
      PROJN = 0.D0
      
      DO 5 J=1,3
        DO 6 I=1,2
          R1(I) = R1(I)+COVA(J,I)*DIR11(J)
6       CONTINUE
        PROJN = PROJN + COVA(J,3) * DIR11(J)
5     CONTINUE

            

      DO 10 I=1,3
        DO 10 N=1,NNO
          DO 10 ALPHA=1,2
            DO 10 BETA=1,2
              DO 10 GAMMA=1,2
                B(I,N)=B(I,N)+R1(ALPHA)*R1(GAMMA)*A(BETA,GAMMA)*
     &             DFF(BETA,N)*CNVA(I,ALPHA)/(1-PROJN**2)
10    CONTINUE

      END
