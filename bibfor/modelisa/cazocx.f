      SUBROUTINE CAZOCX(CHAR  ,NOMO  ,MOTFAC,IZONE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 15/03/2010   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  CHAR,NOMO
      CHARACTER*16 MOTFAC
      INTEGER      IZONE
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEM - LECTURE DONNEES)
C
C LECTURE DES PRINCIPALES CARACTERISTIQUES DU CONTACT PAR ZONE
C
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMO   : NOM DU MODELE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
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
      CHARACTER*24 DEFICO
      CHARACTER*24 MODCON,CARAXF
      INTEGER      JMOCO ,JCMXF
      INTEGER      CFMMVD,ZCMXF
      CHARACTER*16 INTEG,ALGOLA,GLIS
      CHARACTER*16 ALGOC,ALGOF,STACO0
      INTEGER      NOC
      REAL*8       COEFCR,COEFCS,COEFCP
      REAL*8       COEFFR,COEFFS,COEFFP
      REAL*8       COEFFF,REACSI,COECHE,COEF,TOLJ
      CHARACTER*16 VALK(2)
      INTEGER      IRET,JXC
      LOGICAL      LFROT,CFDISL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'
      TOLJ   = 0.D0
      COEFCR = 100.D0
      COEFCS = 100.D0
      COEFCP = 100.D0
      COEFFR = 100.D0
      COEFFS = 100.D0
      COEFFP = 100.D0
      COEFFF = 0.D0
      REACSI = 0.D0
      COECHE = 1.D0
      INTEG  = 'FPG4'
      ALGOLA = 'NON'
      ALGOC  = 'STANDARD'
      ALGOF  = 'STANDARD'
      LFROT  = .FALSE.
      LFROT  = CFDISL(DEFICO,'FROTTEMENT')
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      CARAXF = DEFICO(1:16)//'.CARAXF'
      MODCON = DEFICO(1:16)//'.MODELX'
C
      CALL JEVEUO(CARAXF,'E',JCMXF )
      CALL JEVEUO(MODCON,'E',JMOCO )
C
      ZCMXF  = CFMMVD('ZCMXF')
C
C --- TEST MODELE CORRECT
C
      CALL EXIXFE(NOMO  ,IRET)
C
      IF (IRET.EQ.0) THEN
        VALK(1) = NOMO
        CALL U2MESK('F','XFEM2_8',1,VALK)
      ELSE
        CALL JEVEUO(NOMO(1:8)//'.XFEM_CONT','L',JXC)
        IF (ZI(JXC).EQ.0) THEN
          VALK(1) = NOMO
          CALL U2MESK('F','XFEM2_9',1,VALK)
        ENDIF
      ENDIF
C
C --- STOCKAGE DU NOM DU MODELE
C
      ZK8(JMOCO) = NOMO
C
C --- TYPE INTEGRATION
C
      CALL GETVTX(MOTFAC,'INTEGRATION',IZONE,1,1,INTEG,NOC)
      IF (INTEG(1:5) .EQ. 'NOEUD') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 1.D0
      ELSEIF (INTEG.EQ.'GAUSS') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 2.D0
      ELSEIF (INTEG.EQ.'SIMPSON') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 3.D0
      ELSEIF (INTEG.EQ.'SIMPSON1') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 4.D0
      ELSEIF (INTEG.EQ.'NCOTES') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 6.D0
      ELSEIF (INTEG.EQ.'NCOTES1') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 7.D0
      ELSEIF (INTEG.EQ.'NCOTES2') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 8.D0
      ELSEIF (INTEG.EQ.'FPG2') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 12.D0
      ELSEIF (INTEG.EQ.'FPG3') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 13.D0
      ELSEIF (INTEG.EQ.'FPG4') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 14.D0
      ELSEIF (INTEG.EQ.'FPG6') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 16.D0
      ELSEIF (INTEG.EQ.'FPG7') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+1-1) = 17.D0
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- OPTIONS ALGORITHME CONTACT
C
      CALL GETVTX(MOTFAC,'ALGO_CONT',IZONE,1,1,ALGOC,NOC)
      IF (ALGOC(1:10) .EQ. 'STANDARD') THEN
        CALL GETVR8(MOTFAC,'COEF_CONT',IZONE,1,1,COEF  ,NOC)
        COEFCR = COEF
        COEFCS = COEF
        COEFCP = COEF
      ELSEIF (ALGOC(1:10) .EQ. 'AVANCE') THEN
        CALL GETVR8(MOTFAC,'COEF_REGU_CONT',IZONE,1,1,COEFCR,NOC)
        CALL GETVR8(MOTFAC,'COEF_STAB_CONT',IZONE,1,1,COEFCS,NOC)
        CALL GETVR8(MOTFAC,'COEF_PENA_CONT',IZONE,1,1,COEFCP,NOC)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      ZR(JCMXF+ZCMXF*(IZONE-1)+2-1)  = COEFCR
      ZR(JCMXF+ZCMXF*(IZONE-1)+11-1) = COEFCS
      ZR(JCMXF+ZCMXF*(IZONE-1)+12-1) = COEFCP
