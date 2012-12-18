      SUBROUTINE TE0206(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/12/2012   AUTEUR LAVERNE J.LAVERNE 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C ======================================================================
C COPYRIGHT (C) 2007 NECS - BRUNO ZUBER   WWW.NECS.FR
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

      CHARACTER*16       NOMTE, OPTION

C ----------------------------------------------------------------------
C       OPTIONS NON LINEAIRES DES ELEMENTS DE FISSURE JOINT 3D
C       OPTIONS : FULL_MECA, FULL_MECA_ELAS, RAPH_MECA,
C                 RIGI_MECA_ELAS, RIGI_MECA_TANG
C ----------------------------------------------------------------------


      INTEGER NDIM,NNO,NNOS,NPG,NDDL
      INTEGER IPOIDS,IVF,IDFDE,JGANO
      INTEGER IGEOM, IMATER, ICARCR, ICOMP, IDEPM, IDDEP,ICORET
      INTEGER ICONTM, ICONTP, IVECT, IMATR
      INTEGER IVARIM ,IVARIP, JTAB(7),IRET,LGPG,IINSTM,IINSTP
C     COORDONNEES POINT DE GAUSS + POIDS : X,Y,Z,W => 1ER INDICE
      REAL*8  COOPG(4,4)
      LOGICAL RESI,RIGI,MATSYM
C ----------------------------------------------------------------------

      RESI = OPTION.EQ.'RAPH_MECA'      .OR. OPTION(1:9).EQ.'FULL_MECA'
      RIGI = OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION(1:9).EQ.'RIGI_MECA'

C -  FONCTIONS DE FORMES ET POINTS DE GAUSS : ATTENTION CELA CORRESPOND
C    ICI AUX FONCTIONS DE FORMES 2D DES FACES DES MAILLES JOINT 3D
C    PAR EXEMPLE FONCTION DE FORME DU QUAD4 POUR LES HEXA8.

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      NDDL = 6*NNO

      IF (NNO.GT.4) CALL U2MESS('F','ELEMENTS5_22')
      IF (NPG.GT.4) CALL U2MESS('F','ELEMENTS5_23')

C - LECTURE DES PARAMETRES
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATER)
      CALL JEVECH('PCARCRI','L',ICARCR)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PDEPLMR','L',IDEPM)
      CALL JEVECH('PVARIMR','L',IVARIM)
      CALL JEVECH('PCONTMR','L',ICONTM)

C - INSTANTS
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)

C     CALCUL DES COORDONNEES DES POINTS DE GAUSS, POIDS=0
      CALL GEDISC(3,NNO,NPG,ZR(IVF),ZR(IGEOM),COOPG)

C     RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS
      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)

      IF (RESI) THEN
        CALL JEVECH('PDEPLPR','L',IDDEP)
        CALL JEVECH('PVARIPR','E',IVARIP)
        CALL JEVECH('PCONTPR','E',ICONTP)
        CALL JEVECH('PVECTUR','E',IVECT)
        CALL JEVECH('PCODRET','E',ICORET)
      ELSE
        IDDEP=1
        IVARIP=1
        ICONTP=1
        IVECT=1
        ICORET=1
      ENDIF

      IF (RIGI) THEN

        IF (ZK16(ICOMP)(1:15).EQ.'JOINT_MECA_RUPT'.OR.
     &      ZK16(ICOMP)(1:15).EQ.'JOINT_MECA_FROT') THEN
          MATSYM = .FALSE.
          CALL JEVECH('PMATUNS','E',IMATR)
        ELSE
          MATSYM = .TRUE.
          CALL JEVECH('PMATUUR','E',IMATR)
        ENDIF
      ELSE
        IMATR=1
      ENDIF

      CALL NMFI3D(NNO,NDDL,NPG,LGPG,ZR(IPOIDS),ZR(IVF),ZR(IDFDE),
     &            ZI(IMATER),OPTION,ZR(IGEOM),ZR(IDEPM),
     &            ZR(IDDEP),ZR(ICONTM),ZR(ICONTP),ZR(IVECT),ZR(IMATR),
     &            ZR(IVARIM),ZR(IVARIP),ZR(ICARCR),
     &            ZK16(ICOMP),MATSYM,COOPG,ZR(IINSTM),ZR(IINSTP),
     &            ZI(ICORET))

      END
