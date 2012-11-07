      SUBROUTINE DLTINI ( LCREA, NUME,
     &                    DEPINI, VITINI, ACCINI,
     &                    NEQ, NUMEDD, INCHAC, BASENO,
     &                    NRPASE, INPSCO )
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/11/2012   AUTEUR LADIER A.LADIER 
C ======================================================================
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
C     CALCUL MECANIQUE TRANSITOIRE PAR INTEGRATION DIRECTE
C     RECUPERATION DES CONDITIONS INITIALES
C     ------------------------------------------------------------------
C OUT : LCREA  : CREATION OU NON DU RESULTAT
C OUT : NUME   : NUMERO D'ORDRE DE REPRISE
C OUT : DEPINI : CHAMP DE DEPLACEMENT INITIAL OU DE REPRISE
C OUT : VITINI : CHAMP DE VITESSE INITIALE OU DE REPRISE
C OUT : ACCINI : CHAMP D'ACCELERATION INITIALE OU DE REPRISE
C IN  : NEQ    : NOMBRE D'EQUATIONS
C IN  : NUMEDD : NUMEROTATION DDL
C IN  : BASENO : BASE DES NOMS DE STRUCTURES
C VAR : INCHAC : CALCUL OU NON DE L'ACCELERATION INITIALE
C IN  : NRPASE : NUMERO DU CHARGEMENT (STANDARD OU SENSIBILITE)
C IN  : INPSCO : STRUCTURE CONTENANT LA LISTE DES NOMS (CF. PSNSIN)
C     ------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      REAL*8 DEPINI(*), VITINI(*), ACCINI(*)
      CHARACTER*8 BASENO
      CHARACTER*13 INPSCO
      CHARACTER*24 NUMEDD
      LOGICAL LCREA
      INTEGER NEQ
      INTEGER NRPASE
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      REAL*8 VALR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER IBID, IEQ, INCHAC, IRE, IRET, JVALE
      INTEGER NAI, NBTROU, NC, NDI, NDY, NNI, NP, NT, NUME, NVI
      REAL*8 PREC, TEMPS
      INTEGER JAUX,IERR
      INTEGER VALI
      CHARACTER*8   K8B, NOMRES, DYNA, CRIT, DYNA1
      CHARACTER*24 VALK
      CHARACTER*19  CHAMP, CHAM2, RESULT
      COMPLEX*16    C16B
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      LCREA = .TRUE.

C====
C 1. NOM DES STRUCTURES ASSOCIEES AUX DERIVATIONS
C               3. LE NOM DU RESULTAT
C====
      IBID = 0
      JAUX = 3
      CALL PSNSLE ( INPSCO,   IBID, JAUX, NOMRES )
      JAUX = 3
      CALL PSNSLE ( INPSCO, NRPASE, JAUX, RESULT )
      DYNA1 = RESULT(1:8)
C
C====
C 2.  --- EST-ON EN REPRISE ? ---
C====
C
      CALL GETVID('ETAT_INIT','DYNA_TRANS',1,1,1,DYNA,NDY)
C
C====
C 3. EN REPRISE
C====
C
      IF ( NDY .NE. 0 ) THEN
C
         CALL GETVIS('ETAT_INIT','NUME_INIT' ,1,1,1,NUME,NNI)
         IF ( NNI .EQ. 0 ) THEN
            CALL GETVR8('ETAT_INIT','INST_INIT',1,1,1,TEMPS,NT)
            IF ( NT .EQ. 0 ) THEN
               CALL RSORAC(DYNA,'DERNIER',IBID,TEMPS,K8B,C16B,
     &                                         PREC,CRIT,NUME,1,NBTROU)
               IF (NBTROU.NE.1) THEN
                  CALL U2MESS('F','ALGORITH3_24')
               ENDIF
            ELSE
               CALL GETVR8('ETAT_INIT','PRECISION',1,1,1,PREC ,NP)
               CALL GETVTX('ETAT_INIT','CRITERE'  ,1,1,1,CRIT ,NC)
               CALL RSORAC(DYNA,'INST',IBID,TEMPS,K8B,C16B,
     &                                        PREC,CRIT,NUME,1,NBTROU)
               IF (NBTROU.LT.0) THEN
                 VALK = DYNA
                 VALR = TEMPS
                 VALI = -NBTROU
                 CALL U2MESG('F', 'ALGORITH12_83',1,VALK,1,VALI,1,VALR)
               ELSEIF (NBTROU.EQ.0) THEN
                 VALK = DYNA
                 VALR = TEMPS
                 CALL U2MESG('F', 'ALGORITH12_84',1,VALK,0,0,1,VALR)
               ENDIF
            ENDIF
         ENDIF
