      SUBROUTINE TE0011(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/07/2002   AUTEUR CAMBIER S.CAMBIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)
C
C          ELEMENTS ISOPARAMETRIQUES 3D
C    FONCTION REALISEE:  
C            OPTION : 'RIGI_MECA      '
C                            CALCUL DES MATRICES ELEMENTAIRES  3D
C            OPTION : 'RIGI_MECA_SENSI' OU 'RIGI_MECA_SENS_C'
C                            CALCUL DU VECTEUR ELEMENTAIRE -DK/DP*U
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      PARAMETER (NBRES=9)
      CHARACTER*8 MODELI,ELREFE
      CHARACTER*2 CODRET(NBRES)
      CHARACTER*16 NOMTE,OPTION,PHENOM
      CHARACTER*24 CHVAL,CHCTE
      REAL*8 B(486),BTDB(81,81),D(36),JACGAU
      REAL*8 REPERE(7),XYZGAU(3),INSTAN,NHARM
      REAL*8 HYDRG,SECHG
      INTEGER NBSIGM
      LOGICAL LSENS

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CALL ELREF1(ELREFE)
      MODELI(1:2) = NOMTE(3:4)

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CHCTE = '&INEL.'//ELREFE//'.CARACTE'
      CALL JEVETE(CHCTE,'L',JIN)
      NDIM = ZI(JIN+1-1)
      NNO = ZI(JIN+2-1)
      NPG1 = ZI(JIN+4-1)

      CHVAL = '&INEL.'//ELREFE//'.FFORMES'
      CALL JEVETE(CHVAL,'L',JVAL)
      IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      IVF = IPOIDS + NPG1
      IDFDE = IVF + NPG1*NNO
      IDFDN = IDFDE + 1
      IDFDK = IDFDN + 1

C --- INITIALISATIONS :
C     -----------------
      INSTAN = 0.D0
      NBINCO = NDIM*NNO
      NHARM = 0.D0

      DO 20 I = 1,NBINCO
        DO 10 J = 1,NBINCO
          BTDB(I,J) = 0.D0
   10   CONTINUE
   20 CONTINUE

C ---- FAIT-ON UN CALCUL DE SENSIBILITE ?
C      ----------------------------------
CS      IF (OPTION(11:15).EQ.'SENSI') THEN
      IF (OPTION(11:14).EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE
        LSENS = .FALSE.
      END IF

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM(MODELI)

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)
      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)

C ---- RECUPERATION TEMPERATURES AUX NOEUDS DE L'ELEMENT
C      -------------------------------------------------
      CALL JEVECH('PTEMPER','L',ITEMPE)

C ---- RECUPERATION DU CHAMP DE L'HDRATATION SUR L'ELEMENT
C      --------------------------------------------------
      CALL TECACH(.FALSE.,.FALSE.,'PHYDRER',1,IHYDR)

C ---- RECUPERATION DU CHAMP DU SECHAGE SUR L'ELEMENT
C      --------------------------------------------------
      CALL TECACH(.FALSE.,.FALSE.,'PSECHER',1,ISECH)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
      CALL ORTREP(ZI(IMATE),NDIM,REPERE)

C ---  BOUCLE SUR LES POINTS D'INTEGRATION
C      -----------------------------------
      DO 50 IGAU = 1,NPG1

        IDECPG = NNO* (IGAU-1) - 1

C  --      COORDONNEES ET TEMPERATURE/HYDRATATION/SECHAGE AU POINT
C  --      D'INTEGRATION COURANT
C          -------
        XYZGAU(1) = 0.D0
        XYZGAU(2) = 0.D0
        XYZGAU(3) = 0.D0
        TEMPG = 0.D0
        IF (IHYDR.GT.0) THEN
          HYDRG = ZR(IHYDR+IGAU-1)
        ELSE
          HYDRG = 0.D0
        END IF

        DO 30 I = 1,NNO

          IDECNO = 3* (I-1) - 1

          XYZGAU(1) = XYZGAU(1) + ZR(IVF+I+IDECPG)*ZR(IGEOM+1+IDECNO)
          XYZGAU(2) = XYZGAU(2) + ZR(IVF+I+IDECPG)*ZR(IGEOM+2+IDECNO)
          XYZGAU(3) = XYZGAU(3) + ZR(IVF+I+IDECPG)*ZR(IGEOM+3+IDECNO)

          TEMPG = TEMPG + ZR(IVF+I+IDECPG)*ZR(ITEMPE+I-1)
   30   CONTINUE

        SECHG = 0.D0
        IF (ISECH.GT.0) THEN
          DO 40 I = 1,NNO
            SECHG = SECHG + ZR(IVF+I+IDECPG)*ZR(ISECH+I-1)
   40     CONTINUE
        END IF

C  --      CALCUL DE LA MATRICE B RELIANT LES DEFORMATIONS DU
C  --      PREMIER ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION
C  --      COURANT : (EPS_1) = (B)*(UN)
C          ----------------------------
        CALL BMATMC(IGAU,NBSIG,MODELI,ZR(IGEOM),ZR(IVF),ZR(IDFDE),
     &              ZR(IDFDN),ZR(IDFDK),ZR(IPOIDS),NNO,NHARM,JACGAU,B)

C  --      CALCUL DE LA MATRICE DE HOOKE (LE MATERIAU POUVANT
C  --      ETRE ISOTROPE, ISOTROPE-TRANSVERSE OU ORTHOTROPE)
C          -------------------------------------------------
        CALL DMATMC(MODELI,ZI(IMATE),TEMPG,HYDRG,SECHG,INSTAN,REPERE,
     &              XYZGAU,NBSIG,D,LSENS)

C  --      MATRICE DE RIGIDITE ELEMENTAIRE BT*D*B
C          ---------------------------------------
        CALL BTDBMC(B,D,JACGAU,NDIM,MODELI,NNO,NBSIG,PHENOM,BTDB)

   50 CONTINUE

C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C      ------------------------------------------------
      IF (.NOT.LSENS) THEN
C  --  DEMI-MATRICE DE RIGIDITE
        CALL JEVECH('PMATUUR','E',IMATUU)

        K = 0
        DO 70 I = 1,NBINCO
          DO 60 J = 1,I
            K = K + 1
            ZR(IMATUU+K-1) = BTDB(I,J)
   60     CONTINUE
   70   CONTINUE
      ELSEIF (OPTION(1:15).EQ.'RIGI_MECA_SENSI') THEN
C  --  CHARGEMENT SENSIBILITE REEL
        CALL JEVECH('PVECTUR','E',IVECUU)
        CALL JEVECH('PVAPRIN','L',IVAPRU)
        DO 90 I = 1,NBINCO
          ZR(IVECUU+I-1) = 0.D0
          DO 80 J = 1,NBINCO
            ZR(IVECUU+I-1) = ZR(IVECUU+I-1) - BTDB(I,J)*ZR(IVAPRU+J-1)
   80     CONTINUE
   90   CONTINUE
      ELSEIF (OPTION(1:16).EQ.'RIGI_MECA_SENS_C') THEN
C  --  CHARGEMENT SENSIBILITE COMPLEXE
        CALL JEVECH('PVECTUC','E',IVECUU)
        CALL JEVECH('PVAPRIN','L',IVAPRU)
        DO 190 I = 1,NBINCO
          ZC(IVECUU+I-1) = DCMPLX(0.D0,0.D0)
          DO 180 J = 1,NBINCO
            ZC(IVECUU+I-1) = ZC(IVECUU+I-1) - BTDB(I,J)*ZC(IVAPRU+J-1)
  180     CONTINUE
  190   CONTINUE
      END IF

      END
