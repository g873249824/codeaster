      SUBROUTINE PJ2DFB(BOITE,TRIA3,GEOM1,GEOM2)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 GEOM1(*),GEOM2(*)
      INTEGER TRIA3(*)
      CHARACTER*14 BOITE
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
C       CONSTRUIRE LA STRUCTURE DE DONNEES BOITE_2D QUI PERMET DE SAVOIR
C       QUELS SONT LES TRIA3 QUI SE TROUVE DANS UNE BOITE(P,Q)

C  IN/JXOUT   BOITE      K14 : NOM DE LA SD BOITE_2D A CREER
C  IN         GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN         GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN         TRIA3(*)   I  : OBJET '&&PJXXCO.TRIA3'
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
      REAL*8 STOTAL,SBOITE,DX,DY,DDX,DDY,RBIG,XXMAX,XXMIN,XMAX,XMIN
      REAL*8 YYMAX,YYMIN,YMAX,YMIN
      CHARACTER*8 KB
      INTEGER P1,Q1,P2,Q2,P,Q,NX,NY
      LOGICAL DBG

C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      NTR3 = TRIA3(1)
      RBIG = R8MAEM()
      IF (NTR3.EQ.0) CALL UTMESS('F','PJ2DFB','STOP 1')

      CALL JEVEUO('&&PJXXCO.LINO1','L',IALIN1)
      CALL JEVEUO('&&PJXXCO.LINO2','L',IALIN2)
      CALL JELIRA('&&PJXXCO.LINO1','LONMAX',NNO1,KB)
      CALL JELIRA('&&PJXXCO.LINO2','LONMAX',NNO2,KB)


C     1. : ON CALCULE XMIN,XMAX,YMIN,YMAX,NX,NY,DX,DY
C     -------------------------------------------------------
      XMIN = RBIG
      YMIN = RBIG
      XMAX = -RBIG
      YMAX = -RBIG
      DO 10,I = 1,NNO1
        IF (ZI(IALIN1-1+I).EQ.0) GO TO 10
        XMIN = MIN(XMIN,GEOM1(3* (I-1)+1))
        XMAX = MAX(XMAX,GEOM1(3* (I-1)+1))
        YMIN = MIN(YMIN,GEOM1(3* (I-1)+2))
        YMAX = MAX(YMAX,GEOM1(3* (I-1)+2))
   10 CONTINUE
      DO 20,I = 1,NNO2
        IF (ZI(IALIN2-1+I).EQ.0) GO TO 20
        XMIN = MIN(XMIN,GEOM2(3* (I-1)+1))
        XMAX = MAX(XMAX,GEOM2(3* (I-1)+1))
        YMIN = MIN(YMIN,GEOM2(3* (I-1)+2))
        YMAX = MAX(YMAX,GEOM2(3* (I-1)+2))
   20 CONTINUE
      STOTAL = (XMAX-XMIN)* (YMAX-YMIN)
      SBOITE = (STOTAL/NTR3)*5.D0
      DX = SQRT(SBOITE)
      DY = DX
      NX = INT((XMAX-XMIN)*1.05D0/DX) + 1
      NY = INT((YMAX-YMIN)*1.05D0/DY) + 1
      IF (NX*NY.EQ.0) CALL UTMESS('F','PJ2DFB','STOP 2')
      DDX = (NX*DX- (XMAX-XMIN))/2.D0
      DDY = (NY*DY- (YMAX-YMIN))/2.D0
      XMIN = XMIN - DDX
      XMAX = XMAX + DDX
      YMIN = YMIN - DDY
      YMAX = YMAX + DDY


