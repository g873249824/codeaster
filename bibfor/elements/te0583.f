      SUBROUTINE TE0583(OPTION,NOMTE)
      IMPLICIT NONE
C MODIF ELEMENTS  DATE 03/07/2002   AUTEUR CIBHHPD D.NUNEZ 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================
      CHARACTER*16 OPTION,NOMTE
C ......................................................................

C    - FONCTION REALISEE:  CALCUL DU SECOND MEMBRE : TRAVAIL DE LA
C                          PRESSION ET FORCES LINEIQUES TUYAUX
C                          OPTIONS :'CHAR_MECA_PESA_R'
C                          OPTIONS :'CHAR_MECA_FR1D1D'
C                          OPTIONS :'CHAR_MECA_PRES_R'
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      INTEGER NBRDDM
      PARAMETER (NBRDDM=156)
      REAL*8 H,A,L,PRESNO(4),PRESPG(4),RINT
      REAL*8 VPESAN(6),FPESAN(6),PESAN,F(NBRDDM)
      REAL*8 PI,DEUXPI,FI,PASS(NBRDDM,NBRDDM)
      REAL*8 FPESA1(6),FPESA2(6),FPESA3(6),VTEMP(NBRDDM)
      REAL*8 VPESA1(6),VPESA2(6),VPESA3(6),VPESA4(6)
      REAL*8 PGL(3,3),PGL1(3,3),PGL2(3,3),PGL3(3,3),OMEGA
      REAL*8 HK,POIDS,R8PI,RAYON,THETA,TK(4),CK,SK
      REAL*8 COSFI,SINFI,TE,PGL4(3,3),FPESA4(6),XPG(4)
      REAL*8 R8B,REXT,SEC,RHO,XXX,R,TIME,VALPAR(4)
      CHARACTER*2 CODRES
      CHARACTER*8 NOMPAR(4)
      CHARACTER*8  ELREFE
      CHARACTER*16 PHENOM,CH16
      CHARACTER*24 CARAC,FF
      INTEGER NNO,NPG,NBCOU,NBSEC,M,ICARAC,LORIEN,ICOUDE
      INTEGER IPOIDS,IVF,I,ICOU,IBLOC,INO,NBPAR
      INTEGER ICAGEP,IGEOM,LMATER,JPESA,JOUT,LFORC
      INTEGER IGAU,ISECT,IPRES,IFF,K,IVECT,NBRDDL,INDIC0
      INTEGER INDIC1,INDIC2,INDIC3,INDIC4,INDIC5,J
      INTEGER NPG1,NPG2,IXF,JNBSPI,NBSECM,NBCOUM,ITEMPS,IER
      PARAMETER (NBSECM=32,NBCOUM=10)
      REAL*8 POICOU(2*NBCOUM+1),POISEC(2*NBSECM+1)
      LOGICAL NORMAL,GLOBAL
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
      CALL ELREF1(ELREFE)
      PI = R8PI()
      DEUXPI = 2.D0*PI
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
      NPG2 = ZI(ICARAC+3)
      M = ZI(ICARAC+6)
C     ON INTEGRE INEXACTEMENT LES TERMES DE PRESSION
C         NPG = NPG1
C         IXF= IFF
      NPG = NPG2
      IXF = IFF + 2*NPG1 + 3*NPG1*NNO

      DO 30 I = 1,NPG
        XPG(I) = ZR(IXF-1+I)
   30 CONTINUE

      IPOIDS = IXF + NPG
      IVF = IPOIDS + NPG
      NBRDDL = NNO* (6+3+6* (M-1))
      IF (NBRDDL.GT.NBRDDM) THEN
        CALL UTMESS('F','TUYAU','LE NOMBRE DE DDL EST TROP GRAND')
      END IF
      IF (NOMTE.EQ.'MET3SEG3') THEN
        IF (NBRDDL.NE.63) THEN
          CALL UTMESS('F','MET3SEG3','LE NOMBRE DE DDL EST FAUX')
        END IF
      ELSE IF (NOMTE.EQ.'MET6SEG3') THEN
        IF (NBRDDL.NE.117) THEN
          CALL UTMESS('F','MET6SEG3','LE NOMBRE DE DDL EST FAUX')
        END IF
      ELSE IF (NOMTE.EQ.'MET3SEG4') THEN
        IF (NBRDDL.NE.84) THEN
          CALL UTMESS('F','MET3SEG4','LE NOMBRE DE DDL EST FAUX')
        END IF
      ELSE
        CALL UTMESS('F','TUYAU','NOM DE TYPE ELEMENT INATTENDU')
      END IF

      CALL JEVECH('PCAORIE','L',LORIEN)
      CALL CARCOU(ZR(LORIEN),L,PGL,RAYON,THETA,PGL1,PGL2,PGL3,PGL4,NNO,
     &            OMEGA,ICOUDE)
      IF (ICOUDE.GE.10) THEN
        ICOUDE = ICOUDE - 10
      END IF

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCAGEPO','L',ICAGEP)

      H = ZR(ICAGEP+1)
      A = ZR(ICAGEP) - H/2.D0
      RINT = A - H/2.D0
      REXT = A + H/2.D0
      SEC = PI* (REXT**2-RINT**2)
