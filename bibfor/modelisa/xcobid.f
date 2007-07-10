      SUBROUTINE XCOBID(MODELE,DEFICO)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE ABBAS M.ABBAS
C 
      IMPLICIT NONE
      CHARACTER*8  MODELE
      CHARACTER*24 DEFICO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEM - ALGORITHME)
C
C CREATION D'UNE SD CONTACT BIDON POUR XFEM
C      
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE CONTACT
C IN  MODELE : NOM DU MODELE
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
      INTEGER      IFISS,NFISS,IRET,NZOCO,IZONE
      INTEGER      JXC,JXSDC,JNFIS,JMOFIS
      CHARACTER*8  NOMFIS
      CHARACTER*24 CARACF,METHCO,ECPDON,FORMCO
      INTEGER      JCMCF,JMETH,JECPD,JFORM
      INTEGER      CFMMVD,ZECPD,ZCMCF,ZMETH 
      CHARACTER*24 XCONTA,XFIMAI
      INTEGER      JCONTX,JFIMAI      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES A LA SD FISS_XFEM
C
      CALL JEEXIN(MODELE(1:8)//'.FISS',IRET)
C      
      IF (IRET.EQ.0) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        CALL JEVEUO(MODELE(1:8)//'.FISS'  ,'L',JMOFIS)        
        CALL JEVEUO(MODELE(1:8)//'.NFIS'  ,'L',JNFIS)
        CALL JEVEUO(MODELE(1:8)//'.XFEM_SDCONT','L',JXSDC)
        CALL JEVEUO(MODELE(1:8)//'.XFEM_CONT'  ,'L',JXC)
      ENDIF
C 
C --- INITIALISATIONS
C
      NFISS  = ZI(JNFIS)      
      NZOCO  = NFISS
C   
C --- ACCES AUX SDS
C 
      FORMCO = DEFICO(1:16)//'.FORMCO'             
      ECPDON = DEFICO(1:16)//'.ECPDON'
      CARACF = DEFICO(1:16)//'.CARACF'  
      METHCO = DEFICO(1:16)//'.METHCO'
      XFIMAI = DEFICO(1:16)//'.XFIMAI' 
      XCONTA = DEFICO(1:16)//'.XFEM'      
C
      ZMETH  = CFMMVD('ZMETH')
      ZECPD  = CFMMVD('ZECPD')
      ZCMCF  = CFMMVD('ZCMCF') 
C   
C --- CREATION DES SDS
C       
      CALL JEEXIN(CARACF,IRET)
      IF (IRET.EQ.0) THEN
        CALL WKVECT(CARACF,'G V R' ,ZCMCF*NZOCO+1,JCMCF)
        CALL WKVECT(ECPDON,'G V I' ,ZECPD*NZOCO+1,JECPD)
        CALL WKVECT(FORMCO,'G V I' ,NZOCO,JFORM)
        CALL WKVECT(METHCO,'G V I' ,ZMETH*NZOCO+1,JMETH)  
        CALL WKVECT(XFIMAI,'G V K8',NZOCO,JFIMAI) 
        CALL WKVECT(XCONTA,'G V I' ,2    ,JCONTX)      
      ELSE
        CALL JEVEUO(XFIMAI,'E',JFIMAI) 
        CALL JEVEUO(XCONTA,'E',JCONTX)
        GOTO 899
      ENDIF       
C
C --- REMPLISSAGE DES STRUCTURES DE DONNEES DE CONTACT
C 
      ZR(JCMCF)      = NZOCO  
      ZI(JECPD)      = 1  
      ZI(JCONTX-1+1) = NZOCO
      ZI(JCONTX-1+2) = 0
      ZI(JMETH)      = NZOCO       
C      
      DO 10 IZONE = 1,NZOCO     
        ZI(JFORM-1+IZONE)            = 3
        ZI(JMETH+ZMETH*(IZONE-1)+6)  = 11
        ZR(JCMCF+ZCMCF*(IZONE-1)+1)  = 4.D0
        ZR(JCMCF+ZCMCF*(IZONE-1)+2)  = 100.D0
        ZR(JCMCF+ZCMCF*(IZONE-1)+3)  = 0.D0        
        ZR(JCMCF+ZCMCF*(IZONE-1)+4)  = 0.D0 
        ZR(JCMCF+ZCMCF*(IZONE-1)+5)  = 1.D0         
        ZR(JCMCF+ZCMCF*(IZONE-1)+6)  = 0.D0         
        ZI(JECPD+ZECPD*(IZONE-1)+2)  = 4     
        ZI(JECPD+ZECPD*(IZONE-1)+3)  = 0
        ZI(JECPD+ZECPD*(IZONE-1)+4)  = 1 
        ZI(JECPD+ZECPD*(IZONE-1)+5)  = 0
        ZR(JCMCF+ZCMCF*(IZONE-1)+23) = 1.D0
        ZR(JCMCF+ZCMCF*(IZONE-1)+24) = 0.D0 
  10  CONTINUE
C
C --- LECTURE DES FISSURES EN CONTACT
C
  899 CONTINUE 
C        
      DO 20 IZONE = 1,NZOCO     
        IFISS  = IZONE
        NOMFIS = ZK8(JMOFIS-1 + IFISS)
        ZK8(JFIMAI-1+IZONE) = NOMFIS 
        ZI(JXC-1+IFISS)     = IZONE        
  20  CONTINUE  
C
  999 CONTINUE                          
C
      CALL JEDEMA()
C
      END
