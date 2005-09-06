      SUBROUTINE NM1VIL(KPGVRC,ICDMAT,CRIT,
     &                  INSTAM,INSTAP,
     &                  TM,TP,TREF,
     &                  DEPS,
     &                  SIGM,VIM,
     &                  OPTION,
     &                  DEFAM,DEFAP,
     &                  ANGMAS,
     &                  SIGP,VIP,DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/09/2005   AUTEUR GODARD V.GODARD 
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
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
      INTEGER            ICDMAT,KPGVRC
      REAL*8             CRIT(*)
      REAL*8             INSTAM,INSTAP
      REAL*8             TM,TP,TREF
      REAL*8             IRRAM,IRRAP
      REAL*8             DEPS
      REAL*8             SIGM,VIM
      CHARACTER*16       OPTION
      REAL*8             DEFAM,DEFAP
      REAL*8             ANGMAS(3)
      REAL*8             SIGP,VIP,DSIDEP


C ----------------------------------------------------------------------
C      VISCO_PLASTICITE FLUAGE SOUS IRRADIATION AVEC GRANDISSEMENT
C      ASSE_COMBU AVEC VISC_IRRA_LOG
C      LOI 1D PURE
C
C IN  ICDMAT  : MATERIAU CODE
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
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
C OUT DSIDEP  : MODULE TANGENT


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
C     COMMON POUR LES PARAMETRES DES LOIS VISCOPLASTIQUES
      COMMON / NMPAVP / DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
      REAL*8            DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
C     COMMON POUR LES PARAMETRES DES LOIS DE FLUAGE SOUS IRRADIATION
C     ZIRC_EPRI    : FLUPHI VALDRP TTAMAX
C     ZIRC_CYRA2   : FLUPHI EPSFAB TPREC  
C     VISC_IRRA_LOG: FLUPHI A      B      CTPS    ENER 
      COMMON / NMPAIR / FLUPHI,
     *                  EPSFAB,TPREC,
     *                  VALDRP,TTAMAX,
     *                  A,B,CTPS,ENER
      REAL*8            FLUPHI
      REAL*8            VALDRP,TTAMAX          
      REAL*8            EPSFAB,TPREC
      REAL*8            A,B,CTPS,ENER
C PARAMETRES MATERIAUX
C ELASTIQUES
      REAL*8            ALPHAP,EP,NUP,TROIKP,DEUMUP
      REAL*8            ALPHAM,EM,NUM,TROIKM,DEUMUM   
C AUTRES 
      INTEGER    NBCGIL,IRET2
      PARAMETER  (NBCGIL=5)
      REAL*8     COEGIL(NBCGIL)
      CHARACTER*8  NOMGIL(NBCGIL) 
      CHARACTER*2 CODGIL(NBCGIL)
C GRANDISSEMENT
      INTEGER    NBCLGR
      PARAMETER (NBCLGR=3)
      REAL*8     COEFGR(NBCLGR)
      CHARACTER*8 NOMGRD(NBCLGR)
      REAL*8            T1,T2,R8VIDE
      REAL*8            DEPSGR,DEGRAN,DEPSTH,DEPSEL,DEPSAN,DEPSIM
      REAL*8            SIGEL
      REAL*8            DPCMOD,COEF1,COEF2,COEFB
      REAL*8            FG,FDGDST,FDGDEV
      REAL*8            ALPHA,A0,XAP,X
      REAL*8            VPAVIL
      EXTERNAL          VPAVIL
      DATA NOMGIL / 'A', 'B', 'CSTE_TPS', 'ENER_ACT', 'FLUX_PHI'/
      DATA        NOMGRD / 'GRAN_A' , 'GRAN_B' , 'GRAN_S' /

C     PARAMETRE THETA D'INTEGRATION

      THETA = CRIT(4)
      T1 = ABS(THETA-0.5D0)
      T2 = ABS(THETA-1.D0)
      PREC = 0.01D0
      IF ((T1.GT.PREC).AND.(T2.GT.PREC))  THEN
         CALL UTMESS('F','ROUTINE NMAVIL','THETA = 1 OU 0.5 ')
      ENDIF

C TEMPERATURE AU MILIEU DU PAS DE TEMPS  (DANS COMMON / NMPAVP /)    
      TSCHEM = TM*(1.D0-THETA)+TP*THETA
C DEFORMATION PLASTIQUE CUMULEE  (DANS COMMON / NMPAVP /)     
      DPC = VIM
C INCREMENT DE TEMPS (DANS COMMON / NMPAVP /)      
      DELTAT = INSTAP - INSTAM
C CARACTERISTIQUES ELASTIQUES VARIABLES
      CALL NMASSE(ICDMAT,INSTAM,TM,
     &            EM,NUM,ALPHAM,DEUMUM,TROIKM)

      CALL NMASSE(ICDMAT,INSTAP,TP,
     &            EP,NUP,ALPHAP,DEUMUP,TROIKP)

C     IRRADIATION AU POINT CONSIDERE  
C     FLUX NEUTRONIQUE        
      CALL RCVARC('F','IRRA','-',KPGVRC,IRRAM,IRET2)
      IF (IRET2.GT.0) IRRAM=0.D0
      CALL RCVARC('F','IRRA','+',KPGVRC,IRRAP,IRET2)
      IF (IRET2.GT.0) IRRAP=0.D0

      FLUPHI = (IRRAP-IRRAM)/DELTAT 
C     RECUPERATION DES CARACTERISTIQUES DE GRANDISSEMENT       
      CALL RCVALA(ICDMAT,' ','GRAN_IRRA_',0,' ',0.D0,
     &              3,NOMGRD(1),COEFGR(1),CODGIL(1), '  ' )
C     RECUPERATION DES CARACTERISTIQUES DES LOIS DE FLUAGE  
      CALL RCVALA(ICDMAT,' ','GRAN_IRRA_',0,' ',0.D0,
     &              NBCGIL,NOMGIL(1),COEGIL(1),CODGIL(1), '  ' )
C     TRAITEMENT DES PARAMETRES DE LA LOI DE FLUAGE 
      IF (CODGIL(1).EQ.'OK') THEN 
C         LOI DE TYPE VISC_IRRA_LOG         
C         PARAMETRES DE LA LOI DE FLUAGE 

          A       = COEGIL(1)
          B       = COEGIL(2) 
          CTPS    = COEGIL(3)
          ENER    = COEGIL(4)

          IF (COEGIL(5).NE.1.D0) THEN
            CALL UTMESS('A','GRAN_IRRA_LOG',
     *        'FLUENCE COMMANDEE ET FLUX_PHI DIFFERENT DE 1')
          ENDIF   
          IF (FLUPHI.LT.0.D0) THEN
            CALL UTMESS('F','GRAN_IRRA_LOG',
     *      'FLUENCE DECROISSANTE (PHI<0)')
          ENDIF  
      ELSE
          CALL UTMESS('F','NM1VIL',
     *        'RELATION ASSE_COMBU 1D SANS LOI DE FLUENCE APPROPRIEE')
      ENDIF

C     INCREMENT DEFORMATION DE GRANDISSEMENT UNIDIMENSIONNEL  
      DEPSGR = (COEFGR(1)*TP+COEFGR(2))*(IRRAP**COEFGR(3))-
     *         (COEFGR(1)*TM+COEFGR(2))*(IRRAM**COEFGR(3))

C     RECUPERATION DU REPERE POUR LE GRANDISSEMENT 
      ALPHA = ANGMAS(1)
      IF ( ANGMAS(2) .NE. 0.D0 ) THEN
         CALL UTMESS('F','NM1VIL','ERREUR DIR. GRANDISSEMENT')
      ENDIF

C     INCREMENT DEFORMATION DE GRANDISSEMENT DANS LE REPERE    
      DEGRAN = DEPSGR*COS(ALPHA)*COS(ALPHA)
C     INCREMENT DEFORMATION ANELASTIQUE
      DEPSAN = DEFAP-DEFAM
C     INCREMENT DEFORMATION THERMIQUE
      DEPSTH = ALPHAP*(TP-TREF)-ALPHAM*(TM-TREF)
C     INCREMENT DEFORMATION IMPOSEE
      DEPSIM = DEPSTH+DEPSAN+DEGRAN
C     INCREMENT DEFORMATION ELASTIQUE
      DEPSEL = THETA*(DEPS-DEPSIM)

C     CONTRAINTE ELASTIQUE
      SIGEL = (EP/EM)*SIGM+
     &        (1.D0-THETA)*(1.D0-EP/EM)*SIGM+
     &        EP*DEPSEL


C     CONTRAINTE ELASTIQUE EQUIVALENTE
      SIELEQ = ABS(SIGEL)

C----RESOLUTION DE L'EQUATION SCALAIRE----
C TROUVER X TEL QUE 
C    VPAVIL = EP*DELTAT*G + X - SIELEQ = 0

C PARMATRES DE CONVERGENCE LOCALE
      PREC  = CRIT(3)
      NITER = CRIT(1)
C RUSE POUR UTILISER VPAVIL
C VPAVIL = 1.5D0*DEUXMU*DELTAT*G + X - SIELEQ en 3D
C   SI ON ECRIT DEUXMU = 2.D0*EP/3.D0 ALORS
C VPAVIL = EP*DELTAT*G + X - SIELEQ en 1D
      DEUXMU = 2.D0*EP/3.D0

C POINT DE DEPART
      A0 = - SIELEQ
C
      XAP = 0.99D0 * SIELEQ


      IF (ABS(A0).LE.PREC) THEN
         X = 0.D0
      ELSE
         CALL ZEROF2(VPAVIL,A0,XAP,PREC,INT(NITER),X)
      ENDIF

C INCREMENT DE DEFORMATION PLASTIQUE
      DPCMOD = DPC+(SIELEQ-X)/EP

      CALL GGPVIL(X,DPCMOD,TSCHEM,
     *            FLUPHI,A,B,CTPS,ENER,THETA,DEUXMU,PREC,INT(NITER),
     *            FG,FDGDST,FDGDEV) 
    
C CONTRAINTE ACTUALISEE
      
      IF (X.NE.0.D0) THEN
        COEFB = 1.D0/(1.D0+EP*DELTAT*FG/X)
      ELSE
        COEFB = 1.D0/(1.D0+EP*DELTAT*FDGDST)
      ENDIF

      SIGP = COEFB*SIGEL
      SIGP = (SIGP-SIGM)/THETA + SIGM
C DEFORMATION PLASTIQUE CUMULEE ACTUALISEE
C      VIP  = VIM+(SIGEL-COEFB*SIGEL)/(EP*THETA)
      VIP  = VIM+(SIELEQ-COEFB*SIELEQ)/(EP*THETA)

C MODULE TANGENT POUR MATRICE TANGENTE    

      COEF1 = (1.D0/SIELEQ**3)*
     &        (SIELEQ*(1.D0-DELTAT*FDGDEV)/(1+EP*DELTAT*FDGDST)-X)

C on modifie la routine pour eviter une division par 0
      IF (SIELEQ.GE.PREC) THEN
        COEF2 = X / SIELEQ
      ELSE
        COEF2 = 0.D0
      ENDIF
      
      IF (FDGDST.LE.1D-10) THEN
        DSIDEP = EP
      ELSE
        DSIDEP = EP*(COEF1*SIGEL*SIGEL+COEF2)
      ENDIF

      END
