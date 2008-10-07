      SUBROUTINE TE0273(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/10/2008   AUTEUR PELLET J.PELLET 
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
C----------------------------------------------------------------------
C
C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU FLUX NON-LINEAIRE
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'CHAR_THER_FLUNL'
C                   'CHAR_SENS_FLUNL'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       11/03/02 (OB): MODIFICATIONS POUR INSERER LE CALCUL DE SENSI
C       BILITE PAR RAPPORT AU FLUX NON-LINEAIRE OU EN PRESENCE DE FLUX
C       NON-LINEAIRE.
C       + MODIFS FORMELLES: IMPLICIT NONE, IDENTATION...
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

      CHARACTER*16  OPTION,NOMTE
      REAL*8        NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),JAC,THETA,TPG,
     &              ALPHA,RBID,DALPHA,TPGM
      INTEGER       JIN,NDIM,NNO,NPG1,JVAL,IPOIDS,IVF,IDFDX,IDFDY,
     &              IGEOM,IFLUX,ITEMPR,ITEMPS,INO,JNO,IVECTT,
     &              IVAPRM,TETYPS,I,J,KP,KDEC,LDEC,IDEC,JDEC,IRET,
     &              NNOS,JGANO
      CHARACTER*8   COEF
      CHARACTER*8   ELREFE
      LOGICAL       LSENS

C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C -----------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      CALL JEMARQ()

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDX,JGANO)
      IDFDY  = IDFDX  + 1
C
      IF (OPTION(6:9).EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE IF (OPTION(6:9).EQ.'THER') THEN
        LSENS = .FALSE.
      ELSE
CC OPTION DE CALCUL INVALIDE
        CALL ASSERT(.FALSE.)
      ENDIF

C====
C 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====

C CALCUL DE SENSIBILITE PART I
      IF (LSENS) THEN
C RECUPERATION DE (DT/DS)-. LA PRESENCE DE CE PARAMETRE, OPTIONNEL EN
C CALCUL DE SENSIBILITE, SIGNIFIE QU'IL FAUT ASSEMBLER LE TERME COMPLEN
C TAIRE. SINON, IL FAUT ASSEMBLER LE TERME CORRESPONDANT A LA DERIVEE
C PAR RAPPORT AU FLUX NON-LINEAIRE
        CALL TECACH('ONN','PTEMPER',1,ITEMPR,IRET)
        IF (ITEMPR.EQ.0) THEN
C DERIVEE PAR RAPPORT AU FLUX
          TETYPS = 2
        ELSE
C TERME COMPLEMENTAIRE
          TETYPS = 1
C CHAMP CORRESPONDANT A T-
          CALL JEVECH('PVAPRMO','L',IVAPRM)
        ENDIF
      ELSE
C CALCUL STD
        TETYPS = 0
C RECUPERATION DE T-
        CALL JEVECH('PTEMPER','L',ITEMPR)
      ENDIF

      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
C FLUX NON-LIN (PB STD OU TERME COMPLEMENTAIRE SENSIBILITE) OU
C DERIVEE DU FLUX (SENSIBILITE PAR RAPPORT AU FLUX)
      CALL JEVECH('PFLUXNL','L',IFLUX )
      CALL JEVECH('PVECTTR','E',IVECTT)

C====
C 1.3 PREALABLES LIES AUX CALCULS
C====

      THETA  = ZR(ITEMPS+2)
      COEF   = ZK8(IFLUX)
      IF ( COEF(1:7) .EQ. '&FOZERO' ) GOTO 999

C    CALCUL DES PRODUITS VECTORIELS OMI   OMJ

      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
        DO 2 JNO = 1,NNO
          J = IGEOM + 3*(JNO-1) -1
          SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
          SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
          SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
 2      CONTINUE
 1    CONTINUE

C====
C 2. CALCULS TERMES STD OU SENSIBLE
C====
C    BOUCLE SUR LES POINTS DE GAUSS
      DO 101 KP=1,NPG1

        KDEC = (KP-1)*NNO*NDIM
        LDEC = (KP-1)*NNO
        NX = 0.0D0
        NY = 0.0D0
        NZ = 0.0D0

C   CALCUL DE LA NORMALE AU POINT DE GAUSS KP

        DO 102 I=1,NNO
          IDEC = (I-1)*NDIM
          DO 102 J=1,NNO
            JDEC = (J-1)*NDIM
            NX = NX+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SX(I,J)
            NY = NY+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SY(I,J)
            NZ = NZ+ ZR(IDFDX+KDEC+IDEC)* ZR(IDFDY+KDEC+JDEC)* SZ(I,J)
 102    CONTINUE

C   CALCUL DU JACOBIEN AU POINT DE GAUSS KP
        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)

        TPG  = 0.D0
        IF (TETYPS.NE.2) THEN
          DO 104 I=1,NNO
C CALCUL DE T- EN STD (OU (DT/DS)- POUR TERME COMPLENTAIRE EN SENSI)
            TPG  = TPG  + ZR(ITEMPR+I-1) * ZR(IVF+LDEC+I-1)
 104      CONTINUE
        ENDIF

C CALCUL DE SENSIBILITE PART II
        TPGM = 0.D0
        IF (TETYPS.EQ.1) THEN
          DO 106 I=1,NNO
C CALCUL DE T- POUR TERME COMPLEMENTAIRE EN SENSIBILITE
            TPGM = TPGM + ZR(IVAPRM+I-1) * ZR(IVF+LDEC+I-1)
 106      CONTINUE
        ENDIF

C OBTENTION DES PARAMETRES MATERIAU, SENSIBILITE PART III
        IF (.NOT.LSENS) THEN
          CALL FODERI(COEF,TPG,ALPHA,RBID)
        ELSE
          CALL FODERI(COEF,TPGM,ALPHA,DALPHA)
        ENDIF

CCDIR$ IVDEP
        IF (TETYPS.EQ.0) THEN
          DO 108 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + ZR(IPOIDS+KP-1)*JAC*
     &                  (1.D0-THETA)*ALPHA*ZR(IVF+LDEC+I-1)
 108      CONTINUE
        ELSE IF (TETYPS.EQ.1) THEN
          DO 110 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + ZR(IPOIDS+KP-1)*JAC*
     &                  (1.D0-THETA)*DALPHA*TPG*ZR(IVF+LDEC+I-1)
 110      CONTINUE
        ELSE IF (TETYPS.EQ.2) THEN
          DO 112 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + ZR(IPOIDS+KP-1)*JAC*
     &                       ALPHA*ZR(IVF+LDEC+I-1)
 112      CONTINUE
        ENDIF

C FIN BOUCLE SUR LES PT DE GAUSS
 101  CONTINUE
C EXIT SI LE FLUX EST LA FONCTION NULLE
 999  CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
