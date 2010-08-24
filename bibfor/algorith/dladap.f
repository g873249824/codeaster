      SUBROUTINE DLADAP(TINIT,LCREA,LAMORT,NEQ,IMAT,
     &                  MASSE,RIGID,AMORT,
     &                  DEP0,VIT0,ACC0,
     &                  NCHAR,NVECA,LIAD,LIFO,
     &                  MODELE,MATE,CARELE,
     &                  CHARGE,INFOCH,FOMULT,NUMEDD,NUME,INPSCO,NBPASE)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2010   AUTEUR COURTOIS M.COURTOIS 
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
C TOLE CRP_20 CRP_21
C     ------------------------------------------------------------------
C     CALCUL MECANIQUE TRANSITOIRE PAR INTEGRATION DIRECTE
C     AVEC  METHODE EXPLICITE :  DIFFERENCES CENTREES AVEC PAS
C     ADAPTATIF
C
C     ------------------------------------------------------------------
C
C  HYPOTHESES :                                                "
C  ----------   SYSTEME CONSERVATIF DE LA FORME  K.U    +    M.U = F
C           OU                                           '     "
C               SYSTEME DISSIPATIF  DE LA FORME  K.U + C.U + M.U = F
C
C     ------------------------------------------------------------------
C  IN  : TINIT     : INSTANT DE CALCUL INITIAL
C  IN  : LCREA     : LOGIQUE INDIQUANT SI IL Y A REPRISE
C  IN  : LAMORT    : LOGIQUE INDIQUANT SI IL Y A AMORTISSEMENT
C  IN  : NEQ       : NOMBRE D'EQUATIONS
C  IN  : IMAT      : TABLEAU D'ADRESSES POUR LES MATRICES
C  IN  : MASSE     : MATRICE DE MASSE
C  IN  : RIGID     : MATRICE DE RIGIDITE
C  IN  : AMORT     : MATRICE D'AMORTISSEMENT
C  IN  : NCHAR     : NOMBRE D'OCCURENCES DU MOT CLE CHARGE
C  IN  : NVECA     : NOMBRE D'OCCURENCES DU MOT CLE VECT_ASSE
C  IN  : LIAD      : LISTE DES ADRESSES DES VECTEURS CHARGEMENT (NVECT)
C  IN  : LIFO      : LISTE DES NOMS DES FONCTIONS EVOLUTION (NVECT)
C  IN  : MODELE    : NOM DU MODELE
C  IN  : MATE      : NOM DU CHAMP DE MATERIAU
C  IN  : CARELE    : CARACTERISTIQUES DES POUTRES ET COQUES
C  IN  : CHARGE    : LISTE DES CHARGES
C  IN  : INFOCH    : INFO SUR LES CHARGES
C  IN  : FOMULT    : LISTE DES FONC_MULT ASSOCIES A DES CHARGES
C  IN  : NUMEDD    : NUME_DDL DE LA MATR_ASSE RIGID
C  IN  : NUME      : NUMERO D'ORDRE DE REPRISE
C  IN  : NBPASE   : NOMBRE DE PARAMETRE SENSIBLE
C  IN  : INPSCO   : STRUCTURE CONTENANT LA LISTE DES NOMS (CF. PSNSIN)
C  VAR : DEP0      : TABLEAU DES DEPLACEMENTS A L'INSTANT N
C  VAR : VIT0      : TABLEAU DES VITESSES A L'INSTANT N
C  VAR : ACC0      : TABLEAU DES ACCELERATIONS A L'INSTANT N
C
C
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER      NBPASE
      INTEGER      NEQ,IMAT(*),LIAD(*),NCHAR,NVECA,NUME

      CHARACTER*8  MASSE, RIGID, AMORT
      CHARACTER*13 INPSCO
      CHARACTER*24 MODELE, CARELE, CHARGE, FOMULT, MATE, NUMEDD
      CHARACTER*24 INFOCH, LIFO(*)
C
      REAL*8       DEP0(*),VIT0(*),ACC0(*),TINIT
C
      LOGICAL      LAMORT, LCREA

