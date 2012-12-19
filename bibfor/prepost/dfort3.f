      SUBROUTINE DFORT3(NSOMMX,ICNC,NOEU1,NOEU2,
     &                  TBELZO,NBELT,TBNOZO,NBNOE,
     &                  XY,VOLUME,ENERGI,PE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C********************************************************************
C                  BUT DE CETTE ROUTINE :                           *
C      CALCULER LE DEGRE DE LA SINGULARITE PE SUR L ARETE           *
C                 D EXTREMITE NOEU1 ET NOEU2                        *
C 1) CALCUL DE L ENERGIE MOYENNE ENER SUR UN CYLINDRE D EXTREMITE   *
C    NOEU1 ET NOEU2 ET POUR DIFFERENTS RAYONS RAYZ                  *
C 2) COMPARAISON DE CETTE ENERGIE CALCULEE AVEC L ENERGIE THEORIQUE *
C    EN POINTE DE FISSURE ENER_THEO=K*(RAYZ**(2*(PE-1)))+C          *
C    ET CALCUL DU COEFFICENT PE PAR LA METHODE DES MOINDRES CARRES  *
C********************************************************************

C IN  NSOMMX               : NOMBRE DE SOMMETS MAX PAR EF
C IN  ICNC(NSOMMX+2,NELEM) : CONNECTIVITE EF => NOEUDS CONNECTES
C     1ERE VALEUR = NBRE DE NOEUDS SOMMETS CONNECTES A L EF N°X
C     2EME VALEUR = 1 SI EF UTILE 0 SINON
C     CONNECTIVITE  EF N°X=>N° DE NOEUDS SOMMETS CONNECTES A X
C     EN 2D EF UTILE = QUAD OU TRIA
C     EN 3D EF UTILE = TETRA OU HEXA
C IN  NOEU1 ET NOEU2       : NOEUDS DE L ARETE CONSIDEREE
C IN  TBELZO(NBELT)        : EFS DES COUCHES 1, 2 ET 3
C IN  NBELT                : NBR D EFS DES COUCHES 1,2,3
C IN  TBNOZO(NBNOE)        : NOEUDS DES COUCHES 1, 2 ET 3
C IN  NBNOE                : SOMME(NBNOZO)
C IN  XY(3,NNOEM)          : COORDONNEES DES NOEUDS
C IN  VOLUME(NELEM)        : VOLUME DE CHAQUE EF
C IN  ENERGI(NELEM)        : ENERGIE SUR CHAQUE EF
C OUT PE                   : DEGRE DE LA SINGULARITE

      IMPLICIT NONE

C DECLARATION GLOBALE

      INTEGER NSOMMX,ICNC(NSOMMX+2,*),NOEU1,NOEU2
      INTEGER NBELT,NBNOE
      INTEGER TBELZO(NBELT),TBNOZO(NBNOE)
      REAL*8  XY(3,*),VOLUME(*),ENERGI(*),PE

C DECLARATION LOCALE

      INTEGER I,INNO,NUEF,IINT,INEL,NOEUD
      INTEGER NBINT
      PARAMETER( NBINT = 6 )
      INTEGER NINT,NHOP,NPIR,NEXT,NBI,NORM(2,4)
      REAL*8 COORD1(3),COORD2(3),COORN(3,12)
      REAL*8 XAO1,YAO1,ZAO1,XO1O2,YO1O2,ZO1O2
      REAL*8 DO1O2
      REAL*8 RAYON,DIST,RAY(2),R,RAYZ(NBINT)
      REAL*8 DVOLU1, DVOLU2, DVOLU3, DVOLU4, DVOLU5
      REAL*8 VOLI,VOLTOT
      REAL*8 ENER(NBINT)

