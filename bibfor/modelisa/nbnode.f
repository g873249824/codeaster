      SUBROUTINE NBNODE(NOMA  ,MOTFAC,NZOCU ,NOPONO,NNOCU )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*16  MOTFAC
      INTEGER       NZOCU      
      CHARACTER*24  NOPONO            
      INTEGER       NNOCU
C     
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (LIAISON_UNILATERALE - LECTURE)
C
C DECOMPTE DES NOEUDS AFFECTES PAR ZONE
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MOTFAC : MOT_CLEF FACTEUR POUR LIAISON UNILATERALE
C IN  NZOCU  : NOMBRE DE ZONES DE LIAISON_UNILATERALE
C OUT NOPONO : NOM DE L'OBJET JEVEUX CONTENANT LE VECTEUR D'INDIRECTION
C OUT NNOCU  : NOMBRE DE TOTAL DE NOEUDS POUR TOUTES LES OCCURRENCES
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
      CHARACTER*8  K8BLA
      INTEGER      IZONE
      INTEGER      JNP
      INTEGER      NBMOCL
      CHARACTER*16 LIMOCL(2),TYMOCL(2) 
      CHARACTER*24 LISTMN,LISTNN 
      INTEGER      NBMANO,NBNONO,NBNO     
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C      
      CALL WKVECT(NOPONO,'V V I',NZOCU+1,JNP)
      
      ZI(JNP) = 1
      NNOCU   = 0
      NBMOCL  = 2
      K8BLA   = ' '
C
C --- NOM DES SD TEMPORAIRES
C          
      LISTMN = '&&NBNODE.MAIL.NOEU'
      LISTNN = '&&NBNODE.NOEU.NOEU'      
C                             
C --- ON COMPTE LES NOEUDS DES ZONES 
C     
      DO 10 IZONE = 1,NZOCU
        TYMOCL(1) = 'GROUP_MA'
        TYMOCL(2) = 'MAILLE'
        LIMOCL(1) = 'GROUP_MA'
        LIMOCL(2) = 'MAILLE'
        CALL RELIEM(K8BLA ,NOMA  ,'NU_NOEUD',MOTFAC,IZONE ,
     &              NBMOCL,LIMOCL,TYMOCL,LISTMN,NBMANO)
           
        TYMOCL(1) = 'GROUP_NO'
        TYMOCL(2) = 'NOEUD'
        LIMOCL(1) = 'GROUP_NO'
        LIMOCL(2) = 'NOEUD'
        CALL RELIEM(K8BLA ,NOMA  ,'NU_NOEUD',MOTFAC,IZONE ,
     &              NBMOCL,LIMOCL,TYMOCL,LISTNN,NBNONO)
        NBNO   = NBMANO+NBNONO
        NNOCU  = NNOCU+NBNO
        ZI(JNP+IZONE) = ZI(JNP+IZONE-1)+NBNO 
 10   CONTINUE 
C   
      CALL JEDETR(LISTMN)
      CALL JEDETR(LISTNN)  
C
      CALL JEDEMA()
C
      END