C     2. : ALLOCATION DE LA SD BOITE_2D :
C     ---------------------------------------
      CALL WKVECT(BOITE//'.BT2DDI','V V I',2,IABTDI)
      CALL WKVECT(BOITE//'.BT2DVR','V V R',6,IABTVR)
      CALL WKVECT(BOITE//'.BT2DNB','V V I',NX*NY,IABTNB)
      CALL WKVECT(BOITE//'.BT2DLC','V V I',1+NX*NY,IABTLC)

      ZI(IABTDI-1+1) = NX
      ZI(IABTDI-1+2) = NY

      ZR(IABTVR-1+1) = XMIN
      ZR(IABTVR-1+2) = XMAX
      ZR(IABTVR-1+3) = YMIN
      ZR(IABTVR-1+4) = YMAX
      ZR(IABTVR-1+5) = DX
      ZR(IABTVR-1+6) = DY



C     3. : ON COMPTE COMBIEN DE TRIA3 SERONT CONTENUS
C             DANS CHAQUE BOITE(P,Q)
C     -------------------------------------------------------
      DO 60,I = 1,NTR3
        XXMIN = RBIG
        YYMIN = RBIG
        XXMAX = -RBIG
        YYMAX = -RBIG
        DO 30,K = 1,3
          INO = TRIA3(1+4* (I-1)+K)
          XXMIN = MIN(XXMIN,GEOM1(3* (INO-1)+1))
          XXMAX = MAX(XXMAX,GEOM1(3* (INO-1)+1))
          YYMIN = MIN(YYMIN,GEOM1(3* (INO-1)+2))
          YYMAX = MAX(YYMAX,GEOM1(3* (INO-1)+2))
   30   CONTINUE
        P1 = INT((XXMIN-XMIN)/DX) + 1
        P2 = INT((XXMAX-XMIN)/DX) + 1
        Q1 = INT((YYMIN-YMIN)/DY) + 1
        Q2 = INT((YYMAX-YMIN)/DY) + 1
        DO 50,P = P1,P2
          DO 40,Q = Q1,Q2
            ZI(IABTNB-1+ (Q-1)*NX+P) = ZI(IABTNB-1+ (Q-1)*NX+P) + 1
   40     CONTINUE
   50   CONTINUE

   60 CONTINUE



C     4. : ON REMPLIT .BT2DCO  ET .BT2DLC :
C     -------------------------------------------------------
      ZI(IABTLC-1+1) = 0
      DO 70,IB = 1,NX*NY
        ZI(IABTLC-1+IB+1) = ZI(IABTLC-1+IB) + ZI(IABTNB-1+IB)
        ZI(IABTNB-1+IB) = 0
   70 CONTINUE


      LONT = ZI(IABTLC-1+1+NX*NY)
      CALL WKVECT(BOITE//'.BT2DCO','V V I',LONT,IABTCO)

      DO 110,I = 1,NTR3
        XXMIN = RBIG
        YYMIN = RBIG
        XXMAX = -RBIG
        YYMAX = -RBIG
        DO 80,K = 1,3
          INO = TRIA3(1+4* (I-1)+K)
          XXMIN = MIN(XXMIN,GEOM1(3* (INO-1)+1))
          XXMAX = MAX(XXMAX,GEOM1(3* (INO-1)+1))
          YYMIN = MIN(YYMIN,GEOM1(3* (INO-1)+2))
          YYMAX = MAX(YYMAX,GEOM1(3* (INO-1)+2))
   80   CONTINUE
        P1 = INT((XXMIN-XMIN)/DX) + 1
        P2 = INT((XXMAX-XMIN)/DX) + 1
        Q1 = INT((YYMIN-YMIN)/DY) + 1
        Q2 = INT((YYMAX-YMIN)/DY) + 1
        DO 100,P = P1,P2
          DO 90,Q = Q1,Q2
            ZI(IABTNB-1+ (Q-1)*NX+P) = ZI(IABTNB-1+ (Q-1)*NX+P) + 1
            IPOSI = ZI(IABTLC-1+ (Q-1)*NX+P) + ZI(IABTNB-1+ (Q-1)*NX+P)
            IF ((IPOSI.LT.1) .OR. (IPOSI.GT.LONT)) CALL UTMESS('F',
     &          'PJ2DFB','STOP 3')
            ZI(IABTCO-1+IPOSI) = I
   90     CONTINUE
  100   CONTINUE

  110 CONTINUE

      DBG = .FALSE.
      IF (DBG) CALL UTIMSD('MESSAGE',2,.FALSE.,.TRUE.,BOITE,1,' ')
      CALL JEDEMA()
      END
