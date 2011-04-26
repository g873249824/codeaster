      SUBROUTINE MERGTH(MODELE,CHARGE,INFCHA,CARELE,MATE,INST,MERIGI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*24 MODELE,CHARGE,INFCHA,CARELE,INST,MERIGI,MATE
C ----------------------------------------------------------------------
C CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE THERMIQUE
C  - TERMES DE VOLUME
C  - TERMES DE SURFACE DUS AUX CONDITIONS LIMITES

C IN  MODELE  : NOM DU MODELE
C IN  CHARGE  : LISTE DES CHARGES
C IN  INFCHA  : INFORMATIONS SUR LES CHARGEMENTS
C IN  CARELE  : CHAMP DE CARA_ELEM
C IN  MATE    : CHAMP DE MATERIAU
C IN  INST    : CARTE CONTENANT LA VALEUR DE L'INSTANT
C OUT MERIGI  : MATRICES ELEMENTAIRES

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*8 NOMCHA,LPAIN(6),LPAOUT(1),K8BID
      CHARACTER*16 OPTION
      CHARACTER*24 LIGREL(2),LCHIN(6),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(18),CHHARM
      INTEGER IRET,NCHAR,ILIRES,ICHA,JCHAR,JINF
      LOGICAL EXICAR,EXIGEO
C ----------------------------------------------------------------------
      INTEGER NBCHMX
      PARAMETER (NBCHMX=2)
      INTEGER NLIGR(NBCHMX)
      CHARACTER*6 NOMPAR(NBCHMX),NOMCHP(NBCHMX),NOMOPT(NBCHMX)
      DATA NOMCHP/'.COEFH','.HECHP'/
      DATA NOMOPT/'_COEH_','_PARO_'/
      DATA NOMPAR/'PCOEFH','PHECHP'/
      DATA NLIGR/1,2/

      CALL JEMARQ()
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BID)
        CALL JEVEUO(CHARGE,'L',JCHAR)
      ELSE
        NCHAR = 0
      END IF

      CALL MEGEOM(MODELE,'       ',EXIGEO,CHGEOM)
      CALL MECARA(CARELE,EXICAR,CHCARA)

C  ON INITIALISE LE NUMERO D'HARMONIQUE A -1 POUR EMETTRE UN MESSAGE
C  FATAL S'IL Y A DES ELEMENTS DE FOURIER DANS LE MODELE

      NH = -1
      CALL MEHARM(MODELE,NH,CHHARM)

      CALL JEEXIN(MERIGI,IRET)
      IF (IRET.EQ.0) THEN
        MERIGI = '&&MERIGI           .RELR'
      CALL MEMARE('V',MERIGI(1:19),MODELE(1:8),MATE,CARELE,'RIGI_THER')
      ELSE
        CALL JEDETR(MERIGI)
      END IF
      LIGREL(1) = MODELE(1:8)//'.MODELE'

      LPAOUT(1) = 'PMATTTR'
      LCHOUT(1) = MERIGI(1:8)//'.ME001'
      ILIRES = 0

      IF (MODELE.NE.'        ') THEN
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PMATERC'
        LCHIN(2) = MATE
        LPAIN(3) = 'PCACOQU'
        LCHIN(3) = CHCARA(7)
        LPAIN(4) = 'PTEMPSR'
        LCHIN(4) = INST
        LPAIN(5) = 'PHARMON'
        LCHIN(5) = CHHARM
        LPAIN(6) = 'PCAMASS'
        LCHIN(6) = CHCARA(12)
        OPTION = 'RIGI_THER'
        ILIRES = ILIRES + 1
        CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
        CALL CALCUL('S',OPTION,LIGREL(1),6,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V','OUI')
        CALL REAJRE(MERIGI,LCHOUT(1),'V')
      END IF

      IF (NCHAR.GT.0) THEN
        CALL JEVEUO(INFCHA,'L',JINF)
        DO 20 ICHA = 1,NCHAR
          IF (ZI(JINF+NCHAR+ICHA).NE.0) THEN
            NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
            LIGREL(2) = NOMCHA//'.CHTH.LIGRE'
            LPAIN(1) = 'PGEOMER'
            LCHIN(1) = CHGEOM
            LPAIN(2) = 'PTEMPSR'
            LCHIN(2) = INST

            IF (ZI(JINF+NCHAR+ICHA).EQ.1) THEN
              OPTION = 'RIGI_THER_    _R'
              LPAIN(3) = '      R'
            ELSE
              OPTION = 'RIGI_THER_    _F'
              LPAIN(3) = '      F'
            END IF
            DO 10 K = 1,NBCHMX
              LCHIN(3) = NOMCHA//'.CHTH'//NOMCHP(K)//'.DESC'
              CALL JEEXIN(LCHIN(3),IRET3)
              IF (IRET3.GT.0) THEN
                OPTION(10:15) = NOMOPT(K)
                LPAIN(3) (1:6) = NOMPAR(K)
                ILIRES = ILIRES + 1
                CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
                CALL CALCUL('S',OPTION,LIGREL(NLIGR(K)),3,LCHIN,LPAIN,1,
     &                      LCHOUT,LPAOUT,'V','OUI')
                CALL REAJRE(MERIGI,LCHOUT(1),'V')
              END IF
   10       CONTINUE
          END IF
   20   CONTINUE

      END IF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
