      SUBROUTINE TILBAR ( STILD , VECTT , BARS )
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
      REAL * 8 STILD  ( 5 )
      REAL * 8 VECTT ( 3 , 3 )
      REAL * 8 BARS ( 9 , 9 )
C
      REAL * 8 BID33 ( 3 , 3 )
C
      REAL * 8 STIL  ( 3 , 3 )
C
C
      REAL * 8     S     ( 3 , 3 )
C
CDEB
C
C---- TENSEUR 3 * 3 CONTRAINTES LOCALES 
C
      CALL SIGVTE ( STILD , STIL )
C
C---- ROTATION DU TENSEUR CONTRAINTES : LOCALES --> GLOBALES
C
C              S     =  ( VECTT ) T * STIL  * VECTT
C
      CALL BTKB ( 3 , 3 , 3 , STIL , VECTT , BID33 , S )
C
C---- BARS   ( 9 , 9 )
C
      CALL SIGBAR ( S , BARS )
C
C
C FIN
C
      END
