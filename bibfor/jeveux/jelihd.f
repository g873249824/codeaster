      SUBROUTINE JELIHD ( NOMF, FICHDF, CLAS )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 21/04/2008   AUTEUR LEFEBVRE J-P.LEFEBVRE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_18 CRP_20 CRS_508 CRS_512 CRS_513 CRS_505 
      IMPLICIT NONE
      CHARACTER*(*)       NOMF, FICHDF, CLAS
C ----------------------------------------------------------------------
C ROUTINE UTILISATEUR D'OUVERTURE D'UNE BASE AVEC LECTURE SUR
C FICHIER HDF
C
C IN  NOMF   : NOM LOCALE DE LA BASE
C IN  FICHDF : NOM LOCAL DU FICHIER HDF UTILISE POUR L'IMPRESSION
C IN  CLAS   : NOM DE LA CLASSE ASSOCIEE
C
C ----------------------------------------------------------------------
      CHARACTER *24                     NOMCO
      CHARACTER *32    NOMUTI , NOMOS ,         NOMOC , BL32
      COMMON /NOMCJE/  NOMUTI , NOMOS , NOMCO , NOMOC , BL32
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      REAL*8           R8ZON(1)
      LOGICAL          LSZON(1)
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) , R8ZON(1) , LSZON(1) )
      INTEGER          N
      PARAMETER      ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     &                 LONO    , HCOD    , CARA    , LUTI    , IMARQ   
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     &                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      INTEGER          JLTYP   , JLONG   , JDATE   , JIADD   , JIADM   ,
     &                 JLONO   , JHCOD   , JCARA   , JLUTI   , JMARQ   
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
C
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      INTEGER          JGENR   , JTYPE   , JDOCU   , JORIG   , JRNOM
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
      INTEGER          IACCE, JIACCE, IUSADI, JUSADI
      COMMON /IACCED/  IACCE(1)
      COMMON /JIACCE/  JIACCE(N)
      COMMON /KUSADI/  IUSADI(1)
      COMMON /JUSADI/  JUSADI(N)
C ----------------------------------------------------------------------
      INTEGER          NBLMAX    , NBLUTI    , LONGBL    ,
     &                 KITLEC    , KITECR    ,             KIADM    ,
     &                 IITLEC    , IITECR    , NITECR    , KMARQ
      COMMON /IFICJE/  NBLMAX(N) , NBLUTI(N) , LONGBL(N) ,
     &                 KITLEC(N) , KITECR(N) ,             KIADM(N) ,
     &                 IITLEC(N) , IITECR(N) , NITECR(N) , KMARQ(N)
C
      INTEGER          NRHCOD    , NREMAX    , NREUTI
      COMMON /ICODJE/  NRHCOD(N) , NREMAX(N) , NREUTI(N)
C
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
      CHARACTER*8      NOMBAS
      COMMON /KBASJE/  NOMBAS(N)
      INTEGER          IDN    , IEXT    , NBENRG
      COMMON /IEXTJE/  IDN(N) , IEXT(N) , NBENRG(N)
      INTEGER          NBCLA
      COMMON /NFICJE/  NBCLA
C ----------------------------------------------------------------------
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      INTEGER          LFIC,MFIC
      COMMON /FENVJE/  LFIC,MFIC
C
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
      INTEGER          LDYN , LGDYN , NBDYN , NBFREE
      COMMON /IDYNJE/  LDYN , LGDYN , NBDYN , NBFREE
C---------- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C---------- FIN  COMMUNS NORMALISES  JEVEUX ----------------------------
      CHARACTER*4      Z
      PARAMETER      ( Z = 'INIT' )
      CHARACTER*8      KNOM,KNOMF,KSTIN,KSTOU,CVERSB,CVERSU
      CHARACTER*16     K16BID
      INTEGER          NCAR , ITLEC(1) , ITECR(1) , IADADD(2)
      PARAMETER      ( NCAR = 11 )
