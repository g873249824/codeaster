      SUBROUTINE SEGICO ( CHOIX,
     &                    BASENO, NBPASE, LIPASE, RESULT,
     &                    INPSCO, INFOEN, CODRET )
C
C     SENSIBILITE - GESTION DES INFORMATIONS POUR UNE COMMANDE
C     **            *           *                     **
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GNICOLAS G.NICOLAS
C ----------------------------------------------------------------------
C     GERE LA STRUCTURE QUI CONTIENDRA TOUTES LES
C     INFORMATIONS RELATIVES AUX PARAMETRES DE SENSIBILITES
C     CELA EST APPLICABLE AU COURS DU TRAITEMENT D'UNE COMMANDE
C     A PRIORI, CE PROGRAMME NE DOIT ETRE APPELE QUE PAR UN AUTRE PSXXXX
C ----------------------------------------------------------------------
C IN  CHOIX  : 1 : CREER LA STRUCTURE
C              2 : RECUPERER LE NOMBRE DE STRUCTURES ENREGISTREES
C              3 : RECUPERER L'ADRESSE DE LA STRUCTURE DE MEMORISATION
C . SI CHOIX = 1 :
C IN  BASENO  : BASE DU NOM DES STRUCTURES
C IN  NBPASE  : NOMBRE DE PARAMETRES SENSIBLES
C IN  LIPASE  : STRUCTURE CONTENANT LA LISTE DES NOMS DE CES PARAMETRES
C IN  RESULT  : NOM DU RESULTAT PRINCIPAL
C OUT INPSCO  : BASE DU NOM DE LA STRUCTURE QUI CONTIENT LA LISTE DES
C               INFORMATIONS SUR LES PARAMETRES SENSIBLES DE LA COMMANDE
C               **                   *          *               **
C               EN COURS. LE VRAI NOM EST SUFFIXE PAR '.MEMO'
C               SA TAILLE : (NOMBRE DE PARAMETRES SENSIBLES + 1) * 12
C               SON CONTENU, POUR LE CALCUL STANDARD, PUIS POUR CHAQUE
C               PARAMETRE SENSIBLE :
C                0. UN COMMENTAIRE
C                1. LE NOM DU PARAMETRE SENSIBLE (RIEN EN STANDARD)
C                2. LE NOM DE LA STRUCTURE POUR LE TYPE DE SENSIBILITE
C                3. LE NOM DU RESULTAT
C               DIVERS NOMS DE STRUCTURES DE TRAVAIL CONSTRUITS A PARTIR
C               DE LA BASE FOURNIE EN DONNEE, BASENO :
C                4. LA VARIABLE PRINCIPALE A L'INSTANT N
C                5. LA VARIABLE PRINCIPALE A L'INSTANT N-1
C                6. LA VARIABLE PRINCIPALE A L'INSTANT N+1
C                7. LA VARIABLE PRINCIPALE INITIALE
C                8. VARIABLE COMPLEMENTAIRE NUMERO 1 INSTANT N
C                9. VARIABLE COMPLEMENTAIRE NUMERO 1 INSTANT N-1
C               10. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N
C               11. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N-1
C               DIVERS NOMS DE STRUCTURES DE TRAVAIL CONSTRUITS AVEC
C               UN PREFIXE ARBITRAIRE :
C               12. VECTEUR DES CHARGES SOUS LE NOM "&&VECnnn    "
C               13. VECTEUR DES DIRICHLETS SOUS LE NOM "&&VEDnnn    "
C               DIVERS NOMS DE STRUCTURES DE TRAVAIL COMPLEMENTAIRES
C               14. VARIABLE COMPLEMENTAIRE NUMERO 3 INSTANT N
C               15. VARIABLE COMPLEMENTAIRE NUMERO 3 INSTANT N-1
C               16. VARIABLE COMPLEMENTAIRE NUMERO 4 INSTANT N
C               17. VARIABLE COMPLEMENTAIRE NUMERO 4 INSTANT N-1
C               18. VARIABLE COMPLEMENTAIRE NUMERO 5 INSTANT N
C               19. VARIABLE COMPLEMENTAIRE NUMERO 5 INSTANT N-1
C . SI CHOIX = 2 :
C OUT INFOEN   : NOMBRE D'INFORMATIONS ENREGISTREES
C . SI CHOIX = 3 :
C OUT INFOEN   : ADRESSE DE LA TABLE DE MEMORISATION
C
C OUT CODRET  : CODE DE RETOUR, 0 SI TOUT VA BIEN
C               1 : ON N'A PAS TROUVE LA DERIVEE
C
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER CHOIX, NBPASE, INFOEN
      INTEGER CODRET
