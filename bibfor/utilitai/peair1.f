      SUBROUTINE PEAIR1 ( MODELE, NBMA, LISMA, AIRE, LONG )
      IMPLICIT   NONE
      INTEGER          NBMA, LISMA(*)
      REAL*8           AIRE, LONG ,DDOT
      CHARACTER*(*)    MODELE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C
C     CALCUL DE L'AIRE_INTERNE A UN CONTOUR
C     IN : MODELE : NOM DU MODELE
C     IN : LISMA (NBMA) : LISTE DES NUMEROS DE MAILLES DU CONTOUR FERME
C     OUT : AIRE : AIRE DELIMITEE PAR LE CONTOUR
C     OUT : LONG : LONGUEUR DU CONTOUR
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32  JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER JMA,IE,IFM,NIV,JNOMA,IDTYMA,JN1,JN2,IMA,NUMA,IDCOOR
      INTEGER NUTYMA,NBEL,JDNO,NO1,NO2,NO3,NBEXT1,NBEXT2,IEXT1
      INTEGER IEXT2,NI1,NI2,NJ1,NJ2,NBE,NJ3,NJ0,JDCO,JM1
      REAL*8 ORIG(3),ZERO,VGN1(3),VN1N2(3),AIRE1,AIRE2,VGN3(3),VN1N3(3)
      REAL*8 XX1(3),XX2(3),XX3(3),XN(3),PV(3),XNORM,VN3N2(3),VGN2(3)
      REAL*8 X1, Y1, Z1, X2, Y2, Z2, XXL
      CHARACTER*8   K8B, NOMA, NOMAIL, TYPEL
      CHARACTER*24  MLGNMA,MLGCNX,MLGCOO
C
      CALL JEMARQ ( )
C
      CALL INFNIV(IFM,NIV)
C
      ZERO    = 0.0D0
      ORIG(1) = ZERO
      ORIG(2) = ZERO
      ORIG(3) = ZERO
      CALL JEVEUO(MODELE(1:8)//'.MODELE    .NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
      MLGNMA = NOMA//'.NOMMAI'
      MLGCNX = NOMA//'.CONNEX'
C
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IDTYMA)
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',IDCOOR)
C
      CALL WKVECT('&&PEAIR1.NOEUD1' ,'V V I',NBMA*3,JN1)
      CALL WKVECT('&&PEAIR1.NOEUD2' ,'V V I',NBMA*3,JN2)
      CALL WKVECT('&&PEAIR1.MAILLES','V V I',NBMA  ,JM1)
C
C     VERIFICATION DU TYPE DES MAILLES ET STOCKAGE DES CONNECTIVITES
C
      LONG = 0.D0
      NBEL = 0
      DO 10 IMA = 1, NBMA
         NUMA = LISMA(IMA)
         CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMA),NOMAIL)
C
C        TYPE DE LA MAILLE COURANTE :
C
         NUTYMA = ZI(IDTYMA+NUMA-1)
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYMA),TYPEL)
C
         IF ( TYPEL(1:3) .NE. 'SEG' ) THEN
            CALL JENUNO(JEXNUM(MLGNMA,NUMA),NOMAIL)
            CALL UTMESS('F','PAAIR1','IMPOSSIBILITE, LA MAILLE '//
     &                  NOMAIL//' DOIT ETRE DE TYPE "SEG2" OU "SEG3"'//
     &                 'ET ELLE EST DE TYPE : '//TYPEL)
C        CALL U2MESK('F','UTILITAI3_40', 2 ,VALK)
         ENDIF
         NBEL = NBEL + 1
         CALL JEVEUO(JEXNUM(MLGCNX,NUMA),'L',JDNO)
         ZI(JN1-1+3*NBEL-2) = ZI(JDNO)
         ZI(JN1-1+3*NBEL-1) = ZI(JDNO+1)
         IF ( TYPEL(1:4) .EQ. 'SEG3' )  THEN
            ZI(JN1-1+3*NBEL) = ZI(JDNO+2)
            X1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+1-1)
            Y1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+2-1)
            Z1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+3-1)
            X2 = ZR(IDCOOR+3*(ZI(JDNO+2)-1)+1-1)
            Y2 = ZR(IDCOOR+3*(ZI(JDNO+2)-1)+2-1)
            Z2 = ZR(IDCOOR+3*(ZI(JDNO+2)-1)+3-1)
            XXL = (X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2) + (Z1-Z2)*(Z1-Z2)
            LONG = LONG + SQRT( XXL )
            X1 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+1-1)
            Y1 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+2-1)
            Z1 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+3-1)
            XXL = (X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2) + (Z1-Z2)*(Z1-Z2)
            LONG = LONG + SQRT( XXL )
         ELSE
            X1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+1-1)
            Y1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+2-1)
            Z1 = ZR(IDCOOR+3*(ZI(JDNO  )-1)+3-1)
            X2 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+1-1)
            Y2 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+2-1)
            Z2 = ZR(IDCOOR+3*(ZI(JDNO+1)-1)+3-1)
            XXL = (X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2) + (Z1-Z2)*(Z1-Z2)
            LONG = LONG + SQRT( XXL )
         ENDIF
  10  CONTINUE
      IF (NBMA.NE.NBEL) THEN
          CALL U2MESS('F','UTILITAI3_41')
      ENDIF
