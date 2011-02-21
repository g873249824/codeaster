      SUBROUTINE NXDOET(MODELE,NUMEDD,LREUSE,LOSTAT,LNONL ,
     &                  INPSCO,NBPASE,INITPR,VTEMP ,VHYDR ,
     &                  INSTIN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      CHARACTER*24  MODELE
      LOGICAL       LOSTAT,LREUSE,LNONL
      CHARACTER*24  VTEMP,VHYDR,NUMEDD
      REAL*8        INSTIN
      INTEGER       INITPR,NBPASE
      CHARACTER*(*) INPSCO
C
C ----------------------------------------------------------------------
C
C ROUTINE THER_NON_LINE (INITIALISATION)
C
C SAISIE DES CHAMPS A L'ETAT INITIAL
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NUME_DDL
C IN  LREUSE : .TRUE. SI REUSE
C IN  LNONL  : .TRUE. SI NON-LINEAIRE
C IN  INPSCO : SD CONTENANT LA LISTE DES NOMS POUR LA SENSIBILITE
C IN  NBPASE : NOMBRE DE PARAMETRES SENSIBLES
C OUT LOSTAT : .TRUE. SI L'ON CALCULE UN CAS STATIONNAIRE
C OUT INITPR : TYPE D'INITIALISATION
C              -1 : PAS D'INITIALISATION. (VRAI STATIONNAIRE)
C               0 : CALCUL STATIONNAIRE
C               1 : VALEUR UNIFORME
C               2 : CHAMP AUX NOEUDS
C               3 : RESULTAT D'UN AUTRE CALCUL
C OUT INSTIN : INSTANT INITIAL
C                R8VIDE SI NON DEFINI
C OUT VTEMP  : CHAMP DE TEMPERATURE INITIALE
C OUT VHYDR  : CHAMP D'HYDRATATION INITIALE
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
      CHARACTER*8  K8BID ,CALCRI,RESULT,RESULS
      CHARACTER*24 CHAMP ,REPSTA,EVOL
      CHARACTER*24 LIGRMO
      CHARACTER*16 MOTFAC,TYPRES
      INTEGER      N1,IBID,IERD,IRET
      INTEGER      I, NEQ,NOCC,NUMEIN,NRPASE
      INTEGER      JTEMP,NNCP
      INTEGER      IAUX,JAUX
      REAL*8       TEMPCT,R8VIDE
      INTEGER      IFM,NIV
      COMPLEX*16   CBID
      LOGICAL      EVONOL,LHYD0,LEINIT
      CHARACTER*19 HYDRIC,HYDRIS,HYDZER
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFNIV(IFM,NIV)
C
C --- INITIALISATIONS
C
      INITPR = -2
      INSTIN = R8VIDE()
      EVONOL = .FALSE.
      LOSTAT = .FALSE.
      LEINIT = .FALSE.
      LHYD0  = .FALSE.
      HYDRIC = '&&NXDOET.HYDR_C'
      HYDRIS = '&&NXDOET.HYDR_S'
      HYDZER = '&&NXDOET.HYDR_R'
      MOTFAC = 'ETAT_INIT'    
C      
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID  ,LIGRMO,IRET)
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- PREPARATION CHAM_ELEM_S NUL POUR HYDRATATION
C
      IF (LNONL) THEN
        CALL MECACT('V',HYDRIC,'MODELE',LIGRMO,'HYDR_R',1,
     &              'HYDR',IBID,0.D0,CBID,K8BID)
        CALL CARCES(HYDRIC,'ELNO',' ','V',HYDRIS,IRET)
        CALL CESCEL(HYDRIS,LIGRMO,'RESI_RIGI_MASS','PHYDRPP',
     &              'NON',NNCP,'V',HYDZER,'F',IBID)
      ENDIF
C
C --- HYDRATATION NULLE PAR DEFAUT EN NON-LINEAIRE
C      
      IF (LNONL) THEN
        LHYD0 = .TRUE.
      ENDIF
C
C --- ON VERIFIE QUE LE MODELE SAIT CALCULER UNE RIGIDITE
C
      CALL DISMOI('F','CALC_RIGI',MODELE,'MODELE',IBID,CALCRI,IERD)
      IF (CALCRI.NE.'OUI') CALL U2MESK('F','CALCULEL2_65',1,MODELE)
C
C --- PAS D'ETAT INITIAL EN PRESENCE D'UN CONCEPT REENTRANT
C
      CALL GETFAC(MOTFAC,NOCC  )
      CALL ASSERT(NOCC.LE.1)
      LEINIT = NOCC.GT.0
      IF (LEINIT) THEN
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<THERNONLINE> LECTURE ETAT INITIAL'
        ENDIF
      ELSE
        IF (LREUSE) THEN
          CALL U2MESS('A','ETATINIT_1')
        ENDIF
      ENDIF
C
C --- CONCEPT EVOL_THER DONNE DANS ETAT_INIT
C
      CALL GETVID(MOTFAC,'EVOL_THER',1,1,1,EVOL,NOCC)
      CALL ASSERT(NOCC.LE.1)
      EVONOL = NOCC.GT.0