C
      CHARACTER*8 BASENO
      CHARACTER*(*) RESULT, LIPASE
      CHARACTER*(*) INPSCO
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'SEGICO' )
C
      INTEGER NBPSCX
      PARAMETER ( NBPSCX = 23 )
C
      INTEGER LXLGUT
C
      INTEGER ADPSCO, ADPASE, NRPASE
      INTEGER LGNORE, LGNOMP
      INTEGER IAUX, JAUX, IRET
C
      CHARACTER*3 SAUX03
      CHARACTER*8 SAUX08, NOPASE
      CHARACTER*24 NOMSTR
      CHARACTER*24 SAUX24, BLAN24
C
C                    123456789012345678901234
      DATA BLAN24 / '                        ' /
C
C====
C 0. PREALABLE
C====
C
      IAUX = LXLGUT(INPSCO)
      NOMSTR = BLAN24
      NOMSTR(1:IAUX+5) = INPSCO(1:IAUX)//'.MEMO'
C
      CODRET = 0
C
C====
C 1. INITIALISATION
C====
C
      IF ( CHOIX.EQ.1 ) THEN
C
C 1.1. ==> ALLOCATION DE LA STRUCTURE
C
      IAUX = (NBPASE+1)*(NBPSCX+1)
      CALL WKVECT ( NOMSTR, 'V V K24', IAUX, ADPSCO )
C
C 1.2. ==> SI IL Y A DES PARAMETRES SENSIBLES, RECUPERATION DE L'ADRESSE
C          DU STOCKAGE DES NOMS DE CES PARAMETRES
C
      IF ( NBPASE.NE.0 ) THEN
        CALL JEVEUO ( LIPASE, 'L', ADPASE )
      ENDIF
C
C 1.3. ==> LONGUEUR DU NOM DU RESULTAT PRINCIPAL
C
      LGNORE = LXLGUT(RESULT)
C
C 1.4. ==> ARCHIVAGE DES NOMS
C          ON NE MEMORISE QUE LES CARACTERES UTILES
C          ON COMPLETE A DROITE AVEC DES BLANCS
C
      DO 14 , NRPASE = 0 , NBPASE
C
        IAUX = ADPSCO + (NBPSCX+1)*NRPASE
C
C 1.4.00. ==> CHAINE AUXILAIRE
C
        IF ( NRPASE.EQ.0 ) THEN
          SAUX03 = '   '
        ELSE
          CALL CODENT ( NRPASE,'D0',SAUX03 )
        ENDIF
C
C 1.4.0. ===> 0. COMMENTAIRE SUR LE CAS
C
        IF ( NRPASE.EQ.0 ) THEN
          ZK24(IAUX) = 'CALCUL PRINCIPAL        '
        ELSE
C                       123456789012345678901234
          ZK24(IAUX) = 'DERIVEE NUMERO       '//SAUX03
        ENDIF
C
C 1.4.1. ==> 1. LE NOM DU PARAMETRE SENSIBLE, LE CAS ECHEANT
C
        ZK24(IAUX+1) = BLAN24
        IF ( NRPASE.GT.0 ) THEN
          NOPASE = ZK8(ADPASE+NRPASE-1)
          LGNOMP = LXLGUT(NOPASE)
          ZK24(IAUX+1)(1:LGNOMP) = NOPASE(1:LGNOMP)
        ENDIF
C
C 1.4.2. ==> 2. LE TYPE DE SENSIBILITE. IL SERA DEFINI PLUS TARD, AU
C            COURS DU DECODAGE DES CHARGEMENTS DU CAS
C
        ZK24(IAUX+2) = BLAN24
