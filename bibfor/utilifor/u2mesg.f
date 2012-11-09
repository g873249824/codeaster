      SUBROUTINE U2MESG (TYP, IDMESS, NK, VALK, NI, VALI, NR, VALR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE COURTOIS M.COURTOIS
C
      IMPLICIT NONE
      CHARACTER*(*)    TYP, IDMESS, VALK(*)
      INTEGER          NK, NI, VALI(*), NR
      REAL*8           VALR(*)
C
      INTEGER          NEXCEP
      COMMON /UTEXC /  NEXCEP
C
      INTEGER          RECURS
      CHARACTER*16     COMPEX
      CHARACTER*8      NOMRES, K8B
      CHARACTER*2      TYPM
      LOGICAL          LERROR, LVALID, LABORT, SUITE, LSTOP, LERRM
      INTEGER          LOUT, IDF, I, LC, IMAAP, LXLGUT, ISJVUP
      INTEGER          NUMEX
C
      SAVE             RECURS
C
C     TYPES DE MESSAGES :
C     ERREURS :
C       F : ERREUR AVEC DESTRUCTION DU CONCEPT PRODUIT PAR LA COMMANDE
C       S : ERREUR AVEC VALIDATION DU CONCEPT, EXCEPTION
C       Z : LEVEE D'EXCEPTION PARTICULIERE, COMME 'S'
C       M : ERREUR SUIVIE DE MPI_ABORT, NE PAS LEVER D'EXCEPTION --> 'F'
C     MESSAGES :
C       E : SIMPLE MESSAGE D'ERREUR QUI SERA SUIVI D'UNE ERREUR 'F'
C       D : COMME 'E' MAIS AFFICHE AVEC 'F' POUR ASSURER UN 'D'IAGNOSTIC
C       I : INFORMATION
C       A : ALARME
C
      TYPM = TYP
      IDF  = INDEX('EFIMASZD', TYPM(1:1))
      CALL ASSERT(IDF .NE. 0)
C
C     --- COMPORTEMENT EN CAS D'ERREUR
      CALL ONERRF(' ', COMPEX, LOUT)
C
      LERRM = IDF.EQ.4
      IF ( LERRM ) THEN
        IDF = 2
        TYPM(1:1) = 'F'
C       L'EXCEPTION A-T-ELLE DEJA ETE LEVEE ?
        IF ( RECURS .NE. 0) THEN
C         L'EXCEPTION A DEJA ETE LEVEE
          RECURS = 0
        ELSE
          LERRM = .FALSE.
        ENDIF
      ENDIF
C
      LERROR = IDF.EQ.2 .OR. IDF.EQ.6 .OR. IDF.EQ.7
C     DOIT-ON VALIDER LE CONCEPT ?
      LVALID = (IDF.EQ.6 .OR. IDF.EQ.7)
     &    .OR. (IDF.EQ.2 .AND. COMPEX(1:LOUT).EQ.'EXCEPTION+VALID')
C     DOIT-ON S'ARRETER BRUTALEMENT (POUR DEBUG) ?
      LABORT = IDF.EQ.2 .AND. COMPEX(1:LOUT).EQ.'ABORT'
C
      SUITE = .FALSE.
      IF (LEN(TYPM) .GT. 1) THEN
         IF (TYPM(2:2) .EQ. '+') SUITE=.TRUE.
      ENDIF
C
C --- SE PROTEGER DES APPELS RECURSIFS POUR LES MESSAGES D'ERREUR
      IF ( LERROR ) THEN
        IF ( RECURS .EQ. 1234567891 ) THEN
           CALL JEFINI('ERREUR')
        ENDIF

        IF ( RECURS .EQ. 1234567890 ) THEN
           RECURS = 1234567891
C          ON EST DEJA PASSE PAR U2MESG... SANS EN ETRE SORTI
           CALL UTPRIN('F', 0, 'CATAMESS_55', 0, VALK, 0, VALI, 0, VALR)
C          ON NE FAIT PLUS RIEN ET ON SORT DE LA ROUTINE
           GOTO 9999
        ENDIF
        RECURS = 1234567890
      ENDIF

      CALL JEVEMA(IMAAP)
      IF (IMAAP.GE.200) CALL JEFINI('ERREUR')
      IF ( ISJVUP() .EQ. 1 ) THEN
        CALL JEMARQ()
      ENDIF
C
      NUMEX = NEXCEP
      IF (LERROR .AND. IDF.NE.7) THEN
C     SI EXCEPTION, NEXCEP EST FIXE PAR COMMON VIA UTEXCP
C     SINON ON LEVE L'EXCEPTION DE BASE ASTER.ERROR
        NUMEX = 21
      ENDIF
C
      CALL UTPRIN(TYPM, NUMEX, IDMESS, NK, VALK, NI, VALI, NR, VALR)
C
C     --- REMONTEE D'ERREUR SI DISPO
      IF ( LABORT ) THEN
        CALL TRABCK('Liste des appels successifs ' //
     &              '(option -traceback)', -1)
      ENDIF
      LSTOP = .FALSE.
C --- EN CAS DE MESSAGE AVEC SUITE, PAS D'ARRET, PAS D'EXCEPTION
      IF ( .NOT. SUITE ) THEN
C
C     -- ABORT SUR ERREUR <F> "ORDINAIRE"
         IF ( LABORT ) THEN
C           AVERTIR LE PROC #0 QU'ON A RENCONTRE UN PROBLEME !
            CALL MPICMW(0)
C
            CALL JEFINI('ERREUR')

C     -- LEVEE D'UNE EXCEPTION
         ELSEIF ( LERROR ) THEN

C        -- QUELLE EXCEPTION ?
C           SI EXCEPTION, NEXCEP EST FIXE PAR COMMON VIA UTEXCP
C           IL A ETE COPIE DANS NUMEX POUR NE PAS ETRE MODIFIE SI
C           DES APPELS SONT IMBRIQUES
            IF ( IDF.NE.7 ) THEN
C           SINON ON LEVE L'EXCEPTION DE BASE ASTER.ERROR
               NUMEX = 21
            ENDIF
C
C           NOM DU CONCEPT COURANT
            CALL GETRES(NOMRES, K8B, K8B)

            IF ( NOMRES .NE. ' ' ) THEN
C             LE CONCEPT EST REPUTE VALIDE :
C               - SI ERREUR <S> OU EXCEPTION
C               - SI ERREUR <F> MAIS LA COMMANDE A DIT "EXCEPTION+VALID"
              IF ( LVALID) THEN
                CALL UTPRIN('I',0,'CATAMESS_70',1,NOMRES,0,VALI,0,VALR)

C             SINON LE CONCEPT COURANT EST DETRUIT
              ELSE
                CALL UTPRIN('I',0,'CATAMESS_69',1,NOMRES,0,VALI,0,VALR)
                LC = LXLGUT(NOMRES)
                IF (LC .GT. 0) THEN
                  CALL JEDETC(' ', NOMRES(1:LC), 1)
                ENDIF
              ENDIF
            ENDIF

            IF ( ISJVUP() .EQ. 1 ) THEN
C
C             -- MENAGE SUR LA BASE VOLATILE
              CALL JEDETV()

C             REMONTER LES N JEDEMA COURT-CIRCUITES
              CALL JEVEMA(IMAAP)
              DO 10 I=IMAAP, 1, -1
                 CALL JEDEMA()
 10           CONTINUE
C
            ENDIF
C
C           AVERTIR LE PROC #0 QU'ON A RENCONTRE UN PROBLEME !
            CALL MPICMW(1)
C
C           ON REMONTE UNE EXCEPTION AU LIEU DE FERMER LES BASES
            IF ( LERROR ) RECURS = 0
            LSTOP = .TRUE.
            IF ( .NOT. LERRM ) THEN
              CALL IB1MAI()
              CALL UEXCEP(NUMEX, IDMESS, NK, VALK, NI, VALI, NR, VALR)
            ENDIF
         ENDIF
C
      ENDIF
C
      IF ( LERROR ) RECURS = 0
 9999 CONTINUE
      IF ( ISJVUP() .EQ. 1 .AND. .NOT. LSTOP ) THEN
        CALL JEDEMA()
      ENDIF
      END
