      SUBROUTINE TUFORC(OPTION,ELREFE,NBRDDL,B,F,VIN,VOUT,MAT,PASS,
     &                   VTEMP)
      IMPLICIT NONE
C MODIF ELEMENTS  DATE 03/07/2002   AUTEUR CIBHHPD D.NUNEZ 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================
      CHARACTER*16 OPTION,ELREFL

C    - FONCTION REALISEE:  CALCUL DES OPTIONS FORC_NODA ET
C      EFGE_ELNO_DEPL ELEMENT: MET3SEG3 MET6SEG3 MET3SEG4

      INTEGER NBRES,NBRDDL,NBSECM,NBCOUM
      PARAMETER (NBRES=9)
      CHARACTER*24 CARAC,FF,CHMAT
      CHARACTER*8 NOMRES(NBRES),NOMPAR,NOMPU(2)
      CHARACTER*8 ELREFE
      CHARACTER*2 CODRET(NBRES)
      REAL*8 VALRES(NBRES),VALPAR,VALPU(2),H,A,L,E,NU
      PARAMETER (NBSECM=32,NBCOUM=10)
      REAL*8 POICOU(2*NBCOUM+1),POISEC(2*NBSECM+1)
      REAL*8 PI,DEUXPI,SIG(4),FPG(4,6)
      REAL*8 B(4,NBRDDL),C(4,4),F(NBRDDL),EFG(6),FNO(6)
      REAL*8 PGL(3,3),VIN(NBRDDL),VOUT(NBRDDL),MAT(NBRDDL,4)
      REAL*8 VTEMP(NBRDDL),PASS(NBRDDL,NBRDDL),COSFI,SINFI
      REAL*8 TEMPGM(4),TEMPGS(4),TEMPGI(3),TREF,VPG(4)
      REAL*8 TMOY(4),TINF(4),TSUP(4),SIGTH(2),HK(4,4),VNO(4)
      REAL*8 BETA,CISAIL,FI,G,POIDS,R,R8PI,OMEGA,XPG(4)
      REAL*8 PGL1(3,3),PGL2(3,3),PGL3(3,3),RAYON,THETA
      REAL*8 CP(2,2),CV(2,2),CO(4,4),SI(4,4),TK(4),PGL4(3,3)
      INTEGER NNO,NPG,NBCOU,NBSEC,M,ICARAC,NPG2
      INTEGER IPOIDS,IVF,ICOUDE,ICOUD2
      INTEGER IMATE,ITEMP,ICAGEP,IGEOM,NBPAR,I1,I2,IH,MMT
      INTEGER IGAU,ICOU,ISECT,I,J,JIN,JOUT,IRET,INO,KPGS
      INTEGER IFF,LORIEN,INDICE,K,ICOMPO,NPSIG
      INTEGER IBID,IER,JTREF,IP,JMAT,IC,KP,NNOS,NLIG,NCOL
      INTEGER NPG1,IXF,JNBSPI,ITAB(8)
      REAL*8 ALPHA,TMOY1,TINF1,TSUP1,HHK,COE1,ALPHAF,BETAF
      REAL*8 ALPHAM,BETAM,XA,XB,XC,XD
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

      PI = R8PI()
      DEUXPI = 2.D0*PI
      ELREFL = ELREFE

      CALL JEVECH('PNBSP_I','L',JNBSPI)
      NBCOU = ZI(JNBSPI-1+1)
      NBSEC = ZI(JNBSPI-1+2)

C     -- CALCUL DES POIDS DES COUCHES ET DES SECTEURS:
      POICOU(1) = 1.D0/3.D0
      DO 10 I = 1,NBCOU - 1
        POICOU(2*I) = 4.D0/3.D0
        POICOU(2*I+1) = 2.D0/3.D0
   10 CONTINUE
      POICOU(2*NBCOU) = 4.D0/3.D0
      POICOU(2*NBCOU+1) = 1.D0/3.D0
      POISEC(1) = 1.D0/3.D0
      DO 20 I = 1,NBSEC - 1
        POISEC(2*I) = 4.D0/3.D0
        POISEC(2*I+1) = 2.D0/3.D0
   20 CONTINUE
      POISEC(2*NBSEC) = 4.D0/3.D0
      POISEC(2*NBSEC+1) = 1.D0/3.D0

      CARAC = '&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      FF = '&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      NNO = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
