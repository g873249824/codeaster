      SUBROUTINE PTKA01(SK,E,A,XL,XIY,XIZ,XJX,G,ALFAY,ALFAZ,EY,EZ,IST)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/04/2013   AUTEUR FLEJOU J-L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      REAL*8   SK(*)
      REAL*8   E,A,XL,XIY,XIZ,XJX,G,ALFAY,ALFAZ,EY,EZ
      INTEGER  IST
C    -------------------------------------------------------------------
C    * CE SOUS PROGRAMME CALCULE LA MATRICE DE RAIDEUR DE L'ELEMENT DE
C    POUTRE DROITE A SECTION CONSTANTE.
C
C    * DESCRIPTION DE L'ELEMENT:
C      C'EST UN ELEMENT A DEUX NOEUDS ET A SIX DEGRES DE LIBERTES PAR
C      NOEUDS (3 DEPLACEMENTS ET 3 ROTATIONS).
C      IL PEUT PRENDRE EN COMPTE L'EFFORT TRANCHANT ET L'EXCENTRICITE
C      DU CENTRE DE ROTATION (CENTRE DE TORSION) PAR RAPPORT A LA FIBRE
C      NEUTRE (LIEU DES CENTRES DE GRAVITES).
C
C    * REMARQUE :
C      LA MATRICE EST STOCKEE TRIANGULAIRE INFERIEURE DANS UN TABLEAU
C      UNICOLONNE
C    -------------------------------------------------------------------
C  DONNEES NON MODIFIEES
C
C IN TYPE ! NOM    ! TABLEAU !             SIGNIFICATION
C IN -------------------------------------------------------------------
C IN R*8  ! E      !     -   ! MODULE D'ELASTICITE DU MATERIAU
C IN R*8  ! A      !     -   ! AIRE DE LA SECTION DROITE DE L'ELEMENT
C IN R*8  ! XL     !     -   ! LONGUEUR DE L ELEMENT
C IN R*8  ! XIY    !     -   ! MOMENT D INERTIE / Y PRINCIPAL
C IN R*8  ! XIZ    !     -   ! MOMENT D INERTIE / Z PRINCIPAL
C IN R*8  ! XJX    !     -   ! CONSTANTE DE TORSION
C IN R*8  ! G      !     -   ! MODULE DE CISAILLEMENT DU MATERIAU
C IN R*8  ! ALFAY  !     -   ! COEFFICIENT DE CISAILLEMENT AXE Y (+)
C IN R*8  ! ALFAZ  !     -   ! COEFFICIENT DE CISAILLEMENT AXE Z (+)
C IN R*8  ! EY     !     -   ! COMPOSANTE GT SUR Y PRINCIPAL
C IN R*8  ! EZ     !     -   ! COMPOSANTE GT SUR Z PRINCIPAL
C IN  I   ! IST    !    -    ! TYPE DE STRUCTURE DE LA POUTRE
C IN
C IN (+) REMARQUES :
C IN  -  LE COEFFICIENT DE CISAILLEMENT EST L'INVERSE DU COEFFICIENT DE
C IN     FORME ( IL EST DONC SUPERIEUR A 1)
C IN  -  SI ALFAY OU ALFAZ EST NUL ALORS ON CONSIDERE L'ELEMENT DE TYPE
C IN     EULER-BERNOULLI (I.E.  SANS EFFORT TRANCHANT)
C
C OUT TYPE ! NOM   ! TABLEAU !             SIGNIFICATION
C OUT ------------------------------------------------------------------
C OUT R*8 !   SK   ! (78)    ! MATRICE ELEMENTAIRE UNICOLONNE
C
C
C LOC TYPE !  NOM  ! TABLEAU !              SIGNIFICATION
C LOC ------------------------------------------------------------------
C LOC I   ! IP     !   12    ! POINTEUR SUR L'ELEMENT DIAGONAL PRECEDENT
C     ------------------------------------------------------------------
      INTEGER     IP(12),I
      REAL*8      ZERO,R8GAEM,XL2,XL3,PHIY,PHIZ,EIY,EIZ
C--- -------------------------------------------------------------------
      PARAMETER  (ZERO=0.D0)
      DATA        IP/0,1,3,6,10,15,21,28,36,45,55,66/
C--- -------------------------------------------------------------------
      DO 10,I = 1,78
         SK(I) = ZERO
10    CONTINUE
C
C --- SI G ET E SONT NULS : K=0
      IF (ABS(G).LT.1.D0/R8GAEM()) THEN
         IF (ABS(E).LT.1.D0/R8GAEM())  GO TO 9999
         CALL U2MESS('F','ELEMENTS2_54')
      END IF
