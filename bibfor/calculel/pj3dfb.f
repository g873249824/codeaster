      SUBROUTINE PJ3DFB(BOITE,MAILLZ,GEOM1,GEOM2)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      REAL*8 GEOM1(*),GEOM2(*)
      CHARACTER*14 BOITE
      CHARACTER*(*) MAILLZ
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
C       CONSTRUIRE LA STRUCTURE DE DONNEES BOITE_3D QUI PERMET DE SAVOIR
C       QUELLES SONT LES MAILLES QUI SE TROUVENT DANS UNE BOITE(P,Q,R)

C  IN/JXOUT   BOITE      K14 : NOM DE LA SD BOITE_3D A CREER
C  IN         GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
C  IN         GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
C  IN         MAILLZ   K*  : OBJET '&&PJXXCO.TETR4' OU '&&PJXXCO.TRIA3'
C                               OU '&&PJXXCO.SEG2'
C ----------------------------------------------------------------------


      REAL*8 STOTAL,DX,DY,DDX,DDY,RBIG,XXMAX,XXMIN,XMAX,XMIN
      REAL*8 YYMAX,YYMIN,YMAX,YMIN
      REAL*8 DZ,DDZ,ZMIN,ZMAX,ZZMIN,ZZMAX,R8MAEM
      CHARACTER*8 KB
      CHARACTER*24 MAILLE
      INTEGER P1,Q1,R1,P2,Q2,R2,P,Q,R,NX,NY,NZ,NDEC,NNO
      INTEGER IATR3,NTR3,IALIN1,IALIN2,NNO1,NNO2,I,IPOSI,IFM,NIV
      INTEGER IABTDI,IABTVR,IABTNB,IABTLC,K,INO,IB,LONT,IABTCO
      INTEGER NBTOT,NBMAX,NBMIN,ISMAEM ,NBTET
      LOGICAL DBG

C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
      MAILLE = MAILLZ
      IF (MAILLE(10:14).EQ.'TRIA3') THEN
        NDEC = 4
        NNO = 3
      ELSE IF (MAILLE(10:14).EQ.'TETR4') THEN
        NDEC = 6
        NNO = 4
      ELSE IF (MAILLE(10:13).EQ.'SEG2') THEN
        NDEC = 3
        NNO = 2
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
      CALL JEVEUO(MAILLE,'L',IATR3)
      NTR3 = ZI(IATR3-1+1)
      RBIG = R8MAEM()
      IF (NTR3.EQ.0) CALL U2MESS('F','CALCULEL4_57')

      CALL JEVEUO('&&PJXXCO.LINO1','L',IALIN1)
      CALL JEVEUO('&&PJXXCO.LINO2','L',IALIN2)
      CALL JELIRA('&&PJXXCO.LINO1','LONMAX',NNO1,KB)
      CALL JELIRA('&&PJXXCO.LINO2','LONMAX',NNO2,KB)


