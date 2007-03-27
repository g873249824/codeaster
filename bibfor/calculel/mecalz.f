      SUBROUTINE MECALZ(OPTION,CHAMGD,CHGEOM,CHMATE,CHVARC,CHVREF,
     &                  CHTIME,CHARGE,CHELEM,LIGREL,BASE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) OPTION,CHGEOM,CHMATE
      CHARACTER*(*) CHVARC,CHVREF,CHTIME,CHAMGD(*)
      CHARACTER*(*) CHARGE,LIGREL,BASE,CHELEM(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_21
C     - FONCTION REALISEE : APPEL A "CALCUL" - OPTIONS METHODE ZAC
C                           CALCUL DU ALPHA0
C                           PROJECTION DU ALPHA ZERO
C                           CHARGEMENT DEFORM. INITIALES
C                           AMPLITUDES CONTRAINTES - DEFORMATIONS
C ----------------------------------------------------------------------
C IN  : OPTION  : OPTION DE CALCUL
C IN  : MODELE  : NOM DU MODELE
C IN  : CHAMGDX : NOM DES CHAMPS DE GRANDEUR DONNES
C IN  : CH...   : NOM DES CHAMPS ...
C IN  : CHARGE  : NOM D'UNE CHARGE
C IN  : BASE    : BASE OU EST CREE LE CHAMELEM
C OUT : CHELEMX : CHAMELEMS RESULTAT
C ----------------------------------------------------------------------
      CHARACTER*8 K8B,LPAIN(10),LPAOUT(10)
      CHARACTER*16 OPTIO2
      CHARACTER*1 BASE2
      CHARACTER*24 LCHIN(10),LCHOUT(10)
      CHARACTER*24 VALK
C DEB-------------------------------------------------------------------

      BASE2 = BASE
      OPTIO2 = OPTION

      IF (OPTIO2.EQ.'ALPH_ELGA_ZAC') THEN

        LPAOUT(1) = 'PALPHAR'
        LCHOUT(1) = CHELEM(1)

        LPAIN(1) = 'PDEPLAP'
        LCHIN(1) = CHAMGD(1)
        LPAIN(2) = 'PDEPLAE'
        LCHIN(2) = CHAMGD(2)
        LPAIN(3) = 'PCONTRP'
        LCHIN(3) = CHAMGD(3)
        LPAIN(4) = 'PGEOMER'
        LCHIN(4) = CHGEOM
        LPAIN(5) = 'PMATERC'
        LCHIN(5) = CHMATE
        LPAIN(6) = 'PVARCPR'
        LCHIN(6) = CHVARC
        LPAIN(7) = 'PVARCRR'
        LCHIN(7) = CHVREF

        NBOUT = 1
        NBIN = 7

      ELSE IF (OPTIO2.EQ.'PROJ_ALPH_ZAC') THEN

        LPAOUT(1) = 'PALPHAL'
        LCHOUT(1) = CHELEM(1)
        LPAOUT(2) = 'PALPHAI'
        LCHOUT(2) = CHELEM(2)
        LPAOUT(3) = 'PALPHAS'
        LCHOUT(3) = CHELEM(3)
        LPAOUT(4) = 'PADAPTI'
        LCHOUT(4) = CHELEM(4)
        LPAOUT(5) = 'PALPHA1'
        LCHOUT(5) = CHELEM(5)

        LPAIN(1) = 'PALPHA0'
        LCHIN(1) = CHAMGD(1)
        LPAIN(2) = 'PCONTMR'
        LCHIN(2) = CHAMGD(2)
        LPAIN(3) = 'PCONTPR'
        LCHIN(3) = CHAMGD(3)
        LPAIN(4) = 'PGEOMER'
        LCHIN(4) = CHGEOM
        LPAIN(5) = 'PMATERC'
        LCHIN(5) = CHMATE
        LPAIN(6) = 'PTEMPER'
        LCHIN(6) = CHVARC
        LPAIN(7) = 'PTEMPSR'
        LCHIN(7) = CHTIME

        NBOUT = 5
        NBIN = 7

      ELSE IF (OPTIO2.EQ.'CHAR_ALPH_ZAC') THEN

        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) = CHELEM(1)

        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PVARCPR'
        LCHIN(2) = CHVARC
        LPAIN(3) = 'PALPHAR'
        LCHIN(3) = CHAMGD(1)
        LPAIN(4) = 'PMATERC'
        LCHIN(4) = CHMATE

        NBOUT = 1
        NBIN = 4

      ELSE IF (OPTIO2.EQ.'AMPL_ELNO_ZAC') THEN

        LPAOUT(1) = 'PCONTZR'
        LCHOUT(1) = CHELEM(1)
        LPAOUT(2) = 'PDEFOZR'
        LCHOUT(2) = CHELEM(2)
        LPAOUT(3) = 'PALPHAP'
        LCHOUT(3) = CHELEM(3)

        LPAIN(1) = 'PMATERC'
        LCHIN(1) = CHMATE
        LPAIN(2) = 'PGEOMER'
        LCHIN(2) = CHGEOM
        LPAIN(3) = 'PTEMPER'
        LCHIN(3) = CHVARC
        LPAIN(4) = 'PALPHAR'
        LCHIN(4) = CHAMGD(2)
        LPAIN(5) = 'PDEPLAR'
        LCHIN(5) = CHAMGD(1)
        LPAIN(6) = 'PCONTMR'
        LCHIN(6) = CHAMGD(3)
        LPAIN(7) = 'PCONTPR'
        LCHIN(7) = CHAMGD(4)
        LPAIN(8) = 'PTEMPSR'
        LCHIN(8) = CHTIME

        NBOUT = 3
        NBIN = 8

      ELSE
        VALK = OPTIO2
        CALL U2MESG('F', 'CALCULEL6_11',1,VALK,0,0,0,0.D0)
      END IF

      CALL CALCUL('S',OPTIO2,LIGREL,NBIN,LCHIN,LPAIN,NBOUT,LCHOUT,
     &            LPAOUT,BASE2)


      END
