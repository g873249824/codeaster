      SUBROUTINE MACR78(NOMRES,TRANGE,TYPRES)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMRES
      CHARACTER*16  TYPRES
      CHARACTER*19  TRANGE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR LADIER A.LADIER 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C IN  : NOMRES : NOM UTILISATEUR POUR LA COMMANDE REST_COND_TRAN
C IN  : TYPRES : TYPE DE RESULTAT : 'DYNA_TRANS'
C IN  : TRANGE : NOM UTILISATEUR DU CONCEPT TRAN_GENE AMONT
C       NOMCMD : NOM DE LA COMMANDE : 'REST_COND_TRAN'
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
      COMPLEX*16    CBID
      CHARACTER*8   K8B, BASEMO, MAILLA, NOMIN, NOMCMP(6),
     &              MACREL, LINTF, NOMNOL, NOGDSI, MAYA
      CHARACTER*14  NUMDDL
      CHARACTER*16  CONCEP, CHAMP(8)
      CHARACTER*19  KINST, KNUME, KREFE, CHAM19
      CHARACTER*24  CHAMNO, NOMCHA, NUMEDD, NPRNO
C      CHARACTER*3  TREDU
      LOGICAL      LREDU
      INTEGER      IARG
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IACONX ,IADREF ,IADRIF ,IAPRNO ,IARC0 ,IARCH
      INTEGER IBID ,ICMP ,IDBASE ,IDDL ,IE ,IERD ,IM
      INTEGER INOE ,INU0 ,INUM ,IRET ,IRETOU ,IVALE ,J
      INTEGER JINST ,JNOCMP ,JNUME ,JORDR ,JRESTR ,K ,LDNEW
      INTEGER LINST ,LNOCM2 ,LNOCMP ,LPA2 ,LPAR ,LREFE ,N0
      INTEGER N1 ,NBCHAM ,NBEC ,NBINST ,NBMDEF ,NBMDYN ,NBMODE
      INTEGER NBNDEF ,NBNDYN ,NBNOE ,NBNTOT ,NBTDYN ,NEC ,NEQ
      INTEGER NES ,NMC
      REAL*8 RBID
C-----------------------------------------------------------------------
      DATA NOMCMP   /'DX      ','DY      ','DZ      ',
     &               'DRX     ','DRY     ','DRZ     '/
C     ------------------------------------------------------------------
      CALL JEMARQ()
      NOMIN = TRANGE
C      TYPRES = 'DYNA_TRANS'
      CALL GETTCO(NOMIN,CONCEP)

C     --- RECUPERATION DES ENTITES DU MAILLAGE SUR LESQUELLES ---
C     ---                PORTE LA RESTITUTION                 ---
C      TOUSNO = .TRUE.
C
      LREDU = .FALSE.
