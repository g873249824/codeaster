      SUBROUTINE VIEMMA(NBVARI,VINTM,VINTP,ADVICO,VICPHI,PHI0,
     +                  DP1,DP2,SIGNE,SAT,EM,PHI,PHIM,RETCOM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C --- CALCUL ET STOCKAGE DE LA VARIABLE INTERNE DE POROSITE ------------
C ======================================================================
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      INTEGER       NBVARI,ADVICO,VICPHI,RETCOM
      REAL*8        VINTM(NBVARI),VINTP(NBVARI),PHI0,EM
      REAL*8        DP1,DP2,SIGNE,SAT,PHI,PHIM
      REAL*8        DPREQ
C ======================================================================
C ======================================================================
C --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
C --- ET VERIFICATION DE SA COHERENCE ----------------------------------
C ======================================================================
      DPREQ = (DP2 - SAT*SIGNE*DP1 )
      PHIM = VINTM(ADVICO+VICPHI) + PHI0
      PHI=PHIM+DPREQ*EM
      VINTP(ADVICO+VICPHI)  =  PHI- PHI0
C ======================================================================
C ======================================================================
      END
