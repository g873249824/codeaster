      SUBROUTINE IRCH19 ( CHAM19,PARTIE,FORM,IFI,TITRE,NOMO,
     &                    NOMSD,NOSIMP,NOPASE,NOMSYM,NBCMDU,NOMMED,
     &                    NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,
     &                    LCHAM1,LCOR,NBNOT,NUMNOE,NBMAT,NUMMAI,NBCMP,
     &                    NOMCMP,LSUP,BORSUP,LINF,BORINF,LMAX,LMIN,
     &                    LRESU,FORMR,NIVE )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 30/05/2011   AUTEUR REZETTE C.REZETTE 
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
C TOLE CRP_21 CRS_1404
C ----------------------------------------------------------------------
C     IMPRIMER UN CHAMP (CHAM_NO OU CHAM_ELEM)
C
C IN  CHAM19: NOM DU CHAM_XX
C IN  PARTIE: IMPRESSION DE LA PARTIE IMAGINAIRE OU REELLE POUR
C             UN CHAMP COMPLEXE AU FORMAT CASTEM OU GMSH OU MED
C IN  FORM  : FORMAT :'RESULTAT','SUPERTAB', 'ENSIGHT'
C IN  IFI   : UNITE LOGIQUE D'IMPRESSION DU CHAMP.
C IN  TITRE : TITRE.
C IN  NOMO  : NOM DU MODELE SUPPORT.
C IN  NOMSD : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER.
C IN  NOSIMP: NOM SIMPLE ASSOCIE AU CONCEPT NOMSD SI SENSIBILITE
C IN  NOPASE: NOM DU PARAMETRE SENSIBLE
C IN  NOMSYM: NOM SYMBOLIQUE DU CHAMP A IMPRIMER
C IN  NBCMDU: NOMBRE DE CHAMP MED UTILISATEUR
C IN  NOMMED: NOM DU CHAMP MED UTILISATEUR
C IN  NUMORD: NUMERO D'ORDRE DU CHAMP DANS LE RESULTAT_COMPOSE.
C             (1 SI LE RESULTAT EST UN CHAM_GD)
C IN  NUORD1: NUMERO DU PREMIER DES NUMEROS D'ORDRE A IMPRIMER
C             (POUR FORMAT 'ENSIGHT')
C IN  NORDEN: NOMBRE DE NUMEROS D'ORDRE A IMPRIMER
C             (POUR FORMAT 'ENSIGHT')
C IN  IORDEN: INDICE DE NUMORD DANS LA LISTE DES NUMEROS D'ORDRE
C             A IMPRIMER (POUR FORMAT 'ENSIGHT')
C IN  NBCHAM: NOMBRE DE CHAMPS A IMPRIMER (POUR FORMAT 'ENSIGHT')
C IN  ICHAM : INDICE DU CHAMP DANS LA LISTE DES CHAMPS A IMPRIMER
C             (POUR FORMAT 'ENSIGHT')
C IN  LCHAM1: INDIQUE SI LE CHAMP EST LE PREMIER DES CHAMPS A IMPRIMER
C             POUR LE NUMERO D'ORDRE NUMORD
C             (POUR FORMAT 'ENSIGHT')
C IN  LCOR  : IMPRESSION DES COORDONNEES DE NOEUDS .TRUE. IMPRESSION
C IN  NBNOT : NOMBRE DE NOEUDS A IMPRIMER
C IN  NUMNOE: NUMEROS DES NOEUDS A IMPRIMER
C IN  NBMAT : NOMBRE DE MAILLES A IMPRIMER
C IN  NUMMAI: NUMEROS DES MAILLES A IMPRIMER
C IN  NBCMP : NOMBRE DE COMPOSANTES A IMPRIMER
C IN  NOMCMP: NOMS DES COMPOSANTES A IMPRIMER
C IN  LSUP  : =.TRUE. INDIQUE PRESENCE D'UNE BORNE SUPERIEURE
C IN  BORSUP: VALEUR DE LA BORNE SUPERIEURE
C IN  LINF  : =.TRUE. INDIQUE PRESENCE D'UNE BORNE INFERIEURE
C IN  BORINF: VALEUR DE LA BORNE INFERIEURE
C IN  LMAX  : =.TRUE. INDIQUE IMPRESSION VALEUR MAXIMALE
C IN  LMIN  : =.TRUE. INDIQUE IMPRESSION VALEUR MINIMALE
C IN  LRESU : =.TRUE. INDIQUE IMPRESSION D'UN CONCEPT RESULTAT
C IN  FORMR : FORMAT D'ECRITURE DES REELS SUR "RESULTAT"
C IN  NIVE  : NIVEAU IMPRESSION CASTEM 3 OU 10
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
C
      CHARACTER*(*)     CHAM19, NOMSD,NOSIMP,NOPASE, NOMSYM
      CHARACTER*(*)     FORM, NOMO, FORMR, TITRE, NOMCMP(*), PARTIE
      CHARACTER*64      NOMMED
      REAL*8            BORSUP, BORINF
      INTEGER           NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,NBMAT
      INTEGER           NBNOT,NUMNOE(*),NUMMAI(*),NBCMP,NCMP,NBCMDU
      INTEGER           NIVE
      LOGICAL           LCOR, LCHAM1, LSUP, LINF, LMAX, LMIN, LRESU