C 1 - COORDONNEES DE NOEU1 ET NOEU2

      DO 10 I = 1,3
        COORD1(I) = XY(I,NOEU1)
        COORD2(I) = XY(I,NOEU2)
 10   CONTINUE
      XO1O2 = COORD2(1)-COORD1(1)
      YO1O2 = COORD2(2)-COORD1(2)
      ZO1O2 = COORD2(3)-COORD1(3)
      DO1O2 = SQRT( XO1O2**2 + YO1O2**2 + ZO1O2**2 )
      CALL ASSERT(DO1O2.GE.1.D-20)

C 2 - CALCUL DU RAYON MAXI

      RAYON = -1.D+10

      DO 20 INNO= 1,NBNOE

        NOEUD = TBNOZO(INNO)
        XAO1 = XY(1,NOEUD)-COORD1(1)
        YAO1 = XY(2,NOEUD)-COORD1(2)
        ZAO1 = XY(3,NOEUD)-COORD1(3)

        DIST = SQRT((YAO1*ZO1O2 - ZAO1*YO1O2 )**2 +
     &             (ZAO1*XO1O2 - XAO1*ZO1O2 )**2 +
     &             (XAO1*YO1O2 - YAO1*XO1O2 )**2) / DO1O2
        RAYON=MAX(RAYON,DIST)

 20   CONTINUE

C 3 - CALCUL DE L ENERGIE POUR DIFFERENTS RAYONS RAYZ
C     ENER=SOMME(ENERGI(EF)*VOLI/VOLUME(EF))/VOLTOT
C     LA SOMME S EFFECTUE SUR TOUS LES EFS DES COUCHES 1,2 ET 3
C     VOLTOT EST LE VOLUME DU CYLINDRE
C     VOLUME(EF) EST LE VOLUME DE L EF CONSIDERE
C     VOLI EST LE VOLUME DE L INTERSECTION ENTRE L EF CONSIDERE
C     ET LE CYLINDRE D EXTREMITE NOEU1 ET NOEU2 ET DE RAYON RAYZ

      DO 30 IINT = 1,NBINT

        R = (IINT*RAYON) / NBINT
        RAYZ(IINT) = R
        ENER(IINT) = 0.D+0
        VOLTOT = 0.D+0

C 3.1 - BOUCLE SUR TOUS LES EFS

        DO 40 INEL = 1,NBELT

          NUEF = TBELZO(INEL)

C 3.1.1 - CLASSEMENT DES NOEUDS
C         NINT NBR DE NOEUDS INTERNES AU CYLINDRE
C         NHOP NBR DE NOEUDS EXTERIEURS AUX DEUX PLANS
C         NPIR NBR DE NOEUDS INFEREURS AU RAYON
C         NEXT NBR DE NOEUDS EXTERNES AU CYLINDRE
C         NBI  NBR DE NOEUDS D INTERSECTION AU CYLINDRE

          NINT = 0
          NHOP = 0
          NPIR = 0
          NEXT = 0
          DO 50 INNO = 1,ICNC(1,NUEF)
            NOEUD = ICNC(INNO+2,NUEF)
            CALL DRAO12(COORD1,COORD2,XO1O2,YO1O2,ZO1O2,
     &                  DO1O2,XY(1,NOEUD),RAY)
            IF ( RAY(1).LE.RAYZ(IINT) ) THEN
              IF ( RAY(2).EQ.0.0D0 ) THEN
                NORM(1,INNO) = 1
                NORM(2,INNO) = 0
                NINT = NINT + 1
                NPIR = NPIR + 1
              ELSE
                NORM(1,INNO) = -1
                IF ( RAY(2).EQ.1.0D0 )  NORM(2,INNO) = 1
                IF ( RAY(2).EQ.-1.0D0 ) NORM(2,INNO) = -1
                NEXT = NEXT + 10
                NHOP = NHOP + 1
                NPIR = NPIR + 1
              ENDIF
            ELSE
              IF ( RAY(2).NE.0.0D0 ) THEN
                NORM(1,INNO) = -1
                IF ( RAY(2).EQ.1.0D0 )  NORM(2,INNO) = 1
                IF ( RAY(2).EQ.-1.0D0 ) NORM(2,INNO) = -1
                NEXT = NEXT + 1
                NHOP = NHOP + 1
              ELSE
                NORM(1,INNO) = -1
                NORM(2,INNO) = 0
                NEXT = NEXT + 1
              ENDIF
            ENDIF
 50       CONTINUE

