      SUBROUTINE TE0239(OPTION,NOMTE)

C MODIF ELEMENTS  DATE 16/10/2004   AUTEUR D6BHHJP J.P.LEFEBVRE 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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

C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON LINEAIRES
C                          COQUE 1D
C                          OPTION : 'RIGI_MECA_TANG ',
C                                   'FULL_MECA      ','RAPH_MECA      '
C                          ELEMENT: MECXSE3,METCSE3,METDSE3

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      IMPLICIT NONE

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR,R8VIDE
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

      INTEGER ICOMPO,NBCOU,NPGE,ICONTM,IDEPLM,IVECTU,ICOU,INTE,ICONTP,
     &        KPKI,K1,K2,KOMPT,IVARIM,ITEMPM,ITEMPP,ITREF,IVARIP,IINSTM,
     &        IINSTP,LGPG,IDEPLP,ICARCR,NBVARI,NZ,JCRET,CODRET,ITEMPF
      REAL*8 CISAIL,ZIC,COEF,RHOS,RHOT,EPSX3,GSX3,SGMSX3
      REAL*8 TPC,TMC,TMPG1,TMPG2,TMPG3,TPPG1,TPPG2,TPPG3
      REAL*8 ZMIN,HIC,EPAIS,DEPSX3
      INTEGER NBRES,ITAB(8),JNBSPI,ITABM(8),ITABP(8)
      CHARACTER*16 OPTION,NOMTE
      PARAMETER (NBRES=2)
      CHARACTER*8 NOMRES(NBRES),TYPMOD(2),NOMPAR,NOMPU(NBRES),ELREFE
      CHARACTER*2 VALRET(NBRES)
      REAL*8 VALRES(NBRES),VALPU(NBRES),VALPAR
      REAL*8 DFDX(3),ZERO,UN,DEUX
      REAL*8 TEST,TEST2,EPS,NU,H,COSA,SINA,COUR,R,TPG
      REAL*8 JACP,KAPPA,CORREC
      REAL*8 EPS2D(4),DEPS2D(4),SIGTDI(5),SIGMTD(5)
      REAL*8 EPSANM(4),EPSANP(4),PHASM(7),PHASP(7)
      REAL*8 X3,T,TINF,TSUP
      REAL*8 DTILD(5,5),DTILDI(5,5),DSIDEP(6,6)
      REAL*8 RTANGI(9,9),RTANGE(9,9)
      REAL*8 XI,XS,XM,SIGMA,ANGMAS(3)
      REAL*8 HYDRGM,HYDRGP,SECHGM,SECHGP,SREF,LC
      INTEGER NNO,NNOS,JGANO,NDIM,KP,NPG,I,J,K,IMATUU,ITEMPR,ICACO,
     &        NDIMV,IVARIX
      INTEGER IPOIDS,IVF,IDFDK,IGEOM,IMATE,ITER
      INTEGER NBPAR,IER,COD,IRET
      LOGICAL VECTEU,MATRIC,TESTL1,TESTL2,TEMPNO

      PARAMETER (NPGE=3)

      DATA ZERO,UN,DEUX/0.D0,1.D0,2.D0/

      EPS = 1.D-3
      CODRET = 0

      VECTEU = ((OPTION.EQ.'FULL_MECA') .OR. (OPTION.EQ.'RAPH_MECA'))
      MATRIC = ((OPTION.EQ.'FULL_MECA') .OR.
     &         (OPTION.EQ.'RIGI_MECA_TANG'))

      CALL ELREF1(ELREFE)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)

      TYPMOD(1) = 'C_PLAN  '
      TYPMOD(2) = '        '

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCACOQU','L',ICACO)
      H = ZR(ICACO)
      KAPPA = ZR(ICACO+1)
      CORREC = ZR(ICACO+2)

