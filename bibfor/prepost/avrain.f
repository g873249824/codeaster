      SUBROUTINE AVRAIN(NBVEC, NBORDR, ITRV, NPIC, PIC, OPIC, FATSOC,
     &                  NCYCL, VMIN, VMAX, OMIN, OMAX)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE F1BHHAJ J.ANGLES
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      INTEGER       NBVEC, NBORDR, ITRV(2*(NBORDR+2)), NPIC(NBVEC)
      INTEGER       OPIC(NBVEC*(NBORDR+2)), NCYCL(NBVEC)
      INTEGER       OMIN(NBVEC*(NBORDR+2)), OMAX(NBVEC*(NBORDR+2))
      REAL*8        PIC(NBVEC*(NBORDR+2)), FATSOC
      REAL*8        VMIN(NBVEC*(NBORDR+2)), VMAX(NBVEC*(NBORDR+2))
C ----------------------------------------------------------------------
C BUT: COMPTAGE DE CYCLE PAR LA METHODE RAINFLOW (POSTDAM)
C ----------------------------------------------------------------------
C ARGUMENTS:
C NBVEC     IN   I  : NOMBRE DE VECTEURS NORMAUX.
C NBORDR    IN   I  : NOMBRE DE NUMERO D'ORDRE.
C ITRV      IN   I  : VECTEUR DE TRAVAIL ENTIER (POUR LES NUME_ORDRE)
C NPIC      IN   I  : NOMBRE DE PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX APRES REARANGEMENT DES PICS.
C PIC       IN   R  : VALEUR DES PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX APRES REARANGEMENT DES PICS.
C OPIC      IN   I  : NUMEROS D'ORDRE ASSOCIES AUX PICS DETECTES POUR
C                     TOUS LES VECTEURS NORMAUX APRES REARANGEMENT
C                     DES PICS.
C FATSOC     IN  R  : COEFFICIENT PERMETTANT D'UTILISER LES MEMES
C                     ROUTINES POUR LE TRAITEMENT DES CONTRAINTES ET
C                     DES DEFORMATIONS.
C NCYCL     OUT  I  : NOMBRE DE CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C VMIN      OUT  R  : VALEURS MIN DES CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C VMAX      OUT  R  : VALEURS MAX DES CYCLES ELEMENTAIRES POUR TOUS LES
C                     VECTEURS NORMAUX.
C OMIN      OUT  I  : NUMEROS D'ORDRE ASSOCIES AUX VALEURS MIN DES
C                     CYCLES ELEMENTAIRES POUR TOUS LES VECTEURS
C                     NORMAUX.
C OMAX      OUT  I  : NUMEROS D'ORDRE ASSOCIES AUX VALEURS MAX DES
C                     CYCLES ELEMENTAIRES POUR TOUS LES VECTEURS
C                     NORMAUX.
C
C-----------------------------------------------------------------------
C     ------------------------------------------------------------------
      INTEGER       IVECT, I, NPICB, ADRS, J, K, NPICR
C
      REAL*8        E1, E2, E3, R1, R2, RAD, RD, X, Y
C
      LOGICAL       LRESI
C
C-----------------------------------------------------------------------
C234567                                                              012
C
      CALL JEMARQ()
C
      DO 10 IVECT=1, NBVEC

