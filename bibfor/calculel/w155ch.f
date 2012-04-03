      SUBROUTINE W155CH(CHIN,CARELE,LIGREL,CHEXTR,MOTFAC,NUCOU,NICOU,
     &                  NANGL,NUFIB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/04/2012   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE PELLET J.PELLET
C ======================================================================
      IMPLICIT NONE
      CHARACTER*8 CARELE
      CHARACTER*3 NICOU
      CHARACTER*16 MOTFAC
      CHARACTER*19 CHIN,CHEXTR,LIGREL
      INTEGER NUCOU,NANGL,NUFIB

C ----------------------------------------------------------------------
C BUT : EXTRACTION DU CHAM_ELEM CORRESPONDANT A UN SOUS-POINT

C IN/JXIN  CHIN  : CHAM_ELEM (PLUSIEURS SOUS-POINTS) DANS LEQUEL
C                  ON DOIT EXTRAIRE CHEXTR
C IN/JXIN  CARELE  : CARA_ELEM ASSOCIE A CHIN
C IN/JXIN  LIGREL  : LIGREL SUR LEQUEL CREER CHEXTR
C IN/JXOUT CHEXTR  : CHAM_ELEM (1 SEUL SOUS-POINT) A CREER
C IN       MOTFAC  : EXTR_COQUE / EXTR_TUYAU / EXTR_PMF
C IN       NUCOU   : NUMERO DE LA COUCHE
C IN       NICOU   : NIVEAU DE LA COUCHE (MOY/INF/SUP)
C IN       NANGL   : VALEUR (ENTIER) DE L'ANGLE (EN DEGRES)
C IN       NUFIB   : NUMERO DE LA FIBRE
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*24 LINUMA,LINUTE
      CHARACTER*19 CES1,CES2,CES3,CES4,CES5
      CHARACTER*16 OPTION
      CHARACTER*8 KBID,LICMP(5),MA,NOMGD,TSCA,TYPCES
      CHARACTER*8 NOMPAR
      INTEGER IRET,NBMA,IBID,NBMAT,NUMA,JNBPT,KMA
      INTEGER NBPT,KSP1,KSP2,KPT,KCMP,NNCP,JLITE
      INTEGER IAD1,IAD2,IAD4,JLIMA,NCMP
      INTEGER JCE2L,JCE2D,JCE2V,JCE3K,JCE3L,JCE3D,JCE3V,JCE3C
      INTEGER JCE4L,JCE4D,JCE4V,JCE5L,JCE5D,JCE5V,NBSPMX
      REAL*8 C1,C2

C ----------------------------------------------------------------------
      CALL JEMARQ()
      CALL DISMOI('F','NOM_MAILLA',CHIN,'CHAM_ELEM',IBID,MA,IRET)
      CALL DISMOI('F','NOM_GD',CHIN,'CHAM_ELEM',IBID,NOMGD,IRET)
      CALL DISMOI('F','TYPE_SCA',CHIN,'CHAM_ELEM',IBID,TSCA,IRET)
      CALL DISMOI('F','MXNBSP',CHIN,'CHAM_ELEM',NBSPMX,KBID,IRET)
      IF (NBSPMX.LE.1) CALL U2MESS('F','CALCULEL2_15')
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMAT,KBID,IRET)

      CES1='&&W155CH.CES1'
      CES2='&&W155CH.CES2'
      CES3='&&W155CH.CES3'
      CES4='&&W155CH.CES4'
      CES5='&&W155CH.CES5'

C     1.  LISTE DES MAILLES A TRAITER :
C     ---------------------------------
      LINUMA='&&W155CH.LIMA'
      LINUTE='&&W155CH.LITE'
      CALL LIGLMA(LIGREL,NBMA,LINUMA,LINUTE)
      CALL ASSERT(NBMA.GT.0)
      CALL JEVEUO(LINUMA,'L',JLIMA)
      CALL JEVEUO(LINUTE,'L',JLITE)


