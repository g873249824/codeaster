      SUBROUTINE XNRCH3(NOMA  ,CNSLT ,CNSLN ,CNSEN ,CNSENR,
     &                  FISS  ,LISMAE,LISNOE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_20
C
      IMPLICIT NONE
      CHARACTER*8   NOMA,FISS
      CHARACTER*19  CNSLT,CNSLN
      CHARACTER*19  CNSEN,CNSENR
      CHARACTER*24  LISMAE,LISNOE      
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION)
C
C CALCUL DE L'ENRICHISSEMENT ET DES POINTS DU FOND DE FISSURE - CAS 3D
C
C ----------------------------------------------------------------------
C
C
C I/O FISS   : NOM DE LA FISSURE 
C IN  NOMA   : NOM DU MAILLAGE      
C IN  LISMAE : NOM DE LA LISTE DES MAILLES ENRICHIES
C IN  LISNOE : NOM DE LA LISTE DES NOEUDS ENRICHIS 
C IN  CNSLT  : LEVEL-SET TANGENTE (TRACE DE LA FISSURE)
C IN  CNSLN  : LEVEL-SET NORMALE  (PLAN DE LA FISSURE)
C OUT CNSEN  : CHAM_NO SIMPLE POUR LE STATUT DES NOEUDS
C OUT CNSENR : CHAM_NO SIMPLE REEL POUR VISUALISATION
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32  JEXATR,JEXNUM
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
      INTEGER       NXMAFI,NXPTFF
      PARAMETER    (NXMAFI=20000,NXPTFF=500)
C
      INTEGER       IRET,NBNO,INO,IMAE,IMA,EN,EM,NMAFON,JFON,NFON
      INTEGER       JCOOR,JCONX1,JCONX2,JLTSV,JLNSV,JSTANO,JABSC
      INTEGER       JENSV,JENSL,NBMA,JMA,ITYPMA,NNOS
      INTEGER       JENSVR,JENSLR
      INTEGER       NMAABS,NBNOMA,I,NMAFIS,EM1,EM2,JMAEN1
      INTEGER       NUNO,JMAFIS,JMAFON,K
      INTEGER       IM1,IM2,IM3,IN,JMAEN2,JMAEN3
      INTEGER       NBFOND,JFISAR,JFISDE,JBORD,NPTBOR,NUFI,NDIM
      CHARACTER*3   NUFIK3
      CHARACTER*8   K8BID,TYPMA,NOMAIL
      CHARACTER*12  K12
      CHARACTER*19  MAI
      CHARACTER*24  MAFIS,STANO,NOMMAI      
      REAL*8        M(3),P(3),DIMIN,Q(4),ARMIN,PADIST
      INTEGER       IFM,NIV
      CHARACTER*24  XCARFO
      INTEGER       JCARAF  
      REAL*8        PFI(3),VOR(3),ORI(3),RAYON
      INTEGER       NMAEN1,NMAEN2,NMAEN3         
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)  
C
C --- ACCES AU MAILLAGE
C
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      NOMMAI = NOMA//'.NOMMAI'
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8BID,IRET)
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IRET)
C      
      NDIM   = 3
C
C --- ACCES AUX LEVEL-SET
C
      CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
      CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)
C
C --- RECUPERATION INFORMATIONS
C
      XCARFO = FISS(1:8)//'.CARAFOND'
      CALL JEVEUO(XCARFO,'L',JCARAF)
      RAYON  = ZR(JCARAF)
      VOR(1) = ZR(JCARAF+1)
      VOR(2) = ZR(JCARAF+2)
      VOR(3) = ZR(JCARAF+3)  
      ORI(1) = ZR(JCARAF+4)
      ORI(2) = ZR(JCARAF+5)
      ORI(3) = ZR(JCARAF+6)     
      PFI(1) = ZR(JCARAF+7)
      PFI(2) = ZR(JCARAF+8)
      PFI(3) = ZR(JCARAF+9)
C      
C     VOIR ALGORITHME D�TAILL� DANS BOOK II (16/12/03)
C
C-------------------------------------------------------------------
C    1) ON RESTREINT LA ZONE D'ENRICHISSEMENT AUTOUR DE LA FISSURE
C-------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-1) RESTRICTION DE LA ZONE D ENRICHISSEMENT'

      MAFIS='&&XENRCH.MAFIS'
      CALL WKVECT(MAFIS,'V V I',NXMAFI,JMAFIS)
