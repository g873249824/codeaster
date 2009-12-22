      SUBROUTINE CFECRD(RESOCO,QUESTZ,IVAL  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS

      IMPLICIT NONE
      CHARACTER*24  RESOCO
      CHARACTER*(*) QUESTZ
      INTEGER       IVAL
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
C
C ECRIRE INFORMATIONS SUR L'ETAT DU CONTACT ACTUEL
C
C ----------------------------------------------------------------------
C
C 
C IN  RESOCO  : SD DE RESOLUTION DU CONTACT
C IN  QUESTI  : VALEUR A LIRE/ECRIRE
C   NDIM   : DIMENSION 
C   INDIC  : INDIC VAUT 1 LORSQU'ON AJOUTE UNE LIAISON 
C                  VAUT 0 LORSQU'ON SUPPRIME UNE LIAISON 
C   NBLIAC : NOMBRE DE LIAISON DE CONTACT 
C   AJLIAI : POSITION DE LA LIAISON AJOUTEE 
C   SPLIAI : POSITION DE LA LIAISON SUPPRIMEE 
C   LLF    : NOMBRE DE LIAISON DE FROTTEMENT (DEUX DIRECTIONS) 
C   LLF1   : NOMBRE DE LIAISON DE FROTTEMENT (1ERE DIRECTION ) 
C   LLF2   : NOMBRE DE LIAISON DE FROTTEMENT (2EME DIRECTION ) 
C IN  IVAL    : VALEUR 
C
C --------------- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*24 QUESTI
      CHARACTER*19 COCO
      INTEGER      JCOCO   
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      QUESTI = QUESTZ  
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C     
      COCO     = RESOCO(1:14)//'.COCO'
      CALL JEVEUO(COCO,'E',JCOCO)
C   
      IF (QUESTI.EQ.'NDIM') THEN
        ZI(JCOCO+0) = IVAL
      ELSEIF (QUESTI.EQ.'INDIC') THEN
        ZI(JCOCO+1) = IVAL        
      ELSEIF (QUESTI.EQ.'NBLIAC') THEN
        ZI(JCOCO+2) = IVAL
      ELSEIF (QUESTI.EQ.'AJLIAI') THEN
        ZI(JCOCO+3) = IVAL
      ELSEIF (QUESTI.EQ.'SPLIAI') THEN
        ZI(JCOCO+4) = IVAL        
      ELSEIF (QUESTI.EQ.'LLF') THEN
        ZI(JCOCO+5) = IVAL  
      ELSEIF (QUESTI.EQ.'LLF1') THEN
        ZI(JCOCO+6) = IVAL  
      ELSEIF (QUESTI.EQ.'LLF2') THEN
        ZI(JCOCO+7) = IVAL                                        
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF        
C
      CALL JEDEMA()
      END
