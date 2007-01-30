      SUBROUTINE NMAS3D(NNO,NBPG1,IPOIDS,IVF,IDFDE,GEOM,TYPMOD,OPTION,
     &                  IMATE,COMPOR,LGPG,CRIT,
     &                  INSTAM,INSTAP,
     &                  TM,TP,TREF,
     &                  DEPLM,DEPLP,
     &                  ANGMAS,
     &                  SIGM,VIM,
     &                  DFDI,DEF,SIGP,VIP,MATUU,VECTU,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/01/2007   AUTEUR DESROCHES X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER NNO,IMATE,LGPG,CODRET,NBPG1
      INTEGER IPOIDS,IVF,IDFDE
      INTEGER IPOID2,IVF2,IDFDE2
      CHARACTER*8 TYPMOD(*)
      CHARACTER*16 OPTION,COMPOR(4)
      REAL*8 INSTAM,INSTAP
      REAL*8 GEOM(3,NNO),CRIT(3),TM(NNO),TP(NNO)
      REAL*8 TREF
      REAL*8 DEPLM(3,NNO),DEPLP(3,NNO),DFDI(NNO,3)
      REAL*8 DEF(6,3,NNO)
      REAL*8 SIGM(78,NBPG1),SIGP(78,NBPG1)
      REAL*8 VIM(LGPG,NBPG1),VIP(LGPG,NBPG1)
      REAL*8 MATUU(*),VECTU(3,NNO),ANGMAS(3)

      LOGICAL DEFANE
C.......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN HYPO-ELASTICITE EN 3D POUR LE HEXA8 SOUS INTEGRE
C           STABILITE PAR ASSUMED STRAIN
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NBPG1   : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
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
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DEPLP   : INCREMENT DE DEPLACEMENT
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

      LOGICAL GRAND,CALBN,AXI
      INTEGER KPG,I,II,INO,IA,J,K,J1,KL,PROJ,COD(9),NBPG2,IC
      INTEGER NDIM,NNOS,JGANO,KP,IAA,KP1,KP3
      REAL*8 D(6,6),F(3,3),EPS(6),DEPS(6),R,S,SIGMA(6),SIGN(6)
      REAL*8 POIDS,TEMPM,TEMPP,TMP,POIPG2(8)
      REAL*8 ELGEOM(10,9)
      REAL*8 JAC,SIGAS(6,8),INVJA(3,3),BI(3,8),HX(3,4)
      REAL*8 GAM(4,8),COOPG2(24),H(8,4),DH(4,24)
      REAL*8 QPLUS(72),QMOINS(72),DQ(72)
      REAL*8 BN(6,3,8),P(3,3)
      REAL*8 PQX(4),PQY(4),PQZ(4)
      REAL*8 DFDX(8),DFDY(8),DFDZ(8)
      REAL*8 VALPAR(3),VALRES(2),NU,NUB,RAC2,R8VIDE,DEN,BID
      REAL*8 XAB(6,24),K0(24,24),MATUUR(24,24),DJAC(6,6)
      CHARACTER*2 CODRE
      CHARACTER*8 NOMRES(2),NOMPAR(3)
      CHARACTER*16 OPTIOS
      DATA H/ 1.D0, 1.D0, -1.D0,-1.D0,-1.D0,-1.D0, 1.D0, 1.D0,
     &        1.D0,-1.D0, -1.D0, 1.D0,-1.D0, 1.D0, 1.D0,-1.D0,
     &        1.D0,-1.D0,  1.D0,-1.D0, 1.D0,-1.D0, 1.D0,-1.D0,
     &       -1.D0, 1.D0, -1.D0, 1.D0, 1.D0,-1.D0, 1.D0,-1.D0/

C - INITIALISATION
C   ==============

C    PROJ : INDICATEUR DE LA PROJECTION
C           0 AUCUNE
C           1 ADS
C           2 ASQBI
C
      IF(COMPOR(1).EQ.'ELAS            ') THEN
        PROJ= 2
      ELSE
        PROJ= 1
      ENDIF
      RAC2 = SQRT(2.D0)
      GRAND = .FALSE.
      CALBN = .FALSE.

C - CALCUL DES ELEMENTS GEOMETRIQUES SPECIFIQUES AU COMPORTEMENT
      CALL LCEGEO(NNO,NBPG1,IPOIDS,IVF,IDFDE,GEOM,TYPMOD,OPTION,
     &            IMATE,COMPOR,LGPG,ELGEOM)

C - INITIALISATION CODES RETOURS
      DO 1 KPG = 1,NBPG1
        COD(KPG) = 0
   1  CONTINUE

C - INITIALISATION HEXAS8
      CALL ELRAGA ( 'HE8', 'FPG8    ', NDIM, NBPG2, COOPG2, POIPG2)
      CALL ELREF4 ( 'HE8', 'MASS', NDIM, NNO, NNOS, NBPG2, IPOID2,
     &                                           IVF2, IDFDE2, JGANO )

C - CALCUL DES COEFFICIENTS BI (MOYENNE DES DERIVEES DES FCTS DE FORME)

      DO 66 I = 1,3
        DO 77 INO = 1,NNO
          II=3*(INO-1)
          BI(I,INO) = 0.D0
  77    CONTINUE
  66  CONTINUE
      DEN = 0.D0
      DO 2 KPG = 1,NBPG2
        CALL DFDM3D ( NNO, KPG, IPOID2, IDFDE2, GEOM,
     &                    DFDX, DFDY, DFDZ, JAC )
        DEN = DEN + JAC 
        DO 3 INO = 1,NNO
          BI(1,INO) = BI(1,INO) + JAC * DFDX(INO)
          BI(2,INO) = BI(2,INO) + JAC * DFDY(INO)
          BI(3,INO) = BI(3,INO) + JAC * DFDZ(INO)
   3    CONTINUE
   2  CONTINUE
      DO 4 I = 1,3
        DO 5 INO = 1,NNO
          BI(I,INO) = BI(I,INO)/ DEN
   5    CONTINUE
   4  CONTINUE

C - CALCUL DES COEFFICIENTS GAMMA

      DO 6 I = 1,4
        DO 7 K = 1,3
          HX(K,I) = 0.D0 
          DO 8 J = 1,NNO
            HX(K,I) = HX(K,I) + H(J,I) * GEOM(K,J)
   8      CONTINUE
   7    CONTINUE
   6  CONTINUE
      DO 9 I = 1,4
        DO 10 J = 1,NNO
          S = 0.D0 
          DO 11 K = 1,3
            S = S + HX(K,I) * BI(K,J)
   11     CONTINUE
        GAM(I,J) = 0.125D0 * (H(J,I) - S)
   10   CONTINUE
   9  CONTINUE
      
C - CALCUL POUR LE POINT DE GAUSS CENTRAL
      KPG = 1

C - CALCUL DE LA TEMPERATURE AU POINT DE GAUSS
C - DE L HYDRATATION ET DU SECHAGE AU POINT DE GAUSS
C - ET DES DEFORMATIONS ANELASTIQUES AU POINT DE GAUSS

      TEMPM = 0.D0
      TEMPP = 0.D0

      DO 60 I = 1,NNO
        TEMPM = TEMPM + TM(I)*ZR(IVF+I+(KPG-1)*NNO-1)
        TEMPP = TEMPP + TP(I)*ZR(IVF+I+(KPG-1)*NNO-1)

   60 CONTINUE

C - CALCUL DES ELEMENTS GEOMETRIQUES

C     CALCUL DE DFDI,F,EPS,DEPS ET POIDS

      DO 70 J = 1,6
        EPS(J) = 0.D0
        DEPS(J) = 0.D0
   70 CONTINUE
      AXI = .FALSE.
      CALL NMGEOM(3,NNO,AXI,GRAND,GEOM,KPG,
     &              IPOIDS,IVF,IDFDE,DEPLM,POIDS,DFDI,F,EPS,R)

C     CALCUL DE DEPS
      CALL NMGEOM(3,NNO,AXI,GRAND,GEOM,KPG,
     &              IPOIDS,IVF,IDFDE,DEPLP,POIDS,DFDI,F,DEPS,R)

C      CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 41 I=1,NNO
          DO 31 J=1,3
            DEF(1,J,I) =  F(J,1)*DFDI(I,1)
            DEF(2,J,I) =  F(J,2)*DFDI(I,2)
            DEF(3,J,I) =  F(J,3)*DFDI(I,3)
            DEF(4,J,I) = (F(J,1)*DFDI(I,2) + F(J,2)*DFDI(I,1))/RAC2
            DEF(5,J,I) = (F(J,1)*DFDI(I,3) + F(J,3)*DFDI(I,1))/RAC2
            DEF(6,J,I) = (F(J,2)*DFDI(I,3) + F(J,3)*DFDI(I,2))/RAC2
 31       CONTINUE
 41     CONTINUE
C
      DO 100 I = 1,3
        SIGN(I) = SIGM(I,KPG)
  100 CONTINUE
      DO 65 I = 4,6
        SIGN(I) = SIGM(I,KPG)*RAC2
 65   CONTINUE

C - LOI DE COMPORTEMENT
      IF (OPTION(1:9).EQ.'RAPH_MECA') THEN
        OPTIOS = 'FULL_MECA'
      ELSE
        OPTIOS = OPTION
      END IF

      CALL NMCOMP('RIGI',KPG,1,3,TYPMOD,IMATE,COMPOR,CRIT,
     &            INSTAM,INSTAP,
     &            TEMPM,TEMPP,TREF,
     &            EPS,DEPS,
     &            SIGN,VIM(1,KPG),
     &            OPTIOS,
     &            ANGMAS,
     &            ELGEOM(1,KPG),
     &            SIGMA,VIP(1,KPG),D,COD(KPG))

C - ERREUR D'INTEGRATION
      IF (COD(KPG).EQ.1) THEN
        GO TO 320
      END IF
C
C  RECUP DU COEF DE POISSON POUR ASQBI
C
      NOMRES(1)='E'
      NOMRES(2)='NU'
C
      NOMPAR(1) = 'TEMP'
      VALPAR(1) = TEMPM
C
      CALL RCVALA(IMATE,' ','ELAS',1,NOMPAR,VALPAR,1,
     +                 NOMRES(2),VALRES(2),CODRE, 'FM' )
      IF(CODRE.EQ.'OK') THEN
         NU = VALRES(2)
      ELSE
         CALL U2MESS('F','ELEMENTS4_72')
      ENDIF
      
      NUB = NU/(1.D0-NU)

      IF (OPTION(1:10).EQ.'RIGI_MECA_' .OR.
     &    OPTION(1:9).EQ.'FULL_MECA') THEN

        CALL R8INIR(300,0.D0,MATUU,1)

C     CALCUL DE KC (MATRICE DE RIGIDITE AU CENTRE)
C     --------------------------------------------
        CALL CAATDB(NNO,DEF,D,DEF,POIDS,MATUU)

C           CORRECTION DE LA MATRICE DE RIGIDITE
C                 CALCUL DE KSTAB
C     --------------------------------------------
C
C        CALCUL DES TERMES EVALUES AUX 8 POINTS DE GAUSS
        DO 160 KPG = 1,NBPG2
          CALL INVJAC ( NNO, KPG, IPOID2, IDFDE2, GEOM,
     &                  INVJA, JAC )
C     
          DO 161 I = 1,3
            DH(1,3*(KPG-1)+I) = COOPG2(3*KPG-1) * INVJA(3,I) +
     &                          COOPG2(3*KPG)   * INVJA(2,I)
  161     CONTINUE

          DO 162 I = 1,3
            DH(2,3*(KPG-1)+I) = COOPG2(3*KPG-2) * INVJA(3,I) +
     &                          COOPG2(3*KPG)   * INVJA(1,I)
  162     CONTINUE

          DO 163 I = 1,3
            DH(3,3*(KPG-1)+I) = COOPG2(3*KPG-2) * INVJA(2,I) +
     &                          COOPG2(3*KPG-1) * INVJA(1,I)
  163     CONTINUE

          DO 164 I = 1,3
            DH(4,3*(KPG-1)+I) =
     &       COOPG2(3*KPG-2) * COOPG2(3*KPG-1) * INVJA(3,I) +
     &       COOPG2(3*KPG-1) * COOPG2(3*KPG)   * INVJA(1,I) +
     &       COOPG2(3*KPG-2) * COOPG2(3*KPG)   * INVJA(2,I) 
  164     CONTINUE

          CALL CAST3D(PROJ,GAM,DH,DEF,NNO,KPG,NUB,NU,
     &                D,CALBN,BN,JAC,MATUU)

  160   CONTINUE

      END IF

C - CALCUL DES FORCES INTERNES ET DES CONTRAINTES DE CAUCHY

      IF (OPTION(1:9).EQ.'FULL_MECA' .OR.
     &    OPTION(1:9).EQ.'RAPH_MECA') THEN

C     INITIALISATION
        NBPG2 = 8
        DO 12 IA = 1,4
          PQX(IA) = 0.D0
          PQY(IA) = 0.D0
          PQZ(IA) = 0.D0
  12    CONTINUE

C     DEFORMATIONS GENERALISEES
        DO 169 IA = 1,4
          DO 170 KL = 1,NNO
            PQX(IA) = PQX(IA) + GAM(IA,KL)*DEPLP(1,KL)
            PQY(IA) = PQY(IA) + GAM(IA,KL)*DEPLP(2,KL)
            PQZ(IA) = PQZ(IA) + GAM(IA,KL)*DEPLP(3,KL)
  170     CONTINUE
  169   CONTINUE

C      INCREMENT DES CONTRAINTES GENERALISEES

       CALL CALCDQ(PROJ,NUB,NU,D,PQX,PQY,PQZ,DQ)

        DO 180 I = 1,72
          QMOINS(I) = SIGM(I+6,1)
          QPLUS(I) = QMOINS(I) + DQ(I)
  180   CONTINUE

        DO 181 I = 1,NNO
          DO 182 J = 1,3
              VECTU(J,I) = 0.D0
  182     CONTINUE
  181   CONTINUE

        DO 183 I = 1,6
          DO 184 J = 1,NBPG2
              SIGAS(I,J) = 0.D0
  184     CONTINUE
  183   CONTINUE

        CALBN = .TRUE.

C      OPERATEUR DE STABILISATION DU GRADIENT AUX 8 POINTS DE GAUSS

        DO 290 KPG = 1,NBPG2
          KP = 3*(KPG-1)
          CALL INVJAC ( NNO, KPG, IPOID2, IDFDE2, GEOM,
     &                  INVJA, JAC )
     
          DO 165 I = 1,3
            DH(1,3*(KPG-1)+I) = COOPG2(3*KPG-1) * INVJA(3,I) +
     &                          COOPG2(3*KPG)   * INVJA(2,I)
  165     CONTINUE

          DO 166 I = 1,3
            DH(2,3*(KPG-1)+I) = COOPG2(3*KPG-2) * INVJA(3,I) +
     &                          COOPG2(3*KPG)   * INVJA(1,I)
  166     CONTINUE

          DO 167 I = 1,3
            DH(3,3*(KPG-1)+I) = COOPG2(3*KPG-2) * INVJA(2,I) +
     &                          COOPG2(3*KPG-1) * INVJA(1,I)
  167     CONTINUE

          DO 168 I = 1,3
            DH(4,3*(KPG-1)+I) =
     &       COOPG2(3*KPG-2) * COOPG2(3*KPG-1) * INVJA(3,I) +
     &       COOPG2(3*KPG-1) * COOPG2(3*KPG)   * INVJA(1,I) +
     &       COOPG2(3*KPG-2) * COOPG2(3*KPG)   * INVJA(2,I) 
  168     CONTINUE
C
C  CALCUL DE BN AU POINT DE GAUSS KPG
C
          CALL CAST3D(PROJ,GAM,DH,DEF,NNO,KPG,NUB,NU,
     &                D,CALBN,BN,JAC,BID)

C    CONTRAINTES DE HOURGLASS

         DO 32 I = 1,6
           II = 12*(I-1)
           DO 34 IA = 1,4
             IAA = 3*(IA-1)
             DO 35 J= 1,3
               SIGAS(I,KPG) = SIGAS(I,KPG) + QPLUS(II+IAA+J) 
     &                                       * DH(IA,KP+J)
  35         CONTINUE
  34       CONTINUE
  32     CONTINUE

C     CALCUL DES FORCES INTERNES

          DO 250 I = 1,NNO
            DO 240 J = 1,3
              DO 230 KL = 1,3
                VECTU(J,I) = VECTU(J,I) + (DEF(KL,J,I)+ BN(KL,J,I))*
     &                       (SIGAS(KL,KPG)+SIGMA(KL))*JAC 
     &                       + (RAC2*DEF(KL+3,J,I)+ BN(KL+3,J,I))*
     &                       (SIGAS(KL+3,KPG)+SIGMA(KL+3)/RAC2)*JAC 
  230         CONTINUE
  240       CONTINUE
  250     CONTINUE

  290   CONTINUE

        DO 300 KL = 1,3
          SIGP(KL,1) = SIGMA(KL)
          SIGP(KL+3,1) = SIGMA(KL+3)/RAC2
  300   CONTINUE

        DO 310 I = 1,72
          SIGP(I+6,1) = QPLUS(I)
  310   CONTINUE

      END IF

  320 CONTINUE
C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NBPG1,CODRET)

      END
