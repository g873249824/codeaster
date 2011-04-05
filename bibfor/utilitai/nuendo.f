      SUBROUTINE NUENDO(NUMEDD,COMPOR,SDNURO)
C      
C            
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 15/02/2011   AUTEUR FLEJOU J-L.FLEJOU 
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
C
      IMPLICIT NONE
      CHARACTER*24 NUMEDD,COMPOR
      CHARACTER*24 SDNURO
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C CREATION DE LA SD POUR ELEMENTS DE STRUCTURES EN GRANDES ROTATIONS
C      
C ----------------------------------------------------------------------
C
C      
C CREATION DE LA S.D. DE NOM SDNURO QUI INDIQUE QUELLES SONT LES   
C ADRESSES DANS L'OBJET .VALE D'UN CHAM_NO S'APPUYANT SUR NUMEDD   
C DES ROTATIONS DRX, DRY, DRZ DES NOEUDS DES MAILLES 
C
C IN  NUMEDD : NOM DE LA NUMEROTATION 
C IN  COMPOR : NOM DE LA CARTE COMPOR         
C IN  SDNURO : NOM DE LA S.D. NUME_DDL_ROTA        
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32       JEXNUM,JEXNOM
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
      INTEGER       DG
      CHARACTER*8   NOCMP, NOMGD, MODELE, NOMA, K8BID
      CHARACTER*16  COMPT,NOMTE
      CHARACTER*19  LIGRMO
      CHARACTER*24  NOLILI,NOLIEL
      LOGICAL       EXISDG
      INTEGER       NEC,NBMA,NBNOEU,NGDMAX,NCMPMX
      INTEGER       NLILI,NBNO,NEQUA,NBNOC
      INTEGER       IER,IRET,IBID,ICO
      INTEGER       IMA,IGD,INO,IDEBGD,IDRZ,INDIK8,I,K,INOC,IVAL,IADG
      INTEGER       ITRAV,IDESC,IVALE,IPTMA,ICONEX,NBELEM
      INTEGER       INDRO,IANCMP,IANUEQ,IAPRNO
      INTEGER       IFM,NIV,NBGR,IGR,TE,TYPELE,NBELGR,LIEL,IEL,NBGREL
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      NOMGD  = 'COMPOR  '
C
      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,K8BID,IER)
      
      CALL ASSERT (NEC.LE.1)
C
C --- MODELE ASSOCIE AU NUME_DDL 
C
      CALL DISMOI('F','NOM_MODELE',NUMEDD,'NUME_DDL',IBID,MODELE,IER)
C
C --- NOM DU MAILLAGE 
C
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IER)
C
C --- NOMBRE DE MAILLES DU MAILLAGE 
C
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IER)
C
C --- NOMBRE DE NOEUDS DU MAILLAGE 
C
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNOEU,K8BID,IER)
C
      LIGRMO = MODELE//'.MODELE'
C
C --- CREATION DU TABLEAU DESCRIPTEUR DE LA CARTE COMPOR 
C
      CALL ETENCA(COMPOR,LIGRMO,IRET  )
      CALL ASSERT(IRET.EQ.0)
C
C --- CREATION D'UN VECTEUR DESTINE A CONTENIR LES NUMEROS 
C --- DES NOEUDS EN GRANDES ROTATIONS                      
C
      CALL WKVECT('&&NUROTB.NOEUDS.GR','V V I',NBNOEU,ITRAV)
