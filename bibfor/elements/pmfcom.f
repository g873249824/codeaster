      SUBROUTINE PMFCOM(OPTION,COMPOR,CRIT,
     &                  NF,
     &                  INSTAM,INSTAP,
     &                  TEMPM,TEMPP,TREF,
     &                  IRRAM,IRRAP,
     &                  E,ALPHA,
     &                  ICDMAT,NBVALC,
     &                  DEFAM,DEFAP,
     &                  VARIM,VARIMP,
     &                  CONTM,DEFM,DEFP,
     &                  EPSM,CORRM,CORRP,
     &                  MODF,SIGF,VARIP,ISECAN,CODRET) 

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/12/2004   AUTEUR VABHHTS J.PELLET 
C TOLE CRP_21
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
      IMPLICIT NONE
      CHARACTER*16 OPTION,COMPOR(*),COMPO
      INTEGER NF,ICDMAT,NBVALC,ISECAN
      REAL*8 E,VARIM(NBVALC*NF),CONTM(NF),DEFM(NF),DEFP(NF),MODF(NF),
     +       SIGF(NF),VARIMP(NBVALC*NF),VARIP(NBVALC*NF),CORRM
      REAL*8 TEMPM,TEMPP,ALPHA,DSIDEP,TREF,SIGX,SIGXP,EPSX,DEPSX,CORRP
      REAL*8 CRIT(*),INSTAM,INSTAP,IRRAM,IRRAP
      REAL*8 DEFAP(*), DEFAM(*)
C     ------------------------------------------------------------------
C     AIGUILLAGE COMPORTEMENT DES ELEMENTS DE POUTRE MULTIFIBRES

C IN  COMPO : NOM DU COMPORTEMENT
C IN  CRIT  : CRITERES DE CONVERGENCE LOCAUX
C IN  NF    : NOMBRE DE FIBRES
C IN  INSTAM: INSTANT DU CALCUL PRECEDENT
C IN  INSTAP: INSTANT DU CALCUL
C IN  IRRAM: IRRADIATION DU CALCUL PRECEDENT
C IN  IRRAP: IRRADIATION DU CALCUL
C IN  E     : MODULE D'YOUNG (ELASTIQUE)
C IN  ICDMAT: CODE MATERIAU
C IN  NV    : NOMBRE DE VARIABLES INTERNES DU MODELE
C IN  VARIM : VARIABLES INTERNES MOINS
C IN  VARIMP: VARIABLES INTERNES ITERATION PRECEDENTE (POUR DEBORST)
C IN  DEFAM   : DEFORMATIONS ANELASTIQUES A L'INSTANT PRECEDENT
C IN  DEFAP   : DEFORMATIONS ANELASTIQUES A L'INSTANT DU CALCUL
C IN  CONTM : CONTRAINTES MOINS (ATTENTION POUR L'INSTANT EFGEGA ET
C              PAS PAR FIBRE !)
C IN  DEFM  : DEFORMATION  A L'INSTANT DU CALCUL PRECEDENT
C IN  DEFP  : INCREMENT DE DEFORMATION
C IN  CORRM : CORROSION A L'INSTANT PRECEDENT
C IN  CORRP : CORROSION A L'INSTANT DU CALCUL
C IN  EPSM  : DEFORMATION A L'INSTANT PRECEDENT
C OUT MODF  : MODULE TANGENT DES FIBRES
C OUT SIGF  : CONTRAINTE A L'INSTANT ACTUEL DES FIBRES
C OUT VARIP : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT ISECAN: 
C     ------------------------------------------------------------------

      INTEGER NBVAL,NBPAR,NBRES,NBVARI,CODREF
      PARAMETER (NBVAL=12)
      REAL*8 VALPAR,VALRES(NBVAL),ALPHAM,ALPHAP,EP,EM
      CHARACTER*2 ARRET,RETOUR,CODRES(NBVAL)
      CHARACTER*8 NOMPAR,NOECLB(9),NOMPIM(12)
      REAL*8 A1,A2,BETA1,BETA2,Y01,Y02,B1,B2,SIGF1
      REAL*8 CSTPM(13),EPSM,ANGMAS(3),R8VIDE
      INTEGER    NBCLMA, NBCLEM, NBCVIL, NBCCYR,NBCEPR,NBCINT
      PARAMETER (NBCLMA=12,NBCLEM=7,NBCVIL=5,NBCCYR=3,NBCEPR=3,NBCINT=2)
      REAL*8     COELMA(NBCLMA),COELEM(NBCLEM),COEVIL(NBCVIL)
      REAL*8     COECYR(NBCCYR),COEEPR(NBCEPR),COEINT(NBCINT)
      INTEGER I,IVARI,CODRET,ICAS
      DATA ARRET,RETOUR/'FM','  '/
      DATA NOECLB/'Y01','Y02','A1','A2','B1','B2','BETA1','BETA2',
     +     'SIGF'/
      DATA NOMPIM/'SY','EPSI_ULTM','SIGM_ULTM','EPSP_HARD','R_PM',
     +     'EP_SUR_E','A1_PM','A2_PM','ELAN','A6_PM','C_PM','A_PM'/
     
      COMPO=COMPOR(1)