C    ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ---------------------------

      INTEGER NBTYAR
      PARAMETER ( NBTYAR = 3 )
      INTEGER NRORES
      INTEGER IFM, NIV, ETAUSR
      INTEGER IAUX, JAUX
      INTEGER IV, IV1, IV2
      INTEGER JDEPL, JDEP2
      INTEGER JVITE, JVIT2
      INTEGER JACCE, JACC2
      INTEGER JIND1, JIND2
      INTEGER JVIP1, JVIP2
      INTEGER JVMIN, JVMIN1, JVMIN2
      INTEGER ISTOC
      INTEGER NDDL
      INTEGER IWK0
      INTEGER VALI(3)
      CHARACTER*4   TYP1(3)
      CHARACTER*8   K8B, NOMRES
      CHARACTER*8   VVAR
      CHARACTER*16  TYPRES, NOMCMD,TYPEAR(NBTYAR)
      CHARACTER*24  SOP
      CHARACTER*24  NDEEQ
      REAL*8        TPS1(4),TFIN
      REAL*8        CMP,CDP,CPMIN,ERR,DTI,DT1,DT2,DTMIN,PAS1
      REAL*8        TEMPS,TEMP2,DTMAX
      REAL*8        DTARCH,TARCH,TARCHI
      REAL*8        EPSI,R8VAL,FREQ
      REAL*8        TJOB
      REAL*8 PAS2
      REAL*8 VALR(3)
      REAL*8 R8PREM
      INTEGER       IWK1,IWK2,IFORC1
      INTEGER       NPER,NRMAX,NR,NPAS,IPAS,IPARCH,IARCHI
      INTEGER       NNC,NBEXCL,NBIPAS,IVERI,NBORDR,NBITER
      INTEGER       NBPASC
      INTEGER       ADEEQ
      INTEGER       NRPASE, IBID
C
C     -----------------------------------------------------------------
      CALL JEMARQ()
C
C====
C 1. LES DONNEES DU CALCUL
C====
C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION

      CALL INFNIV(IFM,NIV)
C
C 1.2. ==> NOM DES STRUCTURES
C     --- RECUPERATION NOM DE LA COMMANDE ---

      CALL GETRES ( NOMRES, TYPRES, NOMCMD )
C
      NDEEQ = NUMEDD(1:8)//'      .NUME.DEEQ'
C
C     --- VECTEURS DE TRAVAIL SUR BASE VOLATILE ---
C
      CALL WKVECT('&&DLADAP.FORCE1','V V R',NEQ,IFORC1)
      CALL WKVECT('&&DLADAP.F0'    ,'V V R',NEQ,IWK0  )
      CALL WKVECT('&&DLADAP.F1'    ,'V V R',NEQ,IWK1  )
      CALL WKVECT('&&DLADAP.F2'    ,'V V R',NEQ,IWK2  )
      CALL WKVECT('&&DLADAP.DEPL','V V R',NEQ,JDEPL)
      CALL WKVECT('&&DLADAP.DEP2','V V R',NEQ,JDEP2)
      CALL WKVECT('&&DLADAP.VITE','V V R',NEQ,JVITE)
      CALL WKVECT('&&DLADAP.VIT2','V V R',NEQ,JVIT2)
      CALL WKVECT('&&DLADAP.VIP1','V V R',NEQ,JVIP1)
      CALL WKVECT('&&DLADAP.VIP2','V V R',NEQ,JVIP2)
      CALL WKVECT('&&DLADAP.ACCE','V V R',NEQ,JACCE)
      CALL WKVECT('&&DLADAP.ACC2','V V R',NEQ,JACC2)
      CALL WKVECT('&&DLADAP.VMIN','V V R',NEQ,JVMIN)
      CALL WKVECT('&&DLADAP.VMIN1','V V R',NEQ,JVMIN1)
      CALL WKVECT('&&DLADAP.VMIN2','V V R',NEQ,JVMIN2)
      CALL WKVECT('&&DLADAP.IND1','V V I',NEQ,JIND1)
      CALL WKVECT('&&DLADAP.IND2','V V I',NEQ,JIND2)
      CALL JEVEUO(NDEEQ,'L',ADEEQ)
C
      EPSI = R8PREM()
      NPAS = 0
      IARCHI = NUME
