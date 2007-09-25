      SUBROUTINE SANSCC (CHAR, MOTFAC, NOMA, NZOCO, NNOCO, NMACO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
C REPONSABLE
C
      IMPLICIT     NONE
      CHARACTER*8  CHAR,NOMA
      CHARACTER*16 MOTFAC
      INTEGER      NZOCO,NNOCO,NMACO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - LECTURE DONNEES)
C
C TRAITEMENT MOT-CLEFS GROUP_NO_FOND/GROUP_MA_FOND/GROUP_NO_RACC
C      
C ----------------------------------------------------------------------
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NOMA   : NOM DU MAILLAGE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NMACO  : NOMBRE TOTAL DE MAILLES DES SURFACES
C IN  NNOCO  : NOMBRE TOTAL DE NOEUDS DES SURFACES
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
      CHARACTER*24 BARSNO,PBARS,BARSMA,PBARM,RACCNO,PRACC,FROTNO,PFROT
      INTEGER      NUMSUR
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()   
C
C --- TRAITEMENT MOT-CLEF GROUP_NO_FOND/NOEUD_FOND
C
      NUMSUR = 0 
      BARSNO = CHAR(1:8)//'.CONTACT.BANOCO'
      PBARS  = CHAR(1:8)//'.CONTACT.PBANOCO'
      CALL SANSNO(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,
     &            'GROUP_NO_FOND','NOEUD_FOND',BARSNO,PBARS,NUMSUR)
C
C --- TRAITEMENT MOT-CLEF GROUP_MA_FOND/MAILLE_FOND
C
      NUMSUR = 0 
      BARSMA = CHAR(1:8)//'.CONTACT.BAMACO'
      PBARM  = CHAR(1:8)//'.CONTACT.PBAMACO'
      CALL SANSMA(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NMACO ,
     &            'GROUP_MA_FOND','MAILLE_FOND',BARSMA,PBARM,NUMSUR)
C
C --- TRAITEMENT MOT-CLEF GROUP_NO_RACC/NOEUD_RACC
C
      NUMSUR = 0 
      RACCNO = CHAR(1:8)//'.CONTACT.RANOCO'
      PRACC  = CHAR(1:8)//'.CONTACT.PRANOCO'
      CALL SANSNO(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,
     &            'GROUP_NO_RACC','NOEUD_RACC',RACCNO,PRACC,NUMSUR)
C
C --- TRAITEMENT MOT-CLEF SANS_GROUP_NO_FROT/SANS_NOEUD_FROT
C
      NUMSUR = 0 
      FROTNO = CHAR(1:8)//'.CONTACT.SANOFR'
      PFROT  = CHAR(1:8)//'.CONTACT.PSANOFR'
      CALL SANSNO(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,
     &           'SANS_GROUP_NO_FR','SANS_NOEUD_FR',FROTNO,PFROT,NUMSUR)
     
      CALL JEDEMA()
      END
