      SUBROUTINE NMLECT (RESULT, MODELE, MATE  , CARELE, COMPOR,
     &                   LISCHA, METHOD, SOLVEU, PARMET, PARCRI,
     &                   CARCRI, MODEDE, SOLVDE, NBPASE, BASENO,
     &                   INPSCO, PARCON )

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/04/2005   AUTEUR PBADEL P.BADEL 
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
C RESPONSABLE PBADEL P.BADEL
C
      IMPLICIT NONE
      INTEGER      NBPASE
C
      REAL*8       PARMET(*), PARCRI(*), PARCON(*)
C
      CHARACTER*8  MODEDE, RESULT,K8B, BLAN8
      CHARACTER*8 BASENO
      CHARACTER*16 METHOD(6)
      CHARACTER*19 LISCHA, SOLVEU, SOLVDE
      CHARACTER*24 MODELE, MATE, CARELE, COMPOR
      CHARACTER*24 CARCRI
      CHARACTER*(*) INPSCO
C
C ----------------------------------------------------------------------
C
C COMMANDES MECA_STATIQUE & STAT_NON_LINE : LECTURE DES OPERANDES
C
C ----------------------------------------------------------------------
C
C      OUT RESULT : NOM UTILISATEUR DU RESULTAT DE STAT_NON_LINE
C      OUT MODELE : NOM DU MODELE
C      OUT MATE   : NOM DU CHAMP DE MATERIAU
C      OUT CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C      OUT COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C      OUT LISCHA : SD L_CHARGES
C      OUT METHOD : DESCRIPTION DE LA METHODE DE RESOLUTION
C                     1 : NOM DE LA METHODE NON LINEAIRE : NEWTON
C                     2 : TYPE DE MATRICE (TANGENTE OU ELASTIQUE)
C                     3 : (DECHARGE OU RIEN)       --> PAS UTILISE
C                     4 : (NON , BGFGS OU BROYDEN) --> PAS UTILISE
C                     5 : METHODE D'INITIALISATION
C                     6 : NOM CONCEPT EVOL_NOLI SI PREDI. 'DEPL_CALCULE'
C      OUT SOLVEU : NOM DU SOLVEUR
C      OUT PARMET : PARAMETRES DE LA METHODE DE RESOLUTION
C                     1 : REAC_INCR
C                     2 : REAC_ITER
C                     3 : PAS_MINI_ELAS
C                     4 : REAC_ITER_ELAS
C                    10 : ITER_LINE_MAXI
C                    11 : RESI_LINE_RELA
C                    20 : RHO (LAGRANGIEN)
C                    21 : ITER_GLOB_MAXI (LAGRANGIEN)
C                    22 : ITER_INTE_MAXI (LAGRANGIEN)
C                    30 : THETA (INTEGRATION PAR THETA METHODE)
C      OUT PARCRI : PARAMETRES DES CRITERES DE CONVERGENCE
C                     1 : ITER_GLOB_MAXI
C                     2 : RESI_GLOB_RELA
C                     3 : RESI_GLOB_MAXI
C                     4 : ARRET (0=OUI, 1=NON)
C                     5 : ITER_GLOB_ELAS
C                     6 : RESI_REFE_RELA
C                    10 : INCO_GLOB_ABSO (LAGRANGIEN)
C                    11 : DIFF_GLOB_ABSO (LAGRANGIEN)
C                    
C IN/JXOUT CARCRI : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C                     0 : ITER_INTE_MAXI
C                     1 : TYPE_MATR_COMP (0: VIT, 1: INC)
C                     2 : RESI_INTE_RELA
C                     3 : THETA (POUR THM)
C                     4 : ITER_INTE_PAS
C                     5 : RESO_INTE (0: EULER_1, 1: RK_2, 2: RK_4)
C      OUT MODEDE : NOM DU MODELE POUR LES ELEMENTS NON LOCAUX OU ' '
C      OUT SOLVDE : PARAMETRE DU SOLVEUR POUR LOIS NON LOCALES
C      OUT NBPASE : NOMBRE DE PARAMETRES SENSIBLES
C      IN  BASENO : BASE DU NOM DES STRUCTURES DERIVEES
C      OUT INPSCO : SD CONTENANT LA LISTE DES NOMS POUR LA SENSIBILITE
C      OUT PARCON : PARAMETRES DU CRITERE DE CONVERGENCE EN CONTRAINTE
C                   SI PARCRI(6)=RESI_CONT_RELA != R8VIDE()
C                     1 : SIGM_REFE
C                     2 : EPSI_REFE
C                     3 : FLUX_THER_REFE
C                     4 : FLUX_HYD1_REFE
C                     5 : FLUX_HYD2_REFE
C ----------------------------------------------------------------------
      LOGICAL EXI
      INTEGER IBID, IAUX, IRET
      CHARACTER*5  SUFFIX
      CHARACTER*16 K16BID, NOMCMD
C ----------------------------------------------------------------------
C
C               1234567890123456789
      BLAN8  = '        '
C
C -- NOM UTILISATEUR DU CONCEPT RESULTAT CREE PAR LA COMMANDE
C
      CALL GETRES (RESULT,K16BID,NOMCMD)
C
C -- SENSIBILITE : LECTURE DES NOMS DES PARAMETRES
C
      IAUX = 1
      CALL PSLECT ( ' ', IBID, BASENO, RESULT, IAUX,
     >                NBPASE, INPSCO, IRET )
C
C -- DONNEES MECANIQUES
C
      MODELE = ' '
      CALL NMDOME ( MODELE, MATE, CARELE, LISCHA,
     >              NBPASE, INPSCO ,BLAN8,IBID)
C
C -- PARAMETRES DONNES APRES LE MOT-CLE FACTEUR SOLVEUR
C
      SUFFIX = '     '
      CALL CRESOL (SOLVEU,SUFFIX)
C
      IF ( NOMCMD(1:13).NE.'MECA_STATIQUE' ) THEN
C
C -- RELATION DE COMPORTEMENT

        CALL NMDORC (MODELE, COMPOR)
C
C -- CRITERES DE CONVERGENCE
C
        CALL NMDOCN (MODELE, PARCRI, CARCRI, PARCON)
C
C -- NOM ET PARAMETRES DE LA METHODE DE RESOLUTION
C
        CALL NMDOMT (METHOD, PARMET)
        CALL GETVR8 (' ','PARM_THETA',0,1,1,PARMET(30),IRET)


C -- ARGUMENTS DES LOIS NON LOCALES

        CALL DELECT (MODELE, EXI, SOLVDE, PARMET, PARCRI)
        IF (EXI) THEN
          MODEDE = MODELE(1:8)
        ELSE
          MODEDE = '        '
        END IF


      ENDIF
C
      END
