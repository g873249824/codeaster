      SUBROUTINE MDEXCC ( NOFIMD, IDFIMD, NOCHMD, NBCMPC, NOMCMC,
     &                    EXISTC, NBCMFI, NMCMFI, CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/05/2011   AUTEUR SELLENET N.SELLENET 
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
C_____________________________________________________________________
C        FORMAT MED : EXISTENCE D'UN CHAMP - EST-IL CREE DANS UN FICHIER
C               - -   --             -              -
C_______________________________________________________________________
C .        .     .        .                                            .
C .  NOM   . E/S . TAILLE .           DESCRIPTION                      .
C .____________________________________________________________________.
C . NOFIMD .  E  .   1    . NOM DU FICHIER MED                         .
C . NOFIMD .  E  .   1    . OU NUMERO DU FICHIER DEJA OUVERT           .
C . NOCHMD .  E  .   1    . NOM DU CHAMP MED VOULU                     .
C . NBCMPC .  E  .   1    . NOMBRE DE COMPOSANTES A CONTROLER          .
C          .     .        . S'IL EST NUL, ON NE CONTROLE RIEN          .
C . NOMCMC .  E  .   *    . SD DES NOMS DES COMPOSANTES A CONTROLER    .
C . NOMAMD .  E  .   1    . NOM DU MAILLAGE MED ASSOCIE                .
C . EXISTC .  S  .   1    . 0 : LE CHAMP N'EST PAS CREE                .
C .        .     .        . >0 : LE CHAMP EST CREE AVEC :              .
C .        .     .        . 1 : LES COMPOSANTES VOULUES SONT PRESENTES .
C .        .     .        . 2 : LES COMPOSANTES VOULUES NE SONT PAS    .
C .        .     .        .     TOUTES ENREGISTREES                    .
C . NBCMFI .  S  .   1    . NOMBRE DE COMPOSANTES DANS LE FICHIER      .
C . NMCMFI .  S  .   1    . SD DU NOM DES COMPOSANTES DANS LE FICHIER  .
C . CODRET .  S  .    1   . CODE DE RETOUR DES MODULES                 .
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
      CHARACTER*(*) NOFIMD, NOCHMD
      CHARACTER*(*) NOMCMC, NMCMFI
C
      INTEGER NBCMPC, EXISTC, NBCMFI
C
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'MDEXCC' )
C
      INTEGER EDLECT
      INTEGER VALI(2)
      PARAMETER (EDLECT=0)
      INTEGER MFLOAT
      PARAMETER (MFLOAT=6)
C
      INTEGER LXLGUT
C
      INTEGER LNOCHM
      INTEGER IDFIMD, NBCHAM
      INTEGER IAUX, JAUX, KAUX
      INTEGER ADNCMP, ADUCMP, ADNCMC, ADNCFI, NSEQCA
      LOGICAL FICEXI,DEJOUV
C
      CHARACTER*8 SAUX08
      CHARACTER*16 SAUX16
      CHARACTER*64 SAUX64
C ______________________________________________________________________
C
C===
C 1. ON OUVRE LE FICHIER EN LECTURE
C    ON PART DU PRINCIPE QUE SI ON N'A PAS PU OUVRIR, C'EST QUE LE
C    FICHIER N'EXISTE PAS, DONC SANS CHAMP A FORTIORI
C====
C
      EXISTC = 0
      NBCMFI = -1
      CODRET = 0
C
      INQUIRE(FILE=NOFIMD,EXIST=FICEXI)
C
      IF ( FICEXI ) THEN
      IF ( IDFIMD.EQ.0 ) THEN
        CALL MFOUVR ( IDFIMD, NOFIMD, EDLECT, IAUX )
        DEJOUV = .FALSE.
      ELSE
        DEJOUV = .TRUE.
        IAUX = 0
      ENDIF
      IF ( IAUX.EQ.0 ) THEN
