      SUBROUTINE NMFONC(PARCRI,PARMET,METHOD,SOLVEU,MODELE,
     &                  DEFICO,LISCHA,LCONT ,LUNIL ,SDNUME,
     &                  SDDYNA,SDCRIQ,MATE  ,COMPOZ,RESULT,
     &                  FONACT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/04/2013   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      INTEGER       FONACT(*)
      LOGICAL       LUNIL,LCONT
      CHARACTER*16  METHOD(*)
      REAL*8        PARCRI(*),PARMET(*)
      CHARACTER*19  SOLVEU,LISCHA,SDDYNA,SDNUME
      CHARACTER*24  SDCRIQ
      CHARACTER*24  MATE,MODELE
      CHARACTER*24  DEFICO
      CHARACTER*8   RESULT
      CHARACTER*(*) COMPOZ
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C FONCTIONNALITES ACTIVEES
C
C ----------------------------------------------------------------------
C
C IN  MODELE : MODELE MECANIQUE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  SDNUME : NOM DE LA SD NUMEROTATION
C IN  LCONT  : .TRUE. S'IL Y A DU CONTACT
C IN  LUNIL  : .TRUE. S'IL Y A LIAISON_UNILATER
C IN  SOLVEU : NOM DU SOLVEUR DE NEWTON
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDCRIQ : SD CRITERE QUALITE
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION
C IN  PARCRI : RESI_CONT_RELA VAUT R8VIDE SI NON ACTIF
C IN  METHOD : DESCRIPTION DE LA METHODE DE RESOLUTION
C IN  ZFON   : LONGUEUR DU VECTEUR FONACT
C IN  LISCHA : SD DE DEFINITION DES CHARGES
C IN  COMPOR : CARTE DE COMPORTEMENT
C IN  RESULT : STRUCTURE DONNEE RESULTAT
C OUT FONACT : FONCTIONNALITES SPECIFIQUES ACTIVEES (VOIR ISFONC)
C
C ----------------------------------------------------------------------
C
      INTEGER      NOCC,IRET,NBSS,NBSST,IBID
      INTEGER      NBFONC,CFDISI,IFORM,JSLVK
      LOGICAL      CFDISL,LBORS,LFROT,LCHOC,LALLV
      LOGICAL      LBOUCG,LBOUCF,LBOUCC
      INTEGER      JSOLVE,IXFEM,ICHAR,IFLAMB,IMVIBR,ISTAB,NMATDI
      LOGICAL      ISCHAR,ISDIRI
      LOGICAL      LSUIV,LLAPL,LCINE,LDIDI
      REAL*8       R8VIDE
      CHARACTER*8  K8BID,REPK
      CHARACTER*16 NOMCMD,K16BID,MATDIS
      CHARACTER*19 COMPOR
      CHARACTER*24 METRES,PRECON,ERRTHM
      LOGICAL      ISFONC,LSTAT,LDYNA,LGROT,LENDO,LARRNO
      LOGICAL      LNEWTC,LNEWTF,LNEWTG
      LOGICAL      NDYNLO,LEXPL
      INTEGER      IFM,NIV
      INTEGER      IARG,NSTA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      NBFONC = 0
      COMPOR = COMPOZ
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION VECTEUR '//
     &                'FONCTIONNALITES ACTIVEES: '
      ENDIF
C
C --- NOM DE LA COMMANDE: STAT_NON_LINE, DYNA_NON_LINE
C
      CALL GETRES(K8BID,K16BID,NOMCMD)
      LSTAT = NOMCMD(1:4).EQ.'STAT'
      LDYNA = NOMCMD(1:4).EQ.'DYNA'
      LEXPL = NDYNLO(SDDYNA,'EXPLICITE')
C
C --- ELEMENTS EN GRANDES ROTATIONS
C
      CALL JEEXIN(SDNUME(1:19)//'.NDRO',IRET)
      LGROT = IRET.NE.0
C
C --- ELEMENTS AVEC ENDO AUX NOEUDS
C
      CALL JEEXIN(SDNUME(1:19)//'.ENDO',IRET)
      LENDO = IRET.NE.0
C
C --- RECHERCHE LINEAIRE
C
      CALL GETFAC('RECH_LINEAIRE',NOCC)
      IF (NOCC.NE.0) THEN
        FONACT(1) = 1
      ENDIF
C
C --- PILOTAGE
C
      IF (LSTAT) THEN
        NOCC = 0
        CALL GETFAC('PILOTAGE',NOCC)
        IF (NOCC.NE.0) THEN
          FONACT(2) = 1
        ENDIF
      ENDIF
C
C --- LIAISON UNILATERALE
C
      IF (LUNIL) THEN
        FONACT(12) = 1
      ENDIF
C
C --- ENERGIE
C
      CALL GETFAC('ENERGIE',NOCC)
      IF (NOCC.NE.0) THEN
        FONACT(50) = 1
      ENDIF
C
C --- PROJ_MODAL
C
      IF (LDYNA) THEN
        CALL GETFAC('PROJ_MODAL',NOCC)
        IF (NOCC.NE.0) THEN
          FONACT(51) = 1
        ENDIF
      ENDIF
C
C --- MATR_DISTRIBUEE
C
      MATDIS='NON'
      CALL GETVTX('SOLVEUR','MATR_DISTRIBUEE',1,IARG,1,MATDIS,NMATDI)
      IF (MATDIS.EQ.'OUI') THEN
        FONACT(52) = 1
      ENDIF
C
C --- DEBORST ?
C
      CALL NMCPQU(COMPOR,'C_PLAN','DEBORST',LBORS )
      IF (LBORS) THEN
        FONACT(7) = 1
      ENDIF
C
C --- CONVERGENCE SUR CRITERE EN CONTRAINTE GENERALISEE
C
      IF (PARCRI(6).NE.R8VIDE()) THEN
        FONACT(8) = 1
      ENDIF
C
C --- CONVERGENCE SUR CRITERE NORME PAR FORC CMP
C
      IF (PARCRI(7).NE.R8VIDE()) THEN
        FONACT(35) = 1
        IF (LDYNA) CALL U2MESS('F','MECANONLINE5_53')
      ENDIF
C
C --- X-FEM
C
      CALL EXIXFE(MODELE,IXFEM )
      IF (IXFEM.NE.0) THEN
        FONACT(6) = 1
      ENDIF
C
C --- CONTACT / FROTTEMENT
C
      IF (LCONT) THEN
        IFORM  = CFDISI(DEFICO,'FORMULATION')
        IF (IFORM.EQ.2) THEN
          FONACT(5)  = 1
          FONACT(17) = CFDISI(DEFICO,'ALL_INTERPENETRE')
          FONACT(26) = 1
          LFROT      = CFDISL(DEFICO,'FROTTEMENT')
          IF (LFROT) THEN
            FONACT(10) = 1
            FONACT(27) = 1
          ENDIF
        ELSEIF (IFORM.EQ.3) THEN
          FONACT(9)  = 1
          FONACT(26) = 1
          LFROT      = CFDISL(DEFICO,'FROTTEMENT')
          IF (LFROT) THEN
            FONACT(25) = 1
            FONACT(27) = 1
          ENDIF
C --- GLUTE TANT QUE XFEM NE DISTINGUE PAS
C --- CONTACT/FROTTEMENT
          FONACT(27) = 1
        ELSEIF (IFORM.EQ.1) THEN
          FONACT(4)  = 1
          LFROT      = CFDISL(DEFICO,'FROTTEMENT')
          IF (LFROT) THEN
            FONACT(3)  = 1
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- MODE ALL VERIF
C
      IF (LCONT) THEN
        LALLV  = CFDISL(DEFICO,'ALL_VERIF')
        IF (LALLV) THEN
          FONACT(38) = 1
        ENDIF
      ENDIF
C
C --- BOUCLES EXTERNES CONTACT / FROTTEMENT
C
      IF (LCONT) THEN
C
        LBOUCG = .FALSE.
        LBOUCF = .FALSE.
        LBOUCC = .FALSE.
C
C ----- BOUCLE SUR GEOMETRIE
C
        LBOUCG = CFDISL(DEFICO,'GEOM_BOUCLE')
C
C ----- BOUCLE SUR FROTTEMENT
C
        IF (LFROT) LBOUCF = CFDISL(DEFICO,'FROT_BOUCLE')
C
C ----- BOUCLE SUR CONTACT
C
        LBOUCC = CFDISL(DEFICO,'CONT_BOUCLE')
C
C ----- TOUTES LES ZONES EN VERIF -> PAS DE BOUCLES
C
        LALLV  = CFDISL(DEFICO,'ALL_VERIF')
        IF (LALLV) THEN
          LBOUCC = .FALSE.
          LBOUCG = .FALSE.
          LBOUCF = .FALSE.
        ENDIF
C
C ----- CONTACT DISCRET -> PAS DE BOUCLES CONT/FROT
C
        IF (IFORM.EQ.1) THEN
          LBOUCC = .FALSE.
          LBOUCF = .FALSE.
        ENDIF
C
C ----- BOUCLES EXTERNES
C
        IF (LBOUCG) THEN
          FONACT(31) = 1
        ENDIF
        IF (LBOUCF) THEN
          FONACT(32) = 1
        ENDIF
        IF (LBOUCC) THEN
          FONACT(33) = 1
        ENDIF
C
        IF (LBOUCG.OR.LBOUCF.OR.LBOUCC) THEN
          FONACT(34) = 1
        ENDIF
      ENDIF
C
C --- NEWTON GENERALISE
C
      IF (LCONT) THEN
        IF (IFORM.EQ.2) THEN
          LNEWTG = CFDISL(DEFICO,'GEOM_NEWTON')
          LNEWTF = CFDISL(DEFICO,'FROT_NEWTON')
          LNEWTC = CFDISL(DEFICO,'CONT_NEWTON')
          IF (LNEWTF) FONACT(47) = 1
          IF (LNEWTC) FONACT(53) = 1
          IF (LNEWTG) FONACT(55) = 1
        ENDIF
      ENDIF
C
C --- FETI
C
      CALL  JEVEUO(SOLVEU//'.SLVK','L',JSOLVE)
      IF (ZK24(JSOLVE)(1:4).EQ.'FETI') THEN
        FONACT(11) = 1
      ELSE
        FONACT(11) = 0
      ENDIF
C
C --- AU MOINS UNE CHARGE SUIVEUSE
C
      ICHAR = 0
      LSUIV = ISCHAR(LISCHA,'NEUM','SUIV',ICHAR )
      IF (LSUIV) FONACT(13) = 1
C
C --- AU MOINS UNE CHARGE DE TYPE DIDI
C
      ICHAR = 0
      LDIDI = ISCHAR(LISCHA,'DIRI','DIDI',ICHAR )
      IF (LDIDI) FONACT(22) = 1
C
C --- AU MOINS UNE CHARGE DE TYPE DIRICHLET PAR
C --- ELIMINATION (AFFE_CHAR_CINE)
C
      LCINE = ISDIRI(LISCHA,'ELIM')
      IF (LCINE) FONACT(36) = 1
C
C --- AU MOINS UNE CHARGE DE TYPE FORCE DE LAPLACE
C
      LLAPL = ISCHAR(LISCHA,'NEUM','LAPL',ICHAR )
      IF (LLAPL) FONACT(20) = 1
C
C --- SOUS STRUCTURES STATIQUES
C
      CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8BID,IRET)
      IF (NBSS.GT.0) THEN
        FONACT(14) = 1
      ENDIF
C
C --- CALCUL PAR SOUS-STRUCTURATION
C
      CALL NMLSSV('LECT',LISCHA,NBSST)
      IF (NBSST.GT.0)THEN
        FONACT(24) = 1
      ENDIF
C
C --- ELEMENTS EN GRANDES ROTATIONS
C
      IF (LGROT) THEN
        FONACT(15) = 1
      ENDIF
C
C --- ELEMENTS AVEC ENDO AUX NOEUDS
C
      IF (LENDO) THEN
        FONACT(40) = 1
      ENDIF
C
C --- CALCUL DE FLAMBEMENT
C
      IFLAMB = 0
      CALL GETFAC('CRIT_STAB',IFLAMB)
      IF (IFLAMB.GT.0) THEN
        FONACT(18) = 1
      ENDIF
C
C --- CALCUL DE STABILITE
C
      ISTAB = 0
      CALL GETVTX('CRIT_STAB','DDL_STAB',1,IARG,0,K16BID,NSTA)
      ISTAB = -NSTA
      IF (ISTAB.GT.0) THEN
        FONACT(49) = 1
      ENDIF
C
C --- CALCUL DE MODES VIBRATOIRES
C
      IMVIBR = 0
      IF (LDYNA) THEN
        CALL GETFAC('MODE_VIBR',IMVIBR)
        IF (IMVIBR.GT.0) THEN
          FONACT(19) = 1
        ENDIF
      ENDIF
C
C --- ERREUR EN TEMPS
C
      IF (LSTAT) THEN
        ERRTHM = SDCRIQ(1:19)//'.ERRT'
        CALL JEEXIN(ERRTHM,IRET)
        IF (IRET.NE.0) FONACT(21) = 1
      ENDIF
C
C --- ALGORITHME IMPLEX
C
      IF (LSTAT) THEN
        IF (METHOD(1).EQ.'IMPLEX') THEN
          FONACT(28) = 1
        ELSE
          FONACT(28) = 0
        ENDIF
      ENDIF
C
C --- ALGORITHME NEWTON_KRYLOV
C
      IF (METHOD(1) .EQ.'NEWTON_KRYLOV') THEN
        FONACT(48) = 1
      ELSE
        FONACT(48) = 0
      ENDIF
C
C --- ELEMENTS DIS_CHOC ?
C
      CALL NMCPQU(COMPOR,'RELCOM','DIS_CHOC',LCHOC )
      IF (LCHOC) THEN
        FONACT(29) = 1
      ENDIF
C
C --- PRESENCE DE VARIABLES DE COMMANDE
C
      CALL DISMOI('F','EXI_VARC',MATE ,'CHAM_MATER',IBID,
     &            REPK,IRET)
      IF (REPK.EQ.'OUI') THEN
        FONACT(30) = 1
      ENDIF
C
C --- MODELISATION THM ?
C
      CALL DISMOI('F','EXI_THM', MODELE, 'MODELE',IBID,
     &            REPK,IRET)
      IF (REPK(1:3).EQ.'OUI') THEN
        FONACT(37) = 1
      ENDIF
C
C --- PRESENCE D'ELEMENTS UTILISANT STRX (PMF)
C
      CALL DISMOI('F','EXI_STRX',MODELE,'MODELE',IBID,
     &            REPK,IRET)
      IF (REPK.EQ.'OUI') THEN
        FONACT(56) = 1
      ENDIF
C
C --- CONCEPT REENTRANT ?
C
      CALL GCUCON(RESULT, 'EVOL_NOLI', IRET)
      IF (IRET.GT.0) THEN
        FONACT(39) = 1
      ENDIF
C
C --- SOLVEUR LDLT?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'LDLT') THEN
        FONACT(41) = 1
      ENDIF
C
C --- SOLVEUR MULT_FRONT?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'MULT_FRONT') THEN
        FONACT(42) = 1
      ENDIF
C
C --- SOLVEUR GCPC?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'GCPC') THEN
        FONACT(43) = 1
      ENDIF
