        SUBROUTINE REDECE ( FAMI,KPG,KSP,NDIM,TYPMOD,IMAT,COMP,CRIT,
     1                      TIMED,TIMEF, TEMPD,TEMPF,TREF,
     &                      SECHD,SECHF,SREF,EPSDT,DEPST,SIGD,
     2                      VIND, OPT,ELGEOM,ANGMAS,SIGF,VINF,DSDE,
     &                      RETCOM)
        IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/04/2006   AUTEUR CIBHHPD L.SALMONA 
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
C TOLE CRP_21
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
C       - SI CRIT(5) = -N  EN CAS DE NON-CONVERGENCE LOCALE ON EFFECTUE
C                          UN REDECOUPAGE DU PAS DE TEMPS EN N PALIERS
C                          L ORDRE D EXECUTION ETANT REMONTE EN ARGUMENT
C                          DANS REDECE, APPELE PAR NMCOMP AVANT PLASTI
C       - SI CRIT(5) = -1,0,1  PAS DE REDECOUPAGE DU PAS DE TEMPS
C       - SI CRIT(5) = +N  ON EFFECTUE UN REDECOUPAGE DU PAS DE TEMPS
C                          EN N PALIERS A CHAQUE APPEL DE REDECE
C                          LE PREMIER APPEL DE PLASTI SERT A
C                          L'INITIALISATION DE NVI
C       SI APRES REDECOUPAGE ON ABOUTIT A UN CAS DE NON CONVERGENCE, ON
C       REDECOUPE A NOUVEAU LE PAS DE TEMPS, EN 2*N PALIERS
C       ================================================================
C
C       PLASTI  ALGORITHME D INTEGRATION ELASTO PLASTIQUE
C       LCXXXX  ROUTINES UTILITAIRES (VOIR LE DETAIL DANS PLASTI)
C       ================================================================
C       ARGUMENTS
C
C       IN      FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C       IN      KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
C       IN      NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
C               TYPMOD  TYPE DE MODELISATION
C               IMAT    ADRESSE DU MATERIAU CODE
C               COMP    COMPORTEMENT DE L ELEMENT
C                       COMP(1) = RELATION DE COMPORTEMENT (CHABOCHE...)
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
C                                 (ITER_INTE_PAS == ITEDEC)
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C               ELGEOM  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
C                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
C                       FIXEE EN DUR)
C               TIMED   INSTANT T
C               TIMEF   INSTANT T+DT
C               TEMPD   TEMPERATURE A T
C               TEMPF   TEMPERATURE A T+DT
C               TREF    TEMPERATURE DE REFERENCE
C               SECHD   SECHAGE A L'INSTANT PRECEDENT
C               SECHF   SECHAGE A L'INSTANT DU CALCUL
C               SREF    SECHAGE DE REFERENCE
C               EPSDT   DEFORMATION TOTALE A T
C               DEPST   INCREMENT DE DEFORMATION TOTALE
C               SIGD    CONTRAINTE A T
C               VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C    ATTENTION  VIND    VARIABLES INTERNES A T MODIFIEES SI REDECOUPAGE
C       OUT     SIGF    CONTRAINTE A T+DT
C               VINF    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
C               DSDE    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C       ----------------------------------------------------------------
        INTEGER         IMAT,NDIM,NDT,NDI,NVI,KPG,KSP
C
        REAL*8          CRIT(*), ANGMAS(3)
        REAL*8          TIMED,     TIMEF,    TEMPD,   TEMPF  , TREF
        REAL*8          SECHD , SECHF , SREF, ELGEOM(*)
        REAL*8          EPSDT(6),  DEPST(6)
        REAL*8          SIGD(6),   SIGF(6)
        REAL*8          VIND(*),   VINF(*)
        REAL*8          DSDE(6,6)
C
        CHARACTER*16    COMP(*),     OPT
        CHARACTER*8     TYPMOD(*)
        CHARACTER*(*)   FAMI
