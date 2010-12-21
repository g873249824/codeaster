      SUBROUTINE XBSIG2(ELREFP,ELRESE,NDIM,COORSE,IGEOM,
     &                  HE,NFH,DDLC,DDLM,NFE,
     &                  BASLOC,NNOP,NPG,SIGMA,LSN,LST,NFISS,FISNO,
     &                  IVECTU)

      IMPLICIT NONE
C
      CHARACTER*8   ELREFP,ELRESE
      CHARACTER*24  COORSE
      INTEGER       NFH,DDLC,DDLM,NFE
      INTEGER       IGEOM,NDIM,NNOP,NPG,IVECTU,NFISS,FISNO(NNOP,NFISS)
      REAL*8        HE(NFISS)
      REAL*8        BASLOC(6*NNOP),SIGMA(4,NPG),LSN(NNOP),LST(NNOP)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/12/2010   AUTEUR PELLET J.PELLET 
C TOLE CRS_1404
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     BUT:  CALCUL  DU PRODUIT BT. SIGMA SUR UN SOUS-ELEMENT X-FEM
C
C IN  ELREFP  : ELEMENT DE REFERENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONNEES DES SOMMETS DU SOUS-ELEMENT
C IN  IGEOM   : COORDONNEES DES NOEUDS DE L'ELEMENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-ELT
C IN  NFH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  DDLM    : NOMBRE DE DDL PAR NOEUD MILIEU
C IN  NFE     : NOMBRE DE FONCTIONS SINGULIERES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-ELEMENT
C IN  SIGMA   : CONTRAINTES DE CAUCHY
C IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
C IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS

C OUT IVECTU  : ADRESSE DU VECTEUR BT.SIGMA
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C     VARIABLES LOCALES
      INTEGER    DDLD,DDLS,NNO,NNOS,NPGBIS,CPT,IRET
      INTEGER    JCOORS,IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
      INTEGER    KPG,I,N,IG,M,INO
      REAL*8     XG(NDIM)
      REAL*8     DFDI(NNOP,NDIM),F(3,3),RBID2(6),BASLOG(9),FE(4)
      REAL*8     DGDGL(4,3),RAC2,RBID3(4),XE(NDIM),FF(NNOP)
      REAL*8     RBID4(4),JAC,RBID6(3,3),LSNG,LSTG
      REAL*8     DEF(6,NNOP,NDIM*(1+NFH+NFE)),SIGN(4)
      INTEGER    IBID,NNOPS,NN
      INTEGER    IBID2,IBID3,IBID4,IBID5,IBID6,IBID7,IBID8

      DATA       RAC2 / 1.4142135623731D0 /

C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET
      DDLD=NDIM*(1+NFH+NFE)

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLS=DDLD+DDLC

      CALL ELREF4(' ','RIGI',IBID,IBID2,NNOPS,IBID3,IBID4,IBID5,
     &                        IBID6,IBID7)

C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)

      CALL ELREF5(ELRESE,'XINT',NDIM,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
     &            IDFDE,JDFD2,JGANO)
C
      CALL ASSERT(NPG.EQ.NPGBIS)
C
C-----------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS
      DO 100 KPG=1,NPG

C       COORDONNEES DU PT DE GAUSS DANS LE REPERE REEL : XG
        CALL VECINI(NDIM,0.D0,XG)
        DO 110 I=1,NDIM
          DO 111 N=1,NNO
           XG(I)=XG(I)+ZR(IVF-1+NNO*(KPG-1)+N)*ZR(JCOORS-1+NDIM*(N-1)+I)
 111      CONTINUE
 110    CONTINUE

C       JUSTE POUR CALCULER LES FF
        CALL REEREF(ELREFP,NNOP,NNOPS,IGEOM,XG,IBID,.FALSE.,NDIM,HE,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'NON',
     &              XE,FF,DFDI,F,RBID2,RBID6)

        IF (NFE.GT.0) THEN
