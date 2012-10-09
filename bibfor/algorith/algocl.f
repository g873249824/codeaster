       SUBROUTINE ALGOCL(SDSTAT,DEFICO,RESOCO,SOLVEU,MATASS,
     &                   NOMA  ,CTCCVG,CTCFIX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/10/2012   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 SDSTAT
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 SOLVEU,MATASS
      INTEGER      CTCCVG
      LOGICAL      CTCFIX
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C ALGO. POUR CONTACT    : DUALISATION (LAGRANGIEN)
C ALGO. POUR FROTTEMENT : SANS
C
C ----------------------------------------------------------------------
C
C
C RESOLUTION DE : C.DU + AT.MU  = F
C                 A(U+DU)      <= E (POUR LES LIAISONS ACTIVES)
C
C AVEC E = JEU COURANT (CORRESPONDANT A U/I/N)
C
C      A = MATRICE DE CONTACT
C
C      C = ( K  BT ) MATRICE DE RIGIDITE INCLUANT LES LAGRANGE
C          ( B  0  )
C
C      U = ( DEPL )
C          ( LAM  )
C
C      F = ( DL  ) DANS LA PHASE DE PREDICTION
C          ( DUD )
C
C      F = ( L - QT.SIG - BT.LAM  ) AU COURS D'UNE ITERATION DE NEWTON
C          (           0          )
C
C IN  SDSTAT : SD STATISTIQUES
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  SOLVEU : SD SOLVEUR
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  NOMA   : NOM DU MAILLAGE
C OUT CTCCVG : CODE RETOUR CONTACT DISCRET
C                -1 : PAS DE CALCUL DU CONTACT DISCRET
C                 0 : CAS DU FONCTIONNEMENT NORMAL
C                 1 : NOMBRE MAXI D'ITERATIONS
C                 2 : MATRICE SINGULIERE
C OUT CTCFIX : .TRUE.  SI ATTENTE POINT FIXE CONTACT
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      CFDISI,CFDISD
      LOGICAL      LECHEC
      INTEGER      IBID,IEQ,ITER
      INTEGER      LLLIAI,LLLIAC
      INTEGER      LLF,LLF1,LLF2
      INTEGER      INDIC,INDFAC,AJLIAI,SPLIAI,SPAVAN
      INTEGER      NEQ,NBLIAC,NBLIAI,NDIM,NESMAX
      INTEGER      NBPREN
      REAL*8       RHO,XJVMAX
      CHARACTER*1  TYPEAJ
      CHARACTER*2  TYPEC0
      CHARACTER*19 MACONT
      INTEGER      LDSCON,LMAT
      CHARACTER*19 DDEPLC,DDEPL0,DDELT
      INTEGER      JDDEPC,JDDEP0,JDDELT
      INTEGER      ITEMAX,ISTO,ITEMUL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<CONTACT><CALC> ALGO_CONTACT   : DUALISATION'
        WRITE(IFM,*) '<CONTACT><CALC> ALGO_FROTTEMENT: SANS'
      ENDIF
C
C --- ACCES AUX CHAMPS DE TRAVAIL
C --- DDEPL0: INCREMENT DE SOLUTION SANS CORRECTION DU CONTACT
C --- DDEPLC: INCREMENT DE SOLUTION APRES CORRECTION DU CONTACT
C --- DDELT : INCREMENT DE SOLUTION ITERATION DE CONTACT
C
      DDEPL0 = RESOCO(1:14)//'.DEL0'
      DDEPLC = RESOCO(1:14)//'.DELC'
      DDELT  = RESOCO(1:14)//'.DDEL'
      CALL JEVEUO(DDEPL0(1:19)//'.VALE','L',JDDEP0)
      CALL JEVEUO(DDEPLC(1:19)//'.VALE','E',JDDEPC)
      CALL JEVEUO(DDELT (1:19)//'.VALE','E',JDDELT)
C
C --- PREPARATION DE LA MATRICE DE CONTACT
C
      MACONT = RESOCO(1:14)//'.MATC'
      CALL MTDSC3(MACONT)
      CALL JEECRA(MACONT(1:19)//'.REFA','DOCU',IBID,'ASSE')
      CALL JEVEUO(MACONT(1:19)//'.&INT','E',LDSCON)
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE GLOBALE
C
      CALL JEVEUO(MATASS//'.&INT','L',LMAT)
C
C --- INITIALISATION DES VARIABLES
C
      NBLIAI = CFDISD(RESOCO,'NBLIAI')
      NEQ    = CFDISD(RESOCO,'NEQ'   )
      NDIM   = CFDISD(RESOCO,'NDIM'  )
      NESMAX = CFDISD(RESOCO,'NESMAX')
      NBLIAC = CFDISD(RESOCO,'NBLIAC')
      LLF    = 0
      LLF1   = 0
      LLF2   = 0
      ITEMUL = CFDISI(DEFICO,'ITER_CONT_MULT')
      ITEMAX = ITEMUL*NBLIAI
      TYPEAJ = 'A'
      TYPEC0 = 'C0'
      XJVMAX = 0.D0
C
C --- GESTION DE LA FACTORISATION
C
      ISTO   = CFDISI(DEFICO,'STOP_SINGULIER')
      AJLIAI = 0
      SPLIAI = 0
      IF (NBLIAC.GT.0) THEN
        INDIC  = 1
      ELSE
        INDIC  = 0
      ENDIF
      INDFAC = 1
C
      ITER   = 1
C
      IF ( NIV .GE. 2 ) THEN
        WRITE(IFM,1001) ITEMAX
      ENDIF
C
C ======================================================================
C                    REPRISE DE LA BOUCLE PRINCIPALE
C ======================================================================
C
  40  CONTINUE
C
C --- MISE A JOUR DE LA SOLUTION ITERATION DE CONTACT
C
      DO 50 IEQ = 1,NEQ
        ZR(JDDELT+IEQ-1) = ZR(JDDEP0+IEQ-1) - ZR(JDDEPC-1+IEQ)
   50 CONTINUE
C
C --- RESOLUTION MATRICIELLE POUR DES LIAISONS ACTIVES
C
      IF (NBLIAC.NE.0) THEN
C
        SPAVAN = SPLIAI
C
C ----- CALCUL DE [-A.C-1.AT] COLONNE PAR COLONNE (A PARTIR DE INDFAC)
C
        CALL CFACAT(NDIM  ,INDIC ,NBLIAC,AJLIAI,SPLIAI,
     &              LLF   ,LLF1  ,LLF2  ,INDFAC,NESMAX,
     &              DEFICO,RESOCO,SOLVEU,LMAT  ,NBLIAI,
     &              XJVMAX)
C
C ----- DETECTION DES PIVOTS NULS
C
        CALL ELPIV1(XJVMAX,INDIC ,NBLIAC,AJLIAI,SPLIAI,
     &              SPAVAN,NOMA  ,DEFICO,RESOCO)
C
C ----- ON A SUPPRIME UNE LIAISON
C
        IF (INDIC .EQ. -1) THEN
          GOTO 150
        ENDIF
C
C ----- FACTORISATION LDLT DE [-A.C-1.AT]
C
        CALL CFFACT(LDSCON,NDIM  ,ISTO  ,NBLIAC,LLF   ,
     &              LLF1  ,LLF2  ,INDFAC,LECHEC)
C
C ----- LA MATRICE DE CONTACT EST-ELLE SINGULIERE ?
C
        IF (LECHEC) THEN
          CTCCVG = 2
          GOTO 999
        ENDIF
C
C ----- CALCUL DU SECOND MEMBRE : {JEU(DEPTOT) - A.DDEPL0} -> {MU}
C
        CALL CFADUC(RESOCO,NBLIAC)
C
C ----- RESOLUTION : [-A.C-1.AT].{MU} = {JEU(DEPTOT) - A.DDEPL0}
C
        CALL CFRESO(RESOCO,LDSCON,NDIM  ,NBLIAC,LLF   ,
     &              LLF1  ,LLF2  )
C
C ----- MISE A JOUR DU VECTEUR SOLUTION ITERATION DE CONTACT
C
        CALL CFMAJC(RESOCO,NEQ   ,NBLIAC)
      ENDIF
C
C --- VERIFICATION SI L'ENSEMBLE DES LIAISONS SUPPOSEES EST TROP PETIT
C
      CALL CFPETI(RESOCO,NEQ   ,NBLIAI,NBLIAC,LLF   ,
     &            LLF1  ,LLF2  ,RHO   ,LLLIAI,LLLIAC)
C
C --- ACTUALISATION DE DDEPLC = DDEPLC + RHO .DDELT
C
      CALL DAXPY(NEQ   ,RHO   ,ZR(JDDELT),1,ZR(JDDEPC),1)
C
C --- MODIFICATIONS DES LIAISONS
C
      IF (RHO.LT.1.D0) THEN
C
C ----- SI AU MOINS UNE LIAISON SUPPOSEE NON ACTIVE EST VIOLEE
C ----- ON AJOUTE A L'ENSEMBLE DES LIAISONS ACTIVES LA PLUS VIOLEE
C
        CALL ASSERT(LLLIAI.GT.0)
        CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &              LLF1  ,LLF2  ,RESOCO,TYPEAJ,LLLIAC,
     &              LLLIAI,TYPEC0)
        CALL CFIMP2(DEFICO,RESOCO,NOMA  ,LLLIAI,TYPEC0,
     &              'ACT' )
      ELSE
C
C ----- ON A "CONVERGE" (AU SENS "LAGRANGIEN")
C
        GOTO 160

      ENDIF
C
C --- ON PASSE A L'ITERATION DE CONTRAINTES ACTIVES SUIVANTE
C
  150 CONTINUE
C
      ITER = ITER + 1
C
C --- A-T-ON DEPASSE LE NOMBRE D'ITERATIONS DE CONTACT AUTORISE ?
C
      IF (ITER.GT.ITEMAX+1) THEN
        CTCCVG = 1
        GOTO 999
      END IF
C
      GOTO 40
C
C ======================================================================
C                            ON A CONVERGE
C ======================================================================
C
  160 CONTINUE
C
C --- ON ENLEVE TOUTES LES LIAISONS DE CONTACT POUR LESQUELLES
C --- LA PRESSION EST NEGATIVE
C
      INDIC = 0
      CALL CFNEG (RESOCO,DEFICO,NOMA  ,NDIM  ,INDIC ,
     &            NBLIAI,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &            LLF1  ,LLF2  ,NBPREN)
C
C --- CALCUL DES FORCES DE CONTACT (AT.MU)
C
      CALL CFATMU(NEQ   ,NESMAX,NDIM  ,NBLIAC,0     ,
     &            LLF   ,LLF1  ,LLF2  ,RESOCO)
C
C --- CODE RETOUR
C
      CTCCVG = 0
C
C --- ETAT DES VARIABLES DE CONTROLE DU CONTACT
C
      CALL CFECRD(RESOCO,'NBLIAC',NBLIAC)
C
      IF ( NIV .GE. 2 ) THEN
        WRITE(IFM,1002) ITER
      END IF
C
C --- ATTENTE POINT FIXE
C
      IF ((NBPREN.NE.0).AND.(INDIC.NE.0)) THEN
        CTCFIX = .TRUE.
      ENDIF
C
  999 CONTINUE
C
C --- SAUVEGARDE DES INFOS DE DIAGNOSTIC
C
      CALL NMRVAI(SDSTAT,'CTCD_ALGO_ITER','E',ITER  )
      CALL NMRVAI(SDSTAT,'CONT_NBLIAC'   ,'E',NBLIAC)
C
      CALL JEDEMA()
C
 1001 FORMAT (' <CONTACT><CALC> DEBUT DES ITERATIONS (MAX: ',I6,')')
 1002 FORMAT (' <CONTACT><CALC> FIN DES ITERATIONS (NBR: ',I6,')')
C
      END
