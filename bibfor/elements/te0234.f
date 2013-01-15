      SUBROUTINE TE0234(OPTION,NOMTE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     CALCUL DES OPTIONS DES ELEMENTS DE COQUE 1D

C     OPTION : FORC_NODA (REPRISE)
C          -----------------------------------------------------------


      INTEGER NBRES,JNBSPI,NBSP,ITAB(7)

      INTEGER NBCOU,NPGE,ICONTM,IDEPLM,IVECTU,ICOU,INTE,KPKI,K1

      REAL*8 CISAIL,ZIC,COEF,RHOS,RHOT,EPSX3,GSX3,SGMSX3

C---- DECLARATIONS LOCALES ( RAMENEES DE TE0239.F FULL_MECA )

      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES),ELREFE
      INTEGER ICODRE(NBRES)
      REAL*8 VALRES(NBRES)
      REAL*8 DFDX(3),ZERO,UN,DEUX
      REAL*8 TEST,TEST2,EPS,NU,H,COSA,SINA,COUR,R,TPG
      REAL*8 JACP,KAPPA,CORREC
      REAL*8 EPS2D(4),SIGTDI(5),SIGMTD(5)
      REAL*8 X3
      INTEGER NNO,NNOS,JGANO,NDIM,KP,NPG,I,K,ICACO,IRET
      INTEGER IPOIDS,IVF,IDFDK,IGEOM,IMATE
      LOGICAL TESTL1,TESTL2
      REAL*8 ZMIN,HIC


      DATA ZERO,UN,DEUX/0.D0,1.D0,2.D0/

C-- SHIFT POUR LES COURBURES
      CALL ELREF1(ELREFE)
      EPS = 1.D-3

CDEB


      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)


C-- LECTURE DU COMPORTEMENT
      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
      IF (NBCOU.LE.0) CALL U2MESS('F','ELEMENTS_12')
      IF (NBCOU.GT.30) CALL U2MESS('F','ELEMENTS3_50')

      NPGE = 3

C---- LECTURES STANDARDS ( RAMENEES DE TE0239.F FULL_MECA )

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCACOQU','L',ICACO)
      H = ZR(ICACO)
      KAPPA = ZR(ICACO+1)
      CORREC = ZR(ICACO+2)
C---- COTE MINIMALE SUR L'EPAISSEUR

      ZMIN = -H/2.D0
C---- EPAISSEUR DE CHAQUE COUCHE

      HIC = H/NBCOU
      CALL JEVECH('PMATERC','L',IMATE)
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      CALL TECACH('OOO','PCONTMR' ,'L',7,ITAB,IRET)
      ICONTM=ITAB(1)
      NBSP=ITAB(7)
      IF (NBSP.NE.NPGE*NBCOU) CALL U2MESS('F','ELEMENTS_4')

      CALL JEVECH('PDEPLMR','L',IDEPLM)
C---- INITIALISATION DU VECTEUR FORCE INTERNE

      CALL JEVECH('PVECTUR','E',IVECTU)
      DO 10 I = 1,3*NNO
        ZR(IVECTU+I-1) = 0.D0
   10 CONTINUE

        KPKI = 0
        DO 60 KP = 1,NPG