C
C 1.4.3. ==> 3. LE NOM DU RESULTAT
C
        IF ( NRPASE.EQ.0 ) THEN
          SAUX08(1:LGNORE) = RESULT(1:LGNORE)
          JAUX = LGNORE
        ELSE
          CALL PSRENC ( RESULT(1:LGNORE), NOPASE(1:LGNOMP),
     &                  SAUX08, IRET )
          IF ( IRET.NE.0 ) THEN
            SAUX24 = BLAN24
            SAUX24(1:LGNORE) = RESULT(1:LGNORE)
            CALL UTDEBM ( 'A', NOMPRO, 'CODE RETOUR DE PSRENC' )
            CALL UTIMPI ( 'S', ' : ', 1, IRET )
            CALL UTIMPK ( 'L', 'LA DERIVEE DE : ', 1, SAUX24 )
            CALL UTIMPK ( 'L', 'PAR RAPPORT A : ', 1, NOPASE )
            CALL UTIMPK ( 'L', 'EST INTROUVABLE.', 0, SAUX08 )
            CALL UTFINM
            CODRET = 1
          ENDIF
          JAUX = LXLGUT(SAUX08)
        ENDIF
        ZK24(IAUX+3) = BLAN24
        ZK24(IAUX+3)(1:JAUX) = SAUX08(1:JAUX)
C
C 1.4.4. ==> DIVERS NOMS DE STRUCTURES DE TRAVAIL
C            CES NOMS SONT CONSTRUITS AVEC LA BASE FOURNIE EN DONNEE
C                4. LA VARIABLE PRINCIPALE A L'INSTANT N
C                5. LA VARIABLE PRINCIPALE A L'INSTANT N-1
C                6. LA VARIABLE PRINCIPALE A L'INSTANT N+1
C                7. LA VARIABLE PRINCIPALE INITIALE
C                8. VARIABLE COMPLEMENTAIRE NUMERO 1 INSTANT N
C                9. VARIABLE COMPLEMENTAIRE NUMERO 1 INSTANT N-1
C               10. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N
C               11. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N-1
C
C                       12345678   90123456   789      01234
        ZK24(IAUX+4)  = BASENO  //'VAR_____'//SAUX03//'     '
        ZK24(IAUX+5)  = BASENO  //'VAR_T_MO'//SAUX03//'     '
        ZK24(IAUX+6)  = BASENO  //'VAR_T_PL'//SAUX03//'     '
        ZK24(IAUX+7)  = BASENO  //'VAR_INIT'//SAUX03//'     '
        ZK24(IAUX+8)  = BASENO  //'VAR_C1_P'//SAUX03//'     '
        ZK24(IAUX+9)  = BASENO  //'VAR_C1_M'//SAUX03//'     '
        ZK24(IAUX+10) = BASENO  //'VAR_C2_P'//SAUX03//'     '
        ZK24(IAUX+11) = BASENO  //'VAR_C2_M'//SAUX03//'     '
CGN        PRINT *,'ZK24(IAUX)    = ',ZK24(IAUX)
CGN        PRINT *,'ZK24(IAUX+1)  = ',ZK24(IAUX+1)
CGN        PRINT *,'ZK24(IAUX+2)  = ',ZK24(IAUX+2)
CGN        PRINT *,'ZK24(IAUX+3)  = ',ZK24(IAUX+3)
CGN        PRINT *,'ZK24(IAUX+4)  = ',ZK24(IAUX+4)
CGN        PRINT *,'ZK24(IAUX+5)  = ',ZK24(IAUX+5)
CGN        PRINT *,'ZK24(IAUX+6)  = ',ZK24(IAUX+6)
CGN        PRINT *,'ZK24(IAUX+7)  = ',ZK24(IAUX+7)
CGN        PRINT *,'ZK24(IAUX+8)  = ',ZK24(IAUX+8)
CGN        PRINT *,'ZK24(IAUX+9)  = ',ZK24(IAUX+9)
CGN        PRINT *,'ZK24(IAUX+10) = ',ZK24(IAUX+10)
CGN        PRINT *,'ZK24(IAUX+11) = ',ZK24(IAUX+11)
C
C 1.4.5. ==> DIVERS NOMS DE STRUCTURES DE TRAVAIL
C            CES NOMS SONT CONSTRUITS AVEC UN PREFIXE ARBITRAIRE
C               12. VECTEUR DES CHARGES SOUS LE NOM "&&VECnnn    "
C               13. VECTEUR DES DIRICHLETS SOUS LE NOM "&&VEDnnn    "
C
C                        12345   678      9012345678901234
        ZK24(IAUX+12) = '&&VEC'//SAUX03//'                '
        ZK24(IAUX+13) = '&&VED'//SAUX03//'                '
