      SUBROUTINE XSTAN2(CRIMAX,NOMA,NBMA,FISS)
      IMPLICIT NONE 

      CHARACTER*8   FISS,NOMA
      INTEGER       NBMA
      REAL*8        CRIMAX
      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/10/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C.......................................................................
C RESPONSABLE GENIAUT S.GENIAUT
C
C    CREATION LISTE DE NOEUDS OU IL FAUDRA ANNULER LES DDLS HEAVISIDE
C     POUR DES RAISONS DE CONDITIONNEMENT DE MATRICE ET POUR EVITER
C                DES PIVOTS NULS DANS LA MATRICE DE RAIDEUR
C                         (VOIR BOOK V 15/04/05)
C
C
C  IN         CRIMAX   : CRIT�RE (RAPPORT MAXIMUM ENTRE LES VOLUMES)
C  IN         NOMA     : NOM DE L'OBJET MAILLAGE	 
C  IN         NBMA     : NOMBRE DE MAILLE DU MAILLAGE
C  IN/OUT     FISS     : NOM DE LA SD FISS_XFEM
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
      CHARACTER*32    JEXATR,JEXNUM,JEXNOM
      
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      CHARACTER*8   TYPMA,K8B
      CHARACTER*19  CES1,CEL1,CES2,CEL2,MAI,CNO,CNS,CNO1,CNS1,CNO2,CNS2
      CHARACTER*19  CNXINV,LISNOH
      REAL*8        CRIT,LSN,MINLSN,R8MAEM,MAXLSN
      INTEGER       JMA,JCESD1,JCESL1,JCESV1,IAD,JCESD2,JCESL2,JCESV2
      INTEGER       JCONX1,JCONX2,JSTNV,JLNSV1,JLNSV2,ADRMA,JLITMP
      INTEGER       IMA,ITYPMA,NINTER,NBNOMA,NNOS,INO,NUNO,IMIN,IBID,IM
      INTEGER       NBMANO,NUMA,IN,NUNO2,NBNO,JLISNO,CPT,IER
      LOGICAL       MAAPB(NBMA)
C......................................................................

      CALL JEMARQ()
      
      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8B,IBID)

