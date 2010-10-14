      SUBROUTINE NMCOMA(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &                  PARMET,METHOD,LISCHA,NUMEDD,SOLVEU,
     &                  COMREF,SDDISC,SDDYNA,SDTIME,NUMINS,
     &                  ITERAT,FONACT,DEFICO,RESOCO,VALINC,
     &                  SOLALG,VEELEM,MEELEM,MEASSE,VEASSE,
     &                  MAPREC,MATASS,CODERE,FACCVG,LDCCVG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2010   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      REAL*8        PARMET(*)
      CHARACTER*16  METHOD(*)
      INTEGER       FONACT(*)
      CHARACTER*(*) MODELZ
      CHARACTER*24  MATE,CARELE
      CHARACTER*24  COMPOR,CARCRI,SDTIME,NUMEDD      
      CHARACTER*19  SDDISC,SDDYNA,LISCHA,SOLVEU
      CHARACTER*24  COMREF,CODERE
      CHARACTER*19  MEELEM(*),VEELEM(*)
      CHARACTER*19  SOLALG(*),VALINC(*)      
      CHARACTER*19  MEASSE(*),VEASSE(*)  
      INTEGER       NUMINS,ITERAT,IBID
      CHARACTER*24  DEFICO,RESOCO
      CHARACTER*19  MAPREC,MATASS       
      INTEGER       FACCVG,LDCCVG
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CALCUL DE LA MATRICE GLOBALE EN CORRECTION
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
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  DEFICO : SD DEF. CONTACT
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISC_INST
C IN  SDTIME : SD TIMER
C IN  NUMINS : NUMERO D'INSTANT
C IN  ITERAT : NUMERO D'ITERATION
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
C IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C OUT LFINT  : .TRUE. SI FORCES INTERNES CALCULEES 
C OUT MATASS : MATRICE DE RESOLUTION ASSEMBLEE
C OUT MAPREC : MATRICE DE RESOLUTION ASSEMBLEE - PRECONDITIONNEMENT
C OUT FACCVG : CODE RETOUR (INDIQUE SI LA MATRICE EST SINGULIERE)
C                   O -> MATRICE INVERSIBLE
C                   1 -> MATRICE SINGULIERE
C                   2 -> MATRICE PRESQUE SINGULIERE
C                   3 -> ON NE SAIT PAS SI LA MATRICE EST SINGULIERE
C OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
C                0 : CAS DE FONCTIONNEMENT NORMAL
C                1 : ECHEC DE L'INTEGRATION DE LA LDC
C                3 : SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
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
      LOGICAL      REASMA,LCAMOR
      LOGICAL      LDYNA,LAMOR,LSUIV,LCRIGI,LCFINT,LARIGI
      LOGICAL      NDYNLO,ISFONC
      CHARACTER*16 METCOR,METPRE   
      CHARACTER*16 OPTRIG,OPTAMO 
      CHARACTER*19 VEFINT,CNFINT
      CHARACTER*24 MODELE
      LOGICAL      LBID,RENUME
      REAL*8       R8BID
      INTEGER      IFM,NIV
      INTEGER      NBMATR
      CHARACTER*6  LTYPMA(20)
      CHARACTER*16 LOPTME(20),LOPTMA(20)
      LOGICAL      LASSME(20),LCALME(20)                       
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL MATRICE' 
      ENDIF      
C
C --- INTIIALISATIONS
C
      CALL NMCMAT('INIT','      ',' ',' ',.FALSE.,
     &            .FALSE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LCALME,LASSME)      
      MODELE = MODELZ
      FACCVG = 0
      LDCCVG = 0
      RENUME = .FALSE.
      LCAMOR = .FALSE.    
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LAMOR  = NDYNLO(SDDYNA,'MAT_AMORT')
      LSUIV  = ISFONC(FONACT,'FORCE_SUIVEUSE')
C
C --- CHOIX DE REASSEMBLAGE DE LA MATRICE GLOBALE
C 
      CALL NMCHRM('CORRECTION',
     &            PARMET,METHOD,FONACT,SDDISC,SDDYNA,
     &            NUMINS,ITERAT,DEFICO,METPRE,METCOR,
     &            REASMA)
C
C --- CHOIX DE REASSEMBLAGE DE L'AMORTISSEMENT
C 
      IF (LAMOR) THEN
        CALL NMCHRA(SDDYNA,OPTAMO,LCAMOR)
      ENDIF  
C
C --- RE-CREATION DU NUME_DDL OU PAS
C
      CALL NMRENU(MODELZ,FONACT,SDTIME,NUMEDD,LISCHA,
     &            SOLVEU,RESOCO,RENUME)    
C
C --- OPTION DE CALCUL POUR MERIMO
C 
      CALL NMCHOI('CORRECTION',
     &            SDDYNA,SDDISC,FONACT,METPRE,METCOR,
     &            REASMA,LCAMOR,OPTRIG,LCRIGI,LARIGI,
     &            LCFINT)
C
C --- CALCUL ET ASSEMBLAGE DES FORCES INTERNES
C
      IF (LCFINT) THEN
        CALL NMCHEX(VEELEM,'VEELEM','CNFINT',VEFINT)
        CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT) 
        CALL NMFINT(MODELE,MATE  ,CARELE,COMREF,COMPOR,
     &              LISCHA,CARCRI,FONACT,ITERAT,SDDYNA,
     &              SDTIME,VALINC,SOLALG,LDCCVG,CODERE,
     &              VEFINT)
        LCFINT = .FALSE.    
        CALL NMAINT(NUMEDD,FONACT,DEFICO,VEASSE,VEFINT,
     &              CNFINT)          
      ENDIF
