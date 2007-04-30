      SUBROUTINE XCONTA(NOMA  ,NOMO  ,NDIM  ,NFISS,FISS  ,
     &                  SDCONT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      INTEGER      NFISS
      CHARACTER*8  FISS(NFISS),NOMA,NOMO
      CHARACTER*24 SDCONT
      INTEGER      NDIM
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (MODIF. DU MODELE)
C
C PREPARATION DONNEES RELATIVES AU CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NOMA   : NOM DE L'OBJET MAILLAGE
C IN  NOMA   : NOM DE L'OBJET MODELE
C IN  SDCONT : SD CONTACT
C IN  NFISS  : NOMBRE DE FISSURES
C I/O FISS   : LISRE DES SD FISS_XFEM 
C                FISS//'.CONTACT.LISRL' POUR V1 ET V2
C                FISS//'.CONTACT.LISCO' POUR V1 ET V2
C                FISS//'.CONTACT.LISEQ' POUR V2 SEULEMENT    
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
      INTEGER      IFISS,XXCONI,ALGOLA,IZONE
      CHARACTER*24 K24BLA
      REAL*8       R8BID
      LOGICAL      LCONT
      CHARACTER*8  FISCOU
      INTEGER      JXC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C     
      K24BLA = ' '   
C
C --- ACCES OBJETS
C 
      CALL JEVEUO(NOMO(1:8)//'.CONT','E',JXC)
C      
      DO 220 IFISS = 1,NFISS
C
C --- FISSURE COURANTE
C
        FISCOU = FISS(IFISS)      
C
C --- ZONE DE CONTACT IZONE CORRESPONDANTE
C
        IZONE  = XXCONI(SDCONT,FISCOU,'MAIT')      
        ZI(JXC-1+IFISS) = IZONE
C
C --- TYPE LIAISON POUR CONTACT
C     
        CALL MMINFP(IZONE ,SDCONT,K24BLA,'XFEM_ALGO_LAGR',
     &              ALGOLA,R8BID ,K24BLA,LCONT)     
C
C --- CHOIX DE L'ESPACE DES LAGRANGES POUR LE CONTACT
C
        CALL XDEFCO(NOMA  ,FISCOU,ALGOLA,NDIM)
 
 220  CONTINUE 
C
      CALL JEDEMA()
      END
