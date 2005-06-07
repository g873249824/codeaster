      SUBROUTINE GGDTET ( GDTETZ, THETAZ, MODELZ )
      IMPLICIT NONE
      CHARACTER*(*)       GDTETZ, THETAZ, MODELZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/12/2003   AUTEUR CIBHHLV L.VIVAN 
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
C.======================================================================
C     GGDTET  -- CALCUL DU CHAMP AUX NOEUDS DES GRADIENTS DU
C                CHAMNO THETA.
C                CE CHAMP CORRESPOND A L'OPTION GRAD_NOEU_DEPL
C                POUR CALCULER CE CHAMNO , ON CALCULE :
C                .D'ABORD LE CHAMELEM ISSU DE L'OPTION
C                 GRAD_ELGA_THETA
C                .PUIS LE CHAMELEM VENANT DES GTHE_ELNO_ELGA
C                .PUIS LE CHAMNO DES GRAD_NOEU_DEPL
C                LES 2 CHAMELEMS SONT CALCULES SUR LA BASE VOLATILE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    GDTETZ         OUT    K*     NOM DU CHAMNO DES GRADIENTS DE THETA
C    THETAZ          IN    K*     NOM DU CHAMNO DE THETA
C    MODELZ          IN    K*     NOM DU MODELE SUR LEQUEL A ETE CREE
C                                 THETA
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER       IBID, IER, NBIN
      LOGICAL       EXIGEO
      CHARACTER*8   MODELE
      CHARACTER*8   LPAIN(2), LPAOUT(1)
      CHARACTER*19  GDTETA, THETA, LIGREL, CHAMS0, CHAMS1
      CHARACTER*24  CHGEOM, LCHIN(2), LCHOUT(1)
C.========================= DEBUT DU CODE EXECUTABLE ==================

      CALL JEMARQ()

C --- INITIALISATIONS :
C     ---------------
      GDTETA = GDTETZ
      THETA = THETAZ
      MODELE = MODELZ

C --- CONSTRUCTION DU CHAMP CONTENANT LES COORDONNEES DES CONNECTIVITES:
C     -----------------------------------------------------------------
      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)

C --- RECUPERATION DU LIGREL DU MODELE :
C     --------------------------------
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGREL,IER)

C =================================================================
C --- CALCUL DU CHAMELEM DES GTHE_ELNO_ELGA DU CHAMP THETA SUR    =
C --- LA BASE VOLATILE                                            =
C =================================================================
      LPAIN(1) = 'PTHETAR'
      LCHIN(1) = THETA
      LPAIN(2) = 'PGEOMER'
      LCHIN(2) = CHGEOM
      LPAOUT(1) = 'PGRADUR'
      LCHOUT(1) = '&&GRAD_THETA_NO'
      NBIN = 2
      CALL CALCUL('S','GTHE_ELNO_ELGA',LIGREL,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V')

C =================================================================
C --- CALCUL DU CHAMNO DES GRAD_NOEU_THETA DU CHAMP THETA SUR     =
C --- LA BASE GLOBALE                                             =
C =================================================================
      CHAMS0 = '&&GGDTET.CHAMS0'
      CHAMS1 = '&&GGDTET.CHAMS1'
      CALL CELCES ( '&&GRAD_THETA_NO', 'V', CHAMS0 )
      CALL CESCNS ( CHAMS0, ' ', 'V', CHAMS1 )
      CALL CNSCNO ( CHAMS1, ' ', 'G', GDTETA )
      CALL DETRSD ( 'CHAM_ELEM_S', CHAMS0 )
      CALL DETRSD ( 'CHAM_NO_S'  , CHAMS1 )

C --- DESTRUCTION DES CHAMELEMS DE TRAVAIL SUR LA VOLATILE :
C     ----------------------------------------------------
      CALL JEDETC('V','&&GRAD_THETA_NO',1)

      CALL JEDEMA()
      END