C 3.1.2 - VOLUME DE L INTERSECTION VOLI SELON LES CAS
C         SI NINT = 4, VOLI=VOLUME DE L EF
C         SI NEXT = 4, VOLI=0
C         SINON ON CORRIGE

          IF ( NINT.EQ.4 ) THEN
            VOLI=VOLUME(NUEF)
          ELSE IF ( NEXT.NE.4 ) THEN
            VOLI = 0.0D0
            DO 60 INNO = 1,4
              COORN(1,INNO) = XY(1,ICNC(INNO+2,NUEF))
              COORN(2,INNO) = XY(2,ICNC(INNO+2,NUEF))
              COORN(3,INNO) = XY(3,ICNC(INNO+2,NUEF))
 60         CONTINUE

C CALCUL DES INTERSECTIONS DES ARETES DU TETRA AVEC LE CYLINDRE

            CALL DINTTC(COORD1,COORD2,XO1O2,YO1O2,ZO1O2,DO1O2,
     &                  R,NORM,NINT,NHOP,NPIR,COORN,NBI)

            IF ( NINT.EQ.1 .AND. NBI.EQ.3 ) THEN
              I = -1
              VOLI = DVOLU1(I,COORN,NORM,VOLUME)
            ELSE IF ( NINT.EQ.3.AND.NBI.EQ.3 ) THEN
              VOLI = DVOLU1(NUEF,COORN,NORM,VOLUME)
            ELSE IF ( NINT.EQ.2.AND.NBI.EQ.2 ) THEN
              VOLI = DVOLU4(COORN,NORM,COORD1)
            ELSE IF ( NINT.EQ.2.AND.NBI.EQ.3 ) THEN
              VOLI = DVOLU3(COORN,NORM,COORD1)
            ELSE IF ( NINT.EQ.2.AND.NBI.EQ.4 ) THEN
              VOLI = DVOLU2(COORN,NORM)
            ELSE IF ( NINT.EQ.2.AND.NBI.EQ.6 ) THEN
              VOLI = DVOLU5(NUEF,COORN,NORM,VOLUME,COORD1,COORD2)
            ELSE IF ( NBI.EQ.0 ) THEN
              VOLI = 0.0D0
            ELSE
C             problème intersection cylindre tétraèdre
              CALL ASSERT(.FALSE.)
            ENDIF
          ENDIF

          CALL ASSERT(VOLI.GE.0.D0)

C 3.1.3 - CALCUL DE L ENERGIE

          ENER(IINT) = ENER(IINT) + ENERGI(NUEF)*VOLI/VOLUME(NUEF)
          VOLTOT = VOLTOT + VOLI

C 2 - FIN DE LA BOUCLE SUR TOUS LES EF

 40     CONTINUE

        CALL ASSERT(VOLTOT.GT.0.D0.AND.ENER(IINT).GT.0.D0)
        ENER(IINT) = ENER(IINT) / VOLTOT

C LISSAGE DE LA COURBE ENERGI=F(RAYON) POUR IDENTIFIER PE

        IF (IINT.GE.2) THEN
          ENER(IINT) = MIN(ENER(IINT),ENER(IINT-1))
        ENDIF

C 3 - FIN DE LA BOUCLE SUR LE CALCUL DE L ENERGIE

 30   CONTINUE


C 4 - CALCUL DU DEGRE DE LA SINGULARITE
C     PAR LA METHODE DES MOINDRES CARRES

      CALL DCALPH(RAYZ,ENER,NBINT,PE)

      END