C      RINT  = A
C A= RMOY, H = EPAISSEUR
C RINT = RAYON INTERIEUR
C CALCUL DE L = LONGUEUR DU COUDE
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
C  CALCUL DU TRAVAIL DE LA PRESSION
C  LA PRESSION NE TRAVAILLE QUE SUR LE TERME WO
      IF (OPTION.EQ.'CHAR_MECA_PRES_R') THEN
        CALL JEVECH('PPRESSR','L',IPRES)
        DO 40 I = 1,NNO
          PRESNO(I) = ZR(IPRES-1+I)
   40   CONTINUE
C  PASSAGE DE LA PRESSION DES NOEUDS AUX POINT DE GAUSS
        DO 60,IGAU = 1,NPG
          PRESPG(IGAU) = 0.D0
          DO 50,K = 1,NNO
            HK = ZR(IVF-1+NNO* (IGAU-1)+K)
            PRESPG(IGAU) = HK*PRESNO(K) + PRESPG(IGAU)
   50     CONTINUE
   60   CONTINUE
        CALL JEVECH('PVECTUR','E',IVECT)
        DO 90 K = 1,NNO
C           TRAVAIL SUR UX
          INDIC0 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 1
C           TRAVAIL SUR UY
          INDIC1 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 2
C           TRAVAIL SUR UZ
          INDIC2 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 3
C           TRAVAIL SUR W0
          INDIC3 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 1 + 6 + 6* (M-1)
C           TRAVAIL SUR WI1
          INDIC4 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 2 + 6 + 6* (M-1)
C           TRAVAIL SUR W01
          INDIC5 = IVECT - 1 + (6+6* (M-1)+3)* (K-1) + 3 + 6 + 6* (M-1)
          DO 80 IGAU = 1,NPG
C BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR
            HK = ZR(IVF-1+NNO* (IGAU-1)+K)
            IF (ICOUDE.EQ.1) THEN
              CK = COS((1.D0+XPG(IGAU))*THETA/2.D0-TK(K))
              SK = SIN((1.D0+XPG(IGAU))*THETA/2.D0-TK(K))
            ELSE
              CK = 1.D0
              SK = 0.D0
            END IF
C BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE
            DO 70 ISECT = 1,2*NBSEC + 1
              IF (ICOUDE.EQ.0) THEN
                POIDS = ZR(IPOIDS-1+IGAU)*POISEC(ISECT)* (L/2.D0)*
     &                  DEUXPI/ (2.D0*NBSEC)*RINT
                ZR(INDIC3) = ZR(INDIC3) + HK*POIDS*PRESPG(IGAU)
              ELSE
                FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
                COSFI = COS(FI)
                SINFI = SIN(FI)
                TE = FI - OMEGA
                L = THETA* (RAYON+RINT*SINFI)
                POIDS = ZR(IPOIDS-1+IGAU)*POISEC(ISECT)* (L/2.D0)*
     &                  DEUXPI/ (2.D0*NBSEC)*RINT
                ZR(INDIC0) = ZR(INDIC0) + HK*POIDS*PRESPG(IGAU)*SINFI*SK
                ZR(INDIC1) = ZR(INDIC1) - HK*POIDS*PRESPG(IGAU)*SINFI*CK
                ZR(INDIC2) = ZR(INDIC2) - HK*POIDS*PRESPG(IGAU)*COSFI
                ZR(INDIC3) = ZR(INDIC3) + HK*POIDS*PRESPG(IGAU)
                ZR(INDIC4) = ZR(INDIC4) + HK*POIDS*PRESPG(IGAU)*COS(TE)
                ZR(INDIC5) = ZR(INDIC5) + HK*POIDS*PRESPG(IGAU)*SIN(TE)
              END IF
   70       CONTINUE
   80     CONTINUE
   90   CONTINUE
        IF (ICOUDE.NE.0) THEN
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,ZR(IVECT),'LG',
     &                PASS,VTEMP)
        END IF