C     ATTENTION, MAFIS EST LIMIT� � NXMAFI MAILLES

      CALL XMAFIS(NOMA,CNSLN,NXMAFI,MAFIS,NMAFIS,LISMAE)
      WRITE(IFM,*)'NOMBRE DE MAILLES DE LA ZONE FISSURE :',NMAFIS
      IF (NIV.GT.2) THEN
        WRITE(IFM,*)'NUMERO DES MAILLES DE LA ZONE FISSURE'
        DO 110 IMAE=1,NMAFIS
          WRITE(6,*)' ',ZI(JMAFIS-1+IMAE)
 110    CONTINUE
      ENDIF

C--------------------------------------------------------------------
C    2�) ON ATTRIBUE LE STATUT DES NOEUDS DE GROUP_ENRI
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-2) ATTRIBUTION DU STATUT DES NOEUDS '//
     &                          'DE GROUPENRI'

C     CREATION DU VECTEUR STATUT DES NOEUDS
      STANO='&&XENRCH.STANO'
      CALL WKVECT(STANO,'V V I',NBNO,JSTANO)

C     ON INITIALISE POUR TOUS LES NOEUDS DU MAILLAGE ENR � 0
      DO 200 INO=1,NBNO
        ZI(JSTANO-1+(INO-1)+1)=0
 200  CONTINUE

      CALL XSTANO(NOMA,LISNOE,NMAFIS,JMAFIS,CNSLT,CNSLN,RAYON,STANO)

C     ENREGISTREMENT DU CHAM_NO SIMPLE : STATUT DES NOEUDS
      CALL CNSCRE(NOMA,'NEUT_I',1,'X1','V',CNSEN)
      CALL JEVEUO(CNSEN//'.CNSV','E',JENSV)
      CALL JEVEUO(CNSEN//'.CNSL','E',JENSL)
      DO 210 INO=1,NBNO
        ZI(JENSV-1+(INO-1)+1)=ZI(JSTANO-1+(INO-1)+1)
        ZL(JENSL-1+(INO-1)+1)=.TRUE.
 210  CONTINUE
C     ENREGISTREMENT DU CHAM_NO SIMPLE REEL (POUR VISUALISATION)
      CALL CNSCRE(NOMA,'NEUT_R',1,'X1','V',CNSENR)
      CALL JEVEUO(CNSENR//'.CNSV','E',JENSVR)
      CALL JEVEUO(CNSENR//'.CNSL','E',JENSLR)
      DO 211 INO=1,NBNO
        ZR(JENSVR-1+(INO-1)+1)=ZI(JSTANO-1+(INO-1)+1)
        ZL(JENSLR-1+(INO-1)+1)=.TRUE.
 211  CONTINUE

C--------------------------------------------------------------------
C    3�) ON ATTRIBUE LE STATUT DES MAILLES VOLUMIQUES DU MAILLAGE
C        (AINSI QUE LES MAILLES DE FACES)
C        ET ON CONSTRUIT LES MAILLES DE MAFOND (NB MAX = NMAFIS)
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-3) ATTRIBUTION DU STATUT DES MAILLES'

      IF (NMAFIS.EQ.0) THEN
        CALL U2MESS('A','XFEM_57')
        NMAFON=0
        NMAEN1=0
        NMAEN2=0
        NMAEN3=0
        GOTO 333
      ENDIF

      CALL WKVECT('&&XENRCH.MAFOND','V V I',NMAFIS,JMAFON)
      CALL WKVECT('&&XENRCH.MAENR1','V V I',NBMA,JMAEN1)
      CALL WKVECT('&&XENRCH.MAENR2','V V I',NBMA,JMAEN2)
      CALL WKVECT('&&XENRCH.MAENR3','V V I',NBMA,JMAEN3)

      I=0
      IM1=0
      IM2=0
      IM3=0

      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)

C     BOUCLE SUR LES MAILLES DU MAILLAGE
      DO 310 IMA=1,NBMA
        ITYPMA=ZI(JMA-1+IMA)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)