C      NPG2 = ZI(ICARAC+3)
      M = ZI(ICARAC+6)
      NPG = NPG1
      IXF = IFF
      IPOIDS = IXF + NPG
      IVF = IPOIDS + NPG
      CHMAT = '&INEL.'//ELREFL//'M1'
      CALL JEVETE(CHMAT,'L',JMAT)
      DO 30 I = 1,NPG
        XPG(I) = ZR(IXF-1+I)
   30 CONTINUE


      CALL JEVECH('PCAORIE','L',LORIEN)
      CALL CARCOU(ZR(LORIEN),L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,NNO,
     &            OMEGA,ICOUD2)
      IF (ICOUD2.GE.10) THEN
        ICOUDE = ICOUD2 - 10
        MMT = 0
      ELSE
        ICOUDE = ICOUD2
        MMT = 1
      END IF
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCAGEPO','L',ICAGEP)
      H = ZR(ICAGEP+1)
      A = ZR(ICAGEP) - H/2.D0
      IF (NNO.EQ.3) THEN
        TK(1) = 0.D0
        TK(2) = THETA
        TK(3) = THETA/2.D0
      ELSE IF (NNO.EQ.4) THEN
        TK(1) = 0.D0
        TK(2) = THETA
        TK(3) = THETA/3.D0
        TK(4) = 2.D0*THETA/3.D0
      END IF


      IF (OPTION(1:9).EQ.'FORC_NODA') THEN
        CALL JEVECH('PCONTMR','L',JIN)
        CALL JEVECH('PVECTUR','E',JOUT)

        DO 40 I = 1,NBRDDL
          F(I) = 0.D0
   40   CONTINUE
        KPGS = 0
        DO 100 IGAU = 1,NPG
          DO 90 ICOU = 1,2*NBCOU + 1
            IF (MMT.EQ.0) THEN
              R = A
            ELSE
              R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
            END IF
            DO 80 ISECT = 1,2*NBSEC + 1
              KPGS = KPGS + 1
              INDICE = JIN - 1 + 6* (KPGS-1)
              SIG(1) = ZR(INDICE+1)
              SIG(2) = ZR(INDICE+2)
              SIG(3) = ZR(INDICE+4)
              SIG(4) = ZR(INDICE+5)
              IF (ICOUDE.EQ.0) THEN
                CALL BCOUDE(IGAU,ICOU,ISECT,L,H,A,M,OMEGA,NPG,NNO,NBCOU,
     &                      NBSEC,ZR(IVF),MMT,B)
              ELSE IF (ICOUDE.EQ.1) THEN
                FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
                COSFI = COS(FI)
                SINFI = SIN(FI)
                L = THETA* (RAYON+R*SINFI)
                CALL BCOUDC(IGAU,ICOU,ISECT,L,H,A,M,OMEGA,NPG,XPG,NNO,
     &                      NBCOU,NBSEC,ZR(IVF),RAYON,THETA,MMT,B)
              END IF
              DO 60 I = 1,4
                DO 50 J = 1,NBRDDL
                  MAT(J,I) = B(I,J)
   50           CONTINUE
   60         CONTINUE

              IRET = 0
              CALL PRODMV(0,MAT,NBRDDL,NBRDDL,4,SIG,4,VOUT,NBRDDL,IRET)

C  STOCKAGE DU VECTEUR VOUT DANS FI

              POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
              DO 70 I = 1,NBRDDL
                F(I) = F(I) + VOUT(I)*POIDS
   70         CONTINUE
   80       CONTINUE
   90     CONTINUE
  100   CONTINUE