C
C 1.4. ==> PARAMETRES D'INTEGRATION
C
      CALL GETVR8('INCREMENT','INST_FIN',1,1,1,TFIN,IBID)
      CALL GETVR8('INCREMENT','PAS',1,1,1,DTI,IBID)
      IF (IBID.EQ.0)
     &   CALL U2MESS('F','ALGORITH3_11')
      IF (DTI.EQ.0.D0)
     &   CALL U2MESS('F','ALGORITH3_12')
      CALL RECPAR(NEQ,DTMAX,ZR(JVMIN),VVAR,CMP,CDP,CPMIN,NPER,NRMAX)
      DTMIN = DTI * CPMIN
      NBORDR = INT((TFIN-TINIT)/DTI)+2
      NBIPAS = INT((TFIN-TINIT)/DTI)+1
C
C 1.5. ==> EXTRACTION DIAGONALE M ET CALCUL VITESSE INITIALE
C
      CALL DISMOI('C','SUR_OPTION',MASSE,'MATR_ASSE',IBID,SOP,IBID)
      IF (SOP.EQ.'MASS_MECA_DIAG') THEN
        CALL EXTDIA (MASSE, NUMEDD, 2, ZR(IWK1))
      ELSE
        CALL U2MESS('F','ALGORITH3_13')
      ENDIF
C
      DO 15 , IAUX=1, NEQ
C
        IF (ZR(IWK1+IAUX-1).NE.0.D0) THEN
C
          ZR(IWK1+IAUX-1)=1.0D0/ZR(IWK1+IAUX-1)
          NDDL = ZI(ADEEQ + 2*IAUX-1)
          DO 151 IV1 = 1,NEQ
            IV2=IAUX+IV1
            IF (IV2.LE.NEQ) THEN
              IF (ZI(ADEEQ+2*IV2-1).EQ.NDDL) THEN
                ZI(JIND2+IAUX-1) = IV2
                GOTO 152
              ENDIF
            ELSE
              GOTO 152
            ENDIF
  151     CONTINUE
C
  152     CONTINUE
C
          DO 153 IV1 = 1,NEQ
            IV2=IAUX-IV1
            IF (IV2.GT.0) THEN
              IF (ZI(ADEEQ+2*IV2-1).EQ.NDDL) THEN
                ZI(JIND1+IAUX-1) = IV2
                GOTO 154
              ENDIF
            ELSE
              GOTO 154
            ENDIF
  153     CONTINUE
C
  154     CONTINUE
C
        ENDIF
C
   15 CONTINUE
C
C 1.6. ==> AFFECTATION DES VECTEURS INITIAUX
C
      DO 16 , IAUX=1,NEQ
        DO 161 , NRORES = 0 , NBPASE
C
          NRPASE = NRORES
          ZR(JDEPL+IAUX-1) = DEP0(IAUX+NEQ*NRPASE)
          ZR(JVITE+IAUX-1) = VIT0(IAUX+NEQ*NRPASE)-
     &                       0.5D0*DTI*ACC0(IAUX+NEQ*NRPASE)
          ZR(JVIP1+IAUX-1) = VIT0(IAUX+NEQ*NRPASE)
          ZR(JACCE+IAUX-1) = ACC0(IAUX+NEQ*NRPASE)
  161   CONTINUE
        ZR(JVMIN1+IAUX-1) = 1.D-15
        ZR(JVMIN2+IAUX-1) = 1.D-15
   16 CONTINUE
C
C 1.7. ==> --- ARCHIVAGE ---
C
      TARCHI = TINIT
      NBEXCL = 0
      TYPEAR(1) = 'DEPL'
      TYPEAR(2) = 'VITE'
      TYPEAR(3) = 'ACCE'
      CALL GETVIS('ARCHIVAGE','PAS_ARCH',1,1,1,IPARCH,IBID)
      IF(IBID .EQ. 0) IPARCH=1
      DTARCH = DTI * IPARCH
      CALL GETVTX('ARCHIVAGE','CHAM_EXCLU' ,1,1,0,K8B,NNC)
      IF (NNC.NE.0) THEN
          NBEXCL = -NNC
          CALL GETVTX('ARCHIVAGE','CHAM_EXCLU' ,1,1,NBEXCL,TYP1,NNC)
      ENDIF
C
      IF ( NBEXCL.EQ.NBTYAR ) THEN
        CALL U2MESS('F','ALGORITH3_14')
      ENDIF
      DO 17 , IAUX = 1,NBEXCL
        IF (TYP1(IAUX).EQ.'DEPL') THEN
          TYPEAR(1) = '    '
        ELSEIF (TYP1(IAUX).EQ.'VITE') THEN
          TYPEAR(2) = '    '
        ELSEIF (TYP1(IAUX).EQ.'ACCE') THEN
          TYPEAR(3) = '    '
        ENDIF
   17 CONTINUE
