      SUBROUTINE TUFULL(OPTION,NOMTE,NBRDDL,DEPLM,DEPLP,
     &                  B,KTILD,EFFINT,
     &                  PASS,VTEMP,CODRET)
      IMPLICIT   NONE
      CHARACTER*16 OPTION
C ......................................................................
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C TOLE CRP_20
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

C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          TUYAU
C                          OPTION : RIGI_MECA_TANG, FULL_MECA
C                                   RAPH_MECA
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL

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

      INTEGER NBRES,NBRDDL,NC,KPGS,NBCOUM,NBSECM
      PARAMETER (NBRES=9)
      CHARACTER*16 NOMTE
      CHARACTER*8 NOMRES(NBRES),NOMPAR,TYPMOD(2),NOMPU(2)
      CHARACTER*10 PHENOM
      CHARACTER*2 VALRET(NBRES)
      REAL*8 VALRES(NBRES),VALPAR,VALPU(2),XPG(4)
      PARAMETER (NBSECM=32,NBCOUM=10)
      REAL*8 CM1,CP1,TMINF,TMMOY,TMSUP,TPINF,TPMOY,TPSUP
      REAL*8 POICOU(2*NBCOUM+1),POISEC(2*NBSECM+1)
      REAL*8 H,A,L,FI,GXZ,RAC2,SINFI,X,PI,DEUXPI
      REAL*8 DEPLM(NBRDDL),DEPLP(NBRDDL),B(4,NBRDDL),PGL4(3,3)
      REAL*8 EPSI(4),DEPSI(4),EPS2D(6),DEPS2D(6)
      REAL*8 SIGN(4),SIGMA(4),SGMTD(4)
      REAL*8 DSIDEP(6,6),DTILD(4,4)
      REAL*8 CISAIL,WGT,R,R8PI,R8NNEM,INSTM,INSTP
      REAL*8 KTILD(NBRDDL,NBRDDL),EFFINT(NBRDDL)
      REAL*8 PASS(NBRDDL,NBRDDL)
      REAL*8 PGL(3,3),TMC,TPC,OMEGA,VTEMP(NBRDDL)
      REAL*8 PGL1(3,3),PGL2(3,3),PGL3(3,3),RAYON,THETA
      REAL*8 LC,ANGMAS(3)
      INTEGER NNO,NPG,NBCOU,NBSEC,M,ICOMPO,NDIMV,IVARIX
      INTEGER IPOIDS,IVF,NBVARI,LGPG,JTAB(7)
      INTEGER IMATE,ITEMP,IMATUU,ICAGEP,IGEOM,NBPAR,ITABM(8),ITABP(8)
      INTEGER IVARIP,IVARIM,ITREF,ICONTM,ICONTP,IVECTU
      INTEGER IGAU,ICOU,ISECT,I,J,K,L1,LORIEN
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICARCR,NBV,ICOUDE,K1,K2
      INTEGER ITEMPM,ITEMPP,INO,IER,ICOUD2,MMT,CODRET,COD
      INTEGER JNBSPI,IRET,KSP
      INTEGER NDIM,NNOS,JCOOPG,IDFDK,JDFD2,JGANO
      LOGICAL VECTEU,MATRIC,TEMPNO

      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,JCOOPG,IVF,IDFDK,
     &            JDFD2,JGANO)

      NC = NBRDDL* (NBRDDL+1)/2
      PI = R8PI()
      DEUXPI = 2.D0*PI
      RAC2 = SQRT(2.D0)
      TYPMOD(1) = 'C_PLAN  '
      TYPMOD(2) = '        '
      CODRET = 0

