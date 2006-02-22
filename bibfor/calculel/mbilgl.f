      SUBROUTINE MBILGL(OPTION,RESULT,MODELE,DEPLA1,DEPLA2,THETAI,MATE,
     &                  NCHAR,LCHAR,SYMECH,CHFOND,NNOFF,
     &                  NDEG,THLAGR,GLAGR,MILIEU,EXTIM,TIMEU,TIMEV,
     &                  INDI,INDJ,NBPRUP,NOPRUP)
      IMPLICIT  NONE

      INTEGER NCHAR,NNOFF,INDI,INDJ,NDEG
      INTEGER NBPRUP

      REAL*8 TIMEU,TIMEV

      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='MBILGL')
      CHARACTER*8 MODELE,THETAI,LCHAR(*)
      CHARACTER*8 RESULT,SYMECH
      CHARACTER*16 OPTION,NOPRUP(*)
      CHARACTER*24 DEPLA1,DEPLA2,CHFOND,MATE

      LOGICAL EXTIM,THLAGR,GLAGR,MILIEU
      LOGICAL UFONC,VFONC,EPSIU,EPSIV
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 21/02/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     TOLE CRP_21

C  - FONCTION REALISEE:   CALCUL DU TAUX DE RESTITUTION LOCAL D'ENERGIE

C  IN    OPTION --> CALC_G_BILI / CALC_G_BILI_F
C  IN    RESULT --> NOM UTILISATEUR DU RESULTAT ET TABLE
C  IN    MODELE --> NOM DU MODELE
C  IN    DEPLA  --> CHAMP DE DEPLACEMENT
C  IN    THETAI --> BASE DE I CHAMPS THETA
C  IN    MATE   --> CHAMP DE MATERIAUX
C  IN    COMPOR --> COMPORTEMENT
C  IN    NCHAR  --> NOMBRE DE CHARGES
C  IN    LCHAR  --> LISTE DES CHARGES
C  IN    SYMECH --> SYMETRIE DU CHARGEMENT
C  IN    CHFOND --> NOM DES NOEUDS DE FOND DE FISSURE
C  IN    NNOFF  --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C  IN    TIME   --> INSTANT DE CALCUL
C  IN    THLAGR --> VRAI SI LISSAGE THETA_LAGRANGE (SINON LEGENDRE)
C  IN    GLAGR  --> VRAI SI LISSAGE G_LAGRANGE (SINON LEGENDRE)
C  IN    NDEG   --> DEGRE DU POLYNOME DE LEGENDRE
C  IN    MILIEU --> .TRUE.  : ELEMENT QUADRATIQUE
C                   .FALSE. : ELEMENT LINEAIRE
C  IN    THETA  --> CHAMP DE PROPAGATION LAGRANGIENNE (SI CALC_G_LGLO)
C  IN    ALPHA  --> PROPAGATION LAGRANGIENNE          (SI CALC_G_LGLO)
C ......................................................................
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

      INTEGER I,IBID,IADRG,IADRGS,IER,IRET,JRESU,NCHIN
      INTEGER JTEMP,NUM,INCR,NRES,NSIG,NDEP
      INTEGER NDIMTE,IERD,INIT
      INTEGER IADRNO,IADGI,IADABS,IFM,NIV
      INTEGER IORD,IVAL(2)

      REAL*8 GTHI,GPMR(3),ALPHA

      COMPLEX*16 CBID

      LOGICAL EXIGEO,EXITHE,EXITRF

      CHARACTER*8 NOMA,K8BID,RESU,NOEUD
      CHARACTER*8 LPAIN(25),LPAOUT(1),REPK
      CHARACTER*16 OPTI
      CHARACTER*24 LIGRMO,TEMPE,CHGEOM,CHGTHI,CHROTA,CHPESA
      CHARACTER*24 UCHTMP,VCHTMP,CHTREF,CF2D3D,CHPRES
      CHARACTER*24 LCHIN(25),LCHOUT(1),CHTHET,CHALPH,CHTIMU,CHTIMV
      CHARACTER*24 OBJCUR,NORMFF,PAVOLU,PAPRES,PA2D3D
      CHARACTER*24 CHSIG,CHEPSP,CHVARI,TYPE,PEPSIN
      CHARACTER*24 CHSIGI,CHDEPI,CHEPSI,CHVOLU,CF1D2D
      CHARACTER*24 THETA
