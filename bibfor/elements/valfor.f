      SUBROUTINE VALFOR ( INDN , INDC , LT1 , LT2 , L1 , L2 , L3 ) 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 10/11/98   AUTEUR D6BHHMA M.ALMIKDAD 
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
C
C ......................................................................
C     FONCTION :  CALCUL DES POINTEURS DES FONCTIONS DE FORMES 
C
C                 LT1 LT2   : TRANSLATION
C                 L1 L2 L3  : ROTATION
C
C                 SELON INTEGRATION
C
C ......................................................................
C
C
C
      IMPLICIT NONE
C
      INTEGER INDN , INDC
C
      INTEGER LT1 , LT2
C
      INTEGER L1 , L2 , L3
C
CDEB
C
C
C---- LES ADRESSES DES FONCTIONS DE FORME ET DE LEURS DERIVEES 
C     SELON INDN ( VOIR ROUTINE BTDFN )
C
C
C
C------- NOEUDS DE SERENDIP POUR LA TRANSLATION
C
C            D N ( 1 ) D QSI 1      LT1 POUR  I1
C            D N ( 1 ) D QSI 2      LT2 POUR  I2
C
C------- NOEUDS DE LAGRANGE POUR LA ROTATION
C
C              N ( 2 )              L1  POUR  I3
C            D N ( 2 ) D QSI 1      L2  POUR  I4
C            D N ( 2 ) D QSI 2      L3  POUR  I5
C
C
      IF      ( INDN . EQ . 1 ) THEN
C
C------- INDN =  1 INTEGRATION NORMALE 
C
C        VOIR ROUTINE INI080 ET VECTGT 
C
         LT1 = 207
         LT2 = 279
C
C        VOIR ROUTINE BTDFN 
C
         L1  = 459
         L2  = 540
         L3  = 621
C
      ELSE IF ( INDN . EQ . 0 ) THEN
C
C------- INDN =  0 INTEGRATION REDUITE 
C
C        VOIR ROUTINE BTDMSR 
C
         LT1 = 44
         LT2 = 76
C
         L1  = 351
         L2  = 387
         L3  = 423
C
       ELSE
C
        CALL UTMESS('F','JM1DN1',
     &  'INDN = 1 (INTEGRATION NORMALE) OU
     &   INDN = 0 (INTEGRATION REDUITE) OBLIGATOIREMENT.')
C
      ENDIF
C
CFIN
C
      END
