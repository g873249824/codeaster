      SUBROUTINE NMETCR(MODELE,COMPOR,FONACT,SDDYNA,SDPOST,
     &                  DEFICO,RESOCO,SDIETO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/07/2011   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT     NONE
      CHARACTER*24 SDIETO,MODELE,COMPOR
      INTEGER      FONACT(*)
      CHARACTER*19 SDDYNA,SDPOST
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (GESTION IN ET OUT)
C
C CREATION DE LA SD IN ET OUT
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  COMPOR : CARTE COMPORTEMENT
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_FLAMB ET MODE_VIBR)
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  SDIETO : SD GESTION IN ET OUT
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER      ZIOCH,NBMAX
      PARAMETER    (ZIOCH = 10,NBMAX=16 )
      INTEGER      NBCHAM,NBCHIN,NBCHOU
      CHARACTER*24 IOINFO,IOLCHA
      INTEGER      JIOINF,JIOLCH
      INTEGER      ICHAM,ICH
      LOGICAL      NDYNLO,ISFONC,CFDISL
      LOGICAL      LXFCM,LDYNA,LXFFM,LXCZM,LCONT,LNOEU,LMUAP
      LOGICAL      LVIBR,LFLAM
      INTEGER      IFM,NIV
      LOGICAL      CHAACT(NBMAX)
C
      CHARACTER*24 NOMCHS(NBMAX),MOTCOB(NBMAX)
      CHARACTER*24 NOMGD(NBMAX),MOTCEI(NBMAX),LOCCHA(NBMAX)
      LOGICAL      LARCH(NBMAX),LETIN(NBMAX)
C -- NOM DU CHAMP DANS LA SD RESULTAT
      DATA NOMCHS  /'DEPL'        ,'SIEF_ELGA'   ,'VARI_ELGA'   ,
     &              'COMPORTEMENT','VITE'        ,'ACCE'        ,
     &              'INDC_ELGA'   ,'SECO_ELGA'   ,'COHE_ELGA'   ,
     &              'VALE_CONT'   ,'MODE_FLAMB'  ,'MODE_MECA'   ,
     &              'DEPL_ABSOLU' ,'VITE_ABSOLU' ,'ACCE_ABSOLU' ,
     &              'FORC_NODA'/
C -- NOM DE LA GRANDEUR
      DATA NOMGD   /'DEPL_R','SIEF_R','VARI_R',
     &              'COMPOR','DEPL_R','DEPL_R',
     &              'NEUT_I','NEUT_R','NEUT_R',
     &              'DEPL_R','DEPL_R','DEPL_R',
     &              'DEPL_R','DEPL_R','DEPL_R',
     &              'DEPL_R'/
C -- MOT-CLEF DANS ETAT_INIT, ' ' SI PAS DE MOT-CLEF
      DATA MOTCEI  /'DEPL','SIGM','VARI',
     &              ' '   ,'VITE','ACCE',
     &              ' '   ,' '   ,' '   ,
     &              ' '   ,' '   ,' '   ,
     &              ' '   ,' '   ,' '   ,
     &              ' '/
C -- LOCALISATION DU CHAMP
      DATA LOCCHA  /'NOEU','ELGA','ELGA',
     &              'ELGA','NOEU','NOEU',
     &              'ELEM','ELEM','ELEM',
     &              'NOEU','NOEU','NOEU',
     &              'NOEU','NOEU','NOEU',
     &              'NOEU'/ 
C -- .TRUE. SI CHAMP EST LU DANS ETAT_INIT
      DATA LETIN   /.TRUE. ,.TRUE. ,.TRUE. ,
     &              .FALSE.,.TRUE. ,.TRUE. ,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .FALSE.,.FALSE.,.FALSE.,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .FALSE./
C -- .TRUE. SI CHAMP EST ECRIT DANS ARCHIVAGE
      DATA LARCH   /.TRUE. ,.TRUE. ,.TRUE. ,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .TRUE. ,.TRUE. ,.TRUE. ,
     &              .FALSE./
C -- MOT-CLEF DANS OBSERVATION, ' ' SI PAS DE MOT-CLEF
      DATA MOTCOB  /'DEPL'        ,'SIEF_ELGA'   ,'VARI_ELGA'   ,
     &              ' '           ,'VITE'        ,'ACCE'        ,
     &              ' '           ,' '           ,' '           ,
     &              'VALE_CONT'   ,' '           ,' '           ,
     &              'DEPL_ABSOLU' ,'VITE_ABSOLU' ,'ACCE_ABSOLU' ,
     &              'FORC_NODA'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION DE LA SD GESTION'//
     &                ' IN ET OUT'
      ENDIF
