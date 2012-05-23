      SUBROUTINE XORIPE(MODELE)
      IMPLICIT NONE

      CHARACTER*8   MODELE


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/05/2012   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C        ORIENTER LES SOUS-ELEMENTS DE PEAU DES ELEMENTS X-FEM
C      (ET CALCUL DE HEAV SUR LES BORDS COINCIDANT AVEC INTERACE)
C
C  IN/OUT         MODELE    : NOM DE L'OBJET MODELE
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8,TYP3D
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      REAL*8        R8B,ARMIN,PREC,G1(3),GBO(3),GPR(3),NEXT(3),NORME,LSN
      REAL*8        CO(3,3),AB(3),AC(3),N2D(3),DDOT,A(3),B(3),C(3)
      COMPLEX*16    CBID
      INTEGER       IMA,NBMA,J,IER,KK,I,JMOFIS,IFIS,JNFIS,NFIS,IAD2
      INTEGER       JMAIL,NBMAIL,IRET,NBPAR,JCOOR,JM3D,IBID,JVECNO
      INTEGER       NUMAPR,NUMAB,NBNOPR,NBNOBO,NBNOSE,NBNOTT(3)
      INTEGER       JCONX1,JCONX2,INO,NUNO,NORIEG,NTRAIT,JTYPMA,JTMDIM
      INTEGER       ICH,JCESD(5),JCESV(5),JCESL(5),IAD,NSE,ISE,IN
      INTEGER       NDIME,ICMP,NDIM,ID(3),INTEMP,NSEORI,IFM,NIV,NNCP
      INTEGER       JDIM,S1,S2,JGRP,NMAENR,JINDIC,ZERO,JLSNV,JLSND,JLSNL
      INTEGER       NSIGNP,NSIGNM,NSIGNZ,IHE,HE,ITYPMA,JMA
      INTEGER       IFISS,NFISS
      CHARACTER*8   NOMA,K8BID,K8B,TYPBO,FISS
      CHARACTER*2   KDIM
      CHARACTER*19  LIGREL,NOMT19,CHS(5),CHLSN
      CHARACTER*24  MAMOD,GRMAPE,NOMOB,PARA,VECNOR,GRP(3),XINDIC
      CHARACTER*19  PINTTO,CNSETO,LONCHA,HEAV,PMILTO
      LOGICAL       ISMALI,MAQUA
      INTEGER       ITYPBO

C ----------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
      
C     INITIALISATION DU NOMBRE DE SOUS-ELEMENTS RE-ORIENTES
      NSEORI=0

      LIGREL = MODELE//'.MODELE'

