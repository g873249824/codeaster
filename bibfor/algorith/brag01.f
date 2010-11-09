      SUBROUTINE BRAG01(FAMI,KPG,KSP,
     &             NDIM,TYPMOD,IMATE,COMPOR,INSTAM,INSTAP,
     &             SECHM,SECHP,TM,TP,TREF,EPSM,DEPS,SIGM,
     &             VIM,OPTION,SIGP,VIP,DSIDEP,DEVPT,FLUOR)

C        ROUTINE ANCIENNEMENT NOMMEE BETON3DV13 PUIS BETRAG1

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2010   AUTEUR DEBONNIERES P.DE-BONNIERES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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

C        E.GRIMAL JUILLET 2006
C     CORREC = ABREVIATION DE CORRECTION
C    CORREC 5/5/04 AS BCH=1 DS SIG_APP PCH ET PW SONT EFFECTIVES
C          AU SENS DE L ENDOMMAGEMENT
C    CORREC 25/5/04 AS E1D EST BIEN LA PARTIE REVERSIBLE DE LA
C          DEFORMATION DEVIATORIQUE ET E2D LA PARTIE VISCOPLASTIQUE
C    CORREC 24/6/04 AS FLUAGE CALCULE AVEC PW=-PC ET SIGMA EFF AVEC
C          PW*BW & BW=SR A PRECISER DS LES DONNEES MATERIAUX
C          PW BRANCH�SUR LES 2 AMORTISSEURS SPH�IQUES, 2CAS DE
C          FLUAGE SPHERIQUE AVEC OU SANS K2 SUIVANT LE SIGNE DE E2*DE2
C    CORREC 25/6/04 AS DS SIG_APP PW DOIT ETRE POSITIF POUR INTERVENIR
C          DANS LES CONTRAINTES EFFECTIVES
C    CORREC 6/7/04 AS MEME SCHEMA RHEOLOGIQUE EN DEV ET SPH SANS
C          PRESSION ET SANS CONSOLIDATION
C    CORREC 6/7/04 AS I1 REMPLACE PAR NEG(I1) DS LA CRITERE DE DRUCKER
C          PRAGER
C    CORREC 21/07/2004 AS RETOUR AU MONTAGE FRACTAL SUR LE FLUAGE AVEC
C          DEPRESSION CAPILLAIRE SPHERIQUE ET SURPRESSION GLOBALE
C          + RAJOUT DES 2+12 VARIABLES INTERNES SEUILS VISCOPLASTIQUES
C          DES ETAGES 2 (SEUIL PLASTIQUE SUR K2*E2)
C    CORREC 7/09/2004 AS PRESSION D EAU A COMPORTEMENT UNILATERAL
C          MACROSCOPIQUE DANS SIG_APP
C    CORREC 23/9/04 AS INT�RATIONDE L' ENDOMMAGEMENT DE FLUAGE ET
C          COMPORTEMENT UNILATERAL EN SPHERIQUE
C    CORREC 27/9/04 AS ATTENUATION DES CARACTERISTIQUES DE FLUAGE
C          EN TRACTION (RFST)=FL T/FL C
C    CORREC 29/9/04 AS RAPPORT IRREVERSIBLE /REVERSIBLE REGLABLE
C          EN TRACTION  (KIST)=K2T/K1T=MU2T/MU1T
C    CORREC 8/10/04 AS SUPPRESSION DU CARACTERE UNILATERAL
C          SUR LA RHEOLOGIE
C          + RAJOUT DE LA DEFORMATION VISCOPLASTIQUE ANISOTROPES
C          DE TRACTION DANS LE CALCUL DES CONTRAINTES EFFECTIVES
C    CORREC 01/2005 EG MODIFICATION DE L'ENDO DE COMPRESSION
C          (PRISE EN COMPTE DES CONTRAINTES DE COMPRESSION)
C    CORREC 01/2005 EG RAJOUT DES VARIABLE SUIVANTE :
C          W0 (TENEUR EN EAU INITIALE)
C          EVPMAX (DEFORMATION DE FLUAGE MAXI)
C          SVFT(CONTRAINTE MODIFIANT LA VITESSE DE FLUAGE DE TRACTION)
C    CORREC 01/2005 EG MODIFICATION DE
C          PCH=(A-A0)+ * MCH * (VG-B(TR.EPS))+
C    CORREC 04/2005 EG MODIFICATION DE LOI AVANCEMENT PRISE EN COMPTE
C          D'UN SEUIL DE SR MINI POUR QUE RAG SOIT POSSIBLE
C    CORREC 02/2006 EG MODIFICATION LOI DU FLU_ORTO : SUPPRESSION DE
C          SVFT ET MODIFICATION E.VDT

