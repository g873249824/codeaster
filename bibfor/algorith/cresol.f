      SUBROUTINE CRESOL(SOLVEU,KBID)
      IMPLICIT   NONE

      CHARACTER*19 SOLVEU
      CHARACTER*(*) KBID
C ----------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     CREATION D'UNE SD_SOLVEUR PAR LECTURE DU MOT CLE SOLVEUR

C IN/JXOUT K19 SOLVEU  : SD_SOLVEUR
C IN       K*  KBID    : INUTILISE
C ----------------------------------------------------------------------
C RESPONSABLE VABHHTS J.PELLET
C TOLE CRP_20

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------

      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --- FIN DECLARATIONS NORMALISEES JEVEUX --------------------

      INTEGER      ISTOP,NSOLVE,IBID,NPREC,ILGRF,
     &             JLIR,ISLVK,ISLVR,ISLVI
      REAL*8       EPSMAT
      CHARACTER*3  SYME,MIXPRE,KMD
      CHARACTER*8  KSTOP,MODELE
      CHARACTER*8  METHOD,LISINS,PARTIT
      CHARACTER*16 NOMSOL,TYPECO
      CHARACTER*19 LIGREL
      INTEGER      EXIMC,GETEXM
C------------------------------------------------------------------
      CALL JEMARQ()

C --- INITS. GLOBALES (CAR MOT-CLES OPTIONNELS)
      NOMSOL='SOLVEUR'
      SYME='NON'
      NPREC=8
      ISTOP=0
      KSTOP=' '
      EPSMAT=-1.D0
      MIXPRE='NON'
      KMD='NON'

      CALL GETFAC(NOMSOL,NSOLVE)
      IF (NSOLVE.EQ.0) GOTO 10
      CALL GETVTX(NOMSOL,'METHODE',1,1,1,METHOD,IBID)

C ------------------------------------------------------
C --- LECTURE BLOC COMMUN A TOUS LES SOLVEURS LINEAIRES
C --- CES PARAMETRES NE SONT PAS FORCEMENT UTILISES PAR
C --- TOUS LES OPERATEURS ET TOUS LES SOLVEURS
C ------------------------------------------------------

C ----- STOP SINGULIER/NPREC
      EXIMC=GETEXM(NOMSOL,'STOP_SINGULIER')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVTX(NOMSOL,'STOP_SINGULIER',1,1,1,KSTOP,IBID)
      ENDIF
      EXIMC=GETEXM(NOMSOL,'NPREC')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVIS(NOMSOL,'NPREC',1,1,1,NPREC,IBID)
        IF (KSTOP.EQ.'NON') THEN
          ISTOP=1
        ELSE IF (KSTOP.EQ.'DECOUPE') THEN
          CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,IBID)
          CALL GETTCO(LISINS,TYPECO)
          IF (TYPECO.EQ.'LIST_INST') THEN
            CALL JEVEUO(LISINS//'.LIST.INFOR','L',JLIR)
            IF (ZR(JLIR-1+7).NE.0) ISTOP = 1
          ENDIF
          IF (ISTOP.EQ.0) CALL U2MESS('F','ALGORITH11_81')
        ENDIF
      ENDIF

C ----- SYME
      EXIMC=GETEXM(NOMSOL,'SYME')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVTX(NOMSOL,'SYME',1,1,1,SYME,IBID)
      ENDIF

C ----- FILTRAGE_MATRICE
      EXIMC=GETEXM(NOMSOL,'FILTRAGE_MATRICE')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVR8(NOMSOL,'FILTRAGE_MATRICE',1,1,1,EPSMAT,IBID)
      ENDIF

C ----- MIXER PRECISION
      EXIMC=GETEXM(NOMSOL,'MIXER_PRECISION')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVTX(NOMSOL,'MIXER_PRECISION',1,1,1,MIXPRE,IBID)
      ENDIF

C ------ MATR_DISTRIBUEE
      EXIMC=GETEXM(NOMSOL,'MATR_DISTRIBUEE')
      IF (EXIMC .EQ. 1) THEN
        CALL GETVTX(NOMSOL,'MATR_DISTRIBUEE',1,1,1,KMD,IBID)
        CALL GETVID(' ','MODELE',1,1,1,MODELE,IBID)
        LIGREL=MODELE//'.MODELE'
        CALL JEVEUO(LIGREL//'.LGRF','L',ILGRF)
        PARTIT=ZK8(ILGRF-1+2)
        IF ( (PARTIT.EQ.' ').AND.(KMD.EQ.'OUI') ) THEN
          KMD='NON'
          CALL U2MESS('I','ASSEMBLA_3')
        ENDIF
      ENDIF

C ------------------------------------------------------
C --- CREATION DES TROIS COMPOSANTES DE LA SD_SOLVEUR
C     POUR FETI C'EST FAIT POUR LE DOMAINE GLOBAL ET CHAQUE SD
C     VIA CRSVFE/CRESO1
C ------------------------------------------------------
      IF (METHOD.NE.'FETI') THEN
        CALL WKVECT(SOLVEU//'.SLVK','V V K24',12,ISLVK)
        CALL WKVECT(SOLVEU//'.SLVR','V V R',4,ISLVR)
        CALL WKVECT(SOLVEU//'.SLVI','V V I',7,ISLVI)
      ENDIF

C ------------------------------------------------------
C --- LECTURE MOT-CLE ET REMPLISSAGE DE LA SD_SOLVEUR PROPRE A CHAQUE
C     SOLVEUR LINEAIRE
C ------------------------------------------------------

      IF (METHOD.EQ.'MUMPS') THEN
C     -----------------------------
        CALL CRSVMU(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ELSE IF (METHOD.EQ.'FETI') THEN
C     -----------------------------
        CALL CRSVFE(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ELSE IF (METHOD.EQ.'PETSC') THEN
C     -----------------------------
        CALL CRSVPE(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ELSE IF (METHOD.EQ.'LDLT') THEN
C     -----------------------------
        CALL CRSVLD(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ELSE IF (METHOD.EQ.'GCPC') THEN
C     -----------------------------
        CALL CRSVGC(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ELSE IF (METHOD.EQ.'MULT_FRO') THEN
C     -----------------------------
        CALL CRSVMF(NOMSOL,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,KMD)

      ENDIF


   10 CONTINUE

      CALL JEDEMA()
      END