C       SI MAILLE NON VOLUMIQUE ET NON MAILLE DE FACE ON CONTINUE � 310
        IF (TYPMA(1:4).NE.'HEXA'.AND.TYPMA(1:5).NE.'PENTA'.
     &      AND.TYPMA(1:5).NE.'TETRA'.AND.TYPMA(1:4).NE.'QUAD'.
     &      AND.TYPMA(1:4).NE.'TRIA') GOTO 310

        EM=0
        EM1=0
        EM2=0
        NMAABS=IMA
        NBNOMA=ZI(JCONX2+NMAABS) - ZI(JCONX2+NMAABS-1)
        IF (TYPMA(1:6).EQ.'HEXA20'.OR.TYPMA(1:7).EQ.'PENTA15'.
     &     OR.TYPMA(1:7).EQ.'TETRA10') THEN
C         MAILLE QUADRATIQUE : NB NOEUDS SOMMETS = 2/5 x NB NOEUDS TOTAL
          NNOS=2*NBNOMA/5
        ELSEIF (TYPMA(1:5).EQ.'QUAD8'.OR.TYPMA(1:5).EQ.'TRIA6') THEN
C         MAILLE QUADRATIQUE : NB NOEUDS SOMMETS =NB NOEUDS TOTAL /2
          NNOS=NBNOMA/2
        ELSE
          NNOS=NBNOMA
        ENDIF
C       BOUCLE SUR LES NOEUDS SOMMETS DE LA MAILLE
        DO 311 IN=1,NNOS
          NUNO=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+IN-1)
          EN=ZI(JSTANO-1+(NUNO-1)+1)
          IF (EN.EQ.1.OR.EN.EQ.3) EM1=EM1+1
          IF (EN.EQ.2.OR.EN.EQ.3) EM2=EM2+1
 311    CONTINUE
        IF (EM1.GE.1) EM=1
        IF (EM2.GE.1) EM=2
        IF (EM1.GE.1.AND.EM2.GE.1) EM=3
        IF (EM2.EQ.NNOS) THEN
C         MAILLE RETENUE POUR MAFOND (TS LS NOEUDS SOMMET SONT 'CARR�S')
C         SOUS R�SERVE QUE CE SOIT UNE MAILLE DE MAFIS
          DO 312 IMAE=1,NMAFIS
            IF (NMAABS .EQ. ZI(JMAFIS-1+IMAE)) THEN
              I=I+1
              CALL ASSERT(I.LE.NMAFIS)
              ZI(JMAFON-1+I)=NMAABS
C             ON SORT DE LA BOUCLE 312
              GOTO 313
            ENDIF
 312      CONTINUE
 313      CONTINUE
        ENDIF

C       ON R�CUP�RE LES NUMEROS DES MAILLES ENRICHIES
        IF (EM.EQ.1)   THEN
          IM1=IM1+1
          CALL ASSERT(IM1.LE.NBMA)
          ZI(JMAEN1-1+IM1)=NMAABS
        ELSEIF (EM.EQ.2)   THEN
          IM2=IM2+1
          CALL ASSERT(IM2.LE.NBMA)
          ZI(JMAEN2-1+IM2)=NMAABS
        ELSEIF (EM.EQ.3)   THEN
          IM3=IM3+1
          CALL ASSERT(IM3.LE.NBMA)
          ZI(JMAEN3-1+IM3)=NMAABS
        ENDIF
 310  CONTINUE

      NMAFON=I
      NMAEN1=IM1
      NMAEN2=IM2
      NMAEN3=IM3

C     REPRISE SI NMAFIS=0
 333  CONTINUE

      IF (NIV.GT.2) THEN
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAFON :',NMAFON
        DO 320 IMA=1,NMAFON
          CALL JENUNO(JEXNUM(NOMMAI,ZI(JMAFON-1+IMA)),NOMAIL)
          WRITE(IFM,*)'MAILLE ',NOMAIL
 320    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR1 :',NMAEN1
        DO 321 IMA=1,NMAEN1
          CALL JENUNO(JEXNUM(NOMMAI,ZI(JMAEN1-1+IMA)),NOMAIL)
          WRITE(IFM,*)'MAILLE ',NOMAIL
 321    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR2 :',NMAEN2
        DO 322 IMA=1,NMAEN2
          CALL JENUNO(JEXNUM(NOMMAI,ZI(JMAEN2-1+IMA)),NOMAIL)
          WRITE(IFM,*)'MAILLE ',NOMAIL
 322    CONTINUE
        WRITE(IFM,*)'NOMBRE DE MAILLES DE MAENR3 :',NMAEN3
        DO 323 IMA=1,NMAEN3
          CALL JENUNO(JEXNUM(NOMMAI,ZI(JMAEN3-1+IMA)),NOMAIL)
          WRITE(IFM,*)'MAILLE ',NOMAIL
 323    CONTINUE
      ENDIF

