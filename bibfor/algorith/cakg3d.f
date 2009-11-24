      SUBROUTINE CAKG3D(OPTION,RESULT,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &                 NCHAR,LCHAR,SYMECH,CHFOND,NNOFF,BASLOC,COURB,
     &                 IORD,NDEG,THLAGR,GLAGR,THLAG2,PAIR,NDIMTE,
     &                 EXTIM,TIME,NBPRUP,NOPRUP,FISS,
     &                 LMELAS,NOMCAS)
      IMPLICIT  NONE

      INTEGER IORD,NCHAR,NBPRUP,NDIMTE
      REAL*8 TIME
      CHARACTER*8 MODELE,THETAI,LCHAR(*),FISS
      CHARACTER*8 RESULT,SYMECH
      CHARACTER*16 OPTION,NOPRUP(*),NOMCAS
      CHARACTER*24 DEPLA,CHFOND,MATE,COMPOR,BASLOC,COURB
      LOGICAL EXTIM,THLAGR,GLAGR,THLAG2,PAIR,LMELAS

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/11/2009   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     TOLE CRP_21

C  FONCTION REALISEE:   CALCUL DU TAUX DE RESTITUTION LOCAL D'ENERGIE ET
C                       DES FACTEURS D'INTENSITE DE CONTRAINTES EN 3D

C  IN    OPTION --> CALC_K_G
C  IN    RESULT --> NOM UTILISATEUR DU RESULTAT ET TABLE
C  IN    MODELE --> NOM DU MODELE
C  IN    DEPLA  --> CHAMP DE DEPLACEMENT
C  IN    THETAI --> BASE DE I CHAMPS THETA
C  IN    MATE   --> CHAMP DE MATERIAUX
C  IN    COMPOR --> COMPORTEMENT
C  IN    NCHAR  --> NOMBRE DE CHARGES
C  IN    LCHAR  --> LISTE DES CHARGES
C  IN    SYMECH --> SYMETRIE DU CHARGEMENT
C  IN    CHFOND --> POINTS DU FOND DE FISSURE
C  IN    NNOFF  --> NOMBRE DE POINTS DU FOND DE FISSURE
C  IN    BASLOC --> BASE LOCALE
C  IN    TIME   --> INSTANT DE CALCUL
C  IN    IORD   --> NUMERO D'ORDRE DE LA SD
C  IN    THLAGR --> VRAI SI LISSAGE THETA_LAGRANGE (SINON LEGENDRE)
C  IN    GLAGR  --> VRAI SI LISSAGE G_LAGRANGE (SINON LEGENDRE)
C  IN    NDEG   --> DEGRE DU POLYNOME DE LEGENDRE
C  IN    FISS   --> NOM DE LA SD FISS_XFEM
C  IN    LMELAS --> TRUE SI LE TYPE DE LA SD RESULTAT EST MULT_ELAS
C  IN    NOMCAS --> NOM DU CAS DE CHARGE SI LMELAS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER      NBINMX,NBOUMX,NUMFON
      PARAMETER   (NBINMX=50,NBOUMX=1)
      CHARACTER*8  LPAIN(NBINMX),LPAOUT(NBOUMX)      
      CHARACTER*24 LCHIN(NBINMX),LCHOUT(NBOUMX)  
