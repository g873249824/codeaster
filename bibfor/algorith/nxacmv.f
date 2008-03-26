      SUBROUTINE NXACMV(MODELE,MATE,CARELE,FOMULT,CHARGE,INFCHA,
     &                  INFOCH,NUMEDD,SOLVEU,LOSTAT,TIME,TPSTHE,
     &                  REASVC,REASVT,REASMT,REASRG,REASMS,CREAS,
     &                  VTEMP,VHYDR,TMPCHI,TMPCHF,VEC2ND,VEC2NI,
     &                  MATASS,MAPREC,CNDIRP,CNCHCI,MEDIRI,COMPOR,
     &                  TYPESE,STYPSE,NOPASE,VAPRIN,VAPRMO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE                            DURAND C.DURAND
C TOLE CRP_21
C TOLE CRP_20
C ----------------------------------------------------------------------
C
C COMMANDE THER_LINEAIRE : ACTUALISATION EVENTUELLE
C   - DES VECTEURS CONTRIBUANT AU SECOND MEMBRE
C   - DE LA MATRICE ASSEMBLEE
C COMMANDE THER_NON_LINE : ACTUALISATION EVENTUELLE
C   - DES VECTEURS CONTRIBUANT AU SECOND MEMBRE (RESIDU)
C   - DE LA MATRICE TANGENTE ASSEMBLEE
C
C OUT VEC2ND  : VECTEUR ASSEMBLE SECOND MEMBRE = L1(V,T-)
C OUT VEC2NI  : VECTEUR ASSEMBLE SECOND MEMBRE = L1(V,T-)
C                         AVEC RHOCP.T- ET NON PLUS H(T-)
C OUT MATASS,MAPREC  MATRICE DE RIGIDITE ASSEMBLEE
C OUT CNDIRP  : VECTEUR ASSEMBLE DES DIRICHLETS
C OUT CNCHCI  : ????????
C IN  TYPESE  : TYPE DE SENSIBILITE
C                0 : CALCUL STANDARD, NON DERIVE
C                SINON : DERIVE (VOIR NTTYSE)
C IN  STYPSE  : SOUS-TYPE DE SENSIBILITE (VOIR NTTYSE)
C . POUR UN CALCUL STANDARD :
C IN  VTEMP   : CHAMP DE LA TEMPERATURE A L'INSTANT PRECEDENT
C . POUR UN CALCUL DE DERIVEE, ON A LES DONNEES SUIVANTES :
C IN  VTEMP   : CHAMP DE LA DERIVEE A L'INSTANT PRECEDENT
C IN  NOPASE  : NOM DU PARAMETRE SENSIBLE
C IN  VAPRIN  : VARIABLE PRINCIPALE (TEMPERATURE) A L'INSTANT COURANT
C IN  VAPRMO  : VARIABLE PRINCIPALE (TEMPERATURE) A L'INSTANT PRECEDENT
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       MESSAGE:U2MESS, U2MESI, U2MESK, U2MESG
C       JEVEUX:JEMARQ,JEVEUO,JEDETR,JELIRA.
C       MANIP SD: MECACT.
C       DIRICHLET: VEDITH,ASCAVC
C       SECONDS MEMBRES:VETNTH,VECHNL.
C       CALCUL: CALCUL,ASAVE,ASCOVA.
C       FICH COMM: GETRES.
C
C     FONCTIONS INTRINSEQUES:
C       AUCUNE.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       30/11/01 (OB): MODIFICATIONS POUR TRAITER LES CALCULS DE SENSI
C                      BILITE (TYPESE.GT.0).
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C 0.1. ==> ARGUMENTS

      LOGICAL      REASVC,REASVT,REASMT,REASRG,REASMS,LOSTAT
      INTEGER      TYPESE
      REAL*8       TPSTHE(6)
      CHARACTER*1  CREAS
      CHARACTER*19 INFCHA,SOLVEU,MAPREC
      CHARACTER*24 MODELE,MATE,CARELE,FOMULT,CHARGE,INFOCH,NUMEDD,TIME,
     &             VTEMP,VEC2ND,VEC2NI,VHYDR,COMPOR,TMPCHI,TMPCHF,
     &             MATASS,CNDIRP,CNCHCI,CNCHTP,CNTNTP,CNTNTI,CNCHNL,
     &             VAPRIN,VAPRMO
      CHARACTER*24 STYPSE
      CHARACTER*(*) NOPASE

C 0.2. ==> COMMUNS
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------

      INTEGER            ZI
      INTEGER VALI
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

C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C 0.3. ==> VARIABLES LOCALES

      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'NXACMV' )
      INTEGER      IBID,K,IERR,NBMAT,LONCH,LONCM1,JMER,JMED,JMEM,JTN,
     &             JTNI,JNCHTP,JNDIRP,JNCHNL,JNTNTP,JNTNTI,J2ND,J2ND1,
     &             J2ND2,J2ND3,J2NI,J2NI1,J2NI2,J2NI3,IRET,TYPCUM,IFM,
     &             NIV,J2ND4
      COMPLEX*16   CBID
      CHARACTER*1  TYPRES
      CHARACTER*4  TYPCAL
      CHARACTER*8  K8BID,NOMCMP(6)
      CHARACTER*16 K16BID, OPTION, NOMCMD
      CHARACTER*24 LIGRMO,MERIGI,MEMASS,MEDIRI,TLIMAT(3),BIDON,VEDIRI,
     &             VECHTP,VETNTP,VETNTI,VADIRP,VACHTP,VECHTN,VACHTN,
     &             VTEMP2
      LOGICAL LLIN,LVECH,LVECNL
      DATA TYPRES /'R'/
      DATA NOMCMP /'INST    ','DELTAT  ','THETA   ','KHI     ',
     &             'R       ','RHO     '/
      DATA MEMASS /'&&METMAS           .RELR'/
      DATA MERIGI /'&&METRIG           .RELR'/
      DATA VEDIRI /'&&VETDIR           .RELR'/
      DATA VECHTP /'&&VETCHA           .RELR'/
      DATA VECHTN /'&&VENCHA           .RELR'/
      DATA VETNTI,VETNTP /'&&VETNTI           .RELR',
     &                    '&&VETNTH           .RELR'/
      DATA CNCHTP,CNTNTP,CNTNTI,CNCHNL  /4*' '/
      DATA BIDON  /' '/

