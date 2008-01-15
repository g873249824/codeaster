      SUBROUTINE VESECN ( NOMCMD, OPTION, NOPASE, TYPESE, CODRET )
C
C     VERIFICATION DE LA SENSIBILITE POUR CALC_NO
C     **                 **               *    *
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 14/01/2008   AUTEUR DEBONNIERES P.DE-BONNIERES 
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
C ----------------------------------------------------------------------
C IN  NOMCMD : NOM DE LA COMMANDE
C IN  OPTION : NOM DE L'OPTION A CONTROLER
C IN  NOPASE : NOM DU PARAMETRE SENSIBLE
C IN  TYPESE : TYPE DE SENSIBILITE
C               -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C                0 : CALCUL STANDARD
C                1 : CALCUL INSENSIBLE
C                2 : DEPLACEMENT IMPOSE
C                3 : PARAMETRE MATERIAU
C                4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C               EN THERMIQUE (CF NTTYSE) :
C                5 : SOURCE
C                6 : FLUX IMPOSE
C                7 : TEMPERATURE EXTERIEURE
C                8 : COEFFICIENT D'ECHANGE
C               EN MECANIQUE (CF METYSE) :
C
C OUT CODRET : CODRET DE RETOUR (O, TOUT VA BIEN)
C                0 : TOUT VA BIEN
C                1 : CALCUL DERIVE NON DISPONIBLE POUR CETTE OPTION
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER TYPESE, CODRET
C
      CHARACTER*8 NOPASE
      CHARACTER*16 OPTION, NOMCMD
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'VESECN' )
C
C====
C 1. ON PASSE EN REVUE TOUTES LES OPTIONS
C====
C
      CODRET = 0
C
      IF ( OPTION(6:9) .EQ. 'NOEU') THEN
C
        CODRET = 0
C
C    ------------------------------------------------------------------
      ELSEIF ( OPTION.EQ.'FORC_NODA' .OR. OPTION.EQ.'REAC_NODA' ) THEN
C
        CODRET = 1
        IF ((TYPESE.EQ.0).OR.(TYPESE.EQ.2)) THEN
          CODRET = 0
        ENDIF
        IF ((TYPESE.EQ.3).OR.(TYPESE.EQ.5)) THEN
          CODRET = 0
        ENDIF

C
C    ------------------------------------------------------------------
      ELSE
        CALL U2MESK('A','CALCULEL5_37',1,NOMPRO)
        CALL U2MESK('F','CALCULEL3_22',1,OPTION)
      ENDIF
C
C====
C 2. LES ERREURS
C====
C
      IF ( CODRET.NE.0 ) THEN
C
      CALL U2MESK('A','CALCULEL3_23',1,OPTION)
      IF ( NOPASE.NE.' ' ) THEN
        CALL U2MESK('A','SENSIBILITE_71',1,NOPASE)
      ENDIF
C
      IF ( CODRET.EQ.1 ) THEN
C
        CALL U2MESS('A','CALCULEL3_25')
C
      ENDIF
C
      ENDIF
C
      END
