      SUBROUTINE TANGNT(NO,NBNO,DIME,TANG)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C 
      IMPLICIT NONE
      INTEGER DIME
      INTEGER NBNO      
      REAL*8  NO(DIME,*)
      REAL*8  TANG(DIME,DIME-1,*) 
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CALCUL DES TANGENTES MOYENNES AUX NOEUDS D'UNE MAILLE
C
C ----------------------------------------------------------------------
C 
C
C IN  NO     : COORDONNEES DES NOEUDS
C IN  NBNO   : NOMBRE DE NOEUDS MAILLE MOYENNE
C IN  DIME   : DIMENSION DE L'ESPACE
C OUT TANG   : TANGENTE[S] AUX NOEUDS
C                DIM: (DIME,DIME-1,*)
C                      ( T1.1X,T1.1Y,[T1.1Z,T1.2X,T1.2Y,T1.2Z],
C                       [T2.1X, ... ] )
C                        T1.1 [T1.2] TANGENTE[S] CONSTANTE[S] 
C                        OU T*.1 [T*.2] TANGENTE[S] AU NOEUD *
C
C ----------------------------------------------------------------------
C
      INTEGER     TANMAX
      PARAMETER  (TANMAX=162)
      INTEGER     I,J,K,L,Q,NBTANG
      REAL*8      R,COETAN(TANMAX)
      CHARACTER*8 TYPTAN
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      NBTANG = DIME-1
      TYPTAN = 'VARIABLE'
      Q      = 0
      IF ((NBNO.LT.0).OR.(NBNO.GT.27)) THEN
        WRITE(6,*) 'NBNO: ',NBNO
        CALL ASSERT(.FALSE.)
      ENDIF  
C
C --- COEFFICIENTS POUR LE CALCUL DES TANGENTES
C
      CALL COTANG(NBNO,DIME,TYPTAN,TANMAX,COETAN)
C
      IF (TYPTAN.EQ.'VARIABLE') THEN
        DO 10 I = 1, NBNO
          DO 11 J = 1, NBTANG
            DO 12 K = 1, DIME
              TANG(K,J,I) = 0.D0
 12         CONTINUE
 11       CONTINUE
 10     CONTINUE
      ELSEIF (TYPTAN.EQ.'CONSTANT') THEN
        DO 60 I = 1, NBTANG
          DO 61 J = 1, DIME
            TANG(J,I,1) = 0.D0
 61       CONTINUE
 60     CONTINUE
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF       
C
C --- TANGENTES VARIABLES SUR LA MAILLE
C
      IF (TYPTAN.EQ.'VARIABLE') THEN
C 
C --- NOEUDS DE LA MAILLE MOYENNE
C
        DO 20 I = 1, NBNO
          DO 21 J = 1, NBTANG
            DO 22 K = 1, NBNO
              Q = Q + 1
              R = COETAN(Q)       
              IF (R.NE.0.D0) THEN
                DO 30 L = 1, DIME
                  TANG(L,J,I) = TANG(L,J,I) + R*NO(L,K)
 30             CONTINUE
              ENDIF
 22         CONTINUE 
 21       CONTINUE 
 20     CONTINUE 
C
C --- TANGENTES CONSTANTES SUR LA MAILLE
C
      ELSEIF (TYPTAN.EQ.'CONSTANT') THEN
C 
C --- NOEUDS DE LA MAILLE MOYENNE
C
        DO 70 I = 1, NBTANG
          DO 71 J = 1, NBNO
            Q = Q + 1
            R = COETAN(Q)
            IF (R.NE.0.D0) THEN
              DO 80 K = 1, DIME
                TANG(K,I,1) = TANG(K,I,1) + R*NO(K,J)
 80           CONTINUE
            ENDIF
 71       CONTINUE 
 70     CONTINUE 
C
C --- TANGENTES CONSTANTES SUR LA MAILLE --> ON TRANSFERE LES TANGENTES
C --- AUX NOEUDS PAR SIMPLE RECOPIE
C
        DO 110 I = 2, NBNO
          DO 111 J = 1, NBTANG
            CALL DCOPY(NBNO,TANG(1,J,1),1,TANG(1,J,I),1)
 111      CONTINUE
 110    CONTINUE
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C             
      END
