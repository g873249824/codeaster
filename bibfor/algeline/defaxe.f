      FUNCTION DEFAXE(ICOQ,IMOD,Z,LONG,NBM,TCOEF)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
C CALCUL DE LA DEFORMEE AXIALE AU POINT DE COTE Z SUR LA COQUE ICOQ POUR
C LE MODE IMOD
C-----------------------------------------------------------------------
C  IN : ICOQ  : INDICE CARACTERISTIQUE DE LA COQUE CONSIDEREE
C               ICOQ=1 COQUE INTERNE  ICOQ=2 COQUE EXTERNE
C  IN : IMOD  : INDICE DU MODE
C  IN : Z     : COTE
C  IN : LONG  : LONGUEUR DU DOMAINE DE RECOUVREMENT DES DEUX COQUES
C  IN : NBM   : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
C  IN : TCOEF : TABLEAU CONTENANT LES COEFFICIENTS DES DEFORMEES AXIALES
C-----------------------------------------------------------------------
      REAL*8       DEFAXE
      INTEGER      ICOQ,IMOD,NBM
      REAL*8       Z,LONG,TCOEF(10,NBM)
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER ITAB 
      REAL*8 ZZ 
C-----------------------------------------------------------------------
      ITAB = 0
      IF (ICOQ.EQ.2) ITAB = 5
      ZZ = TCOEF(1+ITAB,IMOD)*Z/LONG
      DEFAXE = TCOEF(2+ITAB,IMOD)*DBLE(COS(ZZ))
     &       + TCOEF(3+ITAB,IMOD)*DBLE(SIN(ZZ))
     &       + TCOEF(4+ITAB,IMOD)*DBLE(COSH(ZZ))
     &       + TCOEF(5+ITAB,IMOD)*DBLE(SINH(ZZ))
C
      END
