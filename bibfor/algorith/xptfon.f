      SUBROUTINE XPTFON(NOMA,NDIM,NMAFON,CNSLT,CNSLN,CNXINV,
     &                  JMAFON,NXPTFF,JFON,NFON,JBAS,JBORD,NPTBOR,
     &                  FISS)
      IMPLICIT NONE

      INTEGER       NMAFON,JMAFON,JFON,NFON,NXPTFF,JBORD,NPTBOR
      CHARACTER*8   NOMA,FISS
      CHARACTER*19  CNSLT,CNSLN,CNXINV
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/04/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IPT THE HOPE THAT IT WILL BE USEFUL, BUT
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
C       RECHERCHE DES POINTS DU FOND DE FISSURE DANS LE CADRE DE XFEM
C
C  ENTREES :
C     NOMA         :    NOM DE L'OBJET MAILLAGE
C     NMAFON       :    NOMBRE DE MAILLES DE LA ZONE FOND DE FISSURE
C     JMAFON       :    MAILLES DE LA ZONE FOND DE FISSURE
C     NXPTFF       :    NOMBRE MAXIMUM DE POINTS DU FOND DE FISSURE
C     CNSLT,CNSLN  :    LEVEL-SETS
C     CNXINV       :    CONNECTIVITE INVERSE
C     FISS         :    SD FISS_XFEM (POUR RECUP DES GRADIENTS)
C
C  SORTIES :
C     JFON         :   ADRESSE DES POINTS DU FOND DE FISSURE
C     JBAS         :   ADRESSE DES DIRECTIONS DE PROPAGATION
C     NFON         :   NOMBRE DE POINTS DU FOND DE FISSURE
C     JBORD        :   ADRESSE DE L'ATTRIBUT LOGIQUE 'POINT DE BORD'
C     NPTBOR       :   NOMBRE DE POINTS 'DE BORD' DU FOND DE FISSURE
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
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32    JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER         IPT,IMA,IFT,I,J,IBID,IRET,NDIM,INO,K,IFQ
      INTEGER         NMAABS,NBF,NBNOMA,NUNO,NUNOA,NUNOB,NUNOC,CODRET
      INTEGER         FA(6,4),FT(12,3),NBFT,IBID3(12,3)
      INTEGER         JCONX1,JCONX2,JCOOR,JLTSV,JLNSV,JMA,JBAS
      INTEGER         JLSN,JLST,JGLSN,JGLST,IGEOM,JGT,JGN,ITYPMA
      REAL*8          A(3),B(3),C(3),M(3),P(3),GLN(3),GLT(3)
      REAL*8          R8PREM,PREC,PADIST,LONCAR
      CHARACTER*8     TYPMA,GRAD
      CHARACTER*19    MAI,GRLT,CHGRT,GRLN,CHGRN
      CHARACTER*32    JEXATR
      LOGICAL         FABORD
C ----------------------------------------------------------------------
      CALL JEMARQ()

C     PR�CISION :
      PREC=1.D-3

      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)
      CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
      CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)
      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)

C     GRADIENT LST
      GRLT = FISS//'.GRLTNO'
      CHGRT = '&&XPTFON.GRLN'
      CALL CNOCNS(GRLT,'V',CHGRT)
      CALL JEVEUO(CHGRT//'.CNSV','L',JGT)

C     GRADIENT LSN
      GRLN = FISS//'.GRLNNO'
      CHGRN = '&&XPTFON.GRLT'
      CALL CNOCNS(GRLN,'V',CHGRN)
      CALL JEVEUO(CHGRN//'.CNSV','L',JGN)


      DO 10 I=1,NXPTFF
         ZL(JBORD-1+I)=.FALSE.
 10   CONTINUE


C     COMPTEUR : NOMBRE DE POINTS DE FONFIS TROUV�S
      IPT=0
C     COMPTEUR : NOMBRE DE POINTS DE FONFIS DE BORD TROUVES
      NPTBOR=0

C     BOUCLE SUR LES MAILLES DE MAFOND
      DO 100 IMA=1,NMAFON

        NMAABS=ZI(JMAFON-1+(IMA-1)+1)
        ITYPMA=ZI(JMA-1+NMAABS)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)

C       ON SE RECREE UN ENVIRONNEMENT COMME DANS UN TE
C       POUR LSN, LST, GRLST, GRLST ET IGEOM
C       AFIN DE POUVOIR APPELER INTFAC
        NBNOMA = ZI(JCONX2+NMAABS) - ZI(JCONX2+NMAABS-1)
        CALL WKVECT('&&XPTFON.LSN','V V R',NBNOMA,JLSN)
        CALL WKVECT('&&XPTFON.LST','V V R',NBNOMA,JLST)
        CALL WKVECT('&&XPTFON.GRLSN','V V R',NBNOMA*NDIM,JGLSN)
        CALL WKVECT('&&XPTFON.GRLST','V V R',NBNOMA*NDIM,JGLST)
        CALL WKVECT('&&XPTFON.IGEOM','V V R',NBNOMA*NDIM,IGEOM)
        DO 110 INO=1,NBNOMA
          NUNO=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INO-1)
          ZR(JLSN-1+INO) = ZR(JLNSV-1+NUNO)
          ZR(JLST-1+INO) = ZR(JLTSV-1+NUNO)
          DO 120 J=1,NDIM
            ZR(JGLSN-1+NDIM*(INO-1)+J) = ZR(JGN-1+NDIM*(NUNO-1)+J)
            ZR(JGLST-1+NDIM*(INO-1)+J) = ZR(JGT-1+NDIM*(NUNO-1)+J)
            ZR(IGEOM-1+NDIM*(INO-1)+J) = ZR(JCOOR-1+3*(NUNO-1)+J)
 120      CONTINUE
 110    CONTINUE

        CALL CONFAC(TYPMA,IBID3,IBID,FA,NBF)