C ----------------------------------------------------------------------
      CHARACTER*1      KCLAS,TYPEI,GENRI,TYPEB
      CHARACTER*80     NHDF
      CHARACTER*32     CRNOM,NGRP,K32(1),K32B(2),NOMO
      CHARACTER*24     KATTR(5),KATTRG(5),NOMATR,NOMAT2
      CHARACTER*8      K8(1),K8B(2),NREP(2)
      PARAMETER      ( NOMATR = 'ATTRIBUTS JEVEUX',
     &                 NOMAT2 = 'BASE GLOBALE JEVEUX' )
      INTEGER          IPGCA,LTYPI,LONOI,NBOBJ,IK32(1),JK32,IK8(1),JK8
      INTEGER          IDFIC,IDTS,LTYPB,LONIND,NBVAL,IADMI,VALI(2)
      INTEGER          IDOS,KITAB,IDGR,IDT1,IDT2,IDG,JULIST,IUNIFI
      INTEGER          HDFOPF,HDFNBO,HDFOPD,HDFTSD,HDFRSV,HDFRAT
      INTEGER          HDFNOM,HDFTYP,HDFCLD,HDFOPG,HDFCLG,HDFRSI,HDFCLF
      INTEGER          IRET1,IRET2,IRET3,IDCO,IVERS,IUTIL,INIVO,LMARQ
      EQUIVALENCE     (IK32,K32),(IK8,K8)
      INTEGER          IGENR(1),ITYPE(1),IDOCU(1),IORIG(1),IRNOM(1)
      INTEGER          I,K,KTEMP1,KTEMP2,LON,LON2,IC,LCARAO,IADRS,LONOK
      INTEGER          LONGJ,JJPREM,ITAB,JTAB,ICONV,NBLMA2
      EQUIVALENCE     (IGENR,GENR),(ITYPE,TYPE),
     &                (IDOCU,DOCU),(IORIG,ORIG),(IRNOM,RNOM)
C     ------------------------------------------------------------------
      INTEGER          ILOREP , IDENO , ILNOM , ILMAX , ILUTI , IDEHC
      PARAMETER      ( ILOREP=1,IDENO=2,ILNOM=3,ILMAX=4,ILUTI=5,IDEHC=6)
C ----------------------------------------------------------------------
      INTEGER          LIDBAS      , LIDEFF, IDYN32, IDYN8 , IBID
      PARAMETER      ( LIDBAS = 20 , LIDEFF = 15 )
      CHARACTER*8      CIDBAS(LIDBAS)
      CHARACTER*24     VALK(3)
      CHARACTER*32     NOMSYS,D32
      INTEGER          KAT(LIDBAS),LSO(LIDBAS),KDY(LIDBAS),LGBL,IADYN
      REAL*8           VALR
      LOGICAL          LEXP
      DATA CIDBAS  / '$$CARA  ' , '$$IADD  ' , '$$GENR  ' , '$$TYPE  ' ,
     &               '$$DOCU  ' , '$$ORIG  ' , '$$RNOM  ' , '$$LTYP  ' ,
     &               '$$LONG  ' , '$$LONO  ' , '$$DATE  ' , '$$LUTI  ' ,
     &               '$$HCOD  ' , '$$USADI ' , '$$ACCE  ' , '$$MARQ  ' ,
     &               '$$XXXX  ' , '$$TLEC  ' , '$$TECR  ' , '$$IADM  ' /
C     ------------------------------------------------------------------
      DATA NOMSYS  / '________XXXXXXXX________$$CARA' /
      DATA             NREP / 'T_HCOD' , 'T_NOM' /
      DATA             D32 /'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'/
C DEB ------------------------------------------------------------------
      IPGCA = IPGC
      IPGC  = -2
C
      ICONV = 0
      KCLAS = CLAS
      KNOM  = NOMF
      KNOMF = NOMF
      CALL LXMINS(KNOMF)