C
C 0.3. ==> VARIABLES LOCALES
C
C
      CHARACTER*8   TYCH, NOMGD
      CHARACTER*8   NOMSD8, NOSIM8, NOMPA8
      CHARACTER*16  NOSY16
      CHARACTER*19  CH19
      CHARACTER*24 VALK(2), TYRES
      INTEGER       LGNOGD,LGCH16,IBID,IERD,IFI,LXLGUT,NUMCMP(NBCMP)
C
C     PASSAGE DANS DES VARIABLES FIXES
C
      CH19 = CHAM19
      NOMSD8 = NOMSD
      NOSIM8 = NOSIMP
      NOMPA8 = NOPASE
      NOSY16 = NOMSYM
      LGCH16 = LXLGUT(NOSY16)
C
C     --- TYPE DU CHAMP A IMPRIMER (CHAM_NO OU CHAM_ELEM)
      CALL DISMOI('F','TYPE_CHAMP',CH19,'CHAMP',IBID,TYCH,IERD)
      CALL DISMOI('F','TYPE_RESU',NOMSD8,'RESULTAT',IBID,TYRES,IERD)

      IF ((TYCH(1:4).EQ.'NOEU') .OR. (TYCH(1:2).EQ.'EL')) THEN
      ELSEIF ( TYCH(1:4).EQ. 'CART' ) THEN
         GOTO 9999
      ELSE
          VALK(1) = TYCH
          VALK(2) = CH19
          IF(TYRES(1:9) .EQ. 'MODE_GENE'  .OR.
     &       TYRES(1:9) .EQ. 'HARM_GENE')THEN
             CALL U2MESK('A+','PREPOST_87', 2 ,VALK)
             CALL U2MESS('A' ,'PREPOST6_36')
          ELSE
             CALL U2MESK('A','PREPOST_87', 2 ,VALK)
          ENDIF
      ENDIF
C
C     --- NOM DE LA GRANDEUR ASSOCIEE AU CHAMP CH19
      CALL DISMOI('F','NOM_GD',CH19,'CHAMP',IBID,NOMGD,IERD)
C
       NCMP = 0
       IF ( NBCMP .NE. 0 ) THEN
         IF ( (NOMGD.EQ.'VARI_R') .AND. (TYCH(1:2).EQ.'EL') ) THEN
C --------- TRAITEMENT SUR LES "NOMCMP"
            NCMP = NBCMP
            CALL UTCMP3 ( NBCMP, NOMCMP, NUMCMP )
         ENDIF
       ENDIF
C
C     -- POUR LE FORMAT "ENSIGHT" ON VERIFIE LE CHAMP:
C     -------------------------------------------------
      IF((FORM(1:7).EQ.'ENSIGHT') .AND. (TYCH(1:2).EQ.'EL')) THEN
        LGNOGD=LXLGUT(NOMGD)
         VALK(1) = NOSY16(1:LGCH16)
         VALK(2) = NOMGD(1:LGNOGD)
         CALL U2MESK('A','PREPOST_88', 2 ,VALK)
        GO TO 9999
      ENDIF
C
C     -- ON LANCE L'IMPRESSION:
C     -------------------------
C
C     -- EMBRANCHEMENT DE L'ECRITURE AU FORMAT MED
C     -- POUR LES AUTRES, PROCEDURE CLASSIQUE
C
      IF (FORM(1:3).EQ.'MED') THEN
         CALL IRCHME ( IFI, CH19,  NBCMDU, NOMMED, NOMO, PARTIE,
     &                 LRESU, NOMSD8, NOSIM8, NOMPA8, NOSY16,
     &                 TYCH, NUMORD,
     &                 NBCMP, NOMCMP,
     &                 NBNOT, NUMNOE, NBMAT, NUMMAI,
     &                 IERD )
      ELSE IF (TYCH(1:4).EQ.'NOEU'.AND.NBNOT.GE.0) THEN
         CALL IRDEPL(CH19,PARTIE,IFI,FORM,TITRE,NOMSD,NOMSYM,
     &      NUMORD,NUORD1,NORDEN,IORDEN,NBCHAM,ICHAM,LCHAM1,LCOR,
     &      NBNOT,NUMNOE,NBCMP,NOMCMP,LSUP,BORSUP,LINF,BORINF,
     &      LMAX,LMIN,LRESU, FORMR ,NIVE )
      ELSE IF (TYCH(1:2).EQ.'EL'.AND.NBMAT.GE.0) THEN
         CALL IRCHML(CH19,PARTIE,IFI,FORM,TITRE,TYCH(1:4),NOMSD,
     &      NOMSYM,NUMORD,LCOR,NBNOT,NUMNOE,NBMAT,NUMMAI,NBCMP,
     &      NOMCMP,LSUP,BORSUP,LINF,BORINF,LMAX,LMIN,LRESU, FORMR,
     &      NCMP,NUMCMP,NIVE )
      ENDIF
C
 9999 CONTINUE
C
      IF ( IERD.NE.0 ) THEN
         VALK(1) = CH19
         VALK(2) = FORM(1:7)
         CALL U2MESK('A','PREPOST_90', 2 ,VALK)
      ENDIF
C
      END
