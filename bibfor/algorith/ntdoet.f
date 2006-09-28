      SUBROUTINE NTDOET ( MODELE,
     &                    LOSTAT, INITPR, RESULT, NUMINI,
     &                    TEMPIN, HYDRIN )
C
C     THERMIQUE - DONNEES EN TEMPS
C     *           **      *  *
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C ----------------------------------------------------------------------
C SAISIE DU TYPE DE CALCUL ET DU CHAMP INITIAL
C
C IN  MODELE : NOM DU  MODELE
C OUT LOSTAT : LOGIQUE INDIQUE SI L'ON CALCULE UN CAS STATIONNAIRE
C OUT INITPR : TYPE D'INITIALISATION
C              -1 : PAS D'INITIALISATION. (VRAI STATIONNAIRE)
C               0 : CALCUL STATIONNAIRE
C               1 : VALEUR UNIFORME
C               2 : CHAMP AUX NOEUDS
C               3 : RESULTAT D'UN AUTRE CALCUL
C OUT RESULT : NOM DU RESULTAT PRECEDENT SI INITPR = 3
C OUT NUMINI : NUMERO D'ORDRE DU CALCUL PRECEDENT SI INITPR = 3
C I/O TEMPIN : CHAMP DE TEMPERATURE INITIALE
C              SI INITPR = -1 OU 0 : RIEN
C              SI INITPR = 1 : ON REMPLIT LE TABLEAU PAR LA CONSTANTE
C              SI INITPR = 2 OU 3 : ON DONNE LE NOM DU CHAMP DE DEPART
C                                   A LA VARIABLE TEMPIN
C OUT HYDRIN : CHAMP D HYDRATATION INITIALE
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*24 MODELE
C
      LOGICAL LOSTAT
      CHARACTER*24 RESULT, TEMPIN, HYDRIN
      INTEGER NUMINI
      INTEGER INITPR
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'NTDOET' )
C
      CHARACTER*8       K8BID
      CHARACTER*16      NOMCOM
      CHARACTER*24      CHAMP, REPSTA
      CHARACTER*24 LIGRMO, HYDRIC, HYDRIS
C
      INTEGER NUM,N1,N2,IBID,IERD,IRET,JINST
      INTEGER IOCC
      INTEGER I, NDDL
      INTEGER JTEMPI,NNCP
C
      REAL*8 TEMPCT
C
      COMPLEX*16 CBID
C
C     ------------------------------------------------------------------
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
C
      INITPR = -2
      NUMINI = 0
C
      LOSTAT = .FALSE.
      LIGRMO = MODELE(1:8)//'.MODELE'
      HYDRIC='&&NTMODET.HYDR_C'
      HYDRIS='&&NTMODET.HYDR_S'
C
C====
C 2. INITIALISATION DE LA TEMPERATURE
C====
C
      CALL GETFAC ( 'TEMP_INIT', IOCC )
C
C 2.1. ==> PAS DE PRECISION --> C'EST UN CALCUL STATIONNAIRE
C
      IF ( IOCC .EQ. 0 ) THEN
C
        LOSTAT = .TRUE.
        INITPR = -1
C
      ELSE
C
C 2.2. ==> COMMANDE A DECODER
C
C 2.2.1. ==> TEMPERATURE INITIALE STATIONNAIRE
C
        CALL GETVTX('TEMP_INIT','STATIONNAIRE',1,1,1,REPSTA,N1)
        IF ( N1 .GT. 0 ) THEN
          IF ( REPSTA(1:3) .EQ. 'OUI' ) THEN
            LOSTAT = .TRUE.
            INITPR = 0
          ENDIF
        ENDIF
C
C 2.2.2. ==> TEMPERATURE INITIALE UNIFORME
C            RECOPIE DE LA VALEUR CONSTANTE DANS LE CHAMP TEMPIN
C
        CALL GETVR8('TEMP_INIT','VALE',1,1,1,TEMPCT,N1)
C
        IF (N1.GT.0) THEN
C
          INITPR = 1
