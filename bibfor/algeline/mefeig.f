      SUBROUTINE MEFEIG(NDIM,NBMOD,MATM,MATR,MATA,FRE,KSI,MAVR,ALFR,
     &                  ALFI,MAT1,MAVI,W,Z,IND)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER       NBMOD,NDIM(14),IND(2*NBMOD)
      REAL*8        MATM(NBMOD,NBMOD),MATR(NBMOD,NBMOD)
      REAL*8        MAT1(2*NBMOD,2*NBMOD),MAVI(2*NBMOD,2*NBMOD)
      REAL*8        MATA(NBMOD,NBMOD),FRE(NBMOD),KSI(NBMOD)
      REAL*8        MAVR(2*NBMOD,2*NBMOD),ALFR(2*NBMOD),ALFI(2*NBMOD)
      REAL*8        W(4*NBMOD),Z(4*NBMOD,2*NBMOD)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 05/10/1999   AUTEUR KXBADNG A.ADOBES 
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
C ----------------------------------------------------------------------
C     RESOLUTION DU PROBLEME SOUS ECOULEMENT - CALCUL DES VALEURS ET
C     VECTEURS PROPRES DY SYSTEME GENERALISE
C     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST
C ----------------------------------------------------------------------
C     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
C     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
C     DE TUBES SOUS ECOULEMENT AXIAL"
C ----------------------------------------------------------------------
C IN  : NDIM   : TABLEAU DES DIMENSIONS
C IN  : NBMOD  : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
C IN  : MATM   : MATRICE DE MASSE AJOUTEE REPRESENTANT LA PROJECTION DES
C                EFFORTS FLUIDES INERTIELS DANS LA BASE DES DEFORMEES
C                MODALES DES CYLINDRES
C IN  : MATR   : MATRICE DE RAIDEUR  AJOUTEE REPRESENTANT LA PROJECTION
C                DES EFFORTS FLUIDES DE RAIDEUR DANS LA BASE DES
C                DEFORMEES MODALES DES CYLINDRES
C IN  : MATA   : MATRICE D AMORTISSEMENT AJOUTEE REPRESENTANT LA
C                PROJECTION DES EFFORTS FLUIDES D AMORTISSEMENT DANS LA
C                BASE DES DEFORMEES MODALES DES CYLINDRES
C OUT : FRE    : FREQUENCES SOUS ECOULEMENT
C OUT : KSI    : AMORTISSEMENTS SOUS ECOULEMENT
C OUT : MAVR   : TABLEAU DE TRAVAIL ET DEFORMEES MODALES SOUS ECOULEMENT
C                EN BASE MODALE - PARTIE REEL DES VECTEURS PROPRES
C --  : ALFR   : TABLEAU DE TRAVAIL: PARTIE REELE DE LA FREQUENCE
C                COMPLEXE
C --  : ALFI   : TABLEAU DE TRAVAIL: PARTIE IMAGINAIRE DE LA FREQUENCE
C                COMPLEXE
C --  : MAT1   : TABLEAU DE TRAVAIL: MATRICE A DU SYSTEME A.X = L.X
C --  : MAVI   : TABLEAU DE TRAVAIL POUR L INVERSION DE LA MATRICE DE
C                MASSE - PARTIE IMAGINAIRE DES VECTEURS PROPRES
C --  : W      : TABLEAU DE TRAVAIL: VALEURS PROPRES COMPLEXES APRES
C                RESOLUTION DU SYSTEME
C --  : Z      : TABLEAU DE TRAVAIL: VECTEURS PROPRES COMPLEXES APRES
C                RESOLUTION DU SYSTEME
C OUT : IND    : TABLEAU DE TRAVAIL: INDICES DES VALEURS PROPRES
C                RETENUES, CORRESPONDANT A UNE FREQUENCE POSITIVE, ET
C                ORDONNEES DE FACON CROISSANTE
C ----------------------------------------------------------------------
      INTEGER      I,J,K
      CHARACTER*3  NOTE
      REAL*8       NOREMA,NOREMI,NOIMMA,NOIMMI,NORMR,NORMI,NORM
      REAL*8       TEMP