C     1. : ON CALCULE XMIN,XMAX,YMIN,YMAX,NX,NY,NZ,DX,DY,DZ...
C     -------------------------------------------------------
      XMIN = RBIG
      YMIN = RBIG
      ZMIN = RBIG
      XMAX = -RBIG
      YMAX = -RBIG
      ZMAX = -RBIG
      DO 10,I = 1,NNO1
        IF (ZI(IALIN1-1+I).EQ.0) GO TO 10
        XMIN = MIN(XMIN,GEOM1(3* (I-1)+1))
        XMAX = MAX(XMAX,GEOM1(3* (I-1)+1))
        YMIN = MIN(YMIN,GEOM1(3* (I-1)+2))
        YMAX = MAX(YMAX,GEOM1(3* (I-1)+2))
        ZMIN = MIN(ZMIN,GEOM1(3* (I-1)+3))
        ZMAX = MAX(ZMAX,GEOM1(3* (I-1)+3))
   10 CONTINUE
      DO 20,I = 1,NNO2
        IF (ZI(IALIN2-1+I).EQ.0) GO TO 20
        XMIN = MIN(XMIN,GEOM2(3* (I-1)+1))
        XMAX = MAX(XMAX,GEOM2(3* (I-1)+1))
        YMIN = MIN(YMIN,GEOM2(3* (I-1)+2))
        YMAX = MAX(YMAX,GEOM2(3* (I-1)+2))
        ZMIN = MIN(ZMIN,GEOM2(3* (I-1)+3))
        ZMAX = MAX(ZMAX,GEOM2(3* (I-1)+3))
   20 CONTINUE


      STOTAL = MAX((XMAX-XMIN), (YMAX-YMIN), (ZMAX-ZMIN))
      IF (STOTAL.EQ.0.D0) CALL U2MESS('F','CALCULEL4_58')
      DX = 2.D0*STOTAL/(DBLE(NTR3)** (1.D0/3.D0))

      DY = DX
      DZ = DX

      NX = INT((XMAX-XMIN)*1.05D0/DX) + 1
      NY = INT((YMAX-YMIN)*1.05D0/DY) + 1
      NZ = INT((ZMAX-ZMIN)*1.05D0/DZ) + 1
      CALL ASSERT(NX*NY*NZ.NE.0)
      DDX = (NX*DX- (XMAX-XMIN))/2.D0
      DDY = (NY*DY- (YMAX-YMIN))/2.D0
      DDZ = (NZ*DZ- (ZMAX-ZMIN))/2.D0
      XMIN = XMIN - DDX
      XMAX = XMAX + DDX
      YMIN = YMIN - DDY
      YMAX = YMAX + DDY
      ZMIN = ZMIN - DDZ
      ZMAX = ZMAX + DDZ

      IF (NIV.GT.1) THEN
        WRITE (IFM,*)
        WRITE (IFM,*) '-----------------------------------------'
        WRITE (IFM,*) ' MISE EN BOITES DES ELEMENTS DU MODELE_1'
        WRITE (IFM,*) '-----------------------------------------'
        WRITE (IFM,*)
        WRITE (IFM,*)'ZONE DE TRAVAIL : XMIN,XMAX=',XMIN,XMAX
        WRITE (IFM,*)'                  YMIN,YMAX=',YMIN,YMAX
        WRITE (IFM,*)'                  ZMIN,ZMAX=',ZMIN,YMAX
        WRITE (IFM,*)
        WRITE (IFM,*)'NOMBRE DE BOITES :'
        WRITE (IFM,*)'  DANS LES DIRECTIONS X,Y,Z :',NX,' ',NY,' ',NZ
        WRITE (IFM,*)'  TOTAL                     :',NX*NY*NZ
        WRITE (IFM,*)
        WRITE (IFM,*)'DIMENSIONS DES BOITES LX,LY,LZ=',DX,DY,DZ
      END IF