C--------------------------------------------------------------------
C    4�) RECHERCHES DES POINTS DE FONFIS (ALGO BOOK I 18/12/03)
C        ET REPERAGE DES POINTS DE BORD
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-4) RECHERCHE DES POINTS DE FONFIS'

      CALL WKVECT('&&XENRCH.FONFIS','V V R',4*NXPTFF,JFON)
      CALL WKVECT('&&XENRCH.PTBORD','V V L',NXPTFF,JBORD)

      CALL XPTFON(NOMA,NMAFON,CNSLT,CNSLN,JMAFON,NXPTFF,JFON,NFON,JBORD,
     &            NPTBOR,ARMIN)
      WRITE(K12,'(E12.5)') ARMIN
      WRITE(IFM,*)'LA LONGUEUR DE LA PLUS PETITE ARETE '//
     &      'DU MAILLAGE EST '//K12//'.'
      WRITE(IFM,*)'NOMBRE DE POINTS DE FONFIS',NFON
      IF (NFON.EQ.0) THEN
        CALL U2MESS('A','XFEM_58')
       IF (RAYON.GT.0.D0) CALL U2MESS('F','XFEM_59')

        CALL ASSERT(NMAEN2+NMAEN3.EQ.0)
C       CR�ATION DE DEUX POINTS BIDONS DU FOND DE FISSURE
        NFON=2
        ZR(JFON-1+1)=0.D0
        ZR(JFON-1+2)=0.D0
        ZR(JFON-1+3)=0.D0
        ZR(JFON-1+4)=0.D0
        ZR(JFON-1+5)=100.D0
        ZR(JFON-1+6)=100.D0
        ZR(JFON-1+7)=100.D0
        ZR(JFON-1+8)=100.D0
      ENDIF

C--------------------------------------------------------------------
C    5�) ORIENTATION DES POINTS DE FONFIS (ALGO BOOK I 19/12/03)
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-5) ORIENTATION DE FONFIS'

      CALL XORIFF(NFON,JFON,JBORD,PFI,ORI,VOR,DIMIN)

      WRITE(IFM,*)'DISTANCE ENTRE PFON_INI DEMANDE ET TROUVE :',DIMIN

C--------------------------------------------------------------------
C    6�) CALCUL DES FONDS MULTIPLES EVENTUELS
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-6) CALCUL DES EVENTUELS FONDS MULTIPLES'

      CALL WKVECT('&&XENRCH.FOMUDEP','V V I',NFON,JFISDE)
      CALL WKVECT('&&XENRCH.FOMUARR','V V I',NFON,JFISAR)

      IF ((.NOT.ZL(JBORD)).AND.(NPTBOR.GT.0))
     &   CALL U2MESS('A','XFEM_60')
      NBFOND=1
      ZI(JFISDE-1+NBFOND)=1
      ZI(JFISAR-1+NBFOND)=1
C     BOUCLE SUR LES POINTS DU FOND DE FISSURE
      DO 600 I=2,NFON-1
        IF (ZL(JBORD+I-1)) THEN
C       LE POINT I EST UN POINT DE BORD
          IF (ZI(JFISDE-1+NBFOND).EQ.ZI(JFISAR-1+NBFOND).AND.
     &        ZI(JFISAR-1+NBFOND).NE.I) THEN
C  SI ON RECHERCHE LE POINT D'ARRIVE DE LA FISSURE NBFOND,
C  ET QUE LE POINT N'EST PAS DEJA REPERE EN DEPART DE LA FISSURE NBFOND
C  => ON A TROUVE LE POINT D'ARRIVEE DE LA FISSURE NBFOND
            ZI(JFISAR-1+NBFOND)=I
            NBFOND=NBFOND+1
