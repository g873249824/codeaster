      SUBROUTINE NMFINT(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,CARCRI,FONACT,ITERAT,
     &                  SDDYNA,DEFICO,VALMOI,VALPLU,POUGD ,
     &                  SOLALG,VEASSE,LDCCVG,CODERE,VEFINT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE     
      INTEGER       LDCCVG
      INTEGER       ITERAT
      LOGICAL       FONACT(*)
      CHARACTER*19  LISCHA,SDDYNA
      CHARACTER*24  MODELE,NUMEDD,MATE  ,CODERE  
      CHARACTER*24  CARELE,COMPOR,COMREF,CARCRI
      CHARACTER*24  VALMOI(8),POUGD(8),VALPLU(8)
      CHARACTER*19  SOLALG(*),VEASSE(*)
      CHARACTER*24  DEFICO
      CHARACTER*19  VEFINT
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C INTEGRATION DE LA LOI DE COMPORTEMENT
C CALCUL DES FORCES INTERIEURES 
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NOM DE LA NUMEROTATION
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VALEURS DE REF DES VARIABLES DE COMMANDE
C IN  COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C IN  LISCHA : SD L_CHARGES
C IN  DEFICO : SD DEFINITION CONTACT
C IN  CARCRI : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  ITERAT : NUMERO DE L'ITERATION DE NEWTON
C IN  SDDYNA : SD DYNAMIQUE
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C OUT VEFINT : VECT_ELEM DES FORCES INTERNES
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                0 : CAS DE FONCTIONNEMENT NORMAL
C                1 : ECHEC DE L'INTEGRATION DE LA LDC
C                3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      TABRET(0:10)
      INTEGER      ITER
      INTEGER      IFM,NIV
      CHARACTER*1  BASE    
      CHARACTER*16 OPTION
      CHARACTER*19 K19BLA
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV) 
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CALCUL DES FORCES INTERNES'
      ENDIF       
C
C --- INITIALISATIONS
C
      ITER   = ITERAT+1   
      BASE   = 'V' 
      K19BLA = ' '
      OPTION = 'RAPH_MECA'
      CODERE = '&&OP0070.CODERE'
C
C --- CALCUL DES FORCES INTERIEURES
C
      CALL MERIMO(BASE  ,MODELE,CARELE,MATE  ,COMREF,
     &            COMPOR,LISCHA,CARCRI,ITER  ,FONACT,
     &            SDDYNA,VALMOI,VALPLU,POUGD ,SOLALG,
     &            K19BLA,VEFINT,OPTION,TABRET,CODERE)
      LDCCVG = 0
      IF (TABRET(0)) THEN
        IF ( TABRET(3) ) THEN
          LDCCVG = 3
        ELSE
          LDCCVG = 1
        ENDIF
        IF ( TABRET(1) ) THEN
          LDCCVG = 1
        ENDIF
      ENDIF   
C
C ---
C
                
C
      CALL JEDEMA()
      END
