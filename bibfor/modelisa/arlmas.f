      SUBROUTINE ARLMAS(MAIL  ,NOMARL,TYPMAI,MAILAR,NDIM  ,
     &                  NOM1  ,NOM2  ,IMA1  ,IMA2  ,NNEL  ,
     &                  CONNEX,LONCUM,COORD ,NORMAL,
     &                  IMAIL ,INOEU ,ITYTR3,ITYTE4,
     &                  TRAVR ,TRAVI ,TRAVL ,JTRAV ,NT    ,
     &                  NUMMAI,CXCUMU)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C
      IMPLICIT NONE   
      CHARACTER*16 TYPMAI
      CHARACTER*8  MAIL,MAILAR
      CHARACTER*8  NOMARL         
      CHARACTER*10 NOM1,NOM2   
      INTEGER      NDIM,NNEL
      INTEGER      CONNEX(*),LONCUM(*)
      REAL*8       COORD(3,*),NORMAL(NDIM,*) 
      INTEGER      IMAIL,INOEU  
      INTEGER      IMA1,IMA2
      INTEGER      ITYTR3,ITYTE4
      INTEGER      NT,NUMMAI,CXCUMU
      INTEGER      TRAVI(*)
      LOGICAL      TRAVL(*)
      REAL*8       TRAVR(*)   
      INTEGER      JTRAV  
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DU MAILLAGE INTERNE ARLEQUIN 
C COPIE MAILLES ISSUES DU DECOUPAGE DE 1 SUR 2
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM DU MAILLAGE
C IN  MAILAR : NOM DU PSEUDO-MAILLAGE ARLEQUIN
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  TYPMAI : SD CONTENANT NOM DES TYPES ELEMENTS (&&CATA.NOMTM)
C IN  NDIM   : NDIMNSION DU PROBLEME
C IN  NOM1   : NOM DU GROUPE ARLEQUIN DE LA MAILLE 1
C IN  IMA1   : INDEX MAILLE COURANTE DANS NOM1
C IN  NOM2   : NOM DU GROUPE ARLEQUIN DE LA MAILLE 2
C IN  IMA2   : INDEX MAILLE COURANTE DANS NOM2
C IN  NNEL   : NOMBRE DE NOEUDS PAR ELEMENT
C                3 EN 2D (DECOUPE EN TRIANGLES)
C                4 EN 3D (DECOUPE EN TETRA)
C IN  COORD  : COORDONNES DES MAILLES
C IN  CONNEX : CONNEXITE DES MAILLES
C IN  LONCUM : LONGUEUR CUMULEE DE CONNEX
C IN  NORMAL : NORMALES POUR LES COQUES
C IN  IMAIL  : NUMERO MAILLE COURANTE DANS PSEUDO-MAILLAGE
C IN  INOEU  : NUMERO NOEUD COURANT DANS PSEUDO-MAILLAGE
C IN  ITYTR3 : NUMERO D'ORDRE DE ELEMENT TRIA3 DANS &CATA.TM.NOMTM
C IN  ITYTE4 : NUMERO D'ORDRE DE ELEMENT TETRA4 DANS &CATA.TM.NOMTM
C IN  TRAVR  : VECTEURS DE TRAVAIL DE REELS 
C IN  TRAVI  : VECTEURS DE TRAVAIL D'ENTIERS  
C IN  TRAVL  : VECTEURS DE TRAVAIL DE BOOLEENS
C IN  JTRAV  : POINTEUR SUR TABLEAU POUR LES CONNECTIVITES DES
C              MAILLES DECOUPEES
C I/O CXCUMU : LONGUEUR CUMULEE DE LA CONNEXITE
C OUT NT     : NOMBRE DE TRIA/TETRA DANS L'INTERSECTION 
C OUT NUMMAI : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE 
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM,JEXNOM
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER       NNM
      PARAMETER     (NNM = 27)
C      
      INTEGER      IFM,NIV   
      INTEGER      IT,INO,IRET
      INTEGER      NUMMA1,NUMMA2
      CHARACTER*8  TM1,NOMMA1,TM2,NOMMA2
      REAL*8       H1,H2      
      INTEGER      NN1,NN2,CXMAX    
      REAL*8       NO1(3*NNM),NO2(3*NNM),X,Y,Z        
      CHARACTER*8  NOMND ,NOMEL ,K8BID
      INTEGER      INDABS,IELABS,INDND
      CHARACTER*24 COOVAL
      INTEGER      JCOOR ,JTYPM ,JGCNX   
      CHARACTER*24 MNOMN,MNOMM,MCONN,MTYPM 
      INTEGER      CNX(4)
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- NOMS POUR ACCES AU PSEUDO MAILLAGE
C
      MNOMN  = MAILAR(1:8)//'.NOMNOE         '   
      MNOMM  = MAILAR(1:8)//'.NOMMAI         '         
      MCONN  = MAILAR(1:8)//'.CONNEX         '  
      MTYPM  = MAILAR(1:8)//'.TYPMAIL        ' 
      COOVAL = MAILAR(1:8)//'.COORDO    .VALE' 
C
C --- ACCES AUX OBJETS 
C 
      CALL JEVEUO(COOVAL,'E',JCOOR)       
      CALL JEVEUO(MTYPM ,'E',JTYPM)       
      CALL JELIRA(MCONN,'LONT',CXMAX,K8BID)      
