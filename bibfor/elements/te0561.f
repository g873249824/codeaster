      SUBROUTINE TE0561(OPTION,NOMTE)
C            
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/02/2011   AUTEUR FLEJOU J-L.FLEJOU 
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
C
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES FORCES NODALES
C                          POUR ELEMENTS NON LOCAUX  GVNO
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      CHARACTER*8 TYPMOD(2),NOMAIL,ELREFE,ELREF2
      INTEGER NNO,NNOB,NPG,IMATUU,LGPG,LGPG1,LGPG2
      INTEGER IW,IVF,IDFDE,IGEOM,IMATE,ICOREF
      INTEGER IVFB,IDFDEB,NNOS,JGANO,JGANOB
      INTEGER ITREF,ICONTM,IVARIM
      INTEGER IDPLGM,IDDPLG
      INTEGER IVECTU,ICONTP,IVARIP,IINSTM,IINSTP
      INTEGER IVARIX,IFORC
      INTEGER JTAB(7),IADZI,IAZK24,JCRET
      INTEGER NDIM,IRET
      LOGICAL LTEATT

      CHARACTER*16 NOMELT
      COMMON /FFAUTO/ NOMELT
      
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C



      NOMELT = NOMTE

      CALL ELREFV(NOMELT,'RIGI',NDIM,NNO,NNOB,NNOS,NPG,IW,IVF,IVFB,
     &            IDFDE,IDFDEB,JGANO,JGANOB)

   
C - TYPE DE MODELISATION

      IF (LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS    '
      ELSE IF (LTEATT(' ','D_PLAN','OUI')) THEN
        TYPMOD(1) = 'D_PLAN  '
      ELSE IF (NOMTE(1:4).EQ.'MNVG') THEN
        TYPMOD(1) = '3D      '
      ELSE
C       NOM D'ELEMENT ILLICITE
        CALL ASSERT(NOMTE(1:4).EQ.'MNVG')
      END IF

      TYPMOD(2) = 'GDVARINO'

C      CALL JEVECH('PDEPLMR','L',IDPLGM)
C      CALL JEVECH('PDEPLPR','L',IDDPLG)

      IF (OPTION.EQ.'FORC_NODA') THEN
      
        CALL JEVECH('PGEOMER','L',IGEOM)
        CALL JEVECH('PCONTMR','L',ICONTM)
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PDEPLMR','L',IDPLGM)
        CALL JEVECH('PVECTUR','E',IVECTU)       

        CALL NMFOGN(NDIM,NNO,NNOB,NPG,IW,ZR(IVF),ZR(IVFB),
     &    IDFDE,IDFDEB,ZR(IGEOM),TYPMOD,
     &    ZI(IMATE),ZR(IDPLGM),
     &    ZR(ICONTM),ZR(IVECTU))

      ENDIF


      IF (OPTION.EQ.'REFE_FORC_NODA') THEN
      
        CALL JEVECH('PMATERC','L',IMATE)
        CALL JEVECH('PGEOMER','L',IGEOM)
        CALL JEVECH('PREFCO' ,'L',ICOREF)
        CALL JEVECH('PVECTUR','E',IVECTU)       

        CALL NMFORN(NDIM,NNO,NNOB,NPG,IW,ZR(IVF),ZR(IVFB),
     &    IDFDE,ZI(IMATE),IDFDEB,ZR(IGEOM),TYPMOD,
     &    ZR(ICOREF),ZR(IVECTU))
      END IF      



      END
