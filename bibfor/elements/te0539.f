      SUBROUTINE TE0539(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          ELEMENTS 3D AVEC X-FEM
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      CHARACTER*8 TYPMOD(2),ELREFP
      INTEGER JGANO,NNO,NPG,I,KP,K,L,IMATUU,LGPG,NDIM,LGPG1,IRET,IJ
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER ITREF,ICONTM,IVARIM,ITEMPM,ITEMPP,IPHASM,IPHASP
      INTEGER IINSTM,IINSTP,IDEPLM,IDEPLP,ICOMPO,ICARCR
      INTEGER IVECTU,ICONTP,IVARIP,LI,IDEFAM,IDEFAP,JCRET,CODRET
      INTEGER IHYDRM,IHYDRP,ISECHM,ISECHP,ISREF,IVARIX
      INTEGER JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,JLSN,JLST
      INTEGER KK,NI,MJ,JTAB(7),NZ,NNOS,ICAMAS
      INTEGER DDLH,DDLC,NDDL,INO,NNOM,NFE,IBID
      LOGICAL DEFANE, MATSYM,LTEATT
      REAL*8  MATNS(3*27*3*27)
      REAL*8  VECT1(54), VECT2(4*27*27), VECT3(4*27*2)
      REAL*8  PFF(6*27*27),DEF(6*27*3),DFDI(3*27),DFDI2(3*27)
      REAL*8  ANGMAS(3),R8VIDE,R8DGRD
      REAL*8  PHASM(7*27),PHASP(7*27)

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
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      IF (NNO.GT.27) CALL UTMESS('F','TE0539','MATNS MAL DIMENSIONNEE')

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,DDLH,NFE,IBID,DDLC,NNOM,IBID,NDDL)
      
C - TYPE DE MODELISATION
      IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D      '
        TYPMOD(2) = '        '
      ELSE
         IF (LTEATT(' ','AXIS','OUI')) THEN
           TYPMOD(1) = 'AXIS    '
         ELSE IF (NOMTE(3:4).EQ.'CP') THEN
           TYPMOD(1) = 'C_PLAN  '
         ELSE IF (NOMTE(3:4).EQ.'DP') THEN
           TYPMOD(1) = 'D_PLAN  '
         ELSE
           CALL UTMESS('F','TE0100','NOM D''ELEMENT ILLICITE')
         END IF
         IF (NOMTE(1:2).EQ.'MD') THEN
           TYPMOD(2) = 'ELEMDISC'
         ELSE IF (NOMTE(1:2).EQ.'MI') THEN
           TYPMOD(2) = 'INCO    '
         ELSE
           TYPMOD(2) = '        '
         END IF
         CODRET=0     
      ENDIF

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

C     PARAM�TRES PROPRES � X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN'   ,'L',JLSN)
      CALL JEVECH('PLST'   ,'L',JLST)

C --- ORIENTATION DU MASSIF
      CALL RCANGM ( NDIM, ANGMAS )

C - VARIABLES DE COMMANDE

      CALL JEVECH('PTEREF','L',ITREF)
      CALL JEVECH('PTEMPMR','L',ITEMPM)
      CALL JEVECH('PTEMPPR','L',ITEMPP)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL JEVECH('PHYDRMR','L',IHYDRM)
      CALL JEVECH('PHYDRPR','L',IHYDRP)
      CALL JEVECH('PSECHMR','L',ISECHM)
      CALL JEVECH('PSECHPR','L',ISECHP)
      CALL JEVECH('PSECREF','L',ISREF)
      CALL TECACH('ONN','PDEFAMR',1,IDEFAM,IRET)
      IF (NDIM .EQ. 3) THEN
         CALL TECACH('ONN','PDEFAPR',1,IDEFAP,IRET)
         DEFANE = IRET .EQ. 0
      ELSE
         CALL TECACH('ONN','PDEFAPR',1,IDEFAP,IRET)
         DEFANE = IDEFAM .NE. 0
      ENDIF
      CALL TECACH('NNN','PPHASMR',1,IPHASM,IRET)
      CALL TECACH('NNN','PPHASPR',1,IPHASP,IRET)
      IF (IRET.EQ.0) THEN
        CALL TECACH('OON','PPHASPR',7,JTAB,IRET)
        NZ = JTAB(6)
C  PASSAGE DE PPHASMR ET PPHASPR AUX POINTS DE GAUSS
        DO 9 KP = 1,NPG
          K = (KP-1)*NNO
          DO 7 L = 1,NZ
            PHASM(NZ*(KP-1)+L)=0.D0
            PHASP(NZ*(KP-1)+L)=0.D0
            DO 5 I = 1,NNO
              PHASM(NZ*(KP-1)+L) = PHASM(NZ*(KP-1)+L) +
     +                           ZR(IPHASM+NZ*(I-1)+L-1)*ZR(IVF+K+I-1)
              PHASP(NZ*(KP-1)+L) = PHASP(NZ*(KP-1)+L) +
     +                           ZR(IPHASP+NZ*(I-1)+L-1)*ZR(IVF+K+I-1)
  5         CONTINUE
  7       CONTINUE
  9     CONTINUE
      END IF


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