C
      CHARACTER*19 UCHVOL,VCHVOL,UCF12D,VCF12D,UCF23D,VCF23D
      CHARACTER*19 UCHPRE,VCHPRE,UCHEPS,VCHEPS,UCHPES,VCHPES
      CHARACTER*19 UCHROT,VCHROT
      CHARACTER*24 UPAVOL,VPAVOL,UPA23D,VPA23D,UPAPRE,VPAPRE
      CHARACTER*24 UPEPSI,VPEPSI
C
C     ------------------------------------------------------------------

      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      NOMA = CHGEOM

C- RECUPERATION DE L'ETAT INITIAL

      CALL GETFAC('ETAT_INIT',INIT)
      IF (INIT.NE.0) THEN
        CALL GETVID('ETAT_INIT','SIGM',1,1,1,CHSIGI,NSIG)
        IF(NSIG.NE.0)THEN
            CALL CHPVER('F',CHSIGI,'ELGA','SIEF_R',IER)
        ENDIF
        CALL GETVID('ETAT_INIT','DEPL',1,1,1,CHDEPI,NDEP)
        IF(NDEP.NE.0)THEN
            CALL CHPVER('F',CHDEPI,'NOEU','DEPL_R',IER)
        ENDIF
        IF ((NSIG.EQ.0) .AND. (NDEP.EQ.0)) THEN
          CALL UTMESS('F','MBILGL','AUCUN CHAMP INITIAL TROUVE')
        END IF
      END IF

