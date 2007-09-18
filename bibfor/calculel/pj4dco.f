      SUBROUTINE PJ4DCO(MOCLE,MO1,MO2,NBMA1,LIMA1,NBNO2,LINO2,
     &                  GEOM1,GEOM2,CORRES,LDMAX,DISTMA)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 CORRES
      CHARACTER*(*) GEOM1,GEOM2
      CHARACTER*8  MO1,MO2
      CHARACTER*(*) MOCLE
      INTEGER NBMA1,LIMA1(*),NBNO2,LINO2(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/09/2007   AUTEUR DURAND C.DURAND 
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
C       CREER UNE SD CORRESP_2_MAILLA
C       DONNANT LA CORRESPONDANCE ENTRE LES NOEUDS DU MAILLAGE M1
C       ET CEUX DE M2 (DANS LE CAS DE MAILLAGES 2.5D : SURFACES EN 3D)
C
C  IN        MOCLE    K*: /'TOUT':ON CHERCHE LA CORRESPONDANCE ENTRE
C                           TOUS LES NOEUDS DE MO2 ET LES MAILLES DE MO1
C                         /'PARTIE':ON CHERCHE LA CORRESPONDANCE ENTRE
C                           LES NOEUDS DE LINO2 ET LES MAILLES DE LIMA1
C  IN/JXIN   MO1      K8  : NOM DU MODELE INITIAL
C  IN/JXIN   MO2      K8  : NOM DU MODELE SUR LEQUEL ON VEUT PROJETER
C                           DES CHAMPS

C  IN        NBMA1    I   : NOMBRE DE MAILLES DE LIMA1
C  IN        LIMA1(*) I   : LISTE DE NUMEROS DE MAILLES
C  IN        NBNO2    I   : NOMBRE DE NOEUDS DE LINO2
C  IN        LINO2(*) I   : LISTE DE NUMEROS DE NOEUDS

C  IN/JXIN   GEOM1    I   : OBJET JEVEUX CONTENANT LA GEOMETRIE DES
C                           NOEUDS DU MAILLAGE 1 (OU ' ')
C  IN/JXIN   GEOM2    I   : OBJET JEVEUX CONTENANT LA GEOMETRIE DES
C                           NOEUDS DU MAILLAGE 2 (OU ' ')
C                REMARQUE:  LES OBJETS GEOM1 ET GEOM2 NE SONT UTILES
C                           QUE LORSQUE L'ON VEUT TRUANDER LA GEOMETRIE
C                           DES MAILLAGES DES MODELES MO1 ET MO2.

C  IN/JXOUT  CORRES  K16 : NOM DE LA SD CORRESP_2_MAILLA
C
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
      REAL*8   COBARY(3)
      CHARACTER*8   KB,M1,M2,NONO2
      CHARACTER*16 CORTR3
      CHARACTER*14 BOITE
      PARAMETER  (NBTM=6)
      INTEGER     NUTM(NBTM), IFM, NIV
      CHARACTER*8 NOTM(NBTM), ELRF(NBTM)
      LOGICAL DBG

      LOGICAL LDMAX
      REAL*8  DISTMA
C DEB ------------------------------------------------------------------
      CALL JEMARQ()

      CALL DISMOI('F','NOM_MAILLA', MO1,'MODELE',IBID,M1,IE)
      CALL DISMOI('F','NOM_MAILLA', MO2,'MODELE',IBID,M2,IE)
      CALL PJNOUT(MO2)

      CALL DISMOI('F','NB_NO_MAILLA', M1,'MAILLAGE',NNO1,KB,IE)
      CALL DISMOI('F','NB_NO_MAILLA', M2,'MAILLAGE',NNO2,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M1,'MAILLAGE',NMA1,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M2,'MAILLAGE',NMA2,KB,IE)

      CALL INFNIV(IFM,NIV)



C     1. ON CHERCHE LES MAILLES (ET LES NOEUDS) UTILES :
C        CE SONT LES MAILLES SURFACIQUES QUI PORTENT DES ELEMENTS FINIS
C        ET LES NOEUDS PORTES PAR CES MAILLES
C     -----------------------------------------------------------------

C     1.1 : MAILLES UTILES DE MO1:
C     ----------------------------
      NOTM(1)='TRIA3'
      NOTM(2)='TRIA6'
      NOTM(3)='TRIA7'
      NOTM(4)='QUAD4'
      NOTM(5)='QUAD8'
      NOTM(6)='QUAD9'

      ELRF(1)='TR3'
      ELRF(2)='TR6'
      ELRF(3)='TR7'
      ELRF(4)='QU4'
      ELRF(5)='QU8'
      ELRF(6)='QU9'

      DO 9,K=1,NBTM
        CALL JENONU(JEXNOM('&CATA.TM.NOMTM',NOTM(K)),NUTM(K))
9     CONTINUE

      CALL WKVECT('&&PJXXCO.LIMA1','V V I',NMA1,IALIM1)
      CALL JEVEUO(MO1//'.MAILLE','L',IAD)
      CALL JELIRA(MO1//'.MAILLE','LONMAX',LONG,KB)
      DO 1,I=1,LONG
        IF (ZI(IAD-1+I).NE.0) ZI(IALIM1-1+I)=1
1     CONTINUE
      CALL JEVEUO(M1//'.TYPMAIL','L',IAD)
      DO 11,J=1,NBTM
        DO 111,I=1,NMA1
          IF (ZI(IAD-1+I).EQ.NUTM(J)) ZI(IALIM1-1+I)=
     &        ZI(IALIM1-1+I)+1
111     CONTINUE
11    CONTINUE
      DO 12,I=1,NMA1
        IF (ZI(IALIM1-1+I).EQ.1) THEN
          ZI(IALIM1-1+I)=0
        ELSE IF (ZI(IALIM1-1+I).EQ.2) THEN
          ZI(IALIM1-1+I)=1
        ELSE IF (ZI(IALIM1-1+I).GT.2) THEN
          CALL ASSERT(.FALSE.)
        END IF
12    CONTINUE

      IF (MOCLE.EQ.'PARTIE') THEN
        DO 13,IMA1=1,NBMA1
          ZI(IALIM1-1+LIMA1(IMA1))=2*ZI(IALIM1-1+LIMA1(IMA1))
13      CONTINUE
        DO 14,IMA1=1,NMA1
          ZI(IALIM1-1+IMA1)=ZI(IALIM1-1+IMA1)/2
14      CONTINUE
      END IF


C     1.2 : NOEUDS UTILES DE MO1 ET MO2 :
C     -----------------------------------
      CALL WKVECT('&&PJXXCO.LINO1','V V I',NNO1,IALIN1)
      CALL JEVEUO(M1//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(M1//'.CONNEX','LONCUM'),'L',ILCNX1)
      DO 3,IMA=1,NMA1
        IF (ZI(IALIM1-1+IMA).EQ.0) GO TO 3
        NBNO=ZI(ILCNX1+IMA)-ZI(ILCNX1-1+IMA)
        DO 31,INO=1,NBNO
          NUNO=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+INO)
          ZI(IALIN1-1+NUNO)=1
31      CONTINUE
3     CONTINUE

      CALL WKVECT('&&PJXXCO.LINO2','V V I',NNO2,IALIN2)
      CALL JEVEUO(MO2//'.NOEUD_UTIL','L',IAD)
      IF (MOCLE.EQ.'TOUT') THEN
        DO 41,INO=1,NNO2
          IF (ZI(IAD-1+INO).NE.0) ZI(IALIN2-1+INO)=1
41      CONTINUE
      ELSE IF (MOCLE.EQ.'PARTIE') THEN
        DO 42,INO2=1,NBNO2
          IF (ZI(IAD-1+LINO2(INO2)).NE.0) ZI(IALIN2-1+LINO2(INO2))=1
42      CONTINUE
      END IF


C     ON ARRETE S'IL N'Y A PAS DE NOEUDS "2" :
C     ------------------------------------------------
      KK=0
      DO 43,K=1,NNO2
        IF (ZI(IALIN2-1+K).GT.0) KK=KK+1
43    CONTINUE
      IF (KK.EQ.0) CALL U2MESS('F','CALCULEL4_54')



C     2. ON DECOUPE TOUTES LES MAILLES 2D EN TRIA3
C     ------------------------------------------------
C        (EN CONSERVANT LE LIEN DE PARENTE):
C        ON CREE L'OBJET V='&&PJXXCO.TRIA3' : OJB S V I
C           LONG(V)=1+4*NTR3
C           V(1) : NTR3(=NOMBRE DE TRIA3)
C           V(1+4(I-1)+1) : NUMERO DU 1ER  NOEUD DU IEME TRIA3
C           V(1+4(I-1)+2) : NUMERO DU 2EME NOEUD DU IEME TRIA3
C           V(1+4(I-1)+3) : NUMERO DU 3EME NOEUD DU IEME TRIA3
C           V(1+4(I-1)+4) : NUMERO DE LA MAILLE MERE DU IEME TRIA3
      CALL JEVEUO(M1//'.TYPMAIL','L',IATYM1)
      ICO=0
      DO 51,IMA=1,NMA1
        IF (ZI(IALIM1-1+IMA).EQ.0) GO TO 51
        ITYPM=ZI(IATYM1-1+IMA)
        IF (ITYPM.EQ.NUTM(1)) THEN
          ICO=ICO+1
        ELSE IF (ITYPM.EQ.NUTM(2)) THEN
          ICO=ICO+1
        ELSE IF (ITYPM.EQ.NUTM(3)) THEN
          ICO=ICO+1
        ELSE IF (ITYPM.EQ.NUTM(4)) THEN
          ICO=ICO+2
        ELSE IF (ITYPM.EQ.NUTM(5)) THEN
          ICO=ICO+2
        ELSE IF (ITYPM.EQ.NUTM(6)) THEN
          ICO=ICO+2
        ELSE
          CALL U2MESS('F','ALGORITH_19')
      IF (ICO.EQ.0)
     &  CALL U2MESS('F','CALCULEL4_55')
        END IF
51    CONTINUE
      CALL WKVECT('&&PJXXCO.TRIA3','V V I',1+4*ICO,IATR3)
      ZI(IATR3-1+1)=ICO

      CALL JEVEUO(M1//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(M1//'.CONNEX','LONCUM'),'L',ILCNX1)
      ICO=0
      DO 52,IMA=1,NMA1
        IF (ZI(IALIM1-1+IMA).EQ.0) GO TO 52
        ITYPM=ZI(IATYM1-1+IMA)
C       -- CAS DES TRIANGLES :
        IF ((ITYPM.EQ.NUTM(1)).OR.(ITYPM.EQ.NUTM(2))
     &                        .OR.(ITYPM.EQ.NUTM(3))) THEN
          ICO=ICO+1
          ZI(IATR3+(ICO-1)*4+4)=IMA
          ZI(IATR3+(ICO-1)*4+1)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+1)
          ZI(IATR3+(ICO-1)*4+2)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+2)
          ZI(IATR3+(ICO-1)*4+3)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+3)
C       -- CAS DES QUADRANGLES :
        ELSE IF ((ITYPM.EQ.NUTM(4)).OR.(ITYPM.EQ.NUTM(5))
     &                             .OR.(ITYPM.EQ.NUTM(6))) THEN
          ICO=ICO+1
          ZI(IATR3+(ICO-1)*4+4)=IMA
          ZI(IATR3+(ICO-1)*4+1)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+1)
          ZI(IATR3+(ICO-1)*4+2)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+2)
          ZI(IATR3+(ICO-1)*4+3)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+3)
          ICO=ICO+1
          ZI(IATR3+(ICO-1)*4+4)=IMA
          ZI(IATR3+(ICO-1)*4+1)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+1)
          ZI(IATR3+(ICO-1)*4+2)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+3)
          ZI(IATR3+(ICO-1)*4+3)=ZI(IACNX1+ ZI(ILCNX1-1+IMA)-2+4)
        END IF
