      SUBROUTINE DFORT2(NSOMMX,ICNC,NDIM,NOEU1,
     &                  TBELZO,NBELT,TBNOZO,NBNOZO,NBNOE,
     &                  XY,AIRE,ENERGI,PE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/07/2005   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C       CALCULER LE DEGRE DE LA SINGULARITE PE AU NOEUD NOEU1       *
C 1) CALCUL DE L ENERGIE MOYENNE ENER SUR UN CERCLE DE CENTRE NOEU1 *
C    ET POUR DIFFERENTS RAYONS RAYZ                                 *
C 2) COMPARAISON DE CETTE ENERGIE CALCULEE AVEC L ENERGIE THEORIQUE *
C    EN POINTE DE FISSURE ENER_THEO=K*(RAYZ**(2*(PE-1)))+C          *
C    ET CALCUL DU COEFFICENT PE PAR LA METHODE DES MOINDRES CARRES  *
C********************************************************************

C IN  NSOMMX               : NOMBRE DE SOMMETS MAX PAR EF
C IN  ICNC(NSOMMX+2,NELEM) : CONNECTIVITE EF => NOEUDS CONNECTES
C     1ERE VALEUR = NBRE DE NOEUDS SOMMETS CONNECTES A L EF N�X
C     2EME VALEUR = 1 SI EF UTILE 0 SINON 
C     CONNECTIVITE  EF N�X=>N� DE NOEUDS SOMMETS CONNECTES A X
C     EN 2D EF UTILE = QUAD OU TRIA
C     EN 3D EF UTILE = TETRA OU HEXA
C IN  NDIM                 : DIMENSION DU PROBLEME
C IN  NOEU1                : NOEUD CONSIDERE
C IN  TBELZO(NBELT)        : EFS DES COUCHES 1, 2 ET 3
C IN  NBELT                : NBR D EFS DES COUCHES 1,2,3
C IN  TBNOZO(NBNOE)        : NOEUDS DES COUCHES 1, 2 ET 3
C IN  NBNOZO(3)            : NBR DE NOEUDS DES COUCHES 1, 2 ET 3
C IN  XY(3,NNOEM)          : COORDONNEES DES NOEUDS
C IN  AIRE(NELEM)          : SURFACE DE CHAQUE EF
C IN  ENERGI(NELEM)        : ENERGIE SUR CHAQUE EF
C OUT PE                   : DEGRE DE LA SINGULARITE

      IMPLICIT NONE 

C DECLARATION GLOBALE

      INTEGER NSOMMX,ICNC(NSOMMX+2,*),NDIM,NOEU1
      INTEGER NBNOZO(3),NBELT,NBNOE
      INTEGER TBELZO(NBELT),TBNOZO(NBNOE)      
      REAL*8  XY(3,*),AIRE(*),ENERGI(*),PE

C DECLARATION LOCALE

      INTEGER I,J,INNO,IINT,INEL,NUEF,NOEU2,NEDEP,NEFIN
      INTEGER NSOMM,NBINT
      INTEGER IPOI1,IPOI2,IPOI4,NINT,IP1      
      PARAMETER (NBINT = 10)
      REAL*8  COORD(2),COOR(2,4),COORIN(2,2)
      REAL*8  DELTA(3),DIST,RAYZ(NBINT),RAY
      REAL*8  AIRTOT,SPRIM
      REAL*8  ENER(NBINT)
      
C 1 - COORDONNEES DU NOEUD CONSIDERE INNO

      DO 5 I=1,2
        COORD(I)=XY(I,NOEU1)
 5    CONTINUE

C 2 - CALCUL DES RAYONS DES COUCHES 1,2 ET 3
      
      NEDEP=0
      NEFIN=NBNOZO(1)
      DO 10 J=1,3
        DELTA(J) = 1.D+10
        DO 20 INNO=NEDEP+1,NEFIN
          NOEU2=TBNOZO(INNO)
          IF(NOEU2.NE.NOEU1) THEN
            DIST = SQRT((COORD(1)-XY(1,NOEU2))**2
     &               + (COORD(2)-XY(2,NOEU2))**2)
            DELTA(J) = MIN(DELTA(J),DIST)
          ENDIF
 20     CONTINUE
        IF(J.NE.3) THEN
          NEDEP=NEFIN
          NEFIN=NEDEP+NBNOZO(J+1)
        ENDIF
 10   CONTINUE
 
C 3 - CALCUL DE L ENERGIE POUR DIFFERENTS RAYONS RAYZ
C     ENER=SOMME(ENERGI(EF)*SPRIM(EF)/AIRE(EF))/AIRTOT
C     LA SOMME S EFFECTUE SUR TOUS LES EFS DES COUCHES 1,2 ET 3
C     AIRTOT EST L AIRE DU CERCLE DE CENTRE NOEU1 ET DE RAYON RAYZ
C     AIRE(EF) EST LA SURFACE DE L EF CONSIDERE
C     SPRIM(EF) EST LA SURFACE DE L EF CONSIDERE INCLUE DANS LE CERCLE 
C     CAS 1 : EF INCLU DANS LE CERCLE => SPRIM(EF)=AIRE(EF)
C     CAS 2 : EF EXCLU DU CERCLE      => SPRIM(EF)=0
C     CAS 3 : EF INCLUE EN PARTIE     => SPRIM(EF) A CALCULER 

      DO 30 IINT = 1,NBINT
        
        RAYZ(IINT) = DELTA(1)+(DELTA(3)-DELTA(1))*(IINT-1)/(NBINT-1)
        ENER(IINT) = 0.D+0
        AIRTOT = 0.D+0

