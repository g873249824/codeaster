      SUBROUTINE DSQMAS(XYZL,OPTION,PGL,MAS,ENER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/11/2001   AUTEUR JMBHH01 J.M.PROIX 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 XYZL(3,*),PGL(*)
      CHARACTER*(*) OPTION
      REAL*8 MAS(*),ENER(*)
C     ------------------------------------------------------------------
C     MATRICE MASSE DE L'ELEMENT DE PLAQUE DSQ
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES QUATRE NOEUDS
C     IN  OPTION : OPTION RIGI_MECA OU EPOT_ELEM_DEPL
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
C     OUT MAS    : MATRICE DE RIGIDITE
C     OUT ENER   : TERMES POUR ENER_CIN (ECIN_ELEM_DEPL)
C     ------------------------------------------------------------------
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
      INTEGER INT,II(8),JJ(8),LL(16)
      INTEGER MULTIC, P
      REAL*8 ROE,RHO,EPAIS
      REAL*8 DETJ,WGT
      REAL*8 DF(3,3),DM(3,3),DMF(3,3),DC(2,2),DCI(2,2),DMC(3,2),DFC(3,2)
      REAL*8 HFT2(2,6),HMFT2(2,6)
      REAL*8 BCB(2,12),BCA(2,4),AN(4,12),AM(4,8),BCM(2,8)
      REAL*8 NFX(12), NFY(12), NMX(8), NMY(8), NMI(4)
      REAL*8 FLEX(12,12)
      REAL*8 MEMB(8,8),AMEMB(64)
      REAL*8 MEFL(8,12)
      REAL*8 WSQ(12),WMESQ(8),DEPL(24)
      REAL*8 MASLOC(300),MASGLO(300)
      REAL*8 ZERO, UNQUAR, UNDEMI, UN, NEUF
      CHARACTER*8  TYPELE
      CHARACTER*24 DESR
      LOGICAL ELASCO, EXCE, INER

C     ------------------ PARAMETRAGE QUADRANGLE ------------------------
      INTEGER NPG,NC,NNO
      INTEGER LDETJ,LJACO,LTOR,LQSI,LETA,LWGT,LXYC,LCOTE,LCOS,LSIN,LAIRE
      PARAMETER (NPG=4)
      PARAMETER (NNO=4)
      PARAMETER (NC=4)
      PARAMETER (LDETJ=1)
      PARAMETER (LJACO=2)
      PARAMETER (LTOR=LJACO+4)
      PARAMETER (LQSI=LTOR+1)
      PARAMETER (LETA=LQSI+NPG+NNO+2*NC)
      PARAMETER (LWGT=LETA+NPG+NNO+2*NC)
      PARAMETER (LXYC=LWGT+NPG)
      PARAMETER (LCOTE=LXYC+2*NC)
      PARAMETER (LCOS=LCOTE+NC)
      PARAMETER (LSIN=LCOS+NC)
      PARAMETER (LAIRE=LSIN+NC)
C     ------------------------------------------------------------------
      REAL*8 CTOR
      DATA (II(K),K=1,8)/1,10,19,28,37,46,55,64/
      DATA (JJ(K),K=1,8)/5,14,23,32,33,42,51,60/
      DATA (LL(K),K=1,16)/3,7,12,16,17,21,26,30,35,39,44,48,49,53,58,62/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      ZERO   = 0.0D0
      UNQUAR = 0.25D0
      UNDEMI = 0.5D0
      UN     = 1.0D0
      NEUF   = 9.0D0
      DOUZE = 12.0D0
C
      TYPELE = 'MEDSQU4 '
      EXCENT = ZERO

      CALL DXROEP(RHO,EPAIS)
      ROE = RHO*EPAIS
      ROF = RHO*EPAIS*EPAIS*EPAIS/DOUZE
      DESR = '&INEL.'//TYPELE//'.DESR'
      CALL JEVETE(DESR,' ',LZR)

      CALL JEVECH('PCACOQU','L',JCOQU)
      CTOR   = ZR(JCOQU+3)
      EXCENT = ZR(JCOQU+4)
      XINERT = ZR(JCOQU+5)

      EXCE = .FALSE.
      INER = .FALSE.
      IF (ABS(EXCENT).GT.UN/R8GAEM()) EXCE = .TRUE.
      IF (ABS(XINERT).GT.UN/R8GAEM()) INER = .TRUE.
      IF ( .NOT. INER )  ROF = 0.0D0
C
C --- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE :
C     ---------------------------------------------------
      CALL GQUAD4(XYZL,ZR(LZR))
C
C --- CALCUL DES MATRICES DE RIGIDITE DU MATERIAU EN FLEXION,
C --- MEMBRANE ET CISAILLEMENT INVERSEE :
C     ---------------------------------
      CALL DXMATE(DF,DM,DMF,DC,DCI,DMC,DFC,NNO,PGL,ZR(LZR),MULTIC,
     +            .FALSE.,ELASCO)
C
C --- INITIALISATIONS :
C     ---------------
      DO 10 K = 1,96
        MEFL(K,1) = ZERO
   10 CONTINUE
      DO 20 K = 1,144
        FLEX(K,1) = ZERO
   20 CONTINUE
C
      CALL R8INIR(32,ZERO,AM,1)
C
C --- CAS AVEC EXCENTREMENT
C     ---------------------
C --- CALCUL DES MATRICES AN ET AM QUI SONT TELLES QUE 
C --- ALPHA = AN*UN + AM*UM
C ---  UN DESIGNANT LES DEPLACEMENTS DE FLEXION  UN = (W,BETA_X,BETA_Y)
C ---  UM DESIGNANT LES DEPLACEMENTS DE MEMBRANE UM = (U,V) 
C
C --- CAS SANS EXCENTREMENT
C     ---------------------
C --- ON CALCULE SEULEMENT AN QUI EST TEL QUE ALPHA = AN*UN :
C      ----------------------------------------------------
      IF (EXCE) THEN
        CALL DSQDI2(XYZL,DF,DCI,DMF,DFC,DMC,AN,AM)
      ELSE
        CALL DSQDIS(XYZL,DF,DCI,AN)
      ENDIF
C
C===========================================================
C ---  CALCUL DE LA PARTIE MEMBRANE DE LA MATRICE DE MASSE =
C===========================================================
C
C --- PRISE EN COMPTE DES TERMES DE MEMBRANE CLASSIQUES
C --- EN U*U ET V*V :
C     -------------
      COEFM = ZR(LZR-1+LAIRE)*ROE/NEUF
      DO 30 K = 1,64
        AMEMB(K) = ZERO
   30 CONTINUE
      DO 40 K = 1,8
        AMEMB(II(K)) = UN
        AMEMB(JJ(K)) = UNQUAR
   40 CONTINUE
      DO 50 K = 1,16
        AMEMB(LL(K)) = UNDEMI
   50 CONTINUE
      DO 60 K = 1,64
        MEMB(K,1) = COEFM*AMEMB(K)
   60 CONTINUE
C
C --- BOUCLE SUR LES POINTS D'INTEGRATION :
C     ===================================
      DO 70 INT = 1,NPG
C
C ---   CALCUL DU JACOBIEN SUR LE QUADRANGLE :
C       ------------------------------------ 
        CALL JQUAD4(INT,XYZL,ZR(LZR))
C
C ---   CALCUL DU PRODUIT HF.T2 :
C       -----------------------
        CALL DSXHFT(DF,ZR(LZR),HFT2)
C
C ---   CALCUL DU PRODUIT HMF.T2 :
C       ------------------------
        CALL DXHMFT(DMF,ZR(LZR),HMFT2)
C
C ---   CALCUL DES MATRICES BCB, BCA ET BCM :
C       -----------------------------------
        CALL DSQCIS(INT,ZR(LZR),HMFT2,HFT2,BCM,BCB,BCA)
C
C ---   CALCUL DES FONCTIONS D'INTERPOLATION DE LA FLECHE :
C       -------------------------------------------------
        CALL DSQNIW(INT,ZR(LZR),DCI,BCM,BCB,BCA,AN,AM,WSQ,WMESQ)
C
C ---   CALCUL DES FONCTIONS D'INTERPOLATION DES ROTATIONS :
C       --------------------------------------------------
        CALL DSQNIB(INT,ZR(LZR),AN,AM,NFX,NFY,NMX,NMY)
C
C ---   CALCUL DES FONCTIONS DE FORME DE MEMBRANE :
C       -----------------------------------------
        CALL DXQNIM(INT,ZR(LZR),NMI)
C
C==========================================================
C ---  CALCUL DE LA PARTIE FLEXION DE LA MATRICE DE MASSE =
C==========================================================
C
        DETJ = ZR(LZR-1+LDETJ)
C
C ---   LA MASSE VOLUMIQUE RELATIVE AUX TERMES DE FLEXION W
C ---   EST EGALE A RHO_F = RHO*EPAIS :
C       -----------------------------
        WGT = ZR(LZR-1+LWGT+INT-1)*DETJ*ROE
C
C ---   CALCUL DE LA PARTIE FLEXION DE LA MATRICE DE MASSE
C ---   DUE AUX SEULS TERMES DE LA FLECHE W :
C       -----------------------------------
        DO 80 I = 1,12
          DO 90 J = 1,12
            FLEX(I,J) = FLEX(I,J) + WSQ(I)*WSQ(J)*WGT
   90     CONTINUE
   80   CONTINUE
C
C ---   LA MASSE VOLUMIQUE RELATIVE AUX TERMES DE FLEXION BETA
C ---   EST EGALE A RHO_F = RHO*EPAIS**3/12 + D**2*EPAIS*RHO :
C       ----------------------------------------------------
          WGTF = ZR(LZR-1+LWGT+INT-1)*DETJ*(ROF+EXCENT*EXCENT*ROE)
C
C ---   PRISE EN COMPTE DES TERMES DE FLEXION DUS AUX ROTATIONS :
C       -------------------------------------------------------
          DO 100 I = 1, 12
            DO 110 J = 1, 12
              FLEX(I,J) = FLEX(I,J)+(NFX(I)*NFX(J)+NFY(I)*NFY(J))*WGTF
  110     CONTINUE
  100   CONTINUE
C==============================================================
C ---   CAS D'UN ELEMENT EXCENTRE : IL APPARAIT DE TERMES DE  =
C ---   COUPLAGE MEMBRANE-FLEXION ET DE NOUVEAUX TERMES POUR  =
C ---   PARTIE MEMBRANE DE LA MATRICE DE MASSE :              =
C==============================================================
C
        IF (EXCE) THEN
C
C===================================================================
C ---  CALCUL DE LA PARTIE MEMBRANE-FLEXION DE LA MATRICE DE MASSE =
C===================================================================
C
C ---     POUR LE COUPLAGE MEMBRANE-FLEXION, ON DOIT TENIR COMPTE
C ---     DE 3 MASSES VOLUMIQUES
C ---     RHO_M  = EPAIS*RHO 
C ---     RHO_MF = D*EPAIS*RHO 
C ---     RHO_F  = RHO*EPAIS**3/12 + D**2*EPAIS*RHO
C         -------------------------------------------------
          WGTM  = ZR(LZR-1+LWGT+INT-1)*DETJ*ROE
          WGTMF = ZR(LZR-1+LWGT+INT-1)*DETJ*EXCENT*ROE
          WGTF  = ZR(LZR-1+LWGT+INT-1)*DETJ*(ROF+EXCENT*EXCENT*ROE)
C
C ---     PRISE EN COMPTE DES TERMES DE COUPLAGE MEMBRANE-FLEXION 
C ---     ON A 3 TYPES DE TERMES DONT IL FAUT TENIR COMPTE
C ---     1) LES TERMES U*BETA     -> NMI*NFX ET NMI*NFY (RHO_MF)
C ---     2) LES TERMES W*W        -> WMESQ*WST          (RHO_M)
C ---     3) LES TERMES BETA*BETA  -> NMX*NFX            (RHO_F)
C         ------------------------------------------------------
C
C ---      1) TERMES DE COUPLAGE MEMBRANE-FLEXION U*BETA :
C             ------------------------------------------
          DO 120 K = 1, 4
            I1 = 2*(K-1)+1
            I2 = I1     +1
            DO 130 J = 1, 12
                MEFL(I1,J) = MEFL(I1,J)+NMI(K)*NFX(J)*WGTMF
                MEFL(I2,J) = MEFL(I2,J)+NMI(K)*NFY(J)*WGTMF
  130       CONTINUE
  120     CONTINUE
