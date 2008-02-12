      SUBROUTINE REEREF(ELREFP,NNOP  ,IGEOM  ,XG   ,DEPL  ,
     &                  GRAND ,NDIM  ,HE     ,DDLH ,NFE   ,
     &                  DDLT  ,FE    ,DGDGL  ,CINEM,XE    ,
     &                  FF    ,DFDI  ,F      ,EPS  ,GRAD)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*3  CINEM
      CHARACTER*8  ELREFP
      INTEGER      IGEOM,NNOP,NDIM,DDLH,NFE,DDLT
      REAL*8       XG(NDIM),DEPL(DDLT,NNOP),HE,FE(4),DGDGL(4,NDIM)
      REAL*8       XE(NDIM),FF(NNOP),DFDI(NNOP,NDIM),F(3,3)
      REAL*8       EPS(6),GRAD(NDIM,NDIM)
      LOGICAL      GRAND
C
C ----------------------------------------------------------------------
C
C TROUVER LES COORDONNEES DANS L'ELEMENT DE REFERENCE D'UN 
C POINT DONNE DANS L'ELEMENT REEL PAR LA METHODE NEWTON
C ET CALCUL DES ELEMENTS CINEMATIQUES
C
C ----------------------------------------------------------------------
C
C
C IN  ELREFP : TYPE DE L'ELEMENT DE REF PARENT
C IN  NNOP   : NOMBRE DE NOEUDS DE L'ELT DE R�F PARENT
C   L'ORDRE DES DDLS DOIT ETRE 'DC' 'H1' 'E1' 'E2' 'E3' 'E4' 'LAGC'
C IN  IGEOM  : COORDONNEES DES NOEUDS
C IN  XG     : COORDONNES DU POINT DANS L'ELEMENT REEL
C IN  DEPL   : DEPLACEMENT R�EL � PARTIR DE LA CONF DE REF
C IN  GRAND  : INDICATEUR SI GRANDES TRANSFORMATIONS
C              SI GRAND = .FALSE.
C                --> MATRICE F: UNITE
C                --> DEFORMATION EPS PETITES
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  HE     : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-�LT
C IN  DDLH   : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
C IN  NFE    : NOMBRE DE FONCTIONS SINGULI�RES D'ENRICHISSEMENT
C IN  DDLT   : NOMBRE DE DDLS TOTAL PAR NOEUD
C IN  FE     : VALEURS AUX NOEUDS DES FONCTIONS D'ENRICHISSEMENT
C IN  DGDGL  : D�RIV�ES DES FONCTIONS D'ENRICHISSEMENT
C IN  CINEM  : CALCUL DES QUANTIT�S CIN�MATIQUES 
C               'NON' : ON S'ARRETE APRES LE CALCUL DES FF
C               'DFF' : ON S'ARRETE APRES LE CALCUL DES DERIVEES DES FF
C               'OUI' : ON VA JUSQU'AU BOUT
C OUT XE     : COORDONN�ES DU POINT DANS L'�L�MENT DE R�F PARENT
C OUT FF     : FONCTIONS DE FORMES EN XE
C OUT DFDI   : D�RIV�ES DES FONCTIONS DE FORMES EN XE
C OUT F      : GRADIENT DE LA TRANSFORMATION
C OUT EPS    : D�FORMATIONS
C OUT GRAD   : GRADIENT DES D�PLACEMENTS
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
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
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER     NBNOMX
      PARAMETER   (NBNOMX = 27)
C
      REAL*8      ZERO,UN,RAC2
      INTEGER     I,J,K,N,P,IG,CPT
      INTEGER     NNO,NDERIV
      REAL*8      INVJAC(NDIM,NDIM)
      REAL*8      DFF(3,NBNOMX)
      REAL*8      KRON(NDIM,NDIM),TMP,EPSTAB(3,3)
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C      
C --- INITIALISATIONS
C
      CALL ASSERT(CINEM.EQ.'NON'.OR.CINEM.EQ.'OUI'.OR.CINEM.EQ.'DFF')
      ZERO = 0.D0
      UN   = 1.D0
      RAC2 = SQRT(2.D0)   
C
C --- RECHERCHE DE XE PAR NEWTON-RAPHSON
C    
      CALL REEREG(ELREFP,NNOP  ,ZR(IGEOM),XG   ,NDIM  ,
     &            XE    )
