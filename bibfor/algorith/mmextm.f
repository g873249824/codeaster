      SUBROUTINE MMEXTM(DEFICO,CNSMUL,POSMAE,MLAGR  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      INTEGER       POSMAE
      CHARACTER*19  CNSMUL
      CHARACTER*24  DEFICO
      REAL*8        MLAGR(9)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C EXTRACTION D'UN MULTIPLICATEUR DE LAGRANGE SUR LES NOEUDS D'UNE MAILLE
C ESCLAVE
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  CNSMUL : CHAM_NO_SIMPLE REDUIT AUX DDLS DU MULTIPLICATEUR EXTRAIT
C IN  POSMAE : INDICE DE LA MAILLE ESCLAVE
C OUT MLAGR  : MULTIPLICATEURS SUR LES NOEUDS ESCLAVES
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
      INTEGER      NBNMAX
      PARAMETER    (NBNMAX = 9)
C
      INTEGER      INO,NNOMAI
      INTEGER      NUMNNO(NBNMAX),POSNNO(NBNMAX)
      INTEGER      JCNSLB
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DO 10,INO = 1,NBNMAX
        MLAGR(INO) = 0.D0
   10 CONTINUE
C
C --- NUMEROS DANS SD CONTACT DES NOEUDS DE LA MAILLE ESCLAVE
C
      CALL CFPOSN(DEFICO,POSMAE,POSNNO,NNOMAI)
      CALL ASSERT(NNOMAI.LE.NBNMAX)
C
C --- NUMEROS ABSOLUS DES NOEUDS DE LA MAILLE ESCLAVE
C
      CALL CFNUMN(DEFICO,NNOMAI ,POSNNO,NUMNNO)
C
C --- EXTRACTION DU MULTIPLICATEUR
C
      CALL JEVEUO(CNSMUL//'.CNSV','L',JCNSLB)
      DO 20 INO = 1,NNOMAI
        MLAGR(INO) = ZR(JCNSLB-1+NUMNNO(INO))
   20 CONTINUE
C
      CALL JEDEMA()
      END
