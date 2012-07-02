         SUBROUTINE PLASBE ( FAMI, KPG, KSP, TYPMOD, IMAT,
     &                       CRIT, EPSDT,
     &                       DEPST, SIGD, VIND, OPT, ELGEOM, SIGF,
     &                       VINF,  DSDE,  ICOMP, NVI,  IRTETI)
      IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C       ================================================================
C       INTEGRATION DE LOIS DE COMPORTEMENT ELASTO PLASTIQUE ET VISCO
C       PLASTIQUE
C               AVEC    . N VARIABLES INTERNES
C                       . UNE FONCTION SEUIL ELASTIQUE
C
C       INTEGRATION DES CONTRAINTES           = SIG(T+DT)
C       INTEGRATION DES VARIABLES INTERNES    = VIN(T+DT)
C       ET CALCUL DU JACOBIEN ASSOCIE         = DS/DE(T+DT) OU DS/DE(T)
C
C       EN CAS DE NON-CONVERGENCE LOCALE ON EFFECTUE UN REDECOUPAGE DU
C       PAS DE TEMPS, L ORDRE D EXECUTION ETANT REMONTE EN ARGUMENT
C       DANS REDECE, APPELE PAR NMCOMP AVANT PLASBE
C       ================================================================
C       ROUTINE CONSTRUITE SUIVANT LE MODELE ET L'ARCHITECTURE DE
C                                PLASTI
C       ================================================================
C       ROUTINES UTILITAIRES DE CALCUL MATRICIEL(6,6) - VECTORIEL (6)
C       COMMON /TDIM/ NDT,NDI    A INCLURE OBLIGATOIREMENT
C       () = DEBUG
C
C       ( LCIMMA  IMPRESSION MATRICE )
C       ( LCIMVE  IMPRESSION VECTEUR )
C       ( LCIMSC  IMPRESSION SCALAIRE )
C       LCPRTE  PRODUIT TENSORIEL DE VECTEURS
C       LCPRSC  PRODUIT SCALAIRE  DE VECTEURS
C       LCPRSM  PRODUIT SCALAIRE * MATRICE
C       LCPTMV  PRODUIT MATRICE TRANSPOSEE * VECTEUR
C       LCPRMV  PRODUIT MATRICE  * VECTEUR
C       LCPRMM  PRODUIT MATRICE  * MATRICE
C       LCDIMA  DIFFERENCE DE MATRICES
C       LCSOMA  SOMME DE MATRICES
C       LCTRMA  TRANSPOSEE DE MATRICE
C       LCEQMA  EGALITE DE MATRICES
C       LCINMA  INITIALISATION DE MATRICE A UNE VALEUR
C       LCPRSV  PRODUIT SCALAIRE * VECTEUR
C       LCSOVE  SOMME DE VECTEUR
C       LCNRVE  NORME DE VECTEUR
C       LCDIVE  DIFFERENCE DE VECTEURS
C       LCINVE  INITIALISATION DE VECTEUR
C       LCEQVE  EGALITE DE VECTEURS
C
C       ----------------------------------------------------------------
C       ROUTINES UTILITAIRES D INTEGRATION D UN MODELE DE COMPORTEMENT
C
C       LCDEVI  PARTIE DEVIATORIQUE D UN TENSEUR
C       LCHYDR  PARTIE SPHERIQUE    D UN TENSEUR
C       LCVS    DERIVEE DE LA CONTRAINTE VON MISES / CONTRAINTE
C       LCVVSS  DERIVEE SECONDE DE LA CONTRAINTE VON MISES / CONTRAINTE
C       LCIV2S  SECOND INVARIANT DU TENSEUR CONTRAINTE
C       LCIV2E  SECOND INVARIANT DU TENSEUR DEFORMATION
C       LCNRTS  'NORME' DU TENSEUR CONTRAINTE
C       LCNRTE  'NORME' DU TENSEUR DEFORMATION
C       LCOPLI  OPERATEUR ELASTIQUE LINEAIRE
C       LCELIN  INTEGRATION  ELASTIQUE LINEAIRE ISOTROPE
C       LCVERR  CALCUL DU VECTEUR D'ERREUR RELATIVE, ABSOLU, NORMEE...
C
C       ================================================================
C       ARGUMENTS
C
C       IN      TYPMOD  TYPE DE MODELISATION
C               IMAT    ADRESSE DU MATERIAU CODE
C               COMP    COMPORTEMENT DE L ELEMENT
C                       COMP(1) = RELATION DE COMPORTEMENT
C                       COMP(2) = NB DE VARIABLES INTERNES
C                       COMP(3) = TYPE DE DEFORMATION (PETIT,JAUMANN...)
C               OPT     OPTION DE CALCUL A FAIRE
C                               'RIGI_MECA_TANG'> DSDE(T)
C                               'FULL_MECA'     > DSDE(T+DT) , SIG(T+DT)
C                               'RAPH_MECA'     > SIG(T+DT)
C               CRIT    CRITERES  LOCAUX
C                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                                 (ITER_INTE_MAXI == ITECREL)
C                       CRIT(2) = TYPE DE JACOBIEN A T+DT
C                                 (TYPE_MATR_COMP == MACOMP)
C                                 0 = EN VITESSE     > SYMETRIQUE
C                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
C                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                                 (RESI_INTE_RELA == RESCREL)
C                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
C                                 (RESI_INTE_PAS == ITEDEC )
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C               ELGEOM  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
C                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
C                       FIXEE EN DUR)
C               EPSDT   DEFORMATION TOTALE A T
C               DEPST   INCREMENT DE DEFORMATION TOTALE
C               SIGD    CONTRAINTE A T
C               VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C               ICOMP   COMPTEUR POUR LE REDECOUPAGE DU PAS DE TEMPS
C       OUT     SIGF    CONTRAINTE A T+DT
C               VINF    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
C               DSDE    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C               IRTETI = 1 CONTROLE DU REDECOUPAGE DU PAS DE TEMPS
C       ----------------------------------------------------------------
C       INFO    MATERD        (*,1) = CARACTERISTIQUES ELASTIQUES A T
C                             (*,2) = CARACTERISTIQUES PLASTIQUES A T
C               MATERF        (*,1) = CARACTERISTIQUES ELASTIQUES A T+DT
C                             (*,2) = CARACTERISTIQUES PLASTIQUES A T+DT
C               MATCST          'OUI' SI MATERIAU CST ENTRE T ET T+DT
C                               'NON' SINON
C               NDT             NB DE COMPOSANTE TOTALES DES TENSEURS
C                                       = 6  3D
C                                       = 4  AXIS  C_PLAN  D_PLAN
C                                       = 1  1D
C               NDI             NB DE COMPOSANTE DIRECTES DES TENSEURS
C               NVI             NB DE VARIABLES INTERNES
C               NR              NB EQUATION SYSTEME INTEGRE A RESOUDRE
C       ----------------------------------------------------------------
C       ROUTINE LC....UTILITAIRES POUR INTEGRATION LOI DE COMPORTEMENT
C       ----------------------------------------------------------------
C       ORDRE DES TENSEURS      3D      XX YY ZZ XY XZ YZ
C                               DP      XX YY ZZ XY
C                               AX      RR ZZ TT RZ
C                               1D      XX YY ZZ
C       ----------------------------------------------------------------
C       ATTENTION
C       SI OPT = 'RIGI_MECA_TANG' NE PAS TOUCHER AUX VARIABLES SIGF,VINF
C       QUI N ONT PAS DE PLACE MEMOIRE ALLOUEE
C
C       SIG EPS DEPS  ONT DEJA LEURS COMPOSANTES DE CISAILLEMENT
C       MULTIPLIES PAR RACINE DE 2 > PRISE EN COMPTE DES DOUBLES
C       PRODUITS TENSORIELS ET CONSERVATION DE LA SYMETRIE
C
C       ----------------------------------------------------------------
      INCLUDE 'jeveux.h'
        INTEGER         IMAT , NDT   , NDI   , NR  , NVI
        INTEGER         ITMAX, ICOMP
        INTEGER         NMAT , IRTET , IRTETI, NSEUI4, IISNAN 
        INTEGER         NSEUIL, NSEUI1, NSEUI2, NSEUI3
        INTEGER         IADZI, IAZK24
        REAL*8          TOLER
        REAL*8          EPSI
