      SUBROUTINE MMIMP1(IFM,NOMA,IPC,NBC,NTPC,JTABF,JEU,NORM)
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
      IMPLICIT     NONE
      INTEGER      IFM
      CHARACTER*8  NOMA
      INTEGER      IPC
      INTEGER      NTPC
      INTEGER      NBC 
      REAL*8       JEU
      INTEGER      JTABF
      REAL*8       NORM(3)
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : MAPPAR
C ----------------------------------------------------------------------
C
C AFFICHAGE POUR L'APPARIEMENT (METHODE CONTACT CONTINU)
C
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMAE  : NUMERO MAILLE ESCLAVE
C IN  IPC    : ORDRE POINT DE CONTACT SUR MAILLE ESCLAVE
C IN  NBC    : NOMBRE POINTS DE CONTACT POUR MAILLE EN COURS
C IN  NTPC   : NOMBRE POINTS DE CONTACT CUMULEE (!) POUR MAILLE EN COURS
C IN  JMACO  : POINTEUR VERS DEFICO(1:16)//'.CARACF'
C IN  JEU    : JEU DE LA LIAISON 
C IN  NORM   : NORMALE
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
      INTEGER      NUMMAI,IZONE
      REAL*8       COMPLI
      CHARACTER*8  NOMESC,NOMMAI
      INTEGER      NUMAE   
      REAL*8  XPG,YPG,HPG,XPROJ,YPROJ
      REAL*8  TANG1(3),TANG2(3)
      LOGICAL LCOMP        
C
C ----------------------------------------------------------------------
C
      ZTABF = CFMMVD('ZTABF')
C
C --- REPERAGE DE L'ESCLAVE
C
      NUMAE = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+1)
      CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMAE),NOMESC)
C
C --- REPERAGE DU MAITRE
C
      NUMMAI = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+2))
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAI),NOMMAI)      
C
C --- INFOS COMMUNES POUR MAILLE ESCLAVE EN COURS
C      
      IF (IPC.EQ.1) THEN
        IZONE  = NINT(ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+15))  
C        LAMBDA = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+14)    
        COMPLI = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) 
        IF (COMPLI.EQ.0.D0) THEN
          LCOMP = .FALSE.
        ELSE
          LCOMP = .TRUE.  
        ENDIF
        IF (.NOT.LCOMP) THEN
          WRITE (IFM,1000) NOMESC,IZONE,NBC     
        ELSE
          WRITE (IFM,1000) NOMESC,IZONE,NBC        
        ENDIF                      
      ENDIF          
C
C --- POINT DE CONTACT EN COURS
C
      XPG = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+3)       
      YPG = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+12)      
      HPG = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+16)
C
C --- COORDONNEES DU POINT DE PROJECTION SUR MAITRE (ELEM. DE REFERENCE)
C
      XPROJ = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+4)
      YPROJ = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+5)
C
C --- TANGENTES AU POINT DE PROJECTION SUR MAITRE   
C   
      TANG1(1) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+6)
      TANG1(2) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+7)
      TANG1(3) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+8)
      TANG2(1) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+9)
      TANG2(2) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+10)
      TANG2(3) = ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+11)      
C
C --- AFFICHAGE INFOS APPARIEMENT
C
      WRITE(IFM,2000) IPC,XPG,YPG,HPG  
      WRITE(IFM,2001) NORM(1),NORM(2),NORM(3)
      WRITE(IFM,2002) TANG1(1),TANG1(2),TANG1(3),
     &                TANG2(1),TANG2(2),TANG2(3)      
      WRITE(IFM,2003) NOMMAI,XPROJ,YPROJ 
C
C --- FORMATS AFFICHAGE
C
 1000 FORMAT (' <CONTACT> <> MAILLE ESCLAVE ',A8,' SUR ZONE ',
     &        I5,' (SANS COMPLIANCE) AVEC ',I5,
     &        ' POINTS DE CONTACT')
 2000 FORMAT (' <CONTACT> <> * POINT DE CONTACT ',I3,' SITUE EN <',
     &         E10.3,',',E10.3,'> - POIDS: ',E10.3)
 2001 FORMAT (' <CONTACT> <>     NORMALE     <',
     &         E10.3,',',E10.3,',',E10.3,'>')
 2002 FORMAT (' <CONTACT> <>     TANGENT     <',
     &         E10.3,',',E10.3,',',E10.3,'> <',
     &         E10.3,',',E10.3,',',E10.3,'>')      
 2003 FORMAT (' <CONTACT> <>     SUR MAILLE  <',A8,'> EN <',
     &         E10.3,',',E10.3,'>')
      END
