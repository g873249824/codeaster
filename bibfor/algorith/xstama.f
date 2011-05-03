      SUBROUTINE XSTAMA(NOMO,NOMA,NBMA,NMAFIS,JMAFIS,NCOUCH,LISNOE,
     &                  STANO,CNSLT,CNSLN,
     &                  JMAFON,JMAEN1,JMAEN2,JMAEN3,
     &                  NMAFON,NMAEN1,NMAEN2,NMAEN3 )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/05/2011   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      INTEGER       NMAFIS,NMAFON,NMAEN1,NMAEN2,NMAEN3,NBMA,JMAFIS
      INTEGER       NCOUCH,STANO(*),JMAFON,JMAEN1,JMAEN2,JMAEN3
      CHARACTER*8   NOMO,NOMA
      CHARACTER*19  CNSLT,CNSLN
      CHARACTER*24  LISNOE
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM
C
C CALCUL DU STATUT DES MAILLES
C   + PRISE EN COMPTE SI NECESSAIRE DE L'ENRICHISSEMENT A NB_COUCHES
C   -> MAJ DE STANO
C
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DU MODELE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C IN  NMAFIS : NOMBRE DE MAILLES DE LA ZONE FISSURE
C IN  JMAFIS : ADRESSE DES MAILLES DE LA ZONE FISSURE
C IN  NCOUCH : NOMBRE DE COUCHES D'ENRICHISSEMENT GEOMETRIQUE
C IN  LISNOE : NOM DE LA LISTE DES NOEUDS DE GROUP_ENRI
C IN  CNSLT  : LEVEL-SET TANGENTE (TRACE DE LA FISSURE)
C IN  CNSLN  : LEVEL-SET NORMALE  (PLAN DE LA FISSURE)

C OUT  NMAFON : NOMBRE DE MAILLES CONTENANT LE FOND DE FISSURE
C OUT  NMAEN1 : NOMBRE DE MAILLES 'HEAVISIDE'
C OUT  NMAEN2 : NOMBRE DE MAILLES 'CRACKTIP'
C OUT  NMAEN3 : NOMBRE DE MAILLES 'HEAVISIDE-CRACKTIP'
C OUT  JMAFON : POINTEUR SUR MAILLES 'CONTENANT LE FOND DE FISSURE
C OUT  JMAEN1 : POINTEUR SUR MAILLES 'HEAVISIDE'
C OUT  JMAEN2 : POINTEUR SUR MAILLES 'CRACKTIP'
C OUT  JMAEN3 : POINTEUR SUR MAILLES 'HEAVISIDE-CRACKTIP'

C IN/OUT  STANO  : VECTEUR STATUT DES NOEUDS


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
      INTEGER       JMA,IRET,IGEOM,JCOORD,JCONX1,JCONX2
      INTEGER       IMA,ITYPMA,J,IDIM,NDIM
      INTEGER       NUNO,IFM,NIV
      INTEGER       NBNOE,INO,NABS,JDLINO,NBNOMA
      INTEGER       JLTSV,JLNSV
      REAL*8        HFF,R8MAEM,DIAM,LSN,LST,RAYON
      CHARACTER*8   TYPMA,K8B
      CHARACTER*19  MAI


      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)

      MAI=NOMA//'.TYPMAIL'
      CALL JEVEUO(MAI,'L',JMA)
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',IGEOM)
      CALL JEVEUO(NOMA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX2)

C     1) STATUT DES MAILLES SANS TENIR COMPTE DE NB_COUCHES
C     --------------------------------------------------
      CALL XSTAM1(NOMO,NOMA,NBMA,NMAFIS,ZI(JMAFIS),STANO,
     &            ZI(JMAFON),ZI(JMAEN1),ZI(JMAEN2),ZI(JMAEN3),
     &            NMAFON,NMAEN1,NMAEN2,NMAEN3 )

