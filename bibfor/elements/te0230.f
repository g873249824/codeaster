      SUBROUTINE TE0230(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C .  - FONCTION REALISEE:      CONTRAINTES PLANES AUX NOEUDS
C .                            COQUE 1D
C .                        OPTIONS : 'SIGM_ELNO_DEPL  '
C .                        ELEMENT: MECXSE3,METCSE3,METDSE3
C .  - ARGUMENTS:
C .      DONNEES:      OPTION       -->  OPTION DE CALCUL
C .                    NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
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
C --------- FIN  DECLARATIONS NORMALISEES JEVEUX -----------------------

      CHARACTER*8 ELREFE
      CHARACTER*8 NOMRES(3),NOMPAR,NOMPU(2)
      CHARACTER*2 BL2,CODRET(3)
      REAL*8 E,NU,TPG,TPG1,TPG2,TPG3,VALPAR
      REAL*8 ORD,X3,EPS(5),C1,C2,H,DILAT,KI
      REAL*8 E11,E22,K11,K22,EP11,EP22,EP12,ESX3
      REAL*8 DFDX(3),CONTPG(24),VALRES(3),VALPU(2)
      REAL*8 JAC,R,COSA,SINA,COUR,CORREC
      INTEGER I,K,KP,IGEOM,IMATE,ICACO,IDEPL,ICONT,INUMCO,NBPAR,IER
      INTEGER NNO,NPG,IDFDK,ITEMP,IVF,ITREF,IRET
      INTEGER ITAB(8)

      CALL ELREF1(ELREFE)

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCACOQU','L',ICACO)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PTEREF','L',ITREF)
      CALL JEVECH('PNUMCOR','L',INUMCO)
      CALL JEVECH('PCONTRR','E',ICONT)

      BL2 = '  '
      H = ZR(ICACO)
      CORREC = ZR(ICACO+2)
      ORD = 0.D0

      IF (ZI(INUMCO+1).LT.0) THEN
        KI = ORD - 1.D0
      ELSE IF (ZI(INUMCO+1).GT.0) THEN
        KI = ORD + 1.D0
      ELSE
        KI = ORD
      END IF
      X3 = KI*H/2.D0


      DO 40 KP = 1,NPG
        K = (KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     &              JAC,COSA,SINA)

C===============================================================
C     -- RECUPERATION DE LA TEMPERATURE POUR LE MATERIAU:

C     -- SI LA TEMPERATURE EST CONNUE AUX NOEUDS :
        CALL TECACH('OON','PTEMPER',8,ITAB,IRET)
        ITEMP = ITAB(1)
        IF (ITEMP.NE.0) THEN
          NBPAR = 1
          NOMPAR = 'TEMP'
          TPG1 = 0.D0
          TPG2 = 0.D0
          TPG3 = 0.D0
          DO 10 I = 1,NNO
            CALL DXTPIF(ZR(ITEMP+3* (I-1)),ZL(ITAB(8)+3* (I-1)))
            TPG1 = TPG1 + ZR(ITEMP+3*I-3)*ZR(IVF+K+I-1)
            TPG2 = TPG2 + ZR(ITEMP+3*I-2)*ZR(IVF+K+I-1)
            TPG3 = TPG3 + ZR(ITEMP+3*I-1)*ZR(IVF+K+I-1)
   10     CONTINUE
          TPG = TPG3*KI* (1.D0+KI)/2.D0 + TPG1* (1.D0- (KI)**2) -
     &          TPG2*KI* (1.D0-KI)/2.D0

          VALPAR = TPG
        ELSE

C     -- SI LA TEMPERATURE EST UNE FONCTION DE 'INST' ET 'EPAIS':
          CALL TECACH('ONN','PTEMPEF',1,ITEMP,IRET)
          IF (ITEMP.GT.0) THEN
            NBPAR = 1
            NOMPAR = 'TEMP'
            NOMPU(1) = 'INST'
            NOMPU(2) = 'EPAIS'
            CALL JEVECH('PTEMPSR','L',IBID)
            VALPU(1) = ZR(IBID)
            VALPU(2) = X3
            CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,VALPAR,IER)

C     -- SI LA TEMPERATURE N'EST PAS DONNEE:
          ELSE
            NBPAR = 0
            NOMPAR = ' '
            VALPAR = 0.D0
          END IF
        END IF
C===============================================================

        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NOMRES(3) = 'ALPHA'
        CALL RCVALA(ZI(IMATE),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,CODRET,'FM')
        CALL RCVALA(ZI(IMATE),' ','ELAS',NBPAR,NOMPAR,VALPAR,1,
     &              NOMRES(3),VALRES(3),CODRET(3),BL2)
        E = VALRES(1)
        NU = VALRES(2)
        IF (CODRET(3).NE.'OK') THEN
          DILAT = 0.D0
        ELSE
          DILAT = VALRES(3)*E/ (1.D0-NU)
          TPG = TPG - ZR(ITREF)
        END IF

        DO 20 I = 1,5
          EPS(I) = 0.D0
   20   CONTINUE
        R = 0.D0
        DO 30 I = 1,NNO
          EPS(1) = EPS(1) + DFDX(I)*ZR(IDEPL+3*I-3)
          EPS(2) = EPS(2) + DFDX(I)*ZR(IDEPL+3*I-2)
          EPS(3) = EPS(3) + DFDX(I)*ZR(IDEPL+3*I-1)
          EPS(4) = EPS(4) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-3)
          EPS(5) = EPS(5) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-1)
          R = R + ZR(IVF+K+I-1)*ZR(IGEOM+2*I-2)
   30   CONTINUE

        E11 = EPS(2)*COSA - EPS(1)*SINA
        K11 = EPS(3)
        IF (NOMTE(3:4).EQ.'CX') THEN
          E22 = EPS(4)/R
          K22 = -EPS(5)*SINA/R
          EP22 = (E22+X3*K22)/ (1.D0+ (CORREC*X3*COSA/R))
        ELSE
          E22 = 0.D0
          K22 = 0.D0
        END IF
        ESX3 = EPS(5) + EPS(1)*COSA + EPS(2)*SINA

        EP11 = (E11+X3*K11)/ (1.D0+ (CORREC*X3*COUR))
        EP12 = ESX3/ (1.D0+ (CORREC*X3*COUR))

        C1 = E/ (1.D0+NU)
        C2 = C1/ (1.D0-NU)

        IF (NOMTE(3:4).EQ.'CX') THEN
          CONTPG(3* (KP-1)+1) = C2* (EP11+NU*EP22) - DILAT*TPG
          CONTPG(3* (KP-1)+2) = C2* (EP22+NU*EP11) - DILAT*TPG
        ELSE IF (NOMTE(1:8).EQ.'METDSE3 ') THEN
          CONTPG(3* (KP-1)+1) = C2*EP11 - DILAT*TPG
          CONTPG(3* (KP-1)+2) = C2*NU*EP11 - DILAT*TPG
        ELSE
          CONTPG(3* (KP-1)+1) = E* (EP11-DILAT*TPG)
          CONTPG(3* (KP-1)+2) = 0.D0
        END IF
        CONTPG(3* (KP-1)+3) = C1*EP12

   40 CONTINUE

C     -- PASSAGE GAUSS -> NOEUDS :
      CALL PPGAN2(JGANO,3,CONTPG,ZR(ICONT))

      END