C
C --- INSTANT INITIAL
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<THERNONLINE> ... INSTANT INITIAL'
      ENDIF
      CALL NMDOIN(EVOL  ,EVONOL,INSTIN,NUMEIN)
      IF (NIV.GE.2) THEN
        IF (INSTIN.EQ.R8VIDE()) THEN
          WRITE (IFM,*) '<THERNONLINE> ...... NON DEFINI PAR ETAT_INIT'
        ELSE
          WRITE (IFM,*) '<THERNONLINE> ...... VALEUR    : ',INSTIN
          WRITE (IFM,*) '<THERNONLINE> ...... NUME_ORDRE: ',NUMEIN
        ENDIF  
      ENDIF       
C
C --- PAS DE PRECISION --> C'EST UN CALCUL STATIONNAIRE
C
      CALL GETFAC(MOTFAC,NOCC)
      IF (NOCC .EQ. 0 ) THEN
        LOSTAT = .TRUE.
        INITPR = -1
        CALL VTZERO(VTEMP)
      ELSE
        DO 10 NRPASE = NBPASE,0,-1
C
C ------- NOM DES CHAMPS
C
          IAUX = NRPASE
          JAUX = 4
          CALL PSNSLE(INPSCO,IAUX  ,JAUX  ,VTEMP ) 
          CALL JEVEUO(VTEMP(1:19)//'.VALE','E',JTEMP)
C
          IF (EVONOL) THEN
C
C --------- ETAT INITIAL DEFINI PAR UN CONCEPT DE TYPE EVOL_THER
C
            IF (NRPASE.GT.0) THEN
              JAUX = 3
              CALL PSNSLE(INPSCO,IAUX  ,JAUX  ,RESULS)
              RESULT = RESULS
            ELSE
              RESULT = EVOL(1:8)
            ENDIF
C
C --------- LECTURE DES TEMPERATURES (OU DERIVE)
C            
            INITPR = 3
            CALL RSEXCH(RESULT,'TEMP',NUMEIN,CHAMP,IRET)
            IF (IRET.EQ.0) THEN
              CALL VTCOPY(CHAMP,VTEMP )
            ELSE
              CALL U2MESK('F','THERNONLINE4_41',1,EVOL  )
            ENDIF
C
C --------- LECTURE DE L'HYDRATATION
C
            IF (LNONL) THEN
              CALL RSEXCH(RESULT,'HYDR_ELNO',NUMEIN,CHAMP ,IRET)
              IF (IRET.GT.0) THEN
                LHYD0 = .TRUE.
              ELSE
                LHYD0 = .FALSE.
                CALL ASSERT(NBPASE.EQ.0)
                CALL COPISD('CHAMP_GD','V',CHAMP,VHYDR)
              ENDIF
            ENDIF
          ELSE
C
C --------- TEMPERATURE INITIALE STATIONNAIRE
C
            CALL GETVTX(MOTFAC,'STATIONNAIRE',1,1,1,REPSTA,N1)
            IF ( N1 .GT. 0 ) THEN
              IF ( REPSTA(1:3) .EQ. 'OUI' ) THEN
                LOSTAT = .TRUE.
                INITPR = 0
              ENDIF
            ENDIF
C
C --------- TEMPERATURE INITIALE UNIFORME
C
            CALL GETVR8(MOTFAC,'VALE',1,1,1,TEMPCT,N1)
            IF (N1.GT.0) THEN
              INITPR = 1
              DO 222  I = 1 , NEQ
                ZR(JTEMP+I-1) = TEMPCT
  222         CONTINUE
            ENDIF         
C
C --------- RECUPERATION D'UN CHAM_NO DE TEMPERATURE
C
            CALL GETVID(MOTFAC,'CHAM_NO',1,1,1,CHAMP,N1)
            IF (N1.GT.0) THEN
              INITPR = 2
              CALL CHPVER('F',CHAMP(1:19),'NOEU','TEMP_R',IERD)
              CALL DISMOI('F','TYPE_RESU',CHAMP,'RESULTAT',IBID,
     &                    TYPRES,IERD)
              IF (TYPRES.EQ.'CHAMP') THEN
                CALL VTCOPY(CHAMP,VTEMP)
              ELSE
                CALL ASSERT(.FALSE.)
              ENDIF
            ENDIF
C            
C --------- TEMPERATURE UNIFORME OU CHAMP AU NOEUDS==> PB DERIVEE INITI
C --------- ALISE PAR UN CAUCHY NUL.
C
            IF ( NRPASE.NE.0 ) THEN
              IF ((INITPR.EQ.1).OR.(INITPR.EQ.2)) THEN
                CALL VTZERO(VTEMP)
              ENDIF
            ENDIF
            
          ENDIF  
  10    CONTINUE
      ENDIF
C
      IF (LHYD0) THEN
        CALL COPISD('CHAMP_GD','V',HYDZER,VHYDR)
      ENDIF
C
      CALL DETRSD('CHAMP',HYDRIC)
      CALL DETRSD('CHAMP',HYDRIS)
      CALL DETRSD('CHAMP',HYDZER)
      CALL JEDEMA()
C
      END
