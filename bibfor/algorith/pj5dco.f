      SUBROUTINE PJ5DCO(MO1,MO2,CORRES)
      IMPLICIT NONE
      CHARACTER*16 CORRES
      CHARACTER*8  MO1,MO2
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ======================================================================
C     BUT :
C       CREER UNE SD CORRESP_2_MAILLA
C       DONNANT LA CORRESPONDANCE ENTRE LES NOEUDS DU MAILLAGE M1
C       ET CEUX DE M2 (DANS LE CAS DE MAILLAGE EN SEG2)
C
C  IN/JXIN   MO1      K8  : NOM DU MODELE INITIAL
C  IN/JXIN   MO2      K8  : NOM DU MODELE SUR LEQUEL ON VEUT PROJETER
C                           DES CHAMPS
C  IN/JXOUT  CORRES  K16 : NOM DE LA SD CORRESP_2_MAILLA
C
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER NBMAIL,NBDIM,IBID,IE,NNO1,NNO2,NBNO
      INTEGER LLIN1,LLIN2,INODE,NBTR,LNO1,LNO2,LCO1,LCO2,IDECAL
      INTEGER OUT1,OUT2,JCOO1,JCOO2,IACNX1,ILCNX1,NUMNOE
      INTEGER I,NBMANO,IMA,IMAIL,INO,J2XXK1,I2CONB,I2CONU,I2COCF
      PARAMETER (NBMAIL=10)
      PARAMETER (NBDIM=3)
      INTEGER NUMANO(NBMAIL),NUNOE(NBMAIL)
      REAL*8   A(NBDIM),B(NBDIM),M(NBDIM),R8MAEM,UN,DEUX
      REAL*8   DPMIN,L1,L2,XABS,DP,AM(NBDIM),BM(NBDIM),A1,A2,DIST
      CHARACTER*8   KB,M1,M2
      CHARACTER*16 LISIN1,LISIN2,LISOU1,LISOU2
      CHARACTER*16 NOEUD1,NOEUD2,COBAR1,COBAR2
      CHARACTER*24 COORMO,COORME,DIMEMO,DIMEME

C DEB ------------------------------------------------------------------
      CALL JEMARQ()

      UN = 1.D0
      DEUX = 2.D0

      CALL DISMOI('F','NOM_MAILLA', MO1,'MODELE',IBID,M1,IE)
      CALL DISMOI('F','NOM_MAILLA', MO2,'MODELE',IBID,M2,IE)

      CALL DISMOI('F','NB_NO_MAILLA', M1,'MAILLAGE',NNO1,KB,IE)
      CALL DISMOI('F','NB_NO_MAILLA', M2,'MAILLAGE',NNO2,KB,IE)

      IF (NNO2.EQ.0) CALL U2MESS('F','CALCULEL4_54')

C     DETERMINATION DE LA DIMENSION DE L'ESPACE :
C     --------------------------------------------------------
C
C     Initialisation des A, B et M
      DO 771 I=1,NBDIM
          A(I) = 0.D0
          B(I) = 0.D0
          M(I) = 0.D0
          AM(I) = 0.D0
          BM(I) = 0.D0
 771  CONTINUE

      COORMO = M1//'.COORDO    .VALE'
      CALL JEVEUO(COORMO,'L',JCOO1)

      COORME = M2//'.COORDO    .VALE'
      CALL JEVEUO(COORME,'L',JCOO2)

