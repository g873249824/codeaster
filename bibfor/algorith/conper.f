      SUBROUTINE CONPER(MACOC,I1,I2,I3,I4)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/03/2007   AUTEUR LAVERNE J.LAVERNE 
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
C
C  ROUTINE CONPER
C    PERMUTATION CIRCULAIRE
C  DECLARATIONS
C    KDUM   : CHARACTER DE TRAVAIL
C    MACOC  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE FISSURE
C
C  MOT_CLEF : ORIE_FISSURE
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ------------------------------------------------------------------
C
      CHARACTER*8  KDUM
      CHARACTER*8  MACOC(*)
C
      KDUM        = MACOC(I1+2)
      MACOC(I1+2) = MACOC(I2+2)
      MACOC(I2+2) = MACOC(I3+2)
      MACOC(I3+2) = MACOC(I4+2)
      MACOC(I4+2) = KDUM
C
      END
