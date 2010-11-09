      SUBROUTINE W175CA(MODELE,CARELE,CHFER1,CHEFGE,CHFER2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
      IMPLICIT NONE
      CHARACTER*8 MODELE,CARELE
      CHARACTER*19 CHFER1,CHFER2,CHEFGE

C ----------------------------------------------------------------------
C     CALCUL DE L'OPTION CALC_FERRAILLAGE

C IN  MODELE  : NOM DU MODELE
C IN  CARELE  : CARACTERISTIQUES COQUES
C IN  CHFER1  : CHAMP DE FER1_R
C IN  CHEFGE  : CHAMP DE EFGE_ELNO_DEPL
C OUT CHFER2  : RESULTAT DU CALCUL DE CALC_FERRAILLAGE

      CHARACTER*8 LPAIN(5),LPAOUT(1)
      CHARACTER*8 K8BID,REPK
      CHARACTER*16 OPTION
      CHARACTER*19 CHCARA(18)
      CHARACTER*19 LIGRMO,LCHIN(15),LCHOUT(1)
      LOGICAL EXICAR

      LIGRMO = MODELE//'.MODELE'
      OPTION = 'CALC_FERRAILLAGE'

      CALL MECARA(CARELE,EXICAR,CHCARA)

      LPAIN(1) = 'PCACOQU'
      LCHIN(1) = CHCARA(7)
      LPAIN(2) = 'PFERRA1'
      LCHIN(2) = CHFER1
      LPAIN(3) = 'PEFFORR'
      LCHIN(3) = CHEFGE


      LPAOUT(1) = 'PFERRA2'
      LCHOUT(1) = CHFER2

      CALL CALCUL('S',OPTION,LIGRMO,3,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'G',
     &               'OUI')

      END
