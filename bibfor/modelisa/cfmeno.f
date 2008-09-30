      SUBROUTINE CFMENO(DEFICO,NSUCO  ,NNOCO0,LISTNO,POINSN,
     &                  NNOCO )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2008   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      INTEGER      NSUCO
      INTEGER      NNOCO0,NNOCO
      CHARACTER*24 DEFICO
      CHARACTER*24 LISTNO
      CHARACTER*24 POINSN
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES NOEUDES - LECTURE DONNEES - ELIMINATION)
C
C MISE A JOUR DE LA LISTE DES NOEUDS APRES ELIMINATION
C      
C ----------------------------------------------------------------------
C
C 
C IN  DEFICO : NOM SD CONTACT DEFINITION
C IN  NSUCO  : NOMBRE TOTAL DE SURFACES DE CONTACT
C IN  NNOCO0 : NOMBRE TOTAL DE NOEUDS DES SURFACES
C IN  POINSN : POINTEUR MISE A JOUR POUR PSURNO
C IN  LISTNO : LISTE DES NOEUDS RESTANTES (LONGUEUR NNOCO
C IN  NNOCO  : NOMBRE DE NOEUDS AU FINAL 
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 CONTNO,PSURNO
      INTEGER      JNOCO,JSUNO
      INTEGER      JELINO,JNO
      INTEGER      ISUCO,I
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
C
C --- ACCES SD
C         
      CALL JEVEUO(LISTNO,'L',JNO   )
      CALL JEVEUO(POINSN,'L',JELINO)
C         
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      PSURNO = DEFICO(1:16)//'.PSUNOCO'      
      CALL JEVEUO(PSURNO,'E',JSUNO) 
      CALL JEVEUO(CONTNO,'E',JNOCO)                 
C 
C --- MODIFICATION DU POINTEUR PSURNO
C 
      DO 160 ISUCO = 1,NSUCO
        ZI(JSUNO+ISUCO)  = ZI(JSUNO+ISUCO)  - ZI(JELINO+ISUCO)
  160 CONTINUE
C
C --- TRANSFERT DES VECTEURS DE TRAVAIL DANS CONTNO
C
      DO 170 I = 1,NNOCO
        ZI(JNOCO+I-1) = ZI(JNO+I-1)
  170 CONTINUE
C
C --- MAZ ET MODIFICATION DE L'ATTRIBUT LONUTI
C
      DO 180 I = NNOCO + 1,NNOCO0
        ZI(JNOCO+I-1) = 0
  180 CONTINUE
      CALL JEECRA(CONTNO,'LONUTI',NNOCO,K8BID) 
C
      CALL JEDEMA()
      END
