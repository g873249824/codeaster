      SUBROUTINE PJ3DAP(INO2,GEOM2,MA2,GEOM1,TETR4,COBARY,ITR3,NBTROU,
     &                  BTDI,BTVR,BTNB,BTLC,BTCO,IFM,NIV,
     &                  LDMAX,DISTMA)
      IMPLICIT NONE
      REAL*8 COBARY(4),GEOM1(*),GEOM2(*),BTVR(*)
      INTEGER ITR3,NBTROU,BTDI(*),BTNB(*),BTLC(*),BTCO(*)
      INTEGER TETR4(*),IFM,NIV
      CHARACTER*8 MA2
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 31/08/2004   AUTEUR VABHHTS J.PELLET 
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
C  OUT  NBTROU     I  : NOMBRE DE TETR4 SOLUTIONS
C  OUT  ITR3       I  : NUMERO D'UN TETR4 SOLUTION
C  OUT  COBARY(4)  R  : COORDONNEES BARYCENTRIQUES DE INO2 DANS ITR3
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      REAL*8 COBAR2(4),DMIN,D2,DX,DY,DZ,XMIN,YMIN,ZMIN,R8MAEM,VOLU,RTR3
      INTEGER P,Q,R,P1,Q1,P2,Q2,R1,R2,INO2,NTR3,I,K,IPOSI,NX,NY,NTRBT
      CHARACTER*8 KB,NONO2
      LOGICAL OK

      LOGICAL LDMAX,LOIN
      REAL*8  DISTMA
C DEB ------------------------------------------------------------------
C     NTR3=TETR4(1)
      NBTROU = 0

      NX = BTDI(1)
      NY = BTDI(2)
      DX = BTVR(7)
      DY = BTVR(8)
      DZ = BTVR(9)
      XMIN = BTVR(1)
      YMIN = BTVR(3)
      ZMIN = BTVR(5)


C     -- 1. : ON CHERCHE UN TETR4 ITR3 QUI CONTIENNE INO2 :
C     -------------------------------------------------------
C     -- PARCOURS DES MAILLES CANDIDATES :
C     DO 1,I=1,NTR3
      P = INT((GEOM2(3* (INO2-1)+1)-XMIN)/DX) + 1
      Q = INT((GEOM2(3* (INO2-1)+2)-YMIN)/DY) + 1
      R = INT((GEOM2(3* (INO2-1)+3)-ZMIN)/DZ) + 1
      NTRBT = BTNB((R-1)*NX*NY+ (Q-1)*NX+P)
      IPOSI = BTLC((R-1)*NX*NY+ (Q-1)*NX+P)
      DO 10,K = 1,NTRBT
        I = BTCO(IPOSI+K)
        CALL PJ3DA1(INO2,GEOM2,I,GEOM1,TETR4,COBAR2,OK)
        IF (OK) THEN
          ITR3 = I
          NBTROU = NBTROU + 1
          COBARY(1) = COBAR2(1)
          COBARY(2) = COBAR2(2)
          COBARY(3) = COBAR2(3)
          COBARY(4) = COBAR2(4)
          GO TO 11
        END IF
   10 CONTINUE
   11 CONTINUE



C     -- 2. : SI ECHEC DE LA RECHERCHE PRECEDENTE, ON
C        CHERCHE LE TETR4 ITR3 LE PLUS PROCHE DE INO2 :
C     -------------------------------------------------------
      IF (NBTROU.EQ.0) THEN
        IF ( LDMAX ) THEN
          DMIN = DISTMA
        ELSE
          DMIN = R8MAEM()
        ENDIF


C       -- ON RECHERCHE LA GROSSE BOITE CANDIDATE :
        CALL PJ3DGB(INO2,GEOM2,GEOM1,TETR4,6,BTDI,BTVR,BTNB,BTLC,BTCO,
     &              P1,Q1,R1,P2,Q2,R2)
        DO 50,P = P1,P2
          DO 40,Q = Q1,Q2
            DO 30,R = R1,R2
              NTRBT = BTNB((R-1)*NX*NY+ (Q-1)*NX+P)
              IPOSI = BTLC((R-1)*NX*NY+ (Q-1)*NX+P)
              DO 20,K = 1,NTRBT
                I = BTCO(IPOSI+K)
                CALL PJ3DA2(INO2,GEOM2,I,GEOM1,TETR4,COBAR2,D2,VOLU)
                IF (D2.LT.DMIN) THEN
                  RTR3 = VOLU
                  ITR3 = I
                  DMIN = D2
                  NBTROU = 1
                  COBARY(1) = COBAR2(1)
                  COBARY(2) = COBAR2(2)
                  COBARY(3) = COBAR2(3)
                  COBARY(4) = COBAR2(4)
                END IF
   20         CONTINUE
   30       CONTINUE
   40     CONTINUE
   50   CONTINUE

C       S'IL N'Y A PAS DE DISTANCE MINIMALE IMPOSEE, LE NOEUD EST
C          OBLIGATOIREMENT PROJETE
C       SI LE NOEUD EST PROJETE SUR UNE MAILLE LOINTAINE, ON INFORME :
        IF ((NIV.GT.0).AND.(.NOT.LDMAX)) THEN
          DMIN = SQRT(DMIN)

          LOIN=.FALSE.
          IF (RTR3.EQ.0) THEN
            LOIN=.TRUE.
          ELSE
            RTR3 = RTR3** (1.D0/3.D0)
            IF (DMIN/RTR3.GT.1.D-1) LOIN=.TRUE.
          END IF

          IF (LOIN) THEN
            CALL JENUNO(JEXNUM(MA2//'.NOMNOE',INO2),NONO2)
            WRITE (IFM,*) '<PROJCH> LE NOEUD :',NONO2,
     &        ' EST PROJETE SUR UNE MAILLE DISTANTE.'
            WRITE (IFM,*) '           DISTANCE              = ',DMIN
            WRITE (IFM,*) '           DIAMETRE DE LA MAILLE = ',RTR3
            WRITE (IFM,*)
          END IF
        END IF

      END IF

      END
