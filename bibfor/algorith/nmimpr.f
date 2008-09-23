      SUBROUTINE NMIMPR(PHASE,NATURZ,ARGZ,ARGR,ARGI)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_20
C
      IMPLICIT      NONE
      CHARACTER*4   PHASE
      CHARACTER*(*) NATURZ
      CHARACTER*(*) ARGZ(*)
      REAL*8        ARGR(*)
      INTEGER       ARGI(*)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE)
C
C GESTION DES IMPRESSIONS DE LA COMMANDE MECA_NON_LINE
C      
C ----------------------------------------------------------------------
C      
C
C IN  PHASE  : 'INIT' INITIALISATION
C              'TITR' AFFICHAGE DE L'EN TETE DES PAS DE TEMPS
C              'IMPR' IMPRESSION
C IN  NATURE : NATURE DE L'IMPRESSION POUR PHASE 'INIT' 
C              'DYNA_TRAN' -> CAS SCHEMA EXPLICITE (PAS DE TABLEAU
C                             DE CONVERGENCE)
C              ' '         -> AUTRES CAS
C IN  NATURE : NATURE DE L'IMPRESSION POUR PHASE 'IMPR'          
C              'MATR_ASSE' -> ASSEMBLAGE DE LA MATRICE
C              'ARCH_INIT' -> TITRE ARCHIVAGE ETAT INITIAL
C              'ARCHIVAGE' -> STOCKAGE DES CHAMPS
C              'ARCH_SENS' -> STOCKAGE DES CHAMPS DERIVES (SENSIBILITE)
C              'ITER_MAXI' -> MAXIMUM ITERATIONS ATTEINT
C              'SUBDIVISE' -> SUBDIVISION DU PAS DE TEMPS
C              'CONV_OK  ' -> CONVERGENCE ATTEINTE
C              'GEOM_MIN'  -> BOUCLE EN MOINS
C              'GEOM_MAX'  -> BOUCLE SUPPLEMENTAIRE
C              'FIXE_NON'  -> BOUCLE SUPPLEMENTAIRE SUR POINT FIXE
C                             DU CONTACT-FROTTEMENT
C              'ETAT_CONV' -> PARAMETRES DE CONVERGENCE
C              'ECHEC_LDC' -> ECHEC DE L'INTEGRATION DE LA LDC
C              'ECHEC_PIL' -> ECHEC DU PILOTAGE
C              'ECHEC_CON' -> ECHEC DE TRAITEMENT DU CONTACT
C              'CONT_SING' -> MATRICE DE CONTACT SINGULIERE
C              'MATR_SING' -> MATRICE DU SYSTEME SINGULIERE
C              'MAXI_RELA' -> CONVERGENCE SUR RESI_GLOB_MAXI
C                             QUAND RESI_GLOB_RELA & CHARGEMENT=0
C              'BCL_SEUIL' -> NUMERO BOUCLE SEUIL CONTACT ECP
C              'BCL_GEOME' -> NUMERO BOUCLE GEOMETRIE CONTACT ECP
C              'BCL_CTACT' -> NUMERO BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'CNV_SEUIL' -> CONVERGENCE BOUCLE SEUIL CONTACT ECP
C              'CNV_GEOME' -> CONVERGENCE BOUCLE GEOMETRIE CONTACT ECP
C              'CNV_CTACT' -> CONVERGENCE BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'OPTI_LIST' -> LISTE D'INSTANTS OPTIMISEES
C                               (OPTION OPTI_LIST_INST)
C IN  ARGZ   : ARGUMENTS EVENTUELS DE TYPE TEXTE
C IN  ARGR   : ARGUMENTS EVENTUELS DE TYPE REEL
C IN  ARGI   : ARGUMENTS EVENTUELS DE TYPE ENTIER
C ----------------------------------------------------------------------
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER          MESS,IUNIFI,UNITM,IBID,IFM,NIV,RANG,JIMPIN,IRET,
     &                 IINF,NIVMPI
      REAL*8           RBID
      CHARACTER*24     IMPRCO,IMPINF,K24B,INFOFE
      INTEGER          UNIT
      SAVE             UNIT
      DATA IMPRCO      /'&&OP0070.IMPR.          '/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      MESS   = IUNIFI ('MESSAGE')

C FETI PARALLE OR NOT ?
      CALL INFNIV(IFM,NIV)
      CALL JEEXIN('&FETI.MAILLE.NUMSD',IRET)
      RANG=0
      IF (IRET.GT.0) THEN
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE=ZK24(IINF)
        IF (INFOFE(10:10).EQ.'T') THEN
          NIVMPI=2
        ELSE
          NIVMPI=1
        ENDIF
        CALL FETMPI(2,IBID,IFM,NIVMPI,RANG,IBID,K24B,K24B,K24B,RBID)
      ENDIF

C ======================================================================
C
C ROUTINE CHAPEAU - APPELLE LA ROUTINE PRINCIPALE NMIMPM
C EN DEUX FOIS SI NECESSAIRE (SORTIES MESSAGE/FICHIER)
C SI FETI PARALLELE, SEUL LE PROCESSEUR MAITRE AFFICHE
C ======================================================================

      IF (RANG.EQ.0) THEN

        IF (PHASE.EQ.'INIT') THEN      
          UNITM = 0
          CALL NMIMPM(UNITM,PHASE,NATURZ,ARGZ,ARGR,ARGI)
          IMPINF = IMPRCO(1:14)//'INFO'
          CALL JEVEUO(IMPINF,'L',JIMPIN)
          UNIT   = ZI(JIMPIN-1+8)
        ELSE
C
C --- ECRITURE DANS LE FICHIER MESSAGE
C
          UNITM  = MESS
          CALL NMIMPM(UNITM,PHASE,NATURZ,ARGZ,ARGR,ARGI)
C
C --- ECRITURE DANS LE FICHIER PERSO
C      
          IF (UNIT.NE.0) THEN
            UNITM = UNIT
            CALL NMIMPM(UNITM,PHASE,NATURZ,ARGZ,ARGR,ARGI)
          ENDIF
        ENDIF

      ENDIF

      CALL JEDEMA()
      END