C      CALL GETVTX ( ' ', 'REDUC' , 1,IARG,1, TREDU, N2 )
C      IF (TREDU.EQ.'OUI') LREDU = .TRUE.
      CALL GETVID (' ','MACR_ELEM_DYNA',1,IARG,1,MACREL,NMC)
      CALL JEVEUO(MACREL//'.MAEL_REFE','L',IADREF)
      BASEMO = ZK24(IADREF)
      CALL RSORAC(BASEMO,'LONUTI',IBID,RBID,K8B,CBID,RBID,
     &               K8B,NBMODE,1,IBID)
      CALL JEVEUO(BASEMO//'           .REFD','L',IADRIF)
      NUMEDD = ZK24(IADRIF+3)
      CALL DISMOI('F','NOM_MAILLA',NUMEDD(1:14),'NUME_DDL',IBID,
     &                 MAILLA,IRET)
      LINTF = ZK24(IADRIF+4)
      CALL JELIRA(JEXNUM(LINTF//'.IDC_LINO',1),'LONMAX',NBNOE,K8B)
      CALL DISMOI('F','NB_MODES_STA',BASEMO,'RESULTAT',
     &                      NBMDEF,K8B,IERD)
C      CALL BMNBMD(BASEMO,'DEFORMEE',NBMDEF)
      NBMDYN = NBMODE-NBMDEF
      CALL JELIRA(MACREL//'.LINO','LONMAX',NBNTOT,K8B)
      NEC = NBMODE/NBNTOT
      NBNDYN = NBMDYN/NEC
      NBNDEF = NBNTOT-NBNDYN
C      NBNDE2 = NBMDEF/NEC
C      CALL ASSERT(NBNDEF.EQ.NBNDE2)
      IF (NBMDEF.NE.0) THEN
        CALL RSADPA(BASEMO,'L',1,'NOEUD_CMP',NBMDYN+1,0,LNOCMP,K8B)
        IF (ZK16(LNOCMP).EQ.' ') THEN
          LREDU=.TRUE.
          NEC = NBMODE/NBNTOT
          NBNDYN = NBMDYN/NEC
          NBNDEF = NBNTOT-NBNDYN
        ELSE
          K = 1
  31      CONTINUE
          IF ((K+1).GT.NBMDEF) THEN
            NES = K
            GOTO 32
          ENDIF
          CALL RSADPA(BASEMO,'L',1,'NOEUD_CMP',NBMDYN+K+1,0,LNOCM2,K8B)
          IF (ZK16(LNOCMP)(1:8).NE.ZK16(LNOCM2)(1:8)) THEN
            NES = K
            GOTO 32
          ELSE
            K=K+1
            GOTO 31
          ENDIF
  32      CONTINUE
          WRITE(6,*) 'NES ',NES
          NBNDEF = NBMDEF/NES
          NBNDYN = NBNTOT-NBNDEF
          IF (NBMDYN.NE.0) THEN
            NEC = NBMDYN/NBNDYN
          ELSE
            NEC = NES
          ENDIF
        ENDIF
      ENDIF
C      IF (NBNDEF.LT.NBNOE) LREDU=.TRUE.
      WRITE(6,*) 'LREDU NEC ',LREDU,NEC
C       CREATION DU TABLEAU NOEUD-COMPOSANTE ASSOCIES AUX MODES
      CALL WKVECT('&&MACR78.NOECMP','V V K8',2*NBMODE,JNOCMP)
      CALL JEVEUO(MACREL//'.LINO','L',IACONX)
      IF (LREDU) THEN
        NBTDYN = NBNTOT
      ELSE
        NBTDYN = NBNDYN
        DO 23 I=NBMDYN+1,NBMODE
          CALL RSADPA(BASEMO,'L',1,'NOEUD_CMP',I,0,LNOCMP,K8B)
          ZK8(JNOCMP+2*I-2) = ZK16(LNOCMP)(1:8)
          ZK8(JNOCMP+2*I-1) = ZK16(LNOCMP)(9:16)
  23    CONTINUE
      ENDIF
      WRITE(6,*) 'LREDU MAILLA NBTDYN ',LREDU,MAILLA,NBTDYN
      DO 21 I=1,NBTDYN
C         WRITE(6,*) 'I NUME ',I,ZI(IACONX+I-1)
         CALL JENUNO(JEXNUM(MAILLA//'.NOMNOE',ZI(IACONX+I-1)),NOMNOL)
         DO 22 J=1,NEC
            ZK8(JNOCMP+2*NEC*(I-1)+2*J-2) = NOMNOL
            ZK8(JNOCMP+2*NEC*(I-1)+2*J-1) = NOMCMP(J)
  22     CONTINUE
  21  CONTINUE
C        CALL GETVID(' ','NUME_DDL',1,IARG,1,K8B,IBID)
C        IF (IBID.NE.0) THEN
C          CALL GETVID(' ','NUME_DDL',1,1,1,NUMEDD,IBID)
C          NUMEDD = NUMEDD(1:14)//'.NUME'
C        ENDIF
      NUMDDL = NUMEDD(1:14)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8B,IRET)
      CALL WKVECT('&&MACR78.BASE','V V R',NBMODE*NEQ,IDBASE)
      CALL COPMO2(BASEMO,NEQ,NUMDDL,NBMODE,ZR(IDBASE))
      CALL GETVTX(' ','TOUT_CHAM',1,IARG,0,K8B,N0)
      IF (N0.NE.0) THEN
         NBCHAM = 3
         CHAMP(1) = 'DEPL'
         CHAMP(2) = 'VITE'
         CHAMP(3) = 'ACCE'
      ELSE
         CALL GETVTX(' ','NOM_CHAM',1,IARG,0,CHAMP,N1)
         IF (N1.NE.0) THEN
            NBCHAM = -N1
            CALL GETVTX(' ','NOM_CHAM',1,IARG,NBCHAM,CHAMP,N1)
         ELSE
            CALL U2MESS('A','ALGORITH10_93')
            GOTO 9999
         ENDIF
      ENDIF
      KNUME = '&&MACR78.NUM_RANG'
      KINST = '&&MACR78.INSTANT'
      CALL RSTRAN('NON',TRANGE,' ',1,KINST,KNUME,NBINST,IRETOU)
      IF ( IRETOU .NE. 0 ) THEN
         CALL U2MESS('F','UTILITAI4_24')
      ENDIF
      CALL JEEXIN(KINST,IRET )
      IF ( IRET .GT. 0 ) THEN
         CALL JEVEUO( KINST, 'L', JINST )
         CALL JEVEUO( KNUME, 'L', JNUME )
      ENDIF
C      WRITE(6,*) 'NBINST ',NBINST
      CALL JEEXIN(TRANGE//'.ORDR',IRET  )
      IF (IRET.NE.0) THEN
        CALL JEVEUO(TRANGE//'.ORDR','L',JORDR)
C        WRITE(6,*) 'ORDR ',(ZI(JORDR+I-1),I=1,NBINST)
      ENDIF
C      WRITE(6,*) 'KINST ',(ZR(JINST+I-1),I=1,NBINST)
C      WRITE(6,*) 'KNUME ',(ZI(JNUME+I-1),I=1,NBINST)
C     --- CREATION DE LA SD RESULTAT ---
      CALL RSCRSD('G',NOMRES, TYPRES, NBINST)
C
      CALL WKVECT('&&MACR78.RESTR','V V R',NBMODE,JRESTR)
      CALL RSEXCH('F',NOMIN,'DEPL',1,CHAM19,IRET )
      CALL DISMOI('F','NOM_MAILLA',CHAM19,'CHAMP',IBID,MAYA,IE)
C ATTENTION MAILLA MAILLAGE DU MACRO_ELEM DE RESTITUTION
C  ET MAYA MAILLAGE DU RESULTAT SUR MODELE SOUS-STRUC-STAT
      CALL DISMOI('F','NOM_GD',CHAM19,'CHAMP',IBID,NOGDSI,IE)
      CALL DISMOI('F','NB_EC',NOGDSI,'GRANDEUR',NBEC,K8B,IERD)

      CALL DISMOI('F','PROF_CHNO',CHAM19,'CHAMP',IBID,NPRNO,IE)
      NPRNO = NPRNO(1:19)//'.PRNO'
      CALL JEVEUO(JEXNUM(NPRNO,1),'L',IAPRNO)
      DO 300 I = 1 , NBCHAM
         DO 310 IARC0 = 1, NBINST
            INU0 = ZI(JNUME+IARC0-1)
            INUM = ZI(JORDR+INU0-1)
            IARCH = IARC0-1
C            IF (CONCEP(1:10).EQ.'DYNA_TRANS') INUM=INUM-1
C            WRITE(6,*) 'INUM IARCH ',INUM,IARCH
            CALL RSEXCH('F',NOMIN,CHAMP(I)(1:4),INUM,NOMCHA,IRET)
            NOMCHA = NOMCHA(1:19)//'.VALE'
            CALL JEVEUO(NOMCHA,'L',IVALE)
            DO 24 IM=1,NBMODE
               NOMNOL = ZK8(JNOCMP+2*IM-2)
               CALL JENONU(JEXNOM(MAYA//'.NOMNOE',NOMNOL),INOE)
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DX') ICMP = 1
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DY') ICMP = 2
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DZ') ICMP = 3
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DRX') ICMP = 4
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DRY') ICMP = 5
               IF (ZK8(JNOCMP+2*IM-1).EQ.'DRZ') ICMP = 6
               IDDL = ZI(IAPRNO-1+(NBEC+2)*(INOE-1)+1)
               ZR(JRESTR+IM-1) = ZR(IVALE+IDDL-1+ICMP-1)
  24        CONTINUE
            CALL RSEXCH(' ',NOMRES,CHAMP(I)(1:4),IARCH,CHAMNO,IRET)
            CALL VTCREB(CHAMNO,NUMEDD,'G','R',NEQ)
            CALL JEVEUO(CHAMNO(1:19)//'.VALE','E',LDNEW)
            CALL MDGEPH(NEQ,NBMODE,ZR(IDBASE),ZR(JRESTR),ZR(LDNEW))
            CALL RSNOCH(NOMRES,CHAMP(I)(1:4),IARCH)
            IF (I.EQ.1) THEN
               CALL RSADPA(NOMRES,'E',1,'INST',IARCH,0,LINST,K8B)
               ZR(LINST) = ZR(JINST+IARC0-1)
               CALL RSADPA(NOMIN,'L',1,'MODELE',INUM,0,LPA2,K8B)
               CALL RSADPA(NOMRES,'E',1,'MODELE',IARCH,0,LPAR,K8B)
               ZK8(LPAR) = ZK8(LPA2)
               CALL RSADPA(NOMIN,'L',1,'CHAMPMAT',INUM,0,LPA2,K8B)
               CALL RSADPA(NOMRES,'E',1,'CHAMPMAT',IARCH,0,LPAR,K8B)
               ZK8(LPAR) = ZK8(LPA2)
               CALL RSADPA(NOMIN,'L',1,'CARAELEM',INUM,0,LPA2,K8B)
               CALL RSADPA(NOMRES,'E',1,'CARAELEM',IARCH,0,LPAR,K8B)
               ZK8(LPAR) = ZK8(LPA2)
            ENDIF
 310     CONTINUE
 300  CONTINUE
      KREFE  = NOMRES
      CALL WKVECT(KREFE//'.REFD','G V K24',7,LREFE)
      ZK24(LREFE  ) = ZK24(IADRIF)
      ZK24(LREFE+1) = ZK24(IADRIF+1)
      ZK24(LREFE+2) = ZK24(IADRIF+2)
      ZK24(LREFE+3) = NUMEDD
      ZK24(LREFE+4) = ZK24(IADRIF+4)
      ZK24(LREFE+5) = ZK24(IADRIF+5)
      ZK24(LREFE+6) = ZK24(IADRIF+6)
      CALL JELIBE(KREFE//'.REFD')
C
C --- MENAGE
C
      CALL JEDETR('&&MACR78.NOECMP')
      CALL JEDETR('&&MACR78.BASE')
      CALL JEDETR('&&MACR78.NUM_RANG')
      CALL JEDETR('&&MACR78.INSTANT')
      CALL JEDETR('&&MACR78.RESTR')
C
      CALL TITRE
9999  CONTINUE
C
      CALL JEDEMA()
      END
