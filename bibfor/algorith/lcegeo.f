       SUBROUTINE  LCEGEO(NNO   ,NPG   ,IPOIDS,IVF   ,IDFDE ,
     &                    GEOM  ,TYPMOD,COMPOR,NDIM  ,DFDI  ,
     &                    DEPLM ,DDEPL ,ELGEOM)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/07/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
       IMPLICIT NONE
       INTEGER       NNO, NPG, IPOIDS,IVF,IDFDE, NDIM
       CHARACTER*8   TYPMOD(2)
       CHARACTER*16  COMPOR(*)
       REAL*8        GEOM(3,NNO), ELGEOM(10,NPG),DFDI(NNO,3)
       REAL*8        DEPLM(3,NNO),DDEPL(3,NNO)
C
C ----------------------------------------------------------------------
C
C CALCUL D'ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS DE COMPORTEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG    : NOMBRE DE POINTS DE GAUSS
C IN  IPOIDS : POIDS DES POINTS DE GAUSS
C IN  IVF    : VALEUR  DES FONCTIONS DE FORME
C IN  IDFDE  : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM   : COORDONEES DES NOEUDS
C IN  TYPMOD : TYPE DE MODELISATION
C IN  COMPOR : COMPORTEMENT

C OUT ELGEOM  : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
C               DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
C               FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER KPG, K, I, NDDL, J
      REAL*8  RAC2, LC, DFDX(27), DFDY(27), DFDZ(27), POIDS, R,R8BID
      REAL*8  L(3,3),FMM(3,3),DF(3,3),F(3,3)
      REAL*8  VOLUME,SURFAC
      REAL*8  DEPLP(3,27),GEOMM(3,27),EPSBID(6),ID(3,3)
      LOGICAL LAXI
      DATA    ID/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/
C
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C
      RAC2   = SQRT(2.D0)
      LAXI   = TYPMOD(1) .EQ. 'AXIS'
      NDDL   = NDIM*NNO
C
C --- CALCUL DE LA LONGUEUR CARACTERISTIQUE POUR LA LOI
C --- BETON_DOUBLE_DP
C
      IF (COMPOR(1)(1:15) .EQ. 'BETON_DOUBLE_DP'.OR.
     &   (COMPOR(1)(1:7) .EQ. 'KIT_DDI'.AND.
     &    COMPOR(9)(1:15) .EQ. 'BETON_DOUBLE_DP')) THEN
         
         IF (TYPMOD(1)(1:2).EQ.'3D')THEN
         
           VOLUME = 0.D0
           DO 10 KPG = 1,NPG
             CALL DFDM3D(NNO   ,KPG   ,IPOIDS,IDFDE ,GEOM  ,
     &                   DFDX  ,DFDY  ,DFDZ  ,POIDS )
             VOLUME  = VOLUME + POIDS
 10        CONTINUE
           IF(NPG.GE.9) THEN
             LC = VOLUME ** 0.33333333333333D0
           ELSE
             LC = RAC2 * VOLUME ** 0.33333333333333D0
           ENDIF
         ELSEIF(TYPMOD(1)(1:6).EQ.'D_PLAN'
     &      .OR.TYPMOD(1)(1:4).EQ.'AXIS')THEN
     
            SURFAC = 0.D0
            DO 40 KPG = 1,NPG
              K      = (KPG-1)*NNO
              CALL DFDM2D(NNO   ,KPG   ,IPOIDS,IDFDE ,GEOM  ,
     &                    DFDX  ,DFDY  ,POIDS )
              IF ( LAXI ) THEN
                R = 0.D0
                DO 30 I = 1,NNO
                   R = R + GEOM(1,I)*ZR(IVF+I+K-1)
 30             CONTINUE
                POIDS = POIDS*R
              ENDIF
              SURFAC  = SURFAC + POIDS
 40         CONTINUE
 
            IF (NPG.GE.5) THEN
              LC = SURFAC ** 0.5D0
            ELSE
              LC = RAC2 * SURFAC ** 0.5D0
            ENDIF
            
         ELSE
           CALL ASSERT(.FALSE.)
         ENDIF
C
         DO 50 KPG = 1,NPG
           ELGEOM(1,KPG) = LC
 50      CONTINUE
      ENDIF
C
C --- ELEMENTS GEOMETRIQUES POUR META_LEMA_INI
C
      IF (COMPOR(1)(1:13) .EQ. 'META_LEMA_ANI') THEN
        IF (LAXI) THEN
          DO 130 KPG = 1,NPG
            ELGEOM(1,KPG) = 0.D0
            ELGEOM(2,KPG) = 0.D0
            ELGEOM(3,KPG) = 0.D0
 130      CONTINUE        
        ELSE
          DO 100 KPG = 1,NPG
            ELGEOM(1,KPG) = 0.D0
            ELGEOM(2,KPG) = 0.D0
            ELGEOM(3,KPG) = 0.D0            
            DO 110 I = 1,NDIM
              DO 120 K = 1,NNO
                ELGEOM(I,KPG) = ELGEOM(I,KPG) +
     &                          GEOM(I,K)*ZR(IVF-1+NNO*(KPG-1)+K)
 120          CONTINUE
 110        CONTINUE
 100      CONTINUE
        ENDIF
      ENDIF
C
C --- ELEMENTS GEOMETRIQUES POUR MONOCRISTAL: ROTATION DU RESEAU
C      
      IF (COMPOR(1) .EQ. 'MONOCRISTAL') THEN
C       ROTATION RESEAU DEBUT
C       CALCUL DE L = DF*F-1 
        CALL DCOPY(NDDL,GEOM,1,GEOMM,1)
        CALL DAXPY(NDDL,1.D0,DEPLM,1,GEOMM,1)
        CALL DCOPY(NDDL,DEPLM,1,DEPLP,1)
        CALL DAXPY(NDDL,1.D0,DDEPL,1,DEPLP,1)
        DO 200 KPG=1,NPG
           CALL NMGEOM(NDIM  ,NNO   ,.FALSE.,.TRUE.,GEOM  ,
     &                 KPG   ,IPOIDS,IVF    ,IDFDE ,DEPLP ,
     &                 R8BID ,DFDI  ,F      ,EPSBID,R     )
           CALL NMGEOM(NDIM  ,NNO   ,.FALSE.,.TRUE.,GEOMM ,
     &                 KPG   ,IPOIDS,IVF    ,IDFDE ,DDEPL ,
     &                 R8BID ,DFDI  ,DF     ,EPSBID,R     )
           CALL DAXPY(9,-1.D0,ID,1,DF,1)
           CALL MATINV('S',3,F,FMM,R8BID)
           CALL PMAT(3,DF,FMM,L)
           DO 272 I=1,3
              DO 273 J=1,3
                 ELGEOM(3*(I-1)+J,KPG)=L(I,J)
273           CONTINUE
272        CONTINUE
200     CONTINUE
      ENDIF
C      
      END
