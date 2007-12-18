      SUBROUTINE MECAGL(OPTION,RESULT,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &                  NCHAR,LCHAR,SYMECH,CHFOND,NNOFF,IORD,NDEG,
     &                  THLAGR,GLAGR,THLAG2,MILIEU,THETA,NDIMTE,PAIR,
     &                  ALPHA,EXTIM,TIME,NBPRUP,NOPRUP,CHVITE,CHACCE,
     &                  LMELAS,NOMCAS)
      IMPLICIT  NONE

      INTEGER IORD,NCHAR,NBPRUP,NDIMTE

      REAL*8 TIME,ALPHA

      CHARACTER*8 MODELE,THETAI,LCHAR(*)
      CHARACTER*8 RESULT,SYMECH
      CHARACTER*16 OPTION,NOPRUP(*),NOMCAS
      CHARACTER*24 DEPLA,CHFOND,MATE,COMPOR,THETA
      CHARACTER*24 CHVITE,CHACCE

      LOGICAL EXTIM,THLAGR,GLAGR,MILIEU,PAIR,THLAG2,LMELAS
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 17/12/2007   AUTEUR REZETTE C.REZETTE 
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

C  IN    OPTION --> CALC_G OU G_LAGR (SI CHARGES REELLES)
C               --> CALC_G_F OU G_LAGR_F (SI CHARGES FONCTIONS)
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
C  IN    IORD   --> NUMERO D'ORDRE DE LA SD
C  IN    THLAGR --> VRAI SI LISSAGE THETA_LAGRANGE
C  IN    THLAG2 --> VRAI SI LISSAGE THETA_LAGRANGE_REGU
C  IN    GLAGR  --> VRAI SI LISSAGE G_LAGRANGE
C  IN    NDEG   --> DEGRE DU POLYNOME DE LEGENDRE
C  IN    THETA  --> CHAMP DE PROPAGATION LAGRANGIENNE (SI G_LAGR)
C  IN    ALPHA  --> PROPAGATION LAGRANGIENNE          (SI G_LAGR)
C  IN    LMELAS --> TRUE SI LE TYPE DE LA SD RESULTAT EST MULT_ELAS
C  IN    NOMCAS --> NOM DU CAS DE CHARGE SI LMELAS
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


      INTEGER I,IBID,IADRG,IADRGS,IRET,JRESU,NCHIN
      INTEGER JTEMP,NNOFF,NUM,INCR,NRES,NSIG,NDEP
      INTEGER NDEG,IERD,INIT,IAD
      INTEGER IADRNO,IADGI,IADABS,IFM,NIV

      REAL*8 GTHI,GPMR(3)

      COMPLEX*16 CBID

      LOGICAL EXIGEO,EXITHE,EXITRF,FONC,EPSI

      CHARACTER*8 NOMA,K8BID,RESU,NOEUD,K8B
      CHARACTER*8 LPAIN(23),LPAOUT(1),REPK
      CHARACTER*16 OPTI,GPNK(2)
      CHARACTER*19 CHROTA,CHPESA,CF2D3D,CHPRES,CHVOLU,CF1D2D,CHEPSI
      CHARACTER*19 CHVARC,CHVREF
      CHARACTER*24 LIGRMO,TEMPE,CHGEOM,CHGTHI
      CHARACTER*24 CHTEMP,CHTREF,CHSIGI,CHDEPI
      CHARACTER*24 LCHIN(23),LCHOUT(1),CHTHET,CHALPH,CHTIME
      CHARACTER*24 OBJCUR,NORMFF,PAVOLU,PAPRES,PA2D3D
      CHARACTER*24 CHSIG,CHEPSP,CHVARI,TYPE,PEPSIN
C     ------------------------------------------------------------------

      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)

      CHVARC = '&&MECAGL.VARC'
      CHVREF = '&&MECAGL.VARC.REF'

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      NOMA = CHGEOM(1:8)

