      SUBROUTINE TE0100(OPTION,NOMTE)
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          EN 2D (CPLAN ET DPLAN) ET AXI
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      CHARACTER*8 TYPMOD(2)
      CHARACTER*4 FAMI
      INTEGER NNO,NPG1,I,IMATUU,LGPG,LGPG1
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER ICONTM,IVARIM
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,LI
      INTEGER IVARIX,IRET
      INTEGER JTAB(7),JCRET,CODRET
      INTEGER NDIM,NNOS,JGANO,IDIM
      REAL*8  VECT1(54), VECT2(4*27*27), VECT3(4*27*2),DFDI(4*9)
      REAL*8  ANGMAS(7),BARY(3)
      LOGICAL MATSYM,LTEATT
C     POUR TGVERI
      REAL*8 SDEPL(3*9),SVECT(3*9),SCONT(6*9),SMATR(3*9*3*9),EPSILO
      REAL*8 VARIA(2*3*9*3*9)
C
      ICONTP=1
      IVARIP=1
      IMATUU=1
      IVECTU=1
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
C - FONCTIONS DE FORMES ET POINTS DE GAUSS
C

C - TYPE DE MODELISATION

      IF (LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS    '
      ELSE IF (LTEATT(' ','C_PLAN','OUI')) THEN
        TYPMOD(1) = 'C_PLAN  '
      ELSE IF (LTEATT(' ','D_PLAN','OUI')) THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE
C       NOM D'ELEMENT ILLICITE
        CALL ASSERT(LTEATT(' ','C_PLAN','OUI'))
      END IF

      IF (LTEATT(' ','TYPMOD2','ELEMDISC')) THEN
        TYPMOD(2) = 'ELEMDISC'
      ELSE
        TYPMOD(2) = '        '
      END IF
      CODRET = 0

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCONTMR','L',ICONTM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PCARCRI','L',ICARCR)

      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG1 = MAX(JTAB(6),1)*JTAB(7)
      LGPG = LGPG1

C     ORIENTATION DU MASSIF
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      BARY(1) = 0.D0
      BARY(2) = 0.D0
      BARY(3) = 0.D0
      DO 150 I = 1,NNO
        DO 140 IDIM = 1,NDIM
          BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 140    CONTINUE
 150  CONTINUE
      CALL RCANGM ( NDIM, BARY, ANGMAS )

C - VARIABLES DE COMMANDE

      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
C PARAMETRES EN SORTIE

      IF (OPTION(1:10).EQ.'RIGI_MECA_' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
          CALL NMTSTM(ZK16(ICOMPO),IMATUU,MATSYM)
      ENDIF

      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PVECTUR','E',IVECTU)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVARIPR','E',IVARIP)

C      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL DCOPY(NPG1*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)
      ELSE
        IVARIX=1
      END IF

C - PARAMETRES EN SORTIE SUPPLEMENTAIE POUR LA METHODE IMPLEX
      IF (OPTION(1:16).EQ.'RIGI_MECA_IMPLEX') THEN
        IF (ZK16(ICOMPO).NE.'VMIS_ISOT_LINE' .AND.
     &      ZK16(ICOMPO).NE.'ELAS' .AND.
     &      ZK16(ICOMPO).NE.'ENDO_FRAGILE' .AND.
     &      ZK16(ICOMPO).NE.'ENDO_ISOT_BETON') THEN
          CALL U2MESS('F','ELEMENTS5_50')
        END IF
        CALL JEVECH('PCONTXR','E',ICONTP)
      END IF


C - HYPER-ELASTICITE

      IF (ZK16(ICOMPO+3) (1:9).EQ.'COMP_ELAS') THEN

        IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN

C        OPTION RIGI_MECA_TANG :         ARGUMENTS EN T-
          CALL NMEL2D(FAMI,'-',NNO,NPG1,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                IDEPLM,ANGMAS,VECT1,VECT2,
     &                VECT3,ZR(ICONTM),ZR(IVARIM),
     &                ZR(IMATUU),IVECTU,CODRET)

        ELSE

C        OPTION FULL_MECA OU RAPH_MECA : ARGUMENTS EN T+
          DO 10 LI = 1,2*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   10     CONTINUE

          CALL NMEL2D(FAMI,'+',NNO,NPG1,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                IDEPLP,ANGMAS,VECT1,VECT2,
     &                VECT3,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),IVECTU,CODRET)
        END IF

      ELSE

C - HYPO-ELASTICITE

C      Pour le calcul de la matrice tangente par perturbation
 1000 CONTINUE

        IF (ZK16(ICOMPO+2) (6:10).EQ.'_REAC') THEN
CCDIR$ IVDEP
          DO 20 I = 1,2*NNO
            ZR(IGEOM+I-1) = ZR(IGEOM+I-1) + ZR(IDEPLM+I-1) +
     &                      ZR(IDEPLP+I-1)
  20     CONTINUE
        END IF

        IF (ZK16(ICOMPO+2) (1:5).EQ.'PETIT') THEN

