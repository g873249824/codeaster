      SUBROUTINE NMDOET(MODELE,COMPOR,FONACT,NUMEDD,SDPILO,
     &                  SDDYNA,SDCRIQ,SDIETO,SOLALG,LACC0 ,
     &                  INSTIN)
C
C MODIF ALGORITH  DATE 31/07/2012   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_20
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      REAL*8       INSTIN
      CHARACTER*24 MODELE,COMPOR,SDCRIQ
      CHARACTER*24 NUMEDD
      CHARACTER*24 SDIETO
      CHARACTER*19 SDDYNA,SDPILO
      CHARACTER*19 SOLALG(*)
      INTEGER      FONACT(*)
      LOGICAL      LACC0
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C SAISIE DES CHAMPS A L'ETAT INITIAL
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  COMPOR : CARTE COMPORTEMENT
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  NUMEDD : NUME_DDL
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  SDPILO : SD DE PILOTAGE
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDCRIQ : SD CRITERE QUALITE
C IN  SDIETO : SD GESTION IN ET OUT
C OUT LACC0  : .TRUE. SI ACCEL. INITIALE A CALCULER
C OUT INSTIN : INSTANT INITIAL
C                R8VIDE SI NON DEFINI
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 IOINFO,IOLCHA
      INTEGER      JIOINF,JIOLCH
      INTEGER      NBCHAM,ZIOCH
      CHARACTER*24 NOMCHS
      LOGICAL      EVONOL,LEINIT
      INTEGER      NEQ,NOCC,NUMEIN,IRET,IBID,I
      INTEGER      JPLTK,ICHAM
      CHARACTER*8  K8BID
      CHARACTER*8  CALCRI,RESULT
      CHARACTER*16 MOTFAC
      CHARACTER*24 EVOL
      CHARACTER*24 TYPPIL,TYPSEL
      CHARACTER*19 DEPOLD
      CHARACTER*24 CHAMP1,CHAMP2,DEP2,DEP1,ERRTHM
      INTEGER      JDEP1,JDEP2,JDEPOL,JPLIR,JINST,JERRT
      LOGICAL      ISFONC,LPILO,LPIARC,LCTCC
      LOGICAL      NDYNLO,LEXGE,LREUSE,LERRT
      LOGICAL      LZERO
      REAL*8       R8VIDE,COEFAV
      INTEGER      IFM,NIV
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)

C
C --- INITIALISATIONS
C
      DEP1    = '&&CNPART.CHP1'
      DEP2    = '&&CNPART.CHP2'
      LACC0   = .FALSE.
      LPIARC  = .FALSE.
      MOTFAC  = 'ETAT_INIT'
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- ON VERIFIE QUE LE MODELE SAIT CALCULER UNE RIGIDITE
C
      CALL DISMOI('F','CALC_RIGI',MODELE,'MODELE',IBID,CALCRI,IRET)
      IF (CALCRI.NE.'OUI') CALL U2MESK('F','CALCULEL2_65',1,MODELE)
C
C --- ACCES SD IN ET OUT
C
      IOINFO = SDIETO(1:19)//'.INFO'
      IOLCHA = SDIETO(1:19)//'.LCHA'
      CALL JEVEUO(IOINFO,'L',JIOINF)
      CALL JEVEUO(IOLCHA,'L',JIOLCH)
      ZIOCH  = ZI(JIOINF+4-1)
      NBCHAM = ZI(JIOINF+1-1)
C
C --- FONCTIONNALITES ACTIVEES
C
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU')
      LEXGE  = NDYNLO(SDDYNA,'EXPL_GENE')
      LREUSE = ISFONC(FONACT,'REUSE')
      LERRT  = ISFONC(FONACT,'ERRE_TEMPS_THM')
