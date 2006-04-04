      SUBROUTINE TE0210(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
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
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_PARO_F'
C                          OPTION : 'CHAR_SENS_PARO_F'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       18/01/02 (OB): MODIFICATIONS POUR INSERER LES ARGUMENTS OPTION
C       NELS PERMETTANT D'UTILISER CETTE ROUTINE POUR CALCULER LA
C       SENSIBILITE PAR RAPPORT A H.
C       + MODIFS FORMELLES: IMPLICIT NONE, IDENTATION...
C       08/03/02 (OB): CORRECTION BUG EN STATIONNAIRE ET SENSIBILITE
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

      INTEGER NBRES,IRET
      PARAMETER (NBRES=3)
      CHARACTER*16 OPTION,NOMTE
      CHARACTER*8 NOMPAR(NBRES),ELREFE,LIREFE(2)
      REAL*8 VALPAR(NBRES),POIDS,POIDS1,POIDS2,R,R1,R2,Z,HECHP,NX,NY,
     &       TPG,THETA,VAPRIN,VAPRMO,Z1,Z2
      INTEGER NNO,NNOS,JGANO,NDIM,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM,IVECTT,
     &        K,I,L,LI,IHECHP,IVAPRI,IVAPRM,ITEMP,ITEMPS,ICODE,NBELR
      LOGICAL LSENS,LSTAT
      LOGICAL  LTEATT, LAXI

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

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      CALL ELREF2(NOMTE,2,LIREFE,NBELR)
      CALL ASSERT(NBELR.EQ.2)
      CALL ELREF4(LIREFE(2),'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,
     &            JGANO)

      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.
C====
C 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PHECHPF','L',IHECHP)
      CALL JEVECH('PTEMPER','L',ITEMP)
      CALL JEVECH('PVECTTR','E',IVECTT)

C CALCUL DE SENSIBILITE PART I
      LSTAT = .FALSE.
      IF (OPTION(6:9).EQ.'SENS') THEN
        LSENS = .TRUE.
        CALL JEVECH('PVAPRIN','L',IVAPRI)
        CALL TECACH('ONN','PVAPRMO',1,IVAPRM,IRET)
C L'ABSENCE DE CE CHAMP DETERMINE LE CRITERE STATIONNAIRE OU PAS
        IF (IVAPRM.EQ.0) LSTAT = .TRUE.
      ELSE
        LSENS = .FALSE.
      END IF
      THETA = ZR(ITEMPS+2)

C====
C 2. CALCULS TERMES DE MASSE (STD ET/OU SENSIBLE)
C====
C    BOUCLE SUR LES POINTS DE GAUSS
      DO 50 KP = 1,NPG
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS1)
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM+2*NNO),NX,
     &              NY,POIDS2)
        R1 = 0.D0
        R2 = 0.D0
        Z1 = 0.D0
        Z2 = 0.D0
        TPG = 0.D0
        DO 10 I = 1,NNO
          L = (KP-1)*NNO + I
          R1 = R1 + ZR(IGEOM+2*I-2)*ZR(IVF+L-1)
          R2 = R2 + ZR(IGEOM+2* (NNO+I)-2)*ZR(IVF+L-1)
          Z1 = Z1 + ZR(IGEOM+2*I-1)*ZR(IVF+L-1)
          Z2 = Z2 + ZR(IGEOM+2* (NNO+I)-1)*ZR(IVF+L-1)
          TPG = TPG + (ZR(ITEMP+NNO+I-1)-ZR(ITEMP+I-1))*ZR(IVF+L-1)
   10   CONTINUE
        IF (LAXI) THEN
          POIDS1 = POIDS1*R1
          POIDS2 = POIDS2*R2
        END IF

C CALCUL DE SENSIBILITE PART II
C DETERMINATION DE T+ (VAPRIN) ET DE T- (VAPRMO)
        IF (LSENS) THEN
          VAPRIN = 0.D0
          VAPRMO = 0.D0
          DO 20 I = 1,NNO
            L = (KP-1)*NNO + I
            VAPRIN = VAPRIN + (ZR(IVAPRI+NNO+I-1)-ZR(IVAPRI+I-1))*
     &               ZR(IVF+L-1)
            IF (.NOT.LSTAT) VAPRMO = VAPRMO +
     &                               (ZR(IVAPRM+NNO+I-1)-ZR(IVAPRM+I-
     &                               1))*ZR(IVF+L-1)
   20     CONTINUE
        END IF

        R = (R1+R2)/2.0D0
        Z = (Z1+Z2)/2.0D0
        POIDS = (POIDS1+POIDS2)/2
        VALPAR(1) = R
        VALPAR(2) = Z
        VALPAR(3) = ZR(ITEMPS)
        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'INST'
        CALL FOINTE('FM',ZK8(IHECHP),3,NOMPAR,VALPAR,HECHP,ICODE)
CCDIR$ IVDEP
        IF (.NOT.LSENS) THEN
          DO 30 I = 1,NNO
            LI = IVF + (KP-1)*NNO + I - 1
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                       POIDS*ZR(LI)*HECHP* (1.0D0-THETA)*TPG
            ZR(IVECTT+I-1+NNO) = ZR(IVECTT+I-1+NNO) -
     &                           POIDS*ZR(LI)*HECHP* (1.0D0-THETA)*TPG
   30     CONTINUE
        ELSE
C CALCUL DE SENSIBILITE PART III
          DO 40 I = 1,NNO
            LI = IVF + (KP-1)*NNO + I - 1
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                       POIDS*ZR(LI)*HECHP* (THETA*VAPRIN+
     &                       (1.0D0-THETA)*VAPRMO)
            ZR(IVECTT+I-1+NNO) = ZR(IVECTT+I-1+NNO) -
     &                           POIDS*ZR(LI)*HECHP*
     &                           (THETA*VAPRIN+ (1.0D0-THETA)*VAPRMO)
   40     CONTINUE
        END IF
   50 CONTINUE
      END
