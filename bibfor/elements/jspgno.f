      SUBROUTINE JSPGNO(L,A,B)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
      REAL*8 A(21),B(14), L
C-----------------------------------------------------------------------
C    PERMET LE PASSAGE DU CHAMPS DE CONTRAINTES CALCULEES AUX POINTS DE
C    GAUSS AUX NOEUDS
C
C     EN ENTREE :
C                L : LONGUEUR DE L'ELEMENT
C                A : VECTEUR DES EFFORTS GENERALISES AUX POINTS
C                    D'INTEGRATION
C     EN SORTIE :
C                B : VECTEUR DES EFFORTS GENERALISES AUX NOEUDS
C-----------------------------------------------------------------------
      REAL*8   MFYPG1, MFYPG2, MFZPG1, MFZPG2, MTPG1, MTPG2
      REAL*8 CONST1, CONST2, CONST3 , XPG
C
C-----------------------------------------------------------------------
      REAL*8 DEUX ,UNDEMI 
C-----------------------------------------------------------------------
      UNDEMI = 0.5D0
      DEUX   = 2.0D0
      XPG    = SQRT(0.6D0)
C
C --- AFFECTATION DES EFFORTS NORMAUX ET DES BIMOMENTS AUX
C --- POINTS D'INTEGRATION AUX EFFORTS NODAUX :
C     ---------------------------------------
      B(1) = A(1)
      B(7) = A(7)
      B(8) = A(15)
      B(14)= A(21)
C
C --- NOTATIONS PLUS PARLANTES :
C     ------------------------
      MTPG1  = A(4)
      MFYPG1 = A(5)
      MFZPG1 = A(6)
      MTPG2  = A(11)
      MFYPG2 = A(12)
      MFZPG2 = A(13)
C
C --- EXTRAPOLATION LINEAIRE DES MOMENTS DE FLEXION AUX NOEUDS
C --- L'ABSCISSE DU PREMIER NOEUD SUR L'ELEMENT DE REFERENCE EST -1
C --- L'ABSCISSE DU SECOND NOEUD SUR L'ELEMENT DE REFERENCE EST +1 :
C     ------------------------------------------------------------
      CONST1 = -DEUX*(MTPG1 - MTPG2)/(L*XPG)
      CONST2 = -DEUX*(MFYPG1 - MFYPG2)/(L*XPG)
      CONST3 = -DEUX*(MFZPG1 - MFZPG2)/(L*XPG)
C
      B(4)   = -CONST1*UNDEMI*L + MTPG2
      B(5)   = -CONST2*UNDEMI*L + MFYPG2
      B(6)   = -CONST3*UNDEMI*L + MFZPG2
C
      B(11)  =  CONST1*UNDEMI*L + MTPG2
      B(12)  =  CONST2*UNDEMI*L + MFYPG2
      B(13)  =  CONST3*UNDEMI*L + MFZPG2
C
C --- DETERMINATION DES EFFORTS TRANCHANTS PAR LES EQUATIONS D'EQUILIBRE
C --- RELIANT LES EFFORTS TRANCHANTS AUX MOMENTS DE FLEXION
C ---     VY + D(MFZ)/DX = 0
C ---     VZ - D(MFY)/DX = 0
C --- LES DERIVEES DES MOMENTS DE FLEXION ETANT APPROXIMEES PAR
C --- DIFFERENCES FINIES :
C     ------------------
      B(2) = -DEUX*(MFZPG2-MFZPG1)/(L*XPG)
      B(3) =  DEUX*(MFYPG2-MFYPG1)/(L*XPG)
      B(9) =  B(2)
      B(10)=  B(3)
C
      END