C ----------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

C====
C 1. PREALABLE
C====
C RECUPERATION DU NOM DE LA CMD
      CALL GETRES ( K8BID, K16BID, NOMCMD )
      VADIRP = '&&'//NOMPRO//'VATDIR'
      VACHTP = '&&'//NOMPRO//'VATCHA'
      VACHTN = '&&'//NOMPRO//'VANCHA'
      CREAS = ' '

C DETERMINATION DU TYPE DE CALCUL (LINEAIRE OU NON)
      IF (NOMCMD(1:13).EQ.'THER_LINEAIRE') THEN
        LLIN = .TRUE.
        IF ( TYPESE.EQ.9 .OR. TYPESE.EQ.10 ) THEN
          CALL U2MESI('A','SENSIBILITE_1', 1 , TYPESE)
          CALL U2MESK('F','UTILITAI7_99', 1 ,NOMPRO)
        ENDIF
      ELSE
        LLIN = .FALSE.
      ENDIF

      IF (NIV.EQ.2) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'*******************************************'
        WRITE(IFM,*)' CALCUL DE SECOND MEMBRE THERMIQUE: NXACMV'
        WRITE(IFM,*)
        WRITE(IFM,*)' TYPESE/STYPSE        :',TYPESE,STYPSE
        WRITE(IFM,*)' INST                 :',TPSTHE(1)
        WRITE(IFM,*)' CALCUL LINEAIRE      :',LLIN
        WRITE(IFM,*)' REASVT/REASVC        :',REASVT,REASVC
        WRITE(IFM,*)' REASMT/REASRG/REASMS :',REASMT,REASRG,REASMS
        WRITE(IFM,*)' VTEMP/VAPRIN/VAPRMO  :',VTEMP,VAPRIN,VAPRMO
        WRITE(IFM,*)
      ENDIF
