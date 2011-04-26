      SUBROUTINE NMFI2D( NPG,LGPG,MATE,OPTION,GEOM,DEPLM,DDEPL,SIGMA,
     &                   FINT,KTAN,VIM,VIP,TM,TP,CRIT,COMPOR,TYPMOD)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C TOLE CRS_1404
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      INTEGER MATE,NPG,LGPG
      REAL*8  GEOM(2,4),DEPLM(8),DDEPL(8),TM,TP
      REAL*8  FINT(8),KTAN(8,8),SIGMA(6,NPG),VIM(LGPG,NPG),VIP(LGPG,NPG)
      CHARACTER*8  TYPMOD(*)
      CHARACTER*16 OPTION, COMPOR(*)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
C-----------------------------------------------------------------------
C
C BUT: DEVELOPPEMENT D'UN ELEMENT DE JOINT.
C      CALCUL DU SAUT DANS L'ELEMENT
C             DE LA CONTRAINTE A PARTIR D'UNE LDC
C             DE FINT ET KTAN : EFFORTS INTERIEURS ET MATRICE TANGENTE.
C
C      OPTION : OPTIONS DE CALCUL EN FONCTION DE LA SUBROUTINE LANCEE
C       * RAPH_MECA      : U = U- + DU  ->   SIGMA , FINT
C       * FULL_MECA      : U = U- + DU  ->   SIGMA , FINT , KTAN
C       * RIGI_MECA_TANG : U = U-       ->                   KTAN
C       * FORC_NODA      : TRAITE DANS NMFIFI.F
C
C SUBROUTINE APPELEE DANS LE TE0201
C
C IN  : OPTION,COMPOR,GEOM,DEPLM,DDEPL,VIM,NPG,TYPMOD,MATE
C IN   TM  : INSTANT MOINS
C IN   TP  :INSTANT PLUS
C OUT : SIGMA,FINT,KTAN,VIP
C I/O :
C
C-----------------------------------------------------------------------

      LOGICAL RESI, RIGI, AXI
      INTEGER I,J,Q,S, IBID,KPG
      INTEGER NDIM,NNO,NNOS,IPOIDS,IVF,IDFDE,JGANO
C     COORDONNEES POINT DE GAUSS + POIDS : X,Y,W => 1ER INDICE
      REAL*8 COOPG(3,NPG)
      REAL*8 DSIDEP(6,6),B(2,8),RBID,R8VIDE
      REAL*8 SUM(2),DSU(2),POIDS
      REAL*8 CRIT
      REAL*8 ANGMAS(3)

      AXI   = TYPMOD(1) .EQ. 'AXIS'
      RESI  = OPTION.EQ.'RAPH_MECA' .OR. OPTION(1:9).EQ.'FULL_MECA'
      RIGI  = OPTION(1:9).EQ.'FULL_MECA'.OR.OPTION(1:10).EQ.'RIGI_MECA_'

C --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C --- INITIALISE A R8VIDE (ON NE S'EN SERT PAS)
      CALL R8INIR(3,  R8VIDE(), ANGMAS ,1)

      IF (.NOT. RESI .AND. .NOT. RIGI)
     &  CALL U2MESK('F','ALGORITH7_61',1,OPTION)

      IF (RESI)  CALL R8INIR(8 , 0.D0, FINT,1)
      IF (RIGI)  CALL R8INIR(64, 0.D0, KTAN,1)

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     CALCUL DES COORDONNEES DES POINTS DE GAUSS
      CALL GEDISC(2,NNO,NPG,ZR(IVF),GEOM,COOPG)

      DO 11 KPG=1,NPG

C CALCUL DE LA MATRICE B DONNANT LES SAUT PAR ELEMENTS A PARTIR DES
C DEPLACEMENTS AUX NOEUDS , AINSI QUE LE POIDS DES PG :
C LE CHANGEMENT DE REPERE EST INTEGRE DANS LA MATRICE B (VOIR NMFISA)

        CALL NMFISA(AXI,GEOM,KPG,POIDS,B)

C CALCUL DU SAUT DE DEPLACEMENT DANS L'ELEMENT (SU_N,SU_T) = B U

        CALL R8INIR(2, 0.D0, SUM,1)
        CALL R8INIR(2, 0.D0, DSU,1)
        DO 10 J=1,8
          SUM(1) = SUM(1) + B(1,J)*DEPLM(J)
          SUM(2) = SUM(2) + B(2,J)*DEPLM(J)
 10     CONTINUE
        IF (RESI) THEN
          DO 13 J=1,8
            DSU(1) = DSU(1) + B(1,J)*DDEPL(J)
            DSU(2) = DSU(2) + B(2,J)*DDEPL(J)
 13       CONTINUE
        END IF

C -   APPEL A LA LOI DE COMPORTEMENT
C CALCUL DE LA CONTRAINTE DANS L'ELEMENT AINSI QUE LA DERIVEE
C DE CELLE-CI PAR RAPPORT AU SAUT DE DEPLACEMENT (SIGMA ET DSIDEP)

        CALL NMCOMP('RIGI',KPG,1,2,TYPMOD,MATE,COMPOR,CRIT,
     &              TM,TP,
     &              SUM,DSU,
     &              RBID,VIM(1,KPG),
     &              OPTION,
     &              ANGMAS,
     &              COOPG(1,KPG),
     &              SIGMA(1,KPG),VIP(1,KPG),DSIDEP,IBID)


C CALCUL DES FINT (B_T SIGMA )

        IF (RESI) THEN

          DO 20 I=1,8
            DO 40 Q=1,2
              FINT(I) = FINT(I) +  POIDS*B(Q,I)*SIGMA(Q,KPG)
 40         CONTINUE
 20       CONTINUE

        ENDIF


C CALCUL DES KTAN = ( B_T  DSIGMA/DSU  B )

        IF (RIGI) THEN

          DO 50 I=1,8
            DO 52 J=1,8
              DO 60 Q=1,2
                DO 62 S=1,2
                  KTAN(I,J) = KTAN(I,J)+
     &                        POIDS*B(Q,I)*DSIDEP(Q,S)*B(S,J)
 62             CONTINUE
 60           CONTINUE
 52         CONTINUE
 50       CONTINUE

        ENDIF

 11   CONTINUE

      END
