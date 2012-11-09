      SUBROUTINE TE0454(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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

      IMPLICIT  NONE

      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE: CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                         POUR DES ELEMENTS MIXTES A 3 CHAMPS EN
C                        3D/D_PLAN/AXIS  GRANDES DEFORMATIONS
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................


      CHARACTER*8 LIELRF(10),TYPMOD(2)
      LOGICAL RIGI,RESI,MATSYM,LTEATT
      INTEGER NDIM,NNO1,NNO2,NNO3,NPG,ICORET,CODRET,IRET,NNOS,JGN,NTROU
      INTEGER IW,IVF1,IVF2,IVF3,IDF1,IDF2,IDF3,JTAB(7),LGPG,I,IDIM
      INTEGER VU(3,27),VG(27),VP(27)
      INTEGER IGEOM,IMATE,ICONTM,IVARIM
      INTEGER IINSTM,IINSTP,IDDLM,IDDLD,ICOMPO,ICARCR,IVARIX
      INTEGER IVECTU,ICONTP,IVARIP,IMATUU,NDDL
      REAL*8 DFF1(4*27),DFF2(3*27),ANGMAS(7),BARY(3)
C     POUR TGVERI
      REAL*8 SDEPL(135),SVECT(135),SCONT(6*27),SMATR(18225),EPSILO
      REAL*8 EPSILP, EPSILG
      REAL*8 VARIA(2*135*135)
C ----------------------------------------------------------------------

C - FONCTIONS DE FORME
      CALL ELREF2(NOMTE,10,LIELRF,NTROU)
      CALL ASSERT(NTROU.GE.3)
      CALL ELREF4(LIELRF(3),'RIGI',NDIM,NNO3,NNOS,NPG,IW,IVF3,IDF3,JGN)
      CALL ELREF4(LIELRF(2),'RIGI',NDIM,NNO2,NNOS,NPG,IW,IVF2,IDF2,JGN)
      CALL ELREF4(LIELRF(1),'RIGI',NDIM,NNO1,NNOS,NPG,IW,IVF1,IDF1,JGN)
      NDDL = NNO1*NDIM + NNO2 + NNO3

C - TYPE DE MODELISATION
      IF (NDIM.EQ.2 .AND. LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS  '
      ELSE IF (NDIM.EQ.2 .AND. NOMTE(3:4).EQ.'PL') THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D'
      ELSE
        CALL U2MESK('F','ELEMENTS_34',1,NOMTE)
      END IF
      TYPMOD(2) = 'INCO'
      CODRET = 0

C - ACCES AUX COMPOSANTES DU VECTEUR DDL
      CALL NIINIT(NOMTE,TYPMOD,NDIM,NNO1,NNO2,NNO3,VU,VG,VP)

C - OPTION
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'

C PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PDEPLMR','L',IDDLM)
      CALL JEVECH('PDEPLPR','L',IDDLD)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PCARCRI','L',ICARCR)

      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)

      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)

C --- ORIENTATION DU MASSIF
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      BARY(1) = 0.D0
      BARY(2) = 0.D0
      BARY(3) = 0.D0
      DO 150 I = 1,NNO1
        DO 140 IDIM = 1,NDIM
          BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO1
 140    CONTINUE
 150  CONTINUE
      CALL RCANGM ( NDIM, BARY, ANGMAS )

C PARAMETRES EN SORTIE

      IF (RIGI) THEN
        CALL NMTSTM(ZK16(ICOMPO),IMATUU,MATSYM)
      ELSE
        IMATUU=1
      END IF

      IF (RESI) THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL DCOPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)
      ELSE
        IVECTU=1
        ICONTP=1
        IVARIP=1
        IVARIX=1
      END IF


      IF (ZK16(ICOMPO+2) (1:10).NE.'SIMO_MIEHE')
     &  CALL U2MESK('F','ELEMENTS3_16', 1, ZK16(ICOMPO+2))

 1000 CONTINUE

      CALL NIFINT(NDIM,NNO1,NNO2,NNO3,NPG,IW,ZR(IVF1),ZR(IVF2),
     &    ZR(IVF3),IDF1,IDF2,DFF1,DFF2,VU,VG,VP,
     &    ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),LGPG,
     &    ZR(ICARCR),ZR(IINSTM),ZR(IINSTP),ZR(IDDLM),ZR(IDDLD),
     &    ANGMAS,ZR(ICONTM),ZR(IVARIM),ZR(ICONTP),ZR(IVARIP),
     &    ZR(IVECTU),ZR(IMATUU),CODRET)

      IF (CODRET.NE.0) GOTO 2000
C       Calcul eventuel de la matrice TGTE par PERTURBATION
      CALL TGVERM(OPTION,ZR(ICARCR),ZK16(ICOMPO),NNO1,NNO2,NNO3,
     &            ZR(IGEOM),NDIM,NDDL,ZR(IDDLD),SDEPL,VU,VG,VP,
     &            ZR(IVECTU),SVECT,NDIM*2*NPG,ZR(ICONTP),SCONT,NPG*LGPG,
     &            ZR(IVARIP),ZR(IVARIX),ZR(IMATUU),SMATR,MATSYM,EPSILO,
     &            EPSILP,EPSILG,VARIA,IRET)
      IF (IRET.NE.0) GOTO 1000

 2000 CONTINUE

      IF (RESI) THEN
        CALL JEVECH('PCODRET','E',ICORET)
        ZI(ICORET) = CODRET
      END IF


      END