CGN        PRINT *,'ZK24(IAUX+12) = ',ZK24(IAUX+12)
CGN        PRINT *,'ZK24(IAUX+13) = ',ZK24(IAUX+13)
CGN        PRINT *,' '
C
C 1.4.4. ==> NOMS DE STRUCTURES DE TRAVAIL COMPLEMENTAIRES
C            NECESSAIRES POUR LA DYNAMIQUE
C               14. VARIABLE COMPLEMENTAIRE NUMERO 3 INSTANT N
C               15. VARIABLE COMPLEMENTAIRE NUMERO 3 INSTANT N-1
C               16. VARIABLE COMPLEMENTAIRE NUMERO 4 INSTANT N
C               17. VARIABLE COMPLEMENTAIRE NUMERO 4 INSTANT N-1
C               18. VARIABLE COMPLEMENTAIRE NUMERO 5 INSTANT N
C               19. VARIABLE COMPLEMENTAIRE NUMERO 5 INSTANT N-1
C               20. VARIABLE COMPLEMENTAIRE NUMERO 6 INSTANT N
C               21. VARIABLE COMPLEMENTAIRE NUMERO 6 INSTANT N-1
C               22. VARIABLE COMPLEMENTAIRE NUMERO 7 INSTANT N
C               23. VARIABLE COMPLEMENTAIRE NUMERO 7 INSTANT N-1
        ZK24(IAUX+14) = BASENO  //'VAR_C3_P'//SAUX03//'     '
        ZK24(IAUX+15) = BASENO  //'VAR_C3_M'//SAUX03//'     '
        ZK24(IAUX+16) = BASENO  //'VAR_C4_P'//SAUX03//'     '
        ZK24(IAUX+17) = BASENO  //'VAR_C4_M'//SAUX03//'     '
        ZK24(IAUX+18) = BASENO  //'VAR_C5_P'//SAUX03//'     '
        ZK24(IAUX+19) = BASENO  //'VAR_C5_M'//SAUX03//'     '
        ZK24(IAUX+20) = BASENO  //'VAR_C6_P'//SAUX03//'     '
        ZK24(IAUX+21) = BASENO  //'VAR_C6_M'//SAUX03//'     '
        ZK24(IAUX+22) = BASENO  //'VAR_C7_P'//SAUX03//'     '
        ZK24(IAUX+23) = BASENO  //'VAR_C7_M'//SAUX03//'     '
C
C
   14 CONTINUE
C
C====
C 2. RECUPERATION DU NOMBRE D'INFORMATIONS ENREGISTREES
C====
C
      ELSEIF ( CHOIX.EQ.2 ) THEN
C
        INFOEN = NBPSCX
C
C====
C 3. RECUPERATION DE L'ADRESSE DE LA STRUCTURE DE MEMORISATION
C====
C
      ELSEIF ( CHOIX.EQ.3 ) THEN
C
        CALL JEVEUO ( NOMSTR, 'L', INFOEN )
C
C====
C 4. MAUVAIS CHOIX
C====
C
      ELSE
C
        CALL UTDEBM ( 'A', NOMPRO, 'MAUVAISE VALEUR POUR CHOIX' )
        CALL UTIMPI ( 'L', 'IL FAUT 1,2 OU 3, MAIS PAS ', 1, CHOIX )
        CALL UTFINM
        CALL U2MESS('F','MODELISA_67')
C
      ENDIF
C
      END