C
         IF (NRPASE.EQ.0) THEN
             DYNA1 = DYNA
         ELSE
             CALL U2MESK('A', 'SENSIBILITE_41',0,' ')
         ENDIF
C
C        --- RECUPERATION DES CHAMPS DEPL VITE ET ACCE ---
         CALL RSEXCH(DYNA1,'DEPL',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL U2MESK('F','ALGORITH3_25',1,DYNA1)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL DCOPY(NEQ,ZR(JVALE),1,DEPINI,1)
         ENDIF
         CALL RSEXCH(DYNA1,'VITE',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL U2MESK('F','ALGORITH3_26',1,DYNA1)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL DCOPY(NEQ,ZR(JVALE),1,VITINI,1)
         ENDIF
         CALL RSEXCH(DYNA1,'ACCE',NUME,CHAMP,IRET)
         IF ( IRET .NE. 0 ) THEN
            CALL U2MESK('F','ALGORITH3_27',1,DYNA1)
         ELSE
            CALL JEVEUO(CHAMP//'.VALE','L',JVALE)
            CALL DCOPY(NEQ,ZR(JVALE),1,ACCINI,1)
         ENDIF
C
C        --- CREE-T-ON UNE NOUVELLE STRUCTURE ? ---
         IF ( NOMRES .EQ. DYNA ) THEN
            LCREA = .FALSE.
            CALL RSRUSD ( NOMRES, NUME+1 )
         ENDIF
C====
C 4. --- RECUPERATION DES CONDITIONS INITIALES ---
C====
C
      ELSE
C
         CALL JEEXIN(DYNA1(1:8)//'           .REFD',IRE)
         IF (IRE.GT.0) THEN
           LCREA = .FALSE.
         ENDIF

         NUME = 0
         CALL GETVID('ETAT_INIT','DEPL_INIT',1,1,1,CHAMP,NDI)
         IF (NDI.GT.0) THEN
            CALL CHPVER('F',CHAMP,'NOEU','DEPL_R',IERR)
            INCHAC = 1
            CHAM2 = BASENO//'.DEPINI'
            IF (NRPASE.EQ.0) THEN
              CALL VTCREB (CHAM2, NUMEDD, 'V', 'R', NEQ)
              CALL VTCOPY(CHAMP,CHAM2)
              CALL JEVEUO(CHAM2//'.VALE','L',JVALE)
            ELSE
              CALL JEVEUO(CHAM2//'.VALE','E',JVALE)
              DO 41 IEQ=1,NEQ
                ZR(JVALE-1+IEQ)=0.D0
   41         CONTINUE
              CALL U2MESK('A', 'SENSIBILITE_41',0,' ')
            ENDIF
            CALL DCOPY(NEQ,ZR(JVALE),1,DEPINI,1)
         ELSE
            CALL U2MESS('I','ALGORITH3_28')
         ENDIF
C
         CALL GETVID('ETAT_INIT','VITE_INIT',1,1,1,CHAMP,NVI)
         IF (NVI.GT.0) THEN
            CALL CHPVER('F',CHAMP,'NOEU','DEPL_R',IERR)
            INCHAC = 1
            CHAM2 = BASENO//'.VITINI'
            IF (NRPASE.EQ.0) THEN
              CALL VTCREB (CHAM2, NUMEDD, 'V', 'R', NEQ)
              CALL VTCOPY(CHAMP,CHAM2)
              CALL JEVEUO(CHAM2//'.VALE','L',JVALE)
            ELSE
              CALL JEVEUO(CHAM2//'.VALE','E',JVALE)
              DO 42 IEQ=1,NEQ
                ZR(JVALE-1+IEQ)=0.D0
   42         CONTINUE
              CALL U2MESK('A', 'SENSIBILITE_42',0,' ')
            ENDIF
            CALL DCOPY(NEQ,ZR(JVALE),1,VITINI,1)
         ELSE
            CALL U2MESS('I','ALGORITH3_29')
         ENDIF

         CALL GETVID('ETAT_INIT','ACCE_INIT',1,1,1,CHAMP,NAI)
         IF (NAI.GT.0 .AND. NRPASE.EQ.0) THEN
              CALL CHPVER('F',CHAMP,'NOEU','DEPL_R',IERR)
              INCHAC = 0
              CHAM2 = BASENO//'.ACCINI'
              CALL VTCREB (CHAM2, NUMEDD, 'V', 'R', NEQ)
              CALL VTCOPY(CHAMP,CHAM2)
              CALL JEVEUO(CHAM2//'.VALE','L',JVALE)
              CALL DCOPY(NEQ,ZR(JVALE),1,ACCINI,1)
         ENDIF
C
      ENDIF
C
      CALL JEDEMA()
      END
