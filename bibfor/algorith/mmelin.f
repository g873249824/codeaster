      SUBROUTINE MMELIN(NOMA,NUMA,TYPINT,NNINT,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/09/2006   AUTEUR MABBAS M.ABBAS 
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
      INTEGER     TYPINT
      INTEGER     NNINT
      INTEGER     IRET
C
C ----------------------------------------------------------------------
C ROUTINE UTILITAIRE (CONTACT METHODE CONTINUE)
C ----------------------------------------------------------------------
C
C RETOURNE LE NOMBRE DE POINTS D'INTEGRATION POUR UN ELEMENT
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMA   : NUMERO ABSOLU DE LA MAILLE 
C IN  TYPINT : TYPE SCHEMA INTEGRATION
C OUT NNINT  : NOMBRE DE POINTS D'INTEGRATION DE CET ELEMENT
C OUT IRET   : CODE RETOUR ERREUR
C                0 TOUT VA BIEN
C                1 SCHEMA D'INTEGRATION INCONNU
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
      INTEGER      IBID
      CHARACTER*8  ALIAS
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      IRET = 0
      CALL MMELTY(NOMA,NUMA,ALIAS,IBID,IBID)
C
      IF (TYPINT .EQ. 1) THEN
C NOEUDS
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 2
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 3
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 3
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 9
      ELSEIF (TYPINT .EQ. 2) THEN
C PGAUSS
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 2
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 2
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 3
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 9
      ELSEIF (TYPINT .EQ. 3) THEN
C SIMPSON
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 3
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 3
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 9
      ELSEIF (TYPINT .EQ. 4) THEN
C SIMPSON1
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 5
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 5
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 15
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 15
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 21
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 21
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 21
      ELSEIF (TYPINT .EQ. 5) THEN
C SIMPSON2
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 9
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 42
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 42
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 65
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 65
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 65
      ELSEIF (TYPINT .EQ. 6) THEN
C NEWTON-COTES
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 4
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 16
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 16
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 16
      ELSEIF (TYPINT .EQ. 7) THEN
C NEWTON-COTES1
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 5
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 5
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 6
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 25
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 25
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 25
      ELSEIF (TYPINT .EQ. 8) THEN
C NEWTON-COTES2
        IF (ALIAS(1:3) .EQ. 'SG2') NNINT = 10
        IF (ALIAS(1:3) .EQ. 'SG3') NNINT = 10
        IF (ALIAS(1:3) .EQ. 'TR3') NNINT = 42
        IF (ALIAS(1:3) .EQ. 'TR6') NNINT = 42
        IF (ALIAS(1:3) .EQ. 'QU4') NNINT = 100
        IF (ALIAS(1:3) .EQ. 'QU8') NNINT = 100
        IF (ALIAS(1:3) .EQ. 'QU9') NNINT = 100
      ELSE
        IRET = 1
        CALL UTMESS('F','MMELIN',
     &   'SCHEMA INTEGRATION NON CONFORME')
      END IF      
C
      CALL JEDEMA()        
      END
