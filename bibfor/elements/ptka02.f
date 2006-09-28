      SUBROUTINE PTKA02(ID,SK,E,A,A2,XL,XIY,XIY2,XIZ,XIZ2,XJX,XJX2,G,
     &                ALFAY,ALFAY2,ALFAZ,ALFAZ2,EY,EZ,IST)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER         ID,                             IST
      REAL*8          SK(*),E,A,A2,XL,XIY,XIY2
      REAL*8                          XIZ,XIZ2,XJX,XJX2,G,ALFAY,ALFAY2
      REAL*8          ALFAZ,ALFAZ2,EY,EZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C    * CE SOUS PROGRAMME CALCULE LA MATRICE DE RAIDEUR DE L'ELEMENT DE
C      POUTRE DROITE A SECTION VARIABLE.
C
C    * DESCRIPTION DE L'ELEMENT:
C      C'EST UN ELEMENT A DEUX NOEUDS ET A SIX DEGRES DE LIBERTES PAR
C      NOEUDS (3 DEPLACEMENTS ET 3 ROTATIONS)
C      IL PEUT PRENDRE EN COMPTE L'EFFORT TRANCHANT ET L'EXCENTRICITE DU
C      CENTRE DE ROTATION (CENTRE DE TORSION) PAR RAPPORT A LA FIBRE
C      NEUTRE (LIEU GEOMETRIQUE DES CENTRES DE GRAVITES).
C
C    * REMARQUE FONDAMENTALE SUR LA VARIATION DE LA SECTION DROITE :
C      DANS LE CAS DE SECTION AFFINE ON SUPPOSE QUE LA COMPOSANTE EN Y
C      VARIE ALORS QUE CELLE SELON Z EST FIXE
C
C    * REMARQUE : LA MATRICE EST STOCKEE TRIANGULAIRE INFERIEURE DANS UN
C      TABLEAU UNICOLONNE
C     ------------------------------------------------------------------
C
C  DONNEES NON MODIFIEES
C
C IN TYPE ! NOM    ! TABLEAU !             SIGNIFICATION
C IN -------------------------------------------------------------------
C IN  I   ! ID     !   -     ! TYPE DE VARIATION SECTION DROITE
C IN      !        !         !   ID = 1 : SECTIONS AFFINES
C IN      !        !         !   ID = 2 : SECTIONS HOMOTHETIQUES
C IN R*8  ! E      !   -     ! MODULE D'ELASTICITE DU MATERIAU
C IN R*8  ! A      !   -     ! AIRE DE LA SECTION DROITE INITIALE
C IN R*8  ! A2     !   -     ! AIRE DE LA SECTION DROITE FINALE
C IN R*8  ! XL     !   -     ! LONGUEUR DE L ELEMENT
C IN R*8  ! XIY    !   -     ! MOMENT D INERTIE / Y PRINCIPAL SECTION
C IN      !        !         !   INITIALE
C IN R*8  ! XIY2   !   -     ! MOMENT D INERTIE / Y PRINCIPAL SECTION
C IN      !        !         !   FINALE
C IN R*8  ! XIZ    !   -     ! MOMENT D INERTIE / Z PRINCIPAL SECTION
C IN      !        !         !   INITIALE
C IN R*8  ! XIZ2   !   -     ! MOMENT D INERTIE / Z PRINCIPAL SECTION
C IN      !        !         !   FINALE
C IN R*8  ! XJX    !   -     ! CONSTANTE DE TORSION SECTION INITIALE
C IN R*8  ! XJX2   !   -     ! CONSTANTE DE TORSION SECTION FINALE
C IN R*8  ! G      !   -     ! MODULE DE CISAILLEMENT DU MATERIAU
C IN R*8  ! ALFAY  !   -     ! COEFFICIENT DE CISAILLEMENT AXE Y
C IN      !        !         !   SECTION INITIALE (+)
C IN R*8  ! ALFAY2 !   -     ! COEFFICIENT DE CISAILLEMENT AXE Y
C IN      !        !         !   SECTION FINALE   (+)
C IN R*8  ! ALFAZ  !   -     ! COEFFICIENT DE CISAILLEMENT AXE Z
C IN      !        !         !   SECTION INITIALE (+)
C IN R*8  ! ALFAZ2 !   -     ! COEFFICIENT DE CISAILLEMENT AXE Z
C IN      !        !         !   SECTION FINALE   (+)
C IN R*8  ! EY     !   -     ! COMPOSANTE TG SUR Y PRINCIPAL
C IN R*8  ! EZ     !   -     ! COMPOSANTE TG SUR Z PRINCIPAL
C IN  I   ! IST    !   -     ! TYPE DE STRUCTURE DE LA POUTRE
C IN
C IN (+) REMARQUES :
C IN  -  LE COEFFICIENT DE CISAILLEMENT EST L'INVERSE DU COEFFICIENT DE
C IN     FORME ( IL EST DONC SUPERIEUR A 1)
C IN  -  SI ALFAY OU ALFAZ EST NUL ALORS ON CONSIDERE L'ELEMENT DE TYPE
C IN     EULER-BERNOULLI (I.E.  SANS EFFORT TRANCHANT)
C
C OUT R*8 ! SK     ! (78)    ! MATRICE ELEMENTAIRE UNICOLONNE
C
C LOC R*8 ! ASY    !   -     ! AIRE REDUITE CISAILLEE SUIVANT Y
C LOC R*8 ! ASZ    !   -     ! AIRE REDUITE CISAILLEE SUIVANT Z
C LOC R*8 ! PHIY   !   -     ! COEFFICIENT DU A L'EFFORT TRANCHANT SUR Z
C LOC R*8 ! PHIZ   !   -     ! COEFFICIENT DU A L'EFFORT TRANCHANT SUR Y
C LOC I   ! IP     !   -     ! POINTEUR SUR L'ELEMENT DIAGONAL PRECEDENT
C     ------------------------------------------------------------------
C
C     SOUS - PROGRAMMES UTILISES
C BBL  FUN1     - AIRES ET CONSTANTE DE TORSION EQUIVALENTES
C BBL  FUN2     - MOMENTS D INERTIE EQUIVALENTS
C     ------------------------------------------------------------------
      INTEGER IP(12)
      REAL*8  EXL,XL2,XL3, PHIY,PHIZ, ASY,ASZ, EY2,EZ2
      REAL*8  AA,AAS1,AAS2,AS1,AS2, TK,VT,Q,XKK
      REAL*8 ZERO,R8GAEM
      PARAMETER (  ZERO  = 0.D0         )
      DATA             IP/ 0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66 /