C PASSAGE DU REPERE LOCAL AU REPERE GLOBAL

        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,F,'LG',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,F,'LG',PASS,VTEMP)
        END IF
        DO 110,I = 1,NBRDDL
          ZR(JOUT-1+I) = F(I)
  110   CONTINUE

      ELSE IF (OPTION(1:14).EQ.'EFGE_ELNO_DEPL') THEN

        CALL JEVECH('PMATERC','L',IMATE)
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NOMRES(3) = 'ALPHA'

        CALL TECAC2 ('ONN','PTEMPER',8,ITAB,IRET)
        ITEMP=ITAB(1)
        IF (ITEMP.EQ.0) THEN
          NBPAR = 0
          NOMPAR = ' '
          VALPAR = 0.D0
        ELSE
          CALL DXTPIF(ZR(ITEMP),ZL(ITAB(8)))
          NBPAR = 1
          NOMPAR = 'TEMP'
          VALPAR = ZR(ITEMP)
        END IF

        CALL RCVALA(ZI(IMATE),'ELAS',NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,CODRET,'FM')
        CALL RCVALA(ZI(IMATE),'ELAS',NBPAR,NOMPAR,VALPAR,1,NOMRES(3),
     &              VALRES(3),CODRET(3),'  ')
        E = VALRES(1)
        NU = VALRES(2)
        IF (CODRET(3).EQ.'OK') THEN
          ALPHA = VALRES(3)
        ELSE
          ALPHA = 0.D0
        END IF

C DEFINITION DE LA MATRICE DE COMPORTEMENT C

        BETA = E/ (1.D0-NU**2)
        G = E/ (2.D0* (1.D0+NU))
        CISAIL = 1.D0

        C(1,1) = BETA
        C(1,2) = NU*BETA
        C(1,3) = 0.D0
        C(1,4) = 0.D0

        C(2,1) = NU*BETA
        C(2,2) = BETA
        C(2,3) = 0.D0
        C(2,4) = 0.D0

        C(3,1) = 0.D0
        C(3,2) = 0.D0
        C(3,3) = G
        C(3,4) = 0.D0

        C(4,1) = 0.D0
        C(4,2) = 0.D0
        C(4,3) = 0.D0
        C(4,4) = G*CISAIL

C          -- RECUPERATION DE LA TEMPERATURE :
C          -- SI LA TEMPERATURE EST CONNUE AUX NOEUDS :
        CALL TECAC2 ('ONN','PTEMPER',8,ITAB,IRET)
        ITEMP=ITAB(1)
        IF (ITEMP.GT.0) THEN
          DO 120 I = 1,NNO
            CALL DXTPIF(ZR(ITEMP+3*(I-1)),ZL(ITAB(8)+3*(I-1)))
            TMOY(I) = ZR(ITEMP+3* (I-1))
            TINF(I) = ZR(ITEMP+3* (I-1)+1)
            TSUP(I) = ZR(ITEMP+3* (I-1)+2)
  120     CONTINUE
        END IF
C          -- SI LA TEMPERATURE EST UNE FONCTION DE 'INST' ET 'EPAIS'
        CALL TECACH(.FALSE.,.FALSE.,'PTEMPEF',1,ITEMP)
        IF (ITEMP.GT.0) THEN
          NOMPU(1) = 'INST'
          NOMPU(2) = 'EPAIS'
          CALL JEVECH('PTEMPSR','L',IBID)
          VALPU(1) = ZR(IBID)
          VALPU(2) = 0.D0
          CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,TMOY1,IER)
          VALPU(2) = -H/2.D0
          CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,TINF1,IER)
          VALPU(2) = +H/2.D0
          CALL FOINTE('FM',ZK8(ITEMP),2,NOMPU,VALPU,TSUP1,IER)
          DO 130,I = 1,NNO
            TMOY(I) = TMOY1
            TINF(I) = TINF1
            TSUP(I) = TSUP1
  130     CONTINUE
        END IF

