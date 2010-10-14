      SUBROUTINE CLCOPT ( FCTTAB, ATAB, AX, AY )
C_____________________________________________________________________
C
C CLCOPT
C
C RECHERCHE DU MINIMUM D'ARMATURES (METHODE DE CAPRA ET MAURY)
C
C I FCTTAB     PARAMETRES TRIGONOMETRIQUES POUR LES (36) FACETTES
C I ATAB       SECTIONS DES ARMATURES (DENSITES) CALCULEES PAR FACETTE
C O AX         SECTION DES ARMATURES EN X
C O AY         SECTION DES ARMATURES EN Y
C
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/10/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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

        REAL*8 FCTTAB(36,3)
        REAL*8 ATAB(36)
        REAL*8 AX
        REAL*8 AY

        REAL*8 PRECIS
        PARAMETER (PRECIS = 1D-10)

C       DIMENSIONNEMENT DES TABLEAUX DE POINTS DU POLYGONE
C       BORDANT LE DOMAINE DE VALIDITE
        INTEGER PLGNNB
        PARAMETER (PLGNNB = 72)

C         ******   POLYGONE BORDANT LE DOMAINE DE VALIDITE  ******
C           TABLEAUX DES POSITIONS (SURDIMENSIONNES)
        REAL*8 XP(PLGNNB)
        REAL*8 YP(PLGNNB)

C       ANGLES THETA
        INTEGER AP(PLGNNB)

C       TABLEAU DE SUIVI DES INDICES
C       (CONTIENT A CHAQUE INDICE LE SUIVANT)
C          - DONNE LA SEQUENCE DES POINTS DU POLYGONE (CHAINE),
C            TERMINEE PAR 0
C          - FOURNIT LE NUMERO LIBRE SUIVANT QUAND CELUI-CI EST UTILISE
        INTEGER INEXT(PLGNNB)

C       PREMIER INDICE LIBRE
C       (L'INDICE LIBRE SUIVANT IFREE <- INEXT(IFREE))
        INTEGER IFREE

C       INDICES DE SEGMENT COURANT
C         I...1 = INDICE DE DEBUT DU SEGMENT
C         I...2 = INDICE DE FIN DE SEGMENT
        INTEGER ICUR1, ICUR2

C       INDICES DE NOUVEAU SEGMENT
C         I...1 = INDICE DE DEBUT DU SEGMENT
C         I...2 = INDICE DE FIN DE SEGMENT
        INTEGER INEW1, INEW2

C       CARACTERISTIQUE DES SEGMENTS (CALCUL DE L'INTERSECTION)
        REAL*8 PHICUR
        REAL*8 PHINEW

C       RECHERCHE DU MIN
        REAL*8 TMP0
        REAL*8 TMP1

        INTEGER I, II, J

C       INITIALISATION DES SUIVANTS
        DO 30 ICUR1 = 1, PLGNNB
            INEXT(ICUR1) = ICUR1 + 1
            XP(ICUR1)    = 1D+6
            YP(ICUR1)    = 1D+6
   30   CONTINUE

C       CREATION DE 2 PREMIERS SEGMENTS A INTERSECTER
        I = 36/2

        ICUR1 = 1
        TMP0 = ATAB(I+1)
        XP(ICUR1) = TMP0
        YP(ICUR1) = 1D+6
        AP(ICUR1) = 1

        ICUR1 = 2
        TMP0 = ATAB(I+1)
        XP(ICUR1) = TMP0
        TMP0 = ATAB(1)
        YP(ICUR1) = TMP0
        AP(ICUR1) = I+1

        ICUR1 = 3
        XP(ICUR1) = 1D+6
        TMP0 = ATAB(1)
        YP(ICUR1) = TMP0
        AP(ICUR1) = 1

C       FIN (PROVISOIRE) DE LA CHAINE DES INDICES DE POINTS DU POLYGONE
        INEXT(3) = 0
C       PREMIER INDICE LIBRE
        IFREE = 4

        DO 40 I = 2, 36
          IF( I .NE. (36/2)+1 ) THEN
            PHICUR = 1D0
            ICUR1 = 1
            INEW2 = 0
            DO 400 J=1,PLGNNB
              ICUR2 = INEXT(ICUR1)
              PHINEW = FCTTAB(I,1) * XP(ICUR2)
     &               + FCTTAB(I,2) * YP(ICUR2)
     &               - ATAB(I)
              IF( PHINEW .LT. -PRECIS) THEN
                IF( PHICUR .LT. -PRECIS ) THEN
                  INEXT(ICUR1) = IFREE
                  IFREE = ICUR1
                ELSE
                  INEW1 = IFREE
                  IFREE = INEXT(IFREE)
                  II = AP(ICUR2)
                  TMP0 = 1D0 /
     &             (FCTTAB(I,1)*FCTTAB(II,2)-FCTTAB(II,1)*FCTTAB(I,2))
                  XP(INEW1) =
     &              (ATAB(I)*FCTTAB(II,2)-ATAB(II)*FCTTAB(I,2))*TMP0
                  YP(INEW1) =
     &              (ATAB(II)*FCTTAB(I,1)-ATAB(I)*FCTTAB(II,1))*TMP0
                  AP(INEW1) = II
                  INEXT(ICUR1) = INEW1
                ENDIF
              ELSE
                IF ( PHICUR .LT. -PRECIS ) THEN
                  INEW2 = IFREE
                  IFREE = INEXT(IFREE)
                  II = AP(ICUR2)
                  TMP0 = 1D0 /
     &             (FCTTAB(I,1)*FCTTAB(II,2)-FCTTAB(II,1)*FCTTAB(I,2))
                  XP(INEW2) =
     &              (ATAB(I)*FCTTAB(II,2)-ATAB(II)*FCTTAB(I,2))*TMP0
                  YP(INEW2) =
     &              (ATAB(II)*FCTTAB(I,1)-ATAB(I)*FCTTAB(II,1))*TMP0
                  AP(INEW2) = I
                  INEXT(INEW1) = INEW2
                  INEXT(INEW2) = ICUR2
                  INEXT(ICUR1) = IFREE
                  IFREE = ICUR1
                ENDIF
              ENDIF
              IF ( (INEXT(ICUR2) .LT. 1) .OR. (INEW2 .GE. 1) ) THEN
                GO TO 401
              ENDIF
              ICUR1 = ICUR2
              PHICUR = PHINEW
  400       CONTINUE
  401       CONTINUE
          ENDIF
   40   CONTINUE

C       RECHERCHE DU MINIMUM DE XP(*)+YP(*)
        ICUR1 = 1
        TMP0 = 1D99
   50   CONTINUE
          TMP1 = XP(ICUR1) + YP(ICUR1)
C         -- LORSQUE 2 FACETTES DONNENT QUASIMENT LE MEME XP+YP,
C            ON VEUT QUE L'ALGORITHME TROUVE TOUJOURS LA MEME FACETTE
C            QUELQUE SOIENT LES OPTIONS DE COMPILATION.
C            POUR CELA, ON FAVORISE LA 1ERE FACETTE RENCONTREE EN
C            NE CHANGEANT DE MINIMUM QUE SI LE GAIN EST APRECIABLE :
          IF( TMP1 .LE. 0.9999D0*TMP0) THEN
            TMP0 = TMP1
            ICUR2 = ICUR1
          ENDIF
          ICUR1 = INEXT(ICUR1)
          IF( ICUR1 .GT. 0 ) THEN
            GOTO 50
          ENDIF

        AX = XP(ICUR2)
        AY = YP(ICUR2)


9999  CONTINUE
      END
