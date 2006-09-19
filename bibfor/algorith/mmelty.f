      SUBROUTINE MMELTY(NOMA,NUMA,ALIAS,NNO,NDIM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*8 NOMA
      INTEGER     NUMA
      CHARACTER*8 ALIAS
      INTEGER     NNO
      INTEGER     NDIM
C
C ----------------------------------------------------------------------
C ROUTINE UTILITAIRE (CONTACT METHODE CONTINUE)
C ----------------------------------------------------------------------
C
C RETOURNE UN ALIAS POUR UN TYPE D'ELEMENT, LE NOMBRE DE NOEUDS
C DE CET ELEMENT ET SA DIMENSION
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMA   : NUMERO ABSOLU DE LA MAILLE
C OUT ALIAS  : TYPE DE L'ELEMENT
C               'PO1'
C               'SG2'  
C               'SG3'  
C               'TR3'  
C               'TR6'  
C               'QU4'  
C               'QU8'  
C               'QU9'  
C OUT NNO    : NOMBRE DE NOEUDS DE CET ELEMENT
C OUT NDIM   : DIMENSION DU PROBLEME (2D/3D)
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
      INTEGER      IATYMA,ITYP,NUTYP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      ALIAS(1:8) = '        '
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)      
      ITYP  = IATYMA - 1 + NUMA
      NUTYP = ZI(ITYP)
C
      IF (NUTYP .EQ. 1) THEN
        ALIAS(1:3) = 'PO1'
        NNO  = 1
        NDIM = 1
      ELSEIF (NUTYP .EQ. 2) THEN
        ALIAS(1:3) = 'SG2'
        NNO = 2
        NDIM = 2        
      ELSEIF (NUTYP .EQ. 4) THEN
        ALIAS(1:3) = 'SG3'
        NNO = 3
        NDIM = 2
      ELSEIF (NUTYP .EQ. 7) THEN
        ALIAS(1:3) = 'TR3'
        NNO = 3
        NDIM = 3        
      ELSEIF (NUTYP .EQ. 9) THEN
        ALIAS(1:3) = 'TR6'
        NNO = 6
        NDIM = 3        
      ELSEIF (NUTYP .EQ. 12) THEN
        ALIAS(1:3) = 'QU4'
        NNO = 4
        NDIM = 3        
      ELSEIF (NUTYP .EQ. 14) THEN
        ALIAS(1:3) = 'QU8'
        NNO = 8
        NDIM = 3        
      ELSEIF (NUTYP .EQ. 16) THEN
        ALIAS(1:3) = 'QU9'
        NNO = 9
        NDIM = 3        
      ELSE
        CALL UTMESS('F','MMELTY',
     &   'ELEMENT DE CONTACT NON CONFORME (DVLP)')
      END IF
      IF ((NDIM.NE.2).AND.(NDIM.NE.3)) THEN
        CALL UTMESS('F','MMELTY',
     &   'DIMENSION DE L''ESPACE INCORRECTE (DVLP)')      
      ENDIF
C
      CALL JEDEMA()      
      END