C     TI TEMPS AU DEBUT DU PAS
C     TF TEMPS FIN DU PAS
C     EPSI DEFORMATION TOTALE SANS DEFORMATION THERMIQUE EN DEBUT
C          DE PAS
C     EPSF IDEM EN FIN DE PAS
C     XMAT00  CONSTANTES DU MAT�IAUX DANS L'ORDRE DES D�LARATIONS
C          DANS (IDVISC.ESO POUR CASTEM)(DS...POUR ASTER)
C     NMAT00 NOMBRE DE PARAMETREE MATERIAU=NBR MAXI DECLARE
C          DS IDVISC (NMAT0+12) +NBR POUR LA FORMU-
C          LATION ELASTIQ ISO (NMAT=4)+ CONSTANTES DS BETON3D (7)
C     VIM VARIABLES INTERNES AU DEBUT DU PAS CLASSEE CONFORMEMENT A LA
C          DECLARATION DS (IDVAR4.ESO POUR CASTEM) (...POUR ASTER)
C     VIP IDEM �LA FIN DU PAS
C     NVARI NOMBRE DE VARIBLES INTERNES
C          (31 D APRES DECLARATION DS IDVAR40.ESO)
C     SIGMA CONTRAINTES �LA FIN DU PAS
C     LOCAL INDICATEUR LOGIQUE POUR LE TRAITEMENT LOCAL DE LA
C          LOCALISATION (SI .TRUE. BESOIN DE LA TAILLE DES ELEMENTS...
C     CORREC BW=SR 26/09/05
C          COMPORTEMENT VISCO-ELASTIQUE ENDOMMAGEABLE ANISOTROPE
C          TRIDIM DU BETON (MODELE SIMPLIFIE TOTALEMENT EXPLICITE)
C TOLE CRP_21
C TOLE CRP_20

      IMPLICIT NONE
C      IMPLICIT REAL*8(A-Z) 
      INTEGER         NDIM,IMATE
      CHARACTER*16    COMPOR(3),OPTION
      CHARACTER*8     TYPMOD(*)
      CHARACTER*(*)   FAMI
      REAL*8          VIM(65),VIP(65)
      REAL*8          INSTAM,INSTAP
      REAL*8          HYDRM,HYDRP,SECHM,SECHP
      REAL*8          SIGM(6),DEPS(6),EPSM(6)
      REAL*8          SIGP(6),DSIDEP(6,6)
      REAL*8          DEVPT(6)
      INTEGER         FLUOR,KPG,KSP
C LE NOMBRE DE PARAMTRES MATERIAUX EST DE 32 ET PAS 31
C     (CF. DEFI_MATERIAU.CAPY)
C
C SEULS LES VERITABLES PARAMETRES MATERIAUX ONT ETE CONSERVES
C ATTENTION : SECH DESIGNE LA SATURATION DU MATERIAU
C
C      CHARACTER*8  NOMRES(32),NOMPAR(1)
      CHARACTER*8 NOMRES(33)
      CHARACTER*2  CODRET(33)
      REAL*8  VALRES(33)
      REAL*8  CMAT(15),DEP(6,6)
      REAL*8  RBID,VALR(4)
      INTEGER NDIMSI
      INTEGER I,J,K,L
      REAL*8  DT
C CARATERISTIQUES THERMO-ELASTIQUES
      REAL*8  E0,NU0,MU0,K0
      REAL*8  COEFH,COEFI

C CARACTERISTIQUES DU FLUAGE
      LOGICAL FLUAGE,PRESSN
C      LOGICAL CONSO
      REAL*8  K1,ETA1S,ETA2S,MU1,ETA1D,ETA2D
      REAL*8  K2,MU2
C      REAL*8  SVFT
      REAL*8  EPS0,TAU0,EVPMAX
      REAL*8  EPSTI(6),EPSTF(6)
C      REAL*8  EKD1,EKD2
      REAL*8  CC2,DED
C CARACTERISTIQUES DE L'ENDOMMAGEMENT
      REAL*8  RC,RT,DELTA,EDPICT,EDPICC
      REAL*8  XMC,XMT,DPICC0,DPICT0
      REAL*8  LCC,LCT
      REAL*8  SUT,SUC,SC
      REAL*8  SIGE2,SE2SP1,SE2DV6(6)
C CARACTERISTIQUES DES COUPLAGES FLUIDE/SQUELETTE ET GEL/SQUELETTE
      REAL*8  BW,MW,W0
      REAL*8  AVG,BVG,SR,TPC,PW3,MM,PWC,BWMAX
      REAL*8  WCH,PCH,WW,XX,PW2,PC,AA,BB,DES,ESX
C      REAL*8  PW1
C CARACTERISTIQUES DE LA FORMATION DES GELS
      REAL*8  VG,A0,ALP0,EA,R,SR0
      REAL*8  X00,F00,AVRAG,BCH,MCH,BCHMAX,ERAGMX
      REAL*8  ARAG,ARAGM,ARAGP,WCH1,WCH2,WCH11,WCH22
      REAL*8  TM,TP,TREF,TMABS,TPABS,TRFABS
C VARIABLES INTERNES
      REAL*8  E1SI,E1SF,E2SI,E2SF
      REAL*8  E2MIN,E2MAX
      REAL*8  E1DI(6),E1DF(6)
      REAL*8  E2DI(6),E2DF(6)
      REAL*8  SIGEFF(6),SIGE6(6),SIGEC6(6),SIGET6(6)
      REAL*8  DT6(6),DC,SUT6(6),SUC1,DT66(6,6)
      REAL*8  EVP06(6),EVP16(6),BT6(6),BC1
C VARIABLES DE CALCUL
      REAL*8  T1,T2,T4,T7,T8,T10,T13,T19,T12,A1,PI,R8PI
      INTEGER I0
C      REAL*8  PW2,PCH,ARAGM,ARAGP

C TAILLE ELEMENT
      REAL*8 T33(3,3),N33(3,3)

      REAL*8  EPSI(6),EPSF(6),SIGMA
      LOGICAL  LOCAL

      REAL*8   YYI,YYF
      REAL*8   E0DF(6)
      REAL*8   E0SF
      LOGICAL  INDIC,CPLAN
      REAL*8 COEF1,COEF2

C*********************************************************************
CC     VARIABLE LOGIQUE DE CONSOLIDATION DEVIATORIQUE
C      CONSO=.FALSE.
CC     VARIABLE LOGIQUE POUR PRISE EN COMPTE DU FLUAGE
C      FLUAGE=.TRUE.

C*********************************************************************
C       PRINT *,'FLUOR',FLUOR
C       IF (FLUOR.EQ.3) THEN
C       I0=0
C       DO I=1,64
C       T12=(1.+VIM(I0+I))**2.
C        IF (T12.GT.0.) THEN
C         IF (T12.GT.1000.0) THEN
C          PRINT *,'VIM(',I0+I,')=',VIM(I0+I)
C         END IF
C        ELSE
C         PRINT*,'VIM(',I0+I,')=',VIM(I0+I)
C        END IF
C       END DO
C       END IF
C*********************************************************************

C  **** CHARGEMENT DES PARAMETRES MATERIAU ****
C  ------- CARACTERISTIQUES ELASTIQUES
      NOMRES(1)='E'
      NOMRES(2)='NU'
      CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ', 'ELAS', 0,' ', 0.D0,
     &             2, NOMRES, VALRES, CODRET, 'F ' )