C
C --- INFOS ET COORD. SOMMETS DE LA MAILLE M1
C                   
      CALL ARLGRC(MAIL     ,TYPMAI   ,NOM1     ,NDIM  ,IMA1 ,
     &            CONNEX   ,LONCUM   ,COORD    ,NORMAL,
     &            NUMMA1   ,NOMMA1   ,TM1      ,H1       ,
     &            NN1      ,NO1)                    
C
C --- INFOS ET COORD. SOMMETS DE LA MAILLE M2
C                         
      CALL ARLGRC(MAIL     ,TYPMAI   ,NOM2     ,NDIM  ,IMA2 ,
     &            CONNEX   ,LONCUM   ,COORD    ,NORMAL,
     &            NUMMA2   ,NOMMA2   ,TM2      ,H2       ,
     &            NN2      ,NO2)       
C
C --- CALCUL INTERSECTION PAR DECOUPE
C
      CALL INTMAM(NDIM  ,NOMARL,
     &            NOMMA1,TM1   ,NO1  ,NN1   ,H1    ,
     &            NOMMA2,TM2   ,NO2  ,NN2   ,H2    ,
     &            TRAVR ,TRAVI ,TRAVL,NT)
C
C --- INDICE DES NOEUDS DANS LE MAILLAGE
C            
      IF (NT.EQ.0) THEN
        GOTO 999
      ENDIF 
C
      NUMMAI = NUMMA2              
C
      INDND  = 1         
      DO 90 IT = 1, NT
C
C --- CONNEX INITIAL
C
        CNX(1) = TRAVI(NNEL*(IT-1)+1)
        CNX(2) = TRAVI(NNEL*(IT-1)+2)
        CNX(3) = TRAVI(NNEL*(IT-1)+3)
        CNX(4) = TRAVI(NNEL*(IT-1)+4)   
C
        DO 100 INO = 1,NNEL
C
C --- INDICE ABSOLU DU NOEUD DANS LE MAILLAGE
C      
          INDABS    = INOEU+INDND-1
C
C --- TABLE DE CORRESPONDANCE
C          
          ZI(JTRAV+CNX(INO)-1) = INDABS     
C
C --- GENERATION DU NOM DU NOEUD
C                           
          CALL CODENT(INDABS,'D0',NOMND(2:8))   
          NOMND(1:1) = 'N'      
C
C --- COORDONNEES DU NOEUD
C                    
          X = TRAVR(NDIM*(CNX(INO)-1)+1)
          Y = TRAVR(NDIM*(CNX(INO)-1)+2)
          IF (NDIM.EQ.2) THEN
            Z = 0.D0
          ELSE  
            Z = TRAVR(NDIM*(CNX(INO)-1)+3)
          ENDIF       
C
C --- SAUVEGARDE CORDONNEES
C
          ZR(JCOOR+3*(INDABS-1)+1-1) = X
          ZR(JCOOR+3*(INDABS-1)+2-1) = Y
          IF (NDIM.EQ.3) THEN
            ZR(JCOOR+3*(INDABS-1)+3-1) = Z
          ENDIF  
C      
C --- CREATION DU NOM DU NOEUD
C
          CALL JEEXIN(JEXNOM(MNOMN,NOMND),IRET)
          IF (IRET.EQ.0) THEN
            CALL JECROC(JEXNOM(MNOMN,NOMND))
          ELSE
            CALL U2MESK('F','MODELISA7_10',1,NOMND)
          ENDIF                  
C
C --- NOEUD SUIVANT
C 
          INDND = INDND + 1
C                   
  100   CONTINUE
  90  CONTINUE  
C
C --- AJOUT DES ELEMENTS
C 
      DO 91 IT = 1, NT   
C
C --- INDICE ABSOLU DE L'ELEMENT DANS LE MAILLAGE
C
        IELABS = IMAIL+IT-1       
C
C --- GENERATION DU NOM DE L'ELEMENT
C      
        NOMEL(1:8) = 'M       '                       
        CALL CODENT(IELABS,'D0',NOMEL(2:8))         
C      
C --- CREATION DU NOM DE L'ELEMENT
C
        CALL JEEXIN(JEXNOM(MNOMM,NOMEL),IRET)
        IF (IRET.EQ.0) THEN
          CALL JECROC(JEXNOM(MNOMM,NOMEL))
        ELSE
          CALL U2MESK('F','MODELISA7_10',1,NOMEL)
        ENDIF
C                    
C --- TYPE
C   
        IF (NDIM.EQ.2) THEN
          ZI(JTYPM+IMAIL+IT-2)  = ITYTR3
        ELSEIF (NDIM.EQ.3) THEN
          ZI(JTYPM+IMAIL+IT-2)  = ITYTE4
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C      
C --- CONNECTIVITE  
C
        CNX(1) = TRAVI(NNEL*(IT-1)+1)
        CNX(2) = TRAVI(NNEL*(IT-1)+2)
        CNX(3) = TRAVI(NNEL*(IT-1)+3)
        CNX(4) = TRAVI(NNEL*(IT-1)+4)      
C     
        CXCUMU = CXCUMU + NNEL
      
        IF (CXCUMU.GT.CXMAX) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL JEECRA(JEXNUM(MCONN,IELABS),'LONMAX',NNEL,' ')      
        CALL JEVEUO(JEXNUM(MCONN,IELABS),'E',JGCNX)
        DO 51 INO = 1,NNEL
          INDABS = ZI(JTRAV+CNX(INO)-1)     
          ZI(JGCNX+INO-1) = INDABS
 51     CONTINUE   
  91  CONTINUE
C
  999 CONTINUE
C
      CALL JEDEMA()

      END
