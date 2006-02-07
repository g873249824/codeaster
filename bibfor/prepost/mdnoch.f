      SUBROUTINE MDNOCH ( NOCHMD, LNOCHM,
     >                    LRESU, NORESU, NOMSYM, NOPASE, CODRET )
C_____________________________________________________________________
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 06/02/2006   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C_____________________________________________________________________
C        FORMAT MED : ELABORATION D'UN NOM DE CHAMP DANS LE FICHIER
C               - -                    --     --
C_____________________________________________________________________
C
C   LA REGLE EST LA SUIVANTE :
C
C     LE NOM EST LIMITE A 32 CARACTERES DANS MED. ON UTILISE ICI
C     EXACTEMENT 32 CARACTERES.
C       . POUR UN CHAMP ISSU D'UNE STRUCTURE DE RESULTAT :
C                 12345678901234567890123456789012
C                 AAAAAAAABBBBBBBBBBBBBBBBCCCCCCCC
C       AAAAAAAA : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER
C       BBBBBBBBBBBBBBBB : NOM SYMBOLIQUE DU CHAMP
C       CCCCCCCC : NOM D'UN PARAMETRE EVENTUEL
C       . POUR UN CHAMP DE GRANDEUR :
C                 12345678901234567890123456789012
C                 AAAAAAAA
C       AAAAAAAA : NOM DE LA GRANDEUR A IMPRIMER
C
C   REMARQUE :
C       LES EVENTUELS BLANCS SONT REMPLACES PAR DES '_'
C
C   EXEMPLE :
C     . CHAMP DE LA DERIVEE DU DEPLACEMENT DU RESULTAT 'RESU1' PAR
C       RAPPORT AU PARAMETRE 'YOUNG1' :
C                 12345678901234567890123456789012
C       NOCHMD = 'RESU1___DEPL____________YOUNG1__'
C     . CHAMP DE GRANDEUR 'EXTRRESU' :
C                 12345678901234567890123456789012
C       NOCHMD = 'EXTRRESU________________________'
C
C     SORTIES :
C       NOCHMD : NOM DU CHAMP DANS LE FICHIER MED
C       LNOCHM : LONGUEUR UTILE DU NOM DU CHAMP DANS LE FICHIER MED
C       CODRET : CODE DE RETOUR DE L'OPERATION
C                0 --> TOUT VA BIEN
C                1 --> LA DECLARATION DU NOM DE L'OBJET NE CONVIENT PAS
C               10 --> AUTRE PROBLEME
C    ENTREES :
C       LRESU  : .TRUE. : INDIQUE IMPRESSION D'UN CONCEPT RESULTAT
C                .FALSE. : IMPRESSION D'UN CHAMP GRANDEUR
C       NORESU : NOM DU RESULTAT D'OU PROVIENT LE CHAMP A IMPRIMER
C       NOMSYM : NOM SYMBOLIQUE DU CHAMP, SI RESULTAT
C                CHAINE BLANCHE SI GRANDEUR
C       NOPASE : NOM DE L'EVENTUEL PARAMETRE COMPLEMENTAIRE
C_____________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*32 NOCHMD
      CHARACTER*16 NOMSYM
      CHARACTER*8  NOPASE,NORESU
C
      LOGICAL LRESU
C
      INTEGER LNOCHM
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'MDNOCH' )
C
      INTEGER LXLGUT
C
      INTEGER IAUX
C
C====
C 1. PREALABLES
C====
C
      CODRET = 0
C
C====
C 2. CREATION DU NOM
C====
C
      IF ( CODRET.EQ.0 ) THEN
C
C 2.1. ==> BLANCHIMENT INITIAL
C               12345678901234567890123456789012
      NOCHMD = '                                '
C
C 2.2. ==> NOM DU RESULTAT
C
      IAUX = LXLGUT(NORESU)
      IF ( IAUX.GE.1 .AND. IAUX.LE.8 ) THEN
        NOCHMD(1:IAUX) = NORESU(1:IAUX)
      ELSE
        CODRET = 1
        CALL UTMESS
     >  ( 'E', NOMPRO, 'MAUVAISE DEFINITION DE NORESU.' )
      ENDIF
C
C 2.3. ==> NOM SYMBOLIQUE DU CHAMP
C
      IF ( LRESU ) THEN
C
        IAUX = LXLGUT(NOMSYM)
        IF ( IAUX.GE.1 .AND. IAUX.LE.16 ) THEN
          NOCHMD(9:8+IAUX) = NOMSYM(1:IAUX)
        ELSE
          CODRET = 1
          CALL UTMESS
     >    ( 'E', NOMPRO, 'MAUVAISE DEFINITION DE NOMSYM.' )
        ENDIF
C
      ENDIF
C
C 2.4. ==> NOM DU PARAMETRE COMPLEMENTAIRE
C
      IAUX = LXLGUT(NOPASE)
      IF ( IAUX.NE.0 ) THEN
        IF ( IAUX.GE.1 .AND. IAUX.LE.8 ) THEN
          NOCHMD(25:24+IAUX) = NOPASE(1:IAUX)
        ELSE
          CODRET = 1
          CALL UTMESS
     >    ( 'E', NOMPRO, 'MAUVAISE DEFINITION DE NOPASE.' )
        ENDIF
      ENDIF
C
C 2.5. ==> REMPLACEMENT DES BLANCS PAR DES _
C
      DO 25 , IAUX = 1 , 32
        IF ( NOCHMD(IAUX:IAUX).EQ.' ' ) THEN
          NOCHMD(IAUX:IAUX) = '_'
        ENDIF
   25 CONTINUE
C
C 2.6. ==> LONGUEUR UTILE (EN FAIT, TOUT EST UTILE PUISQU'ON A REMPLACE
C          LES BLANCS PAR DES _ !)
C
      LNOCHM = 32
C
      ENDIF
C
C====
C 3. BILAN
C====
C
      IF ( CODRET.NE.0 ) THEN
         CALL UTMESS
     > ( 'F' , NOMPRO, 'IMPOSSIBLE DE DETERMINER UN NOM DE CHAMP MED.' )
      ENDIF
C
      END
