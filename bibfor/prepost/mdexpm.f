      SUBROUTINE MDEXPM ( NOFIMD, IDFIMD, NOMAMD, EXISTM,
     &                    NDIM, CODRET )
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/05/2011   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SELLENET N.SELLENET
C        FORMAT MED : EXISTENCE DU PREMIER MAILLAGE DANS UN FICHIER
C               - -   --           -       -
C ______________________________________________________________________
C .        .     .        .                                            .
C .  NOM   . E/S . TAILLE .           DESCRIPTION                      .
C .____________________________________________________________________.
C . NOFIMD .  E  .   1    . NOM DU FICHIER MED                         .
C . NOFIMD .  E  .   1    . OU NUMERO DU FICHIER DEJA OUVERT           .
C . NOMAMD .  S  .   1    . NOM DU MAILLAGE MED VOULU                  .
C . EXISTM .  S  .   1    . .TRUE. OU .FALSE., SELON QUE LE MAILLAGE   .
C .        .     .        . EST PRESENT OU NON                         .
C . NDIM   .  S  .   1    . LA DIMENSION DU MAILLAGE QUAND IL EXISTE   .
C . CODRET .  S  .   1    . CODE DE RETOUR DES MODULES                 .
C ______________________________________________________________________
C
C====
C 0. DECLARATIONS ET DIMENSIONNEMENT
C====
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*(*) NOFIMD, NOMAMD
C
      LOGICAL EXISTM,FICEXI,DEJOUV
C
      INTEGER NDIM, CODRET
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
      INTEGER EDNSTR
      PARAMETER (EDNSTR=0)
C
      INTEGER LXLGUT
C
      INTEGER IDFIMD, NBMAIE
      INTEGER IAUX, JAUX, KAUX, TYAUX
C
      CHARACTER*8  SAUX08
      CHARACTER*64 SAUX64
      CHARACTER*200 DAUX
C ______________________________________________________________________
C
C====
C 1. ON OUVRE LE FICHIER EN LECTURE
C    ON PART DU PRINCIPE QUE SI ON N'A PAS PU OUVRIR, C'EST QUE LE
C    FICHIER N'EXISTE PAS, DONC SANS MAILLAGE A FORTIORI
C====
C
      EXISTM = .FALSE.
      CODRET = 0
      INQUIRE(FILE=NOFIMD,EXIST=FICEXI)
C
      IF ( .NOT. FICEXI ) THEN
C
      EXISTM = .FALSE.
      CODRET = 0
C
      ELSE
C
      IF ( IDFIMD.EQ.0 ) THEN
        CALL MFOUVR ( IDFIMD, NOFIMD, EDLECT, IAUX )
        DEJOUV = .FALSE.
      ELSE
        DEJOUV = .TRUE.
        IAUX = 0
      ENDIF
      IF ( IAUX.EQ.0 ) THEN
C====
C 2. LE MAILLAGE EST-IL PRESENT ?
C====
C
C 2.1. ==> COMBIEN DE MAILLAGES DANS LE FICHIER
C
      CALL MFNMAA ( IDFIMD, NBMAIE, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFNMAA  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C 2.2. ==> RECHERCHE DU NOM ET DE LA DIMENSION DU PREMIER MAILLAGE
C
      IF ( NBMAIE.EQ.0 ) THEN
C
        EXISTM = .FALSE.
C
      ELSE
C
C                 12345678901234567890123456789012
        SAUX64 = '                                '//
     &           '                                '
        DAUX = ' '
        IAUX = 1
        CALL MFMAAI ( IDFIMD, IAUX, SAUX64, KAUX, TYAUX, DAUX, CODRET )
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFMAAI  '
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
        IF ( TYAUX .NE. EDNSTR ) THEN
          CALL U2MESS('A','MED_81')
        ENDIF
C
        IAUX = LEN(NOMAMD)
        JAUX = LXLGUT(SAUX64)
        CALL ASSERT(JAUX.LE.IAUX)
C
        NOMAMD = ' '
        NOMAMD(1:JAUX) = SAUX64(1:JAUX)
        NDIM = KAUX
        EXISTM = .TRUE.
C
      ENDIF
C
C 2.3. ==> FERMETURE DU FICHIER
C
      IF ( .NOT.DEJOUV ) THEN
        CALL MFFERM ( IDFIMD, CODRET )
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFFERM  '
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
        IDFIMD = 0
      ENDIF
C
      ENDIF
      ENDIF
C
      END
