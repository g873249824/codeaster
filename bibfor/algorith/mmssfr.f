      SUBROUTINE MMSSFR(DEFICO,IZONE ,POSMAE,NDEXFR)
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
      CHARACTER*24 DEFICO
      INTEGER      POSMAE
      INTEGER      NDEXFR,IZONE 
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT - UTILITAIRE)
C
C INDICATEUR QU'UNE MAILLE ESCLAVE CONTIENT DES NOEUDS 
C EXCLUS PAR SANS_GROUP_NO_FR
C      
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
C IN  IZONE  : NUMEOR DE LA ZONE DE CONTACT
C IN  POSMAE : NUMERO DE LA MAILLE ESCLAVE
C OUT NDEXFR : ENTIER CODE DES NOEUDS EXCLUS
C
C
C
C
      INTEGER      NUMNO
      INTEGER      NNOMAI,POSNNO(9),NUMNNO(9)
      INTEGER      SUPPOK,INO
      INTEGER      CFDISI,NDIMG,MMINFI,NDIREX
      INTEGER      NDEXCL(10),NBEXFR
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
C
C --- INITIALISATIONS 
C
      NBEXFR = 0
      NDEXFR = 0
      DO 10 INO = 1,10
        NDEXCL(INO) = 0
 10   CONTINUE     
C
C --- NUMEROS DES NOEUDS DE LA MAILLE DANS SD CONTACT   
C    
      CALL CFPOSN(DEFICO,POSMAE,POSNNO,NNOMAI)
      CALL CFNUMN(DEFICO,NNOMAI,POSNNO,NUMNNO)
      CALL ASSERT(NNOMAI.LE.9)      
C     
C --- REPERAGE SI LE NOEUD EST UN NOEUD A EXCLURE 
C
      DO 50 INO = 1,NNOMAI
        NUMNO  = NUMNNO(INO) 
        CALL CFMMEX(DEFICO,'FROT',IZONE ,NUMNO ,SUPPOK)
        IF (SUPPOK .EQ. 1) THEN
          NBEXFR  = NBEXFR + 1
          NDEXCL(INO) = 1
        ELSE
          NDEXCL(INO) = 0  
        ENDIF
 50   CONTINUE 
C
C --- CODAGE
C
      IF (NBEXFR.NE.0) THEN
C
C ----- NOMBRE DE DIRECTIONS A EXCLURE
C
        NDIMG  = CFDISI(DEFICO,'NDIM')
        NDIREX = MMINFI(DEFICO,'EXCL_DIR',IZONE)
        IF (NDIMG.EQ.2) THEN
          IF (NDIREX.GT.0) THEN
            NDEXCL(10) = 1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (NDIMG.EQ.3) THEN
          IF (NDIREX.EQ.1) THEN
            NDEXCL(10) = 0
          ELSEIF (NDIREX.EQ.2) THEN
            NDEXCL(10) = 1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL ISCODE(NDEXCL,NDEXFR,10    )
      ENDIF
C
      CALL JEDEMA()      
      END
