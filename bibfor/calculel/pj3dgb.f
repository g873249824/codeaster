      SUBROUTINE PJ3DGB(INO2,GEOM2,GEOM1,TETR4,NDEC,BTDI,BTVR,BTNB,BTLC,
     &                  BTCO,P1,Q1,R1,P2,Q2,R2)
      IMPLICIT NONE
      REAL*8 GEOM1(*),GEOM2(*),BTVR(*)
      INTEGER INO2,P1,Q1,R1,P2,Q2,R2,NDEC
      INTEGER BTDI(*),BTNB(*),BTLC(*),BTCO(*),TETR4(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/02/2000   AUTEUR VABHHTS J.PELLET 
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
C     BUT :
C       TROUVER LA "GROSSE BOITE" (P1,Q1,R1,P2,Q2,R2) DANS LA QUELLE
C       ON EST SUR DE TROUVER LE TETR4 LE PLUS PROCHE DE INO2

C  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
C  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN   TETR4(*)   I  : OBJET '&&PJXXCO.TETR4' OU '&&PJXXCO.TRIA3'
C  IN   NDEC       I  : 6  SI '&&PJXXCO.TETR4'
C                     : 4  SI '&&PJXXCO.TRIA3'
C  IN   BTDI(*)    I  : OBJET .BT3DDI DE LA SD BOITE_3D
C  IN   BTVR(*)    R  : OBJET .BT3DVR DE LA SD BOITE_3D
C  IN   BTNB(*)    I  : OBJET .BT3DNB DE LA SD BOITE_3D
C  IN   BTLC(*)    I  : OBJET .BT3DLC DE LA SD BOITE_3D
C  IN   BTCO(*)    I  : OBJET .BT3DCO DE LA SD BOITE_3D
C  OUT  P1         I  : ABSCISSE DU COIN BAS/GAUCHE DE LA GROSSE BOITE
C  OUT  Q1         I  : ORDONNEE DU COIN BAS/GAUCHE DE LA GROSSE BOITE
C  OUT  R1         I  : COTE     DU COIN BAS/GAUCHE DE LA GROSSE BOITE
C  OUT  P2         I  : ABSCISSE DU COIN HAUT/DROIT DE LA GROSSE BOITE
C  OUT  Q2         I  : ORDONNEE DU COIN HAUT/DROIT DE LA GROSSE BOITE
C  OUT  R2         I  : COTE     DU COIN HAUT/DROIT DE LA GROSSE BOITE
C ----------------------------------------------------------------------
      REAL*8 D,X1,Y1,Z1,X2,Y2,Z2,XMIN,YMIN,ZMIN,DX,DY,DZ
      INTEGER P0,Q0,R0,NX,NY,NZ,K,P,Q,R,ITR,NTRBT,IPOSI,INO1

C DEB ------------------------------------------------------------------

      NX = BTDI(1)
      NY = BTDI(2)
      NZ = BTDI(3)
      DX = BTVR(7)
      DY = BTVR(8)
      DZ = BTVR(9)
      XMIN = BTVR(1)
      YMIN = BTVR(3)
      ZMIN = BTVR(5)


C      1. ON CHERCHE UNE BOITE NON VIDE AUTOUR DE INO2
C     -------------------------------------------------------
      P0 = INT((GEOM2(3* (INO2-1)+1)-XMIN)/DX) + 1
      Q0 = INT((GEOM2(3* (INO2-1)+2)-YMIN)/DY) + 1
      R0 = INT((GEOM2(3* (INO2-1)+3)-ZMIN)/DZ) + 1

      DO 40,K = 0,MAX(NX,NY) - 1
        DO 30,P = MAX(P0-K,1),MIN(P0+K,NX)
          DO 20,Q = MAX(Q0-K,1),MIN(Q0+K,NY)
            DO 10,R = MAX(R0-K,1),MIN(R0+K,NZ)
              NTRBT = BTNB((R-1)*NX*NY+ (Q-1)*NX+P)
C             -- SI LA BOITE EST NON VIDE :
              IF (NTRBT.GT.0) THEN
C               -- ON CHOISIT LE 1ER NOEUD DU 1ER TETR4 DE LA BOITE:INO1
                IPOSI = BTLC((R-1)*NX*NY+ (Q-1)*NX+P)
                ITR = BTCO(IPOSI+1)
                INO1 = TETR4(1+NDEC* (ITR-1)+1)
                GO TO 50
              END IF
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE
      CALL UTMESS('F','PJ3DGB','STOP 1')


   50 CONTINUE
C     2. ON CALCULE LA DISTANCE ENTRE INO2 ET INO1
C     -------------------------------------------------------
      X1 = GEOM1(3* (INO1-1)+1)
      Y1 = GEOM1(3* (INO1-1)+2)
      Z1 = GEOM1(3* (INO1-1)+3)
      X2 = GEOM2(3* (INO2-1)+1)
      Y2 = GEOM2(3* (INO2-1)+2)
      Z2 = GEOM2(3* (INO2-1)+3)
      D = SQRT((X2-X1)**2+ (Y2-Y1)**2+ (Z2-Z1)**2)


C     3. ON DETERMINE LA GROSSE BOITE CONTENANT :
C        INO2 - D*VECTEUR_I - D*VECTEUR_J - D*VECTEUR_K
C     ET INO2 + D*VECTEUR_I + D*VECTEUR_J + D*VECTEUR_K
C     -------------------------------------------------------
      P1 = INT((X2-D-XMIN)/DX) + 1
      Q1 = INT((Y2-D-YMIN)/DY) + 1
      R1 = INT((Z2-D-ZMIN)/DZ) + 1
      P1 = MAX(1,P1)
      Q1 = MAX(1,Q1)
      R1 = MAX(1,R1)

      P2 = INT((X2+D-XMIN)/DX) + 1
      Q2 = INT((Y2+D-YMIN)/DY) + 1
      R2 = INT((Z2+D-ZMIN)/DZ) + 1
      P2 = MIN(NX,P2)
      Q2 = MIN(NY,Q2)
      R2 = MIN(NZ,R2)


      END
