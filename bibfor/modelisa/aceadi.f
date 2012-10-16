      SUBROUTINE ACEADI(NOMA,NOMO,MCF,LMAX,NBOCC,IVR,IFM)
      IMPLICIT       NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8    NOMA,NOMO
      INTEGER        LMAX,NBOCC,IVR(*),IFM
      CHARACTER*(*)  MCF
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/10/2012   AUTEUR DEVESA G.DEVESA 
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
C
C --- ------------------------------------------------------------------
C     AFFE_CARA_ELEM
C     AFFECTATION DES CARACTERISTIQUES POUR LES ELEMENTS DISCRET
C --- ------------------------------------------------------------------
C  IN
C     NOMA   : NOM DU MAILLAGE
C     NOMO   : NOM DU MODELE
C     LMAX   : NOMBRE MAX DE MAILLE OU GROUPE DE MAILLE
C     NBOCC  : NOMBRE D'OCCURENCES DU MOT CLE DISCRET
C     IVR    : TABLEAU DES INDICES DE VERIFICATION
C --- ------------------------------------------------------------------
C
      INTEGER        NBCAR,NBVAL,NRD
      PARAMETER    ( NBCAR = 100 , NBVAL = 1000 , NRD = 2 )
      INTEGER        JDC(3),JDV(3),DIMMAT,DIMCAR,NM,II,L,IV,NDIM
      INTEGER        JDCINF,JDVINF,NBORM,NBORP,NCMP,KK,IBID,NBNOGR,NN
      INTEGER        NSYM,NETA,NREP,JDNW,NCARAC,I3D,I2D,IER
      INTEGER        IXNW,NBMTRD,JDDI,JDLS,I,J,IOC,IREP,ISYM,NG,NJ,NCAR
      INTEGER        NVAL,JDGN,NBOMP
      REAL*8         VAL(NBVAL),ETA,R8BID
      CHARACTER*1    KMA(3), K1BID
      CHARACTER*6    KI
      CHARACTER*8    K8B, NOMU,K8BID
      CHARACTER*9    CAR(NBCAR)
      CHARACTER*16   REP,REPDIS(NRD),CONCEP,CMD,SYM,SYMDIS(NRD)
      CHARACTER*19   CART(3),LIGMO,CARTDI
      CHARACTER*24   TMPND(3),TMPVD(3),TMPDIS,MLGGNO,MLGNNO
      CHARACTER*24   TMCINF,TMVINF,MODNEM
      INTEGER      IARG
C
      DATA REPDIS /'GLOBAL          ','LOCAL           '/
      DATA SYMDIS /'OUI             ','NON             '/
      DATA KMA    /'K','M','A'/
C --- --------------------------------------------------------------
C
      CALL JEMARQ()
      CALL GETRES(NOMU,CONCEP,CMD)
      TMPDIS = NOMU//'.DISCRET'
      MLGGNO = NOMA//'.GROUPENO'
      MLGNNO = NOMA//'.NOMNOE'
      LIGMO  = NOMO//'.MODELE    '
      MODNEM = NOMO//'.MODELE    .NEMA'

C --- VERIFICATION DES DIMENSIONS / MODELISATIONS
      IER = 0
      CALL VERDIS(NOMO,NOMA,'F',I3D,I2D,NDIM,IER)
      CALL ASSERT( (MCF.EQ.'DISCRET_2D').OR.(MCF.EQ.'DISCRET') )
C
      CALL JEEXIN(MODNEM,IXNW)
      NBMTRD = 0
      IF (IXNW.NE.0) THEN
         CALL JELIRA(MODNEM,'NMAXOC',NBMTRD,K1BID)
         CALL JEVEUO(MODNEM,'L',JDNW)
         CALL WKVECT(TMPDIS,'V V I',NBMTRD,JDDI)
      ENDIF
      CALL WKVECT('&&TMPDISCRET','V V K8',LMAX,JDLS)
C
C --- CONSTRUCTION DES CARTES ET ALLOCATION
C
C     CARTE INFO POUR TOUS LES DISCRETS
      CARTDI = NOMU//'.CARDINFO'
      CALL ALCART('G',CARTDI,NOMA,'CINFDI')
      TMCINF = CARTDI//'.NCMP'
      TMVINF = CARTDI//'.VALV'
      CALL JEVEUO(TMCINF,'E',JDCINF)
      CALL JEVEUO(TMVINF,'E',JDVINF)
C     PAR DEFAUT POUR M, A, K :
C        REPERE GLOBAL, MATRICE SYMETRIQUE, PAS AFFECTEE
      CALL INFDIS('DIMC',DIMCAR,R8BID,K8BID)
      DO 200 I = 1 , 3
         ZK8(JDCINF+I-1) = 'REP'//KMA(I)//'    '
         CALL INFDIS('INIT',IBID,ZR(JDVINF+I-1),ZK8(JDCINF+I-1))
         ZK8(JDCINF+I+2) = 'SYM'//KMA(I)//'    '
         CALL INFDIS('INIT',IBID,ZR(JDVINF+I+2),ZK8(JDCINF+I+2))
         ZK8(JDCINF+I+5) = 'DIS'//KMA(I)//'    '
         CALL INFDIS('INIT',IBID,ZR(JDVINF+I+5),ZK8(JDCINF+I+5))
