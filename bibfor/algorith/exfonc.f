      SUBROUTINE EXFONC(FONACT,PARMET,SOLVEU,DEFICO,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/04/2010   AUTEUR JAUBERT A.JAUBERT 
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
      INTEGER      FONACT(*)
      CHARACTER*19 SOLVEU,SDDYNA
      CHARACTER*24 DEFICO
      REAL*8       PARMET(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C FONCTIONNALITES INCOMPATIBLES
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  SOLVEU : NOM DU SOLVEUR DE NEWTON
C IN  SDDYNA : SD DYNAMIQUE
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  FONACT : FONCTIONNALITES SPECIFIQUES ACTIVEES
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
      INTEGER      IBID,NBPROC,REINCR
      INTEGER      JSOLVE
      LOGICAL      ISFONC,NDYNLO,CFDISL
      LOGICAL      LFETI,LCTCC,LCTCD,LPILO,LRELI,LMACR,LUNIL
      LOGICAL      LCTCV,LMVIB,LFLAM,LEXPL,LCONT,LXFEM,LMATRF
      LOGICAL      LMUMPS,LGCPC,LRCMK,LMUMPD,LSYME,LIMPEX
      LOGICAL      LONDE,LDYNA,LSENS,REAROT,LTHETA,LPENA
      INTEGER      IFM,NIV,RANG
C
C ---------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- FONCTIONNALITES ACTIVEES
C
      LFETI  = ISFONC(FONACT,'FETI')
      LXFEM  = ISFONC(FONACT,'XFEM')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU')
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LCONT  = ISFONC(FONACT,'CONTACT')
      LUNIL  = ISFONC(FONACT,'LIAISON_UNILATER')
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LRELI  = ISFONC(FONACT,'RECH_LINE')
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')
      LMVIB  = ISFONC(FONACT,'MODE_VIBR')
      LFLAM  = ISFONC(FONACT,'CRIT_FLAMB')
      LONDE  = NDYNLO(SDDYNA,'ONDE_PLANE')
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE')
      LSENS  = ISFONC(FONACT,'SENSIBILITE')
      REAROT = ISFONC(FONACT,'REAROT')
      LTHETA = NDYNLO(SDDYNA,'THETA_METHODE')
      LIMPEX = ISFONC(FONACT,'IMPL_EX')
C
C --- INITIALISATIONS
C
      REINCR = NINT(PARMET(1))
C
C --- TYPE DE SOLVEUR
C
      CALL  JEVEUO(SOLVEU//'.SLVK','E',JSOLVE)
      LMUMPS = .FALSE.
      LGCPC  = .FALSE.
      LRCMK  = .FALSE.
      LMUMPD = .FALSE.
      IF (ZK24(JSOLVE)(1:4).EQ.'GCPC') THEN
        LGCPC = .TRUE.
        IF (ZK24(JSOLVE-1+4).EQ.'RCMK') THEN
          LRCMK = .TRUE.
        ENDIF
      ENDIF
      IF (ZK24(JSOLVE)(1:5).EQ.'MUMPS') THEN
        LMUMPS = .TRUE.
        IF (ZK24(JSOLVE+6)(1:4).EQ.'DIST') THEN
          LMUMPD = .TRUE.
        ENDIF
      ENDIF
      LSYME  = ZK24(JSOLVE+4).EQ.'OUI'
      IF (LMUMPD) THEN
        CALL INFNIV(IFM,NIV)
        CALL MPICM0(RANG,NBPROC)
      ENDIF
C
C --- FETI
C
      IF (LFETI) THEN
        IF (LMACR) THEN
          CALL U2MESS('F','MECANONLINE3_70')
        ENDIF
        IF (LONDE) THEN
          CALL U2MESS('F','MECANONLINE3_71')
        ENDIF
        IF (LDYNA) THEN
          CALL U2MESS('F','MECANONLINE3_73')
        ENDIF
        IF (LSENS) THEN
          CALL U2MESS('F','MECANONLINE3_75')
        ENDIF
        IF (LCTCD) THEN
          CALL U2MESS('F','MECANONLINE3_78')
        ENDIF
        IF (LCTCC) THEN
          CALL U2MESS('F','MECANONLINE3_79')
        ENDIF
      ENDIF
C
C --- CONTACT DISCRET
C
      IF (LCTCD) THEN
        LMATRF = CFDISL(DEFICO,'MATR_FROT')
        LCTCV  = CFDISL(DEFICO,'CONT_VERIF')
        LPENA  = CFDISL(DEFICO,'CONT_PENA')
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE_43')
        ENDIF
        IF (LRELI.AND.(.NOT.LCTCV)) THEN
          CALL U2MESS('A','MECANONLINE3_89')
        ENDIF
        IF (LGCPC) THEN
          IF (.NOT.(LCTCV.OR.LPENA)) THEN
            CALL U2MESS('F','MECANONLINE3_90')
          ENDIF
        ENDIF
        IF (REINCR.EQ.0) THEN
          IF (LMATRF) THEN
            CALL U2MESS('F','CONTACT_88')
          ENDIF
        ENDIF
C       ON FORCE SYME='OUI' AVEC LE CONTACT DISCRET
        IF (.NOT.(LSYME.OR.LCTCV)) THEN
          ZK24(JSOLVE+4)='OUI'
          CALL U2MESS('A','CONTACT_1')
        ENDIF
      ENDIF
C
C --- CONTACT CONTINU
C
      IF (LCTCC) THEN
        IF (LPILO.AND.(.NOT.LXFEM)) THEN
C         LEVEE D INTERDICTION TEMPORAIRE POUR X-FEM
          CALL U2MESS('F','MECANONLINE3_92')
        ENDIF
        IF (LRELI) THEN
          CALL U2MESS('F','MECANONLINE3_91')
        ENDIF
        IF (LGCPC) THEN
          IF (LRCMK) THEN
            CALL U2MESS('F','MECANONLINE3_93')
          ENDIF
        ENDIF
      ENDIF
C
C --- LIAISON UNILATERALE
C
      IF (LUNIL) THEN
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE3_94')
        ENDIF
        IF (LRELI) THEN
          CALL U2MESS('A','MECANONLINE3_95')
        ENDIF
        IF (LGCPC) THEN
          CALL U2MESS('A','MECANONLINE3_96')
        ENDIF
      ENDIF
C
C --- CALCUL DE MODES/FLAMBEMENT: PAS MUMPS, PAS GCPC
C
      IF (LMVIB.OR.LFLAM) THEN
        IF (LMUMPS.OR.LGCPC) THEN
          CALL U2MESS('F','FACTOR_52')
        ENDIF
      ENDIF
C
C --- EXPLICITE
C
      IF (LEXPL) THEN
        IF (LCONT) THEN
          CALL U2MESS('F','MECANONLINE5_22')
        ENDIF
        IF (LUNIL) THEN
          CALL U2MESS('F','MECANONLINE5_23')
        ENDIF
        IF (REAROT) THEN
          CALL U2MESS('A','MECANONLINE5_24')
        ENDIF
      ENDIF
C
C --- DYNAMIQUE
C
      IF (LDYNA) THEN
        IF (LPILO) THEN
          CALL U2MESS('F','MECANONLINE5_25')
        ENDIF
        IF (LRELI) THEN
          CALL U2MESS('F','MECANONLINE5_26')
        ENDIF
        IF (LTHETA) THEN
          IF (REAROT) THEN
            CALL U2MESS('F','MECANONLINE5_27')
          ENDIF
        ENDIF
        IF (LXFEM) THEN
          CALL U2MESS('F','MECANONLINE5_28')
        ENDIF
        IF (LIMPEX) THEN
          CALL U2MESS('F','MECANONLINE5_33')
        ENDIF
      ENDIF
C
      CALL JEDEMA()
      END