C
C --- CALCUL DES MATR_ELEM CONTACT/XFEM_CONTACT
C      
      CALL NMCHCC(FONACT,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LASSME,LCALME)           
C
C --- ASSEMBLAGE DES MATR-ELEM DE RIGIDITE
C
      IF (LARIGI) THEN
        CALL NMCMAT('AJOU','MERIGI',OPTRIG,' ',.FALSE.,
     &              LARIGI,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &              LCALME,LASSME)
      ENDIF  
C
C --- CALCUL DES MATR-ELEM D'AMORTISSEMENT DE RAYLEIGH A CALCULER 
C --- NECESSAIRE SI MATR_ELEM RIGIDITE CHANGE !
C
      IF (LCAMOR) THEN
        CALL NMCMAT('AJOU','MEAMOR',OPTAMO,' ',.TRUE.,
     &            .TRUE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &            LCALME,LASSME) 
      ENDIF 
C
C --- CALCUL DES MATR-ELEM DES CHARGEMENTS SUIVEURS
C
      IF (LSUIV) THEN
        CALL NMCMAT('AJOU','MESUIV',' ',' ',.TRUE.,
     &              .FALSE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &              LCALME,LASSME)     
      ENDIF 
C
C --- RE-CREATION MATRICE MASSE SI NECESSAIRE (NOUVEUA NUME_DDL)
C
      IF (RENUME) THEN         
        IF (LDYNA) THEN
          CALL NMCMAT('AJOU','MEMASS',' ',' ',.FALSE.,
     &                .TRUE.,NBMATR,LTYPMA,LOPTME,LOPTMA,
     &                LCALME,LASSME)
        ENDIF
        IF (.NOT.REASMA) THEN
          CALL ASSERT(.FALSE.)
        ENDIF        
      ENDIF  
C
C --- CALCUL ET ASSEMBLAGE DES MATR_ELEM DE LA LISTE
C
      IF (NBMATR.GT.0) THEN
        CALL NMXMAT(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,FONACT,NUMINS,ITERAT,
     &              VALINC,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,SOLVEU,NUMEDD,SDTIME,NBMATR,
     &              LTYPMA,LOPTME,LOPTMA,LCALME,LASSME,
     &              LCFINT,MEELEM,MEASSE,VEELEM,LDCCVG,
     &              CODERE)
      ENDIF
C
C --- CALCUL DE LA MATRICE ASSEMBLEE GLOBALE
C      
      IF (REASMA) THEN
        CALL NMMATR('CORRECTION',
     &              FONACT,LISCHA,SOLVEU,NUMEDD,SDDYNA,
     &              SDDISC,DEFICO,RESOCO,MEELEM,MEASSE,
     &              MATASS)
        CALL NMIMPR('IMPR','MATR_ASSE',METCOR,0.D0,0)
      ELSE
        CALL NMIMPR('IMPR','MATR_ASSE',' ',0.D0,0)
      ENDIF
C
C --- FACTORISATION DE LA MATRICE ASSEMBLEE GLOBALE
C  
      IF (REASMA) THEN
        CALL NMTIME('INIT' ,'TMP',SDTIME,LBID  ,R8BID )
        CALL NMTIME('DEBUT','TMP',SDTIME,LBID  ,R8BID )      
        CALL PRERES(SOLVEU,'V',FACCVG,MAPREC,MATASS,IBID,-9999)
        CALL NMTIME('FIN'      ,'TMP',SDTIME,LBID  ,R8BID )
        CALL NMTIME('FACT_NUME','TMP',SDTIME,LBID  ,R8BID )
      ENDIF     
C
      CALL JEDEMA()        
C
      END
