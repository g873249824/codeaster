      SUBROUTINE VPCNTL
     &  (CTY, MODE, OPTION, OMEMIN, OMEMAX, SEUIL, NFREQ, IPOS, LMAT,
     &   OMECOR, PRECDC, IER, VPINF, VPMAX, FREQ, ERR, CHARGE,
     &   TYPRES, STURM, NBLAGR,SOLVEU)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 11/09/2012   AUTEUR BOITEAU O.BOITEAU 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_21
C     CONTROLE DE VALIDITE DES MODES TROUVES
C-----------------------------------------------------------------------
C IN  LMAT : I : POINTEUR SUR LE DESCRIPTEUR DE MATRICE
C            LMAT(1)  : MATRICE DE RAIDEUR
C            LMAT(2)  : MATRICE DE MASSE
C            LMAT(3)  : RESULTAT DE LA MATRICE SHIFTEE FACTORISEE
C OUT IER  : I : CODE RETOUR
C            0 TOUT C'EST BIEN PASSE
C            > 0 NOMBRE D'ERREURS TROUVEES
C IN  SOLVEU : K19 : SD SOLVEUR POUR PARAMETRER LE SOLVEUR LINEAIRE
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      CHARACTER*1  CTY
      CHARACTER*(*) MODE, OPTION, TYPRES
      CHARACTER*19  SOLVEU
      INTEGER      NFREQ, IPOS(*), LMAT(3), IER, NBLAGR
      REAL*8       VPINF, VPMAX, OMEMIN, OMEMAX, SEUIL, PRECDC, OMECOR,
     &             CHARGE(NFREQ), FREQ(NFREQ), ERR(NFREQ)

      LOGICAL      STURM
      CHARACTER*24 VALK
C
C     ------------------------------------------------------------------
      REAL*8 ZMIN, ZMAX, MANTIS, FREQOM, OMEGA2, OMEGA, XFMAX, XFMIN
      REAL*8 VALR(3)
      INTEGER EXPO, IFM, NIV, IFREQ, NBMAX, NBMIN, NFREQT, IR
      INTEGER VALI(2)
C     ------------------------------------------------------------------
      IER    = 0

C     ---RECUPERATION DU NIVEAU D'IMPRESSION----
      CALL INFNIV(IFM,NIV)
C
      IF (NIV.GE.1) THEN
        WRITE(IFM,1000)
        WRITE(IFM,1100)
        WRITE(IFM,1200)
      ENDIF

      EXPO=0

C     ------------------------------------------------------------------
C     ------------------ CONTROLE DES NORMES D'ERREURS -----------------
C     ------------------------------------------------------------------
C
      IF ( SEUIL .GT. 0.0D0 ) THEN

         DO 100 IFREQ = 1, NFREQ
