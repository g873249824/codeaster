      SUBROUTINE CFBORD(CHAR  ,NOMA  )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  CHAR
      CHARACTER*8  NOMA
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C LECTURE DES MAILLES DE CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NDIM   : NOMBRE DE DIMENSIONS DU PROBLEME
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C OUT LIGRET : LIGREL D'ELEMENTS TARDIFS DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 DEFICO,CONTMA
      INTEGER      IATYMA,JMACO ,JTMDIM
      INTEGER      CFDISI
      INTEGER      NDIMG ,NMACO ,VALI(2)
      INTEGER      IMA   ,NUMMAI,NUTYP ,NDIMMA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'
      CONTMA = DEFICO(1:16)//'.MAILCO'
C
C --- LECTURE DES STRUCTURES DE DONNEES
C
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO('&CATA.TM.TMDIM','L',JTMDIM)
C
C --- INFO SUR LE CONTACT
C
      NDIMG   = CFDISI(DEFICO,'NDIM' )
      NMACO   = CFDISI(DEFICO,'NMACO' )
C
C --- VERIFICATION DE LA COHERENCE DES DIMENSIONS
C
      DO 10 IMA = 1, NMACO
         NUMMAI = ZI(JMACO  -1 + IMA)
         NUTYP  = ZI(IATYMA -1 + NUMMAI)
         NDIMMA = ZI(JTMDIM -1 + NUTYP)
         IF (NDIMMA.GT.(NDIMG-1)) THEN
           VALI(1) = NDIMMA
           VALI(2) = NDIMG
           CALL U2MESI('F','CONTACT2_11',2,VALI)
         ENDIF
 10   CONTINUE

      CALL JEDEMA()

      END