C      
      INTEGER      I,J,IBID,IADRGK,IADGKS,IRET,JRESU,NCHIN
      INTEGER      NNOFF,NUM,INCR,NRES,NSIG,NDEP
      INTEGER      NDEG,IERD,INIT,GPMI(3)
      INTEGER      IADGKI,IADABS,IFM,NIV
      REAL*8       GKTHI(8),GPMR(8)
      COMPLEX*16   CBID
      LOGICAL      EXIGEO,FONC,EPSI
      CHARACTER*1  K1BID
      CHARACTER*2  CODRET
      CHARACTER*8  K8BID,RESU
      CHARACTER*16 OPTI,VALK
      CHARACTER*19 CHROTA,CHPESA,CHVOLU,CF1D2D,CHEPSI,CF2D3D,CHPRES
      CHARACTER*19 CHVARC,CHVREF
      CHARACTER*24 LIGRMO,CHGEOM,CHGTHI
      CHARACTER*24 CHSIGI,CHDEPI
      CHARACTER*24 CHTHET,CHTIME
      CHARACTER*24 ABSCUR,PAVOLU,PAPRES,PA2D3D
      CHARACTER*24 CHSIG,CHEPSP,CHVARI,TYPE,PEPSIN
      CHARACTER*19 PINTTO,CNSETO,HEAVTO,LONCHA,LNNO,LTNO
C
C ---------------------------------------------------------------------
C
      CALL JEMARQ()

      CALL INFNIV(IFM,NIV)

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      CHVARC='&&CAKG3D.VARC'
      CHVREF='&&CAKG3D.VARC.REF'

C- RECUPERATION DU COMPORTEMENT

      CALL GETFAC('COMP_INCR',INCR)
      IF (INCR.NE.0) THEN
        CALL GETVID(' ','RESULTAT',0,1,1,RESU,NRES)
        CALL DISMOI('F','TYPE_RESU',RESU,'RESULTAT',IBID,TYPE,IERD)
        IF (TYPE.NE.'EVOL_NOLI') THEN
          CALL U2MESS('F','RUPTURE1_15')
        END IF
        CALL RSEXCH(RESU,'SIEF_ELGA',IORD,CHSIG,IRET)
        IF (IRET.NE.0) THEN
          VALK='SIEF_ELGA'
          CALL U2MESK('F','RUPTURE1_16',1,VALK)
        END IF
        CALL RSEXCH(RESU,'EPSP_ELNO',IORD,CHEPSP,IRET)
        IF (IRET.NE.0) THEN
          VALK='EPSP_ELNO'
          CALL U2MESK('F','RUPTURE1_16',1,VALK)
        END IF
        CALL RSEXCH(RESU,'VARI_ELNO_ELGA',IORD,CHVARI,IRET)
        IF (IRET.NE.0) THEN
          VALK='VARI_ELNO_ELGA'
          CALL U2MESK('F','RUPTURE1_16',1,VALK)
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
          CALL U2MESS('F','RUPTURE1_12')
        END IF
      END IF