C
      CALL ASSERT( KNOMF .NE. '        ' .AND. LEN(NOMF) .LE. 8 ) 
      CALL ASSERT( KCLAS .NE. ' ' ) 
      CALL ASSERT( INDEX (CLASSE,KCLAS) .EQ. 0 )
C
      IC = INDEX (CLASSE , ' ')
      CALL ASSERT( IC .NE. 0 )
      NOMFIC(IC) = KNOMF
      NOMBAS(IC) = KNOM
      KSTINI(IC) = 'POURSUIT'
      KSTOUT(IC) = 'SAUVE   '
      CLASSE(IC:IC) = KCLAS
      NBCLA = INDEX( CLASSE , '$' ) - 1
      IF ( NBCLA .EQ. -1 ) NBCLA = N
      ICLAS  = IC
      NOMUTI = ' '
      NOMOS  = D32
      NOMCO  = D32
      NOMOC  = D32
C
C ----- OPEN FICHIER
C ----- LECTURE DE L'OBJET ________GLOBALE ________$$CARA
C ----- PERMET DE DIMENSIONNER LES OBJETS SYSTEMES ASSOCIES A LA BASE
C
      NHDF  = FICHDF
      IDFIC = HDFOPF (NHDF)
      IF ( IDFIC .LT. 0 ) THEN
        CALL U2MESK('F','JEVEUX_54',1,NHDF)
      ENDIF
      NGRP ='/'
      IDG  = HDFOPG (IDFIC,NGRP)
      IRET1 = HDFRAT (IDG,NOMAT2,5,KATTR)
      IRET1 = HDFCLG (IDG)
      JULIST = IUNIFI ('MESSAGE')
      WRITE(JULIST,*) '<I> RELECTURE DE LA BASE GLOBALE AU FORMAT'//
     &                ' HDF SUR LE FICHIER :' 
      WRITE(JULIST,*) '    ',NHDF
      WRITE(JULIST,*) '    '
      WRITE(JULIST,*) '    CONSTRUITE AVEC LA VERSION ',KATTR(1)
      WRITE(JULIST,*) '    SUR LA PLATE-FORME ',KATTR(2)
      WRITE(JULIST,*) '    SOUS SYSTEME ',KATTR(3)
      WRITE(JULIST,*) '    '

      NBOBJ = HDFNBO(IDFIC,NGRP)
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(1)
      IDTS = HDFOPD(IDFIC,NGRP,CRNOM)
      LCARAO = NCAR * LOIS
      CALL JJALLS (LCARAO,IC,'V','I',LOIS ,Z,CARA, IADRS,KAT(1),IADYN)
      JCARA(IC) = IADRS
      CALL JJHRSV (IDTS,NCAR,KAT(1))

      CVERSB = '  .  .  '
      CALL CODENT(CARA(JCARA(IC) + 8 ),'D ',CVERSB(1:2) )
      CALL CODENT(CARA(JCARA(IC) + 9 ),'D0',CVERSB(4:5) )
      CALL CODENT(CARA(JCARA(IC) + 10),'D0',CVERSB(7:8) )
      CALL VERSIO ( IVERS , IUTIL , INIVO , K16BID , LEXP )
      CVERSU = '  .  .  '
      CALL CODENT(IVERS,'D ',CVERSU(1:2) )
      CALL CODENT(IUTIL,'D0',CVERSU(4:5) )
      CALL CODENT(INIVO,'D0',CVERSU(7:8) )
      NREMAX(IC) = CARA(JCARA(IC)     )
      NREUTI(IC) = CARA(JCARA(IC) + 1 )
      NRHCOD(IC) = CARA(JCARA(IC) + 2 )
      NBLMAX(IC) = CARA(JCARA(IC) + 3 )
      NBLUTI(IC) = CARA(JCARA(IC) + 4 )
      LONGBL(IC) = CARA(JCARA(IC) + 5 )
      IF ( CVERSU .NE. CVERSB ) THEN
         VALK(1) = NOMBAS(IC)
         VALK(2) = CVERSB
         VALK(3) = CVERSU
         CALL U2MESK('A','JEVEUX_08', 3 ,VALK)
      ENDIF