C     CONNECTIVITE INVERSEE
      CNXINV = '&&XSTAN2.CNCINV'
      CALL CNCINV (NOMA,IBID,0,'V',CNXINV)
      
      CEL1 = FISS//'.TOPOSE.CRITER'
      CALL JEEXIN(CEL1,IER)
      IF (IER.EQ.0) GOTO 9999
      
      CES1 = '&&XSTAN2.CES1'
      CALL CELCES(CEL1,'V',CES1)
      CALL JEVEUO(CES1//'.CESD','L',JCESD1)
      CALL JEVEUO(CES1//'.CESL','E',JCESL1)
      CALL JEVEUO(CES1//'.CESV','E',JCESV1)
      
      CEL2 = FISS//'.TOPOFAC.LONCHAM'
      CES2 = '&&XSTAN2.CES2'
      CALL CELCES(CEL2,'V',CES2)
      CALL JEVEUO(CES2//'.CESD','L',JCESD2)
      CALL JEVEUO(CES2//'.CESL','E',JCESL2)
      CALL JEVEUO(CES2//'.CESV','E',JCESV2)
      
      CNO = FISS//'.STNO'
      CNS = '&&XSTAN2.CNS'
      CALL CNOCNS(CNO,'V',CNS)      
      CALL JEVEUO(CNS//'.CNSV','L',JSTNV)

      CNO1 = FISS//'.LNNO'
      CNS1 = '&&XSTAN2.CNS1'
      CALL CNOCNS(CNO1,'V',CNS1)      
      CALL JEVEUO(CNS1//'.CNSV','L',JLNSV1)

      CNO2 = '&&XSTAN2.CNO2'
      CNS2 = '&&XSTAN2.CNS2'
      CALL COPICH('V',CNO1,CNO2)
      CALL CNOCNS(CNO2,'V',CNS2)      
      CALL JEVEUO(CNS2//'.CNSV','L',JLNSV2)

C     LISTE TEMPORAIRE DES NOEUDS OU IL FAUT ANNULER LES DDLS HEAV      
      LISNOH = '&&XSTAN2.LISTNOH'
      CALL WKVECT(LISNOH,'V V I',NBNO,JLITMP)
      CPT=0 
          
C     BOUCLE SUR TOUTES LES MAILLES DU MAILLAGE   
      DO 10 IMA = 1,NBMA

        MAAPB(IMA)=.FALSE.
        CALL CESEXI('C',JCESD1,JCESL1,IMA,1,1,1,IAD)
        IF (IAD.EQ.0) GOTO 10
        CRIT=ZR(JCESV1-1+IAD)

        IF (CRIT.EQ.0.D0) GOTO 10
        IF (CRIT.GT.CRIMAX) GOTO 10
        ITYPMA=ZI(JMA-1+IMA)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
        CALL CESEXI('C',JCESD2,JCESL2,IMA,1,1,1,IAD)
        NINTER=ZI(JCESV2-1+IAD)
        WRITE(6,*)'IMA TYPMA NINTER CRIT ',IMA,TYPMA,NINTER,CRIT     
        CALL ASSERT(TYPMA(1:4).EQ.'HEXA'.AND.NINTER.EQ.3)
        MAAPB(IMA)=.TRUE.

C       RECHERCHE DU NOEUD DE LA MAILLE OU ABS(LSN) EST MINIMUM MAIS > 0
C       NB NOEUDS = 2/5 x NB NOEUDS TOTAL CAR MAILLE QUADRAT
        NBNOMA=ZI(JCONX2+IMA) - ZI(JCONX2+IMA-1)
        NNOS=2*NBNOMA/5
        MINLSN=R8MAEM()
        DO 20 INO=1,NNOS                
          NUNO=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+INO-1)
          LSN=ABS(ZR(JLNSV1-1+(NUNO-1)+1))
          IF (LSN.NE.0.D0.AND.LSN.LT.MINLSN) THEN
            MINLSN=LSN
            IMIN=NUNO
          ENDIF
 20     CONTINUE
C       MISE A ZERO DE LA PSEUDO LSN POUR CE NOEUD OU LSN EST MINIMUM
        ZR(JLNSV2-1+IMIN)=0.D0
 10   CONTINUE



C     BOUCLE SUR TOUTES LES MAILLES DU MAILLAGE   
      DO 100 IMA = 1,NBMA

        IF (.NOT.MAAPB(IMA)) GOTO 100

        NBNOMA=ZI(JCONX2+IMA) - ZI(JCONX2+IMA-1)
        NNOS=2*NBNOMA/5        

C       CALCUL DE L'ENRICHISSMENT DES NOEUDS DE LA MAILLE
        DO 30 INO=1,NNOS             
          NUNO=ZI(JCONX1-1+ZI(JCONX2+IMA-1)+INO-1)     
          MINLSN=R8MAEM()
          MAXLSN=-1.D0*R8MAEM()
C         RECUPERATION DES MAILLES CONTENANT LE NOEUD 
          CALL JELIRA(JEXNUM(CNXINV,NUNO),'LONMAX',NBMANO,K8B)
          CALL JEVEUO(JEXNUM(CNXINV,NUNO),'L',ADRMA)
          DO 40 IM=1,NBMANO
            NUMA = ZI(ADRMA-1 + IM)
            ITYPMA=ZI(JMA-1+NUMA)
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
C           SI MAILLE NON VOLUMIQUE ON CONTINUE � 40
            IF (TYPMA(1:4).NE.'HEXA'.AND.TYPMA(1:5).NE.'PENTA'.
     &                               AND.TYPMA(1:5).NE.'TETRA') GOTO 40
            NBNOMA=ZI(JCONX2+NUMA) - ZI(JCONX2+NUMA-1)
            NNOS=2*NBNOMA/5
            DO 50 IN=1,NNOS
              NUNO2=ZI(JCONX1-1+ZI(JCONX2+NUMA-1)+IN-1)
              LSN=ZR(JLNSV2-1+(NUNO2-1)+1)
              IF (LSN.LT.MINLSN) MINLSN=LSN
              IF (LSN.GT.MAXLSN) MAXLSN=LSN              
 50         CONTINUE  
 40       CONTINUE

          IF (MINLSN*MAXLSN.GE.0.D0.AND.ZI(JSTNV-1+NUNO).EQ.1) THEN
            CPT=CPT+1
            ZI(JLITMP-1+CPT)=NUNO
          ENDIF

 30     CONTINUE

 100  CONTINUE        

      WRITE(6,*)'CPT',CPT
      IF (CPT.GT.0) THEN
C       CREATION DE L'OBJET .LISNOH DIMENSIONN� CORRECTEMENT
        CALL WKVECT(FISS//'.LISNOH','G V I',CPT,JLISNO)
        DO 900 INO=1,CPT
          ZI(JLISNO-1+INO)=ZI(JLITMP-1+INO)
          WRITE(6,*)'LISNOH',ZI(JLISNO-1+INO)
 900    CONTINUE
      ENDIF
      
      CALL JEDETR(CNXINV)
      CALL JEDETR(CES1)
      CALL JEDETR(CES2)
      CALL JEDETR(CNS)
      CALL JEDETR(CNS1)
      CALL JEDETR(CNS2)
      CALL JEDETR(CNO2)
      CALL JEDETR(LISNOH)
C ----------------------------------------------------------------------

 9999 CONTINUE

      CALL JEDEMA()
      END
