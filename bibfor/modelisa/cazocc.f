      SUBROUTINE CAZOCC(CHAR  ,MOTFAC,IZONE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  CHAR
      CHARACTER*16 MOTFAC
      INTEGER      IZONE
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - LECTURE DONNEES)
C
C LECTURE DES PRINCIPALES CARACTERISTIQUES DU CONTACT (SURFACE IZONE)
C REMPLISSAGE DE LA SD 'DEFICO' (SURFACE IZONE)
C
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'ZONE')
C IN  IZONE  : INDICE POUR LIRE LES DONNEES DANS AFFE_CHAR_MECA
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      CFMMVD,ZCMCF,ZEXCL
      CHARACTER*24 DEFICO
      INTEGER      NOC,NOCC
      CHARACTER*8  COMPLI,FONFIS,RACSUR,INDUSU,PIVOT
      CHARACTER*24 CARACF,EXCLFR
      INTEGER      JCMCF,JEXCLF
      CHARACTER*16 GLIS,SGRNO,INTEG,STACO0,ALGOC,ALGOF
      REAL*8       DIR(3),COEFFF,REACSI
      REAL*8       COEFAF,COEFAC
      REAL*8       ALGOCR,ALGOFR
      REAL*8       KWEAR,HWEAR
      REAL*8       ASPER,KAPPAN,KAPPAV
      LOGICAL      LINTNO,LFROT,LSSCON,LSSFRO,LEXDIR,MMINFL,CFDISL
      INTEGER      PARING
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'
      COEFAF = 100.D0
      COEFAC = 100.D0
      COEFFF = 0.D0
      KWEAR  = 0.D0
      HWEAR  = 0.D0
      ASPER  = 0.D0
      KAPPAN = 0.D0
      KAPPAV = 0.D0
      ALGOCR = 0.D0
      ALGOFR = 0.D0
      REACSI = -1.0D+6
      LINTNO = .FALSE.
      LFROT  = .FALSE.
      LSSCON = .FALSE.
      LSSFRO = .FALSE.
      ALGOC  = 'STANDARD'
      ALGOF  = 'STANDARD'
      LFROT  = CFDISL(DEFICO,'FROTTEMENT')
      PARING = 0
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      CARACF = DEFICO(1:16)//'.CARACF'
      EXCLFR = DEFICO(1:16)//'.EXCLFR'
C
      CALL JEVEUO(CARACF,'E',JCMCF )
      CALL JEVEUO(EXCLFR,'E',JEXCLF)
C
      ZCMCF = CFMMVD('ZCMCF')
      ZEXCL = CFMMVD('ZEXCL')
