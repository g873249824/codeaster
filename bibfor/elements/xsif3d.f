      SUBROUTINE XSIF3D(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                  BASLOC,NNOP,NPG,DEPL,LSN,LST,IGTHET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

      IMPLICIT NONE
      CHARACTER*8   ELREFP
      CHARACTER*24  COORSE
      INTEGER       IGEOM,NDIM,DDLH,DDLC,NFE,NNOP,NPG
      REAL*8        HE,DEPL(NDIM+DDLH+NDIM*NFE+DDLC,NNOP)
      REAL*8        BASLOC(9*NNOP),LSN(NNOP),LST(NNOP)


C    - FONCTION REALISEE:  CALCUL DES OPTIONS DE POST-TRAITEMENT
C                          EN M�CANIQUE DE LA RUPTURE
C                          POUR LES �L�MENTS X-FEM
C

C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE AUX NOEUDS
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-�L�MENT
C IN  DEPL    : D�PLACEMENTS
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS

C OUT IGTHET  : G, K1, K2, K3

      INTEGER  ITHET,IMATE,ICOMP,ICOUR,IGTHET,JCOORS
      INTEGER  IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
      INTEGER  I,J,K,KPG,N,INO,IRET
      INTEGER  NDIMB,NNO,NNOS,NPGBIS,DDLD,DDLT
      REAL*8   G,K1,K2,K3,COEFF,COEFF3,VALRES(3),TEMPG,R8PREM
      REAL*8   DEVRES(3),E,NU,LAMBDA,MU,KA,C1,C2,C3,XG(NDIM),FE(4)
      REAL*8   DGDGL(4,3),XE(NDIM),FF(NNOP),DFDI(NNOP,NDIM),F(3,3)
      REAL*8   EPS(6),BASLOG(9),E1(3),E2(3),NORME,E3(3),P(3,3)
      REAL*8   DET,INVP(3,3),AG(3),VGL(3),XLG,YLG,RG,TG,RBID1(4)
      REAL*8   DGDPO(4,2),DGDLO(4,3),COURB(3,3,3),DU1DM(3,3),DU2DM(3,3)
      REAL*8   DU3DM(3,3),GRAD(3,3),DUDM(3,3),POIDS,RBID2(4),RBID3(4)
      REAL*8   DTDM(3,3),TZERO(3),DZERO(3,4),LSNG,LSTG
      REAL*8   DUDME(3,4),DTDME(3,4),DU1DME(3,4),DU2DME(3,4),DU3DME(3,4)
      CHARACTER*2  CODRET(3)
      CHARACTER*8  NOMRES(3)
      CHARACTER*16 COMPOR(4)
      LOGICAL  LCOUR,GRDEPL

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CALL JEMARQ()

      GRDEPL=.FALSE.

C     ATTENTION, DEPL ET VECTU SONT ICI DIMENSIONN�S DE TELLE SORTE
C     QU'ILS NE PRENNENT PAS EN COMPTE LES DDL SUR LES NOEUDS MILIEU

C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET
      DDLD=NDIM+DDLH+NDIM*NFE

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLT=DDLD+DDLC

      CALL JEVECH('PTHETAR','L',ITHET)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PCOURB','L',ICOUR)

C     V�RIFICATION DU CADRE TH�ORIQUE DU CALCUL
      DO 20 I = 3,4
        COMPOR(I) = ZK16(ICOMP+I-1)
 20   CONTINUE
      IF ((COMPOR(3) (1:5) .EQ. 'GREEN').OR.
     &    (COMPOR(4) (1:9) .EQ. 'COMP_INCR')) THEN
        CALL U2MESS('F','ELEMENTS3_68')
      ENDIF

C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)

C     TE4-'XINT' : SCH�MAS � 15 POINTS
      CALL ELREF5('TE4','XINT',NDIMB,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
     &                  IDFDE,JDFD2,JGANO)
      CALL ASSERT(NPG.EQ.NPGBIS.AND.NDIM.EQ.NDIMB)

C     RECUPERATION DES DONNEES MATERIAUX
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      TEMPG=0.D0
      CALL RCVADA (ZI(IMATE),'ELAS',TEMPG,2,NOMRES,VALRES,DEVRES,CODRET)
      E   = VALRES(1)

      NU  = VALRES(2)



      LAMBDA  = NU*E/((1.D0+NU)*(1.D0-2.D0*NU))
      MU  = E/(2.D0*(1.D0+NU))
C     EN DP
      KA=3.D0-4.D0*NU
      COEFF=E/(1.D0-NU*NU)
      COEFF3=2.D0 * MU
C     EN CP
C     KA=(3.D0-NU)/(1.D0+NU)
C     COEFF=E
C     COEFF3=2.D0 * MU
      C1 = LAMBDA + 2.D0 * MU
      C2 = LAMBDA
      C3 = MU

C     BOUCLE SUR LES POINTS DE GAUSS DU SOUS-T�TRA
      DO 100 KPG=1,NPG

