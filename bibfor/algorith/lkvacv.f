      SUBROUTINE LKVACV(NBMAT, MATER, PARAVI, VARVI)
C
      IMPLICIT      NONE
      INTEGER       NBMAT
      REAL*8        PARAVI(3), MATER(NBMAT,2), VARVI(4)
C ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C ================================================================
C --- MODELE LETK : LAIGLE VISCOPLASTIQUE-------------------------
C ================================================================
C --- BUT : CALCUL DES VARIABLES D'ECROUISSAGE CRITERE VISQUEUX --
C ================================================================
C IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------
C --- : MATER  : PARAMETRES DU MODELE ----------------------------
C     : PARAVI : VARIABLE D'ECROUISSAGE VISQUEUSE ----------------
C ------------ : PARAVI(1)=AXIV ----------------------------------
C ------------ : PARAVI(2)=SXIV ----------------------------------
C ------------ : PARAVI(3)=MXIV ----------------------------------
C OUT : VARVI  : AVXIV, BVXIV, DVXIV ----------------------------
C ================================================================
      REAL*8  SIGC, GAMCJS, H0C
      REAL*8   AVXIV, BVXIV, KVXIV, DVXIV
      REAL*8  UN, DEUX, TROIS, SIX
C ================================================================
C --- INITIALISATION DE PARAMETRES -------------------------------
C ================================================================
      PARAMETER       ( UN     =  1.0D0   )
      PARAMETER       ( DEUX   =  2.0D0   )
      PARAMETER       ( TROIS  =  3.0D0   )
      PARAMETER       ( SIX    =  6.0D0   )
C ================================================================
C --- RECUPERATION DE PARAMETRES DU MODELE -----------------------
C ================================================================
      SIGC   = MATER(3,2)
      GAMCJS = MATER(5,2)
C ================================================================
C---- CALCUL DE Kd(XIP)-------------------------------------------
C ================================================================
      KVXIV = (DEUX/TROIS)**(UN/DEUX/PARAVI(1))
C ================================================================
C---- CALCUL DE Ad(XIP)-------------------------------------------
C ================================================================
      H0C   = (UN - GAMCJS)**(UN/SIX)
      AVXIV = -PARAVI(3) * KVXIV/SQRT(SIX)/SIGC/H0C
C ================================================================
C---- CALCUL DE Bd(XIP)-------------------------------------------
C ================================================================
      BVXIV = PARAVI(3) * KVXIV/TROIS/SIGC
C ================================================================
C---- CALCUL DE Dd(XIP)-------------------------------------------
C ================================================================
      DVXIV = PARAVI(2) * KVXIV
C ================================================================
C --- STOCKAGE ---------------------------------------------------
C ================================================================
      VARVI(1) = AVXIV
      VARVI(2) = BVXIV
      VARVI(3) = DVXIV
      VARVI(4) = KVXIV
C ================================================================
      END
