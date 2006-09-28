      SUBROUTINE TE0538(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) OPTION,NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DES TERMES PROPRES A UN STRUCTURE  (ELEMENTS DE POUTRE)
C     ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C        'MASS_INER      : CALCUL DES CARACTERISTIQUES DE STRUCTURES
C IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
C        'MECA_POU_D_TGM' : POUTRE DROITE DE TIMOSHENKO MULTI-FIBRES
C                              SECTION CONSTANTE
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CHARACTER*2 CODRES
      CHARACTER*16 CH1,CH2,PHENOM
      REAL*8 RHO,A1,IY1,IZ1,XL,XL2,MATINL(6)
      REAL*8 MATINE(6),PGL(3,3)
      REAL*8 R8B

      INTEGER LMATER,LX,LORIEN,NNO,NC,LCASTR,LSECT,ITYPE,I
C     ------------------------------------------------------------------

C     --- VERIFICATION DE L'OPTION ET DU MODELE ---
      IF ((OPTION.NE.'MASS_INER').OR.(NOMTE.NE.'MECA_POU_D_TGM')) THEN
        CH1 = OPTION
        CH2 = NOMTE
        CALL UTMESS('F','TE0538','POUR L''ELEMENT DE POUTRE "'//CH2//
     &        '" L''OPTION "'//CH1//'" EST INVALIDE')
C        CALL U2MESK('F','ELEMENTS4_20', 2 ,VALK)
      ENDIF

C     --- RECUPERATION DES COORDONNEES DES NOEUDS ---
      CALL JEVECH('PGEOMER','L',LX)
      LX = LX - 1
      XL = SQRT((ZR(LX+4)-ZR(LX+1))**2+ (ZR(LX+5)-ZR(LX+2))**2+
     &     (ZR(LX+6)-ZR(LX+3))**2)
      IF (XL.EQ.0.D0) THEN
        CH1 = ' ?????????'
        CALL U2MESK('F','ELEMENTS4_21',1,CH1(:8))
      END IF

C     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
      CALL JEVECH('PMATERC','L',LMATER)
      CALL RCCOMA(ZI(LMATER),'ELAS',PHENOM,CODRES)
      IF (PHENOM.EQ.'ELAS' .OR. PHENOM.EQ.'ELAS_FO' .OR.
     &    PHENOM.EQ.'ELAS_ISTR' .OR. PHENOM.EQ.'ELAS_ISTR_FO' .OR.
     &    PHENOM.EQ.'ELAS_ORTH' .OR. PHENOM.EQ.'ELAS_ORTH_FO') THEN
        CALL RCVALA(ZI(LMATER),' ',PHENOM,0,' ',R8B,1,'RHO',RHO,
     &              CODRES,'FM')
      ELSE
        CALL U2MESS('F','ELEMENTS_50')
      END IF

C     --- ORIENTATION DE LA POUTRE ---
      CALL JEVECH('PCAORIE','L',LORIEN)
      CALL MATROT(ZR(LORIEN),PGL)
      NNO = 1
      NC  = 3

      CALL JEVECH('PMASSINE','E',LCASTR)
      DO 10 I = 1,6
        MATINE(I) = 0.D0
        MATINL(I) = 0.D0
10    CONTINUE

C     --- RECUPERATION DES CARACTERISTIQUES GENERALES DES SECTIONS
      CALL JEVECH('PCAGNPO','L',LSECT)
      LSECT = LSECT - 1

      ITYPE = NINT(ZR(LSECT+23))
C     --- LES POUTRE A SECTION VARIABLE NE SONT PAS TRAITEES
      IF (ITYPE.NE.0) THEN
        CALL U2MESS('F','ELEMENTS4_22')
      ENDIF
C     --- SECTION INITIALE ---
      A1  = ZR(LSECT +  1)
      IY1 = ZR(LSECT +  2)
      IZ1 = ZR(LSECT +  3)

C     --- CALCUL DES CARACTERISTIQUES ELEMENTAIRES 'MASS_INER' ----
      MATINL(3) = IY1
      MATINL(6) = IZ1
      XL2 = XL*XL

C     -------- MASSE
      ZR(LCASTR) = RHO*A1*XL
C     -------- CDG
      ZR(LCASTR+1) = (ZR(LX+4)+ZR(LX+1))/2.D0
      ZR(LCASTR+2) = (ZR(LX+5)+ZR(LX+2))/2.D0
      ZR(LCASTR+3) = (ZR(LX+6)+ZR(LX+3))/2.D0
C     -------- INERTIE
      MATINL(1) = RHO* (IY1+IZ1)*XL
      MATINL(2) = 0.D0
      MATINL(3) = RHO*XL*(IY1+A1*XL2/12.D0)
      MATINL(4) = 0.D0
      MATINL(5) = 0.D0
      MATINL(6) = RHO*XL*(IZ1+A1*XL2/12.D0)
      CALL UTPSLG(NNO,NC,PGL,MATINL,MATINE)

      ZR(LCASTR+3+1) = MATINE(1)
      ZR(LCASTR+3+2) = MATINE(3)
      ZR(LCASTR+3+3) = MATINE(6)
      ZR(LCASTR+3+4) = MATINE(2)
      ZR(LCASTR+3+5) = MATINE(4)
      ZR(LCASTR+3+6) = MATINE(5)

      END
