      SUBROUTINE TE0304(OPTION,NOMTE)
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
C
C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN THERMIQUE
C          CORRESPONDANT AU TERME D'ECHANGE ENTRE 2 PAROIS (FACE)
C          D'ELEMENTS ISOPARAMETRIQUES 3D
C
C          OPTION : 'CHAR_THER_PARO_F'
C          OPTION : 'CHAR_SENS_PARO_F'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
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
      CHARACTER*8    ELREFE,NOMPAR(4),LIREFE(2)
      CHARACTER*24   CHVAL,CHCTE
      CHARACTER*16   NOMTE,OPTION
      REAL*8         NX,NY,NZ,SX(9,9),SY(9,9),SZ(9,9),XX,YY,ZZ,
     &               JAC,TEM,THETA,HECHP,VALPAR(4),VAPRIN,VAPRMO
      INTEGER        IPOIDS,IVF,IDFDX,IDFDY,IGEOM,I,JVAL,ITEMP,ITEMPS,
     &               NDIM,NNO,IPG,NPG1,IVECTT,IHECHP,JIN,NBFPG,INO,JNO,
     &               IDEC,JDEC,KDEC,LDEC,NBPG(10),IVAPRI,IVAPRM,IER,
     &               J,NBELR,IRET
      LOGICAL        LSENS,LSTAT

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      CALL ELREF2(NOMTE,2,LIREFE,NBELR)
      CALL ASSERT(NBELR.EQ.2)
      ELREFE = LIREFE(2)
      CHCTE = '&INEL.'//ELREFE//'.CARACTE'
      CALL JEVETE(CHCTE,'L',JIN)
      NDIM = ZI(JIN+1-1)
      NNO = ZI(JIN+2-1)
      NBFPG = ZI(JIN+3-1)
      DO 111 I = 1,NBFPG
         NBPG(I) = ZI(JIN+3-1+I)
  111 CONTINUE
      NPG1 = NBPG(1)
      CHVAL = '&INEL.'//ELREFE//'.FFORMES'
      CALL JEVETE(CHVAL,'L',JVAL)
      IPOIDS = JVAL + (NDIM+1)*NNO*NNO
      IVF    = IPOIDS + NPG1
      IDFDX  = IVF    + NPG1 * NNO
      IDFDY  = IDFDX  + 1

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
      ENDIF
C====
C 1.3 PREALABLES LIES AUX CALCULS
C====
      THETA = ZR(ITEMPS+2)
      VALPAR(4) = ZR(ITEMPS)
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
      NOMPAR(4) = 'INST'
      DO 10 I = 1,2*NNO
        ZR(IVECTT+I-1) = 0.0D0
10    CONTINUE

C    CALCUL DES PRODUITS VECTORIELS OMI * OMJ

      DO 1 INO = 1,NNO
        I = IGEOM + 3*(INO-1) -1
        DO 2 JNO = 1,NNO
          J = IGEOM + 3*(JNO-1) -1
          SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
          SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
          SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
2       CONTINUE
1     CONTINUE

C====
C 2. CALCULS TERMES DE MASSE (STD ET/OU SENSIBLE)
C====
C    BOUCLE SUR LES POINTS DE GAUSS

      DO 101 IPG=1,NPG1
        KDEC = (IPG-1)*NNO*NDIM
        LDEC = (IPG-1)*NNO
C    CALCUL DE HECHP
        XX = 0.D0
        YY = 0.D0
        ZZ = 0.D0
        DO 202 I = 1,NNO
          XX = XX + ZR(IGEOM+3*I-3) * ZR(IVF+LDEC+I-1)
          YY = YY + ZR(IGEOM+3*I-2) * ZR(IVF+LDEC+I-1)
          ZZ = ZZ + ZR(IGEOM+3*I-1) * ZR(IVF+LDEC+I-1)
 202    CONTINUE
        VALPAR(1) = XX
        VALPAR(2) = YY
        VALPAR(3) = ZZ
        CALL FOINTE('FM',ZK8(IHECHP),4,NOMPAR,VALPAR,HECHP,IER)

C   CALCUL DE LA NORMALE AU POINT DE GAUSS IPG
        NX = 0.0D0
        NY = 0.0D0
        NZ = 0.0D0
        DO 102 I=1,NNO
          IDEC = (I-1)*NDIM
          DO 102 J=1,NNO
            JDEC = (J-1)*NDIM
            NX=NX+ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SX(I,J)
            NY=NY+ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SY(I,J)
            NZ=NZ+ZR(IDFDX+KDEC+IDEC)*ZR(IDFDY+KDEC+JDEC)*SZ(I,J)
102     CONTINUE

C --- CALCUL DU JACOBIEN AU POINT DE GAUSS IPG

        JAC = SQRT(NX*NX + NY*NY + NZ*NZ)
        TEM = 0.D0
        DO 104 I=1,NNO
           LDEC = (IPG-1)*NNO
           TEM = TEM + (ZR(ITEMP+NNO+I-1)- ZR(ITEMP+I-1) )
     &                 * ZR(IVF+LDEC+I-1)
 104    CONTINUE
C CALCUL DE SENSIBILITE PART II
C DETERMINATION DE T+ (VAPRIN) ET DE T- (VAPRMO)
        IF (LSENS) THEN
          VAPRIN = 0.D0
          VAPRMO = 0.D0
          DO 114 I = 1,NNO
            LDEC = (IPG-1)*NNO
            VAPRIN=VAPRIN+(ZR(IVAPRI+NNO+I-1)-ZR(IVAPRI+I-1))*
     &             ZR(IVF+LDEC+I-1)
            IF (.NOT.LSTAT) VAPRMO=VAPRMO+
     &         (ZR(IVAPRM+NNO+I-1)-ZR(IVAPRM+I-1))*ZR(IVF+LDEC+I-1)
114       CONTINUE
          DO 115 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + JAC * HECHP *
     &         ZR(IPOIDS+IPG-1) * ZR(IVF+LDEC+I-1) *
     &         (THETA*VAPRIN+(1.0D0-THETA)*VAPRMO)
            ZR(IVECTT+NNO+I-1) = ZR(IVECTT+NNO+I-1) - JAC * HECHP *
     &         ZR(IPOIDS+IPG-1) * ZR(IVF+LDEC+I-1) *
     &         (THETA*VAPRIN+(1.0D0-THETA)*VAPRMO)

115       CONTINUE
        ELSE
CCDIR$ IVDEP
          DO 103 I=1,NNO
            ZR(IVECTT+I-1) = ZR(IVECTT+I-1) + JAC * HECHP *
     &         ZR(IPOIDS+IPG-1) * ZR(IVF+LDEC+I-1) * (1.0D0-THETA)*TEM
            ZR(IVECTT+NNO+I-1) = ZR(IVECTT+NNO+I-1) - JAC * HECHP *
     &         ZR(IPOIDS+IPG-1) * ZR(IVF+LDEC+I-1) * (1.0D0-THETA)*TEM
103       CONTINUE
        ENDIF
101   CONTINUE
      END