C
C --- SOLVEUR MUMPS?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'MUMPS') THEN
        FONACT(44) = 1
      ENDIF
C
C --- SOLVEUR PETSC?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'PETSC') THEN
        FONACT(45) = 1
      ENDIF
C
C --- PRECONDITIONNEUR LDLT_SP?
C
      CALL JEVEUO(SOLVEU//'.SLVK','L',JSLVK)
      METRES=ZK24(JSLVK)
      IF (METRES.EQ.'PETSC'.OR.METRES.EQ.'GCPC') THEN
        PRECON=ZK24(JSLVK-1+2)
        IF (PRECON.EQ.'LDLT_SP') THEN
          FONACT(46) = 1
        ENDIF
      ENDIF
C
C --- BLINDAGE ARRET=NON
C
      LARRNO = (NINT(PARCRI(4)).EQ.1)
      IF (LARRNO) CALL U2MESS('A','MECANONLINE5_37')
C
C --- CALCUL DYNAMIQUE EXPLICITE
C
      IF (LEXPL) FONACT(54) = 1
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
C
C ----- METHODES DE RESOLUTION
C
        IF (ISFONC(FONACT,'IMPLEX')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... METHODE IMPLEX'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'EXPLICITE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... METHODE EXPLICITE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'NEWTON_KRYLOV')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... METHODE NEWTON_KRYLOV'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'RECH_LINE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... RECHERCHE LINEAIRE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'PILOTAGE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... PILOTAGE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'DEBORST')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... METHODE DEBORST'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'SOUS_STRUC')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL PAR SOUS-'//
     &                    'STRUCTURATION'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'PROJ_MODAL')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL PAR PROJECTION'//
     &                    ' MODALE'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- CONTACT
