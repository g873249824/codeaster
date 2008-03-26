      SUBROUTINE NMCHAR(MODE  ,PHASEZ,MODELE,NUMEDD,MATE  ,
     &                  CARELE,COMPOR,LISCHA,CARCRI,INST  ,
     &                  FONACT,PARMET,SOLVEU,VALMOI,VALPLU,
     &                  POUGD ,SECMBR,DEPALG,VEELEM,MEELEM,
     &                  MEASSE,SDSENS,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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
C TOLE CRP_21
C
      IMPLICIT NONE
      REAL*8        INST(*),PARMET(*)
      CHARACTER*4   MODE
      CHARACTER*(*) PHASEZ
      CHARACTER*19  LISCHA,SDDYNA,SOLVEU
      CHARACTER*24  MODELE,MATE,CARELE, NUMEDD
      CHARACTER*24  VALMOI(8),VALPLU(8),SECMBR(8),DEPALG(8),POUGD(8)
      CHARACTER*24  COMPOR,CARCRI,SDSENS
      LOGICAL       FONACT(*)
      CHARACTER*19  MEELEM(8),VEELEM(30)      
      CHARACTER*19  MEASSE(8)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
C
C COMMANDE STAT_NON_LINE   : CALCUL DES EFFORTS EXTERIEURS
C COMMANDE DYNA_TRAN_EXPLI : CALCUL DU SECOND MEMBRE
C      
C ----------------------------------------------------------------------
C 
C
C IN  MODE   : 'FIXE' -> CALCUL CHARGES FIXES
C              'SUIV' -> CALCUL CHARGES SUIVEUSES
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMPOR : COMPORTEMENT      (VIEUX THM) ('SUIV')
C IN  LISCHA : L_CHARGES
C IN  CARCRI : PARAMETRES LOCAUX (VIEUX THM) ('SUIV')
C IN  INST   : PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C IN  DEPMOI : DEPLACEMENT              ('SUIV')
C IN  DEPDEL : INCREMENT DE DEPLACEMENT ('SUIV')
C IN  COMPLU : VARIABLES DE COMMANDES A T+ (POUTRES)
C IN  OLDTHM : PARAMETRES POUR VIELLE VERSION THM (DANS VECGME)
C IN  NRPASE : NUMERO DU PARAMETRE SENSIBLE (0=CALCUL CLASSIQUE)
C IN  NBPASE : NOMBRE DE PARAMETRES SENSIBLES
C IN  INPSCO : SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C IN  SECOLD : SECOND MEMBRE A L'INSTANT PRECEDENT
C IN  CNFOLD : EFFORTS INTERIEURS A L'INSTANT PRECEDENT
C IN  FOPREC : BOOLEEN D'EXISTENCE DE SECOLD
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C I/O SECMBR : VECTEURS ASSEMBLES DES CHARGEMENTS ('FIXE' 'SUIV')
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C 
      REAL*8       INSTAP,INSTAM,COEFML, COEFM2
      LOGICAL      LDYNA
      LOGICAL      NDYNLO,FOPREC,LONDE,LSENSI,LIMPL,LEXPL
      INTEGER      NRPASE
      CHARACTER*24 CNFEDO,CNFEPI,CNDIDO,CNDIPI,CNFSDO,CNFSPI,CNCINE
      CHARACTER*24 K24BID
      CHARACTER*10 PHASE       
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
        WRITE (IFM,*) '<MECANONLINE><CHAR> CALCUL DU CHARGEMENT: ',MODE 
      ENDIF          
C
C --- INITIALISATIONS
C
      PHASE  = PHASEZ
      BASE   = 'V'    
C
C --- FONCTIONNALITES ACTIVEES
C    
      FOPREC = NDYNLO(SDDYNA,'FOPREC') 
      LONDE  = NDYNLO(SDDYNA,'ONDE_PLANE') 
      LIMPL  = NDYNLO(SDDYNA,'IMPLICITE')
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE')
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE') 
C
C --- PAS DE SENSIBILITE
C      
      LSENSI = .FALSE.
      NRPASE = 0         
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL DESAGG(SECMBR,CNFEDO,CNFEPI,CNDIDO,CNDIPI,
     &            CNFSDO,CNFSPI,K24BID,CNCINE)   
C
C --- COEFFICIENTS POUR DYNAMIQUE
C
      INSTAM = INST(1) - INST(2)
      INSTAP = INST(1)
      COEFML = 1.D0
      COEFM2 = -1.D0
      IF ( NDYNLO(SDDYNA,'HHT_COMPLET'))  THEN
        FOPREC = NDYNLO(SDDYNA,'FOPREC')
        IF (FOPREC) THEN
          COEFML = (INST(5)-0.5D0)/(1.5D0-INST(5))
        ENDIF
        COEFM2 = -1.D0/(1.5D0-INST(5))  
      ENDIF
      
C ======================================================================
C                            CHARGEMENTS FIXES
C ======================================================================
      IF (MODE.EQ.'FIXE') THEN

C -- DEPLACEMENTS IMPOSES DONNES                             ---> CNDIDO
 
        CALL NMCALV('DEPL_FIXE',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &              VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &              SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &              VEELEM)
          
        CALL NMASSV('DEPL_FIXE',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNDIDO)  

C -- DEPLACEMENTS IMPOSES PILOTES                            ---> CNDIPI

        CALL NMCALV('DEPL_PILO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &              VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &              SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &              VEELEM)

        CALL NMASSV('DEPL_PILO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNDIPI)  

C -- CHARGEMENTS FORCES DE LAPLACE                    

        CALL NMCALV('FORC_LAPLACE',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &              VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &              SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &              VEELEM)

C -- CHARGEMENTS ONDE_PLANE 

        IF (LONDE) THEN
          CALL NMCALV('FORC_ONDE_PLANE',
     &                MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                VEELEM)
        ENDIF

C -- AUTRES CHARGEMENTS MECANIQUES FIXES

        CALL NMCALV('FORC_FIXE_MECA',
     &                MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                VEELEM)

C -- CHARGEMENTS MECANIQUES PILOTES                         ---> CNFEPI

        CALL NMCALV('FORC_PILO',
     &                MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                VEELEM)

        CALL NMASSV('FORC_PILO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNFEPI)   

C -- CHARGEMENTS MECANIQUES DONNES                           ---> CNFEDO

        CALL NMASSV('FORC_FIXE',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNFEDO)               

C -- CONDITIONS CINEMATIQUES IMPOSEES  (AFFE_CHAR_CINE) ---> CNCINE

        CALL NMASSV('CINE_IMPO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNCINE)

C ======================================================================
C                        CHARGEMENTS SUIVEURS
C ======================================================================
      ELSE IF (MODE.EQ.'SUIV') THEN

C -- FORCES SUIVEUSES DONNEES

        CALL NMCALV('FORC_SUIV_IMPO',
     &                MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                VEELEM)

C -- FORCES SUIVEUSES D'INERTIE
       
        IF (LDYNA) THEN
          IF (LIMPL) THEN
            CALL NMCALV('FORC_INER',
     &                  MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                  INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                  VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                  SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                  VEELEM)
          ENDIF
          
          IF ((LEXPL.AND.PHASE.EQ.'PREDICTION').OR.LIMPL) THEN
            IF (PHASE.EQ.'PREDICTION') THEN
              CALL NMCALV('FORC_MODA_PRED',
     &                    MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                    INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                    VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                    SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                    VEELEM)
            ELSEIF (PHASE.EQ.'CORRECTION') THEN    
               CALL NMCALV('FORC_MODA_CORR',
     &                    MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                    INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                    VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                    SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                    VEELEM)           
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
     
            CALL NMCALV('FORC_AMOR',
     &                  MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                  INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                  VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                  SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                  VEELEM) 
     
            IF (PHASE.EQ.'PREDICTION') THEN
              CALL NMCALV('FORC_IMPE_PRED',
     &                    MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                    INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                    VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                    SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                    VEELEM) 
            ELSEIF (PHASE.EQ.'CORRECTION') THEN
              CALL NMCALV('FORC_IMPE_CORR',
     &                    MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                    INSTAM,INSTAP,CARCRI,PARMET,NUMEDD,
     &                    VALMOI,VALPLU,DEPALG,POUGD ,SDSENS,
     &                    SDDYNA,LSENSI,NRPASE,BASE  ,MEASSE,
     &                    VEELEM)
            ELSE
              WRITE(6,*) 'PHASE: ',PHASE
              CALL ASSERT(.FALSE.)
            ENDIF


          ENDIF 
        ENDIF
     
C -- ASSEMBLAGE
     
        CALL NMASSV('FORC_SUIV_IMPO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNFSDO)

C -- FORCES SUIVEUSES PILOTEES (NON IMPLANTEES -> VECTEUR NUL)

        CALL NMASSV('FORC_SUIV_PILO',
     &              MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &              SOLVEU,NUMEDD,FONACT,INSTAM,INSTAP,
     &              COEFML,COEFM2,SDDYNA,MEELEM,VALMOI,
     &              VALPLU,SECMBR,DEPALG,POUGD ,VEELEM,
     &              LSENSI,SDSENS,NRPASE,MEASSE,CNFSPI)
     
      ELSE
        CALL ASSERT(.FALSE.)
      END IF

      CALL JEDEMA()
      END
