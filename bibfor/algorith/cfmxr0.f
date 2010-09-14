      SUBROUTINE CFMXR0(DEFICO,RESOCO,NOMA  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*8  NOMA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - POST-TRAITEMENT)
C
C CREER LE VALE_CONT POUR L'ARCHIVAGE DU CONTACT 
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C
C ------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C --------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------
C 
      INTEGER      NBCMP
      PARAMETER    (NBCMP = 27)
      CHARACTER*8  NOMCMP(NBCMP)
      INTEGER      NBPER
      PARAMETER    (NBPER = 4)
      CHARACTER*8  NOMPER(NBPER)            
C
      INTEGER      CFMMVD,ZRESU,ZPERC
      INTEGER      IFM,NIV
      INTEGER      IZONE,ICMP,INOE
      INTEGER      NBNOE,POSNOE,NUMNOE
      INTEGER      CFDISI,NZOCO
      INTEGER      JCNSVR,JCNSLR
      CHARACTER*19 CNSINR
      INTEGER      JCNSVP,JCNSLP
      INTEGER      MMINFI,JDECNE
      LOGICAL      CFDISL,LCTCC,LCTCD,LMAIL
      CHARACTER*19 CNSPER      
C ----------------------------------------------------------------------
      DATA NOMCMP
     &   / 'CONT','JEU' ,'RN'  ,
     &     'RNX' ,'RNY' ,'RNZ' ,
     &     'GLIX','GLIY','GLI' ,
     &     'RTAX','RTAY','RTAZ',
     &     'RTGX','RTGY','RTGZ',
     &     'RX'  ,'RY'  ,'RZ'  ,
     &     'R'   ,'HN'  ,'I'   ,
     &     'IX'  ,'IY'  ,'IZ'  ,
     &     'PT_X','PT_Y','PT_Z'/   
C ----------------------------------------------------------------------
      DATA NOMPER
     &   / 'V1','V2','V3','V4'/     
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- INITIALISATIONS
C      
      NZOCO  = CFDISI(DEFICO,'NZOCO' )
C
C --- ACCES SD CONTACT
C    
      CNSINR = RESOCO(1:14)//'.VALE'
      CNSPER = RESOCO(1:14)//'.PERC'    
      ZRESU  = CFMMVD('ZRESU')
      ZPERC  = CFMMVD('ZPERC')
      IF (ZRESU.NE.NBCMP) THEN
        CALL ASSERT(.FALSE.)
      ENDIF    
      IF (ZPERC.NE.NBPER) THEN
        CALL ASSERT(.FALSE.)
      ENDIF   
C
C --- TYPE DE CONTACT
C       
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LCTCD  = CFDISL(DEFICO,'FORMUL_DISCRETE')
      LMAIL  = LCTCC.OR.LCTCD               
C
C --- CREATION DU CHAM_NO_S VALE_CONT
C
      CALL CNSCRE(NOMA  ,'INFC_R',ZRESU ,NOMCMP,'V',CNSINR)
C
C --- INITIALISATION DU CHAM_NO_S VALE_CONT 
C
      IF (LMAIL) THEN
        CALL JEVEUO(CNSINR(1:19)//'.CNSV','E',JCNSVR)
        CALL JEVEUO(CNSINR(1:19)//'.CNSL','E',JCNSLR)
        DO 10 IZONE = 1,NZOCO
          JDECNE = MMINFI(DEFICO,'JDECNE',IZONE )
          NBNOE  = MMINFI(DEFICO,'NBNOE' ,IZONE )
          DO 11 INOE = 1,NBNOE
            POSNOE = INOE + JDECNE
            CALL CFNUMN(DEFICO,1     ,POSNOE,NUMNOE)
            DO 12 ICMP = 1,ZRESU
              ZR(JCNSVR-1+ZRESU*(NUMNOE-1)+ICMP) = 0.D0
              ZL(JCNSLR-1+ZRESU*(NUMNOE-1)+ICMP) = .TRUE.
 12         CONTINUE
 11       CONTINUE
 10     CONTINUE
      ENDIF
C
C --- CREATION DU CHAM_NO_S PERCUSSION
C 
      IF (LMAIL) THEN
        CALL CNSCRE(NOMA  ,'VARI_R',ZPERC,NOMPER,'V',CNSPER)
      ENDIF   
C
C --- INITIALISATION DU CHAM_NO_S PERCUSSION
C --- ON NE REMET PAS A ZERO D'UN PAS A L'AUTRE
C
      IF (LMAIL) THEN
        CALL JEVEUO(CNSPER(1:19)//'.CNSV','E',JCNSVP)
        CALL JEVEUO(CNSPER(1:19)//'.CNSL','E',JCNSLP)      
        DO 1 IZONE = 1,NZOCO
          JDECNE = MMINFI(DEFICO,'JDECNE',IZONE )
          NBNOE  = MMINFI(DEFICO,'NBNOE' ,IZONE )
          DO 2 INOE = 1,NBNOE
            POSNOE = INOE + JDECNE
            CALL CFNUMN(DEFICO,1     ,POSNOE,NUMNOE)
            DO 3 ICMP = 1,ZPERC
              ZR(JCNSVP-1+ZPERC*(NUMNOE-1)+ICMP) = 0.D0
              ZL(JCNSLP-1+ZPERC*(NUMNOE-1)+ICMP) = .FALSE.
 3          CONTINUE
 2        CONTINUE
 1      CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
