      SUBROUTINE APTGNN(SDAPPA,NDIMG ,JDECNO,NBNO  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/01/2011   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*19 SDAPPA
      INTEGER      NDIMG,JDECNO,NBNO
C
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT - TANGENTES EN CHAQUE NOEUD 
C
C CALCUL SUR UNE ZONE
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  NMDIMG : DIMENSION DE L'ESPACE
C IN  JDECNO : DECALAGE POUR NUMERO DE NOEUD
C IN  NBNO   : NOMBRE DE NOEUDS DE LA ZONE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32  JEXNUM
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
      CHARACTER*24 RNOMSD
      CHARACTER*8  NOMA,NOMNOE,NOMMAI,VALK(2)
      INTEGER      POSMAI,NUMMAI,POSNO,NUMNO
      INTEGER      NMANOM,NNOSDM
      INTEGER      JDECIV,JDEC
      INTEGER      INO,IMA,INOCOU,INOMAI
      INTEGER      NIVERR
      REAL*8       TAU1(3),TAU2(3),NORMAL(3),NORMN
      REAL*8       TAUND1(3),TAUND2(3)
      REAL*8       VNORM(3),R8PREM,NOOR
      CHARACTER*24 APTGEL,APTGNO
      INTEGER      JTGELN,JPTGNO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOM SD MAILLAGE
C
      CALL APNOMK(SDAPPA,'NOMA'  ,RNOMSD)
      NOMA   = RNOMSD(1:8)
C
C --- ACCES SD
C
      APTGEL = SDAPPA(1:19)//'.TGEL'
      APTGNO = SDAPPA(1:19)//'.TGNO'
      CALL JEVEUO(APTGNO,'E',JPTGNO)     
C
C --- BOUCLE SUR LES NOEUDS
C
      DO 20 INO = 1,NBNO
C
C ----- INITIALISATIONS
C
        NORMAL(1) = 0.D0
        NORMAL(2) = 0.D0
        NORMAL(3) = 0.D0
        TAUND1(1) = 0.D0
        TAUND1(2) = 0.D0
        TAUND1(3) = 0.D0
        TAUND2(1) = 0.D0
        TAUND2(2) = 0.D0
        TAUND2(3) = 0.D0
C
C ----- NOEUD COURANT
C
        POSNO  = INO+JDECNO
C
C ----- NUMERO ABSOLU ET NOM DU NOEUD
C
        CALL APNUMN(SDAPPA,POSNO ,NUMNO )
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNO ),NOMNOE)
C
C ----- NOMBRE DE MAILLES ATTACHEES AU NOEUD 
C
        CALL APNINV(SDAPPA,POSNO ,'NMANOM',NMANOM)
C
C ----- DECALAGE POUR CONNECTIVITE INVERSE
C
        CALL APNINV(SDAPPA,POSNO ,'JDECIV',JDECIV)
C
C ----- BOUCLE SUR LES MAILLES ATTACHEES
C
        DO 10 IMA = 1,NMANOM
C
C ------- POSITION DE LA MAILLE ATTACHEE
C
          CALL APATTA(SDAPPA,JDECIV,IMA   ,POSMAI)
C
C ------- NUMERO ABSOLU ET NOM DE LA MAILLE ATTACHEE
C
          CALL APNUMM(SDAPPA,POSMAI,NUMMAI)
          CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAI),NOMMAI)
          VALK(1) = NOMMAI
          VALK(2) = NOMNOE
C
C ------- ACCES CONNECTIVITE DE LA MAILLE ATTACHEE
C
          CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',NUMMAI),'L',JDEC)
C
C ------- NOMBRE DE NOEUDS DE LA MAILLE ATTACHEE
C
          CALL APNNDM(SDAPPA,POSMAI,NNOSDM)
C
C ------- ACCES TANGENTES MAILLE COURANTE
C
          CALL JEVEUO(JEXNUM(APTGEL,POSMAI),'L',JTGELN)
C
C ------- TRANSFERT NUMERO ABSOLU DU NOEUD -> NUMERO DANS LA CONNEC DE
C ------- LA MAILLE
C
          INOCOU = 0
          DO 30 INOMAI = 1,NNOSDM
            IF (ZI(JDEC+INOMAI-1).EQ.NUMNO) THEN
              INOCOU = INOMAI
            ENDIF
 30       CONTINUE
          CALL ASSERT(INOCOU.NE.0)
C
C ------- RECUPERATIONS DES TANGENTES EN CE NOEUD
C
          TAU1(1) = ZR(JTGELN+6*(INOCOU-1)+1-1)
          TAU1(2) = ZR(JTGELN+6*(INOCOU-1)+2-1)
          TAU1(3) = ZR(JTGELN+6*(INOCOU-1)+3-1)                     
          TAU2(1) = ZR(JTGELN+6*(INOCOU-1)+4-1)
          TAU2(2) = ZR(JTGELN+6*(INOCOU-1)+5-1)
          TAU2(3) = ZR(JTGELN+6*(INOCOU-1)+6-1)
C
C ------- CALCUL DE LA NORMALE _INTERIEURE_ 
C
          CALL MMNORM(NDIMG,TAU1  ,TAU2  ,VNORM ,NOOR  )
          IF (NOOR.LE.R8PREM()) THEN
            CALL U2MESK('F','APPARIEMENT_15',2,VALK)
          ENDIF             
C  
C ------- NORMALE RESULTANTE 
C
          NORMAL(1) = NORMAL(1) + VNORM(1)
          NORMAL(2) = NORMAL(2) + VNORM(2)
          NORMAL(3) = NORMAL(3) + VNORM(3)
 10     CONTINUE          
C
C ----- MOYENNATION DE LA NORMALE SUR TOUTES LES MAILLES LIEES AU NOEUD
C
        NORMAL(1) = NORMAL(1) / NMANOM
        NORMAL(2) = NORMAL(2) / NMANOM
        NORMAL(3) = NORMAL(3) / NMANOM
C
C ----- NORMALISATION NORMALE SUR TOUTES LES MAILLES LIEES AU NOEUD
C 
        CALL NORMEV(NORMAL,NORMN )
        IF (NORMN.LE.R8PREM()) THEN
          CALL U2MESK('F','APPARIEMENT_16',1,NOMNOE)
        ENDIF
C
C ----- RE-CONSTRUCTION DES VECTEURS TANGENTS APRES LISSAGE
C
        CALL MMMRON(NDIMG ,NORMAL,TAUND1,TAUND2)
C
C ----- NORMALISATION DES TANGENTES
C
        CALL MMTANN(NDIMG ,TAUND1,TAUND2,NIVERR)
        IF (NIVERR.EQ.1) THEN  
          CALL U2MESK('F','APPARIEMENT_17',1,NOMNOE)
        ENDIF
C 
C ----- STOCKAGE DES VECTEURS TANGENTS EXTERIEURS SUR LE NOEUD  
C
        ZR(JPTGNO+6*(POSNO-1)+1-1) = TAUND1(1)
        ZR(JPTGNO+6*(POSNO-1)+2-1) = TAUND1(2)
        ZR(JPTGNO+6*(POSNO-1)+3-1) = TAUND1(3)
        ZR(JPTGNO+6*(POSNO-1)+4-1) = TAUND2(1)
        ZR(JPTGNO+6*(POSNO-1)+5-1) = TAUND2(2)
        ZR(JPTGNO+6*(POSNO-1)+6-1) = TAUND2(3)
 20   CONTINUE
C
      CALL JEDEMA()
      END
