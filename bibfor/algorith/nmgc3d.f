       SUBROUTINE  NMGC3D(NNO,NPG,IPOIDS,IVF,IDFDE,GEOMI,
     &                    TYPMOD,OPTION,IMATE,COMPOR,LGPG,CRIT,
     &                    INSTAM,INSTAP,
     &                    TM,TP,TREF,
     &                    DEPLM,DEPLP,
     &                    ANGMAS,
     &                    SIGM,VIM,
     &                    DFDI,PFF,DEF,SIGP,VIP,MATUU,VECTU,CODRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2006   AUTEUR CIBHHPD L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE JMBHH01 J.M.PROIX
C TOLE CRP_21

       IMPLICIT NONE
C
       INTEGER       NNO, NPG, IMATE, LGPG, CODRET,IPOIDS,IVF,IDFDE
C
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  OPTION, COMPOR(4)
C
       REAL*8        INSTAM,INSTAP
       REAL*8        GEOMI(3,NNO), CRIT(3), TM(NNO),TP(NNO)
       REAL*8        TREF
       REAL*8        DEPLM(1:3,1:NNO),DEPLP(1:3,1:NNO),DFDI(NNO,3)
       REAL*8        PFF(6,NNO,NNO),DEF(6,NNO,3)
       REAL*8        SIGM(6,NPG),SIGP(6,NPG)
       REAL*8        VIM(LGPG,NPG),VIP(LGPG,NPG)
       REAL*8        MATUU(*),VECTU(3,NNO)
C
C.......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN GRANDES DEFORMATIONS 3D COROTATIONNEL ZMAT
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOMI   : COORDONEES DES NOEUDS SUR CONFIG INITIALE
C IN  TYPMOD  : TYPE DE MODEELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT PRECEDENT
C IN  INSTAP  : INSTANT DE CALCUL
C IN  TM      : TEMPERATURE AUX NOEUDS A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE AUX NOEUDS A L'INSTANT DE CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DEPLP   : DEPLACEMENT A L'INSTANT COURANT
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
C.......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL GRAND,RESI,RIGI

      INTEGER KPG,KK,KKD,N,I,M,J,J1,KL,PQ,COD(27)

      REAL*8 DSIDEP(6,6),F(3,3),FM(3,3),FR(3,3),EPSM(6),EPSP(6),DEPS(6)
      REAL*8 R,SIGMA(6),SIGN(6),SIG(6),SIGG(6)
      REAL*8 POIDS,TEMPM,TEMPP,TMP1,TMP2,R8VIDE
      REAL*8 ELGEOM(10,27),ANGMAS(3),R8NNEM
      REAL*8 GEOMP(3,NNO),FB(3,3)
      REAL*8 KRON(3,3),RAC2
      DATA KRON/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/


      IF(COMPOR(1)(1:4) .NE. 'ZMAT') THEN
         CALL UTMESS('F','NMGC3D','COMPORTEMENT ZMAT OBLIGATOIRE')
      ENDIF
      
C 1 - INITIALISATION
      RAC2=SQRT(2.D0)
      GRAND  = .TRUE.
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'

C 3 - CALCUL DES ELEMENTS GEOMETRIQUES SPECIFIQUES AU COMPORTEMENT

      CALL LCEGEO(NNO,NPG,IPOIDS,IVF,IDFDE,GEOMI,TYPMOD,OPTION,
     &            IMATE,COMPOR,LGPG,ELGEOM)

C 4 - INITIALISATION CODES RETOURS

      DO 1955 KPG=1,NPG
        COD(KPG)=0
1955  CONTINUE

C 5 - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 800 KPG=1,NPG

C 5.1 - CALCUL DE LA TEMPERATURE AU POINT DE GAUSS
C     - ET DES DEFORMATIONS ANELASTIQUES AU POINT DE GAUSS

       TEMPM = 0.D0
       TEMPP = 0.D0

       DO 10 N=1,NNO
        TEMPM = TEMPM + TM(N)*ZR(IVF+N+(KPG-1)*NNO-1)
        TEMPP = TEMPP + TP(N)*ZR(IVF+N+(KPG-1)*NNO-1)

 10    CONTINUE

C 5.2 - CALCUL DES ELEMENTS GEOMETRIQUES

C 5.2.1 - CALCUL DE EPSM EN T- POUR LDC

       DO 20 J = 1,6
        EPSM (J)=0.D0
        EPSP (J)=0.D0
20    CONTINUE
      CALL NMGEOM(3,NNO,.FALSE.,GRAND,GEOMI,KPG,IPOIDS,
     &            IVF,IDFDE,DEPLM,POIDS,DFDI,
     &            FM,EPSM,R)

C 5.2.2 - CALCUL DE F, EPSP, DFDI, R ET POIDS EN T+

      CALL NMGEOM(3,NNO,.FALSE.,GRAND,GEOMI,KPG,IPOIDS,
     &           IVF,IDFDE,DEPLP,POIDS,DFDI,
     &           F,EPSP,R)
     
        DO 55 N = 1,NNO
           DO 56 I = 1,3
              GEOMP(I,N) = GEOMI(I,N) + DEPLP(I,N)
 56        CONTINUE
 55     CONTINUE

        CALL NMGEOM(3,NNO,.FALSE.,GRAND,GEOMP,KPG,IPOIDS,
     &           IVF,IDFDE,DEPLP,POIDS,DFDI,
     &           FB,EPSP,R)
     
        DO 57 I=1,3
           DO 58 J=1,3
              FR(I,J) = KRON(I,J)
 58        CONTINUE
 57     CONTINUE
 
      DO 40 N=1,NNO
       DO 30 I=1,3
        DEF(1,N,I) =  FR(I,1)*DFDI(N,1)
        DEF(2,N,I) =  FR(I,2)*DFDI(N,2)
        DEF(3,N,I) =  FR(I,3)*DFDI(N,3)
        DEF(4,N,I) = (FR(I,1)*DFDI(N,2) + FR(I,2)*DFDI(N,1))/RAC2
        DEF(5,N,I) = (FR(I,1)*DFDI(N,3) + FR(I,3)*DFDI(N,1))/RAC2
        DEF(6,N,I) = (FR(I,2)*DFDI(N,3) + FR(I,3)*DFDI(N,2))/RAC2
 30    CONTINUE
 40    CONTINUE


C 5.2.6 - CALCUL DES PRODUITS DE FONCTIONS DE FORMES (ET DERIVEES)

       IF (RIGI) THEN
        DO 125 N=1,NNO
         DO 126 M=1,N
          PFF(1,N,M) =  DFDI(N,1)*DFDI(M,1)
          PFF(2,N,M) =  DFDI(N,2)*DFDI(M,2)
          PFF(3,N,M) =  DFDI(N,3)*DFDI(M,3)
          PFF(4,N,M) =(DFDI(N,1)*DFDI(M,2)+DFDI(N,2)*DFDI(M,1))/RAC2
          PFF(5,N,M) =(DFDI(N,1)*DFDI(M,3)+DFDI(N,3)*DFDI(M,1))/RAC2
          PFF(6,N,M) =(DFDI(N,2)*DFDI(M,3)+DFDI(N,3)*DFDI(M,2))/RAC2
 126     CONTINUE
 125    CONTINUE
       ENDIF

C         CAUCHY      
         DO 59 I=1,3
             SIGN(I)=SIGM(I,KPG)
 59      CONTINUE
         DO 60 I=1,3
             SIGN(3+I)=SIGM(3+I,KPG)*RAC2
 60      CONTINUE
C 5.3.2 - INTEGRATION

C -    APPEL A LA LOI DE COMPORTEMENT
       CALL NMCOMP('RIGI',KPG,1,3,TYPMOD,IMATE,COMPOR,CRIT,
     &            INSTAM,INSTAP,
     &            TEMPM,TEMPP,TREF,
     &            FM,F,                            
     &            SIGN,VIM(1,KPG),
     &            OPTION,ANGMAS,
     &            ELGEOM(1,KPG),
     &            SIGMA,VIP(1,KPG),DSIDEP,COD(KPG))

      
       IF(COD(KPG).EQ.1) THEN
         GOTO 1956
       ENDIF

C 5.4 - CALCUL DE LA MATRICE DE RIGIDITE

       IF (RIGI) THEN
        DO 160 N=1,NNO
         DO 150 I=1,3
          DO 151,KL=1,6
           SIG(KL)=0.D0
           SIG(KL)=SIG(KL)+DEF(1,N,I)*DSIDEP(1,KL)
           SIG(KL)=SIG(KL)+DEF(2,N,I)*DSIDEP(2,KL)
           SIG(KL)=SIG(KL)+DEF(3,N,I)*DSIDEP(3,KL)
           SIG(KL)=SIG(KL)+DEF(4,N,I)*DSIDEP(4,KL)
           SIG(KL)=SIG(KL)+DEF(5,N,I)*DSIDEP(5,KL)
           SIG(KL)=SIG(KL)+DEF(6,N,I)*DSIDEP(6,KL)
151       CONTINUE
          DO 140 J=1,3
           DO 130 M=1,N
            IF (M.EQ.N) THEN
             J1 = I
            ELSE
             J1 = 3
            ENDIF

C 5.4.1 - RIGIDITE GEOMETRIQUE

            IF (OPTION(1:4).EQ.'RIGI') THEN
              SIGG(1)=SIGN(1)
              SIGG(2)=SIGN(2)
              SIGG(3)=SIGN(3)
              SIGG(4)=SIGN(4)
              SIGG(5)=SIGN(5)
              SIGG(6)=SIGN(6)
             ELSE
              SIGG(1)=SIGMA(1)
              SIGG(2)=SIGMA(2)
              SIGG(3)=SIGMA(3)
              SIGG(4)=SIGMA(4)
              SIGG(5)=SIGMA(5)
              SIGG(6)=SIGMA(6)
             ENDIF

            TMP1 = 0.D0
            IF (I.EQ.J) THEN
             TMP1 = PFF(1,N,M)*SIGG(1)
     &           + PFF(2,N,M)*SIGG(2)
     &           + PFF(3,N,M)*SIGG(3)
     &           + PFF(4,N,M)*SIGG(4)
     &           + PFF(5,N,M)*SIGG(5)
     &           + PFF(6,N,M)*SIGG(6)
            ENDIF

C 5.4.2 - RIGIDITE ELASTIQUE

            TMP2=0.D0
            TMP2=TMP2+SIG(1)*DEF(1,M,J)
            TMP2=TMP2+SIG(2)*DEF(2,M,J)
            TMP2=TMP2+SIG(3)*DEF(3,M,J)
            TMP2=TMP2+SIG(4)*DEF(4,M,J)
            TMP2=TMP2+SIG(5)*DEF(5,M,J)
            TMP2=TMP2+SIG(6)*DEF(6,M,J)

C 5.4.3 - STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
            IF (J.LE.J1) THEN
             KKD = (3*(N-1)+I-1) * (3*(N-1)+I) /2
             KK = KKD + 3*(M-1)+J
             MATUU(KK) = MATUU(KK) + (TMP1+TMP2)*POIDS
            END IF

 130       CONTINUE
 140      CONTINUE
 150     CONTINUE
 160    CONTINUE
       ENDIF

C 5.5 - CALCUL DE LA FORCE INTERIEURE

       IF (RESI) THEN
        DO 230 N=1,NNO
         DO 220 I=1,3
          DO 210 KL=1,6
           VECTU(I,N)=VECTU(I,N)+DEF(KL,N,I)*SIGMA(KL)*POIDS
 210      CONTINUE
 220     CONTINUE
 230    CONTINUE

C 5.6 - CALCUL DES CONTRAINTES DE CAUCHY, CONVERSION LAGRANGE -> CAUCHY
          DO 255 PQ = 1,6
              SIGP(PQ,KPG) = SIGMA(PQ)
 255      CONTINUE

        ENDIF

800   CONTINUE

1956  CONTINUE

C - SYNTHESE DES CODES RETOURS

      CALL CODERE(COD,NPG,CODRET)
      END