C     EVALUATION DU MODULE SECANT 
      ISECAN = 0

C --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C --- INITIALISE A R8VIDE() (ON NE S'EN SERT PAS)
      CALL R8INIR(3,  R8VIDE(), ANGMAS ,1)
      IF (COMPO.EQ.'ELAS') THEN
        DO 10 I = 1,NF
          MODF(I) = E
          SIGF(I) = E* (DEFM(I)+DEFP(I))
   10   CONTINUE
      ELSE IF (COMPO.EQ.'LABORD_1D') THEN
C ---   ON RECUPERE LES PARAMETRES MATERIAU
        CALL R8INIR(NBVAL,0.D0,VALRES,1)
        NBPAR = 0
        NOMPAR = '  '
        VALPAR = 0.D0
        NBRES = 9
        CALL RCVALA(ICDMAT,' ','LABORD_1D',NBPAR,NOMPAR,VALPAR,NBRES,
     +              NOECLB,VALRES,CODRES,ARRET)
        Y01 = VALRES(1)
        Y02 = VALRES(2)
        A1 = VALRES(3)
        A2 = VALRES(4)
        B1 = VALRES(5)
        B2 = VALRES(6)
        BETA1 = VALRES(7)
        BETA2 = VALRES(8)
        SIGF1 = VALRES(9)

C ---   BOUCLE COMPORTEMENT SUR CHAQUE FIBRE
        DO 20 I = 1,NF
          IVARI = NBVALC* (I-1) + 1
          CALL NMCB1D(E,Y01,Y02,A1,A2,B1,B2,BETA1,BETA2,SIGF1,ALPHA,
     +                TREF,TEMPP,CONTM(I),VARIM(IVARI),DEFM(I),
     +                DEFP(I),MODF(I),SIGF(I),VARIP(IVARI))
   20   CONTINUE
      ELSE IF (COMPO.EQ.'PINTO_MENEGOTTO') THEN
        NBRES = 12
        CALL R8INIR(NBVAL,0.D0,VALRES,1)
        NBPAR = 0
        NOMPAR = '  '
        VALPAR = 0.D0
        CALL RCVALA(ICDMAT,' ','PINTO_MENEGOTTO',NBPAR,NOMPAR,VALPAR,
     +              NBRES,NOMPIM,VALRES,CODRES,RETOUR)
        IF (CODRES(7).NE.'OK') VALRES(7) = -1.D0
        CSTPM(1) = E
        DO 30 I = 1,12
          CSTPM(I+1) = VALRES(I)
   30   CONTINUE
        DO 40 I = 1,NF
          IVARI = NBVALC* (I-1) + 1
          CALL NM1DPM(OPTION,NBVALC,ALPHA,TEMPM,13,CSTPM,CONTM(I),
     +                VARIM(IVARI),TEMPP,DEFP(I),VARIP(IVARI),SIGF(I),
     +                MODF(I))
   40   CONTINUE

      ELSE IF (COMPO.EQ.'VMIS_ISOT_LINE' .OR.
     +         (COMPO.EQ.'VMIS_CINE_LINE') .OR.
     +           (COMPO.EQ.'CORR_ACIER' )) THEN
      NBPAR = 1
      NOMPAR = 'TEMP'

C --- CARACTERISTIQUES ELASTIQUES A TMOINS

      VALPAR = TEMPM
      CALL RCVALA(ICDMAT,' ','ELAS',NBPAR,NOMPAR,VALPAR,1,'E',EM,CODRES,
     & ARRET)
      CALL RCVALA(ICDMAT,' ','ELAS',NBPAR,NOMPAR,VALPAR,1,'ALPHA',
     &            ALPHAM,CODRES,RETOUR)
      IF (CODRES(1).NE.'OK') ALPHAM = 0.D0

C --- CARACTERISTIQUES ELASTIQUES A TPLUS

      VALPAR = TEMPP
      CALL RCVALA(ICDMAT,' ','ELAS',NBPAR,NOMPAR,VALPAR,1,'E',EP,CODRES,
     &            ARRET)
      CALL RCVALA(ICDMAT,' ','ELAS',NBPAR,NOMPAR,VALPAR,1,'ALPHA',
     &            ALPHAP,CODRES,RETOUR)
      IF (CODRES(1).NE.'OK') ALPHAP = 0.D0
        IF (COMPO.EQ.'VMIS_CINE_LINE') THEN
          DO 50 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
        CALL NM1DCI(ICDMAT,TEMPM,TEMPP,TREF,EM,EP,ALPHAM,ALPHAP,CONTM(I)
     &       ,DEFP(I),VARIM(IVARI),OPTION,SIGF(I),VARIP(IVARI),MODF(I))
   50     CONTINUE
        ELSE IF (COMPO.EQ.'VMIS_ISOT_LINE') THEN
          DO 60 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
        CALL NM1DIS(ICDMAT,TEMPM,TEMPP,TREF,EM,EP,ALPHAM,ALPHAP,CONTM(I)
     & ,DEFP(I),VARIM(IVARI),OPTION,COMPO,SIGF(I),VARIP(IVARI),MODF(I))
   60     CONTINUE
        ELSE IF (COMPO.EQ.'CORR_ACIER') THEN
        DO 65 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            
       CALL NM1DCO(OPTION,ICDMAT,TEMPM,TEMPP,EP,CONTM(I),EPSM,
     &       DEFP(I),VARIM(IVARI),SIGF(I),VARIP(IVARI),MODF(I),
     &       CORRM,CORRP)   
   65      CONTINUE     
        END IF
      ELSE IF (COMPO.EQ.'VMIS_ISOT_TRAC') THEN
        DO 55 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            CALL NM1TRA(ICDMAT,TEMPP,DEFM(I),DEFP(I),
     +                  VARIM(IVARI),VARIM(IVARI+1),
     +                  SIGF(I),VARIP(IVARI),VARIP(IVARI+1),MODF(I))
55      CONTINUE
      ELSE IF (COMPO.EQ.'ASSE_COMBU') THEN
        IF (COMPOR(5)(1:10).EQ.'ANALYTIQUE') THEN
C       RECUPERATION DES CARACTERISTIQUES DES LOIS DE FLUAGE            
        CALL NMASSC(ICDMAT,
     &              '  ',R8VIDE(),R8VIDE(),'  ',
     &              COELMA,COELEM,COEVIL,COECYR,COEEPR,COEINT,
     &              ICAS)

          IF (ICAS.EQ.3) THEN
            DO 56 I = 1,NF
              IVARI = NBVALC* (I-1) + 1

              CALL NM1VIL(ICDMAT,CRIT,
     &                   INSTAM,INSTAP,
     &                   TEMPM,TEMPP,TREF,                
     &                   IRRAM,IRRAP,
     &                   DEFP(I),
     &                   CONTM(I),VARIM(IVARI),
     &                   OPTION,
     &                   DEFAM(1),DEFAP(1),
     &                   ANGMAS,
     &                   SIGF(I),VARIP(IVARI),MODF(I))
56          CONTINUE

          ELSEIF (ICAS.EQ.6) THEN
              CALL UTMESS('F','PMF',
     &     'LOI LEMA_SEUIL NON IMPLEMENTE '//
     &      'AVEC LES POUTRES MULTI FIBRES')
          ENDIF
        ELSE
          IF ((OPTION(1:9).EQ.'FULL_MECA') .OR.
     &        (OPTION(1:9).EQ.'RAPH_MECA')) THEN     
               NBVARI = NBVALC*NF
               CALL DCOPY(NBVARI,VARIMP,1,VARIP,1)
          ENDIF

          DO 57 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            SIGX  = CONTM(I)
            EPSX  = DEFM(I)
            DEPSX = DEFP(I)
            CALL COMP1D(OPTION,
     &                  SIGX,EPSX,DEPSX,
     &                  TEMPM,TEMPP,TREF,
     &                  IRRAM,IRRAP,
     &                  CORRM,CORRP,
     &                  ANGMAS,
     &                  VARIM(IVARI),VARIP(IVARI),SIGF(I),MODF(I),
     &                  CODREF)
C SI MODULE TANGENT PAS CALCULE EXACTEMENT -> EVALUATION
            ISECAN = 0

            IF (CODREF.NE.0) CODRET=CODREF
   57     CONTINUE
        ENDIF
      ELSE

C       APPEL A COMP1D POUR BENEFICIER DE TOUS LES COMPORTEMENTS AXIS
C       PAR UNE EXTENSION DE LA METHODE DE DEBORST

        IF ((COMPOR(5)(1:7).NE.'DEBORST').AND.
     &      (COMPOR(1)(1:4).NE.'SANS')) THEN
          CALL UTMESS('F','PMF','UTILISER ALGO_1D="DEBORST"'//
     &     ' SOUS COMP_INCR POUR LE COMPORTEMENT '//COMPO)
        ELSE
        
          IF ((OPTION(1:9).EQ.'FULL_MECA') .OR.
     &        (OPTION(1:9).EQ.'RAPH_MECA')) THEN     
               NBVARI = NBVALC*NF
               CALL DCOPY(NBVARI,VARIMP,1,VARIP,1)
          ENDIF
          DO 70 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            SIGX  = CONTM(I)
            EPSX  = DEFM(I)
            DEPSX = DEFP(I)
            CALL COMP1D(OPTION,
     &                  SIGX,EPSX,DEPSX,
     &                  TEMPM,TEMPP,TREF,
     &                  IRRAM,IRRAP,
     &                  CORRM,CORRP,
     &                  ANGMAS,
     &                  VARIM(IVARI),VARIP(IVARI),SIGF(I),MODF(I),
     &                  CODREF)
            IF (CODREF.NE.0) CODRET=CODREF

C SI MODULE TANGENT PAS CALCULE EXACTEMENT -> EVALUATION
            ISECAN = 1

   70     CONTINUE
        END IF
      END IF

      END
