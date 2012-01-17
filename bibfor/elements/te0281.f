      SUBROUTINE TE0281(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/01/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------

C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_EVOLNI'
C                          ELEMENTS 3D ISOPARAMETRIQUES

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT

C THERMIQUE NON LINEAIRE LUMPE SANS HYDRATATION, NI SECHAGE
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C PARAMETRES D'APPEL
      CHARACTER*16 NOMTE,OPTION

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER ICODRE
      REAL*8 BETA,DBETA,LAMBDA,THETA,DELTAT,TPG,R8BID,DFDX(27),DFDY(27),
     &       DFDZ(27),POIDS,DTPGDX,DTPGDY,DTPGDZ,DLAMBD,
     &       R8PREM,TPGBUF,TPSEC,DIFF,CHAL,HYDRPG(27)
      INTEGER JGANO,IPOIDS,IVF,IDFDE,IGEOM,IMATE,ITEMP,NNO,KP,NNOS
      INTEGER NPG,I,L,IFON(3),NDIM,ICOMP,IVECTT,IVECTI
      INTEGER ITEMPS
      INTEGER ISECHI,ISECHF,IHYDR
      INTEGER NPG2,IPOID2,IVF2,IDFDE2
      LOGICAL LTEATT,LHYD

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      IF ( (LTEATT(' ','LUMPE','OUI')).AND.
     &    (NOMTE(6:10).NE.'PYRAM')) THEN
         CALL ELREF4(' ','NOEU',NDIM,NNO,NNOS,NPG2,IPOID2,IVF2,
     &            IDFDE2,JGANO)
      ELSE
         CALL ELREF4(' ','MASS',NDIM,NNO,NNOS,NPG2,IPOID2,IVF2,
     &            IDFDE2,JGANO)
      ENDIF
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

CC====
C 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PVECTTI','E',IVECTI)

C====
C 1.3 PREALABLES LIES A L'HYDRATATION
C====
      DELTAT = ZR(ITEMPS+1)
      THETA = ZR(ITEMPS+2)

      IF(ZK16(ICOMP)(1:5).NE.'SECH_') THEN
         CALL NTFCMA (ZI(IMATE),IFON)
      ENDIF
C====
C 1.4 PREALABLES LIES A L'HYDRATATION
C====
      IF (ZK16(ICOMP) (1:9).EQ.'THER_HYDR') THEN
          LHYD = .TRUE.
          CALL JEVECH('PHYDRPM','L',IHYDR)
          DO 152 KP = 1,NPG2
             L = NNO*(KP-1)
             HYDRPG(KP)=0.D0
             DO 162 I = 1,NNO
                HYDRPG(KP)=HYDRPG(KP)+ZR(IHYDR)*ZR(IVF2+L+I-1)
 162         CONTINUE
 152      CONTINUE

          CALL RCVALB('FPG1',1,1,'+',ZI(IMATE),' ','THER_HYDR',0,
     &               ' ',R8BID,1,'CHALHYDR', CHAL,ICODRE,1)
      ELSE
          LHYD = .FALSE.
      END IF
      IF(ZK16(ICOMP)(1:5).EQ.'THER_') THEN
C====
C 2. CALCULS DU TERME DE RIGIDITE DE L'OPTION
C====

      DO 70 KP = 1,NPG
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        TPG = 0.D0
        DTPGDX = 0.D0
        DTPGDY = 0.D0
        DTPGDZ = 0.D0
        DO 10 I = 1,NNO
C CALCUL DE T- ET DE SON GRADIENT
          TPG = TPG + ZR(ITEMP+I-1)*ZR(IVF+L+I-1)
          DTPGDX = DTPGDX + ZR(ITEMP+I-1)*DFDX(I)
          DTPGDY = DTPGDY + ZR(ITEMP+I-1)*DFDY(I)
          DTPGDZ = DTPGDZ + ZR(ITEMP+I-1)*DFDZ(I)
   10   CONTINUE

C CALCUL DES CARACTERISTIQUES MATERIAUX STD EN TRANSITOIRE UNIQUEMENT
C ON LES EVALUE AVEC TPG=T-
        TPGBUF = TPG
        CALL RCFODE(IFON(2),TPGBUF,LAMBDA,DLAMBD)
C
        DO 40 I = 1,NNO
          ZR(IVECTT+I-1) = ZR(IVECTT+I-1) -
     &                     POIDS* (1.0D0-THETA)*LAMBDA*
     &                     (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                     DFDZ(I)*DTPGDZ)
          ZR(IVECTI+I-1) = ZR(IVECTI+I-1) -
     &                     POIDS* (1.0D0-THETA)*LAMBDA*
     &                     (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                     DFDZ(I)*DTPGDZ)
   40   CONTINUE
C FIN BOUCLE SUR LES PTS DE GAUSS
   70 CONTINUE

C====
C 3. CALCULS DU TERME DE MASSE DE L'OPTION 
C====


      DO 140 KP = 1,NPG2
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOID2, IDFDE2,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        TPG = 0.D0
        DO 80 I = 1,NNO
C CALCUL DE T- ET DE SON GRADIENT
          TPG = TPG + ZR(ITEMP+I-1)*ZR(IVF2+L+I-1)
   80   CONTINUE

C CALCUL DES CARACTERISTIQUES MATERIAUX EN TRANSITOIRE UNIQUEMENT
C ON LES EVALUE AVEC TPG=T-
        TPGBUF = TPG
        CALL RCFODE(IFON(1),TPGBUF,BETA,DBETA)
        IF (LHYD) THEN
C THER_HYDR
          DO 81 I = 1,NNO
              ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                         POIDS* ((BETA-CHAL*HYDRPG(KP))*
     &                         ZR(IVF2+L+I-1)/DELTAT)
              ZR(IVECTI+I-1) = ZR(IVECTI+I-1) +
     &                         POIDS* ((DBETA*TPG-CHAL*HYDRPG(KP))*
     &                         ZR(IVF2+L+I-1)/DELTAT)
   81      CONTINUE
        ELSE
C THER_NL
C
C CALCUL STD A 2 OUTPUTS (LE DEUXIEME NE SERT QUE POUR LA PREDICTION)

        DO 110 I = 1,NNO
          ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                     POIDS*BETA/DELTAT*ZR(IVF2+L+I-1)
          ZR(IVECTI+I-1) = ZR(IVECTI+I-1) +
     &                     POIDS*DBETA*TPG/DELTAT*ZR(IVF2+L+I-1)
  110   CONTINUE

C ENDIF THER_HYDR
        ENDIF
C FIN BOUCLE SUR LES PTS DE GAUSS
  140 CONTINUE

C --- SECHAGE

      ELSE IF ((ZK16(ICOMP) (1:5).EQ.'SECH_')) THEN
        IF (ZK16(ICOMP) (1:12).EQ.'SECH_GRANGER' .OR.
     &      ZK16(ICOMP) (1:10).EQ.'SECH_NAPPE') THEN
          CALL JEVECH('PTMPCHI','L',ISECHI)
          CALL JEVECH('PTMPCHF','L',ISECHF)
        ELSE
C          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
C          ISECHI ET ISECHF SONT FICTIFS
          ISECHI = ITEMP
          ISECHF = ITEMP
        END IF
        DO 150 KP = 1,NPG
          L = NNO*(KP-1)
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          TPSEC = 0.D0
          DO 160 I = 1,NNO
            TPG   = TPG   + ZR( ITEMP+I-1)*ZR(IVF+L+I-1)
            TPSEC = TPSEC + ZR(ISECHI+I-1)*ZR(IVF+L+I-1)
            DTPGDX = DTPGDX + ZR(ITEMP+I-1)*DFDX(I)
            DTPGDY = DTPGDY + ZR(ITEMP+I-1)*DFDY(I)
            DTPGDZ = DTPGDZ + ZR(ITEMP+I-1)*DFDZ(I)
  160     CONTINUE
          CALL RCDIFF(ZI(IMATE),ZK16(ICOMP),TPSEC,TPG,DIFF)
C
          DO 170 I = 1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) -
     &                       POIDS* (
     &                       (1.0D0-THETA)*DIFF* (DFDX(I)*DTPGDX+
     &                       DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ))
            ZR(IVECTI+I-1) = ZR(IVECTT+I-1)
  170     CONTINUE
  150   CONTINUE
        DO 151 KP = 1,NPG2
          L = NNO*(KP-1)
          CALL DFDM3D ( NNO, KP, IPOID2, IDFDE2,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          TPSEC = 0.D0
          DO 161 I = 1,NNO
            TPG   = TPG   + ZR( ITEMP+I-1)*ZR(IVF2+L+I-1)
            TPSEC = TPSEC + ZR(ISECHI+I-1)*ZR(IVF2+L+I-1)
            DTPGDX = DTPGDX + ZR(ITEMP+I-1)*DFDX(I)
            DTPGDY = DTPGDY + ZR(ITEMP+I-1)*DFDY(I)
            DTPGDZ = DTPGDZ + ZR(ITEMP+I-1)*DFDZ(I)
  161     CONTINUE
          CALL RCDIFF(ZI(IMATE),ZK16(ICOMP),TPSEC,TPG,DIFF)
          DO 171 I = 1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                     POIDS* (TPG/DELTAT*ZR(IVF2+L+I-1))
            ZR(IVECTI+I-1) = ZR(IVECTT+I-1)
  171     CONTINUE
  151   CONTINUE

      ENDIF
C FIN ------------------------------------------------------------------
      END
