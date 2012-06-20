      SUBROUTINE CRSVMU(MOTFAC,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,
     &           KMD)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER      ISTOP,NPREC
      REAL*8       EPSMAT
      CHARACTER*3  SYME,MIXPRE,KMD
      CHARACTER*16 MOTFAC
      CHARACTER*19 SOLVEU
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2012   AUTEUR BOITEAU O.BOITEAU 
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
C ----------------------------------------------------------
C  BUT : REMPLISSAGE SD_SOLVEUR MUMPS
C        ATTENTION A LA COHERENCE AVEC CRSMSP ET CRSINT
C
C IN K19 SOLVEU  : NOM DU SOLVEUR DONNE EN ENTREE
C OUT    SOLVEU  : LE SOLVEUR EST CREE ET INSTANCIE
C IN  IN ISTOP   : PARAMETRE LIE AUX MOT-CLE STOP_SINGULIER
C IN  IN NPREC   :                           NPREC
C IN  K3 SYME    :                           SYME
C IN  R8 EPSMAT  :                           FILTRAGE_MATRICE
C IN  K3 MIXPRE  :                           MIXER_PRECISION
C IN  K3 KMD     :                           MATR_DISTRIBUEE
C ----------------------------------------------------------

      INTEGER IBID,IFM,NIV,I,PCPIV,NBPROC,RANG,IAUX,JREFA
      INTEGER MONIT(12),JNUMSD,N1,VALI(2),COMPT
      INTEGER JMAIL,NBMA,ISLVK,ISLVR,ISLVI,IRET
      REAL*8       EPS
      CHARACTER*3  KDJ
      CHARACTER*4  KLAG2
      CHARACTER*8  KTYPR,KTYPS,KTYPRN,KTYPP,MODELE,PARTIT,KBID,MATRA
      CHARACTER*12 KOOC
      CHARACTER*19 K19B
      CHARACTER*24 KMONIT(12),K24B
      INTEGER      GETEXM,EXIMO1,EXIMO2,EXIMC,EXIMOD,JPRTI,JPRTK
      INTEGER      IARG,JPART,IEXI
      LOGICAL LDGREL
C------------------------------------------------------------------
      CALL JEMARQ()

C --- INIT
      CALL INFNIV(IFM,NIV)
      RANG=0
      NBPROC=1
      IF (NIV.GE.2) THEN
        CALL MPICM0(RANG,NBPROC)
      ENDIF