C     1.RECUPERATION D'INFORMATIONS DANS MODELE

      CALL JEVEUO(MODELE//'.NFIS','L',JNFIS)
      NFIS = ZI(JNFIS)
      CALL JEVEUO(MODELE//'.FISS','L',JMOFIS)

C     RECUPERATION DU MAILLAGE ASSOCIE AU MODELE :
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA,IER)
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IBID)
      CALL DISMOI('F','DIM_GEOM'    ,NOMA,'MAILLAGE',NDIM,K8BID,IBID)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO('&CATA.TM.TMDIM','L',JTMDIM)
      CALL JEVEUO(NOMA//'.TYPMAIL','L',JTYPMA)

C     RECUPERATION DE L'ARETE MINIMUM DU MAILLAGE :
      CALL JEEXIN ( NOMA//'           .LTNT', IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL LTNOTB ( NOMA , 'CARA_GEOM' , NOMT19 )
         NBPAR = 0
         PARA = 'AR_MIN                  '
         CALL TBLIVA (NOMT19, NBPAR, ' ', IBID, R8B, CBID, K8B,
     &                K8B, R8B , PARA, K8B, IBID, ARMIN, CBID,
     &                K8B, IRET )
         IF ( IRET .EQ. 0 ) THEN
            PREC = ARMIN*1.D-06
         ELSEIF ( IRET .EQ. 1 ) THEN
            PREC = 1.D-10
         ELSE
            CALL U2MESS('F','MODELISA2_13')
         ENDIF
      ELSE
         CALL U2MESS('F','MODELISA3_18')
      ENDIF

      CHLSN = '&&XORIPE.CHLSN'
      CALL CELCES(MODELE//'.LNNO','V',CHLSN)
      CALL JEVEUO(CHLSN//'.CESL','L',JLSNL)
      CALL JEVEUO(CHLSN//'.CESD','L',JLSND)
      CALL JEVEUO(CHLSN//'.CESV','L',JLSNV)

C     ------------------------------------------------------------------
C     I�) CREATION DE LA LISTE DES NUMEROS DES MAILLES DE PEAU ENRICHIES
C     ------------------------------------------------------------------

      GRMAPE='&&XORIPE.GRMAPE'
      CALL WKVECT(GRMAPE,'V V I',NBMA,JMAIL)

C     INITIALISATION DU NOMBRE DE MAILLES DE LA LISTE
      NBMAIL=0

      DO 20 IFIS = 1,NFIS

        FISS = ZK8(JMOFIS-1 + IFIS)

C       REMPLISSAGE DE LA LISTE
        GRP(1) = FISS//'.MAILFISS  .HEAV'
        GRP(2) = FISS//'.MAILFISS  .CTIP'
        GRP(3) = FISS//'.MAILFISS  .HECT'
        XINDIC = FISS//'.MAILFISS .INDIC'

        CALL JEVEUO(XINDIC,'L',JINDIC)

C         BOUCLE SUR LES 3 GROUPES : HEAV, CTIP ET HECT
        DO 100 KK = 1,3
     
          IF (ZI(JINDIC-1+2*(KK-1)+1).EQ.1) THEN
            CALL JEVEUO(GRP(KK),'L',JGRP)
            NMAENR = ZI(JINDIC-1+2*KK)
     
C           BOUCLE SUR LES MAILLES DE CHAQUE GROUPE
            DO 120 I = 1,NMAENR
              IMA = ZI(JGRP-1+I)
C             NDIME : DIMENSION TOPOLOGIQUE DE LA MAILLE
              NDIME= ZI(JTMDIM-1+ZI(JTYPMA-1+IMA))
              IF (NDIM.EQ.NDIME+1) THEN
                NBMAIL=NBMAIL+1
                ZI(JMAIL-1+NBMAIL)=IMA
              ENDIF
 120        CONTINUE

          ENDIF
 100    CONTINUE

 20   CONTINUE
      IF (NBMAIL.EQ.0) GOTO 999

C     ------------------------------------------------------------------
C     II�) RECHERCHE DES MAILLES SUPPORT
C     ------------------------------------------------------------------
      CALL CODENT(NDIM,'D',KDIM)
      KDIM = KDIM//'D'
      NOMOB = '&&XORIPE.NU_MAILLE_3D'
      ZERO=0

      CALL UTMASU(NOMA, KDIM, NBMAIL, ZI(JMAIL), NOMOB,PREC,ZR(JCOOR),
     &             ZERO,IBID)
      CALL JEVEUO (NOMOB,'L',JM3D)

C     ------------------------------------------------------------------
C     III�) CREATION DU VECTEUR DES NORMALES SORTANTES
C     ------------------------------------------------------------------

      VECNOR='&&XORIPE.VECNOR'
      CALL WKVECT(VECNOR,'V V R',NBMAIL*NDIM,JVECNO)
   
      DO 300 IMA=1,NBMAIL
C       NUMEROS DES MAILLES PRINCIPALE ET DE BORD
        NUMAB=ZI(JMAIL-1+IMA)
        NUMAPR=ZI(JM3D-1+IMA)

C       NOMBRES DE NOEUDS DES MAILLES PRINCIPALE ET DE BORD
        NBNOBO=ZI(JCONX2+NUMAB) - ZI(JCONX2+NUMAB-1)
        NBNOPR=ZI(JCONX2+NUMAPR) - ZI(JCONX2+NUMAPR-1)
   
C       GBO : CENTRE DE GRAVIT� DE LA MAILLE DE BORD
        CALL VECINI(3,0.D0,GBO)
        DO 310 INO=1,NBNOBO
          NUNO=ZI(JCONX1-1+ZI(JCONX2+NUMAB-1)+INO-1)
          DO 311 J=1,NDIM
            GBO(J)=GBO(J)+ZR(JCOOR-1+3*(NUNO-1)+J)/NBNOBO
 311      CONTINUE
 310    CONTINUE

C     GPR : CENTRE DE GRAVIT� DE LA MAILLE PRICIPALE
        CALL VECINI(3,0.D0,GPR)
        DO 320 INO=1,NBNOPR
          NUNO=ZI(JCONX1-1+ZI(JCONX2+NUMAPR-1)+INO-1)
          DO 321 J=1,NDIM
            GPR(J)=GPR(J)+ZR(JCOOR-1+3*(NUNO-1)+J)/NBNOPR
 321      CONTINUE
 320    CONTINUE

C       NORMALE EXTERIEURE : NEXT = GBO - GPR
        CALL VECINI(3,0.D0,NEXT)
        CALL VDIFF(3,GBO,GPR,NEXT)
        CALL NORMEV(NEXT,NORME)

        DO 330 J=1,NDIM
          ZR(JVECNO-1+NDIM*(IMA-1)+J)=NEXT(J)
 330    CONTINUE

 300  CONTINUE




C     ------------------------------------------------------------------
C     IV�) ORIENTATION DES SOUS-ELEMENTS
C     ------------------------------------------------------------------

      CHS(1)  = '&&XORIPE.PINTTO'
      CHS(2)  = '&&XORIPE.CNSETO'
      CHS(3)  = '&&XORIPE.LONCHA'
      CHS(4)  = '&&XORIPE.HEAV'

      PINTTO = MODELE//'.TOPOSE.PIN'
      CNSETO = MODELE//'.TOPOSE.CNS'
      LONCHA = MODELE//'.TOPOSE.LON'
      HEAV   = MODELE//'.TOPOSE.HEA'

      CALL CELCES(PINTTO,'V',CHS(1))
      CALL CELCES(CNSETO,'V',CHS(2))
      CALL CELCES(LONCHA,'V',CHS(3))
      CALL CELCES(HEAV  ,'V',CHS(4))

      DO 40 ICH=1,4
        CALL JEVEUO(CHS(ICH)//'.CESD','L',JCESD(ICH))
        CALL JEVEUO(CHS(ICH)//'.CESV','E',JCESV(ICH))
        CALL JEVEUO(CHS(ICH)//'.CESL','L',JCESL(ICH))
 40   CONTINUE

      DO 400 IMA=1,NBMAIL
        DO 401 J=1,NDIM
          NEXT(J)=ZR(JVECNO-1+NDIM*(IMA-1)+J)
 401    CONTINUE

        NUMAB =ZI(JMAIL-1+IMA)
C --- CA NE SERT A RIEN DE RECUPERER NDIME CAR ON A SELECTIONN� NUMAB
C --- TEL QUE NDIME = NDIM-1 (BOUCLE 120)
        NDIME= ZI(JTMDIM-1+ZI(JTYPMA-1+NUMAB))
        NFISS = ZI(JCESD(4)-1+5+4*(NUMAB-1)+2)
        NUMAPR=ZI(JM3D-1+IMA)
        NBNOPR=ZI(JCONX2+NUMAPR) - ZI(JCONX2+NUMAPR-1)
C
        ITYPMA=ZI(JTYPMA-1+NUMAPR)
        CALL PANBNO(ITYPMA,NBNOTT)
        IF(NDIM.EQ.2) THEN
          ITYPBO=ZI(JTYPMA-1+NUMAB)
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPBO),TYPBO)
          NBNOBO=ZI(JCONX2+NUMAB) - ZI(JCONX2+NUMAB-1)
          NBNOSE=NBNOBO
        ELSE
          NBNOSE=3
        ENDIF
C
C       RECUPERATION DE LA SUBDIVISION LA MAILLE DE PEAU EN NIT
C       SOUS-ELEMENTS
        CALL CESEXI('S',JCESD(3),JCESL(3),NUMAB,1,1,1,IAD)
        NSE=ZI(JCESV(3)-1+IAD)

C         BOUCLE SUR LES NSE SOUS-ELEMENTS
        DO 420 ISE=1,NSE

C         CO(J,IN) : JEME COORDONNEE DU INEME SOMMET DU SOUS-ELEMENT
          DO 421 IN=1,NBNOSE
            ICMP=NBNOSE*(ISE-1)+IN
            CALL CESEXI('S',JCESD(2),JCESL(2),NUMAB,1,1,ICMP,ID(IN))
            INO=ZI(JCESV(2)-1+ID(IN))
            IF (INO.LT.1000) THEN
              NUNO=ZI(JCONX1-1+ZI(JCONX2+NUMAB-1)+INO-1)

              DO 422 J=1,NDIM
                CO(J,IN)=ZR(JCOOR-1+3*(NUNO-1)+J)
 422          CONTINUE
            ELSEIF (INO.GT.1000 .AND. INO.LT.2000) THEN
              DO 423 J=1,NDIM
                ICMP=NDIM*(INO-1000-1)+J
                CALL CESEXI('S',JCESD(1),JCESL(1),NUMAB,1,1,ICMP,IAD)
                CO(J,IN)=ZR(JCESV(1)-1+IAD)
 423          CONTINUE
            ENDIF
 421      CONTINUE
C
          DO 430 J=1,NDIM
             A(J) = CO(J,1)
             B(J) = CO(J,2)
             IF (NDIM.EQ.3) C(J) = CO(J,3)
 430      CONTINUE
             IF (NDIM.EQ.2) THEN
                A(3) = 0.D0
                B(3) = 0.D0
             ENDIF

C         NORMALE AU SOUS-ELEMENT 2D
          CALL VECINI(3,0.D0,AB)
          CALL VDIFF(3,B,A,AB)
          CALL VECINI(3,0.D0,N2D)
          IF (NDIM.EQ.3) THEN
            CALL VECINI(3,0.D0,AC)
            CALL VDIFF(3,C,A,AC)
            CALL PROVEC(AB,AC,N2D)
          ELSEIF (NDIM.EQ.2) THEN
            N2D(1) = AB(2)
            N2D(2) = -AB(1)
            N2D(3) = 0
          ENDIF
          CALL NORMEV(N2D,NORME)


C         PRODUIT SCALAIRE DES NORMALES : N2D.NEXT
          IF (DDOT(NDIM,N2D,1,NEXT,1).LT.0.D0) THEN
C           ON INVERSE LES SOMMETS S1 ET S2
C           (ON INVERSE 1 ET 2 EN 2D
           S1 = NDIM-1
           S2 = NDIM
C            ON INVERSE 2 ET 3 EN 3D)
            NSEORI=NSEORI+1
            INTEMP=ZI(JCESV(2)-1+ID(S1))
            ZI(JCESV(2)-1+ID(S1))=ZI(JCESV(2)-1+ID(S2))
            ZI(JCESV(2)-1+ID(S2))=INTEMP
          ENDIF

C         ON MODIF HEAVISIDE SI BORD COINCIDANT AVEC INTERFACE
C         RECUPERATION DE LA VALEUR DE LA FONCTION HEAVISIDE
          DO 450 IFISS=1,NFISS
            IHE = ISE
            CALL CESEXI('S',JCESD(4),JCESL(4),NUMAB,1,IFISS,IHE,IAD)
            HE=ZI(JCESV(4)-1+IAD)
            CALL ASSERT(HE.EQ.-1.OR.HE.EQ.1.OR.HE.EQ.99)
            IF (HE.EQ.99) THEN
C             VERIF QUE C'EST NORMAL         
              CALL ASSERT(NSE.EQ.1)
C             SIGNE LEVEL SET SUR LA MAILLE PRINCIPALE
              NSIGNP=0
              NSIGNM=0
              NSIGNZ=0
C             LSN SUR LES NOEUDS SOMMETS DE LA MAILLE PRINCIPALE
              DO 440 INO=1,NBNOTT(1)
                CALL CESEXI('S',JLSND,JLSNL,NUMAB,INO,IFISS,1,IAD2)
C                NUNO=ZI(JCONX1-1+ZI(JCONX2+NUMAPR-1)+INO-1)
                LSN = ZR(JLSNV-1+IAD2)
                IF (LSN.GT.0.D0) NSIGNP = NSIGNP +1
                IF (LSN.EQ.0.D0) NSIGNZ = NSIGNZ +1
                IF (LSN.LT.0.D0) NSIGNM = NSIGNM +1
 440          CONTINUE
              CALL ASSERT(NSIGNZ.NE.0)
C             REMARQUE : LES DEUX TESTS SUIVANTS NE SONT PAS CORRECTS
C             VOIR FICHE 13265
C              CALL ASSERT(NSIGNP+NSIGNM.NE.0)
C              CALL ASSERT(NSIGNP*NSIGNM.EQ.0)
C             ON ECRIT HE
              IF (NSIGNP.GT.0) ZI(JCESV(4)-1+IAD)= 1
              IF (NSIGNM.GT.0) ZI(JCESV(4)-1+IAD)=-1
            ENDIF
 450      CONTINUE

 420    CONTINUE

 400  CONTINUE

C     ON SAUVE LES NOUVEAUX CHAM_ELEM MODIFIES A LA PLACE DES ANCIENS
      CALL CESCEL(CHS(2),LIGREL,'TOPOSE','PCNSETO','OUI',NNCP,'G',
     &            CNSETO,'F',IBID)
      CALL CESCEL(CHS(4),LIGREL,'TOPOSE','PHEAVTO','OUI',NNCP,'G',
     &            HEAV,'F',IBID)
C     ------------------------------------------------------------------
C     FIN
C     ------------------------------------------------------------------

      CALL JEDETR('&&XORIPE.NU_MAILLE_3D')
      CALL JEDETR('&&XORIPE.VECNOR')

 999  CONTINUE

      WRITE(IFM,*)'NOMBRE DE SOUS-ELEMENTS DE PEAU RE-ORIENTES :',NSEORI

      CALL JEDETR('&&XORIPE.GRMAPE')

      CALL JEDEMA()
      END