C- RECUPERATION (S'ILS EXISTENT) DES CHAMP 
C  DE TEMPERATURE (TU, TV, TREF)

      TEMPE = ' '
      UCHTMP = '&&MBILGL.CH_TEMP_R'
      DO 10 I = 1,NCHAR
        CALL JEEXIN(LCHAR(I)//'.CHME.TEMPE.TEMP',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(LCHAR(I)//'.CHME.TEMPE.TEMP','L',JTEMP)
          TEMPE = ZK8(JTEMP)
        END IF
   10 CONTINUE
   
      CALL METREF(MATE,NOMA,EXITRF,CHTREF)
   
      CALL METEMP(NOMA,TEMPE,EXTIM,TIMEU,CHTREF,EXITHE,UCHTMP(1:19))
      
      TEMPE = ' '
      VCHTMP = '&&MBILGL.CH_TEMP_R'
      DO 11 I = 1,NCHAR
        CALL JEEXIN(LCHAR(I)//'.CHME.TEMPE.TEMP',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(LCHAR(I)//'.CHME.TEMPE.TEMP','L',JTEMP)
          TEMPE = ZK8(JTEMP)
        END IF
   11 CONTINUE
      CALL METEMP(NOMA,TEMPE,EXTIM,TIMEV,CHTREF,EXITHE,VCHTMP(1:19))
      
      CALL DISMOI('F','ELAS_F_TEMP',MATE,'CHAM_MATER',IBID,REPK,IERD)
      IF (REPK.EQ.'OUI') THEN
        IF (.NOT.EXITHE) THEN
          CALL UTMESS('F','MBILGL',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                '! IL N''Y A PAS DE CHAMP DE TEMPERATURE '//
     &                '! LE CALCUL EST IMPOSSIBLE ')
        END IF
        IF (.NOT.EXITRF) THEN
          CALL UTMESS('A',' MBILGL',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                ' IL N''Y A PAS DE TEMPERATURE DE REFERENCE'//
     &                ' ON PRENDRA DONC LA VALEUR 0')
        END IF
      END IF

C - TRAITEMENT DES CHARGES U
      
      UCHVOL = '&&MBILGL.VOLU'
      UCF12D = '&&MBILGL.1D2D'
      UCF23D = '&&MBILGL.2D3D'
      UCHPRE = '&&MBILGL.PRES'
      UCHEPS = '&&MBILGL.EPSI'
      UCHPES = '&&MBILGL.PESA'                  
      UCHROT = '&&MBILGL.ROTA'
      CALL GCHARG(MODELE,NCHAR,LCHAR,UCHVOL,UCF12D,UCF23D,UCHPRE,UCHEPS,
     &            UCHPES,UCHROT,UFONC,EPSIV,TIMEU,INDI)

      IF (UFONC) THEN
        UPAVOL = 'UPFFVOL'
        UPA23D = 'UPFF23D'
        UPAPRE = 'UPRESSF'
        UPEPSI = 'UEPSINF'
        OPTI = 'CALC_G_BILI_F'
      ELSE
        UPAVOL = 'UPFRVOL'
        UPA23D = 'UPFR23D'
        UPAPRE = 'UPRESSR'
        UPEPSI = 'UEPSINR'
        OPTI = OPTION
      END IF
      
C - TRAITEMENT DES CHARGES V 
 
      VCHVOL = '&&MBILGL.VOLU'
      VCF12D = '&&MBILGL.1D2D'
      VCF23D = '&&MBILGL.2D3D'
      VCHPRE = '&&MBILGL.PRES'
      VCHEPS = '&&MBILGL.EPSI'
      VCHPES = '&&MBILGL.PESA'                  
      VCHROT = '&&MBILGL.ROTA'
      CALL GCHARG(MODELE,NCHAR,LCHAR,VCHVOL,VCF12D,VCF23D,VCHPRE,VCHEPS,
     &            VCHPES,VCHROT,VFONC,EPSIU,TIMEV,INDJ)

      IF (VFONC) THEN
        VPAVOL = 'VPFFVOL'
        VPA23D = 'VPFF23D'
        VPAPRE = 'VPRESSF'
        VPEPSI = 'VEPSINF'
        OPTI = 'CALC_G_BILI_F'
      ELSE
        VPAVOL = 'VPFRVOL'
        VPA23D = 'VPFR23D'
        VPAPRE = 'VPRESSR'
        VPEPSI = 'VEPSINR'
        OPTI = OPTION
      END IF
  
C- CREATION D'UN CHAMP DE PROPAGATION. UTILISE SEULEMENT POUR
C  UN CALCUL DE G_LOCAL AVEC PROPAGATION LAGRANGIENNE

C      CALL MEALPH(NOMA,ALPHA,CHALPH)

C- CALCUL DES G(THETA_I) AVEC I=1,NDIMTE  NDIMTE = NNOFF  SI TH-LAGRANGE
C                                         NDIMTE = NDEG+1 SI TH-LEGENDRE
      IF (THLAGR) THEN
        NDIMTE = NNOFF
      ELSE
        NDIMTE = NDEG + 1
      END IF

      CALL WKVECT('&&MBILGL.VALG','V V R8',NDIMTE,IADRG)
      CALL JEVEUO(THETAI,'L',JRESU)

      DO 20 I = 1,NDIMTE
        CHTHET = ZK24(JRESU+I-1)
        CALL CODENT(I,'G',CHGTHI)
        LPAOUT(1) = 'PGTHETA'
        LCHOUT(1) = CHGTHI
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PDEPLAU'
        LCHIN(2) = DEPLA1
        LPAIN(3) = 'PTHETAR'
        LCHIN(3) = CHTHET
        LPAIN(4) = 'PMATERC'
        LCHIN(4) = MATE
        LPAIN(5) = 'PTMPERU'
        LCHIN(5) = UCHTMP
        LPAIN(6) = 'PDEPLAV'
        LCHIN(6) = DEPLA2
        LPAIN(7) = 'PTMPERV'
        LCHIN(7) = VCHTMP
        LPAIN(8) = UPAVOL
        LCHIN(8) = UCHVOL
        LPAIN(9) = VPAVOL
        LCHIN(9) = VCHVOL
        LPAIN(10) = UPA23D
        LCHIN(10) = UCF23D
        LPAIN(11) = VPA23D
        LCHIN(11) = VCF23D
        LPAIN(12) = UPAPRE
        LCHIN(12) = UCHPRE
        LPAIN(13) = VPAPRE
        LCHIN(13) = VCHPRE
        LPAIN(14) = UPEPSI
        LCHIN(14) = UCHEPS
        LPAIN(15) = VPEPSI
        LCHIN(15) = VCHEPS
        LPAIN(16) = 'UPESANR'
        LCHIN(16) = UCHPES
        LPAIN(17) = 'VPESANR'
        LCHIN(17) = VCHPES
        LPAIN(18) = 'UROTATR'
        LCHIN(18) = UCHROT
        LPAIN(19) = 'VROTATR'
        LCHIN(19) = VCHROT
        LPAIN(20) = 'PTEREF'
        LCHIN(20) = CHTREF
        
        LIGRMO = MODELE//'.MODELE'
        NCHIN = 20
        IF (OPTI .EQ. 'CALC_G_BILI_F') THEN
          CHTIMU = '&&'//NOMPRO//'.CH_INST_R'
          CALL MECACT('V',CHTIMU,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &                IBID,TIMEU,CBID,K8BID)
          NCHIN = NCHIN + 1
          LPAIN(NCHIN) = 'UTEMPSR'
          LCHIN(NCHIN) = CHTIMU
          
          CHTIMV = '&&'//NOMPRO//'.CH_INST_R'
          CALL MECACT('V',CHTIMV,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &                IBID,TIMEV,CBID,K8BID)
          NCHIN = NCHIN + 1
          LPAIN(NCHIN) = 'VTEMPSR'
          LCHIN(NCHIN) = CHTIMV
        END IF
        
        CALL CALCUL('S',OPTI,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V')
        CALL MESOMM(CHGTHI,1,IBID,GTHI,CBID,0,IBID)
        ZR(IADRG+I-1) = GTHI
   20 CONTINUE

C- CALCUL DE G(S) SUR LE FOND DE FISSURE PAR 2 METHODES
C- PREMIERE METHODE : G_LEGENDRE ET THETA_LEGENDRE
C- DEUXIEME METHODE: G_LAGRANGE ET THETA_LAGRANGE

      CALL WKVECT('&&MBILGL.VALG_S','V V R8',NNOFF,IADRGS)
      IF (GLAGR) THEN
        CALL WKVECT('&&MBILGL.VALGI','V V R8',NNOFF,IADGI)
      ELSE
        CALL WKVECT('&&MBILGL.VALGI','V V R8',NDEG+1,IADGI)
      END IF
      IF ((.NOT.GLAGR) .AND. (.NOT.THLAGR)) THEN
        NUM = 1
        CALL GMETH1(MODELE,OPTION,NNOFF,NDEG,CHFOND,ZR(IADRG),THETA,
     &              ALPHA,ZR(IADRGS),OBJCUR,ZR(IADGI))
      ELSE IF (THLAGR .AND. THLAGR) THEN
        NORMFF = ZK24(JRESU+NNOFF+1-1)
        NORMFF(20:24) = '.VALE'
        CALL GMETH3(MODELE,NNOFF,NORMFF,CHFOND,ZR(IADRG),MILIEU,
     &              ZR(IADRGS),OBJCUR,ZR(IADGI),NUM)
      END IF

C- SYMETRIE DU CHARGEMENT ET IMPRESSION DES RESULTATS

      IF (SYMECH.NE.'SANS') THEN
        DO 30 I = 1,NNOFF
          ZR(IADRGS+I-1) = 2.D0*ZR(IADRGS+I-1)
   30   CONTINUE
      END IF

C- IMPRESSION ET ECRITURE DANS TABLE(S) DE G(S)

      CALL JEVEUO(CHFOND,'L',IADRNO)
      CALL JEVEUO(OBJCUR,'L',IADABS)

      IF (NIV.GE.2) THEN
        CALL GIMPGS(RESULT,NNOFF,ZR(IADABS),ZR(IADRGS),NUM,ZR(IADGI),
     &              NDEG,ZR(IADRG),EXTIM,TIMEU,IORD,IFM)
      END IF

      DO 40 I = 1,NNOFF
        NOEUD = ZK8(IADRNO+I-1)
        GPMR(1) = TIMEU
        GPMR(2) = ZR(IADABS+I-1)
        GPMR(3) = ZR(IADRGS+I-1)
        IVAL(1) = INDI
        IVAL(2) = INDJ

        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IVAL,GPMR,CBID,NOEUD,0)
   40 CONTINUE

C- DESTRUCTION D'OBJETS DE TRAVAIL

      CALL JEDETR(OBJCUR)
      CALL JEDETR('&&MBILGL.VALG_S')
      CALL JEDETR('&&MBILGL.VALGI')
      CALL DETRSD('CHAMP_GD',UCHTMP)
      CALL DETRSD('CHAMP_GD',VCHTMP)
      CALL DETRSD('CHAMP_GD',CHTREF)
      CALL DETRSD('CHAMP_GD',CHTIMU)
      CALL DETRSD('CHAMP_GD',CHTIMV)
      CALL DETRSD('CHAMP_GD',UCHVOL)
      CALL DETRSD('CHAMP_GD',VCHVOL)
      CALL DETRSD('CHAMP_GD',UCF23D)
      CALL DETRSD('CHAMP_GD',VCF23D)
      CALL DETRSD('CHAMP_GD',UCHPRE)
      CALL DETRSD('CHAMP_GD',VCHPRE)
      CALL DETRSD('CHAMP_GD',UCHEPS)
      CALL DETRSD('CHAMP_GD',VCHEPS)
      CALL DETRSD('CHAMP_GD',UCHPES)
      CALL DETRSD('CHAMP_GD',VCHPES)
      CALL DETRSD('CHAMP_GD',UCHROT)
      CALL DETRSD('CHAMP_GD',VCHROT)
      
      CALL JEDETR('&&MBILGL.VALG')

      CALL JEDEMA()
      END
