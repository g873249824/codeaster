      SUBROUTINE CAKG3D(OPTION,RESULT,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &                 NCHAR,LCHAR,SYMECH,CHFOND,NNOFF,BASLOC,COURB,
     &                 IORD,NDEG,THLAGR,GLAGR,MILIEU,THETA,ALPHA,EXTIM,
     &                 TIME,NBPRUP,NOPRUP)
      IMPLICIT  NONE

      INTEGER IORD,NCHAR,NBPRUP
      REAL*8 TIME,ALPHA
      CHARACTER*8 MODELE,THETAI,LCHAR(*)
      CHARACTER*8 RESULT,SYMECH
      CHARACTER*16 OPTION,NOPRUP(*)
      CHARACTER*24 DEPLA,CHFOND,MATE,COMPOR,THETA,BASLOC,COURB
      LOGICAL EXTIM,THLAGR,GLAGR,MILIEU

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2004   AUTEUR GALENNE E.GALENNE 
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

      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='CAKG3D')
      INTEGER I,J,IBID,IADRGK,IADGKS,IRET,JRESU,NCHIN, LNOFF
      INTEGER JTEMP,NNOFF,NUM,INCR,NRES,NSIG,NDEP
      INTEGER NDEG,NDIMTE,IERD,INIT,GPMI(2)
      INTEGER IADRNO,IADGKI,IADABS,IFM,NIV
      REAL*8  GKTHI(4),GPMR(6)
      COMPLEX*16 CBID
      LOGICAL EXIGEO,EXITHE,EXITRF,FONC,EPSI
      CHARACTER*1  K1BID
      CHARACTER*8  NOMA,K8BID,RESU,NOEUD
      CHARACTER*8  LPAIN(21),LPAOUT(1),REPK
      CHARACTER*16 OPTI,OPER
      CHARACTER*24 LIGRMO,TEMPE,CHGEOM,CHGTHI,CHROTA,CHPESA
      CHARACTER*24 CHTEMP,CHTREF,CF2D3D,CHPRES
      CHARACTER*24 LCHIN(21),LCHOUT(1),CHTHET,CHALPH,CHTIME
      CHARACTER*24 ABSCUR,NORMFF,PAVOLU,PAPRES,PA2D3D
      CHARACTER*24 CHSIG,CHEPSP,CHVARI,TYPE,PEPSIN
      CHARACTER*24 CHSIGI,CHDEPI,CHEPSI,CHVOLU,CF1D2D
C     ------------------------------------------------------------------

      CALL JEMARQ()
      OPER = 'CALC_G_LOCAL_T'
      CALL INFNIV(IFM,NIV)

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      NOMA = CHGEOM(1:8)

C- RECUPERATION DU COMPORTEMENT

      CALL GETFAC('COMP_INCR',INCR)
      IF (INCR.NE.0) THEN
        CALL GETVID(' ','RESULTAT',0,1,1,RESU,NRES)
        CALL DISMOI('F','TYPE_RESU',RESU,'RESULTAT',IBID,TYPE,IERD)
        IF (TYPE.NE.'EVOL_NOLI') THEN
          CALL UTMESS('F',OPER,'RESULTAT N''EST PAS EN EVOL_NOLI')
        END IF
        CALL RSEXCH(RESU,'SIEF_ELGA',IORD,CHSIG,IRET)
        IF (IRET.NE.0) THEN
          CALL UTMESS('F',NOMPRO,'CHAMP SIEF_ELGA NON TROUVE')
        END IF
        CALL RSEXCH(RESU,'EPSP_ELNO',IORD,CHEPSP,IRET)
        IF (IRET.NE.0) THEN
          CALL UTMESS('F',NOMPRO,'CHAMP EPSP_ELNO NON TROUVE')
        END IF
        CALL RSEXCH(RESU,'VARI_ELNO_ELGA',IORD,CHVARI,IRET)
        IF (IRET.NE.0) THEN
          CALL UTMESS('F',NOMPRO,'CHAMP VARI_ELNO_ELGA NON TROUVE')
        END IF
      END IF