C ----------------------------------------------------------------------
C
C --- LECTURE DES DIMENSIONS
      NBMOD  = NDIM(2)
C
C
      PI = R8PI()
C
C
C --- INVERSION DE LA MATRICE DE MASSE MAT1 = MATM
C     MAVI EST L IDENTITE
C
      DO 20 I = 1,NBMOD
         DO 10 J = 1,NBMOD
            MAT1(I,J) = MATM(I,J)
            MAVI(I,J) = 0.D0
  10     CONTINUE
         MAVI(I,I) = 1.D0
  20  CONTINUE
C
      IER = 1
      CALL MTCROG(MAT1,MAVI,2*NBMOD,NBMOD,NBMOD,MAVR,ALFR,IER)
      IF ( IER .NE. 0 ) CALL UTMESS('F','MEFEIG',
     &                      'ERREUR DANS L''INVERSION DE LA MASSE')
C
C
C --- CALCUL DU PRODUIT DE L INVERSE DE LA MATRICE DE MASSE PAR LES
C --- MATRICES DE RAIDEUR ET D AMORTISSEMENT
C --- D AMORTISSEMENT
C --- CONSTRUCTION DE LA MATRICE DU PROBLEME MODALE GENERALISE MAR1 = A
      DO 50 I = 1,NBMOD
         DO 40 J = 1,NBMOD
            MAT1(I,NBMOD+J) = 0.D0
            MAT1(NBMOD+I,NBMOD+J) = 0.D0
            MAT1(I,J) = 0.D0
            MAT1(NBMOD+I,J) = 0.D0
            DO 30 K = 1,NBMOD
               MAT1(NBMOD+I,J) = MAT1(NBMOD+I,J) - MAVR(I,K) * MATR(K,J)
               MAT1(NBMOD+I,NBMOD+J) = MAT1(NBMOD+I,NBMOD+J)
     &                               - MAVR(I,K) * MATA(K,J)
  30        CONTINUE
  40     CONTINUE
         MAT1(I,NBMOD+I) = 1.D0
  50  CONTINUE

C
C --- RESOLUTION DU SYSTEME A.X = L.X
C
      IER = 1
      ICODE = 1
      CALL VPHQRP(MAT1,2*NBMOD,2*NBMOD,ICODE,W,Z,2*NBMOD,MAVR,30,
     &            IER,NITQR)
C
      IF(IER.EQ.1) THEN
         CALL UTMESS('F','MEFEIG','ERERUR DANS LA RECHERCHE DES'//
     &                     ' VALEURS PROPRES - PAS DE CONVERGENCE'//
     &                     ' DE L ALGORITHME QR ' )
      ENDIF
C
C --- ALFR: PARTIES REELLES DES VALEURS PROPRES
C --- ALFI: PARTIES IMAGINAIRES DES VALEURS PROPRES
C --- MAVR: PARTIES REELLES DES VECTEURS PROPRES
C --- MAVI: PARTIES IMAGINAIRES DES VECTEURS PROPRES
      DO 60 IHH = 1,2*NBMOD
         ALFR(IHH) = W(2*(IHH-1)+1)
         ALFI(IHH) = W(2*(IHH-1)+2)
         DO 60 JHH = 1,2*NBMOD
         MAVR(JHH,IHH) = Z(2*(JHH-1)+1,IHH)
         MAVI(JHH,IHH) = Z(2*(JHH-1)+2,IHH)
C         MAVR(JHH,IHH) = Z(2*(JHH+(IHH-1)*NBMOD-1)+1)
C         MAVI(JHH,IHH) = Z(2*(JHH+(IHH-1)*NBMOD-1)+2)
  60  CONTINUE
