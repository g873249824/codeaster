      SUBROUTINE NMCTCD(MODELE,MATE  ,CARELE,FONACT,COMPOR,
     &                  CARCRI,SDDISC,SDDYNA,NUMINS,VALINC,
     &                  SOLALG,LISCHA,COMREF,DEFICO,RESOCO,
     &                  RESOCU,NUMEDD,PARCON,SDSENS,VEELEM,
     &                  VEASSE,MEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
      INTEGER       FONACT(*)
      CHARACTER*24  MODELE      
      CHARACTER*24  MATE,CARELE
      CHARACTER*24  COMPOR,CARCRI
      INTEGER       NUMINS
      REAL*8        PARCON(8)
      CHARACTER*19  SDDISC,SDDYNA,LISCHA
      CHARACTER*24  DEFICO,RESOCO,RESOCU,COMREF,NUMEDD,SDSENS
      CHARACTER*19  VEELEM(*),VEASSE(*),MEASSE(*)
      CHARACTER*19  SOLALG(*),VALINC(*)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
C
C CALCUL ET ASSEMBLAGE DES FORCES LIEES AU CONTACT
C DISCRET ET LIAISON_UNILATER
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  PARCON : PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  RESOCU : SD RESOLUTION LIAISON_UNILATER
C IN  DEFICO : SD DEF. CONTACT
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  SDSENS : SD SENSIBILITE
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISC_INST
C IN  NUMINS : NUMERO D'INSTANT
C IN  NRPASE : NUMERO PARAMETRE SENSIBLE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  NBVECT : NOMBRE DE VECT_ELEM DANS LA LISTE
C IN  LTYPVE : LISTE DES NOMS DES VECT_ELEM
C IN  LOPTVE : LISTE DES OPTIONS DES VECT_ELEM 
C IN  LASSVE : SI VECT_ELEM A ASSEMBLER
C IN  LCALVE : SI VECT_ELEM A CALCULER
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
      INTEGER      IFM,NIV   
      INTEGER      NBVECT,NRPASE   
      LOGICAL      ISFONC,LUNIL,LCTCD,LSENS,LCTFD,LALLV
      LOGICAL      CFDISL,LPENAC
      CHARACTER*6  LTYPVE(20)
      CHARACTER*16 LOPTVE(20)
      LOGICAL      LASSVE(20),LCALVE(20)
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- ALL VERIF ?
C     
      LALLV  = CFDISL(DEFICO,'ALL_VERIF')
      IF (LALLV) THEN  
        GOTO 99
      ENDIF  
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ...... CALCUL FORCES CONTACT' 
      ENDIF
C
C --- INITIALISATIONS
C
      CALL NMCVEC('INIT',' ',' ',.FALSE.,.FALSE.,
     &            NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
C
C --- PAS DE SENSIBILITE
C      
      LSENS  = .FALSE.
      NRPASE = 0         
C
C --- FONCTIONNALITES ACTIVEES
C     
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET') 
      LCTFD  = ISFONC(FONACT,'FROT_DISCRET')
      LPENAC = CFDISL(DEFICO,'CONT_PENA') 
      LUNIL  = ISFONC(FONACT,'LIAISON_UNILATER')
C
C --- FORCES DE CONTACT/FROTTEMENT DISCRETS
C
      IF (LCTCD) THEN 
        CALL NMCVEC('AJOU','CNCTDC',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
      ENDIF
      IF ((LCTFD).OR.(LPENAC)) THEN  
        CALL NMCVEC('AJOU','CNCTDF',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
      ENDIF 
C
C --- FORCES DE LIAISON_UNILATER (PAS DE VECT_ELEM)
C     
      IF (LUNIL) THEN 
        CALL NMCVEC('AJOU','CNUNIL',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
      ENDIF      
C
C --- CALCUL EFFECTIF
C 
      CALL NMXVEC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &            SDDISC,SDDYNA,NUMINS,VALINC,SOLALG,
     &            LISCHA,COMREF,DEFICO,RESOCO,RESOCU,
     &            NUMEDD,PARCON,SDSENS,LSENS ,NRPASE,
     &            VEELEM,VEASSE,MEASSE,NBVECT,LTYPVE,
     &            LCALVE,LOPTVE,LASSVE)   
C
  99  CONTINUE         
C
      CALL JEDEMA()
      END
