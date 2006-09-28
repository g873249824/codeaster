      SUBROUTINE POFAUN
      IMPLICIT   NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     -----------------------------------------------------------------
C     COMMANDE POST_FATIGUE :
C              CHARGEMENT PUREMENT UNIAXIAL
C     -----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ------------------------------------------------------------------
      INTEGER NBOCC,IFONC,NBPTS,I,N1,NBPAPF,IFM,NIV,NBP
      INTEGER IVKE,IVCORR,IVPOIN,NBPOIN,IVMAX,IVMIN,IVTRAV
      INTEGER IBID,INTRAV,IVPICS,NBPICS,NBCYCL,NBPAR,IVDOME
      CHARACTER*2 CODRET(3),CODWO,CODBA,CODHS,CODMA
      CHARACTER*8 NOMFON,RESULT,TXCUM,K8B,NOMMAT,KCORRE,CARA
      CHARACTER*8 METHOD,NOMPAR,NOMRES(3)
      CHARACTER*16 PHENO,PHENOM,KDOMM,NOMCMD
      CHARACTER*24 FVALE
      REAL*8 R8B,PSEUIL,RDOMM,VAL(3),RAMPL
      COMPLEX*16 CBID
      LOGICAL LHAIGH,FATEPS,LKE
C     --- POST_FATI_UNIAX ----------------------------------------------
      PARAMETER (NBPAPF=5)
      CHARACTER*1 TYPPPF(NBPAPF)
      CHARACTER*16 NOMPPF(NBPAPF)
      DATA NOMPPF/'CYCLE','VALE_MIN','VALE_MAX','DOMMAGE','DOMM_CUMU'/
      DATA TYPPPF/'I','R','R','R','R'/
C     ------------------------------------------------------------------

      CALL JEMARQ()

      FATEPS = .FALSE.
      LHAIGH = .FALSE.
      LKE = .FALSE.
      IVPICS = 0
      IVKE = 0
      IVCORR = 0

C     --- RECUPERATION DU NIVEAU D'IMPRESSION ---

      CALL INFNIV(IFM,NIV)

      CALL GETRES(RESULT,K8B,NOMCMD)

C     --- RECUPERATION DE LA FONCTION CHARGEMENT ---

      NOMFON = ' '
      CALL GETVID('HISTOIRE','SIGM',1,1,1,NOMFON,N1)
      CALL GETVID('HISTOIRE','EPSI',1,1,1,NOMFON,N1)
      IF (N1.NE.0) FATEPS = .TRUE.

      FVALE = NOMFON//'           .VALE'
      CALL JELIRA(FVALE,'LONMAX',NBPTS,K8B)
      CALL JEVEUO(FVALE,'L',IFONC)
      NBPTS = NBPTS/2
      CALL WKVECT('&&POFAUN.FONC.POIN','V V R',NBPTS,IVPOIN)

C     --- IMPRESSION DE LA FONCTION ----
      IF (NIV.EQ.2) THEN
        WRITE (IFM,'(1X,A)') 'VALEURS DE LA FONCTION CHARGEMENT:'
        DO 10 I = 1,NBPTS
          WRITE (IFM,1000) ZR(IFONC+I-1),ZR(IFONC+NBPTS+I-1)
   10   CONTINUE
      END IF

C     --- EXTRACTION DES PICS DE LA FONCTION DE CHARGEMENT ---

      CALL GETVR8(' ','DELTA_OSCI',1,1,1,PSEUIL,N1)
      CALL FGPEAK(NOMFON,PSEUIL,NBPOIN,ZR(IVPOIN))

C     --- IMPRESSION DES PICS EXTRAITS DE LA FONCTION ----
      IF (NIV.EQ.2) THEN
        WRITE (IFM,*)
        WRITE (IFM,'(1X,A)') 'PICS EXTRAITS DE LA FONCTION CHARGEMENT'
        WRITE (IFM,1010) PSEUIL,NBPOIN
        WRITE (IFM,*)
        WRITE (IFM,'(4(1X,E18.6))') (ZR(IVPOIN+I-1),I=1,NBPOIN)
      END IF

C     --- RECUPERATION DU COEFFICIENT D'AMPLIFICATION ---
      CALL GETFAC('COEF_MULT',NBOCC)
      IF (NBOCC.NE.0) THEN
        CALL GETVR8('COEF_MULT','KT',1,1,1,RAMPL,N1)
        CALL FGAMPL(RAMPL,NBPOIN,ZR(IVPOIN))
      END IF

