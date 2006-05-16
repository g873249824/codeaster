      SUBROUTINE NMTHMC(COMP, MODELE, MOCLEF, K, COMEL, NCOMEL, NBNVI)
C =====================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/05/2006   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE UFBHHLL C.CHAVANT
C TOLE CRP_20
C =====================================================================
C --- BUT : DETERMINER LA COHERENCE DE LA RELATION DE COUPLAGE THM ----
C =====================================================================
      IMPLICIT      NONE
      INTEGER       NCOMEL, NBNVI(*), K
      CHARACTER*16  COMP, MOCLEF, COMEL(*)
      CHARACTER*24  MODELE
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

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
      CHARACTER*32     JEXNUM, JEXNOM, JEXATR

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C =====================================================================
C --- DEFINITION DES DIMENSIONS DES VECTEURS DE POSSIBILITE DES LOIS --
C =====================================================================
      LOGICAL       LTHMC, LHYDR, LMECA, EXIST, GETEXM, TOUT
      INTEGER       DMTHMC, DMHYDR, DMMECA, N1, JMAIL, ITYPEL
      INTEGER       NBMA, IERD, IBID, JNOMA, JMESM
      PARAMETER   ( DMTHMC = 7  )
      PARAMETER   ( DMHYDR = 3  )
      PARAMETER   ( DMMECA = 11 )
      CHARACTER*16  POTHMC(DMTHMC), MODELI, NOMTE,KBID
      CHARACTER*16  POHYDR(DMHYDR), POMECA(DMMECA)
      CHARACTER*16  THMC, THER, HYDR, MECA, MOCLES(2)
      CHARACTER*8   NOMA, TYPMCL(2)
      CHARACTER*24  MESMAI
C
      INTEGER       JJ, II, IM, IMA
C *********************************************************************
C --- DEBUT INITIALISATION ------------------------------------------ *
C *********************************************************************
      THMC = '        '
      THER = '        '
      HYDR = '        '
      MECA = '        '
C =====================================================================
C --- PARTIE THMC -----------------------------------------------------
C =====================================================================
      DATA POTHMC / 'LIQU_SATU'     ,
     +              'LIQU_GAZ'      ,
     +              'GAZ'           ,
     +              'LIQU_GAZ_ATM'  ,
     +              'LIQU_VAPE_GAZ' ,
     +              'LIQU_VAPE'     ,
     +              'LIQU_AD_GAZ_VAPE' /
C =====================================================================
C --- PARTIE HYDR -----------------------------------------------------
C =====================================================================
      DATA POHYDR / 'HYDR'      ,
     +              'HYDR_UTIL' ,
     +              'HYDR_ENDO' /
C =====================================================================
C --- PARTIE MECA -----------------------------------------------------
C =====================================================================
      DATA POMECA / 'ELAS'            ,
     +              'CJS'             ,
     +              'CAM_CLAY'        ,
     +              'BARCELONE'       ,
     +              'LAIGLE'          ,
     +              'HOEK_BROWN_EFF'  ,  
     +              'HOEK_BROWN_TOT'  ,  
     +              'ELAS_THER'       ,
     +              'MAZARS'          ,
     +              'ENDO_ISOT_BETON' ,
     +              'DRUCKER_PRAGER'  /