C  PASSAGE DE LA TEMPERATURE DES NOEUDS AUX POINTS DE GAUSS

        DO 150,IGAU = 1,NPG
          TEMPGI(IGAU) = 0.D0
          TEMPGM(IGAU) = 0.D0
          TEMPGS(IGAU) = 0.D0
          DO 140,K = 1,NNO
            HHK = ZR(IVF-1+NNO* (IGAU-1)+K)
            TEMPGI(IGAU) = HHK*TINF(K) + TEMPGI(IGAU)
            TEMPGM(IGAU) = HHK*TMOY(K) + TEMPGM(IGAU)
            TEMPGS(IGAU) = HHK*TSUP(K) + TEMPGS(IGAU)
  140     CONTINUE
  150   CONTINUE

        CALL JEVECH('PTEREF','L',JTREF)
        TREF = ZR(JTREF)

C  CONTRUCTION DE LA MATRICE H(I,J) = MATRICE DES VALEURS DES
C  FONCTIONS DE FORMES AUX POINT DE GAUSS

        DO 170,K = 1,NNO
          DO 160,IGAU = 1,NPG
            HK(K,IGAU) = ZR(IVF-1+NNO* (IGAU-1)+K)
  160     CONTINUE

  170   CONTINUE

        CALL JEVECH('PDEPLAR','L',JIN)
        DO 180 I = 1,NBRDDL
          VIN(I) = ZR(JIN-1+I)
  180   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,VIN,'GL',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,VIN,'GL',PASS,
     &                VTEMP)
        END IF
        CALL JEVECH('PEFFORR','E',JOUT)

        DO 230 IGAU = 1,NPG

          COE1 = (TEMPGI(IGAU)+TEMPGS(IGAU)+TEMPGM(IGAU))/3.D0 - TREF
          SIGTH(1) = (C(1,1)+C(1,2))*COE1*ALPHA
          SIGTH(2) = (C(2,1)+C(2,2))*COE1*ALPHA
          DO 190,I = 1,6
            EFG(I) = 0.D0
  190     CONTINUE

          DO 210 ICOU = 1,2*NBCOU + 1
            IF (MMT.EQ.0) THEN
              R = A
            ELSE
              R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
            END IF

            DO 200 ISECT = 1,2*NBSEC + 1
              FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
              IF (ICOUDE.EQ.0) THEN
                COSFI = COS(FI)
                SINFI = SIN(FI)
                CALL BCOUDE(IGAU,ICOU,ISECT,L,H,A,M,OMEGA,NPG,NNO,NBCOU,
     &                      NBSEC,ZR(IVF),MMT,B)
              ELSE IF (ICOUDE.EQ.1) THEN
C               FI = FI - OMEGA
                COSFI = COS(FI)
                SINFI = SIN(FI)
                L = THETA* (RAYON+R*SINFI)
                CALL BCOUDC(IGAU,ICOU,ISECT,L,H,A,M,OMEGA,NPG,XPG,NNO,
     &                      NBCOU,NBSEC,ZR(IVF),RAYON,THETA,MMT,B)
              END IF
              CALL PROMAT(C,4,4,4,B,4,4,NBRDDL,MAT)
              IRET = 0
              CALL PRODMV(0,MAT,4,4,NBRDDL,VIN,NBRDDL,SIG,4,IRET)
              POIDS = POICOU(ICOU)*POISEC(ISECT)*H*DEUXPI/
     &                (4.D0*NBCOU*NBSEC)*R
              EFG(1) = EFG(1) + POIDS* (SIG(1)-SIGTH(1))
              EFG(2) = EFG(2) - POIDS* (SINFI*SIG(4)+COSFI*SIG(3))
              EFG(3) = EFG(3) + POIDS* (SINFI*SIG(3)-COSFI*SIG(4))
              EFG(4) = EFG(4) - POIDS*SIG(3)*R
              EFG(5) = EFG(5) - POIDS* (SIG(1)-SIGTH(1))*R*COSFI
              EFG(6) = EFG(6) + POIDS* (SIG(1)-SIGTH(1))*R*SINFI

  200       CONTINUE
  210     CONTINUE
          DO 220,I = 1,6
            FPG(IGAU,I) = EFG(I)
  220     CONTINUE
  230   CONTINUE

        IF ((NNO.EQ.3) .AND. (NPG.EQ.3)) THEN