C     ---RECUPERATION DE LA LOI DE COMPTAGES DE CYCLES

      CALL GETVTX(' ','COMPTAGE',1,1,1,METHOD,N1)

      CALL WKVECT('&&POFAUN.SIGMAX','V V R',NBPOIN+2,IVMAX)
      CALL WKVECT('&&POFAUN.SIGMIN','V V R',NBPOIN+2,IVMIN)
      CALL WKVECT('&&POFAUN.POIN.TRAV','V V R',NBPOIN+2,IVTRAV)
      CALL WKVECT('&&POFAUN.NUME.TRAV','V V I',2* (NBPOIN+2),INTRAV)
      IF (METHOD.EQ.'RAINFLOW') THEN
        CALL WKVECT('&&POFAUN.FONC.PICS','V V R',NBPOIN+2,IVPICS)
        CALL FGPIC2(METHOD,ZR(IVTRAV),ZR(IVPOIN),NBPOIN,ZR(IVPICS),
     &              NBPICS)
        CALL FGRAIN(ZR(IVPICS),NBPICS,ZI(INTRAV),NBCYCL,ZR(IVMIN),
     &              ZR(IVMAX))
      ELSE IF (METHOD.EQ.'RCCM') THEN
        CALL FGORDO(NBPOIN,ZR(IVPOIN),ZR(IVTRAV))
        CALL FGRCCM(NBPOIN,ZR(IVTRAV),NBCYCL,ZR(IVMIN),ZR(IVMAX))
      ELSE IF (METHOD.EQ.'NATUREL') THEN
        CALL FGCOTA(NBPOIN,ZR(IVPOIN),NBCYCL,ZR(IVMIN),ZR(IVMAX))
      ELSE
        CALL U2MESS('F','PREPOST4_52')
      END IF
      IF (NBCYCL.EQ.0) CALL U2MESS('F','PREPOST4_53')

C     --- CORRECTION ELASTO-PLASTIQUE ---

      KCORRE = ' '
      CALL GETVTX(' ','CORR_KE',1,1,1,KCORRE,N1)
      CALL GETVID(' ','MATER',1,1,1,NOMMAT,N1)
      IF (KCORRE.EQ.'RCCM') THEN
        NOMRES(1) = 'N_KE'
        NOMRES(2) = 'M_KE'
        NOMRES(3) = 'SM'
        NBPAR = 0
        NOMPAR = ' '
        CALL RCVALE(NOMMAT,'RCCM',NBPAR,NOMPAR,R8B,3,NOMRES,VAL,CODRET,
     &              'F ')
        CALL WKVECT('&&POFAUN.KE','V V R',NBCYCL,IVKE)
        LKE = .TRUE.
        CALL FGCOKE(NBCYCL,ZR(IVMIN),ZR(IVMAX),VAL(1),VAL(2),VAL(3),
     &              ZR(IVKE))
      END IF

C     --- CALCUL DU DOMMAGE ELEMENTAIRE ---

      KDOMM = ' '
      CALL GETVTX(' ','DOMMAGE',1,1,1,KDOMM,N1)

      CALL WKVECT('&&POFAUN.DOMM.ELEM','V V R',NBCYCL,IVDOME)

C     --- CALCUL DU DOMMAGE ELEMENTAIRE DE WOHLER ---
C         ---------------------------------------
      IF (KDOMM.EQ.'WOHLER') THEN
C        ---CORRECTION DE HAIG (GOODMANN OU GERBER)
        KCORRE = ' '
        CALL GETVTX(' ','CORR_SIGM_MOYE',1,1,1,KCORRE,N1)
        IF (KCORRE.NE.' ') THEN
          NOMRES(1) = 'SU'
          NBPAR = 0
          NOMPAR = ' '
          CALL RCVALE(NOMMAT,'RCCM',NBPAR,NOMPAR,R8B,1,NOMRES,VAL,
     &                CODRET,'F ')
          CALL WKVECT('&&POFAUN.HAIG','V V R',NBCYCL,IVCORR)
          LHAIGH = .TRUE.
          CALL FGCORR(NBCYCL,ZR(IVMIN),ZR(IVMAX),KCORRE,VAL(1),
     &                ZR(IVCORR))
        END IF

        PHENO = 'FATIGUE'
        CALL RCCOME(NOMMAT,PHENO,PHENOM,CODRET(1))
        IF (CODRET(1).EQ.'NO') CALL U2MESS('F','PREPOST_2')
        CARA = 'WOHLER'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODWO)
        CARA = 'A_BASQUI'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODBA)
        CARA = 'A0'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODHS)
        IF (CODWO.EQ.'OK') THEN
          CALL FGDOWH(NOMMAT,NBCYCL,ZR(IVMIN),ZR(IVMAX),LKE,ZR(IVKE),
     &                LHAIGH,ZR(IVCORR),ZR(IVDOME))
        ELSE IF (CODBA.EQ.'OK') THEN
          CALL FGDOBA(NOMMAT,NBCYCL,ZR(IVMIN),ZR(IVMAX),LKE,ZR(IVKE),
     &                LHAIGH,ZR(IVCORR),ZR(IVDOME))
        ELSE IF (CODHS.EQ.'OK') THEN
          CALL FGDOHS(NOMMAT,NBCYCL,ZR(IVMIN),ZR(IVMAX),LKE,ZR(IVKE),
     &                LHAIGH,ZR(IVCORR),ZR(IVDOME))
        END IF

