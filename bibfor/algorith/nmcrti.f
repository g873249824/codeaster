      SUBROUTINE NMCRTI(SDTIME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*24  SDTIME      
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - INITIALISATIONS)
C
C CREATION DE LA SD TIMER
C      
C ----------------------------------------------------------------------
C 
C
C IN  SDTIME : SD TIMER
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NBTIME,NBMESU
      PARAMETER    (NBTIME=6,NBMESU=16)
C
      INTEGER      IFM,NIV
      CHARACTER*24 TIMPAS,TIMITE,TIMARC,TIMPST
      INTEGER      JTPAS,JTITE,JTARC,JTPST
      CHARACTER*24 TIMDEB
      INTEGER      JTDEB
      CHARACTER*24 TIMTM1,TIMTM2 
      INTEGER      JTMP1,JTMP2
      CHARACTER*24 TIMET,TIMEP,TIMEN
      INTEGER      JTIMET,JTIMEP,JTIMEN             
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION SD TIMER' 
      ENDIF      
C
C --- TIMERS: PAS/ITERATION/ARCHIVAGE/AUTRES
C 
      TIMTM1 = SDTIME(1:19)//'.TMP1'
      TIMTM2 = SDTIME(1:19)//'.TMP2'
      TIMPAS = SDTIME(1:19)//'.TPAS'
      TIMITE = SDTIME(1:19)//'.TITE'
      TIMARC = SDTIME(1:19)//'.TARC'
      TIMPST = SDTIME(1:19)//'.TPST'
      CALL WKVECT(TIMTM1,'V V R',4,JTMP1)
      CALL WKVECT(TIMTM2,'V V R',4,JTMP2)
      CALL WKVECT(TIMPAS,'V V R',4,JTPAS)
      CALL WKVECT(TIMITE,'V V R',4,JTITE)
      CALL WKVECT(TIMARC,'V V R',4,JTARC)
      CALL WKVECT(TIMPST,'V V R',4,JTPST)    
C
C --- STOCKAGE TEMPS INITIAL POUR LES TIMERS
C             
      TIMDEB = SDTIME(1:19)//'.TDEB'
      CALL WKVECT(TIMDEB,'V V R',NBTIME,JTDEB)
C
C --- STOCKAGE MESURES - ITERATION DE NEWTON
C  
      TIMEN  = SDTIME(1:19)//'.TIMN'
      CALL WKVECT(TIMEN ,'V V R',NBMESU,JTIMEN)
C
C --- STOCKAGE MESURES - PAS DE TEMPS
C  
      TIMEP  = SDTIME(1:19)//'.TIMP'
      CALL WKVECT(TIMEP ,'V V R',NBMESU,JTIMEP)
C
C --- STOCKAGE MESURES - TOTAL TRANSITOIRE
C  
      TIMET  = SDTIME(1:19)//'.TIMT'
      CALL WKVECT(TIMET ,'V V R',NBMESU,JTIMET)
C
C --- INITIALISATION DE TOUS LES TIMERS
C
      CALL NMTIME(SDTIME,'INI','ALL')     
C
      CALL JEDEMA()
      END
