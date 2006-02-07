      SUBROUTINE PRCYCB(NOMRES,SOUMAT,REPMAT)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/02/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C TOLE CRP_20
C***********************************************************************
C  P. RICHARD     DATE 11/03/91
C-----------------------------------------------------------------------
C  BUT : < PROJECTION CYCLIQUE CRAIG-BAMPTON >
C
C        PROJETER LES MATRICES MASSE ET RAIDEUR ET SORTIR LES SOUS
C        MATRICES POUR TRAITER LE CAS CYCLIQUE AVEC INTERFACES
C        DE CRAIG BAMPTON (CF RAPPORT)
C
C  PARTICULARITES:
C
C  LES MATRICES ISSUES DES PRODUITS MODES-MATRICES-MODES SONT
C  DIAGONALES, ICI ELLES SONT CONSIDEREES PLEINES ET CALCULEES
C  PAR PROJECTION, LA METHODE OBTENUE RESTE AINSI EXACTE SI
C  LES MODES PROPRES DU SECTEUR N'ONT PAS BIEN CONVERGE
C
C  LES MATRICES ISSUES DES PRODUITS DEFORMEES-RAIDEURS-DEFORMEES
C  SONT NULLES POUR LA METHODE DE CRAIG-BAMPTON AVEC MODES
C  CONTRAINTS STATIQUES MAS PAS AVEC DES MODES CONTRAINTS
C  HARMONIQUES, ELLES SONT DONC SYSTEMATIQUEMENT CALCULEES
C  ICI ET ASSEMBLEES APRES
C
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM UTILISATEUR DU RESULTAT
C SOUMAT /I/ : NOM K24 DE LA FAMILLE DES SOUS-MATRICES
C REPMAT /I/ : NOM K24 DU REPERTOIRE DES NOMS DES SOUS-MATRICES
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNOM, JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*6  PGC
      CHARACTER*8  NOMRES,BASMOD,MAILLA,INTF,KBID,K8BID
      CHARACTER*14 NUM
      CHARACTER*19 RAID,MASS
      CHARACTER*24 REPMAT,SOUMAT,NOEINT,CHAMVA
      CHARACTER*1  K1BID
      REAL*8       TPS1(4),TPS2(4)
C
C-----------------------------------------------------------------------
      DATA PGC /'PRCYCB'/