C ATTENTION : ICONTM ET ICONTP : SIGMA AUX PTS DE GAUSS DES SOUS-T�TRAS

C      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
        CALL JEVECH('PVARIMP','L',IVARIX)
        CALL DCOPY(NPG*LGPG,ZR(IVARIX),1,ZR(IVARIP),1)

      END IF


      IF (ZK16(ICOMPO+3) (1:9).EQ.'COMP_ELAS') THEN

C - LOIS DE COMPORTEMENT ECRITES EN CONFIGURATION DE REFERENCE
C                          COMP_ELAS

        IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN

C         OPTION RIGI_MECA_TANG :         ARGUMENTS EN T-
          CALL XMEL3D(NNO,IPOIDS,IVF,DDLH,NFE,DDLC,IGEOM,TYPMOD,OPTION,
     &                NOMTE,ZI(IMATE),ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(ITEMPM),ZR(JPINTT),ZI(JCNSET),ZI(JHEAVT),
     &                ZI(JLONCH),ZR(JBASLO),ZR(IHYDRM),ZR(ISECHM),
     &                ZR(ITREF),ZR(IDEPLM),ZR(JLSN),ZR(JLST),ZR(ICONTM),
     &                ZR(IVARIM),ZR(IMATUU),ZR(IVECTU),CODRET)

C          DO 444 LI=1,NDDL
C            DO 445 I=1,LI
C              IJ = (LI-1)*LI/2 + I
C              IF (ABS(ZR(IMATUU-1+IJ)).GT.1.D-12)
C     &                WRITE(6,*)'K1(',I,',',LI,')=',ZR(IMATUU-1+IJ),';'
C 445        CONTINUE                
C 444      CONTINUE

        ELSE

C        OPTION FULL_MECA OU RAPH_MECA : ARGUMENTS EN T+
          DO 200 LI = 1,NDDL
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
 200      CONTINUE

          CALL XMEL3D(NNO,IPOIDS,IVF,DDLH,NFE,DDLC,IGEOM,TYPMOD,OPTION,
     &                NOMTE,ZI(IMATE),ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(ITEMPP),ZR(JPINTT),ZI(JCNSET),ZI(JHEAVT),
     &                ZI(JLONCH),ZR(JBASLO),ZR(IHYDRP),ZR(ISECHP),
     &                ZR(ITREF),ZR(IDEPLP),ZR(JLSN),ZR(JLST),ZR(ICONTP),
     &                ZR(IVARIP),ZR(IMATUU),ZR(IVECTU),CODRET)

C          WRITE(6,*)'VECTU long: ',NDDL
C          DO 446 LI=1,NDDL
C           WRITE(6,*)' ',ZR(IVECTU-1+LI)
C 446      CONTINUE

        END IF

      ELSEIF (NDIM .EQ. 3) THEN

C - LOIS DE COMPORTEMENT ECRITE EN CONFIGURATION ACTUELLE
C                          COMP_INCR

C
C ATTENTION : LE FONCTIONNEMENT DE NMTSTM AVEC 'SIMO_MIEHE' A CHANGE
C             C'EST LA MATRICE NON SYMETRIQUE QUI EST UTILISEE
C
       CALL UTMESS('F','TE0539','COMP_INCR NON DISPONIBLE POUR LES '//
     &                            'ELEMENTS ENRICHIS AVEC X-FEM.')

C      PETITES DEFORMATIONS (AVEC EVENTUELLEMENT REACTUALISATION)
        IF (ZK16(ICOMPO+2) (1:5).EQ.'PETIT') THEN
          IF (ZK16(ICOMPO+2) (6:10).EQ.'_REAC') THEN
            DO 20 I = 1,3*NNO
              ZR(IGEOM+I-1) = ZR(IGEOM+I-1) + ZR(IDEPLM+I-1) +
     &                        ZR(IDEPLP+I-1)
   20       CONTINUE
          END IF
          CALL NMPL3D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,PHASM,PHASP,
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(IDEFAM),ZR(IDEFAP),DEFANE,
     &                ZR(ICONTM),ZR(IVARIM),
     &                MATSYM,DFDI,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)


C      GRANDES DEFORMATIONS : FORMULATION SIMO - MIEHE

        ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
          CALL NMGP3D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,PHASM,PHASP,
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                DFDI,DFDI2,
     &                ZR(ICONTP),ZR(IVARIP),MATNS,ZR(IVECTU),CODRET)

C        SYMETRISATION DE MATNS DANS MATUU
          IF (OPTION(1:10).EQ.'RIGI_MECA_' .OR.
     &        OPTION(1:9).EQ.'FULL_MECA') THEN
            NDDL = 3*NNO
            KK = 0
            DO 40 NI = 1,NDDL
              DO 30 MJ = 1,NI
                ZR(IMATUU+KK) = (MATNS((NI-1)*NDDL+MJ)+
     &                          MATNS((MJ-1)*NDDL+NI))/2.D0
                KK = KK + 1
   30         CONTINUE
   40       CONTINUE
          END IF