C LE TEST SI (NPIC(IVECT) .EQ. 0) EST EQUIVALENT
C AU TEST SI (IFLAG(IVECT) .EQ. 3).
         IF (NPIC(IVECT) .EQ. 0) THEN
            GOTO 10
         ENDIF

         CALL ASSERT((NBORDR+2) .GE. NPIC(IVECT))
         ADRS = (IVECT-1)*(NBORDR+2)
         LRESI = .FALSE.
         NPICB = NPIC(IVECT)

         DO 20 I=1, NPICB
            ITRV(I) = I
 20      CONTINUE

         NCYCL(IVECT) = 0

 1       CONTINUE

         I = 1
         J = 1

 2       CONTINUE

         IF ( I+3 .GT. NPICB ) THEN
            GOTO 100
         ENDIF

         E1 = ABS ( PIC(ADRS + ITRV(I+1)) - PIC(ADRS + ITRV(I)) )
         E2 = ABS ( PIC(ADRS + ITRV(I+2)) - PIC(ADRS + ITRV(I+1)) )
         E3 = ABS ( PIC(ADRS + ITRV(I+3)) - PIC(ADRS + ITRV(I+2)) )

         IF ( (E1. GE. E2) .AND. (E3 .GE. E2) ) THEN
            NCYCL(IVECT) = NCYCL(IVECT) + 1
            IF ( PIC(ADRS+ITRV(I+1)) .GE. PIC(ADRS+ITRV(I+2)) ) THEN
               VMAX(ADRS+NCYCL(IVECT)) = PIC(ADRS + ITRV(I+1))/FATSOC
               VMIN(ADRS+NCYCL(IVECT)) = PIC(ADRS + ITRV(I+2))/FATSOC
               OMAX(ADRS+NCYCL(IVECT)) = OPIC(ADRS + ITRV(I+1))
               OMIN(ADRS+NCYCL(IVECT)) = OPIC(ADRS + ITRV(I+2))
            ELSE
               VMAX(ADRS+NCYCL(IVECT)) = PIC(ADRS + ITRV(I+2))/FATSOC
               VMIN(ADRS+NCYCL(IVECT)) = PIC(ADRS + ITRV(I+1))/FATSOC
               OMAX(ADRS+NCYCL(IVECT)) = OPIC(ADRS + ITRV(I+2))
               OMIN(ADRS+NCYCL(IVECT)) = OPIC(ADRS + ITRV(I+1))
            ENDIF

            DO 30 K=I+2, J+2, -1
               ITRV(K) = ITRV(K-2)
 30         CONTINUE

            J=J+2
            I=J
            GOTO 2
         ELSE
            I=I+1
            GOTO 2
         ENDIF

C  --- TRAITEMENT DU RESIDU -------

 100     CONTINUE

         IF ( .NOT. LRESI ) THEN
            NPICR = NPICB - 2*NCYCL(IVECT)
            DO 110 I=1, NPICR
               ITRV(I) = ITRV(2*NCYCL(IVECT)+I)
 110        CONTINUE
            R1 = PIC(ADRS + ITRV(1))
            R2 = PIC(ADRS + ITRV(2))
            RAD= PIC(ADRS + ITRV(NPICR-1))
            RD = PIC(ADRS + ITRV(NPICR))
            X  = (RD-RAD)*(R2-R1)
            Y  = (RD-RAD)*(R1-RD)
            IF ( (X .GT. 0.D0) .AND. (Y .LT. 0.D0) ) THEN
               DO 120 I=1, NPICR
                  ITRV(I+NPICR) = ITRV(I)
 120           CONTINUE
               NPICB = 2*NPICR
            ELSE IF ( (X .GT. 0.D0) .AND. (Y .GE. 0.D0) ) THEN
C -- ON ELIMINE  R1 ET RN
               DO 130 I=NPICR, 2, -1
                  ITRV(I+NPICR-2) = ITRV(I)
 130           CONTINUE
               NPICB = 2*NPICR - 2
            ELSE IF ( (X .LT. 0.D0) .AND. (Y .LT. 0.D0) ) THEN
C -- ON ELIMINE R1
               DO 140 I=NPICR, 2, -1
                  ITRV(I+NPICR-1) = ITRV(I)
 140           CONTINUE
               NPICB = 2*NPICR - 1
            ELSE IF ( (X .LT. 0.D0) .AND. (Y .GE. 0.D0) ) THEN
C -- ON ELIMINE RN
               DO 150 I=NPICR, 1, -1
                  ITRV(I+NPICR-1) = ITRV(I)
 150           CONTINUE
               NPICB = 2*NPICR - 1
            ENDIF
            LRESI = .TRUE.
            GOTO 1
         ENDIF


         CALL ASSERT((NBORDR+2) .GE. NCYCL(IVECT))

 10   CONTINUE

      CALL JEDEMA()
C
      END
