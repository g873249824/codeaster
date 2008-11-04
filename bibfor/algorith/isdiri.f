      LOGICAL FUNCTION ISDIRI(LISCHA)     
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*19 LISCHA
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C DIT SI ON A DES CHARGEMENTS DE TYPE DIRICHLET PAR AFFE_CHAR_MECA
C
C ATTENTION ! ON NE DETECTE APS LES DIRICHELT PAR AFFE_CHAR_CINE !
C      
C ----------------------------------------------------------------------
C
C
C IN  LISCHA : SD L_CHARGES
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IRET,ICHA
      CHARACTER*8  K8BID,NOMCHA
      INTEGER      JCHAR,JINF
      INTEGER      NCHAR
      CHARACTER*19 LIGRCH      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
C
C --- INITIALISATIONS
C 
      ISDIRI = .FALSE.
     
     
      CALL JEEXIN(LISCHA(1:19)//'.LCHA', IRET)
      IF (IRET.EQ.0) THEN
        ISDIRI = .FALSE.
        GOTO 99
      ELSE  
        CALL JELIRA(LISCHA(1:19)//'.LCHA','LONMAX',NCHAR,K8BID)
        CALL JEVEUO(LISCHA(1:19)//'.LCHA','L',JCHAR)
        CALL JEVEUO(LISCHA(1:19)//'.INFC','L',JINF)   
        IF (ZK24(JCHAR).NE.'        ') THEN
          DO 10 ICHA = 1,NCHAR
            IF (ZI(JINF+ICHA).NE.0) THEN
              NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
              LIGRCH = NOMCHA(1:8)//'.CHME.LIGRE'
              CALL JEEXIN(LIGRCH(1:19)//'.LIEL',IRET)
              IF (IRET.LE.0) GO TO 10
              CALL EXISD('CHAMP_GD',NOMCHA(1:8)//'.CHME.CMULT',IRET)
              IF (IRET.LE.0) GO TO 10
              ISDIRI = .TRUE.
              GOTO 99
            ENDIF
  10      CONTINUE
        ENDIF               
      ENDIF
C
  99  CONTINUE
C
      CALL JEDEMA()
      END