C
C --- TYPE INTEGRATION
C
      CALL GETVTX(MOTFAC,'INTEGRATION',IZONE,IARG,1,INTEG,NOC)
      IF (INTEG(1:5) .EQ. 'NOEUD') THEN
        LINTNO = .TRUE.
        ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 1.D0
      ELSE IF (INTEG(1:5) .EQ. 'GAUSS') THEN
        CALL GETVIS(MOTFAC,'ORDRE_INT',IZONE,IARG,1,PARING,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 10.D0*PARING + 2.D0
      ELSE IF (INTEG(1:7) .EQ. 'SIMPSON') THEN
        IF (INTEG(1:8) .EQ. 'SIMPSON1') THEN
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 23.D0
        ELSE IF (INTEG(1:8) .EQ. 'SIMPSON2') THEN
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 43.D0
        ELSE
            CALL GETVIS(MOTFAC,'ORDRE_INT',IZONE,IARG,1,PARING,NOC)
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 10.D0*PARING + 3.D0
C---- SI SIMPSON ORDRE 1, LES POINTS D'INTEGRATION SONT AUX NOEUDS
            IF (ZR(JCMCF+ZCMCF*(IZONE-1)+1-1).EQ.13) LINTNO = .TRUE.
        END IF
      ELSE IF (INTEG(1:6) .EQ. 'NCOTES') THEN
        IF (INTEG(1:7) .EQ. 'NCOTES1') THEN
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 54.D0
        ELSE IF (INTEG(1:7) .EQ. 'NCOTES2') THEN
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 84.D0
        ELSE
            CALL GETVIS(MOTFAC,'ORDRE_INT',IZONE,IARG,1,PARING,NOC)
            ZR(JCMCF+ZCMCF*(IZONE-1)+1-1) = 10.D0*PARING + 4.D0
        END IF
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- OPTIONS ALGORITHME CONTACT
C
      CALL GETVTX(MOTFAC,'ALGO_CONT',IZONE,IARG,1,ALGOC,NOC)

      IF (ALGOC(1:10) .EQ. 'STANDARD') THEN
        CALL GETVR8(MOTFAC,'COEF_CONT',IZONE,IARG,1,COEFAC,NOC)
        ALGOCR = 1.D0
      ELSEIF (ALGOC(1:14) .EQ. 'PENALISATION') THEN
        CALL GETVR8(MOTFAC,'COEF_PENA_CONT',IZONE,IARG,1,COEFAC,NOC)
        ALGOCR = 3.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      ZR(JCMCF+ZCMCF*(IZONE-1)+2-1)  = COEFAC
      ZR(JCMCF+ZCMCF*(IZONE-1)+28-1) = ALGOCR
C
C --- OPTIONS ALGORITHME FROTTEMENT
C
      IF (LFROT) THEN
        CALL GETVTX(MOTFAC,'ALGO_FROT',IZONE,IARG,1,ALGOF,NOC)
        IF (ALGOF(1:10) .EQ. 'STANDARD') THEN
          CALL GETVR8(MOTFAC,'COEF_FROT',IZONE,IARG,1,COEFAF,NOC)
          ALGOFR = 1.D0
        ELSEIF (ALGOF(1:14) .EQ. 'PENALISATION') THEN
          CALL GETVR8(MOTFAC,'COEF_PENA_FROT',IZONE,IARG,1,COEFAF,NOC)
          ALGOFR = 3.D0
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE
        COEFAF = 0.D0
        ALGOFR = 0.D0
      ENDIF
      ZR(JCMCF+ZCMCF*(IZONE-1)+3-1)  = COEFAF
      ZR(JCMCF+ZCMCF*(IZONE-1)+29-1) = ALGOFR
C
C --- CARACTERISTIQUES DU FROTTEMENT
C
      IF (LFROT) THEN
        CALL GETVR8(MOTFAC,'COULOMB',IZONE,IARG,1,COEFFF,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+4-1) = COEFFF
        CALL GETVR8(MOTFAC,'SEUIL_INIT',IZONE,IARG,1,REACSI,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+6-1) = REACSI
C       FROTTEMENT PAR ZONE
        IF (COEFFF.EQ.0.D0) THEN
          ZR(JCMCF+ZCMCF*(IZONE-1)+5-1) = 1.D0
        ELSE
          ZR(JCMCF+ZCMCF*(IZONE-1)+5-1) = 3.D0
        ENDIF
      ELSE
        ZR(JCMCF+ZCMCF*(IZONE-1)+5-1) = 1.D0
      END IF
C
C --- LECTURE DES PARAMETRES DE LA COMPLIANCE
C
      CALL GETVTX(MOTFAC,'COMPLIANCE',IZONE,IARG,1,COMPLI,NOC)
      IF (COMPLI .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+7-1) = 1.D0
        CALL GETVR8(MOTFAC,'ASPERITE',IZONE,IARG,1,ASPER,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+8-1) = ASPER
        CALL GETVR8(MOTFAC,'E_N',IZONE,IARG,1,KAPPAN,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+9-1) = KAPPAN
        CALL GETVR8(MOTFAC,'E_V',IZONE,IARG,1,KAPPAV,NOC)
        ZR(JCMCF+ZCMCF*(IZONE-1)+10-1) = KAPPAV
      ELSEIF (COMPLI .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+7-1) = 0.D0
        ZR(JCMCF+ZCMCF*(IZONE-1)+8-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- LECTURE DES PARAMETRES DE LA LOI D'USURE
C
      IF (LFROT) THEN
        CALL GETVTX(MOTFAC,'USURE',IZONE,IARG,1,INDUSU,NOC)
        IF (INDUSU .EQ. 'ARCHARD') THEN
          ZR(JCMCF+ZCMCF*(IZONE-1)+13-1) = 1.D0
          CALL GETVR8(MOTFAC,'K',IZONE,IARG,1,KWEAR,NOC)
          ZR(JCMCF+ZCMCF*(IZONE-1)+14-1) = KWEAR
          CALL GETVR8(MOTFAC,'H',IZONE,IARG,1,HWEAR,NOC)
          ZR(JCMCF+ZCMCF*(IZONE-1)+15-1) = HWEAR
        ELSEIF (INDUSU .EQ. 'SANS') THEN
          ZR(JCMCF+ZCMCF*(IZONE-1)+13-1) = 0.D0
        ELSE
          CALL ASSERT(.FALSE.)
        END IF
      ENDIF
C
C --- TRAITEMENT EXCLUSION NOEUDS
C
      CALL GETVTX(MOTFAC,'SANS_GROUP_NO'   ,IZONE,IARG,1,SGRNO,NOC)
      CALL GETVTX(MOTFAC,'SANS_NOEUD'      ,IZONE,IARG,1,SGRNO,NOCC)
      LSSCON = (NOC.NE.0)  .OR. (NOCC.NE.0)
C
      CALL GETVTX(MOTFAC,'SANS_GROUP_MA'   ,IZONE,IARG,1,SGRNO,NOC)
      CALL GETVTX(MOTFAC,'SANS_MAILLE'     ,IZONE,IARG,1,SGRNO,NOCC)
      LSSCON = LSSCON.OR.((NOC.NE.0).OR.(NOCC.NE.0))
C
      IF (LSSCON) THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+23-1) = 1.D0
      ELSE
        ZR(JCMCF+ZCMCF*(IZONE-1)+23-1) = 0.D0
      ENDIF
C
      CALL GETVTX(MOTFAC,'SANS_GROUP_NO_FR',IZONE,IARG,1,SGRNO,NOC)
      CALL GETVTX(MOTFAC,'SANS_NOEUD_FR'   ,IZONE,IARG,1,SGRNO,NOCC)
      LSSFRO = (NOC.NE.0) .OR. (NOCC.NE.0)
C
      IF (LSSFRO) THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+24-1) = 1.D0
      ELSE
        ZR(JCMCF+ZCMCF*(IZONE-1)+24-1) = 0.D0
      ENDIF
