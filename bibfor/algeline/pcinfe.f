      SUBROUTINE PCINFE(N,ICPL,ICPC,ICPD,ICPLP,ICPCP,IND,LCA,IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 29/03/2010   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C       S.P. PCINFE IDEM S-P PCFULL
C                    SAUF NON CREATION COEFS SUR U

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C BUT : CE SP CALCULE LES POINTEURS ICPLP,ICPCP
C ----  CORRESPONDANTS AU 'REMPLISSAGE' DE LA
C       MATRICE EN COURS DE FACTORISATION

C       VERSION GENERALE : MATRICE A STRUCTURE QUELCONQUE

C   PARAMETRES D'ENTREE:
C   -------------------

C   ICPL,ICPD,ICPC : LES POINTEURS ASSOCIES A LA MATRICE A FACTORISER

C   * ICPL(I) = ADRESSE DANS LE RANGEMENT DES COEFFICIENTS A(I,J)
C               DU DERNIER COEFFICIENT DE LA LIGNE I
C   * ICPC(K) = POUR K = ICPL(I-1)+1...ICPL(I) NUMEROS DES INDICES DE
C               COLONNE J, DES COEFFICIENTS A(I,J) DE LA LIGNE I
C               ( RANGES PAR ORDRE DE J CROISSANT)
C   * ICPD(I) = ADRESSE DANS LE RANGEMENT DES COEFFICIENTS A(I,J)
C               DU DERNIER COEFFICIENT DE LA LIGNE I AVEC A(I,J), J < I

C   IND         : TABLEAU UTILITAIRE
C   LCA         : TAILLE MAXIMALE ADMISE POUR LA MATRICE FACTORISEE

C   PARAMETRE DE SORTIE:
C   -------------------

C   ICPLP,ICPCP : LES POINTEURS ASSOCIES AU REMPLISSAGE

C   * ICPLP(I) = ADRESSE DANS LE RANGEMENT DES COEFFICIENTS A(I,J)
C               DU DERNIER COEFFICIENT DE REMPLISSAGE DE LA LIGNE I
C   * ICPCP(K) = POUR K = ICPL(I-1)+1...ICPL(I) NUMEROS DES INDICES DE
C               COLONNE J, DES COEFFICIENTS DE REMPLISSAGE DE LA LIGNE I
C               ( RANGES PAR ORDRE DE J CROISSANT)

C   ICPL,ICPC  : LES POINTEURS ASSOCIES A LA MATRICE FACTORISEE
C                ( REUNION DE ICPL ET ICPLP, ICPC ET ICPCP )
C   NZA        : NOMBRE DE COEFFICIENTS DE LA MATRICE FACTORISEE

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C TOLE CRP_4
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER*4 ICPC(*)
      INTEGER ICPL(0:N),ICPD(N)
      INTEGER ICPLP(0:N),ICPCP(*),IND(N)

C     INITIALISATION DU TABLEAU INDIC
C     -------------------------------

      DO 10 I = 1,N
        IND(I) = 0
   10 CONTINUE
      IC1 = 0
      IC2 = 0
      K1 = 1

C     FACTORISATION LOGIQUE : LIGNE PAR LIGNE
C     ---------------------------------------

      DO 50 I = 1,N
        K2 = ICPL(I)

C     MISE A JOUR DU TABLEAU INDIC

        DO 20 K = K1,K2
          J = ICPC(K)
          IND(J) = I
   20   CONTINUE
        IND(I) = I

C     RECHERCHE DANS LA LIGNE I DES L(I,J) NON NULS

        DO 40 K = K1,ICPD(I)
          J = ICPC(K)

C     RECHERCHE DANS LA LIGNE J DES U(J,JJ) NON NULS

          DO 30 L = ICPD(J) + 1,ICPL(J)
            JJ = ICPC(L)

C     LE COEFFICIENT L(I,JJ) EXISTE-T-IL ?
C                         ARRET AU PREMIER  U(JJ,I)

            IF (JJ.GE.I) GO TO 30

            IF (IND(JJ).NE.I) THEN

C     NON ==> CREATION D'UN COEFFICIENT DE REMPLISSAGE

              IC1 = IC1 + 1

C     TEST DE DEPASSEMENT DE DIMENSION (PROTECTION DES TABLEAUX)

              IF (IC1.GT.LCA) THEN
C               WRITE (6,107) NIV,LCA,I
                ISTOP = I
                GO TO 100
              END IF

C     STOCKAGE DE L'INDICE DE COLONNE DU COEFFICIENT LU(I,JJ)

              ICPCP(IC1) = JJ

C     MISE A JOUR DU TABLEAU INDIC

              IND(JJ) = I
            END IF
   30     CONTINUE
   40   CONTINUE

C     RECLASSEMENT DES INDICES DE COLONNE PAR ORDRE CROISSANT

        CALL PCTRII(ICPCP(IC2+1),IC1-IC2)

C     MISE A JOUR DU POINTEUR ICPLP

        ICPLP(I) = IC1
        IC2 = IC1
        K1 = K2 + 1
   50 CONTINUE
      ICPLP(0) = 0

C     AVANT FUSION DE ICPC ET ICPCP
C     TEST DE DEPASSEMENT DE DIMENSION (PROTECTION DES TABLEAUX)

      K1 = ICPL(N)
      KP1 = ICPLP(N)
      NZERO = K1 + KP1
      IF (NZERO.GT.LCA) THEN
C       WRITE (6,200) NIV,LCA,NZERO
        IER = NZERO
        GO TO 150
      END IF

C     CREATION DES TABLEAUX ICPL ET ICPC
C     POUR LA MATRICE FACTORISEE : REUNION DES TABLEAUX ICPC ET ICPCP
C     ---------------------------------------------------------------

      K = NZERO
      DO 90 I = N,1,-1
        ICPL(I) = K
        KP2 = ICPLP(I-1)
        K2 = ICPL(I-1)
   60   CONTINUE
        IF (K1.GT.K2) THEN
          IF (KP1.GT.KP2) THEN
C       -------------------
            IF (ICPC(K1).LT.ICPCP(KP1)) THEN
              ICPC(K) = ICPCP(KP1)
              K = K - 1
              KP1 = KP1 - 1
            ELSE
              ICPC(K) = ICPC(K1)
              K = K - 1
              K1 = K1 - 1
            END IF
          ELSE
            ICPC(K) = ICPC(K1)
            K = K - 1
            K1 = K1 - 1
          END IF
        ELSE
C     ---- LIGNE DE L EPUISEE ------
   70     CONTINUE
          IF (KP1.GT.KP2) THEN
            ICPC(K) = ICPCP(KP1)
            K = K - 1
            KP1 = KP1 - 1
          ELSE
            GO TO 80
          END IF
          GO TO 70
        END IF
C     ------
        GO TO 60
   80   CONTINUE
   90 CONTINUE

C     LE NOMBRE DE COEFFICIENTS DE LA MATRICE FACTORISEE

C     NZCA = NZERO
C     WRITE (6,*) ' FIN DU S-P PCINFE  TAILLE FACTORISEE= ',NZCA

      GO TO 150

C  DEPASSEMENT DE DIMENSION ON CALCULE IC1= PLACE A AJOUTER

  100 CONTINUE
      DO 140 I = ISTOP,N
        K2 = ICPL(I)
        DO 110 K = K1,K2
          J = ICPC(K)
          IND(J) = I
  110   CONTINUE
        IND(I) = I
        DO 130 K = K1,ICPD(I)
          J = ICPC(K)
          DO 120 L = ICPD(J) + 1,ICPL(J)
            JJ = ICPC(L)
            IF (JJ.GE.I) GO TO 120

            IF (IND(JJ).NE.I) THEN
C     NON ==> CREATION D'UN COEFFICIENT DE REMPLISSAGE
              IC1 = IC1 + 1
              IND(JJ) = I
            END IF
  120     CONTINUE
  130   CONTINUE
        K1 = K2 + 1
  140 CONTINUE
C NZERO=TAILLE MAT INI.+TAILLE MAT REMPLIE
      NZERO = ICPL(N) + IC1
C     WRITE (6,200) NIV,LCA,NZERO
      IER = NZERO
  150 CONTINUE

  107 FORMAT (' NIVEAU',I4,' REMPLISSAGE FINAL',/,
     &       'ARRET DES CALCULS PLACE MEMOIRE',I12,
     &       ' INSUFFISANTE  LIGNE ',I9)
  200 FORMAT (' NIVEAU',I4,' REMPLISSAGE FINAL',/,
     &       'ARRET DES CALCULS PLACE MEMOIRE',I12,
     &       ' INSUFFISANTE IL FAUT ',I12)
      END