200   CONTINUE
      ZK8(JDCINF+9)  = 'ETAK    '
      CALL INFDIS('INIT',IBID,ZR(JDVINF+9),ZK8(JDCINF+9))
      ZK8(JDCINF+10) = 'TYDI    '
      CALL INFDIS('INIT',IBID,ZR(JDVINF+10),ZK8(JDCINF+10))
C
      CALL NOCART(CARTDI,1,' ',' ',0,' ',0,' ',DIMCAR)
      IF (IXNW.NE.0) THEN
         CALL NOCART(CARTDI,-1,' ',' ',0,' ',0,LIGMO,DIMCAR)
      ENDIF
      DO 220 I = 1, 3
C        CARTE POUR LES DISCRETS
         CART(I)  = NOMU//'.CARDISC'//KMA(I)
         TMPND(I) = CART(I)//'.NCMP'
         TMPVD(I) = CART(I)//'.VALV'
         CALL ALCART('G',CART(I),NOMA,'CADIS'//KMA(I))
         CALL JEVEUO(TMPND(I),'E',JDC(I))
         CALL JEVEUO(TMPVD(I),'E',JDV(I))
220   CONTINUE
C
C --- AFFECTATION SYSTEMATIQUE DE VALEURS NULLES DANS LES CARTES
C     POUR TOUTES LES MAILLES AFIN DE POUVOIR CALCULER LES MATRICES
C     K,M,A DANS TOUS LES CAS DANS LE REPERE GLOBAL PAR DEFAUT
      CALL INFDIS('DMXM',DIMMAT,R8BID,K8BID)
      DO 20 I = 1 , 3
         DO 22 J = 1 , DIMMAT
            CALL CODENT(J,'G',KI)
            ZR(JDV(I)+J-1)  = 0.D0
            ZK8(JDC(I)+J-1) = KMA(I)//KI
22       CONTINUE
         CALL NOCART(CART(I),  1,' ',' ',0,' ',0,' ',DIMMAT)
         IF (IXNW.NE.0) THEN
            CALL NOCART(CART(I),  -1,' ',' ',0,' ',0,LIGMO,DIMMAT)
         ENDIF
20    CONTINUE

C
C --- BOUCLE SUR LES OCCURENCES DE DISCRET
      DO 30 IOC = 1 , NBOCC
         ETA  = 0.0D0
         IREP = 1
         ISYM = 1
         DO 31 I = 1 , NBVAL
            VAL(I) = 0.0D0
31       CONTINUE
         CALL GETVEM(NOMA,'GROUP_MA',MCF,'GROUP_MA',
     &                     IOC,IARG,LMAX,ZK8(JDLS),NG)
         CALL GETVEM(NOMA,'MAILLE'  ,MCF,'MAILLE',
     &                     IOC,IARG,LMAX,ZK8(JDLS),NM)
         CALL GETVEM(NOMA,'GROUP_NO',MCF,'GROUP_NO',
     &                     IOC,IARG,LMAX,ZK8(JDLS),NJ)
         CALL GETVEM(NOMA,'NOEUD'   ,MCF,'NOEUD',
     &                     IOC,IARG,LMAX,ZK8(JDLS),NN)
         CALL GETVR8(MCF,'VALE',IOC,IARG,NBVAL,VAL,NVAL)
         CALL ASSERT( NBVAL .GE. 1 )
         CALL GETVTX(MCF,'CARA',IOC,IARG,NBCAR,CAR,NCAR)
         IF (NCAR .GT. 0) NCARAC = NCAR
         CALL ASSERT( NCARAC .EQ. 1 )

         CALL GETVTX(MCF,'REPERE'   ,IOC,IARG,1,REP,NREP)
         CALL GETVR8(MCF,'AMOR_HYST',IOC,IARG,1,ETA,NETA)
         IF (IOC.EQ.1 .AND. NREP.EQ.0) REP = REPDIS(1)
         DO 32 I = 1 , NRD
            IF (REP.EQ.REPDIS(I)) IREP = I
 32      CONTINUE

C        MATRICE SYMETRIQUE OU NON-SYMETRIQUE : PAR DEFAUT SYMETRIQUE
         CALL GETVTX(MCF,'SYME',IOC,IARG,1,SYM,NSYM)
         IF ( NSYM.EQ.0 ) SYM = SYMDIS(1)
         DO 33 I = 1 , NRD
            IF (SYM.EQ.SYMDIS(I)) ISYM = I
33       CONTINUE
C
         IF ( IVR(3) .EQ. 1 ) THEN
            IF ( ISYM .EQ. 1) THEN
               WRITE(IFM,1000) REP,'SYMETRIQUE',IOC
            ELSE
               WRITE(IFM,1000) REP,'NON-SYMETRIQUE',IOC
            ENDIF
1000        FORMAT(/,3X,
     &      '<DISCRET> MATRICES (REPERE ',A6,') ',
     &      'AFFECTEES AUX ELEMENTS DISCRETS ',
     &      '(TYPE ',A,'), OCCURENCE ',I4)
         ENDIF
C
C ---    "GROUP_MA" = TOUTES LES MAILLES DE TOUS LES GROUPES DE MAILLES
         IF (NG.GT.0) THEN
            IV = 1
            DO 36 I = 1,NCARAC
               CALL AFFDIS(NDIM,IREP,ETA,CAR(I),VAL,JDC,JDV,
     &                     IVR,IV,KMA,NCMP,L,
     &                     JDCINF,JDVINF,ISYM,IFM)
               DO 38 II = 1 , NG
                  CALL NOCART(CARTDI, 2,ZK8(JDLS+II-1),' ',0,' ',0,
     &                        ' ',DIMCAR)
                  CALL NOCART(CART(L),2,ZK8(JDLS+II-1),' ',0,' ',0,
     &                        ' ',NCMP)
38             CONTINUE
36          CONTINUE
         ENDIF
C
C ---   "MAILLE" = TOUTES LES MAILLES  DE LA LISTE DE MAILLES
         IF (NM.GT.0) THEN
            IV = 1
            DO 40 I = 1,NCARAC
               CALL AFFDIS(NDIM,IREP,ETA,CAR(I),VAL,JDC,JDV,
     &                     IVR,IV,KMA,NCMP,L,
     &                     JDCINF,JDVINF,ISYM,IFM)
               CALL NOCART(CARTDI, 3,' ','NOM',NM,ZK8(JDLS),0,' ',
     &                     DIMCAR)
               CALL NOCART(CART(L),3,' ','NOM',NM,ZK8(JDLS),0,' ',
     &                     NCMP)
40          CONTINUE
         ENDIF
C
C ---    SI DES MAILLES TARDIVES EXISTENT POUR CE MODELE :
         IF (IXNW.NE.0) THEN
C ---       "GROUP_NO" = TOUTES LES MAILLES TARDIVES DE
C                    LA LISTE DE GROUPES DE NOEUDS
            IF (NJ.GT.0) THEN
               DO 42 I = 1 , NJ
                  CALL JEVEUO(JEXNOM(MLGGNO,ZK8(JDLS+I-1)),'L',JDGN)
                  CALL JELIRA(JEXNOM(MLGGNO,ZK8(JDLS+I-1)),'LONUTI',
     &                                                  NBNOGR,K1BID)
                  CALL CRLINU('NUM', MLGNNO, NBNOGR, ZI(JDGN), K8B,
     &                         NBMTRD, ZI(JDNW), ZI(JDDI), KK )
                  IF (KK.GT.0) THEN
                     IV = 1
                     DO 44 II = 1,NCARAC
                        CALL AFFDIS(NDIM,IREP,ETA,CAR(II),VAL,JDC,JDV,
     &                              IVR,IV,KMA,NCMP,L,
     &                              JDCINF,JDVINF,ISYM,IFM)
                        CALL NOCART(CARTDI, -3,' ','NUM',KK,' ',
     &                              ZI(JDDI),LIGMO,DIMCAR)
                        CALL NOCART(CART(L),-3,' ','NUM',KK,' ',
     &                              ZI(JDDI),LIGMO,NCMP)
 44                  CONTINUE
                  ENDIF
 42            CONTINUE
            ENDIF
C ---       "NOEUD" = TOUS LES NOEUDS TARDIFS DE LA LISTE DE NOEUDS
            IF (NN.GT.0) THEN
               CALL CRLINU('NOM', MLGNNO, NN, IBID, ZK8(JDLS),
     &                      NBMTRD, ZI(JDNW), ZI(JDDI), KK )
               IF (KK.GT.0) THEN
                  IV = 1
                  DO 46 I = 1,NCARAC
                     CALL AFFDIS(NDIM,IREP,ETA,CAR(I),VAL,JDC,JDV,
     &                           IVR,IV,KMA,NCMP,L,
     &                           JDCINF,JDVINF,ISYM,IFM)
                     CALL NOCART(CARTDI, -3,' ','NUM',KK,' ',ZI(JDDI),
     &                           LIGMO,DIMCAR)
                     CALL NOCART(CART(L),-3,' ','NUM',KK,' ',ZI(JDDI),
     &                           LIGMO,NCMP)
 46               CONTINUE
               ENDIF
            ENDIF
         ENDIF
 30   CONTINUE
C
      IF (IXNW.NE.0) CALL JEDETR(TMPDIS)
      CALL JEDETR('&&TMPDISCRET')
      CALL GETFAC('RIGI_PARASOL',NBORP)
      CALL GETFAC('RIGI_MISS_3D',NBORM)
      CALL GETFAC('MASS_AJOU',NBOMP)
      IF (NBORP.EQ.0.AND.NBORM.EQ.0.AND.NBOMP.EQ.0) THEN
         DO 240 I = 1 , 3
            CALL JEDETR(TMPND(I))
            CALL JEDETR(TMPVD(I))
240      CONTINUE
         CALL JEDETR(TMCINF)
         CALL JEDETR(TMVINF)
      ENDIF
C
      CALL JEDEMA()
      END