C        MODULES INSTANTANES ISOTROPES
      E0    = VALRES(1)
      NU0   = VALRES(2)
      K0    = E0/3.D0/(1.D0-2.D0*NU0)
      MU0   = E0/2.D0/(1.D0+NU0)
C
C  ------- CARACTERISTIQUES DE FLUAGE
C
      NOMRES(1)  = 'ACTIV_FL'
      NOMRES(2)  = 'K_RS'
      NOMRES(3)  = 'K_IS'
      NOMRES(4)  = 'ETA_RS'
      NOMRES(5)  = 'ETA_IS'
      NOMRES(6)  = 'K_RD'
      NOMRES(7)  = 'K_ID' 
      NOMRES(8)  = 'ETA_RD'
      NOMRES(9)  = 'ETA_ID'
      NOMRES(10) = 'EPS_0'
      NOMRES(11) = 'TAU_0'
      NOMRES(12) = 'EPS_FL_L'
C
C  ------- CARACTERISTIQUES DE L'ENDOMMAGEMENT
C
      NOMRES(13) = 'ACTIV_LO'
      NOMRES(14) = 'F_C'
      NOMRES(15) = 'F_T'
      NOMRES(16) = 'ANG_CRIT'
      NOMRES(17) = 'EPS_COMP'
      NOMRES(18) = 'EPS_TRAC'
      NOMRES(19) = 'LC_COMP'
      NOMRES(20) = 'LC_TRAC'
C
C  --- CARACTERISTIQUES DU COUPLAGE FLUIDE/SQUELETTE ET GEL/SQUELETTE
C
      NOMRES(21) = 'A_VAN_GE'
      NOMRES(22) = 'B_VAN_GE'
      NOMRES(23) = 'BIOT_EAU'
      NOMRES(24) = 'MODU_EAU'
      NOMRES(25) = 'W_EAU_0'
      NOMRES(26) = 'HYD_PRES'

C
C  ------ CARACTERISTIQUES DE LA FORMATION DES GELS
C
      NOMRES(27) = 'BIOT_GEL'
      NOMRES(28) = 'MODU_GEL'
      NOMRES(29) = 'VOL_GEL'
      NOMRES(30) = 'AVANC_LI'
      NOMRES(31) = 'PARA_CIN'
      NOMRES(32) = 'ENR_AC_G'
      NOMRES(33) = 'SEUIL_SR'
C
C  ------- AFFECTATION DES PARAMETRES DE FLUAGE
C
C          FLUAGE : 1  PRISE EN COMPTE DU FLUAGE
C                  AUTRE  PAS DE FLUAGE
C          CONSO : 1  PRISE EN COMPTE DE LA CONSOLIDATION
C                 AUTRE  PAS DE CONSOLIDATION
C          LOC : 1 PRISE EN COMPTE LOCALISATION

      CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ', 'BETON_RAG', 0,' ', RBID,
     &             33, NOMRES, VALRES, CODRET, 'F ' )

      IF (VALRES(1).EQ.1.0D0) THEN
      FLUAGE=.TRUE.
      ELSE
      FLUAGE=.FALSE.
      ENDIF
C PLUS DE LOI DE CONSOLIDATION
C      IF (VALRES(2).EQ.1.0D0) THEN
C      CONSO=.TRUE.
C      ELSE
C      CONSO=.FALSE.
C      ENDIF
C      FLUAGE = VALRES(1)
C      CONSO = VALRES(2)
C  MODULES DE COMPRESSIBILITE DIFFERES
C  (K1 POUR LA PARTIE REVERSIBLE ET K2 IRREVERSIBLE)
      K1 = VALRES(2)
      K2 = VALRES(3)
C VISCOSITES SPHERIQUES
C (ETA1S POUR LA PARTIE REVERSIBLE ET ETA2S IRREVERSIBLE)
      ETA1S = VALRES(4)
      ETA2S = VALRES(5)
