      SUBROUTINE PJ3DAP(INO2,GEOM2,MA2,GEOM1,TETR4,COBARY,ITR3,NBTROU,
     &                  BTDI,BTVR,BTNB,BTLC,BTCO,IFM,NIV,LDMAX,DISTMA,
     &                  LOIN,DMIN)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      REAL*8 COBARY(4),GEOM1(*),GEOM2(*),BTVR(*)
      INTEGER ITR3,NBTROU,BTDI(*),BTNB(*),BTLC(*),BTCO(*)
      INTEGER TETR4(*),IFM,NIV
      CHARACTER*8 MA2
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C     BUT :
C       TROUVER LE TETR4 QUI SERVIRA A INTERPOLER LE NOEUD INO2
C       AINSI QUE LES COORDONNEES BARYCENTRIQUES DE INO2 DANS CE TETR4

C  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
C  IN   MA2        K8 : NOM DU MAILLAGE M2
C  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN   TETR4(*)   I  : OBJET '&&PJXXCO.TETR4'
C  IN   BTDI(*)    I  : OBJET .BT3DDI DE LA SD BOITE_3D
C  IN   BTVR(*)    R  : OBJET .BT3DVR DE LA SD BOITE_3D
C  IN   BTNB(*)    I  : OBJET .BT3DNB DE LA SD BOITE_3D
C  IN   BTLC(*)    I  : OBJET .BT3DLC DE LA SD BOITE_3D
C  IN   BTCO(*)    I  : OBJET .BT3DCO DE LA SD BOITE_3D
C  IN   IFM        I  : NUMERO LOGIQUE DU FICHIER MESSAGE
C  IN   NIV        I  : NIVEAU D'IMPRESSION POUR LES "INFO"
C  IN   LDMAX      L  : .TRUE. : IL FAUT PRENDRE DISTMA EN COMPTE
C  IN   DISTMA     R  : DISTANCE AU DELA DE LAQUELLE LE NOEUD INO2
C                       NE SERA PAS PROJETE.
C  OUT  NBTROU     I  : 2 -> ON A TROUVE 1 TETR4 QUI CONTIENT INO2
C                     : 1 -> ON A TROUVE 1 TETR4 ASSEZ PROCHE DE INO2
C                     : 0 -> ON N'A PAS TROUVE DE TETR4 ASSEZ PROCHE
C  OUT  ITR3       I  : NUMERO DU TETR4 SOLUTION
C  OUT  COBARY(4)  R  : COORDONNEES BARYCENTRIQUES DE INO2 DANS ITR3
C  OUT  DMIN       R  : DISTANCE DE INO2 AU BORD DE ITR3 SI INO2 EST
C                       EXTERIEUR A ITR3.
C  OUT  LOIN       L  : .TRUE. SI DMIN > 10% DIAMETRE(ITR3)

C  REMARQUE :
C    SI NBTROU=0, INO2 NE SERA PAS PROJETE CAR IL EST AU DELA DE DISTMA
C    ALORS : DMIN=0, LOIN=.FALSE.
C ----------------------------------------------------------------------


      REAL*8 COBAR2(4),DMIN,D2,DX,DY,DZ,XMIN,YMIN,ZMIN,R8MAEM,VOLU,RTR3
      INTEGER P,Q,R,P1,Q1,P2,Q2,R1,R2,INO2,I,K,IPOSI,NX,NY,NTRBT
      LOGICAL OK

      LOGICAL LDMAX,LOIN
      REAL*8 DISTMA
C DEB ------------------------------------------------------------------
      NBTROU=0
      LOIN=.FALSE.
      DMIN=0.D0

      NX=BTDI(1)
      NY=BTDI(2)
      DX=BTVR(7)
      DY=BTVR(8)
      DZ=BTVR(9)
      XMIN=BTVR(1)
      YMIN=BTVR(3)
      ZMIN=BTVR(5)


C     -- 1. : ON CHERCHE UN TETR4 ITR3 QUI CONTIENNE INO2 :
C     -------------------------------------------------------
C     -- PARCOURS DES MAILLES CANDIDATES :
C     DO 1,I=1,NTR3
      P=INT((GEOM2(3*(INO2-1)+1)-XMIN)/DX)+1
      Q=INT((GEOM2(3*(INO2-1)+2)-YMIN)/DY)+1
      R=INT((GEOM2(3*(INO2-1)+3)-ZMIN)/DZ)+1
      NTRBT=BTNB((R-1)*NX*NY+(Q-1)*NX+P)
      IPOSI=BTLC((R-1)*NX*NY+(Q-1)*NX+P)
      DO 10,K=1,NTRBT
        I=BTCO(IPOSI+K)
        CALL PJ3DA1(INO2,GEOM2,I,GEOM1,TETR4,COBAR2,OK)
        IF (OK) THEN
          ITR3=I
          NBTROU=2
          COBARY(1)=COBAR2(1)
          COBARY(2)=COBAR2(2)
          COBARY(3)=COBAR2(3)
          COBARY(4)=COBAR2(4)
          GOTO 9999

        ENDIF
   10 CONTINUE



C     -- 2. : SI ECHEC DE LA RECHERCHE PRECEDENTE, ON
C        CHERCHE LE TETR4 ITR3 LE PLUS PROCHE DE INO2 :
C     -------------------------------------------------------
      IF (LDMAX) THEN
        DMIN=DISTMA
      ELSE
        DMIN=R8MAEM()
      ENDIF


C     -- ON RECHERCHE LA GROSSE BOITE CANDIDATE :
      CALL PJ3DGB(INO2,GEOM2,GEOM1,TETR4,6,BTDI,BTVR,BTNB,BTLC,BTCO,
     &            P1,Q1,R1,P2,Q2,R2)
      DO 60,P=P1,P2
        DO 50,Q=Q1,Q2
          DO 40,R=R1,R2
            NTRBT=BTNB((R-1)*NX*NY+(Q-1)*NX+P)
            IPOSI=BTLC((R-1)*NX*NY+(Q-1)*NX+P)
            DO 30,K=1,NTRBT
              I=BTCO(IPOSI+K)
              CALL PJ3DA2(INO2,GEOM2,I,GEOM1,TETR4,COBAR2,D2,VOLU)
              IF (SQRT(D2).LT.DMIN) THEN
                RTR3=VOLU
                ITR3=I
                DMIN=SQRT(D2)
                NBTROU=1
                COBARY(1)=COBAR2(1)
                COBARY(2)=COBAR2(2)
                COBARY(3)=COBAR2(3)
                COBARY(4)=COBAR2(4)
              ENDIF
   30       CONTINUE
   40     CONTINUE
   50   CONTINUE
   60 CONTINUE


      IF (NBTROU.EQ.1) THEN
        IF (RTR3.EQ.0) THEN
          LOIN=.TRUE.
        ELSE
          RTR3 = RTR3** (1.D0/3.D0)
          IF (DMIN/RTR3.GT.1.D-1) LOIN=.TRUE.
        END IF
      ELSE
        DMIN=0.D0
      ENDIF

9999  CONTINUE

      END
