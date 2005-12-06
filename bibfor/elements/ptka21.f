      SUBROUTINE PTKA21(SK,E,A,XL,XIY,XIZ,XJX,XIG,G,ALFAY,ALFAZ,EY,EZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/09/95   AUTEUR GIBHHAY A.Y.PORTABILITE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 SK(*)
      REAL*8 E,A,XL,XIY,XIZ,XJX,XIG,G,ALFAY,ALFAZ,EY,EZ
C    -------------------------------------------------------------------
C    * CE SOUS PROGRAMME CALCULE LA MATRICE DE RAIDEUR DE L'ELEMENT DE
C    POUTRE DROITE A SECTION CONSTANTE ET A 7 DDL PAR NOEUD.
C
C    * DESCRIPTION DE L'ELEMENT:
C      C'EST UN ELEMENT A DEUX NOEUDS ET A 7 DEGRES DE LIBERTES PAR
C      NOEUDS (3 DEPLACEMENTS ,3 ROTATIONS ET 1 DDL DE GAUCHISSEMENT).
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
C IN R*8  ! XIG    !     -   ! MOMENT D'INERTIE DE GAUCHISSEMENT
C IN R*8  ! G      !     -   ! MODULE DE CISAILLEMENT DU MATERIAU
C IN R*8  ! ALFAY  !     -   ! COEFFICIENT DE CISAILLEMENT AXE Y (+)
C IN R*8  ! ALFAZ  !     -   ! COEFFICIENT DE CISAILLEMENT AXE Z (+)
C IN R*8  ! EY     !     -   ! COMPOSANTE GT SUR Y PRINCIPAL
C IN R*8  ! EZ     !     -   ! COMPOSANTE GT SUR Z PRINCIPAL
C IN
C IN (+) REMARQUES :
C IN  -  LE COEFFICIENT DE CISAILLEMENT EST L'INVERSE DU COEFFICIENT DE
C IN     FORME ( IL EST DONC SUPERIEUR A 1)
C IN  -  SI ALFAY OU ALFAZ EST NUL ALORS ON CONSIDERE L'ELEMENT DE TYPE
C IN     EULER-BERNOULLI (I.E.  SANS EFFORT TRANCHANT)
C
C OUT TYPE ! NOM   ! TABLEAU !             SIGNIFICATION
C OUT ------------------------------------------------------------------
C OUT R*8 !   SK   ! (105)   ! MATRICE ELEMENTAIRE UNICOLONNE
C
C
C LOC TYPE !  NOM  ! TABLEAU !              SIGNIFICATION
C LOC ------------------------------------------------------------------
C LOC I   ! IP     !   14    ! POINTEUR SUR L'ELEMENT DIAGONAL PRECEDENT
C     ------------------------------------------------------------------
      INTEGER IP(14)
      REAL*8 ZERO,R8GAEM
      REAL*8 XL2,XL3,PHIY,PHIZ,EIY,EIZ,EY2,EZ2
C
      PARAMETER (ZERO=0.D0)
      DATA IP/0,1,3,6,10,15,21,28,36,45,55,66,78,91/
C ---------------------------------------------------------------------
      DO 1,I = 1,105
          SK(I) = ZERO
    1 CONTINUE
C
C     -- SI G  ET E SONT NULS : K=0
      IF (ABS(G).LT.1.D0/R8GAEM()) THEN
        IF (ABS(E).LT.1.D0/R8GAEM())   GO TO 9999
        CALL UTMESS ('F','PTKA21','G EST NUL MAIS PAS E')
      END IF
C
C     1/ TRACTION - COMPRESSION
C     -------------------------
      SK(1) = E*A/XL
      SK(IP(8)+1) = -SK(1)
      SK(IP(8)+8) = SK(1)
C
C
C     2/ FLEXION
C     ----------
C        2.1) CALCUL DES CONSTANTES
      XL2 = XL*XL
      XL3 = XL*XL2
      EIY = E*XIY
      EIZ = E*XIZ
      PHIY = (12.D0*EIZ*ALFAY)/ (G*A*XL2)
      PHIZ = (12.D0*EIY*ALFAZ)/ (G*A*XL2)
C
C        2.2) REMPLISSAGE DE LA MATRICE
C
C        FLEXION DANS LE PLAN XOY
      SK(IP(2)+2) = 12.D0*EIZ/ ((1.D0+PHIY)*XL3)
      SK(IP(6)+2) = 6.D0*EIZ/ ((1.D0+PHIY)*XL2)
      SK(IP(9)+2) = -SK(IP(2)+2)
      SK(IP(13)+2) = SK(IP(6)+2)
      SK(IP(6)+6) = (4.D0+PHIY)*EIZ/ ((1.D0+PHIY)*XL)
      SK(IP(9)+6) = -SK(IP(6)+2)
      SK(IP(13)+6) = (2.D0-PHIY)*EIZ/ ((1.D0+PHIY)*XL)
      SK(IP(9)+9) = SK(IP(2)+2)
      SK(IP(13)+9) = -SK(IP(6)+2)
      SK(IP(13)+13) = SK(IP(6)+6)
C
C        FLEXION DANS LE PLAN XOZ
      SK(IP(3)+3) = 12.D0*EIY/ ((1.D0+PHIZ)*XL3)
      SK(IP(5)+3) = -6.D0*EIY/ ((1.D0+PHIZ)*XL2)
      SK(IP(10)+3) = -SK(IP(3)+3)
      SK(IP(12)+3) = SK(IP(5)+3)
      SK(IP(5)+5) = (4.D0+PHIZ)*EIY/ ((1.D0+PHIZ)*XL)
      SK(IP(10)+5) = -SK(IP(5)+3)
      SK(IP(12)+5) = (2.D0-PHIZ)*EIY/ ((1.D0+PHIZ)*XL)
      SK(IP(10)+10) = SK(IP(3)+3)
      SK(IP(12)+10) = -SK(IP(5)+3)
      SK(IP(12)+12) = SK(IP(5)+5)
C
C     3/ TORSION ET GAUCHISSEMENT
C     ---------------------------
      SK(IP(4)+4) = (3.D0*G*XJX/ (5.D0*XL/2.D0)) + (12.D0*E*XIG/XL3)
      SK(IP(7)+4) = (G*XJX/10.D0) + (6.0D0*E*XIG/XL2)
      SK(IP(7)+7) = (2.D0*G*XJX*XL/15.D0) + (4.D0*E*XIG/XL)
      SK(IP(11)+4) = -SK(IP(4)+4)
      SK(IP(11)+7) = -SK(IP(7)+4)
      SK(IP(11)+11) = SK(IP(4)+4)
      SK(IP(14)+4) = SK(IP(7)+4)
      SK(IP(14)+7) = - (G*XJX*XL/30.D0) + (2.D0*E*XIG/XL)
      SK(IP(14)+11) = -SK(IP(7)+4)
      SK(IP(14)+14) = SK(IP(7)+7)
C
C     4/ CHANGEMENT DE VARIABLES DY(C),DZ(C) --> DY(G),DZ(G) (EXCENTR.)
C     -----------------------------------------------------------------
      CALL POUEX7(SK(1),EY,EZ)
C
 9999 CONTINUE
      END