C
C     1/ TRACTION - COMPRESSION
      SK(1) = E*A/XL
      SK(IP(7)+1) = -SK(1)
      SK(IP(7)+7) = SK(1)
C
      IF ((IST.EQ.2).OR.(IST.EQ.5)) GO TO 9999
C
C     2/ FLEXION
C     2.1) CALCUL DES CONSTANTES
      XL2 = XL*XL
      XL3 = XL*XL2
      EIY = E*XIY
      EIZ = E*XIZ
      PHIY = (12.D0*EIZ*ALFAY)/(G*A*XL2)
      PHIZ = (12.D0*EIY*ALFAZ)/(G*A*XL2)
C
C     2.1) REMPLISSAGE DE LA MATRICE
C     FLEXION DANS LE PLAN XOY
      SK(IP(2)+2)   =  12.D0*EIZ/((1.D0+PHIY)*XL3)
      SK(IP(6)+2)   =  6.D0*EIZ/((1.D0+PHIY)*XL2)
      SK(IP(8)+2)   = -SK(IP(2)+2)
      SK(IP(12)+2)  =  SK(IP(6)+2)
      SK(IP(6)+6)   = (4.D0+PHIY)*EIZ/((1.D0+PHIY)*XL)
      SK(IP(8)+6)   = -SK(IP(6)+2)
      SK(IP(12)+6)  = (2.D0-PHIY)*EIZ/((1.D0+PHIY)*XL)
      SK(IP(8)+8)   =  SK(IP(2)+2)
      SK(IP(12)+8)  = -SK(IP(6)+2)
      SK(IP(12)+12) =  SK(IP(6)+6)
C
      IF ((IST.EQ.3).OR.(IST.EQ.6)) GO TO 9999
C
C     3/ FLEXION DANS LE PLAN XOZ
      SK(IP(3)+3)   =  12.D0*EIY/((1.D0+PHIZ)*XL3)
      SK(IP(5)+3)   = -6.D0*EIY/((1.D0+PHIZ)*XL2)
      SK(IP(9)+3)   = -SK(IP(3)+3)
      SK(IP(11)+3)  =  SK(IP(5)+3)
      SK(IP(5)+5)   = (4.D0+PHIZ)*EIY/((1.D0+PHIZ)*XL)
      SK(IP(9)+5)   = -SK(IP(5)+3)
      SK(IP(11)+5)  = (2.D0-PHIZ)*EIY/((1.D0+PHIZ)*XL)
      SK(IP(9)+9)   =  SK(IP(3)+3)
      SK(IP(11)+9)  = -SK(IP(5)+3)
      SK(IP(11)+11) =  SK(IP(5)+5)
C
C     4/ TORSION
      SK(IP(4)+4)   =  G*XJX/XL
      SK(IP(10)+4)  = -SK(IP(4)+4)
      SK(IP(10)+10) =  SK(IP(4)+4)
C
      IF ((EZ.EQ.ZERO).AND.(EY.EQ.ZERO)) GO TO 9999
C
C     5/ AVEC EXCENTREMENT
C     RECTIFICATION POUR LA TORSION
      SK(IP(4)+4)   =  SK(IP(4)+4)+EZ*EZ*SK(IP(2)+2)+EY*EY*SK(IP(3)+3)
      SK(IP(10)+4)  = -SK(IP(4)+4)
      SK(IP(10)+10) =  SK(IP(4)+4)
C     TERME INDUIT PAR L'EXCENTREMENT
      SK(IP(4)+2)   = -EZ*SK(IP(2)+2)
      SK(IP(10)+2)  = -SK(IP(4)+2)
      SK(IP(4)+3)   =  EY*SK(IP(3)+3)
      SK(IP(10)+3)  = -SK(IP(4)+3)
      SK(IP(5)+4)   =  EY*SK(IP(5)+3)
      SK(IP(6)+4)   = -EZ*SK(IP(6)+2)
      SK(IP(8)+4)   =  SK(IP(10)+2)
      SK(IP(9)+4)   =  SK(IP(10)+3)
      SK(IP(11)+4)  =  SK(IP(5)+4)
      SK(IP(12)+4)  =  SK(IP(6)+4)
      SK(IP(10)+5)  = -SK(IP(5)+4)
      SK(IP(10)+6)  = -SK(IP(6)+4)
      SK(IP(10)+8)  =  SK(IP(4)+2)
      SK(IP(10)+9)  =  SK(IP(4)+3)
      SK(IP(11)+10) =  SK(IP(10)+5)
      SK(IP(12)+10) =  SK(IP(10)+6)
 9999 CONTINUE
      END