C       BOUCLE SUR LES FACES
        DO 200 IFQ=1,NBF

C         RECHERCHE DES INTERSECTION ENTRE LE FOND DE FISSURE ET LA FACE
          CALL INTFAC(IFQ,FA,NBNOMA,ZR(JLST),ZR(JLSN),NDIM,'OUI',
     &                JGLSN,JGLST,IGEOM,M,GLN,GLT,CODRET)

          IF (CODRET .EQ. 0) GOTO 200

C         LONGUEUR CARACTERISTIQUE
          DO 260 I=1,NDIM
            A(I) =  ZR(IGEOM-1+NDIM*(FA(IFQ,1)-1)+I)
            B(I) =  ZR(IGEOM-1+NDIM*(FA(IFQ,2)-1)+I)
            C(I) =  ZR(IGEOM-1+NDIM*(FA(IFQ,3)-1)+I)
 260      CONTINUE
          LONCAR=(PADIST(NDIM,A,B)+PADIST(NDIM,A,C))/2.D0

C         V�RIFICATION SI CE POINT A D�J� �T� TROUV�
          DO 612 J=1,IPT
            P(1)=ZR(JFON-1+4*(J-1)+1)
            P(2)=ZR(JFON-1+4*(J-1)+2)
            P(3)=ZR(JFON-1+4*(J-1)+3)

            IF (PADIST(NDIM,P,M).LT.(LONCAR*PREC)) THEN
C             POINT DEJA TROUVE
C             SI CE POINT (J) AVAIT ETE TROUVE SUR UNE FACE INTERNE,
C             IL FAUT APPELER XFABOR POUR VOIR SI LA FACE ACTUELLE
C             EST UNE FACE DE BORD OU PAS ET METTRE A JOUR LE
C             VECTEUR DE FACES DE BORD SI C'EST LE CAS
C             (CF. FICHE 14067)
              IF (ZL(JBORD-1+J)) GOTO 200
              IF (NDIM.NE.3)     GOTO 200
              NUNOA = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,1)-1)
              NUNOB = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,2)-1)
              NUNOC = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,3)-1)
              CALL XFABOR(NOMA,CNXINV,NUNOA,NUNOB,NUNOC,FABORD)
              IF (FABORD) THEN
                ZL(JBORD-1+J)=.TRUE.
                NPTBOR=NPTBOR+1
              ENDIF
              GOTO 200
            ENDIF
 612      CONTINUE

C         CE POINT N'A PAS D�J� �T� TROUV�, ON LE GARDE
          IPT=IPT+1
C         AUGMENTER NXPTFF
          CALL ASSERT(IPT.LE.NXPTFF)

C         STOCKAGE DES COORDONNEES DU POINT M
C         ET DE LA BASE LOCALE (GRADIENT DE LSN ET LST)
          DO 556 K=1,NDIM
            ZR(JFON-1+4*(IPT-1)+K)          =   M(K)
            ZR(JBAS-1+2*NDIM*(IPT-1)+K)     = GLN(K)
            ZR(JBAS-1+2*NDIM*(IPT-1)+K+NDIM)= GLT(K)
 556      CONTINUE

C         ON VERIFIE SI LA FACE COURANTE EST UNE FACE DE BORD
C         CELA N'A DE SENS QU'EN 3D
          IF (NDIM.EQ.3) THEN
            NUNOA = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,1)-1)
            NUNOB = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,2)-1)
            NUNOC = ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+FA(IFQ,3)-1)
            CALL XFABOR(NOMA,CNXINV,NUNOA,NUNOB,NUNOC,FABORD)
            IF (FABORD) THEN
              ZL(JBORD-1+IPT)=.TRUE.
              NPTBOR=NPTBOR+1
            ENDIF
          ENDIF

 200    CONTINUE

C       DESTRUCTION DES VECTEURS LOCAUX A LA MAILLE
        CALL JEDETR('&&XPTFON.LSN')
        CALL JEDETR('&&XPTFON.LST')
        CALL JEDETR('&&XPTFON.GRLSN')
        CALL JEDETR('&&XPTFON.GRLST')
        CALL JEDETR('&&XPTFON.IGEOM')

 100  CONTINUE

      NFON = IPT

      CALL JEDETR(CHGRN)
      CALL JEDETR(CHGRT)
      CALL JEDEMA()
      END