C
C --- LORSQUE LE NOMBRE D'ENREGISTREMENTS MAXIMUM EST MODIFIE
C
      NBLMA2 = MFIC/(LONGBL(IC)*LOIS)
      IF ( NBLMAX(IC) .GE. NBLMA2 ) THEN
        NBLMA2 = NBLMAX(IC)
      ELSE
        VALI(1) = NBLMAX(IC)
        VALI(2) = NBLMA2
        VALK(1) = NOMBAS(IC)
        CALL U2MESG('I','JEVEUX_36', 1 , VALK, 2 , VALI, 0 , VALR)
      ENDIF
C
      NBLMAX(IC)= NBLMA2
C
      KAT(17) = 0      
      KDY(17) = 0      
C
      LMARQ = 2 * NREMAX(IC) * LOIS
      CALL JJALLS(LMARQ,IC,'V','I',LOIS,Z,IMARQ,IADRS,KMARQ(IC),KDY(16))
      KAT(16) = KMARQ(IC)
      JMARQ(IC) = IADRS - 1
      CALL JJECRS (KAT(16),IC,16,0,'E',IMARQ(JMARQ(IC)+2*16-1))
C
      IDTS = HDFOPD(IDFIC,NGRP,CRNOM)
      LCARAO = NCAR * LOIS
      CALL JJALLS (LCARAO,IC,'V','I',LOIS ,Z,CARA,IADRS,KAT(1),KDY(1))
      JCARA(IC) = IADRS
      CALL JJECRS (KAT(1),IC,1,0,'E',IMARQ(JMARQ(IC)+2*1-1))
      CALL JJHRSV (IDTS,NCAR,KAT(1))
C
      NBENRG(IC) = MIN ( LFIC/(LONGBL(IC)*LOIS) , NBLMAX(IC) )
C
C ----OPEN DU FICHIER BINAIRE ASSOCIE A LA BASE JEVEUX
C
      CALL JXOUVR (IC, 1)
      IEXT(IC) = 1
C
C ----ALLOCATION DES TAMPONS DE LECTURE/ECRITURE, DES ADRESSES MEMOIRE
C     ET DES MARQUES
C
      LGBL=1024*LONGBL(IC)*LOIS
      CALL JJALLS(LGBL,IC,'V','I',LOIS,Z,ITLEC,IADRS,KITLEC(IC),KDY(18))
      KAT(18) = KITLEC(IC)
      KITLEC(IC) = ( KITLEC(IC) - 1 ) * LOIS
      CALL JJECRS (KAT(18),IC,18,0,'E',IMARQ(JMARQ(IC)+2*18-1))
      CALL JJALLS (LGBL,IC,'V','I',LOIS,Z,ITECR,IADRS ,KITECR(IC),
     &             KDY(19))
      KAT(19) = KITECR(IC)
      KITECR(IC) = ( KITECR(IC) - 1 ) * LOIS
      LON = NREMAX(IC) * LOIS
      CALL JJECRS (KAT(19),IC,19,0,'E',IMARQ(JMARQ(IC)+2*19-1))
      CALL JJALLS (2*LON,IC,'V','I',LOIS,Z,IADM,IADRS,KIADM(IC),KDY(20))
      KAT(20) = KIADM(IC)
      JIADM(IC) = IADRS - 1
      CALL JJECRS (KAT(20),IC,20,0,'E',IMARQ(JMARQ(IC)+2*20-1))
C
C     CES DEUX OBJETS SYSTEME NE DOIVENT PAS ETRE RELUS SUR FICHIER HDF
C
      CALL JJALLS (2*LON, IC,'V','I',LOIS,Z, IADD,IADRS,KAT(2),KDY(2))
      JIADD(IC) = IADRS - 1
      CALL JJECRS (KAT(2),IC,2,0,'E',IMARQ(JMARQ(IC)+2*2-1))