C
C
C --- MINIMISATION DE LA PARTIE IMAGINAIRE DES VECTEURS PROPRES
C --- PAR MULTIPLICATION PAR UNE CONSTANTE COMPLEXE
C --- LES MISES A JOUR SONT FAITES SUR LA TOTALITE DES VECTEURS
C --- LES CALCULS DES NORMES SONT FAITS SUR LES NBMOD PREMIERS TERMES
C
C --  BOUCLE SUR LES VECTEURS PROPRES
      DO 150 I = 1,2*NBMOD
C
C --  ON EFFECTUE LA MINIMISATION QUE SUR LES VECTEURS PROPRES POUR
C --  LESQUELS LES PARTIES IMAGINAIRES DES VALEURS PROPRES
C --  CORRESPONDANTES SONT POSITIVES
         IF(ALFI(I).GE.0.D0) THEN
C
C --        CALCUL DE LA SOMME DES CARRES DES PARTIES REELLES, DES
C           PARTIES IMAGINAIRES ET DES DOUBLES PRODUITS CROISES
            A = 0.D0
            B = 0.D0
            C = 0.D0
            DO 80 J = 1,NBMOD
               A = A + MAVR(J,I)*MAVR(J,I)
               B = B + MAVI(J,I)*MAVI(J,I)
               C = C + MAVR(J,I)*MAVI(J,I)*2
  80        CONTINUE
C
            IF(A.NE.0.D0.AND.B.NE.0.D0.AND.C.NE.0.D0) THEN
C
C --        CALCUL DES COMPLEXES MULTIPLICATEURS ALPHA ET BETA
C           ALPHA = ALPHAR + I . ALPHAI
C           BETA  = BETAR  + I . BETAI
            U = A*A - B*B
            V = A*C + B*C
            DET = U*U +V*V
            ALPHA = (U + SQRT(DET)) / V
            ADIV = SQRT(ALPHA*ALPHA + 1.D0)
            ALPHAR = 1.D0 / ADIV
            ALPHAI = ALPHA / ADIV
            BETA  = (U - SQRT(DET)) / V
            BDIV = SQRT(BETA*BETA + 1.D0)
            BETAR = 1.D0 / BDIV
            BETAI = BETA / BDIV
C
C --        CALCUL DES PRODUITS DES VECTEURS PROPRES PAR ALPHA ET BETA
              DO 90 J = 1,2*NBMOD
              Z(J,1)         = (MAVR(J,I) * ALPHAR - MAVI(J,I) * ALPHAI)
              Z(J+2*NBMOD,1) = (MAVR(J,I) * ALPHAI + MAVI(J,I) * ALPHAR)
              Z(J,2)         = (MAVR(J,I) * BETAR  - MAVI(J,I) * BETAI )
              Z(J+2*NBMOD,2) = (MAVR(J,I) * BETAI  + MAVI(J,I) * BETAR )
  90        CONTINUE
C
C --        CALCUL DE LA SOMME DES CARRES DES PARTIES IMAGINAIRES
            VNORMA = 0.D0
            VNORMB = 0.D0
            DO 100 J = 1,NBMOD
               VNORMA = VNORMA + Z(J+2*NBMOD,1) * Z(J+2*NBMOD,1)
               VNORMB = VNORMB + Z(J+2*NBMOD,2) * Z(J+2*NBMOD,2)
 100        CONTINUE
C
C --        MISE A JOUR DU VECTEUR PROPRE OBTENUS AVEC LE COEFFICIENT
C           ALPHA OU BETA MINIMISANT LA NORME DE LA PARTIE IMAGINAIRE
            IF(VNORMA.LT.VNORMB) THEN
                DO 110 J = 1,2*NBMOD
                   MAVR(J,I) = Z(J,1)
                   MAVI(J,I) = Z(J+2*NBMOD,1)
 110           CONTINUE
            ELSE
                DO 120 J = 1,2*NBMOD
                   MAVR(J,I) = Z(J,2)
                   MAVI(J,I) = Z(J+2*NBMOD,2)
 120           CONTINUE
            ENDIF