C 7.3 - GRANDES ROTATIONS ET PETITES DEFORMATIONS
        ELSE IF (ZK16(ICOMPO+2) (1:5).EQ.'GREEN') THEN

          DO 50 LI = 1,3*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   50     CONTINUE

          CALL NMGR3D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),
     &                ZK16(ICOMPO),LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,PHASM,PHASP,
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(IDEFAM),ZR(IDEFAP),DEFANE,
     &                ZR(ICONTM),ZR(IVARIM),
     &                DFDI,PFF,DEF,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)
        ELSE
          CALL UTMESS('F','TE0539','COMPORTEMENT:'//ZK16(ICOMPO+2)//
     &                'NON IMPLANTE')
        END IF

      ELSE
       CALL UTMESS('F','TE0539','COMP_INCR NON DISPONIBLE POUR LES '//
     &                            'ELEMENTS ENRICHIS AVEC X-FEM.')


C PARTIE 2D
C - HYPO-ELASTICITE

        IF (ZK16(ICOMPO+2) (6:10).EQ.'_REAC') THEN
CCDIR$ IVDEP
          DO 25 I = 1,2*NNO
            ZR(IGEOM+I-1) = ZR(IGEOM+I-1) + ZR(IDEPLM+I-1) +
     &                      ZR(IDEPLP+I-1)
  25     CONTINUE
        END IF

        IF (ZK16(ICOMPO+2) (1:5).EQ.'PETIT') THEN

C -       ELEMENT A DISCONTINUITE INTERNE
          IF (TYPMOD(2).EQ.'ELEMDISC') THEN

            CALL NMED2D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                  ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                  LGPG,ZR(ICARCR),
     &                  ZR(IDEPLM),ZR(IDEPLP),
     &                  ZR(ICONTM),ZR(IVARIM),VECT1,
     &                  VECT3,ZR(ICONTP),ZR(IVARIP),
     &                  ZR(IMATUU),ZR(IVECTU),CODRET)

          ELSE

            CALL NMPL2D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                  ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                  LGPG,ZR(ICARCR),
     &                  ZR(IINSTM),ZR(IINSTP),
     &                  ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                  ZR(IHYDRM),ZR(IHYDRP),
     &                  ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                  NZ,PHASM,PHASP,
     &                  ZR(IDEPLM),ZR(IDEPLP),ZR(IDEFAM),ZR(IDEFAP),
     &                  DEFANE,
     &                  ANGMAS,
     &                  ZR(ICONTM),ZR(IVARIM),MATSYM,VECT1,
     &                  VECT3,ZR(ICONTP),ZR(IVARIP),
     &                  ZR(IMATUU),ZR(IVECTU),CODRET)

          ENDIF

C      GRANDES DEFORMATIONS : FORMULATION SIMO - MIEHE

        ELSE IF (ZK16(ICOMPO+2) (1:10).EQ.'SIMO_MIEHE') THEN
          CALL NMGP2D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,PHASM,PHASP,
     &                ZR(IDEPLM),ZR(IDEPLP),
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                VECT1,VECT2,ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)


C 7.3 - GRANDES ROTATIONS ET PETITES DEFORMATIONS
        ELSE IF (ZK16(ICOMPO+2) .EQ.'GREEN') THEN

          DO 45 LI = 1,2*NNO
            ZR(IDEPLP+LI-1) = ZR(IDEPLM+LI-1) + ZR(IDEPLP+LI-1)
   45     CONTINUE

          CALL NMGR2D(NNO,NPG,IPOIDS,IVF,IDFDE,
     &                ZR(IGEOM),TYPMOD,OPTION,ZI(IMATE),ZK16(ICOMPO),
     &                LGPG,ZR(ICARCR),
     &                ZR(IINSTM),ZR(IINSTP),
     &                ZR(ITEMPM),ZR(ITEMPP),ZR(ITREF),
     &                ZR(IHYDRM),ZR(IHYDRP),
     &                ZR(ISECHM),ZR(ISECHP),ZR(ISREF),
     &                NZ,PHASM,PHASP,
     &                ZR(IDEPLM),ZR(IDEPLP),ZR(IDEFAM),ZR(IDEFAP),
     &                DEFANE,
     &                ANGMAS,
     &                ZR(ICONTM),ZR(IVARIM),
     &                VECT1,VECT2,VECT3,
     &                ZR(ICONTP),ZR(IVARIP),
     &                ZR(IMATUU),ZR(IVECTU),CODRET)
        ELSE
          CALL UTMESS('F','TE0539','COMPORTEMENT:'//ZK16(ICOMPO+2)//
     &                'NON IMPLANTE')
        END IF

      END IF

      IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PCODRET','E',JCRET)
        ZI(JCRET) = CODRET
      END IF

      END