C
C-----------------------------------------------------------------------
      INTEGER IRET ,KPG ,KSP 
      REAL*8 TNEG ,TREF 
C-----------------------------------------------------------------------
        PARAMETER       ( EPSI = 1.D-15 )
        PARAMETER       ( NMAT = 90     )
        PARAMETER       ( TNEG = -1.D3  )
C
        REAL*8          CRIT(*)
        REAL*8          VIND(*),     VINF(*)
        REAL*8          TEMPD,    TEMPF
        REAL*8          ELGEOM(*)
        REAL*8          EPSD(6),     DEPS(6)
        REAL*8          EPSDT(6),    DEPST(6)
        REAL*8          SIGD(6),     SIGF(6),   SIGE(6)
C
        REAL*8          DSDE(6,6)
        REAL*8          MATERD(NMAT,2) , MATERF(NMAT,2) , TMPMX
        CHARACTER*7     ETATD  ,     ETATF
        CHARACTER*8     MOD,        TYPMA,   TYPMOD(*)
        CHARACTER*16    OPT
        CHARACTER*3     MATCST, CNSEUI
        CHARACTER*8     NOMAIL
        CHARACTER*(*)   FAMI
        REAL*8          R8NNEM
        LOGICAL         RIGI, RESI, ISTEMP
