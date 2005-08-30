      SUBROUTINE NMVPIR (KPGVRC,NDIM,TYPMOD,IMATE,COMPOR,CRIT,
     &                   INSTAM,INSTAP,
     &                   TM,TP,TREF,
     &                   DEPS,
     &                   SIGM,VIM,
     &                   OPTION,
     &                   DEFAM,DEFAP,
     &                   ANGMAS,
     &                   SIGP,VIP,DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/08/2005   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_7
C TOLE CRP_20
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER            NDIM,IMATE,KPGVRC
      CHARACTER*8        TYPMOD(*)
      CHARACTER*16       COMPOR(*),OPTION
      REAL*8             CRIT(4),INSTAM,INSTAP,TM,TP,TREF,IRRAM,IRRAP
      REAL*8             DEPS(6),DEFAM(6),DEFAP(6),ANGMAS(3)
      REAL*8             SIGM(6),VIM(2),SIGP(6),VIP(2),DSIDEP(6,6)
C ----------------------------------------------------------------------
C     REALISE LES LOIS DE VISCOPLASTICITE SOUS IRRADIATION
C     POUR LES ELEMENTS
C     ISOPARAMETRIQUES EN PETITES DEFORMATIONS
C
C 1/ LEMAITRE MODIFIEE
C 2/ ZIRC_CYRA2 (PROJET CYRANO - 1994)
C 3/ ZIRC_EPRI
C 4/ VISC_IRRA_LOG (PROJET PACHYDERME - 2004)
C 5/ LEMA_SEUIL
C
C
C IN  KPGVRC  : NUMERO DU POINT DE GAUSS
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT : RELCOM ET DEFORM
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  INSTAM  : INSTANT DU CALCUL PRECEDENT
C IN  INSTAP  : INSTANT DU CALCUL
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  SIGM    : CONTRAINTES A L'INSTANT DU CALCUL PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
C IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
C IN  DEFAM   : DEFORMATIONS ANELASTIQUES A L'INSTANT PRECEDENT
C IN  DEFAP   : DEFORMATIONS ANELASTIQUES A L'INSTANT DU CALCUL
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C OUT SIGP    : CONTRAINTES A L'INSTANT ACTUEL
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT DSIDEP  : MATRICE CARREE
C
C               ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C               L'ORDRE :  XX YY ZZ XY XZ YZ
C
C     COMMON POUR LES PARAMETRES DES LOIS VISCOPLASTIQUES
      COMMON / NMPAVP / DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
      REAL*8            DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
C     COMMON POUR LES PARAMETRES DES LOIS DE FLUAGE SOUS IRRADIATION
C     ZIRC_EPRI    : FLUPHI VALDRP TTAMAX
C     ZIRC_CYRA2   : FLUPHI EPSFAB TPREC
C     VISC_IRRA_LOG: FLUPHI A      B      CTPS    ENER
C -------------------------------------------------------------
      COMMON / NMPAIR / FLUPHI,
     *                  EPSFAB,TPREC,
     *                  VALDRP,TTAMAX,
     *                  A,B,CTPS,ENER
      REAL*8            FLUPHI
      REAL*8            VALDRP,TTAMAX
      REAL*8            EPSFAB,TPREC
      REAL*8            A,B,CTPS,ENER
C     COMMON POUR LES PARAMETRES DE LA LOI DE LEMAITRE (NON IRRADIEE)
      COMMON / NMPALE / UNSURK,UNSURM,VALDEN
      REAL*8            UNSURK,UNSURM,VALDEN
C PARAMETRES MATERIAUX
C ELASTIQUES
      REAL*8            ALPHAP,EP,NUP,TROIKP,DEUMUP
      REAL*8            ALPHAM,EM,NUM,TROIKM,DEUMUM
C AUTRES
      INTEGER   NBCLEM, NBCVIL, NBCCYR, NBCEPR, NBCINT
      PARAMETER (NBCLEM=7, NBCVIL=5, NBCCYR=3, NBCEPR=3, NBCINT=2)
      REAL*8     COELEM(NBCLEM),COEVIL(NBCVIL)
      REAL*8     COECYR(NBCCYR), COEEPR(NBCEPR), COEINT(NBCINT)
      CHARACTER*8  NOMLEM(NBCLEM),NOMVIL(NBCVIL)
      CHARACTER*8  NOMINT(NBCINT)
      CHARACTER*2  CODVIL(NBCVIL),CODLEM(NBCLEM),CODINT(NBCINT)
C GRANDISSEMENT
      INTEGER    NBCLGR
      PARAMETER (NBCLGR=3)
      REAL*8     COEFGR(NBCLGR)
      CHARACTER*8 NOMGRD(NBCLGR)
      CHARACTER*2 CODGRA(NBCLGR)
C
      REAL*8            T1,T2
      INTEGER           IULMES,IUNIFI,IRET2
      REAL*8            RAC2,TABS,R8T0,R8VIDE
      INTEGER           K,L
      INTEGER           NDIMSI
      REAL*8            ALPHA,BETA,CAA,SAA,CBA,SBA
      REAL*8            DEPSGR
      REAL*8            DEGRAN(6)
      REAL*8            DEPSTH(6)
      REAL*8            DEPSDV(6),SIGDV(6),SIGEL(6),EPSMO,SIGMO
      REAL*8            SIEQM,SIEQP,D
      REAL*8            XNUMER
      REAL*8            SIGMP(6),DELTKL,DELTP2
      REAL*8            A0,XAP,X,FG,FDGDST,FDGDEV
      REAL*8            COEF1,DELTEV,COEF2
      REAL*8            VPALEM,VPACYR,VPAEPR,VPAVIL
      EXTERNAL          VPALEM,VPACYR,VPAEPR,VPAVIL
      REAL*8            KRON(6)
      DATA              KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA NOMLEM / 'N', 'UN_SUR_K', 'UN_SUR_M', 'QSR_K',
     &              'BETA','PHI_ZERO','L'/
      DATA NOMVIL / 'A', 'B', 'CSTE_TPS', 'ENER_ACT', 'FLUX_PHI'/
      DATA NOMINT / 'A',         'S'/
      DATA NOMGRD / 'GRAN_A','GRAN_B','GRAN_S' /
C DEB ------------------------------------------------------------------
C
      THETA = CRIT(4)
      T1 = ABS(THETA-0.5D0)
      T2 = ABS(THETA-1.D0)
      PREC = 0.01D0
      IF ((T1.GT.PREC).AND.(T2.GT.PREC))  THEN
         CALL UTMESS('F','ROUTINE NMVPIR','THETA = 1 OU 0.5 ')
      ENDIF
C
      IF (TYPMOD(1).EQ.'C_PLAN') THEN
         IULMES = IUNIFI('MESSAGE')
         WRITE (IULMES,*) 'COMPORTEMENT ',COMPOR(1)(1:10),' NON
     & PROGRAMME POUR DES ELEMENTS DE CONTRAINTES PLANES'
         CALL UTMESS('F','NMVPIR_1','PAS DE CONTRAINTES PLANES')
         GO TO 299
      ENDIF
      TABS = R8T0()
      RAC2 = SQRT(2.D0)

C DEFORMATIONS DE GRANDISSEMENT
      CALL R8INIR(6,0.D0,DEGRAN,1)
      CALL R8INIR(3,0.D0,COEFGR,1)
      DEPSGR = 0.D0
C TEMPERATURE AU MILIEU DU PAS DE TEMPS
      TSCHEM = TM*(1.D0-THETA)+TP*THETA
C DEFORMATION PLASTIQUE CUMULEE
      DPC = VIM(1)
C INCREMENT DE TEMPS
      DELTAT = INSTAP - INSTAM
      IF (DELTAT.EQ.0.D0) THEN
         CALL UTMESS('F','NMVPIR',
     &    'L''INCREMENT DE TEMPS VAUT ZERO, VERIFIER VOTRE DECOUPAGE')
      ENDIF

      CALL RCVARC(' ','IRRA','-',KPGVRC,IRRAM,IRET2)
      IF (IRET2.GT.0) IRRAM=0.D0
      CALL RCVARC(' ','IRRA','+',KPGVRC,IRRAP,IRET2)
      IF (IRET2.GT.0) IRRAP=0.D0

      DO 100 K=1,6
      DO 100 L=1,6
         DSIDEP(K,L) = 0.D0
 100  CONTINUE
      IF(NDIM.EQ.2) THEN
         NDIMSI=4
      ELSE
         NDIMSI=6
      ENDIF
C
C MISE AU FORMAT DES TERMES NON DIAGONAUX
C
      DO 105 K=4,NDIMSI
         DEFAM(K) = DEFAM(K)*RAC2
         DEFAP(K) = DEFAP(K)*RAC2
 105  CONTINUE
C
C CARACTERISTIQUES ELASTIQUES VARIABLES
C
      CALL NMASSE(IMATE,INSTAM,TM,
     &            EM,NUM,ALPHAM,DEUMUM,TROIKM)

C CONNERIE DE COMMON DEBILE
      DEUXMU = DEUMUM

      CALL NMASSE(IMATE,INSTAP,TP,
     &            EP,NUP,ALPHAP,DEUMUP,TROIKP)

C ----------------------------------------------------------------------
C ASSEMBLAGE COMBUSTIBLE
C       LOIS DE COMPORTEMENT DISPONIBLES :
C        - LEMAITRE MODIFIEE POUR L'IRRADIATION AVEC GRANDISSEMENT
C        - VISC_IRRA_LOG AVEC GRANDISSEMENT
C ----------------------------------------------------------------------
      IF (COMPOR(1)(1:13).EQ.'LEMAITRE_IRRA') THEN

C       RECUPERATION DES CARACTERISTIQUES DES LOIS DE FLUAGE

         CALL RCVALA(IMATE,' ','LEMAITRE_IRRA',0,' ',0.D0,
     &                 7,NOMLEM,COELEM,CODLEM, 'FM' )

         CALL RCVALA(IMATE,' ','LEMAITRE_IRRA',0,' ',0.D0,
     &                 3,NOMGRD,COEFGR,CODGRA, 'FM' )
C          FLUX NEUTRONIQUE
         FLUPHI = (IRRAP-IRRAM)/DELTAT

C       TRAITEMENT DES PARAMETRES DE LA LOI DE FLUAGE
         IF (COELEM(2).EQ.0.D0) THEN
            FLUPHI = 1.D0
         ENDIF
C         PARAMETRES DE LA LOI DE FLUAGE
         VALDEN = COELEM(1)
         IF (COELEM(6).LE.0.D0) THEN
            CALL UTMESS('F','LEMAITRE3D','PHI_ZERO < OU = A ZERO')
         ENDIF
         IF (FLUPHI.LT.0.D0) THEN
            CALL UTMESS('F','LEMAITRE3D','FLUENCE DECROISSANTE(PHI<0)')
         ENDIF
         XNUMER = EXP(-1.D0*COELEM(4)/(VALDEN*(TSCHEM+TABS)))
         UNSURK = COELEM(2)*FLUPHI/COELEM(6) + COELEM(7)
         IF (UNSURK.LT.0.D0) THEN
            CALL UTMESS('F','LEMAITRE3D','1/K ET L DOIVENT ETRE >=0')
         ENDIF
         IF (UNSURK.EQ.0.D0) THEN
            IF (COELEM(5).EQ.0.D0) UNSURK=1.D0
            IF (COELEM(5).LT.0.D0) THEN
               CALL UTMESS('F','LEMAITRE3D','PHI/KPHI0+L=0 ET BETA<0')
            ENDIF
         ENDIF
         IF (UNSURK.GT.0.D0) THEN
            UNSURK = UNSURK**(COELEM(5)/VALDEN)
         ENDIF
         UNSURK = UNSURK * XNUMER
         UNSURM = COELEM(3)

      ELSE IF (COMPOR(1)(1:10).EQ.'VISC_IRRA_') THEN
C        PARAMETRES DE LA LOI DE FLUAGE
         CALL RCVALA(IMATE,' ','VISC_IRRA_',1,'TEMP',TSCHEM,
     &           5,NOMVIL(1),COEVIL(1),CODVIL, 'FM' )
         A         = COEVIL(1)
         B         = COEVIL(2)
         CTPS      = COEVIL(3)
         ENER      = COEVIL(4)
         FLUPHI=COEVIL(5)

      ELSE IF (COMPOR(1)(1:10).EQ.'GRAN_IRRA_') THEN
C        PARAMETRES DE LA LOI DE FLUAGE
         CALL RCVALA(IMATE,' ','GRAN_IRRA_',1,' ',0.D0,
     &           5,NOMVIL(1),COEVIL(1),CODVIL, 'FM' )
         CALL RCVALA(IMATE,' ','GRAN_IRRA_',0,' ',0.D0,
     &                 3,NOMGRD,COEFGR,CODGRA, 'FM' )
         IF (CODGRA(3).NE.'OK') THEN
            COEFGR(3) = 1.D0
         ENDIF
            IF (COEVIL(5).NE.1.D0) THEN
               CALL UTMESS('A','GRAN_IRRA_LOG',
     *         'FLUENCE COMMANDEE ET FLUX_PHI DIFFERENT DE 1')
               FLUPHI=COEVIL(5)
            ELSE
               FLUPHI = (IRRAP-IRRAM)/DELTAT
            ENDIF
            IF(ABS(FLUPHI).LE.1.D-10) FLUPHI=0.D0
            IF (FLUPHI.LT.0.D0) THEN
               CALL UTMESS('F','GRAN_IRRA_LOG',
     *         'FLUENCE DECROISSANTE (PHI<0)')
            ENDIF
         A     = COEVIL(1)
         B     = COEVIL(2)
         CTPS  = COEVIL(3)
         ENER  = COEVIL(4)

      ELSE IF (COMPOR(1)(1:10).EQ.'LEMA_SEUIL') THEN
         CALL RCVALA(IMATE,' ','LEMA_SEUIL',1,'TEMP',TSCHEM,
     &              2,NOMINT(1),COEINT(1),CODINT, 'FM' )
         UNSURM=0.D0
         VALDEN=1.D0
         UNSURK = (COEINT(1)*FLUPHI*2.D0)/SQRT(3.D0)
         FLUPHI=IRRAP
         IF (UNSURK.LT.0.D0) THEN
            CALL UTMESS('F','LEMA_SEUIL',
     &                  'LE PARAMETRE A DOIT ETRE >=0')
         ENDIF
C ------------------------- ZIRC_CYRA2 ---------------------------------
C       LOI DE COMPORTEMENT ZIRC_CYRA2
C ----------------------------------------------------------------------
      ELSE IF (COMPOR(1)(1:10).EQ.'ZIRC_CYRA2')THEN
         CALL NMVPCA(IMATE,COMPOR(1),'T ',INSTAP,R8VIDE(),'F ',
     &              COEVIL,COECYR,COEEPR)
         EPSFAB = COECYR(1)
         TPREC  = COECYR(2)
         FLUPHI = COECYR(3)
C ------------------------- ZIRC_EPRI ---------------------------------
C       LOI DE COMPORTEMENT ZIRC_EPRI
C ---------------------------------------------------------------------
      ELSE IF (COMPOR(1)(1:9).EQ.'ZIRC_EPRI')THEN
         CALL NMVPCA(IMATE,COMPOR(1),' T',R8VIDE(),TSCHEM,'F ',
     &              COEVIL,COECYR,COEEPR)
         FLUPHI = COEEPR(1)
         VALDRP = COEEPR(2)
         TTAMAX = COEEPR(3)
      ELSE IF (COMPOR(1)(1:10).EQ.'LMARC_IRRA') THEN
         CALL UTMESS ('F','NMVPIR','LA LOI LMARC_IRRA'//
     &   'N''EST COMPATIBLE QU''AVEC UNE MODELISATION POUTRE')

      ENDIF
C
C       TRAITEMENT DES PARAMETRES DE LA LOI DE GRANDISSEMENT
C
      IF ((COEFGR(1).NE.0.D0).OR.(COEFGR(2).NE.0.D0)) THEN
C      DEFORMATION DE GRANDISSEMENT UNIDIMENSIONNEL
         DEPSGR = (COEFGR(1)*TP+COEFGR(2))*(IRRAP**COEFGR(3))-
     *            (COEFGR(1)*TM+COEFGR(2))*(IRRAM**COEFGR(3))

C      RECUPERATION DU REPERE POUR LE GRANDISSEMENT
         IF (NDIM.EQ.2) THEN
            IF (ANGMAS(2) .NE. 0.D0 ) THEN
               CALL UTDEBM('F','NMVPIR_2','ERREUR DIR. GRANDISSEMENT')
               CALL UTIMPR('L','   ANGLE ALPHA = ',1,ANGMAS(1))
               CALL UTIMPR('L','    ANGLE BETA = ',1,ANGMAS(2))
               CALL UTFINM()
            ENDIF
         ENDIF
         ALPHA = ANGMAS(1)
         BETA  = ANGMAS(2)
         CAA = COS(ALPHA)
         SAA = SIN(ALPHA)
         CBA = COS(BETA)
         SBA = SIN(BETA)

C      DEFORMATIONS DE GRANDISSEMENT DANS LE REPERE
         DEGRAN(1) =  DEPSGR*CAA*CAA*CBA*CBA
         DEGRAN(2) =  DEPSGR*SAA*SAA*SBA*SBA
         DEGRAN(3) =  DEPSGR*SBA*SBA
         DEGRAN(4) =  DEPSGR*SAA*CAA*CBA*CBA*RAC2
         DEGRAN(5) = -DEPSGR*CAA*SBA*CBA*RAC2
         DEGRAN(6) = -DEPSGR*SAA*SBA*CBA*RAC2
      ENDIF
C
      EPSMO = 0.D0

      DO 110 K=1,3
         DEPSTH(K)   = DEPS(K)
     &                -(ALPHAP*(TP-TREF)-ALPHAM*(TM-TREF))
     &                -(DEFAP(K)-DEFAM(K))
         DEPSTH(K) = DEPSTH(K) - DEGRAN(K)
         DEPSTH(K)   = DEPSTH(K) * THETA

         IF ((K.EQ.1).OR.(NDIMSI.EQ.6)) THEN
            DEPSTH(K+3) = DEPS(K+3)-(DEFAP(K+3)-DEFAM(K+3))
            DEPSTH(K+3) = DEPSTH(K+3) - DEGRAN(K+3)
            DEPSTH(K+3) = DEPSTH(K+3) * THETA
         ENDIF

         EPSMO = EPSMO + DEPSTH(K)
 110  CONTINUE
C
      EPSMO = EPSMO/3.D0

      DO 111 K=1,NDIMSI
         DEPSDV(K)   = DEPSTH(K) - EPSMO * KRON(K)
 111  CONTINUE
      SIGMO = 0.D0
      DO 113 K =1,3
         SIGMO = SIGMO + SIGM(K)
 113  CONTINUE
      SIGMO = SIGMO /3.D0

      SIEQM=0.D0
      DO 114 K=1,NDIMSI
         SIGDV(K) = SIGM(K) - SIGMO * KRON(K)
         SIEQM   = SIEQM   + SIGDV(K)**2
         SIGMP(K)=((DEUMUP+DEUMUM)/DEUMUM*(SIGM(K)-SIGMO*KRON(K))+
     &            (TROIKP+TROIKM)/TROIKM*SIGMO*KRON(K))*0.5D0
114   CONTINUE
      SIEQM=SQRT(1.5D0*SIEQM)
      SIGMO = 0.D0
      DO 116 K =1,3
         SIGMO = SIGMO + SIGMP(K)
116   CONTINUE
      SIGMO = SIGMO /3.D0


      IF (COMPOR(1)(1:10).EQ.'LEMA_SEUIL') THEN
         SIEQP=0.D0
         DO 117 K = 1,NDIMSI
            SIGDV(K) = SIGMP(K) - SIGMO * KRON(K)
            SIGEL(K) = SIGDV(K) + DEUMUP * DEPSDV(K)/THETA
            SIEQP   = SIEQP   + SIGEL(K)**2

 117     CONTINUE
         SIEQP=SQRT(1.5D0*SIEQP)
      ENDIF

      SIELEQ = 0.D0
      DO 118 K = 1,NDIMSI
         SIGDV(K) = SIGMP(K) - SIGMO * KRON(K)
         SIGEL(K) = SIGDV(K) + DEUMUP * DEPSDV(K)
         SIELEQ   = SIELEQ   + SIGEL(K)**2

 118  CONTINUE
      SIELEQ       = SQRT(1.5D0*SIELEQ)
C
C----RESOLUTION DE L'EQUATION SCALAIRE----
C
      PREC = CRIT(3)
      NITER = CRIT(1)
C
      A0 = - SIELEQ
C

      IF (COMPOR(1)(1:13).EQ.'LEMAITRE_IRRA') THEN
         XAP = SIELEQ
         XAP = XAP - SIELEQ*1.D-12
         IF (ABS(A0).LE.PREC) THEN
            X = 0.D0
         ELSE
            CALL ZEROF2(VPALEM,A0,XAP,PREC,INT(NITER),X)
         ENDIF
         CALL GGPLEM(X,DPC+(SIELEQ-X)/(1.5D0*DEUMUP),VALDEN,
     *          UNSURK,UNSURM,THETA,DEUMUP,FG,FDGDST,FDGDEV)
      ELSE IF (COMPOR(1)(1:10).EQ.'VISC_IRRA_') THEN
         XAP = 0.99D0 * SIELEQ
         IF (ABS(A0).LE.PREC.OR.FLUPHI.LE.1.D-15) THEN
            X = 0.D0
         ELSE
          CALL ZEROF2(VPAVIL,A0,XAP,PREC,INT(NITER),X)
         ENDIF
         CALL GGPVIL(X,DPC+(SIELEQ-X)/(1.5D0*DEUMUP),TSCHEM,
     *            FLUPHI,A,B,CTPS,ENER,THETA,DEUMUP,PREC,INT(NITER),
     *            FG,FDGDST,FDGDEV)

      ELSE IF (COMPOR(1)(1:10).EQ.'GRAN_IRRA_') THEN
         XAP = 0.99D0 * SIELEQ
         IF (ABS(A0).LE.PREC.OR.FLUPHI.LE.1.D-15) THEN
            X = 0.D0
         ELSE
          CALL ZEROF2(VPAVIL,A0,XAP,PREC,INT(NITER),X)
         ENDIF
         CALL GGPVIL(X,DPC+(SIELEQ-X)/(1.5D0*DEUMUP),TSCHEM,
     *            FLUPHI,A,B,CTPS,ENER,THETA,DEUMUP,PREC,INT(NITER),
     *            FG,FDGDST,FDGDEV)

      ELSE IF (COMPOR(1)(1:10).EQ.'LEMA_SEUIL') THEN
         D=VIM(2)+(DELTAT*(SIEQM+SIEQP)/(2*COEINT(2)))
         XAP = SIELEQ
         XAP = XAP - SIELEQ*1.D-12
         IF (ABS(A0).LE.PREC) THEN
            X = 0.D0
C -----LE COMPORTEMENT EST PUREMENT ELASTIQUE EN DESSOUS DU SEUIL
         ELSE IF (D.LE.1.D0) THEN
            X=SIELEQ
         ELSE
            CALL ZEROF2(VPALEM,A0,XAP,PREC,INT(NITER),X)
         ENDIF
C -----LE COMPORTEMENT EST PUREMENT ELASTIQUE EN DESSOUS DU SEUIL
         IF (D.LE.1.D0) THEN
            FG=0.D0
            FDGDST=0.D0
            FDGDEV=0.D0
         ELSE
            CALL GGPLEM(X,1.D0,VALDEN,
     *      UNSURK,UNSURM,THETA,DEUMUP,FG,FDGDST,FDGDEV)

         ENDIF

      ELSE IF (COMPOR(1)(1:10).EQ.'ZIRC_CYRA2')THEN
         XAP = 0.99D0 * SIELEQ
         IF (ABS(A0).LE.PREC) THEN
            X = 0.D0
         ELSE
            CALL ZEROF2(VPACYR,A0,XAP,PREC,INT(NITER),X)
         ENDIF
         CALL GGPCYR(X,DPC+(SIELEQ-X)/(1.5D0*DEUMUP),TSCHEM,
     *     EPSFAB,TPREC,FLUPHI,THETA,DEUMUP,PREC,INT(NITER),FG,FDGDST,
     *     FDGDEV)
      ELSE IF (COMPOR(1)(1:9).EQ.'ZIRC_EPRI')THEN
         XAP = 0.99D0 * SIELEQ
         IF (ABS(A0).LE.PREC) THEN
            X = 0.D0
         ELSE
            CALL ZEROF2(VPAEPR,A0,XAP,PREC,INT(NITER),X)
         ENDIF
         CALL GGPEPR(X,DPC+(SIELEQ-X)/(1.5D0*DEUMUP),TSCHEM,
     *        FLUPHI,VALDRP,TTAMAX,THETA,DEUMUP,PREC,INT(NITER),
     *        FG,FDGDST,FDGDEV)
      ENDIF
C
      IF (X.NE.0.D0) THEN
         COEF1 = 1.D0/(1.D0+1.5D0*DEUXMU*DELTAT*FG/X)
      ELSE
         COEF1 = 1.D0/(1.D0+1.5D0*DEUXMU*DELTAT*FDGDST)
      ENDIF
C
      IF ( OPTION(1:9) .EQ. 'RAPH_MECA' .OR.
     &     OPTION(1:9) .EQ. 'FULL_MECA' ) THEN
         DELTP2 = 0.D0
         DO 170 K = 1,NDIMSI
            SIGDV(K) = SIGEL(K) * COEF1
            SIGP(K)  = SIGDV(K) + (SIGMO + TROIKP*EPSMO)*KRON(K)
            SIGP(K)  = (SIGP(K) - SIGM(K))/THETA + SIGM(K)
            DELTEV   = (SIGEL(K)-SIGDV(K))/(DEUMUP*THETA)
            DELTP2   = DELTP2   + DELTEV**2
 170     CONTINUE
         VIP(1) = VIM(1) + SQRT(2.D0*DELTP2/3.D0)

         IF (COMPOR(1)(1:10).EQ.'LEMA_SEUIL') THEN
            IF (D.LE.1.D0) THEN
               VIP(2) = VIM(2)+ ((SIEQP+SIEQM)*DELTAT)/(2*COEINT(2))
            ELSE
               VIP(2) = VIM(2)+ ((X/THETA+SIEQM)*DELTAT)/(2*COEINT(2))
            ENDIF

         ENDIF
      ENDIF
C
      IF  ( OPTION(1:9) .EQ. 'FULL_MECA'.OR.
     &      OPTION(1:14) .EQ. 'RIGI_MECA_TANG' ) THEN
         IF (X.NE.0.D0) THEN
            COEF2=SIELEQ*(1.D0 - DELTAT*FDGDEV)
            COEF2=COEF2/(1.D0+1.5D0*DEUXMU*DELTAT*FDGDST)
            COEF2=COEF2 - X
            COEF2=COEF2*1.5D0/(SIELEQ**3)
         ELSE
         COEF2 = 0.D0
         ENDIF
         DO 135 K=1,NDIMSI
            DO 135 L=1,NDIMSI
               DELTKL = 0.D0
               IF (K.EQ.L) DELTKL = 1.D0
                  DSIDEP(K,L) = COEF1*(DELTKL-KRON(K)*KRON(L)/3.D0)
               DSIDEP(K,L) = DEUMUP*(DSIDEP(K,L)+
     &                       COEF2*SIGEL(K)*SIGEL(L))
               DSIDEP(K,L) = DSIDEP(K,L) + TROIKP*KRON(K)*KRON(L)/3.D0
 135     CONTINUE
      ENDIF
C
 9999 CONTINUE
C
C MISE AU FORMAT DES TERMES NON DIAGONAUX
C
      DO 200 K=4,NDIMSI
         DEFAM(K) = DEFAM(K)/RAC2
         DEFAP(K) = DEFAP(K)/RAC2
 200  CONTINUE
 299  CONTINUE



      END
