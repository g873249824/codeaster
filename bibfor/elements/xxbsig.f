      SUBROUTINE XXBSIG(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,
     &                  BASLOC,NNOP,NPG,SIGMA,BSIGMA)
        
      IMPLICIT NONE
C
      CHARACTER*8   ELREFP
      CHARACTER*24  COORSE
      INTEGER       IGEOM,NDIM,DDLH,DDLC,NFE,NNOP,NPG
      REAL*8        HE,BASLOC(9*NNOP),SIGMA(6,NPG)
      REAL*8        BSIGMA(NDIM+DDLH+NFE*NDIM+DDLC,NNOP)

C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 05/09/2005   AUTEUR VABHHTS J.PELLET 
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
C
C     BUT:  CALCUL  DU PRODUIT BT. SIGMA SUR UN SOUS-T�TRA X-FEM
C
C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NFE     : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-�L�MENT
C IN  SIGMA   : CONTRAINTES DE CAUCHY

C OUT BSIGMA  : BT.SIGMA
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
      INTEGER    DDLD,DDLT,NNO,NNOS,NPGBIS,CPT
      INTEGER    JCOORS,IPOIDS,JCOOPG,IVF,IDFDE,JDFD2,JGANO
      INTEGER    KPG,I,N,IG,M,INO
      REAL*8     XG(NDIM),RBID1(NDIM+DDLH+NDIM*NFE+DDLC,NNOP)
      REAL*8     DFDI(NNOP,NDIM),F(3,3),RBID2(6),BASLOG(9),FE(4)
      REAL*8     DGDGL(4,3),RAC2,RBID3(4),XE(NDIM),FF(NNOP)
      REAL*8     RBID4(4),RBID5(4),JAC,RBID6(3,3)
      REAL*8     DEF(6,NNOP,NDIM+DDLH+NDIM*NFE)
      DATA       RAC2 / 1.4142135623731D0 /
      
C.========================= DEBUT DU CODE EXECUTABLE ==================

C     ATTENTION, BSIGMA EST DIMENSIONN� DE TELLE SORTE 
C     QU'IL NE PRENNE PAS EN COMPTE LES DDL SUR LES NOEUDS MILIEU
C
C     NOMBRE DE DDL DE DEPLACEMENT � CHAQUE NOEUD SOMMET 
      DDLD=NDIM+DDLH+NDIM*NFE

C     NOMBRE DE DDL TOTAL (DEPL+CONTACT) � CHAQUE NOEUD SOMMET
      DDLT=DDLD+DDLC

C     MISE � Z�RO D'UNE MATRICE BIDON
      CALL MATINI(DDLT,NNOP,0.D0,RBID1)

C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)

C     TE4-'RIGI' : SCH�MAS � 15 POINTS        
      CALL ELREF5('TE4','RIGI',NDIM,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
     &                  IDFDE,JDFD2,JGANO)
C
      CALL ASSERT(NPG.EQ.NPGBIS)
C
C-----------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS
      DO 100 KPG=1,NPG      

C       COORDONN�ES DU PT DE GAUSS DANS LE REP�RE R�EL : XG 
        CALL LCINVN(NDIM,0.D0,XG)
        DO 110 I=1,3
          DO 111 N=1,NNO
            XG(I)=XG(I)+ZR(IVF-1+NNO*(KPG-1)+N)*ZR(JCOORS-1+3*(N-1)+I)
 111      CONTINUE
 110    CONTINUE

C             JUSTE POUR CALCULER LES FF
        CALL REEREF(ELREFP,NNOP,IGEOM,XG,RBID1,.FALSE.,NDIM,HE,DDLH,NFE,
     &              DDLT,FE,DGDGL,'NON',XE,FF,DFDI,F,RBID2,RBID6)

        IF (NFE.GT.0) THEN
C         BASE LOCALE AU POINT DE GAUSS
          CALL LCINVN(9,0.D0,BASLOG)
          DO 112 INO=1,NNOP
            DO 113 I=1,9 
              BASLOG(I) = BASLOG(I) + BASLOC(9*(INO-1)+I) * FF(INO)
 113        CONTINUE 
 112      CONTINUE
         
