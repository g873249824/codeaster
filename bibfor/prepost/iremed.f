      SUBROUTINE IREMED(NOMCON,IFICHI,NBCHAM,NOCHAM,NBCMDU,
     &                  NCHMDU,PARTIE,NBORDR,LIORDR,LRESU,
     &                  NBNOEC,LINOEC,NBMAEC,LIMAEC,NBRCMP,
     &                  NOMCMP,LVARIE)
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      CHARACTER*(*)     NOMCON
      CHARACTER*(*)     NOCHAM(*)
      CHARACTER*(*)     NOMCMP(*),PARTIE
      CHARACTER*(*)     NCHMDU(*)
      INTEGER           NBCHAM,NBCMDU,IFICHI
      INTEGER           NBORDR,LIORDR(*),NBRCMP
      INTEGER           NBNOEC,LINOEC(*),NBMAEC,LIMAEC(*)
      LOGICAL           LRESU,LVARIE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 24/07/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE SELLENET N.SELLENET
C
C-----------------------------------------------------------------------
C     ECRITURE D'UN CONCEPT SUR FICHIER MED
C
C IN  NOMCON : K8  : NOM DU CONCEPT A IMPRIMER
C IN  IFICHI : IS  : UNITE LOGIQUE D'ECRITURE
C IN  NBCHAM : I   : NOMBRE DE CHAMP DANS LE TABLEAU CHAM
C IN  NOCHAM : K16 : NOM DES CHAMPS A IMPRIMER ( EX 'DEPL', ....
C IN  NBCMDU : I   : NOMBRE DE CHAMP DANS LE TABLEAU NCHMDU
C IN  NCHMDU : K80 : NOM DES CHAMPS MED UTILISATEUR
C IN  PARTIE : K4  : IMPRESSION DE LA PARTIE COMPLEXE OU REELLE DU CHAMP
C IN  NBORDR : I   : NOMBRE DE NUMEROS D'ORDRE DANS LE TABLEAU ORDR
C IN  LIORDR : I   : LISTE DES NUMEROS D'ORDRE A IMPRIMER
C IN  LRESU  : L   : INDIQUE SI NOMCON EST UN CHAMP OU UN RESULTAT
C IN  NBNOEC : I   : NOMBRE DE NOEUDS A IMPRIMER
C IN  LINOEC : I   : NUMEROS DES NOEUDS A IMPRIMER
C IN  NBMAEC : I   : NOMBRE DE MAILLES A IMPRIMER
C IN  LIMAEC : I   : NUMEROS DES MAILLES A IMPRIMER
C IN  NBRCMP : I   : NOMBRE DE COMPOSANTES A IMPRIMER
C IN  NOMCMP : K8  : NOMS DES COMPOSANTES A IMPRIMER
C     ------------------------------------------------------------------
C TOLE CRS_1404
C
C     ------------------------------------------------------------------
      CHARACTER*6  CHNUMO
      CHARACTER*8  TYPECH,NOMGD,SAUX08,NORESU
      CHARACTER*16 NOSY16
      CHARACTER*19 CHAM19
      CHARACTER*24 VALK(2),TYRES
      CHARACTER*64 NOMMED,NOCHMD
C
      INTEGER      NUMORD,ISY,IORDR,IRET,LXLGUT,IBID,CODRET
      INTEGER      NUMCMP(NBRCMP),LNOCHM,I
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      NORESU=NOMCON
C
C     *******************************************
C     --- BOUCLE SUR LA LISTE DES NUMEROS D'ORDRE
C     *******************************************
C
      DO 21 IORDR = 1,NBORDR
        CALL JEMARQ()
        CALL JERECU('V')
C
C       --- SI VARIABLE DE TYPE RESULTAT = RESULTAT COMPOSE :
C           VERIFICHICATION CORRESPONDANCE ENTRE NUMERO D'ORDRE
C           UTILISATEUR ORDR(IORDR) ET NUMERO DE RANGEMENT IRET
C AU CAS OU ON NE PASSE PAS EN DESSOUS ON INITIALISE LORDR A FALSE
        IF ( LRESU ) THEN
          CALL RSUTRG(NOMCON,LIORDR(IORDR),IRET)
          IF(IRET.EQ.0) THEN
C           - MESSAGE NUMERO D'ORDRE NON LICITE
            CALL CODENT(LIORDR(IORDR),'G',CHNUMO)
            CALL U2MESK('A','PREPOST2_46',1,CHNUMO)
            GOTO 22
          ENDIF
        ENDIF
C
C       --- BOUCLE SUR LE NOMBRE DE CHAMPS A IMPRIMER
        DO 20 ISY = 1,NBCHAM
          IF( LRESU ) THEN
C         * RESULTAT COMPOSE
C           - VERIFICHICATION EXISTENCE DANS LA SD RESULTAT NOMCON
C             DU CHAMP CHAM(ISY) POUR LE NO. D'ORDRE ORDR(IORDR)
C             ET RECUPERATION DANS CHAM19 DU NOM SE LE CHAM_GD EXISTE
            CALL RSEXCH(' ',NOMCON,NOCHAM(ISY),LIORDR(IORDR),CHAM19,
     &                  IRET)
            IF(IRET.NE.0) GOTO 20
          ELSE
C         * CHAM_GD
            CHAM19 = NOMCON
          ENDIF
C
C         * IMPRESSION DU CHAMP (CHAM_NO OU CHAM_ELEM)
C             LE CHAMP EST UN CHAM_GD SIMPLE SI LRESU=.FALSE. OU
C             LE CHAMP EST LE CHAM_GD CHAM(ISY) DE NUMERO D'ORDRE
C             ORDR(IORDR) ISSU DE LA SD_RESULTAT NOMCON
          IF(NBCMDU.EQ.0)THEN
              NOMMED=' '
          ELSE
              NOMMED=NCHMDU(ISY)
          ENDIF
          NOSY16=NOCHAM(ISY)
          NUMORD=LIORDR(IORDR)
C
C       --- TYPE DU CHAMP A IMPRIMER (CHAM_NO OU CHAM_ELEM)
          CALL DISMOI('F','TYPE_CHAMP',CHAM19,'CHAMP',
     &                IBID,TYPECH,CODRET)
          CALL DISMOI('F','TYPE_RESU',NORESU,'RESULTAT',
     &                IBID,TYRES,CODRET)

          IF ((TYPECH(1:4).EQ.'NOEU') .OR. (TYPECH(1:2).EQ.'EL')) THEN
          ELSEIF ( TYPECH(1:4).EQ. 'CART' ) THEN
C            GOTO 9999
          ELSE
            VALK(1) = TYPECH
            VALK(2) = CHAM19
            IF( TYRES(1:9).EQ.'MODE_GENE'.OR.
     &          TYRES(1:9).EQ.'HARM_GENE') THEN
              CALL U2MESK('A+','PREPOST_87',2,VALK)
              CALL U2MESS('A' ,'PREPOST6_36')
            ELSE
              CALL U2MESK('A','PREPOST_87',2,VALK)
            ENDIF
          ENDIF
C
C         --- NOM DE LA GRANDEUR ASSOCIEE AU CHAMP CHAM19
          CALL DISMOI('F','NOM_GD',CHAM19,'CHAMP',IBID,NOMGD,CODRET)
          IF ( (TYPECH(1:4).EQ. 'CART'.AND.NOMGD(6:7).NE.'R').OR.
     &         NOMGD.EQ.'COMPOR' ) GOTO 9999
C
          IF ( NBRCMP .NE. 0 ) THEN
            IF ( (NOMGD.EQ.'VARI_R') .AND. (TYPECH(1:2).EQ.'EL') ) THEN
C ----------- TRAITEMENT SUR LES "NOMCMP"
              CALL UTCMP3 ( NBRCMP, NOMCMP, NUMCMP )
            ENDIF
          ENDIF

          SAUX08 = NORESU

          IF (NBCMDU.EQ.0) THEN
            CALL MDNOCH ( NOCHMD, LNOCHM,
     &                    LRESU, SAUX08, NOSY16, CODRET )
          ELSE
            DO 10 I=1,64
              NOCHMD(I:I) = ' '
 10         CONTINUE
            I = LXLGUT(NOMMED)
            NOCHMD(1:I) = NOMMED(1:I)
          ENDIF
C
C         -- ON LANCE L'IMPRESSION:
C         -------------------------
C
          IF ( .NOT.LRESU ) NORESU = ' '
          CALL IRCHME ( IFICHI, CHAM19, PARTIE, NOCHMD, NORESU,
     &                  NOSY16, TYPECH, NUMORD, NBRCMP, NOMCMP,
     &                  NBNOEC, LINOEC, NBMAEC, LIMAEC, LVARIE,
     &                  CODRET )
C
 9999     CONTINUE
C
          IF ( CODRET.NE.0 ) THEN
            VALK(1) = CHAM19
            VALK(2) = 'MED'
            CALL U2MESK('A','PREPOST_90', 2 ,VALK)
          ENDIF
C
   20   CONTINUE
C
   22   CONTINUE
        CALL JEDEMA()
   21 CONTINUE
C
      CALL JEDEMA()
      END
