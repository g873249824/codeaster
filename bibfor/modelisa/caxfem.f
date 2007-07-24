      SUBROUTINE CAXFEM(FONREE,CHAR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 23/07/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      CHARACTER*8 CHAR
      CHARACTER*4 FONREE
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION - AFFE_CHAR_MECA)
C
C CREER LES RELATIONS LIN�AIRES QUI ANNULENT LES DDLS EN TROP
C
C ----------------------------------------------------------------------
C
C
C IN  FONREE : FONC OU REEL SUIVANT L'OPERATEUR
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
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
      INTEGER      NFISMX
      PARAMETER    (NFISMX=100)
      CHARACTER*8  FISS(NFISMX)
C  
      INTEGER      IBID,IER,I
      INTEGER      NFISS,NREL
      INTEGER      JFISS,JSTANO,JNFIS,JXC
      CHARACTER*24 GRMA,GRNO
      CHARACTER*19 CHS,LISREL
      CHARACTER*8  REP
      CHARACTER*8  NOMA,NOMO,SDCONT
      LOGICAL      LCONTX
      CHARACTER*24 MODCON
      INTEGER      JMOCO
      CHARACTER*16 VALK(2)
      CHARACTER*8  MODELX  
      CHARACTER*24 XNRELL,XNBASC
      INTEGER      JXNREL,JXNBAS      
      CHARACTER*19 NLISEQ,NLISRL,NLISCO,NBASCO           
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

      IF (FONREE.NE.'REEL') GOTO 9999

      CALL GETVTX(' ','LIAISON_XFEM',0,1,1,REP,IBID)
      IF (REP.EQ.'NON') GOTO 9999
C
C --- MAILLAGE ET MODELE
C
      CALL DISMOI('F','NOM_MODELE',CHAR(1:8),'CHARGE',IBID,NOMO,IER)
      CALL DISMOI('F','NOM_MAILLA',NOMO,'MODELE',IBID,NOMA,IER)
C
C --- ACCES A LA SD FISSURE
C
      CALL JEEXIN(NOMO(1:8)//'.FISS',IER)
C      
      IF (IER.EQ.0) THEN
        VALK(1) = NOMO
        CALL U2MESK('F','XFEM2_12',1,VALK) 
      ENDIF
C      
      CALL JEVEUO(NOMO(1:8)//'.FISS','L',JFISS)
      CALL JEVEUO(NOMO(1:8)//'.NFIS','L',JNFIS)
      NFISS = ZI(JNFIS)
C      
      IF (NFISS .GT. NFISMX) THEN
        CALL U2MESI ('F', 'XFEM_2', 1, NFISMX)
      ENDIF
C      
C --- ACCES SD_CONTACT SI LIAISON CONTACT
C
      CALL JEVEUO(NOMO(1:8)//'.XFEM_CONT'  ,'L',JXC)
      LCONTX = ZI(JXC) .EQ. 1
      IF (LCONTX) THEN
        CALL GETVID(' ','CONTACT_XFEM',1,1,1,SDCONT,IER)
        IF (IER.EQ.0) THEN
          CALL U2MESS('F','XFEM2_7')
        ELSE
          MODCON = SDCONT(1:8)//'.CONTACT.MODELX'
          CALL JEVEUO(MODCON,'L',JMOCO)    
          MODELX        = ZK8(JMOCO)
          IF (MODELX.NE.NOMO) THEN
            VALK(1) = MODELX
            VALK(2) = SDCONT(1:8)
            CALL U2MESK('F','XFEM2_11',2,VALK)           
          ELSE 
            XNRELL = SDCONT(1:8)//'.CONTACT.XNRELL'
            XNBASC = SDCONT(1:8)//'.CONTACT.XNBASC'      
            CALL JEVEUO(XNRELL,'L',JXNREL)               
            CALL JEVEUO(XNBASC,'L',JXNBAS) 
          ENDIF           
        ENDIF
      ENDIF        
C
C --- INITIALISATIONS
C
      CHS    = '&&CAXFEM.CHS'
      LISREL = '&&CAXFEM.RLISTE'     
C
C --- BOUCLE SUR LES FISSURES
C
      DO 10 I = 1,NFISS
        FISS(I) = ZK8(JFISS-1 + I)
C
C --- TRANSFO EN CHAM_NO_S DU CHAM_NO POUR LE STATUT DES NOEUDS
C             
        CALL CNOCNS(FISS(I)//'.STNO','V',CHS)
        CALL JEVEUO(CHS(1:19)//'.CNSV','L',JSTANO)       
        NREL=0
C
C --- ON SUPPRIME LES DDLS HEAVISIDE ET CRACK TIP
C     
        GRMA = FISS(I)//'.MAILFISS  .HEAV'
        CALL XDELDL(NOMO,NOMA,GRMA,JSTANO,LISREL,NREL)
        GRMA = FISS(I)//'.MAILFISS  .CTIP'
        CALL XDELDL(NOMO,NOMA,GRMA,JSTANO,LISREL,NREL)
        GRMA = FISS(I)//'.MAILFISS  .HECT'
        CALL XDELDL(NOMO,NOMA,GRMA,JSTANO,LISREL,NREL)
        GRNO = FISS(I)//'.LISNOH'
        CALL XDELH(NOMO,NOMA,GRNO,LISREL,NREL)
C
C --- ON SUPPRIME LES DDLS DE CONTACT EN TROP
C    
        GRMA = FISS(I)//'.MAILFISS  .HEAV'
        CALL XDELCO(NOMO,FISS(I),GRMA  ,LISREL,NREL)
        GRMA = FISS(I)//'.MAILFISS  .CTIP'
        CALL XDELCO(NOMO,FISS(I),GRMA  ,LISREL,NREL)
        GRMA = FISS(I)//'.MAILFISS  .HECT'
        CALL XDELCO(NOMO,FISS(I),GRMA  ,LISREL,NREL)
C
C --- RELATIONS ENTRE LES INCONNUES DE CONTACT (POUR LA LBB)
C
        IF (LCONTX) THEN
          NBASCO = ZK24(JXNBAS+I-1)(1:19)
          NLISEQ = ZK24(JXNREL+3*(I-1)  )(1:19)
          NLISRL = ZK24(JXNREL+3*(I-1)+1)(1:19)
          NLISCO = ZK24(JXNREL+3*(I-1)+2)(1:19)
          CALL XRELCO(NOMA  ,NLISEQ,NLISRL,NLISCO,
     &                NBASCO,LISREL,NREL)        
        ENDIF
      
      
 10   CONTINUE  
C
C --- AFFECTATION DES RELATIONS LINEAIRES DANS LE LIGREL DE CHARGE
C
      IF (NREL.NE.0) THEN
        CALL AFLRCH(LISREL,CHAR)
      ENDIF  
C
9999  CONTINUE
      CALL JEDEMA()
      END
