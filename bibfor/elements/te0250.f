      SUBROUTINE TE0250(OPTION,NOMTE)
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
C----------------------------------------------------------------------

C     BUT: CALCUL DES MATRICES TANGENTES ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU TERME D'ECHANGE
C          (LE COEFFICIENT D'ECHANGE EST UNE FONCTION DU TEMPS ET DE
C           L'ESPACE)
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 2D

C          OPTION : 'MTAN_THER_COEF_F'
C          OPTION : 'MTAN_THER_RAYO_F'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       04/04/02 (OB): CORRECTION BUG CALCUL TPG EN LUMPE
C       + MODIFS FORMELLES: IMPLICIT NONE, LAXI, LCOEF, UTMESS...
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C PARAMETRES D'APPEL
      CHARACTER*16 OPTION,NOMTE

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

C VARIABLES LOCALES
      INTEGER NBRES
      PARAMETER (NBRES=3)
      CHARACTER*8 NOMPAR(NBRES)
      REAL*8 VALPAR(NBRES),POIDS,R,Z,COEFH,NX,NY,THETA,MRIGT(9,9),
     &       COORSE(18),SIGMA,EPSIL,TPG,TZ0,R8T0
      INTEGER NNO,NNOS,JGANO,NDIM,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM,ITEMPS,
     &        IMATTT,I,J,IJ,L,LI,LJ,ICOEFH,IRAY,ITEMP,C(6,9),ISE,NSE,
     &        NNOP2,ICODE,IER
      LOGICAL LAXI,LCOEF,LTEATT

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      TZ0 = R8T0()
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C INITS.
      IF (OPTION(11:14).EQ.'COEF') THEN
        LCOEF = .TRUE.
        CALL JEVECH('PCOEFHF','L',ICOEFH)
      ELSE IF (OPTION(11:14).EQ.'RAYO') THEN
        LCOEF = .FALSE.
        CALL JEVECH('PRAYONF','L',IRAY)
        CALL JEVECH('PTEMPEI','L',ITEMP)
      ELSE
        CALL UTMESS('F','TE0250','OPTION DE CALCUL INVALIDE')
      END IF
      IF (LTEATT(' ','AXIS','OUI')) THEN
        LAXI = .TRUE.
      ELSE
        LAXI = .FALSE.
      END IF

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PMATTTR','E',IMATTT)
      THETA = ZR(ITEMPS+2)

      CALL CONNEC(NOMTE,NSE,NNOP2,C)

      DO 20 I = 1,NNOP2
        DO 10 J = 1,NNOP2
          MRIGT(I,J) = 0.D0
   10   CONTINUE
   20 CONTINUE

C --- CALCUL ISO-P2 : BOUCLE SUR LES SOUS-ELEMENTS -------

      DO 120 ISE = 1,NSE

        DO 40 I = 1,NNO
          DO 30 J = 1,2
            COORSE(2* (I-1)+J) = ZR(IGEOM-1+2* (C(ISE,I)-1)+J)
   30     CONTINUE
   40   CONTINUE

        DO 110 KP = 1,NPG
          CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,COORSE,NX,NY,POIDS)
          R = 0.D0
          Z = 0.D0
          DO 50 I = 1,NNO
            L = (KP-1)*NNO + I
            R = R + COORSE(2* (I-1)+1)*ZR(IVF+L-1)
            Z = Z + COORSE(2* (I-1)+2)*ZR(IVF+L-1)
   50     CONTINUE
          IF (LAXI) POIDS = POIDS*R

          VALPAR(1) = R
          NOMPAR(1) = 'X'
          VALPAR(2) = Z
          NOMPAR(2) = 'Y'
          VALPAR(3) = ZR(ITEMPS)
          NOMPAR(3) = 'INST'
          IF (LCOEF) THEN
            CALL FOINTE('A',ZK8(ICOEFH),3,NOMPAR,VALPAR,COEFH,ICODE)
            IF (ICODE.NE.0) CALL UTMESS('F','TE0250',
     &                                'ERREUR LORS DE L''APPEL A FOINTE'
     &                                  )
            DO 70 I = 1,NNO
              LI = IVF + (KP-1)*NNO + I - 1
CCDIR$ IVDEP
              DO 60 J = 1,NNO
                LJ = IVF + (KP-1)*NNO + J - 1
                MRIGT(C(ISE,I),C(ISE,J)) = MRIGT(C(ISE,I),C(ISE,J)) +
     &                                     POIDS*THETA*ZR(LI)*ZR(LJ)*
     &                                     COEFH

   60         CONTINUE
   70       CONTINUE

          ELSE
            TPG = 0.D0
            DO 80 I = 1,NNO
              L = (KP-1)*NNO + I
              TPG = TPG + ZR(ITEMP-1+C(ISE,I))*ZR(IVF+L-1)
   80       CONTINUE
            CALL FOINTE('A',ZK8(IRAY),4,NOMPAR,VALPAR,SIGMA,IER)
            IF (IER.NE.0) CALL UTMESS('F','TE0250',
     &                                'ERREUR LORS DE L APPEL A FOINTE')
            CALL FOINTE('A',ZK8(IRAY+1),4,NOMPAR,VALPAR,EPSIL,IER)
            IF (IER.NE.0) CALL UTMESS('F','TE0250',
     &                                'ERREUR LORS DE L APPEL A FOINTE')
            DO 100 I = 1,NNO
              LI = IVF + (KP-1)*NNO + I - 1
CCDIR$ IVDEP
              DO 90 J = 1,NNO
                LJ = IVF + (KP-1)*NNO + J - 1
                MRIGT(C(ISE,I),C(ISE,J)) = MRIGT(C(ISE,I),C(ISE,J)) +
     &                                     POIDS*THETA*ZR(LI)*ZR(LJ)*
     &                                     4.D0*SIGMA*EPSIL*
     &                                     (TPG+TZ0)**3

   90         CONTINUE
  100       CONTINUE
          END IF
  110   CONTINUE

  120 CONTINUE

C MISE SOUS FORME DE VECTEUR
      IJ = IMATTT - 1
      DO 140 I = 1,NNOP2
        DO 130 J = 1,I
          IJ = IJ + 1
          ZR(IJ) = MRIGT(I,J)
  130   CONTINUE
  140 CONTINUE
      END