C       ----------------------------------------------------------------
        COMMON /TDIM/   NDT  , NDI
        COMMON /ECRI/   NOMAIL
C       ----------------------------------------------------------------
C
C --    INITIALISATION DES PARAMETRES DE CONVERGENCE ET ITERATIONS
C
        IRTETI   = 0
        ITMAX    = INT(CRIT(1))
        TOLER    =     CRIT(3)
C        LOI      = COMP(1)
        MOD      = TYPMOD(1)
        NSEUIL   = 0
        NSEUI1   = 0
        NSEUI2   = 0
        NSEUI3   = 0
        NSEUI4   = 0
        NOMAIL   = ' '

        RESI   = OPT(1:9).EQ.'FULL_MECA' .OR.
     &           OPT     .EQ.'RAPH_MECA'
        RIGI   = OPT(1:9).EQ.'FULL_MECA' .OR.
     &           OPT(1:9).EQ.'RIGI_MECA'
        CALL ASSERT ( (OPT(1:9).EQ.'RIGI_MECA') .OR.
     &                (OPT(1:9).EQ.'FULL_MECA') .OR.
     &                (OPT     .EQ.'RAPH_MECA') )
        CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TEMPD,IRET)
        CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TEMPF,IRET)
        CALL RCVARC(' ','TEMP','REF',FAMI,KPG,KSP,TREF,IRET)

C --    C'EST INTERDIT DE MELANGER DEUX MODELISATIONS AVEC OU SANS 
C --      DEPENDENCE DES PARAMETRES DE LA TEMPERATURE       
        IF ( (IISNAN(TEMPD).EQ.0).AND.(IISNAN(TEMPF).EQ.1) ) THEN
          CALL U2MESS('F','ALGORITH9_100')
        ELSEIF ((IISNAN(TEMPD).EQ.1).AND.(IISNAN(TEMPF).EQ.0)) THEN
          CALL U2MESS('F','ALGORITH9_100')
        ELSEIF ((VIND(3).EQ.TNEG).AND.(IISNAN(TEMPF).EQ.0)) THEN
          CALL U2MESS('F','ALGORITH9_100')        
        ELSE
          ISTEMP = IISNAN(TEMPD).EQ.0 .AND. IISNAN(TEMPF).EQ.0
        ENDIF
C
C --    OPTION SUPPRIMEE CAR TYPMA EST IMPOSE SUIVANT QUE L'ON EST EN
C --    PLASTCITE OU VISCOPLASTICITE. TYPMA EST DEFINI DANS LCMATE
C --    POUR LES MODELE VISCO-PLASTIQUES A LA VALEUR 'COHERENT'.
C          IF ( INT(CRIT(2)) .EQ. 0 ) THEN
C          TYPMA = 'VITESSE '
C          ELSE
C          TYPMA = 'COHERENT'
C          ENDIF
C
          TYPMA = 'VITESSE '