C- RECUPERATION (S'ILS EXISTENT) DES CHAMP DE TEMPERATURES (T,TREF)

      CALL VRCINS(MODELE,MATE,' ',TIME,CHVARC,CODRET)
      CALL VRCREF(MODELE,MATE(1:8),'        ',CHVREF(1:19))

C - TRAITEMENT DES CHARGES

      CHVOLU = '&&CAKG3D.VOLU'
      CF1D2D = '&&CAKG3D.1D2D'
      CF2D3D = '&&CAKG3D.2D3D'
      CHPRES = '&&CAKG3D.PRES'
      CHEPSI = '&&CAKG3D.EPSI'
      CHPESA = '&&CAKG3D.PESA'
      CHROTA = '&&CAKG3D.ROTA'
      CALL GCHARG(MODELE,NCHAR,LCHAR,CHVOLU,CF1D2D,CF2D3D,CHPRES,CHEPSI,
     &            CHPESA,CHROTA,FONC,EPSI,TIME,IORD)
      IF (FONC) THEN
        PAVOLU = 'PFFVOLU'
        PA2D3D = 'PFF2D3D'
        PAPRES = 'PPRESSF'
        PEPSIN = 'PEPSINF'
        OPTI = 'CALC_K_G_F'
      ELSE
        PAVOLU = 'PFRVOLU'
        PA2D3D = 'PFR2D3D'
        PAPRES = 'PPRESSR'
        PEPSIN = 'PEPSINR'
        OPTI = 'CALC_K_G'
      END IF
C
C --- RECUPERATION DES DONNEES XFEM (TOPOSE)
C
      PINTTO = MODELE(1:8)//'.TOPOSE.PIN'
      CNSETO = MODELE(1:8)//'.TOPOSE.CNS'
      HEAVTO = MODELE(1:8)//'.TOPOSE.HEA'
      LONCHA = MODELE(1:8)//'.TOPOSE.LON' 
C     ON NE PREND PAS LES LSN ET LST DU MODELE
C     CAR LES CHAMPS DU MODELE SONT DEFINIS QUE AUTOUR DE LA FISSURE
C     OR ON A BESOIN DE LSN ET LST MEME POUR LES �L�MENTS CLASSIQUES
      LNNO   = FISS//'.LNNO'  
      LTNO   = FISS//'.LTNO'  
         

C- CALCUL DES K(THETA_I) AVEC I=1,NDIMTE  NDIMTE = NNOFF  SI TH-LAGRANGE
C                                         NDIMTE = NDEG+1 SI TH-LEGENDRE
      IF (THLAG2) THEN
        NDIMTE = NDIMTE
      ELSEIF (THLAGR) THEN
        NDIMTE = NNOFF
      ELSE
        NDIMTE = NDEG + 1
      END IF

      CALL WKVECT('&&CAKG3D.VALG','V V R8',NDIMTE*8,IADRGK)
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
        LPAIN(8) = 'PPESANR'
        LCHIN(8) = CHPESA
        LPAIN(9) = 'PROTATR'
        LCHIN(9) = CHROTA
        LPAIN(10) = PEPSIN(1:8)
        LCHIN(10) = CHEPSI
        LPAIN(11) = 'PCOMPOR'
        LCHIN(11) = COMPOR
        LPAIN(12) = 'PBASLOR'
        LCHIN(12) = BASLOC
        LPAIN(13) = 'PCOURB'
        LCHIN(13) = COURB
        LPAIN(14) = 'PPINTTO'
        LCHIN(14) = PINTTO
        LPAIN(15) = 'PCNSETO'
        LCHIN(15) = CNSETO
        LPAIN(16) = 'PHEAVTO'
        LCHIN(16) = HEAVTO
        LPAIN(17) = 'PLONCHA'
        LCHIN(17) = LONCHA
        LPAIN(18) = PA2D3D(1:8)
        LCHIN(18) = CF2D3D
        LPAIN(19) = PAPRES
        LCHIN(19) = CHPRES
        LPAIN(20) = 'PLSN'
        LCHIN(20) = LNNO
        LPAIN(21) = 'PLST'
        LCHIN(21) = LTNO
        IF (OPTION.EQ.'CALC_K_G'.OR.
     &      OPTION.EQ.'CALC_K_G_F') THEN
          LPAIN(22) = 'PPINTER'
C          LCHIN(22) = MODELE(1:8)//'.TOPOFAC.PI'
          LCHIN(22) = MODELE(1:8)//'.TOPOFAC.OE'
          LPAIN(23) = 'PAINTER'
          LCHIN(23) = MODELE(1:8)//'.TOPOFAC.AI'
          LPAIN(24) = 'PCFACE'
          LCHIN(24) = MODELE(1:8)//'.TOPOFAC.CF'
          LPAIN(25) = 'PLONGCO'
          LCHIN(25) = MODELE(1:8)//'.TOPOFAC.LO'
        ENDIF


        LIGRMO = MODELE//'.MODELE'
        NCHIN = 25
C
        CHTIME = '&&CAKG3D.CH_INST_R'
        IF (OPTI .EQ. 'CALC_K_G_F') THEN
        CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &              IBID,TIME,CBID,K8BID)
          NCHIN = NCHIN + 1
          LPAIN(NCHIN) = 'PTEMPSR'
          LCHIN(NCHIN) = CHTIME
        END IF