C
C       ----------------------------------------------------------------
C       VARIABLES LOCALES POUR LE REDECOUPAGE DU PAS DE TEMPS
C               TD      INSTANT T
C               TF      INSTANT T+DT
C               TEMD    TEMPERATURE A T
C               TEMF    TEMPERATURE A T+DT
C               SECD   SECHAGE A T
C               SECF   SECHAGE A T+DT
C               EPS     DEFORMATION TOTALE A T
C               DEPS    INCREMENT DE DEFORMATION TOTALE
C               SD      CONTRAINTE A T
C               VD      VARIABLES INTERNES A T    + INDICATEUR ETAT T
C               DSDELO MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C               NPAL            NOMBRE DE PALIER POUR LE REDECOUPAGE
C               ICOMP           COMPTEUR POUR LE REDECOUPAGE DU PAS DE
C                                    TEMPS
C               RETURN1 EN CAS DE NON CONVERGENCE LOCALE
C       ----------------------------------------------------------------
C
        INTEGER         ICOMP,        NPAL,      IPAL
        INTEGER         IRTET,     K
        INTEGER         RETCOM
        REAL*8          EPS(6),       DEPS(6),   SD(6)
        REAL*8          DSDELO(6,6)
        REAL*8          DELTAT,TD,TF
        REAL*8          TEMD,         TEMF,      DETEMP
        REAL*8          SECD,         SECF,      DESECH
C       ----------------------------------------------------------------
C       COMMONS POUR VARIABLES DE COMMANDE : CAII17 ET CARR01
        INTEGER NFPGMX
        PARAMETER (NFPGMX=10)
        INTEGER NFPG,JFPGL,DECALA(NFPGMX),KM,KP,KR,IREDEC
        COMMON /CAII17/NFPG,JFPGL,DECALA,KM,KP,KR,IREDEC
        REAL*8 TIMED1,TIMEF1,TD1,TF1
        COMMON /CARR01/TIMED1,TIMEF1,TD1,TF1
C       ----------------------------------------------------------------
C       ----------------------------------------------------------------
        COMMON /TDIM/   NDT  , NDI
C       ----------------------------------------------------------------
C       ----------------------------------------------------------------
C       -- POUR LES VARIABLES DE COMMANDE :
        IREDEC=1
        TIMED1=TIMED
        TIMEF1=TIMEF
        TD1=TIMED
        TF1=TIMEF


        IPAL  =  INT(CRIT(5))
        RETCOM=0
        READ (COMP(2),'(I16)') NVI
C
C IPAL = 0  1 OU -1 -> PAS DE REDECOUPAGE DU PAS DE TEMPS
C
        IF ( IPAL .EQ. 0 .OR. IPAL .EQ. 1 .OR. IPAL .EQ. -1 ) THEN
           IPAL  = 0
           NPAL  = 0
           ICOMP = 2
C
C IPAL < -1 -> REDECOUPAGE DU PAS DE TEMPS EN CAS DE NON CONVERGENCE
C
        ELSEIF ( IPAL .LT. -1 ) THEN
           NPAL  = -IPAL
           ICOMP = 0
C
C IPAL > 1 -> REDECOUPAGE IMPOSE DU PAS DE TEMPS
C
        ELSEIF ( IPAL .GT.  1 ) THEN
           NPAL  = IPAL
           ICOMP = -1
        ENDIF
C
        IF ( COMP(1)(1:15) .EQ. 'BETON_DOUBLE_DP') THEN
        CALL PLASBE ( FAMI, KPG ,KSP, TYPMOD, IMAT, COMP, CRIT,
     1                TEMPD, TEMPF, TREF, SECHD, SECHF, SREF,
     3                EPSDT, DEPST, SIGD,  VIND,  OPT, ELGEOM,
     4                SIGF,  VINF,  DSDE,  ICOMP, NVI,  IRTET)
        ELSE
        CALL PLASTI ( FAMI,KPG,KSP, TYPMOD, IMAT,  COMP,  CRIT,
     1                TIMED, TIMEF, TEMPD, TEMPF, TREF, SECHD, 
     2                SECHF, SREF, EPSDT, DEPST, SIGD,  VIND,  
     3                OPT, ANGMAS, SIGF,  VINF,  DSDE,  ICOMP,
     4                NVI,  IRTET)
        ENDIF
        IF ( IRTET.GT.0 ) GOTO (1,2), IRTET
C
C -->   IPAL > 0 --> REDECOUPAGE IMPOSE DU PAS DE TEMPS
C -->   REDECOUPAGE IMPOSE ==>  RETURN DANS PLASTI APRES RECHERCHE
C       DES CARACTERISTIQUES DU MATERIAU A (T) ET (T+DT)
        IF ( IPAL  .LE.   0 ) GOTO 9999
        IF ( ICOMP .EQ.  -1 ) ICOMP = 0