C ---------------------------------------------------------------------
      DO 1,I = 1,78
          SK(I) = ZERO
    1 CONTINUE
C
C     -- SI G  ET E SONT NULS : K=0
      IF (ABS(G).LT.1.D0/R8GAEM()) THEN
        IF (ABS(E).LT.1.D0/R8GAEM())   GO TO 9999
        CALL U2MESS('F','ELEMENTS2_54')
      END IF
C
C     1/ TRACTION-COMPRESSION
      CALL FUN1(AA,A,A2,ID)
C
C
      SK(IP(1)+1) = E * AA / XL
      SK(IP(7)+1) = -SK(IP(1)+1)
      SK(IP(7)+7)=SK(IP(1)+1)
C
      IF (IST.EQ.2 .OR. IST.EQ.5 ) GO TO   9999
C
C     2/ FLEXION
C        2.1) CALCUL DES CONSTANTES
         XL2=XL*XL
         XL3=XL*XL2
         EXL=E/XL
         IF( ALFAZ.NE.ZERO )  THEN
           AS1=A/ALFAZ
         ELSE
           AS1=A
         ENDIF
         IF(ALFAZ2.NE.ZERO)  THEN
           AS2=A2/ALFAZ2
         ELSE
           AS2=A2
         ENDIF
         IF ( ALFAZ .EQ. ZERO .AND. ALFAZ2 .EQ. ZERO ) THEN
            PHIZ = ZERO
         ELSE
            CALL FUN1(ASY,AS1,AS2,ID)
            PHIZ=E/(G*ASY*XL2)
         ENDIF
C
         IF(ALFAY.NE.ZERO) THEN
            AAS1=A/ALFAY
         ELSE
            AAS1=A
         ENDIF
         IF(ALFAY2.NE.ZERO) THEN
            AAS2=A2/ALFAY2
         ELSE
            AAS2=A2
         ENDIF
         IF ( ALFAY .EQ. ZERO .AND. ALFAY2 .EQ. ZERO ) THEN
            PHIY = ZERO
         ELSE
            CALL FUN1(ASZ,AAS1,AAS2,ID)
            PHIY=E/(G*ASZ*XL2)
         ENDIF