C ======================================================================
C 1.      VECTEURS (CHARGEMENTS) CONTRIBUANT AU SECOND MEMBRE
C            REACTUALISES AU DEBUT DE CHAQUE PAS DE TEMPS
C ======================================================================

      IF (REASVT) THEN

C 1.1. ==> (RE)ACTUALISATION DU CHAMP CONSTANT EN ESPACE : TIME

        LIGRMO = MODELE(1:8)//'.MODELE'
        CALL MECACT ('V',TIME,'MODELE',LIGRMO,'INST_R',6,NOMCMP,IBID,
     &              TPSTHE,CBID,K8BID)

C 1.2. ==> TEMPERATURES IMPOSEES (DIRICHLET)                 ---& CNDIRP
        IF ( TYPESE.EQ.0 .OR. TYPESE.EQ.2 ) THEN
          CALL VEDITH (MODELE,CHARGE,INFOCH,TIME,TYPESE,NOPASE,VEDIRI)
          CALL ASASVE (VEDIRI,NUMEDD,TYPRES,VADIRP)
          CALL ASCOVA ('D',VADIRP,FOMULT,'INST',TPSTHE(1),TYPRES,CNDIRP)
          CALL JEVEUO (CNDIRP(1:19)//'.VALE','L',JNDIRP)
        ENDIF

C 1.3. ==> CHARGES CINEMATIQUES                              ---& CNCHCI

        CNCHCI = ' '
        CALL ASCAVC (CHARGE,INFOCH,FOMULT,NUMEDD,TPSTHE(1),CNCHCI)

C 1.4. ==> CONTRIBUTION DU CHAMP A L'INSTANT PRECEDENT       ---& CNTNTP
C --- IDEM AVEC RHOCP ET NON ENTHALPIE                       ---& CNTNTI
C          INFLUENCE DES TERMES DE SENSIBILITE DANS CERTAINS CAS

C ON ECARTE D'EMBLEE LE CAS STATIONNAIRE (SAUF EN DERIVEE LAGRANGIENNE
C OU EN DERIVEE MATERIAU)
C POUR UN PB DE SENSIBILITE ON A A CALCULER
C LE TERME D'EVOLUTION SI ON EST EN TRANSITOIRE.
C POUR UN PB STD TRANSITOIRE C'EST BIEN SUR AUSSI LE CAS.

        IF ((.NOT.LOSTAT).OR.(TYPESE.EQ.-1).OR.(TYPESE.EQ.3)) THEN
          IF (LLIN) THEN
C THERMIQUE LINEAIRE -------------------------------------
            IF ( TYPESE.EQ.0 ) THEN
C PB STD
              OPTION = 'CHAR_THER_EVOL  '
            ELSE IF ( TYPESE.EQ.-1 ) THEN
C DERIVEES LAGRANGIENNES
              IF (LOSTAT) THEN
                OPTION = 'CHAR_DLAG_EVOLST'
              ELSE
                OPTION = 'CHAR_DLAG_EVOLTR'
              ENDIF
            ELSE
C PB DERIVE NON MATERIAU: ON CALCULE LE TERME STD EN REMPLACANT JUSTE
C T- PAR (DT/DS)- .
C PB DERIVE MATERIAU: OPTION SPECIFIQUE AVEC PLUS DE PARAMETRES
C RENVOYANT SUR LE MEME TE.
              IF (TYPESE.EQ.3) THEN
                OPTION = 'CHAR_SENS_EVOL  '
              ELSE
                OPTION = 'CHAR_THER_EVOL  '
              ENDIF
            ENDIF
          ELSE
C THERMIQUE NON LINEAIRE -----------------------------------
             IF (TYPESE.GT.1) THEN
               OPTION = 'CHAR_SENS_EVOLNI'
             ELSE
               OPTION = 'CHAR_THER_EVOLNI'
             ENDIF
           ENDIF