C
            IF ( ERR(IFREQ) .GT. SEUIL ) THEN
               IER = IER + 1
               VALK = MODE
               VALI (1) = IPOS(IFREQ)
      CALL U2MESG(CTY//'+','ALGELINE5_15',1,VALK,1,VALI,0,0.D0)
               IF (TYPRES .EQ. 'DYNAMIQUE' ) THEN
                 VALR (1) = FREQ(IFREQ)
                 CALL U2MESG(CTY//'+','ALGELINE5_16',0,' ',0,0,1,VALR)
               ELSE
                 VALR (1) = CHARGE(IFREQ)
                 CALL U2MESG(CTY//'+','ALGELINE5_17',0,' ',0,0,1,VALR)
               ENDIF
              VALR (1) = ERR(IFREQ)
              VALR (2) = SEUIL
              CALL U2MESG(CTY,'ALGELINE5_18',0,' ',0,0,2,VALR)
            ENDIF
 100     CONTINUE
      ENDIF
C     ------------------------------------------------------------------
C     -- OPTION BANDE :                                              ---
C     -- VERIFICATION QUE LES FREQUENCES TROUVEES SONT DANS LA BANDE ---
C     ------------------------------------------------------------------
      IF ( OPTION .EQ. 'BANDE' ) THEN
         ZMAX = (1.D0 + SIGN(PRECDC,OMEMAX)) * OMEMAX
         ZMIN = (1.D0 - SIGN(PRECDC,OMEMIN)) * OMEMIN
         IF (ABS(OMEMIN).LE.OMECOR) ZMIN = - OMECOR
         DO 210 IFREQ = 1, NFREQ
            IF (TYPRES .EQ. 'DYNAMIQUE') THEN
              OMEGA = OMEGA2(FREQ(IFREQ))
            ELSE
              OMEGA = CHARGE(IFREQ)
            ENDIF
            IF ( OMEGA .LT.ZMIN .OR. OMEGA .GT. ZMAX ) THEN
               IER = IER + 1
               VALK = MODE
               VALI (1) = IPOS(IFREQ)
      CALL U2MESG(CTY//'+','ALGELINE5_19',1,VALK,1,VALI,0,0.D0)
               IF (TYPRES .EQ. 'DYNAMIQUE' ) THEN
                 VALR (1) = FREQ(IFREQ)
                 VALR (2) = FREQOM(OMEMIN)
                 VALR (3) = FREQOM(OMEMAX)
                 CALL U2MESR(CTY//'+','ALGELINE5_20',3,VALR)
               ELSE
                 VALR (1) = CHARGE(IFREQ)
                 VALR (2) = OMEMIN
                 VALR (3) = OMEMAX
                 CALL U2MESR(CTY//'+','ALGELINE5_21',3,VALR)
               ENDIF
               CALL U2MESS(CTY,'VIDE_1')
            ENDIF
 210     CONTINUE
      ENDIF
C
C     ------------------------------------------------------------------
C     -- POUR TOUTES LES OPTIONS :                                   ---
C     -- VERIFICATION QU'ON A LE BON NOMBRE DE FREQUENCES            ---
C     ------------------------------------------------------------------
C
C        --- RECHERCHE DE LA PLUS PETITE ET DE LA PLUS GRANDE FREQUENCES

      IF ( OPTION .NE. '  ' ) THEN

C --- POUR OPTIMISER ON NE CALCULE PAS LE DET, ON NE GARDE PAS LA FACTO
C --- (SI MUMPS)
         XFMAX = VPMAX
         CALL VPSTUR(LMAT(1),XFMAX,LMAT(2),LMAT(3),MANTIS,EXPO,
     +               NBMAX,IR,SOLVEU,.FALSE.,.FALSE.)
         XFMIN = VPINF
         CALL VPSTUR(LMAT(1),XFMIN,LMAT(2),LMAT(3),MANTIS,EXPO,
     +               NBMIN,IR,SOLVEU,.FALSE.,.FALSE.)
C
C REGLES DE STURM ETENDUE
         IF (.NOT.STURM) THEN
           NFREQT = ABS(NBMAX - NBMIN)
         ELSE
           NFREQT = ABS(NBMAX + NBMIN) - 2*NBLAGR
         ENDIF
         IF ( NFREQT .NE. NFREQ ) THEN
           IER = IER + 1
           VALK = MODE
           CALL U2MESG(CTY//'+','ALGELINE5_23',1,VALK,0,0,0,0.D0)
           IF (TYPRES .EQ. 'DYNAMIQUE') THEN
             VALR (1) = FREQOM(VPINF)
             VALR (2) = FREQOM(VPMAX)
             VALI (1) = NFREQT
             VALI (2) = NFREQ
             CALL U2MESG(CTY//'+','ALGELINE5_24',0,' ',2,VALI,2,VALR)
           ELSE
             VALR (1) = VPINF
             VALR (2) = VPMAX
             VALI (1) = NFREQT
             VALI (2) = NFREQ
             CALL U2MESG(CTY//'+','ALGELINE5_25',0,' ',2,VALI,2,VALR)
           ENDIF
           CALL U2MESS(CTY,'VIDE_1')
         ELSE
           IF (NIV.GE.1) THEN
             IF (TYPRES .EQ. 'DYNAMIQUE') THEN
               WRITE(IFM,1300) FREQOM(VPINF), FREQOM(VPMAX)
               WRITE(IFM,1400) NFREQT
             ELSE
               WRITE(IFM,1300) VPINF, VPMAX
               WRITE(IFM,1401) NFREQT
             ENDIF
           ENDIF
         ENDIF
      ENDIF
      IF (NIV.GE.1) THEN
        WRITE(IFM,1000)
      ENDIF
C
 1000 FORMAT (72('-'),/)
 1100 FORMAT (10X,'VERIFICATION A POSTERIORI DES MODES')
 1200 FORMAT (3X)
 1300 FORMAT (3X,'DANS L''INTERVALLE (',1PE12.5,',',1PE12.5,') ')
 1400 FORMAT (3X,'IL Y A BIEN ',I4,' FREQUENCE(S) ')
 1401 FORMAT (3X,'IL Y A BIEN ',I4,' CHARGE(S) CRITIQUE(S) ')
C
      END