C 3.1 - BOUCLE SUR LES EFS    

        DO 40 INEL = 1,NBELT  

          NUEF = TBELZO(INEL)
          NSOMM=ICNC(1,NUEF)
          
C 3.1.1 - NOMBRE DE NOEUD NINTER DE L EF INEL INCLU DANS LE CERCLE

          NINT = 0
          IPOI1 = 0        
          DO 50 INNO = 1,NSOMM
            COOR(1,INNO) = XY(1,ICNC(INNO+2,NUEF))
            COOR(2,INNO) = XY(2,ICNC(INNO+2,NUEF))
            RAY   = SQRT((COORD(1)-COOR(1,INNO))**2 
     &                 +(COORD(2)-COOR(2,INNO))**2)
            IF (RAY.LE.RAYZ(IINT)) THEN
              NINT = NINT + 1 
              IF (IPOI1.EQ.0) THEN
                IPOI1 = INNO
              ELSE
                IPOI4 = INNO
              ENDIF
            ELSE
              IPOI2 = INNO
            ENDIF
 50       CONTINUE                      

C 3.1.2 - AIRE DE L INTERSECTION SPRIM SELON LES CAS
C         SI NINT=NSOMM SPRIM = AIRE(EF)
C         SI NINT=0     SPRIM = 0
C         SINON ON CORRIGE

          SPRIM = 0.D+0
          IF (NINT.EQ.NSOMM) THEN
            SPRIM = AIRE(NUEF)

C SI 2 NOEUDS APPARTIENNENT AU CERCLE SPRIM=AIRE - TRIANGLE COUPE
C RQ :DINTER CALCULE LES COORDONNEES DES NOEUDS COUPANT LE CERCLE

          ELSE IF (NINT.EQ.(NSOMM-1)) THEN
            IP1 = IPOI2 + 1
            IF (IP1.GT.NSOMM) IP1 = IP1 - NSOMM
            CALL DINTER(COORD,RAYZ(IINT),COOR(1,IPOI2),COOR(1,IP1),
     &                  COORIN(1,1))
            IP1 = IPOI2 - 1
            IF (IP1.LE.0) IP1 = IP1 + NSOMM
            CALL DINTER(COORD,RAYZ(IINT),COOR(1,IPOI2),COOR(1,IP1),
     &                  COORIN(1,2))

            CALL DCSPRI(COOR(1,IPOI2),COORIN,SPRIM)
            SPRIM = AIRE(NUEF) - SPRIM

C SI 1 NOEUD APPARTIENT AU CERCLE SPRIM=TRIANGLE COUPE

          ELSE IF (NINT.EQ.1) THEN
            IP1 = IPOI1 + 1
            IF (IP1.GT.3) IP1 = IP1 - 3
            CALL DINTER(COORD,RAYZ(IINT),COOR(1,IPOI1),COOR(1,IP1),
     &                  COORIN(1,1))
            IP1 = IPOI1 + 2
            IF (IP1.GT.3) IP1 = IP1 - 3
            CALL DINTER(COORD,RAYZ(IINT),COOR(1,IPOI1),COOR(1,IP1),
     &                  COORIN(1,2))
          
            CALL DCSPRI(COOR(1,IPOI1),COORIN,SPRIM)
                    
C CAS PARTICULIER DES QUADRILATERES

          ELSE IF (NSOMM.EQ.4 .AND. NINT.EQ.2 ) THEN
            IF ( IPOI1.EQ.1 .AND. IPOI4.EQ.4 ) THEN
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,1),COOR(1,2),
     &                    COORIN(1,1))
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,4),COOR(1,3),
     &                    COORIN(1,2))
              CALL DCQPRI(COOR(1,1),COOR(1,4),COORIN,SPRIM)
            ELSE IF ( IPOI1.EQ.3 .AND. IPOI4.EQ.4 ) THEN
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,4),COOR(1,1),
     &                    COORIN(1,1))
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,3),COOR(1,2),
     &                    COORIN(1,2))
              CALL DCQPRI(COOR(1,4),COOR(1,3),COORIN,SPRIM)
            ELSE IF (IPOI1.EQ.2 .AND. IPOI4.EQ.3 ) THEN
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,3),COOR(1,4),
     &                    COORIN(1,1))
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,2),COOR(1,1),
     &                    COORIN(1,2))
              CALL DCQPRI(COOR(1,3),COOR(1,2),COORIN,SPRIM)
            ELSE IF ( IPOI1.EQ.1 .AND. IPOI4.EQ.2 ) THEN
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,2),COOR(1,3),
     &                    COORIN(1,1))
              CALL DINTER(COORD,RAYZ(IINT),COOR(1,1),COOR(1,4),
     &                    COORIN(1,2))
              CALL DCQPRI(COOR(1,2),COOR(1,1),COORIN,SPRIM)
            ELSE
              CALL UTMESS('F','DFORT2','IPOI1 ET IPOI4 NON TRAITE')
            ENDIF
          ENDIF

          IF (SPRIM.LT.0.D0) CALL UTMESS('F','DFORT2','SPRIM NEGATIVE'//
     &                                 ' BIZARRE')

C 3.1.3 - CALCUL DE L ENERGIE 

          ENER(IINT) = ENER(IINT) + ENERGI(NUEF) * SPRIM / AIRE(NUEF)
          AIRTOT = AIRTOT + SPRIM

C 2 - FIN DE LA BOUCLE SUR TOUS LES EF

 40     CONTINUE

        IF (AIRTOT.GT.0.D0.AND.ENER(IINT).GT.0.D0) THEN
          ENER(IINT) = ENER(IINT) / AIRTOT 
        ELSE
          CALL UTMESS('F','DFORT2','AIRTOT OU ENER NUL')
        ENDIF

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