52    CONTINUE


C     3. ON MET LES TRIA3 EN BOITES :
C     ---------------------------------------------------
      IF (GEOM1.EQ.' ') THEN
        CALL JEVEUO(M1//'.COORDO    .VALE','L',IACOO1)
      ELSE
        CALL JEVEUO(GEOM1,'L',IACOO1)
      END IF
      IF (GEOM2.EQ.' ') THEN
        CALL JEVEUO(M2//'.COORDO    .VALE','L',IACOO2)
      ELSE
        CALL JEVEUO(GEOM2,'L',IACOO2)
      END IF

      BOITE='&&PJ4DCO.BOITE'
      CALL PJ3DFB(BOITE,'&&PJXXCO.TRIA3',ZR(IACOO1),ZR(IACOO2))
      CALL JEVEUO(BOITE//'.BT3DDI','L',IABTDI)
      CALL JEVEUO(BOITE//'.BT3DVR','L',IABTVR)
      CALL JEVEUO(BOITE//'.BT3DNB','L',IABTNB)
      CALL JEVEUO(BOITE//'.BT3DLC','L',IABTLC)
      CALL JEVEUO(BOITE//'.BT3DCO','L',IABTCO)

C     DESCRIPTION DE LA SD BOITE_3D :
C     BOITE_3D (K14) ::= RECORD
C      .BT3DDI   : OJB S V I  LONG=3
C      .BT3DVR   : OJB S V R  LONG=9
C      .BT3DNB   : OJB S V I  LONG=NX*NY*NZ
C      .BT3DLC   : OJB S V I  LONG=1+NX*NY*NZ
C      .BT3DCO   : OJB S V I  LONG=*

C      .BT3DDI(1) : NX=NOMBRE DE BOITES DANS LA DIRECTION X
C      .BT3DDI(2) : NY=NOMBRE DE BOITES DANS LA DIRECTION Y
C      .BT3DDI(3) : NZ=NOMBRE DE BOITES DANS LA DIRECTION Z

C      .BT3DVR(1) : XMIN     .BT3DVR(2) : XMAX
C      .BT3DVR(3) : YMIN     .BT3DVR(4) : YMAX
C      .BT3DVR(5) : ZMIN     .BT3DVR(6) : ZMAX
C      .BT3DVR(7) : DX = (XMAX-XMIN)/NBX
C      .BT3DVR(8) : DY = (YMAX-YMIN)/NBY
C      .BT3DVR(9) : DZ = (ZMAX-ZMIN)/NBZ

C      .BT3DNB    : LONGUEURS DES BOITES
C      .BT3DNB(1) : NOMBRE DE TRIA3 CONTENUS DANS LA BOITE(1,1,1)
C      .BT3DNB(2) : NOMBRE DE TRIA3 CONTENUS DANS LA BOITE(2,1,1)
C      .BT3DNB(3) : ...
C      .BT3DNB(NX*NY*NZ) : NOMBRE DE TRIA3 CONTENUS DANS LA
C                          DERNIERE BOITE(NX,NY,NZ)

C      .BT3DLC    : LONGUEURS CUMULEES DE .BT3DCO
C      .BT3DLC(1) : 0
C      .BT3DLC(2) : BT3DLC(1)+NBTR3(BOITE(1,1))
C      .BT3DLC(3) : BT3DLC(2)+NBTR3(BOITE(2,1))
C      .BT3DLC(4) : ...

C      .BT3DCO    : CONTENU DES BOITES
C       SOIT :
C        NBTR3 =NBTR3(BOITE(P,Q,R)=BT3DNB((R-1)*NY*NX+(Q-1)*NX+P)
C        DEBTR3=BT3DLC((R-1)*NY*NX+(Q-1)*NX+P)
C        DO K=1,NBTR3
C          TR3=.BT3DCO(DEBTR3+K)
C        DONE
C        TR3 EST LE NUMERO DU KIEME TRIA3 DE LA BOITE (P,Q,R)


C     4. CONSTRUCTION D'UN CORRESP_2_MAILLA TEMPORAIRE :CORTR3
C        (EN UTILISANT LES TRIA3 DEDUITS DU MAILLAGE M1)
C     ---------------------------------------------------
      CORTR3='&&PJ4DCO.CORRESP'
      CALL WKVECT(CORTR3//'.PJEF_NO','V V K8',2,IACONO)
      ZK8(IACONO-1+1)=M1
      ZK8(IACONO-1+2)=M2
      CALL WKVECT(CORTR3//'.PJEF_NB','V V I',NNO2,IACONB)
      CALL WKVECT(CORTR3//'.PJEF_NU','V V I',4*NNO2,IACONU)
      CALL WKVECT(CORTR3//'.PJEF_CF','V V R',3*NNO2,IACOCF)
      CALL WKVECT(CORTR3//'.PJEF_TR','V V I',NNO2,IACOTR)


C     ON CHERCHE POUR CHAQUE NOEUD INO2 DE M2 LE TRIA3
C     AUQUEL IL APPARTIENT AINSI QUE SES COORDONNEES
C     BARYCENTRIQUES DANS CE TRIA3 :
C     ------------------------------------------------
      IDECAL=0
      DO 6,INO2=1,NNO2
        IF (ZI(IALIN2-1+INO2).EQ.0) GO TO 6
        CALL PJ4DAP(INO2,ZR(IACOO2),M2,ZR(IACOO1),ZI(IATR3),
     &                COBARY,ITR3,NBTROU,ZI(IABTDI), ZR(IABTVR),
     &   ZI(IABTNB), ZI(IABTLC),ZI(IABTCO),IFM,NIV,LDMAX,DISTMA)

        IF (LDMAX.AND.(NBTROU.EQ.0)) THEN
          ZI(IACONB-1+INO2)=3
          ZI(IACOTR-1+INO2)=0
          GOTO 6
        END IF

        IF (NBTROU.EQ.0) THEN
          CALL JENUNO(JEXNUM(M2//'.NOMNOE',INO2),NONO2)
          CALL U2MESK('F','CALCULEL4_56',1,NONO2)
        END IF

        ZI(IACONB-1+INO2)=3
        ZI(IACOTR-1+INO2)=ITR3
        DO 61,K=1,3
          ZI(IACONU-1+IDECAL+K)= ZI(IATR3+4*(ITR3-1)+K)
          ZR(IACOCF-1+IDECAL+K)= COBARY(K)
61      CONTINUE
        IDECAL=IDECAL+ZI(IACONB-1+INO2)
 6    CONTINUE



C  5. ON TRANSFORME CORTR3 EN CORRES (RETOUR AUX VRAIES MAILLES)
C     ----------------------------------------------------------
      CALL PJ2DTR(CORTR3,CORRES,NUTM,ELRF)
      DBG=.FALSE.
      IF (DBG) THEN
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,'&&PJ4DCO',1,' ')
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,CORRES,1,' ')
      END IF
      CALL DETRSD('CORRESP_2_MAILLA',CORTR3)


 9999 CONTINUE

      CALL JEDETR(BOITE//'.BT3DDI')
      CALL JEDETR(BOITE//'.BT3DVR')
      CALL JEDETR(BOITE//'.BT3DNB')
      CALL JEDETR(BOITE//'.BT3DLC')
      CALL JEDETR(BOITE//'.BT3DCO')

      CALL JEDETR('&&PJXXCO.TRIA3')
      CALL JEDETR('&&PJXXCO.LIMA1')
      CALL JEDETR('&&PJXXCO.LIMA2')
      CALL JEDETR('&&PJXXCO.LINO1')
      CALL JEDETR('&&PJXXCO.LINO2')
      CALL JEDEMA()
      END
