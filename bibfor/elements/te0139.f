      SUBROUTINE TE0139(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/02/2011   AUTEUR BARGELLI R.BARGELLINI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          ELEMENTS 3D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      CHARACTER*8 TYPMOD(2)
      CHARACTER*4 FAMI
      INTEGER JGANO,NNO,NPG,I,IMATUU,LGPG,NDIM,LGPG1,IRET
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER ICONTM,IVARIM
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,LI,JCRET,CODRET
      INTEGER IVARIX
      LOGICAL MATSYM
      INTEGER JTAB(7),NNOS,IDIM
      REAL*8 BARY(3)
      REAL*8 PFF(6*27*27),DEF(6*27*3),DFDI(3*27)
      REAL*8 ANGMAS(7)
C     POUR TGVERI
      REAL*8 SDEPL(3*27),SVECT(3*27),SCONT(6*27),SMATR(3*27*3*27),EPSILO
      REAL*8 VARIA(2*3*27*3*27)

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


C - FONCTIONS DE FORMES ET POINTS DE GAUSS
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     MATNS MAL DIMENSIONNEE
      CALL ASSERT(NNO.LE.27)


C - TYPE DE MODELISATION
      TYPMOD(1) = '3D      '
      TYPMOD(2) = '        '

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

C --- ORIENTATION DU MASSIF
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

C - PARAMETRES EN SORTIE

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
        CALL DCOPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)

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

      IF (ZK16(ICOMPO+3) (1:9).EQ.'COMP_ELAS') THEN

C - LOIS DE COMPORTEMENT ECRITES EN CONFIGURATION DE REFERENCE
C                          COMP_ELAS

        IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN

C        OPTION RIGI_MECA_TANG :         ARGUMENTS EN T-
          CALL NMEL3D(FAMI,'-',NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IDEPLM),ANGMAS,DFDI,
     &                PFF,DEF,ZR(ICONTM),ZR(IVARIM),ZR(IMATUU),
     &                ZR(IVECTU),CODRET)

        ELSE

C        OPTION FULL_MECA OU RAPH_MECA : ARGUMENTS EN T+

          DO 10 LI = 1,3*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   10     CONTINUE

          CALL NMEL3D(FAMI,'+',NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IDEPLP),ANGMAS,DFDI,
     &                PFF,DEF,ZR(ICONTP),ZR(IVARIP),ZR(IMATUU),
     &                ZR(IVECTU),CODRET)
        END IF

      ELSE

C - LOIS DE COMPORTEMENT ECRITE EN CONFIGURATION ACTUELLE
C                          COMP_INCR

C       Pour le calcul de la matrice tangente par perrturbation
 1000   CONTINUE

C      PETITES DEFORMATIONS (AVEC EVENTUELLEMENT REACTUALISATION)
        IF (ZK16(ICOMPO+2) (1:5).EQ.'PETIT') THEN
          IF (ZK16(ICOMPO+2) (6:10).EQ.'_REAC') THEN
            DO 20 I = 1,3*NNO
              ZR(IGEOM+I-1) = ZR(IGEOM+I-1) + ZR(IDEPLM+I-1) +
     &                        ZR(IDEPLP+I-1)
   20       CONTINUE
          END IF
          CALL NMPL3D(FAMI,NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                MATSYM,DFDI,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)


C      GRANDES DEFORMATIONS : FORMULATION SIMO - MIEHE

        ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
              CALL NMGPFI(FAMI,OPTION,TYPMOD,
     &      NDIM,NNO,NPG,IPOIDS,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
     &      ZK16(ICOMPO),ZI(IMATE),LGPG,ZR(ICARCR),ANGMAS,
     &      ZR(IINSTM),ZR(IINSTP),
     &      ZR(IDEPLM),ZR(IDEPLP),ZR(ICONTM),ZR(IVARIM),
     &      ZR(ICONTP),ZR(IVARIP),ZR(IVECTU),ZR(IMATUU),CODRET)

C 7.3 - CO-ROTATIONNELLE ZMAT 

        ELSE IF (((ZK16(ICOMPO).EQ.'ZMAT').AND.
     &             ZK16(ICOMPO+2).EQ.'GDEF_HYPO_ELAS') ) THEN

          DO 51 LI = 1,3*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   51     CONTINUE

          CALL NMGZ3D(FAMI,NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                DFDI,PFF,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)


C 7.3 - GREEN-REAC

        ELSE IF (ZK16(ICOMPO+2).EQ.'GREEN_REAC') THEN

          DO 52 LI = 1,3*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   52     CONTINUE

          CALL NMGC3D(FAMI,NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                DFDI,PFF,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)


C 7.3 - GRANDES ROTATIONS ET PETITES DEFORMATIONS
        ELSE IF (ZK16(ICOMPO+2) .EQ.'GROT_GDEP') THEN

          DO 50 LI = 1,3*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   50     CONTINUE

          CALL NMGR3D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),MATSYM,
     &                DFDI,PFF,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)
     
C 7.3 - GRANDES DEFORMATIONS FORMULATION GDEF_HYPO_ELAS
C       ou SIMO_HUGHES1 (A DEBUGGER)

        ELSE IF (ZK16(ICOMPO+2).EQ.'GDEF_HYPO_ELAS')  THEN

              CALL NMSH1(FAMI,OPTION,TYPMOD,ZK16(ICOMPO+2),
     &      NDIM,NNO,NPG,IPOIDS,IVF,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
     &      ZK16(ICOMPO),ZI(IMATE),LGPG,ZR(ICARCR),ANGMAS,
     &      ZR(IINSTM),ZR(IINSTP),
     &      ZR(IDEPLM),ZR(IDEPLP),ZR(ICONTM),ZR(IVARIM),
     &      ZR(ICONTP),ZR(IVARIP),ZR(IVECTU),ZR(IMATUU),CODRET)
     
C 7.3 - GRANDES DEFORMATIONS FORMULATION MIEHE-APEL-LAMBRECHT

        ELSE IF (ZK16(ICOMPO+2).EQ.'GDEF_LOG') THEN

            CALL NMDLOG(FAMI,OPTION,TYPMOD,
     &      NDIM,NNO,NPG,IPOIDS,IVF,ZR(IVF),IDFDE,ZR(IGEOM),DFDI,
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
     &              ZR(IVECTU),SVECT,6*NPG,ZR(ICONTP),SCONT,
     &              NPG*LGPG,ZR(IVARIP),ZR(IVARIX),
     &              ZR(IMATUU),SMATR,MATSYM,EPSILO,VARIA,IRET)
        IF (IRET.NE.0) GOTO 1000

      END IF

 2000  CONTINUE
      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = CODRET
      END IF

      END
