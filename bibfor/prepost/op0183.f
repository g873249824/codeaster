      SUBROUTINE OP0183()

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT   NONE
C
C-----------------------------------------------------------------------
C     COMMANDE :  CALC_FORC_NONL
C-----------------------------------------------------------------------
C

C 0.1. ==> ARGUMENTS

C 0.2. ==> COMMUNS

C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C 0.3. ==> VARIABLES LOCALES

      INTEGER IBID
      INTEGER I,IACHAR,IAD,ICHAR
      INTEGER IORDR,IRET,IRET2,J
      INTEGER JFO,JFONO,JINFC
      INTEGER JNOCH,JORDR
      INTEGER LONCH,LREF,LVAFON,N0,N2,NBCHAR
      INTEGER NBDDL,NBORDR,NC,NEQ,NH,NP
      INTEGER II,LTPS,LTPS2,NBPASE
      INTEGER JREF,NCMPMA,DIMAKI,DIMANV
C     ------------------------------------------------------------------
C     DIMAKI = DIMENSION MAX DE LA LISTE DES RELATIONS KIT
      PARAMETER(DIMAKI=9)
C     DIMANV = DIMENSION MAX DE LA LISTE DU NOMBRE DE VAR INT EN THM
      PARAMETER(DIMANV=4)
      PARAMETER(NCMPMA=7+DIMAKI+DIMANV)
C     ------------------------------------------------------------------

      REAL*8 TIME,PREC,PARTPS(3)

      CHARACTER*2 CODRET
      CHARACTER*6 NOMPRO
      CHARACTER*8 K8BID,CTYP,CRIT,MATERI
      CHARACTER*8 KIORD,NMCMP2(NCMPMA)
      CHARACTER*13 INPSCO
      CHARACTER*16 OPTION,TYPE,OPER,K16BID
      CHARACTER*16 COMPEX,MCL(2)
      CHARACTER*19 RESUCO,KNUM,INFCHA,LIGREL,RESUC1,CHDEP2
      CHARACTER*24 MODELE,MATER,CARAC,CHARGE,INFOCH,CHAMNO
      CHARACTER*24 NUME,VFONO,VAFONO,SIGMA,CHDEPL,K24BID
      CHARACTER*24 VRENO,COMPOR,CHVIVE,CHACVE
      CHARACTER*24 BIDON,CHVARC
      CHARACTER*24 NUMREF,VALK(3)
C     ------------------------------------------------------------------
      PARAMETER(NOMPRO='OP0183')
C     ------------------------------------------------------------------

      LOGICAL EXITIM,FNOEVO

C     ------------------------------------------------------------------
      DATA INFCHA/'&&INFCHA.INFCHA'/
      DATA K24BID/' '/
      DATA CHVARC/'&&OP0183.CHVARC'/
      DATA NMCMP2/'RELCOM  ','NBVARI  ','DEFORM  ','INCELA  ',
     &     'C_PLAN  ','XXXX1   ','XXXX2   ','KIT1    ','KIT2    ',
     &     'KIT3    ','KIT4    ','KIT5    ','KIT6    ','KIT7    ',
     &     'KIT8    ','KIT9    ','NVI_C   ','NVI_T   ','NVI_H   ',
     &     'NVI_M   '/
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFMAJ()

C --- ON STOCKE LE COMPORTEMENT EN CAS D'ERREUR AVANT MNL : COMPEX
C --- PUIS ON PASSE DANS LE MODE "VALIDATION DU CONCEPT EN CAS D'ERREUR"
      CALL ONERRF(' ',COMPEX,IBID)
      CALL ONERRF('EXCEPTION+VALID',K16BID,IBID)

      CALL INFMUE()
C
C --- OPTIONS A CALCULER
C
      CALL GETRES(RESUC1,TYPE,OPER)
      CALL ASSERT(TYPE.EQ.'DYNA_TRANS')
      CALL GETVID(' ','RESULTAT',1,1,1,RESUCO,N0)
      CALL ASSERT(RESUCO.NE.RESUC1)


      CALL GETVTX(' ','OPTION',1,1,1,OPTION,N2)
      CALL ASSERT(N2.EQ.1 .AND. OPTION.EQ.'FONL_NOEU')
C

      INPSCO='&&'//NOMPRO//'_PSCO'
      KNUM='&&'//NOMPRO//'.NUME_ORDRE'

C=======================================================================
      K8BID='&&'//NOMPRO
      IBID=1
      NBPASE=0
