      SUBROUTINE CARACC(CHAR  ,NZOCO)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*8  CHAR
      INTEGER      NZOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - LECTURE DONNEES)
C
C CREATION DES SDS DE DEFINITION DU CONTACT
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
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
      INTEGER      CFMMVD,ZCMCF,ZECPD,ZEXCL
      CHARACTER*24 ECPDON,CARACF,EXCLFR
      INTEGER      JECPD,JCMCF,JEXCLF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()            
C   
C --- COMMUNS AVEC FORM. XFEM
C 
      ECPDON = CHAR(1:8)//'.CONTACT.ECPDON'
      CARACF = CHAR(1:8)//'.CONTACT.CARACF'
      EXCLFR = CHAR(1:8)//'.CONTACT.EXCLFR'
C     
      ZCMCF = CFMMVD('ZCMCF')      
      ZECPD = CFMMVD('ZECPD')
      ZEXCL = CFMMVD('ZEXCL')     
C
      CALL WKVECT(CARACF,'G V R',ZCMCF*NZOCO+1,JCMCF)
      CALL WKVECT(ECPDON,'G V I',ZECPD*NZOCO+1,JECPD) 
      CALL WKVECT(EXCLFR,'G V R',ZEXCL*NZOCO  ,JEXCLF)  
C
      ZR(JCMCF) = NZOCO   
      ZI(JECPD) = 1       
C
      CALL JEDEMA()
C
      END