C       INITIALISATIONS
        CALL LCINVN(9,0.D0,DTDM)
        CALL LCINVN(9,0.D0,DU1DM)
        CALL LCINVN(9,0.D0,DU2DM)
        CALL LCINVN(9,0.D0,DU3DM)

C       COORDONN�ES DU PT DE GAUSS DANS LE REP�RE R�EL : XG
        CALL LCINVN(NDIM,0.D0,XG)
        DO 110 I=1,NDIM
          DO 111 N=1,NNO
            XG(I)=XG(I)+ZR(IVF-1+NNO*(KPG-1)+N)*ZR(JCOORS-1+3*(N-1)+I)
 111      CONTINUE
 110    CONTINUE

C       CALCUL DES FF
        CALL REEREF(ELREFP,NNOP,IGEOM,XG,DEPL,GRDEPL,NDIM,HE,DDLH,NFE,
     &              DDLT,FE,DGDGL,'NON',XE,FF,DFDI,F,EPS,GRAD)

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
C       ON ENVOIE DFDM3D AVEC LES COORD DU SS-ELT
        CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                   RBID1,RBID2,RBID3,POIDS)

C       --------------------------------------
C       1) COORDONN�ES POLAIRES ET BASE LOCALE
C       --------------------------------------

C       BASE LOCALE ET LEVEL SETS AU POINT DE GAUSS
        CALL LCINVN(NDIM,0.D0,E1)
        CALL LCINVN(NDIM,0.D0,E2)
        LSNG=0.D0
        LSTG=0.D0
        DO 113 INO=1,NNOP
          LSNG = LSNG + LSN(INO) * FF(INO)
          LSTG = LSTG + LST(INO) * FF(INO)
          DO 114 I=1,NDIM
            E1(I) = E1(I) + BASLOC(9*(INO-1)+I+3) * FF(INO)
            E2(I) = E2(I) + BASLOC(9*(INO-1)+I+6) * FF(INO)
 114      CONTINUE
 113    CONTINUE

C       NORMALISATION DE LA BASE
        CALL NORMEV(E1,NORME)
        CALL NORMEV(E2,NORME)
        CALL PROVEC(E1,E2,E3)

C       CALCUL DE LA MATRICE DE PASSAGE P TQ 'GLOBAL' = P * 'LOCAL'
        DO 124 I=1,NDIM
          P(I,1)=E1(I)
          P(I,2)=E2(I)
          P(I,3)=E3(I)
 124    CONTINUE

C       V�RIFICATION QUE LE D�TERMINANT DE P VAUT BIEN 1
        DET = P(1,1)*P(2,2)*P(3,3) + P(2,1)*P(3,2)*P(1,3)
     &      + P(3,1)*P(1,2)*P(2,3) - P(3,1)*P(2,2)*P(1,3)
     &      - P(2,1)*P(1,2)*P(3,3) - P(1,1)*P(3,2)*P(2,3)

        IF (ABS(DET-1.D0).GT.1.D-3)
     &    CALL U2MESS('A','ALGORITH11_41')
C       CALCUL DE L'INVERSE DE LA MATRICE DE PASSAGE : INV=TRANSPOSE(P)
        DO 125 I=1,3
          DO 126 J=1,3
            INVP(I,J)=P(J,I)
 126      CONTINUE
 125    CONTINUE

C       COORDONN�ES POLAIRES DU POINT
        RG=SQRT(LSNG**2+LSTG**2)

        IF (RG.GT.R8PREM()) THEN
C         LE POINT N'EST PAS SUR LE FOND DE FISSURE
          TG = HE * ABS(ATAN2(LSNG,LSTG))
          IRET=1
        ELSE
C         LE POINT EST SUR LE FOND DE FISSURE :
C         L'ANGLE N'EST PAS D�FINI, ON LE MET � Z�RO
C         ON NE FERA PAS LE CALCUL DES D�RIV�ES
          TG=0.D0
          IRET=0
        ENDIF
C
        IF (IRET.EQ.0) CALL U2MESS('F','ELEMENTS3_69')

C       -----------------
C       2) CALCUL DE DUDM
C       -----------------

C       FONCTIONS D'ENRICHISSEMENT
        FE(1)=SQRT(RG)*SIN(TG/2.D0)
        FE(2)=SQRT(RG)*COS(TG/2.D0)
        FE(3)=SQRT(RG)*SIN(TG/2.D0)*SIN(TG)
        FE(4)=SQRT(RG)*COS(TG/2.D0)*SIN(TG)

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE
        DGDPO(1,1)=1.D0/(2.D0*SQRT(RG))*SIN(TG/2.D0)
        DGDPO(1,2)=SQRT(RG)/2.D0*COS(TG/2.D0)
        DGDPO(2,1)=1.D0/(2.D0*SQRT(RG))*COS(TG/2.D0)
        DGDPO(2,2)=-SQRT(RG)/2.D0*SIN(TG/2.D0)
        DGDPO(3,1)=1.D0/(2.D0*SQRT(RG))*SIN(TG/2.D0)*SIN(TG)
        DGDPO(3,2)=SQRT(RG) *
     &            (COS(TG/2.D0)*SIN(TG)/2.D0 + SIN(TG/2.D0)*COS(TG))
        DGDPO(4,1)=1.D0/(2.D0*SQRT(RG))*COS(TG/2.D0)*SIN(TG)
        DGDPO(4,2)=SQRT(RG) *
     &            (-SIN(TG/2.D0)*SIN(TG)/2.D0 + COS(TG/2.D0)*COS(TG))

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE LOCALE
        DO 131 I=1,4
          DGDLO(I,1)=DGDPO(I,1)*COS(TG)-DGDPO(I,2)*SIN(TG)/RG
          DGDLO(I,2)=DGDPO(I,1)*SIN(TG)+DGDPO(I,2)*COS(TG)/RG
          DGDLO(I,3)=0.D0
 131    CONTINUE

