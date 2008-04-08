      SUBROUTINE ARLASS(SIGN ,INO ,NU  ,CMP ,R   ,
     &                  ND   ,NE  ,NL  ,IMPO,MULT,
     &                  LIEL ,NEMA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      INTEGER SIGN
      INTEGER INO
      INTEGER NU(*)
      INTEGER CMP
      INTEGER ND
      INTEGER NE
      INTEGER NL
      INTEGER LIEL(2,*)
      INTEGER NEMA(4,*)
      REAL*8  R
      REAL*8  IMPO(*)
      REAL*8  MULT(6,*)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C ECRITURE D'UN TERME DANS LES RELATIONS LINEAIRES COUPLAGE
C
C ----------------------------------------------------------------------
C
C
C IN  SIGN   : SIGNE DEVANT R (0 : +, 1 : -)
C IN  INO    : NUMERO DU NOEUD
C IN  NU     : NUMERO DES ELEMENTS DE LIAISON 'D_DEPL_R_*'
C                       * = (DX, DY, DZ, DRX, DRY, DRZ)
C IN  CMP    : NUMERO DE LA COMPOSANTE (INDEX NU)
C IN  R      : VALEUR DU TERME
C I/O ND     : NOMBRE DE TERME
C I/O NE     : NUMERO DE L'EQUATION
C I/O NL     : NUMERO DU PREMIER LAGRANGE - 1
C I/O IMPO   : VECTEUR CHME.CIMPO.VALE
C I/O MULT   : VECTEUR CHME.CMULT.VALE
C I/O LIEL   : COLLECTION CHME.LIGRE.LIEL
C I/O NEMA   : COLLECTION CHME.LIGRE.NEMA
C
C ----------------------------------------------------------------------
C
      NE         = NE + 1
      LIEL(1,NE) = -NE
      LIEL(2,NE) = NU(CMP)
      NEMA(1,NE) = INO
      NEMA(2,NE) = -(NL+1)
      NEMA(3,NE) = -(NL+2)
      NEMA(4,NE) = 4
C
      ND         = ND + 1
      IMPO(ND)   = 0.D0
C
      IF (SIGN.EQ.0) THEN
        MULT(1,ND) = R
      ELSE
        MULT(1,ND) = -R
      ENDIF
C
      END