C
        IF ( OPT .EQ. 'RIGI_MECA_TANG' ) GOTO 9999
C
C
C --    CAS DE NON CONVERGENCE LOCALE / REDECOUPAGE DU PAS DE TEMPS
C
 1      CONTINUE
C
        IF ( NPAL .EQ. 0 ) THEN
            CALL UTMESS('A','REDECE','REDECOUPAGE DEMANDE'
     1       //' APRES NON CONVERGENCE LOCALE. REDECOUPAGE GLOBAL')
           GOTO 2
        ENDIF
C
        IF ( ICOMP .GT. 3 ) THEN
            CALL UTMESS('A','REDECE','REDECOUPAGE EXCESSIF DU PAS DE'
     1       //' TEMPS INTERNE : REDUISEZ VOTRE PAS DE TEMPS OU'
     3       //' AUGMENTER ABS(ITER_INTE_PAS). REDECOUPAGE GLOBAL.')
           GOTO 2
        ENDIF
C
        IF ( ICOMP .GE. 1 ) NPAL = 2 * NPAL
        ICOMP = ICOMP + 1
C
        DO 124 K=1,NPAL
C --       INITIALISATION DES VARIABLES POUR LE REDECOUPAGE DU PAS
           IF ( K .EQ. 1 ) THEN
                TD = TIMED
                TD1 = TD
                DELTAT = (TIMEF - TIMED) / NPAL
                TF = TD + DELTAT
                TF1=TF
                TEMD = TEMPD
                DETEMP = (TEMPF - TEMPD) / NPAL
                TEMF = TEMD + DETEMP
                DESECH = (SECHF - SECHD)  / NPAL
                SECD = SECHD
                SECF = SECD + DESECH
                IF ( OPT .EQ. 'RIGI_MECA_TANG'
     1                  .OR. OPT .EQ. 'FULL_MECA' )
     1                  CALL LCINMA ( 0.D0 , DSDE )
                CALL LCEQVE ( EPSDT     , EPS            )
                CALL LCEQVE ( DEPST     , DEPS           )
                CALL LCPRSV ( 1.D0/NPAL , DEPS    , DEPS )
                CALL LCEQVN ( NDT       , SIGD    , SD   )
C
C --        REACTUALISATION DES VARIABLES POUR L INCREMENT SUIVANT
            ELSE IF ( K .GT. 1 ) THEN
                TD = TF
                TD1=TD
                TF = TF + DELTAT
                TF1=TF
                TEMD = TEMF
                TEMF = TEMF + DETEMP
                SECD = SECF
                SECF = SECF + DESECH
                CALL LCSOVE ( EPS     , DEPS    , EPS  )
                IF ( OPT .NE. 'RIGI_MECA_TANG' ) THEN
                    CALL LCEQVN ( NDT     , SIGF    , SD   )
                    CALL LCEQVN ( NVI     , VINF    , VIND   )
                ENDIF
            ENDIF
C
C
            IF ( COMP(1)(1:15) .EQ. 'BETON_DOUBLE_DP') THEN
              CALL PLASBE ( FAMI, KPG, KSP, TYPMOD, IMAT, COMP,
     1                    CRIT, TEMD,   TEMF,   TREF,
     2                    SECD, SECF, SREF, EPS,   DEPS,
     3                    SD,  VIND,   OPT, ELGEOM, SIGF, VINF,
     4                    DSDELO,  ICOMP,   NVI,  IRTET)
            ELSE
              CALL PLASTI ( FAMI,KPG,KSP,TYPMOD,IMAT,COMP,CRIT,TD,
     1                    TF,    TEMD,   TEMF,   TREF,
     2                    SECD, SECF, SREF,  EPS,   DEPS,
     2                    SD, VIND, OPT, ANGMAS, SIGF, VINF,
     3                    DSDELO,  ICOMP,   NVI,  IRTET)
            ENDIF

            IF ( IRTET.GT.0 ) GOTO (1,2), IRTET
C
            IF ( OPT .EQ. 'RIGI_MECA_TANG'
     1               .OR. OPT .EQ. 'FULL_MECA' ) THEN
                CALL LCPRSM ( 1.D0/NPAL , DSDELO , DSDELO   )
                CALL LCSOMA ( DSDE    , DSDELO , DSDE      )
            ENDIF
C
 124    CONTINUE
        GOTO 9999
C
   2    CONTINUE
        RETCOM = 1
        GO TO 9999
C
 9999   CONTINUE
        END
