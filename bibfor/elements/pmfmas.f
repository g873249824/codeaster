      SUBROUTINE PMFMAS(NOMTE,RHO,KANL,MLV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/05/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================
      IMPLICIT NONE
      CHARACTER*(*) NOMTE
      REAL*8 RHO,MLV(*)
      INTEGER KANL
C     ------------------------------------------------------------------
C     CALCULE LA MATRICE DE MASSE DES ELEMENTS DE POUTRE MULTIFIBRES

C IN  NOMTE : NOM DU TYPE ELEMENT
C             'MECA_POU_D_EM'
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CHARACTER*16 CH16
      INTEGER JACF,NBFIB,NCARFI
      INTEGER LX,I
      REAL*8 CASECT(6),XL
      REAL*8 ZERO
      PARAMETER (ZERO=0.0D+0)
C     ------------------------------------------------------------------


C        --- POUTRE DROITE D'EULER A 6 DDL ---
      IF (NOMTE(1:13).NE.'MECA_POU_D_EM') THEN
        CH16 = NOMTE
        CALL UTMESS('F','ELEMENTS DE POUTRE',
     +              '"'//CH16//'"    NOM D''ELEMENT INCONNU.')
      END IF

C     --- RECUPERATION DES CARACTERISTIQUES DES FIBRES :
      CALL JEVECH('PNBSP_I','L',I)
      NBFIB = ZI(I)
      CALL JEVECH('PFIBRES','L',JACF)
      NCARFI = 3

C --- CALCUL DES CARACTERISTIQUES DE LA SECTION ---
      CALL PMFITG(NBFIB,NCARFI,ZR(JACF),CASECT)
C --- ON MULTIPLIE PAR RHO (CONSTANT SUR LA SECTION)
      DO 10 I = 1,6
        CASECT(I) = RHO*CASECT(I)
   10 CONTINUE

C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH('PGEOMER','L',LX)
      LX = LX - 1
      XL = SQRT((ZR(LX+4)-ZR(LX+1))**2+ (ZR(LX+5)-ZR(LX+2))**2+
     +     (ZR(LX+6)-ZR(LX+3))**2)
      IF (XL.EQ.ZERO) THEN
        CH16 = ' ?????????'
        CALL UTMESS('F','ELEMENTS DE POUTRE',
     +              'NOEUDS CONFONDUS POUR UN ELEMENT: '//CH16(:8))
      END IF

C     --- CALCUL DE LA MATRICE DE MASSE LOCALE

      CALL PMFM01(KANL,XL,CASECT,MLV)

      END