C- RECUPERATION DE L'ETAT INITIAL

      CALL GETFAC('ETAT_INIT',INIT)
      IF (INIT.NE.0) THEN
        CALL GETVID('ETAT_INIT','SIGM',1,1,1,CHSIGI,NSIG)
        CALL GETVID('ETAT_INIT','DEPL',1,1,1,CHDEPI,NDEP)
        IF ((NSIG.EQ.0) .AND. (NDEP.EQ.0)) THEN
          CALL UTMESS('F',NOMPRO,'AUCUN CHAMP INITIAL TROUVE')
        END IF
      END IF

C- RECUPERATION (S'ILS EXISTENT) DES CHAMP DE TEMPERATURES (T,TREF)

      TEMPE = ' '
      CHTEMP = '&&CAKG3D.CH_TEMP_R'
      DO 10 I = 1,NCHAR
        CALL JEEXIN(LCHAR(I)//'.CHME.TEMPE.TEMP',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(LCHAR(I)//'.CHME.TEMPE.TEMP','L',JTEMP)
          TEMPE = ZK8(JTEMP)
        END IF
   10 CONTINUE
      CALL METREF(MATE,NOMA,EXITRF,CHTREF)
      CALL METEMP(NOMA,TEMPE,EXTIM,TIME,CHTREF,EXITHE,CHTEMP(1:19))
      CALL DISMOI('F','ELAS_F_TEMP',MATE,'CHAM_MATER',IBID,REPK,IERD)
      IF (REPK.EQ.'OUI') THEN
        IF (.NOT.EXITHE) THEN
          CALL UTMESS('F','CAKG3D',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                '! IL N''Y A PAS DE CHAMP DE TEMPERATURE '//
     &                '! LE CALCUL EST IMPOSSIBLE ')
        END IF
        IF (.NOT.EXITRF) THEN
          CALL UTMESS('A',' CAKG3D',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                ' IL N''Y A PAS DE TEMPERATURE DE REFERENCE'//
     &                ' ON PRENDRA DONC LA VALEUR 0')
        END IF
      END IF

C - TRAITEMENT DES CHARGES

      CALL GCHARG(MODELE,NCHAR,LCHAR,CHVOLU,CF1D2D,CF2D3D,CHPRES,CHEPSI,
     &            CHPESA,CHROTA,FONC,EPSI,TIME,IORD)
      IF (FONC) THEN
        PAVOLU = 'PFFVOLU'
C        PA2D3D = 'PFF2D3D'
C        PAPRES = 'PPRESSF'
        PEPSIN = 'PEPSINF'
        IF (OPTION.EQ.'CALC_K_G') THEN
          OPTI = 'CALC_K_G_F'
        END IF
      ELSE
        PAVOLU = 'PFRVOLU'
C        PA2D3D = 'PFR2D3D'
C        PAPRES = 'PPRESSR'
        PEPSIN = 'PEPSINR'
        OPTI = OPTION
      END IF

C- CREATION D'UN CHAMP DE PROPAGATION. UTILISE SEULEMENT POUR
C  UN CALCUL DE G_LOCAL AVEC PROPAGATION LAGRANGIENNE

      CALL MEALPH(NOMA,ALPHA,CHALPH)

C- CALCUL DES K(THETA_I) AVEC I=1,NDIMTE  NDIMTE = NNOFF  SI TH-LAGRANGE
C                                         NDIMTE = NDEG+1 SI TH-LEGENDRE
      IF (THLAGR) THEN
        NDIMTE = NNOFF
      ELSE
        NDIMTE = NDEG + 1
      END IF

      CALL WKVECT('&&CAKG3D.VALG','V V R8',NDIMTE*4,IADRGK)
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
        LPAIN(5) = 'PTEMPER'
        LCHIN(5) = CHTEMP
        LPAIN(6) = 'PTEREF'
        LCHIN(6) = CHTREF
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

        LIGRMO = MODELE//'.MODELE'
        NCHIN = 13
        
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
        
        CALL CALCUL('S',OPTI,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              'V')
        
C     BUT :  FAIRE LA "SOMME" D'UN CHAM_ELEM        
        CALL MESOMM(CHGTHI,4,IBID,GKTHI,CBID,0,IBID)
        
        DO 29 J=1,4
          ZR(IADRGK-1+(I-1)*4+J) = GKTHI(J)
 29     CONTINUE
        
 20   CONTINUE
  
C- CALCUL DE G(S), K1(S), K2(S) et K3(S)
C             SUR LE FOND DE FISSURE PAR 2 METHODES
C- PREMIERE METHODE : G_LEGENDRE ET THETA_LEGENDRE
C- DEUXIEME METHODE : G_LEGENDRE ET THETA_LAGRANGE
C- TROISIEME METHODE: G_LAGRANGE ET THETA_LAGRANGE
C    (OU G_LAGRANGE_NO_NO ET THETA_LAGRANGE)

      CALL WKVECT('&&CAKG3D.VALGK_S','V V R8',NNOFF*4,IADGKS)  
      CALL WKVECT('&&CAKG3D.VALGKI','V V R8',NNOFF*4,IADGKI) 
      ABSCUR='&&CAKG3D.TEMP     .ABSCU'       
      CALL WKVECT(ABSCUR,'V V R',NNOFF,IADABS)
      
      IF ((.NOT.GLAGR) .AND. (.NOT.THLAGR)) THEN
        NUM = 1        
        CALL GKMET1(NDEG,NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR)
            
      ELSE IF (THLAGR) THEN
C        NORMFF = ZK24(JRESU+NNOFF+1-1)
C        NORMFF(20:24) = '.VALE'
        IF (.NOT.GLAGR) THEN
          NUM = 2
          CALL UTMESS('F','CAKG3D','THLAG-GLEG PAS POSSIBLE')
C         CALL GMETH2(NDEG,NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR,NUM)
        ELSE
          NUM = 3
          CALL GKMET3(NNOFF,CHFOND,IADRGK,IADGKS,IADGKI,ABSCUR,NUM)
        END IF
      END IF

C- SYMETRIE DU CHARGEMENT ET IMPRESSION DES RESULTATS

      IF (SYMECH.NE.'SANS') THEN
        DO 30 I = 1,NNOFF*4
          ZR(IADGKS+I-1) = 2.D0*ZR(IADGKS+I-1)
   30   CONTINUE
      END IF

C- IMPRESSION ET ECRITURE DANS TABLE(S) DE G(S), K1(S), K2(S) et K3(S)

      IF (NIV.GE.2) THEN
        CALL GKSIMP(RESULT,NNOFF,ZR(IADABS),IADRGK,NUM,IADGKS,
     &              NDEG,IADGKI,EXTIM,TIME,IORD,IFM)        
      END IF
      
      DO 40 I = 1,NNOFF
          GPMI(1)=IORD
          GPMI(2)=I
          GPMR(1) = TIME
          GPMR(2) = ZR(IADABS-1+I)
          GPMR(3) = ZR(IADGKS-1+4*(I-1)+2)
          GPMR(4) = ZR(IADGKS-1+4*(I-1)+3)
          GPMR(5) = ZR(IADGKS-1+4*(I-1)+4)
          GPMR(6) = ZR(IADGKS-1+4*(I-1)+1)
        
        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,GPMI,GPMR,CBID,K1BID,0)
 40   CONTINUE
      
C- DESTRUCTION D'OBJETS DE TRAVAIL

      CALL JEDETR(ABSCUR)
      CALL JEDETR('&&CAKG3D.VALG_S')
      CALL JEDETR('&&CAKG3D.VALGI')
      CALL DETRSD('CHAMP_GD',CHTEMP)
      CALL JEDETR('&&CAKG3D.VALG') 
      
      CALL JEDEMA()
      END