C        MODULES DE CISAILLEMENT DIFFERES
      MU1 = VALRES(6)  
      MU2 = VALRES(7)
C VISCOSITES DEVIATORIQUES
C (ETA1D POUR LA PARTIE REVERSIBLE ET ETA2D IRREVERSIBLE)
      ETA1D = VALRES(8)
C        VISCOSITE FLUAGE DEVIATORIQUE IRREVERSIBLE
      ETA2D = VALRES(9)
C        EXPOSANT DE LA LOIS DE CONSOLIDATION
C      EKD1 = VALRES(10)
C        DEF CARACT CONSOLIDATION DEVIATORIQUE ETAGE 1 ET 2
C      EKD2 = VALRES(11)
C DEFORMATION CARACTERISTIQUE
C DE VISCOPLASTICITE COUPLE ENDOMMAGEMENT DE TRACTION
      EPS0 = VALRES(10)
C     TEMPS CARACTERISTIQUE DU FLAUGE ORTHOTROPE DE TRACTION
      TAU0 = VALRES(11)
C DEFORMATION LIMITE DE FLUAGE ORTHOTROPE DE TRACTION
      EVPMAX = VALRES(12)
C  ------- AFFECTATION DES PARAMETRES D'ENDOMMAGEMENT
C ACTIVATION DE LA LOCALISATION
      IF (VALRES(13).EQ.1.0D0) THEN
      LOCAL=.TRUE.
      ELSE
      LOCAL=.FALSE.
      ENDIF
C     RESISTANCE DU BETON
      RC = VALRES(14)
      RT = VALRES(15)
C        CARACTERISTIQUES DU CRITERE DE COMPRESSION
C     ANGLE DU CRITERE DE DRUCKER PRAGER
C     + CONVERSION DE DEGRES EN RADIANS
      DELTA = VALRES(16)
      PI = R8PI()
      DELTA = DELTA*PI/180.D0
C        EXPOSANT DES LOIS D ENDOMMAGEMENT
      EDPICC = VALRES(17)
      EDPICT = VALRES(18)
      DPICC0=1.D0-(RC/(E0*EDPICC))
      DPICT0=1.D0-(RT/(E0*EDPICT))


C      COHESION DES LOIS D'ENDOMMAGEMENT
C      FORTRAN POUR MT
      T1 = (NU0 ** 2)
      T7 = LOG((1D0 - DPICT0))
      T12 = (1-NU0-2.D0*T1+2*T1*DPICT0)/T7/(-1.D0+NU0)
      XMT=T12
      IF (XMT.GT.2.5D0) THEN
         XMT=2.5D0
      END IF