C
C --        TRAITEMENT DU CAS OU A OU B OU C = 0
C --        SI B = 0 ON A UN VECTEUR PROPRE REEL: ON NE FAIT RIEN
C --        SI A = 0 ON A UN VECTEUR PROPRE IMAGINAIRE PUR, ON MULTIPLIE
C --                 CE DERNIER PAR -I
C --        SI C=0 ET B>A, ON MULTIPLIE LE VECTEUR PROPRE PAR -I
            ELSE IF(A.EQ.0.D0) THEN
            DO 130 J = 1,2*NBMOD
               MAVR(J,I) = MAVI(J,I)
               MAVI(J,I) = 0.D0
 130        CONTINUE
            ELSE IF(B.GT.A.AND.C.EQ.0.D0) THEN
            DO 140 J = 1,2*NBMOD
               U = MAVI(J,I)
               MAVI(J,I) = - MAVR(J,I)
               MAVR(J,I) = U
 140        CONTINUE
            ENDIF
         ENDIF
C
C --  FIN DE BOUCLE SUR LES VECTEURS PROPRES
 150  CONTINUE
C
C --- NORMALISATION DES VECTEURS PROPRES COMPLEXES (SUR LES NBMOD
C --- PREMIERES COMPOSANTES )
C
         DO 180 I = 1,2*NBMOD
            SNOR = 0.D0
            DO 160 J = 1,NBMOD
               SNOR = SNOR + MAVR(J,I)**2+ MAVI(J,I)**2
 160        CONTINUE
            SNOR = SNOR ** 0.5D0
            IF (SNOR.NE.0.D0) THEN
               DO 170 J = 1,2*NBMOD
                  MAVR(J,I) =  MAVR(J,I) / SNOR
                  MAVI(J,I) =  MAVI(J,I) / SNOR
 170           CONTINUE
            ENDIF
 180     CONTINUE
C
C --- VALEUR PROPRE (J) = (ALFR(J)+I*ALFI(J))
C --- FREQUENCE COMPLEXE : S = ALFR(J) + I*ALFI(J)
C --- PARTIE IMAGINAIRE ALFI(J) = 2*PI*FREQUENCE
C ---                           * RACINE(1-AMORTISSEMENT**2)
C --- PARTIE REELLE     ALFR(J) = -PULSATION*AMORTISSEMENT
C
C
C --- SUPPRESSION DES MODES MATHEMATIQUES DE FREQUENCE NEGATIVE
C --- RECHERCHE DES INDICES DES VALEURS PROPRES CORRESPONDANT A UNE
C --- FREQUENCE POSITIVE

      N = 0
      DO 200 I = 1,2*NBMOD
         IF(ALFI(I).GE.0.D0) THEN
            N = N + 1
            IND(N) = I
         ENDIF
 200  CONTINUE
