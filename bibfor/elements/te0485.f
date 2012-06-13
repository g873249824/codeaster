      SUBROUTINE TE0485(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C ELEMENT SHB15
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)
C
C          ELEMENT SHB
C    FONCTION REALISEE:
C            OPTION : 'RIGI_MECA      '
C                            CALCUL DES MATRICES ELEMENTAIRES  3D
C            OPTION : 'RIGI_MECA_SENSI' OU 'RIGI_MECA_SENS_C'
C                            CALCUL DU VECTEUR ELEMENTAIRE -DK/DP*U
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C
      INCLUDE 'jeveux.h'
      PARAMETER (NBRES=2)
      CHARACTER*4 FAMI
      INTEGER ICODRE(NBRES),KPG,SPT
      CHARACTER*8 NOMRES(NBRES),FAMIL,POUM
      CHARACTER*16 NOMTE,OPTION,NOMSHB
      REAL*8 SIGMA(120),PARA(11)
      REAL*8 FSTAB(12)
      REAL*8 VALRES(NBRES),DUSX(180)
      INTEGER NBSIG
      REAL*8 NU,E
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C --- INITIALISATIONS :
      CALL IDSSHB(NDIM,NNO,NPG,NOMSHB)
      NBSIG = 6
      DO 10 I = 1,11
         PARA(I) = 0.D0
   10 CONTINUE
      FAMIL='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      IF (OPTION.EQ.'SIEF_ELGA') THEN
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
        CALL RCVALB(FAMIL,KPG,SPT,POUM,ZI(IMATE),' ','ELAS',1,'TEMP',
     &              TEMPM,NBV,NOMRES,VALRES,ICODRE,1)
        E = VALRES(1)
        NU = VALRES(2)
C ----  PARAMETRES MATERIAUX
        YGOT = E
C ----  PARAMETRES MATERIAUX POUR LE CALCUL DE LA
C ----  MATRICE TANGENTE PLASTIQUE
C       LAG=0 LAGRANGIEN REACTUALISE (EPS=EPSLIN)
C       LAG=1 LAGRANGIEN TOTAL (EPS=EPSLIN+EPSNL)
        LAG = 0
        PARA(1) = E
        PARA(2) = NU
        PARA(3) = YGOT
        PARA(4) = 0
        PARA(5) = 1
        PARA(6) = LAG
C
      END IF
C
C  ===========================================
C  -- CONTRAINTES
C  ===========================================
      IF (OPTION.EQ.'SIEF_ELGA') THEN
        IF (NOMSHB.EQ.'SHB8') THEN
          DO 60 I = 1,NBSIG*NPG
            SIGMA(I) = 0.D0
   60     CONTINUE
C        SIGMA(1) = WORK(150)
C        RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C        DEPL Dans ZR(IDEPL)
          CALL JEVECH('PDEPLAR','L',IDEPL)
C        VECTEUR DES CONTRAINTES AUX POINTS D'INTEGRATION
          CALL SH8SIG(ZR(IGEOM),PARA,ZR(IDEPL),DUSX,SIGMA)
C        RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
          CALL JEVECH('PCONTRR','E',ICONT)
          CALL R8INIR(12,0.D0,FSTAB,1)
          DO 67 I=1,12
             ZR(ICONT+I-1+6)=FSTAB(I)
   67     CONTINUE
          DO 69 I=1,5
            DO 68 J=1,6
             ZR(ICONT+18*(I-1)+J-1)=SIGMA(6*(I-1)+J)
   68       CONTINUE
   69     CONTINUE
C
        ELSE IF (NOMSHB.EQ.'SHB6') THEN
          DO 70 I = 1,NBSIG*NPG
            SIGMA(I) = 0.D0
   70     CONTINUE
C        RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C        DEPL Dans ZR(IDEPL)
          CALL JEVECH('PDEPLAR','L',IDEPL)
C        VECTEUR DES CONTRAINTES AUX POINTS D'INTEGRATION
          CALL SH6SIG(ZR(IGEOM),PARA,ZR(IDEPL),DUSX,SIGMA)
C        RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
          CALL JEVECH('PCONTRR','E',ICONT)
          DO 79 I=1,5
            DO 78 J=1,6
             ZR(ICONT+18*(I-1)+J-1)=SIGMA(6*(I-1)+J)
   78       CONTINUE
   79     CONTINUE
C
        ELSE IF (NOMSHB.EQ.'SHB15') THEN
          DO 80 I = 1,NBSIG*NPG
            SIGMA(I) = 0.D0
   80     CONTINUE
C        RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C        DEPL Dans ZR(IDEPL)
          CALL JEVECH('PDEPLAR','L',IDEPL)
C        VECTEUR DES CONTRAINTES AUX POINTS D'INTEGRATION
C        RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
          CALL SH1SIG(ZR(IGEOM),PARA,ZR(IDEPL),DUSX,SIGMA)
          CALL JEVECH('PCONTRR','E',ICONT)
C
          DO 89 I=1,15
            DO 88 J=1,6
             ZR(ICONT+18*(I-1)+J-1)=SIGMA(6*(I-1)+J)
   88       CONTINUE
   89     CONTINUE
C
        ELSE IF (NOMSHB.EQ.'SHB20') THEN
          DO 91 I = 1,NBSIG*NPG
            SIGMA(I) = 0.D0
   91     CONTINUE
C        RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C        DEPL Dans ZR(IDEPL)
          CALL JEVECH('PDEPLAR','L',IDEPL)
C        VECTEUR DES CONTRAINTES AUX POINTS D'INTEGRATION
C        RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
          CALL SH2SIG(ZR(IGEOM),PARA,ZR(IDEPL),DUSX,SIGMA)
          CALL JEVECH('PCONTRR','E',ICONT)
C
          DO 93 I=1,20
            DO 92 J=1,6
             ZR(ICONT+18*(I-1)+J-1)=SIGMA(6*(I-1)+J)
   92       CONTINUE
   93     CONTINUE
        END IF
      END IF

      END