C
C 1.8. ==> --- AFFICHAGE DE MESSAGES SUR LE CALCUL ---
C
      WRITE(IFM,*) '-------------------------------------------------'
      WRITE(IFM,*) '--- CALCUL PAR INTEGRATION TEMPORELLE DIRECTE ---'
      WRITE(IFM,*) '! LA MATRICE DE MASSE EST         : ',MASSE
      WRITE(IFM,*) '! LA MATRICE DE RIGIDITE EST      : ',RIGID
      IF ( LAMORT ) WRITE(IFM,*)
     &'! LA MATRICE D''AMORTISSEMENT EST : ',AMORT
      WRITE(IFM,*) '! LE NB D''EQUATIONS EST          : ',NEQ
      IF ( NUME.NE.0 ) WRITE(IFM,*)
     &'! REPRISE A PARTIR DU NUME_ORDRE  : ',NUME
      WRITE(IFM,*)'! L''INSTANT INITIAL EST        : ',TINIT
      WRITE(IFM,*)'! L''INSTANT FINAL EST          : ',TFIN
      WRITE(IFM,*)'! LE PAS DE TEMPS MAX DU CALCUL EST : ',DTI
      WRITE(IFM,*)'! LE NB MIN DE PAS DE CALCUL EST    : ',NBIPAS
      WRITE(IFM,*) '----------------------------------------------',' '
C
C====
C 2. BOUCLE SUR CREATION DES CONCEPTS RESULTAT
C====
C
      DO 21 , NRORES = 0 , NBPASE
C
        NRPASE = NRORES
        IAUX = 1 + NEQ*NRPASE
        JAUX = NBTYAR

        CALL DLTCRR ( NRPASE, INPSCO,
     &                NEQ, NBORDR, IARCHI, 'PREMIER(S)', IFM,
     &                TINIT, LCREA, TYPRES,
     &                MASSE, RIGID, AMORT,
     &                DEP0(IAUX), VIT0(IAUX), ACC0(IAUX),
     &                NUMEDD, NUME, JAUX, TYPEAR )

   21 CONTINUE

      CALL TITRE
C
C====
C 3. CALCUL : BOUCLE SUR LES PAS DE TEMPS
C====
C
          NRORES = 0
      IPAS = 0
      NBITER = 0
      IVERI = 0
      TJOB = 0.D0
      NBPASC = 0
      TEMPS = TINIT
      TARCH = TINIT + DTARCH
      DT1 = 0.D0
      DT2 = DTI
      CALL UTTCPU('CPU.DLADAP', 'INIT',' ')
      NRPASE = 0
C
   30 CONTINUE
C
      IF (TEMPS.LT.TFIN) THEN
        ISTOC = 0
        ERR = 100.D0
        NR = 0
        IF (IVERI.EQ.0) THEN
          CALL UTTCPU('CPU.DLADAP', 'DEBUT',' ')
        ELSE
          IF (MOD(IVERI,NBPASC).EQ.0) THEN
            CALL UTTCPU('CPU.DLADAP', 'DEBUT',' ')
          ENDIF
        ENDIF
C
C        --- DERNIER PAS DE TEMPS ? ---
        IF (TEMPS+DT2 .GT. TFIN) DT2 = TFIN-TEMPS
 101    CONTINUE
        IF (ERR .GT. 1.D0 .AND. NR .LT. NRMAX) THEN
          NBITER = NBITER + 1
          PAS1 = (DT1+DT2)*0.5D0
          PAS2 = DT2*0.5D0
          DO 102 IAUX = 0,NEQ-1
C            --- VITESSES AUX INSTANTS INTERMEDIAIRES ------
             ZR(JVIT2+IAUX) = ZR(JVITE+IAUX) + PAS1 * ZR(JACCE+IAUX)
C            --- DEPLACEMENTS AUX INSTANTS 'TEMPS+DT2' ---------
             ZR(JDEP2+IAUX) = ZR(JDEPL+IAUX) + (DT2 * ZR(JVIT2+IAUX))
 102      CONTINUE
C ------------- CALCUL DU SECOND MEMBRE F*
          R8VAL = TEMPS+DT2
          CALL DLFEXT ( NVECA,NCHAR,R8VAL,NEQ,
     &                   LIAD,LIFO,CHARGE,INFOCH,FOMULT,
     &                   MODELE,MATE,CARELE,NUMEDD,
     &                   NBPASE,NRPASE,INPSCO,ZR(IFORC1))
