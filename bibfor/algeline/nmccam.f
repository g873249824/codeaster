      SUBROUTINE NMCCAM (NDIM,TYPMOD,IMATE,COMPOR,CRIT,
     &                   INSTAM,INSTAP,TM,TP,TREF,DEPS,SIGM,PCRM,
     &                   OPTION,SIGP,PCRP,DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 25/10/2002   AUTEUR JOUMANA J.EL-GHARIB 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C  TOLE CRP_20
      IMPLICIT NONE
      INTEGER            NDIM,IMATE
      CHARACTER*8        TYPMOD(*)
      CHARACTER*16       COMPOR(1),OPTION
      REAL*8             CRIT(3),INSTAM,INSTAP,TM,TP,TP2,LINE,TREF
      REAL*8             DEPS(6),PREC,DX,DEUXMU
      REAL*8             SIGM(6),PCRM(2),SIGP(6),PCRP(2),DSIDEP(6,6)
C ----------------------------------------------------------------------
C     REALISE LA LOI DE CAM CLAY ELASTOPLASTIQUE POUR LES
C     ELEMENTS ISOPARAMETRIQUES EN PETITES DEFORMATIONS
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT : RELCOM ET DEFORM
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT DU CALCUL PRECEDENT
C IN  INSTAP  : INSTANT DU CALCUL
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  SIGM    : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT
C IN  PCRM    : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C OUT SIGP    : CONTRAINTES A L'INSTANT ACTUEL
C OUT PCRP    : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIDEP  : MATRICE CARREE (INUTILISE POUR RAPH_MECA)
C
C               ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C               L'ORDRE :  XX,YY,ZZ,SQRT(2)*XY,SQRT(2)*XZ,SQRT(2)*YZ
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
      LOGICAL     CPLAN,PLASTI,IRET,LOGIC
      REAL*8      DEPSTH(6),VALRES(10),ALPHA
      REAL*8      LAMBDA,KAPA,PORO,PRESCR,M,PA
      REAL*8      DEPSMO,SIGMMO,E,NU,E0,XK0,XK,FONC
      REAL*8      SIELEQ,SIMOEL,H,A(6),AA(6),SIEQM, TOTO, TOTO1
      REAL*8      KRON(6),DEPSDV(6),SIGMDV(6),SIGPDV(6),TPLUS(6)
      REAL*8      SIGPMO,F1,F2,F3,F4,F5,F6,F,FP,COEF,DIFF,PORO1,PORO2
      REAL*8      DEPPMO,DELTAP,DELTAS(6),SPARDS,HP,XC,XD
      REAL*8      XLAM,XA,XU,XG,XH,XE,XF,XV,XI,RAP,CC(6,6),FV(6),FF(6)
      REAL*8      C(6,6),BB(6,6),CT,XB,V0,V0EST,SEUIL,D(3,3),DD(3,3)
      REAL*8      SIGEL(6),XINF,XSUP,DET,TOL,FFI(6,6),EE(6,6)
      REAL*8      NUL,RAC2,DEUX
      INTEGER     NDIMSI
      INTEGER     K,L,ITER, MATR
      CHARACTER*2 BL2, FB2, CODRET(9)
      CHARACTER*8 NOMRES(9)
      CHARACTER*8 NOMPAR(9),TYPE
      REAL*8      VALPAM(3)
      DATA        KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA        TOL/1.D-10/NUL/0.D0/DEUX/2.D0/
C DEB ------------------------------------------------------------------
C
C     -- 1 INITIALISATIONS :
C     ----------------------
      CPLAN =  TYPMOD(1) .EQ. 'C_PLAN'
      NDIMSI = 2*NDIM
      RAC2 = SQRT(DEUX)
      LOGIC = .TRUE.
C
      BL2 = '  '
      FB2 = 'F '
C
      IF ((.NOT.( COMPOR(1)(1:9) .EQ. 'CAM_CLAY ')).AND.
     &   (.NOT.( COMPOR(1)(1:6) .EQ. 'KIT_HM')).AND.
     &   (.NOT.( COMPOR(1)(1:7) .EQ. 'KIT_HHM')).AND.
     &   (.NOT.( COMPOR(1)(1:7) .EQ. 'KIT_THM')).AND.
     &   (.NOT.( COMPOR(1)(1:8) .EQ. 'KIT_THHM'))) THEN
            CALL UTMESS('F','NMCCAM_01',
     &           ' COMPORTEMENT INATTENDU : '//COMPOR(1))
      ENDIF
C
C     -- 2 RECUPERATION DES CARACTERISTIQUES
C     ---------------------------------------
      NOMRES(1)='E'
      NOMRES(2)='NU'
      NOMRES(3)='ALPHA'
      NOMRES(4)='PORO'
      NOMRES(5)='LAMBDA'
      NOMRES(6)='KAPA'
      NOMRES(7)='M'
      NOMRES(8)='PRES_CRIT'
      NOMRES(9)='PA'
C
      NOMPAR(1) = 'TEMP'
      VALPAM(1) = TM
C
      IF (COMPOR(1)(1:9) .EQ. 'CAM_CLAY ' ) THEN
         CALL RCVALA ( IMATE,'ELAS',1,NOMPAR,VALPAM,1,
     +                 NOMRES(1),VALRES(1),CODRET(1), FB2 )
         E  = VALRES(1)
         CALL RCVALA ( IMATE,'ELAS',2,NOMPAR,VALPAM,1,
     +                 NOMRES(2),VALRES(2),CODRET(2), FB2 )
         NU = VALRES(2)
         CALL RCVALA ( IMATE,'ELAS',3,NOMPAR,VALPAM,1,
     +                 NOMRES(3),VALRES(3),CODRET(3), BL2 )
         IF ( CODRET(3) .NE. 'OK' ) VALRES(3) = 0.D0
         ALPHA = VALRES(3)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(4),VALRES(4),CODRET(4), FB2 )
         PORO = VALRES(4)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(5),VALRES(5),CODRET(5), FB2 )
         LAMBDA = VALRES(5)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(6),VALRES(6),CODRET(6), FB2 )
         KAPA = VALRES(6)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(7),VALRES(7),CODRET(7), FB2 )
         M     = VALRES(7)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(8),VALRES(8),CODRET(8), FB2 )
         PRESCR = VALRES(8)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(9),VALRES(9),CODRET(9), FB2 )
         PA = VALRES(9)
      ENDIF
      IF (((COMPOR(1)(1:6) .EQ. 'KIT_HM') .OR. 
     &     (COMPOR(1)(1:7) .EQ. 'KIT_HHM') .OR.
     &     (COMPOR(1)(1:7) .EQ. 'KIT_THM') .OR.
     &     (COMPOR(1)(1:8) .EQ. 'KIT_THHM')).AND.
     &     (COMPOR(8)(1:9) .EQ. 'CAM_CLAY ')) THEN
         CALL RCVALA ( IMATE,'ELAS',4,NOMPAR,VALPAM,1,
     +                 NOMRES(1),VALRES(1),CODRET(1), FB2 )
         E  = VALRES(1)
         CALL RCVALA ( IMATE,'ELAS',4,NOMPAR,VALPAM,1,
     +                 NOMRES(2),VALRES(2),CODRET(2), FB2 )
         NU = VALRES(2)
         CALL RCVALA ( IMATE,'ELAS',4,NOMPAR,VALPAM,1,
     +                 NOMRES(3),VALRES(3),CODRET(3), BL2 )
         IF ( CODRET(3) .NE. 'OK' ) VALRES(3) = 0.D0
         ALPHA = VALRES(3)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(4),VALRES(4),CODRET(4), FB2 )
         PORO = VALRES(4)
         PORO1 = PORO
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(5),VALRES(5),CODRET(5), FB2 )
         LAMBDA = VALRES(5)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(6),VALRES(6),CODRET(6), FB2 )
         KAPA = VALRES(6)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(7),VALRES(7),CODRET(7), FB2 )
         M     = VALRES(7)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(8),VALRES(8),CODRET(8), FB2 )
         PRESCR = VALRES(8)
         CALL RCVALA ( IMATE,'CAM_CLAY ',6,NOMPAR,VALPAM,1,
     +                 NOMRES(9),VALRES(9),CODRET(9), FB2 )
         PA = VALRES(9)
         CALL RCVALA ( IMATE,'THM_INIT',5,NOMPAR,VALPAM,1,
     +                 NOMRES(4),VALRES(4),CODRET(4), FB2 )
         PORO = VALRES(4)
         PORO2 = PORO
         DIFF = PORO1-PORO2
         IF (ABS(DIFF) .GT. TOL) THEN
           CALL UTMESS('F','NMCCAM','CAM_CLAY : LA POROSITE '
     &   //'DONNEE DANS CAM_CLAY DOIT ETRE LA MEME QUE DANS THM_INIT')
         ELSE
         PORO=PORO1
         ENDIF
      ENDIF
         DEUXMU = E/(1.D0+NU)
         E0=PORO/(1.D0-PORO)
         XK0 = (1.D0+E0)/KAPA
         XK= (1.D0+E0)/(LAMBDA-KAPA)
C
C     -- 3 CALCUL DE DEPSMO ET DEPSDV :
C     --------------------------------
      COEF = ALPHA*(TP-TREF) - ALPHA*(TM-TREF)
      IF (CPLAN)THEN 
           CALL UTMESS('F','NMCCAM','CAM_CLAY : LE CAS DES '
     &     //'CONTRAINTES PLANES N EST PAS TRAITE POUR CE MODELE.')
      ENDIF 
      DEPSMO = 0.D0 
      DO 110 K=1,NDIMSI
        DEPSTH(K) = DEPS(K)
 110  CONTINUE
      DO 111 K=1,3
        DEPSTH(K) = DEPSTH(K) + COEF
        DEPSMO = DEPSMO + DEPSTH(K)      
 111  CONTINUE 
      DEPSMO = -DEPSMO
      DO 115 K=1,NDIMSI
        DEPSDV(K)   = DEPSTH(K) + DEPSMO/3.D0 * KRON(K)
 115  CONTINUE
C
C     -- 4 CALCUL DE SIGMMO, SIGMDV, SIGEL,SIMOEL,SIELEQ, SIEQM :
C     -------------------------------------------------------------
      SIGMMO = 0.D0
      DO 116 K =1,3
        SIGMMO = SIGMMO + SIGM(K)
 116  CONTINUE
      SIGMMO = -SIGMMO /3.D0
      IF (SIGMMO.LT.(0.99D0*PA)) THEN 
           CALL UTMESS('F','NMCCAM','CAM_CLAY : IL FAUT QUE '
     &     //'LA CONTRAINTE HYDROSTATIQUE SOIT SUPERIEURE A LA ' 
     &     //' PRESSION INITIALE PA ')
      ENDIF        
      SIELEQ = 0.D0
      SIEQM = 0.D0
      DO 117 K = 1,NDIMSI
        SIGMDV(K) = SIGM(K) + SIGMMO * KRON(K)
        SIEQM = SIEQM + SIGMDV(K)**2
        SIGEL(K)  = SIGMDV(K) + DEUXMU * DEPSDV(K)
        SIELEQ     = SIELEQ + SIGEL(K)**2
 117  CONTINUE
      SIELEQ     = SQRT(1.5D0*SIELEQ)
      SIEQM    = SQRT(1.5D0*SIEQM)
      SIMOEL    = SIGMMO*EXP(XK0*DEPSMO)
      IF (PCRM(1).EQ.0.D0)  PCRM(1) = PRESCR
C
C     -- 5 CALCUL DU CRITERE :
C     ----------------------
      FONC = SIELEQ**2+M*M*SIMOEL*SIMOEL-2.D0*M*M*SIMOEL*PCRM(1)
C     -- 6  TEST DE PLASTIFICATION ET CALCUL DE PCRP SIGP, SIGPDV :
C     ------------------------------------------------------------
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA'     ) THEN
        IF (FONC.LE.0.D0) THEN
           PCRP(1) = PCRM(1)
           PCRP(2) = 0.D0
            DO 118 K=1,NDIMSI
              SIGPDV(K) = SIGEL(K)
              SIGP(K)   = SIGEL(K)-SIMOEL*KRON(K)
 118  CONTINUE
        ELSE
C     -- PLASTIFICATION : CALCUL DE LA DEFORMATION 
C     -- VOLUMIQUE PLASTIQUE : DEPPMO 
         PCRP(2) = 1.D0
C     -- TRAITEMENT DU CAS GENERAL
           IF (SIGMMO.NE.PCRM(1)) THEN
C     -- CALCUL DE LA BORNE
       XB = 1.D0/(XK+XK0)*LOG(SIMOEL/PCRM(1))
       XINF = 0.D0
       XSUP = XB
C     --RESOLUTION AVEC LA METHODE DE NEWTON ENTRE LES BORNES
       V0 = XINF
       SEUIL = M**2*PCRM(1)**2
       F1 = SIMOEL*EXP(-XK0*V0)
       F2 = SIMOEL*EXP(-XK0*V0)-2.D0*PCRM(1)*EXP(XK*V0)
       F3 = SIMOEL*EXP(-XK0*V0)-PCRM(1)*EXP(XK*V0)
       F = SIELEQ**2+M**2*(1.D0+3.D0*DEUXMU*V0/2.D0/M/M/F3)**2*F1*F2
       F4 = (1.D0+3.D0*DEUXMU*V0/2.D0/M/M/F3)
       F5 = -2.D0*XK0*SIMOEL**2*EXP(-2.D0*XK0*V0)+
     &         2.D0*SIMOEL*PCRM(1)*EXP((XK-XK0)*V0)*(XK0-XK)
       F6 = SIMOEL*(1.D0+V0*XK0)*EXP(-XK0*V0)+
     &        PCRM(1)*(-1.D0+V0*XK)*EXP(XK*V0) 
       FP = M**2*F4**2*F5+3.D0*DEUXMU*F4*F1*F2*(F6/F3/F3)
C          
       DO 200 ITER = 1, NINT(CRIT(1))
       
C     --CRITERE DE CONVERGENCE
       IF ((ABS(F)/SEUIL) . LE. CRIT(3))   GOTO 100         

C     --CONSTRUCTION DU NOUVEL ITERE    
       V0 = V0-F/FP

       IF (V0.LE.XINF .OR. V0.GE.XSUP)  V0 = (XINF+XSUP)/2
       
C     --CALCUL DE LA FONCTION ET DE SA DERIVEE
       F1 = SIMOEL*EXP(-XK0*V0)
       F2 = SIMOEL*EXP(-XK0*V0)-2.D0*PCRM(1)*EXP(XK*V0)
       F3 = SIMOEL*EXP(-XK0*V0)-PCRM(1)*EXP(XK*V0)
       F=SIELEQ**2+M**2*(1.D0+3.D0*DEUXMU*V0/2.D0/M/M/F3)**2*F1*F2
       F4 = (1.D0+3.D0*DEUXMU*V0/2.D0/M/M/F3)
       F5 = -2.D0*XK0*SIMOEL**2*EXP(-2.D0*XK0*V0)+
     &         2.D0*SIMOEL*PCRM(1)*EXP((XK-XK0)*V0)*(XK0-XK)
       F6 = SIMOEL*(1.D0+V0*XK0)*EXP(-XK0*V0)+
     &        PCRM(1)*(-1.D0+V0*XK)*EXP(XK*V0) 
       FP = M**2*F4**2*F5+3.D0*DEUXMU*F4*F1*F2*(F6/F3/F3)   
         
         IF (F .GE. 0.D0) XINF = V0
         IF (F .LE. 0.D0) XSUP = V0
 
 200  CONTINUE
      CALL UTMESS('F','CAM_CLAY ','ITER_INTE_MAXI INSUFFISANT')
 100  CONTINUE       
      DEPPMO=V0
C
C     -- REACTUALISATION DE LA VARIABLE INTERNE
        PCRP(1) = PCRM(1)*EXP(XK*DEPPMO)
C
C     -- REACTUALISATION DES CONTRAINTES
        SIGPMO = SIGMMO*EXP(XK0*(DEPSMO-DEPPMO))
       CALL R8INIR(6,0.D0,SIGPDV,1)        
         DO 119 K=1,NDIMSI
           SIGPDV(K) = SIGEL(K)/(1.D0+(3.D0*DEUXMU/2.D0*DEPPMO)/
     &                (M*M*(SIGPMO-PCRP(1))))
           SIGP(K) = SIGPDV(K)-SIGPMO*KRON(K)
 119  CONTINUE 
C 
           ELSE
C     -- TRAITEMENT DU POINT CRITIQUE 
           DEPPMO=0.D0
           PCRP(1)=PCRM(1)
           SIGPMO = SIGMMO*(1.D0+XK0*DEPSMO)
         DO 122 K=1,NDIMSI
           SIGPDV(K) = SIGEL(K)*SIEQM/SIELEQ*
     &                SQRT(1.D0-XK0**2*DEPSMO**2) 
           SIGP(K) = SIGPDV(K)-SIGPMO*KRON(K)
 122  CONTINUE
           ENDIF
      ENDIF        
      ENDIF
C
C     -- 7 CALCUL DE L'OPERATEUR TANGENT :
C     --------------------------------
      IF ( OPTION(1:14) .EQ. 'RIGI_MECA_TANG'.OR.
     &     OPTION(1:9)  .EQ. 'FULL_MECA'         ) THEN     
C
       IF ( OPTION(1:14) .EQ. 'RIGI_MECA_TANG' ) THEN
           IF (PCRM(2) .EQ. 0.D0) THEN
            MATR = 0
           ELSE
            MATR = 1
           END IF
       END IF
       IF ( OPTION(1:9) .EQ. 'FULL_MECA' ) THEN
           IF (PCRP(2) .EQ. 1.D0) THEN
            MATR = 2
           ELSE
            MATR = 0
           END IF
       END IF
            
C      INITIALISATION DE L'OPERATEUR TANGENT
C     ---------------------------------------
         DO 125 K=1,6
         DO 126 L=1,6
            DSIDEP(K,L) = 0.D0
 126  CONTINUE
 125  CONTINUE
C 
C     -- 7.1 CALCUL DE DSIDEP(6,6)-ELASTIQUE: 
C     ---------------------------------------
        IF (MATR .EQ. 0) THEN
          DO 127 K=1,3
            DO 128 L=1,3
              DSIDEP(K,L) = XK0*SIMOEL-DEUXMU/3.D0
 128  CONTINUE
 127  CONTINUE
            DO 129 K=1,NDIMSI
               DSIDEP(K,K) = DSIDEP(K,K)+DEUXMU
 129  CONTINUE
        END IF
C 
C     -- 7.2 CALCUL DE DSIDEP(6,6)-EN VITESSE : 
C     ---------------------------------------
      IF ( MATR .EQ. 1 ) THEN
C 
C     -- 7.2.1 CALCUL DU MODULE ELASTOPLASTIQUE H
        H = 4.D0*M**4*SIGMMO*(SIGMMO-PCRM(1))*
     &  (XK0*(SIGMMO-PCRM(1))+XK*PCRM(1))+6.D0*DEUXMU*SIEQM**2

C     -- 7.2.2 CALCUL D'UN TERME INTERMEDIAIRE      
          DO 160 K=1,NDIMSI
             A(K) = 0.D0
 160  CONTINUE
          DO 130 K=1,3
             A(K) = -DEUX*XK0*M*M*SIGMMO*(SIGMMO-PCRM(1))*KRON(K)+
     &                3.D0*DEUXMU*SIGMDV(K)
 130  CONTINUE
       CALL R8INIR(3,0.D0,AA,1)
          DO 131 K=4,NDIMSI
             AA(K) = 3.D0*DEUXMU*SIGMDV(K)
 131  CONTINUE
C
C     -- 7.2.3 CALCUL DES TERMES DE DSIDEP 
       CALL R8INIR(NDIMSI*NDIMSI,0.D0,DSIDEP,1)
          DO 132 K=1,3
           DO 133 L=1,3
             DSIDEP(K,L)=XK0*SIGMMO-DEUXMU/3.D0-A(K)*A(L)/H
 133  CONTINUE
 132  CONTINUE
          DO 134 K=1,3
          DO 135 L=4,NDIMSI
             DSIDEP(K,L) = -A(K)*AA(L)
             DSIDEP(K,L) = DSIDEP(K,L)/H
             DSIDEP(L,K) = DSIDEP(K,L)
 135  CONTINUE
 134  CONTINUE
          DO 136 K=4,NDIMSI
          DO 137 L=4,NDIMSI
             DSIDEP(K,L) = -AA(K)*AA(L)
             DSIDEP(K,L) = DSIDEP(K,L)/H
 137  CONTINUE
 136  CONTINUE  
           DO 138 K=1,NDIMSI     
           DSIDEP(K,K) = DEUXMU + DSIDEP(K,K)
 138  CONTINUE
      
        ENDIF
C        
C     -- 7.3 CALCUL DE DSIDEP(6,6)-MATRICE COHERENTE : 
C     ----------------------------------------------
        IF ( MATR .EQ. 2 ) THEN
C        
C      -- 7.3.1 CALCUL DES INCREMENTS DE P ET DE S
        DELTAP = SIGPMO - SIGMMO
       CALL R8INIR(6,0.D0,DELTAS,1)
           DO 140 K=1,NDIMSI
              DELTAS(K)=SIGPDV(K)-SIGMDV(K)
 140  CONTINUE
C           
C     -- 7.3.2 CALCUL DES TERMES INTERMEDIAIRES 
        SPARDS = 0.D0
           DO 141 K = 1,NDIMSI
               SPARDS = SPARDS+DELTAS(K)*SIGPDV(K)
 141  CONTINUE
       CALL R8INIR(6,0.D0,TPLUS,1)
           DO 142 K = 1, NDIMSI
               TPLUS(K) = SIGPDV(K) + DELTAS(K)
 142  CONTINUE              
C
C      -- MODULE PLASTIQUE               
        HP = 4.D0*M**4*XK*SIGPMO*PCRP(1)*(SIGPMO-PCRP(1))
C
        XC = 9.D0*SPARDS/HP
        XD = 6.D0*M*M*(SIGPMO-PCRP(1))*DELTAP/HP
        XV = 3.D0*SPARDS + 2.D0*M**2*(SIGPMO-PCRP(1))*DELTAP
        XLAM = XV/HP
        XA = (4.D0*XLAM*XK*M**4*SIGPMO*(SIGPMO-2.D0*PCRP(1))+
     &       2.D0*M**2*DELTAP)*M**2*(SIGPMO-PCRP(1))/(M**2*XLAM+
     &       (1.D0/2.D0/XK/PCRP(1)))
        XI = 2.D0*M**2*(SIGPMO-PCRP(1))-2.D0*M**4*XLAM*
     &      (SIGPMO-PCRP(1))/((1.D0/2.D0/XK/PCRP(1))+M**2*XLAM)
        RAP = XI/(HP+XA)
C
C     -- CALCUL DES TERMES D'UNE MATRICE INTERMEDIAIRE CC
C
       CALL R8INIR(6*6,0.D0,CC,1)
          DO 172 K=1,3
          DO 173 L=1,3
              CC(K,L)=(TPLUS(K)+TPLUS(L))/2.D0
 173  CONTINUE
 172  CONTINUE
          DO 174 K=1,3
          DO 175 L=4,NDIMSI
              CC(K,L)=TPLUS(L)/2.D0
              CC(L,K)=CC(K,L)
 175  CONTINUE
 174  CONTINUE
                  
C     -- CALCUL DES TERMES D'UNE MATRICE INTERMEDIAIRE C
C
       CALL R8INIR(6*6,0.D0,C,1)
          DO 170 K=1,NDIMSI
          DO 171 L=1,NDIMSI
             C(K,L) = 9.D0/2.D0/(HP+XA)*(SIGPDV(K)*TPLUS(L)+
     &                                         TPLUS(K)*SIGPDV(L))
 171  CONTINUE
 170  CONTINUE
           DO 149 K=1,NDIMSI
               C(K,K) = C(K,K)+1.D0/DEUXMU+XC+XD
 149  CONTINUE
C 
C     -- PARTIE DEVIATORIQUE
       CALL R8INIR(6*6,0.D0,EE,1)
         IF (NDIM.EQ.3) THEN
           DO 180 K=1,NDIMSI
           DO 181 L=1,NDIMSI
               EE(K,L) = C(K,L) - RAP*CC(K,L)
  181   CONTINUE
  180   CONTINUE
            ELSE
         IF (NDIM.EQ.2) THEN
           DO 280 K=1,NDIMSI
           DO 281 L=1,NDIMSI
               EE(K,L) = C(K,L) - RAP*CC(K,L)
  281   CONTINUE
  280   CONTINUE
           EE(5,5) = 1.D0
           EE(6,6) = 1.D0
           ENDIF
           ENDIF             
C     -- INVERSE DE LA MATRICE EE
       CALL R8INIR(6*6,0.D0,BB,1)
           DO 150 K=1,6
               BB(K,K)=1.D0
 150  CONTINUE  
        CALL MGAUSS(EE,BB,6,6,6,NUL,LOGIC)
C            
        XU = 2.D0*M**2*XK*PCRP(1)
        XG = XLAM*XU/(1.D0+XLAM*XU)
        XH = XU*(SIGPMO-PCRP(1))/(1.D0+XLAM*XU)
        XE = 1.D0+XH*2.D0*M**2*DELTAP/HP+XH*4.D0*XK*M**4*
     &      SIGPMO*(SIGPMO-2.D0*PCRP(1))*XV/HP/HP
        XF = (2.D0*M**2*(SIGPMO-PCRP(1))+2.D0*M**2*DELTAP-
     &      XG*2.D0*M**2*DELTAP)/HP-4.D0*XK*M**4*XV/HP/HP*
     &     ((2.D0*SIGPMO-PCRP(1))*PCRP(1)+XG*SIGPMO*
     &       (SIGPMO-2.D0*PCRP(1))) 
        CT = (1.D0+2.D0*M**2*XK0*SIGPMO*(XLAM-XG*XLAM-
     &       XLAM*XF*XH/XE+XF/XE*(SIGPMO-PCRP(1))))/(XK0*SIGPMO)

C     --  PARTIE HYDROSTATQUE 
       CALL R8INIR(6,0.D0,FV,1)
       DO 190 K=1,NDIMSI
           FV(K)=3.D0*XF/XE*SIGPDV(K)-CT*KRON(K)/3.D0
 190  CONTINUE
 
       CALL R8INIR(3*3,0.D0,D,1)
       D(1,1) = FV(1)
       D(1,2) = FV(4)/RAC2
       D(1,3) = FV(6)/RAC2
       D(2,1)=D(1,2)
       D(2,2)=FV(2)
       D(2,3)=FV(5)/RAC2
       D(3,1)=D(1,3)
       D(3,2)=D(2,3)
       D(3,3)=FV(3)
C     -- INVERSE DE LA MATRICE D
       CALL R8INIR(3*3,0.D0,DD,1)
           DO 191 K=1,3
               DD(K,K)=1.D0
 191  CONTINUE  
        CALL MGAUSS(D,DD,3,3,3,NUL,LOGIC)
C 
       CALL R8INIR(6,0.D0,FF,1)
       FF(1) = DD(1,1)
       FF(2) = DD(2,2)
       FF(3) = DD(3,3) 
       FF(4) = DD(1,2)*RAC2
       FF(5) = DD(2,3)*RAC2
       FF(6) = DD(1,3)*RAC2      
C     -- MATRICE SYMETRIQUE FFI
       CALL R8INIR(6*6,0.D0,FFI,1)
        DO 195 K=1,3
        DO 196 L=1,3
             FFI(K,L) = (FF(K)+FF(L))/2.D0
 196  CONTINUE
 195  CONTINUE
        DO 197 K=1,3
        DO 198 L=4,NDIMSI
             FFI(K,L) = FF(L)/2.D0
             FFI(L,K) = FFI(K,L)
 198  CONTINUE
 197  CONTINUE
C     --  7.3.3 CALCUL DES TERMES DSIDEP L'OPERATEUR TANGENT
       CALL R8INIR(6*6,0.D0,DSIDEP,1)
        DO 155 K=1,NDIMSI
        DO 156 L=1,NDIMSI
              DSIDEP(K,L)=BB(K,L)-FFI(K,L)
 156  CONTINUE
 155  CONTINUE                  
      ENDIF
C FIN ---------------------------------------------------------
      ENDIF
      END