C-----------------------------------------------------------------------
C
C --- RECUPERATION DES CONCEPTS AMONT
C
      CALL JEMARQ()
      CALL JEVEUO(NOMRES//'.CYCL_REFE','L',LLREF1)
      INTF  =ZK24(LLREF1+1)
      BASMOD=ZK24(LLREF1+2)
      CALL JELIBE(NOMRES//'.CYCL_REFE')
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF2)
      RAID=ZK24(LLREF2)
      MASS=ZK24(LLREF2+1)
      CALL JELIBE(BASMOD//'           .REFD')
C
C --- RECUPERATION DES DIMENSIONS DU PROBLEME GENERALISE
C
      CALL JEVEUO(NOMRES//'.CYCL_DESC','L',LLDESC)
      NBMOD=ZI(LLDESC)
      NBDDR=ZI(LLDESC+1)
      NBDGA=NBDDR
      NBDAX=ZI(LLDESC+2)
      CALL JELIBE(NOMRES//'.CYCL_DESC')
C
C --- RECUPERATION DES NUMEROS INTERFACE DROITE ET GAUCHE
C
      CALL JEVEUO(NOMRES//'.CYCL_NUIN','L',LLNIN)
      NUMD=ZI(LLNIN)
      NUMG=ZI(LLNIN+1)
      NUMA=ZI(LLNIN+2)
C
C --- ALLOCATION DU REPERTOIRE DES NOMS DES SOUS-MATRICES
C
      IF(NBDAX.GT.0) THEN
        NBSMA=24
      ELSE
        NBSMA=10
      ENDIF
C
      CALL JECREO(REPMAT,'V N K8')
      CALL JEECRA(REPMAT,'NOMMAX',NBSMA,' ')
C
C --- CREATION DE LA FAMILLE DES SOUS-MATRICES
C
      CALL JECREC(SOUMAT,'V V R','NU','DISPERSE','VARIABLE',
     &             NBSMA)
C
C --- ALLOCATION DES MATRICES
C
C --- STOCKAGE DIAGONAL
C
      NTAIL=NBMOD*(NBMOD+1)/2
C
      CALL JECROC(JEXNOM(REPMAT,'K0II'))
      CALL JENONU(JEXNOM(REPMAT,'K0II'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'M0II'))
      CALL JENONU(JEXNOM(REPMAT,'M0II'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
C --- STOCKAGE PLEIN
C
      NTRIAN=NBDDR*(NBDDR+1)/2
      NTAIL=NBDDR*NBDDR
C
      CALL JECROC(JEXNOM(REPMAT,'K0JJ'))
      CALL JENONU(JEXNOM(REPMAT,'K0JJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTRIAN,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'KPLUSJJ'))
      CALL JENONU(JEXNOM(REPMAT,'KPLUSJJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'K0IJ'))
      CALL JENONU(JEXNOM(REPMAT,'K0IJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDDR,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'KPLUSIJ'))
      CALL JENONU(JEXNOM(REPMAT,'KPLUSIJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDDR,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'M0JJ'))
      CALL JENONU(JEXNOM(REPMAT,'M0JJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTRIAN,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'MPLUSJJ'))
      CALL JENONU(JEXNOM(REPMAT,'MPLUSJJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'M0IJ'))
      CALL JENONU(JEXNOM(REPMAT,'M0IJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDDR,' ')
C
      CALL JECROC(JEXNOM(REPMAT,'MPLUSIJ'))
      CALL JENONU(JEXNOM(REPMAT,'MPLUSIJ'),IBID)
      CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDDR,' ')
C
      IF(NBDAX.GT.0) THEN
C
        NTAIL=NBDDR*NBDAX
C
        CALL JECROC(JEXNOM(REPMAT,'K0AJ'))
        CALL JENONU(JEXNOM(REPMAT,'K0AJ'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'K0AA'))
        CALL JENONU(JEXNOM(REPMAT,'K0AA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBDAX**2,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'KPLUSAA'))
        CALL JENONU(JEXNOM(REPMAT,'KPLUSAA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBDAX**2,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'KPLUSIA'))
        CALL JENONU(JEXNOM(REPMAT,'KPLUSIA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDAX,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'KPLUSJA'))
        CALL JENONU(JEXNOM(REPMAT,'KPLUSJA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'KPLUSAJ'))
        CALL JENONU(JEXNOM(REPMAT,'KPLUSAJ'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'K0IA'))
        CALL JENONU(JEXNOM(REPMAT,'K0IA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDAX,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'M0IA'))
        CALL JENONU(JEXNOM(REPMAT,'M0IA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDAX,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'MPLUSIA'))
        CALL JENONU(JEXNOM(REPMAT,'MPLUSIA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBMOD*NBDAX,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'M0AJ'))
        CALL JENONU(JEXNOM(REPMAT,'M0AJ'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'MPLUSAJ'))
        CALL JENONU(JEXNOM(REPMAT,'MPLUSAJ'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'MPLUSJA'))
        CALL JENONU(JEXNOM(REPMAT,'MPLUSJA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NTAIL,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'M0AA'))
        CALL JENONU(JEXNOM(REPMAT,'M0AA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBDAX**2,' ')
C
        CALL JECROC(JEXNOM(REPMAT,'MPLUSAA'))
        CALL JENONU(JEXNOM(REPMAT,'MPLUSAA'),IBID)
        CALL JEECRA(JEXNUM(SOUMAT,IBID),'LONMAX',NBDAX**2,' ')
C
      ENDIF
C
C --- ALLOCATION DES TABLEAUX DE TRAVAIL
C
      CALL WKVECT('&&'//PGC//'.ORD.DROIT','V V I',NBDDR,LTORD)
      CALL WKVECT('&&'//PGC//'.ORD.GAUCH','V V I',NBDDR,LTORG)
      IF(NBDAX.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.ORD.AXE','V V I',NBDAX,LTORA)
      ENDIF
     
C
C --- RECUPERATION NUMEROTATION ET NB EQUATIONS
C
      CALL DISMOI('F','NB_EQUA',RAID,'MATR_ASSE',NEQ,K8BID,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',RAID,'MATR_ASSE',IBID,NUM,IRET)
      CALL JEVEUO(NUM//'.NUME.DEEQ','L',IDDEEQ)
C
C --- RECUPERATION DU NOMBRE DE NOEUDS DES INTERFACES
C
      NOEINT=INTF//'.IDC_LINO'
C
      CALL JELIRA(JEXNUM(NOEINT,NUMD),'LONMAX',NBNOD,K1BID)
      CALL JEVEUO(JEXNUM(NOEINT,NUMD),'L',LLNOD)
C
      CALL JELIRA(JEXNUM(NOEINT,NUMG),'LONMAX',NBNOG,K1BID)
      CALL JEVEUO(JEXNUM(NOEINT,NUMG),'L',LLNOG)
C
      IF(NBDAX.GT.0) THEN
        CALL JELIRA(JEXNUM(NOEINT,NUMA),'LONMAX',NBNOA,K1BID)
        CALL JEVEUO(JEXNUM(NOEINT,NUMA),'L',LLNOA)
      ENDIF
C
C --- RECUPERATION DU NOMBRE DE SECTEURS
C
      CALL JEVEUO(NOMRES//'.CYCL_NBSC','L',LLNOMS)
      NBSEC=ZI(LLNOMS)
      CALL JELIBE(NOMRES//'.CYCL_NBSC')
C
C --- RECUPERATION DES NUMEROS D'ORDRE DES DEFORMEES
C
C --- RECUPERATION DES DEFORMEES DES NOEUDS DROITE
C
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'        ',NUMD,NBDDR,ZI(LTORD),IBID)
C
C --- RECUPERATION DES DEFORMEES DES NOEUDS GAUCHE
C
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'        ',NUMG,NBDDR,ZI(LTORG),IBID)
C
C --- RECUPERATION DES DEFORMEES EVENTUELLES DES NOEUDS D'AXE
C
      IF(NBDAX.GT.0) THEN
        KBID=' '
        CALL BMNODI(BASMOD,KBID,'        ',NUMA,NBDAX,ZI(LTORA),IBID)
      ENDIF
C


C --- CALCUL DES MATRICES TETA DE CHANGEMENT DE REPERE
C
      NTAIL=NBDDR**2
      CALL WKVECT('&&'//PGC//'.TETGD','V V R',NTAIL,LTETGD)
      CALL CTETGD(BASMOD,NUMD,NUMG,NBSEC,ZR(LTETGD),NBDDR)
C
      IF(NBDAX.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.TETAX','V V R',NBDAX*NBDAX,LTETAX)
        CALL CTETAX(BASMOD,NUMA,NBSEC,ZR(LTETAX),NBDAX)
      ENDIF
C      
C --- RECUPERATION DES MODES 
C
      CALL WKVECT('&&'//PGC//'.VECTA','V V R',NBMOD*NEQ,LTVECA)
      CALL WKVECT('&&'//PGC//'.VECTB','V V R',NBDDR*NEQ,LTVECB)
      CALL WKVECT('&&'//PGC//'.VECTC','V V R',NBDDR*NEQ,LTVECC)
      IF(NBDAX.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.VECTD','V V R',NBDAX*NEQ,LTVECD)
      ENDIF
      DO 666 I=1,NBMOD
        CALL DCAPNO(BASMOD,'DEPL    ',I,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
        CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVECA+(I-1)*NEQ),1)
        CALL JELIBE(CHAMVA)
        CALL ZERLAG(ZR(LTVECA+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 666  CONTINUE
      DO 667 I=1,NBDDR
        IORD=ZI(LTORD+I-1)
        CALL DCAPNO(BASMOD,'DEPL    ',IORD,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
        CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVECB+(I-1)*NEQ),1)
        CALL JELIBE(CHAMVA)
        CALL ZERLAG(ZR(LTVECB+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 667  CONTINUE
      DO 668 I=1,NBDDR
        IORD=ZI(LTORG+I-1)
        CALL DCAPNO(BASMOD,'DEPL    ',IORD,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
        CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVECC+(I-1)*NEQ),1)
        CALL JELIBE(CHAMVA)
        CALL ZERLAG(ZR(LTVECC+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 668  CONTINUE
      IF(NBDAX.GT.0) THEN
        DO 669 I=1,NBDAX
          IORD=ZI(LTORA+I-1)
          CALL DCAPNO(BASMOD,'DEPL    ',IORD,CHAMVA)
          CALL JEVEUO(CHAMVA,'L',LLCHAM)
          CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVECD+(I-1)*NEQ),1)
          CALL JELIBE(CHAMVA)
        CALL ZERLAG(ZR(LTVECD+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 669    CONTINUE
      ENDIF

      CALL WKVECT('&&'//PGC//'.VECT1','V V R',NEQ,LTVEC1)
      CALL WKVECT('&&'//PGC//'.VECT3','V V R',NEQ,LTVEC3)
C
C***********************************************************************
C***********************************************************************
C                             PROJECTION
C***********************************************************************
C***********************************************************************
C
C --- CONTROLE D'EXISTENCE DE LA MATRICE DE RAIDEUR & DE MASSE
C
      CALL MTEXIS(RAID,IER1)
      CALL MTEXIS(MASS,IER2)
      IF(IER1.EQ.0) THEN
        CALL UTDEBM('E','PRCYCB','ARRET SUR MATRICE INEXISTANTE')
        CALL UTIMPK('F','MATRICE',1,RAID)
        CALL UTFINM
      ELSEIF(IER2.EQ.0) THEN
        CALL UTDEBM('E','PRCYCB','ARRET SUR MATRICE INEXISTANTE')
        CALL UTIMPK('F','MATRICE',1,MASS)
        CALL UTFINM
      ENDIF
C
C --- ALLOCATION DESCRIPTEUR DE LA MATRICE
C
      CALL MTDSCR(RAID)
      CALL JEVEUO(RAID(1:19)//'.&INT','L',LMATK)
      CALL MTDSCR(MASS)
      CALL JEVEUO(MASS(1:19)//'.&INT','L',LMATM)
C
C --- PROJECTION MODES-MATRICE-MODES
C     PAS INDISPENSABLE MAIS LA METHODE RESTE EXACTE SI LES
C     MODES DU SECTEUR ONT MAL CONVERGE
C
C --- REQUETTES MATRICES A REMPLIR
C
      CALL JENONU(JEXNOM(REPMAT,'K0II'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0II)
      CALL JENONU(JEXNOM(REPMAT,'M0II'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0II)
C
      KTRIAN = 0
      DO 10 I=1,NBMOD
C
C ----- CALCUL PRODUIT MATRICE  MODES
C
        CALL MRMULT('ZERO',LMATK,ZR(LTVECA+(I-1)*NEQ),'R',ZR(LTVEC1),1)
        CALL MRMULT('ZERO',LMATM,ZR(LTVECA+(I-1)*NEQ),'R',ZR(LTVEC3),1)
        CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
        CALL ZERLAG(ZR(LTVEC3),NEQ,ZI(IDDEEQ))
C
C ----- PRODUIT AVEC MODES
C
        ZR(LDK0II+KTRIAN) = DDOT(NEQ,ZR(LTVEC1),1,
     &    ZR(LTVECA+(I-1)*NEQ),1)
        ZR(LDM0II+KTRIAN) = DDOT(NEQ,ZR(LTVEC3),1,
     &   ZR(LTVECA+(I-1)*NEQ),1)
        KTRIAN = KTRIAN + 1
        DO 20 J=I-1,1,-1
           ZR(LDK0II+KTRIAN) = DDOT(NEQ,ZR(LTVEC1),1,
     &      ZR(LTVECA+(J-1)*NEQ),1)
           ZR(LDM0II+KTRIAN) = DDOT(NEQ,ZR(LTVEC3),1,
     &      ZR(LTVECA+(J-1)*NEQ),1)
           KTRIAN = KTRIAN + 1
20      CONTINUE

10    CONTINUE
C
C --- PRODUIT MATRICE DEFORMEES DROITES
C
C --- REQUETTES MATRICES A REMPLIR
C
      CALL JENONU(JEXNOM(REPMAT,'K0JJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0JJ)
      CALL JENONU(JEXNOM(REPMAT,'K0IJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0IJ)
      CALL JENONU(JEXNOM(REPMAT,'M0JJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0JJ)
      CALL JENONU(JEXNOM(REPMAT,'M0IJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0IJ)
      IF(NBDAX.GT.0) THEN
          CALL JENONU(JEXNOM(REPMAT,'K0AJ'),IBID)
          CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0AJ)
          CALL JENONU(JEXNOM(REPMAT,'M0AJ'),IBID)
          CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0AJ)
      ENDIF
C
      KTRIAN = 0
C --- PRODUIT MATRICE DEFORMEES DROITES
C
C --- REQUETTES MATRICES A REMPLIR
C
      CALL JENONU(JEXNOM(REPMAT,'K0JJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0JJ)
      CALL JENONU(JEXNOM(REPMAT,'K0IJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0IJ)
      CALL JENONU(JEXNOM(REPMAT,'M0JJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0JJ)
      CALL JENONU(JEXNOM(REPMAT,'M0IJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0IJ)
      IF(NBDAX.GT.0) THEN
          CALL JENONU(JEXNOM(REPMAT,'K0AJ'),IBID)
          CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0AJ)
          CALL JENONU(JEXNOM(REPMAT,'M0AJ'),IBID)
          CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0AJ)
      ENDIF
C
      KTRIAN = 0

      DO 60 I=1,NBDDR
C
C ----- CALCUL PRODUIT MATRICE DEFORMEE DROITE
C
        CALL MRMULT('ZERO',LMATK,ZR(LTVECB+(I-1)*NEQ),'R',ZR(LTVEC1),1)
        CALL MRMULT('ZERO',LMATM,ZR(LTVECB+(I-1)*NEQ),'R',ZR(LTVEC3),1)
        CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
        CALL ZERLAG(ZR(LTVEC3),NEQ,ZI(IDDEEQ))
C
C ----- CALCUL TERME DIAGONAL
C
        ZR(LDK0JJ+KTRIAN) = DDOT(NEQ,ZR(LTVEC1),1,
     &                      ZR(LTVECB+(I-1)*NEQ),1)
        ZR(LDM0JJ+KTRIAN) = DDOT(NEQ,ZR(LTVEC3),1,
     &                      ZR(LTVECB+(I-1)*NEQ),1)
C
C ----- MULTIPLICATION PAR MODES PROPRES
C ----- NUL SI MODES CONTRAINTS STATIQUES MAIS NON NUL
C ----- SI MODES CONTRAINTS HARMONIQUES
C
        DO 65 J=1,NBMOD
           XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECA+(J-1)*NEQ),1)
           CALL AMPPR(ZR(LDK0IJ),NBMOD,NBDDR,XPROD,1,1,J,I)
           XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECA+(J-1)*NEQ),1)
           CALL AMPPR(ZR(LDM0IJ),NBMOD,NBDDR,XPROD,1,1,J,I)
65      CONTINUE
C
C ----- PRODUIT AVEC DEFORMEES DROITES (HORS TERMES DIAGONAUX)
C
        KTRIAN = KTRIAN + 1
        DO 70 J=I-1,1,-1
          ZR(LDK0JJ+KTRIAN) = DDOT(NEQ,ZR(LTVEC1),1,
     &                        ZR(LTVECB+(J-1)*NEQ),1)
          ZR(LDM0JJ+KTRIAN) = DDOT(NEQ,ZR(LTVEC3),1,
     &                        ZR(LTVECB+(J-1)*NEQ),1)
          KTRIAN = KTRIAN + 1
70      CONTINUE
C
C ----- PRODUIT AVEC DEFORMEES AXE
C
        IF(NBDAX.GT.0) THEN
          DO 75 J=1,NBDAX
            XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LDK0AJ),NBDAX,NBDDR,XPROD,1,1,J,I)
            XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LDM0AJ),NBDAX,NBDDR,XPROD,1,1,J,I)
75        CONTINUE
        ENDIF
C
60    CONTINUE

C
C --- TRAITEMENT DES PRODUITS MATRICIELS PAR TETA
C
C --- POUR K0AJ
C
      IF(NBDAX.GT.0) THEN
        CALL JENONU(JEXNOM(REPMAT,'KPLUSJA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPJA)
        CALL PMPPR(ZR(LDK0AJ),NBDAX,NBDDR,-1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDKPJA),NBDDR,NBDAX)
        CALL JENONU(JEXNOM(REPMAT,'MPLUSJA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPJA)
        CALL PMPPR(ZR(LDM0AJ),NBDAX,NBDDR,-1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDMPJA),NBDDR,NBDAX)
      ENDIF
C
C --- PRODUIT MATRICE DEFORMEES GAUCHES
C
C --- REQUETTE DU TABLEAU A REMPLIR (MATRICE STOCKEE PLEINE)
C
      CALL WKVECT('&&'//PGC//'.KGG','V V R',NBDDR*NBDDR,LTKGG)
      CALL WKVECT('&&'//PGC//'.KDG','V V R',NBDDR*NBDDR,LTKDG)
      CALL WKVECT('&&'//PGC//'.KIG','V V R',NBMOD*NBDDR,LTKIG)
      CALL WKVECT('&&'//PGC//'.MGG','V V R',NBDDR*NBDDR,LTMGG)
      CALL WKVECT('&&'//PGC//'.MDG','V V R',NBDDR*NBDDR,LTMDG)
      CALL WKVECT('&&'//PGC//'.MIG','V V R',NBMOD*NBDDR,LTMIG)
      IF(NBDAX.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.KAG','V V R',NBDAX*NBDDR,LTKAG)
        CALL WKVECT('&&'//PGC//'.MAG','V V R',NBDAX*NBDDR,LTMAG)
      ENDIF
C
      DO 80 I=1,NBDGA
C
C ----- CALCUL PRODUIT MATRICE DEFORMEE GAUCHE
C
        CALL MRMULT('ZERO',LMATK,ZR(LTVECC+(I-1)*NEQ),'R',ZR(LTVEC1),1)
        CALL MRMULT('ZERO',LMATM,ZR(LTVECC+(I-1)*NEQ),'R',ZR(LTVEC3),1)
        CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
        CALL ZERLAG(ZR(LTVEC3),NEQ,ZI(IDDEEQ))
C
C ----- CALCUL TERME DIAGONAL
C
        XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECC+(I-1)*NEQ),1)
        CALL AMPPR(ZR(LTKGG),NBDGA,NBDGA,XPROD,1,1,I,I)
        XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECC+(I-1)*NEQ),1)
        CALL AMPPR(ZR(LTMGG),NBDGA,NBDGA,XPROD,1,1,I,I)
C
C ----- MULTIPLICATION PAR MODES PROPRES
C
        DO 85  J=1,NBMOD
           XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECA+(J-1)*NEQ),1)
           CALL AMPPR(ZR(LTKIG),NBMOD,NBDGA,XPROD,1,1,J,I)
           XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECA+(J-1)*NEQ),1)
           CALL AMPPR(ZR(LTMIG),NBMOD,NBDGA,XPROD,1,1,J,I)
85      CONTINUE
C
C ----- PRODUIT AVEC DEFORMEE DROITE
C
        DO 90 J=1,NBDDR
          XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECB+(J-1)*NEQ),1)
          CALL AMPPR(ZR(LTKDG),NBDDR,NBDDR,XPROD,1,1,J,I)
          XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECB+(J-1)*NEQ),1)
          CALL AMPPR(ZR(LTMDG),NBDDR,NBDDR,XPROD,1,1,J,I)
90      CONTINUE
C
C ----- PRODUIT AVEC DEFORMEES GAUCHES (HORS TERMES DIAGONAUX)
C
        DO 100 J=1,I-1
          XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECC+(J-1)*NEQ),1)
          CALL AMPPR(ZR(LTKGG),NBDGA,NBDGA,XPROD,1,1,J,I)
          CALL AMPPR(ZR(LTKGG),NBDGA,NBDGA,XPROD,1,1,I,J)
          XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECC+(J-1)*NEQ),1)
          CALL AMPPR(ZR(LTMGG),NBDGA,NBDGA,XPROD,1,1,J,I)
          CALL AMPPR(ZR(LTMGG),NBDGA,NBDGA,XPROD,1,1,I,J)
100     CONTINUE
C
C ----- PRODUIT AVEC DEFORMEES AXE
C
        IF(NBDAX.GT.0) THEN
          DO 105 J=1,NBDAX
            XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTKAG),NBDAX,NBDGA,XPROD,1,1,J,I)
            XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTMAG),NBDAX,NBDGA,XPROD,1,1,J,I)
105       CONTINUE
        ENDIF
C
80    CONTINUE

C
C --- TRAITEMENT DES PRODUITS MATRICIELS PAR TETA

C
C --- POUR KPLUSIJ
C
      CALL JENONU(JEXNOM(REPMAT,'KPLUSIJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPIJ)
      CALL PMPPR(ZR(LTKIG),NBMOD,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &           ZR(LDKPIJ),NBMOD,NBDDR)
C
      CALL JEDETR('&&'//PGC//'.KIG')
C --- POUR MPLUSIJ
      CALL JENONU(JEXNOM(REPMAT,'MPLUSIJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPIJ)
      CALL PMPPR(ZR(LTMIG),NBMOD,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &           ZR(LDMPIJ),NBMOD,NBDDR)
C
      CALL JEDETR('&&'//PGC//'.MIG')
C
C --- POUR KPLUSJJ
C
      CALL JENONU(JEXNOM(REPMAT,'KPLUSJJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPJJ)
      CALL PMPPR(ZR(LTKDG),NBDDR,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &            ZR(LDKPJJ),NBDDR,NBDDR)
C
C --- POUR K0JJ
C
      CALL PMPPR(ZR(LTKGG),NBDDR,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &            ZR(LTKDG),NBDDR,NBDDR)
C
      CALL PMPPR(ZR(LTETGD),NBDDR,NBDDR,-1,ZR(LTKDG),NBDDR,NBDDR,1,
     &            ZR(LTKGG),NBDDR,NBDDR)
C

      CALL JENONU(JEXNOM(REPMAT,'MPLUSJJ'),IBID)
      CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPJJ)
      CALL PMPPR(ZR(LTMDG),NBDDR,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &           ZR(LDMPJJ),NBDDR,NBDDR)
C
C --- POUR M0JJ
C
      CALL PMPPR(ZR(LTMGG),NBDDR,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &           ZR(LTMDG),NBDDR,NBDDR)
C
      CALL PMPPR(ZR(LTETGD),NBDDR,NBDDR,-1,ZR(LTMDG),NBDDR,NBDDR,1,
     &           ZR(LTMGG),NBDDR,NBDDR)

      K = 0
      DO 107 J=1,NBDDR
      DO 107 I=J,1,-1
         ZR(LDK0JJ+K) = ZR(LDK0JJ+K)+ZR(LTKGG-1+(J-1)*NBDDR+I)
         ZR(LDM0JJ+K) = ZR(LDM0JJ+K)+ZR(LTMGG-1+(J-1)*NBDDR+I)
         K = K + 1
 107  CONTINUE

C
C --- SAUVEGARDE ET DESTRUCTION
      CALL JEDETR('&&'//PGC//'.KGG')
      CALL JEDETR('&&'//PGC//'.KDG')
      CALL JEDETR('&&'//PGC//'.MGG')
      CALL JEDETR('&&'//PGC//'.MDG')
C
      IF(NBDAX.GT.0) THEN
C
        CALL JENONU(JEXNOM(REPMAT,'KPLUSAJ'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPAJ)
        CALL PMPPR(ZR(LTKAG),NBDAX,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &            ZR(LDKPAJ),NBDAX,NBDDR)
C
        CALL PMPPR(ZR(LTETAX),NBDAX,NBDAX,-1,ZR(LDKPAJ),NBDAX,NBDDR,1,
     &            ZR(LTKAG),NBDAX,NBDDR)
C
        CALL AMPPR(ZR(LDK0AJ),NBDAX,NBDDR,ZR(LTKAG),NBDAX,NBDDR,1,1)
C
        CALL JEDETR('&&'//PGC//'.KAG')
        CALL JENONU(JEXNOM(REPMAT,'MPLUSAJ'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPAJ)
        CALL PMPPR(ZR(LTMAG),NBDAX,NBDDR,1,ZR(LTETGD),NBDDR,NBDDR,1,
     &           ZR(LDMPAJ),NBDAX,NBDDR)
C
        CALL PMPPR(ZR(LTETAX),NBDAX,NBDAX,-1,ZR(LDMPAJ),NBDAX,NBDDR,1,
     &           ZR(LTMAG),NBDAX,NBDDR)
C
        CALL AMPPR(ZR(LDM0AJ),NBDAX,NBDDR,ZR(LTMAG),NBDAX,NBDDR,1,1)
C
        CALL JEDETR('&&'//PGC//'.MAG')
C
      ENDIF
C
C --- PRODUIT MATRICE - DEFORMEES AXE
C
C --- REQUETTE DU TABLEAU A REMPLIR (MATRICE STOCKEE PLEINE)
C
      IF(NBDAX.GT.0) THEN
        CALL WKVECT('&&'//PGC//'.KAA','V V R',NBDAX*NBDAX,LTKAA)
        CALL WKVECT('&&'//PGC//'.KIA','V V R',NBMOD*NBDAX,LTKIA)
        CALL WKVECT('&&'//PGC//'.MAA','V V R',NBDAX*NBDAX,LTMAA)
        CALL WKVECT('&&'//PGC//'.MIA','V V R',NBMOD*NBDAX,LTMIA)
C
        DO 210 I=1,NBDAX
C
C ------- CALCUL PROJECTION MATRICE DEFORMEES AXE
C
          CALL MRMULT('ZERO',LMATK,ZR(LTVECD+(I-1)*NEQ),'R',
     &                ZR(LTVEC1),1)
          CALL MRMULT('ZERO',LMATM,ZR(LTVECD+(I-1)*NEQ),'R',
     &                ZR(LTVEC3),1)
          CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
          CALL ZERLAG(ZR(LTVEC3),NEQ,ZI(IDDEEQ))
C
C ------- MULTIPLICATION PAR MODES PROPRES
C
          DO 220 J=1,NBMOD
            XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECA+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTKIA),NBMOD,NBDAX,XPROD,1,1,J,I)
            XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECA+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTMIA),NBMOD,NBDAX,XPROD,1,1,J,I)
220       CONTINUE
C
C ------- PRODUIT AVEC DEFORMEE AXE
C
          DO 230 J=1,NBDAX
            XPROD= DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTKAA),NBDAX,NBDAX,XPROD,1,1,J,I)
            XPROD= DDOT(NEQ,ZR(LTVEC3),1,ZR(LTVECD+(J-1)*NEQ),1)
            CALL AMPPR(ZR(LTMAA),NBDAX,NBDAX,XPROD,1,1,J,I)
230       CONTINUE
210     CONTINUE
C
C ----- TRAITEMENT DES PRODUITS MATRICIEL PAR TETA
C -----(RECUPERATION EN LECTURE DE K0AA & MOAA)
C
C ----- POUR K0IA ET KPLUSIA
C
        CALL JENONU(JEXNOM(REPMAT,'K0IA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0IA)
C
        CALL JENONU(JEXNOM(REPMAT,'KPLUSIA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPIA)
        CALL AMPPR(ZR(LDK0IA),NBMOD,NBDAX,ZR(LTKIA),NBMOD,NBDAX,1,1)
C
        CALL PMPPR(ZR(LTKIA),NBMOD,NBDAX,1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDKPIA),NBMOD,NBDAX)
C
        CALL JEDETR('&&'//PGC//'.KIA')
C
C ----- POUR KPLUSAA ET K0AA
C
        CALL JENONU(JEXNOM(REPMAT,'KPLUSAA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDKPAA)
        CALL JENONU(JEXNOM(REPMAT,'K0AA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDK0AA)
C
        CALL PMPPR(ZR(LTKAA),NBDAX,NBDAX,1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDKPAA),NBDAX,NBDAX)
C
        CALL AMPPR(ZR(LDK0AA),NBDAX,NBDAX,ZR(LTKAA),NBDAX,NBDAX,1,1)
C
        CALL PMPPR(ZR(LTETAX),NBDAX,NBDAX,-1,ZR(LDKPAA),NBDAX,NBDAX,1,
     &             ZR(LTKAA),NBDAX,NBDAX)
C
        CALL AMPPR(ZR(LDK0AA),NBDAX,NBDAX,ZR(LTKAA),NBDAX,NBDAX,1,1)
C
        CALL JEDETR('&&'//PGC//'.KAA')
C
C ----- POUR M0IA  ET MPLUSIA
C
        CALL JENONU(JEXNOM(REPMAT,'M0IA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0IA)
        CALL JENONU(JEXNOM(REPMAT,'MPLUSIA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPIA)
        CALL PMPPR(ZR(LTMIA),NBMOD,NBDAX,1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDMPIA),NBMOD,NBDAX)
C
        CALL AMPPR(ZR(LDM0IA),NBMOD,NBDAX,ZR(LTMIA),NBMOD,NBDAX,1,1)
        CALL JEDETR('&&'//PGC//'.MIA')
C
C ----- POUR  M0AA
C
        CALL JENONU(JEXNOM(REPMAT,'MPLUSAA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDMPAA)
        CALL JENONU(JEXNOM(REPMAT,'M0AA'),IBID)
        CALL JEVEUO(JEXNUM(SOUMAT,IBID),'E',LDM0AA)
C
        CALL PMPPR(ZR(LTMAA),NBDAX,NBDAX,1,ZR(LTETAX),NBDAX,NBDAX,1,
     &             ZR(LDMPAA),NBDAX,NBDAX)
C
        CALL AMPPR(ZR(LDM0AA),NBDAX,NBDAX,ZR(LTMAA),NBDAX,NBDAX,1,1)
C
        CALL PMPPR(ZR(LTETAX),NBDAX,NBDAX,-1,ZR(LDMPAA),NBDAX,NBDAX,1,
     &             ZR(LTMAA),NBDAX,NBDAX)
        CALL AMPPR(ZR(LDM0AA),NBDAX,NBDAX,ZR(LTMAA),NBDAX,NBDAX,1,1)
C
        CALL JEDETR('&&'//PGC//'.MAA')

      ENDIF
C      
      CALL JEDETR('&&PRCYCB.MAT.TRAV')
      CALL JEDETR('&&PRCYCB.VECT')
      CALL JEDETR('&&'//PGC//'.TETGD')
      CALL JEDETR('&&'//'PRCYCB'//'.ORD.DROIT')
      CALL JEDETR('&&'//'PRCYCB'//'.ORD.GAUCH')
      IF(NBDAX.GT.0) THEN
        CALL JEDETR('&&'//PGC//'.TETAX')
        CALL JEDETR('&&'//'PRCYCB'//'.ORD.AXE')
      ENDIF
C
      CALL JEDETR('&&'//PGC//'.VECTA')
      CALL JEDETR('&&'//PGC//'.VECTB')
      CALL JEDETR('&&'//PGC//'.VECTC')
      IF(NBDAX.GT.0) THEN
        CALL JEDETR('&&'//PGC//'.VECTD')
      ENDIF
      
      CALL JEDETR('&&'//PGC//'.VECT1')
      CALL JEDETR('&&'//PGC//'.VECT3')
C
 9999 CONTINUE
      CALL JEDEMA()
      END
