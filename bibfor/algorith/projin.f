      SUBROUTINE PROJIN(DIAGNO,TOLEOU,DIAG,ARETE,NOEUD,DEBORD,
     &                  PROYES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
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
      IMPLICIT NONE
C
      INTEGER       DIAGNO
      REAL*8        TOLEOU
      INTEGER       DIAG(2)
      INTEGER       ARETE(4)
      INTEGER       NOEUD(4)
      REAL*8        DEBORD 
      INTEGER       PROYES
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJMA
C ----------------------------------------------------------------------
C
C CETTE ROUTINE VERIFIE LA PROJECTION SUR UNE ENTITE GEOMETRIQUE
C LORS DE LA PROJECTION D'UN NOEUD ESCLAVE SUR UNE MAILLE MAITRE, ON
C PEUT "TOMBER" SUR UNE ENTITE GEOMETRIQUE ELEMENTAIRE.
C    POUR UN QUADRANGLE: UN DES QUATRE NOEUDS, UNE DES QUATRE ARETES OU 
C     UNE DES DEUX DIAGONALES
C    POUR UN TRIANGLE: UN DES TROIS NOEUDS, UNE DES TROIS ARETES
C    POUR UN SEGMENT: UN DES DEUX NOEUDS
C ON PEUT AUSSI TOMBER "EN DEHORS" DE LA MAILLE MAITRE. LA PROJECTION
C  EST ALORS RAMENEE SUR LA MAILLE DANS LES ROUTINES INTERNES (VOIR
C  PROJSE PAR EXEMPLE). MAIS IL EST POSSIBLE D'iGNORER CE RABATTEMENT
C
C POUR LES MAILLES QUADRATIQUES, ON IGNORE LES NOEUDS MILIEUX
C
C IN  DIAGNO : FLAG POUR DETECTION PROJECTION SUR ENTITES GEOMETRIQUES
C IN  TOLEOU : TOLERANCE POUR DETECTION PROJECTION EN DEHORS 
C              MAILLE MAITRE
C IN  DEBORD : PROJECTION HORS DE LA MAILLE
C              >0 : PROJECTION HORS DE LA MAILLE
C              <0 : PROJECTION SUR LA MAILLE
C IN  DIAG   : DETECTION DE PROJECTION SUR PSEUDO_DIAGONALES
C                 (1: SUR L'ARETE, 0 NON)
C              DIAG(1) : ARETE AC
C              DIAG(2) : ARETE BD
C IN  ARETE  : DETECTION DE PROJECTION SUR ARETE
C                 (1: SUR L'ARETE, 0: NON)
C              ARETE(1) : SEGMENT AB
C              ARETE(2) : SEGMENT BC
C              ARETE(3) : SEGMENT CD
C              ARETE(4) : SEGMENT DA
C IN  NOEUD  : DETECTION DE PROJECTION SUR NOEUD 
C                 (1: SUR LE NOEUD, 0: NON)
C              NOEUD(1) : NOEUD A
C              NOEUD(2) : NOEUD B
C              NOEUD(3) : NOEUD C
C              NOEUD(4) : NOEUD D
C OUT PROYES : TYPE DE PROJECTION
C              -1XXX  PROJECTION EN DEHORS
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEOU ET DEBORD) 
C                    -> ON A ALORS FORCEMENT PROJECTION SUR UN NOEUD OU
C                        UNE ARETE
C                       000 : IMPOSSIBLE
C                       20X:  PROJECTION SUR L'ARETE X
C                       30X:  PROJECTION SUR LE NOEUD X
C            
C              -30X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE NOEUD
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET NOEUD)
C                      X EST LE NUMERO DE NOEUD (1 A 4)
C              -20X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE ARETE
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET ARETE)
C                      X EST LE NUMERO D'ARETE (1 A 4)
C              -10X   PROJECTION SUR
C                   ENTITE GEOMETRIQUE DIAG (PSEUDO SUR QUADRANGLE)
C                   DE LA MAILLE MAITRE (TOLERANCE TOLEIN ET DIAG)
C                      X EST LE NUMERO DE DIAGONALE (1 A 2)
C               0     PROJECTION NORMALE
C
C ----------------------------------------------------------------------
C
      PROYES = 0
C
C --- GESTION DES DEBORDEMENTS HORS ZONE
C
      IF (DEBORD.GT.0.D0) THEN
         IF (TOLEOU.GT.0.D0) THEN               
            IF (DEBORD.GT.TOLEOU) THEN
              PROYES = -1000
            ENDIF
         ENDIF  
      ENDIF
C
C --- GESTION DES PROJECTIONS SUR ENTITES GEOMETRIQUES
C
      IF (DIAGNO.NE.0) THEN
          IF (NOEUD(1).EQ.1) THEN
             PROYES = PROYES - 301
             GOTO 10
          ENDIF
          IF (NOEUD(2).EQ.1) THEN
             PROYES = PROYES - 302
             GOTO 10
          ENDIF
          IF (NOEUD(3).EQ.1) THEN
             PROYES = PROYES - 303
             GOTO 10
          ENDIF
          IF (NOEUD(4).EQ.1) THEN
             PROYES = PROYES - 304
             GOTO 10
          ENDIF
          IF (ARETE(1).EQ.1) THEN
             PROYES = PROYES - 201
             GOTO 10
          ENDIF
          IF (ARETE(2).EQ.1) THEN
             PROYES = PROYES - 202
             GOTO 10
          ENDIF
          IF (ARETE(3).EQ.1) THEN
             PROYES = PROYES - 203
             GOTO 10
          ENDIF
          IF (ARETE(4).EQ.1) THEN
             PROYES = PROYES - 204
             GOTO 10
          ENDIF
          IF (DIAG(1).EQ.1) THEN
             PROYES = PROYES - 101
             GOTO 10
          ENDIF
          IF (DIAG(2).EQ.1) THEN
             PROYES = PROYES - 102
             GOTO 10
          ENDIF
      ENDIF

   10 CONTINUE

C ----------------------------------------------------------------------
      END