C
          IF ( ITMAX .LE. 0  ) ITMAX = -ITMAX
C
C --    LES PARAMETRES SONT FONCTIONS DE LA TEMPERATURE MAXIMALE
C --    VIND(3) EST LE MAX DES TEMPERATURES DANS L'HISTORIQUE DES TEMP.
C
        IF (ISTEMP) THEN
          TMPMX = VIND(3)
          IF (TEMPD.GT.TMPMX) TMPMX = TEMPD
        ELSE 
          TMPMX=R8NNEM()
        ENDIF
C
C --    RECUPERATION COEF(TEMP(T))) LOI ELASTO-PLASTIQUE A T ET/OU T+DT
C                    NB DE CMP DIRECTES/CISAILLEMENT + NB VAR. INTERNES
C

        CALL BETMAT ( FAMI, KPG, KSP, MOD, IMAT, NMAT, TMPMX, TEMPF,
     &                MATERD, MATERF, MATCST, NDT, NDI , NR, NVI)
C
C --    RETRAIT INCREMENT DE DEFORMATION DUE A LA DILATATION THERMIQUE
C
        CALL LCDEDI ( FAMI, KPG, KSP, NMAT,  MATERD, MATERF,TEMPD,TEMPF,
     &                TREF, DEPST, EPSDT, DEPS,   EPSD )
C
C --    RETRAIT ENDOGENNE ET RETRAIT DE DESSICCATION
C
        CALL LCDEHY ( FAMI, KPG, KSP, NMAT,  MATERD, MATERF,
     &                DEPS, EPSD )
C
C --    SEUIL A T > ETAT ELASTIQUE OU PLASTIQUE A T
C
        IF  ( ABS(VIND (NVI)) .LE. EPSI ) THEN
           ETATD = 'ELASTIC'
        ELSE
           ETATD = 'PLASTIC'
        ENDIF       
C
C  -->  REDECOUPAGE IMPOSE
        IF ( ICOMP .EQ. -1 .AND. OPT .NE. 'RIGI_MECA_TANG') THEN
            IRTETI = 0
            GOTO 9999
        ENDIF
C
C       ----------------------------------------------------------------
C       OPTIONS 'FULL_MECA' ET 'RAPH_MECA' = CALCUL DE SIG(T+DT)
C       ----------------------------------------------------------------
C
C        IF ( OPT .EQ. 'RAPH_MECA' .OR. OPT .EQ. 'FULL_MECA' ) THEN
        IF (RESI) THEN
C
C --    INTEGRATION ELASTIQUE SUR DT
C
C       CALL LCELAS ( LOI  ,MOD ,  IMAT,  NMAT, MATERD, MATERF, MATCST,
C    1                NVI,  TEMPD, TEMPF, TIMED,TIMEF,  DEPS,   EPSD,
C    2                SIGD ,VIND,  SIGE,  VINF )
        CALL LCELIN ( MOD ,  NMAT, MATERD, MATERF,
     &                DEPS,  SIGD, SIGE)
        CALL LCEQVN  ( NVI-1, VIND , VINF )
        VINF(NVI)    = 0.D0

        IF (ISTEMP) THEN
          IF (TMPMX.LT.TEMPF) TMPMX = TEMPF
          VINF(3) = TMPMX
        ELSE
          VINF(3) = TNEG
        ENDIF
C
        CALL LCEQVN ( NDT  ,  SIGE , SIGF )
C
C --    PREDICTION ETAT ELASTIQUE A T+DT : F(SIG(T+DT),VIN(T)) = 0 ?
C
        CALL BETCVX ( NMAT, MATERF, SIGF, VIND, VINF,
     &                ELGEOM, NVI, NSEUIL)
C
        IF ( NSEUIL .GE. 0 ) THEN
C
C --       PREDICTION INCORRECTE > INTEGRATION ELASTO-PLASTIQUE SUR DT
C
           ETATF = 'PLASTIC'
C
           NSEUI1 = NSEUIL
           CALL LCPLBE ( TOLER, ITMAX, NMAT, MATERF,NVI, VIND, SIGF,
     &                   VINF, ELGEOM, NSEUIL, IRTET)
