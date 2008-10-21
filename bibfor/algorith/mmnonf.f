        SUBROUTINE  MMNONF(NDIM  ,NNO   ,ALIAS  ,KSI1  ,KSI2  ,
     &                     FF    ) 
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/10/2008   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      REAL*8      FF(9)
      INTEGER     NNO,NDIM   
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
C
C CALCUL DES FONCTIONS DE FORME EN UN POINT DE L'ELEMENT DE REFERENCE
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
C OUT FF     : FONCTIONS DE FORMES EN XI,YI
C
C ----------------------------------------------------------------------
C
      INTEGER     IBID,I
      REAL*8      KSI(2)
      CHARACTER*8 ELREFE
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      DO 10 I  = 1,9
        FF(I)     = 0.D0      
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
C --- RECUP FONCTIONS DE FORME 
C
      CALL ELRFVF(ELREFE,KSI,NNO   ,FF    ,IBID)

      END