C
          CALL JEVEUO(TEMPIN(1:19)//'.VALE','E',JTEMPI)
          CALL JELIRA(TEMPIN(1:19)//'.VALE','LONMAX',NDDL,K8BID)
C
          DO 222 , I = 1 , NDDL
            ZR(JTEMPI+I-1) = TEMPCT
  222     CONTINUE
C
        ENDIF
C
C 2.2.3. ==> RECUPERATION D'UN CHAM_NO DE TEMPERATURE
C
        CALL GETVID('TEMP_INIT','CHAM_NO',1,1,1,CHAMP,N1)
C
        IF (N1.GT.0) THEN
C
          INITPR = 2
C
          CALL CHPVER('F',CHAMP(1:19),'NOEU','TEMP_R',IERD)
          CALL DISMOI('F','TYPE_RESU',CHAMP,'RESULTAT',IBID,K8BID,
     &          IERD)
          IF (K8BID.EQ.'CHAMP') THEN
            TEMPIN=CHAMP
          ELSE
            CALL U2MESS('F','ALGORITH9_2')
          ENDIF
C
        ENDIF
C
C 2.2.4. ==> RECUPERATION D'UN CHAM_NO DE TEMPERATURE A PARTIR D'UNE
C            STRUCTURE DE DONNEES RESULTAT
C
        CALL GETVID('TEMP_INIT','EVOL_THER',1,1,1,RESULT,N1)
C
        IF (N1.GT.0) THEN
C
          INITPR = 3
C
          CALL GETVIS('TEMP_INIT','NUME_INIT',1,1,1,NUM,N2)
          IF (N2.LE.0) THEN
            CALL U2MESS('F','ALGORITH9_3')
          ELSE
            CALL RSEXCH(RESULT,'TEMP',NUM,TEMPIN,IRET)
            IF (IRET.GT.0) THEN
              CALL U2MESS('F','ALGORITH9_1')
            ENDIF
            CALL GETRES(K8BID,K8BID,NOMCOM)

C
C ------- RECUPERATION D'UN CHAM_ELEM D'HYDRATATION A PARTIR D'UNE
C ------- STRUCTURE DE DONNEES RESULTAT SI THER_NON_LINE

            IF (NOMCOM .EQ. 'THER_NON_LINE') THEN
            CALL RSEXCH(RESULT,'HYDR_ELNO_ELGA',NUM,HYDRIN,IRET)
            IF (IRET.GT.0) THEN
               HYDRIN = '&&'//NOMPRO//'.HYDR_R'
               CALL MECACT('V',HYDRIC,'MODELE',LIGRMO,'HYDR_R',1,
     &                 'HYDR',IBID,0.D0,CBID,K8BID)
               CALL CARCES(HYDRIC,'ELNO',' ','V',HYDRIS,IRET)
               CALL CESCEL(HYDRIS,LIGRMO,'RESI_RIGI_MASS',
     &              'PHYDRPP','NON',NNCP,'V',HYDRIN)
               CALL DETRSD('CHAMP',HYDRIC)
               CALL DETRSD('CHAMP',HYDRIS)

            ENDIF
            ENDIF

            NUMINI = NUM
            CALL RSADPA(RESULT,'L',1,'INST',NUM,0,JINST,K8BID)
          ENDIF
C
        ENDIF
C
      ENDIF
C
C====
C 3. EN NON-LINEAIRE :
C    INITIALISATION A ZERO DES VARIABLES D'HYDRATATION SI CALCUL
C    STATIONNAIRE OU TEMP INIT PAR CHAM_NO OU VALE
C====
C
      CALL GETRES ( K8BID, K8BID, NOMCOM )
C
      IF ( NOMCOM .EQ. 'THER_NON_LINE' ) THEN
C
        IF ( INITPR.LE.2 ) THEN
          HYDRIN = '&&'//NOMPRO//'.HYDR_R'
          CALL MECACT('V',HYDRIC,'MODELE',LIGRMO,'HYDR_R',1,
     &                 'HYDR',IBID,0.D0,CBID,K8BID)
          CALL CARCES(HYDRIC,'ELNO',' ','V',HYDRIS,IRET)
          CALL CESCEL(HYDRIS,LIGRMO,'RESI_RIGI_MASS',
     &         'PHYDRPP','NON',NNCP,'V',HYDRIN)
          CALL DETRSD('CHAMP',HYDRIC)
          CALL DETRSD('CHAMP',HYDRIS)
        ENDIF
C
      ENDIF
C
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
C
      END
