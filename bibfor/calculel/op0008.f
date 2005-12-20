      SUBROUTINE OP0008(IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER IER
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/04/2005   AUTEUR VABHHTS J.PELLET 
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
C ......................................................................
C     COMMANDE:  CALC_VECT_ELEM

C ......................................................................
C ----- DEBUT --- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      LOGICAL FNOEVO
      INTEGER NBCHME,IBID,ICH,ICHA,IED,IERD,IRET,JLMAT,JLVF,NCHA,NH
      INTEGER NBSS,N1,N3,N4,N5,N6,N7,N9,N10,N11
      REAL*8 TIME,TPS(6),PARTPS(3),VCMPTH(3)
      COMPLEX*16 CBID
      LOGICAL EXITIM
      CHARACTER*8 MATEL,MODELE,CHA,CARA,KBID,K8BID
      CHARACTER*8 NOMCMP(6),MO1,TYCH,MATERI,NCMPTH(3),K8B
      CHARACTER*16 TYPE,OPER,SUROPT,TYPCO
      CHARACTER*19 CHAM19,VRESUL,CH19,LIGREL
      CHARACTER*24 TIME2,CHAM,VFONO,VAFONO,VMATEL,VMAT,CH24,MATE
      CHARACTER*24 SDTHET,THETA
      DATA NOMCMP/'INST    ','DELTAT  ','THETA   ','KHI     ',
     &     'R       ','RHO     '/
      DATA NCMPTH/'TEMP','TEMP_INF','TEMP_SUP'/
      DATA VCMPTH/3*0.D0/
      DATA TPS/0,2*1.0D0,3*0/

      CALL JEMARQ()
      CALL INFMAJ()
      VFONO = ' '
      VAFONO = ' '

      CALL GETRES(MATEL,TYPE,OPER)

      CALL GETVTX(' ','OPTION',0,1,1,SUROPT,N3)

C     - ON VERIFIE LE NOM DU MODELE:
C     -------------------------------
      MODELE = ' '
      CALL GETVID(' ','MODELE',0,1,1,MODELE,N1)
      CALL GETVID(' ','CHARGE',0,1,0,CHA,NCHA)


      IF (NCHA.LT.0) THEN
        NCHA = -NCHA
        CALL JECREO(MATEL//'.CHARGES','V V K8')
        N3=MAX(1,NCHA)
        CALL JEECRA(MATEL//'.CHARGES','LONMAX',N3,' ')
        CALL JEVEUO(MATEL//'.CHARGES','E',ICHA)
        CALL GETVID(' ','CHARGE',0,1,NCHA,ZK8(ICHA),IBID)

        CALL DISMOI('F','NOM_MODELE',ZK8(ICHA),'CHARGE',IBID,MO1,IED)
        IF ((N1.EQ.1) .AND. (MODELE.NE.MO1)) CALL UTMESS('F','OP0008',
     &      'LES CHARGES SONT INCOHERENTES AVEC LE MODELE.')

        MODELE = MO1
        DO 10,ICH = 1,NCHA
          CALL DISMOI('F','NOM_MODELE',ZK8(ICHA-1+ICH),'CHARGE',IBID,
     &                K8BID,IED)
          IF (K8BID.NE.MODELE) THEN
            CALL UTMESS('F','CALC_VECT_ELEM',
     &        'ERREUR: LES CHARGES NE S APPUIENT PAS TOUTES SUR LE MEME'
     &                  //' MODELE.')
          END IF
   10   CONTINUE
      END IF

      IF (SUROPT.EQ.'FORC_NODA') THEN
        CALL GETVID(' ','SIEF_ELGA',0,1,1,CHAM,N6)
      END IF

      IF (SUROPT.NE.'FORC_NODA') THEN
        CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,KBID,IED)
      ELSE
        NBSS = 0
      END IF


      CARA = ' '
      MATERI = ' '
      CALL GETVID(' ','CARA_ELEM',0,1,1,CARA,N5)
      CALL GETVID(' ','CHAM_MATER',0,1,1,MATERI,N4)
      IF (N4.NE.0) THEN
        CALL RCMFMC(MATERI,MATE)
      ELSE
        MATE = ' '
      END IF

      CALL GETVR8(' ','INST',0,1,1,TIME,N7)
      EXITIM = .FALSE.
      IF (N7.EQ.1) EXITIM = .TRUE.
      CALL GETVIS(' ','MODE_FOURIER',0,1,1,NH,N9)
      IF (N9.EQ.0) NH = 0

      IF (SUROPT.EQ.'CHAR_MECA_LAGR') THEN
        CALL GETVID(' ','THETA',0,1,1,SDTHET,N10)
        CALL GETVR8(' ','PROPAGATION',0,1,1,ALPHA,N11)
        CALL RSEXCH(SDTHET,'THETA',0,THETA,IRET)
        IF (IRET.GT.0) THEN
          CALL UTMESS('F','OP0008','LE CHAMP DE THETA EST INEXISTANT'
     &                //' DANS LA STRUCTURE DE DONNEES '//SDTHET//
     &                ' DE '//'TYPE THETA_GEOM .')
        END IF
        IF (N11.EQ.0) ALPHA = 0.0D0
      END IF

C     -- VERIFICATION DES CHARGES:
      IF ((SUROPT.EQ.'CHAR_MECA') .OR.
     &    (SUROPT.EQ.'CHAR_MECA_LAGR')) THEN
        DO 20,ICH = 1,NCHA
          CALL DISMOI('F','TYPE_CHARGE',ZK8(ICHA-1+ICH),'CHARGE',IBID,
     &                K8BID,IED)
          IF (K8BID(1:5).NE.'MECA_') THEN
            CALL UTMESS('F','CALC_VECT_ELEM',
     &                  'ERREUR: UNE DES CHARGES N''EST PAS MECANIQUE')
          END IF
   20   CONTINUE
      END IF

      IF ((SUROPT.EQ.'CHAR_THER')) THEN
        DO 30,ICH = 1,NCHA
          CALL DISMOI('F','TYPE_CHARGE',ZK8(ICHA-1+ICH),'CHARGE',IBID,
     &                K8BID,IED)
          IF (K8BID(1:5).NE.'THER_') THEN
            CALL UTMESS('F','CALC_VECT_ELEM',
     &                  'ERREUR: UNE DES CHARGES N''EST PAS THERMIQUE')
          END IF
   30   CONTINUE
      END IF

      IF ((SUROPT.EQ.'CHAR_ACOU')) THEN
        DO 40,ICH = 1,NCHA
          CALL DISMOI('F','TYPE_CHARGE',ZK8(ICHA-1+ICH),'CHARGE',IBID,
     &                K8BID,IED)
          IF (K8BID(1:5).NE.'ACOU_') THEN
            CALL UTMESS('F','CALC_VECT_ELEM',
     &                  'ERREUR: UNE DES CHARGES N''EST PAS ACOUSTIQUE')
          END IF
   40   CONTINUE
      END IF

      IF ((SUROPT.EQ.'FORC_NODA')) THEN
        CALL DISMOI('F','TYPE_CHAMP',CHAM,'CHAMP',IBID,TYCH,IERD)
        IF (TYCH(1:4).NE.'ELGA') THEN
          CALL UTMESS('F','CALC_VECT_ELEM',
     &                'ERREUR: LE CHAMP DOIT ETRE UN CHAM_ELEM'//
     &                ' AUX POINTS DE GAUSS')
        END IF
      END IF

      IF (SUROPT.EQ.'CHAR_MECA') THEN

C        -- TRAITEMENT DES ELEMENTS FINIS CLASSIQUES (.LISTE_RESU)
C           (ET CREATION DE L'OBJET .REFE_RESU).
        CALL ME2MME(MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,MATEL,
     &              NH,'G')

C        -- TRAITEMENT DES SOUS-STRUCTURES EVENTUELLES. (.LISTE_CHAR):
        CALL SS2MME(MODELE,MATEL,'G')

      ELSE IF (SUROPT.EQ.'CHAR_MECA_LAGR') THEN
        CALL ME2MLA(MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,MATEL,
     &              THETA(1:19),ALPHA)

      ELSE IF (SUROPT.EQ.'CHAR_THER') THEN

        TPS(1) = TIME

        TIME2 = '&TIME'
        CALL MECACT('V',TIME2,'MODELE',MODELE//'.MODELE','INST_R  ',6,
     &              NOMCMP,IBID,TPS,CBID,KBID)
        CALL MECACT('V','&&OP0008.PTEMPER','MODELE',MODELE//'.MODELE',
     &              'TEMP_R  ',3,NCMPTH,IBID,VCMPTH,CBID,KBID)
        CALL ME2MTH(MODELE,NCHA,ZK8(ICHA),MATE,CARA,TIME2,
     &              '&&OP0008.PTEMPER',MATEL)
      ELSE IF (SUROPT.EQ.'CHAR_ACOU') THEN
        CALL ME2MAC(MODELE,NCHA,ZK8(ICHA),MATE,MATEL)
      ELSE IF (SUROPT.EQ.'FORC_NODA') THEN

C       - ON CHERCHE LE NOM DU MODELE A ATTACHER AU VECT_ELEM :
        CALL JEVEUO(CHAM(1:19)//'.CELK','L',IAD)
        K8B = ZK24(IAD)
        CALL GETTCO(K8B,TYPCO)
        IF (TYPCO(1:14).EQ.'MODELE_SDASTER') THEN
          MODELE = K8B
        ELSE
          CALL GETVID(' ','MODELE',0,1,1,MODELE,N1)
          IF (N1.EQ.0) CALL UTMESS('F','OP0008',
     &              'AVEC UN CHAM_ELEM CALCULE SUR UNE LISTE DE MAILLE,'
     &                             //
     &                          ' IL FAUT UTILISER LE MOT CLE "MODELE:"'
     &                             )
        END IF

        PARTPS(1) = 0.D0
        PARTPS(2) = 0.D0
        PARTPS(3) = 0.D0
        CH24 = ' '
        FNOEVO=.FALSE.
        CALL VEFNME(MODELE,CHAM,CARA,' ',' ',VFONO,MATE,' ',NH,FNOEVO,
     >              PARTPS,' ',CH24,' ',' ')
        CALL JEVEUO(VFONO,'L',JLVF)
        VAFONO = ZK24(JLVF)
        CALL JELIRA(VFONO,'LONUTI',NBCHME,K8BID)
        VMATEL = MATEL//'.LISTE_RESU'
        CALL MEMARE('G',MATEL,MODELE,MATE,CARA,'CHAR_MECA')
        CALL WKVECT(VMATEL,'G V K24',NBCHME,JLMAT)
        VRESUL = MATEL//'.VE001     '
        ZK24(JLMAT) = VRESUL
        CALL COPISD('CHAMP','G',VAFONO(1:19),VRESUL)
      END IF

      CALL JEDEMA()
      END
