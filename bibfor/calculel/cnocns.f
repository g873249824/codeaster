      SUBROUTINE CNOCNS(CNOZ,BASEZ,CNSZ)
C RESPONSABLE VABHHTS J.PELLET
C A_UTIL
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 25/09/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT NONE
      CHARACTER*(*) CNOZ,CNSZ,BASEZ
C ------------------------------------------------------------------
C BUT : TRANSFORMER UN CHAM_NO (CNOZ) EN CHAM_NO_S (CNSZ)
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNOZ    IN/JXIN  K19 : SD CHAM_NO A TRANSFORMER
C BASEZ   IN       K1  : BASE DE CREATION POUR CNSZ : G/V/L
C CNSZ    IN/JXOUT K19 : SD CHAM_NO_S A CREER
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C     ------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*1 KBID,BASE
      CHARACTER*3 TSCA
      CHARACTER*8 MA,NOMGD,LICMP(200)
      CHARACTER*19 CNO,CNS,PROFCN
      LOGICAL EXISDG
      INTEGER NEC,GD,NCMPMX,IBID,NBNO,JCMPGD,JNUCMP,JREFE,JVALE,JDESC
      INTEGER IADG,ICMP,JPRNO,JNUEQ,INO,NCMP,NCMP1,JCNSL,JCNSV
      INTEGER IVAL,ICO,IEQ,ICMP1,LONG
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CNO = CNOZ
      CNS = CNSZ
      BASE = BASEZ


