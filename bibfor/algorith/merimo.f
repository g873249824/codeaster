      SUBROUTINE MERIMO(BASE  ,MODELE,CARELE,MATE  ,COMREF,
     &                  COMPOR,LISCHA,CARCRI,ITERAT,FONACT,
     &                  SDDYNA,VALINC,SOLALG,MERIGI,VEFINT,
     &                  OPTIOZ,TABRET,CODERE)
C 
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C TOLE CRP_20
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER       ITERAT
      LOGICAL       TABRET(0:10)
      INTEGER       FONACT(*)
      CHARACTER*(*) MATE,OPTIOZ
      CHARACTER*1   BASE
      CHARACTER*19  LISCHA,SDDYNA
      CHARACTER*24  MODELE,CARELE,COMPOR,COMREF
      CHARACTER*24  CARCRI,CODERE
      CHARACTER*19  MERIGI,VEFINT
      CHARACTER*19  SOLALG(*),VALINC(*)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE
C CALCUL DES VECTEURS ELEMENTAIRES DES FORCES INTERNES
C      
C ----------------------------------------------------------------------
C
C
C IN  BASE   : BASE 'V' OU 'G' OU SONT CREES LES OBJETS EN SORTIE
C IN  MODELE : NOM DU MODELE
C IN  LISCHA : SD L_CHARGES
C IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE   : CHAMP DE MATERIAU CODE
C IN  COMPOR : TYPE DE RELATION DE COMPORTEMENT
C IN  CARCRI : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN  OPTION : OPTION DEMANDEE
C IN  ITERAT : NUMERO D'ITERATION INTERNE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  COMREF : VALEURS DE REF DES VAR DE COMMANDE (TREF, ...)
C OUT MERIGI : MATRICES ELEMENTAIRES DE RIGIDITE
C OUT VEFINT : VECTEURS ELEMENTAIRES DES FORCES INTERIEURES
C OUT CODERE : CHAM_ELEM CODE RETOUR ERREUR INTEGRATION LDC
C OUT TABRET : TABLEAU RESUMANT LES CODES RETOURS DU TE
C                    TABRET(0) = .TRUE. UN CODE RETOUR NON NUL EXISTE
C                    TABRET(I) = .TRUE. CODE RETOUR I RENCONTRE
C                                SINON .FALSE.
C                    I VALANT DE 1 A 10
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
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=8, NBIN=53)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      LOGICAL      ISFONC,LMACR
      LOGICAL      MATRIX,VECTOR,CODINT,CONEXT
      INTEGER      NCHAR,IRET,IRES,IAREFE
      CHARACTER*8  K8BID
      CHARACTER*24 CACO3D
      CHARACTER*24 LIGRMO
      CHARACTER*19 SIGEXT,SIGPLU,VARPLU
      CHARACTER*16 OPTION
      LOGICAL      DEBUG
      INTEGER      IFMDBG,NIVDBG       
C
      DATA CACO3D/'&&MERIMO.CARA_ROTA_FICTI'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)      
C
C --- INITIALISATIONS
C       
      OPTION = OPTIOZ
      LIGRMO = MODELE(1:8)//'.MODELE'
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF
      DO 10 IRET = 0 , 10
        TABRET(IRET) = .FALSE.
 10   CONTINUE