C -       ELEMENT A DISCONTINUITE INTERNE
          IF (TYPMOD(2).EQ.'ELEMDISC') THEN

            CALL NMED2D(NNO,NPG1,IPOIDS,IVF,IDFDE,
     &                  ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                  LGPG,ZR(ICARCR),
     &                  IDEPLM,IDEPLP,
     &                  ZR(ICONTM),ZR(IVARIM),VECT1,
     &                  VECT3,ZR(ICONTP),ZR(IVARIP),
     &                  ZR(IMATUU),IVECTU,CODRET)

          ELSE

            CALL NMPL2D(FAMI,NNO,NPG1,IPOIDS,IVF,IDFDE,
     &                  ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                  LGPG,ZR(ICARCR),
     &                  ZR(IINSTM),ZR(IINSTP),
     &                  IDEPLM,IDEPLP,
     &                  ANGMAS,
     &                  ZR(ICONTM),ZR(IVARIM),MATSYM,VECT1,
     &                  VECT3,ZR(ICONTP),ZR(IVARIP),
     &                  ZR(IMATUU),IVECTU,CODRET)

          ENDIF

C      GRANDES DEFORMATIONS : FORMULATION SIMO - MIEHE

        ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
          CALL NMGPFI(FAMI,OPTION,TYPMOD,
     &      NDIM,NNO,NPG1,IPOIDS,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
     &      ZK16(ICOMPO),ZI(IMATE),LGPG,ZR(ICARCR),ANGMAS,
     &      ZR(IINSTM),ZR(IINSTP),
     &      ZR(IDEPLM),ZR(IDEPLP),ZR(ICONTM),ZR(IVARIM),
     &      ZR(ICONTP),ZR(IVARIP),ZR(IVECTU),ZR(IMATUU),CODRET)

C 7.3 - CO-ROTATIONNELLE ZMAT

        ELSE IF (((ZK16(ICOMPO).EQ.'ZMAT').AND.
     &             ZK16(ICOMPO+2).EQ.'GDEF_HYPO_ELAS') ) THEN

          DO 46 LI = 1,2*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   46     CONTINUE

          CALL NMGZ2D(FAMI,NNO,NPG1,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                IDEPLM,IDEPLP,
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                VECT1,VECT2,VECT3,
     &                ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),IVECTU,CODRET)

C 7.3 - CO-ROTATIONNELLE ZMAT SUPPRIME  ATTENTE CORRECTION FICHE 14063

C 7.3 - GRANDES ROTATIONS ET PETITES DEFORMATIONS
        ELSE IF (ZK16(ICOMPO+2) .EQ.'GROT_GDEP') THEN

          DO 45 LI = 1,2*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   45     CONTINUE

          CALL NMGR2D(FAMI,NNO,NPG1,IPOIDS,IVF,ZR(IVF),IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),MATSYM,
     &                VECT1,VECT2,VECT3,
     &                ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)

        ELSE IF (ZK16(ICOMPO+2).EQ.'GDEF_HYPO_ELAS') THEN

              CALL NMSH1(FAMI,OPTION,TYPMOD,ZK16(ICOMPO+2),
     &      NDIM,NNO,NPG1,IPOIDS,IVF,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
     &      ZK16(ICOMPO),ZI(IMATE),LGPG,ZR(ICARCR),ANGMAS,
     &      ZR(IINSTM),ZR(IINSTP),
     &      ZR(IDEPLM),ZR(IDEPLP),ZR(ICONTM),ZR(IVARIM),
     &      ZR(ICONTP),ZR(IVARIP),ZR(IVECTU),ZR(IMATUU),CODRET)
        ELSE IF (ZK16(ICOMPO+2).EQ.'GDEF_LOG') THEN

            CALL NMDLOG(FAMI,OPTION,TYPMOD,
     &      NDIM,NNO,NPG1,IPOIDS,IVF,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
     &      ZK16(ICOMPO),ZI(IMATE),LGPG,ZR(ICARCR),ANGMAS,
     &      ZR(IINSTM),ZR(IINSTP),MATSYM,
     &      ZR(IDEPLM),ZR(IDEPLP),ZR(ICONTM),ZR(IVARIM),
     &      ZR(ICONTP),ZR(IVARIP),ZR(IVECTU),ZR(IMATUU),CODRET)

        ELSE
          CALL U2MESK('F','ELEMENTS3_16',1,ZK16(ICOMPO+2))
        END IF

        IF (CODRET.NE.0) GOTO 2000

C       Calcul eventuel de la matrice TGTE par PERTURBATION
        CALL TGVERI(OPTION,ZR(ICARCR),ZK16(ICOMPO),NNO,ZR(IGEOM),NDIM,
     &              NDIM*NNO,ZR(IDEPLP),SDEPL,
     &              ZR(IVECTU),SVECT,4*NPG1,ZR(ICONTP),SCONT,
     &              NPG1*LGPG,ZR(IVARIP),ZR(IVARIX),
     &              ZR(IMATUU),SMATR,MATSYM,EPSILO,VARIA,IRET)
        IF (IRET.NE.0) GOTO 1000

      END IF

 2000  CONTINUE

      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = CODRET
      END IF

      END