C --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C --- INITIALISE A 0.D0 (ON NE S'EN SERT PAS)
      CALL R8INIR(3, 0.D0, ANGMAS ,1)

      M = 3
      IF (NOMTE.EQ.'MET6SEG3') M = 6

C=====RECUPERATION NOMBRE DE COUCHES ET DE SECTEURS ANGULAIRES

      CALL JEVECH('PCOMPOR','L',ICOMPO)
      IF (ZK16(ICOMPO+3).EQ.'COMP_ELAS') THEN
        CALL U2MESS('F','ELEMENTS2_90')
      END IF

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
      NBSEC = ZI(JNBSPI-1+2)
      IF (NBCOU*NBSEC.LE.0) THEN
        CALL U2MESS('F','ELEMENTS4_46')
      END IF
      IF (NBCOU.GT.NBCOUM) THEN
        CALL UTDEBM('F','TUFULL','TUYAU : LE NOMBRE DE COUCHES')
        CALL UTIMPI('L',' EST LIMITE A ',1,NBCOUM)
        CALL UTFINM
      END IF
      IF (NBSEC.GT.NBSECM) THEN
        CALL UTDEBM('F','TUFULL','TUYAU : LE NOMBRE DE SECTEURS')
        CALL UTIMPI('L',' EST LIMITE A ',1,NBSECM)
        CALL UTFINM
      END IF

      READ (ZK16(ICOMPO-1+2),'(I16)') NBVARI
      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCAGEPO','L',ICAGEP)
      H = ZR(ICAGEP+1)
      A = ZR(ICAGEP) - H/2.D0
C A= RMOY, H = EPAISSEUR, L = LONGUEUR


      DO 10 I = 1,NPG
        XPG(I) = ZR(JCOOPG-1+I)
   10 CONTINUE

C  LES POIDS POUR L'INTEGRATION DANS L'EPAISSEUR

      POICOU(1) = 1.D0/3.D0
      DO 20 I = 1,NBCOU - 1
        POICOU(2*I) = 4.D0/3.D0
        POICOU(2*I+1) = 2.D0/3.D0
   20 CONTINUE
      POICOU(2*NBCOU) = 4.D0/3.D0
      POICOU(2*NBCOU+1) = 1.D0/3.D0

C  LES POIDS POUR L'INTEGRATION SUR LA CIRCONFERENCE

      POISEC(1) = 1.D0/3.D0
      DO 30 I = 1,NBSEC - 1
        POISEC(2*I) = 4.D0/3.D0
        POISEC(2*I+1) = 2.D0/3.D0
   30 CONTINUE
      POISEC(2*NBSEC) = 4.D0/3.D0
      POISEC(2*NBSEC+1) = 1.D0/3.D0

C   FIN DES POIDS D'INTEGRATION

C     --- RECUPERATION DES ORIENTATIONS ---

      CALL JEVECH('PCAORIE','L',LORIEN)

      CALL CARCOU(ZR(LORIEN),L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,NNO,
     &            OMEGA,ICOUD2)
      IF (ICOUD2.GE.10) THEN
        ICOUDE = ICOUD2 - 10
        MMT = 0
        IF (H/A.GT. (0.25D0)) THEN
          CALL U2MESS('A','ELEMENTS4_53')
        END IF
      ELSE
        ICOUDE = ICOUD2
        MMT = 1
      END IF

      VECTEU = ((OPTION.EQ.'FULL_MECA') .OR. (OPTION.EQ.'RAPH_MECA'))
      MATRIC = ((OPTION.EQ.'FULL_MECA') .OR.
     &         (OPTION.EQ.'RIGI_MECA_TANG'))

      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PTEREF','L',ITREF)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      INSTM = ZR(IINSTM)
      INSTP = ZR(IINSTP)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PCARCRI','L',ICARCR)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PMATERC','L',IMATE)

      IF (VECTEU) THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
        NDIMV = NPG*NBVARI* (2*NBSEC+1)* (2*NBCOU+1)
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL DCOPY(NDIMV,ZR(IVARIX),1,ZR(IVARIP),1)
      ELSE
C       -- POUR AVOIR UN TABLEAU BIDON A DONNER A NMCOMP :
        IVARIP = IVARIM
      END IF

