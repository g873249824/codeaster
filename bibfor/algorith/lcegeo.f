       SUBROUTINE  LCEGEO(NNO,NPG,IPOIDS,IVF,IDFDE,GEOM,TYPMOD,
     &                    OPTION,IMATE,COMPOR,LGPG,ELGEOM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
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
       IMPLICIT NONE
C
       INTEGER       NNO, NPG, IMATE, LGPG, IPOIDS,IVF,IDFDE
C
       CHARACTER*8   TYPMOD(2)
       CHARACTER*16  OPTION, COMPOR(*)
C
       REAL*8        GEOM(3,NNO), ELGEOM(10,NPG)
C.......................................................................
C
C     BUT:  CALCUL D'ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS DE
C           COMPORTEMENT
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IPOIDS  : POIDS DES POINTS DE GAUSS
C IN  IVF     : VALEUR  DES FONCTIONS DE FORME
C IN  IDFDE   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C OUT ELGEOM  : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
C               DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
C               FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER KPG, K, I
      REAL*8  RAC2, LC, DFDX(27), DFDY(27), DFDZ(27), POIDS, R
      REAL*8  VOLUME, SURFAC
      LOGICAL AXI
C......................................................................
C
C -   INITIALISATION
C
      RAC2   = SQRT(2.D0)
      AXI    = TYPMOD(1) .EQ. 'AXIS'
C
C -   CALCUL DE LA LONGUEUR CARACTERISTIQUE POUR LA LOI
C -   BETON_DOUBLE_DP
C
      IF(COMPOR(1)(1:15) .EQ. 'BETON_DOUBLE_DP'.OR.
     &  (COMPOR(1)(1:7) .EQ. 'KIT_DDI'.AND.
     &   COMPOR(9)(1:15) .EQ. 'BETON_DOUBLE_DP')) THEN
         IF(TYPMOD(1)(1:2).EQ.'3D')THEN
            VOLUME = 0.D0
            DO 10 KPG=1,NPG
              CALL DFDM3D ( NNO, KPG, IPOIDS, IDFDE,
     &                      GEOM, DFDX, DFDY, DFDZ, POIDS )
              VOLUME  = VOLUME + POIDS
 10         CONTINUE
            IF(NPG.GE.9) THEN
               LC = VOLUME ** 0.33333333333333D0
            ELSE
               LC = RAC2 * VOLUME ** 0.33333333333333D0
            ENDIF
C
         ELSEIF(TYPMOD(1)(1:6).EQ.'D_PLAN'
     &      .OR.TYPMOD(1)(1:4).EQ.'AXIS')THEN
            SURFAC = 0.D0
            DO 40 KPG=1,NPG
              K = (KPG-1)*NNO
              CALL DFDM2D ( NNO,KPG,IPOIDS,IDFDE,GEOM,DFDX,DFDY,POIDS)
              IF ( AXI ) THEN
                R = 0.D0
                DO 30 I = 1,NNO
                   R = R + GEOM(1,I)*ZR(IVF+I+K-1)
 30             CONTINUE
                POIDS = POIDS*R
              ENDIF
              SURFAC  = SURFAC + POIDS
 40         CONTINUE
            IF(NPG.GE.5) THEN
               LC = SURFAC ** 0.5D0
            ELSE
               LC = RAC2 * SURFAC ** 0.5D0
            ENDIF
         ELSE
            CALL UTMESS('F','LCEGEO','MODELISATION ' // TYPMOD(1)
     &        //'IMCOMPATIBLE AVEC LA LOI BETON_DOUBLE_DP .')
         ENDIF
C
         DO 50 KPG=1,NPG
         ELGEOM(1,KPG) = LC
 50      CONTINUE
      ENDIF
C
      END
