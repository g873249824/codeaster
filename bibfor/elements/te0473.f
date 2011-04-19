      SUBROUTINE TE0473(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)

C          ELEMENT SHB
C    FONCTION REALISEE:
C            OPTION : 'RIGI_MECA      '
C                            CALCUL DES MATRICES ELEMENTAIRES  3D
C            OPTION : 'RIGI_MECA_SENSI' OU 'RIGI_MECA_SENS_C'
C                            CALCUL DU VECTEUR ELEMENTAIRE -DK/DP*U
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      PARAMETER (NBRES=2)
      CHARACTER*4 FAMI
      INTEGER ICODRE(NBRES)
      CHARACTER*8 NOMRES(NBRES)
      CHARACTER*16 NOMTE,OPTION,NOMSHB
      REAL*8 PARA(11),RE20(60,60)
      REAL*8 VALRES(NBRES),RE(24,24),RE6(18,18)
      INTEGER NBV
      REAL*8 NU,E,RE15(45,45)

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
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      CALL IDSSHB(NDIM,NNO,NPG,NOMSHB)
      NBINCO = NDIM*NNO
      DO 10 I = 1,11
         PARA(I) = 0.D0
   10 CONTINUE
      IF (OPTION.EQ.'RIGI_MECA') THEN
C ----  RECUPERATION DES COORDONNEES DES CONNECTIVITES
        CALL JEVECH('PGEOMER','L',IGEOM)
C ----  RECUPERATION DU MATERIAU DANS ZI(IMATE)
        CALL JEVECH('PMATERC','L',IMATE)
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NBV = 2
C ----  INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----  ET DU TEMPS
C
        CALL MOYTEM(FAMI,NPG,1,'+',TEMPM,IRET)
        CALL RCVALA(ZI(IMATE),' ','ELAS',1,'TEMP',TEMPM,NBV,NOMRES,
     &              VALRES,ICODRE,1)
        E = VALRES(1)
        NU = VALRES(2)
C ----  PARAMETRES MATERIAUX
        YGOT = E
C ----  PARAMETRES MATERIAUX POUR LE CALCUL DE LA
C ----  MATRICE TANGENTE PLASTIQUE
C       MATRICE TANGENTE PLASTIQUE SI WORK(13)=1
C       LAG=0 LAGRANGIEN REACTUALISE (EPS=EPSLIN)
C       LAG=1 LAGRANGIEN TOTAL (EPS=EPSLIN+EPSNL)
        LAG = 0
        PARA(1) = E
        PARA(2) = NU
        PARA(3) = YGOT
C PARA(4) = WORK(13)
        PARA(4) = 0
C PARA(5) = WORK(150)
        PARA(5) = 1
C PARA(6) = LAG
        PARA(6) = LAG
      END IF
C
C  ===========================================
C  -- MATRICE DE RIGIDITE
C  ===========================================
      IF (OPTION.EQ.'RIGI_MECA') THEN
        IF (NOMSHB.EQ.'SHB8') THEN
          DO 30 I = 1,NBINCO
            DO 20 J = 1,NBINCO
             RE(I,J) = 0.D0
   20       CONTINUE
   30     CONTINUE
          CALL SH8RIG(ZR(IGEOM),PARA,RE)
C        RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C        DEMI-MATRICE DE RIGIDITE
          CALL JEVECH('PMATUUR','E',IMATUU)
          K = 0
          DO 50 I = 1,NBINCO
            DO 40 J = 1,I
              K = K + 1
              ZR(IMATUU+K-1) = RE(I,J)
   40       CONTINUE
   50     CONTINUE
        ELSE IF (NOMSHB.EQ.'SHB6') THEN
          DO 70 I = 1,NBINCO
            DO 60 J = 1,NBINCO
             RE6(I,J) = 0.D0
   60       CONTINUE
   70     CONTINUE
          CALL SH6RIG(ZR(IGEOM),PARA,RE6)
          CALL JEVECH('PMATUUR','E',IMATUU)
          K = 0
          DO 90 I = 1,NBINCO
            DO 80 J = 1,I
              K = K + 1
              ZR(IMATUU+K-1) = RE6(I,J)
   80       CONTINUE
   90     CONTINUE
        ELSE IF (NOMSHB.EQ.'SHB15') THEN
          DO 110 I = 1,NBINCO
            DO 100 J = 1,NBINCO
             RE15(I,J) = 0.D0
  100       CONTINUE
  110     CONTINUE
C
          CALL SH1RIG(ZR(IGEOM),PARA,RE15)
          CALL JEVECH('PMATUUR','E',IMATUU)
          K = 0
          DO 130 I = 1,NBINCO
            DO 120 J = 1,I
              K = K + 1
              ZR(IMATUU+K-1) = RE15(I,J)
  120       CONTINUE
  130     CONTINUE
        ELSE IF (NOMSHB.EQ.'SHB20') THEN
          DO 150 I = 1,60
            DO 140 J = 1,60
             RE20(I,J) = 0.D0
  140       CONTINUE
  150     CONTINUE
          CALL SH2RIG(ZR(IGEOM),PARA,RE20)
          CALL JEVECH('PMATUUR','E',IMATUU)
          K = 0
          DO 170 I = 1,60
            DO 160 J = 1,I
              K = K + 1
              ZR(IMATUU+K-1) = RE20(I,J)
  160       CONTINUE
  170     CONTINUE
        END IF
      END IF
      END
