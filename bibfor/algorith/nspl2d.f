      SUBROUTINE NSPL2D(NNO,NPG,POIDSG,VFF,DFDE,DFDK,GEOM,TYPMOD,OPTION,
     &                  IMATE,COMPOR,LGPG,DEPMOI,DEPPLU,SIGMOS,
     &                  VARMOS,VARMOI,SIGMOI,STYPSE,DEPMOS,DEPPLS,
     &                  VARPLU,SIGPLU,VECTU,SIGPLS,VARPLS,DFDI,DEF)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2003   AUTEUR PBADEL P.BADEL 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21

       IMPLICIT NONE

      INTEGER NNO,NPG,IMATE,LGPG

      CHARACTER*8 TYPMOD(*)
      CHARACTER*16 OPTION,COMPOR(4)
      CHARACTER*24 STYPSE

      REAL*8 POIDSG(NPG),VFF(NNO,NPG),DFDE(*),DFDK(*)
      REAL*8 GEOM(2,NNO)
      REAL*8 DEPMOI(2,NNO),DEPPLU(2,NNO)
      REAL*8 SIGMOS(4,NPG),VARMOS(LGPG,NPG)
      REAL*8 VARMOI(LGPG,NPG),SIGMOI(4,NPG)
      REAL*8 DEPMOS(2,NNO),DEPPLS(2,NNO)
      REAL*8 VARPLU(LGPG,NPG),SIGPLU(4,NPG)
      REAL*8 VECTU(2,NNO),VARPLS(LGPG,NPG),SIGPLS(4,NPG)
      REAL*8 DEF(4,NNO,2),DFDI(NNO,2)
C.......................................................................

C     BUT:  CALCUL  DES OPTIONS MECA_SENS_MATE, MECA_SENS_CHAR,
C           MECA_SENS_RAPH EN HYPO-ELASTICITE EN 2D
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  IMATS   : MATERIAU CODE SENSIBLE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  DEPMOI  : DEPLACEMENT A L'INSTANT -
C IN  DEPPLU  : INCR DE DEPLACEMENT
C IN  SIGMOS  : CONTRAINTES SENSIBLE A L'INSTANT -
C IN  VARMOS  : V. INTERNES SENSIBLE A L'INSTANT -
C IN  VARMOI  : V. INTERNES A L'INSTANT -
C IN  SIGMOI  : CONTRAINTES A L'INSTANT PRECEDENT
C IN  STYPSE  : SOUS-TYPE DE SENSIBILITE
C IN  DEPMOS  : DEPLACEMENT SENSIBLE A L'INSTANT -
C IN  DEPPLS  : INCR DE DEPLACEMENT SENSIBLE
C IN  VARPLU  : V. INTERNES A L'INSTANT +
C IN  SIGPLU  : CONTRAINTES A L'INSTANT +
C OUT VECTU   : FORCES NODALES
C OUT SIGPLS  : CONTRAINTES SENSIBLE A L'INSTANT +
C OUT VARPLS  : V. INTERNES SENSIBLE A L'INSTANT +
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
C.......................................................................

      LOGICAL GRAND,AXI

      INTEGER KPG,N,I,J,KL

      REAL*8 F(3,3),EPS(6),DEPS(6),R,POIDS
      REAL*8 RBID,SIGMS(6),SIGPS(6),DUM,ELGEOM(10,9)
      REAL*8 SIGM(6),SIGP(6)

      REAL*8 RAC2


C - INITIALISATION

      RAC2 = SQRT(2.D0)
      GRAND = .FALSE.
      AXI = TYPMOD(1) .EQ. 'AXIS'

C - CALCUL DES ELEMENTS GEOMETRIQUES SPECIFIQUES AU COMPORTEMENT

      CALL LCEGEO(NNO,NPG,POIDSG,VFF,DFDE,RBID,DFDK,GEOM,TYPMOD,OPTION,
     &            IMATE,COMPOR,LGPG,ELGEOM)


C - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 100 KPG = 1,NPG

C - CALCUL DES ELEMENTS GEOMETRIQUES

C     CALCUL DE DFDI,F,EPS,DEPS,R(EN AXI) ET POIDS

        DO 10 J = 1,6
          EPS(J) = 0.D0
          DEPS(J) = 0.D0
   10   CONTINUE

        IF ((OPTION.EQ.'MECA_SENS_MATE')
     &      .OR.(OPTION.EQ.'MECA_SENS_CHAR')) THEN
          CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,POIDSG(KPG),VFF(1,KPG),
     &                DFDE,DUM,DFDK,DEPMOI,POIDS,DFDI,F,EPS,R)

          CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,POIDSG(KPG),VFF(1,KPG),
     &                DFDE,DUM,DFDK,DEPPLU,POIDS,DFDI,F,DEPS,R)
        ELSE IF (OPTION.EQ.'MECA_SENS_RAPH') THEN
          CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,POIDSG(KPG),VFF(1,KPG),
     &                DFDE,DUM,DFDK,DEPMOS,POIDS,DFDI,F,EPS,R)

          CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,POIDSG(KPG),VFF(1,KPG),
     &                DFDE,DUM,DFDK,DEPPLS,POIDS,DFDI,F,DEPS,R)
        END IF



C      CALCUL DES PRODUITS SYMETR. DE F PAR N,
        DO 30 N = 1,NNO
          DO 20 I = 1,2
            DEF(1,N,I) = F(I,1)*DFDI(N,1)
            DEF(2,N,I) = F(I,2)*DFDI(N,2)
            DEF(3,N,I) = 0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2)+F(I,2)*DFDI(N,1))/RAC2
   20     CONTINUE
   30   CONTINUE

C      TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
        IF (AXI) THEN
          DO 40 N = 1,NNO
            DEF(3,N,1) = F(3,3)*VFF(N,KPG)/R
   40     CONTINUE
        END IF

        DO 50 I = 1,3
          SIGMS(I) = SIGMOS(I,KPG)
   50   CONTINUE
        SIGMS(4) = SIGMOS(4,KPG)*RAC2

        DO 52 I = 1,3
          SIGM(I) = SIGMOI(I,KPG)
   52   CONTINUE
        SIGM(4) = SIGMOI(4,KPG)*RAC2

        DO 54 I = 1,3
          SIGP(I) = SIGPLU(I,KPG)
   54   CONTINUE
        SIGP(4) = SIGPLU(4,KPG)*RAC2

C - LOI DE COMPORTEMENT

        CALL NSCOMP(OPTION,TYPMOD,COMPOR,2,IMATE,EPS,DEPS,SIGMS,
     &              VARMOS(1,KPG),VARMOI(1,KPG),SIGM,
     &              VARPLU(1,KPG),
     &              SIGP,SIGPS,VARPLS(1,KPG),STYPSE)

C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY
C - ATTENTION AU SIGNE - : ON CALCULE -VECTU!

        IF ((OPTION(1:14).EQ.'MECA_SENS_MATE')
     &      .OR.(OPTION(1:14).EQ.'MECA_SENS_CHAR')) THEN

          DO 80 N = 1,NNO
            DO 70 I = 1,2
              DO 60 KL = 1,4
                VECTU(I,N) = VECTU(I,N) - DEF(KL,N,I)*SIGPS(KL)*POIDS
   60         CONTINUE
   70       CONTINUE
   80     CONTINUE

        END IF

        DO 90 KL = 1,3
          SIGPLS(KL,KPG) = SIGPS(KL)
   90   CONTINUE
        SIGPLS(4,KPG) = SIGPS(4)/RAC2

  100 CONTINUE
  110 CONTINUE

      END
