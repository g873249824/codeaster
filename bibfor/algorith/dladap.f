      SUBROUTINE DLADAP(TINIT,LCREA,LAMORT,NEQ,IMAT,
     &                  MASSE,RIGID,AMORT,
     &                  DEP0,VIT0,ACC0,
     &                  NCHAR,NVECA,LIAD,LIFO,
     &                  MODELE,MATE,CARELE,
     &                  CHARGE,INFOCH,FOMULT,NUMEDD,NUME)
      IMPLICIT  REAL*8  (A-H,O-Z)
      CHARACTER*8  MASSE, RIGID, AMORT
      CHARACTER*24 MODELE, CARELE, CHARGE, FOMULT, MATE, NUMEDD
      CHARACTER*24 INFOCH, LIFO(*)
      REAL*8       DEP0(*),VIT0(*),ACC0(*),TINIT
      INTEGER      NEQ,IMAT(*),LIAD(*),NCHAR,NVECA,NUME
      LOGICAL      LAMORT, LCREA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/1999   AUTEUR SABJLMA P.LATRUBESSE 
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
C  VAR : DEP0      : TABLEAU DES DEPLACEMENTS A L'INSTANT N
C  VAR : VIT0      : TABLEAU DES VITESSES A L'INSTANT N
C  VAR : ACC0      : TABLEAU DES ACCELERATIONS A L'INSTANT N
C
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

      CHARACTER*4   TYP1(3)
      CHARACTER*8   K8B, NOMRES
      CHARACTER*8   VVAR
      CHARACTER*16  TYPRES, NOMCMD,TYPE(3)
      CHARACTER*19  KREFE
      CHARACTER*24  CHAMNO
      CHARACTER*24  SOP
      CHARACTER*24  NDEEQ
      REAL*8        TPS1(4),TFIN,DTM
      REAL*8        CMP,CDP,CPMIN,ERR,DTI,DT1,DT2,DTMIN,PAS1
      REAL*8        TEMPS,TEMP2
      REAL*8        DTARCH,TARCH,TARCHI
      REAL*8        EPSI,R8VAL,FREQ,TMP
      REAL*8        DMIN,DMAX,VMIN,DD,RAPP
      REAL*8        TJOB
      INTEGER       IWK1,IWK2,IFORC1
      INTEGER       NPER,NRMAX,NR,NPAS,IPAS,IPARCH,IARCHI
      INTEGER       NNC,NBEXCL,NBIPAS,IVERI,NBSAUV,NBITER
      INTEGER       NBPASC
      INTEGER       ADEEQ
C
C     -----------------------------------------------------------------
      CALL JEMARQ()
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV(IFM,NIV)
C
C     --- RECUPERATION NOM DE LA COMMANDE ---
C
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
C     --- PARAMETRES D'INTEGRATION ---
C
      CALL GETVR8('INCREMENT','INST_FIN',1,1,1,TFIN,N1)
      CALL GETVR8('INCREMENT','PAS',1,1,1,DTI,N1)
      IF (N1.EQ.0) 
     +   CALL UTMESS('F','DLADAP','METHODE A PAS ADAPTATIF '//
     +               ' LA DONNEE DU PAS EST OBLIGATOIRE ')
      IF (DTI.EQ.0.D0) 
     +   CALL UTMESS('F','DLADAP','METHODE A PAS ADAPTATIF'//
     +               ' LE PAS NE PEUT PAS ETRE NUL  ')
      CALL RECPAR(NEQ,ZR(JVMIN),VVAR,CMP,CDP,CPMIN,NPER,NRMAX)
      DTMIN = DTI * CPMIN
      NBSAUV = INT((TFIN-TINIT)/DTI)+2
      NBIPAS = INT((TFIN-TINIT)/DTI)+1
C
C     --- AFFECTATION DES VECTEURS INITIAUX ------
      DO 201 I=1,NEQ
        ZR(JDEPL+I-1) = DEP0(I)
        ZR(JVITE+I-1) = VIT0(I)-0.5D0*DTI*ACC0(I)
        ZR(JVIP1+I-1) = VIT0(I)
        ZR(JACCE+I-1) = ACC0(I)
        ZR(JVMIN1+I-1) = 1.D-15
        ZR(JVMIN2+I-1) = 1.D-15
 201  CONTINUE      
