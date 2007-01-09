      SUBROUTINE ARLCH3(DIME,NC  ,SIGN,NU  ,B   ,
     &                  INO ,INC ,PREC,EQ  ,ND  ,
     &                  NE  ,NLG ,IMPO,MULT,LIEL,
     &                  NEMA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
      INTEGER SIGN
      INTEGER ND
      INTEGER NE
      INTEGER NLG
      INTEGER NC
      INTEGER NU(*)
      INTEGER INO(*)
      INTEGER INC(*)
      REAL*8  B(*)
      REAL*8  PREC
      LOGICAL EQ(5,*)
      INTEGER LIEL(*)
      INTEGER NEMA(*)
      REAL*8  IMPO(*)
      REAL*8  MULT(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C ECRITURE RELATIONS LINEAIRES COUPLAGE 
C MAILLE COQUE / SOLIDE
C
C ----------------------------------------------------------------------
C       
C
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  NC     : NOMBRE DE NOEUDS DOMAINE DE COLLAGE
C IN  SIGN   : SIGNE DEVANT LA MATRICE B (0 : +, 1 : -)
C IN  NU     : NUMERO DES ELEMENTS DE LIAISON 'D_DEPL_R_*'
C                       * = (DX, DY, DZ, DRX, DRY, DRZ)
C IN  B      : VALEURS DE LA MATRICE ARLEQUIN MORSE (CF ARLCPL)
C IN  INO    : COLLECTION NOEUDS COLONNES DE B   
C IN  INC    : LONGUEUR CUMULEE ASSOCIEE A INO
C IN  PREC   : PRECISION RELATIVE SUR LES TERMES DE B
C IN  EQ     : EQUATIONS SELECTIONNEES
C I/O ND     : NOMBRE DE TERMES
C I/O NE     : NOMBRE D'EQUATIONS
C I/O NLG    : NOMBRE DE LAGRANGES
C I/O IMPO   : VECTEUR CHME.CIMPO.VALE
C I/O MULT   : VECTEUR CHME.CMULT.VALE
C I/O LIEL   : COLLECTION CHME.LIGRE.LIEL
C I/O NEMA   : COLLECTION CHME.LIGRE.NEMA
C
C ----------------------------------------------------------------------
C
      INTEGER I,J,K,L,P0,P1,Q,NL,NO,N
      REAL*8  R
C
C ----------------------------------------------------------------------
C
      Q  = 0
      N  = 2*DIME-1
      P1 = INC(1)
      DO 10 I = 1, NC
        P0 = P1
        P1 = INC(1+I)
        DO 20 J = P0, P1-1 
          NO = INO(J)
          NL = NLG
C ------- RELATIONS COUPLAGE TRANSLATION + ROTATION / TRANSLATION
          DO 20 K = 1, N
            IF (.NOT.EQ(K,I)) THEN
              Q = Q + DIME
            ELSE
              DO 30 L = 1, DIME
                Q = Q + 1
                R = B(Q)
                IF (ABS(R).GT.PREC) THEN
                  CALL ARLASS(SIGN,NO  ,NU  ,L   ,R   ,  
     &                        ND  ,NE  ,NL  ,IMPO,MULT,
     &                        LIEL,NEMA)
                ENDIF
 30           CONTINUE
              NL = NL + 2
            ENDIF
 20     CONTINUE
        NLG = NL
 10   CONTINUE
      END      