C     --- CALCUL DU DOMMAGE ELEMENTAIRE DE MANSON_COFFIN ----
C         ----------------------------------------------
      ELSE IF (KDOMM.EQ.'MANSON_COFFIN') THEN
        IF (.NOT.FATEPS) THEN
          CALL U2MESS('F','PREPOST4_54')
        END IF
        PHENO = 'FATIGUE'
        CALL RCCOME(NOMMAT,PHENO,PHENOM,CODRET(1))
        IF (CODRET(1).EQ.'NO') CALL U2MESS('F','PREPOST_2')
        CARA = 'MANSON_C'
        CALL RCPARE(NOMMAT,PHENO,CARA,CODMA)
        IF (CODMA.EQ.'OK') THEN
          CALL FGDOMA(NOMMAT,NBCYCL,ZR(IVMIN),ZR(IVMAX),ZR(IVDOME))
        ELSE
          CALL U2MESS('F','PREPOST4_55')
        END IF

C     --- CALCUL DU DOMMAGE ELEMENTAIRE DE TAHERI ---
C         ---------------------------------------
      ELSE IF (KDOMM(1:6).EQ.'TAHERI') THEN
        IF (FATEPS) THEN
          CALL FGTAHE(KDOMM,NBCYCL,ZR(IVMIN),ZR(IVMAX),ZR(IVDOME))
        ELSE
          CALL U2MESS('F','PREPOST4_56')
        END IF

      ELSE IF (KDOMM.EQ.' ') THEN
      ELSE
        CALL U2MESS('F','PREPOST4_49')
      END IF

C     --- CREATION DE LA TABLE ---

      CALL TBCRSD(RESULT,'G')
      CALL TBAJPA(RESULT,NBPAPF,NOMPPF,TYPPPF)

      NBP = 4
      IF (KDOMM.EQ.' ') NBP = 3
      DO 20 I = 1,NBCYCL
        VAL(1) = ZR(IVMIN+I-1)
        VAL(2) = ZR(IVMAX+I-1)
        VAL(3) = ZR(IVDOME+I-1)
        CALL TBAJLI(RESULT,NBP,NOMPPF,I,VAL,CBID,K8B,0)
   20 CONTINUE

C     --- CALCUL DU DOMMAGE TOTAL ---

      TXCUM = ' '
      CALL GETVTX(' ','CUMUL',1,1,1,TXCUM,N1)
      IF (TXCUM.EQ.'LINEAIRE') THEN

        CALL FGDOMM(NBCYCL,ZR(IVDOME),RDOMM)

        CALL TBAJLI(RESULT,1,NOMPPF(5),IBID,RDOMM,CBID,K8B,0)

      END IF

      CALL JEDETR('&&POFAUN.FONC.POIN')
      CALL JEDETR('&&POFAUN.SIGMAX')
      CALL JEDETR('&&POFAUN.SIGMIN')
      CALL JEDETR('&&POFAUN.POIN.TRAV')
      CALL JEDETR('&&POFAUN.NUME.TRAV')
      CALL JEDETR('&&POFAUN.DOMM.ELEM')
      IF (IVPICS.NE.0) CALL JEDETR('&&POFAUN.FONC.PICS')
      IF (IVKE.NE.0) CALL JEDETR('&&POFAUN.KE')
      IF (IVCORR.NE.0) CALL JEDETR('&&POFAUN.HAIG')

 1000 FORMAT (2X,E18.6,5X,E18.6)
 1010 FORMAT (1X,'SEUIL = ',E18.6,10X,'NB DE PICS = ',I5)

      CALL JEDEMA()
      END
