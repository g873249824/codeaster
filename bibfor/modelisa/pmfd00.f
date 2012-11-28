      SUBROUTINE PMFD00()
C MODIF MODELISA  DATE 27/11/2012   AUTEUR LADIER A.LADIER 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C TOLE CRP_20
C ----------------------------------------------------------------------
C     COMMANDE AFFE_CARA_ELEM
C --- TRAITEMENT DES MOTS CLES AFFE_SECT ET AFFE_FIBRE
C     + TRAITEMENT DES MOTS CLES :
C           COQUE  /COQUE_NCOU
C           GRILLE /COQUE_NCOU
C           POUTRE /TUYAU_NCOU
C           POUTRE /TUYAU_NSEC
C
C       CONSTRUCTION DU CHAM_ELEM (CONSTANT PAR MAILLE) CONTENANT
C       LES INFORMATIONS DE "DECOUPAGE" DES ELEMENTS DE STRUCTURE :
C        NBRE DE COUCHES (COQUE), DE SECTEURS (TUYAU), "FIBRES" (PMF),..

C ----------------------------------------------------------------------
      IMPLICIT NONE
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
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER NBVAL,NCARFI
      PARAMETER (NCARFI=3)
      REAL*8 ZERO
      PARAMETER (ZERO=0.D+0)
      CHARACTER*8 CARELE,NOMO,NOMA,K8B,NOMAS,MODELE,KNS
      CHARACTER*8 NOMMAI,NMLIS,SDGF
      CHARACTER*16 CONCEP,CMD
      CHARACTER*16 LTYMCL(3),PHENO
      CHARACTER*19 CESDEC,LIGRMO,CELBID
      CHARACTER*24 MODNOM
      CHARACTER*24 MLGNMA,VPOCFG
      CHARACTER*24 MLGCNX,MLGTMS,MLGCOO
      CHARACTER*24 VPOINT,VNBFIB,VCARFI,VNBFIG,VCAFIG,RNOMGF
      INTEGER NBOCC0,NBOCC1,NBOCC2,NBOCC3,NCR
      INTEGER NGM,NMA,JMPS
      INTEGER INZSEC,IDASEC
      INTEGER IRET,IBID,INZFIB,IDAFIB,IMASEC
      INTEGER NBVM,NMAILP,NBV,NMAILS,NUMAIL,NBFIB
      INTEGER I,J,IOC,IPOS
      INTEGER JDNM,JNF,JMP
      INTEGER JNBFG,NBGF,JNGF,JCARFI,JPOINT,IPOINT,NGF,IG,NG,IG1
C     NB DE GROUPES MAX PAR ELEMENT
C     CE NOMBRE DOIT ETRE EN ACCORD AVEC LES CATALOGUES
C     GRANDEUR_SIMPLE__.CATA ET GENER_MEPMF1.CATA !
      INTEGER NGMXEL
      CHARACTER*2 KNGMX
      PARAMETER (NGMXEL=10,KNGMX='10')
      INTEGER NUGRP(NGMXEL)
      REAL*8 CASECT(6),CARG(6)
      INTEGER NUMMAI,IZONE,NBMAZA,IDESC,ILIMA,IVALE,NBCOMA,IOCP,NBFIG
      REAL*8 AIRPOU,MOINOY,MOINOZ,ERRE,EPSA,EPSI,VALR(4)
      CHARACTER*1 K1BID

      INTEGER IFM,NIV

      DATA LTYMCL/'MAILLE','GROUP_MA','TOUT'/
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)


      CALL GETVID(' ','MODELE',1,1,1,NOMO,NBVM)

      CALL GETRES(CARELE,CONCEP,CMD)

      VNBFIB = CARELE//'.PMFNF'

      CALL GETFAC('MULTIFIBRE',NBOCC0)
      IF(NBOCC0.NE.0)THEN
        CALL GETVID(' ','GEOM_FIBRE',1,1,1,SDGF,IBID)
        VNBFIG = SDGF//'.NB_FIBRE_GROUPE'
        VPOINT = SDGF//'.POINTEUR'
        VCARFI = SDGF//'.CARFI'
        RNOMGF = SDGF//'.NOMS_GROUPES'
C ----- NOMBRE DE GROUPES TOTAL = DIMENSION DE VNBFIG
        CALL JELIRA(VNBFIG,'LONMAX',NBGF,K1BID)
        CALL JEVEUO(VNBFIG,'L',JNBFG)
        CALL JEVEUO(VCARFI,'L',JCARFI)
        CALL JEVEUO(VPOINT,'L',JPOINT)
C ----- NOMBRE TOTAL DE FIBRES SUR TOUS LES GROUPES
        NBFIB=0
        DO 10 IG=1,NBGF
          NBFIB=NBFIB+ZI(JNBFG-1+IG)
  10    CONTINUE
      ENDIF

      MODNOM = NOMO//'.MODELE    .LGRF'
      CALL JEVEUO(MODNOM,'L',JDNM)
      NOMA = ZK8(JDNM)
      MLGNMA = NOMA//'.NOMMAI'
      CALL JELIRA(MLGNMA,'NOMMAX',NMAILP,K1BID)

