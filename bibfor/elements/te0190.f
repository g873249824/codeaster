      SUBROUTINE TE0190(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 06/05/2003   AUTEUR CIBHHPD D.NUNEZ 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C     BUT: CALCUL DES MATRICES DE RIGIDITE ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 2D FOURIER

C            OPTION : 'RIGI_MECA        '

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      PARAMETER (NBRES=9)
      CHARACTER*2 CODRET(NBRES)
      CHARACTER*8 MODELI,ELREFE
      CHARACTER*16 PHENOM
      CHARACTER*24 CARAC,FF
      REAL*8 B(486),BTDB(81,81),D(36),JACGAU
      REAL*8 REPERE(7),XYZGAU(3),INSTAN,NHARM
      REAL*8 HYDRG,SECHG
      INTEGER NBSIGM
      LOGICAL LSENS

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

      CALL ELREF1(ELREFE)
      MODELI(1:2) = NOMTE(3:4)


C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CARAC = '&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)

      FF = '&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS = IFF
      IVF = IPOIDS + NPG1
      IDFDE = IVF + NPG1*NNO
      IDFDK = IDFDE + NPG1*NNO

C --- INITIALISATIONS :
C     -----------------
      NDIM = 3
      NDIM2 = 2
      ZERO = 0.0D0
      INSTAN = ZERO
      NBINCO = NDIM*NNO
      NHARM = ZERO
      BIDON = ZERO

      DO 20 I = 1,NBINCO
        DO 10 J = 1,NBINCO
          BTDB(I,J) = ZERO
   10   CONTINUE
   20 CONTINUE

      XYZGAU(1) = ZERO
      XYZGAU(2) = ZERO
      XYZGAU(3) = ZERO

C ---- FAIT-ON UN CALCUL DE SENSIBILITE ?
C      ----------------------------------
      IF (OPTION(11:15).EQ.'SENSI') THEN
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
      CALL TECACH('NNN','PHYDRER',1,IHYDR,IRET)

C ---- RECUPERATION DU CHAMP DU SECHAGE SUR L'ELEMENT
C      --------------------------------------------------
      CALL TECACH('NNN','PSECHER',1,ISECH,IRET)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
      CALL ORTREP(ZI(IMATE),NDIM2,REPERE)

C ---- RECUPERATION  DU NUMERO D'HARMONIQUE
C      ------------------------------------
      CALL JEVECH('PHARMON','L',IHARMO)
      NH = ZI(IHARMO)
      NHARM = DBLE(NH)

C ---  BOUCLE SUR LES POINTS D'INTEGRATION
C      -----------------------------------
      DO 50 IGAU = 1,NPG1

        IDECPG = NNO* (IGAU-1) - 1

C  --      TEMPERATURE/HYDRATATION/SECHAGE AU POINT D'INTEGRATION
C  --      COURANT
C          ------------------------------------------------------
        TEMPG = ZERO
        SECHG = ZERO

        IF (IHYDR.GT.0) THEN
          HYDRG = ZR(IHYDR+IGAU-1)
        ELSE
          HYDRG = ZERO
        END IF

        DO 30 I = 1,NNO
          TEMPG = TEMPG + ZR(IVF+I+IDECPG)*ZR(ITEMPE+I-1)
   30   CONTINUE

        IF (ISECH.GT.0) THEN
          DO 40 I = 1,NNO
            SECHG = SECHG + ZR(IVF+I+IDECPG)*ZR(ISECH+I-1)
   40     CONTINUE
        ELSE
          SECHG = ZERO
        END IF

C  --      CALCUL DE LA MATRICE B RELIANT LES DEFORMATIONS DU
C  --      PREMIER ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION
C  --      COURANT : (EPS_1) = (B)*(UN)
C          ----------------------------
        CALL BMATMC(IGAU,NBSIG,MODELI,ZR(IGEOM),ZR(IVF),ZR(IDFDE),
     &              ZR(IDFDK),BIDON,ZR(IPOIDS),NNO,NHARM,JACGAU,B)

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
      ELSE
C  --  CHARGEMENT SENSIBILITE
        CALL JEVECH('PVECTUR','E',IVECUU)
        CALL JEVECH('PVAPRIN','L',IVAPRU)
        DO 90 I = 1,NBINCO
          ZR(IVECUU+I-1) = 0.D0
          DO 80 J = 1,NBINCO
            ZR(IVECUU+I-1) = ZR(IVECUU+I-1) - BTDB(I,J)*ZR(IVAPRU+J-1)
   80     CONTINUE
   90   CONTINUE

      END IF

      END