C---- COTE MINIMALE SUR L'EPAISSEUR
      ZMIN = -H/2.D0

      CALL JEVECH('PMATERC','L',IMATE)
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'

      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL TECACH('OON','PTEMPMR',8,ITABM,IRET)
      ITEMPM = ITABM(1)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PTEREF','L',ITREF)
      CALL TECACH('OON','PTEMPPR',8,ITABP,IRET)
      ITEMPP = ITABP(1)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PCARCRI','L',ICARCR)
      CALL TECACH('ONN','PTEMPEF',1,ITEMPF,IRET)
      TEMPNO = .TRUE.
      IF (IRET.EQ.0) TEMPNO = .FALSE.

      IF (ZK16(ICOMPO+3).EQ.'COMP_ELAS') THEN
        CALL UTMESS('F','TE0239','COMP_ELAS NON VALIDE')
      END IF

      IF (ZK16(ICOMPO+2) (6:10).EQ.'_REAC') THEN
        CALL UTMESS('A','TE0239',' LA REACTUALISATION DE LA '//
     &              'GEOMETRIE (DEFORMATION : PETIT_REAC '//
     &              'SOUS LE MOT CLE COMP_INCR) '//
     &              'EST DECONSEILLEE POUR LES ELEMENTS DE COQUE_1D.')
      END IF

C--- LECTURE DU NBRE DE VAR. INTERNES, DE COUCHES ET LONG. MAX DU
C--- POINT D'INTEGRATION
      READ (ZK16(ICOMPO-1+2),'(I16)') NBVARI
      CALL TECACH('OON','PVARIMR',7,ITAB,IRET)
      LGPG = MAX(ITAB(6),1)*ITAB(7)
      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
C---- MESSAGES LIMITATION NBRE DE COUCHES
      IF (NBCOU.LE.0) CALL UTMESS('F','TE0239',
     &                 'NOMBRE DE COUCHES OBLIGATOIREMENT SUPERIEUR A 0'
     &                            )
      IF (NBCOU.GT.10) CALL UTMESS('F','TE0239',
     &                'NOMBRE DE COUCHES LIMITE A 10 POUR LES COQUES 1D'
     &                             )
C---- EPAISSEUR DE CHAQUE COUCHE
      HIC = H/NBCOU
      IF (VECTEU) THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
      END IF
      IF (VECTEU) THEN
        NDIMV = NPG*NPGE*NBCOU*NBVARI
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL R8COPY(NDIMV,ZR(IVARIX),1,ZR(IVARIP),1)
      END IF
      IF (MATRIC) THEN
        CALL JEVECH('PMATUUR','E',IMATUU)
C        IVARIP=IVARIM
      END IF
C     POUR AVOIR UN TABLEAU BIDON A DONNER A NMCOMP

      DO 10 J = 1,4
        EPSANM(J) = 0.D0
        EPSANP(J) = 0.D0
   10 CONTINUE
      NZ = 0
      DO 20 J = 1,7
        PHASM(J) = 0.D0
        PHASP(J) = 0.D0
   20 CONTINUE

      CALL R8INIR(81,0.D0,RTANGE,1)
      KPKI = 0
C ---  VARIABLE D HYDRATATION ET DE SECHAGE
      HYDRGM = 0.D0
      HYDRGP = 0.D0
      SECHGM = 0.D0
      SECHGP = 0.D0
      SREF   = 0.D0
C-- DEBUT DE BOUCLE D'INTEGRATION SUR LA SURFACE NEUTRE
      DO 140 KP = 1,NPG
        K = (KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     &              JACP,COSA,SINA)
        R = ZERO
        TPG = ZERO
        TMPG1 = ZERO
        TMPG2 = ZERO
        TMPG3 = ZERO
        TPPG1 = ZERO
        TPPG2 = ZERO
        TPPG3 = ZERO

        CALL R8INIR(5,0.D0,SIGMTD,1)
        CALL R8INIR(25,0.D0,DTILD,1)

C-- BOUCLE SUR LES POINTS D'INTEGRATION SUR LA SURFACE

        DO 30 I = 1,NNO
          R = R + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
   30   CONTINUE