C ===== INITIALISATION DE LA MATRICE K DE RIGIDITE===
C ===== ET DES EFFORTS INTERNES======================

      DO 50 I = 1,NBRDDL
        DO 40 J = 1,NBRDDL
          KTILD(I,J) = 0.D0
   40   CONTINUE
        EFFINT(I) = 0.D0
   50 CONTINUE

      DO 80 I = 1,NBRDDL
        DEPLM(I) = ZR(IDEPLM-1+I)
        DEPLP(I) = ZR(IDEPLP-1+I)
   80 CONTINUE
      IF (ICOUDE.EQ.0) THEN
        CALL VLGGL(NNO,NBRDDL,PGL,DEPLM,'GL',PASS,VTEMP)
        CALL VLGGL(NNO,NBRDDL,PGL,DEPLP,'GL',PASS,VTEMP)
      ELSE
        CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,DEPLM,'GL',PASS,
     &              VTEMP)
        CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,DEPLP,'GL',PASS,
     &              VTEMP)
      END IF

C===============================================================
C     -- RECUPERATION DE LA TEMPERATURE :
C     1- SI LA TEMPERATURE EST CONNUE AUX NOEUDS :
C        -----------------------------------------
      CALL TECACH('ONN','PTEMPMR',8,ITABM,IRET)
      ITEMPM = ITABM(1)
      IF (ITEMPM.NE.0) THEN
        NBPAR = 1
        NOMPAR = 'TEMP'
        TEMPNO = .TRUE.
        CALL TECACH('OON','PTEMPPR',8,ITABP,IRET)
        ITEMPP = ITABP(1)


C       -- CALCUL DES TEMPERATURES INF, SUP ET MOY
C          (MOYENNE DES NNO NOEUDS) ET DES COEF. DES POLY. DE DEGRE 2 :
C          ------------------------------------------------------------
        TMINF = 0.D0
        TMMOY = 0.D0
        TMSUP = 0.D0
        TPINF = 0.D0
        TPMOY = 0.D0
        TPSUP = 0.D0
        DO 90,INO = 1,NNO
          CALL DXTPIF(ZR(ITEMPM+3* (INO-1)),ZL(ITABM(8)+3* (INO-1)))
          TMMOY = TMMOY + ZR(ITEMPM-1+3* (INO-1)+1)/DBLE(NNO)
          TMINF = TMINF + ZR(ITEMPM-1+3* (INO-1)+2)/DBLE(NNO)
          TMSUP = TMSUP + ZR(ITEMPM-1+3* (INO-1)+3)/DBLE(NNO)

          CALL DXTPIF(ZR(ITEMPP+3* (INO-1)),ZL(ITABP(8)+3* (INO-1)))
          TPMOY = TPMOY + ZR(ITEMPP-1+3* (INO-1)+1)/DBLE(NNO)
          TPINF = TPINF + ZR(ITEMPP-1+3* (INO-1)+2)/DBLE(NNO)
          TPSUP = TPSUP + ZR(ITEMPP-1+3* (INO-1)+3)/DBLE(NNO)
   90   CONTINUE
        CM1 = TMMOY
        CP1 = TPMOY
        VALPAR = CM1
      ELSE
C     2- SI LA TEMPERATURE EST UNE FONCTION DE 'INST' ET 'EPAIS'
C        -------------------------------------------------------
        CALL TECACH('ONN','PTEMPEF',1,ITEMP,IRET)
        IF (ITEMP.GT.0) THEN
          TEMPNO = .FALSE.
          NBPAR = 1
          NOMPAR = 'TEMP'
          NOMPU(1) = 'INST'
          NOMPU(2) = 'EPAIS'
          VALPU(1) = INSTM
          VALPU(2) = 0.D0
          CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,VALPAR,IER)
        ELSE
          NBPAR = 0
          NOMPAR = ' '
          VALPAR = 0.D0
        END IF
      END IF