C     S'IL N'Y A PAS DE MAILLES DE FOND, ON SORT
      IF (NMAFON.EQ.0) GOTO 9999

C     SI NB_COUCH N'EST PAS DEFINI, ON SORT
      IF (NCOUCH.EQ.0) GOTO 9999

C     2) POUR TENIR COMPTE DE L'ENRICHISSEMENT GEOMETRIQUE A NB_COUCH
C     ------------------------------------------------------------
      IF (NCOUCH.GT.0) THEN

C       DIMENSINO DU MAILLAGE
        CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8B,IRET)

C       LEVEL SETS
        CALL JEVEUO(CNSLT//'.CNSV','L',JLTSV)
        CALL JEVEUO(CNSLN//'.CNSV','L',JLNSV)

C       CALCUL DE HFF : TAILLE MINIMALE D'UNE MAILLE DE MAFON
        HFF = R8MAEM()
        DO 400 J = 1,NMAFON
          IMA = ZI(JMAFON-1+J)
          ITYPMA=ZI(JMA-1+IMA)
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPMA),TYPMA)

C         CONSTRUCTION DES COORDONNES DE LA MAILLE
          NBNOMA = ZI(JCONX2+IMA) - ZI(JCONX2+IMA-1)
          CALL WKVECT('&&XSTAMA.MACOORD','V V R',NDIM*NBNOMA,JCOORD)
          DO 401 INO = 1,NBNOMA
            NUNO = ZI(JCONX1-1+ZI(JCONX2+IMA-1)+INO-1)
            DO 402 IDIM = 1,NDIM
              ZR(JCOORD-1+NDIM*(INO-1)+IDIM)=ZR(IGEOM-1+3*(NUNO-1)+IDIM)
 402        CONTINUE
 401      CONTINUE

          CALL LONCAR(NDIM,TYPMA,ZR(JCOORD),DIAM)
          CALL JEDETR('&&XSTAMA.MACOORD')
          HFF = MIN(HFF,DIAM)
 400    CONTINUE

        RAYON = HFF*NCOUCH
        WRITE(IFM,*)'LE RAYON D ENRICHISSEMENT EQUIVALENT EST ',RAYON

C       ON MODIFIE L'ENRICHISSEMENT DES NOEUDS (MAJ STANO)
C       SI ANCIEN STANO = 0 -> 2
C       SI ANCIEN STANO = 1 -> 3
        CALL JELIRA(LISNOE,'LONMAX',NBNOE,K8B)
        CALL JEVEUO(LISNOE,'L',JDLINO)
        DO 410 INO=1,NBNOE
          NABS=ZI(JDLINO-1+(INO-1)+1)
          IF (STANO(NABS).LE.1) THEN
            LSN=ZR(JLNSV-1+(NABS-1)+1)
            LST=ZR(JLTSV-1+(NABS-1)+1)
            IF (SQRT(LSN**2+LST**2).LE.RAYON) THEN
              STANO(NABS) = STANO(NABS) + 2
            ENDIF
          ENDIF
 410    CONTINUE

        CALL JERAZO('&&XENRCH.MAFOND',NMAFIS,1)
        CALL JERAZO('&&XENRCH.MAENR1',NBMA,1)
        CALL JERAZO('&&XENRCH.MAENR2',NBMA,1)
        CALL JERAZO('&&XENRCH.MAENR3',NBMA,1)

C       ON RECOMMENCE L'ENRICHISSEMENT DES MAILLES AVEC LE NOUVEAU STANO
        CALL XSTAM1(NOMO,NOMA,NBMA,NMAFIS,ZI(JMAFIS),STANO,
     &              ZI(JMAFON),ZI(JMAEN1),ZI(JMAEN2),ZI(JMAEN3),
     &              NMAFON,NMAEN1,NMAEN2,NMAEN3 )

      ENDIF

 9999 CONTINUE

      CALL JEDEMA()
      END
