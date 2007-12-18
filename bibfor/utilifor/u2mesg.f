      SUBROUTINE U2MESG (CH1, IDMESS, NK, VALK, NI, VALI, NR, VALR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 18/12/2007   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER* (*)     CH1,IDMESS,VALK(*)
      INTEGER            NK,NI,VALI(*),NR
      REAL*8             VALR(*)
C     ==================================================================
      INTEGER          NEXCEP
      COMMON /UTEXC /  NEXCEP
C     ------------------------------------------------------------------
      INTEGER          RECURS
      CHARACTER*132    K132B
      CHARACTER *16    COMPEX
      CHARACTER *8     NOMRES, K8B
      LOGICAL          LEXC, SUITE
      INTEGER          LOUT,IDF,I,LL,LC,ICMD,IMAAP,LXLGUT
C     ------------------------------------------------------------------
      SAVE             RECURS
C     ------------------------------------------------------------------
C     --- 'Z' (IDF=8) = LEVEE D'EXCEPTION
      IDF  = INDEX('EFIDASXZ',CH1(1:1))
      SUITE = (LEN(CH1) .GT. 1) .AND. (CH1(2:2) .EQ. '+')
C
C --- SE PROTEGER DES APPELS RECURSIFS
      IF ( RECURS .EQ. 1234567890 ) THEN
C        ON EST DEJA PASSE PAR U2MESG... SANS EN ETRE SORTI
         CALL UTPRIN('F', 'SUPERVIS_55', 0, VALK, 0, VALI, 0, VALR)
         CALL JEFINI('ERREUR')
      ENDIF
      RECURS = 1234567890
      
      CALL JEVEMA(IMAAP)
      IF (IMAAP.GE.200) CALL JEFINI('ERREUR')
      CALL JEMARQ()
      
C     --- COMPORTEMENT EN CAS D'ERREUR <F>
      CALL ONERRF(' ', COMPEX, LOUT)
      LEXC = IDF.EQ.2 .AND. COMPEX(1:LOUT).EQ.'EXCEPTION'
C     --- SI EXCEPTION, NEXCEP EST FIXE PAR COMMON VIA UTEXCP/UTDEXC
      IF ( IDF.NE.8 ) THEN
C        ASTER.ERROR DANS ASTERMODULE.C
         NEXCEP = 21
      ENDIF
C
      CALL UTPRIN(CH1, IDMESS, NK, VALK, NI, VALI, NR, VALR)
C
C     --- REMONTEE D'ERREUR SI DISPO
      IF ( IDF .EQ. 6 .OR. (IDF .EQ. 2 .AND. .NOT. LEXC )) THEN
          CALL TRACEB('Liste des appels successifs ' // 
     &                '(option -traceback)',-1)
      ENDIF
C
      IF (LEXC) THEN
C     -- SI L'UTILISATEUR L'A DEMANDE, ON LEVE L'EXCEPTION FATALERROR
C        AU LIEU D'ARRETER BRUTALEMENT LE CODE (ABORT).
         NEXCEP=20
      ENDIF
C
C --- EN CAS DE MESSAGE AVEC SUITE, PAS D'ARRET, PAS D'EXCEPTION
      IF ( .NOT. SUITE ) THEN
C
         IF ( IDF.EQ.6 .OR. IDF.EQ.8 .OR. LEXC ) THEN
C        -- SI UNE EXCEPTION EST LEVEE
            IF (LEXC) THEN
C              ON DETRUIT LE CONCEPT EN CAS D'ERREUR <F> AVEC EXCEPTION
               CALL GETRES(NOMRES,K8B,K8B)
               LC = LXLGUT(NOMRES)
               IF (LC .GT. 0) THEN
                  CALL JEDETC(' ', NOMRES(1:LC), 1)
               ENDIF
            ELSE
C              ON VALIDE LE CONCEPT EN CAS D'ERREUR <S>
               CALL GCUOPR(2, ICMD)
            ENDIF

C           -- MENAGE SUR LA BASE VOLATILE
            CALL JEDETV()

C           REMONTER LES N JEDEMA COURT-CIRCUITES
            CALL JEVEMA(IMAAP)
            DO 10 I=IMAAP, 1, -1
               CALL JEDEMA()
 10         CONTINUE
C
C           ON REMONTE UNE EXCEPTION AU LIEU DE FERMER LES BASES
            LL=MIN(LEN(IDMESS),80)
            K132B= ' <EXCEPTION LEVEE> '//IDMESS(1:LL)
            RECURS = 0
            CALL UEXCEP(NEXCEP,K132B)
         ELSEIF ( IDF .EQ. 2 ) THEN
C        -- ABORT SUR ERREUR <F> "ORDINAIRE"
C           CALL JXVERI('ERREUR',' ')
            CALL JEFINI('ERREUR')
         ENDIF
C
      ENDIF
C
      RECURS = 0
      CALL JEDEMA()

      END
