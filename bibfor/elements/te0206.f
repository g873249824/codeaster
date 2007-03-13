      SUBROUTINE TE0206(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/03/2007   AUTEUR LAVERNE J.LAVERNE 
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
      CHARACTER*16       NOMTE, OPTION
      
C ----------------------------------------------------------------------
C       OPTIONS NON LINEAIRES DES ELEMENTS DE FISSURE JOINT 3D
C       OPTIONS : FULL_MECA, FULL_MECA_ELAS, RAPH_MECA, 
C                 RIGI_MECA_ELAS, RIGI_MECA_TANG
C ----------------------------------------------------------------------

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

      INTEGER NDIM,NNO,NNOS,NPG,NDDL
      INTEGER IPOIDS,IVF,IDFDE,JGANO
      INTEGER IGEOM, IMATER, ICARCR, ICOMP, IDEPM, IDDEP,ICORET
      INTEGER ICONT, IVECT, IMATR
      INTEGER IVARIM ,IVARIP, JTAB(7),IRET,LGPG,ITEMPM,ITEMPP
C ----------------------------------------------------------------------


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
      CALL JEVECH('PTEMPMR','L',ITEMPM)
      CALL JEVECH('PTEMPPR','L',ITEMPP)


C    RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS
      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)
      
      IF (OPTION.EQ.'RAPH_MECA' .OR. OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PDEPLPR','L',IDDEP) 
        CALL JEVECH('PVARIPR','E',IVARIP)  
        CALL JEVECH('PCONTPR','E',ICONT)
        CALL JEVECH('PVECTUR','E',IVECT)
        CALL JEVECH('PCODRET','E',ICORET)
      ENDIF
      
      IF (OPTION(1:9).EQ.'RIGI_MECA'.OR.OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL JEVECH('PMATUNS','E',IMATR)
      ENDIF


      CALL NMFI3D(NNO,NDDL,NPG,LGPG,ZR(IPOIDS),ZR(IVF),ZR(IDFDE),
     &            ZI(IMATER),OPTION,ZR(IGEOM),ZR(IDEPM),
     &            ZR(IDDEP),ZR(ICONT),ZR(IVECT),ZR(IMATR),
     &            ZR(IVARIM),ZR(IVARIP),ZR(ICARCR),
     &            ZK16(ICOMP),ZR(ITEMPM),ZR(ITEMPP),ZI(ICORET))
                                
      END