C
C --- RECUPERATION DE LA GRANDEUR (ICI COMPOR)  
C --- REFERENCEE PAR LA CARTE COMPOR           
C
      CALL JEVEUO(COMPOR(1:19)//'.DESC','L',IDESC)
      NGDMAX = ZI(IDESC+2-1)
C
C --- NOMBRE DE COMPOSANTES ASSOCIEES A LA GRANDEUR  
C
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'LONMAX',NCMPMX,K8BID)
C
C --- TABLEAU DE VALEURS DE LA CARTE COMPOR     
C --- (CONTENANT LES VALEURS DU COMPORTEMENT)  
C
      CALL JEVEUO(COMPOR(1:19)//'.VALE','L',IVALE)
C
C --- RECUPERATION DU VECTEUR D'ADRESSAGE DANS LA CARTE  
C --- CREE PAR ETENCA                                   
C
      CALL JEVEUO(COMPOR(1:19)//'.PTMA','L',IPTMA)
C
C --- AFFECTATION DU TABLEAU DES NOEUDS EN GRANDES ROTATIONS  
C
      NBGR = NBGREL(LIGRMO)
      NOLIEL = LIGRMO//'.LIEL'
      DO 140 IGR = 1,NBGR
        TE = TYPELE(LIGRMO,IGR)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)
        IF (NOMTE.EQ.'MNDPTR6' .OR. NOMTE.EQ.'MNDPQS8' .OR.
     &      NOMTE.EQ.'MNAXTR6' .OR. NOMTE.EQ.'MNAXQS8' .OR.
     &      NOMTE.EQ.'MNVG_HEXA20' .OR. 
     &      NOMTE.EQ.'MNVG_TETRA10' .OR.
     &      NOMTE.EQ.'MNVG_PENTA15') THEN
     
            NBELGR = NBELEM(LIGRMO,IGR)
            CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
            DO 130 IEL = 1,NBELGR
               IMA = ZI(LIEL-1+IEL)
               IF (ZI(IPTMA+IMA-1).NE.0) THEN
                 
                  IGD   = ZI(IPTMA+IMA-1)
                  IDEBGD = (IGD-1)*NCMPMX
                  DG = ZI(IDESC+3+2*NGDMAX+ZI(IPTMA+IMA-1)-1)
C
C ---     ON S'ASSURE QUE LA PREMIERE COMPOSANTE DE LA GRANDEUR
C ---     QUI EST RELCOM A BIEN ETE AFFECTEE
C
                  CALL ASSERT (EXISDG(DG,1))
C ---     RECUPERATION DU COMPORTEMENT AFFECTE A LA MAILLE
                  COMPT = ZK16(IVALE+IDEBGD+3-1)
                  
                  IF ( COMPT .NE. 'PETIT' ) GOTO 130
                  
C ---     RECUPERATION DES NUMEROS DES NOEUDS DE LA MAILLE
                  CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',IMA),'L',ICONEX)
                  CALL JELIRA(JEXNUM(NOMA//'.CONNEX',IMA),'LONMAX',
     &                   NBNO,K8BID)
                  DO 20 INO = 1, NBNO
                     ZI(ITRAV+ZI(ICONEX+INO-1)-1) = 1
  20              CONTINUE
               ENDIF
 130        CONTINUE
         ENDIF
 140  CONTINUE
C
C --- NOMBRE DE NOEUDS EN GRANDES ROTATIONS  ---
C
      NBNOC = 0
      DO 30 INO = 1, NBNOEU
         IF (ZI(ITRAV+INO-1).EQ.1) THEN
             NBNOC = NBNOC + 1
         ENDIF
  30  CONTINUE
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION SD DDLS EN '//
     &                ' GRANDES ROTATIONS',NBNOC
      ENDIF  
C
C --- CREATION DU TABLEAU DES NUMEROS D'EQUATIONS CORRESPONDANT   ---
C --- AUX DDLS DE ROTATION POUR LES NOEUDS EN GRANDES ROTATIONS   ---
C
C --- RECUPERATION DU NOMBRE D'INCONNUES DU MODELE  ---
      CALL JELIRA(NUMEDD(1:14)//'.NUME.NUEQ','LONUTI',NEQUA,K8BID)
      
      IF (NBNOC.GT.0) THEN
        CALL WKVECT(SDNURO,'V V I',NEQUA,INDRO)
      ELSE
        GOTO 9999
      ENDIF
C
      NOMGD = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,K8BID,IER)
C
C --- NOMBRE DE COMPOSANTES ASSOCIEES A LA GRANDEUR DEPL_R ---
C
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'LONMAX',NCMPMX,K8BID)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMGD),'L',IANCMP)
C
      NOCMP = 'DAMG'
C
C --- LOCALISATION DE DRZ DANS LA LISTE DES DDLS ASSOCIES  ---
C ---  A LA GRANDEUR DEPL_R                                ---
C
      IDRZ = INDIK8(ZK8(IANCMP),NOCMP,1,NCMPMX)
      IF (IDRZ.EQ.0) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- RECUPERATION DU .PRNO ASSOCIE AU MAILLAGE  ---
C
      CALL JELIRA(NUMEDD(1:14)//'.NUME.PRNO','NMAXOC',NLILI,K8BID)
      K = 0
      DO 40 I = 1, NLILI
         CALL JENUNO(JEXNUM(NUMEDD(1:14)//'.NUME.LILI',I),NOLILI)
         IF (NOLILI(1:8).NE.'&MAILLA ') GOTO 40
         K = I
  40  CONTINUE
      CALL ASSERT (K.NE.0)

      CALL JEVEUO(JEXNUM(NUMEDD(1:14)//'.NUME.PRNO',K),'L',IAPRNO)
C
C --- TABLEAU DES NUMEROS D'EQUATIONS  ---
C
      CALL JEVEUO(NUMEDD(1:14)//'.NUME.NUEQ','L',IANUEQ)
C
C --- AFFECTATION DU TABLEAU DES NUMEROS DES INCONNUES ROTATIONS  ---
C --- DES NOEUDS EN GRANDES ROTATIONS                             ---
C      
      INOC = 0
      DO 50 INO = 1, NBNOEU
         IF (ZI(ITRAV+INO-1).EQ.0) GOTO 50
         INOC = INOC + 1
C ---  IVAL  : ADRESSE DU DEBUT DU NOEUD INO DANS .NUEQ
         IVAL = ZI(IAPRNO+(INO-1)*(NEC+2)+1-1)
C ---  NCMP  : NOMBRE DE COMPOSANTES SUR LE NOEUD INO
C ---  IADG  : DEBUT DU DESCRIPTEUR GRANDEUR DU NOEUD INO
         IADG = IAPRNO+(INO-1)*(NEC+2)+3-1
C
C         DO 60 I = IDRZ-2, IDRZ
         DO 60 I = IDRZ, IDRZ
           IF (.NOT.EXISDG(ZI(IADG),I)) THEN
C             CALL ASSERT(.FALSE.)
             GOTO 50
           ENDIF
  60     CONTINUE
         ICO = 0
C         DO 70 I = 1, IDRZ-3
         DO 70 I = 1, IDRZ-1
           IF (EXISDG(ZI(IADG),I)) THEN
             ICO = ICO + 1
           ENDIF
  70     CONTINUE
C
         ZI(INDRO-1+IVAL-1+ICO+1) = 1
C         ZI(INDRO-1+IVAL-1+ICO+2) = 1
C         ZI(INDRO-1+IVAL-1+ICO+3) = 1
     
  50  CONTINUE
C
      CALL JEDETC('V','&&NUROTB',1)
C
9999  CONTINUE
C
      CALL JEDEMA()
      END
