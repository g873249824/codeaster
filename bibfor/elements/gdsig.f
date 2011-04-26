      SUBROUTINE GDSIG (FAMI,KPG,KSP,X0PG,PETIK,ROT0,ROTK,GRANC,IMATE,
     &                  GN,GM,PN,PM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C
C FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, CALCULE LE
C           TORSEUR DES EFFORTS AUX POINTS DE GAUSS, EN AXES GENERAUX.
C
C     IN  : X0PG      : DERIVEE DES COORDONNEES P./R. L'ABSCISSE CURVI.
C           PETIK     : VECTEUR-COURBURE EN AXES GENE.
C           ROT0      : MATRICE DE ROTATION DES AXES PRINCIPAUX D'INERT.
C                       AU POINT DE GAUSS DANS LA POSITION DE REFERENCE,
C                       PAR RAPPORT AUX AXES GENERAUX
C           ROTK      : MATRICE DE ROTATION ACTUELLE
C           GRANC     : DIAG. DE LA MATRICE DE COMPORTEMENT
C           ALPHA     : COEFFICIENT DE DILATATION THERMIQUE
C
C     OUT : GN        : RESULTANTE DES FORCES AU PT DE GAUSS EN AX.LOCAU
C           GM        : MOMENT RESULTANT AU PT DE GAUSS EN AXES LOCAUX
C           PN        : RESULTANTE DES FORCES AU PT DE GAUSS EN AX.GENE.
C           PM        : MOMENT RESULTANT AU PT DE GAUSS EN AXES GENERAUX
C ------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      CHARACTER*(*) FAMI
      REAL*8 X0PG(3),PETIK(3),ROT0(3,3),ROTK(3,3),GRANC(6),
     &       PN(3),PM(3),GN(3),GM(3),ROTABS(3,3),ROTABT(3,3),
     &       GRANGA(3),GRANK(3)
      INTEGER IMATE
C
      UN = 1.D0
      CALL VERIFT(FAMI,KPG,KSP,'+',IMATE,'ELAS',1,EPSTHE,IRET)
C

      CALL PROMAT (ROTK,3,3,3,ROT0,3,3,3,     ROTABS)
      CALL TRANSP (ROTABS,3,3,3,ROTABT,3)
      CALL PROMAT (ROTABT,3,3,3,X0PG ,3,3,1,   GRANGA)
      CALL PROMAT (ROTABT,3,3,3,PETIK,3,3,1,   GRANK )
C
      GRANGA(1) = GRANGA(1) - UN
      DO 1 I=1,3
      GN(I) = GRANC(I)   * GRANGA(I)
      GM(I) = GRANC(3+I) * GRANK(I)
    1 CONTINUE
C
C     DILATATION THERMIQUE : -E*A*ALPHA*(T-TREF)
CC
      GN(1) = GN(1) - GRANC(1)*EPSTHE
C
      CALL PROMAT (ROTABS,3,3,3,GN   ,3,3,1,   PN    )
      CALL PROMAT (ROTABS,3,3,3,GM   ,3,3,1,   PM    )
C
      END