C=======================================================================

      CALL GETVR8(' ','PRECISION',1,1,1,PREC,NP)
      CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)

      CALL RSUTNU(RESUCO,' ',0,KNUM,NBORDR,PREC,CRIT,IRET)
      IF (IRET.EQ.10) THEN
        CALL U2MESK('S','CALCULEL4_8',1,RESUCO)
        GOTO 60

      ENDIF
      IF (IRET.NE.0) THEN
        CALL U2MESS('S','ALGORITH3_41')
        GOTO 60

      ENDIF
      CALL JEVEUO(KNUM,'L',JORDR)
      BIDON='&&'//NOMPRO//'.BIDON'


      EXITIM=.TRUE.
      CARAC=' '
      CHARGE=' '
      MATER=' '
      CALL RSCRSD('G',RESUC1,TYPE,NBORDR)
      CALL GETVID(' ','MODELE',1,1,1,MODELE,N0)
      LIGREL=MODELE(1:8)//'.MODELE'
      CALL ASSERT(N0.EQ.1)
      CALL GETVID(' ','CHAM_MATER',1,1,1,MATERI,N0)
      IF (N0.GT.0) THEN
        CALL RCMFMC(MATERI,MATER)
      ELSE
        MATER=' '
      ENDIF
      CARAC=' '
      CALL GETVID(' ','CARA_ELEM',1,1,1,CARAC,N0)