C===============================================================
C     -- RECUPERATION DE LA TEMPERATURE POUR LE MATERIAU:
C     -- SI LA TEMPERATURE EST CONNUE AUX NOEUDS :
        CALL TECACH('ONN','PTEMPER',8,ITAB,IRET)
        ITEMPR = ITAB(1)
        IF (IRET.EQ.0 .OR. IRET.EQ.3) THEN
          NBPAR = 1
          NOMPAR = 'TEMP'
          DO 40 I = 1,NNO
            CALL DXTPIF(ZR(ITEMPR+3* (I-1)),ZL(ITAB(8)+3* (I-1)))
            T = ZR(ITEMPR+3* (I-1))
            TINF = ZR(ITEMPR+1+3* (I-1))
            TSUP = ZR(ITEMPR+2+3* (I-1))
            TPG = TPG + (T+ (TSUP+TINF-2*T)/6.D0)*ZR(IVF+K+I-1)

C  RECUPERATION DES TEMPERATURES TXPG1 = MOY
C                                TXPG2 = INF
C                                TXPG3 = SUP

            CALL DXTPIF(ZR(ITEMPM+3* (I-1)),ZL(ITABM(8)+3* (I-1)))
            TMPG1 = TMPG1 + ZR(ITEMPM+3*I-3)*ZR(IVF+K+I-1)
            TMPG2 = TMPG2 + ZR(ITEMPM+3*I-2)*ZR(IVF+K+I-1)
            TMPG3 = TMPG3 + ZR(ITEMPM+3*I-1)*ZR(IVF+K+I-1)

            CALL DXTPIF(ZR(ITEMPP+3* (I-1)),ZL(ITABP(8)+3* (I-1)))
            TPPG1 = TPPG1 + ZR(ITEMPP+3*I-3)*ZR(IVF+K+I-1)
            TPPG2 = TPPG2 + ZR(ITEMPP+3*I-2)*ZR(IVF+K+I-1)
            TPPG3 = TPPG3 + ZR(ITEMPP+3*I-1)*ZR(IVF+K+I-1)
   40     CONTINUE
          VALPAR = TPG/NNO
        ELSE
C     -- SI LA TEMPERATURE EST UNE FONCTION DE 'INST' ET 'EPAIS':
          IF (ITEMPF.GT.0) THEN
            NBPAR = 1
            NOMPAR = 'TEMP'
            NOMPU(1) = 'INST'
            NOMPU(2) = 'EPAIS'
            VALPU(1) = ZR(IINSTP)
            VALPU(2) = 0.D0
            CALL FOINTE('FM',ZK8(ITEMPF),2,NOMPU,VALPU,VALPAR,IER)
C     -- SI LA TEMPERATURE N'EST PAS DONNEE:
          ELSE
            NBPAR = 0
            NOMPAR = ' '
            VALPAR = 0.D0
          END IF
        END IF

        CALL RCVALA(ZI(IMATE),' ','ELAS',NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,VALRET,'FM')

        NU = VALRES(2)
        CISAIL = VALRES(1)/ (UN+NU)

        IF (NOMTE(3:4).EQ.'CX') JACP = JACP*R

        TEST = ABS(H*COUR/DEUX)
        IF (TEST.GE.UN) CORREC = ZERO
        TEST2 = ABS(H*COSA/ (DEUX*R))
        IF (TEST2.GE.UN) CORREC = ZERO

        TESTL1 = (TEST.LE.EPS .OR. CORREC.EQ.ZERO)
        TESTL2 = (TEST2.LE.EPS .OR. CORREC.EQ.ZERO .OR.
     &           ABS(COSA).LE.EPS .OR. ABS(COUR*R).LE.EPS .OR.
     &           ABS(COSA-COUR*R).LE.EPS)

C-- DEBUT DE BOUCLE D'INTEGRATION DANS L'EPAISSEUR

        DO 110 ICOU = 1,NBCOU
          DO 100 INTE = 1,NPGE
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