C     S'IL N'Y A PAS D'ELEMENTS A SOUS-POINTS, ON SAUTE TOUT:
C     -------------------------------------------------------
      CALL GETFAC('COQUE',NBOCC1)
      CALL GETFAC('GRILLE',NBOCC2)
      CALL GETFAC('POUTRE',NBOCC3)
      IF ((NBOCC0+NBOCC1+NBOCC2+NBOCC3).EQ.0) GO TO 9999

C     -- 2EME CHANCE :
      CALL GETVID(' ','MODELE',0,1,1,MODELE,IBID)
      LIGRMO = MODELE//'.MODELE'
      CELBID='&&PMFD00.CELBID'
      CALL ALCHML(LIGRMO,'TOU_INI_ELEM','PNBSP_I','V',CELBID,IRET,' ')
      CALL DETRSD('CHAM_ELEM',CELBID)
      IF (IRET.EQ.1) GO TO 9999


C     S'IL N'Y A PAS D'ELEMENTS PMF, ON SAUTE :
C     ----------------------------------------
      IF (NBOCC0.EQ.0) GO TO 140


C     2. CONSTRUCTION DES OBJETS .PMFPT .PMFNF ET .PMFCF
C     ----------------------------------------------------------

      CALL WKVECT('&&PMFD00.NOMS_GROUPES','V V K8',NBGF,JNGF)
      CALL WKVECT(VNBFIB,'V V I',NMAILP*(2+NGMXEL),JNF)

      DO 100 IOC=1,NBOCC0
        DO 101 IG=1,NGMXEL
          NUGRP(IG)=0
 101    CONTINUE
        CALL RELIEM(NOMO,NOMA,'NU_MAILLE','MULTIFIBRE',IOC,2,LTYMCL,
     &              LTYMCL,'&&PMFD00.MAILLSEP',NMAILP)
        CALL JEVEUO('&&PMFD00.MAILLSEP','L',JMP)
C --- NOMBRE DE GROUPES A AFFECTER
        CALL GETVTX('MULTIFIBRE','GROUP_FIBRE',IOC,1,0,K8B,NGF)
        NGF=-NGF
        IF(NGF.GT.NGMXEL)THEN
          CALL U2MESK('F','MODELISA8_7',1,KNGMX)
        ENDIF
C --- NOMS DES GROUPES A AFFECTER
        CALL GETVTX('MULTIFIBRE','GROUP_FIBRE',IOC,1,NGF,ZK8(JNGF),IBID)
C --- ON COMPTE LE NOMBRE DE FIBRES DE L'ENSEMBLE DES GROUPES DE CETTE
C     OCCURENCE, ET ON NOTE LES NUMEROS DE GROUPES
        NBFIB=0
        DO 50 IG=1,NGF
          CALL JENONU(JEXNOM(RNOMGF,ZK8(JNGF+IG-1)),NG)
          NBFIB=NBFIB+ZI(JNBFG+NG-1)
          NUGRP(IG)=NG
 50     CONTINUE

C
C --- ON AFFECTE LES ELEMENTS POUTRES CONCERNES PAR CETTE OCCURENCE
C --- POUR CHAQUE EL : NB DE FIBRE, NB DE GROUPES DE FIBRES
C     ET NUMERO DES GROUPES
        DO 80 J = 1,NMAILP
          NUMAIL = ZI(JMP+J-1)
          IPOS=JNF+(NUMAIL-1)*(2+NGMXEL)
          ZI(IPOS) = NBFIB
          ZI(IPOS+1) = NGF
          DO 82 IG=1,NGMXEL
            ZI(IPOS+1+IG) = NUGRP(IG)
   82     CONTINUE
   80   CONTINUE

C --- VERIFICATIONS PREC_AIRE, PREC_INERTIE POUR L'OCCURENCE
C     DE MULTIFIBRE
C   --- ON INTEGRE POUR TOUS LES GROUPES DE CETTE OCCURENCE
        DO 89 I=1,6
          CASECT(I)=ZERO
 89     CONTINUE
        DO 90 IG=1,NGF
          IG1=NUGRP(IG)
          NBFIG = ZI(JNBFG-1+IG1)
          IPOINT = ZI(JPOINT-1+IG1)
          CALL PMFITG(NBFIG,NCARFI,ZR(JCARFI+IPOINT-1),CARG)
            DO 91 I=1,6
              CASECT(I)=CASECT(I)+CARG(I)
 91       CONTINUE
 90     CONTINUE

C  ON RECUPERE LE NUMERO DE LA PREMIERE MAILLE CORRESPONDANT AU IOC
        CALL RELIEM(NOMO,NOMA,'NU_MAILLE','MULTIFIBRE',IOC,2,LTYMCL,
     &              LTYMCL,'&&PMFD00.MAILLSEP',NMAILP)
        CALL JEVEUO('&&PMFD00.MAILLSEP','L',JMP)
        NUMMAI=ZI(JMP)
