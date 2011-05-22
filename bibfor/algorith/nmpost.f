      SUBROUTINE NMPOST(MODELE,MAILLA,NUMEDD,NUMFIX,CARELE,
     &                  COMPOR,SOLVEU,MAPREC,MATASS,NUMINS,
     &                  MATE  ,COMREF,LISCHA,DEFICO,RESOCO,
     &                  RESOCU,PARMET,PARCON,FONACT,CARCRI,
     &                  SDDISC,SDTIME,SDOBSE,SDERRO,SDSENS,
     &                  SDDYNA,SDPOST,VALINC,SOLALG,MEELEM,
     &                  MEASSE,VEELEM,VEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2011   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21 
C
      IMPLICIT     NONE
      INTEGER      NUMINS
      CHARACTER*8  MAILLA
      REAL*8       PARMET(*),PARCON(*)
      CHARACTER*19 MEELEM(*)
      CHARACTER*24 RESOCO,DEFICO,RESOCU
      CHARACTER*19 SOLVEU,MAPREC,MATASS
      CHARACTER*19 LISCHA
      CHARACTER*19 SDDISC,SDDYNA,SDPOST,SDOBSE
      CHARACTER*24 MODELE,NUMEDD,NUMFIX,COMPOR
      CHARACTER*19 VEELEM(*),MEASSE(*),VEASSE(*)
      CHARACTER*19 SOLALG(*),VALINC(*) 
      CHARACTER*24 SDSENS,SDTIME,SDERRO
      CHARACTER*24 MATE,CARELE
      CHARACTER*24 CARCRI,COMREF
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCULS DE POST-TRAITEMENT
C      
C ----------------------------------------------------------------------
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  DEFICO : SD DEF. CONTACT
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISC_INST
C IN  PREMIE : SI PREMIER INSTANT DE CALCUL
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  MATASS : MATRICE ASSEMBLEE GLOBALE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_FLAMB ET MODE_VIBR)
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL ISFONC,LMVIB,LFLAM,LERRT,LSENS,LCONT
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS

C
C --- FONCTIONNALITES ACTIVEES
C
      LSENS  = ISFONC(FONACT,'SENSIBILITE')      
      LCONT  = ISFONC(FONACT,'CONTACT')
      LERRT  = ISFONC(FONACT,'ERRE_TEMPS')
      LMVIB  = ISFONC(FONACT,'MODE_VIBR')
      LFLAM  = ISFONC(FONACT,'CRIT_FLAMB')
C
C --- CALCUL EVENTUEL DE L'INDICATEUR D'ERREUR TEMPORELLE
C
      IF (LERRT) THEN
        CALL NMETCA(MODELE,MAILLA,MATE  ,SDDISC,SDERRO,
     &              NUMINS,VALINC)
      ENDIF
C
C --- POST_TRAITEMENT DU CONTACT
C
      IF (LCONT) THEN
        CALL CFMXPO(MAILLA,MODELE,DEFICO,RESOCO,NUMINS,
     &              SDDISC,SOLALG,VALINC,VEASSE)
      ENDIF
C
C --- CALCUL DE POST-TRAITEMENT: FLAMBEMENT ET MODES VIBRATOIRES
C
      IF (LMVIB.OR.LFLAM) THEN
        CALL NMSPEC(MODELE,NUMEDD,NUMFIX,CARELE,COMPOR,
     &              SOLVEU,NUMINS,MATE  ,COMREF,LISCHA,
     &              DEFICO,RESOCO,PARMET,FONACT,CARCRI,
     &              SDDISC,SDTIME,VALINC,SOLALG,MEELEM,
     &              MEASSE,VEELEM,SDDYNA,SDPOST)
      ENDIF
C
C --- CALCUL DE SENSIBILITE
C
      IF (LSENS) THEN
        CALL NMSENS(MODELE,NUMEDD,MATE  ,COMPOR,CARELE,
     &              LISCHA,FONACT,SOLVEU,NUMINS,CARCRI,
     &              COMREF,DEFICO,RESOCO,RESOCU,PARCON,
     &              MATASS,MAPREC,SDSENS,SDDYNA,SDDISC,
     &              VALINC,SOLALG,VEELEM,VEASSE,MEASSE)
      ENDIF
C
C --- OBSERVATION EVENTUELLE
C
      CALL NMOBSV(MAILLA,SDDISC,SDOBSE,SDDYNA,RESOCO,
     &            VALINC,VEASSE,NUMINS)       
C
      CALL JEDEMA()      
C   
      END
