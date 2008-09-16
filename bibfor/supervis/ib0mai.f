      SUBROUTINE IB0MAI ( IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                      IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 16/09/2008   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C     MAIN  D'ANALYSE DE LA COMMANDE DE DEMARRAGE
C     ------------------------------------------------------------------
C OUT IER  CODE RETOUR
C      1   PROCEDURE "DEBUT" ET "POURSUITE" NON TROUVEES
C      2   ERREUR(S) DANS LA COMMANDE  "DEBUT" OU "POURSUITE"
C      0   SINON
C     ------------------------------------------------------------------
      CHARACTER*16 NOMCMD(2)
      CHARACTER*8  NOMF
      INTEGER      LG(2), UNMEGA, IADZON, VALI(2)
      LOGICAL      LERMEM
      LOGICAL      LMEMEX
C
C     --- MEMOIRE POUR LE GESTIONNAIRE D'OBJET ---
      UNMEGA = 1 024 * 1 024
      IADZON = 0
      LMO  = 0
C     RESTRICTION POUR UNE TAILLE MEMOIRE JEVEUX EXACTE
      LOIS = LOISEM()
      LERMEM = .FALSE.
      FNTMEM = -1.0D0
      MEMDEM = MEJVST ( FNTMEM ) / LOIS 
      WRITE(6,'(/,1X,A)') 'PARAMETRES DE LA GESTION MEMOIRE JEVEUX  '
      WRITE(6,'(1X,A)')   '======================================='
      IF ( MEMDEM .GT. 0 ) THEN
         FNTMEM = MEMDEM * 1.0D0/ UNMEGA
         WRITE(6,'(1X,A,I14,A,F12.3,A)') 
     &           'LIMITE MEMOIRE STATIQUE       : ',
     &            MEMDEM*LOIS,' OCTETS (',FNTMEM*LOIS,' Mo)'
         IMEMO  = MEMDIS (MEMDEM, IADZON, LMO, 0)
         WRITE(6,'(1X,A,I14,A)') 'MEMOIRE DISPONIBLE            : ',
     &             IMEMO*LOIS,' OCTETS'
         IF ( MEMDEM .LE. IMEMO ) THEN
            IMEMO = MEMDEM
         ELSE
            LERMEM = .TRUE.
         ENDIF
      ELSE
         IMEMO = UNMEGA
      ENDIF
      FNTMEM = IMEMO * 1.0D0 / UNMEGA
      WRITE(6,'(1X,A,I14,A,F12.3,A)') 
     &        'MEMOIRE PRISE                 : ',
     &         IMEMO*LOIS,' OCTETS (',FNTMEM*LOIS,' Mo)'
C
C     --- OUVERTURE DE GESTIONNAIRE D'OBJET ---
      INTDBG = -1
      IF (ISDBGJ(INTDBG) .EQ. 1) THEN
         IDEBUG = 1
      ELSE
         IDEBUG = 0
      ENDIF
      VDY = -1.0D0
      MXDYN =  MEMJVX (VDY) - IMEMO
      IF ( MXDYN .GT. 0 ) THEN
        WRITE(6,'(1X,A,I14,A,F12.3,A)') 
     &          'LIMITE MEMOIRE DYNAMIQUE      : ',
     &           MXDYN*LOIS,' OCTETS (',MXDYN*LOIS*1.D0/UNMEGA,' Mo)'
      ENDIF
      CALL JEDEBU(4,IMEMO,MXDYN,IADZON,LMO,'MESSAGE','VIGILE',IDEBUG )
      WRITE(6,'(1X,A)')   '======================================='
C
C     --- ALLOCATION D'UNE BASE DE DONNEES DUMMY ---
      NOMF = 'LDUMMY'
      CALL JEINIF( 'DUMMY','DETRUIT',NOMF,'L', 250 , 100, 1 )
C
      CALL ULDEFI(6,' ','MESSAGE','A','N','N')
      CALL ULDEFI(9,' ','ERREUR' ,'A','N','N')
      CALL UTINIT(2, 80, 1)

      IF ( LERMEM ) CALL U2MESI('F','SUPERVIS_11',1,INT(FNTMEM*LOIS))

      IF (IDEBUG .EQ. 1) THEN
         CALL U2MESS('I','SUPERVIS_12')
      ENDIF
      END