C===============================================================
C     RECUPERATION COMPORTEMENT POUR TERME DE CISAILLEMENT

      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,VALRET)

      IF (PHENOM.EQ.'ELAS') THEN
        NBV = 2
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
      ELSE
        CALL U2MESS('F','ELEMENTS_42')
      END IF

      CALL RCVALA(ZI(IMATE),' ',PHENOM,NBPAR,NOMPAR,VALPAR,NBV,NOMRES,
     &            VALRES,VALRET,'FM')

      CISAIL = VALRES(1)/ (1.D0+VALRES(2))

C==============================================================

C BOUCLE SUR LES POINTS DE GAUSS

      KPGS = 0
      DO 140 IGAU = 1,NPG

C BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR

        DO 130 ICOU = 1,2*NBCOU + 1
          IF (MMT.EQ.0) THEN
            R = A
          ELSE
            R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
          END IF

C BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE

          DO 120 ISECT = 1,2*NBSEC + 1
            KPGS = KPGS + 1
            IF (ICOUDE.EQ.0) THEN

              WGT = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &              (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R

              CALL BCOUDE(IGAU,ICOU,ISECT,L,H,A,M,NNO,NBCOU,
     &                    NBSEC,ZR(IVF),ZR(IDFDK),ZR(JDFD2),MMT,B)
            ELSE IF (ICOUDE.EQ.1) THEN
              FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
C               FI = FI - OMEGA
              SINFI = SIN(FI)
              L = THETA* (RAYON+R*SINFI)
              CALL BCOUDC(IGAU,ICOU,ISECT,H,A,M,OMEGA,XPG,NNO,
     &                    NBCOU,NBSEC,ZR(IVF),ZR(IDFDK),ZR(JDFD2),RAYON,
     &                    THETA,MMT,B)
              WGT = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &              (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
            END IF

            K1 = 6* (KPGS-1)
            K2 = LGPG* (IGAU-1) + ((2*NBSEC+1)* (ICOU-1)+ (ISECT-1))*
     &           NBVARI

C ======= CALCUL DES DEFORMATIONS ET INCREMENTS DE DEFORMATION

            CALL EPSETT('DEFORM',NBRDDL,DEPLM,B,X,EPSI,WGT,X)
            EPS2D(1) = EPSI(1)
            EPS2D(2) = EPSI(2)
            EPS2D(3) = 0.D0
            EPS2D(4) = EPSI(3)/RAC2

            CALL EPSETT('DEFORM',NBRDDL,DEPLP,B,X,DEPSI,WGT,X)
            DEPS2D(1) = DEPSI(1)
            DEPS2D(2) = DEPSI(2)
            DEPS2D(3) = 0.D0
            DEPS2D(4) = DEPSI(3)/RAC2

            GXZ = EPSI(4) + DEPSI(4)

C  RAPPEL DU VECTEUR CONTRAINTE

            DO 100 I = 1,3
              SIGN(I) = ZR(ICONTM-1+K1+I)
  100       CONTINUE
            SIGN(4) = ZR(ICONTM-1+K1+4)*RAC2

C         -- CALCUL DES TEMPERATURES TPC ET TMC SUR LA COUCHE :
C         ---------------------------------------------------
            IF (TEMPNO) THEN
              TMC = CM1
              TPC = CP1
            ELSE
              VALPU(2) = R - A
              VALPU(1) = INSTM
              CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,TMC,IER)
              VALPU(1) = INSTP
              CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,TPC,IER)
            END IF

C -    APPEL A LA LOI DE COMPORTEMENT
            KSP=(ICOU-1)*(2*NBSEC+1) + ISECT
            CALL NMCOMP('RIGI',IGAU,KSP,2,TYPMOD,ZI(IMATE),
     &                  ZK16(ICOMPO),ZR(ICARCR),
     &                  ZR(IINSTM),ZR(IINSTP),
     &                  TMC,TPC,ZR(ITREF),
     &                  EPS2D,DEPS2D,
     &                  SIGN,ZR(IVARIM+K2),
     &                  OPTION,
     &                  ANGMAS,
     &                  LC,SIGMA,ZR(IVARIP+K2),DSIDEP,COD)

