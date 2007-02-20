      SUBROUTINE METYSE ( NBPASE, INPSCO, NOPASE, TYPESE, STYPSE )
C
C     MECANIQUE  - TYPE DE SENSIBILITE
C     **            **      **
C     COMMANDE:  MECA_STATIQUE & STAT_NON_LINE
C
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C ----------------------------------------------------------------------
C IN  NBPASE  : NOMBRE DE PARAMETRES SENSIBLES
C IN  INPSCO  : STRUCTURE CONTENANT LA LISTE DES NOMS
C               VOIR LA DEFINITION DANS SEGICO
C IN  NOPASE  : NOM DU PARAMETRE SENSIBLE
C OUT TYPESE  : TYPE DE SENSIBILITE
C               -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C                1 : CALCUL INSENSIBLE
C                2 : DEPLACEMENT IMPOSE
C                3 : PARAMETRE MATERIAU
C                4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C                5 : FORCE
C OUT STYPSE  : SOUS-TYPE DE SENSIBILITE DANS LES CAS SUIVANTS :
C               . PARAMETRE MATERIAU
C ----------------------------------------------------------------------
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBPASE, TYPESE
C
      CHARACTER*(*) NOPASE, INPSCO
      CHARACTER*24 STYPSE
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'METYSE' )
C
      INTEGER NBMCRF, NBMCMX
      PARAMETER ( NBMCRF = 19, NBMCMX = 19 )
C
      INTEGER NBMOSI
      INTEGER NBMC(NBMCRF), NBMCSR
      CHARACTER*24 LIMOSI, LIVALE, LIMOFA
      CHARACTER*24 BLAN24
      CHARACTER*24 TYPEPS
      CHARACTER*24 COREFE(NBMCRF), MCSREF(NBMCMX)
      CHARACTER*24 VALK(2)
C
C                    123456789012345678901234
      DATA BLAN24 / '                        ' /
C
C====
C 1. RECHERCHE DU TYPE GENERIQUE
C    PSTYSE RETOURNE LES INFORMATIONS SUIVANTES :
C      TYPESE : ENTIER, TYPE GENERIQUE DE LA SENSIBILITE :
C               -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C                1 : CALCUL INSENSIBLE
C                2 : CONDITION AUX LIMITES DE DIRICHLET
C                3 : PARAMETRE MATERIAU
C                4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C                0 : AUTRE TYPE, DEPENDANT DE LA COMMANDE
C      TYPEPS : K24, TYPE PRECIS DE LA SENSIBILITE ('FORCE', ... )
C      NBMOSI : NOMBRE DE MOTS-CLES OU INTERVIENT LE PARAMETRE NOPASE
C      LIMOSI : LISTE DE CES MOTS-CLES SIMPLES
C      LIVALE : LISTE DES VALEURS ASSOCIEES
C      LIMOSI : LISTE DES MOTS-CLES FACTEURS ASSOCIES
C====
C                12   345678   9012345678901234
      LIMOSI  = '&&'//NOMPRO//'_LIMOSI         '
      LIVALE  = '&&'//NOMPRO//'_LIVALE         '
      LIMOFA  = '&&'//NOMPRO//'_LIMOFA         '
C
      CALL PSTYSE ( NBPASE, INPSCO, NOPASE,
     >              TYPESE, TYPEPS, NBMOSI, LIMOSI, LIVALE, LIMOFA )
C
CGN      CALL UTDEBM ( 'I', NOMPRO, 'SENSIBILITE DEMANDEE' )
CGN      CALL UTIMPK ( 'S', ' PAR RAPPORT AU CONCEPT :', 1, NOPASE )
CGN      CALL UTIMPK ( 'L', 'APRES PSTYSE, TYPE : ', 1,TYPEPS )
CGN      CALL UTIMPI ( 'L', '. CODE : ', 1,TYPESE )
CGN      CALL UTIMPI ( 'L', '. NOMBRE DE MOTS-CLES : ', 1,NBMOSI )
CGN      CALL UTFINM ()
C
C====
C 2. PRECISION DU TYPE DE SENSIBILITE
C====
C
      STYPSE = BLAN24
C
      IF ( TYPESE.EQ.3 ) THEN
C
        COREFE(1) = 'E'
        NBMC(1) = 1
        MCSREF(1) = 'E'
C
        COREFE(2) = 'E_L'
        NBMC(2) = 1
        MCSREF(2) = 'E_L'
C
        COREFE(3) = 'E_T'
        NBMC(3) = 1
        MCSREF(3) = 'E_T'
C
        COREFE(4) = 'E_N'
        NBMC(4) = 1
        MCSREF(4) = 'E_N'
C
        COREFE(5) = 'NU'
        NBMC(5) = 1
        MCSREF(5) = 'NU'
C
        COREFE(6) = 'NU_LT'
        NBMC(6) = 1
        MCSREF(6) = 'NU_LT'
C
        COREFE(7) = 'NU_LN'
        NBMC(7) = 1
        MCSREF(7) = 'NU_LN'
C
        COREFE(8) = 'NU_TN'
        NBMC(8) = 1
        MCSREF(8) = 'NU_TN'
C
        COREFE(9) = 'G_LT'
        NBMC(9) = 1
        MCSREF(9) = 'G_LT'
C
        COREFE(10) = 'G_LN'
        NBMC(10) = 1
        MCSREF(10) = 'G_LN'
C
        COREFE(11) = 'G_TN'
        NBMC(11) = 1
        MCSREF(11) = 'G_TN'
C
        COREFE(12) = 'DSDE'
        NBMC(12) = 1
        MCSREF(12) = 'D_SIGM_EPSI'

        COREFE(13) = 'SIGY'
        NBMC(13) = 1
        MCSREF(13) = 'SY'
C
        COREFE(14) = 'ALPHA'
        NBMC(14) = 1
        MCSREF(14) = 'ALPHA'

        COREFE(15) = 'SY_ULTM'
        NBMC(15) = 1
        MCSREF(15) = 'SY_ULTM'
C
        COREFE(16) = 'P_ULTM'
        NBMC(16) = 1
        MCSREF(16) = 'P_ULTM'

        COREFE(17) = 'H'
        NBMC(17) = 1
        MCSREF(17) = 'H'
C
        COREFE(18) = 'A_PUIS'
        NBMC(18) = 1
        MCSREF(18) = 'A_PUIS'
C
        COREFE(19) = 'N_PUIS'
        NBMC(19) = 1
        MCSREF(19) = 'N_PUIS'
C
        NBMCSR = 19
C
        CALL PSTYSS ( NBMCSR, NBMC, COREFE, MCSREF,
     >                NBMOSI, LIVALE, NOPASE,
     >                STYPSE )
C
      ELSEIF ( TYPESE.EQ.0 ) THEN
C
        IF ( TYPEPS.EQ.'FORCE   ' ) THEN
          TYPESE = 5
        ELSE
C
          VALK (1) = NOPASE
          VALK (2) = TYPEPS
          CALL U2MESG('A', 'UTILITAI6_45',2,VALK,0,0,0,0.D0)
          CALL U2MESS('F','ALGORITH3_39')
C
        ENDIF
C
      ENDIF
C
C
C====
C 3. MENAGE
C====
C
      CALL JEDETR ( LIMOSI )
      CALL JEDETR ( LIVALE )
      CALL JEDETR ( LIMOFA )
C
      END