C --- POUR MONITORING: RECHERCHE DU NBRE DE MAILLES PAR PROC
C     SI INF>1 ET SI EXISTENCE D'UN MODELE
C --- PREMIER CAS DE FIGURE: OPERATEUR A MOT-CLE MODELE (QUASI-STATIQUE)
C     SECOND CAS DE FIGURE:                      MATR_A (MODAL)
      EXIMOD=0
      EXIMO1=0
      EXIMO1=GETEXM(' ','MODELE')
      IF (EXIMO1.EQ.1) EXIMOD=1
      EXIMO2=0
      EXIMO2=GETEXM(' ','MATR_A')
      IF (EXIMO2.EQ.1) EXIMOD=1
      COMPT=-9999
      IF ((EXIMOD.EQ.1).AND.(NIV.GE.2)) THEN
        IF (EXIMO1.EQ.1) THEN
          CALL GETVID(' ','MODELE',1,IARG,1,MODELE,IBID)
          IF (IBID.NE.1) GOTO 70
        ELSE IF (EXIMO2.EQ.1) THEN
          CALL GETVID(' ','MATR_A',1,IARG,1,MATRA,IBID)
          IF (IBID.NE.1) GOTO 70
          K19B=' '
          K19B=MATRA
          CALL JEVEUO(K19B//'.REFA','L',JREFA)
          IF (ZK24(JREFA+9)(1:4).EQ.'GENE') THEN
C         CAS PARTICULIER DU NUME_DDL_GENE
            GOTO 70
          ELSE IF (ZK24(JREFA+9)(1:4).EQ.'NOEU') THEN
            CALL DISMOI('F','NOM_MODELE',MATRA,'MATR_ASSE',IBID,
     &                MODELE,IRET)
          ELSE
C --- CAS NON PREVU
            CALL ASSERT(.FALSE.)
          ENDIF
        ENDIF

C       -- PARTITION POUR LE PARALLELISME :
        PARTIT=' '
        CALL JEEXIN(MODELE//'.PARTIT',IEXI)
        IF (IEXI.GT.0) THEN
          CALL JEVEUO(MODELE//'.PARTIT','L',JPART)
          IF (ZK8(JPART-1+1).NE.' ') THEN
            PARTIT=ZK8(JPART-1+1)
          ENDIF
        ENDIF

        IF (PARTIT.NE.' ') THEN
C         -- CALCUL DISTRIBUE :
          CALL JEVEUO(PARTIT//'.PRTI','L',JPRTI)
          IF (ZI(JPRTI).NE.NBPROC) THEN
            VALI(1)=ZI(JPRTI)
            VALI(2)=NBPROC
            CALL U2MESI('F','CALCULEL_13',2,VALI)
          ENDIF

          CALL JEVEUO(PARTIT//'.PRTK','L',JPRTK)
          LDGREL=ZK24(JPRTK-1+1).EQ.'GROUP_ELEM'
          IF (.NOT.LDGREL) THEN
            CALL JEVEUO(PARTIT//'.NUPROC.MAILLE','L',JNUMSD)
            CALL JELIRA(PARTIT//'.NUPROC.MAILLE','LONMAX',N1,KBID)
            CALL ASSERT(ZI(JNUMSD-1+N1).EQ.NBPROC)
            NBMA=N1-1
            COMPT=0
            DO 50 I=1,NBMA
              IF (ZI(JNUMSD-1+I).EQ.RANG) COMPT=COMPT+1
   50       CONTINUE
          ENDIF
        ELSE
C       -- CENTRALISE
          CALL JEVEUO(MODELE//'.MAILLE','L',JMAIL)
          CALL JELIRA(MODELE//'.MAILLE','LONMAX',NBMA,K24B)
          COMPT=0
          DO 60 I=1,NBMA
            IF (ZI(JMAIL-1+I).NE.0)COMPT=COMPT+1
   60     CONTINUE
        ENDIF
      ENDIF


C --- OBJETS DE MONITORING
C --- INDIRECTION SI ON N'A PAS PU LIRE LE MODELE (NUME_DDL_GENE)
   70 CONTINUE
      IF (NIV.GE.2) THEN
        KMONIT(1)='&MUMPS.INFO.MAILLE'
        KMONIT(2)='&MUMPS.INFO.MEMOIRE'
        KMONIT(9)='&MUMPS.NB.MAILLE'
        KMONIT(10)='&MUMPS.INFO.MEM.EIC'
        KMONIT(11)='&MUMPS.INFO.MEM.EOC'
        KMONIT(12)='&MUMPS.INFO.MEM.USE'
        CALL WKVECT(KMONIT(1),'V V I',NBPROC,MONIT(1))
        CALL WKVECT(KMONIT(2),'V V I',NBPROC,MONIT(2))
        CALL WKVECT(KMONIT(9),'V V I',NBPROC,MONIT(9))
        CALL WKVECT(KMONIT(10),'V V I',NBPROC,MONIT(10))
        CALL WKVECT(KMONIT(11),'V V I',NBPROC,MONIT(11))
        CALL WKVECT(KMONIT(12),'V V I',NBPROC,MONIT(12))
        DO 110 I=1,NBPROC
          ZI(MONIT(1)+I-1)=0
          ZI(MONIT(2)+I-1)=0
          ZI(MONIT(9)+I-1)=0
          ZI(MONIT(10)+I-1)=0
          ZI(MONIT(11)+I-1)=0
          ZI(MONIT(12)+I-1)=0
  110   CONTINUE
C -----
        ZI(MONIT(9)+RANG)=COMPT
        CALL MPICM2('REDUCE',KMONIT(9))
C ----- CORRECTION SI MODAL
        IF (EXIMO2.EQ.1) THEN
          IAUX=0
          DO 112 I=1,NBPROC
            IAUX=IAUX+ZI(MONIT(9)+I-1)
  112     CONTINUE
          DO 114 I=1,NBPROC
            ZI(MONIT(9)+I-1)=IAUX
  114     CONTINUE
        ENDIF
      ENDIF

C --- LECTURES PARAMETRES DEDIES AU SOLVEUR
      CALL GETVIS(MOTFAC,'PCENT_PIVOT',1,IARG,1,PCPIV,IBID)
      CALL ASSERT(IBID.EQ.1)
      CALL GETVTX(MOTFAC,'TYPE_RESOL',1,IARG,1,KTYPR,IBID)
      CALL ASSERT(IBID.EQ.1)
      CALL GETVTX(MOTFAC,'PRETRAITEMENTS',1,IARG,1,KTYPS,IBID)
      CALL ASSERT(IBID.EQ.1)

      KTYPP='SANS'
      EXIMC=GETEXM(MOTFAC,'POSTTRAITEMENTS')
      IF (EXIMC.EQ.1) THEN
        CALL GETVTX(MOTFAC,'POSTTRAITEMENTS',1,IARG,1,KTYPP,IBID)
      ENDIF

      CALL GETVTX(MOTFAC,'RENUM',1,IARG,1,KTYPRN,IBID)
      CALL ASSERT(IBID.EQ.1)
      CALL GETVTX(MOTFAC,'ELIM_LAGR2',1,IARG,1,KLAG2,IBID)
      CALL ASSERT(IBID.EQ.1)

      EPS=-1.D0
      EXIMC=GETEXM(MOTFAC,'RESI_RELA')
      IF (EXIMC.EQ.1) THEN
        CALL GETVR8(MOTFAC,'RESI_RELA',1,IARG,1,EPS,IBID)
      ENDIF

      CALL GETVTX(MOTFAC,'GESTION_MEMOIRE',1,IARG,1,KOOC,IBID)
      CALL ASSERT(IBID.EQ.1)

C --- ON REMPLIT LA SD_SOLVEUR
C --- ATTENTION A LA COHERENCE AVEC CRSMSP

      CALL JEVEUO(SOLVEU//'.SLVK','E',ISLVK)
      CALL JEVEUO(SOLVEU//'.SLVR','E',ISLVR)
      CALL JEVEUO(SOLVEU//'.SLVI','E',ISLVI)

      ZK24(ISLVK-1+1)  = 'MUMPS'
      ZK24(ISLVK-1+2)  = KTYPS
      ZK24(ISLVK-1+3)  = KTYPR
      ZK24(ISLVK-1+4)  = KTYPRN
      ZK24(ISLVK-1+5)  = SYME
      ZK24(ISLVK-1+6)  = KLAG2
      ZK24(ISLVK-1+7)  = MIXPRE
      ZK24(ISLVK-1+8)  = 'NON'
      ZK24(ISLVK-1+9)  = KOOC
      ZK24(ISLVK-1+10) = KMD
      ZK24(ISLVK-1+11) = KTYPP
      ZK24(ISLVK-1+12) = 'XXXX'

      ZR(ISLVR-1+1) = EPSMAT
      ZR(ISLVR-1+2) = EPS
      ZR(ISLVR-1+3) = 0.D0
      ZR(ISLVR-1+4) = 0.D0

      ZI(ISLVI-1+1) = NPREC
      ZI(ISLVI-1+2) = PCPIV
      ZI(ISLVI-1+3) = ISTOP
      ZI(ISLVI-1+4) = -9999
      ZI(ISLVI-1+5) = -9999
      ZI(ISLVI-1+6) = -9999
      ZI(ISLVI-1+7) = -9999

      CALL JEDEMA()
      END