C
C --- VALEURS DES FONCTIONS DE FORME EN XE: FF
C
      CALL ELRFVF(ELREFP,XE,NBNOMX,FF,NNO)
C
C --- DERIVEES PREMIERES DES FONCTIONS DE FORME EN XE: DFF
C
      CALL ELRFDF(ELREFP,XE,NDIM*NBNOMX,DFF,NNO,NDERIV) 
C
C --- CALCUL DE L'INVERSE DE LA JACOBIENNE EN XE: INVJAC
C 
      CALL XJACOB(NNO   ,NDIM  ,DFF   ,ZR(IGEOM),INVJAC)   
C      
      IF (CINEM.EQ.'NON') GOTO 9999             
C
C --- DERIVEES DES FONCTIONS DE FORMES CLASSIQUES EN XE : DFDI
C    
      CALL MATINI(NNO,NDIM,ZERO,DFDI)
      DO 300 N=1,NNO
        DO 310 I=1,NDIM
          DO 311 K=1,NDIM
            DFDI(N,I)= DFDI(N,I) + INVJAC(K,I)*DFF(K,N)
 311      CONTINUE
 310    CONTINUE
 300  CONTINUE
C
      IF (CINEM.EQ.'DFF') GOTO 9999
C
C --- MATRICE IDENTITE
C
      CALL MATINI(NDIM,NDIM,ZERO,KRON)
      DO 10 P = 1,NDIM
        KRON(P,P) = UN
 10   CONTINUE         
C
C --- CALCUL DES GRADIENTS : GRAD(U) ET F
C
      DO 400 I=1,NDIM
        DO 401 J=1,NDIM
          F(I,J)    = KRON(I,J)
          GRAD(I,J) = ZERO
 401    CONTINUE
 400  CONTINUE
C
C --- L'ORDRE DES DDLS DOIT ETRE 'DC' 'H1' 'E1' 'E2' 'E3' 'E4' 'LAGC'
C
      DO 402 N=1,NNO
        CPT=0
C -- DDLS CLASSIQUES
        DO 403 I=1,NDIM
          CPT = CPT+1
          DO 404 J=1,NDIM
            GRAD(I,J) = GRAD(I,J) + DFDI(N,J) * DEPL(CPT,N)
 404      CONTINUE
 403    CONTINUE
C -- DDLS HEAVISIDE
        DO 405 I=1,DDLH
          CPT = CPT+1
          DO 406 J=1,NDIM
            GRAD(I,J) = GRAD(I,J) + HE * DFDI(N,J) *  DEPL(CPT,N)
 406      CONTINUE
 405    CONTINUE
C -- DDL ENRICHIS EN FOND DE FISSURE
        DO 407 IG=1,NFE
          DO 408 I=1,NDIM
            CPT = CPT+1
            DO 409 J=1,NDIM
              GRAD(I,J) = GRAD(I,J) + DEPL(CPT,N) *
     &                    (DFDI(N,J) * FE(IG) + FF(N) * DGDGL(IG,J))
 409        CONTINUE
 408      CONTINUE
 407    CONTINUE
 402  CONTINUE

      IF (GRAND) THEN
        DO 420 I=1,NDIM
          DO 421 J=1,NDIM
            F(I,J) = F(I,J) + GRAD(I,J)
 421      CONTINUE
 420    CONTINUE
      ENDIF
C          
C --- CALCUL DES D�FORMATIONS : EPS
C
      DO 430 I=1,NDIM
        DO 431 J=1,I
          TMP = GRAD(I,J) + GRAD(J,I)
          IF (GRAND) THEN
            DO 432 K=1,NDIM
              TMP = TMP + GRAD(K,I)*GRAD(K,J)
 432        CONTINUE
          ENDIF
          EPSTAB(I,J) = 0.5D0*TMP
 431    CONTINUE
 430  CONTINUE
      CALL LCINVN(6,ZERO,EPS)
      EPS(1) = EPSTAB(1,1)
      EPS(2) = EPSTAB(2,2)
      EPS(4) = EPSTAB(2,1)*RAC2
      IF (NDIM .EQ. 3) THEN
        EPS(3) = EPSTAB(3,3)
        EPS(5) = EPSTAB(3,1)*RAC2
        EPS(6) = EPSTAB(3,2)*RAC2
      ENDIF
C
 9999 CONTINUE      
C
      CALL JEDEMA()
      END