C *********************************************************************
C --- FIN INITIALISATION -------------------------------------------- *
C *********************************************************************
      CALL JEVEUO(MODELE(1:8)//'.MAILLE','L',JMAIL)
      CALL JEVEUO(MODELE(1:8)//'.MODELE    .NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
C =====================================================================
C --- LE COMPORTEMENT DEFINIT EST-IL COHERENT ? -----------------------
C =====================================================================
      LTHMC = .FALSE.
      LHYDR = .FALSE.
      LMECA = .FALSE.
      TOUT = .FALSE.
      MOCLES(1) = 'GROUP_MA'
      MOCLES(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
      MESMAI = '&&NMTHMC.MES_MAILLES'

      CALL RELIEM(MODELE,NOMA,'NU_MAILLE',MOCLEF,K,2,MOCLES,
     &           TYPMCL,MESMAI,NBMA)
     
      IF (NBMA.EQ.0) THEN
         CALL JELIRA(MODELE(1:8)//'.MAILLE','LONUTI',NBMA,KBID)
         TOUT=.TRUE.
      ELSE 
      CALL JEVEUO(MESMAI,'L',JMESM)
      ENDIF

      DO 1 IM = 1,NBMA
C =====================================================================
C --- COHERENCE DE LA LOI DE COUPLAGE ---------------------------------
C =====================================================================
         IF (TOUT) THEN
            IMA = IM
         ELSE
            IMA = ZI(JMESM+IM-1)
         ENDIF
         ITYPEL = ZI(JMAIL-1+IMA)
         IF (ITYPEL.NE.0) THEN
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
            CALL DISMTE('F','MODELISATION',NOMTE,IBID,MODELI,IERD)
            DO 5 JJ = 1, NCOMEL
              IF ((COMEL(JJ)(1:3).EQ.'GAZ').OR.
     &            (COMEL(JJ)(1:9).EQ.'LIQU_SATU').OR.
     &            (COMEL(JJ)(1:12).EQ.'LIQU_GAZ_ATM')) THEN

                  IF ((MODELI(1:6).NE.'3D_THM').AND.
     &                (MODELI(1:5).NE.'3D_HM').AND.
     &                (MODELI(1:8).NE.'AXIS_THM').AND.
     &                (MODELI(1:7).NE.'AXIS_HM').AND.
     &                (MODELI(1:10).NE.'D_PLAN_THM').AND.
     &                (MODELI(1:9).NE.'D_PLAN_HM').AND.
     &                (MODELI.NE.' ')) THEN

                         CALL UTMESS('F','NMTHMC','INCOMPATIBILITE '//
     &                     'ENTRE LA LOI DE COUPLAGE '//COMEL(JJ)//
     &                     ' ET LA MODELISATION CHOISI '//MODELI)
                  ENDIF

               ELSEIF ((COMEL(JJ)(1:13).EQ.'LIQU_VAPE_GAZ').OR.
     &                      (COMEL(JJ)(1:8).EQ.'LIQU_GAZ')) THEN
   
                  IF ((MODELI(1:6).NE.'3D_THH').AND.
     &                (MODELI(1:6).NE.'3D_HHM').AND.
     &                (MODELI(1:8).NE.'AXIS_THH').AND.
     &                (MODELI(1:8).NE.'AXIS_HHM').AND.
     &                (MODELI(1:10).NE.'D_PLAN_THH').AND.
     &                (MODELI(1:10).NE.'D_PLAN_HHM').AND.
     &                (MODELI.NE.' ')) THEN

                     CALL UTMESS('F','NMTHMC','INCOMPATIBILITE '//
     &                     'ENTRE LA LOI DE COUPLAGE '//COMEL(JJ)//
     &                     ' ET LA MODELISATION CHOISI '//MODELI)

                  ENDIF

               ELSEIF   (COMEL(JJ)(1:9).EQ.'LIQU_VAPE') THEN

                  IF ((MODELI(1:6).NE.'3D_THV').AND.
     &                (MODELI(1:8).NE.'AXIS_THV').AND.
     &                (MODELI(1:10).NE.'D_PLAN_THV').AND.
     &                (MODELI.NE.' ')) THEN

                      CALL UTMESS('F','NMTHMC','INCOMPATIBILITE '//
     &                  'ENTRE LA LOI DE COUPLAGE '//COMEL(JJ)//
     &                  ' ET LA MODELISATION CHOISI '//MODELI)
                  ENDIF

               ELSEIF  (COMEL(JJ)(1:16).EQ.'LIQU_AD_GAZ_VAPE') THEN

                  IF ((MODELI(1:9).NE.'AXIS_HH2M').AND.
     &                (MODELI(1:9).NE.'AXIS_THH2').AND.
     &                (MODELI(1:11).NE.'D_PLAN_HH2M').AND.
     &                (MODELI(1:11).NE.'D_PLAN_THH2').AND.
     &                (MODELI(1:11).NE.'D_PLAN_THH2').AND.
     &                (MODELI(1:7).NE.'3D_HH2M').AND.
     &                (MODELI(1:7).NE.'3D_THH2').AND.
     &                (MODELI.NE.' ')) THEN


                     CALL UTMESS('F','NMTHMC','INCOMPATIBILITE '//
     &                'ENTRE LA LOI DE COUPLAGE '//COMEL(JJ)//
     &                ' ET LA MODELISATION CHOISI '//MODELI)
                  ENDIF

               ENDIF

   5        CONTINUE
         ENDIF  
   1  CONTINUE

      DO 10 JJ=1, NCOMEL
C =====================================================================
C --- DEFINITION DE LA LOI DE COUPLAGE --------------------------------
C =====================================================================
         DO 20 II = 1, DMTHMC
            IF (COMEL(JJ).EQ.POTHMC(II)) THEN
               THMC = COMEL(JJ)
               IF ( LTHMC ) THEN
                  CALL UTMESS('F','NMTHMC_1','IL Y A DEJA UNE LOI '//
     +                                                  'DE COUPLAGE')
               ENDIF
               LTHMC = .TRUE.
               GOTO 10
            ENDIF
 20      CONTINUE
C =====================================================================
C --- DEFINITION DE LA LOI HYDRAULIQUE --------------------------------
C =====================================================================
         DO 40 II = 1, DMHYDR
            IF (COMEL(JJ).EQ.POHYDR(II)) THEN
               HYDR = COMEL(JJ)
               IF ( LHYDR ) THEN
                  CALL UTMESS('F','NMTHMC_3','IL Y A DEJA UNE LOI '//
     +                                                 'HYDRAULIQUE')
               ENDIF
               LHYDR = .TRUE.
               GOTO 10
            ENDIF
 40      CONTINUE
C =====================================================================
C --- DEFINITION DE LA LOI MECANIQUE ----------------------------------
C =====================================================================
         DO 50 II = 1, DMMECA
            IF (COMEL(JJ).EQ.POMECA(II)) THEN
               MECA = COMEL(JJ)
               IF ( LMECA ) THEN
                  CALL UTMESS('F','NMTHMC_4','IL Y A DEJA UNE LOI '//
     +                                                 'DE MECANIQUE')
               ENDIF
               LMECA = .TRUE.
               GOTO 10
            ENDIF
 50      CONTINUE
 10   CONTINUE
C =====================================================================
C --- VERIFICATION DE LA COHERENCE AVEC LA RELATION DEMANDEE ----------
C =====================================================================
C --- PARTIE KIT_HM ---------------------------------------------------
C =====================================================================
      IF (COMP.EQ.'KIT_HM') THEN
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_5','IL N Y A PAS DE LOI DE '//
     +                                                     'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_7','IL N Y A PAS DE LOI '//
     +                                                 'HYDRAULIQUE')
         ENDIF
         IF (.NOT.LMECA) THEN
            CALL UTMESS('F','NMTHMC_8','IL N Y A PAS DE LOI DE '//
     +                                                    'MECANIQUE')
         ENDIF
         IF ( THMC.NE.'LIQU_SATU'    .AND.
     +        THMC.NE.'GAZ'          .AND.
     +        THMC.NE.'LIQU_GAZ_ATM'      ) THEN
            CALL UTMESS('F','NMTHMC_9','LA LOI DE COUPLAGE EST '//
     +                          'INCORRECTE POUR UNE MODELISATION HM')
         ENDIF
         IF ( HYDR.EQ.'HYDR_ENDO'         .AND.
     +        ( MECA.NE.'MAZARS'          .AND.
     +          MECA.NE.'ENDO_ISOT_BETON'      ) ) THEN
            CALL UTMESS('F','NMTHMC_10','INCOMPATIBILITE DES '//
     +                       'COMPORTEMENTS MECANIQUE ET HYDRAULIQUE')
         ENDIF
         IF ( MECA.EQ.'ELAS_THER') THEN
            CALL UTMESS('F','NMTHMC_11','LOI DE MECANIQUE '//
     +                      'INCOMPATIBLE AVEC UNE MODELISATION HM')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' ) THEN
            CALL UTMESS('F','NMTHMC_50','LOI DE MECANIQUE '//
     +                      'INCOMPATIBLE AVEC UNE MODELISATION HM')
         ENDIF
C =====================================================================
C --- PARTIE KIT_HHM --------------------------------------------------
C =====================================================================
      ELSE IF (COMP.EQ.'KIT_HHM') THEN
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_12','IL N Y A PAS DE LOI DE '//
     +                                                     'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_14','IL N Y A PAS DE LOI '//
     +                                                 'HYDRAULIQUE')
         ENDIF
         IF (.NOT.LMECA) THEN
            CALL UTMESS('F','NMTHMC_15','IL N Y A PAS DE LOI DE '//
     +                                                    'MECANIQUE')
         ENDIF
         IF ( THMC.NE.'LIQU_GAZ'.AND.THMC.NE.'LIQU_VAPE_GAZ'.AND.
     +        THMC.NE.'LIQU_AD_GAZ_VAPE'      ) THEN
            CALL UTMESS('F','NMTHMC_16','LA LOI DE COUPLAGE EST '//
     +                         'INCORRECTE POUR UNE MODELISATION HHM')
         ENDIF
         IF ( HYDR.EQ.'HYDR_ENDO'         .AND.
     +        ( MECA.NE.'MAZARS'          .AND.
     +          MECA.NE.'ENDO_ISOT_BETON'      ) ) THEN
            CALL UTMESS('F','NMTHMC_17','INCOMPATIBILITE DES '//
     +                       'COMPORTEMENTS MECANIQUE ET HYDRAULIQUE')
         ENDIF
         IF ( MECA.EQ.'ELAS_THER' ) THEN
            CALL UTMESS('F','NMTHMC_18','LOI DE MECANIQUE '//
     +                                 'INCOMPATIBLE AVEC UNE LOI HHM')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' .AND.
     +        (THMC.NE.'LIQU_GAZ' .AND.
     +         THMC.NE.'LIQU_VAPE_GAZ')) THEN
            CALL UTMESS('F','NMTHMC_51','LOI DE MECANIQUE '//
     +                      'INCOMPATIBLE AVEC UNE MODELISATION HHM')
         ENDIF
C =====================================================================
C --- PARTIE KIT_THH --------------------------------------------------
C =====================================================================
      ELSE IF (COMP.EQ.'KIT_THH') THEN
         THER = 'THER'
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_19','IL N Y A PAS DE LOI DE '//
     +                                                     'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_21','IL N Y A PAS DE LOI '//
     +                                                 'HYDRAULIQUE')
         ENDIF
         IF (LMECA) THEN
            CALL UTMESS('F','NMTHMC_22','IL Y A UNE LOI DE '//
     +                                'MECANIQUE DANS LA RELATION THH')
         ENDIF
         IF ( THMC.NE.'LIQU_GAZ' .AND.THMC.NE.'LIQU_VAPE_GAZ'.AND.
     +        THMC.NE.'LIQU_AD_GAZ_VAPE'      ) THEN
            CALL UTMESS('F','NMTHMC_23','LA LOI DE COUPLAGE EST '//
     +                         'INCORRECTE POUR UNE MODELISATION THH')
         ENDIF
         IF ( MECA.EQ.'ELAS_THER' ) THEN
            CALL UTMESS('F','NMTHMC_24','LOI DE MECANIQUE '//
     +                                 'INCOMPATIBLE AVEC UNE LOI THH')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' ) THEN
            CALL UTMESS('F','NMTHMC_52','LOI DE MECANIQUE '//
     +                                 'INCOMPATIBLE AVEC UNE LOI THH')
         ENDIF
C =====================================================================
C --- PARTIE KIT_THV --------------------------------------------------
C =====================================================================
      ELSE IF (COMP.EQ.'KIT_THV') THEN
         THER = 'THER'
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_25','IL N Y A PAS DE LOI DE '//
     +                                                     'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_27','IL N Y A PAS DE LOI '//
     +                                                 'HYDRAULIQUE')
         ENDIF
         IF (LMECA) THEN
            CALL UTMESS('F','NMTHMC_28','IL Y A UNE LOI DE '//
     +                                'MECANIQUE DANS LA RELATION THV')
         ENDIF
         IF ( THMC.NE.'LIQU_VAPE' ) THEN
            CALL UTMESS('F','NMTHMC_29','LA LOI DE COUPLAGE EST '//
     +                          'INCORRECTE POUR UNE MODELISATION THV')
         ENDIF
         IF ( MECA.EQ.'ELAS_THER' ) THEN
            CALL UTMESS('F','NMTHMC_30','LOI DE MECANIQUE '//
     +                                 'INCOMPATIBLE AVEC UNE LOI THV')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' ) THEN
            CALL UTMESS('F','NMTHMC_53','LOI DE MECANIQUE '//
     +                                 'INCOMPATIBLE AVEC UNE LOI THV')
         ENDIF
C =====================================================================
C --- PARTIE KIT_THM --------------------------------------------------
C =====================================================================
      ELSE IF (COMP.EQ.'KIT_THM') THEN
         THER = 'THER'
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_31','IL N Y A PAS DE LOI DE '//
     +                                                      'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_33','IL N Y A PAS DE LOI '//
     +                                                   'HYDRAULIQUE')
         ENDIF
         IF (.NOT.LMECA) THEN
            CALL UTMESS('F','NMTHMC_34','IL N Y A PAS DE LOI DE '//
     +                                                     'MECANIQUE')
         ENDIF
         IF ( THMC.NE.'LIQU_SATU'     .AND.
     +        THMC.NE.'LIQU_GAZ_ATM'  .AND.
     +        THMC.NE.'GAZ'                ) THEN
            CALL UTMESS('F','NMTHMC_35','LA LOI DE COUPLAGE EST '//
     +                         'INCORRECTE POUR UNE MODELISATION THM')
         ENDIF
         IF ( HYDR.EQ.'HYDR_ENDO'         .AND.
     +        ( MECA.NE.'MAZARS'          .AND.
     +          MECA.NE.'ENDO_ISOT_BETON'      ) ) THEN
            CALL UTMESS('F','NMTHMC_36','INCOMPATIBILITE DES '//
     +                       'COMPORTEMENTS MECANIQUE ET HYDRAULIQUE')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' ) THEN
            CALL UTMESS('F','NMTHMC_54','LOI DE MECANIQUE '//
     +                      'INCOMPATIBLE AVEC UNE MODELISATION THM')
         ENDIF
C =====================================================================
C --- PARTIE KIT_THHM -------------------------------------------------
C =====================================================================
      ELSE IF (COMP.EQ.'KIT_THHM') THEN
         THER = 'THER'
         IF (.NOT.LTHMC) THEN
            CALL UTMESS('F','NMTHMC_38','IL N Y A PAS DE LOI DE '//
     +                                                      'COUPLAGE')
         ENDIF
         IF (.NOT.LHYDR) THEN
            CALL UTMESS('F','NMTHMC_40','IL N Y A PAS DE LOI '//
     +                                                   'HYDRAULIQUE')
         ENDIF
         IF (.NOT.LMECA) THEN
            CALL UTMESS('F','NMTHMC_41','IL N Y A PAS DE LOI DE '//
     +                                                     'MECANIQUE')
         ENDIF
         IF ( THMC.NE.'LIQU_VAPE_GAZ' .AND.
     +        THMC.NE.'LIQU_AD_GAZ_VAPE' .AND.
     +        THMC.NE.'LIQU_GAZ'           ) THEN
            CALL UTMESS('F','NMTHMC_42','LA LOI DE COUPLAGE EST '//
     +                         'INCORRECTE POUR UNE MODELISATION THHM')
         ENDIF
         IF ( HYDR.EQ.'HYDR_ENDO'         .AND.
     +        ( MECA.NE.'MAZARS'          .AND.
     +          MECA.NE.'ENDO_ISOT_BETON'      ) ) THEN
            CALL UTMESS('F','NMTHMC_43','INCOMPATIBILITE DES '//
     +                        'COMPORTEMENTS MECANIQUE ET HYDRAULIQUE')
         ENDIF
         IF ( MECA.EQ.'BARCELONE' .AND.
     +        (THMC.NE.'LIQU_GAZ' .AND.
     +        THMC.NE.'LIQU_VAPE_GAZ')) THEN
            CALL UTMESS('F','NMTHMC_55','LOI DE MECANIQUE '//
     +                     'INCOMPATIBLE AVEC UNE MODELISATION THHM')
         ENDIF
      ENDIF
C =====================================================================
C --- MISE A JOUR DES RELATIONS DE COMPORTEMENTS ----------------------
C =====================================================================
      COMEL(1) = THMC
      COMEL(2) = THER
      COMEL(3) = HYDR
      COMEL(4) = MECA
C ======================================================================
C --- POUR CHAQUE RELATION DE COMPORTEMENT PRESENTE ON RECUPERE --------
C --- LE NOMBRE DE VARIABLES INTERNES ASSOCIE A CETTE LOI --------------
C ======================================================================
C --- LOI DE COUPLAGE --------------------------------------------------
C ======================================================================
      EXIST = GETEXM(MOCLEF,COMEL(1))
      IF (EXIST) THEN
         CALL GETVIS(MOCLEF,COMEL(1),K,1,1,NBNVI(1),N1)
      ENDIF
C ======================================================================
C --- LOI DE THERMIQUE -------------------------------------------------
C ======================================================================
      EXIST = GETEXM(MOCLEF,COMEL(2))
      IF (EXIST) THEN
         CALL GETVIS(MOCLEF,COMEL(2),K,1,1,NBNVI(2),N1)
      ENDIF
C ======================================================================
C --- LOI HYDRAULIQUE --------------------------------------------------
C ======================================================================
      EXIST = GETEXM(MOCLEF,COMEL(3))
      IF (EXIST) THEN
         CALL GETVIS(MOCLEF,COMEL(3),K,1,1,NBNVI(3),N1)
      ENDIF
C ======================================================================
C --- LOI DE MECANIQUE -------------------------------------------------
C ======================================================================
      EXIST = GETEXM(MOCLEF,COMEL(4))
      IF (EXIST) THEN
         CALL GETVIS(MOCLEF,COMEL(4),K,1,1,NBNVI(4),N1)
      ENDIF
C =====================================================================
      END
