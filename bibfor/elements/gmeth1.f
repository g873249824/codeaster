      SUBROUTINE GMETH1(MODELE,OPTION,NNOFF,NDEG,FOND,GTHI,
     &                  GS,OBJCUR,XL,GI)
      IMPLICIT NONE

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
C
C ......................................................................
C      METHODE THETA-LEGENDRE ET G-LEGENDRE POUR LE CALCUL DE G(S)
C
C ENTREE
C
C   MODELE   --> NOM DU MODELE
C   NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C   NDEG     --> NOMBRE+1 PREMIERS CHAMPS THETA CHOISIS
C   FOND     --> NOMS DES NOEUDS DU FOND DE FISSURE
C   GTHI     --> VALEURS DE G POUR LES CHAMPS THETAI
C   OBJCUR  --> ABSCISSES CURVILIGNES S
C   XL     : LONGUEUR DE LA FISSURE
C
C
C SORTIE
C
C   GS      --> VALEUR DE G(S)
C   GI      --> VALEUR DE GI
C ......................................................................
C
      INCLUDE 'jeveux.h'
      INTEGER         NNOFF,NDEG,IADRT3,I,J
C
      REAL*8          XL,SOM,GTHI(1),GS(1),GI(1),OBJCUR(*)
C
      CHARACTER*8     MODELE
      CHARACTER*16    OPTION
      CHARACTER*24    FOND,OBJABS
C
C
C

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C VALEURS DU MODULE DU CHAMP THETA POUR LES NOEUDS DU FOND DE FISSURE
C
      CALL WKVECT('&&METHO1.THETA','V V R8',(NDEG+1)*NNOFF,IADRT3)
      OBJABS = '&&LEGEND.ABSGAMM0'
      CALL GLEGEN(NDEG,NNOFF,XL,OBJABS,ZR(IADRT3))
C
C VALEURS DE GI
C
      DO 10 I=1,NDEG+1
         GI(I) = GTHI(I)
10    CONTINUE
C
C VALEURS DE G(S)
C
      DO 30 I=1,NNOFF
         SOM = 0.D0
         DO 20 J=1,NDEG+1
           SOM = SOM + GI(J)*ZR(IADRT3+(J-1)*NNOFF+I-1)
20       CONTINUE
         GS(I) = SOM
30    CONTINUE
C
      CALL JEDETR('&&METHO1.THETA')
      CALL DETRSD('CHAMP_GD','&&GMETH1.G2        ')
C
      CALL JEDEMA()
      END