C
      LON2 = NBLMA2 * LOIS
      CALL JJALLS (LON2,IC,'V','I',LOIS,Z,IACCE,IADRS,KAT(15),KDY(15))
      JIACCE(IC) = IADRS - 1
      CALL JJECRS (KAT(15),IC,15,0,'E',IMARQ(JMARQ(IC)+2*15-1))
C
      LON = NREMAX(IC) * LEN(GENR(1))
      CALL JJALLS (LON,IC,'V','K',LEN(GENR(1)),Z,IGENR,IADRS,KAT(3),
     &             KDY(3))
      JGENR(IC) = IADRS - 1
      CALL JJECRS (KAT(3),IC,3,0,'E',IMARQ(JMARQ(IC)+2*3-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(3)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(3))
C
      LON = NREMAX(IC) * LEN(TYPE(1))
      CALL JJALLS (LON,IC,'V','K',LEN(TYPE(1)),Z,ITYPE,IADRS,KAT(4),
     &             KDY(4))
      JTYPE(IC) = IADRS - 1
      CALL JJECRS (KAT(4),IC,4,0,'E',IMARQ(JMARQ(IC)+2*4-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(4)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(4))
C
      LON = NREMAX(IC) * LEN(DOCU(1))
      CALL JJALLS (LON,IC,'V','K',LEN(DOCU(1)),Z,IDOCU,IADRS,KAT(5),
     &             KDY(5))
      JDOCU(IC) = IADRS - 1
      CALL JJECRS (KAT(5),IC,5,0,'E',IMARQ(JMARQ(IC)+2*5-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(5)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(5))
C
      LON = NREMAX(IC) * LEN(ORIG(1))
      CALL JJALLS (LON,IC,'V','K',LEN(ORIG(1)),Z,IORIG,IADRS,KAT(6),
     &             KDY(6))
      JORIG(IC) = IADRS - 1
      CALL JJECRS (KAT(6),IC,6,0,'E',IMARQ(JMARQ(IC)+2*6-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(6)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(6))
C
      LON = NREMAX(IC) * LEN(RNOM(1))
      CALL JJALLS (LON,IC,'V','K',LEN(RNOM(1)),Z,IRNOM,IADRS,KAT(7),
     &             KDY(7))
      JRNOM(IC) = IADRS - 1
      CALL JJECRS (KAT(7),IC,7,0,'E',IMARQ(JMARQ(IC)+2*7-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(7)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(7))
C
      LON = NREMAX(IC) * LOIS
      CALL JJALLS (LON, IC,'V','I',LOIS,Z,LTYP, IADRS,KAT(8),KDY(8))
      JLTYP(IC) = IADRS - 1
      CALL JJECRS (KAT(8),IC,8,0,'E',IMARQ(JMARQ(IC)+2*8-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(8)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(8))
C
      CALL JJALLS (LON,IC,'V','I',LOIS,Z,LONG,IADRS,KAT(9),KDY(9))
      JLONG(IC) = IADRS - 1
      CALL JJECRS (KAT(9),IC,9,0,'E',IMARQ(JMARQ(IC)+2*9-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(9)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(9))
C
      CALL JJALLS (LON, IC,'V','I',LOIS,Z,LONO,IADRS,KAT(10),KDY(10))
      JLONO(IC) = IADRS - 1
      CALL JJECRS (KAT(10),IC,10,0,'E',IMARQ(JMARQ(IC)+2*10-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(10)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(10))
C
      CALL JJALLS (LON, IC,'V','I',LOIS,Z,DATE,IADRS,KAT(11),KDY(11))
      JDATE(IC) = IADRS - 1
      CALL JJECRS (KAT(11),IC,11,0,'E',IMARQ(JMARQ(IC)+2*11-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(11)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(11))
C
      CALL JJALLS (LON,IC,'V','I',LOIS,Z,LUTI,IADRS,KAT(12),KDY(12))
      JLUTI(IC) = IADRS - 1
      CALL JJECRS (KAT(12),IC,12,0,'E',IMARQ(JMARQ(IC)+2*12-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(12)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(12))
C
      LON = NRHCOD(IC) * LOIS
      CALL JJALLS (LON,IC,'V','I',LOIS,Z,HCOD,IADRS,KAT(13),KDY(13))
      JHCOD(IC) = IADRS - 1
      CALL JJECRS (KAT(13),IC,13,0,'E',IMARQ(JMARQ(IC)+2*13-1))
      CRNOM = NOMSYS(1:8)//KNOM//NOMSYS(17:24)//CIDBAS(13)
      IDTS  = HDFOPD(IDFIC,NGRP,CRNOM)
      IRET1 = HDFTSD(IDTS,TYPEI,LTYPI,LONOI)
      CALL JJHRSV (IDTS,LONOI,KAT(13))
C
      LON = 3*NBLMA2 * LOIS
      CALL JJALLS (LON,IC,'V','I',LOIS,Z,IUSADI,IADRS,KAT(14),KDY(14))
      JUSADI(IC) = IADRS - 1
      CALL JJECRS (KAT(14),IC,14,0,'E',IMARQ(JMARQ(IC)+2*14-1))
C
C     LA BASE ETANT RECREE, IL FAUT RETABLIR L'ETAT D'USAGE DES
C     ENREGISTREMENTS A -1
C
      DO 14 I = 1,NBLMA2
        IUSADI( IADRS + (3*I-2) - 1 ) = -1
        IUSADI( IADRS + (3*I-1) - 1 ) = -1
        IUSADI( IADRS + (3*I  ) - 1 ) =  0
 14   CONTINUE
      DO 20 I = 1 , LIDBAS
         IADM(JIADM(IC) + 2*I-1 ) = KAT(I)
         IADM(JIADM(IC) + 2*I   ) = KDY(I)
 20   CONTINUE
C
C     IL FAUT AJUSTER LA LONGUEUR DU TYPE ENTIER AVANT ECRITURE
C
 
      DO 49 K=1,LIDEFF
        IF(TYPE(JTYPE(IC)+K).EQ.'I') THEN
          LTYP(JLTYP(IC)+K) = LOIS
        ENDIF
 49   CONTINUE

      IADD (JIADD(IC)+1) = 0
      IADD (JIADD(IC)+2) = 0
      CALL JXECRO (IC,KAT(1),IADD(JIADD(IC)+1),NCAR*LOIS,0,1)
      DO 21 I=2,LIDEFF
        IADD (JIADD(IC)+2*I-1) = 0
        IADD (JIADD(IC)+2*I  ) = 0
        LSO(I) = LONO(JLONO(IC)+I) * LTYP(JLTYP(IC)+I)
        CALL JXECRO (IC,KAT(I),IADD(JIADD(IC)+2*I-1),LSO(I),0,I)
 21   CONTINUE
      CARA(JCARA(IC)+6) = IADD(JIADD(IC) + 2*2-1 )
      CARA(JCARA(IC)+7) = IADD(JIADD(IC) + 2*2   )
C
      IPGC = IPGCA
      LON = NBOBJ*32
      CALL JJALLS (LON,IC,'V','K',32,'INIT',IK32,JK32,KTEMP1,IDYN32)
      ISZON(JISZON+KTEMP1-1) = ISTAT(2)
      ISZON(JISZON+ISZON(JISZON+KTEMP1-4)-4) = ISTAT(4)
      IRET1 = HDFNOM(IDFIC,NGRP,K32(JK32))
      LON = NBOBJ*8
      CALL JJALLS (LON,IC,'V','K',8,'INIT',IK8,JK8,KTEMP2,IDYN8)
      ISZON(JISZON+KTEMP2-1) = ISTAT(2)
      ISZON(JISZON+ISZON(JISZON+KTEMP2-4)-4) = ISTAT(4)
      IRET2 = HDFTYP(IDFIC,NGRP,NBOBJ,K8(JK8))
C
C     ON AJUSTE LA LONGUEUR DU TYPE POUR LES INTEGER *8 OU *4
C     SUIVANT LA PLATE-FORME, ET LA LONGUEUR DES OBJETS DE GENRE
C     REPERTOIRE
C
      DO 51 K=LIDEFF+1,NREMAX(IC)
        IF(TYPE(JTYPE(IC)+K).EQ.'I') THEN
          LTYP(JLTYP(IC)+K) = LOIS
        ENDIF
        IF(GENR(JGENR(IC)+K).EQ.'N') THEN
          LTYPI = LTYP(JLTYP(IC)+K)
          LONGJ = LONG(JLONG(IC)+K)
          LONOK = (IDEHC + JJPREM(LONGJ))*LOIS + (LONGJ+1)*LTYPI
          IF ( MOD(LONOK,LTYPI) .GT. 0 ) THEN
            LONOK = (LONOK/LTYPI + 1 )
          ELSE
            LONOK = LONOK/LTYPI
          ENDIF
          LONO(JLONO(IC)+K) = LONOK
        ENDIF
 51   CONTINUE
C
C     ON TRAITE EN PREMIER LES COLLECTIONS AFIN DE POUVOIR LES LIBERER
C
      CALL JEMARQ()
      DO 101 K=1,NBOBJ
       IF (K8(JK8+K-1) .EQ. 'dataset') THEN
          IDTS=HDFOPD(IDFIC,NGRP,K32(JK32+K-1))
          IRET1=HDFRAT(IDTS,NOMATR,5,KATTR)
          IF ( KATTR(1) .EQ. 'COLLECTION' ) THEN
            READ(KATTR(2),'(16X,I8)') IDCO
            CALL JJLCHD (IDCO,IC,IDFIC,IDTS,NGRP)
          ENDIF
          IRET3=HDFCLD(IDTS)
        ENDIF
 101  CONTINUE
C
C     ON TRAITE MAINTENANT LES OBJETS SIMPLES (OBJETS SYSTEMES EXCLUS)
C
      DO 201 K=1,NBOBJ
        IF (K8(JK8+K-1) .EQ. 'dataset') THEN
          IDTS=HDFOPD(IDFIC,NGRP,K32(JK32+K-1))
          IRET1=HDFTSD(IDTS,TYPEB,LTYPB,NBVAL)
          IRET1=HDFRAT(IDTS,NOMATR,5,KATTR)
          IF ( KATTR(1) .EQ. 'OBJET SIMPLE' ) THEN
            READ(KATTR(2),'(16X,I8)') IDOS
            GENRI = GENR (JGENR(IC)+IDOS)
            TYPEI = TYPE (JTYPE(IC)+IDOS)
            LTYPI = LTYP (JLTYP(IC)+IDOS)
            LON   = LONO (JLONO(IC)+IDOS)
            LONOI = LON  * LTYPI
            IADD (JIADD(IC)+2*IDOS-1) = 0
            IADD (JIADD(IC)+2*IDOS  ) = 0
            CALL JJLIHD (IDTS,LON,LONOI,GENRI,TYPEI,LTYPI,IC,IDOS,
     &                   0,IMARQ(JMARQ(IC)+2*IDOS-1),IADMI,IADYN)
            IADM(JIADM(IC)+2*IDOS-1) = IADMI
            IADM(JIADM(IC)+2*IDOS  ) = IADYN
            ICLAS  = IC
            ICLAOS = IC
            IDATOS = IDOS
            NOMOS  = RNOM(JRNOM(IC)+IDOS)
            NOMCO  = D32
            NOMOC  = D32
            CALL JJLIDE ('JELIBE',RNOM(JRNOM(IC)+IDOS),1)
          ENDIF
          IRET1=HDFCLD(IDTS)
        ELSE IF (K8(JK8+K-1) .EQ. 'group') THEN
          NOMO = K32(JK32+K-1)
          IDGR = HDFOPG(IDFIC,NOMO)
          IRET1= HDFRAT(IDGR,NOMATR,5,KATTRG)
          IF ( KATTRG(1) .EQ. 'OBJET SIMPLE' ) THEN
            READ(KATTRG(2),'(16X,I8)') IDOS
            GENRI = GENR (JGENR(IC)+IDOS)
            TYPEI = TYPE (JTYPE(IC)+IDOS)
            LTYPI = LTYP (JLTYP(IC)+IDOS)
            LON   = LONO (JLONO(IC)+IDOS)
            LONOI = LON  * LTYPI
            IADD (JIADD(IC)+2*IDOS-1) = 0
            IADD (JIADD(IC)+2*IDOS  ) = 0
C
C           ON TRAITE UN GROUPE CONTENANT LES ELEMENTS T_HCOD ET T_NOM
C           CORRESPONDANT A UN REPERTOIRE DE NOMS
C
            IDT1=HDFOPD(IDFIC,NOMO,NREP(1))
            IDT2=HDFOPD(IDFIC,NOMO,NREP(2))
            CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',ITAB,
     &                  JTAB,IADMI,IADYN)
            CALL JJECRS (IADMI,IC,IDOS,0,'E',IMARQ(JMARQ(IC)+2*IDOS-1))
            IRET1=HDFTSD(IDT1,TYPEB,LTYPB,NBVAL)
            CALL JJHRSV (IDT1,NBVAL,IADMI)
C
C           ON AJUSTE LA POSITION DES NOMS EN FONCTION DU TYPE D'ENTIER
C
            ISZON(JISZON+IADMI-1+IDENO)=
     &            (IDEHC+ISZON(JISZON+IADMI-1+ILOREP))*LOIS
            IRET1=HDFTSD(IDT2,TYPEB,LTYPB,NBVAL)
            KITAB=JK1ZON+(IADMI-1)*LOIS+ISZON(JISZON+IADMI-1+IDENO)+1
            IRET1=HDFRSV(IDT2,NBVAL,K1ZON(KITAB),ICONV)
            IRET1 = HDFCLD(IDT2)
            IADM(JIADM(IC)+2*IDOS-1) = IADMI
            IADM(JIADM(IC)+2*IDOS  ) = IADYN
            ICLAS  = IC
            ICLAOS = IC
            IDATOS = IDOS
            NOMOS  = RNOM(JRNOM(IC)+IDOS)
            NOMCO  = D32
            NOMOC  = D32
            CALL JJLIDE ('JELIBE',RNOM(JRNOM(IC)+IDOS),1)
          ENDIF
          IRET1=HDFCLG(IDGR)
        ENDIF
 201  CONTINUE
      IRET1 = HDFCLF (IDFIC)
      IF (IRET1 .NE. 0 ) THEN
        CALL U2MESK('F','JEVEUX_55',1,NHDF)
      ELSE
        CALL U2MESK('I','JEVEUX_56',1,NHDF)
      ENDIF
      IF ( IDYN32 .NE. 0 ) THEN
        CALL HPDEALLC ( IDYN32 , NBFREE , IBID )
      ELSE IF (KTEMP1 .NE. 0) THEN
        CALL JJLIBP (KTEMP1)
      ENDIF     
      IF ( IDYN8 .NE. 0 ) THEN
        CALL HPDEALLC ( IDYN8 , NBFREE , IBID )
      ELSE IF (KTEMP2 .NE. 0) THEN
        CALL JJLIBP (KTEMP2)
      ENDIF     
      CALL JEDEMA()
C FIN ------------------------------------------------------------------
      END
