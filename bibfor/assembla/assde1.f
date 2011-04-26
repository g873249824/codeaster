      SUBROUTINE ASSDE1(CHAMP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) CHAMP
C ----------------------------------------------------------------------
C     IN:
C       NOMU   : NOM D'UN CONCEPT DE TYPE
C                    CHAMP_GD(K19)

C     RESULTAT:
C     ON DETRUIT TOUS LES OBJETS JEVEUX CORRESPONDANT A CE CONCEPT.
C ----------------------------------------------------------------------

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

      INTEGER      IRET,IDD,NBSD,IFETC,ILIMPI
      CHARACTER*5  REFE,VALE,DESC
      CHARACTER*8  K8BID
      CHARACTER*19 K19B
      CHARACTER*24 K24B
      CHARACTER*19 CHAMP2
      LOGICAL DBG
C -DEB------------------------------------------------------------------
      CHAMP2 = CHAMP

      DBG=.TRUE.
      DBG=.FALSE.
      IF (DBG) CALL CHLICI(CHAMP2,19)



C        POUR LES CARTE, CHAM_NO, CHAM_ELEM, ET RESU_ELEM :
      CALL JEDETR(CHAMP2//'.CELD')
      CALL JEDETR(CHAMP2//'.CELV')
      CALL JEDETR(CHAMP2//'.CELK')
      CALL JEDETR(CHAMP2//'.DESC')
      CALL JEDETR(CHAMP2//'.VALE')
      CALL JEDETR(CHAMP2//'.REFE')
      CALL JEDETR(CHAMP2//'.LIMA')
      CALL JEDETR(CHAMP2//'.NOMA')
      CALL JEDETR(CHAMP2//'.NOLI')
      CALL JEDETR(CHAMP2//'.RESL')
      CALL JEDETR(CHAMP2//'.RSVI')
      CALL JEDETR(CHAMP2//'.VALV')
      CALL JEDETR(CHAMP2//'.NCMP')
      CALL JEDETR(CHAMP2//'.PTMA')
      CALL JEDETR(CHAMP2//'.PTMS')

C DESTRUCTION DE LA LISTE DE CHAM_NO LOCAUX SI FETI
      K24B=CHAMP2//'.FETC'
      CALL JEEXIN(K24B,IRET)
C FETI OR NOT ?
      IF (IRET.GT.0) THEN
        DESC='.DESC'
        REFE='.REFE'
        VALE='.VALE'
        CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
        CALL JEVEUO(K24B,'L',IFETC)
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
        DO 5 IDD=1,NBSD
          IF (ZI(ILIMPI+IDD).EQ.1) THEN
            K19B=ZK24(IFETC+IDD-1)(1:19)
            CALL JEDETR(K19B//DESC)
            CALL JEDETR(K19B//REFE)
            CALL JEDETR(K19B//VALE)
          ENDIF
   5    CONTINUE
C========================================
C FIN BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
        CALL JEDETR(K24B)
      ENDIF

      END