C
C     --- EXTRACTION DIAGONALE M ---
C     --- ET ALLOCATION DES TABLX DES INDICES DE DDLS EQUIVALENTS
C     --- POUR LE CALCUL DE VMIN ---
      CALL DISMOI ('I','SUR_OPTION',MASSE,'MATR_ASSE',IBID,SOP,IE)
      IF (SOP.EQ.'MASS_MECA_DIAG') THEN
        CALL EXTDIA (MASSE, NUMEDD, 2, ZR(IWK1))
      ELSE
        CALL UTMESS ('F','DLADAP_01','LES MATRICES DE MASSE '
     &             //'ELEMENTAIRES DOIVENT OBLIGATOIREMENT AVOIR '
     &             //'ETE CALCULEES AVEC L''OPTION MASS_MECA_DIAG')
      ENDIF
      DO 10 I=1, NEQ
        IF (ZR(IWK1+I-1).NE.0.D0) THEN
           ZR(IWK1+I-1)=1.0D0/ZR(IWK1+I-1)
           NDDL = ZI(ADEEQ + 2*I-1)
           DO 12 IV1 = 1,NEQ
             IV2=I+IV1
             IF (IV2.LE.NEQ) THEN
               IF (ZI(ADEEQ+2*IV2-1).EQ.NDDL) THEN
                 ZI(JIND2+I-1) = IV2
                 GOTO 13
               ENDIF
             ELSE
               GOTO 13
             ENDIF
 12        CONTINUE
 13        CONTINUE
           DO 14 IV1 = 1,NEQ
             IV2=I-IV1
             IF (IV2.GT.0) THEN
               IF (ZI(ADEEQ+2*IV2-1).EQ.NDDL) THEN
                 ZI(JIND1+I-1) = IV2
                 GOTO 15
               ENDIF
             ELSE
               GOTO 15
             ENDIF
 14        CONTINUE
 15        CONTINUE
        ENDIF
 10   CONTINUE      
C
C     --- ARCHIVAGE ---
C
      TARCHI = TINIT
      NBSORT = 3
      NBEXCL = 0
      TYPE(1) = 'DEPL'
      TYPE(2) = 'VITE'
      TYPE(3) = 'ACCE'
      CALL GETVIS('ARCHIVAGE','PAS_ARCH',1,1,1,IPARCH,N1)
      IF(N1 .EQ. 0) IPARCH=1
      DTARCH = DTI * IPARCH            
      CALL GETVTX('ARCHIVAGE','CHAM_EXCLU' ,1,1,0,K8B,NNC)
      IF (NNC.NE.0) THEN
          NBEXCL = -NNC
          CALL GETVTX('ARCHIVAGE','CHAM_EXCLU' ,1,1,NBEXCL,TYP1,NNC)
      ENDIF
C    
      IF ( NBEXCL .EQ. NBSORT )
     +   CALL UTMESS('F',NOMCMD,'ON ARCHIVE AU MOINS UN CHAMP.')
      DO 50 I = 1,NBEXCL
         IF (TYP1(I).EQ.'DEPL') THEN
            TYPE(1) = '    '
         ELSEIF (TYP1(I).EQ.'VITE') THEN
            TYPE(2) = '    '
         ELSEIF (TYP1(I).EQ.'ACCE') THEN
            TYPE(3) = '    '
         ENDIF
 50   CONTINUE
C
C     --- AFFICHAGE DE MESSAGES SUR LE CALCUL ---
C
      WRITE(IFM,*)
     +'-------------------------------------------------'
      WRITE(IFM,*)
     +'--- CALCUL PAR INTEGRATION TEMPORELLE DIRECTE ---'
      WRITE(IFM,*)
     +'! LA MATRICE DE MASSE EST         : ',MASSE
      WRITE(IFM,*)
     +'! LA MATRICE DE RIGIDITE EST      : ',RIGID
      IF ( LAMORT ) WRITE(IFM,*)
     +'! LA MATRICE D''AMORTISSEMENT EST : ',AMORT
      WRITE(IFM,*)
     +'! LE NB D''EQUATIONS EST          : ',NEQ
      IF ( NUME.NE.0 ) WRITE(IFM,*)
     +'! REPRISE A PARTIR DU NUME_ORDRE  : ',NUME
      WRITE(IFM,*)'! L''INSTANT INITIAL EST        : ',TINIT
      WRITE(IFM,*)'! L''INSTANT FINAL EST          : ',TFIN
      WRITE(IFM,*)'! LE PAS DE TEMPS MAX DU CALCUL EST : ',DTI
      WRITE(IFM,*)'! LE NB MIN DE PAS DE CALCUL EST    : ',NBIPAS
      WRITE(IFM,*)
     +'----------------------------------------------',' '
C
C     --- CREATION DE LA STRUCTURE DE DONNEE RESULTAT ---
C
      IF ( LCREA ) THEN
         IARCHI = 0
         CALL RSCRSD(NOMRES,TYPRES,NBSAUV)
         KREFE(1:19) = NOMRES
         CALL WKVECT(KREFE//'.REFE','G V K24',3,LREFE)
         ZK24(LREFE  ) = MASSE
         ZK24(LREFE+1) = AMORT
         ZK24(LREFE+2) = RIGID
         CALL JELIBE(KREFE//'.REFE')
C
         DO 30 ITYPE = 1, NBSORT
            IF ( TYPE(ITYPE) .EQ. '    ' ) GOTO 30
            CALL RSEXCH(NOMRES,TYPE(ITYPE),IARCHI,CHAMNO,IER)
            IF ( IER .EQ. 0 ) THEN
            CALL UTMESS('A',NOMCMD,'CHAMP "'//CHAMNO//'" DEJA EXISTANT')
            ELSE IF ( IER .EQ. 100 ) THEN
               CALL VTCREM(CHAMNO,MASSE,'G','R')
            ELSE
               CALL UTMESS('F',NOMCMD,'APPEL ERRONE')
            ENDIF
            CHAMNO(20:24)  = '.VALE'
            CALL JEVEUO(CHAMNO,'E',LVALE)
            IF (ITYPE.EQ.1) THEN
                DO 32 IEQ = 1, NEQ
                   ZR(LVALE+IEQ-1) = DEP0(IEQ)
 32             CONTINUE
            ELSE IF (ITYPE.EQ.2) THEN
                DO 33 IEQ = 1, NEQ
                   ZR(LVALE+IEQ-1) = VIT0(IEQ)
 33             CONTINUE 
            ELSE 
                DO 34 IEQ = 1, NEQ
                   ZR(LVALE+IEQ-1) = ACC0(IEQ)
 34             CONTINUE
            ENDIF  
            CALL JELIBE(CHAMNO)
            CALL RSNOCH(NOMRES,TYPE(ITYPE),IARCHI,' ')
 30      CONTINUE
         CALL RSADPA(NOMRES,'E',1,'INST',IARCHI,0,LINST,K8B)
         ZR(LINST) = TINIT
         WRITE(IFM,1000) (TYPE(ITY),ITY=1,3), IARCHI, TINIT
      ELSE
         NBSAUV = NBSAUV + NUME
         CALL RSAGSD( NOMRES, NBSAUV )
      ENDIF
      CALL TITRE
C
C ------- BOUCLE SUR LES PAS DE TEMPS
      IPAS = 0
      NBITER = 0
      IVERI = 0
      TJOB = 0.D0
      NBPASC = 0
      TEMPS = TINIT
      TARCH = TINIT + DTARCH
      DT1 = 0.D0
      DT2 = DTI
      CALL UTTCPU(1, 'INIT', 4, TPS1)
C
 100  CONTINUE
      IF (TEMPS.LT.TFIN) THEN
        ISTOC = 0
        ERR = 100.D0
        NR = 0
        IF (IVERI.EQ.0) THEN
          CALL UTTCPU(1, 'DEBUT', 4, TPS1)
        ELSE
          IF (MOD(IVERI,NBPASC).EQ.0) THEN
            CALL UTTCPU(1, 'DEBUT', 4, TPS1)
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
          DO 102 I = 0,NEQ-1
C            --- VITESSES AUX INSTANTS INTERMEDIAIRES ------
             ZR(JVIT2+I) = ZR(JVITE+I) + PAS1 * ZR(JACCE+I)
C            --- DEPLACEMENTS AUX INSTANTS 'TEMPS+DT2' ---------
             ZR(JDEP2+I) = ZR(JDEPL+I) + (DT2 * ZR(JVIT2+I))
 102      CONTINUE
C ------------- CALCUL DU SECOND MEMBRE F*
          R8VAL = TEMPS+DT2
          CALL DLFEXT ( NVECA,NCHAR,R8VAL,NEQ,
     +                   LIAD,LIFO,CHARGE,INFOCH,FOMULT,
     +                   MODELE,MATE,CARELE,NUMEDD,ZR(IFORC1))
C
C ------------- FORCE DYNAMIQUE F* = F* - K DEP - C VIT
          CALL DLFDYN ( IMAT(1),IMAT(3),LAMORT,NEQ,
     +                ZR(JDEP2),ZR(JVIT2),ZR(IFORC1),ZR(IWK0))
C
C ------------- RESOLUTION DE M . A = F ET CALCUL DE VITESSE STOCKEE
C           --- RESOLUTION AVEC FORCE1 COMME SECOND MEMBRE ---
          DO 20 IEQ=1, NEQ
                ZR(JACC2+IEQ-1)=ZR(IWK1+IEQ-1)*ZR(IFORC1+IEQ-1)
C           --- VITESSE AUX INSTANTS 'TEMPS+DT2' ---
                ZR(JVIP2+IEQ-1)=ZR(JVIT2+IEQ-1)+PAS2*ZR(JACC2+IEQ-1)
 20       CONTINUE
C
C        --- CALCUL DE VMIN ---
          IF (VVAR(1:4) .EQ. 'MAXI') THEN
            DO 109 IV = 0,NEQ-1
              ZR(JVMIN+IV) = MAX(ZR(JVMIN+IV),
     +                ABS(ZR(JVITE+IV)*1.D-02))
 109        CONTINUE
          ELSEIF (VVAR(1:4) .EQ. 'NORM') THEN
            DO 110 IV = 0,NEQ-1
              IF (ZR(IWK1+IV).NE.0.D0) THEN
               ZR(JVMIN1+IV)=1.D-02*ZR(JVIT2+(ZI(JIND1+IV)-1))
               ZR(JVMIN2+IV)=1.D-02*ZR(JVIT2+(ZI(JIND2+IV)-1))
              ENDIF
              ZR(JVMIN+IV)=MAX(1.D-15,ZR(JVMIN1+IV),
     +                    ZR(JVMIN2+IV))
 110        CONTINUE
          ENDIF
C
C        --- CALCUL DE FREQ. APPARENTE ET ERREUR ---
          CALL FRQAPP(DT2,NEQ,ZR(JDEPL),ZR(JDEP2),
     +            ZR(JACCE),ZR(JACC2),ZR(JVMIN),FREQ)
          ERR = NPER * FREQ * DT2
C
C       --- REDUCTION DU PAS DE TEMPS ---
          IF (ERR .GT. 1.D0) DT2 = DT2/CDP
          IF (DT2.LE.DTMIN .AND. ABS(TFIN-(TEMPS+DT2)).GT.EPSI) THEN
            CALL UTMESS('F','DLAPAP_03','METHODE ADAPT '//
     +                  'PAS DE TEMPS MINIMAL ATTEINT')
          ENDIF
          NR = NR + 1
C       LES DEUX LIGNES SUIVANTES SIMULENT LE WHILE - CONTINUE
          GOTO 101
        ELSE IF (ERR .GT. 1.D0 .AND. NR .GE. NRMAX) THEN 
          CALL UTDEBM('A','DLADAP','ERREUR SUPERIEURE A 1. : ')
          CALL UTIMPR('L','ERREUR = ',1,ERR)
          CALL UTIMPR('L','A L''INSTANT : ',1,TEMPS+DT2)
      CALL UTIMPR('L','ON ARRETE DE REDUIRE DT QUI VAUT :  ',1,DT2)
          CALL UTIMPI('L','CAR NB REDUCTIONS MAX ATTEINT : ',1,NRMAX)
          CALL UTFINM() 
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
     *     (TEMP2.EQ.TFIN)) THEN
          IARCHI = IARCHI + 1
          ISTOC = 1
          IF((TEMP2-TARCH).LE.(TARCH-TEMPS)) THEN
            TARCHI = TEMP2
            CALL DLARCH (IARCHI,TYPE,NOMRES,NOMCMD,MASSE,
     *                  NEQ,ZR(JDEP2),ZR(JVIP2),ZR(JACC2),TEMP2) 
          ELSE
            TARCHI = TEMPS
            CALL DLARCH (IARCHI,TYPE,NOMRES,NOMCMD,MASSE,
     *                  NEQ,ZR(JDEPL),ZR(JVIP1),ZR(JACCE),TEMPS)
          ENDIF
          TARCH = TARCH + DTARCH
        ENDIF 
C          
C ------------- TRANSFERT DES NOUVELLES VALEURS DANS LES ANCIENNES
        TEMPS = TEMP2
        CALL R8COPY(NEQ ,ZR(JDEP2),1,ZR(JDEPL), 1)
        CALL R8COPY(NEQ ,ZR(JVIT2),1,ZR(JVITE), 1)
        CALL R8COPY(NEQ ,ZR(JVIP2),1,ZR(JVIP1), 1)
        CALL R8COPY(NEQ ,ZR(JACC2),1,ZR(JACCE), 1)
C
C ------------- VERIFICATION DU TEMPS DE CALCUL RESTANT
        IF (IVERI.EQ.0) THEN
          CALL UTTCPU(1, 'FIN', 4, TPS1)
          TJOB = TPS1(1)
          IF (TPS1(4) .EQ. 0.D0) TPS1(4)=1.D-02
          NBPASC = INT(1.D-02 * (TPS1(1)/TPS1(4)))+1
        ELSE 
          IF (MOD(IVERI,NBPASC).EQ.0) THEN 
            CALL UTTCPU(1, 'FIN', 4, TPS1)
            IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN
             GOTO 9999
            ENDIF
            IF (TPS1(4) .EQ. 0.D0) TPS1(4)=1.D-02
            NBPASC = INT(1.D-02 * (TJOB/TPS1(4)))+1
          ENDIF               
        ENDIF  
        IVERI = IVERI + 1
C 
        GOTO 100
      ENDIF
C
 9999 CONTINUE
C
C --- ARCHIVAGE COMPLET POUR LE DERNIER INSTANT ---
C
      IF (ISTOC.EQ.0 ) THEN
         IARCHI = IARCHI + 1
         CALL RSADPA(NOMRES,'E',1,'INST',IARCHI,0,LINST,K8B)
         ZR(LINST) = TEMPS
      ELSE
         CALL RSADPA(NOMRES,'L',1,'INST',IARCHI,0,LINST,K8B)
         TEMPS = ZR(LINST)
      ENDIF
      CALL RSEXCH(NOMRES,'DEPL',IARCHI,CHAMNO,IER)
      WRITE(IFM,1001) 'DEPL',' ',' ', IARCHI, TEMPS
      IF ( IER .EQ. 100 ) THEN
         CALL VTCREM(CHAMNO,MASSE,'G','R')
      ELSEIF ( IER .EQ. 0 ) THEN
         GOTO 70
      ELSE
         CALL UTMESS('F',NOMCMD,'APPEL ERRONE')
      ENDIF
      CHAMNO(20:24)  = '.VALE'
      CALL JEVEUO(CHAMNO,'E',LVALE)
      DO 72 IEQ = 1,NEQ
         ZR(LVALE+IEQ-1) = ZR(JDEPL+IEQ-1)
 72   CONTINUE
      CALL JELIBE(CHAMNO)
      CALL RSNOCH(NOMRES,'DEPL',IARCHI,' ')
 70   CONTINUE
      CALL RSEXCH(NOMRES,'VITE',IARCHI,CHAMNO,IER)
      IF ( IER .EQ. 100 ) THEN
         CALL VTCREM(CHAMNO,MASSE,'G','R')
      ELSEIF ( IER .EQ. 0 ) THEN
         GOTO 74
      ELSE
         CALL UTMESS('F',NOMCMD,'APPEL ERRONE')
      ENDIF
      WRITE(IFM,1001) ' ','VITE',' ', IARCHI, TEMPS
      CHAMNO(20:24)  = '.VALE'
      CALL JEVEUO(CHAMNO,'E',LVALE)
      DO 76 IEQ = 1,NEQ
         ZR(LVALE+IEQ-1) = ZR(JVIP1+IEQ-1)
 76   CONTINUE
      CALL JELIBE(CHAMNO)
      CALL RSNOCH(NOMRES,'VITE',IARCHI,' ')
 74   CONTINUE
      CALL RSEXCH(NOMRES,'ACCE',IARCHI,CHAMNO,IER)
      IF ( IER .EQ. 100 ) THEN
         CALL VTCREM(CHAMNO,MASSE,'G','R')
      ELSEIF ( IER .EQ. 0 ) THEN
         GOTO 78
      ELSE
         CALL UTMESS('F',NOMCMD,'APPEL ERRONE')
      ENDIF
      WRITE(IFM,1001) ' ',' ','ACCE', IARCHI, TEMPS
      CHAMNO(20:24)  = '.VALE'
      CALL JEVEUO(CHAMNO,'E',LVALE)
      DO 80 IEQ = 1,NEQ
         ZR(LVALE+IEQ-1) = ZR(JACCE+IEQ-1)
 80   CONTINUE
      CALL JELIBE(CHAMNO)
      CALL RSNOCH(NOMRES,'ACCE',IARCHI,' ')
 78   CONTINUE
C
      IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN 
         CALL UTDEBM('S','DLADAP',
     *               'ARRET PAR MANQUE DE TEMPS CPU')
         CALL UTIMPI('L',' NOMBRE DE PAS CALCULES : ',
     *                1,IPAS)
         CALL UTIMPR('L',' DERNIER INSTANT ARCHIVE : ',
     *                1,TARCHI)
         CALL UTIMPI('L',' NUMERO D''ORDRE CORRESPONDANT : ',
     *                1,IARCHI)
      CALL UTIMPI('L',' LE TEMPS MOYEN POUR UN NOMBRE DE PAS DE ',
     *                 1,NBPASC)
         CALL UTIMPR('L',' VAUT : ',1,NBPASC*TPS1(4))
         CALL UTIMPR('L',' TEMPS CPU RESTANT : ',1,TPS1(1))
         CALL UTFINM()
      ENDIF
C
      CALL UTDEBM('I',
     +'----------------------------------------------',' ')
      CALL UTIMPI('L','! NOMBRE DE PAS DE CALCUL       : ',1,IPAS)
      CALL UTIMPI('L','! NOMBRE D''ITERATIONS          : ',1,NBITER)
      CALL UTIMPK('L',
     +'----------------------------------------------',0,' ')
      CALL UTFINM()
C
C     --- DESTRUCTION DES OBJETS DE TRAVAIL ---
C
      CALL JEDETC('V','&&',1)
      CALL JEDETC('V','.CODI',20)
      CALL JEDETC('V','.MATE_CODE',9)
C
 1000 FORMAT(1P,3X,'PREMIER(S) CHAMP(S) STOCKE(S):',3(1X,A4),
     +             ' NUME_ORDRE:',I8,' INSTANT:',D12.5)
 1001 FORMAT(1P,3X,'DERNIER(S) CHAMP(S) STOCKE(S):',3(1X,A4),
     +             ' NUME_ORDRE:',I8,' INSTANT:',D12.5)    
C
      CALL JEDEMA()
      END
