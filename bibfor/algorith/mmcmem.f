      SUBROUTINE MMCMEM(MODELE,DEPMOI,DEPDEL,LIGREL,CARCON,MCONEL,
     &                  SCONEL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8 MCONEL
      CHARACTER*8 SCONEL
      CHARACTER*19 CARCON,LIGREL
      CHARACTER*24 DEPMOI,DEPDEL,MODELE
C ----------------------------------------------------------------------
C     CALCUL DES MATRICES ELEMENTAIRES DES ELEMENTS DE CONTACT
C              ET DES SECONDS MEMBRES DE TYPE CONTACT FROTTANT

C IN/JXIN  LIGREL : NOM DE LIGREL (DES ELEMENTS DE CONTACT MALEK)
C IN/JXIN  CARCON  : NOM DE LA CARTE CONTENANT LES INFORMATIONS
C DE CONTACT
C IN  TYPCAL : CONTACT /FROTTEMENT /CONTFROT

C IN/JXIN  DEPMOI : DEPLACEMENT A L'INSTANT PRECEDENT
C IN/JXIN  DEPDEL : DEPLACEMENT COURANT A L'ITERATION DE NEWTON
C IN/JXOUT MCONEL : MATR_ELEM : MATRICES ELEMENTAIRES
C IN/JXOUT SCONEL : VECT_ELEM : S M ELEMENTAIRES

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL,EXIGEO
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)


C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*8 NOMCHA,LPAIN(4),LPAOUT,MATEL,K8BID
      CHARACTER*19 CHGEOM,LCHIN(4),LCHOUT
      INTEGER IRET,JLIRES

      CALL JEMARQ()


C     0.1 : ON DETRUIT MCONEL ET SCONEL S'ILS EXISTENT
C     ------------------------------------------------
      CALL DETRSD('MATR_ELEM',MCONEL)
      CALL DETRSD('VECT_ELEM',SCONEL)


C     0.2 : RECUPERATION DE LA GEOMETRIE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)

C CREATION DES LISTES DES CHAMPS IN ET OUT

C LA GEOMETRIE,LES DEPLACEMENTS

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PDEPL_M'
      LCHIN(2) = DEPMOI
      LPAIN(3) = 'PDEPL_P'
      LCHIN(3) = DEPDEL
      LPAIN(4) = 'PCONFR'
      LCHIN(4) = CARCON

C     1. CALCUL DE MCONEL :
C     --------------------
      LPAOUT = 'PMATUUR'

      CALL MEMARE('V',MCONEL(1:8),MODELE,' ',' ','RIGI_MECA')
      CALL WKVECT(MCONEL(1:8)//'.LISTE_RESU','V V K24',2,JLIRES)


      LCHOUT = MCONEL(1:8)//'.ME001'
      CALL CALCUL('S','RIGI_CONT',LIGREL,4,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &            'V')
      ZK24(JLIRES-1+1) = LCHOUT
      LCHOUT = MCONEL(1:8)//'.ME002'
      CALL CALCUL('S','RIGI_FROT',LIGREL,4,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &            'V')
      ZK24(JLIRES-1+2) = LCHOUT
      CALL JEECRA(MCONEL(1:8)//'.LISTE_RESU','LONUTI',2,K8BID)



C      2. CALCUL DE SCONEL :
C      -----------------------
      LPAOUT = 'PVECTUR'

      CALL MEMARE('V',SCONEL,MODELE,' ',' ','CHAR_MECA')
      CALL WKVECT(SCONEL//'.LISTE_RESU','V V K24',2,JLIRES)


      LCHOUT = SCONEL//'.VE001'
      CALL CALCUL('S','CHAR_MECA_CONT',LIGREL,4,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V')
      ZK24(JLIRES-1+1) = LCHOUT
      LCHOUT = SCONEL//'.VE002'
      CALL CALCUL('S','CHAR_MECA_FROT',LIGREL,4,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V')
      ZK24(JLIRES-1+2) = LCHOUT
      CALL JEECRA(SCONEL//'.LISTE_RESU','LONUTI',2,K8BID)


   10 CONTINUE
C FIN ------------------------------------------------------------------

      CALL JEDEMA()
      END