C
        IF (ISFONC(FONACT,'CONTACT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONT_DISCRET')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT DISCRET'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONT_CONTINU')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT CONTINU'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONT_XFEM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT XFEM'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'BOUCLE_EXT_GEOM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT BOUCLE GEOM'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'BOUCLE_EXT_CONT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT BOUCLE CONTACT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'BOUCLE_EXT_FROT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT BOUCLE FROT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'BOUCLE_EXTERNE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... BOUCLE EXTERNE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'GEOM_NEWTON')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... GEOMETRIE AVEC '//
     &                  'NEWTON GENERALISE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'FROT_NEWTON')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... FROTTEMENT AVEC '//
     &                  'NEWTON GENERALISE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONT_NEWTON')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT AVEC '//
     &                  'NEWTON GENERALISE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONT_ALL_VERIF')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT SANS '//
     &                  'CALCUL SUR TOUTES LES ZONES'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'CONTACT_INIT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONTACT INITIAL '
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'LIAISON_UNILATER')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... LIAISON UNILATERALE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'FROT_DISCRET')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... FROTTEMENT DISCRET'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'FROT_CONTINU')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... FROTTEMENT CONTINU'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'FROT_XFEM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... FROTTEMENT XFEM'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- ELEMENTS FINIS
C
        IF (ISFONC(FONACT,'ELT_CONTACT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS DE CONTACT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'ELT_FROTTEMENT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS DE FROTTEMENT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'DIS_CHOC')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS DIS_CHOC '
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'GD_ROTA')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS DE STRUCTURES'//
     &                  ' EN GRANDES ROTATIONS'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'XFEM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS XFEM'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'EXI_STRX')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS DE STRUCTURES'//
     &                  ' DE TYPE PMF'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- CONVERGENCE
