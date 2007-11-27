      SUBROUTINE CNSPRM(CNS1Z,BASEZ,CNS2Z,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 27/11/2007   AUTEUR ANDRIAM H.ANDRIAMBOLOLONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      INTEGER IRET
      CHARACTER*(*) CNS1Z,BASEZ,CNS2Z
C ------------------------------------------------------------------
C BUT : PROJETER UN CHAM_NO_S  SUR UN MAILLAGE MESURE
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNS1Z  IN/JXIN  K19 : CHAM_NO_S A PROJETER
C BASEZ  IN       K1  : BASE DE CREATION POUR CNS2Z : G/V/L
C CNS2Z  IN/JXOUT K19 : CHAM_NO_S RESULTAT DE LA PROJECTION
C IRET   OUT      I   : IRET = 0 : OK / IRET = 1 : PB
C ------------------------------------------------------------------
C    ON NE TRAITE QUE LES CHAMPS REELS (R8) OU COMPLEXES (C16)
C
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
      LOGICAL NEWK,AXE
      CHARACTER*1 BASE
      CHARACTER*3 TSCA,DIR
      CHARACTER*8 MA1,MA2,MA3,NOMGD,PROMES,MACREL,K8BID
      CHARACTER*8 MODEL3,KCMP,NONO,KCMP2
      CHARACTER*8 BASEMO,MAIL,NUMDDL,LICMP,KSTO
      CHARACTER*16 K16BID
      CHARACTER*19 CNS1,CNS2,TRAV
      CHARACTER*24 VNOEUD,VRANGE,VNOEUM,VRANGM,VMES,VSU,K24BID
      CHARACTER*24 VALK(2),VORIEN,VREF,VREFPM
      INTEGER JCNS1C,JCNS1L,JCNS1V,JCNS1K,JCNS1D,ICMP1,ICMP2
      INTEGER JCNS2C,JCNS2L,JCNS2V,JCNS2K,JCNS2D,LVSU,LCMP
      INTEGER NCMP,IBID,GD,NCMP2,INO2,ICMP,INO1,ICMPD
      INTEGER JREFD,IAMACR,ISMA,LORI,LREF,LREFMS
      INTEGER IDDL,JDDL,IMOD,IPOS,IPOSI,IPOSJ,LNOEUD,LRANGE,IPULS
      INTEGER LNOEUM,LRANGM,NBMESU,NBORD,NDDLE,LMESU,LTRAV
      REAL*8 V1,V2,COEF1,R8PREM,VALX,VALY,VALZ,EPS
      COMPLEX*16 V1C,V2C
C     ------------------------------------------------------------------

      CALL JEMARQ()

      CNS1 = CNS1Z
      CNS2 = CNS2Z
      BASE = BASEZ

C RECUPERATION DES OBJETS ET INFORMATIONS DE CNS1 :

      CALL JEVEUO(CNS1//'.CNSK','L',JCNS1K)
      CALL JEVEUO(CNS1//'.CNSD','L',JCNS1D)
      CALL JEVEUO(CNS1//'.CNSC','L',JCNS1C)
      CALL JEVEUO(CNS1//'.CNSV','L',JCNS1V)
      CALL JEVEUO(CNS1//'.CNSL','L',JCNS1L)

C MA1 : MAILLAGE DE LA MODIFICATION
      MA1 = ZK8(JCNS1K-1+1)
      NOMGD = ZK8(JCNS1K-1+2)
      NCMP  = ZI(JCNS1D-1+2)

      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)

      CALL JEVEUO(MA1//'.NOMACR','L',IAMACR)

      CALL GETVID(' ','SUPER_MAILLE',1,1,1,MAIL,IBID)

      CALL JENONU(JEXNOM(MA1//'.SUPMAIL',MAIL),ISMA)
      IF (ISMA.LE.0) THEN
         VALK(1)=MAIL
         VALK(2)=MA1
         CALL U2MESK('F','CALCULEL5_53',2,VALK)
      ENDIF
      MACREL= ZK8(IAMACR-1+ISMA)

      CALL DISMOI('F',
     &    'NOM_PROJ_MESU',MACREL,'MACR_ELEM_STAT',IBID,PROMES,IBID)

C RECUPERATION DES ELEMENTS RELATIFS A LA MESURE
      VNOEUD = PROMES//'.PROJM    .PJMNO'
      VRANGE = PROMES//'.PROJM    .PJMRG'
      VORIEN = PROMES//'.PROJM    .PJMOR'
      VREFPM = PROMES//'.PROJM    .PJMRF'

      CALL JEVEUO (VNOEUD, 'L', LNOEUD)
      CALL JELIRA(VNOEUD,'LONUTI',NBMESU,K8BID)

C MODEL3 : MODELE MESURE
      CALL JEVEUO (VRANGE, 'L', LRANGE)
      CALL JEVEUO(VREFPM,'L',LREFMS)
      K16BID=ZK16(LREFMS-1 +1)
      MODEL3=K16BID(1:8)

      VREF = MACREL//'.PROJM    .PJMRF'
      CALL JEVEUO(VREF,'L',LREF)
      K16BID=ZK16(LREF-1 +3)
      BASEMO=K16BID(1:8)

C POUR LES ORIENTATIONS DES CAPTEURS
      CALL JEVEUO (VORIEN, 'L', LORI)

C BASEMO : POUR LA RECUPERATION DU MAILLAGE DU MODELE SUPPORT (MA2)
      CALL JEVEUO(BASEMO//'           .REFD','L',JREFD)

      K24BID = ZK24(JREFD-1+4)
      NUMDDL = K24BID(1:8)
      CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IBID,MA2,IBID)

      CALL DISMOI('F','NOM_MAILLA',MODEL3,'MODELE',IBID,MA3,IBID)

C  QUELQUES VERIFS :
      IF (TSCA.NE.'R'.AND.TSCA.NE.'C') THEN
C        -- ON NE TRAITE QUE LES CHAMPS R/C :
         IRET = 1
         GO TO 9999
      END IF

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) CALL U2MESK('F','CALCULEL_67',1,NOMGD)

C ALLOCATION DE CNS2 :
      CALL DETRSD('CHAM_NO_S',CNS2)

C FAIRE APPEL A VRANGE POUR LA LISTE DES CMP MESURE
C ON FAIT L UNION DES CMP DE CNS1 ET VRANGE

      LICMP = '&&LICMP'
      CALL WKVECT (LICMP, 'V V K8', 3*NCMP, LCMP)
      DO 230 ICMP = 1,NCMP
        ZK8(LCMP-1+ICMP)=ZK8(JCNS1C-1+ICMP)
230   CONTINUE
      NCMP2 = NCMP
      DO 220 IDDL=1,NBMESU
        KCMP = ZK8(LRANGE-1+IDDL)
        NEWK = .TRUE.
        DO 210 ICMP = 1,NCMP2
          KSTO = ZK8(LCMP-1+ICMP)
          IF (KCMP .EQ. KSTO) NEWK = .FALSE.
210     CONTINUE
        IF (NEWK) THEN
          NCMP2 = NCMP2+1
          ZK8(LCMP-1+NCMP2) = KCMP
        ENDIF
220   CONTINUE

      CALL CNSCRE(MA3,NOMGD,NCMP2,ZK8(LCMP),BASE,CNS2)
      CALL JEVEUO(CNS2//'.CNSK','L',JCNS2K)
      CALL JEVEUO(CNS2//'.CNSD','L',JCNS2D)
      CALL JEVEUO(CNS2//'.CNSC','L',JCNS2C)
      CALL JEVEUO(CNS2//'.CNSV','E',JCNS2V)
      CALL JEVEUO(CNS2//'.CNSL','E',JCNS2L)

C LISTE DES NOEUDS DU MACRO ELEMENT
      VNOEUM = MACREL//'.PROJM    .PJMNO'
      VRANGM = MACREL//'.PROJM    .PJMRG'
      CALL JEVEUO (VNOEUM, 'L', LNOEUM)
      CALL JEVEUO (VRANGM, 'L', LRANGM)
      CALL JELIRA(VNOEUM,'LONUTI',NDDLE,K8BID)

C INVERSE DE LA MATRICE DE PASSAGE : VSU = (TIT*PHI)-1
      VSU = MACREL//'.PROJM    .PJMIG'
      CALL JEVEUO(VSU,'L',LVSU)
      CALL JELIRA(VSU,'LONUTI',NBORD,K8BID)
      NBORD = NBORD/NDDLE
C NBORD : NOMBRE DE NUMERO D'ORDRE (MODE MESURE)

C RECUPERATION DES MODES MESURES
      VMES = MACREL//'.PROJM    .PJMMM'
      CALL JEVEUO(VMES,'L',LMESU)

      TRAV = '&TRAV'
      CALL WKVECT (TRAV, 'V V R', NBMESU*NDDLE, LTRAV)
C CALCUL DU PRODUIT : PHI*VSU
      DO 410 IDDL = 1,NBMESU
        DO 420 JDDL = 1,NDDLE
          IPOS = (JDDL-1)*NBMESU+IDDL
          ZR(LTRAV-1+IPOS) = 0.D0
          DO 430 IMOD = 1,NBORD
            IPOSI = (IMOD-1)*NBMESU+IDDL
            IPOSJ = (JDDL-1)*NBORD+IMOD
            ZR(LTRAV-1+IPOS) = ZR(LTRAV-1+IPOS) +
     &        ZR(LMESU-1+IPOSI)*ZR(LVSU-1+IPOSJ)
430       CONTINUE
420     CONTINUE
410   CONTINUE


C INITIALISATION A ZERO
      V2=0.D0
      V2C = DCMPLX(0.D0,0.D0)

      DO 110 IDDL=1,NBMESU
        INO2 = ZI(LNOEUD-1+IDDL)
        DO 70 ICMP=1,NCMP2
          ZL(JCNS2L-1+ (INO2-1)*NCMP2+ICMP)=.TRUE.
          IF (TSCA.EQ.'R') THEN
            ZR(JCNS2V-1+ (INO2-1)*NCMP2+ICMP)=V2
          ELSE
            ZC(JCNS2V-1+ (INO2-1)*NCMP2+ICMP)=V2C
          ENDIF
70      CONTINUE
110   CONTINUE


C PROJECTION DU CHAMP SUIVANT LA DIRECTION DE MESURE

      DO 100 IDDL=1,NBMESU
        INO2 = ZI(LNOEUD-1+IDDL)
        KCMP2 = ZK8(LRANGE-1+IDDL)

        DO 50 ICMP=1,NCMP2
          IF (ZK8(JCNS2C-1+ICMP).EQ.KCMP2) THEN
            ICMP2=ICMP
            GOTO 60
          ENDIF
50      CONTINUE
60      CONTINUE

        V2=0.D0
        V2C = DCMPLX(0.D0,0.D0)

        DO 200 JDDL=1,NDDLE
          INO1 = ZI(LNOEUM-1+JDDL)
          KCMP = ZK8(LRANGM-1+JDDL)
C ICI ON SUPPOSE QUE LES NOEUDS INTERFACES ONT LE MEME NOM
          CALL JENUNO(JEXNUM(MA2//'.NOMNOE',INO1),NONO)
          CALL JENONU(JEXNOM(MA1//'.NOMNOE',NONO),INO1)

          DO 150 ICMP=1,NCMP
            IF (ZK8(JCNS1C-1+ICMP).EQ.KCMP) THEN
              ICMP1=ICMP
              GOTO 160
            ENDIF
150       CONTINUE
160       CONTINUE

          COEF1 = ZR(LTRAV-1+(JDDL-1)*NBMESU+IDDL)

          IF (TSCA.EQ.'R') THEN
            V1=ZR(JCNS1V-1+(INO1-1)*NCMP+ICMP1)
            V2=V2+COEF1*V1
          ELSE
            V1C=ZC(JCNS1V-1+(INO1-1)*NCMP+ICMP1)
            V2C=V2C+COEF1*V1C
          ENDIF

200     CONTINUE

        ZL(JCNS2L-1+ (INO2-1)*NCMP2+ICMP2)=.TRUE.
        IF (TSCA.EQ.'R') THEN
          ZR(JCNS2V-1+ (INO2-1)*NCMP2+ICMP2)=V2
        ELSE
          ZC(JCNS2V-1+ (INO2-1)*NCMP2+ICMP2)=V2C
        ENDIF

C VERIFICATION SI LA MESURE EST SUR UN DES AXES DE COORDONNEES
C CERTAINS UTILISATEURS SONT HABITUES AUX CMP DX, DY, DZ
        IF ((KCMP2.EQ.'D1').OR.(KCMP2.EQ.'D2')
     &      .OR.(KCMP2.EQ.'D3')) THEN
          VALX = ZR(LORI-1+(IDDL-1)*3+1)
          VALY = ZR(LORI-1+(IDDL-1)*3+2)
          VALZ = ZR(LORI-1+(IDDL-1)*3+3)

          VALX= ABS(VALX)
          VALY= ABS(VALY)
          VALZ= ABS(VALZ)

          EPS = 1.D2*R8PREM()
          AXE = .FALSE.
          IF ((VALY.LT.EPS).AND.(VALZ.LT.EPS)) THEN
            DIR = 'DX'
            AXE = .TRUE.
          ENDIF
          IF ((VALX.LT.EPS).AND.(VALZ.LT.EPS)) THEN
            DIR = 'DY'
            AXE = .TRUE.
          ENDIF
          IF ((VALX.LT.EPS).AND.(VALY.LT.EPS)) THEN
            DIR = 'DZ'
            AXE = .TRUE.
          ENDIF

          IF (AXE) THEN
            DO 250 ICMP=1,NCMP2
              IF (ZK8(JCNS2C-1+ICMP).EQ.DIR) THEN
                ICMPD=ICMP
                GOTO 260
              ENDIF
250         CONTINUE
260         CONTINUE

            ZL(JCNS2L-1+ (INO2-1)*NCMP2+ICMPD)=.TRUE.
            IF (TSCA.EQ.'R') THEN
              ZR(JCNS2V-1+ (INO2-1)*NCMP2+ICMPD)=V2
            ELSE
              ZC(JCNS2V-1+ (INO2-1)*NCMP2+ICMPD)=V2C
            ENDIF
          ENDIF
        ENDIF

100   CONTINUE

      CALL JEDETR (TRAV)
      CALL JEDETR (LICMP)

      IRET = 0

 9999 CONTINUE
      CALL JEDEMA()
      END