C
C     VERIFICATION QUE LE CONTOUR EST FERME
C
      NBEXT1=0
      NBEXT2=0
      DO 30 IMA = 1 , NBEL
         IEXT1=0
         IEXT2=0
         NI1 = ZI(JN1-1+3*IMA-2)
         NI2 = ZI(JN1-1+3*IMA-1)
         ZI(JM1-1+IMA)=IMA
         DO 40 JMA = 1 , NBEL
            IF (JMA.NE.IMA) THEN
               NJ1 = ZI(JN1-1+3*JMA-2)
               NJ2 = ZI(JN1-1+3*JMA-1)
               IF ((NI1.EQ.NJ2).OR.(NI1.EQ.NJ1))  IEXT1=1
               IF ((NI2.EQ.NJ1).OR.(NI2.EQ.NJ2))  IEXT2=1
            ENDIF
 40      CONTINUE
         IF (IEXT1.EQ.0)  NBEXT1=NBEXT1+1
         IF (IEXT2.EQ.0)  NBEXT2=NBEXT2+1
 30   CONTINUE
      IF ((NBEXT1.NE.0).AND.(NBEXT2.NE.0)) THEN
         CALL U2MESS('F','UTILITAI3_42')
      ENDIF
C
C     VERIFICATION QUE LE CONTOUR EST CONTINU ET REORIENTATION
C
      NBE=1
      ZI(JM1)=0
      ZI(JN2)=ZI(JN1)
      ZI(JN2+1)=ZI(JN1+1)
      ZI(JN2+2)=ZI(JN1+2)
 41   CONTINUE
      NI1 = ZI(JN2-1+3*NBE-2)
      NI2 = ZI(JN2-1+3*NBE-1)
      DO 42 JMA = 1 , NBEL
         IF ((ZI(JM1-1+JMA).NE.0)) THEN
            NJ1 = ZI(JN1-1+3*JMA-2)
            NJ2 = ZI(JN1-1+3*JMA-1)
            NJ3 = ZI(JN1-1+3*JMA)
            IF (NI2.EQ.NJ1) THEN
               NBE = NBE+1
               ZI(JN2-1+3*NBE-2)=NJ1
               ZI(JN2-1+3*NBE-1)=NJ2
               IF (NJ3.NE.0)  ZI(JN2-1+3*NBE)=NJ3
               GOTO 43
            ELSEIF (NI2.EQ.NJ2) THEN
               NBE = NBE+1
               ZI(JN2-1+3*NBE-2)=NJ2
               ZI(JN2-1+3*NBE-1)=NJ1
               IF (NJ3.NE.0)  ZI(JN2-1+3*NBE)=NJ3
               GOTO 43
            ENDIF
         ENDIF
 42   CONTINUE
      CALL U2MESS('F','UTILITAI3_43')
 43   CONTINUE
      ZI(JM1-1+JMA)=0
      IF (NBE.GE.NBMA) THEN
         GOTO 11
      ELSE
         GOTO 41
      ENDIF
 11   CONTINUE
      IF (NBMA.NE.NBE) THEN
          CALL U2MESS('F','UTILITAI3_44')
      ENDIF
      NJ2=ZI(JN2-1+3*NBE-1)
      NJ0=ZI(JN2)
      IF (NJ2.NE.NJ0) THEN
          CALL U2MESS('F','UTILITAI3_45')
      ENDIF
