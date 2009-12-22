      SUBROUTINE ALGOCG(DEFICO,RESOCO,MATASS,NOMA  ,RESU  ,
     &                  CTCCVG)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_20
C 
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 RESU,MATASS
      INTEGER      CTCCVG(2)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C ALGO. POUR CONTACT    : GRADIENT CONJUGUE PROJETE
C ALGO. POUR FROTTEMENT : SANS
C
C ----------------------------------------------------------------------
C
C      
C
C RESOLUTION DE : C.DU + AT.MU  = F
C                 A(U+DU)      <= E (= POUR LES LIAISONS ACTIVES)
C
C AVEC E = JEU COURANT (CORRESPONDANT A U/I/N)
C
C      C = ( K  BT ) MATRICE DE RIGIDITE INCLUANT LES LAGRANGE
C          ( B  0  )
C
C      U = ( DEPL )
C          ( LAM  )
C
C      F = ( DL  ) DANS LA PHASE DE PREDICTION
C          ( DUD )
C
C      F = ( L - QT.SIG - BT.LAM  ) AU COURS D'UNE ITERATION DE NEWTON
C          (           0          )
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  MATASS : MATR_ASSE DU SYSTEME MECANIQUE
C IN  NOMA   : NOM DU MAILLAGE
C VAR RESU   : INCREMENT "DDEPLA" DE DEPLACEMENT DEPUIS DEPTOT
C               (DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION
C               DE NEWTON PRECEDENTE)
C                 EN ENTREE : SOLUTION OBTENUE SANS TRAITER LE CONTACT
C                 EN SORTIE : SOLUTION CORRIGEE PAR LE CONTACT
C OUT CTCCVG : CODES RETOURS D'ERREUR DU COTNACT
C                (1) NOMBRE MAXI D'ITERATIONS
C                (2) MATRICE SINGULIERE
C
C --------------- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------
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
      INTEGER CFDISI,CFDISD
      LOGICAL CONJUG
      INTEGER IFM,NIV,FREQ,ISMAEM
      INTEGER ILIAI,ILIAC,JRESU,JDECAL,ITER,PREMAX
      INTEGER NEQ,NBLIAC,NBLIAI,NBDDL,JRESU0
      INTEGER JAPPTR,JAPCOE,JAPJEU,JAPDDL,JSGPRM,JSGPRP
      INTEGER JSECMB,JVEZER,JMUM
      INTEGER JLIAC,JMU,JDELTA,JATMU,LMAT
      INTEGER GCPMAX,JSGRAM,JSGRAP,JDIREC
      REAL*8 AJEU,VAL,DDOT,TOLE,RELA,CFDISR,NORME2
      REAL*8 NUMER,DENOM,NINF,ALPHA,EPSI,R8BID,GAMMA,NUMER2,EPSIPC
      CHARACTER*2 TYPEC0
      CHARACTER*16 PRECON,SEARCH
      CHARACTER*19 LIAC,MU,ATMU,SGRADM,SGRADP
      CHARACTER*19 DIRECT,MUM,SOLVEU
      CHARACTER*19 SGRPRM,SGRPRP,RESU0,KBID
      CHARACTER*24 APPOIN,APCOEF,APJEU,APDDL,VEZERO
      CHARACTER*24 SECMBR,DELTAU
      COMPLEX*16   C16BID

C ----------------------------------------------------------------------

C ======================================================================
C             INITIALISATIONS DES OBJETS ET DES ADRESSES
C ======================================================================
C U      : DEPTOT + RESU+
C DEPTOT : DEPLACEMENT TOTAL OBTENU A L'ISSUE DE L'ITERATION DE NEWTON
C          PRECEDENTE. C'EST U/I/N.
C RESU   : INCREMENT DEPUIS DEPTOT (ACTUALISE AU COURS DES ITERATIONS
C          DE CONTRAINTES ACTIVES : RESU+ = RESU- + RHO.DELTA)
C          C'EST DU/K OU DU/K+1.
C DELTA  : INCREMENT DONNE PAR CHAQUE ITERATION DE CONTRAINTES ACTIVES.
C          C'EST D/K+1.
C DELT0  : INCREMENT DE DEPLACEMENT DEPUIS LA DERNIERE ITERATION DE
C          NEWTON SANS TRAITER LE CONTACT. C'EST C-1.F.
C ======================================================================
      CALL INFNIV(IFM,NIV)
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> <> ALGO_CONTACT   : GRADIENT '//
     &    'CONJUGUE PROJETE'
        WRITE (IFM,*) '<CONTACT> <> ALGO_FROTTEMENT: SANS'
      END IF

      CALL JEMARQ()

