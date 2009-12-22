      SUBROUTINE NDMUAP(NUMINS,NUMEDD,SDDYNA,SDDISC)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21 CRP_20
C
      IMPLICIT NONE
      INTEGER      NUMINS
      CHARACTER*24 NUMEDD
      CHARACTER*19 SDDYNA,SDDISC
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (DYNAMIQUE)
C
C INITIALISATION DES CHAMPS D'ENTRAINEMENT EN MULTI-APPUI
C      
C ----------------------------------------------------------------------
C
C    
C IN  NUMEDD : NUME_DDL
C IN  NUMINS : NUMERO INSTANT COURANT
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDDYNA : SD DYNAMIQUE 
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      REAL*8       ZERO
      PARAMETER    (ZERO = 0.D0)
C      
      INTEGER      IRET,NEQ,IE,IEX
      CHARACTER*8  K8BID
      REAL*8       DIINST,INSTAP
      REAL*8       COEF1,COEF2,COEF3
      CHARACTER*19 DEPENT,VITENT,ACCENT
      INTEGER      JDEPEN,JVITEN,JACCEN
      CHARACTER*19 MAFDEP,MAFVIT,MAFACC,MAMULA,MAPSID      
      INTEGER      JNODEP,JNOVIT,JNOACC,JMLTAP,JPSDEL  
      INTEGER      NDYNIN,NBEXCI      
      INTEGER      IFM,NIV         
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... INIT. MULTI-APPUI' 
      ENDIF
C
C --- INITIALISATIONS
C
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
      NBEXCI = NDYNIN(SDDYNA,'NBRE_EXCIT')
      INSTAP = DIINST(SDDISC,NUMINS)      
C
C --- ACCES SD MULTI-APPUI
C 
      CALL NDYNKK(SDDYNA,'MUAP_MAFDEP',MAFDEP)
      CALL NDYNKK(SDDYNA,'MUAP_MAFVIT',MAFVIT)
      CALL NDYNKK(SDDYNA,'MUAP_MAFACC',MAFACC)
      CALL NDYNKK(SDDYNA,'MUAP_MAMULA',MAMULA)
      CALL NDYNKK(SDDYNA,'MUAP_MAPSID',MAPSID)
C
      CALL JEVEUO(MAFDEP,'L',JNODEP)
      CALL JEVEUO(MAFVIT,'L',JNOVIT)
      CALL JEVEUO(MAFACC,'L',JNOACC)
      CALL JEVEUO(MAMULA,'L',JMLTAP)
      CALL JEVEUO(MAPSID,'L',JPSDEL)       
C
C --- ACCES DEPL/VITE/ACCE ENTRAINEMENT
C      
      CALL NDYNKK(SDDYNA,'DEPENT',DEPENT)
      CALL NDYNKK(SDDYNA,'VITENT',VITENT)
      CALL NDYNKK(SDDYNA,'ACCENT',ACCENT)
      CALL JEVEUO(DEPENT(1:19)//'.VALE','E',JDEPEN)
      CALL JEVEUO(VITENT(1:19)//'.VALE','E',JVITEN)
      CALL JEVEUO(ACCENT(1:19)//'.VALE','E',JACCEN)
C
C --- EVALUATION DEPL/VITE/ACCE ENTRAINEMENT 
C 
      CALL R8INIR(NEQ,ZERO,ZR(JDEPEN),1)
      CALL R8INIR(NEQ,ZERO,ZR(JVITEN),1)
      CALL R8INIR(NEQ,ZERO,ZR(JACCEN),1)
         
      DO 910 IEX = 1,NBEXCI
        IF (ZI(JMLTAP+IEX-1).EQ.1) THEN
          CALL FOINTE('F ',ZK8(JNODEP+IEX-1),1,'INST',INSTAP,COEF1,IE)
          CALL FOINTE('F ',ZK8(JNOVIT+IEX-1),1,'INST',INSTAP,COEF2,IE)
          CALL FOINTE('F ',ZK8(JNOACC+IEX-1),1,'INST',INSTAP,COEF3,IE)
        ELSE
          COEF1  = ZERO
          COEF2  = ZERO
          COEF3  = ZERO
        ENDIF
        DO 810 IE = 1,NEQ
          ZR(JDEPEN+IE-1) = ZR(JDEPEN+IE-1)+
     &                      ZR(JPSDEL+(IEX-1)*NEQ+IE-1)*COEF1
          ZR(JVITEN+IE-1) = ZR(JVITEN+IE-1)+
     &                      ZR(JPSDEL+(IEX-1)*NEQ+IE-1)*COEF2
          ZR(JACCEN+IE-1) = ZR(JACCEN+IE-1)+
     &                      ZR(JPSDEL+(IEX-1)*NEQ+IE-1)*COEF3   
 810    CONTINUE
 910  CONTINUE
C
C --- AFFICHAGE
C 
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... DEPL. ENTRAINEMENT'
        CALL NMDEBG('VECT',DEPENT,IFM)  
        WRITE (IFM,*) '<MECANONLINE> ...... VITE. ENTRAINEMENT'
        CALL NMDEBG('VECT',VITENT,IFM) 
        WRITE (IFM,*) '<MECANONLINE> ...... ACCE. ENTRAINEMENT' 
        CALL NMDEBG('VECT',ACCENT,IFM) 
      ENDIF     
C    
      CALL JEDEMA()

      END
