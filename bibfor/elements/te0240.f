      SUBROUTINE TE0240(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     OPTION,NOMTE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/02/2000   AUTEUR JMBHH01 J.M.PROIX 
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
C     CALCULE LA MATRICE DE RIGIDITE ELEMENTAIRE DES ELEMENTS DE TUYAU
C     DROIT DE TIMOSHENKO
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'RIGI_MECA '   : CALCUL DE LA MATRICE DE RIGIDITE
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C        'MEFS_POU_D_T' : POUTRE DROITE DE TIMOSHENKO
C                         (SECTION CONSTANTE OU NON)
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      REAL*8           ZR
      COMPLEX*16       ZC
      LOGICAL          ZL
      COMMON  /IVARJE/ ZI(1)
      COMMON  /RVARJE/ ZR(1)
      COMMON  /CVARJE/ ZC(1)
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      PARAMETER                 (NBRES=2)
      REAL*8       VALPAR,VALRES(NBRES)
      CHARACTER*2         CODRES(NBRES)
      CHARACTER*8  NOMPAR,NOMRES(NBRES)
      CHARACTER*16 CH16
      REAL*8  ZERO, C1 , C2, PGL(3,3), MAT(136)
      REAL*8  E   , NU , G   , ROF , CELER
      REAL*8  A   , AI , XIY , XIZ , ALFAY , ALFAZ , XJX , XL
      REAL*8  A2  , AI2, XIY2, XIZ2, ALFAY2, ALFAZ2, XJX2, EY, EZ
C     ------------------------------------------------------------------
      ZERO   = 0.D0
      C1     = 1.D0
      C2     = 2.D0
C     ------------------------------------------------------------------
C
C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
      CALL JEVECH ('PMATERC', 'L', IMATE)
      NBPAR  = 0
      NOMPAR = '  '
      VALPAR = ZERO
      DO 10 I=1, NBRES
         VALRES(I) = ZERO
 10   CONTINUE
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
C
      CALL RCVALA ( ZI(IMATE),'ELAS',NBPAR,NOMPAR,VALPAR,NBRES,
     +              NOMRES, VALRES, CODRES, 'FM' )
      E      = VALRES(1)
      NU     = VALRES(2)
      G      = E / (C2 *(C1+NU))
C
      VALRES(1) = ZERO
      VALRES(2) = ZERO
      NOMRES(1) = 'RHO'
      NOMRES(2) = 'CELE_R'
C
      CALL RCVALA ( ZI(IMATE),'FLUIDE',NBPAR,NOMPAR,VALPAR,NBRES,
     +              NOMRES, VALRES, CODRES, 'FM' )
      RHO    = VALRES(1)
      CELER = VALRES(2)
C
C     --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS ---
      CALL JEVECH ('PCAGNPO', 'L',LSECT)
      LSECT = LSECT-1
      ITYPE =  NINT(ZR(LSECT+25))
      NNO = 2
      NC  = 8
C
C     --- SECTION INITIALE ---
      A     =  ZR(LSECT+1)
      XIY   =  ZR(LSECT+2)
      XIZ   =  ZR(LSECT+3)
      ALFAY =  ZR(LSECT+4)
      ALFAZ =  ZR(LSECT+5)
      XJX   =  ZR(LSECT+8)
      AI    =  ZR(LSECT+12)
C
C     --- SECTION FINALE ---
      LSECT2 = LSECT + 12
      A2     = ZR(LSECT2+1)
      XIY2   = ZR(LSECT2+2)
      XIZ2   = ZR(LSECT2+3)
      ALFAY2 = ZR(LSECT2+4)
      ALFAZ2 = ZR(LSECT2+5)
      XJX2   = ZR(LSECT2+8)
      AI2    = ZR(LSECT2+12)
      EY     = -(ZR(LSECT+6)+ZR(LSECT2+6))/C2
      EZ     = -(ZR(LSECT+7)+ZR(LSECT2+7))/C2
C
      IF ( NOMTE .NE. 'MEFS_POU_D_T' )  THEN
         CH16 = NOMTE
         CALL UTMESS('F','ELEMENTS DE POUTRE (TE0240)',
     +                   '"'//CH16//'"    NOM D''ELEMENT INCONNU.')
      ENDIF
C
C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH ('PGEOMER', 'L',LX)
      LX = LX - 1
      XL = SQRT( (ZR(LX+4)-ZR(LX+1))**2
     +            + (ZR(LX+5)-ZR(LX+2))**2 + (ZR(LX+6)-ZR(LX+3))**2 )
      IF( XL .EQ. ZERO ) THEN
         CH16 = ' ?????????'
         CALL UTMESS('F','ELEMENTS DE POUTRE (TE0140)',
     +                  'NOEUDS CONFONDUS POUR UN ELEMENT: '//CH16(:8))
      ENDIF
C
      DO 30 I = 1 , 136
         MAT(I) = 0.D0
 30   CONTINUE
C
C     --- CALCUL DES MATRICES ELEMENTAIRES ----
      IF ( OPTION.EQ.'RIGI_MECA' ) THEN
C
         IF ( ITYPE .EQ. 0 ) THEN
C           --- POUTRE DROITE A SECTION CONSTANTE ---
            CALL PTKTUF(MAT,E,RHO,CELER,A,AI,XL,
     +                  XIY,XIZ,XJX,G,ALFAY,ALFAZ,EY,EZ)
         ELSE IF ( ITYPE .EQ. 1 .OR. ITYPE .EQ. 2 ) THEN
C           --- POUTRE DROITE A SECTION VARIABLE (TYPE 1 OU 2) ---
            CALL PTKTFV(ITYPE,MAT,E,RHO,CELER,A,AI,A2,AI2,XL,
     +                   XIY,XIY2,XIZ,XIZ2,XJX,XJX2,G,
     +                   ALFAY,ALFAY2,ALFAZ,ALFAZ2,EY,EZ)
         ENDIF
C
C        --- RECUPERATION DES ORIENTATIONS ALPHA,BETA,GAMMA ---
         CALL JEVECH ('PCAORIE', 'L',LORIEN)
C
C        --- PASSAGE DU REPERE LOCAL AU REPER GLOBAL ---
         CALL MATROT ( ZR(LORIEN) , PGL )
         CALL JEVECH ('PMATUUR', 'E', LMAT)
         CALL UTPSLG ( NNO, NC, PGL, MAT, ZR(LMAT) )
C
      ELSE
         CH16 = OPTION
         CALL UTMESS('F','ELEMENTS DE POUTRE (TE0140)',
     +                   'L''OPTION "'//CH16//'" EST INCONNUE')
      ENDIF
C
      END