C INFO. RELATIVE AUX CHARGES
      CHARGE=INFCHA//'.LCHA'
      INFOCH=INFCHA//'.INFC'
      CALL JEEXIN(INFOCH,IRET)
      CALL ASSERT(IRET.EQ.0)
      NBCHAR=0
      ICHAR=1



      TIME=0.D0
      PARTPS(1)=0.D0
      PARTPS(2)=0.D0
      PARTPS(3)=0.D0


      NUMREF=' '
      CALL WKVECT(RESUC1//'.REFD','G V K24',7,JREF)
      CALL JEVEUO(RESUCO//'.REFD','L',LREF)
      ZK24(JREF)=ZK24(LREF)
      ZK24(JREF+1)=ZK24(LREF+1)
      ZK24(JREF+2)=ZK24(LREF+2)
      ZK24(JREF+3)=ZK24(LREF+3)
      ZK24(JREF+4)=ZK24(LREF+4)
      ZK24(JREF+5)=ZK24(LREF+5)
      ZK24(JREF+6)=ZK24(LREF+6)
      IF (ZK24(JREF).NE.' ') THEN
        CALL DISMOI('F','NOM_NUME_DDL',ZK24(JREF),'MATR_ASSE',IBID,
     &              NUMREF,IRET)
      ENDIF


      NUMREF=' '
      CALL JEVEUO(RESUCO//'.REFD','L',JREF)
      IF (ZK24(JREF).NE.' ') THEN
        CALL DISMOI('F','NOM_NUME_DDL',ZK24(JREF),'MATR_ASSE',IBID,
     &              NUMREF,IRET)
      ENDIF


      DO 50 I=1,NBORDR
        CALL JEMARQ()
        IORDR=ZI(JORDR+I-1)
        CHARGE=INFCHA//'.LCHA'
        INFOCH=INFCHA//'.INFC'
        CALL JEEXIN(INFOCH,IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(INFOCH,'L',JINFC)
          NBCHAR=ZI(JINFC)
          IF (NBCHAR.NE.0) THEN
            CALL JEVEUO(CHARGE,'L',IACHAR)
            CALL JEDETR('&&'//NOMPRO//'.L_CHARGE')
            CALL WKVECT('&&'//NOMPRO//'.L_CHARGE','V V K8',NBCHAR,ICHAR)
            DO 20 II=1,NBCHAR
              ZK8(ICHAR-1+II)=ZK24(IACHAR-1+II)(1:8)
   20       CONTINUE
          ELSE
            ICHAR=1
          ENDIF
        ELSE
          NBCHAR=0
          ICHAR=1
        ENDIF



        VFONO=' '
        VAFONO=' '
        VRENO='&&'//NOMPRO//'           .RELR'
        NH=0

        CALL RSEXCH(RESUCO,'SIEF_ELGA',IORDR,SIGMA,IRET)
        IF (IRET.NE.0) THEN
          CALL RSEXCH(RESUCO,'SIEF_ELGA',IORDR,SIGMA,IRET2)
          IF (IRET2.NE.0 .AND. OPTION.NE.'FONL_NOEU') THEN
            CALL CODENT(IORDR,'G',KIORD)
            VALK(1)=KIORD
            VALK(2)=OPTION
            CALL U2MESK('A','PREPOST5_2',2,VALK)
            GOTO 40

          ENDIF
          IF (IRET2.NE.0 .AND. OPTION.EQ.'FONL_NOEU') THEN
            SIGMA=' '
          ENDIF
        ENDIF

        CALL RSEXCH(RESUCO,'DEPL',IORDR,CHDEPL,IRET)
        IF (IRET.NE.0) THEN
          CALL CODENT(IORDR,'G',KIORD)
          VALK(1)=KIORD
          VALK(2)=OPTION
          CALL U2MESK('A','PREPOST5_3',2,VALK)
          GOTO 40
        ELSE
C         CREATION D'UN VECTEUR ACCROISSEMENT DE DEPLACEMENT NUL
C         POUR LE CALCUL DE FORC_NODA DANS LES POU_D_T_GD

          CHDEP2='&&'//NOMPRO//'.CHDEP_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHDEP2)
          CALL JELIRA(CHDEP2//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHDEP2//'.VALE',NBDDL,1)
        ENDIF

C       -- CALCUL D'UN NUME_DDL "MINIMUM" POUR ASASVE :
        NUME=NUMREF(1:14)//'.NUME'

        CALL RSEXCH(RESUCO,'VITE',IORDR,CHVIVE,IRET)
        IF (IRET.EQ.0) THEN
          CHVIVE='&&'//NOMPRO//'.CHVIT_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHVIVE)
          CALL JELIRA(CHVIVE(1:19)//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHVIVE(1:19)//'.VALE',NBDDL,1)
        ENDIF
        CALL RSEXCH(RESUCO,'ACCE',IORDR,CHACVE,IRET)
        IF (IRET.EQ.0) THEN
          CHACVE='&&'//NOMPRO//'.CHACC_NUL'
          CALL COPISD('CHAMP_GD','V',CHDEPL,CHACVE)
          CALL JELIRA(CHACVE(1:19)//'.VALE','LONMAX',NBDDL,K8BID)
          CALL JERAZO(CHACVE(1:19)//'.VALE',NBDDL,1)
        ENDIF

        IF (EXITIM) THEN
          CALL RSADPA(RESUCO,'L',1,'INST',IORDR,0,IAD,CTYP)
          TIME=ZR(IAD)
        ENDIF

        CALL VRCINS(MODELE,MATER,CARAC,TIME,CHVARC(1:19),CODRET)

C       --- CALCUL DES VECTEURS ELEMENTAIRES ---
        IF (I.EQ.1) THEN
          COMPOR='&&OP0183.COMPOR'
          MCL(1)='COMP_INCR'
          CALL NMDOCC(COMPOR(1:19),MODELE,1,MCL,NMCMP2,NCMPMA,.TRUE.)
        ENDIF

        FNOEVO=.FALSE.
        CALL VEFNME(MODELE,SIGMA,CARAC,CHDEPL,CHDEP2,VFONO,MATER,COMPOR,
     &              NH,FNOEVO,PARTPS,K24BID,CHVARC,LIGREL,INFCHA,OPTION)

C       --- ASSEMBLAGE DES VECTEURS ELEMENTAIRES ---
        CALL ASASVE(VFONO,NUME,'R',VAFONO)

        CALL RSEXCH(RESUC1,'DEPL',IORDR,CHAMNO,IRET)
        CALL RSADPA(RESUC1,'E',1,'INST',IORDR,0,LTPS2,K8BID)
        CALL RSADPA(RESUCO,'L',1,'INST',IORDR,0,LTPS,K8BID)
        ZR(LTPS2)=ZR(LTPS)


        CALL JEEXIN(CHAMNO(1:19)//'.REFE',IRET)
        IF (IRET.NE.0) THEN
          CALL CODENT(IORDR,'G',KIORD)
          VALK(1)=OPTION
          VALK(2)=KIORD
          CALL U2MESK('A','PREPOST5_1',2,VALK)
          CALL DETRSD('CHAM_NO',CHAMNO(1:19))
        ENDIF
        CALL VTCREB(CHAMNO,NUME,'G','R',NEQ)
        CALL JEVEUO(CHAMNO(1:19)//'.VALE','E',JNOCH)

        CALL JEVEUO(VAFONO,'L',JFO)
        CALL JEVEUO(ZK24(JFO)(1:19)//'.VALE','L',JFONO)
        CALL JELIRA(ZK24(JFO)(1:19)//'.VALE','LONMAX',LVAFON,K8BID)
        CALL JELIRA(CHAMNO(1:19)//'.VALE','LONMAX',LONCH,K8BID)

        DO 30 J=0,LONCH-1
          ZR(JNOCH+J)=ZR(JFONO+J)
   30   CONTINUE
C
        CALL RSNOCH(RESUC1,'DEPL',IORDR,' ')
        CALL NMDOME(MODELE,MATER,CARAC,INFCHA,NBPASE,INPSCO,RESUC1(1:8),
     &              IORDR)

        CALL DETRSD('CHAMP_GD','&&'//NOMPRO//'.SIEF')
        CALL DETRSD('VECT_ELEM',VFONO(1:8))
        CALL DETRSD('VECT_ELEM',VRENO(1:8))
   40   CONTINUE
        CALL JEDEMA()
   50 CONTINUE

      CALL JEDETR(KNUM)
      CALL DETRSD('CHAMP_GD',BIDON)

C --- ON REMET LE MECANISME D'EXCEPTION A SA VALEUR INITIALE
      CALL ONERRF(COMPEX,K16BID,IBID)

   60 CONTINUE
      CALL INFBAV()
      CALL JEDEMA()

      END