C           GOTO (1), IRTET
C
           CALL BETCVX ( NMAT, MATERF,  SIGF, VIND,
     &                   VINF, ELGEOM, NVI, NSEUIL)
           NSEUI2 = NSEUIL
C
           IF ( NSEUI2 .GT. 0 ) THEN
              IF ( NSEUI2 .EQ. 44) THEN
                 CALL U2MESS('A','ALGORITH9_93')
                 GOTO 1
              ENDIF
              IF ( NSEUI2 .EQ. 4) THEN
                 CALL CODENT(NSEUI1,'G',CNSEUI)
                 CALL U2MESK('A','ALGORITH9_94',1,CNSEUI)
                 GOTO 1
              ENDIF
              IF ( NSEUI2 .EQ. NSEUI1) THEN
                 IF ( NSEUI2 .NE. 3 ) THEN
                    NSEUI2 = 3
                 ELSE
                    NSEUI2 = 2
                 ENDIF
                 NSEUIL = NSEUI2
              ENDIF
              CALL LCEQVN ( NDT  ,  SIGE , SIGF )
              CALL LCPLBE ( TOLER, ITMAX, NMAT, MATERF,NVI,VIND,SIGF,
     &                      VINF, ELGEOM, NSEUIL, IRTET)
C              GOTO (1), IRTET
C
              CALL BETCVX ( NMAT, MATERF, SIGF, VIND,
     &                      VINF, ELGEOM, NVI, NSEUIL)
              NSEUI3 = NSEUIL
           ENDIF
C
           IF ( NSEUI3 .GT. 0 ) THEN
              IF ( NSEUI3 .EQ. 44) THEN
                 CALL U2MESS('A','ALGORITH9_93')
                 GOTO 1
              ENDIF
              IF ( NSEUI3 .EQ. 4) THEN
                 CALL CODENT(NSEUI2,'G',CNSEUI)
                 CALL U2MESK('A','ALGORITH9_94',1,CNSEUI)
                 GOTO 1
              ENDIF
              IF ( NSEUI3 .EQ. NSEUI1 .OR. NSEUI3 .EQ. NSEUI2 ) THEN
                 NSEUI3 = 6 - NSEUI1 - NSEUI2
                 NSEUIL = NSEUI3
              ENDIF
              CALL LCEQVN ( NDT  ,  SIGE , SIGF )
              CALL LCPLBE ( TOLER, ITMAX, NMAT, MATERF,NVI, VIND, SIGF,
     &                      VINF, ELGEOM, NSEUIL, IRTET)
C              GOTO (1), IRTET
C
              CALL BETCVX ( NMAT, MATERF, SIGF, VIND,
     &                      VINF, ELGEOM, NVI, NSEUIL)
              NSEUI4 = NSEUIL
           ENDIF
C
           IF ( NSEUI4 .GT. 0 ) THEN
              IF ( NSEUI4 .EQ. 44) THEN
                 CALL U2MESS('A','ALGORITH9_93')
                 GOTO 1
              ENDIF
              IF ( NSEUI4 .EQ. 4) THEN
                 CALL CODENT(NSEUI3,'G',CNSEUI)
                 CALL U2MESK('A','ALGORITH9_94',1,CNSEUI)
                 GOTO 1
              ENDIF
              NSEUIL = 22
              NSEUI4 = NSEUIL
              CALL LCEQVN ( NDT  ,  SIGE , SIGF )
              CALL LCPLBE ( TOLER,ITMAX,NMAT,MATERF,NVI,VIND,SIGF,
     &                      VINF,ELGEOM,NSEUIL,IRTET )
C             GOTO (1), IRTET
C
              CALL BETCVX ( NMAT, MATERF, SIGF, VIND,
     &                      VINF, ELGEOM, NVI, NSEUIL)
           ENDIF
C
           IF ( NSEUIL .GE. 0 ) THEN
              CALL CODENT(NSEUI4,'G',CNSEUI)
              CALL U2MESK('A','ALGORITH9_94',1,CNSEUI)
              GOTO 1
           ENDIF
C
        ELSE
