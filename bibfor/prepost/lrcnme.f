      SUBROUTINE LRCNME ( CHANOM, NOCHMD, NOMAMD,
     >                    NOMAAS, NOMGD,
     >                    NBCMPV, NCMPVA, NCMPVM,
     >                    IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     >                    NROFIC, CODRET )
C_____________________________________________________________________
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 23/06/2005   AUTEUR VABHHTS J.PELLET 
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
C     LECTURE D'UN CHAMP AUX NOEUDS - FORMAT MED
C     -    -       -         -               --
C-----------------------------------------------------------------------
C     ENTREES:
C        CHANOM : NOM ASTER DU CHAMP A LIRE
C        NOCHMD : NOM MED DU CHAMP DANS LE FICHIER
C        NOMAMD : NOM MED DU MAILLAGE LIE AU CHAMP A LIRE
C                  SI ' ' : ON SUPPOSE QUE C'EST LE PREMIER MAILLAGE
C                           DU FICHIER
C        NOMAAS : NOM ASTER DU MAILLAGE
C        NOMGD  : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
C        NBCMPV : NOMBRE DE COMPOSANTES VOULUES
C                 SI NUL, ON LIT LES COMPOSANTES A NOM IDENTIQUE
C        NCMPVA : LISTE DES COMPOSANTES VOULUES POUR ASTER
C        NCMPVM : LISTE DES COMPOSANTES VOULUES DANS MED
C        IINST  : 1 SI LA DEMANDE EST FAITE SUR UN INSTANT, 0 SINON
C        NUMPT  : NUMERO DE PAS DE TEMPS EVENTUEL
C        NUMORD : NUMERO D'ORDRE EVENTUEL DU CHAMP
C        INST   : INSTANT EVENTUEL
C        CRIT   : CRITERE SUR LA RECHERCHE DU BON INSTANT
C        PREC   : PRECISION SUR LA RECHERCHE DU BON INSTANT
C        NROFIC : NUMERO NROFIC LOGIQUE DU FICHIER MED
C     SORTIES:
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*(*) CHANOM
      CHARACTER*(*) NCMPVA, NCMPVM
      CHARACTER*8 NOMAAS, NOMGD
      CHARACTER*8 CRIT
      CHARACTER*32 NOCHMD, NOMAMD
C
      INTEGER NROFIC
      INTEGER NBCMPV
      INTEGER IINST, NUMPT, NUMORD
      INTEGER CODRET
C
      REAL*8 INST
      REAL*8 PREC
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRCNME' )
C
      INTEGER IAUX
      INTEGER NBNOE
      INTEGER JCNSD,JCNSV,JCNSL
      INTEGER JNOCMP, NCMPRF
C
      CHARACTER*1 SAUX01
      CHARACTER*19 CHAMN
      CHARACTER*19 CHAMNS
C
C====
C 1. ALLOCATION D'UN CHAM_NO_S  (CHAMNS)
C====
C
      CALL JEMARQ ( )
C 1.1. ==> REPERAGE DES CARACTERISTIQUES DE CETTE GRANDEUR
C
      CALL JENONU ( JEXNOM ( '&CATA.GD.NOMGD', NOMGD ) , IAUX )
      IF ( IAUX.EQ.0 ) THEN
        CALL UTMESS ( 'F', NOMPRO, 'GRANDEUR INCONNUE')
      ENDIF
      CALL JEVEUO ( JEXNOM ( '&CATA.GD.NOMCMP', NOMGD ) ,
     >              'L', JNOCMP )
      CALL JELIRA ( JEXNOM ( '&CATA.GD.NOMCMP', NOMGD ) ,
     >              'LONMAX', NCMPRF, SAUX01 )
C
C 1.2. ==> ALLOCATION DU CHAM_NO_S
C
C               1234567890123456789
      CHAMNS = '&&      .CNS.MED   '
      CHAMNS(3:8) = NOMPRO
      CALL CNSCRE ( NOMAAS, NOMGD, NCMPRF, ZK8(JNOCMP), 'V', CHAMNS )
C
      CALL JEVEUO ( CHAMNS//'.CNSD', 'L', JCNSD )
      CALL JEVEUO ( CHAMNS//'.CNSV', 'E', JCNSV )
      CALL JEVEUO ( CHAMNS//'.CNSL', 'E', JCNSL )
C
      NBNOE = ZI(JCNSD-1+1)
C
C====
C 2. LECTURE
C====
C
      CALL LRCAME ( NROFIC, NOCHMD, NOMAMD, NOMAAS,
     >              NBNOE,  'NOEU',
     >              NBCMPV, NCMPVA, NCMPVM,
     >              IINST, NUMPT, NUMORD, INST, CRIT, PREC,
     >              NOMGD,  NCMPRF, JNOCMP, JCNSL, JCNSV, JCNSD,
     >              CODRET )
C
C====
C 3. TRANSFORMATION DU CHAM_NO_S EN CHAM_NO :
C====
C
      CHAMN = CHANOM
C
      CALL CNSCNO ( CHAMNS,' ','NON', 'G', CHAMN )
C
      CALL DETRSD ( 'CHAM_NO_S', CHAMNS )
C
C====
C 4. BILAN
C====
C
      IF ( CODRET.NE.0 ) THEN
         CALL UTMESS
     > ( 'A' , NOMPRO, 'LECTURE IMPOSSIBLE POUR '//CHAMN//
     >   ' AU FORMAT MED' )
      ENDIF
      CALL JEDEMA ( )
C
      END