C
C --- OPTIONS ALGORITHME FROTTEMENT
C
      IF (LFROT) THEN
        CALL GETVTX(MOTFAC,'ALGO_FROT',IZONE,1,1,ALGOF,NOC)
        IF (ALGOF(1:10) .EQ. 'STANDARD') THEN
          CALL GETVR8(MOTFAC,'COEF_FROT',IZONE,1,1,COEF  ,NOC)
          COEFFR = COEF
          COEFFS = COEF
          COEFFP = COEF
        ELSEIF (ALGOF(1:10) .EQ. 'AVANCE') THEN
          CALL GETVR8(MOTFAC,'COEF_REGU_FROT',IZONE,1,1,COEFFR,NOC)
          CALL GETVR8(MOTFAC,'COEF_STAB_FROT',IZONE,1,1,COEFFS,NOC)
          CALL GETVR8(MOTFAC,'COEF_PENA_FROT',IZONE,1,1,COEFFP,NOC)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE
        COEFFR = 0.D0
        COEFFS = 0.D0
        COEFFP = 0.D0
      ENDIF

      ZR(JCMXF+ZCMXF*(IZONE-1)+3-1) = COEFFR
      ZR(JCMXF+ZCMXF*(IZONE-1)+13-1) = COEFFS
      ZR(JCMXF+ZCMXF*(IZONE-1)+14-1) = COEFFP
C
C --- CARACTERISTIQUES DU FROTTEMENT
C
      IF (LFROT) THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+5-1) = 3.D0
        CALL GETVR8(MOTFAC,'COULOMB',IZONE,1,1,COEFFF,NOC)
        ZR(JCMXF+ZCMXF*(IZONE-1)+4-1) = COEFFF
        CALL GETVR8(MOTFAC,'SEUIL_INIT',IZONE,1,1,REACSI,NOC)
        ZR(JCMXF+ZCMXF*(IZONE-1)+6-1) = REACSI
      ELSE
        ZR(JCMXF+ZCMXF*(IZONE-1)+5-1) = 1.D0
      END IF
C
C --- CONTACT INITIAL
C
      CALL GETVTX(MOTFAC,'CONTACT_INIT',IZONE,1,1,STACO0,NOC)
      IF (STACO0 .EQ. 'OUI') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+7-1) = 1.D0
      ELSEIF (STACO0 .EQ. 'NON') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+7-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- COEFFICIENT DE MISE A L'ECHELLE DES TERMES DE PRESSION DE CONTACT
C
      CALL GETVR8(MOTFAC,'COEF_ECHELLE',1,1,1,COECHE,NOC)
      ZR(JCMXF+ZCMXF*(IZONE-1)+8-1) = COECHE
C
C --- ALGORITHME DE RESTRICTION DE L'ESPACE DES MULITPLICATEURS
C
      CALL GETVTX(MOTFAC,'ALGO_LAGR',1,1,1,ALGOLA,NOC)
      IF (ALGOLA.EQ.'NON') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+9-1) = 0.D0
      ELSEIF (ALGOLA.EQ.'VERSION1') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+9-1) = 1.D0
      ELSEIF (ALGOLA.EQ.'VERSION2') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+9-1) = 2.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- PARAMETRE APPARIEMENT: TOLE_PROJ_EXT
C --- TOLE_PROJ_EXT <0: LA PROJECTION HORS DE LA MAILLE EST INTERDITE
C --- TOLE_PROJ_EXT >0: LA PROJECTION HORS DE LA MAILLE EST AUTORISEE
C ---                    MAIS LIMITEE PAR TOLJ
C
      CALL GETVR8(MOTFAC,'TOLE_PROJ_EXT',IZONE,1,1,TOLJ,NOC)
      IF (TOLJ .LT. 0.D0) THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+15-1) = -1.D0
      ELSE
        ZR(JCMXF+ZCMXF*(IZONE-1)+15-1) = TOLJ
      ENDIF
C
C --- GLISSIERE
C
      CALL GETVTX(MOTFAC,'GLISSIERE',IZONE,1,1,GLIS  ,NOC   )
      IF (GLIS(1:3) .EQ. 'OUI') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+10-1) = 1.D0
      ELSEIF (GLIS(1:3) .EQ. 'NON') THEN
        ZR(JCMXF+ZCMXF*(IZONE-1)+10-1) = 0.D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