C
        IF (ISFONC(FONACT,'RESI_REFE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONVERGENCE PAR RESI_REFE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'RESI_COMP')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONVERGENCE PAR RESI_COMP'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- CHARGEMENTS
C
        IF (ISFONC(FONACT,'FORCE_SUIVEUSE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENTS SUIVEURS'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'DIDI')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENTS DE '//
     &                  'DIRICHLET DIFFERENTIEL'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'DIRI_CINE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENTS '//
     &                  'CINEMATIQUES PAR ELIMINATION'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'LAPLACE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENTS '//
     &                  'DE LAPLACE'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- MODELISATION
C
        IF (ISFONC(FONACT,'MACR_ELEM_STAT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MACRO-ELEMENTS STATIQUES'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'THM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MODELISATION THM'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'ENDO_NO')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MODELISATION GVNO'
          NBFONC = NBFONC + 1
        ENDIF
C
C ----- POST-TRAITEMENTS
C
        IF (ISFONC(FONACT,'CRIT_STAB')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL CRITERE FLAMBEMENT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'DDL_STAB')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL CRITERE STABILITE'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'MODE_VIBR')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL MODES VIBRATOIRES'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'ENERGIE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL DES ENERGIES'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'ERRE_TEMPS_THM')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL ERREUR TEMPS EN'//
     &                  ' THM'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'EXI_VARC')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... VARIABLES DE COMMANDE'
          NBFONC = NBFONC + 1
        ENDIF

        IF (ISFONC(FONACT,'REUSE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CONCEPT RE-ENTRANT'
          NBFONC = NBFONC + 1
        ENDIF
C
        IF (ISFONC(FONACT,'FETI')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR FETI'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'LDLT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR LDLT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'MULT_FRONT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR MULT_FRONT'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'GCPC')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR GCPC'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'MUMPS')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR MUMPS'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'PETSC')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SOLVEUR PETSC'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'LDLT_SP')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... PRECONDITIONNEUR LDLT_SP'
          NBFONC = NBFONC + 1
        ENDIF
        IF (ISFONC(FONACT,'MATR_DISTRIBUEE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MATRICE GLOBALE '//
     &                  'DISTRIBUEE'
          NBFONC = NBFONC + 1
        ENDIF
C
        IF (NBFONC.EQ.0) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... <AUCUNE>'
        ENDIF
      ENDIF
C
C --- FONCTIONNALITES INCOMPATIBLES
C
      CALL EXFONC(FONACT,PARMET,METHOD,SOLVEU,DEFICO,
     &            SDDYNA)
C
      CALL JEDEMA()
      END