C
C --       PREDICTION CORRECTE > INTEGRATION ELASTIQUE FAITE
C
           ETATF = 'ELASTIC'
        ENDIF
C
        ENDIF
C
C       ----------------------------------------------------------------
C       OPTIONS 'FULL_MECA', 'RIGI_MECA_TANG', 'RIGI_MECA_ELAS' :
C          CALCUL DE DSDE
C       ----------------------------------------------------------------
C       EVALUATION DU JACOBIEN DSDE A (T+DT) POUR 'FULL_MECA'
C       ET CALCUL ELASTIQUE    ET   A (T)    POUR 'RIGI_MECA_TANG'
C       ----------------------------------------------------------------
C
C        IF ( OPT .EQ. 'RIGI_MECA_TANG' .OR. OPT .EQ. 'FULL_MECA' ) THEN
        IF (RIGI) THEN
          IF ( OPT(1:9) .EQ. 'RIGI_MECA' ) THEN
            IF (( ETATD.EQ.'ELASTIC' ) .OR. 
     &         ( OPT(10:14).EQ.'_ELAS' )) THEN 
            
C           CALL LCJELA ( LOI  , MOD ,  IMAT,  NMAT, MATERD, NVI,
C    1                    TEMPD, TIMED, DEPS,  EPSD, SIGD ,  VIND, DSDE)
            CALL LCOPLI ( 'ISOTROPE' , MOD , MATERD(1,1) , DSDE )
            ELSEIF ( ETATD .EQ. 'PLASTIC' ) THEN
C   ------> ELASTOPLASTICITE ==> TYPMA = 'VITESSE '
C   ------> VISCOPLASTICITE  ==> TYPMA = 'COHERENT '==> CALCUL ELASTIQUE
                IF     ( TYPMA .EQ. 'COHERENT' ) THEN
C PAS UTILISE ICI  CALL LCJELA ( LOI  , MOD ,  NMAT, MATERD,VIND, DSDE)
                ELSEIF ( TYPMA .EQ. 'VITESSE ' ) THEN
               CALL BETJPL (MOD, NMAT, MATERD, SIGD,
     &                      VIND, ELGEOM, DSDE)
                ENDIF
            ENDIF
C
          ELSEIF ( OPT (1:9) .EQ . 'FULL_MECA' ) THEN
                IF  (( ETATF .EQ. 'ELASTIC' ) .OR.
     &               ( OPT(10:14) .EQ. '_ELAS' )) THEN
C           CALL LCJELA ( LOI  , MOD ,  IMAT,  NMAT, MATERF, NVI,
C    1                    TEMPF, TIMEF, DEPS,  EPSD, SIGF ,  VINF, DSDE)
            CALL LCOPLI ( 'ISOTROPE' , MOD , MATERF(1,1) , DSDE )
            ELSEIF ( ETATF .EQ. 'PLASTIC' ) THEN
C   ------> ELASTOPLASTICITE ==>  TYPMA = 'VITESSE '
C   ------> VISCOPLASTICITE  ==>  TYPMA = 'COHERENT '
                IF     ( TYPMA .EQ. 'COHERENT' ) THEN
C PAS UTILISE ICI  CALL LCJPLC ( LOI  , MOD ,  NMAT, MATERD, DSDE)
                ELSEIF ( TYPMA .EQ. 'VITESSE ' ) THEN
               CALL BETJPL (MOD, NMAT, MATERD, SIGF,
     &                      VINF, ELGEOM, DSDE)
                ENDIF
            ENDIF
          ENDIF          
        ENDIF
C
C       ----------------------------------------------------------------
C
        IRTETI = 0
        GOTO 9999
 1      CONTINUE
        IRTETI = 1
        CALL BETIMP ( NMAT, MATERF, SIGF, VIND, VINF,
     &                ELGEOM, NSEUI1, NSEUI2, NSEUI3, NSEUI4,
     &                SIGE, SIGD)
C
        CALL TECAEL ( IADZI, IAZK24 )
        NOMAIL = ZK24(IAZK24-1+3)(1:8)
        CALL U2MESK('A','ALGORITH9_95',1, NOMAIL)
C
        GOTO 9999
C        
 9999   CONTINUE
       
        END