C         D�RIV�ES DES FONCTION D'ENRICHISSEMENT AU POINT DE GAUSS
          CALL XCALFE(XG,BASLOG,FE,DGDGL)
        ENDIF

C       COORDONN�ES DU POINT DE GAUSS DANS L'�L�MENT DE R�F PARENT : XE
C       ET CALCUL DE FF, DFDI, ET EPS
        CALL REEREF(ELREFP,NNOP,IGEOM,XG,RBID1,.FALSE.,NDIM,HE,DDLH,NFE,
     &              DDLT,FE,DGDGL,'OUI',XE,FF,DFDI,F,RBID2,RBID6)

C       CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 120 N=1,NNOP
          CPT=0
C         FONCTIONS DE FORME CLASSIQUES
          DO 121 I=1,3
            CPT=CPT+1
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  F(I,3)*DFDI(N,3)
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
            DEF(5,N,I) = (F(I,1)*DFDI(N,3) + F(I,3)*DFDI(N,1))/RAC2
            DEF(6,N,I) = (F(I,2)*DFDI(N,3) + F(I,3)*DFDI(N,2))/RAC2
 121      CONTINUE
C         ENRICHISSEMENT PAR HEAVYSIDE
          DO 122 I=1,DDLH
            CPT=CPT+1
            DO 123 M=1,6
              DEF(M,N,CPT) =  DEF(M,N,I) * HE       
 123        CONTINUE
 122      CONTINUE
C         ENRICHISSEMENT PAR LES NFE FONTIONS SINGULI�RES
          DO 124 IG=1,NFE
            DO 125 I=1,3
              CPT=CPT+1
              DEF(1,N,CPT) =  F(I,1) *
     &             (DFDI(N,1) * FE(IG) + FF(N)*DGDGL(IG,1))
    
              DEF(2,N,CPT) =  F(I,2) *
     &             (DFDI(N,2) * FE(IG) + FF(N)*DGDGL(IG,2))
     
              DEF(3,N,CPT) =  F(I,3) *
     &             (DFDI(N,3) * FE(IG) + FF(N)*DGDGL(IG,3))
     
              DEF(4,N,CPT) = 
     &         ( F(I,1)* (DFDI(N,2)*FE(IG)+FF(N)*DGDGL(IG,2)) 
     &         + F(I,2)* (DFDI(N,1)*FE(IG)+FF(N)*DGDGL(IG,1)) )/RAC2
              
              DEF(5,N,CPT) =  
     &         ( F(I,1)* (DFDI(N,3)*FE(IG)+FF(N)*DGDGL(IG,3)) 
     &         + F(I,3)* (DFDI(N,1)*FE(IG)+FF(N)*DGDGL(IG,1)) )/RAC2
     
              DEF(6,N,CPT) =  
     &         ( F(I,3)* (DFDI(N,2)*FE(IG)+FF(N)*DGDGL(IG,2)) 
     &         + F(I,2)* (DFDI(N,3)*FE(IG)+FF(N)*DGDGL(IG,3)) )/RAC2
     
 125         CONTINUE
 124       CONTINUE

        CALL ASSERT(CPT.EQ.DDLD)

 120    CONTINUE     

C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
C       ON APPELLE DFDM3D AVEC LES COORDONNEES DU SOUS-TETRA  
        CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                   RBID3,RBID4,RBID5,JAC)

C       CALCUL DE LA FORCE INTERIEURE : BSIGMA
        DO 130 N=1,NNOP
          DO 131 I=1,DDLD
            DO 132 M=1,6
              BSIGMA(I,N)=BSIGMA(I,N)+DEF(M,N,I)*SIGMA(M,KPG)*JAC
 132        CONTINUE 
 131      CONTINUE
 130    CONTINUE

 100  CONTINUE
 
C.============================ FIN DE LA ROUTINE ======================
      END