C           COD=1 : ECHEC INTEGRATION LOI DE COMPORTEMENT
C           COD=3 : C_PLAN DEBORST SIGZZ NON NUL
            IF (COD.NE.0) THEN
              IF (CODRET.NE.1) THEN
                CODRET = COD
              END IF
            END IF

C    CALCULS DE LA MATRICE TANGENTE : BOUCLE SUR L'EPAISSEUR

            IF (MATRIC) THEN

              DTILD(1,1) = DSIDEP(1,1)
              DTILD(1,2) = DSIDEP(1,2)
              DTILD(1,3) = DSIDEP(1,4)/RAC2
              DTILD(1,4) = 0.D0

              DTILD(2,1) = DSIDEP(2,1)
              DTILD(2,2) = DSIDEP(2,2)
              DTILD(2,3) = DSIDEP(2,4)/RAC2
              DTILD(2,4) = 0.D0

              DTILD(3,1) = DSIDEP(4,1)/RAC2
              DTILD(3,2) = DSIDEP(4,2)/RAC2
              DTILD(3,3) = DSIDEP(4,4)/2.D0
              DTILD(3,4) = 0.D0

              DTILD(4,1) = 0.D0
              DTILD(4,2) = 0.D0
              DTILD(4,3) = 0.D0
              DTILD(4,4) = CISAIL/2.D0

C  LE DERNIER TERME C'EST R DU  R DFI DX DZETA

              CALL KCOUDE(NBRDDL,WGT,B,DTILD,KTILD)
            END IF

            IF (VECTEU) THEN

              DO 110 I = 1,3
                ZR(ICONTP-1+K1+I) = SIGMA(I)
  110         CONTINUE
              ZR(ICONTP-1+K1+4) = SIGMA(4)/RAC2
              ZR(ICONTP-1+K1+5) = CISAIL*GXZ/2.D0
              ZR(ICONTP-1+K1+6) = 0.D0

C===========    CALCULS DES EFFORTS INTERIEURS

              SGMTD(1) = ZR(ICONTP-1+K1+1)
              SGMTD(2) = ZR(ICONTP-1+K1+2)
              SGMTD(3) = ZR(ICONTP-1+K1+4)
              SGMTD(4) = CISAIL*GXZ/2.D0

              CALL EPSETT('EFFORI',NBRDDL,X,B,SGMTD,X,WGT,EFFINT)

            END IF

  120     CONTINUE
  130   CONTINUE
  140 CONTINUE

C STOCKAGE DE LA MATRICE DE RIGIDITE
      IF (MATRIC) THEN
C     CHANGEMENT DE REPERE : REPERE LOCAL AU REPERE GLOBAL
        IF (ICOUDE.EQ.0) THEN
          CALL KLG(NNO,NBRDDL,PGL,KTILD)
        ELSE IF (ICOUDE.EQ.1) THEN
          CALL KLGCOU(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,KTILD)
        END IF
        CALL JEVECH('PMATUUR','E',IMATUU)
        CALL MAVEC(KTILD,NBRDDL,ZR(IMATUU),NC)
      END IF

C STOCKAGE DES EFFORTS INTERIEURS
      IF (VECTEU) THEN
C     CHANGEMENT DE REPERE : REPERE LOCAL AU REPERE GLOBAL
        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,EFFINT,'LG',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,EFFINT,'LG',PASS,
     &                VTEMP)
        END IF
        DO 150,I = 1,NBRDDL
          ZR(IVECTU-1+I) = EFFINT(I)
  150   CONTINUE
      END IF
  160 CONTINUE

      END
