      SUBROUTINE NMERRO(SDERRO,SDTIME,NUMINS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/09/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      INTEGER       NUMINS
      CHARACTER*24  SDTIME,SDERRO
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DES ERREURS ET EXCEPTIONS
C      
C ----------------------------------------------------------------------
C
C
C IN  NUMINS : NUMERO DU PAS DE TEMPS
C IN  SDTIME : SD TIMER
C IN  SDERRO : SD GESTION ERREUR
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
      CHARACTER*24 TIMPAS,TIMITE
      INTEGER      JTPAS,JTITE
      REAL*8       RTAB(2) 
      INTEGER      ITAB(2)    
      CHARACTER*8  K8BID
      LOGICAL      ECHLDC,ECHEQU,ECHCO1,ECHCO2,ECHPIL,ECHCCC
      LOGICAL      MTCPUI,MTCPUP,ITEMAX,LFATAL
      INTEGER      ETAUSR
      REAL*8       TPSRST,MOYITE,MOYPAS
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
      IF ( ETAUSR().EQ.1 ) THEN
         CALL SIGUSR()
      ENDIF
C
C --- ACCES SD TIMER
C
      TIMPAS = SDTIME(1:19)//'.TPAS'
      TIMITE = SDTIME(1:19)//'.TITE'        
      CALL JEVEUO(TIMPAS,'L',JTPAS)
      CALL JEVEUO(TIMITE,'L',JTITE)
C
C --- TEMPS RESTANT
C      
      TPSRST = ZR(JTPAS+1-1) 
C
C --- TEMPS MOYENS
C
      MOYITE = ZR(JTITE+4-1)
      MOYPAS = ZR(JTPAS+4-1)
C
C --- RECUPERE LES CODES ERREURS ACTIFS
C      
      CALL NMERGE(SDERRO,'GET','LDC',ECHLDC)  
      CALL NMERGE(SDERRO,'GET','PIL',ECHPIL) 
      CALL NMERGE(SDERRO,'GET','CC1',ECHCO1) 
      CALL NMERGE(SDERRO,'GET','CC2',ECHCO2) 
      CALL NMERGE(SDERRO,'GET','FAC',ECHEQU)
      CALL NMERGE(SDERRO,'GET','TIN',MTCPUI)
      CALL NMERGE(SDERRO,'GET','TIP',MTCPUP)
      CALL NMERGE(SDERRO,'GET','ITX',ITEMAX)
      CALL NMERGE(SDERRO,'GET','CCC',ECHCCC)
      CALL NMERGE(SDERRO,'GET','ALL',LFATAL)
C
C --- AFFICHAGE
C
      IF (LFATAL) THEN
        CALL U2MESS('I','MECANONLINE2_1')
      ENDIF
C
C --- LANCEE EXCEPTIONS
C
      IF (MTCPUI) THEN
        ITAB(1) = NUMINS
        RTAB(1) = MOYITE
        RTAB(2) = TPSRST
        CALL UTEXCM(28,'DISCRETISATION2_79',0,K8BID,1,ITAB  ,2,RTAB)
      ELSE IF (MTCPUP) THEN
        ITAB(1) = NUMINS
        RTAB(1) = MOYPAS
        RTAB(2) = TPSRST
        CALL UTEXCM(28,'DISCRETISATION2_80',0,K8BID,1,ITAB  ,2,RTAB)
      ELSE IF (ECHLDC) THEN
        CALL UTEXCP(23,'COMPOR1_9')
      ELSE IF (ECHEQU) THEN
        CALL UTEXCP(25,'MECANONLINE_82')
      ELSE IF (ECHCO1) THEN
        CALL UTEXCP(26,'CONTACT2_1')
      ELSE IF (ECHCO2) THEN
        CALL UTEXCP(27,'CONTACT2_2')
      ELSE IF (ITEMAX) THEN
        CALL UTEXCP(22,'MECANONLINE_83')
      ELSE IF (ECHPIL) THEN
        CALL UTEXCP(29,'MECANONLINE_84')
      ELSE IF (ECHCCC) THEN
        CALL UTEXCP(30,'MECANONLINE_86')
      ENDIF
C
      CALL JEDEMA()
C   
      END