C
C     CALCUL DU CDG APPROXIMATIF
C
      MLGCOO = NOMA//'.COORDO    .VALE'
      CALL JEVEUO(MLGCOO,'L',JDCO)
      DO 50 IMA=1,NBMA
         NJ1 = ZI(JN2-1+3*IMA-2)
         ORIG(1) = ORIG(1)+ZR(JDCO-1+3*NJ1-2)
         ORIG(2) = ORIG(2)+ZR(JDCO-1+3*NJ1-1)
         ORIG(3) = ORIG(3)+ZR(JDCO-1+3*NJ1)
50    CONTINUE
      ORIG(1)=ORIG(1)/NBMA
      ORIG(2)=ORIG(2)/NBMA
      ORIG(3)=ORIG(3)/NBMA
C
C     CALCUL DE L'AIRE GM.VECT.DL
C
      NJ1 = ZI(JN2-1+1)
      NJ2 = ZI(JN2-1+2)
C
C     CALCUL DE LA NORMALE A LA COURBE SUPPOSEE PLANE
C
      XX1(1) = ZR(JDCO-1+3*NJ1-2)
      XX1(2) = ZR(JDCO-1+3*NJ1-1)
      XX1(3) = ZR(JDCO-1+3*NJ1)
      XX2(1) = ZR(JDCO-1+3*NJ2-2)
      XX2(2) = ZR(JDCO-1+3*NJ2-1)
      XX2(3) = ZR(JDCO-1+3*NJ2)
      CALL VDIFF(3,XX1,ORIG,VGN1)
      CALL VDIFF(3,XX2,ORIG,VGN2)
      CALL PROVEC(VGN1,VGN2,XN)
      CALL NORMEV(XN,XNORM)
      AIRE=0.D0
      DO 60 IMA=1,NBMA
         NJ1 = ZI(JN2-1+3*IMA-2)
         NJ2 = ZI(JN2-1+3*IMA-1)
         NJ3 = ZI(JN2-1+3*IMA)
         IF (NJ3.EQ.0) THEN
            XX1(1) = ZR(JDCO-1+3*NJ1-2)
            XX1(2) = ZR(JDCO-1+3*NJ1-1)
            XX1(3) = ZR(JDCO-1+3*NJ1)
            XX2(1) = ZR(JDCO-1+3*NJ2-2)
            XX2(2) = ZR(JDCO-1+3*NJ2-1)
            XX2(3) = ZR(JDCO-1+3*NJ2)
            CALL VDIFF(3,XX1,ORIG,VGN1)
            CALL VDIFF(3,XX2,XX1,VN1N2)
            CALL PROVEC(VGN1,VN1N2,PV)
            AIRE1=DDOT(3,PV,1,XN,1)
            AIRE=AIRE+AIRE1/2.D0
         ELSE
            XX1(1) = ZR(JDCO-1+3*NJ1-2)
            XX1(2) = ZR(JDCO-1+3*NJ1-1)
            XX1(3) = ZR(JDCO-1+3*NJ1)
            XX2(1) = ZR(JDCO-1+3*NJ2-2)
            XX2(2) = ZR(JDCO-1+3*NJ2-1)
            XX2(3) = ZR(JDCO-1+3*NJ2)
            XX3(1) = ZR(JDCO-1+3*NJ3-2)
            XX3(2) = ZR(JDCO-1+3*NJ3-1)
            XX3(3) = ZR(JDCO-1+3*NJ3)
            CALL VDIFF(3,XX1,ORIG,VGN1)
            CALL VDIFF(3,XX3,XX1,VN1N3)
            CALL PROVEC(VGN1,VN1N3,PV)
            AIRE1=DDOT(3,PV,1,XN,1)
            AIRE=AIRE+AIRE1/2.D0
            CALL VDIFF(3,XX3,ORIG,VGN3)
            CALL VDIFF(3,XX2,XX3,VN3N2)
            CALL PROVEC(VGN3,VN3N2,PV)
            AIRE2=DDOT(3,PV,1,XN,1)
            AIRE=AIRE+AIRE2/2.D0
         ENDIF
60    CONTINUE
      CALL JEDETR ( '&&PEAIR1.NOEUD1'  )
      CALL JEDETR ( '&&PEAIR1.NOEUD2'  )
      CALL JEDETR ( '&&PEAIR1.MAILLES' )
      CALL JEDEMA ( )
      END