C
      IF(N.NE.NBMOD) THEN
          WRITE(NOTE(1:3),'(I3.3)') N
          CALL UTMESS('F','MEFEIG','LE NOMBRE DE MODES RESULTATS: '//
     &               NOTE // ' N EST PAS CORRECT ')
      ENDIF
C
C --- FREQUENCE ET AMORTISSEMENT REELS
C
      DO 230 I = 1,NBMOD
         FRE(I) = SQRT(ALFR(IND(I))*ALFR(IND(I))
     &              + ALFI(IND(I))*ALFI(IND(I)))/2.D0/PI
         KSI(I) = -ALFR(IND(I))/2.D0/PI/FRE(I)
 230  CONTINUE
C
C ---- CLASSEMENT PAR ORDRE CROISSANT DE FREQUENCES
C
      DO 220 I = 1,NBMOD-1
         DO 210 J = I+1,NBMOD
            IF ( FRE(J) .LT. FRE(I) ) THEN
               TEMP = FRE(I)
               FRE(I) = FRE(J)
               FRE(J) = TEMP
               TEMP = KSI(I)
               KSI(I) = KSI(J)
               KSI(J) = TEMP
               K = IND(I)
               IND(I) = IND(J)
               IND(J) = K
            ENDIF
 210     CONTINUE
 220  CONTINUE
C
C --- CALCUL DES NORMES DES PARTIES REELLES ET IMAGINAIRES DES
C --- VECTEURS PROPRES ET IMPRESSION SUR LE FICHIER RESULTAT
C --- RECHERCHE DES MAXIMA ET MINIMA
C
      IFM = IUNIFI('MESSAGE')
      WRITE (IFM,*)
      WRITE (IFM,*) '==============================================='
      WRITE (IFM,*)
      WRITE (IFM,*) '     NORMES RELATIVES DES PARTIES REELLES '
      WRITE (IFM,*)
      WRITE (IFM,*) '     ET IMAGINAIRES  DES VECTEURS PROPRES'
      WRITE (IFM,*)
      WRITE (IFM,*) '==============================================='
      WRITE (IFM,*)
      WRITE (IFM,6000)
      WRITE (IFM,6001)
      WRITE (IFM,6002)
      WRITE (IFM,6003)
      WRITE (IFM,6001)
      WRITE (IFM,6000)
      WRITE (IFM,6000)
C
      NOREMI = 1.0D0
      NOREMA = 0.0D0
      NOIMMI = 1.0D0
      NOIMMA = 0.0D0
C
      DO 250 I = 1,NBMOD
         NORMR = 0.D0
         NORMI = 0.D0
         DO 240 J = 1,NBMOD
            NORMR = NORMR + MAVR(J,IND(I)) * MAVR(J,IND(I))
            NORMI = NORMI + MAVI(J,IND(I)) * MAVI(J,IND(I))
 240     CONTINUE
         NORM = NORMI + NORMR
         NORM = SQRT(NORM)
         NORMR = SQRT(NORMR) / NORM
         NORMI = SQRT(NORMI) / NORM
         IF ( NOREMI .GT. NORMR ) NOREMI = NORMR
         IF ( NOREMA .LT. NORMR ) NOREMA = NORMR
         IF ( NOIMMI .GT. NORMI ) NOIMMI = NORMI
         IF ( NOIMMA .LT. NORMI ) NOIMMA = NORMI
 250  CONTINUE
      WRITE (IFM,6005) NOREMA , NOIMMI
      WRITE (IFM,6001)
      WRITE (IFM,6006) NOREMI , NOIMMA
      WRITE (IFM,6001)
      WRITE (IFM,6000)
      WRITE (IFM,*)
C
C
C --- FORMATS
C
 6000 FORMAT (1X,'***************************************************',
     &       '*****************')
 6001 FORMAT (1X,'*              *                         *          ',
     &       '               *')
 6002 FORMAT (1X,'*    NUMERO    *   NORME RELATIVE DE LA  *   NORME '
     &       ,'RELATIVE DE LA  *')
 6003 FORMAT (1X,'*  DE VECTEUR  *     PARTIE REELLE       *    PARTIE'
     &       ,' IMAGINAIRE    *')
 6004 FORMAT (1P,1X,'*    ',I4,'      *   ',3X,D13.6,3X,'   *   '
     &       ,3X,D13.6,3X,'   *')
 6005 FORMAT (1P,1X,'*   MAX :    ','  * ',5X,D13.6,4X,'  *  '
     &       ,4X,D13.6,5X,' *')
 6006 FORMAT (1P,1X,'*   MIN :    ','  * ',5X,D13.6,4X,'  *  '
     &       ,4X,D13.6,5X,' *')
 6007 FORMAT (1X,'*      ---     *       ------------      *       ---',
     &       '---------      *')
C
C
C
      END
