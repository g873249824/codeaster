      SUBROUTINE NMERGE(SDERRO,NOMEVT,LACTIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*24  SDERRO
      CHARACTER*9   NOMEVT
      LOGICAL       LACTIV
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD ERREUR)
C
C DIT SI UN EVENEMENT EST DECLENCHE
C
C ----------------------------------------------------------------------
C
C
C IN  SDERRO : SD GESTION DES ERREURS
C IN  NOMEVT : NOM DE L'EVENEMENT (VOIR LA LISTE DANS NMCRER)
C OUT LACTIV : .TRUE. SI EVENEMENT ACTIVE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      ZEVEN
      INTEGER      IEVEN,ICODE
      CHARACTER*24 ERRINF
      INTEGER      JEINF
      CHARACTER*24 ERRENO,ERRAAC
      INTEGER      JEENOM,JEEACT
      CHARACTER*16 NEVEN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LACTIV = .FALSE.
C
C --- ACCES SD
C
      ERRINF = SDERRO(1:19)//'.INFO'
      CALL JEVEUO(ERRINF,'L',JEINF)
      ZEVEN  = ZI(JEINF-1+1)
C
      ERRENO = SDERRO(1:19)//'.ENOM'
      ERRAAC = SDERRO(1:19)//'.EACT'
      CALL JEVEUO(ERRENO,'L',JEENOM)
      CALL JEVEUO(ERRAAC,'L',JEEACT)
C
      DO 15 IEVEN = 1,ZEVEN
        NEVEN  = ZK16(JEENOM-1+IEVEN)
        IF (NEVEN.EQ.NOMEVT) THEN
          ICODE  = ZI(JEEACT-1+IEVEN)
          IF (ICODE.EQ.1) LACTIV = .TRUE.
        ENDIF
 15   CONTINUE
C
      CALL JEDEMA()
      END
