      SUBROUTINE  XIBSIG(ELREFP,COORSE,IGEOM,HE,DDLH,DDLC,NNOP,NPG,
     &                   SIGMA,BSIGMA)

      IMPLICIT NONE
C
      CHARACTER*8   ELREFP
      CHARACTER*24  COORSE,HEAV
      INTEGER       IGEOM,DDLH,DDLC,NNOP,NPG
      REAL*8        HE,SIGMA(6,NPG),BSIGMA(3+DDLH+DDLC,NNOP)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/01/2005   AUTEUR GENIAUT S.GENIAUT 
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
C
C     BUT:  CALCUL  DU PRODUIT BT. SIGMA SUR UN SOUS-T�TRA X-FEM
C.......................................................................

C IN  ELREFP  : �L�MENT DE R�F�RENCE PARENT
C IN  COORSE  : COORDONN�ES DES SOMMETS DU SOUS-�L�MENT
C IN  IGEOM   : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  DDLH    : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
C IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-�L�MENT
C IN  DEPLM   : DEPLACEMENT � L'�QUILIBRE PR�C�DENT
C IN  SIGMA   : CONTRAINTES DE CAUCHY

C OUT BSIGMA  : BT.SIGMA
C
C......................................................................
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
      INTEGER  KPG,N,I,M
      INTEGER  NDIM,NNO,NNOS,NPGBIS,IPOIDS
      INTEGER  JCOOPG,IVF,IDFDE,JDFD2,JGANO,JCOORS,JHEAV
      REAL*8   DFDI(NNOP,3),XG(3),XE(3),RAC2,JAC,DEF(6,NNOP,3+DDLH)
      REAL*8   F(3,3),FF(NNOP)
      REAL*8   RBID1(4),RBID2(4),RBID3(4),RBID4(3,NNOP),RBID5(6)
      DATA     RAC2 / 1.4142135623731D0 /
C--------------------------------------------------------------------
C
C     INITIALISATIONS
      CALL MATINI(3,NNOP,0.D0,RBID4)
C      
C     ADRESSE DES COORD DU SOUS ELT EN QUESTION
      CALL JEVEUO(COORSE,'L',JCOORS)
C
C       TE4-'RIGI' : SCH�MAS � 15 POINTS        
      CALL ELREF5('TE4','RIGI',NDIM,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
     &                  IDFDE,JDFD2,JGANO)

C      HE8-'MASS' : SCH�MAS � 27 POINTS
C      CALL ELREF5('HE8','RIGI',NDIM,NNO,NNOS,NPGBIS,IPOIDS,JCOOPG,IVF,
C     &                  IDFDE,JDFD2,JGANO)

      CALL ASSERT(NPG.EQ.NPGBIS)

C - CALCUL POUR CHAQUE POINT DE GAUSS DU SOUS-TETRA
C
      DO 800 KPG=1,NPG
C
C - CALCUL DES ELEMENTS GEOMETRIQUES
C       COORDONN�ES DU PT DE GAUSS DANS LE REP�RE R�EL : XG 
        CALL LCINVN(3,0.D0,XG)
        DO 120 I=1,3
          DO 121 N=1,NNO
            XG(I)=XG(I)+ZR(IVF-1+NNO*(KPG-1)+N)*ZR(JCOORS-1+3*(N-1)+I)
 121      CONTINUE
 120    CONTINUE
C
C       COORDONN�ES DU POINT DE GAUSS DANS L'�L�MENT DE R�F PARENT : XE
C       ET CALCUL DE DFDI
        CALL REEREF(ELREFP,NNOP,DDLH,IGEOM,XG,RBID4,.FALSE.,
     &                                         XE,FF,DFDI,F,RBID5)
C
C      CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 220 N=1,NNOP
          DO 30 I=1,3
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  F(I,3)*DFDI(N,3)
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
            DEF(5,N,I) = (F(I,1)*DFDI(N,3) + F(I,3)*DFDI(N,1))/RAC2
            DEF(6,N,I) = (F(I,2)*DFDI(N,3) + F(I,3)*DFDI(N,2))/RAC2
 30       CONTINUE
C         ENRICHISSEMENT PAR HEAVYSIDE
          DO 40 I=1,DDLH
            DO 41 M=1,6
              DEF(M,N,3+I) =  DEF(M,N,I) * HE       
 41         CONTINUE
 40       CONTINUE
 220    CONTINUE
C
C       POUR CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
C       ON ENVOIE DFDM3D AVEC LES COORD DU SS-ELT  
        CALL DFDM3D(NNO,KPG,IPOIDS,IDFDE,ZR(JCOORS),
     &                                   RBID1,RBID2,RBID3,JAC)

C - CALCUL DE LA FORCE INTERIEURE : BSIGMA
C
          DO 180 N=1,NNOP
            DO 181 I=1,3+DDLH
              DO 182 M=1,6
                BSIGMA(I,N)=BSIGMA(I,N)+DEF(M,N,I)*SIGMA(M,KPG)*JAC
 182          CONTINUE 
 181        CONTINUE
 180      CONTINUE

 800  CONTINUE
 
      END