C-- INTERPOLATION DANS L'EPAISSEUR (DISTRIBUTION PARABOLIQUE DE T)
C-- VALEURS DE TMPG ET TPPG AU POINT D'INTEGRATION
C-- CALCUL DE TMC : TEMPERATURE A T-
C             TPC : TEMPERATURE A T+
            EPAIS = H
            IF (TEMPNO) THEN
              TMC = 2* (TMPG2+TMPG3-2*TMPG1)* (ZIC/EPAIS)* (ZIC/EPAIS) +
     &              (TMPG3-TMPG2)* (ZIC/EPAIS) + TMPG1
              TPC = 2* (TPPG2+TPPG3-2*TPPG1)* (ZIC/EPAIS)* (ZIC/EPAIS) +
     &              (TPPG3-TPPG2)* (ZIC/EPAIS) + TPPG1
            ELSE
              VALPU(2) = ZIC
              VALPU(1) = ZR(IINSTM)
              CALL FOINTE('FM',ZK8(ITEMPF),2,NOMPU,VALPU,TMC,IER)
              VALPU(1) = ZR(IINSTP)
              CALL FOINTE('FM',ZK8(ITEMPF),2,NOMPU,VALPU,TPC,IER)
            END IF

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

            CALL DEFGEN(TESTL1,TESTL2,NNO,R,X3,SINA,COSA,COUR,ZR(IVF+K),
     &                  DFDX,ZR(IDEPLM),EPS2D,EPSX3)

            CALL DEFGEN(TESTL1,TESTL2,NNO,R,X3,SINA,COSA,COUR,ZR(IVF+K),
     &                  DFDX,ZR(IDEPLP),DEPS2D,DEPSX3)

            IF (NOMTE(3:4).EQ.'TD') THEN
              EPS2D(2) = 0.D0
              DEPS2D(2) = 0.D0
            ELSE IF (NOMTE(3:4).EQ.'TC') THEN
              EPS2D(2) = 0.D0
              DEPS2D(2) = -10000.D0* (EPS2D(1)+DEPS2D(1))
            END IF

C-- CONSTRUCTION DE LA DEFORMATION GSX3 ET DE LA CONTRAINTE SGMSX3

            GSX3 = 2.D0* (EPSX3+DEPSX3)
            SGMSX3 = CISAIL*KAPPA*GSX3/2.D0
C-- APPEL DE NMCOMP: LOI PLASTIQUE
            KPKI = KPKI + 1
            K1 = 4* (KPKI-1)
            K2 = LGPG* (KP-1) + (NPGE* (ICOU-1)+INTE-1)*NBVARI
            ITER = 0
            IF (DEPS2D(2).GT.0.D0) THEN
              XI = -0.99D0*DEPS2D(2)
              XM = XI
              XS = DEPS2D(2)
            ELSE
              XI = DEPS2D(2)
              XM = XI
              XS = -0.99D0*DEPS2D(2)
            END IF

   50       CONTINUE
            ITER = ITER + 1
            DEPS2D(2) = XM
