      SUBROUTINE MENOGA(OPTION,MODELE,COMPOR,CHAIN,CHAOUT,CARELE)
C MODIF CALCULEL  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*24 COMPOR,CARELE
      CHARACTER*16 OPTION
      CHARACTER*24 MODELE
      CHARACTER*(*) CHAIN,CHAOUT
C ----------------------------------------------------------------------
C     PASSAGE D'UN CHAMELEM DES NOEUDS AUX POINTS DE GAUSS

C IN  OPTION : OPTION DE CALCUL
C IN  MODELE : NOM DU MODELE
C IN  CHAIN  : CHAMELEM EN ENTREE
C IN  CARELE : CARACTERISTIQUES ELEMENTAIRES

C OUT CHAOUT : CHAMELEM EN SORTIE

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

      INTEGER NBC
      CHARACTER*8 LPAIN(7),LPAOUT(1)
      CHARACTER*24 CHIN,CHOUT,LCHIN(7),LCHOUT(1),LIGRMO

      CALL JEMARQ()
      IF (MODELE(1:1).EQ.' ') THEN
        CALL UTMESS('F','MENOGA_01','IL MANQUE LE MODELE')
      END IF

      LCHOUT(1) = CHAOUT
      LCHIN(1) = CHAIN
      LIGRMO = MODELE(1:8)//'.MODELE'
      NBC = 1

      IF (OPTION.EQ.'SIEF_ELGA_ELNO  ') THEN
        LPAOUT(1) = 'PSIEFGR'
        LPAIN(1) = 'PCONTRR'
        NBC = 1
      ELSE IF (OPTION.EQ.'VARI_ELGA_ELNO  ') THEN
        NBC = 2
        LPAOUT(1) = 'PVARIGR'
        LPAIN(1) = 'PVARINR'
        LPAIN(2) = 'PCOMPOR'
        LCHIN(2) = COMPOR

        CALL EXISD('CHAM_ELEM_S',COMPOR,IRET)
        IF (IRET.EQ.0) CALL CESVAR(CARELE,COMPOR,LIGRMO,COMPOR)
        CALL COPISD('CHAM_ELEM_S','V',COMPOR,LCHOUT(1))
      ELSE
        CALL UTDEBM('F','MENOGA_02',' ')
        CALL UTIMPK('S','OPTION INCONNUE',1,OPTION)
        CALL UTFINM()
      END IF

      CALL CALCUL('S',OPTION,LIGRMO,NBC,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
      CALL DETRSD('CHAM_ELEM_S',LCHOUT(1))

   10 CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
