      SUBROUTINE XMIMP3(IFM   ,NOMA  ,ITPC  ,JVALV ,JTABF )
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF DEBUG  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INTEGER      IFM                  
      CHARACTER*8  NOMA
      INTEGER      ITPC
      INTEGER      JVALV,JTABF
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEM - UTILITAIRE - IMPRESSIONS)
C
C AFFICHAGE DE LA CARTE DES ELEMENTS DE CONTACT 
C      
C ----------------------------------------------------------------------
C
C
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  ITPC   : NUMERO DU POINT DE CONTACT SUR TOUTE LA SURFACE
C IN  JVALV  : POINTEUR VERS LE CHAM_ELEM
C IN  JTABF  : POINTEUR VERS DEFICO(1:16)//'.CARACF'
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
      INTEGER      CFMMVD,ZTABF  
      INTEGER      NUMMAE,NUMMAM
      CHARACTER*8  NOMESC,NOMMAI     
      REAL*8       COEFFF,LAMBDA
      REAL*8       COEFCR,COEFFR
      INTEGER      IFROTT  
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()     
C
      ZTABF  = CFMMVD('ZTABF')          
C                
      LAMBDA = ZR(JVALV-1+12)
      COEFCR = ZR(JVALV-1+13)           
      COEFFR = ZR(JVALV-1+14)   
      COEFFF = ZR(JVALV-1+15)
      IFROTT = NINT(ZR(JVALV-1+16))               
C
C --- ACCES A L'ELEMENT EN COURS            
C 
      NUMMAE  = NINT(ZR(JTABF+ZTABF*(ITPC-1)+1))
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAE),NOMESC) 
      NUMMAM  = NINT(ZR(JTABF+ZTABF*(ITPC-1)+2))
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAM),NOMMAI)         
      WRITE(IFM,1000) ITPC,NOMESC,NOMMAI
C
C --- POINT DE CONTACT EN COURS
C             
      WRITE(IFM,1001)   
      WRITE(IFM,1002) LAMBDA,COEFCR
      IF (IFROTT.EQ.3) THEN
        WRITE(IFM,1006) COEFFF,COEFFR          
      ENDIF            
C
C --- FORMATS AFFICHAGE
C
 1000 FORMAT (' <CONTACT>     * LA MAILLE DE CONTACT ',I5,
     &        '(',A8,'/',A8,')')    
 1001 FORMAT (' <CONTACT>        A POUR PROPRIETES') 
  
 1002 FORMAT (' <CONTACT>          - LAMBDA         : ',E10.3,
     &        ' - COEF_REGU_CONT :  ',E10.3) 
        
 1006 FORMAT (' <CONTACT>          AVEC FROTTEMENT DE COULOMB',
     &        ' - COEFFICIENT    :  ',E10.3,
     &        ' - COEF_REGU_FROT :  ',E10.3)      
C    
      CALL JEDEMA()
C
      END