C       POUR L'INSTANT, ON NE PREND PAS EN COMPTE LE COMPORTEMENT INCR
C       NI LES DEFORMATIONS ET CONTRAINTES INITIALLES
C        IF (INCR.NE.0) THEN
C          LPAIN(NCHIN+1) = 'PCONTRR'
C          LCHIN(NCHIN+1) = CHSIG
C          LPAIN(NCHIN+2) = 'PDEFOPL'
C          LCHIN(NCHIN+2) = CHEPSP
C          LPAIN(NCHIN+3) = 'PVARIPR'
C          LCHIN(NCHIN+3) = CHVARI
C          NCHIN = NCHIN + 3
C        END IF
C        IF (INIT.NE.0) THEN
C          IF (NSIG.NE.0) THEN
C            LPAIN(NCHIN+1) = 'PSIGINR'
C            LCHIN(NCHIN+1) = CHSIGI
C            NCHIN = NCHIN + 1
C          END IF
C          IF (NDEP.NE.0) THEN
C            LPAIN(NCHIN+1) = 'PDEPINR'
C            LCHIN(NCHIN+1) = CHDEPI
C            NCHIN = NCHIN + 1
C          END IF
C        END IF


        CALL ASSERT(NCHIN.LE.NBINMX)
        CALL CALCUL('S',OPTI,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V')

C       FAIRE LA "SOMME" D'UN CHAM_ELEM
        CALL MESOMM(CHGTHI,8,IBID,GKTHI,CBID,0,IBID)

C       SYMETRIE DU CHARGEMENT
        IF (SYMECH.EQ.'SANS') THEN
          DO 29 J = 1,7
            ZR(IADRGK-1+(I-1)*8+J) = GKTHI(J)
 29       CONTINUE
        ELSEIF (SYMECH.EQ.'SYME') THEN
C         G, g1, g2, g3, K1, K2, K3, 
          ZR(IADRGK-1+(I-1)*8+1) = 2.D0*GKTHI(1)
          ZR(IADRGK-1+(I-1)*8+2) = 2.D0*GKTHI(2)
          ZR(IADRGK-1+(I-1)*8+3) = 0.D0
          ZR(IADRGK-1+(I-1)*8+4) = 0.D0
          ZR(IADRGK-1+(I-1)*8+5) = 2.D0*GKTHI(5)
          ZR(IADRGK-1+(I-1)*8+6) = 0.D0
          ZR(IADRGK-1+(I-1)*8+7) = 0.D0
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

 20   CONTINUE

C- CALCUL DE G(S), K1(S), K2(S) et K3(S)
C             SUR LE FOND DE FISSURE PAR 2 METHODES
C- PREMIERE METHODE : G_LEGENDRE ET THETA_LEGENDRE
C- DEUXIEME METHODE : G_LEGENDRE ET THETA_LAGRANGE
C- TROISIEME METHODE: G_LAGRANGE ET THETA_LAGRANGE
C    (OU G_LAGRANGE_NO_NO ET THETA_LAGRANGE)

      CALL WKVECT('&&CAKG3D.VALGK_S','V V R8',NNOFF*6,IADGKS)
      IF (GLAGR.OR.THLAG2) THEN
        CALL WKVECT('&&CAKG3D.VALGKI','V V R8',NNOFF*5,IADGKI)
      ELSE
        CALL WKVECT('&&CAKG3D.VALGKI','V V R8',(NDEG+1)*5,IADGKI)
      END IF
      ABSCUR='&&CAKG3D.TEMP     .ABSCU'
      CALL WKVECT(ABSCUR,'V V R',NNOFF,IADABS)

      IF(THLAG2) THEN
        NUM = 5
        CALL GKMET4(NNOFF,NDIMTE,CHFOND,PAIR,IADRGK,IADGKS,IADGKI,
     &          ABSCUR,NUM)
      ELSEIF ((.NOT.GLAGR) .AND. (.NOT.THLAGR)) THEN
        NUM = 1
        CALL GKMET1(NDEG,NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR)

      ELSE IF (THLAGR) THEN
C        NORMFF = ZK24(JRESU+NNOFF+1-1)
C        NORMFF(20:24) = '.VALE'
        IF (.NOT.GLAGR) THEN
          NUM = 2
          CALL U2MESS('F','RUPTURE1_17')
C         CALL GMETH2(NDEG,NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR,NUM)
        ELSE
          NUM = 3
          CALL GKMET3(NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR,NUM)
        END IF
      END IF

C- IMPRESSION ET ECRITURE DANS TABLE(S) DE G(S), K1(S), K2(S) et K3(S)

      IF (NIV.GE.2) THEN
        CALL GKSIMP(RESULT,NNOFF,ZR(IADABS),IADRGK,NUM,IADGKS,
     &              NDEG,NDIMTE,IADGKI,EXTIM,TIME,IORD,IFM)
      END IF
C      
      CALL GETVIS('THETA','NUME_FOND',1,1,1,NUMFON,IBID)
      IF(LMELAS)THEN
        DO 39 I = 1,NNOFF
            GPMI(1)=NUMFON
            GPMI(2)=IORD
            GPMI(3)=I
            GPMR(1) = ZR(IADABS-1+I)
            GPMR(2) = ZR(IADGKS-1+6*(I-1)+2)
            GPMR(3) = ZR(IADGKS-1+6*(I-1)+3)
            GPMR(4) = ZR(IADGKS-1+6*(I-1)+4)
            GPMR(5) = ZR(IADGKS-1+6*(I-1)+1)
            GPMR(6) = ZR(IADGKS-1+6*(I-1)+6)
            GPMR(7) = ZR(IADGKS-1+6*(I-1)+5)
            CALL TBAJLI(RESULT,NBPRUP,NOPRUP,GPMI,GPMR,CBID,NOMCAS,0)
 39     CONTINUE
      ELSE
        DO 40 I = 1,NNOFF
            GPMI(1)=NUMFON
            GPMI(2)=IORD
            GPMI(3)=I
            GPMR(1) = TIME
            GPMR(2) = ZR(IADABS-1+I)
            GPMR(3) = ZR(IADGKS-1+6*(I-1)+2)
            GPMR(4) = ZR(IADGKS-1+6*(I-1)+3)
            GPMR(5) = ZR(IADGKS-1+6*(I-1)+4)
            GPMR(6) = ZR(IADGKS-1+6*(I-1)+1)
            GPMR(7) = ZR(IADGKS-1+6*(I-1)+6)
            GPMR(8) = ZR(IADGKS-1+6*(I-1)+5)
            CALL TBAJLI(RESULT,NBPRUP,NOPRUP,GPMI,GPMR,CBID,K1BID,0)
 40     CONTINUE
      ENDIF

C- DESTRUCTION D'OBJETS DE TRAVAIL

      CALL JEDETR(ABSCUR)
      CALL JEDETR('&&CAKG3D.VALGK_S')
      CALL JEDETR('&&CAKG3D.VALGKI')
      CALL DETRSD('CHAMP_GD',CHVARC)
      CALL DETRSD('CHAMP_GD',CHVREF)
      CALL DETRSD('CHAMP_GD',CHVOLU)
      CALL DETRSD('CHAMP_GD',CF1D2D)
      CALL DETRSD('CHAMP_GD',CF2D3D)
      CALL DETRSD('CHAMP_GD',CHPRES)
      CALL DETRSD('CHAMP_GD',CHEPSI)
      CALL DETRSD('CHAMP_GD',CHPESA)
      CALL DETRSD('CHAMP_GD',CHROTA)

      CALL JEDETR('&&CAKG3D.VALG')

      CALL JEDEMA()
      END
