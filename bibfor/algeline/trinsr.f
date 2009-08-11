      SUBROUTINE TRINSR(CLEF,TAB,NTAB,N)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 10/08/2009   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C A_UTIL
C ----------------------------------------------------------------------
C                            TRI PAR INSERTION
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE / SORTIE
C INTEGER CLEF(N)         : VECTEUR CLEF
C INTEGER TAB(N,NTAB)     : TABLEAU A TRIER EN MEME TEMPS QUE CLEF
C                           (SI NTAB = 0, PAS PRIS EN COMPTE)
C
C VARIABLES D'ENTREE
C INTEGER NTAB            : NOMBRE DE COLONNES DE TAB
C INTEGER N               : NOMBRE DE LIGNES A TRIER
C ----------------------------------------------------------------------

      IMPLICIT NONE

C --- VARIABLES

      INTEGER N,NTAB,CLEF(*)
      REAL*8  TAB(N,*)
      INTEGER G,D,I,J,INSER
      REAL*8  TMPR

C --- TRI PAR INSERTION

      DO 10 D = 2, N

        INSER = CLEF(D)
        G = D

C ----- INSERTION DE INSER

 20     CONTINUE

        G = G - 1

        IF (G.GT.0) THEN
          IF (CLEF(G).GT.INSER) THEN
             CLEF(G+1) = CLEF(G)
             GOTO 20
           ENDIF
        ENDIF

        G = G + 1

        IF (G.NE.D) THEN

          CLEF(G) = INSER

C ------- DEPLACEMENT TABLEAU

          DO 30 I = 1, NTAB
            TMPR = TAB(D,I)
            DO 40 J = D-1, G, -1
              TAB(J+1,I) = TAB(J,I)
 40         CONTINUE
            TAB(G,I) = TMPR
 30       CONTINUE

        ENDIF

 10   CONTINUE

      END
