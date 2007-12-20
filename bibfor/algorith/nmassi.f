      SUBROUTINE NMASSI(MODELE,NUMEDD,MATE  ,CARELE,COMREF,
     &                  COMPOR,LISCHA,SOLVEU,FONACT,PARMET,
     &                  CARCRI,SDDISC,NUMINS,INST  ,VALMOI,
     &                  VALPLU,POUGD ,SECMBR,DEPALG,SDDYNA,
     &                  SDSENS,MEELEM,MEASSE,VEELEM,CNFNOD,
     &                  CNBUDI,CNVCPR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      LOGICAL      FONACT(*)
      INTEGER      NUMINS
      REAL*8       PARMET(*),INST(*)
      CHARACTER*19 LISCHA,SOLVEU,SDDISC,SDDYNA
      CHARACTER*24 MODELE,NUMEDD, MATE, CARELE, COMREF, COMPOR
      CHARACTER*24 CARCRI 
      CHARACTER*24 VALMOI(8),POUGD(8),VALPLU(8),DEPALG(8),SECMBR(8)
      CHARACTER*24 SDSENS
      CHARACTER*8  MEELEM(8),VEELEM(30)
      CHARACTER*19 MEASSE(8) 
      CHARACTER*24 CNFNOD,CNBUDI,CNVCPR
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C CALCUL DU SECOND MEMBRE POUR LE CALCUL DE L'ACCELERATION INITIALE
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  SOLVEU : SOLVEUR
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISC_INST
C IN  NUMINS : NUMERO D'INSTANT
C IN  INST   : PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C IN  VALMOI : ETAT EN T-
C IN  VALPLU : ETAT EN T+
C IN  POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C IN  DEPALG : VARIABLE CHAPEAU POUR DEPLACEMENTS
C IN  SECMBR : SECONDS MEMBRES
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  SDSENS : SD POUR SENSIBILITE
C IN  VEELEM : VECTEURS ELEMENTAIRES
C IN  MEELEM : MATRICES ELEMENTAIRES
C IN  MEASSE : MATRICES ASSEMBLEES
C OUT CNFNOD : VECTEUR ASSEMBLE DES FORCES NODALES
C OUT CNBUDI : VECTEUR ASSEMBLE DES ELEMENTS DE LAGRANGE B.U
C OUT CNVCPR : VECTEUR ASSEMBLE DE LA VARIATION F_INT PAR RAPPORT
C              AUX VARIABLES DE COMMANDE   
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
      LOGICAL      LSENSI
      INTEGER      NRPASE
      REAL*8       INSTAM,INSTAP,DIINST,R8BID
      CHARACTER*1  BASE
      INTEGER      IFM,NIV     
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL SECOND MEMBRE' 
      ENDIF
C
C --- INITIALISATIONS
C
      INSTAM = DIINST(SDDISC,NUMINS-1)
      INSTAP = DIINST(SDDISC,NUMINS)
      LSENSI = .FALSE.
      NRPASE = 0
      BASE   = 'V'      
C
C --- CALCUL DU VECTEUR ASSEMBLE DES FORC_NODA
C      
      CALL NMCALV('FORC_NODA',
     &            MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &            INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &            VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &            SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &            VEELEM)  
      CALL NMASSV('FORC_NODA',
     &            MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &            SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &            R8BID ,R8BID ,SDDYNA,MEELEM,VALMOI,
     &            VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &            LSENSI,SDSENS,NRPASE,MEASSE,CNFNOD)
C
C --- CALCUL DU VECTEUR ASSEMBLE DES CONDITIONS DE DIRICHLET B.U
C
      CALL NMCALV('LAGR_MECA',
     &            MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &            INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &            VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &            SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &            VEELEM) 
      CALL NMASSV('LAGR_MECA',
     &            MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &            SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &            R8BID ,R8BID ,SDDYNA,MEELEM,VALMOI,
     &            VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &            LSENSI,SDSENS,NRPASE,MEASSE,CNBUDI)      
C
C --- CALCUL DU SECOND MEMBRE DE VARIABLES DE COMMANDE
C
      CALL NMVCPR(MODELE,LISCHA,NUMEDD,MATE  ,CARELE, 
     &            COMREF,COMPOR,VALMOI,VALPLU,CNVCPR)
C
      CALL JEDEMA()
      END