C  LE POINT SUIVANT EST POINT DE DEPART DE LA FISSURE SUIVANTE
            ZI(JFISDE-1+NBFOND)=I+1
            ZI(JFISAR-1+NBFOND)=I+1
          ENDIF
        ENDIF
600   CONTINUE
      ZI(JFISAR-1+NBFOND)=NFON
      WRITE(IFM,*)'NOMBRE DE FONDS DE FISSURES DETECTES',NBFOND

C--------------------------------------------------------------------
C    7�) CALCUL DE L'ABSCISSE CURVILIGNE : S
C--------------------------------------------------------------------

      WRITE(IFM,*)'XENRCH-6) CALCUL DES ABSCISSES CURVILIGNES'

      CALL WKVECT('&&XENRCH.ABSC','V V R',NFON,JABSC)

C     INITIALISATIONS
      I=1
      DO 700 K=1,3
        P(K)=ZR(JFON-1+4*(I-1)+K)
 700  CONTINUE
      ZR(JABSC-1+(I-1)+1)=0

C     CALCUL DE LA DISTANCE ENTRE CHAQUE POINT ET
C     CALCUL DE L'ABSCISSE CURVILIGNE EN SOMMANT CES DISTANCES
      NUFI=2
      DO 710 I=2,NFON
         DO 711 K=1,3
          M(K)=ZR(JFON-1+4*(I-1)+K)
 711    CONTINUE
        IF (ZI(JFISDE-1+NUFI).EQ.I) THEN
            ZR(JABSC-1+I)=0.D0
            NUFI=NUFI+1
        ELSE
            ZR(JABSC-1+(I-1)+1)=ZR(JABSC-1+(I-2)+1)+PADIST(3,M,P)
        ENDIF
        P(1)=M(1)
        P(2)=M(2)
        P(3)=M(3)
 710  CONTINUE

C     ON REMPLACE LES VALEURS DE THETA PAR CELLES DE S
      DO 720 I=1,NFON
        ZR(JFON-1+4*(I-1)+4)=ZR(JABSC-1+(I-1)+1)
 720  CONTINUE

      NUFI=1
      WRITE(IFM,*)'COORDONNEES DES POINTS DE FONFIS'
      DO 799 I=1,NFON
        Q(1)=ZR(JFON-1+4*(I-1)+1)
        Q(2)=ZR(JFON-1+4*(I-1)+2)
        Q(3)=ZR(JFON-1+4*(I-1)+3)
        Q(4)=ZR(JFON-1+4*(I-1)+4)
        IF (ZI(JFISDE-1+NUFI).EQ.I) THEN
          CALL CODENT(NUFI,'D',NUFIK3)
          WRITE(6,*)'FOND DE FISSURE'//NUFIK3
          WRITE(6,797)
        ENDIF
        WRITE(6,798)(Q(K),K=1,4)
        IF (ZI(JFISAR-1+NUFI).EQ.I)   NUFI=NUFI+1
 799  CONTINUE
 797  FORMAT(7X,'X',13X,'Y',13X,'Z',13X,'S')
 798  FORMAT(2X,4(E12.5,2X))
C
C --- CREATION DE LA SD
C
      CALL XLMAIL(NOMA  ,FISS  ,NDIM  ,NMAEN1,NMAEN2,NMAEN3,
     &            JMAEN1,JMAEN2,JMAEN3,NFON  ,JFON  ,NBFOND,
     &            JFISDE,JFISAR)
C
C --- MENAGE
C
      CALL JEDETR ('&&XENRCH.FONFIS')
      CALL JEDETR ('&&XENRCH.ABSC')
      CALL JEDETR ('&&XENRCH.MAFOND')
      CALL JEDETR ('&&XENRCH.MAENR1')
      CALL JEDETR ('&&XENRCH.MAENR2')
      CALL JEDETR ('&&XENRCH.MAENR3')
      CALL JEDETR ('&&XENRCH.PTBORD')
      CALL JEDETR ('&&XENRCH.FOMUDEP')
      CALL JEDETR ('&&XENRCH.FOMUARR')

      WRITE(IFM,*)'XENRCH-7) FIN DE XENRCH'

      CALL JEDEMA()
      END