C       D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE GLOBALE
        DO 132 I=1,4
          DO 133 J=1,3
            DGDGL(I,J)=0.D0
            DO 134 K=1,3
              DGDGL(I,J)=DGDGL(I,J)+DGDLO(I,K)*INVP(K,J)
 134        CONTINUE
 133      CONTINUE
 132    CONTINUE

        CALL REEREF(ELREFP,NNOP,IGEOM,XG,DEPL,GRDEPL,NDIM,HE,DDLH,NFE,
     &              DDLT,FE,DGDGL,'OUI',XE,FF,DFDI,F,EPS,DUDM)

C       -----------------
C       3) CALCUL DE DTDM
C       -----------------
C
        DO 120 I=1,NDIM
          DO 121 J=1,NDIM
             DO 122 INO=1,NNOP
              DTDM(I,J)=DTDM(I,J)+ZR(ITHET+NDIM*(INO-1)+I-1)*DFDI(INO,J)
122         CONTINUE
121       CONTINUE
120     CONTINUE

C       ---------------------------------------------
C       4) CALCUL DES D�RIV�ES DES CHAMPS AUXILIAIRES
C       ---------------------------------------------

C       RECUPERATION DU TENSEUR DE COURBURE
        DO 127 I=1,3
          DO 128 J=1,3
            COURB(I,1,J)=ZR(ICOUR-1+3*(I-1)+J)
            COURB(I,2,J)=ZR(ICOUR-1+3*(I+3-1)+J)
            COURB(I,3,J)=ZR(ICOUR-1+3*(I+6-1)+J)
 128      CONTINUE
 127    CONTINUE
C       PRISE EN COMPTE DE LA COURBURE
        LCOUR=.TRUE.

        CALL CHAUXI(NDIM,MU,KA,RG,TG,INVP,LCOUR,COURB,DU1DM,DU2DM,DU3DM)

C       ---------------------------------------------
C       5) CALCUL DE G, K1, K2, K2 AU POINT DE GAUSS (TCLA UNIQUEMENT!)
C       --------------------------------------------
        DO 140 I=1,3
          TZERO(I) = 0.D0
          DO 141 J=1,4
            DZERO(I,J) = 0.D0
 141      CONTINUE
 140    CONTINUE

C       AVEC LA MODIF D'ERWAN, IL FAUT PASSER LES DUDM ET DTDM DIM (3,3)
C       EN DUDME DE DIM (3,4)
        DO 150 I=1,3
          DO 151 J=1,3
            DUDME(I,J) = DUDM(I,J)
            DTDME(I,J) = DTDM(I,J)
            DU1DME(I,J) = DU1DM(I,J)
            DU2DME(I,J) = DU2DM(I,J)
            DU3DME(I,J) = DU3DM(I,J)
 151      CONTINUE
          DUDME(I,4) = 0.D0
          DTDME(I,4) = 0.D0
          DU1DME(I,4) = 0.D0
          DU2DME(I,4) = 0.D0
          DU3DME(I,4) = 0.D0
 150    CONTINUE

        CALL GBIL3D(DUDME,DUDME,DTDME,DZERO,DZERO,TZERO,TZERO,
     &              0.D0,0.D0,POIDS,C1,C2,C3,0.D0,0.D0,0.D0,G)
        ZR(IGTHET )= ZR(IGTHET) + G

        CALL GBIL3D(DUDME,DU1DME,DTDME,DZERO,DZERO,TZERO,TZERO,
     &              0.D0,0.D0,POIDS,C1,C2,C3,0.D0,0.D0,0.D0,K1)
        ZR(IGTHET+1 )= ZR(IGTHET+1) + K1 * COEFF

        CALL GBIL3D(DUDME,DU2DME,DTDME,DZERO,DZERO,TZERO,TZERO,
     &              0.D0,0.D0,POIDS,C1,C2,C3,0.D0,0.D0,0.D0,K2)
        ZR(IGTHET+2) = ZR(IGTHET+2) + K2 * COEFF

        CALL GBIL3D(DUDME,DU3DME,DTDME,DZERO,DZERO,TZERO,TZERO,
     &              0.D0,0.D0,POIDS,C1,C2,C3,0.D0,0.D0,0.D0,K3)
        ZR(IGTHET+3) = ZR(IGTHET+3) + K3 * COEFF3

100   CONTINUE

      CALL JEDEMA()
      END
