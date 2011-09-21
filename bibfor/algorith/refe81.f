      SUBROUTINE  REFE81 (NOMRES,BASMOD,RAIDF,MASSF,AMORF,MAILLA)
      IMPLICIT REAL*8 (A-H,O-Z)
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C***********************************************************************
C  P. RICHARD     DATE 13/07/90
C-----------------------------------------------------------------------
C  BUT : < CREATION DU REFE ET DU DESC POUR OP0081 >
C
C        - RECUPERER LES NOMS UTILISATEUR DES CONCEPTS ASSOCIES AUX
C          MATRICES ASSEMBLEES ET BASE MODALE CONSIDEREES
C        - EFFECTUER QUELQUES CONTROLES ET DETERMINER
C          OPTION DE CALCUL MATRICES PROJETEES
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM UTILISATEUR DU RESULTAT
C BASMOD /O/ : NOM UT DE LA BASE MODALE DE PROJECTION
C RAIDF  /O/ : NOM UT DE LA MATRICE RAIDEUR A PROJETER
C MASSEF /O/ : NOM UT DE LA MATRICE DE MASSE A PROJETER
C AMORF  /O/ : NOM UT DE LA MATRICE D'AMORTISSEMENT A PROJETER
C MAILLA /O/ : NOM UT DU MAILLAGE EN AMONT
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*24 VALK(2),TYPBAS
      CHARACTER*8  NOMRES,MAILLA,BASMOD,MAILLB,AMOR,BLANC,LINTF,K8BID
      CHARACTER*14 NUMDDL,NUMBIS,NUMTER
      CHARACTER*19 RAID,RAIDB,MASS,MASSB,MASSF,RAIDF,AMORF,AMORB
      INTEGER      IARG
C
C-----------------------------------------------------------------------
      DATA BLANC         /'        '/
C-----------------------------------------------------------------------
C
C --- RECUPERATION EVENTUELLE MATRICE RAIDEUR EN ARGUMENT
C
      CALL JEMARQ()
      CALL GETVID(BLANC,'MATR_RIGI',1,IARG,0,K8BID,IOC)
      IOC=-IOC
      IF(IOC.EQ.0) THEN
        RAID=BLANC
      ELSEIF(IOC.EQ.1) THEN
        CALL GETVID(BLANC,'MATR_RIGI',1,IARG,1,RAID,L)
      ELSE
        CALL U2MESG('F', 'ALGORITH14_14',0,' ',0,0,0,0.D0)
      ENDIF
C
C --- RECUPERATION EVENTUELLE MATRICE MASSE EN ARGUMENT
C
      CALL GETVID(BLANC,'MATR_MASS',1,IARG,0,K8BID,IOC)
      IOC=-IOC
      IF(IOC.EQ.0) THEN
        MASS=BLANC
      ELSEIF(IOC.EQ.1) THEN
        CALL GETVID(BLANC,'MATR_MASS',1,IARG,1,MASS,L)
      ELSE
        CALL U2MESG('F', 'ALGORITH14_15',0,' ',0,0,0,0.D0)
      ENDIF
C
C --- RECUPERATION EVENTUELLE MATRICE AMORTISSEMENT EN ARGUMENT
C
      CALL GETVID(BLANC,'MATR_AMOR',1,IARG,0,K8BID,IOC)
      IOC=-IOC
      IF(IOC.EQ.0) THEN
        AMOR=BLANC
      ELSEIF(IOC.EQ.1) THEN
        CALL GETVID(BLANC,'MATR_AMOR',1,IARG,1,AMOR,L)
      ELSE
        CALL U2MESG('F', 'ALGORITH14_16',0,' ',0,0,0,0.D0)
      ENDIF
C
C --- RECUPERATION BASE MODALE OBLIGATOIRE
C
      RAIDB=BLANC
      MASSB=BLANC
      AMORB=BLANC
      CALL GETVID(BLANC,'BASE_MODALE',1,IARG,1,BASMOD,NBVAL)
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREFB)
      RAIDB=ZK24(LLREFB)(1:8)
      MASSB=ZK24(LLREFB+1)(1:8)
      AMORB=ZK24(LLREFB+2)(1:8)
      NUMDDL=ZK24(LLREFB+3)(1:14)
      LINTF=ZK24(LLREFB+4)(1:8)
      TYPBAS=ZK24(LLREFB+6)