C      POUR NE PAS SUPPRIMER LA SAVANTE PROGRAMMATION DE PATRICK

          DO 250 IGAU = 1,NPG
            DO 240 INO = 1,NNO
              IF (ICOUDE.EQ.0) THEN
                CO(IGAU,INO) = 1.D0
                SI(IGAU,INO) = 0.D0
              ELSE
                CO(IGAU,INO) = COS((1.D0+XPG(IGAU))*THETA/2.D0-TK(INO))
                SI(IGAU,INO) = SIN((1.D0+XPG(IGAU))*THETA/2.D0-TK(INO))
              END IF
  240       CONTINUE
  250     CONTINUE
          DO 290,INO = 1,NNO
            IF (INO.EQ.1) THEN
              IH = 2
              IP = 1
              I1 = 1
              I2 = 3
            ELSE IF (INO.EQ.2) THEN
              IH = 1
              IP = 2
              I1 = 3
              I2 = 1
            ELSE
              DO 260,I = 1,6
                FNO(I) = FPG(2,I)
  260         CONTINUE
              GO TO 270
            END IF
            CP(1,1) = CO(1,IH)*CO(1,3) + SI(1,IH)*SI(1,3)
            CP(1,2) = -CO(1,IH)*SI(1,3) + SI(1,IH)*CO(1,3)
            CP(2,1) = -CP(1,2)
            CP(2,2) = CP(1,1)
            CV(1,1) = CO(3,IH)*CO(3,3) + SI(3,IH)*SI(3,3)
            CV(1,2) = -CO(3,IH)*SI(3,3) + SI(3,IH)*CO(3,3)
            CV(2,1) = -CP(1,2)
            CV(2,2) = CP(1,1)

            ALPHAF = HK(IH,3)* (CO(1,IH)*FPG(1,1)+SI(1,IH)*FPG(1,2)) -
     &               HK(IH,3)*HK(3,1)* (CP(1,1)*FPG(2,1)+
     &               CP(1,2)*FPG(2,2)) - HK(IH,1)*
     &               (CO(3,IH)*FPG(3,1)+SI(3,IH)*FPG(3,2)) +
     &               HK(IH,1)*HK(3,3)* (CV(1,1)*FPG(2,1)+
     &               CV(1,2)*FPG(2,2))

            BETAF = HK(IH,3)* (-SI(1,IH)*FPG(1,1)+CO(1,IH)*FPG(1,2)) -
     &              HK(IH,3)*HK(3,1)* (CP(2,1)*FPG(2,1)+
     &              CP(2,2)*FPG(2,2)) - HK(IH,1)*
     &              (-SI(3,IH)*FPG(3,1)+CO(3,IH)*FPG(3,2)) +
     &              HK(IH,1)*HK(3,3)* (CV(2,1)*FPG(2,1)+
     &              CV(2,2)*FPG(2,2))

            ALPHAM = HK(IH,3)* (CO(1,IH)*FPG(1,4)+SI(1,IH)*FPG(1,5)) -
     &               HK(IH,3)*HK(3,1)* (CP(1,1)*FPG(2,4)+
     &               CP(1,2)*FPG(2,5)) - HK(IH,1)*
     &               (CO(3,IH)*FPG(3,4)+SI(3,IH)*FPG(3,5)) +
     &               HK(IH,1)*HK(3,3)* (CV(1,1)*FPG(2,4)+
     &               CV(1,2)*FPG(2,5))

            BETAM = HK(IH,3)* (-SI(1,IH)*FPG(1,4)+CO(1,IH)*FPG(1,5)) -
     &              HK(IH,3)*HK(3,1)* (CP(2,1)*FPG(2,4)+
     &              CP(2,2)*FPG(2,5)) - HK(IH,1)*
     &              (-SI(3,IH)*FPG(3,4)+CO(3,IH)*FPG(3,5)) +
     &              HK(IH,1)*HK(3,3)* (CV(2,1)*FPG(2,4)+
     &              CV(2,2)*FPG(2,5))

            CP(1,1) = CO(1,IH)*CO(1,IP) + SI(1,IH)*SI(1,IP)
            CP(1,2) = -CO(1,IH)*SI(1,IP) + SI(1,IH)*CO(1,IP)
            CP(2,1) = -CP(1,2)
            CP(2,2) = CP(1,1)
            CV(1,1) = CO(3,IH)*CO(3,IP) + SI(3,IH)*SI(3,IP)
            CV(1,2) = -CO(3,IH)*SI(3,IP) + SI(3,IH)*CO(3,IP)
            CV(2,1) = -CP(1,2)
            CV(2,2) = CP(1,1)
            XA = HK(IP,1)*HK(IH,3)*CP(1,1) - HK(IP,3)*HK(IH,1)*CV(1,1)
            XB = HK(IP,1)*HK(IH,3)*CP(1,2) - HK(IP,3)*HK(IH,1)*CV(1,2)
            XC = HK(IP,1)*HK(IH,3)*CP(2,1) - HK(IP,3)*HK(IH,1)*CV(2,1)
            XD = HK(IP,1)*HK(IH,3)*CP(2,2) - HK(IP,3)*HK(IH,1)*CV(2,2)

            FNO(1) = (XD*ALPHAF-XB*BETAF)/ (XA*XD-XB*XC)
            FNO(2) = (-XC*ALPHAF+XA*BETAF)/ (XA*XD-XB*XC)
            FNO(3) = (HK(IH,I2)*FPG(I1,3)-HK(IH,I1)*FPG(I2,3)-
     &               FPG(2,3)* (HK(3,I1)*HK(IH,I2)-HK(3,I2)*HK(IH,I1)))/
     &                (HK(1,1)*HK(2,3)-HK(1,3)*HK(2,1))
            FNO(4) = (XD*ALPHAM-XB*BETAM)/ (XA*XD-XB*XC)
            FNO(5) = (-XC*ALPHAM+XA*BETAM)/ (XA*XD-XB*XC)
            FNO(6) = (HK(IH,I2)*FPG(I1,6)-HK(IH,I1)*FPG(I2,6)-
     &               FPG(2,6)* (HK(3,I1)*HK(IH,I2)-HK(3,I2)*HK(IH,I1)))/
     &                (HK(1,1)*HK(2,3)-HK(1,3)*HK(2,1))

  270       CONTINUE
            DO 280,I = 1,6
              ZR(JOUT-1+6* (INO-1)+I) = FNO(I)
  280       CONTINUE
  290     CONTINUE

        ELSE
          DO 320 IC = 1,6
            DO 300 KP = 1,NPG
              VPG(KP) = FPG(KP,IC)
  300       CONTINUE
            NNOS = 2
            NLIG = NINT(ZR(JMAT))
            NCOL = NINT(ZR(JMAT+1))
            CALL TUGANO(ZR(JMAT+2),NLIG,NCOL,NNOS,NNO,NPG,VPG,VNO)
            DO 310 I = 1,NNO
              ZR(JOUT+6* (I-1)+IC-1) = VNO(I)
  310       CONTINUE
  320     CONTINUE
        END IF
      ELSE
        CALL UTMESS('F','TE0585','L''OPTION "'//OPTION//
     &              '" EST NON PREVUE')
      END IF
  330 CONTINUE
      END