C
C --- EXTRACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(SOLALG,'SOLALG','DEPOLD',DEPOLD)
C
C --- PILOTAGE LONGUEUR D'ARC AVEC ANGL_INCR_DEPL: IL FAUT LES DEUX
C --- DERNIERS DEPLACEMENTS POUR QUE CA MARCHE (CHAMP DEPOLD)
C
      IF (LPILO) THEN
        CALL JEVEUO(SDPILO(1:19)//'.PLTK','L',JPLTK)
        TYPPIL = ZK24(JPLTK)
        TYPSEL = ZK24(JPLTK+5)
        LPIARC = .FALSE.
        IF (TYPPIL.EQ.'LONG_ARC'.OR.TYPPIL.EQ.'SAUT_LONG_ARC') THEN
          IF (TYPSEL(1:14).EQ.'ANGL_INCR_DEPL') THEN
            LPIARC = .TRUE.
          ENDIF
        ENDIF
      ENDIF
C
C --- PAS D'ETAT INITIAL EN PRESENCE D'UN CONCEPT REENTRANT
C
      CALL GETFAC(MOTFAC,NOCC)
      CALL ASSERT(NOCC.LE.1)
      LEINIT = NOCC.GT.0
      IF (LEINIT) THEN
        CALL U2MESS('I','ETATINIT_10')
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> LECTURE ETAT INITIAL'
        ENDIF
      ELSE
        IF (LREUSE) THEN
          CALL U2MESS('A','ETATINIT_1')
        ELSE
          CALL U2MESS('I','ETATINIT_20')
        ENDIF
      ENDIF
C
C --- CONCEPT EVOL_NOLI DONNE DANS ETAT_INIT
C
      CALL GETVID(MOTFAC,'EVOL_NOLI',1,IARG,1,EVOL,NOCC)
      CALL ASSERT(NOCC.LE.1)
      EVONOL = NOCC .GT. 0
C
C --- ALARME SI CONTACT CONTINU AVEC UN CONCEPT REENTRANT
C
      IF (LCTCC) THEN
        IF (LREUSE) THEN
          IF (.NOT.ISFONC(FONACT,'CONTACT_INIT')) THEN
            CALL U2MESS('A','MECANONLINE4_14')
          ENDIF
        ELSE IF (EVONOL) THEN
          IF (.NOT.ISFONC(FONACT,'CONTACT_INIT')) THEN
            CALL U2MESS('A','MECANONLINE4_15')
          ENDIF
        ENDIF
      ENDIF
C
C --- INSTANT INITIAL
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... INSTANT INITIAL'
      ENDIF
      CALL NMDOIN(EVOL  ,EVONOL,INSTIN,NUMEIN)
      IF (NIV.GE.2) THEN
        IF (INSTIN.EQ.R8VIDE()) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... NON DEFINI PAR ETAT_INIT'
        ELSE
          WRITE (IFM,*) '<MECANONLINE> ...... VALEUR    : ',INSTIN
        ENDIF
      ENDIF
C
C --- BOUCLE SUR LES CHAMPS A LIRE
C
      DO 10 ICHAM  = 1,NBCHAM
        RESULT = EVOL(1:8)
C
C ----- LECTURE DU CHAMP - ETAT_INIT/SDRESU
C
        IF (EVONOL) CALL NMETL1(RESULT,NUMEIN,SDIETO,ICHAM )
C
C ----- LECTURE DU CHAMP - CHAMP PAR CHAMP
C
        CALL NMETL2(MOTFAC,SDIETO,ICHAM )
C
C ----- VERIFICATIONS SUR LE CHAMP
C
        CALL NMETL3(MODELE,COMPOR,EVONOL,RESULT,NUMEIN,
     &              SDIETO,LEINIT,ICHAM )
C
  10  CONTINUE
C
C --- VERIFICATION COMPATIBILITE PILOTAGE
C
      IF (EVONOL.AND.LPIARC) THEN
        CALL RSEXCH(' ',RESULT,'DEPL',NUMEIN  ,CHAMP1,IRET)
        CALL RSEXCH(' ',RESULT,'DEPL',NUMEIN-1,CHAMP2,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESK('F','MECANONLINE4_47',1,EVOL  )
        ENDIF
        CALL VTCOPY(CHAMP1,DEP1)
        CALL VTCOPY(CHAMP2,DEP2)
        CALL JEVEUO(DEP1(1:19)//'.VALE','L',JDEP1)
        CALL JEVEUO(DEP2(1:19)//'.VALE','L',JDEP2)
        CALL JEVEUO(DEPOLD(1:19)//'.VALE','E',JDEPOL)
        DO 156 I = 1,NEQ
          ZR(JDEPOL-1+I) = ZR(JDEP1-1+I) - ZR(JDEP2-1+I)
 156    CONTINUE
        CALL JEVEUO(SDPILO(1:19)//'.PLIR','E',JPLIR)
        CALL RSADPA(RESULT,'L',1,'COEF_MULT',NUMEIN,0,JINST,K8BID)
        COEFAV = ZR(JINST)
        IF (COEFAV.NE.0.D0.AND.COEFAV.NE.R8VIDE()) THEN
          ZR(JPLIR+5) = COEFAV
        ENDIF
      ENDIF
C
C --- LECTURE DES INDICATEURS D'ERREUR EN TEMPS EN THM
C
      IF (EVONOL.AND.LERRT) THEN
        ERRTHM = SDCRIQ(1:19)//'.ERRT'
        CALL JEVEUO(ERRTHM,'L',JERRT )
        CALL RSADPA(RESULT,'L',1,'ERRE_TPS_LOC' ,
     &              NUMEIN,0,JINST,K8BID)
        ZR(JERRT-1+1) = ZR(JINST)
        CALL RSADPA(RESULT,'L',1,'ERRE_TPS_GLOB',
     &              NUMEIN,0,JINST,K8BID)
        ZR(JERRT-1+2) = ZR(JINST)

      ENDIF
C
C --- CAS DE LA DYNAMIQUE: VITESSE ET ACCELERATION INITIALES
C
      DO 30 ICHAM  = 1,NBCHAM
        NOMCHS = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+1-1)
        LZERO  = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+4-1).EQ.'ZERO'
        IF (NOMCHS.EQ.'VITE') THEN
          IF (LZERO) THEN
            CALL U2MESS('I','MECANONLINE4_22')
          ENDIF
        ENDIF
        IF (NOMCHS.EQ.'ACCE') THEN
          IF (LZERO) THEN
            CALL U2MESS('I','MECANONLINE4_23')
            LACC0 = .TRUE.
          ENDIF
        ENDIF
  30  CONTINUE
C
C --- PROJECTION MODALE EN EXPLICITE
C
      IF (LEXGE) THEN
        RESULT = EVOL(1:8)
        CALL NDLOAM(SDDYNA,RESULT,EVONOL,NUMEIN)
      ENDIF
C
      CALL JEDEMA()
      END