C CAS PESANTEUR ET FORCE LINEIQUE
      ELSE IF ((OPTION.EQ.'CHAR_MECA_PESA_R') .OR.
     &         (OPTION.EQ.'CHAR_MECA_FR1D1D')) THEN

        IF (OPTION.EQ.'CHAR_MECA_PESA_R') THEN
          CALL JEVECH('PMATERC','L',LMATER)
          CALL RCCOMA(ZI(LMATER),'ELAS',PHENOM,CODRES)
          IF (PHENOM.EQ.'ELAS' .OR. PHENOM.EQ.'ELAS_FO' .OR.
     &        PHENOM.EQ.'ELAS_ISTR' .OR. PHENOM.EQ.'ELAS_ISTR_FO' .OR.
     &        PHENOM.EQ.'ELAS_ORTH' .OR. PHENOM.EQ.'ELAS_ORTH_FO') THEN
            CALL RCVALA(ZI(LMATER),PHENOM,0,' ',R8B,1,'RHO',RHO,CODRES,
     &                  'FM')
          ELSE
            CALL UTMESS('F','TE0583','COMP. ELASTIQUE INEXISTANT')
          END IF
          CALL JEVECH('PPESANR','L',JPESA)
          PESAN = ZR(JPESA)
          DO 100 I = 1,3
            VPESAN(I) = RHO*PESAN*ZR(JPESA+I)
  100     CONTINUE
          DO 110 I = 4,6
            VPESAN(I) = 0.D0
  110     CONTINUE
        ELSE
          CALL JEVECH('PFR1D1D','L',LFORC)
          XXX = ABS(ZR(LFORC+6))
          NORMAL = XXX .GT. 1.001D0
          IF (NORMAL) THEN
            CH16 = OPTION
            CALL UTMESS('F','PFR1D1D','L''OPTION "'//CH16//
     &                  '" EST INCONNUE')
          END IF
          DO 120 I = 1,3
            VPESAN(I) = ZR(LFORC-1+I)/SEC
            XXX = ABS(ZR(LFORC-1+3+I))
            IF (XXX.GT.1.D-20) CALL UTMESS('F','ELEMENTS DE TUYAU',
     &                              'ON NE TRAITE PAS LES MOMENTS')
  120     CONTINUE
          DO 130 I = 4,6
            VPESAN(I) = 0.D0
  130     CONTINUE
        END IF
        DO 140 I = 1,NBRDDL
          F(I) = 0.D0
  140   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL UTPVGL(1,6,PGL,VPESAN(1),FPESAN(1))
        ELSE
          CALL UTPVGL(1,6,PGL1,VPESAN(1),FPESA1(1))
          CALL UTPVGL(1,6,PGL2,VPESAN(1),FPESA2(1))
          CALL UTPVGL(1,6,PGL3,VPESAN(1),FPESA3(1))
          IF (NNO.EQ.4) THEN
            CALL UTPVGL(1,6,PGL4,VPESAN(1),FPESA4(1))
          END IF
        END IF
C BOUCLE SUR LES POINTS DE GAUSS DANS LA LONGUEUR
        DO 190 IGAU = 1,NPG
C BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR
          DO 180 ICOU = 1,2*NBCOU + 1
            R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
C BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE
            DO 170 ISECT = 1,2*NBSEC + 1
              IF (ICOUDE.EQ.0) THEN
                POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                  (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
                DO 150 K = 1,NNO
                  HK = ZR(IVF-1+NNO* (IGAU-1)+K)
                  IBLOC = (9+6* (M-1))* (K-1)
                  F(IBLOC+1) = F(IBLOC+1) + POIDS*HK*FPESAN(1)
                  F(IBLOC+2) = F(IBLOC+2) + POIDS*HK*FPESAN(2)
                  F(IBLOC+3) = F(IBLOC+3) + POIDS*HK*FPESAN(3)
  150           CONTINUE
              ELSE IF (ICOUDE.EQ.1) THEN
                FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
                COSFI = COS(FI)
                SINFI = SIN(FI)
                L = THETA* (RAYON+R*SINFI)
                POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                  (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
                DO 160 K = 1,3
                  HK = ZR(IVF-1+NNO* (IGAU-1)+1)
                  IBLOC = (9+6* (M-1))* (1-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA1(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+2)
                  IBLOC = (9+6* (M-1))* (2-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA2(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+3)
                  IBLOC = (9+6* (M-1))* (3-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA3(K)

                  IF (NNO.EQ.4) THEN
                    IBLOC = (9+6* (M-1))* (4-1)
                    F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA4(K)
                  END IF
  160           CONTINUE
              END IF
  170       CONTINUE
  180     CONTINUE
  190   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,F,'LG',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,F,'LG',PASS,VTEMP)
        END IF
        CALL JEVECH('PVECTUR','E',JOUT)
        DO 200,I = 1,NBRDDL
          ZR(JOUT-1+I) = F(I)
  200   CONTINUE
C CAS FORCE LINEIQUE FONCTION
      ELSE IF ((OPTION.EQ.'CHAR_MECA_FF1D1D')) THEN
        CALL JEVECH('PFF1D1D','L',LFORC)
        NORMAL = ZK8(LFORC+6) .EQ. 'VENT'
        GLOBAL = ZK8(LFORC+6) .EQ. 'GLOBAL'
        IF (NORMAL) THEN
          CALL UTMESS('F','TE0583','L''OPTION "'//OPTION//
     &                '" EST INTERDITE POUR LES TUYAUX')
        END IF
        IF (.NOT.GLOBAL) THEN
          CALL UTMESS('F','TE0583','L''OPTION "'//OPTION//
     &                '" EN REPERE LOCAL EST INTERDITE POUR LES TUYAUX'
     &                //' UTILISER LE REPERE GLOBAL')
        END IF
        NOMPAR(4) = 'INST'
        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'Z'
        CALL TECACH(.FALSE.,.FALSE.,'PTEMPSR',1,ITEMPS)
        IF (ITEMPS.NE.0) THEN
          TIME = ZR(ITEMPS)
          VALPAR(4) = TIME
          NBPAR = 4
        ELSE
          NBPAR = 3
        END IF
C        NOEUDS 1 A 3
        INO = 1
        DO 210 I = 1,3
          VALPAR(I) = ZR(IGEOM-1+3* (INO-1)+I)
  210   CONTINUE
        DO 220 I = 1,3
          CALL FOINTE('FM',ZK8(LFORC+I-1),NBPAR,NOMPAR,VALPAR,VPESA1(I),
     &                IER)
          VPESA1(I) = VPESA1(I)/SEC
  220   CONTINUE
        INO = 2
        DO 230 I = 1,3
          VALPAR(I) = ZR(IGEOM-1+3* (INO-1)+I)
  230   CONTINUE
        DO 240 I = 1,3
          CALL FOINTE('FM',ZK8(LFORC+I-1),NBPAR,NOMPAR,VALPAR,VPESA2(I),
     &                IER)
          VPESA2(I) = VPESA2(I)/SEC
  240   CONTINUE
        INO = 3
        DO 250 I = 1,3
          VALPAR(I) = ZR(IGEOM-1+3* (INO-1)+I)
  250   CONTINUE
        DO 260 I = 1,3
          CALL FOINTE('FM',ZK8(LFORC+I-1),NBPAR,NOMPAR,VALPAR,VPESA3(I),
     &                IER)
          VPESA3(I) = VPESA3(I)/SEC
  260   CONTINUE
        IF (NNO.EQ.4) THEN
          INO = 4
          DO 270 I = 1,3
            VALPAR(I) = ZR(IGEOM-1+3* (INO-1)+I)
  270     CONTINUE
          DO 280 I = 1,3
            CALL FOINTE('FM',ZK8(LFORC+I-1),NBPAR,NOMPAR,VALPAR,
     &                  VPESA4(I),IER)
            VPESA4(I) = VPESA4(I)/SEC
  280     CONTINUE
        END IF
        DO 290 I = 4,6
          VPESA1(I) = 0.D0
          VPESA2(I) = 0.D0
          VPESA3(I) = 0.D0
          VPESA4(I) = 0.D0
  290   CONTINUE
        DO 300 I = 1,NBRDDL
          F(I) = 0.D0
  300   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL UTPVGL(1,6,PGL,VPESA1(1),FPESA1(1))
          CALL UTPVGL(1,6,PGL,VPESA2(1),FPESA2(1))
          CALL UTPVGL(1,6,PGL,VPESA3(1),FPESA3(1))
          IF (NNO.EQ.4) THEN
            CALL UTPVGL(1,6,PGL,VPESA4(1),FPESA4(1))
          END IF
        ELSE
          CALL UTPVGL(1,6,PGL1,VPESAN(1),FPESA1(1))
          CALL UTPVGL(1,6,PGL2,VPESAN(1),FPESA2(1))
          CALL UTPVGL(1,6,PGL3,VPESAN(1),FPESA3(1))
          IF (NNO.EQ.4) THEN
            CALL UTPVGL(1,6,PGL4,VPESAN(1),FPESA4(1))
          END IF
        END IF
C BOUCLE SUR LES POINTS DE GAUSS DANS LA LONGUEUR
        DO 350 IGAU = 1,NPG
C BOUCLE SUR LES POINTS DE SIMPSON DANS L'EPAISSEUR
          DO 340 ICOU = 1,2*NBCOU + 1
            R = A + (ICOU-1)*H/ (2.D0*NBCOU) - H/2.D0
C BOUCLE SUR LES POINTS DE SIMPSON SUR LA CIRCONFERENCE
            DO 330 ISECT = 1,2*NBSEC + 1
              IF (ICOUDE.EQ.0) THEN
                POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                  (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
                DO 310 K = 1,3
                  HK = ZR(IVF-1+NNO* (IGAU-1)+1)
                  IBLOC = (9+6* (M-1))* (1-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA1(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+2)
                  IBLOC = (9+6* (M-1))* (2-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA2(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+3)
                  IBLOC = (9+6* (M-1))* (3-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA3(K)

                  IF (NNO.EQ.4) THEN
                    IBLOC = (9+6* (M-1))* (4-1)
                    F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA4(K)
                  END IF
  310           CONTINUE
              ELSE IF (ICOUDE.EQ.1) THEN
                FI = (ISECT-1)*DEUXPI/ (2.D0*NBSEC)
                COSFI = COS(FI)
                SINFI = SIN(FI)
                L = THETA* (RAYON+R*SINFI)
                POIDS = ZR(IPOIDS-1+IGAU)*POICOU(ICOU)*POISEC(ISECT)*
     &                  (L/2.D0)*H*DEUXPI/ (4.D0*NBCOU*NBSEC)*R
                DO 320 K = 1,3
                  HK = ZR(IVF-1+NNO* (IGAU-1)+1)
                  IBLOC = (9+6* (M-1))* (1-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA1(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+2)
                  IBLOC = (9+6* (M-1))* (2-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA2(K)
                  HK = ZR(IVF-1+NNO* (IGAU-1)+3)
                  IBLOC = (9+6* (M-1))* (3-1)
                  F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA3(K)

                  IF (NNO.EQ.4) THEN
                    IBLOC = (9+6* (M-1))* (4-1)
                    F(IBLOC+K) = F(IBLOC+K) + POIDS*HK*FPESA4(K)
                  END IF

  320           CONTINUE
              END IF
  330       CONTINUE
  340     CONTINUE
  350   CONTINUE
        IF (ICOUDE.EQ.0) THEN
          CALL VLGGL(NNO,NBRDDL,PGL,F,'LG',PASS,VTEMP)
        ELSE
          CALL VLGGLC(NNO,NBRDDL,PGL1,PGL2,PGL3,PGL4,F,'LG',PASS,VTEMP)
        END IF
        CALL JEVECH('PVECTUR','E',JOUT)
        DO 360,I = 1,NBRDDL
          ZR(JOUT-1+I) = F(I)
  360   CONTINUE
      END IF
      END