C-- BOUCLE SUR LES POINTS D'INTEGRATION SUR LA SURFACE

          K = (KP-1)*NNO
          CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,
     &                COUR,JACP,COSA,SINA)

          CALL R8INIR(5,0.D0,SIGMTD,1)
          R = ZERO
          CALL MOYTPG('RIGI',KP,NPGE,'+',TPG,IRET)

          DO 20 I = 1,NNO
            R = R + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
   20     CONTINUE

          CALL RCVALA(ZI(IMATE),' ','ELAS',1,'TEMP',TPG,2,NOMRES,VALRES,
     &                ICODRE,1)
          NU = VALRES(2)
          CISAIL = VALRES(1)/ (UN+NU)
          IF (NOMTE.EQ.'MECXSE3') JACP = JACP*R
          TEST = ABS(H*COUR/DEUX)
          IF (TEST.GE.UN) CORREC = ZERO
          TEST2 = ABS(H*COSA/ (DEUX*R))
          IF (TEST2.GE.UN) CORREC = ZERO

          TESTL1 = (TEST.LE.EPS .OR. CORREC.EQ.ZERO)
          TESTL2 = (TEST2.LE.EPS .OR. CORREC.EQ.ZERO .OR.
     &             ABS(COSA).LE.EPS .OR. ABS(COUR*R).LE.EPS .OR.
     &             ABS(COSA-COUR*R).LE.EPS)

          DO 50 ICOU = 1,NBCOU
            DO 40 INTE = 1,NPGE
              IF (INTE.EQ.1) THEN
                ZIC = ZMIN + (ICOU-1)*HIC
                COEF = 1.D0/3.D0
              ELSE IF (INTE.EQ.2) THEN
                ZIC = ZMIN + HIC/2.D0 + (ICOU-1)*HIC
                COEF = 4.D0/3.D0
              ELSE
                ZIC = ZMIN + HIC + (ICOU-1)*HIC
                COEF = 1.D0/3.D0
              END IF
              X3 = ZIC

              IF (TESTL1) THEN
                RHOS = 1.D0
              ELSE
                RHOS = 1.D0 + X3*COUR
              END IF
              IF (TESTL2) THEN
                RHOT = 1.D0
              ELSE
                RHOT = 1.D0 + X3*COSA/R
              END IF

C-- CALCULS DES COMPOSANTES DE DEFORMATIONS TRIDIMENSIONNELLES :
C-- EPSSS, EPSTT, EPSSX3
C-- (EN FONCTION DES DEFORMATIONS GENERALISEES :ESS,KSS,ETT,KTT,GS)
C-- DE L'INSTANT PRECEDANT ET DES DEFORMATIONS INCREMENTALES
C-- DE L'INSTANT PRESENT

              CALL DEFGEN(TESTL1,TESTL2,NNO,R,X3,SINA,COSA,COUR,
     &                    ZR(IVF+K),DFDX,ZR(IDEPLM),EPS2D,EPSX3)

              IF (NOMTE.EQ.'METDSE3' .OR. NOMTE.EQ.'METCSE3') THEN
                EPS2D(2) = 0.D0
              END IF

C-- CONSTRUCTION DE LA DEFORMATION GSX3 ET DE LA CONTRAINTE SGMSX3

              GSX3 = 2.D0* EPSX3
              SGMSX3 = CISAIL*KAPPA*GSX3/2.D0
C-- JEU D'INDICES DANS LA BOUCLE SUR LES POINTS D'INTEGRATION
C                                  DE LA SURFACE MOYENNE

              KPKI = KPKI + 1
              K1 = 4* (KPKI-1)
C-- CALCUL DES CONTRAINTES TILDE, ON A REMPLACE ICONTP PAR ICONTM

              IF (NOMTE.EQ.'MECXSE3') THEN
C                                                    AXISYM
                SIGTDI(1) = ZR(ICONTM-1+K1+1)/RHOS
                SIGTDI(2) = X3*ZR(ICONTM-1+K1+1)/RHOS
                SIGTDI(3) = ZR(ICONTM-1+K1+2)/RHOT
                SIGTDI(4) = X3*ZR(ICONTM-1+K1+2)/RHOT
                SIGTDI(5) = SGMSX3/RHOS
              ELSE
                SIGTDI(1) = ZR(ICONTM-1+K1+1)/RHOS
                SIGTDI(2) = X3*ZR(ICONTM-1+K1+1)/RHOS
                SIGTDI(3) = SGMSX3/RHOS
                SIGTDI(4) = 0.D0
                SIGTDI(5) = 0.D0
              END IF

              DO 30 I = 1,5
                SIGMTD(I) = SIGMTD(I) + SIGTDI(I)*0.5D0*HIC*COEF
   30         CONTINUE

   40       CONTINUE
   50     CONTINUE

C-- CALCUL DES EFFORTS INTERIEURS

          CALL EFFI(NOMTE,SIGMTD,ZR(IVF+K),DFDX,JACP,SINA,COSA,R,
     &              ZR(IVECTU))

   60   CONTINUE

      END