C --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C --- INITIALISE A R8VIDE (ON NE S'EN SERT PAS)
            ANGMAS(1) = R8VIDE()
            ANGMAS(2) = R8VIDE()
            ANGMAS(3) = R8VIDE()

            CALL NMCOMP(2,TYPMOD,ZI(IMATE),ZK16(ICOMPO),ZR(ICARCR),
     &                  ZR(IINSTM),ZR(IINSTP),
     &                  TMC,TPC,ZR(ITREF),
     &                  HYDRGM,HYDRGP,
     &                  SECHGM,SECHGP,SREF,
     &                  EPS2D,DEPS2D,
     &                  ZR(ICONTM+K1),ZR(IVARIM+K2),
     &                  OPTION,
     &                  EPSANM,EPSANP,NZ,
     &                  PHASM,PHASP,
     &                  R8VIDE(),R8VIDE(),
     &                  ANGMAS,
     &                  LC,
     &                  ZR(ICONTP+K1),ZR(IVARIP+K2),DSIDEP,COD)

C           COD=1 : ECHEC INTEGRATION LOI DE COMPORTEMENT
C           COD=3 : C_PLAN DEBORST SIGZZ NON NUL
            IF (COD.NE.0) THEN
              IF (CODRET.NE.1) THEN
                CODRET = COD
              END IF
            END IF

            IF (VECTEU) THEN

              IF (NOMTE(3:4).NE.'TC') GO TO 60
              IF (ITER.EQ.1) THEN
                SIGMA = ZR(ICONTP-1+K1+2)
                IF (ABS(SIGMA).LT.1.D-18) GO TO 60
                XM = (XS+XI)/2.D0
                GO TO 50
              ELSE
                IF (ABS(XS-XI).LT.1.D-30) GO TO 60
                IF (ABS((XS-XI)/ (XS+XI)).LT.1.D-14) GO TO 60
              END IF
              IF (ITER.GT.1000) THEN
                WRITE (6,*) 'PB CONVERGENCE CONTRAINTE PLANE'
                WRITE (6,*) 'SIGXX',ZR(ICONTP-1+K1+1)
                WRITE (6,*) 'SIGYY',ZR(ICONTP-1+K1+2)
                WRITE (6,*) 'SIGZZ',ZR(ICONTP-1+K1+3)
                WRITE (6,*) 'SIGXY',ZR(ICONTP-1+K1+4)
                GO TO 60
              END IF
              IF (SIGMA*ZR(ICONTP-1+K1+2).GT.0.D0) THEN
                XI = XM
                XM = (XS+XI)/2.D0
              ELSE
                XS = XM
                XM = (XS+XI)/2.D0
              END IF
              GO TO 50
            END IF
   60       CONTINUE

            IF (MATRIC) THEN
C-- CALCULS DE LA MATRICE TANGENTE : BOUCLE SUR L'EPAISSEUR

C-- CONSTRUCTION DE LA MATRICE DTD (DTILD)
              CALL MATDTD(NOMTE,TESTL1,TESTL2,DSIDEP,CISAIL,X3,COUR,R,
     &                    COSA,KAPPA,DTILDI)
              DO 80 I = 1,5
                DO 70 J = 1,5
                  DTILD(I,J) = DTILD(I,J) + DTILDI(I,J)*0.5D0*HIC*COEF
   70           CONTINUE
   80         CONTINUE
            END IF

            IF (VECTEU) THEN
C-- CALCULS DES EFFORTS INTERIEURS : BOUCLE SUR L'EPAISSEUR
              IF (NOMTE(3:4).EQ.'CX') THEN
                SIGTDI(1) = ZR(ICONTP-1+K1+1)/RHOS
                SIGTDI(2) = X3*ZR(ICONTP-1+K1+1)/RHOS
                SIGTDI(3) = ZR(ICONTP-1+K1+2)/RHOT
                SIGTDI(4) = X3*ZR(ICONTP-1+K1+2)/RHOT
                SIGTDI(5) = SGMSX3/RHOS
              ELSE
                SIGTDI(1) = ZR(ICONTP-1+K1+1)/RHOS
                SIGTDI(2) = X3*ZR(ICONTP-1+K1+1)/RHOS
                SIGTDI(3) = SGMSX3/RHOS
                SIGTDI(4) = 0.D0
                SIGTDI(5) = 0.D0
              END IF

              DO 90 I = 1,5
                SIGMTD(I) = SIGMTD(I) + SIGTDI(I)*0.5D0*HIC*COEF
   90         CONTINUE
            END IF
C-- FIN DE BOUCLE SUR LES POINTS D'INTEGRATION DANS L'EPAISSEUR
  100     CONTINUE
  110   CONTINUE

        IF (VECTEU) THEN
C-- CALCUL DES EFFORTS INTERIEURS
          CALL EFFI(NOMTE,SIGMTD,ZR(IVF+K),DFDX,JACP,SINA,COSA,R,
     &              ZR(IVECTU))
        END IF
        IF (MATRIC) THEN
C-- CONSTRUCTION DE LA MATRICE TANGENTE
          CALL MATTGE(NOMTE,DTILD,SINA,COSA,R,JACP,ZR(IVF+K),DFDX,
     &                RTANGI)
          DO 130 I = 1,9
            DO 120 J = 1,9
              RTANGE(I,J) = RTANGE(I,J) + RTANGI(I,J)
  120       CONTINUE
  130     CONTINUE
        END IF
C-- FIN DE BOUCLE SUR LES POINTS D'INTEGRATION DE LA SURFACE NEUTRE
  140 CONTINUE
      IF (MATRIC) THEN
C-- STOCKAGE DE LA MATRICE TANGENTE
        KOMPT = 0
        DO 160 J = 1,9
          DO 150 I = 1,J
            KOMPT = KOMPT + 1
            ZR(IMATUU-1+KOMPT) = RTANGE(I,J)
  150     CONTINUE
  160   CONTINUE
      END IF
      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = CODRET
      END IF
      END
