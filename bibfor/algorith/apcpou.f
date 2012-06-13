      SUBROUTINE APCPOU(SDAPPA,IZONE ,NOMMAI,TYPZON,TAU1  ,
     &                  TAU2  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19  SDAPPA
      CHARACTER*4   TYPZON
      INTEGER       IZONE
      REAL*8        TAU1(3),TAU2(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C ORIENTATION DES TANGENTES DANS LE CAS DES POUTRES
C      
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  IZONE  : NUMERO DE LA ZONE
C IN  NOMMAI : NOM DE LA MAILLE
C IN  TYPZON : TYPE DE LA ZONE 'MAIT' OU 'ESCL'
C OUT TAU1   : PREMIERE TANGENTE (NON NORMALISEE)
C OUT TAU2   : SECONDE TANGENTE (NON NORMALISEE)
C
C
C
C
      INTEGER      ITYPE
      CHARACTER*8  NOMMAI 
      REAL*8       VECTOR(3),NORME
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- TYPE DE NORMALE
C
      IF (TYPZON.EQ.'ESCL') THEN
        CALL APZONI(SDAPPA,IZONE ,'TYPE_NORM_ESCL',ITYPE )
        CALL APZONV(SDAPPA,IZONE ,'VECT_ESCL'     ,VECTOR)
      ELSEIF (TYPZON.EQ.'MAIT') THEN
        CALL APZONI(SDAPPA,IZONE ,'TYPE_NORM_MAIT',ITYPE )
        CALL APZONV(SDAPPA,IZONE ,'VECT_MAIT'     ,VECTOR)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- REDEFINITION SI BASE LOCALE DANS LE CAS DES POUTRES
C
      IF (ITYPE.EQ.0) THEN              
        CALL U2MESK('F','APPARIEMENT_61',1,NOMMAI)
      ELSEIF (ITYPE.EQ.1) THEN
        CALL NORMEV(VECTOR,NORME)
        CALL PROVEC(VECTOR,TAU1,TAU2)   
      ELSEIF (ITYPE.EQ.2) THEN
        CALL NORMEV(VECTOR,NORME)
        CALL DCOPY(3,VECTOR,1,TAU2,1)        
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF  
C
      CALL JEDEMA()
      END