C         BASE LOCALE ET LEVEL SETS AU POINT DE GAUSS
          CALL VECINI(6,0.D0,BASLOG)
          LSNG = 0.D0
          LSTG = 0.D0
          DO 112 INO=1,NNOP
            LSNG = LSNG + LSN(INO) * FF(INO)
            LSTG = LSTG + LST(INO) * FF(INO)
            DO 113 I=1,6
              BASLOG(I) = BASLOG(I) + BASLOC(6*(INO-1)+I) * FF(INO)
 113        CONTINUE
 112      CONTINUE

C         DERIVEES DES FONCTION D'ENRICHISSEMENT AU POINT DE GAUSS
          CALL XCALF2(XG,HE,LSNG,LSTG,BASLOG,FE,DGDGL,IRET)
C         PB CALCUL DES DERIVEES DES FONCTIONS SINGULIERES SUR LE
C         FOND DE FISSURE
          CALL ASSERT(IRET.NE.0)
        ENDIF

C       COORDONNEES DU POINT DE GAUSS DANS L'ELEMENT DE REF PARENT : XE
C       ET CALCUL DE FF, DFDI, ET EPS
        CALL REEREF(ELREFP,NNOP,NNOPS,IGEOM,XG,IBID,.FALSE.,NDIM,HE,
     &              FISNO,NFISS,NFH,NFE,DDLS,DDLM,FE,DGDGL,'OUI',
     &              XE,FF,DFDI,F,RBID2,RBID6)

C       CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 120 N=1,NNOP
          CALL INDENT(N,DDLS,DDLM,NNOPS,NN)

          CPT=0
C         FONCTIONS DE FORME CLASSIQUES
          DO 121 I=1,2
            CPT=CPT+1
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 121      CONTINUE

C         ENRICHISSEMENT PAR HEAVYSIDE
          DO 122 IG=1,NFH
            DO 123 I =1,2
              CPT=CPT+1
              DEF(1,N,CPT) =  DEF(1,N,I) * HE(FISNO(N,IG))
              DEF(2,N,CPT) =  DEF(2,N,I) * HE(FISNO(N,IG))
              DEF(3,N,CPT) =  0.D0
              DEF(4,N,CPT) =  DEF(4,N,I) * HE(FISNO(N,IG))
 123        CONTINUE
 122      CONTINUE
C         ENRICHISSEMENT PAR LES NFE FONTIONS SINGULI�RES
          DO 124 IG=1,NFE
            DO 125 I=1,2
              CPT=CPT+1
              DEF(1,N,CPT) =  F(I,1) *
     &             (DFDI(N,1) * FE(IG) + FF(N)*DGDGL(IG,1))

              DEF(2,N,CPT) =  F(I,2) *
     &             (DFDI(N,2) * FE(IG) + FF(N)*DGDGL(IG,2))
              DEF(3,N,CPT) =  0.D0

              DEF(4,N,CPT) =
     &         ( F(I,1)* (DFDI(N,2)*FE(IG)+FF(N)*DGDGL(IG,2))
     &         + F(I,2)* (DFDI(N,1)*FE(IG)+FF(N)*DGDGL(IG,1)) )/RAC2
 125         CONTINUE
 124       CONTINUE
        CALL ASSERT(CPT.EQ.DDLD)
 120    CONTINUE

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
C       ON APPELLE DFDM2D AVEC LES COORDONNEES DU SOUS-ELEMENT
        CALL DFDM2D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                   RBID3,RBID4,JAC)


        DO 1210 N=1,3
          SIGN(N)   = SIGMA(N  ,KPG)
 1210   CONTINUE
        SIGN(4) = SIGMA(4,KPG)*RAC2

        DO 130 N=1,NNOP
          CALL INDENT(N,DDLS,DDLM,NNOPS,NN)

          DO 131 I=1,DDLD
            DO 132 M=1,4
              ZR(IVECTU-1+NN+I)=
     &        ZR(IVECTU-1+NN+I)+DEF(M,N,I)*SIGN(M)*JAC
 132        CONTINUE
 131      CONTINUE

 130    CONTINUE


 100  CONTINUE

C.============================ FIN DE LA ROUTINE ======================
      END