C  ON RECHERCHE LA ZONE AFFECTEE CORRESPONDANT AU NUMERO DE LA
C   MAILLE NUMMAI
        CALL JEVEUO(CARELE//'.CARGENPO  .DESC','L',IDESC)
        DO 71 I=ZI(IDESC+2),1,-1
            IZONE=ZI(IDESC+2+2*I)
            IF(ZI(IDESC+1+2*I).EQ.3 .OR. ZI(IDESC+1+2*I).EQ.-3)THEN
               CALL JEVEUO(JEXNUM(CARELE//'.CARGENPO  .LIMA',IZONE),
     &                     'L',ILIMA)
               CALL JELIRA(JEXNUM(CARELE//'.CARGENPO  .LIMA',IZONE),
     &                     'LONMAX',NBMAZA,K1BID)
               DO 72 J=1,NBMAZA
                  IF(NUMMAI.EQ.ZI(ILIMA+J-1))THEN
                       GOTO 73
                  ENDIF
 72           CONTINUE
            ENDIF
 71     CONTINUE
        CALL ASSERT(.FALSE.)
 73     CONTINUE
C  ON RECUPERE LES COMPOSANTES : A1 , IY1 , IZ1 DE CETTE ZONE
        CALL JEVEUO(CARELE//'.CARGENPO  .VALE','L',IVALE)
        NBCOMA=31
        AIRPOU=ZR(IVALE+(IZONE-1)*NBCOMA)
        MOINOY=ZR(IVALE+(IZONE-1)*NBCOMA+1)
        MOINOZ=ZR(IVALE+(IZONE-1)*NBCOMA+2)
        IF (AIRPOU.EQ.ZERO) CALL U2MESS('F','MODELISA8_1')
        IF (MOINOY.EQ.ZERO) CALL U2MESS('F','MODELISA8_2')
        IF (MOINOZ.EQ.ZERO) CALL U2MESS('F','MODELISA8_3')
C ON DETERMINE L'OCCURENCE DE "POUTRE" QUI CORRESPOND A CETTE ZONE
C (PAS FORCEMENT IOC SI PAS ENTREE DANS LE MEME ORDRE)
C POUR L'INSTANT JE PRENDS IOCP=1 CAR C'EST GALERE A TROUVER...
      IOCP=1
C  COMPARAISON DE LA SOMME DES AIRES DES FIBRES A L'AIRE DE LA
C   SECTION DE LA POUTRE
        CALL GETVR8('POUTRE','PREC_AIRE',IOCP,1,1,EPSA,IRET)
        ERRE=ABS(AIRPOU-CASECT(1))/AIRPOU
        IF (ERRE.GT.EPSA)THEN
          VALR(1)=DBLE(IOC)
          VALR(2)=AIRPOU
          VALR(3)=CASECT(1)
          VALR(4)=ERRE
          CALL U2MESR('F','MODELISA8_4',4,VALR)
        ENDIF

C       COMPARAISON DES MOMENTS D'INERTIES : IY, IZ
        CALL GETVR8('POUTRE','PREC_INERTIE',IOC,1,1,EPSI,IRET)
        ERRE=ABS(MOINOY-CASECT(5))/MOINOY
        IF (ERRE.GT.EPSI)THEN
          VALR(1)=DBLE(IOC)
          VALR(2)=MOINOY
          VALR(3)=CASECT(5)
          VALR(4)=ERRE
          CALL U2MESR('F','MODELISA8_5',4,VALR)
        ENDIF
        ERRE=ABS(MOINOZ-CASECT(4))/MOINOZ
        IF (ERRE.GT.EPSI)THEN
          VALR(1)=DBLE(IOC)
          VALR(2)=MOINOZ
          VALR(3)=CASECT(4)
          VALR(4)=ERRE
          CALL U2MESR('F','MODELISA8_6',4,VALR)
        ENDIF

 100  CONTINUE


140   CONTINUE

C     3. TRAITEMENT DES MOTS CLES COQUE_NCOU,TUYAU_NCOU, ...
C     ----------------------------------------------------------
      CESDEC = '&&PMFD00.CESDEC'
      CALL PMFD02(NOMA,CESDEC)


C     4. CONSTRUCTION DES CHAM_ELEM '.CANBSP' ET '.CAFIBR'
C     ----------------------------------------------------------
      CALL PMFD01(NOMA,CARELE,VNBFIB,VPOINT,VCARFI,VNBFIG,CESDEC,NGMXEL)

      CALL JEDETR(VNBFIB)
      CALL DETRSD('CHAM_ELEM_S',CESDEC)

      IF (NIV.EQ.2) THEN
        CALL IMPRSD('CHAMP',CARELE//'.CANBSP',6,'INFO=2')
        CALL IMPRSD('CHAMP',CARELE//'.CAFIBR',6,'INFO=2')
      END IF


 9999 CONTINUE

      CALL JEDEMA()
      END
