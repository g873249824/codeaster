         SUBROUTINE CASURF(NDIM,NNO,GEOM,SURFF)
C
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/06/2010   AUTEUR GRANET S.GRANET 
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
C TOLE CRP_20
C TOLE CRP_21
C ======================================================================
C ROUTINE CASURF : CALCUL DE LA SURFACE DE L ELEMENT 2D
C GEOM CONTIENT LES COORDONN2ES DES NOEUDS

      IMPLICIT NONE
      INTEGER NDIM,NNO
      REAL*8 GEOM(1:NDIM,1:NNO)
C
      INTEGER      MAXFA1,MAXDI1
      PARAMETER    (MAXFA1=6,MAXDI1=3)       
C
      REAL*8  T(MAXDI1,MAXFA1)
      INTEGER INO,IFA,I,J,IDEB,IFIN
      REAL*8  VOL, PDVD2,PDVD1,SURFF


      DO 2 IFA=1,NNO
 
        IDEB=IFA
        IFIN=IFA+1
        IF(IFIN.GT.NNO) THEN
         IFIN=IFIN-NNO
        ENDIF
       DO 2 I=1,NDIM
        T(I,IFA)=GEOM(I,IFIN)-GEOM(I,IDEB)

    2 CONTINUE
 
      IF (NNO.EQ.3) THEN
          VOL=ABS(T(1,1)*T(2,2)-T(2,1)*T(1,2))/2.D0
      ELSE
           PDVD1 = T(1,1)*T(2,4)-T(2,1)*T(1,4)
           PDVD2 = T(1,3)*T(2,2)-T(2,3)*T(1,2)
           VOL=(ABS(PDVD1)+
     >        ABS(PDVD2))/2.D0
      ENDIF
      
      SURFF=VOL

      END
