      SUBROUTINE TE0126(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*16 NOMTE,OPTION
C ----------------------------------------------------------------------

C    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
C                          OPTION : 'RESI_RIGI_MASS'
C                          ELEMENTS 3D ISO PARAMETRIQUES

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT

C THERMIQUE NON LINEAIRE

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

      CHARACTER*2 CODRET

      REAL*8 BETA,LAMBDA,THETA,DELTAT,KHI,TPG,TPGM
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS,R8BID
      REAL*8 DTPGDX,DTPGDY,DTPGDZ,RBID,CHAL,AFFINI,ARR
      REAL*8 TZ0,R8T0
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO,NNO,KP,NPG1,I,ITEMPS,IFON(3),L,NDIM
      INTEGER ICOMP,IHYDR,IHYDRP,ITEMPI,ITEMPR,IVERES
      INTEGER ISECHI,ISECHF,NNOS
      REAL*8 DIFF,TPSEC
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE

C --- INDMAT : INDICE SAUVEGARDE POUR LE MATERIAU

CCC      PARAMETER        ( INDMAT = 8 )
C ----------------------------------------------------------------------

C DEB ------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      TZ0 = R8T0()

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PRESIDU','E',IVERES)

      DELTAT = ZR(ITEMPS+1)
      THETA = ZR(ITEMPS+2)
      KHI = ZR(ITEMPS+3)


C --- SECHAGE

      IF (ZK16(ICOMP) (1:5).EQ.'SECH_') THEN
        IF (ZK16(ICOMP) (1:12).EQ.'SECH_GRANGER' .OR.
     &      ZK16(ICOMP) (1:10).EQ.'SECH_NAPPE') THEN
          CALL JEVECH('PTMPCHI','L',ISECHI)
          CALL JEVECH('PTMPCHF','L',ISECHF)
        ELSE
C          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
C          ISECHI ET ISECHF SONT FICTIFS
          ISECHI = ITEMPI
          ISECHF = ITEMPI
        END IF
        DO 30 KP = 1,NPG1
          L = (KP-1)*NNO
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG    = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          TPSEC  = 0.D0
          DO 10 I = 1,NNO
            TPG   = TPG   + ZR(ITEMPI+I-1)*ZR(IVF+L+I-1)
            TPSEC = TPSEC + ZR(ISECHF+I-1)*ZR(IVF+L+I-1)
            DTPGDX = DTPGDX + ZR(ITEMPI+I-1)*DFDX(I)
            DTPGDY = DTPGDY + ZR(ITEMPI+I-1)*DFDY(I)
            DTPGDZ = DTPGDZ + ZR(ITEMPI+I-1)*DFDZ(I)
   10     CONTINUE
          CALL RCDIFF(ZI(IMATE),ZK16(ICOMP),TPSEC,TPG,DIFF)
CCDIR$ IVDEP
          DO 20 I = 1,NNO
            ZR(IVERES+I-1) = ZR(IVERES+I-1) +
     &                       POIDS* (1.D0/DELTAT*KHI*ZR(IVF+L+I-1)*TPG+
     &                       THETA*DIFF* (DFDX(I)*DTPGDX+DFDY(I)*DTPGDY+
     &                       DFDZ(I)*DTPGDZ))
   20     CONTINUE
   30   CONTINUE

C --- THERMIQUE NON LINEAIRE ET EVENTUELLEMENT HYDRATATION

      ELSE
        CALL NTFCMA(ZI(IMATE),IFON)

C ---  RECUPERATION DES PARAMETRES POUR L HYDRATATION

        IF (ZK16(ICOMP) (1:9).EQ.'THER_HYDR') THEN
          CALL JEVECH('PHYDRPG','L',IHYDR)
          CALL JEVECH('PHYDRPP','E',IHYDRP)
          CALL JEVECH('PTEMPER','L',ITEMPR)
          CALL RCVALA(ZI(IMATE),'THER_HYDR',0,' ',R8BID,1,'CHALHYDR',
     &                CHAL,CODRET,'FM')
          CALL RCVALA(ZI(IMATE),'THER_HYDR',0,' ',R8BID,1,'QSR_K',ARR,
     &                CODRET,'FM')
        END IF

C --------------

        DO 80 KP = 1,NPG1
          L = (KP-1)*NNO
          CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE, 
     &                  ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
          TPG = 0.D0
          DTPGDX = 0.D0
          DTPGDY = 0.D0
          DTPGDZ = 0.D0
          DO 40 I = 1,NNO
            TPG = TPG + ZR(ITEMPI+I-1)*ZR(IVF+L+I-1)
            DTPGDX = DTPGDX + ZR(ITEMPI+I-1)*DFDX(I)
            DTPGDY = DTPGDY + ZR(ITEMPI+I-1)*DFDY(I)
            DTPGDZ = DTPGDZ + ZR(ITEMPI+I-1)*DFDZ(I)
   40     CONTINUE

C ---  RESOLUTION DE L EQUATION D HYDRATATION

          IF (ZK16(ICOMP) (1:9).EQ.'THER_HYDR') THEN
            TPGM = 0.D0
            DO 50 I = 1,NNO
              TPGM = TPGM + ZR(ITEMPR+I-1)*ZR(IVF+L+I-1)
   50       CONTINUE
            CALL RCFODE(IFON(3),ZR(IHYDR+KP-1),AFFINI,RBID)
            ZR(IHYDRP+KP-1) = ZR(IHYDR+KP-1) +
     &                        DELTAT*AFFINI*THETA*EXP(-ARR/ (TZ0+TPG)) +
     &                        DELTAT*AFFINI* (1.D0-THETA)*
     &                        EXP(-ARR/ (TZ0+TPGM))
          END IF

C --------------

          CALL RCFODE(IFON(1),TPG,BETA,RBID)
          CALL RCFODE(IFON(2),TPG,LAMBDA,RBID)

CDIR$ IVDEP
          IF (ZK16(ICOMP) (1:9).EQ.'THER_HYDR') THEN
C ---   THERMIQUE NON LINEAIRE AVEC HYDRATATION
            DO 60 I = 1,NNO
              ZR(IVERES+I-1) = ZR(IVERES+I-1) +
     &                         POIDS* ((BETA-CHAL*ZR(IHYDRP+KP-1))/
     &                         DELTAT*KHI*ZR(IVF+L+I-1)+
     &                         THETA*LAMBDA* (DFDX(I)*DTPGDX+
     &                         DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ))
   60       CONTINUE
          ELSE
C ---   THERMIQUE NON LINEAIRE SEULE
            DO 70 I = 1,NNO
              ZR(IVERES+I-1) = ZR(IVERES+I-1) +
     &                         POIDS* (BETA/DELTAT*KHI*ZR(IVF+L+I-1)+
     &                         THETA*LAMBDA* (DFDX(I)*DTPGDX+
     &                         DFDY(I)*DTPGDY+DFDZ(I)*DTPGDZ))
   70       CONTINUE
          END IF
   80   CONTINUE
      END IF
C FIN ------------------------------------------------------------------
      END
