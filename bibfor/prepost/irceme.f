      SUBROUTINE IRCEME ( FICH, NOCHMD, CHANOM,
     >                    NBCMP, NOMCMP,
     >                    NUMPT, INSTAN, UNIINS, NUMORD,
     >                    NBMAEC, LIMAEC,
     >                    CODRET )
C_______________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 16/10/2002   AUTEUR GNICOLAS G.NICOLAS 
C RESPONSABLE GNICOLAS G.NICOLAS
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
C        IMPRESSION DU CHAMP CHANOM ELEMENT ENTIER/REEL
C        AU FORMAT MED
C     ENTREES:
C        FICH   : NOM DU FICHIER OU ON DOIT IMPRIMER LE CHAMP
C        NOCHMD : NOM MED DU CHAM A ECRIRE
C        CHANOM : NOM ASTER DU CHAM A ECRIRE
C        NBCMP  : NOMBRE DE COMPOSANTES A ECRIRE
C        NOMCMP : NOMS DES COMPOSANTES A ECRIRE
C        NUMPT  : NUMERO DE PAS DE TEMPS
C        INSTAN : VALEUR DE L'INSTANT A ARCHIVER
C        UNIINS : UNITE DE L'INSTANT A ARCHIVER
C        NUMORD : NUMERO D'ORDRE DU CHAMP
C        NBMAEC : NOMBRE DE MAILLES A ECRIRE (0, SI TOUTES LES MAILLES)
C        LIMAEC : LISTE DES MAILLES A ECRIRE SI EXTRAIT
C    SORTIES:
C       CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C_______________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*8 UNIINS
      CHARACTER*19 CHANOM
      CHARACTER*32 NOCHMD
      CHARACTER*(*) FICH, NOMCMP(*)
C
      INTEGER NBCMP, NUMPT, NUMORD
      INTEGER NBMAEC
      INTEGER LIMAEC(*)
C
      REAL*8 INSTAN
C
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRCEME' )
C
      CHARACTER*19 CHAMNS
C
      INTEGER JCESK, JCESD, JCESC, JCESV, JCESL
C
      LOGICAL SUPNOE
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C====
C 1. PREALABLE
C====
C
C    --- CONVERSION CHAM_ELEM -> CHAM_ELEM_S
C               1234567890123456789
      CHAMNS = '&&      .CES.MED'
      CHAMNS(3:8) = NOMPRO
      CALL CELCES ( CHANOM, 'V', CHAMNS )
C
C    --- ON RECUPERE LES OBJETS
C
      CALL JEVEUO ( CHAMNS//'.CESK', 'L', JCESK )
      CALL JEVEUO ( CHAMNS//'.CESD', 'L', JCESD )
      CALL JEVEUO ( CHAMNS//'.CESC', 'L', JCESC )
      CALL JEVEUO ( CHAMNS//'.CESV', 'L', JCESV )
      CALL JEVEUO ( CHAMNS//'.CESL', 'L', JCESL )
C
C====
C 2. ECRITURE DES CHAMPS AU FORMAT MED
C====
C
      SUPNOE = .FALSE.
      CALL IRCAME ( FICH, NOCHMD,
     >              NBCMP, NOMCMP,
     >              NUMPT, INSTAN, UNIINS, NUMORD,
     >              JCESK, JCESD, JCESC, JCESV, JCESL,
     >              NBMAEC, LIMAEC,
     >              SUPNOE,
     >              CODRET )
C
C====
C 3. ON NETTOIE
C====
C
      IF ( CODRET.EQ.0 ) THEN
C
      CALL DETRSD ( 'CHAM_ELEM_S', CHAMNS )
C
      ENDIF
C
C====
C 4. BILAN
C====
C
      IF ( CODRET.NE.0 ) THEN
         CALL UTMESS
     > ( 'A' , NOMPRO, 'ECRITURE IMPOSSIBLE POUR '//CHANOM//
     >   ' AU FORMAT MED' )
      ENDIF
C
      CALL JEDEMA()
C
      END
