      SUBROUTINE TE0097(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/12/2010   AUTEUR SFAYOLLE S.FAYOLLE 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE

C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C        ELEMENTS MIXTES 2D ET 3D (3CH UNIQUEMENT)
C                          OPTION : 'CHAR_MECA_TEMP_R'

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER NBSIGM, IDIM, NDDL1, IRET
      INTEGER NDIM, NNO1, NNO2, NNOS, NPG1, NPG2, IPOIDS
      INTEGER IDFDE1, IDFDE2, JGANO, IVF1, IVF2, NBSIG
      INTEGER IGEOM, IMATE, ITEMPS, KK, N, I, IBID, IVECTU

      REAL*8 BSIGMA(81), SIGTH(162), REPERE(7), INSTAN, NHARM, BARY(3)
      REAL*8 ZERO

      CHARACTER*4 FAMI
      CHARACTER*8 ELREFE, ELREF2, ALIAS8

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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

C     QUELLE FORMULATION MIXTE 3CH 2CH
      IF (NOMTE(1:4).EQ.'MIAX' .OR.
     &    NOMTE(1:4).EQ.'MIPL') THEN
        IF (NOMTE(1:6).EQ.'MIAXUP' .OR.
     &      NOMTE(1:6).EQ.'MIPLUP') THEN
          NDDL1 = 3
        ELSE
          NDDL1 = 4
        ENDIF
        CALL METAU1(OPTION,NOMTE,IRET)
      ELSEIF (NOMTE(1:4).EQ.'MINC') THEN
        IF (NOMTE(1:6).EQ.'MINCUP') THEN
          NDDL1 = 4
        ELSE
          NDDL1 = 5
        ENDIF
        CALL METAU2(OPTION,NOMTE,IRET)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      IF(IRET.EQ.1)  GO TO 40

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CALL ELREF1(ELREFE)

      CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)

      IF ( ALIAS8(6:7).EQ.'TR') THEN
         ELREF2 = 'TR3'
      ELSEIF ( ALIAS8(6:7).EQ.'TE') THEN
         ELREF2 = 'TE4'
      ELSEIF (ALIAS8(6:7).EQ. 'QU'  ) THEN
         ELREF2 = 'QU4'
      ELSEIF (ALIAS8(6:8).EQ. 'H20'  ) THEN
         ELREF2 = 'HE8'
      ELSE
        CALL U2MESK('F','DVP_4',1,NOMTE)
      ENDIF

      FAMI = 'RIGI'
      CALL ELREF4(ELREFE,FAMI,NDIM,NNO1,NNOS,NPG1,IPOIDS,IVF1,
     &                                              IDFDE1,JGANO)

      CALL ELREF4(ELREF2,FAMI,NDIM,NNO2,NNOS,NPG2,IPOIDS,IVF2,
     &                                              IDFDE2,JGANO)

C --- INITIALISATIONS :
C     -----------------
      ZERO = 0.0D0
      INSTAN = ZERO
      NHARM = ZERO

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM()

      DO 10 I = 1,NBSIG*NPG1
        SIGTH(I) = ZERO
   10 CONTINUE

      DO 20 I = 1,NDIM*NNO1
        BSIGMA(I) = ZERO
   20 CONTINUE

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      BARY(1) = 0.D0
      BARY(2) = 0.D0
      BARY(3) = 0.D0
      DO 150 I = 1,NNO1
        DO 140 IDIM = 1,NDIM
          BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO1
 140    CONTINUE
 150  CONTINUE
      CALL ORTREP(ZI(IMATE),NDIM,BARY,REPERE)

C ---- RECUPERATION DE L'INSTANT
C      -------------------------
      CALL TECACH('ONN','PTEMPSR',1,ITEMPS,IRET)
      IF (ITEMPS.NE.0) INSTAN = ZR(ITEMPS)

C ---- CALCUL DES CONTRAINTES THERMIQUES
C ---- AUX POINTS D'INTEGRATION DE L'ELEMENT :
C      --------------------------------------------------------
      CALL SIGTMC(FAMI,NNO1,NDIM,NBSIG,NPG1,ZR(IVF1),
     &            ZR(IGEOM),
     &            INSTAN,ZI(IMATE),REPERE,OPTION,SIGTH)

C ---- CALCUL DU VECTEUR DES FORCES D'ORIGINE THERMIQUE/HYDRIQUE
C ---- OU DE SECHAGE (BT*SIGTH)
C      ----------------------------------------------------------
      CALL BSIGMC ( NNO1,NDIM,NBSIG,NPG1, IPOIDS, IVF1, IDFDE1,
     &              ZR(IGEOM), NHARM, SIGTH, BSIGMA )

C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE AVEC LE
C ---- VECTEUR DES FORCES D'ORIGINE THERMIQUE
C      -------------------------------------
      CALL JEVECH('PVECTUR','E',IVECTU)

      KK = 0
      DO 30 N = 1, NNO1
        DO 35 I = 1,NDDL1
          IF (I.LE.NDIM) THEN
            ZR(IVECTU+KK) = BSIGMA((N-1)*NDIM+I)
            KK = KK + 1
          END IF
          IF (I.GE.(NDIM+1) .AND. N.LE.NNO2) THEN
            ZR(IVECTU+KK) = 0.D0
            KK = KK + 1
          END IF
 35     CONTINUE
 30   CONTINUE

   40 CONTINUE
      END