C
C
C --- RECUPERATION MAILLAGE
C
      IF (LINTF.NE.BLANC) THEN
        CALL JEVEUO(LINTF//'.IDC_REFE','L',LLREF)
        MAILLA=ZK24(LLREF)
      ELSE
        CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IBID,
     &   MAILLA,IRET)
      ENDIF
C
C --- RECUPERATION DU TYPE DE BASE MODALE
C
C --- CAS DE LA DONNEE DES MATRICE DE LA BASE
C
      IF (TYPBAS(1:4).NE.'RITZ') THEN
        IF(MASS.EQ.MASSB) MASS=BLANC
        IF(RAID.EQ.RAIDB) RAID=BLANC
        IF(AMOR.EQ.AMORB) AMOR=BLANC
      ENDIF
C
C
C --- CAS BASE MODALE CLASSIQUE
C
      IF((TYPBAS(1:9).EQ.'CLASSIQUE').OR.
     &   (TYPBAS(1:9).EQ.'DIAG_MASS').OR.
     &   (TYPBAS(1:9).EQ.'         ') ) THEN
C
        IF(MASS.NE.BLANC)THEN
          MASSF=MASS
        ELSE
          MASSF=MASSB
        ENDIF
        IF(RAID.NE.BLANC)THEN
          RAIDF=RAID
        ELSE
          RAIDF=RAIDB
        ENDIF
        IF(AMOR.NE.BLANC)THEN
          AMORF=AMOR
        ELSE
          AMORF=AMORB
        ENDIF
      ENDIF
C
C --- CAS BASE MODALE RITZ
      IF((TYPBAS(1:4).EQ.'RITZ')) THEN
C
C --- TRAITEMENT DU NOM FINAL MASSE ET RAIDEUR
C
        MASSF=MASS
        RAIDF=RAID
        AMORF=AMOR
      ENDIF
C
C --- TRAITEMENT COHERENCE MATRICE ASSEMBLEES
C     SI MASSF ET RAIDF NON BLANC
C
C
      IF (RAIDF.EQ.BLANC.OR.MASSF.EQ.BLANC) GOTO 10
C
      CALL DISMOI('F','NOM_NUME_DDL',RAIDF,'MATR_ASSE',
     &IBID,NUMDDL,IRET)
C
      CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IBID,
     &MAILLB,IRET)
C
      CALL DISMOI('F','NOM_NUME_DDL',MASSF,'MATR_ASSE',IBID,
     &NUMBIS,IRET)
C
      IF (AMORF.NE.BLANC) THEN
         CALL DISMOI('F','NOM_NUME_DDL',AMORF,'MATR_ASSE',IBID,
     &               NUMTER,IRET)
      ENDIF
C
C --- CONTROLE DE LA COHERENCE DES MATRICES ASSEMBLEES
C
      IF(NUMDDL.NE.NUMBIS) THEN
        VALK (1) = MASS
        VALK (2) = RAID
         CALL U2MESG('F', 'ALGORITH14_21',2,VALK,0,0,0,0.D0)
      ENDIF
C
      IF (AMOR.NE.BLANC) THEN
        IF (NUMDDL.NE.NUMTER) THEN
          VALK (1) = AMOR
          VALK (2) = RAID
          CALL U2MESG('F', 'ALGORITH14_22',2,VALK,0,0,0,0.D0)
        ENDIF
      ENDIF
C
      IF(MAILLA.NE.MAILLB) THEN
        VALK (1) = MAILLB
        VALK (2) = MAILLA
        CALL U2MESG('F', 'ALGORITH14_23',2,VALK,0,0,0,0.D0)
      ENDIF
C
   10 CONTINUE
C
C --- REMPLISSAGE DU .REFE
C
      CALL WKVECT(NOMRES//'.MAEL_REFE','G V K24',2,IADREF)
      ZK24(IADREF)=BASMOD
      ZK24(IADREF+1)=MAILLA
C
C --- REMPLISSAGE DU .DESC
C
      CALL WKVECT(NOMRES//'.MAEL_DESC','G V I',3,LDDESC)
      IF (LINTF.NE.BLANC) THEN
       CALL JEVEUO(LINTF//'.IDC_DESC','L',LLDESC)
       ZI(LDDESC)=ZI(LLDESC+1)
       ZI(LDDESC+1)=ZI(LLDESC+2)
       ZI(LDDESC+2)=ZI(LLDESC+3)
      ENDIF
C
      CALL JEDEMA()
      END