C     2.  NOMBRE DE COUCHES, SECTEURS ET FIBRES  DES ELEMENTS :
C     -----------------------------------------------------------
      CALL CELCES(CARELE//'.CANBSP','V',CES1)

C     -- L'ORDRE DES CMPS EST IPORTANT (UTILISE DANS W155MA)
      LICMP(1)='COQ_NCOU'
      LICMP(2)='TUY_NCOU'
      LICMP(3)='TUY_NSEC'
      LICMP(4)='NBFIBR'
      LICMP(5)='GRI_NCOU'
      CALL CESRED(CES1,NBMA,ZI(JLIMA),5,LICMP,'V',CES2)
      CALL DETRSD('CHAM_ELEM_S',CES1)
      CALL JEVEUO(CES2//'.CESD','L',JCE2D)
      CALL JEVEUO(CES2//'.CESV','L',JCE2V)
      CALL JEVEUO(CES2//'.CESL','L',JCE2L)


C     2-BIS  VALEUR DE OMEGA (ANGZZK) POUR LES TUYAUX :
C     -----------------------------------------------------------
      IF (MOTFAC.EQ.'EXTR_TUYAU') THEN
        CALL CARCES(CARELE//'.CARORIEN','ELEM',' ','V',CES1,'A',IRET)
        CALL ASSERT(IRET.EQ.0)
        LICMP(1)='ANGZZK'
        CALL CESRED(CES1,NBMA,ZI(JLIMA),1,LICMP,'V',CES5)
        CALL DETRSD('CHAM_ELEM_S',CES1)
        CALL JEVEUO(CES5//'.CESD','L',JCE5D)
        CALL JEVEUO(CES5//'.CESV','L',JCE5V)
        CALL JEVEUO(CES5//'.CESL','L',JCE5L)
      ELSE
        JCE5D=0
        JCE5V=0
        JCE5L=0
      ENDIF


C     3. CHIN -> CES3 :
C     ------------------
      CALL CELCES(CHIN,'V',CES3)
      CALL JEVEUO(CES3//'.CESK','L',JCE3K)
      CALL JEVEUO(CES3//'.CESD','L',JCE3D)
      CALL JEVEUO(CES3//'.CESC','L',JCE3C)
      CALL JEVEUO(CES3//'.CESL','L',JCE3L)
      CALL JEVEUO(CES3//'.CESV','L',JCE3V)
      CALL JELIRA(CES3//'.CESC','LONMAX',NCMP,KBID)
      TYPCES=ZK8(JCE3K-1+3)
      CALL WKVECT('&&W155CH.NBPT','V V I',NBMAT,JNBPT)
      DO 10,KMA=1,NBMA
        NUMA=ZI(JLIMA-1+KMA)
        NBPT=ZI(JCE3D-1+5+4*(NUMA-1)+1)
        ZI(JNBPT-1+NUMA)=NBPT
   10 CONTINUE


C     4. ALLOCATION ET CALCUL DE CHEXTR :
C     ------------------------------------
      CALL CESCRE('V',CES4,TYPCES,MA,NOMGD,NCMP,ZK8(JCE3C),ZI(JNBPT),-1,
     &            -NCMP)
      CALL JEVEUO(CES4//'.CESD','L',JCE4D)
      CALL JEVEUO(CES4//'.CESV','L',JCE4V)
      CALL JEVEUO(CES4//'.CESL','L',JCE4L)
      DO 40,KMA=1,NBMA
        NUMA=ZI(JLIMA-1+KMA)
        CALL ASSERT(NUMA.GE.1 .AND. NUMA.LE.NBMAT)
        NBPT=ZI(JNBPT-1+NUMA)
        CALL W155MA(NUMA,NUCOU,NICOU,NANGL,NUFIB,MOTFAC,JCE2D,JCE2L,
     &              JCE2V,JCE5D,JCE5L,JCE5V,KSP1,KSP2,C1,C2,IRET)
        IF (IRET.EQ.1) GOTO 40
        DO 30,KPT=1,NBPT
          DO 20,KCMP=1,NCMP
            CALL CESEXI('C',JCE3D,JCE3L,NUMA,KPT,KSP1,KCMP,IAD1)
            CALL CESEXI('C',JCE3D,JCE3L,NUMA,KPT,KSP2,KCMP,IAD2)
            IF (IAD1.GT.0) THEN
              CALL ASSERT(IAD2.GT.0)
              CALL CESEXI('C',JCE4D,JCE4L,NUMA,KPT,1,KCMP,IAD4)
              CALL ASSERT(IAD4.LT.0)
              IAD4=-IAD4
              IF (TSCA.EQ.'R') THEN
                ZR(JCE4V-1+IAD4)=C1*ZR(JCE3V-1+IAD1)+C2*ZR(JCE3V-1+IAD2)
              ELSEIF (TSCA.EQ.'C') THEN
                ZC(JCE4V-1+IAD4)=C1*ZC(JCE3V-1+IAD1)+C2*ZC(JCE3V-1+IAD2)
              ELSE
                CALL ASSERT(.FALSE.)
              ENDIF
              ZL(JCE4L-1+IAD4)=.TRUE.
            ENDIF
   20     CONTINUE
   30   CONTINUE
   40 CONTINUE

C     4.5 CES4 -> CHEXTR :
C     ------------------------------------

      CALL DISMOI('F','NOM_OPTION',CHIN,'CHAM_ELEM',IBID,OPTION,IBID)
      CALL DISMOI('F','NOM_PARAM',CHIN,'CHAM_ELEM',IBID,NOMPAR,IBID)
      CALL CESCEL(CES4,LIGREL,OPTION,NOMPAR,'OUI',NNCP,'G',CHEXTR,'F',
     &            IRET)
      CALL ASSERT(NNCP.EQ.0)


C     6. MENAGE :
C     ------------
      CALL DETRSD('CHAM_ELEM_S',CES2)
      CALL DETRSD('CHAM_ELEM_S',CES3)
      CALL DETRSD('CHAM_ELEM_S',CES4)
      CALL DETRSD('CHAM_ELEM_S',CES5)
      CALL JEDETR('&&W155CH.NBPT')
      CALL JEDETR(LINUMA)
      CALL JEDETR(LINUTE)

      CALL JEDEMA()
      END
