      SUBROUTINE NMPRED(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,METHOD,SOLVEU,FONACT,
     &                  PARMET,CARCRI,SDPILO,SDDISC,NUMINS,
     &                  INST  ,VALMOI,VALPLU,POUGD ,SECMBR,
     &                  DEPALG,LICCVG,MATASS,MAPREC,PREMIE,
     &                  PARCRI,DEFICO,RESOCO,CONV  ,CNFINT,
     &                  CNDIRI,SDDYNA,SDSENS,MEELEM,MEASSE,
     &                  VEELEM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
      LOGICAL      PREMIE,FONACT(*)
      INTEGER      NUMINS,LICCVG(*)
      REAL*8       PARMET(*),INST(*)
      REAL*8       PARCRI(*),CONV(*)
      CHARACTER*14 SDPILO
      CHARACTER*16 METHOD(*)
      CHARACTER*19 MATASS,MAPREC
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA
      CHARACTER*19 CNFINT,CNDIRI
      CHARACTER*24 MODELE,NUMEDD, MATE, CARELE, COMREF, COMPOR
      CHARACTER*24 CARCRI 
      CHARACTER*24 VALMOI(8),POUGD(8),VALPLU(8),DEPALG(8),SECMBR(8)
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDSENS
      CHARACTER*8  MEELEM(8),VEELEM(30)
      CHARACTER*19 MEASSE(8) 
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C PHASE DE PREDICTION 
C      
C ----------------------------------------------------------------------
C
C
C IN       MODELE K24  MODELE
C IN       NUMEDD K24  NUME_DDL
C IN       MATE   K24  CHAMP MATERIAU
C IN       CARELE K24  CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN       COMREF K24  VARI_COM DE REFERENCE
C IN       COMPOR K24  COMPORTEMENT
C IN       LISCHA K19  L_CHARGES
C IN       MEDIRI K24  MATRICES ELEMENTAIRES DE DIRICHLET (B)
C IN       METHOD K16  INFORMATIONS SUR LES METHODES DE RESOLUTION
C IN       SOLVEU K19  SOLVEUR
C IN       PARMET  R8  PARAMETRES DES METHODES DE RESOLUTION
C IN       CARCRI K24  PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN       RIGID  K24  MATRICE DE RIGIDITE ASSEMBLE (POUR LA DYNAMIQUE)
C IN       MATASS K19  MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN       PILOTE K14  SD PILOTAGE
C IN       SDDISC K19  SD DISC_INST
C IN       NUMINS  I   NUMERO D'INSTANT
C IN       INST    R8  PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C                      (PAS POUR 'EXTRAPOL')
C IN       DEPOLD K24  ANCIEN INCREMENT DE TEMPS (PAS PRECEDENT)
C IN       VALMOI K24  ETAT EN T-
C IN       POUGD  K24  DONNES POUR POUTRES GRANDES DEFORMATIONS
C IN       VALPLU K24  ETAT EN T+
C IN       SECMBR K24  VECTEURS ASSEMBLES DES CHARGEMENTS FIXES
C OUT DEPPRE : PREDICTION DE L'INCREMENT DE DEPLACEMENT

C IN       SDDYNA K19  SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C OUT      LICCVG  I   CODES RETOURS 
C                      (5) - MATASS SINGULIERE
C
C ----------------------------------------------------------------------
C
      INTEGER IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> CALCUL DE PREDICTION' 
      ENDIF        
C      
C --- PREDICTION PAR LINEARISATION DU SYSTEME
C
      IF (METHOD(5).EQ.'ELASTIQUE' .OR. METHOD(5).EQ.'TANGENTE') THEN
        CALL NMPRTA(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,METHOD,SOLVEU,FONACT,
     &              PARMET,CARCRI,SDPILO,SDDISC,NUMINS,
     &              INST  ,VALMOI,VALPLU,POUGD ,SECMBR,
     &              DEPALG,LICCVG,MATASS,MAPREC,PREMIE,
     &              PARCRI,DEFICO,RESOCO,CONV  ,CNFINT,
     &              CNDIRI,SDDYNA,SDSENS,MEELEM,MEASSE,
     &              VEELEM)
C
C --- PREDICTION PAR EXTRAPOLATION DU PAS PRECEDENT
C
      ELSE IF (METHOD(5) .EQ. 'EXTRAPOL') THEN
        CALL NMPRDE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,METHOD,SOLVEU,FONACT,
     &              PARMET,CARCRI,SDPILO,SDDISC,NUMINS,
     &              INST  ,VALMOI,VALPLU,POUGD ,SECMBR,
     &              DEPALG,LICCVG,MATASS,MAPREC,PREMIE,                 
     &              PARCRI,DEFICO,RESOCO,CONV  ,CNFINT,
     &              CNDIRI,SDDYNA,SDSENS,MEELEM,MEASSE,
     &              VEELEM)
C
C --- PREDICTION PAR DEPLACEMENT CALCULE
C
      ELSE IF (METHOD(5) .EQ. 'DEPL_CALCULE') THEN
        CALL NMPRDE(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &              COMPOR,LISCHA,METHOD,SOLVEU,FONACT,
     &              PARMET,CARCRI,SDPILO,SDDISC,NUMINS,
     &              INST  ,VALMOI,VALPLU,POUGD ,SECMBR,
     &              DEPALG,LICCVG,MATASS,MAPREC,PREMIE,                
     &              PARCRI,DEFICO,RESOCO,CONV  ,CNFINT,
     &              CNDIRI,SDDYNA,SDSENS,MEELEM,MEASSE,
     &              VEELEM)
      ELSE
        CALL ASSERT(.FALSE.)
      END IF

      CALL JEDEMA()
      END
