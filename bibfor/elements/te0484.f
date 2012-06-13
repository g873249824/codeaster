      SUBROUTINE TE0484(OPTION,NOMTE)
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
      CHARACTER*16 NOMTE,NOMSHB,OPTION
      REAL*8 SIGMA(120),XIDEPM(60)
      REAL*8 FSTAB(12),PARA(11)
      REAL*8 VALRES(NBRES)
      REAL*8 NU,E
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C --- INITIALISATIONS :
      CALL IDSSHB(NDIM,NNO,NPG,NOMSHB)
      DO 10 I = 1,11
         PARA(I) = 0.D0
   10 CONTINUE
      FAMIL='FPG1'
      KPG=1
      SPT=1
      POUM='+'
      IF (OPTION.EQ.'FORC_NODA') THEN
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
        LAG = 0
        PARA(1) = E
        PARA(2) = NU
        PARA(3) = YGOT
        PARA(4) = 0
        PARA(5) = 1
        PARA(6) = LAG
      END IF
C
C  ==============================================
C  -- VECTEUR DES FORCES INTERNES
C  ==============================================
      IF (OPTION.EQ.'FORC_NODA') THEN
          CALL JEVECH('PGEOMER','L',IGEOM)
C ----     CONTRAINTES AUX POINTS D'INTEGRATION
          CALL JEVECH('PCONTMR','L',ICONTM)
C         CHAMPS POUR LA REACTUALISATION DE LA GEOMETRIE
          CALL JEVECH('PDEPLMR','L',IDEPLM)
C ----     CONTRAINTES DE STABILISATION
C ----     PARAMETRES EN SORTIE
C ----     VECTEUR DES FORCES INTERNES (BT*SIGMA)
          CALL JEVECH('PVECTUR','E',IVECTU)
          CALL TECACH('ONN','PCOMPOR',1,ICOMPO,IRET)
          IF (ICOMPO.NE.0) THEN
            CALL JEVECH('PCOMPOR','L',ICOMPO)
          END IF
C  =============================================
C  -  ACTUALISATION : GEOM ORIG + DEPL DEBUT PAS
C  =============================================
          CALL R8INIR(60,0.D0,XIDEPM,1)
          IF ((ZK16(ICOMPO+2).EQ.'GROT_GDEP')) THEN
            CALL R8INIR(60,0.D0,XIDEPM,1)
            DO 150 I = 1,3*NNO
             ZR(IGEOM+I-1) = ZR(IGEOM+I-1) + ZR(IDEPLM+I-1)
C            WORK(100+I) = ZR(IDEPLM+I-1)
             XIDEPM(I) = ZR(IDEPLM+I-1)
  150       CONTINUE
          ELSE IF ((ZK16(ICOMPO+2) (1:5).EQ.'PETIT')) THEN
C          CALL R8INIR(24,0.D0,WORK(101),1)
            CALL R8INIR(60,0.D0,XIDEPM,1)
          ELSE
            DO 152 I = 1,3*NNO
C            WORK(100+I) = ZR(IDEPLM+I-1)
             XIDEPM(I) = ZR(IDEPLM+I-1)
  152       CONTINUE
          END IF
C ----   CALCUL DES FORCES INTERNES BT.SIGMA
C
C           ON PASSE EN PARAMETRES
C           ZR(IGEOM) : GEOMETRIE CONFIG DEBUT PAS
C           WORK : PARAMETRES MATERIAU
C                  WORK(1)=E  WORK(2)=NU  WORK(3)=LAG
C           ZR(IDEPLM) : DEPLACEMENT
C           ZR(ICONTM) : CONTRAINTE DE CAUCHY DEBUT DE PAS
C           ZR(IVARIM) (DE 2 A 14) : CONTRAINTES DE STABILISATION
C           ON RECUPERE :
C           ZR(IVECTU) : FORCES INTERNES FIN DE PAS
C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C
          CALL MOYTEM(FAMI,NPG,1,'+',TEMPM,IRET)
          CALL JEVECH('PMATERC','L',IMATE)
          NOMRES(1) = 'E'
          NOMRES(2) = 'NU'
          NBV = 2
          CALL RCVALB(FAMIL,KPG,SPT,POUM,ZI(IMATE),' ','ELAS',1,'TEMP',
     &             TEMPM,NBV,NOMRES,VALRES, ICODRE,1)
          E = VALRES(1)
          NU = VALRES(2)
          PARA(1) = E
          PARA(2) = NU
          DO 557 I=1,NPG
            DO 556 J=1,6
             SIGMA(6*(I-1)+J)=ZR(ICONTM+18*(I-1)+J-1)
  556       CONTINUE
  557     CONTINUE
C
          IF (NOMSHB.EQ.'SHB8') THEN
            DO 94 I=1,12
               FSTAB(I) = ZR(ICONTM+I-1+6)
   94       CONTINUE
            CALL JEVECH('PVECTUR','E',IVECTU)
            CALL SH8FOR(ZR(IGEOM),PARA,XIDEPM,
     &            SIGMA,FSTAB,ZR(IVECTU))
          ELSE IF (NOMSHB.EQ.'SHB6') THEN
            CALL JEVECH('PVECTUR','E',IVECTU)
            CALL SH6FOR(ZR(IGEOM),PARA,XIDEPM,
     &            SIGMA,ZR(IVECTU))
          ELSE IF (NOMSHB.EQ.'SHB15') THEN
            CALL JEVECH('PVECTUR','E',IVECTU)
            CALL SH1FOR(ZR(IGEOM),PARA,XIDEPM,
     &            SIGMA,ZR(IVECTU))
          ELSE IF (NOMSHB.EQ.'SHB20') THEN
            CALL JEVECH('PVECTUR','E',IVECTU)
            CALL SH2FOR(ZR(IGEOM),PARA,XIDEPM,
     &            SIGMA,ZR(IVECTU))
          END IF
      END IF
      END