C      FORTRAN POUR SUT
      T1 = NU0 ** 2
      T2 = 2 * T1
      T4 = 2 * T1 * DPICT0
      T8 = LOG(1 - DPICT0)
      T10 = LOG(-T8 * XMT)
      T13 = EXP(T10 / XMT)
      T19 = RT*(1-NU0-T2+T4)/T13/(1-NU0-T2-DPICT0
     #+ NU0 * DPICT0 + T4)
      SUT=T19

C      FORTRAN POUR MC
      XMC=-1.D0/LOG(1.D0-DPICC0)
C      FORTRAN POUR SUC
      SUC=RC*(SQRT(3.D0)-DELTA)/3.D0/EXP(-1.D0/XMC)


C        LONGUEUR INTERNES EN TRACTION ET COMPRESSION
      LCC = VALRES(19)
      LCT = VALRES(20)

C CHARGEMENT DE LA TAILLE DES ELEMENTS
C TRAITEMENT LOCAL LI=1, LC DONNE LE RAPPORT 1/LC####
C EXEMPLE SI LC=0.30 POUR LI=0.5, LI/LC=1.667 DONC LA LC=0.60
      DO 50 I=1,3
       DO 40 J=1,3
        T33(I,J) = 0.0D0
        N33(I,J) = 0.0D0
 40    CONTINUE
 50   CONTINUE
      DO 60 I=1,3
        T33(I,I) = 1.0D0
        N33(I,I) = 1.0D0
 60   CONTINUE
C  ---- CARACTERISTIQUES DU COUPLAGE FLUIDE/SQUELETTE ET GEL/SQUELETTE
C
C        MILIEU NON SATURE PARAMETRES DE VAN GENUCHTEN
      AVG = VALRES(21)
      BVG = VALRES(22)
C        NOMBRE DE BIO ET MODULE DE BIO DE L'EAU
      BWMAX = VALRES(23)
      MW = VALRES(24)
C TENEUR EN EAU INITIALE
      W0 = VALRES(25)
      IF (W0.EQ.0.D0) THEN
      W0 = 1.0D0
      END IF
C INDICATEUR DE CALCUL PAR PRESSION IMPOS�
      IF (VALRES(26).EQ.1.D0) THEN
        PRESSN=.TRUE.
      ELSE
        PRESSN=.FALSE.
      END IF
C        DEGRE DE SATURATION 
      IF (PRESSN) THEN
C      PRINT *,'LE CALCUL EST DIRECTEMENT EN PRESSION'
         PW3 = (0.5D0*(SECHM+SECHP))
         IF (PW3.LT.0.D0) THEN
            PWC=-PW3
            MM=1/BVG
            XX=(1+(PWC/AVG)**(1/(1-MM)))**(-MM)
            SR=XX
         ELSE
            SR=1.D0
         END IF
      ELSE
C      PRINT *,'LE CALCUL SE FAIT EN CONCENTRATION'
        SR = (0.5D0*(SECHM+SECHP))/W0
      END IF
      IF (SR.GT.1.0001D0) THEN
        VALR(1) = SR
        VALR(2) = SECHM
        VALR(3) = SECHP
        VALR(4) = W0
        CALL U2MESR('A','COMPOR1_63',4,VALR)
        SR = 1.D0
      END IF
      IF (SR.LT.0.0D0) THEN
        VALR(1) = SR
        VALR(2) = SECHM
        VALR(3) = SECHP
        VALR(4) = W0
        CALL U2MESR('A','COMPOR1_64',4,VALR)
        SR = 0.D0
      END IF

C
C  ------ AFFECTATION DES PARAMETRESRELATIFS A LA FORMATION DES GELS
C        NOMBRE DE BIOT ET MODULE DE BIOT DE LA PHASE CHIMIQUE NEOFORMEE
      BCHMAX = VALRES(27)
      MCH = VALRES(28)
C      VOLUME DE GEL MAXI POUVANT ETRE CREE
      VG = VALRES(29)
C      AVANCEMENT LIBRE
      A0 = VALRES(30)
C      PARAMETRE DE CINETIQUE
      ALP0 = VALRES(31)
C      ENERGIE D'ACTIVATION DES GELS
      EA = VALRES(32)
      R = 8.12D0
C      SEUIL SR MINI POUR QUE LA RAG SOIT POSSIBLE
      SR0 = VALRES(33)
C CALCU DE EPSI ET EPSF
C ATTENTION ON TRAVAILLE AVEC DES GAMMA POUR I>3
      DO 70 J=1,6
       EPSTI(J)=EPSM(J)
       EPSTF(J)=EPSM(J)+DEPS(J)
 70   CONTINUE
      DO 80 J=4,6
        EPSTI(J)=EPSTI(J)*SQRT(2.D0)
        EPSTF(J)=EPSTF(J)*SQRT(2.D0)
 80   CONTINUE
C     APPORTS DE MASSE NORMALISES  ********** A CORRIGER ***********
C      WW=XMAT(22)
      WW = 0.0D0
      TMABS=TM+273.15D0
      TPABS=TP+273.15D0
      TRFABS=TREF+273.15D0
      TPC = 0.5D0*(TMABS+TPABS)
C ATTENTION IL FAUT TREF

      IF (INSTAM.EQ.0.D0) THEN
        ARAGM=0.D0
      ELSE
        ARAGM=VIM(31)
      ENDIF
C CALCUL DE L'AVANCEMENT DE LA RAG

C      X00=-1*ALP0*EXP((EA/R)*(1/TRFABS-1/TPC))*SR*(INSTAP-INSTAM)
      XX=SR-SR0
      XX=0.5D0*(XX+ABS(XX))
      XX=XX/(1-SR0)
      X00=-1*ALP0*EXP((EA/R)*(1/TRFABS-1/TPC))*XX*(INSTAP-INSTAM)

      F00=EXP(X00)
      IF ((SR-ARAGM).GT.0.D0) THEN
       ARAGP=SR-(SR-ARAGM)*F00
      ELSE
       ARAGP=ARAGM
      ENDIF
      IF (ARAGP.GT.ARAGM) THEN
       VIP(31)=ARAGP
      ELSE
       VIP(31)=ARAGM
      END IF

C CALCUL DE L'AVANCEMENT AU MILIEU DU PAS DE TEMPS
      ARAG=0.5D0*(ARAGM+ARAGP)
C

C       *** INITIALISATION PAS DE TEMPS 

      DT=INSTAP-INSTAM

C     *** PRESSIONS ***********************************

C     **** EVOLUTION DE LA DEFORMATION SPHERIQUE ****

C        CALCUL DE DV/V=TR(EPSF) OU TR(EPSI)
      YYF=0.D0
      YYI=0.D0
      DO 90 I=1,3
       YYF=YYF+EPSTF(I)
       YYI=YYI+EPSTI(I)
C       PRINT*,EPSTI(I),EPSTF(I)
 90   CONTINUE
C      PRINT*, YYI,YYF

C     ON PEUT AMELIORER EN SUPPOSANT PW(T)=APW*T+BPW DANS 
C     L'INTEGRATION DES EQUATIONS VISCO ELASTIQUES....SPHERIQUES

C        CALCUL DE LA PRESSION CHIMIQUE AU MILIEU DU PAS DE TEMPS
C      XX=VG-BCH*(YYF+YYI)/2.0
C MODIFICATION DE BCH POUR ETRE COMME LA POROM�CANIQUE
      BCH=BCHMAX
C      BCH=BWMAX*(1-(0.5*((A0-ARAG)+ABS(A0-ARAG))))
C      BCH=BWMAX*ARAG
      XX=(A0*VG)+BCH*((YYF+YYI)/2.D0)
      XX=0.5D0*(XX+ABS(XX))
      AVRAG=(ARAG*VG-XX)
C      AVRAG=(ARAG-A0)
      AVRAG=0.5D0*(AVRAG+ABS(AVRAG))
C     PCH=AVRAG*MCH*XX
      PCH=AVRAG*MCH
C      XX=WCH-BCH*YYF
C      XX=0.5D0*(XX+ABS(XX))
C      IF (ARAGM.GT.A0) THEN
C       PCH=MCH*XX
C      ELSE
C       PCH=0.0D0
C      END IF

C  CALCUL DE TR EPS RAG MAXIMUM
      XX=(ARAG*VG-A0*VG)
      XX=0.5D0*(XX+ABS(XX))
      IF(BCH.EQ.0.D0)THEN
       ERAGMX=0.0D0
      ELSE
       ERAGMX=XX/BCH
      ENDIF
C      PRINT*,'ERAGMX',ERAGMX


C     CALCUL DE LA PRESSION HYDRIQUE (SI HORS CADRE HM)AVEC LA DEF
C     A LA FIN DU PAS DE TEMPS (PW2) ET AU MILIEU (PW1)
C     POUR AVOIR UNE MEILLEURE PRECISION SUR LE RETRAIT
      BW=SR*BWMAX
      IF(SR.GT.0.99999D0)THEN
       XX=(WW-BW*0.5D0*(YYF+YYI))
       XX=0.5D0*(XX+ABS(XX))
C       PW1=MW*XX
       XX=(WW-BW*(YYF))
       XX=0.5D0*(XX+ABS(XX))
       PW2=MW*XX
      ELSE
       IF (SR.LT.1D-3)THEN
        SR=1.D-3
       END IF
C        MILIEU NON SATURE ON UTILISE LA RELATION DE VAN GENUCHTEN
C        POUR CALCULER LA PRESSION CAPILLAIRE (EN MPA)
       PC=AVG*(SR**(-BVG)-1.D0)**(1.D0-1.D0/BVG)

C   ET ON SUPPOSE QUE PC N AGIT PLUS DIRECTEMENT SUR LEMILIEU EXTERIEUR 
C   MAIS UNIQUEMENT PAR DEPRESSION CAPILLAIRE SUR LES ETAGES VISQUEUX
C   SPHERIQUES
       PW2=-PC
C       PW1=0.5D0*(PW2+VIM(29))
C      ENDOMMAGEMENT MICRO PAR DEPRESSION CAPILLAIRE
C      IL SERA FONCTION DE L ETAT DE CONTRAINTE EFFECTIVE SPHERIQUE
      END IF
C     STOCKAGE DES PRESSIONS  A LA FIN DU PAS DE TEMPS DANS LES VIM 
      VIP(29)=PW2
      VIP(30)=PCH
      VIP(65)=BCH*PCH

      IF(FLUAGE)THEN

C     **** FLUAGE ORTHOTROPE DE TRACTION *************

C     SEUIL D ENDOMMAGEMENT DE TRACTION DU PAS PRECEDENT
      SUT6(1)=VIM(22)
      SUT6(2)=VIM(23)
      SUT6(3)=VIM(24)
      SUT6(4)=VIM(25)
      SUT6(5)=VIM(26)
      SUT6(6)=VIM(27)
C     CONTRAINTES EFFECTIVES DU PAS PRECEDENT
      SIGE6(1)=VIM(46)
      SIGE6(2)=VIM(47)
      SIGE6(3)=VIM(48)
      SIGE6(4)=VIM(49)
      SIGE6(5)=VIM(50)
      SIGE6(6)=VIM(51)
C     DEFORMATIONS VISCOPLASTIQUES AU PAS PRECEDENT
      EVP06(1)=VIM(52)
      EVP06(2)=VIM(53)
      EVP06(3)=VIM(54)
      EVP06(4)=VIM(55)
      EVP06(5)=VIM(56)
      EVP06(6)=VIM(57)
      IF (FLUOR.EQ.1) THEN
        CALL BRFLUO(SUT,SUT6,XMT,SIGE6,EPS0,
     #  TAU0,DT,EVP06,EVP16,DEVPT,EVPMAX,(BCH*PCH),ERAGMX)
        DO 100 I=1,6
           EVP16(I)=EVP06(I)+DEVPT(I)*DT
 100    CONTINUE
      END IF

      IF (FLUOR.EQ.2) THEN
        CALL BRFLUO(SUT,SUT6,XMT,SIGE6,EPS0,
     #  TAU0,DT,EVP06,EVP16,DEVPT,EVPMAX,(BCH*PCH),ERAGMX)
        GO TO 210
      END IF

      IF (FLUOR.EQ.3) THEN
        DO 110 I=1,6
           EVP16(I)=EVP06(I)+DEVPT(I)*DT
 110    CONTINUE
      END IF
C   STOCKAGE DES DEFORMATIONS VISCOPLASTIQUES DE TRACTION EN FIN DE PAS

      VIP(52)=EVP16(1)
      VIP(53)=EVP16(2)
      VIP(54)=EVP16(3)
      VIP(55)=EVP16(4)
      VIP(56)=EVP16(5)
      VIP(57)=EVP16(6)
C     **** PARTITION DU TENSEUR DES DEFORMATIONS POUR LA RHEOLOGIE ****
      DO 120 I=1,6
       EPSI(I)=EPSTI(I)-EVP06(I)
       EPSF(I)=EPSTF(I)-EVP16(I)
 120  CONTINUE

C     *** FLUAGE SPHERIQUE *****************************

C        CALCUL DE DV/V=TR(EPSF) OU TR(EPSI)
      YYF=0.D0
      YYI=0.D0
      DO 130 I=1,3
       YYF=YYF+EPSF(I)
       YYI=YYI+EPSI(I)
 130  CONTINUE

C        CHARGEMENT DES VARIABLES INTERNES POUR LA PARTIE SPHERIQUE
      E1SI=VIM(1)
      E2SI=VIM(2)
      E2MIN=VIM(32)
      E2MAX=VIM(33)
C        EVOLUTION DES DEFORMATIONS VISCO-ELASTIQUES SPHERIQUE 
      AA=YYF-YYI
      BB=YYI
      DES=AA
      IF(DT.EQ.0.D0)THEN
       PRINT*, 'DT NULL IN BETON3.FOR!'
       PRINT*, 'TR DEPS : ',YYF
       AA=0.D0
       BB=YYF
      ELSE
       AA=AA/DT
      END IF
C      PRINT*,''
C      PRINT*,'E1SI',E1SI,'E2SI',E2SI,'AA',AA,'DT',DT
C      PRINT*,'BB',BB,'K0',K0,'K1',K1,'ETA1S',ETA1S
C      PRINT*,'K2',K2,'ETA2S',ETA2S,'PW1',PW1,'E0SF',E0SF
C      PRINT*,'E1SF',E1SF,'E2SF',E2SF,'E2MIN',E2MIN
C      PRINT*,'E2MAX',E2MAX,'SE2SPH1',SE2SP1
C      CALL BRDEFV(E1SI,E2SI,AA,DT,BB,K0,K1,ETA1S,
C     #K2,ETA2S,PW1,E0SF,E1SF,E2SF,E2MIN,E2MAX,SE2SP1)
      CALL BRDEFV(E1SI,E2SI,AA,DT,BB,K0,K1,ETA1S,
     #K2,ETA2S,0.0D0,E0SF,E1SF,E2SF,E2MIN,E2MAX,SE2SP1)
      
C      PRINT*,''
C      PRINT*,'FLUAGE SPHERIQUE'
C      PRINT*,AA,BB
C      PRINT*,'E0SF',E0SF,' E1SF',E1SF,' E2SF',E2SF
C      READ(*,*)
C        MISE A JOUR DES VARIABLES INTERNES POUR LA PARTIE SPHERIQUE
      VIP(1)=E1SF
      VIP(2)=E2SF
      VIP(32)=E2MIN
      VIP(33)=E2MAX

C     *** CONSOLIDATION FLUAGE DEVIATORIQUE / SPHERIQUE ******

C      IF (CONSO)THEN
C        CC1=EXP(-0.5*(E1SF+E1SI)/EKD1)
C        MU1=XMAT00(NMAT+12)*CC1
C        ETA1D=XMAT00(NMAT+13)*CC1
C        CC2=EXP(-0.5*(E2SF+E2SI)/EKD2)
C        CC2=MAX(1.-0.5*(E2SF+E2SI)/EKD2,1.)
C         ESX=-0.5*(E2SF+E2SI)
C         IF(ESX.GT.0.)THEN
C          CC2=MAX(1.,(ESX/EKD2)**(EKD1))
C         ELSE
C          CC2=1.
C         END IF
C         ETA2D=XMAT00(NMAT+14)*CC2
C        ETA1D=XMAT00(NMAT+13)*CC2
C      END IF

C       *** FLUAGE DEVIATORIQUE ***************************

C        ON BOUCLE SUR LES 6 DEFORMATIONS DEVIATORIQUES
        DO 140 J=1,6
C         CHARGEMENT DES VARIBLES INTERNES POUR LA PARTIE DEVIATORIQUE
        E1DI(J)=VIM(2+(J-1)*2+1)
        E2DI(J)=VIM(2+(J-1)*2+2)
        E2MIN=VIM(33+(J-1)*2+1)
        E2MAX=VIM(33+(J-1)*2+2)

C         VITESSE DE GLISSEMENT IMPOSEE 
C         (ATTENTION ON TRAVAILLE AVEC LES GAMMA POUR J>3...)
        IF (J.LE.3)THEN
         DED=2.D0*((EPSF(J)-EPSI(J))-DES/3.D0)
        ELSE
         DED=(EPSF(J)-EPSI(J))
        END IF
        IF(DT.EQ.0.D0)THEN
         PRINT*, 'DT NULL IN BETON3D.FOR!'
         IF(J.LE.3)THEN
          AA=0.D0
          BB=2.D0*(EPSF(J)-YYF/3.D0)
         ELSE
          AA=0.D0
          BB=EPSF(J)
         END IF
        ELSE
         IF (J.LE.3)THEN
          BB=2.D0*(EPSI(J)-YYI/3.D0)
         ELSE
          BB=EPSI(J)
         END IF
         AA=DED/DT
        END IF

        CALL BRDEFV(E1DI(J),E2DI(J),AA,DT,BB,MU0,
     S  MU1,ETA1D,MU2,ETA2D,0.D0,E0DF(J),E1DF(J),
     S  E2DF(J),E2MIN,E2MAX,SE2DV6(J))

C        MISE A JOUR DES VARIBLES INTERNES POUR LA PARTIE DEVIATORIQUE
        VIP(2+(J-1)*2+1)=E1DF(J)
        VIP(2+(J-1)*2+2)=E2DF(J)
        VIP(33+(J-1)*2+1)=E2MIN
        VIP(33+(J-1)*2+2)=E2MAX

 140    CONTINUE

      ELSE
C      PRINT *,'PAS FLUAGE'
C      SI FLUAGE=.FALSE. : CALCUL ELASTIQUE CLASSIQUE (LES COMPOSANTES
C                          VISQUEUSES SONT NULLES)      
       E0SF=0.D0
       DO 150 I=1,3
        E0SF=E0SF+EPSTF(I)
 150   CONTINUE
       DO 160 I=1,6
        IF(I.LE.3)THEN
         E0DF(I)=2.D0*(EPSTF(I)-E0SF/3.D0)
        ELSE
         E0DF(I)=EPSTF(I)
        END IF
 160   CONTINUE

      END IF

C       *** CALCUL DES CONTRAINTES EFFECTIVES NIVEAU 0***************
      CALL BRSEFF(K0,MU0,E0SF,E0DF,SIGEFF)

C        STOCKAGE DES CONTRAINTES EFFECTIVES EN FIN DE PAS
      VIP(46)=SIGEFF(1)
      VIP(47)=SIGEFF(2)
      VIP(48)=SIGEFF(3)
      VIP(49)=SIGEFF(4)
      VIP(50)=SIGEFF(5)
      VIP(51)=SIGEFF(6)


C     *** ENDOMMAGEMENTS NIVEAU 0 *********************************
C     ** ENDOMMAGEMENTS MACROSCOPIQUES ******************************

C        CHARGEMENT DES ENDOMMAGEMENTS DU PAS PRECEDENT
      DT6(1)=VIM(15)
      DT6(2)=VIM(16)
      DT6(3)=VIM(17)
      DT6(4)=VIM(18)
      DT6(5)=VIM(19)
      DT6(6)=VIM(20)
      DC=VIM(21)
      SUT6(1)=VIM(22)
      SUT6(2)=VIM(23)
      SUT6(3)=VIM(24)
      SUT6(4)=VIM(25)
      SUT6(5)=VIM(26)
      SUT6(6)=VIM(27)
      SUC1=VIM(28)

C     CHARGEMENT DES VARIABLES INTERNES D ENDOMMAGEMENT MACROSCOPIQUE
      I0=57
      DO 170 I=1,6
       BT6(I)=VIM(I0+I)
 170  CONTINUE
      BC1=VIM(64)

C       ON CHARGE LES CONTRAINTES DANS SIGE6 QUI EST MODIFIEE
C        PAR LA PROCEDURE DE TRAITEMENT DE LOCALISATION SI LOCAL=VRAI
      DO 180 J=1,6
        SIGE6(J)=SIGEFF(J)
 180  CONTINUE
      CALL BRENDO(SIGE6,BT6,SUT,BC1,SUC,LOCAL,
     #T33,N33,LCT,BW,PW2,BCH,PCH,DELTA,LCC,XMT,XMC,
     #SIGET6,SIGEC6,NU0,DT66,DC,SUT6,SUC1,SIGP,DT6)

C      CALL ENDO_BETON(SUT,XMT,LCT,BETA,DELTA,SC,SUC,XMC,LCC,
C     #SIGE6,DT6,DC,LOCAL,T33,N33,.TRUE.,SUT6,SUC1,INDIC,
C     # BW,PW2,BCH,PCH)


CC       ***** CALCUL DES CONTRAINTES APPARENTES **********
C      CALL SIG_APP(SRT,XP,ALPHATC,ALPHACT,SIGE6,DT6,DC,SIGP,
C     S  SUT6,SUC1,XMT,SUT,XMC,SUC,BW,PW2,BCH,PCH,SIGEXT6)
CC      PRINT *,'SIGE6',SIGE6
CC      CALL SIG_APP(SRT,XP,ALPHATC,ALPHACT,SIGE6,DT6,
CC     S DC,SIGP,SUT6,SUC1,XMT,SUT,XMC,SUC,BW,PW2,BCH,
CC     S PCH,SIGEXT6,SUCLT,SUTLT,SUCF,SUTF,XMCLT,XMTLT)


C       ***** MISE A JOUR DES VARIBLES INTERNES D ENDOMMAGEMENT *****
      I0=57
      DO 190 I=1,6
       VIP(I0+I)=BT6(I)
 190  CONTINUE
      VIP(64)=BC1

      VIP(15)=DT6(1)
      VIP(16)=DT6(2)
      VIP(17)=DT6(3)
      VIP(18)=DT6(4)
      VIP(19)=DT6(5)
      VIP(20)=DT6(6)
      VIP(21)=DC
      VIP(22)=SUT6(1)
      VIP(23)=SUT6(2)
      VIP(24)=SUT6(3)
      VIP(25)=SUT6(4)
      VIP(26)=SUT6(5)
      VIP(27)=SUT6(6)
      VIP(28)=SUC1

      DO 200 I=4,6
         SIGP(I)=SIGP(I)*SQRT(2.D0)
         EPSTF(I)=EPSTF(I)/2.D0*SQRT(2.D0)
 200  CONTINUE
 210  CONTINUE
C*****************************************************************
      END
