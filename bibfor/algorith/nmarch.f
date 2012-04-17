      SUBROUTINE NMARCH(NUMINS,MODELE,MATE  ,CARELE,FONACT,
     &                  CARCRI,SDIMPR,SDDISC,SDPOST,SDCRIT,
     &                  SDTIME,SDERRO,SDSENS,SDDYNA,SDPILO,
     &                  SDENER,SDIETO,LISCH2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/04/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INTEGER      FONACT(*)
      INTEGER      NUMINS
      CHARACTER*24 SDSENS,SDIETO,SDIMPR,SDTIME
      CHARACTER*19 SDDISC,SDCRIT,SDDYNA,SDPOST,SDPILO,SDENER
      CHARACTER*24 CARCRI
      CHARACTER*24 SDERRO
      CHARACTER*19 LISCH2
      CHARACTER*24 MODELE,MATE,CARELE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C ARCHIVAGE
C
C ----------------------------------------------------------------------
C
C
C IN  SDIETO : SD GESTION IN ET OUT
C IN  SDIMPR : SD AFFICHAGE
C IN  NUMINS : NUMERO DE L'INSTANT
C IN  MODELE : NOM DU MODELEE
C IN  MATE   : CHAMP DE MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  CARCRI : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
C IN  SDCRIT : VALEUR DES CRITERES DE CONVERGENCE
C IN  SDERRO : SD ERREUR
C IN  SDSENS : SD SENSIBILITE
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE
C IN  SDPILO : SD PILOTAGE
C IN  SDTIME : SD TIMER
C IN  SDENER : SD ENERGIE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  LISCH2 : NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      JINST
      INTEGER      IBID,IRET
      INTEGER      NUMARC
      REAL*8       INSTAM,INSTAN,R8BID
      CHARACTER*8  K8BID
      REAL*8       DIINST
      LOGICAL      ISFONC,LSENS,FORCE
      CHARACTER*19 K19BID
      INTEGER      NRPASE,NBPASE,NMSENN
      CHARACTER*8  NOPASE,RESULT
      CHARACTER*4  ETCALC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- DEBUT MESURE TEMPS
C
      CALL NMTIME(SDTIME,'RUN','ARC')
C
C --- CONVERGENCE DU CALCUL ?
C
      CALL NMLEEB(SDERRO,'CALC',ETCALC)
C
C --- DERNIER PAS -> ON FORCE L'ARCHIVAGE
C
      FORCE = .FALSE.
      CALL NMFINP(SDDISC,NUMINS,FORCE )
C
C --- ON FORCE L'ARCHIVAGE
C
      IF (ETCALC.EQ.'CONV') FORCE = .TRUE.
      IF (ETCALC.EQ.'STOP') FORCE = .TRUE.
C
C --- FONCTIONNALITES ACTIVEES
C
      LSENS  = ISFONC(FONACT,'SENSIBILITE')
C
C --- NOMBRE PARAMETRES SENSIBLES
C
      IF (LSENS) THEN
        NBPASE = NMSENN(SDSENS)
      ENDIF
C
C --- IMPRESSION EVENTUELLE DES MESURES DE TEMPS
C
      CALL UTTCPG('IMPR','INCR')
C
C --- NUMERO D'ARCHIVAGE
C
      CALL DINUAR(SDDISC,NUMINS,FORCE ,NUMARC)
C
C --- INSTANT COURANT
C
      INSTAN = DIINST(SDDISC,NUMINS)
C
C --- NOM SD RESULTAT
C
      CALL NMNSLE(SDSENS,0,'RESULT',RESULT)
C
C --- ARCHIVAGE DES PARAMETRES CALCULES DANS LA TABLE PARACALC
C
      CALL NMARPC(RESULT,SDENER,INSTAN)
C
C ----------------------------------------------------------------------
C
      IF (NUMARC.GE.0) THEN
C
C ----- INSTANT DEJA ARCHIVE ?
C
        IF (NUMARC.GE.2) THEN
          CALL RSADPA(RESULT,'L',1,'INST',NUMARC-1,0,JINST,K8BID)
          INSTAM = ZR(JINST)
          IF (INSTAN.EQ.INSTAM) THEN
            GOTO 999
          ENDIF
        ENDIF
C
C ----- AFFICHAGE
C
        CALL NMIMPR(SDIMPR,'IMPR','ARCH_TETE',' ',R8BID,IBID)
C
C ----- EXTENSION DE RESULT SI TROP PETIT (DOUBLEMENT)
C
        CALL RSEXCH(RESULT,'DEPL',NUMARC,K19BID,IRET  )
        IF (IRET.EQ.110) THEN
          CALL RSAGSD(RESULT,0)
        ENDIF
C
C ----- ARCHIVAGE DES PARAMETRES
C
        CALL NMARC0(RESULT,MODELE,MATE  ,CARELE,FONACT,
     &              SDCRIT,SDDYNA,SDPOST,CARCRI,SDERRO,
     &              SDPILO,LISCH2,NUMARC,INSTAN)
C
C ----- ARCHIVAGE DES CHAMPS
C
        NRPASE = 0
        CALL NMARCE(SDSENS,SDIETO,RESULT,SDDISC,INSTAN,
     &              NUMARC,NRPASE,FORCE )
C
C ----- CAS SENSIBLE
C
        IF (LSENS) THEN
C
C ------- BOUCLE SUR LES PARAMETRES SENSIBLES
C
          DO 10 NRPASE = 1,NBPASE
C
C --------- NOM DES CHAMPS SENSIBLES
C
            CALL NMNSLE(SDSENS,NRPASE,'NOPASE',NOPASE)
            CALL NMNSLE(SDSENS,NRPASE,'RESULT',RESULT)
C
C --------- AFFICHAGE
C
            CALL NMIMPR(SDIMPR,'IMPR','ARCH_SENS',NOPASE,R8BID,IBID)
C
C --------- EXTENSION DE RESULT SI TROP PETIT (DOUBLEMENT)
C
            CALL RSEXCH(RESULT,'DEPL',NUMARC,K19BID,IRET  )
            IF (IRET.EQ.110) THEN
              CALL RSAGSD(RESULT,0)
            ENDIF
C
C --------- ARCHIVAGE DES PARAMETRES
C
            CALL NMARC0(RESULT,MODELE,MATE  ,CARELE,FONACT,
     &                  SDCRIT,SDDYNA,SDPOST,CARCRI,SDERRO,
     &                  SDPILO,LISCH2,NUMARC,INSTAN)
C
C --------- ARCHIVAGE DES CHAMPS SENSIBLES
C
            CALL NMARCE(SDSENS,SDIETO,RESULT,SDDISC,INSTAN,
     &                  NUMARC,NRPASE,FORCE )
  10      CONTINUE
        ENDIF
      ENDIF
C
  999 CONTINUE
C
C --- FIN MESURE TEMPS
C
      CALL NMTIME(SDTIME,'END','ARC')
C
      CALL JEDEMA()
      END