C
C --- SI NOEUD EXCLUS, ON VERIFIE QU'ON A UNE INTEGRATION AUX NOEUDS
C
      IF (.NOT.LINTNO) THEN
        IF (LSSCON .OR. LSSFRO) THEN
          CALL U2MESS('F','CONTACT_97')
        ENDIF
        IF (.NOT.MMINFL(DEFICO,'MAIT',IZONE )) THEN
          CALL U2MESS('F','CONTACT_98')
        ENDIF
      ENDIF
C
C --- NOMBRE DE DIRECTIONS A EXCLURE ET VECTEUR DIRECTEUR
C
      IF (LSSFRO) THEN
        CALL GETVR8(MOTFAC,'DIRE_EXCL_FROT',IZONE,IARG,3,DIR,NOC)
        LEXDIR = (NOC .NE. 0)
        IF (.NOT.LEXDIR) THEN
C ------- TOUTES LES DIRECTIONS SONT EXCLUES
          ZR(JCMCF+ZCMCF*(IZONE-1)+25-1) = 2.D0
        ELSE
C ------- UNE SEULE DIRECTION EST EXCLUE
          ZR(JCMCF+ZCMCF*(IZONE-1)+25-1) = 1.D0
          ZR(JEXCLF+ZEXCL*(IZONE-1)-1+1) = DIR(1)
          ZR(JEXCLF+ZEXCL*(IZONE-1)-1+2) = DIR(2)
          ZR(JEXCLF+ZEXCL*(IZONE-1)-1+3) = DIR(3)
        ENDIF
      ENDIF
C
      CALL GETVTX(MOTFAC,'FOND_FISSURE',IZONE,IARG,1,FONFIS,NOC)
      IF (FONFIS .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+11-1) = 1.D0
      ELSEIF (FONFIS .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+11-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      CALL GETVTX(MOTFAC,'RACCORD_LINE_QUAD',IZONE,IARG,1,RACSUR,NOC)
      IF (RACSUR .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+12-1) = 1.D0
      ELSEIF (RACSUR .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+12-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      IF ( (RACSUR .EQ. 'OUI').AND.(FONFIS .EQ. 'OUI')) THEN
        CALL U2MESS('F','CONTACT_95')
      ENDIF

C
      CALL GETVTX(MOTFAC,'EXCLUSION_PIV_NUL',IZONE,IARG,1,PIVOT,NOC)
      IF (PIVOT .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+22-1) = 1.D0
      ELSEIF (PIVOT .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+22-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- CONTACT INITIAL
C
      CALL GETVTX(MOTFAC,'CONTACT_INIT',IZONE,IARG,1,STACO0,NOC)
      IF (STACO0 .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+26-1) = 1.D0
      ELSEIF (STACO0 .EQ. 'INTERPENETRE') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+26-1) = 2.D0
      ELSEIF (STACO0 .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+26-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- GLISSIERE
C
      CALL GETVTX(MOTFAC,'GLISSIERE',IZONE,IARG,1,GLIS  ,NOC   )
      IF (GLIS(1:3) .EQ. 'OUI') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+27-1) = 1.D0
      ELSEIF (GLIS(1:3) .EQ. 'NON') THEN
        ZR(JCMCF+ZCMCF*(IZONE-1)+27-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
