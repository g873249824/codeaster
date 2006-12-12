      SUBROUTINE VPCNTL
     &  (CTY, MODE, OPTION, OMEMIN, OMEMAX, SEUIL, NFREQ, IPOS, LMAT,
     &   OMECOR, PRECDC, IER, VPINF, VPMAX, NPREC, FREQ, ERR, CHARGE,
     &   TYPRES, STURM, NBLAGR)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 13/12/2006   AUTEUR PELLET J.PELLET 
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
C     ------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C        INFNIV, UTDEBM, UTIMPK, UTIMPI, UTIMPR, UTFINM, OMEGA2,
C        VPSTUR,
C     FONCTIONS INTRINSEQUES:
C        ABS, SIGN
C     ------------------------------------------------------------------
C     ASTER INFORMATIONS:
C      24/01/2000 TOILETTAGE FORTRAN, IMPLICIT NONE,
C                 MOFIFICATION DES (1.D0-PRECDC) AVEC SIGN.
C                 NOUVEAUX PARAMETRES STURM ET NBLAGR,
C                 INTRODUCTION DE LA VERIFICATION DE STURM ETENDUE.
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      CHARACTER*1  CTY
      CHARACTER*(*) MODE, OPTION, TYPRES
      INTEGER      NFREQ, IPOS(*), LMAT(3), IER, NBLAGR, NPREC
      REAL*8       VPINF, VPMAX, OMEMIN, OMEMAX, SEUIL, PRECDC, OMECOR,
     &             CHARGE(NFREQ), FREQ(NFREQ), ERR(NFREQ)

      LOGICAL      STURM
C---------- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C     ------------------------------------------------------------------
      REAL*8 ZMIN, ZMAX, MANTIS, FREQOM, OMEGA2, OMEGA, XFMAX, XFMIN
      INTEGER EXPO, IFM, NIV, IFREQ, NBMAX, NBMIN, NFREQT, IR
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
C
C     ------------------------------------------------------------------
C     ------------------ CONTROLE DES NORMES D'ERREURS -----------------
C     ------------------------------------------------------------------
C
      IF ( SEUIL .GT. 0.0D0 ) THEN

         DO 100 IFREQ = 1, NFREQ
C
            IF ( ERR(IFREQ) .GT. SEUIL ) THEN
               IER = IER + 1
               CALL UTDEBM(CTY,'VERIFICATION DES MODES',' ')
               CALL UTIMPK('S',' POUR LE CONCEPT ',1,MODE)
               CALL UTIMPI('L',' LE MODE NUMERO ',1,IPOS(IFREQ))
               IF (TYPRES .EQ. 'DYNAMIQUE' ) THEN
                 CALL UTIMPR('S',' DE FREQUENCE ',1,FREQ(IFREQ))
               ELSE
                 CALL UTIMPR('S',' DE CHARGE CRITIQUE ',1,CHARGE(IFREQ))
               ENDIF
              CALL UTIMPR('S',' A UNE NORME D''ERREUR DE ',1,ERR(IFREQ))
              CALL UTIMPR('S',' SUPERIEURE AU SEUIL ADMIS ',1,SEUIL)
              CALL UTFINM()
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
               CALL UTDEBM(CTY,'VERIFICATION DES MODES',' ')
               CALL UTIMPK('S',' POUR LE CONCEPT ',1,MODE)
               CALL UTIMPI('L',' LE MODE NUMERO ',1,IPOS(IFREQ))
               IF (TYPRES .EQ. 'DYNAMIQUE' ) THEN
                 CALL UTIMPR('S',' DE FREQUENCE ',1,FREQ(IFREQ))
                 CALL UTIMPR('S',' EST EN DEHORS DE L''INTERVALLE DE '//
     +                     'RECHERCHE :',1,FREQOM(OMEMIN))
                 CALL UTIMPR('S',' , ',1,FREQOM(OMEMAX) )
               ELSE
                 CALL UTIMPR('S',' DE CHARGE CRITIQUE ',1,CHARGE(IFREQ))
                 CALL UTIMPR('S',' EST EN DEHORS DE L''INTERVALLE DE '//
     +                     'RECHERCHE :',1,OMEMIN)
                 CALL UTIMPR('S',' , ',1,OMEMAX )
               ENDIF
               CALL UTFINM()
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

         XFMAX = VPMAX
         CALL VPSTUR(LMAT(1),XFMAX,LMAT(2),LMAT(3),NPREC,MANTIS,EXPO,
     +               NBMAX,IR)
         XFMIN = VPINF
         CALL VPSTUR(LMAT(1),XFMIN,LMAT(2),LMAT(3),NPREC,MANTIS,EXPO,
     +               NBMIN,IR)
C
C REGLES DE STURM ETENDUE
         IF (.NOT.STURM) THEN
           NFREQT = ABS(NBMAX - NBMIN)
         ELSE
           NFREQT = ABS(NBMAX + NBMIN) - 2*NBLAGR
         ENDIF
         IF ( NFREQT .NE. NFREQ ) THEN
           IER = IER + 1
           CALL UTDEBM(CTY,'VERIFICATION DES MODES',' ')
           CALL UTIMPK('S',' POUR LE CONCEPT ',1,MODE)
           IF (TYPRES .EQ. 'DYNAMIQUE') THEN
             CALL UTIMPR('L',' DANS L''INTERVALLE  (',1,FREQOM(VPINF))
             CALL UTIMPR('S',' , ',1,FREQOM(VPMAX) )
             CALL UTIMPI('S',')   IL Y A THEORIQUEMENT ',1,NFREQT)
             CALL UTIMPI('S',' FREQUENCE(S) '//
     +                       'ET L''ON EN A CALCULE ',1,NFREQ)
           ELSE
             CALL UTIMPR('L',' DANS L''INTERVALLE  (',1,VPINF)
             CALL UTIMPR('S',' , ',1,VPMAX )
             CALL UTIMPI('S',')   IL Y A THEORIQUEMENT ',1,NFREQT)
             CALL UTIMPI('S',' CHARGE(S) CRITIQUE(S) '//
     +                       'ET L''ON EN A CALCULE ',1,NFREQ)
           ENDIF
           CALL UTFINM()
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