C
C --- FONCTIONNALITES ACTIVEES
C    
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')        
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)  
C
C --- ACCES AUX CHARGEMENTS
C 
      CALL JEEXIN(LISCHA(1:19)//'.LCHA',IRET)
      IF (IRET.EQ.0) THEN
        NCHAR = 0
      ELSE
        CALL JELIRA(LISCHA(1:19)//'.LCHA','LONMAX',NCHAR,K8BID)
      END IF
C     
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','SIGEXT',SIGEXT)
      CALL NMCHEX(VALINC,'VALINC','SIGPLU',SIGPLU)      
      CALL NMCHEX(VALINC,'VALINC','VARPLU',VARPLU)         
C
C --- PREPARATION DES CHAMPS D'ENTREE POUR RIGIDITE TANGENTE (MERIMO)
C          
      CALL MERIMP(MODELE,CARELE,MATE  ,COMREF,
     &            COMPOR,LISCHA,CARCRI,ITERAT,SDDYNA,
     &            VALINC,SOLALG,CACO3D,NBIN  ,LPAIN ,
     &            LCHIN)
C 
C --- TYPE DE SORTIES: 
C --- MATRIX: MATRICE TANGENTE
C --- VECTOR: FORCES INTERIEURES 
C --- CODINT: CODE RETOUR ERREUR INTEG. LDC 
C
      IF (OPTION(1:9).EQ.'FULL_MECA') THEN
        MATRIX = .TRUE.
        VECTOR = .TRUE.
        CODINT = .TRUE.  
        CONEXT = .FALSE.   
      ELSE IF (OPTION(1:10).EQ.'RIGI_MECA ') THEN
        MATRIX = .TRUE.
        VECTOR = .FALSE.
        CODINT = .FALSE. 
        CONEXT = .FALSE. 
      ELSE IF (OPTION(1:16).EQ.'RIGI_MECA_IMPLEX') THEN
        MATRIX = .TRUE.
        VECTOR = .FALSE.
        CODINT = .FALSE.
        CONEXT = .TRUE.                       
      ELSE IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN
        MATRIX = .TRUE.
        VECTOR = .FALSE.
        CODINT = .FALSE. 
        CONEXT = .FALSE.               
      ELSE IF (OPTION(1:9).EQ.'RAPH_MECA') THEN
        MATRIX = .FALSE.
        VECTOR = .TRUE.
        CODINT = .TRUE. 
        CONEXT = .FALSE.               
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C --- AFFICHAGE
C      
      IF (NIVDBG.GE.2) THEN
        WRITE (IFMDBG,*) '<CALCUL> ... OPTION: ',OPTION
        IF (MATRIX) THEN
          WRITE (IFMDBG,*) '<CALCUL> ... CALCUL DES MATR_ELEM '//
     &                  ' DE RIGIDITE '
        ENDIF
        IF (VECTOR) THEN
          WRITE (IFMDBG,*) '<CALCUL> ... CALCUL DES VECT_ELEM '//
     &                  ' DES FORCES INTERNES '
        ENDIF
        IF (CONEXT) THEN
          WRITE (IFMDBG,*) '<CALCUL> ... CALCUL DES CONTRAINTES '//
     &                  ' EXTRAPOLEES POUR IMPL_EX '
        ENDIF        
      ENDIF       
C
C --- PREPARATION DES MATR_ELEM ET VECT_ELEM
C
      IF (MATRIX) THEN
        CALL JEEXIN(MERIGI//'.RELR',IRET)
        IF (IRET.EQ.0) THEN
          CALL JEEXIN(MERIGI//'.RERR',IRES)
          IF (IRES.EQ.0) THEN     
            CALL MEMARE(BASE  ,MERIGI,MODELE(1:8),MATE,CARELE,
     &                  'RIGI_MECA') 
          ENDIF
          IF (LMACR) THEN
            CALL JEVEUO(MERIGI//'.RERR','E',IAREFE)
            ZK24(IAREFE-1+3) = 'OUI_SOUS_STRUC'      
          ENDIF
        ENDIF
        CALL JEDETR(MERIGI//'.RELR')
        CALL REAJRE(MERIGI,' ',BASE)
      ENDIF  
C
      IF (VECTOR) THEN
        CALL JEEXIN(VEFINT//'.RELR',IRET)
        IF (IRET.EQ.0) THEN
          CALL MEMARE(BASE,VEFINT,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        END IF
        CALL JEDETR(VEFINT//'.RELR')
        CALL REAJRE(VEFINT,' ',BASE)
      ENDIF          
C
C --- CHAMPS DE SORTIE
C
      LPAOUT(4) = 'PCONTPR'
      LCHOUT(4) = SIGPLU(1:19)
      LPAOUT(5) = 'PVARIPR'
      LCHOUT(5) = VARPLU(1:19)
      LPAOUT(7) = 'PCACO3D'
      LCHOUT(7) = CACO3D(1:19)
      IF (MATRIX) THEN
        LPAOUT(1) = 'PMATUUR'
        LCHOUT(1) = MERIGI(1:15)//'.M01'
        LPAOUT(2) = 'PMATUNS'
        LCHOUT(2) = MERIGI(1:15)//'.M02'
      ENDIF
      IF (VECTOR) THEN
        LPAOUT(3) = 'PVECTUR'
        LCHOUT(3) = VEFINT(1:15)//'.R01'
      ENDIF
      IF (CODINT) THEN
        LPAOUT(6) = 'PCODRET'
        LCHOUT(6) = CODERE(1:19)
      ENDIF
      IF (CONEXT) THEN
        LPAOUT(8) = 'PCONTXR'
        LCHOUT(8) = SIGEXT(1:19)
      ENDIF               
C
C --- APPEL A CALCUL
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
      ENDIF   
C      
      CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,
     &                              NBOUT,LCHOUT,LPAOUT,BASE)    
C
C --- SAUVEGARDE MATR_ELEM/VECT_ELEM
C
      IF (MATRIX) THEN
        CALL REAJRE(MERIGI,LCHOUT(1),BASE)
        CALL REAJRE(MERIGI,LCHOUT(2),BASE)
      ENDIF
C
      IF (VECTOR) THEN
        CALL REAJRE(VEFINT,LCHOUT(3),BASE)
      ENDIF      
C
C --- SAUVEGARDE CODE RETOUR ERREUR
C
      IF (CODINT) THEN
        CALL NMIRET(LCHOUT(6),TABRET)
      ENDIF        
C
      CALL JEDEMA()
      END
