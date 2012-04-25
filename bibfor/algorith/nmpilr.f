      SUBROUTINE NMPILR(FONACT,NUMEDD,MATASS,VEASSE,RESIDU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/04/2012   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*24 NUMEDD
      CHARACTER*19 MATASS,VEASSE(*)
      INTEGER      FONACT(*)
      REAL*8       RESIDU
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
C
C CALCUL DE LA NORME MAX DU RESIDU D'EQUILIBRE
C      
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  NUMEDD : NOM DU NUME_DDL
C IN  MATASS : MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE 
C OUT RESIDU : NORME MAX DU RESIDU D'EQUILIBRE
C                MAX(CNFINT+CNDIRI-CNFEXT)
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
      INTEGER      JFINT,JFEXT,JDIRI
      CHARACTER*19 CNFEXT,CNFINT,CNDIRI 
      INTEGER      JCCID
      INTEGER      IEQ,NEQ,IRET
      CHARACTER*8  K8BID     
      INTEGER      IFM,NIV     
      LOGICAL      ISFONC,LCINE
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('PILOTAGE',IFM,NIV)
C
C --- FONCTIONNALITES ACTIVEES
C
      LCINE  = ISFONC(FONACT,'DIRI_CINE')
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C      
      CALL NMCHEX(VEASSE,'VEASSE','CNDIRI',CNDIRI)
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT)  
      CALL NMCHEX(VEASSE,'VEASSE','CNFEXT',CNFEXT)           
C
C --- INITIALISATIONS
C
      CALL JEVEUO(CNFINT(1:19)//'.VALE','L',JFINT)
      CALL JEVEUO(CNDIRI(1:19)//'.VALE','L',JDIRI)          
      CALL JEVEUO(CNFEXT(1:19)//'.VALE','L',JFEXT)           
C
C --- POINTEUR SUR LES DDLS ELIMINES PAR AFFE_CHAR_CINE
C
      IF (LCINE) THEN
        CALL NMPCIN(MATASS)
        CALL JEVEUO(MATASS(1:19)//'.CCID','L',JCCID)
      ENDIF
C      
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)      
      RESIDU = 0.D0
C     
C --- CALCUL
C
      DO 10 IEQ=1, NEQ
        IF (LCINE) THEN
          IF (ZI(JCCID+IEQ-1).EQ.1) THEN
            GOTO 15
          ENDIF
        ENDIF
        RESIDU = MAX(RESIDU,ABS( ZR(JFINT+IEQ-1)+
     &                           ZR(JDIRI+IEQ-1)- 
     &                           ZR(JFEXT+IEQ-1)) )
  15    CONTINUE
  10  CONTINUE  
C
      CALL JEDEMA()
      END
