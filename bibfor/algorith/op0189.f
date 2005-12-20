      SUBROUTINE OP0189 ( IER )
C
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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
C                   IMPR_FICO_HOMA
C
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER             IER
C
C 0.2. ==> COMMUNS
C 0.3. ==> VARIABLES LOCALES
C
      INTEGER NBOPT
      PARAMETER ( NBOPT = 40 )
C
      INTEGER TABENT(NBOPT), LGCAR(NBOPT)
C
      REAL*8 TABREE(NBOPT)
C
      CHARACTER*128 TABCAR(NBOPT)
C
C     ------------------------------------------------------------------
C
C     CONTENU DU TABLEAU DES ARGUMENTS ENTIERS TABENT :
C
C   1 : NUMERO D'UNITE LOGIQUE POUR LE FICHIER DE CONFIGURATION HOMARD
C   2 : MODE DE FONCTIONNEMENT DE HOMARD
C       1 : ADAPTATION COMPLETE     2 : INFORMATION
C       3 : INTERPOLATION DE SOLUTION
C   3 : NUMERO D'ITERATION DU MAILLAGE AVANT ADAPTATION
C   4 : TYPE DE RAFFINEMENT
C       0 : PAS DE RAFFINEMENT      1 : RAFFINEMENT LIBRE
C       2 : RAFFINEMENT UNIFORME
C   5 : TYPE DE DERAFFINEMENT
C       0 : PAS DE DERAFFINEMENT    1 : DERAFFINEMENT LIBRE
C       2 : DERAFFINEMENT UNIFORME
C   6 : TYPE DE CRITERE DE RAFFINEMENT
C       0 : PAS DE DONNEES          1 : EN ABSOLU
C       2 : EN RELATIF              3 : EN PROPORTION D'ELEMENTS
C   7 : TYPE DE CRITERE DE DERAFFINEMENT
C       0 : PAS DE DONNEES          1 : EN ABSOLU
C       2 : EN RELATIF              3 : EN PROPORTION D'ELEMENTS
C   8 : NOMBRE DE SOLUTIONS A INTERPOLER
C   9 : NOMBRE DE GROUPES DE MAILLES POUR LA FRONTIERE
C  10 : AUTORISATION DES ELEMENTS NON SIMPLEXES
C       0 : TOUS
C       1 : RAFFINEMENT SUR LES SIMPLEXES, MAIS AUTRES ACCEPTES
C       2 : AUTRES ELEMENTS REFUSES (DEFAUT)
C  11 : NIVEAU MAXIMUM DE RAFFINEMENT
C  12 : NIVEAU MINIMUM DE DERAFFINEMENT
C  15 : NUMERO DE PAS DE TEMPS DE L'INDICATEUR
C  16 : NUMERO D'ORDRE DE L'INDICATEUR
C  17 : PAS DES INSTANTS D'ADAPTATION
C  18 : MENAGE DU CONCEPT MAILLAGE DE L'ETAPE INITIALE
C       0 : PAS DE DESTRUCTION      1 : DESTRUCTION
C  19 : MENAGE DU CONCEPT SOLUTION DE L'ETAPE INITIALE
C       0 : PAS DE DESTRUCTION      1 : DESTRUCTION
C  28 : TYPE D'EXECUTABLE POUR HOMARD
C       0 : PUBLIC                  1 : PERSONNEL
C  29 : NUMERO D'UNITE LOGIQUE DU FICHIER DE MESSAGE
C  30 : NIVEAU D'INFO
C  31 : TYPE DE BILAN SUR LES NOMBRES DE NOEUDS ET ELEMENTS
C       0 : PAS DE BILAN            1 : BILAN
C  32 : TYPE DE BILAN SUR LA QUALITE DES ELEMENTS
C       0 : PAS DE BILAN            1 : BILAN
C  33 : TYPE DE BILAN SUR LA CONNEXITE DU DOMAINE
C       0 : PAS DE BILAN            1 : BILAN
C  34 : TYPE DE BILAN SUR LES TAILLES DES SOUS-DOMAINES
C       0 : PAS DE BILAN            1 : BILAN
C  35 : TYPE DE BILAN SUR L'INTERPENETRATION DES ELEMENTS
C       0 : PAS DE BILAN            1 : BILAN
C  40 : NUMERO D'UNITE LOGIQUE POUR LES DONNEES HOMARD
C
C     ------------------------------------------------------------------
C
C     CONTENU DU TABLEAU DES ARGUMENTS REELS TABREE :
C   1 : CRITERE DE RAFFINEMENT ABSOLU, RELATIF, PROPORTION D'ELEMENTS
C   2 : CRITERE DE DERAFFINEMENT ABSOLU, RELATIF, PROPORTION D'ELEMENTS
C
C     ------------------------------------------------------------------
C
C     CONTENU DU TABLEAU DES ARGUMENTS CARACTERES TABCAR :
C     ( LGCAR(I) EST EGAL A LA LONGUEUR DE LA CHAINE TABCAR(I) )
C     ATTENTION : IL FAUT RESPECTER LES POSITIONS DE 11 A 15 POUR LES
C                 FICHIERS MED, CAR CET ORDRE EST UTILISE DANS LE
C                 LANCEMENT DE LA PROCEDURE PAR ADDM04
C
C   1 : NOM DU FICHIER DE LISTE POUR HOMARD
C   2 : NOM DU CONCEPT MAILLAGE A L'ITERATION N
C   3 : NOM DU CONCEPT MAILLAGE A L'ITERATION N+1
C   4 : NOM DU CONCEPT RESULTAT A L'ITERATION N
C   5 : NOM DU CHAMP D'INDICATEUR D'ERREUR
C   6 : NOM DE LA COMPOSANTE DE L'INDICATEUR
C   7 : NOM DE L'OBJET JEVEUX K8 POUR LE NOM DES CHAMPS A METTRE A JOUR
C   8 : NOM DE L'OBJET JEVEUX I POUR LES NUMEROS D'ORDRE DES CHAMPS A
C       METTRE A JOUR
C  11 : NOM DU FICHIER MED A L'ITERATION N
C  12 : NOM DU FICHIER MED L'ITERATION N+1
C  19 : NOM DU FICHIER HOMARD DU MAILLAGE A L'ITERATION N
C  20 : NOM DU FICHIER HOMARD DU MAILLAGE A L'ITERATION N+1
C  21 : NOM DE L'OBJET MAILLAGE HOMARD A L'ITERATION N
C  22 : NOM DE L'OBJET MAILLAGE HOMARD A L'ITERATION N+1
C  26 : NOM DU TABLEAU K8 UTILE A LA CONVERSION
C  27 : NOM DU TABLEAU ENTIER UTILE A LA CONVERSION
C  28 : NOM DE LA VERSION DE HOMARD
C  30 : NOM DE LA PROCEDURE DE LANCEMENT DE HOMARD
C  31 : NOM DE L'OBJET MED DU MAILLAGE A L'ITERATION N
C  32 : NOM DE L'OBJET MED DU MAILLAGE A L'ITERATION N+1
C  33 : NOM DE L'OBJET MED DE L'INDICATEUR A L'ITERATION N
C  34 : NOM DE L'OBJET MED DU MAILLAGE DE LA FRONTIERE
C  38 : LANGUE DES MESSAGES HOMARD
C  39 : NOM DE L'OBJET JEVEUX K8 POUR LES GROUPES DE MAILLE DE
C       LA FRONTIERE
C
C DEB ------------------------------------------------------------------
C====
C 1. PREALABLES
C====
C
      IER = 0
      CALL JEMARQ()
      CALL INFMAJ
C
C====
C 2. DECODAGE DE L'ECRITURE DU FICHIER DE CONFIGURATION POUR HOMARD
C====
C
      CALL ADHC00 ( NBOPT, TABENT, TABREE, TABCAR, LGCAR )
C
C====
C 3. ECRITURE DU FICHIER DE CONFIGURATION POUR HOMARD
C====
C
      CALL ADHC01 ( NBOPT, TABENT, TABREE, TABCAR, LGCAR )
C
C====
C 4. ECRITURE DU FICHIER DE DONNEES POUR HOMARD
C====
C
      CALL ADHC02 ( NBOPT, TABENT, TABREE, TABCAR, LGCAR )
C
C====
C 5. LA FIN
C====
C
      CALL JEDEMA()
C FIN ------------------------------------------------------------------
      END
