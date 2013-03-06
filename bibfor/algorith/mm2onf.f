        SUBROUTINE  MM2ONF(NDIM  ,NNO   ,ALIAS  ,KSI1  ,KSI2  ,
     &                     DDFF   ) 
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/03/2013   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8 ALIAS 
      REAL*8      KSI1,KSI2   
      REAL*8      DDFF(3,9)
      INTEGER     NNO,NDIM   
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
C
C CALCUL DES DERIVEES SECONDES DES FONCTIONS DE FORME EN UN POINT 
C DE L'ELEMENT DE REFERENCE
C      
C ----------------------------------------------------------------------
C
C IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
C IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT
C IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
C IN  KSI1   : POINT DE CONTACT SUIVANT KSI1 DES
C               FONCTIONS DE FORME ET LEURS DERIVEES
C IN  KSI2   : POINT DE CONTACT SUIVANT KSI2 DES
C               FONCTIONS DE FORME ET LEURS DERIVEES
C OUT DDFF   : DERIVEES SECONDES DES FONCTIONS DE FORME EN XI YI
C
C ----------------------------------------------------------------------
C
      INTEGER     IBID1,IBID2,I
      REAL*8      KSI(2)
      REAL*8      D2FF(3,3,9)
      CHARACTER*8 ELREFE
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      DO 10 I  = 1,9
        DDFF(1,I) = 0.D0
        DDFF(2,I) = 0.D0
        DDFF(3,I) = 0.D0      
        D2FF(1,1,I) = 0.D0
        D2FF(1,2,I) = 0.D0
        D2FF(1,3,I) = 0.D0
        D2FF(2,1,I) = 0.D0
        D2FF(2,2,I) = 0.D0
        D2FF(2,3,I) = 0.D0
        D2FF(3,1,I) = 0.D0 
        D2FF(3,2,I) = 0.D0 
        D2FF(3,3,I) = 0.D0          
 10   CONTINUE
C     
      KSI(1) = KSI1
      KSI(2) = KSI2
C
      ELREFE = ALIAS
C
      IF ((NNO.LT.1).OR.(NNO.GT.9)) THEN
        CALL ASSERT(.FALSE.)
      ENDIF 
C
      IF ((NDIM.LT.1).OR.(NDIM.GT.3)) THEN
        CALL ASSERT(.FALSE.)
      ENDIF                  
C
C --- RECUP DERIVEES SECONDES DES FONCTIONS DE FORME
C
      CALL ELRFD2(ELREFE,KSI,NNO*NDIM*NDIM,D2FF,IBID1,IBID2)          
C
C --- CONVERSION XI-YI/YI-XI -> KSI1-KSI2 
C 
      DO 16 I = 1,NNO
        DDFF(1,I) = D2FF(1,1,I)
        DDFF(2,I) = D2FF(2,2,I)  
        DDFF(3,I) = D2FF(1,2,I)               
  16  CONTINUE 
 
      END
