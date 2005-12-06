       SUBROUTINE DZONFG(NSOMMX,ICNC,NELCOM,NUMELI,INNO,
     &                   TBELZO,NBELZO,TBNOZO,NBNOZO)
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

C*********************************************
C              BUT DE CETTE ROUTINE :        *
C RECHERCHER LES EFS ET LES NOEUDS COMPOSANT * 
C LES COUCHES 1, 2 ET 3                      *
C*********************************************

C IN  NSOMMX                 : NOMBRE DE SOMMETS MAX PAR EF
C IN  ICNC(NSOMMX+2,NELEM)   : CONNECTIVITE EF => NOEUDS CONNECTES
C     1ERE VALEUR = NBRE DE NOEUDS SOMMETS CONNECTES A L EF N�X
C     2EME VALEUR = 1 SI EF UTILE 0 SINON
C     SUITE EF N�X=>N� DE NOEUDS SOMMETS CONNECTES A X
C     EN 2D EF UTILE = QUAD OU TRIA
C     EN 3D EF UTILE = TETRA OU HEXA
C IN  NELCOM                 : NOMBRE MAX D'EF PAR NOEUD
C IN  NUMELI(NELCOM+2,NNOEM) : CONNECTIVITE NOEUD X=>EF CONNECTES A X
C     1ERE VALEUR = NBRE D EFS UTILES CONNECTES AU NOEUD N�X
C     2EME VALEUR = 0 NOEUD MILIEU OU NON CONNECTE A UN EF UTILE
C                   1 NOEUD SOMMET A L INTERIEUR + LIE A UN EF UTILE
C                   2 NOEUD SOMMET BORD + LIE A UN EF UTILE
C     CONNECTIVITE  NOEUD N�X=>N� DES EF UTILE CONNECTES A X
C IN  INNO                   : NOEUD CONSIDER
C OUT TBELZO(SOMME(NBELZO))  : TOUS LES EFS COMPOSANTS LA ZONE
C OUT NBELZO(3)              : NOMBRE D EFS DES COUCHES 1 2 ET 3
C                              NBELZO(1)=NBR D EFS COUCHE 1
C                              NBELZO(2)=NBR D EFS COUCHES 1 ET 2
C                              NBELZO(3)=NBR D EFS COUCHES 1, 2 ET 3
C OUT TBNOZO(SOMME(NBNOZO))  : TOUS LES NOEUDS COMPOSANTS LA ZONE
C OUT NBNOZO(3)              : NOMBRE DE NOEUDS DES COUCHES 1 2 ET 3

      IMPLICIT NONE 

C DECLARATION GLOBALE

      INTEGER NSOMMX,ICNC(NSOMMX+2,*),NELCOM,NUMELI(NELCOM+2,*) 
      INTEGER INNO
      INTEGER TBELZO(1000),NBELZO(3),TBNOZO(1000),NBNOZO(3)      

C DECLARATION LOCALE  

      INTEGER J,INEL,NUEF,IND,NOEUD,IEL,ELEM,N
      INTEGER NEDEP,NEFIN,NBELCO,NBNOCO
      LOGICAL TEST

C 1 - EFS DES COUCHES 1, 2 ET 3
C 1.1 - COUCHE 1
      
      NBELZO(1) = NUMELI(1,INNO)
      IF (NBELZO(1).GT.1000) CALL UTMESS('F','DZONFG','TBELZO'//
     &                                         ' DEPASSEMENT') 
      DO 10 INEL = 1,NBELZO(1)
        TBELZO(INEL) = NUMELI(INEL+2,INNO)
 10   CONTINUE 

C 1.2 - COUCHES 2 ET 3
      
      NEDEP = 1
      NEFIN = NBELZO(1)

      DO 20 J = 1,2
        NBELCO = 0
        DO 30 INEL = NEDEP,NEFIN
          NUEF = TBELZO(INEL)
          DO 40 IND = 1,ICNC(1,NUEF)
            NOEUD = ICNC(IND+2,NUEF)
            DO 50 IEL = 1,NUMELI(1,NOEUD)
              ELEM = NUMELI(IEL+2,NOEUD)
              TEST = .TRUE.
              N = 1
 60           CONTINUE             
              IF (N.LE.(NEFIN+NBELCO).AND.TEST) THEN
                IF ( TBELZO(N).EQ.ELEM ) TEST = .FALSE.
                N=N+1
                GOTO 60
              ENDIF
              IF ( TEST ) THEN
                NBELCO = NBELCO + 1
                IF ((NEFIN+NBELCO).GT.1000) CALL UTMESS('F','DZONFG',
     &                                      'TBELZO DEPASSEMENT') 
                TBELZO(NEFIN+NBELCO) = ELEM
              ENDIF
 50         CONTINUE
 40       CONTINUE
 30     CONTINUE
        IF ( J.EQ.1 ) THEN
          NBELZO(2) = NBELCO
          NEDEP = NBELZO(1)+1
          NEFIN = NBELZO(1)+NBELZO(2)
        ELSE 
          NBELZO(3) = NBELCO
        ENDIF
 20   CONTINUE

C 2 - NOEUDS DES COUCHES 1 2 ET 3

      NBNOZO(1) = 1
      NBNOZO(2) = 0
      NBNOZO(3) = 0
      TBNOZO(1) = INNO
      NBNOCO = 1
      
      NEDEP=0
      NEFIN=NBELZO(1)
      
      DO 70 J=1,3
        DO 80 INEL = NEDEP+1,NEFIN
          NUEF = TBELZO(INEL)
          DO 90 IND = 1,ICNC(1,NUEF)
            NOEUD = ICNC(IND+2,NUEF)
            N = 1
            TEST = .TRUE.
 100        CONTINUE          
            IF ( N.LE.NBNOCO .AND. TEST ) THEN
              IF ( TBNOZO(N).EQ.NOEUD ) TEST = .FALSE.
              N=N+1
              GOTO 100
            ENDIF
            IF ( TEST ) THEN
              NBNOZO(J) = NBNOZO(J) + 1
              NBNOCO = NBNOCO + 1
              IF (NBNOCO.GT.1000) CALL UTMESS('F','DZONFG',
     &                               'TBNOZO DEPASSEMENT') 
              TBNOZO(NBNOCO) = NOEUD
            ENDIF
 90       CONTINUE
 80     CONTINUE
        IF (J.NE.3) THEN
          NEDEP=NEFIN
          NEFIN=NEDEP+NBELZO(J+1)
        ENDIF
 70   CONTINUE          
      
      NBELZO(2)=NBELZO(1)+NBELZO(2)
      NBELZO(3)=NBELZO(2)+NBELZO(3)
      END