C ---      2) TERMES DE COUPLAGE MEMBRANE-FLEXION W*W ET BETA*BETA :
C             ----------------------------------------------------
            DO 140 I = 1, 8
            DO 150 J = 1, 12
                MEFL(I,J) = MEFL(I,J) + WMESQ(I)*WSQ(J)*WGTM
     +                + (NMX(I)*NFX(J) + NMY(I)*NFY(J))*WGTF
  150       CONTINUE
  140     CONTINUE
C
C===========================================================
C ---  AJOUT DE NOUVEAUX TERMES A LA PARTIE MEMBRANE       =
C ---  DE LA MATRICE DE MASSE DUS A L'EXCENTREMENT         =
C===========================================================
C
C ---     PRISE EN COMPTE DES TERMES DE MEMBRANE
C ---     ON A 3 TYPES DE TERMES DONT IL FAUT TENIR COMPTE
C ---     1) LES TERMES U*BETA     -> NMI*NMX ET NMI*NMY (RHO_MF)
C ---     2) LES TERMES W*W        -> WMESQ*WMESQ        (RHO_M)
C ---     3) LES TERMES BETA*BETA  -> NMX*NMX            (RHO_F)
C         ------------------------------------------------------
C
C ---      1) TERMES DE MEMBRANE U*BETA :
C             -------------------------
          DO 160 K = 1, 4
            I1 = 2*(K-1)+1
            I2 = I1     +1
            DO 170 P = 1, 4
              J1 = 2*(P-1)+1
              J2 = J1     +1
              MEMB(I1,J1) = MEMB(I1,J1)+
     +                      (NMI(K)*NMX(J1)+NMI(P)*NMX(I1))*WGTMF
              MEMB(I1,J2) = MEMB(I1,J2)+
     +                      (NMI(K)*NMX(J2)+NMI(P)*NMY(I1))*WGTMF
              MEMB(I2,J1) = MEMB(I2,J1)+
     +                      (NMI(K)*NMY(J1)+NMI(P)*NMX(I2))*WGTMF
              MEMB(I2,J2) = MEMB(I2,J2)+
     +                      (NMI(K)*NMY(J2)+NMI(P)*NMY(I2))*WGTMF
  170       CONTINUE
  160     CONTINUE