C
C====
C 2. LE CHAMP EST-IL PRESENT ?
C====
C
C 2.1. ==> NBCHAM : NOMBRE DE CHAMPS DANS LE FICHIER
C
      CALL MFNCHA ( IDFIMD, NBCHAM, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFNCHA  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C 2.2. ==> RECHERCHE DU CHAMP VOULU
C
      LNOCHM = LXLGUT(NOCHMD)
C
      DO 22 , IAUX = 1 , NBCHAM
C
C 2.2.1. ==> NBCMFI : NOMBRE DE COMPOSANTES DANS LE FICHIER POUR
C                     LE CHAMP NUMERO IAUX
C
      CALL MFNCOM ( IDFIMD, IAUX, NBCMFI, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFNCOM  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C 2.2.2. ==> POUR LE CHAMP NUMERO IAUX, ON RECUPERE :
C            SAUX64 : NOM DU CHAMP
C            ZK16(ADNCMP) : NOM DE SES NBCMFI COMPOSANTES
C            ZK16(ADUCMP) : UNITES DE SES NBCMFI COMPOSANTES
C
      CALL CODENT ( IAUX,'G',SAUX08 )
      CALL WKVECT ('&&'//NOMPRO//'N'//SAUX08,
     &             'V V K16',  NBCMFI, ADNCMP )
      CALL WKVECT ('&&'//NOMPRO//'U'//SAUX08,
     &             'V V K16', NBCMFI, ADUCMP )
C               12345678901234567890123456789012
      SAUX64 = '                                '//
     &'                                '
      CALL MFCHAI ( IDFIMD, IAUX, SAUX64, JAUX, ZK16(ADNCMP),
     &              ZK16(ADUCMP), NSEQCA, CODRET )
      IF ( CODRET.NE.0 .OR. JAUX .NE. MFLOAT ) THEN
        VALI (1) = IAUX
        IF ( CODRET.NE.0 ) THEN
          SAUX08='MFCHAI  '
          CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
        ENDIF
        IF (JAUX.NE.MFLOAT) THEN
          VALI (1) = JAUX
          CALL U2MESG('A+','MED_84',0,' ',1,VALI,0,0.D0)
          CALL U2MESS('F','MED_75')
        ENDIF
      ENDIF
C
C 2.2.3. ==> COMPARAISON DU NOM DU CHAMP
C
      JAUX = LXLGUT(SAUX64)
C
      IF ( JAUX.EQ.LNOCHM ) THEN
        IF ( SAUX64(1:JAUX).EQ.NOCHMD(1:LNOCHM) ) THEN
          EXISTC = 1
        ENDIF
      ENDIF
C
C 2.2.4. ==> C'EST LE BON CHAMP. CONTROLE DU NOM DES COMPOSANTES
C
      IF ( EXISTC.EQ.1 ) THEN
C
C 2.2.4.1. ==> TRANSFERT DES NOMS DES COMPOSANTES DANS LE TABLEAU
C              DE SORTIE
C
        CALL WKVECT ( NMCMFI, 'V V K16',  NBCMFI, ADNCFI )
C
        DO 2241 , KAUX = 0 , NBCMFI-1
          ZK16(ADNCFI+KAUX) = ZK16(ADNCMP+KAUX)
 2241   CONTINUE
C
C 2.2.4.2. ==> TEST DES NOMS DES COMPOSANTES
C
        IF ( NBCMPC.GT.NBCMFI ) THEN
C
          EXISTC = 2
C
        ELSEIF ( NBCMPC.GT.0 ) THEN
C
          CALL JEVEUO ( NOMCMC, 'L', ADNCMC )
C
C      ZK16(ADNCMC+JAUX) : NOM DE LA (JAUX+1)-EME COMPOSANTE A CONTROLER
C      ZK16(ADNCMP+KAUX) : NOM DE LA (KAUX+1)-EME COMPOSANTE DU CHAMP
C
          DO 2242 , JAUX = 0 , NBCMPC-1
C
            SAUX16 = ZK16(ADNCMC+JAUX)
C
            DO 2243 , KAUX = 0 , NBCMFI-1
              IF ( SAUX16.EQ.ZK16(ADNCMP+KAUX) ) THEN
                GOTO 2242
              ENDIF
 2243       CONTINUE
C
C           AUCUNE COMPOSANTE DU CHAMP LU NE CORRESPOND A LA COMPOSANTE
C           SOUHAITEE
C
            EXISTC = 2
C
 2242     CONTINUE
C
        ENDIF
C
        GOTO 30
C
      ENDIF
C
   22 CONTINUE
C
C====
C 3. LA FIN
C====
C
   30   CONTINUE
C
C 3.1. ==> MENAGE
C
      CALL JEDETC ('V','&&'//NOMPRO,1)
C
C 3.2. ==> FERMETURE DU FICHIER
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