C     2. : ALLOCATION DE LA SD BOITE_3D :
C     ---------------------------------------
      CALL WKVECT(BOITE//'.BT3DDI','V V I',3,IABTDI)
      CALL WKVECT(BOITE//'.BT3DVR','V V R',9,IABTVR)
      CALL WKVECT(BOITE//'.BT3DNB','V V I',NX*NY*NZ,IABTNB)
      CALL WKVECT(BOITE//'.BT3DLC','V V I',1+NX*NY*NZ,IABTLC)

      ZI(IABTDI-1+1) = NX
      ZI(IABTDI-1+2) = NY
      ZI(IABTDI-1+3) = NZ

      ZR(IABTVR-1+1) = XMIN
      ZR(IABTVR-1+2) = XMAX
      ZR(IABTVR-1+3) = YMIN
      ZR(IABTVR-1+4) = YMAX
      ZR(IABTVR-1+5) = ZMIN
      ZR(IABTVR-1+6) = ZMAX
      ZR(IABTVR-1+7) = DX
      ZR(IABTVR-1+8) = DY
      ZR(IABTVR-1+9) = DZ



C     3. : ON COMPTE COMBIEN DE MAILLES SERONT CONTENUES
C             DANS CHAQUE BOITE(P,Q,R)
C     -------------------------------------------------------
      DO 70,I = 1,NTR3
        XXMIN = RBIG
        YYMIN = RBIG
        ZZMIN = RBIG
        XXMAX = -RBIG
        YYMAX = -RBIG
        ZZMAX = -RBIG
        DO 30,K = 1,NNO
          INO = ZI(IATR3+NDEC* (I-1)+K)
          XXMIN = MIN(XXMIN,GEOM1(3* (INO-1)+1))
          XXMAX = MAX(XXMAX,GEOM1(3* (INO-1)+1))
          YYMIN = MIN(YYMIN,GEOM1(3* (INO-1)+2))
          YYMAX = MAX(YYMAX,GEOM1(3* (INO-1)+2))
          ZZMIN = MIN(ZZMIN,GEOM1(3* (INO-1)+3))
          ZZMAX = MAX(ZZMAX,GEOM1(3* (INO-1)+3))
   30   CONTINUE
        P1 = INT((XXMIN-XMIN)/DX) + 1
        P2 = INT((XXMAX-XMIN)/DX) + 1
        Q1 = INT((YYMIN-YMIN)/DY) + 1
        Q2 = INT((YYMAX-YMIN)/DY) + 1
        R1 = INT((ZZMIN-ZMIN)/DZ) + 1
        R2 = INT((ZZMAX-ZMIN)/DZ) + 1
        DO 60,P = P1,P2
          DO 50,Q = Q1,Q2
            DO 40,R = R1,R2
              ZI(IABTNB-1+ (R-1)*NX*NY+ (Q-1)*NX+P) = ZI(IABTNB-1+
     &          (R-1)*NX*NY+ (Q-1)*NX+P) + 1
   40       CONTINUE
   50     CONTINUE
   60   CONTINUE

   70 CONTINUE

C     3.2: IMPRESSION DU NOMBRE DE TETRAEDRES PAR BOITE :
      IF (NIV.GT.1) THEN
        NBTOT=0
        NBMAX=0
        NBMIN=ISMAEM()
        DO 61,P = 1,NX
          DO 51,Q = 1,NY
            DO 41,R = 1,NZ
              NBTET= ZI(IABTNB-1+ (R-1)*NX*NY+ (Q-1)*NX+P)
           WRITE (IFM,*)'P,Q,R,NBTET=',P,Q,R,NBTET
              NBTOT=NBTOT+ NBTET
              NBMIN=MIN(NBMIN,NBTET)
              NBMAX=MAX(NBMAX,NBTET)
   41       CONTINUE
   51     CONTINUE
   61   CONTINUE
        WRITE (IFM,*)
        WRITE (IFM,*)'NOMBRE DE TETRAEDRES PAR BOITE:'
        WRITE (IFM,*)'   EN MOYENNE :',NBTOT/(NX*NY*NZ)
        WRITE (IFM,*)'   MIN        :',NBMIN
        WRITE (IFM,*)'   MAX        :',NBMAX
      END IF



C     4. : ON REMPLIT .BT3DCO  ET .BT3DLC :
C     -------------------------------------------------------
      ZI(IABTLC-1+1) = 0
      DO 80,IB = 1,NX*NY*NZ
        ZI(IABTLC-1+IB+1) = ZI(IABTLC-1+IB) + ZI(IABTNB-1+IB)
        ZI(IABTNB-1+IB) = 0
   80 CONTINUE


      LONT = ZI(IABTLC-1+1+NX*NY*NZ)
      CALL WKVECT(BOITE//'.BT3DCO','V V I',LONT,IABTCO)

      DO 130,I = 1,NTR3
        XXMIN = RBIG
        YYMIN = RBIG
        ZZMIN = RBIG
        XXMAX = -RBIG
        YYMAX = -RBIG
        ZZMAX = -RBIG
        DO 90,K = 1,NNO
          INO = ZI(IATR3+NDEC* (I-1)+K)
          XXMIN = MIN(XXMIN,GEOM1(3* (INO-1)+1))
          XXMAX = MAX(XXMAX,GEOM1(3* (INO-1)+1))
          YYMIN = MIN(YYMIN,GEOM1(3* (INO-1)+2))
          YYMAX = MAX(YYMAX,GEOM1(3* (INO-1)+2))
          ZZMIN = MIN(ZZMIN,GEOM1(3* (INO-1)+3))
          ZZMAX = MAX(ZZMAX,GEOM1(3* (INO-1)+3))
   90   CONTINUE
        P1 = INT((XXMIN-XMIN)/DX) + 1
        P2 = INT((XXMAX-XMIN)/DX) + 1
        Q1 = INT((YYMIN-YMIN)/DY) + 1
        Q2 = INT((YYMAX-YMIN)/DY) + 1
        R1 = INT((ZZMIN-ZMIN)/DZ) + 1
        R2 = INT((ZZMAX-ZMIN)/DZ) + 1
        DO 120,P = P1,P2
          DO 110,Q = Q1,Q2
            DO 100,R = R1,R2
              ZI(IABTNB-1+ (R-1)*NX*NY+ (Q-1)*NX+P) = ZI(IABTNB-1+
     &          (R-1)*NX*NY+ (Q-1)*NX+P) + 1
              IPOSI = ZI(IABTLC-1+ (R-1)*NX*NY+ (Q-1)*NX+P) +
     &                ZI(IABTNB-1+ (R-1)*NX*NY+ (Q-1)*NX+P)
              CALL ASSERT((IPOSI.GE.1) .AND. (IPOSI.LE.LONT))
              ZI(IABTCO-1+IPOSI) = I
  100       CONTINUE
  110     CONTINUE
  120   CONTINUE

  130 CONTINUE

      DBG = .FALSE.
      IF (DBG) CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,BOITE,1,' ')
      CALL JEDEMA()
      END
