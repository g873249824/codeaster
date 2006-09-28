      SUBROUTINE TRANSI(NP1,NP2,NP3,NP4,NBM,NBNL,NPFMAX,NPFTS,
     &                  DTTR,TTRANS,EPS,FEXT,TEXT,FEXTTS,TEXTTS,
     &                  FEXTTR,FEXTT0,
     &                  MASGI,AMORI,PULSI,PHII,
     &                  TYPCH,NBSEG,RC,ALPHA,BETA,GAMMA,ORIG,THETA,
     &                  VITG,DEPG,AMOR,PULSD,OMEGAF,AA,BB,OLD,
     &                  S0,Z0,SR0,ZA1,ZA2,ZA3,ZA4,ZA5,ZITR,ZIN,MTRANS,
     &                  AMOR00,PULS00,ACCG0,VITG0,DEPG0,
     &                  ICONFB,TCONF1,FTEST0,IER)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE  CRP_21
C-----------------------------------------------------------------------
C DESCRIPTION : CALCUL DE LA REPONSE DYNAMIQUE TRANSITOIRE D'UNE
C -----------   STRUCTURE PAR UNE METHODE INTEGRALE
C               (VERSION MULTI-MODALE)
C
C               APPELANT : MDITM2
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER     NP1, NP2, NP3, NP4, NBM, NBNL, NPFMAX, NPFTS
      REAL*8      DTTR, TTRANS, EPS,
     &            FEXT(NP4,*), TEXT(*), FEXTTS(NP4,*), TEXTTS(*),
     &            FEXTTR(*), FEXTT0(*),
     &            MASGI(*), AMORI(*), PULSI(*), PHII(NP2,NP1,*)
      INTEGER     TYPCH(*), NBSEG(*)
      REAL*8      RC(NP3,*), ALPHA(2,*), BETA(2,*), GAMMA(2,*),
     &            ORIG(3,*), THETA(NP3,*),
     &            VITG(*), DEPG(*), AMOR(*), PULSD(*),
     &            OMEGAF(*), AA(*), BB(*), OLD(9,*)
      COMPLEX*16  S0(*), Z0(*), SR0(*), ZA1(*), ZA2(*), ZA3(*),
     &            ZA4(NP4,*), ZA5(NP4,*), ZITR(*), ZIN(*)
      REAL*8      MTRANS(2,2,*), AMOR00(*), PULS00(*),
     &            ACCG0(*), VITG0(*), DEPG0(*)
      INTEGER     ICONFB(*)
      REAL*8      TCONF1(4,*), FTEST0
      INTEGER     IER
C
C VARIABLES LOCALES
C -----------------
      INTEGER     I, ICHTR, NPF, NTTR, NTRANS, NTRAMX
      REAL*8      TTRAN0
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL    ADIMVE, CALFFT, CALTRA, COMPTR, DEFTTR, ESTITR,
C    &            INIALG, UTDEBM, UTIMPR, UTFINM, UTMESS
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C 1.  PREMIERE ESTIMATION DE LA DUREE DU REGIME TRANSITOIRE
C     -----------------------------------------------------
C
      IER = 0
      CALL ESTITR(NBM,AMORI,MASGI,EPS,TTRANS,NPF,NPFMAX,TEXT,IER)
      IF ( IER.NE.0 ) THEN
         CALL UTDEBM('F','TRANSITOIRE ',' ')
         CALL UTIMPR('S','VALEUR MINIMALE CONSEILLEE : ',1,TTRANS)
         CALL UTFINM
      ENDIF
C
C 2.  REPETER JUSQU'A VALIDATION DE LA DUREE DU REGIME TRANSITOIRE
C     ------------------------------------------------------------
C
      NTRANS = 0
      NTRAMX = 10000
C
 100  CONTINUE
C
C 2.1 SORTIE EN ERREUR FATALE SI DEPASSEMENT DU NOMBRE D'ITERATIONS
C     MAXIMAL
C
      IF ( NTRANS.GE.NTRAMX )
     &   CALL U2MESS('F','ALGORITH10_96')
C
C 2.2 CARACTERISATION DE L'ECHANTILLON TEMPOREL CONSIDERE
C     (AJUSTEMENT DE LA DUREE DU REGIME TRANSITOIRE)
C     RECUPERATION DES FORCES EXTERNES SUR CET ECHANTILLON

      CALL DEFTTR(NP1,NP4,NBM,NPF,NTTR,NTRANS,TTRAN0,TTRANS,TEXT,
     &            FEXT,FEXTT0,FEXTTR,DTTR)
      IF ( NTTR.GT.NPFMAX )
     &   CALL U2MESS('F','ALGORITH10_97')
C
C 2.3 A LA PREMIERE ESTIMATION DE LA DUREE DU REGIME TRANSITOIRE,
C     CALCUL DES COEFFICIENTS DE FOURIER SUR L'ECHANTILLON TEMPOREL
C
      IF ( NTRANS.EQ.0 )
     &   CALL CALFFT(NP1,NP4,NBM,NTTR,DTTR,FEXT,OMEGAF,AA,BB)
C
C 2.4 CALCUL DE LA REPONSE MODALE SUR L'INTERVALLE (TTRAN0,TTRANS)
C
      CALL CALTRA(NP1,NP4,NBM,NTTR,TTRANS,TTRAN0,
     &            VITG,DEPG,VITG0,DEPG0,
     &            MASGI,AMOR,PULSI,PULSD,MTRANS,
     &            S0,Z0,SR0,ZA1,ZA2,ZA3,ZA4,ZA5,ZITR,ZIN,
     &            FEXTT0,FEXTTR,DTTR,OMEGAF,AA,BB,NTRANS)
C
C 2.5 VERIFICATION QUE L'ON N'A PAS ATTEINT UNE BUTEE
C
      ICHTR = 0
      CALL COMPTR(NP1,NP2,NP3,NBM,NBNL,ICHTR,DEPG,VITG,
     &            PHII,TYPCH,NBSEG,ALPHA,BETA,GAMMA,ORIG,RC,THETA,OLD)
C
C 2.6 SI LE SYSTEME EST EN PHASE DE VOL A L'ISSUE DU REGIME TRANSITOIRE,
C     ON INITIALISE LES PARAMETRES PUIS ON RETOURNE A L'APPELANT MDITM2
C     POUR PASSER A LA SIMULATION EN REGIME ETABLI
C
      IF ( ICHTR.EQ.0 ) THEN
         CALL ADIMVE(NBM,FEXTTR,MASGI)
         CALL INIALG(NP1,NP2,NP3,NP4,NBM,NBNL,NTTR,NPFMAX,NPFTS,
     &               DEPG,VITG,DEPG0,VITG0,ACCG0,
     &               AMOR00,PULS00,FEXTTR,FEXT,TEXT,FEXTTS,TEXTTS,
     &               TYPCH,NBSEG,PHII,ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &               ICONFB,TCONF1,FTEST0)
C
C 2.7 DANS LE CAS CONTRAIRE, INITIALISATION DES VECTEURS DEPLACEMENTS ET
C     VITESSES GENERALISES POUR UNE NOUVELLE ESTIMATION DE LA DUREE DU
C     REGIME TRANSITOIRE
C
      ELSE
         NTRANS = NTRANS + 1
         DO 101 I = 1, NBM
            DEPG0(I) = DEPG(I)
 101     CONTINUE
         DO 102 I = 1, NBM
            VITG0(I) = VITG(I)
 102     CONTINUE
C
C ------ RETOURNER A REPETER
         GO TO 100
C
      ENDIF
C
C --- FIN DE TRANSI.
      END