C
C ------------- FORCE DYNAMIQUE F* = F* - K DEP - C VIT
          CALL DLFDYN ( IMAT(1),IMAT(3),LAMORT,NEQ,
     &                ZR(JDEP2),ZR(JVIT2),ZR(IFORC1),ZR(IWK0))
C
C ------------- RESOLUTION DE M . A = F ET CALCUL DE VITESSE STOCKEE
C           --- RESOLUTION AVEC FORCE1 COMME SECOND MEMBRE ---
          DO 20 IAUX=1, NEQ
                ZR(JACC2+IAUX-1)=ZR(IWK1+IAUX-1)*ZR(IFORC1+IAUX-1)
C           --- VITESSE AUX INSTANTS 'TEMPS+DT2' ---
                ZR(JVIP2+IAUX-1)=ZR(JVIT2+IAUX-1)+PAS2*ZR(JACC2+IAUX-1)
 20       CONTINUE
C
C        --- CALCUL DE VMIN ---
          IF (VVAR(1:4) .EQ. 'MAXI') THEN
            DO 109 IV = 0,NEQ-1
              ZR(JVMIN+IV) = MAX(ZR(JVMIN+IV),
     &                ABS(ZR(JVITE+IV)*1.D-02))
 109        CONTINUE
          ELSEIF (VVAR(1:4) .EQ. 'NORM') THEN
            DO 110 IV = 0,NEQ-1
              IF (ZR(IWK1+IV).NE.0.D0) THEN
               ZR(JVMIN1+IV)=1.D-02*ZR(JVIT2+(ZI(JIND1+IV)-1))
               ZR(JVMIN2+IV)=1.D-02*ZR(JVIT2+(ZI(JIND2+IV)-1))
              ENDIF
              ZR(JVMIN+IV)=MAX(1.D-15,ZR(JVMIN1+IV),
     &                    ZR(JVMIN2+IV))
 110        CONTINUE
          ENDIF
C
C        --- CALCUL DE FREQ. APPARENTE ET ERREUR ---
          CALL FRQAPP(DT2,NEQ,ZR(JDEPL),ZR(JDEP2),
     &            ZR(JACCE),ZR(JACC2),ZR(JVMIN),FREQ)
          ERR = NPER * FREQ * DT2
C
C       --- REDUCTION DU PAS DE TEMPS ---
          IF (ERR .GT. 1.D0) DT2 = DT2/CDP
          IF (DT2.LE.DTMIN .AND. ABS(TFIN-(TEMPS+DT2)).GT.EPSI) THEN
            CALL U2MESS('F','ALGORITH3_17')
          ENDIF
          NR = NR + 1
C       LES DEUX LIGNES SUIVANTES SIMULENT LE WHILE - CONTINUE
          GOTO 101
        ELSE IF (ERR .GT. 1.D0 .AND. NR .GE. NRMAX) THEN
          VALR(1) = TEMPS+DT2
          VALR(2) = ERR
          VALR(3) = DT2
          CALL U2MESG('A', 'ALGORITH3_16',0,' ',1,NRMAX,3,VALR)
        ENDIF
C
        DT1 = DT2
        TEMP2 = TEMPS + DT2
C
C        --- AUGMENTATION DU PAS SI ERREUR TROP FAIBLE ---
        IF(ERR .LT. 0.75D0) THEN
          IF(NPAS .EQ. 5) THEN
            DT2 = CMP*DT2
            DT2 = MIN(DT2,DTI)
            NPAS = 4
          ENDIF
          NPAS = NPAS + 1
        ELSE
          NPAS = 0
        ENDIF
        IPAS = IPAS + 1