C CALCULS ELEMENTAIRES ET SOMMATION DANS LES VECT_ELEM VETNTP
          CALL VETNTH(OPTION,MODELE,CARELE,MATE,TIME,VTEMP,COMPOR,
     &                TMPCHI,TMPCHF,VHYDR,VAPRIN,VAPRMO,
     &                LOSTAT,NOPASE,TYPESE,STYPSE,
     &                VETNTP,VETNTI)

          CALL ASASVE (VETNTP,NUMEDD,TYPRES,CNTNTP)
          CALL JEVEUO (CNTNTP,'L',JTN)
          CALL JEVEUO (ZK24(JTN)(1:19)//'.VALE' ,'L',JNTNTP)
C EN SENSIBILITE NON-LINEAIRE ON N'A PAS A TRAITER CE TERME
          IF (.NOT.LLIN.AND.(TYPESE.EQ.0)) THEN
            CALL ASASVE (VETNTI,NUMEDD,TYPRES,CNTNTI)
            CALL JEVEUO (CNTNTI,'L',JTNI)
            CALL JEVEUO (ZK24(JTNI)(1:19)//'.VALE','L',JNTNTI)
          ENDIF

        ENDIF
C FIN DU IF REASVT
      ENDIF

C ======================================================================
C 2.      VECTEURS (CHARGEMENTS) CONTRIBUANT AU SECOND MEMBRE
C        REACTUALISES AU DEBUT DE CHAQUE ITERATION DE COUPLAGE
C                  ET SOMMATION DES SECONDS MEMBRES
C ======================================================================

      IF (REASVC) THEN

C 2.1. ==> CHARGEMENTS THERMIQUES                            ---& CNCHTP

        LVECH = .TRUE.
        LVECNL = .TRUE.
        IF (TYPESE.EQ.-1) THEN
C CALCUL DE DERIVEE LAGRANGIENNE.
          TYPCAL = 'DLAG'
        ELSE IF (TYPESE.EQ.0) THEN
C CALCUL THERMIQUE STANDARD
          TYPCAL = 'THER'
        ELSE
C CALCUL DE SENSIBILITE
          TYPCAL = 'SENS'
C EN STATIONNAIRE (LINEAIRE OU NON)+ DERIVEE MATERIAU OU DIRICHLET
C  => ON A PAS A FAIRE LES ASSEMBLAGES DES TERMES LIES AUX CHARGEMENTS
          IF (LOSTAT.AND.((TYPESE.EQ.2).OR.(TYPESE.EQ.3))) THEN
            LVECH = .FALSE.
            LVECNL = .FALSE.
          ENDIF
C EN STATIONNAIRE NON-LINEAIRE + DERIVEE FLUX_NL OU RAYONNEMENT
C  => ON A PAS A FAIRE LES ASSEMBLAGES LIES AUX CHARGEMENTS LINEAIRES
          IF (LOSTAT.AND.((TYPESE.EQ.9).OR.(TYPESE.EQ.10)))
     &      LVECH = .FALSE.
        ENDIF

C CALCULS ELEMENTAIRES ET SOMMATION DANS LES VECT_ELEM VECHTP ET VACHTP
        IF (LVECH) THEN
          CALL VECHTH(TYPCAL,MODELE,CHARGE,INFOCH,CARELE,MATE,TIME,
     &                VTEMP,VAPRIN,VAPRMO,
     &                LOSTAT,NOPASE,TYPESE,STYPSE,
     &                VECHTP)
          CALL ASASVE(VECHTP,NUMEDD,TYPRES,VACHTP)
          CALL ASCOVA('D',VACHTP,FOMULT,'INST',TPSTHE(1),TYPRES,CNCHTP)
          CALL JEVEUO(CNCHTP(1:19)//'.VALE','L',JNCHTP)
        ENDIF

C 2.2. ==> CHARGEMENTS THERMIQUES NON LINEAIRES EN TEMPERATURE -& CNCHNL
        IF ((.NOT.LLIN).AND.LVECNL) THEN
          CALL VECHNL(TYPCAL,MODELE,CHARGE,INFOCH,CARELE,TIME,
     &                VTEMP,VAPRIN,VAPRMO,
     &                LOSTAT,NOPASE,TYPESE,VECHTN)
          CALL ASASVE (VECHTN,NUMEDD,TYPRES,VACHTN)
          CALL ASCOVA ('D',VACHTN,BIDON,'INST',TPSTHE(1),TYPRES,CNCHNL)
          CALL JEVEUO (CNCHNL(1:19)//'.VALE','L',JNCHNL)
        ENDIF

        IF (LOSTAT) THEN
          CALL JEDETR(VECHTP)
          CALL JEDETR(VECHTN)
        ENDIF

C 2.3. ==> SECOND MEMBRE COMPLET

C 2.3.1. ==> RECHERCHE DU TYPE DE CUMUL
C            ON DISTINGUE LE GROS PAS DE TEMPS NUMERO 0 ET LES SUIVANTS

        IF ( LOSTAT) THEN

C 2.3.1.1. ==> THERMIQUE LINEAIRE AU GROS PAS DE TEMPS NUMERO 0

          IF (LLIN) THEN

            IF (TYPESE.EQ.0) THEN
C CALCUL STD STATIONNAIRE:
C ==> ON ASSEMBLE LES SECONDS MEMBRES DE DIRICHLET ET DE CHARGE
              TYPCUM = 2
              J2ND1 = JNCHTP
              J2ND2 = JNDIRP
            ELSE IF (TYPESE.EQ.-1) THEN
C CALCUL STATIONNAIRE DE DERIVEE LAGRANGIENNE:
C ==> ON ASSEMBLE LES SECONDS MEMBRES D'IMPLICITATION ET DE CHARGE
              TYPCUM = 2
              J2ND1 = JNCHTP
              J2ND2 = JNTNTP
            ELSE IF (TYPESE.EQ.2) THEN
C CALCUL STATIONNAIRE SENSIBILITE / DIRICHLET:
C ==> ON ASSEMBLE LE SECOND MEMBRE DE DIRICHLET
              TYPCUM = 1
              J2ND1 = JNDIRP
            ELSE IF (TYPESE.EQ.3) THEN
C CALCUL STATIONNAIRE SENSIBILITE / MATERIAU:
C ==> ON ASSEMBLE LES SECONDS MEMBRES D'IMPLICITATION
              TYPCUM = 1
              J2ND1 = JNTNTP
            ELSE
C CALCUL STATIONNAIRE SENSIBILITE / AUTRES PARAMETRES.
C  ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE
              TYPCUM = 1
              J2ND1 = JNCHTP
            ENDIF

C 2.3.1.2. ==> THERMIQUE NON LINEAIRE AU GROS PAS DE TEMPS NUMERO 0
          ELSE

            IF (TYPESE.EQ.2) THEN
C CALCUL STATIONNAIRE SENSIBILITE / DIRICHLET:
C ==> ON ASSEMBLE LE SECOND MEMBRE DE DIRICHLET
              TYPCUM = 1
              J2ND1 = JNDIRP
            ELSE IF (TYPESE.EQ.3) THEN
C CALCUL STATIONNAIRE DE DERIVEE MATERIAU:
C ==> ON ASSEMBLE LES SECONDS MEMBRES D'IMPLICITATION
              TYPCUM = 1
              J2ND1 = JNTNTP
            ELSE IF ((TYPESE.EQ.9).OR.(TYPESE.EQ.10)) THEN
C CALCUL STATIONNAIRE SENSIBILITE / CHARGEMENTS NON-LINEAIRES
C ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE NON-LINEAIRE
              TYPCUM = 1
              J2ND1 = JNCHNL
            ELSE
C CALCUL STD STATIONNAIRE OU SENSIBILITE / AUTRES PARAMETRES:
C ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE LINEAIRE ET NON-LINEAIRE
              TYPCUM = 2
              J2ND1 = JNCHTP
              J2ND2 = JNCHNL
            ENDIF
          ENDIF

        ELSE

C 2.3.1.3. ==> THERMIQUE LINEAIRE AUX GROS PAS DE TEMPS SUIVANTS

          IF (LLIN) THEN

            IF ((TYPESE.EQ.0).OR.(TYPESE.EQ.2)) THEN
C CALCUL TRANSITOIRE STD OU DE SENSIBILITE / DIRICHLET:
C ==> ON ASSEMBLE LES SECONDS MEMBRES DE DIRICHLET, D'IMPLICITATION
C     ET DE CHARGE
              TYPCUM = 3
              J2ND1 = JNCHTP
              J2ND2 = JNDIRP
              J2ND3 = JNTNTP
            ELSE
C CALCUL TRANSITOIRE DE SENSIBILITE PAR RAPPORT AUX AUTRES PARAMETRES.
C  ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE ET D'IMPLICITATION
              TYPCUM = 2
              J2ND1 = JNCHTP
              J2ND2 = JNTNTP
            ENDIF

C 2.3.1.4. ==> THERMIQUE NON LINEAIRE AUX GROS PAS DE TEMPS SUIVANTS

          ELSE
            IF (TYPESE.EQ.0) THEN
C CALCUL TRANSITOIRE STD.
C  ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE LINEAIRE, NON-LINEAIRE
C      ET D'IMPLICITATION (EN RHO_CP DANS J2NI POUR PRE-ITERATION DE
C      PREDICTION ET EN BETA DANS J2ND POUR ITERATIONS DE NEWTON)
              TYPCUM = 33
              J2ND1 = JNCHTP
              J2ND2 = JNCHNL
              J2ND3 = JNTNTP
              J2NI1 = JNCHTP
              J2NI2 = JNCHNL
              J2NI3 = JNTNTI
            ELSE IF (TYPESE.EQ.2) THEN
C CALCUL TRANSITOIRE SENSIBILITE / DIRICHLET:
C ==> ON ASSEMBLE LES SECONDS MEMBRES DE DIRICHLET, D'IMPLICITATION
C     ET DE CHARGE LINEAIRE ET NON-LINEAIRE
              TYPCUM = 4
              J2ND1 = JNCHTP
              J2ND2 = JNDIRP
              J2ND3 = JNTNTP
              J2ND4 = JNCHNL
            ELSE
C CALCUL TRANSITOIRE DE SENSIBILITE / AUTRES PARAMETRES.
C  ==> ON ASSEMBLE LES SECONDS MEMBRES DE CHARGE ET D'IMPLICITATION
              TYPCUM = 3
              J2ND1 = JNCHTP
              J2ND2 = JNTNTP
              J2ND3 = JNCHNL
            ENDIF
          ENDIF
C FIN IF NRGPA
        ENDIF

C --- SECOND MEMBRE COMPLET                                  ---& VEC2ND
C --- SECOND MEMBRE COMPLET                                  ---& VEC2NI

C 2.3.2. ==> ADRESSES ET LONGUEURS DU/DES SECOND(S) MEMBRE(S)

        CALL JEVEUO (VEC2ND(1:19)//'.VALE','E',J2ND)
        IF (.NOT.LLIN) CALL JEVEUO(VEC2NI(1:19)//'.VALE','E',J2NI)
        CALL JELIRA(VEC2ND(1:19)//'.VALE','LONMAX',LONCH,K8BID)
        LONCM1 = LONCH - 1

C 2.3.3. ==> CUMUL DES DIFFERENTS TERMES

        IF ( TYPCUM.EQ.0 ) THEN
          DO 23000 , K = 0, LONCM1
            ZR(J2ND+K) = 0.D0
23000     CONTINUE
        ELSEIF ( TYPCUM.EQ.1 ) THEN
          DO 23001 , K = 0, LONCM1
            ZR(J2ND+K) = ZR(J2ND1+K)
23001     CONTINUE
        ELSEIF ( TYPCUM.EQ.2 ) THEN
          DO 23002 , K = 0, LONCM1
            ZR(J2ND+K) = ZR(J2ND1+K) + ZR(J2ND2+K)
23002     CONTINUE
        ELSEIF ( TYPCUM.EQ.3 ) THEN
          DO 23003 , K = 0, LONCM1
            ZR(J2ND+K) = ZR(J2ND1+K) + ZR(J2ND2+K) + ZR(J2ND3+K)
23003     CONTINUE
        ELSEIF ( TYPCUM.EQ.4 ) THEN
          DO 23004 , K = 0, LONCM1
            ZR(J2ND+K)=ZR(J2ND1+K)+ZR(J2ND2+K)+ZR(J2ND3+K)+ZR(J2ND4+K)
23004     CONTINUE
        ELSEIF ( TYPCUM.EQ.33 ) THEN
          DO 23033 , K = 0, LONCM1
            ZR(J2ND+K) = ZR(J2ND1+K) + ZR(J2ND2+K) + ZR(J2ND3+K)
            ZR(J2NI+K) = ZR(J2NI1+K) + ZR(J2NI2+K) + ZR(J2NI3+K)
23033     CONTINUE
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C FIN IF REASVC
      ENDIF

C ======================================================================
C 3.            MATRICE ASSEMBLEE
C ======================================================================

      IF ( REASMT .OR. REASRG .OR. REASMS ) THEN

C 3.1. ==> (RE)CALCUL DES MATRICES ELEMENTAIRES

C 3.1.1. ==> (RE)CALCUL DE LA MATRICE TANGENTE EN NON-LINEAIRE

        IF (.NOT.LLIN) THEN

          CREAS = 'M'
          IF (TYPESE.EQ.0) THEN
            VTEMP2 = VTEMP
          ELSE
            VTEMP2 = VAPRIN
            IF (NIV.EQ.2) THEN
              WRITE(IFM,*)
              WRITE(IFM,*)'-->  BLUFF DE L''ASSEMBLAGE DE LA MATRICE'
              WRITE(IFM,*)'-->  MTAN_RIGI/THER AVEC T+ =',VAPRIN
              WRITE(IFM,*)'-->  AU LIEU DE (DT/DS)+ =',VTEMP
              WRITE(IFM,*)
            ENDIF
          ENDIF
          CALL MERXTH(MODELE,CHARGE,INFOCH,CARELE,MATE,TIME,
     &                VTEMP2,MERIGI,COMPOR,TMPCHI,TMPCHF)

C 3.1.2. ==> (RE)CALCUL DES MATRICES DE MASSE ET DE RIGIDITE EN LINEAIRE

        ELSE

          IF ( REASMS ) THEN
            CALL MEMSTH (MODELE,CARELE,MATE,TIME,MEMASS)
          ENDIF

          IF ( REASRG ) THEN
            CALL MERGTH (MODELE,CHARGE,INFOCH,CARELE,MATE,TIME,MERIGI)
          ENDIF

        ENDIF

C 3.2. ==> ASSEMBLAGE DE LA MATRICE

        NBMAT = 0

        CALL JEEXIN(MERIGI,IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(MERIGI,'L',JMER)
          IF (ZK24(JMER)(1:8).NE.'        ') THEN
            NBMAT = NBMAT + 1
            TLIMAT(NBMAT) = MERIGI 
          END IF
        END IF

        CALL JEEXIN(MEDIRI,IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(MEDIRI,'L',JMED)
          IF (ZK24(JMED)(1:8).NE.'        ') THEN
            NBMAT = NBMAT + 1
            TLIMAT(NBMAT) = MEDIRI
      END IF
        END IF

        CALL JEEXIN(MEMASS,IRET)
        IF (IRET.GT.0) THEN
          CALL JEVEUO(MEMASS,'L',JMEM)
          IF (ZK24(JMEM) (1:8).NE.'        ') THEN
            NBMAT = NBMAT + 1
            TLIMAT(NBMAT) =MEMASS
         END IF
        END IF

        CALL ASMATR (NBMAT,TLIMAT,' ',NUMEDD,SOLVEU,
     &               INFCHA,'ZERO','V',1,MATASS)

C 3.3. ==> DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONNEMENT

        CALL PRERES (SOLVEU,'V',IERR,MAPREC,MATASS)

      END IF

C-----------------------------------------------------------------------
      CALL JEDEMA()
      END