C ---      2) TERMES DE MEMBRANE WMESQ*WMESQ ET BETA*BETA :
C           -------------------------------------------
          DO 180 I = 1, 8
            DO 190 J = 1, 8
                MEMB(I,J) = MEMB(I,J) + WMESQ(I)*WMESQ(J)*WGTM
     +                + (NMX(I)*NMX(J) + NMY(I)*NMY(J))*WGTF
  190       CONTINUE
  180     CONTINUE
C
        ENDIF
C ---   FIN DU TRAITEMENT DU CAS D'UN ELEMENT EXCENTRE
C       ----------------------------------------------
   70 CONTINUE
C --- FIN DE LA BOUCLE SUR LES POINTS D'INTEGRATION
C     ---------------------------------------------
C
C --- INSERTION DES DIFFERENTES PARTIES CALCULEES DE LA MATRICE
C --- DE MASSE A LA MATRICE ELLE MEME :
C     ===============================   
      IF (( OPTION .EQ. 'MASS_MECA' ).OR.(OPTION.EQ.'M_GAMMA')) THEN
        CALL DXQLOC(FLEX,MEMB,MEFL,CTOR,MAS)
      ELSE IF (OPTION.EQ.'MASS_MECA_DIAG') THEN
        CALL DXQLOC(FLEX,MEMB,MEFL,CTOR,MASLOC)
        WGT = ZR(LZR-1+LAIRE)*ROE
        CALL UTPSLG(4,6,PGL,MASLOC,MASGLO)
        CALL DIALUM(4,6,24,WGT,MASGLO,MAS)
      ELSE IF (OPTION.EQ.'ECIN_ELEM_DEPL') THEN
        CALL JEVECH('PDEPLAR','L',JDEPG)
        CALL UTPVGL(4,6,PGL,ZR(JDEPG),DEPL)
        CALL DXQLOE(FLEX,MEMB,MEFL,CTOR,0,DEPL,ENER)
      END IF
      CALL JEDEMA()
      END