C
C       --- ARCHIVAGE EVENTUEL DANS L'OBJET SOLUTION ---
        IF((TEMPS.LE.TARCH .AND. TEMP2.GE.TARCH) .OR.
     &     (TEMP2.EQ.TFIN)) THEN
          ISTOC = 0
          JAUX = 1
          IF((TEMP2-TARCH).LE.(TARCH-TEMPS)) THEN
            TARCHI = TEMP2
            CALL DLARCH ( NRORES, INPSCO,
     &                    NEQ, ISTOC, IARCHI, ' ',
     &                    JAUX, IFM, TEMP2,
     &                    NBTYAR, TYPEAR, MASSE,
     &                    ZR(JDEP2), ZR(JVIP2), ZR(JACC2) )
          ELSE
            TARCHI = TEMPS
            CALL DLARCH ( NRORES, INPSCO,
     &                    NEQ, ISTOC, IARCHI, ' ',
     &                    JAUX, IFM, TEMPS,
     &                    NBTYAR, TYPEAR, MASSE,
     &                    ZR(JDEPL), ZR(JVIP1), ZR(JACCE) )
          ENDIF
          TARCH = TARCH + DTARCH
        ENDIF
C
C ------------- TRANSFERT DES NOUVELLES VALEURS DANS LES ANCIENNES
        TEMPS = TEMP2
        CALL DCOPY(NEQ ,ZR(JDEP2),1,ZR(JDEPL), 1)
        CALL DCOPY(NEQ ,ZR(JVIT2),1,ZR(JVITE), 1)
        CALL DCOPY(NEQ ,ZR(JVIP2),1,ZR(JVIP1), 1)
        CALL DCOPY(NEQ ,ZR(JACC2),1,ZR(JACCE), 1)
C
C ------------- VERIFICATION DU TEMPS DE CALCUL RESTANT
        IF (IVERI.EQ.0) THEN
          CALL UTTCPU('CPU.DLADAP', 'FIN',' ')
          CALL UTTCPR('CPU.DLADAP', 4, TPS1)
          TJOB = TPS1(1)
          IF (TPS1(4) .EQ. 0.D0) TPS1(4)=1.D-02
          NBPASC = INT(1.D-02 * (TPS1(1)/TPS1(4)))+1
        ELSE
          IF (MOD(IVERI,NBPASC).EQ.0) THEN
            CALL UTTCPU('CPU.DLADAP', 'FIN',' ')
            CALL UTTCPR('CPU.DLADAP', 4, TPS1)
            IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN
             GOTO 9999
            ENDIF
            IF (TPS1(4) .EQ. 0.D0) TPS1(4)=1.D-02
            NBPASC = INT(1.D-02 * (TJOB/TPS1(4)))+1
          ENDIF
        ENDIF
        IVERI = IVERI + 1
C
        GOTO 30
      ENDIF
C
 9999 CONTINUE
C
C====
C 4. ARCHIVAGE DU DERNIER INSTANT DE CALCUL POUR LES CHAMPS QUI ONT
C    ETE EXCLUS DE L'ARCHIVAGE AU FIL DES PAS DE TEMPS
C====
C
      IF ( NBEXCL.NE.0 ) THEN
C
        DO 41 , IAUX = 1,NBEXCL
          TYPEAR(IAUX) = TYP1(IAUX)
   41   CONTINUE
C
        JAUX = 0
        DO 42 , NRORES = 0 , NBPASE

          NRPASE = NRORES
          IAUX = NEQ*NRPASE
C
          CALL DLARCH ( NRORES, INPSCO,
     &                  NEQ, ISTOC, IARCHI, 'DERNIER(S)',
     &                  JAUX, IFM, TEMPS,
     &                  NBTYAR, TYPEAR, MASSE,
     &                  ZR(JDEPL+IAUX), ZR(JVIP1+IAUX),
     &                  ZR(JACCE+IAUX) )
C
   42   CONTINUE
C
      ENDIF
C
C====
C 5. LA FIN
C====
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
      IF ( ETAUSR().EQ.1 ) THEN
         CALL SIGUSR()
      ENDIF
C
      IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN
        VALI(1) = IPAS
        VALI(2) = IARCHI
        VALI(3) = NBPASC
        VALR(1) = TARCHI
        VALR(2) = NBPASC*TPS1(4)
        VALR(3) = TPS1(1)
        CALL UTEXCM(28, 'DYNAMIQUE_11', 0, ' ', 3, VALI, 3, VALR)
      ENDIF
C
      VALI(1) = IPAS
      VALI(2) = NBITER
      CALL U2MESG('I', 'ALGORITH3_21',0,' ',2,VALI,8,VALR)
C
C     --- DESTRUCTION DES OBJETS DE TRAVAIL ---
C
      CALL JEDETC('V','.CODI',20)
      CALL JEDETC('V','.MATE_CODE',9)
C
      CALL JEDEMA()
      END
