      SUBROUTINE ME2ZME(MODELZ,CHSIGZ,VECELZ)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
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

C     ARGUMENTS:
C     ----------
C ......................................................................
C     BUT:
C         CALCUL DE TOUS LES SECONDS MEMBRES ELEMENTAIRES PERMETTANT
C         DE CALCULER L'ESTIMATEUR D'ERREUR SUR LES CONTRAINTES

C                 OPTION : 'SECM_ZZ1'

C     ENTREES:

C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELZ : NOM DU MODELE
C        CHSIGZ : NOM DU CHAMP DE CONTRAINTES CALCULEES
C        VECELZ : NOM DU VEC_ELE (N RESUELEM) PRODUIT
C                 SI VECEL EXISTE DEJA, ON LE DETRUIT.

C     SORTIES:
C ......................................................................

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

      LOGICAL EXIGEO
      CHARACTER*8 MODELE
      CHARACTER*19 VECEL
      CHARACTER*8 LPAIN(2),LPAOUT(4)
      CHARACTER*16 OPTION
      CHARACTER*24 LCHIN(2),LCHOUT(4),LIGRMO,MOD,CHGEOM,CHSIG
      CHARACTER*(*) MODELZ,CHSIGZ,VECELZ


      CALL JEMARQ()
      MODELE = MODELZ
      CHSIG = CHSIGZ
      VECEL = VECELZ

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      IF (.NOT.EXIGEO) CALL U2MESS('F','CALCULEL2_81')

      CALL DETRSD('VECT_ELEM',VECEL)
      CALL MEMARE('V',VECEL,MODELE,' ',' ','SECM_ZZ1')

      LPAOUT(1) = 'PVECTR1'
      LPAOUT(2) = 'PVECTR2'
      LPAOUT(3) = 'PVECTR3'
      LPAOUT(4) = 'PVECTR4'
      LCHOUT(1) = '&&ME2ZME.VE001'
      LCHOUT(2) = '&&ME2ZME.VE002'
      LCHOUT(3) = '&&ME2ZME.VE003'
      LCHOUT(4) = '&&ME2ZME.VE004'
      CALL CORICH('E',LCHOUT(1),-1,IBID)
      CALL CORICH('E',LCHOUT(2),-1,IBID)
      CALL CORICH('E',LCHOUT(3),-1,IBID)
      CALL CORICH('E',LCHOUT(4),-1,IBID)
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PSIEF_R'
      LCHIN(2) = CHSIG
      LIGRMO = MODELE//'.MODELE'
      OPTION = 'SECM_ZZ1'
      CALL CALCUL('S',OPTION,LIGRMO,2,LCHIN,LPAIN,4,LCHOUT,LPAOUT,'V',
     &               'OUI')
      CALL REAJRE(VECEL,LCHOUT(1),'V')
      CALL REAJRE(VECEL,LCHOUT(2),'V')
      CALL REAJRE(VECEL,LCHOUT(3),'V')
      CALL REAJRE(VECEL,LCHOUT(4),'V')

      CALL JEDEMA()
      END
