      SUBROUTINE PJ4DCO(MOCLE,MOA1,MOA2,NBMA1,LIMA1,NBNO2,LINO2,
     &                  GEOM1,GEOM2,CORRES,LDMAX,DISTMA,ALARM2)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXATR
      CHARACTER*16 CORRES,K16BID,NOMCMD
      CHARACTER*(*) GEOM1,GEOM2
      CHARACTER*8  MOA1,MOA2
      CHARACTER*(*) MOCLE,ALARM2
      INTEGER NBMA1,LIMA1(*),NBNO2,LINO2(*),INO2M
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
C   MOA1 DANS LE CAS OU MOA1 EST 2.5D (SURFACE EN 3D)
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
C  IN   ALARM2  K3   : /' '/'OUI'/'NON' :
C                       POUR "FORCER" L'EMMISSION (OU NON) DES ALARMES

C  IN/JXOUT  CORRES  K16 : NOM DE LA SD CORRESP_2_MAILLA
C ----------------------------------------------------------------------
C
C
C
      CHARACTER*8  KB,M1,M2,NONO2,ALARME
      CHARACTER*14 BOITE
      CHARACTER*16 CORTR3
      INTEGER      NBTM,NBTMX
      PARAMETER   (NBTMX=15)
      INTEGER      NUTM(NBTMX)
      CHARACTER*8  ELRF(NBTMX)

      INTEGER IFM,NIV,IBID,IE,NNO1,NNO2,NMA1,NMA2,K
      INTEGER IMA,INO2,ICO
      INTEGER IATR3,IACOO1,IACOO2,IABTDI,IABTVR,IABTNB,IABTLC
      INTEGER IABTCO,JXXK1,IACONU,IACOCF,IACOTR
      INTEGER IALIM1,IALIN1,IACNX1,ILCNX1,IALIN2,IATYM1
      INTEGER IACONB,ITYPM,IDECAL,ITR3,NBTROU

      LOGICAL DBG,LDMAX,LOIN,LOIN2,LRAFF
      REAL*8  DISTMA,DMIN,COBARY(3)

      INTEGER    NBMAX
      PARAMETER (NBMAX=5)
      INTEGER    TINO2M(NBMAX),NBNOD,NBNODM,II
      REAL*8     TDMIN2(NBMAX),UMESSR(4)
      INTEGER      IARG

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
      CALL WKVECT(CORTR3//'.PJXX_K1','V V K24',5,JXXK1)
      ZK24(JXXK1-1+1)=M1
      ZK24(JXXK1-1+2)=M2
      ZK24(JXXK1-1+3)='COLLOCATION'
      CALL WKVECT(CORTR3//'.PJEF_NB','V V I',NNO2,IACONB)
      CALL WKVECT(CORTR3//'.PJEF_NU','V V I',4*NNO2,IACONU)
      CALL WKVECT(CORTR3//'.PJEF_CF','V V R',3*NNO2,IACOCF)
      CALL WKVECT(CORTR3//'.PJEF_TR','V V I',NNO2,IACOTR)


C     ON CHERCHE POUR CHAQUE NOEUD INO2 DE M2 LE TRIA3
C     AUQUEL IL APPARTIENT AINSI QUE SES COORDONNEES
C     BARYCENTRIQUES DANS CE TRIA3 :
C     ------------------------------------------------
      IDECAL= 0
      LOIN2 = .FALSE.
      NBNOD  = 0
      NBNODM = 0
      DO 6,INO2=1,NNO2
         IF (ZI(IALIN2-1+INO2).EQ.0) GO TO 6
         CALL PJ4DAP(INO2,ZR(IACOO2),M2,ZR(IACOO1),ZI(IATR3),
     &            COBARY,ITR3,NBTROU,ZI(IABTDI),ZR(IABTVR),ZI(IABTNB),
     &            ZI(IABTLC),ZI(IABTCO),IFM,NIV,LDMAX,DISTMA,LOIN,DMIN)
         IF (LOIN) THEN
            LOIN2=.TRUE.
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
      IF (LOIN2) THEN
         ALARME='OUI'
         CALL GETRES(K16BID,K16BID,NOMCMD)
         IF (NOMCMD.EQ.'PROJ_CHAMP') THEN
            CALL GETVTX(' ','ALARME',1,IARG,1,ALARME,IBID)
         ENDIF
         IF (ALARM2.NE.' ')  ALARME=ALARM2

         IF (ALARME.EQ.'OUI') THEN
            DO 70,II=1,NBNOD
               INO2M = TINO2M(II)
               CALL JENUNO(JEXNUM(M2//'.NOMNOE',INO2M),NONO2)
               UMESSR(1) = ZR(IACOO2+3*(INO2M-1)  )
               UMESSR(2) = ZR(IACOO2+3*(INO2M-1)+1)
               UMESSR(3) = ZR(IACOO2+3*(INO2M-1)+2)
               UMESSR(4) = TDMIN2(II)
               CALL U2MESG ('I','CALCULEL5_43',1,NONO2,0,0,4,UMESSR)
70          CONTINUE
            CALL JENUNO(JEXNUM(M2//'.NOMNOE',TINO2M(1)),NONO2)
            CALL U2MESG ('A','CALCULEL5_48',1,NONO2,1,NBNODM,
     &                                      1,TDMIN2(1))
         ENDIF
      ENDIF


C  5. ON TRANSFORME CORTR3 EN CORRES (RETOUR AUX VRAIES MAILLES)
C     ----------------------------------------------------------
      LRAFF=.FALSE.
      CALL PJ2DTR(CORTR3,CORRES,NUTM,ELRF,ZR(IACOO1),ZR(IACOO2),LRAFF)
      DBG=.FALSE.
      IF (DBG) THEN
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,'&&PJ4DCO',1,' ')
         CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,CORRES,1,' ')
      END IF
      CALL DETRSD('CORRESP_2_MAILLA',CORTR3)



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
