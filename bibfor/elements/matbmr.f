      SUBROUTINE MATBMR ( NB1   , VECTT , DUDXRI , INTSR , JDN1RI ,
     &                    B1MRI , B2MRI  )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/01/99   AUTEUR D6BHHMA M.ALMIKDAD 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
C
      INTEGER I , J
C
      INTEGER NB1 
C
      INTEGER INTSR
C
      REAL * 8 VECTT  ( 3 , 3 ) 
C
      REAL * 8 DUDXRI ( 9 )
C
      REAL * 8 JDN1RI ( 9 , 51 )
C
      REAL * 8 B1MRI  ( 3 , 51 , 4 ) 
      REAL * 8 B2MRI  ( 3 , 51 , 4 ) 
C
      REAL * 8 TMP  ( 3 , 51 )
C
      REAL * 8 HSM1 ( 3 , 9 )
C
      REAL * 8 HSM2 ( 3 , 9 )
C
CDEB
C
      CALL HSAME ( VECTT , DUDXRI , HSM1 , HSM2 )
C
C --- POUR LA DEFORMATION TOTALE   B1MRI
C
      CALL PROMAT ( HSM1   , 3 , 3 , 9           ,
     &              JDN1RI , 9 , 9 , 6 * NB1 + 3 ,
     &              TMP  )
C
C
      DO 100 J = 1 , 6 * NB1 + 3
         DO 110 I = 1 , 3
C
            B1MRI ( I , J , INTSR ) = TMP ( I , J )
C
 110     CONTINUE
 100  CONTINUE
C
C
C---- POUR LA DEFORMATION DIFFERENTIELLE   B2MRI
C
C---- INITIALISATION
C
C
      CALL R8INIR ( 3 * 51 , 0.D0 , TMP , 1 )
C
C
C
C
      CALL PROMAT ( HSM2   , 3 , 3 , 9           ,
     &              JDN1RI , 9 , 9 , 6 * NB1 + 3 ,
     &              TMP  )
C
C
      DO 200 J = 1 , 6 * NB1 + 3
         DO 210 I = 1 , 3
C
            B2MRI ( I , J , INTSR ) = TMP ( I , J )
C
 210     CONTINUE
 200  CONTINUE
C
C
CFIN
C
      END