C ======================================================================
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C ======================================================================

      APPOIN = RESOCO(1:14)//'.APPOIN'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      APJEU  = RESOCO(1:14)//'.APJEU'
      APDDL  = RESOCO(1:14)//'.APDDL'
      LIAC   = RESOCO(1:14)//'.LIAC'
      MU     = RESOCO(1:14)//'.MU'
      ATMU   = RESOCO(1:14)//'.ATMU'
      SOLVEU = '&&OP0070.SOLVEUR'
      CALL JEVEUO(MATASS//'.&INT', 'L', LMAT)
C ======================================================================
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APCOEF,'L',JAPCOE)
      CALL JEVEUO(APJEU,'E',JAPJEU)
      CALL JEVEUO(APDDL,'L',JAPDDL)
      CALL JEVEUO(LIAC,'E',JLIAC)
      CALL JEVEUO(ATMU,'E',JATMU)
      CALL JEVEUO(MU,'E',JMU)
      CALL JEVEUO(RESU(1:19)//'.VALE','E',JRESU)
C ======================================================================
C --- INITIALISATION DE VARIABLES
C --- NBLIAI : NOMBRE DE LIAISONS DE CONTACT
C --- NBLIAC : NOMBRE DE LIAISONS ACTIVES
C --- NEQ    : NOMBRE D'EQUATIONS DU MODELE
C --- ITEMUL : NOMBRE PAR LEQUEL IL FAUT MULTIPLIER LE NOMBRE DE
C              LIAISONS DE CONTACT POUR OBTENIR LE NOMBRE MAXI
C              D'ITERATIONS DANS L'ALGO GCPMAX=ITEMUL*NBLIAI
C                   <!> FIXE A 10 POUR CET ALGO <!>
C --- GCPMAX : NOMBRE D'ITERATIONS DE CONTACT DANS L'ALGO
C ======================================================================
      NBLIAI = CFDISD(RESOCO,'NBLIAI' )
      NEQ    = ZI(LMAT+2)
      TYPEC0 = 'C0'
C ======================================================================
C                             INITIALISATIONS
C ======================================================================

      ITER = 1
      CONJUG = .FALSE.
      TOLE = 1.D-12
C
C     RECUPERATION DU CRITERE DE CONVERGENCE ET DE LA FREQUENCE DE
C     REACTUALISATION DES DIRECTIONS 
C 

      EPSI   = CFDISR(DEFICO,'RESI_ABSO')
      FREQ   = CFDISI(DEFICO,'REAC_ITER')
      RELA   = CFDISR(DEFICO,'COEF_RESI')
      GCPMAX = 10*NBLIAI
      PREMAX = ISMAEM()
      IF (CFDISI(DEFICO,'ITER_GCP_MAXI').NE.0) THEN
        GCPMAX = MAX(10*NBLIAI,CFDISI(DEFICO,'ITER_GCP_MAXI'))
      ENDIF
      IF (CFDISI(DEFICO,'ITER_PRE_MAXI').NE.0) THEN 
        PREMAX = MAX(PREMAX,CFDISI(DEFICO,'ITER_PRE_MAXI'))
      ENDIF  
      PRECON = 'SANS'
      SEARCH = 'ADMISSIBLE'      
      IF (CFDISI(DEFICO,'PRE_COND').EQ.1) THEN
        PRECON = 'DIRICHLET'
      ENDIF  
      IF (CFDISI(DEFICO,'RECH_LINEAIRE').EQ.1) THEN
        SEARCH = 'NON_ADMISSIBLE'
      ENDIF  



C     CREATION DES VECTEURS DE TRAVAIL
C     ---------------------------------

C     SS-GRADIENT ITERATION (-) ET (+)
      SGRADM = '&&ALGOCG.SGRADM'
      SGRADP = '&&ALGOCG.SGRADP'

C     DIRECTION DE RECHERCHE
      DIRECT = '&&ALGOCG.DIRECP'

C     SS-GRADIENT PRECONDITIONNE (-) ET (+)
      SGRPRM = '&&ALGOCG.SGRPRM'
      SGRPRP = '&&ALGOCG.SGRPRP'

C     MULT. LAGRANGE ITERATION (-)
      MUM = '&&ALGOCG.MUM'

C     INCR. DE DEPLACEMENT INITIAL
      RESU0 = '&&CFJEIN.RESU0'

C     SECOND MEMBRE ET VECTEUR NUL
      SECMBR = '&&ALGOCG.SECMBR'
      VEZERO = '&&ALGOCG.VEZERO'
      DELTAU = '&&ALGOCG.DELTA'

      CALL JEDUPO(MU,'V',SGRADM,.FALSE.)
      CALL JEDUPO(MU,'V',SGRADP,.FALSE.)
      CALL JEDUPO(MU,'V',SGRPRM,.FALSE.)
      CALL JEDUPO(MU,'V',SGRPRP,.FALSE.)
      CALL JEDUPO(MU,'V',DIRECT,.FALSE.)
      CALL JEDUPO(MU,'V',MUM,.FALSE.)
      CALL JEDUPO(ATMU,'V',RESU0,.FALSE.)
      CALL COPISD('CHAMP_GD','V',RESU  ,SECMBR)
      CALL COPISD('CHAMP_GD','V',RESU  ,DELTAU)
      CALL COPISD('CHAMP_GD','V',RESU  ,VEZERO)
      
      CALL JEVEUO(SGRADM,'E',JSGRAM)
      CALL JEVEUO(SGRADP,'E',JSGRAP)
      CALL JEVEUO(SGRPRM,'E',JSGPRM)
      CALL JEVEUO(SGRPRP,'E',JSGPRP)
      CALL JEVEUO(DIRECT,'E',JDIREC)
      CALL JEVEUO(MUM,'E',JMUM)
      CALL JEVEUO(RESU0,'E',JRESU0)
      CALL JEVEUO(SECMBR(1:19)//'.VALE','E',JSECMB)
      CALL JEVEUO(DELTAU(1:19)//'.VALE','E',JDELTA)
      CALL JEVEUO(VEZERO(1:19)//'.VALE','E',JVEZER)
      CALL R8INIR(NEQ,0.D0,ZR(JVEZER),1)


      IF (NIV.GE.2) THEN
        WRITE (IFM,9010) GCPMAX
      END IF

C     INITIALISATION A�PARTIR DU CHAMP DE MULTIPLICATEURS INITIAL MU
C     S'IL EST NON-NUL
C     NB : ON UTILISE LA VALEUR DE MU QUI EST SUR LA BASE VOLATILE
C     --------------------------------------------------------------
      NORME2 = DDOT(NBLIAI,ZR(JMU),1,ZR(JMU),1)
      IF (NORME2.NE.0.D0) THEN 
C        F = A' MU
        CALL R8INIR(NEQ,0.D0,ZR(JDELTA),1)
        DO 22 ILIAC = 1,NBLIAI
          JDECAL = ZI(JAPPTR+ILIAC-1)
          NBDDL = ZI(JAPPTR+ILIAC) - ZI(JAPPTR+ILIAC-1)
          CALL CALATM(NEQ,NBDDL,ZR(JMU-1+ILIAC),ZR(JAPCOE+JDECAL),
     &                ZI(JAPDDL+JDECAL),ZR(JDELTA))
  22    CONTINUE
C        K DELTA = F
        CALL DCOPY(NEQ,ZR(JDELTA),1,ZR(JSECMB),1)
        CALL RESOUD(MATASS,KBID,SECMBR,SOLVEU, VEZERO, 'V',
     &              DELTAU, KBID,0,R8BID,C16BID)      
C        U = U + (-DELTA)
        CALL JEVEUO(DELTAU(1:19)//'.VALE','E',JDELTA)
        CALL DAXPY(NEQ,-1.D0,ZR(JDELTA),1,ZR(JRESU),1)
      ENDIF


C ======================================================================
C =========================== BOUCLE PRINCIPALE ========================
C ======================================================================

   30 CONTINUE

C ======================================================================
C --- CALCUL ET PROJECTION DU SOUS-GRADIENT
C --- EVALUATION DE LA CONVERGENCE
C --- IMPRESSION DE DEBUGGAGE SUR DEMANDE
C ======================================================================

      IF (NIV.EQ.2) THEN
        WRITE (IFM,*) '<CONTACT> <> -----------------------------------'
        WRITE (IFM,*) '<CONTACT> <> ITERATION DE GCP = ',ITER
      END IF

      NINF = 0.D0
      DO 40 ILIAI = 1,NBLIAI
        JDECAL = ZI(JAPPTR+ILIAI-1)
        NBDDL = ZI(JAPPTR+ILIAI) - ZI(JAPPTR+ILIAI-1)
        CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &              ZR(JRESU),VAL)
        
          AJEU = ZR(JAPJEU+ILIAI-1) - VAL


C       PROJECTION DU SOUS-GRADIENT
        ZR(JSGRAP-1+ILIAI) = -AJEU
        IF (ZR(JMU-1+ILIAI).LT.TOLE) THEN
          ZR(JSGRAP-1+ILIAI) = MAX(-1.D0*AJEU,0.D0)
        END IF
C       NORME INFINIE DU RESIDU
        NINF = MAX(ABS(ZR(JSGRAP-1+ILIAI)),NINF)

   40 CONTINUE


C     ON A CONVERGE
      IF (NINF.LT.EPSI) THEN
        IF (NIV.EQ.2) WRITE (IFM,9060) NINF,EPSI
        GO TO 110
      END IF
      IF (NIV.EQ.2) THEN
        WRITE (IFM,9060) NINF,EPSI
      END IF

C ======================================================================
C --- PRECONDITIONNEMENT
C ======================================================================

C-----INITIALISATION DE DELTA ET DU PRECONDITIONNEUR
      CALL R8INIR(NEQ,0.D0,ZR(JDELTA),1)
      CALL R8INIR(NBLIAI,0.D0,ZR(JSGPRP),1)

C----PRECONDITIONNEMENT DIRICHLET
      IF (PRECON.EQ.'DIRICHLET') THEN
        EPSIPC = EPSI*RELA
        CALL PREGCP(NEQ,NBLIAI,TOLE,EPSIPC,ZR(JMU),
     &              ZR(JAPCOE),ZI(JAPDDL),ZI(JAPPTR),ZI(JLIAC),MATASS,
     &              ZR(JSGRAP),ZR(JSGPRP),SECMBR,VEZERO,DELTAU,SOLVEU,
     &              PREMAX)
        CALL JEVEUO(DELTAU(1:19)//'.VALE','E',JDELTA)
      ELSE
C----SINON ON RECOPIE
        CALL DCOPY(NBLIAI,ZR(JSGRAP),1,ZR(JSGPRP),1)
      END IF

C ======================================================================
C --- CONJUGAISON
C ======================================================================

C     ON FAIT LA CONJUGAISON DE POLAK-RIBIERE :
C        - SI L'ETAT DE CONTACT EST LE MEME D'UNE ITERATION SUR L'AUTRE
C        - TOUTES LES FREQ ITERATIONS
C        - SI DIRECT EST UNE DIRECTION DE DESCENTE I.E. 
C                                                     (DIRECT' SGRAD+)>0
C     NB1 :  FORMULE DE CONJUGAISON EN PRESENCE DE PRECONDITIONNEUR :
C            GAMMA = (SGRADP' (SGRPRP - SGRPRM)) / (SGRADM' SGRPRM))
C     NB2 : LA CONJUGAISON DE FLETCHER-REEVES EST : GAMMA = NUMER/DENOM
      GAMMA = 0.D0
      IF (CONJUG) THEN
        NUMER = DDOT(NBLIAI,ZR(JSGRAP),1,ZR(JSGPRP),1)
        NUMER2 = DDOT(NBLIAI,ZR(JSGRAP),1,ZR(JSGPRM),1)
        DENOM = DDOT(NBLIAI,ZR(JSGRAM),1,ZR(JSGPRM),1)
        GAMMA = (NUMER-NUMER2)/DENOM
      END IF


C     DIRECT = GAMMA DIRECT + SGRPRP
      CALL DSCAL(NBLIAI,GAMMA,ZR(JDIREC),1)
      CALL DAXPY(NBLIAI,1.D0,ZR(JSGPRP),1,ZR(JDIREC),1)

C     DIRECT EST-ELLE UNE DIRECTION DE DESCENTE
      NUMER2 = DDOT(NBLIAI,ZR(JDIREC),1,ZR(JSGRAP),1)
      IF (NUMER2.LE.0.D0) THEN
        CONJUG = .FALSE.
        GAMMA = 0.D0
        CALL DCOPY(NBLIAI,ZR(JSGPRP),1,ZR(JDIREC),1)
      END IF

      IF (CONJUG) THEN
        IF (NIV.EQ.2) THEN
          WRITE (IFM,*) '<CONTACT> <> CONJUGAISON DES DIRECTIONS '//
     &      'DE RECHERCHE, GAMMA=',GAMMA
        END IF
      END IF


C ======================================================================
C --- RECHERCHE LINEAIRE
C ======================================================================

C     F = A' DIRECT
      CALL R8INIR(NEQ,0.D0,ZR(JDELTA),1)
      DO 50 ILIAC = 1,NBLIAI
        JDECAL = ZI(JAPPTR+ILIAC-1)
        NBDDL = ZI(JAPPTR+ILIAC) - ZI(JAPPTR+ILIAC-1)
        CALL CALATM(NEQ,NBDDL,ZR(JDIREC-1+ILIAC),ZR(JAPCOE+JDECAL),
     &              ZI(JAPDDL+JDECAL),ZR(JDELTA))
   50 CONTINUE
C     K DELTA = F
      CALL DCOPY(NEQ,ZR(JDELTA),1,ZR(JSECMB),1)
      CALL RESOUD(MATASS,KBID,SECMBR,SOLVEU, VEZERO, 'V',
     &            DELTAU, KBID,0,R8BID,C16BID)      
      CALL JEVEUO(DELTAU(1:19)//'.VALE','E',JDELTA)
      
      
C     PRODUIT SCALAIRE  NUMER=DIRECP' DIRECP
      NUMER = DDOT(NBLIAI,ZR(JSGPRP),1,ZR(JSGRAP),1)


C     PRODUIT SCALAIRE  DENOM=DIRECP' A K-1 A' DIRECP
      DENOM = DDOT(NEQ,ZR(JDELTA),1,ZR(JSECMB),1)

      IF (DENOM.LT.0.D0) THEN
        CALL U2MESS('A','CONTACT_7')
      END IF

      ALPHA = NUMER/DENOM

      IF (NIV.EQ.2) THEN
        WRITE (IFM,9040) ALPHA
      END IF

C ======================================================================
C --- PROJECTION ET MISES A JOUR
C ======================================================================

C     PROJECTION DU PAS D'AVANCEMENT POUR RESPECTER LES CONTRAINTES
      IF (SEARCH.EQ.'ADMISSIBLE') THEN
      
        DO 60 ILIAC = 1,NBLIAI
          IF (ZR(JDIREC-1+ILIAC).LT.0.D0) THEN
            ALPHA = MIN(ALPHA,-ZR(JMU-1+ILIAC)/ZR(JDIREC-1+ILIAC))
          END IF
   60   CONTINUE

        IF (NIV.EQ.2) THEN
          WRITE (IFM,9050) ALPHA
        END IF

C       MISE A JOUR DE MU PUIS DE DELTA
        CALL DAXPY(NBLIAI,ALPHA,ZR(JDIREC),1,ZR(JMU),1)
        CALL DAXPY(NEQ,-ALPHA,ZR(JDELTA),1,ZR(JRESU),1)


C     METHODE NON ADMISSIBLE DE CALCUL DU PAS D'AVANCEMENT
      ELSEIF (SEARCH.EQ.'NON_ADMISSIBLE') THEN
      
C       MISE A JOUR DE MU PUIS PROJECTION
        CALL DAXPY(NBLIAI,ALPHA,ZR(JDIREC),1,ZR(JMU),1)
        DO 70 ILIAC = 1,NBLIAI
          IF (ZR(JMU-1+ILIAC).LT.0.D0) THEN
            ZR(JMU-1+ILIAC) = 0.D0
          END IF
   70   CONTINUE

C       F = A' MU
        CALL R8INIR(NEQ,0.D0,ZR(JDELTA),1)
        DO 80 ILIAC = 1,NBLIAI
          JDECAL = ZI(JAPPTR+ILIAC-1)
          NBDDL = ZI(JAPPTR+ILIAC) - ZI(JAPPTR+ILIAC-1)
          CALL CALATM(NEQ,NBDDL,ZR(JMU-1+ILIAC),ZR(JAPCOE+JDECAL),
     &                ZI(JAPDDL+JDECAL),ZR(JDELTA))
   80   CONTINUE
        CALL DCOPY(NEQ,ZR(JDELTA),1,ZR(JSECMB),1)
C       K DELTA = F
        CALL RESOUD(MATASS,KBID,SECMBR,SOLVEU, VEZERO, 'V',
     &              DELTAU, KBID,0,R8BID,C16BID) 
C       U = U0 + (-DELTA)
        CALL JEVEUO(DELTAU(1:19)//'.VALE','E',JDELTA)
        CALL DCOPY(NEQ,ZR(JRESU0),1,ZR(JRESU),1)
        CALL DAXPY(NEQ,-1.D0,ZR(JDELTA),1,ZR(JRESU),1)

      ELSE
        CALL ASSERT(.FALSE.)
      END IF



C     ON VERIFIE SI L'ETAT DE CONTACT A CHANGE (ON NE CONJUGUE PAS)
C     ON REINITIALISE LA DIRECTION DE RECHERCHE TOUTES LES FREQ
C     ITERATIONS
      CONJUG = .TRUE.
      IF (MOD(ITER,FREQ).NE.0) THEN
        DO 90 ILIAI = 1,NBLIAI
          IF (((ZR(JMU-1+ILIAI).GT.TOLE).AND. 
     &         (ZR(JMUM-1+ILIAI).LT.TOLE)) .OR.
     &        ((ZR(JMU-1+ILIAI).LT.TOLE).AND.
     &        (ZR(JMUM-1+ILIAI).GT.TOLE))) THEN
            CONJUG = .FALSE.
            IF (NIV.EQ.2) THEN
              WRITE (IFM,*) '<CONTACT> <>'//
     &          ' CHANGEMENT DE L''ETAT DE CONTACT'
            END IF
            GO TO 100

          END IF
   90   CONTINUE
      ELSE
        CONJUG = .FALSE.
      END IF
  100 CONTINUE


C     MISE � JOUR DES GRADIENTS ET DES DIRECTIONS DE RECHERCHE
      CALL DCOPY(NBLIAI,ZR(JSGRAP),1,ZR(JSGRAM),1)
      CALL DCOPY(NBLIAI,ZR(JSGPRP),1,ZR(JSGPRM),1)
      CALL DCOPY(NBLIAI,ZR(JMU),1,ZR(JMUM),1)

      ITER = ITER + 1

C ======================================================================
C --- A-T-ON DEPASSE LE NOMBRE D'ITERATIONS DE CONTACT AUTORISE ?
C ======================================================================
      IF (ITER.GE.GCPMAX) THEN
        CALL U2MESI('A','CONTACT_2',1,GCPMAX)
        DO 150  ILIAI=1,NBLIAI
          JDECAL = ZI(JAPPTR+ILIAI-1)
          NBDDL  = ZI(JAPPTR+ILIAI) - ZI(JAPPTR+ILIAI-1)
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JRESU),VAL)
          AJEU = ZR(JAPJEU+ILIAI-1) - VAL
          IF ((ABS(AJEU).GT.AJEU).AND.(ZR(JMU-1+ILIAI).GT.TOLE)) THEN
             CALL CFIMP2(DEFICO,RESOCO,NOMA  ,IFM   ,ILIAI,
     &                   TYPEC0,'N'   ,'AGC' ,AJEU  )
          END IF
 150    CONTINUE
        GO TO 110
      END IF


      GO TO 30

C ======================================================================
C =========================== ON A CONVERGE! ===========================
C ======================================================================

  110 CONTINUE
      

      CALL R8INIR(NEQ,0.D0,ZR(JATMU),1)
      DO 120 ILIAC = 1,NBLIAI
        JDECAL = ZI(JAPPTR+ILIAC-1)
        NBDDL = ZI(JAPPTR+ILIAC) - ZI(JAPPTR+ILIAC-1)
        CALL CALATM(NEQ,NBDDL,ZR(JMU-1+ILIAC),ZR(JAPCOE+JDECAL),
     &              ZI(JAPDDL+JDECAL),ZR(JATMU))
  120 CONTINUE

      NBLIAC = 0
      DO 130 ILIAI = 1,NBLIAI
        IF (ZR(JMU-1+ILIAI).GT.TOLE) THEN
          NBLIAC = NBLIAC + 1
          ZI(JLIAC-1+NBLIAC) = ILIAI
        END IF
  130 CONTINUE


C ======================================================================
C --- STOCKAGE DE L'ETAT DE CONTACT DEFINITIF
C ======================================================================
C
C --- VALEUR DES VARIABLES DE CONVERGENCE
C
      CTCCVG(1) = 0
      CTCCVG(2) = 0
C      
C --- ETAT DES VARIABLES DE CONTROLE DU CONTACT
C
      CALL CFECRD(RESOCO,'NBLIAC',NBLIAC)
C
      IF ( NIV .GE. 2 ) THEN
        WRITE(IFM,9020) ITER
      END IF
C 
C --- SAUVEGARDE DES INFOS DE DIAGNOSTIC 
C 
      CALL CFITER(RESOCO,'E','CONT',ITER  ,R8BID)
      CALL CFITER(RESOCO,'E','LIAC',NBLIAC,R8BID)
C ======================================================================
C --- DESTRUCTION DES VECTEURS INUTILES
C ======================================================================
      CALL JEDETR(SGRADM)
      CALL JEDETR(SGRADP)
      CALL JEDETR(SGRPRM)
      CALL JEDETR(SGRPRP)
      CALL JEDETR(DIRECT)
      CALL JEDETR(SECMBR)
      CALL JEDETR(MUM)
      CALL JEDETR(VEZERO)
      CALL JEDETR(RESU0)
      CALL JEDEMA()
C ======================================================================

 9010 FORMAT (' <CONTACT> <> DEBUT DES ITERATIONS (MAX: ',I8,')')
 9020 FORMAT (' <CONTACT> <> FIN DES ITERATIONS (NBR: ',I8,')')
 9040 FORMAT (' <CONTACT> <> PAS D''AVANCEMENT INITIAL : ',1PE12.5)
 9050 FORMAT (' <CONTACT> <> PAS D''AVANCEMENT APRES PROJECTION : ',
     &       1PE12.5)
 9060 FORMAT (' <CONTACT> <> NORME INFINIE DU RESIDU : ',1PE12.5,' (CR',
     &       'ITERE: ',1PE12.5,')')
      END