C
C --- INITIALISATIONS
C
      NBCHAM = 0
      NBCHIN = 0
      NBCHOU = 0
      DO 1 ICHAM=1,NBMAX
        CHAACT(ICHAM) = .FALSE.
    1 CONTINUE
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE'  )
      LXFCM  = ISFONC(FONACT,'CONT_XFEM'  )
      LCONT  = ISFONC(FONACT,'CONTACT'    )
      LMUAP  = NDYNLO(SDDYNA,'MULTI_APPUI') 
      LFLAM  = ISFONC(FONACT,'CRIT_FLAMB' )
      LVIBR  = ISFONC(FONACT,'MODE_VIBR'  )
      IF (LXFCM) THEN
        LXFFM  = ISFONC(FONACT,'FROT_XFEM')
        LXCZM  = CFDISL(DEFICO,'EXIS_XFEM_CZM')
      ENDIF
C
C --- CHAMPS STANDARDS: DEPL/SIEF_ELGA/VARI_ELGA/FORC_NODA
C
      CHAACT(1)  = .TRUE.
      CHAACT(2)  = .TRUE.
      CHAACT(3)  = .TRUE.
      CHAACT(16) = .TRUE.
C
C --- CARTE COMPORTEMENT
C
      CHAACT(4) = .TRUE.
C
C --- CHAMPS DYNAMIQUE: VITE/ACCE
C
      IF (LDYNA) THEN
        CHAACT(5) = .TRUE.
        CHAACT(6) = .TRUE.
      ENDIF
C
C --- CHAMPS XFEM
C
      IF (LXFCM) THEN
        CHAACT(7) = .TRUE.
        IF (LXFFM) THEN
          CHAACT(8) = .TRUE.        
        ENDIF            
        IF (LXCZM) THEN
          CHAACT(9) = .TRUE.
        ENDIF
      ENDIF
C
C --- CONTACT
C      
      IF (LCONT) THEN
        LNOEU = CFDISL(DEFICO,'ALL_INTEG_NOEUD')
        IF (LNOEU) THEN
          CHAACT(10) = .TRUE.
        ENDIF
      ENDIF
C
C --- FLAMBEMENT
C
      IF (LFLAM) THEN
        CHAACT(11) = .TRUE.
      ENDIF
C
C --- MODES VIBRATOIRES
C
      IF (LVIBR) THEN
        CHAACT(12) = .TRUE.    
      ENDIF
C
C --- DEPL/VITE/ACCE D'ENTRAINEMENT EN MULTI-APPUIS
C
      IF (LMUAP) THEN
        CHAACT(13) = .TRUE.
        CHAACT(14) = .TRUE.
        CHAACT(15) = .TRUE.    
      ENDIF
C
C --- DECOMPTE DES CHAMPS
C
      DO 20 ICHAM = 1,NBMAX
        IF (CHAACT(ICHAM)) THEN
          NBCHAM = NBCHAM + 1
          IF (LETIN(ICHAM)) NBCHIN = NBCHIN + 1
          IF (LARCH(ICHAM)) NBCHOU = NBCHOU + 1
        ENDIF  
   20 CONTINUE        
C
C --- CREATION SD CHAMPS
C
      IOLCHA = SDIETO(1:19)//'.LCHA'
      CALL WKVECT(IOLCHA,'V V K24',NBCHAM*ZIOCH,JIOLCH)
C
C --- AJOUT DES CHAMPS
C
      ICH = 0
      DO 30 ICHAM = 1,NBMAX
        IF (CHAACT(ICHAM)) THEN
          ICH = ICH + 1
          CALL NMETCI(SDIETO,ZIOCH ,ICH   ,
     &                NOMCHS(ICHAM),NOMGD (ICHAM),
     &                MOTCEI(ICHAM),MOTCOB(ICHAM),
     &                LOCCHA(ICHAM),
     &                LETIN (ICHAM),LARCH (ICHAM))
        ENDIF  
   30 CONTINUE
      CALL ASSERT(ICH.EQ.NBCHAM)  
C
C --- NOM DES CHAMPS DANS OP0070
C      
      CALL NMETCC(SDIETO,COMPOR,SDDYNA,SDPOST,RESOCO,
     &            NBCHAM,ZIOCH )
C
C --- NOM DES CHAMPS NULS
C      
      CALL NMETC0(MODELE,SDIETO,COMPOR,RESOCO,NBCHAM,
     &            ZIOCH )
C
C --- CREATION SD INFOS
C
      IOINFO = SDIETO(1:19)//'.INFO'
      CALL WKVECT(IOINFO,'V V I',4,JIOINF)
      ZI(JIOINF+1-1) = NBCHAM
      ZI(JIOINF+2-1) = NBCHIN
      ZI(JIOINF+3-1) = NBCHOU 
      ZI(JIOINF+4-1) = ZIOCH 
C
      CALL JEDEMA()
      END