C     -- SI CNS EXISTE DEJA, ON LE DETRUIT :
      CALL DETRSD('CHAM_NO_S',CNS)

      CALL DISMOI('F','NOM_MAILLA',CNO,'CHAM_NO',IBID,MA,IBID)
      CALL DISMOI('F','NOM_GD',CNO,'CHAM_NO',IBID,NOMGD,IBID)

      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNO,KBID,IBID)

      CALL DISMOI('F','NB_EC',NOMGD,'GRANDEUR',NEC,KBID,IBID)
      CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NCMPMX,KBID,IBID)
      CALL DISMOI('F','NUM_GD',NOMGD,'GRANDEUR',GD,KBID,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',JCMPGD)
      CALL WKVECT('&&CNOCNS.TMP_NUCMP','V V I',NCMPMX,JNUCMP)

      CALL JEVEUO(CNO//'.REFE','L',JREFE)
      CALL JEVEUO(CNO//'.VALE','L',JVALE)
      CALL JEVEUO(CNO//'.DESC','L',JDESC)

C------------------------------------------------------------------
C     1- ON ALLOUE CNS :
C     ------------------

C     1.1 CALCUL DE NCMP1 ET LICMP(NCMP1) :
C         NCMP1: NOMBRE DE CMPS PORTEES PAR CNO
C         LICMP: LISTES DES CMPS PORTEES PAR CNO
C     -------------------------------------------

C     -- CAS DES CHAM_NO A REPRESENTATION CONSTANTE :
      IF (ZI(JDESC-1+2).LT.0) THEN
        PROFCN = ' '
        CALL JELIRA(CNO//'.DESC','LONMAX',LONG,KBID)
        CALL ASSERT(LONG.EQ.(2+NEC))
        IADG = JDESC - 1 + 3
        DO 10,ICMP = 1,NCMPMX
          IF (EXISDG(ZI(IADG),ICMP)) THEN
            ZI(JNUCMP-1+ICMP) = 1
          END IF
   10   CONTINUE


C     -- CAS DES CHAM_NO A PROF_CHNO:
      ELSE
        CALL DISMOI('F','PROF_CHNO',CNO,'CHAM_NO',IBID,PROFCN,IBID)
        CALL JEVEUO(JEXNUM(PROFCN//'.PRNO',1),'L',JPRNO)
        CALL JEVEUO(PROFCN//'.NUEQ','L',JNUEQ)
        DO 30,INO = 1,NBNO
          NCMP = ZI(JPRNO-1+ (INO-1)* (NEC+2)+2)
          IF (NCMP.EQ.0) GO TO 30
          IADG = JPRNO - 1 + (INO-1)* (NEC+2) + 3
          DO 20,ICMP = 1,NCMPMX
            IF (EXISDG(ZI(IADG),ICMP)) THEN
              ZI(JNUCMP-1+ICMP) = 1
            END IF
   20     CONTINUE
   30   CONTINUE

      END IF

      NCMP1 = 0
      DO 40,ICMP = 1,NCMPMX
        IF (ZI(JNUCMP-1+ICMP).EQ.1) THEN
          NCMP1 = NCMP1 + 1
          IF (NCMP1.GT.200) CALL UTMESS('F','CNOCNS','STOP 1')
          ZI(JNUCMP-1+ICMP) = NCMP1
          LICMP(NCMP1) = ZK8(JCMPGD-1+ICMP)
        END IF
   40 CONTINUE

C     1.2 ALLOCATION DE CNS :
C     -------------------------------------------
      CALL CNSCRE(MA,NOMGD,NCMP1,LICMP,BASE,CNS)



C------------------------------------------------------------------
C     2- REMPLISSAGE DE CNS.CNSL ET CNS.CNSV :
C     -------------------------------------------
      CALL JEVEUO(CNS//'.CNSL','E',JCNSL)
      CALL JEVEUO(CNS//'.CNSV','E',JCNSV)


C     2.1 CAS DES CHAM_NO A REPRESENTATION CONSTANTE :
C     ---------------------------------------------------
      IF (PROFCN.EQ.' ') THEN
        DO 60,INO = 1,NBNO
          DO 50,ICMP1 = 1,NCMP1
            ZL(JCNSL-1+ (INO-1)*NCMP1+ICMP1) = .TRUE.
            IEQ = (INO-1)*NCMP1 + ICMP1

            IF (TSCA.EQ.'R') THEN
              ZR(JCNSV-1+IEQ) = ZR(JVALE-1+IEQ)
            ELSE IF (TSCA.EQ.'I') THEN
              ZI(JCNSV-1+IEQ) = ZI(JVALE-1+IEQ)
            ELSE IF (TSCA.EQ.'C') THEN
              ZC(JCNSV-1+IEQ) = ZC(JVALE-1+IEQ)
            ELSE IF (TSCA.EQ.'L') THEN
              ZL(JCNSV-1+IEQ) = ZL(JVALE-1+IEQ)
            ELSE IF (TSCA.EQ.'K8') THEN
              ZK8(JCNSV-1+IEQ) = ZK8(JVALE-1+IEQ)
            ELSE
              CALL UTMESS('F','CNOCNS','STOP 2')
            END IF
   50     CONTINUE
   60   CONTINUE


C     2.2 CAS DES CHAM_NO A PROF-CHNO
C     ---------------------------------------------------
      ELSE
        DO 80,INO = 1,NBNO

C         NCMP : NOMBRE DE CMPS SUR LE NOEUD INO
C         IVAL : ADRESSE DU DEBUT DU NOEUD INO DANS .NUEQ
C         IADG : DEBUT DU DESCRIPTEUR GRANDEUR DU NOEUD INO
          NCMP = ZI(JPRNO-1+ (INO-1)* (NEC+2)+2)
          IF (NCMP.EQ.0) GO TO 80
          IVAL = ZI(JPRNO-1+ (INO-1)* (NEC+2)+1)
          IADG = JPRNO - 1 + (INO-1)* (NEC+2) + 3

          ICO = 0
          DO 70,ICMP = 1,NCMPMX
            IF (EXISDG(ZI(IADG),ICMP)) THEN
              ICO = ICO + 1
              IEQ = ZI(JNUEQ-1+IVAL-1+ICO)
              ICMP1 = ZI(JNUCMP-1+ICMP)

              ZL(JCNSL-1+ (INO-1)*NCMP1+ICMP1) = .TRUE.

              IF (TSCA.EQ.'R') THEN
                ZR(JCNSV-1+ (INO-1)*NCMP1+ICMP1) = ZR(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'I') THEN
                ZI(JCNSV-1+ (INO-1)*NCMP1+ICMP1) = ZI(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'C') THEN
                ZC(JCNSV-1+ (INO-1)*NCMP1+ICMP1) = ZC(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'L') THEN
                ZL(JCNSV-1+ (INO-1)*NCMP1+ICMP1) = ZL(JVALE-1+IEQ)
              ELSE IF (TSCA.EQ.'K8') THEN
                ZK8(JCNSV-1+ (INO-1)*NCMP1+ICMP1) = ZK8(JVALE-1+IEQ)
              ELSE
                CALL UTMESS('F','CNOCNS','STOP 3')
              END IF
            END IF
   70     CONTINUE
   80   CONTINUE
      END IF
C------------------------------------------------------------------

      CALL JEDETR('&&CNOCNS.TMP_NUCMP')
      CALL JEDEMA()
      END