C     1. RECHECHE DES MAILLES LIEES AU NOEUD LE PLUS PROCHE
C     ------------------------------------------------
      LISIN1 = 'NOEUD_MODELE'
      CALL WKVECT (LISIN1, 'V V K8', NNO1, LLIN1)

      LISIN2 = 'NOEUD_MESURE'
      CALL WKVECT (LISIN2, 'V V K8', NNO2, LLIN2)

      LISOU1 = 'NOEUD_MODELE_VIS'
      LISOU2 = 'NOEUD_MESURE_VIS'

      DO 60 INODE = 1,NNO1
        CALL JENUNO (JEXNUM (M1//'.NOMNOE',INODE),
     &               ZK8(LLIN1-1+INODE))
 60   CONTINUE
      DO 61 INODE = 1,NNO2
        CALL JENUNO (JEXNUM (M2//'.NOMNOE',INODE),
     &               ZK8(LLIN2-1+INODE))
 61   CONTINUE

      CALL PACOA2 (LISIN1, LISIN2, NNO1, NNO2, M1, M2,
     &             LISOU1, LISOU2, NBTR)
      IF (NBTR .NE. NNO2) CALL U2MESS('F','ALGORITH9_91')

      NOEUD1 = 'NOEUD_DEBUT'
      CALL WKVECT (NOEUD1, 'V V I', NBTR, LNO1)

      NOEUD2 = 'NOEUD_FIN'
      CALL WKVECT (NOEUD2, 'V V I', NBTR, LNO2)

      COBAR1 = 'COEFF_DEBUT'
      CALL WKVECT (COBAR1, 'V V R', NBTR, LCO1)

      COBAR2 = 'COEFF_FIN'
      CALL WKVECT (COBAR2, 'V V R', NBTR, LCO2)

      CALL JEVEUO(LISOU1,'L',OUT1)
      CALL JEVEUO(LISOU2,'L',OUT2)

      CALL JEVEUO(M1//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(M1//'.CONNEX','LONCUM'),'L',ILCNX1)

C     2. RECHECHE DE LA MAILLE LE PLUS PROCHE DU NOEUD MESURE
C     ------------------------------------------------
      DO 62 INODE = 1,NBTR
        CALL JENONU(JEXNOM(M2//'.NOMNOE',ZK8(OUT2-1+INODE)),NUMNOE)
        DO 22 I = 1 , NBDIM
          M(I) = ZR(JCOO2-1 +(NUMNOE-1)*NBDIM+I)
 22     CONTINUE

        CALL JENONU(JEXNOM(M1//'.NOMNOE',ZK8(OUT1-1+INODE)),NUMNOE)
        CALL EXMANO(M1,NUMNOE,NUMANO,NBMANO)
        IF (NBMANO.EQ.0) CALL U2MESS('F','ALGORITH9_92')
        DPMIN = R8MAEM()
        DO 63 IMA = 1,NBMANO
          IMAIL = NUMANO(IMA)
          NBNO=ZI(ILCNX1-1 +IMAIL+1)-ZI(ILCNX1-1 +IMAIL)
C     THEORIQUEMENT NBNO = 2 (POUR SEG2)
          DO 31 INO=1,NBNO
            NUNOE(INO)=ZI(IACNX1-1 +ZI(ILCNX1-1 +IMAIL)-1+INO)
 31       CONTINUE
          DO 32 I = 1,NBDIM
            A(I) = ZR(JCOO1-1 +(NUNOE(1)-1)*NBDIM+I)
            B(I) = ZR(JCOO1-1 +(NUNOE(2)-1)*NBDIM+I)
 32       CONTINUE

C     3. CALCUL DE LA DISTANCE NOEUD-MAILLE (AM + BM)
C     ------------------------------------------------
          DO 33 I = 1,NBDIM
            AM(I)=M(I)-A(I)
            BM(I)=M(I)-B(I)
 33       CONTINUE

          A1 = 0.D0
          A2 = 0.D0
          DO 34 I = 1,NBDIM
            A1= A1 + AM(I)*AM(I)
            A2= A2 + BM(I)*BM(I)
 34       CONTINUE
          DIST = SQRT(A1)+SQRT(A2)

          IF (DIST .LT. DPMIN) THEN
            DPMIN = DIST

C     4. CALCUL DES COORDONNEES BARYCENTRIQUES
C     ------------------------------------------------
            CALL PJ3DA4(M,A,B,L1,L2,DP)
            ZI(LNO1-1 +INODE) = NUNOE(1)
            ZI(LNO2-1 +INODE) = NUNOE(2)
            ZR(LCO1-1 +INODE) = L1
            ZR(LCO2-1 +INODE) = L2
          ENDIF
 63     CONTINUE

C     5. APPLICATION FONCTION DE FORME (ELEMENT ISOPARAMETRIQUE)
C     ---------------------------------------------------
C     XABS : ABSCISSE DU POINT DANS L'ELEMENT DE REFERENCE (SEG2)
        XABS = -UN*ZR(LCO1-1 +INODE) + UN*ZR(LCO2-1 +INODE)
        ZR(LCO1-1 +INODE) = (UN-XABS)/DEUX
        ZR(LCO2-1 +INODE) = (UN+XABS)/DEUX
 62   CONTINUE

C     6. CREATION DE LA SD CORRESP_2_MAILLA : CORRES
C     ---------------------------------------------------
      CALL WKVECT(CORRES//'.PJXX_K1','V V K24',5,J2XXK1)
      CALL WKVECT(CORRES//'.PJEF_NB','V V I',NNO2,I2CONB)
      CALL WKVECT(CORRES//'.PJEF_NU','V V I',NNO2*2,I2CONU)
      CALL WKVECT(CORRES//'.PJEF_CF','V V R',NNO2*2,I2COCF)

      ZK24(J2XXK1-1 +1)=M1
      ZK24(J2XXK1-1 +2)=M2
      ZK24(J2XXK1-1 +3)='COLLOCATION'

      DO 10, INO=1,NNO2
        ZI(I2CONB-1 +INO)=2
 10   CONTINUE

      IDECAL=0
      DO 20, INO=1,NNO2
        ZI(I2CONU-1 +IDECAL+1)=ZI(LNO1-1 +INO)
        ZI(I2CONU-1 +IDECAL+2)=ZI(LNO2-1 +INO)
        ZR(I2COCF-1 +IDECAL+1)=ZR(LCO1-1 +INO)
        ZR(I2COCF-1 +IDECAL+2)=ZR(LCO2-1 +INO)
        IDECAL = IDECAL+ZI(I2CONB-1 +INO)
 20   CONTINUE

 9999 CONTINUE

      CALL JEDETR(LISIN1)
      CALL JEDETR(LISIN2)
      CALL JEDETR(NOEUD1)
      CALL JEDETR(NOEUD2)
      CALL JEDETR(COBAR1)
      CALL JEDETR(COBAR2)

      CALL JEDEMA()
      END