C- RECUPERATION DU COMPORTEMENT

      CALL GETFAC('COMP_INCR',INCR)

      IF (INCR.NE.0) THEN
        CALL GETVID(' ','RESULTAT',0,1,1,RESU,NRES)
        CALL DISMOI('F','TYPE_RESU',RESU,'RESULTAT',IBID,TYPE,IERD)
        IF (TYPE.NE.'EVOL_NOLI') THEN
          CALL U2MESS('F','ALGORITH_52')
        END IF
        CALL RSEXCH(RESU,'SIEF_ELGA',IORD,CHSIG,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH_53')
        END IF
        CALL RSEXCH(RESU,'EPSP_ELNO',IORD,CHEPSP,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH_54')
        END IF
        CALL RSEXCH(RESU,'VARI_ELNO_ELGA',IORD,CHVARI,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH_55')
        END IF
      END IF

C- RECUPERATION DE L'ETAT INITIAL

      CALL GETFAC('ETAT_INIT',INIT)
      IF (INIT.NE.0) THEN
        CALL GETVID('ETAT_INIT','SIGM',1,1,1,CHSIGI,NSIG)
        IF(NSIG.NE.0)THEN
            CALL CHPVER('F',CHSIGI,'ELGA','SIEF_R',IERD)
        ENDIF
        CALL GETVID('ETAT_INIT','DEPL',1,1,1,CHDEPI,NDEP)
        IF(NDEP.NE.0)THEN
            CALL CHPVER('F',CHDEPI,'NOEU','DEPL_R',IERD)
        ENDIF
        IF ((NSIG.EQ.0) .AND. (NDEP.EQ.0)) THEN
          CALL U2MESS('F','ALGORITH_56')
        END IF
      END IF

      CALL VRCINS(MODELE,MATE(1:8),'        ',NCHAR,LCHAR,TIME,CHVARC)
      CALL VRCREF(MODELE,MATE(1:8),'        ',CHVREF(1:19))

C - TRAITEMENT DES CHARGES

      CHVOLU = '&&MECAGL.VOLU'
      CF1D2D = '&&MECAGL.1D2D'
      CF2D3D = '&&MECAGL.2D3D'
      CHPRES = '&&MECAGL.PRES'
      CHEPSI = '&&MECAGL.EPSI'
      CHPESA = '&&MECAGL.PESA'
      CHROTA = '&&MECAGL.ROTA'
      CALL GCHARG(MODELE,NCHAR,LCHAR,CHVOLU,CF1D2D,CF2D3D,CHPRES,CHEPSI,
     &            CHPESA,CHROTA,FONC,EPSI,TIME,IORD)
      IF (FONC) THEN
        PAVOLU = 'PFFVOLU'
        PA2D3D = 'PFF2D3D'
        PAPRES = 'PPRESSF'
        PEPSIN = 'PEPSINF'
        IF (OPTION.EQ.'CALC_G') THEN
          OPTI = 'CALC_G_F'
        ELSE
          OPTI = 'G_LAGR_F'
        END IF
      ELSE
        PAVOLU = 'PFRVOLU'
        PA2D3D = 'PFR2D3D'
        PAPRES = 'PPRESSR'
        PEPSIN = 'PEPSINR'
        OPTI=OPTION
      END IF


C- CREATION D'UN CHAMP DE PROPAGATION. UTILISE SEULEMENT POUR
C  UN CALCUL DE G_LOCAL AVEC PROPAGATION LAGRANGIENNE

      CALL MEALPH(NOMA,ALPHA,CHALPH)

C- CALCUL DES G(THETA_I) AVEC I=1,NDIMTE  NDIMTE = NNOFF  SI TH-LAGRANGE
C                                         NDIMTE = NDEG+1 SI TH-LEGENDRE
      IF(THLAG2) THEN
        NDIMTE = NDIMTE
      ELSEIF (THLAGR) THEN
        NDIMTE = NNOFF
      ELSE
        NDIMTE = NDEG + 1
      END IF

      CALL WKVECT('&&MECAGL.VALG','V V R8',NDIMTE,IADRG)
      CALL JEVEUO(THETAI,'L',JRESU)

      DO 20 I = 1,NDIMTE
        CHTHET = ZK24(JRESU+I-1)
        CALL CODENT(I,'G',CHGTHI)
        LPAOUT(1) = 'PGTHETA'
        LCHOUT(1) = CHGTHI
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PDEPLAR'
        LCHIN(2) = DEPLA
        LPAIN(3) = 'PTHETAR'
        LCHIN(3) = CHTHET
        LPAIN(4) = 'PMATERC'
        LCHIN(4) = MATE
        LPAIN(5) = 'PVARCPR'
        LCHIN(5) = CHVARC
        LPAIN(6) = 'PVARCRR'
        LCHIN(6) = CHVREF
        LPAIN(7) = PAVOLU(1:8)
        LCHIN(7) = CHVOLU
        LPAIN(8) = PA2D3D(1:8)
        LCHIN(8) = CF2D3D
        LPAIN(9) = PAPRES(1:8)
        LCHIN(9) = CHPRES
        LPAIN(10) = 'PPESANR'
        LCHIN(10) = CHPESA
        LPAIN(11) = 'PROTATR'
        LCHIN(11) = CHROTA
        LPAIN(12) = PEPSIN(1:8)
        LCHIN(12) = CHEPSI
        LPAIN(13) = 'PTHETA1'
        LCHIN(13) = THETA
        LPAIN(14) = 'PALPHAR'
        LCHIN(14) = CHALPH
        LPAIN(15) = 'PCOMPOR'
        LCHIN(15) = COMPOR

        LIGRMO = MODELE//'.MODELE'
        NCHIN = 15
        IF ((OPTI.EQ.'CALC_G_F') .OR. (OPTI.EQ.'G_LAGR_F'))THEN
          CHTIME = '&&MECAGL.CH_INST_R'
          CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R',1,'INST',IBID,
     &                TIME,CBID,K8BID)
          LPAIN(NCHIN+1) = 'PTEMPSR'
          LCHIN(NCHIN+1) = CHTIME
          NCHIN = NCHIN + 1
        END IF
        IF (INCR.NE.0) THEN
          LPAIN(NCHIN+1) = 'PCONTRR'
          LCHIN(NCHIN+1) = CHSIG
          LPAIN(NCHIN+2) = 'PDEFOPL'
          LCHIN(NCHIN+2) = CHEPSP
          LPAIN(NCHIN+3) = 'PVARIPR'
          LCHIN(NCHIN+3) = CHVARI
          NCHIN = NCHIN + 3
        END IF
        IF (INIT.NE.0) THEN
          IF (NSIG.NE.0) THEN
            LPAIN(NCHIN+1) = 'PSIGINR'
            LCHIN(NCHIN+1) = CHSIGI
            NCHIN = NCHIN + 1
          END IF
          IF (NDEP.NE.0) THEN
            LPAIN(NCHIN+1) = 'PDEPINR'
            LCHIN(NCHIN+1) = CHDEPI
            NCHIN = NCHIN + 1
          END IF
        END IF
        IF (OPTION.EQ.'CALC_G'.OR.OPTION.EQ.'CALC_G_F') THEN
          IF (CHVITE.NE.' ') THEN
            LPAIN(NCHIN+1) = 'PVITESS'
            LCHIN(NCHIN+1) =  CHVITE
            LPAIN(NCHIN+2) = 'PACCELE'
            LCHIN(NCHIN+2) =  CHACCE
            NCHIN = NCHIN + 2
          END IF
        END IF

        CALL CALCUL('S',OPTI,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V')
        CALL MESOMM(CHGTHI,1,IBID,GTHI,CBID,0,IBID)
        ZR(IADRG+I-1) = GTHI
   20 CONTINUE

C- CALCUL DE G(S) SUR LE FOND DE FISSURE PAR 4 METHODES
C- PREMIERE METHODE : G_LEGENDRE ET THETA_LEGENDRE
C- DEUXIEME METHODE : G_LEGENDRE ET THETA_LAGRANGE
C- TROISIEME METHODE: G_LAGRANGE ET THETA_LAGRANGE
C    (OU G_LAGRANGE_NO_NO ET THETA_LAGRANGE)
C- QUATRIEME METHODE: G_LAGRANGE_REGU ET THETA_LAGRANGE_REGU

      CALL WKVECT('&&MECAGL.VALG_S','V V R8',NNOFF,IADRGS)
      IF (GLAGR.OR.THLAG2) THEN
        CALL WKVECT('&&MECAGL.VALGI','V V R8',NNOFF,IADGI)
      ELSE
        CALL WKVECT('&&MECAGL.VALGI','V V R8',NDEG+1,IADGI)
      END IF
      IF(THLAG2) THEN
        NUM = 5
        CALL GMETH4(MODELE,OPTION,NNOFF,NDIMTE,CHFOND,ZR(IADRG),
     &              MILIEU,PAIR,ZR(IADRGS),OBJCUR,ZR(IADGI))
      ELSEIF ((.NOT.GLAGR) .AND. (.NOT.THLAGR)) THEN
        NUM = 1
        CALL GMETH1(MODELE,OPTION,NNOFF,NDEG,CHFOND,ZR(IADRG),THETA,
     &              ALPHA,ZR(IADRGS),OBJCUR,ZR(IADGI))
      ELSE IF (THLAGR) THEN
        NORMFF = ZK24(JRESU+NNOFF+1-1)
        NORMFF(20:24) = '.VALE'
        IF (.NOT.GLAGR) THEN
          NUM = 2
          CALL GMETH2(MODELE,OPTION,NNOFF,NDEG,NORMFF,CHFOND,ZR(IADRG),
     &                THETA,ALPHA,ZR(IADRGS),OBJCUR,ZR(IADGI))
        ELSE
          CALL GMETH3(MODELE,NNOFF,NORMFF,CHFOND,ZR(IADRG),
     &                MILIEU,ZR(IADRGS),OBJCUR,ZR(IADGI),NUM)
        END IF
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
     &              NDEG,NDIMTE,ZR(IADRG),EXTIM,TIME,IORD,IFM)
      END IF

      DO 40 I = 1,NNOFF
        NOEUD = ZK8(IADRNO+I-1)
        IF (NBPRUP.EQ.3) THEN
          GPMR(1) = ZR(IADABS+I-1)
          GPMR(2) = ZR(IADRGS+I-1)
          CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IORD,GPMR,CBID,NOEUD,0)
        ELSE
          IF(LMELAS)THEN
            GPMR(1) = ZR(IADABS+I-1)
            GPMR(2) = ZR(IADRGS+I-1)
            GPNK(1) = NOMCAS
            GPNK(2) = NOEUD
            CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IORD,GPMR,CBID,GPNK,0)
          ELSE
            GPMR(1) = TIME
            GPMR(2) = ZR(IADABS+I-1)
            GPMR(3) = ZR(IADRGS+I-1)
            CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IORD,GPMR,CBID,NOEUD,0)
          ENDIF
        END IF
   40 CONTINUE

C- DESTRUCTION D'OBJETS DE TRAVAIL

      CALL JEDETR(OBJCUR)
      CALL JEDETR('&&MECAGL.VALG_S')
      CALL JEDETR('&&MECAGL.VALGI')
      CALL DETRSD('CHAMP_GD',CHVARC)
      CALL DETRSD('CHAMP_GD',CHVREF)
      CALL DETRSD('CHAMP_GD',CHVOLU)
      CALL DETRSD('CHAMP_GD',CF1D2D)
      CALL DETRSD('CHAMP_GD',CF2D3D)
      CALL DETRSD('CHAMP_GD',CHPRES)
      CALL DETRSD('CHAMP_GD',CHEPSI)
      CALL DETRSD('CHAMP_GD',CHPESA)
      CALL DETRSD('CHAMP_GD',CHROTA)
      CALL JEDETR('&&MECAGL.VALG')

      CALL JEDEMA()
      END
