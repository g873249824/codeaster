      SUBROUTINE PJ2DCO(MOCLE,MOA1,MOA2,NBMA1,LIMA1,NBNO2,LINO2,
     &                  GEOM1,GEOM2,CORRES,LDMAX,DISTMA)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXATR
      CHARACTER*16 CORRES
      CHARACTER*(*) GEOM1,GEOM2
      CHARACTER*8  MOA1,MOA2
      CHARACTER*(*) MOCLE
      INTEGER NBMA1,LIMA1(*),NBNO2,LINO2(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C BUT :
C   CREER UNE SD CORRESP_2_MAILLA
C   DONNANT LA CORRESPONDANCE ENTRE LES NOEUDS DE MOA2 ET LES MAILLES DE
C   MOA1 DANS LE CAS OU MOA1 EST 2D (SURFACE PLANE EN 2D)
C ======================================================================

C  POUR LES ARGUMENTS : MOCLE, MOA1, MOA2, NBMA1, LIMA1, NBNO2, LINO2
C  VOIR LE CARTOUCHE DE PJXXUT.F

C  IN/JXIN   GEOM1    I   : OBJET JEVEUX CONTENANT LA GEOMETRIE DES
C                           NOEUDS DU MAILLAGE 1 (OU ' ')
C  IN/JXIN   GEOM2    I   : OBJET JEVEUX CONTENANT LA GEOMETRIE DES
C                           NOEUDS DU MAILLAGE 2 (OU ' ')
C                REMARQUE:  LES OBJETS GEOM1 ET GEOM2 NE SONT UTILES
C                           QUE LORSQUE L'ON VEUT TRUANDER LA GEOMETRIE
C                           DES MAILLAGES

C  IN/JXOUT  CORRES  K16 : NOM DE LA SD CORRESP_2_MAILLA
C ----------------------------------------------------------------------
C
C
C
      CHARACTER*8  KB,M1,M2,NONO2
      CHARACTER*14 BOITE
      CHARACTER*16 CORTR3
      INTEGER      NBTM,NBTMX
      PARAMETER   (NBTMX=15)
      INTEGER      NUTM(NBTMX)
      CHARACTER*8  ELRF(NBTMX)

      INTEGER IFM,NIV,IE,NNO1,NNO2,NMA1,NMA2,K
      INTEGER IMA,INO2,ICO
      INTEGER IATR3,IACOO1,IACOO2,IABTDI,IABTVR,IABTNB,IABTLC
      INTEGER IABTCO,JXXK1,IACONU,IACOCF,IACOTR
      INTEGER IALIM1,IALIN1,IACNX1,ILCNX1,IALIN2,IATYM1
      INTEGER IACONB,ITYPM,IDECAL,ITR3,NBTROU

      LOGICAL DBG,LDMAX,LOIN,LRAFF
      REAL*8  DISTMA,DMIN,COBARY(3)

      INTEGER    NBMAX
      PARAMETER (NBMAX=5)
      INTEGER    TINO2M(NBMAX),NBNOD,NBNODM
      REAL*8     TDMIN2(NBMAX)

C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      CALL PJXXUT('2D',MOCLE,MOA1,MOA2,NBMA1,LIMA1,NBNO2,LINO2,M1,
     &                  M2,NBTMX,NBTM,NUTM,ELRF)

      CALL DISMOI('F','NB_NO_MAILLA', M1,'MAILLAGE',NNO1,KB,IE)
      CALL DISMOI('F','NB_NO_MAILLA', M2,'MAILLAGE',NNO2,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M1,'MAILLAGE',NMA1,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M2,'MAILLAGE',NMA2,KB,IE)

      CALL JEVEUO('&&PJXXCO.LIMA1','L',IALIM1)
      CALL JEVEUO('&&PJXXCO.LINO1','L',IALIN1)
      CALL JEVEUO('&&PJXXCO.LINO2','L',IALIN2)




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
          CALL ASSERT(.FALSE.)
        END IF
51    CONTINUE
      CALL WKVECT('&&PJXXCO.TRIA3','V V I',1+4*ICO,IATR3)
      ZI(IATR3-1+1)=ICO
      IF (ICO.EQ.0)
     &  CALL U2MESS('F','CALCULEL4_55')

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

      BOITE='&&PJ2DCO.BOITE'
      CALL PJ2DFB(BOITE,ZI(IATR3),ZR(IACOO1),ZR(IACOO2))
      CALL JEVEUO(BOITE//'.BT2DDI','L',IABTDI)
      CALL JEVEUO(BOITE//'.BT2DVR','L',IABTVR)
      CALL JEVEUO(BOITE//'.BT2DNB','L',IABTNB)
      CALL JEVEUO(BOITE//'.BT2DLC','L',IABTLC)
      CALL JEVEUO(BOITE//'.BT2DCO','L',IABTCO)

C     DESCRIPTION DE LA SD BOITE_2D :
C     BOITE_2D (K14) ::= RECORD
C      .BT2DDI   : OJB S V I  LONG=2
C      .BT2DVR   : OJB S V R  LONG=6
C      .BT2DNB   : OJB S V I  LONG=NX*NY
C      .BT2DLC   : OJB S V I  LONG=1+NX*NY
C      .BT2DCO   : OJB S V I  LONG=*

C      .BT2DDI(1) : NX=NOMBRE DE BOITES DANS LA DIRECTION X
C      .BT2DDI(2) : NY=NOMBRE DE BOITES DANS LA DIRECTION Y

C      .BT2DVR(1) : XMIN     .BT2DVR(2) : XMAX
C      .BT2DVR(3) : YMIN     .BT2DVR(4) : YMAX
C      .BT2DVR(5) : DX = (XMAX-XMIN)/NBX
C      .BT2DVR(6) : DY = (YMAX-YMIN)/NBY

C      .BT2DNB    : LONGUEURS DES BOITES
C      .BT2DNB(1) : NOMBRE DE TRIA3 CONTENUS DANS LA BOITE(1,1)
C      .BT2DNB(2) : NOMBRE DE TRIA3 CONTENUS DANS LA BOITE(2,1)
C      .BT2DNB(3) : ...
C      .BT2DNB(NX*NY) : NOMBRE DE TRIA3 CONTENUS DANS LA BOITE(NX,NY)

C      .BT2DLC    : LONGUEURS CUMULEES DE .BT2DCO
C      .BT2DLC(1) : 0
C      .BT2DLC(2) : BT2DLC(1)+NBTR3(BOITE(1,1))
C      .BT2DLC(3) : BT2DLC(2)+NBTR3(BOITE(2,1))
C      .BT2DLC(4) : ...

C      .BT2DCO    : CONTENU DES BOITES
C       SOIT   NBTR3 =NBTR3(BOITE(P,Q)=BT2DNB((Q-1)*NX+P)
C              DEBTR3=BT2DLC((Q-1)*NX+P)
C        DO K=1,NBTR3
C          TR3=.BT2DCO(DEBTR3+K)
C        DONE
C        TR3 EST LE NUMERO DU KIEME TRIA3 DE LA BOITE (P,Q)


C     4. CONSTRUCTION D'UN CORRESP_2_MAILLA TEMPORAIRE :CORTR3
C        (EN UTILISANT LES TRIA3 DEDUITS DU MAILLAGE M1)
C     ---------------------------------------------------
      CORTR3='&&PJ2DCO.CORRESP'
      CALL WKVECT(CORTR3//'.PJXX_K1','V V K24',5,JXXK1)
      ZK24(JXXK1-1+1)=M1
      ZK24(JXXK1-1+2)=M2
      ZK24(JXXK1-1+3)='COLLOCATION'
      CALL WKVECT(CORTR3//'.PJEF_NB','V V I',NNO2,IACONB)
      CALL WKVECT(CORTR3//'.PJEF_NU','V V I',3*NNO2,IACONU)
      CALL WKVECT(CORTR3//'.PJEF_CF','V V R',3*NNO2,IACOCF)
      CALL WKVECT(CORTR3//'.PJEF_TR','V V I',NNO2,IACOTR)


C     ON CHERCHE POUR CHAQUE NOEUD INO2 DE M2 LE TRIA3
C     AUQUEL IL APPARTIENT AINSI QUE SES COORDONNEES
C     BARYCENTRIQUES DANS CE TRIA3 :
C     ------------------------------------------------
      IDECAL=0
      NBNOD  = 0
      NBNODM = 0
      DO 6,INO2=1,NNO2
         IF (ZI(IALIN2-1+INO2).EQ.0) GO TO 6
         CALL PJ2DAP(INO2,ZR(IACOO2),M2,ZR(IACOO1),ZI(IATR3),
     &               COBARY,ITR3,NBTROU,ZI(IABTDI),ZR(IABTVR),
     &               ZI(IABTNB),ZI(IABTLC),ZI(IABTCO),IFM,NIV,
     &               LDMAX,DISTMA,LOIN,DMIN)
         IF (LOIN) THEN
            NBNODM = NBNODM + 1
         ENDIF
         CALL INSLRI(NBMAX,NBNOD,TDMIN2,TINO2M,DMIN,INO2)
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
61       CONTINUE
         IDECAL=IDECAL+ZI(IACONB-1+INO2)
 6    CONTINUE


C     -- EMISSION D'UN EVENTUEL MESSAGE D'ALARME:
C     A CE MOMENT DE L'ALGORITHME, L'ALARME EST PEUT ETRE INJUSTIFIEE
C     (VOIR FICHE 16186). ON ALARMERA MIEUX PLUS TARD (PJ2DTR).


C  5. ON TRANSFORME CORTR3 EN CORRES (RETOUR AUX VRAIES MAILLES)
C     ----------------------------------------------------------
      LRAFF=.TRUE.
      CALL PJ2DTR(CORTR3,CORRES,NUTM,ELRF,ZR(IACOO1),ZR(IACOO2),LRAFF)
      DBG=.FALSE.
      IF (DBG) THEN
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,'&&PJ2DCO',1,' ')
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,CORRES,1,' ')
      END IF
      CALL DETRSD('CORRESP_2_MAILLA',CORTR3)



      CALL JEDETR(BOITE//'.BT2DDI')
      CALL JEDETR(BOITE//'.BT2DVR')
      CALL JEDETR(BOITE//'.BT2DNB')
      CALL JEDETR(BOITE//'.BT2DLC')
      CALL JEDETR(BOITE//'.BT2DCO')

      CALL JEDETR('&&PJXXCO.TRIA3')
      CALL JEDETR('&&PJXXCO.LIMA1')
      CALL JEDETR('&&PJXXCO.LIMA2')
      CALL JEDETR('&&PJXXCO.LINO1')
      CALL JEDETR('&&PJXXCO.LINO2')
      CALL JEDEMA()
      END