C
C        2.1) REMPLISSAGE DE LA MATRICE
C
C     2/  FLEXION DANS LE PLAN X0Y
          K=ID+2
          CALL FUN2(XIZ,XIZ2,PHIY,XKK,Q,VT,K)
          SK(IP(2)+2)   =  E*XKK/XL3
          SK(IP(6)+2)   =  XL*Q*SK(IP(2)+2)
          SK(IP(8)+2)   = -SK(IP(2)+2)
          SK(IP(12)+2)  =  (1.D0/Q-1.D0)*SK(IP(6)+2)
          SK(IP(6)+6)   =  EXL*(VT+Q*Q*XKK)
          SK(IP(8)+6)   = -SK(IP(6)+2)
          SK(IP(12)+6)  =  EXL*(XKK*Q*(1.D0-Q)-VT)
C
          CALL FUN2(XIZ2,XIZ,PHIY,XKK,Q,VT,K)
          SK(IP(8)+8)   = SK(IP(2)+2)
          SK(IP(12)+8)  = -SK(IP(12)+2)
          SK(IP(12)+12) =  EXL*(VT+Q*Q*XKK)
C
      IF(IST.EQ.3.OR.IST.EQ.6) GOTO  9999
C
C     3/  FLEXION DANS LE PLAN X0Z
          IF ( ID.EQ.2 ) THEN
             K = 4
          ELSE
             K = 1
          ENDIF
C
          CALL FUN2(XIY,XIY2,PHIZ,XKK,Q,VT,K)
          SK(IP(3)+3)   =  E*XKK/XL3
          SK(IP(5)+3)   = -XL*Q*SK(IP(3)+3)
          SK(IP(9)+3)   = -SK(IP(3)+3)
          SK(IP(11)+3)  = (1.D0/Q-1.D0)*SK(IP(5)+3)
          SK(IP(5)+5)   =  EXL*(VT+Q*Q*XKK)
          SK(IP(9)+5)   = -SK(IP(5)+3)
          SK(IP(11)+5)  =  EXL*(XKK*Q*(1.D0-Q)-VT)
C
          CALL FUN2(XIY2,XIY,PHIZ,XKK,Q,VT,K)
          SK(IP(9)+9)   =  SK(IP(3)+3)
          SK(IP(11)+9)  = -SK(IP(11)+3)
          SK(IP(11)+11) =  EXL*(VT+Q*Q*XKK)
C
C
C     3/  TORSION
          CALL FUN1(TK,XJX,XJX2,ID+2)
          SK(IP(4)+4)   = G*TK/XL
          SK(IP(10)+4)  = -SK(IP(4)+4)
          SK(IP(10)+10) =  SK(IP(4)+4)
C???
C
      IF ( EZ.EQ.ZERO .AND. EY.EQ. ZERO ) GOTO  9999
C
C        AVEC EXCENTRICITE
C
C        TORSION DANS CE CAS
         SK(IP( 4)+ 4)  =  SK(IP(4)+4)
     &                       + EZ*EZ*SK(IP(2)+2) + EY*EY*SK(IP(3)+3)
         SK(IP(10)+4)   = -SK(IP(4)+4)
         SK(IP(10)+10)  =  SK(IP(4)+4)
C
         SK(IP(4)+2)    = -EZ*SK(IP(2)+2)
         SK(IP(10)+2)   = -SK(IP(4)+2)
         SK(IP(4)+3)    =  EY*SK(IP(3)+3)
         SK(IP(10)+3)   = -SK(IP(4)+3)
         SK(IP(5)+4)    =  EY*SK(IP(5)+3)
         SK(IP(6)+4)    = -EZ*SK(IP(6)+2)
         SK(IP(8)+4)    =  SK(IP(10)+2)
         SK(IP(9)+4)    =  SK(IP(10)+3)
         SK(IP(11)+4)   =  EY*SK(IP(11)+3)
         SK(IP(12)+4)   = -EZ*SK(IP(12)+2)
         SK(IP(10)+5)   = -SK(IP(5)+4)
         SK(IP(10)+6)   = -SK(IP(6)+4)
         SK(IP(10)+8)   =  SK(IP(4)+2)
         SK(IP(10)+9)   =  SK(IP(4)+3)
         SK(IP(11)+10)  = -SK(IP(11)+4)
         SK(IP(12)+10)  = -SK(IP(12)+4)
C
C     SORTIE
 9999 CONTINUE
      END
