      SUBROUTINE NMCRGA(SDERRO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'
      CHARACTER*24 SDERRO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD GESTION ALGO)
C
C CREATION DE LA SD
C
C ----------------------------------------------------------------------
C
C NB: LA SD S'APPELLE SDERRO
C
C IN  SDERRO : SD ERREUR
C
C ----------------------------------------------------------------------
C
      INTEGER      ZEVEN
      PARAMETER   (ZEVEN = 33)
      CHARACTER*16 NEVEN(ZEVEN)
      CHARACTER*8  NCRET(ZEVEN)
      INTEGER      VCRET(ZEVEN)
      CHARACTER*16 TEVEN(ZEVEN)
      CHARACTER*24 FEVEN(ZEVEN),MEVEN(ZEVEN)
C
      INTEGER      IFM,NIV
      INTEGER      IEVEN
      CHARACTER*24 ERRECN,ERRECV,ERRENI,ERRENO,ERRAAC,ERRFCT,ERRMSG
      INTEGER      JEECON,JEECOV,JEENIV,JEENOM,JEEACT,JEEFCT,JEEMSG
      CHARACTER*24 ERRINF,ERRCVG,ERREVT
      INTEGER      JEINFO,JECONV,JEEEVT
C
C --- NOM DES EVENEMENTS
C
      DATA NEVEN   /'ERRE_INTE','INTE_NPHY','DIVE_DEBO',
     &              'INTE_BORN',
     &              'ERRE_PILO','CONV_PILO','ERRE_FACS',
     &              'ERRE_FACT','ERRE_CTD1','ERRE_CTD2',
     &              'ERRE_TIMN','ERRE_TIMP','ERRE_EXCP',
     &              'ITER_MAXI',
     &              'DIVE_RESI','RESI_MAXR','RESI_MAXN',
     &              'DIVE_PFIX','CRIT_STAB','DIVE_FIXG',
     &              'DIVE_FIXF','DIVE_FIXC','ERRE_CTCG',
     &              'ERRE_CTCF','ERRE_CTCC','DIVE_FROT',
     &              'DIVE_GEOM','DIVE_RELA','DIVE_MAXI',
     &              'DIVE_REFE','DIVE_COMP','DIVE_CTCC',
     &              'SOLV_ITMX'/
C
C --- NOM DU CODE RETOUR ATTACHE A L'EVENEMENT
C
      DATA NCRET   /'LDC','LDC','LDC',
     &              'LDC',
     &              'PIL','PIL','FAC',
     &              'FAC','CTC','CTC',
     &              'XXX','XXX','XXX',
     &              'XXX',
     &              'XXX','XXX','XXX',
     &              'XXX','XXX','XXX',
     &              'XXX','XXX','XXX',
     &              'XXX','XXX','XXX',
     &              'XXX','XXX','XXX',
     &              'XXX','XXX','XXX',
     &              'RES'/
C
C --- VALEUR DU CODE RETOUR CORRESPONDANT A CHAQUE EVENEMENT
C
      DATA VCRET   / 1 , 2, 3,
     &               4 ,
     &               1 , 2, 1,
     &               2 , 1, 2,
     &               99,99,99,
     &               99,
     &               99,99,99,
     &               99,99,99,
     &               99,99,99,
     &               99,99,99,
     &               99,99,99,
     &               99,99,99,
     &               1 /
C
C --- TYPE ET NIVEAU DE DECLENCHEMENT POSSIBLES DE L'EVENEMENT
C TROIS TYPES
C EVEN  : EVENEMENT A CARACTERE PUREMENT INFORMATIF
C          -> PEUT ETRE TRAITE SI UTILISATEUR LE DEMANDE DANS
C             DEFI_LIST_INST
C ERRI_ : EVENEMENT A TRAITER IMMEDIATEMENT SI ON VEUT CONTINUER
C ERRC_ : EVENEMENT A TRAITER A CONVERGENCE
C CONV_ : EVENEMENT A TRAITER POUR DETERMINER LA CONVERGENCE
C
      DATA TEVEN   /'ERRI_NEWT','ERRC_NEWT','CONV_NEWT',
     &              'EVEN'     ,
     &              'ERRI_NEWT','CONV_CALC','ERRI_NEWT',
     &              'ERRI_NEWT','ERRI_NEWT','ERRI_NEWT',
     &              'ERRI_CALC','ERRI_CALC','ERRI_CALC',
     &              'ERRI_NEWT',
     &              'EVEN'     ,'EVEN'     ,'EVEN'     ,
     &              'CONV_NEWT','EVEN'     ,'CONV_FIXE',
     &              'CONV_FIXE','CONV_FIXE','ERRI_FIXE',
     &              'ERRI_FIXE','ERRI_FIXE','CONV_RESI',
     &              'CONV_NEWT','CONV_RESI','CONV_RESI',
     &              'CONV_RESI','CONV_RESI','CONV_NEWT',
     &              'ERRI_NEWT'/
C
C --- FONCTIONNALITE ACTIVE SI NECESSAIRE POUR CONVERGENCE
C
      DATA FEVEN   /' ',' '       ,' ',
     &              ' ',
     &              ' ','PILOTAGE',' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              ' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              ' ',' '       ,' ',
     &              'LDLT_SP'/
C
C --- CODE DU MESSAGE A AFFICHER
C
      DATA MEVEN /
     &        'MECANONLINE10_1' ,'MECANONLINE10_24',' ',
     &        'MECANONLINE10_25',
     &        'MECANONLINE10_2' ,' '               ,'MECANONLINE10_6' ,
     &        'MECANONLINE10_6' ,'MECANONLINE10_4' ,'MECANONLINE10_4' ,
     &        'MECANONLINE10_7' ,'MECANONLINE10_5' ,'MECANONLINE10_8' ,
     &        'MECANONLINE10_3' ,
     &        ' '               ,' '               ,' '               ,
     &        ' '               ,'MECANONLINE10_20',' '               ,
     &        ' '               ,' '               ,'MECANONLINE10_9' ,
     &        'MECANONLINE10_10','MECANONLINE10_11',' '               ,
     &        ' '               ,' '               ,' '               ,
     &        ' '               ,' '               ,' '               ,
     &        'MECANONLINE10_12'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... LECTURE GESTION ALGORITHME'
      ENDIF
C
C --- GENERAL
C
      ERRINF = SDERRO(1:19)//'.INFO'
      CALL WKVECT(ERRINF,'V V I'  ,2,JEINFO)
      ZI(JEINFO-1+1) = ZEVEN
C
C --- OBJETS
C
      ERRENO = SDERRO(1:19)//'.ENOM'
      ERRECV = SDERRO(1:19)//'.ECOV'
      ERRECN = SDERRO(1:19)//'.ECON'
      ERRENI = SDERRO(1:19)//'.ENIV'
      ERRFCT = SDERRO(1:19)//'.EFCT'
      ERRAAC = SDERRO(1:19)//'.EACT'
      ERRCVG = SDERRO(1:19)//'.CONV'
      ERREVT = SDERRO(1:19)//'.EEVT'
      ERRMSG = SDERRO(1:19)//'.EMSG'
      CALL WKVECT(ERRENO,'V V K16',ZEVEN,JEENOM)
      CALL WKVECT(ERRECV,'V V I'  ,ZEVEN,JEECOV)
      CALL WKVECT(ERRECN,'V V K8' ,ZEVEN,JEECON)
      CALL WKVECT(ERRENI,'V V K16',ZEVEN,JEENIV)
      CALL WKVECT(ERRFCT,'V V K24',ZEVEN,JEEFCT)
      CALL WKVECT(ERRAAC,'V V I'  ,ZEVEN,JEEACT)
      CALL WKVECT(ERRCVG,'V V I'  ,5    ,JECONV)
      CALL WKVECT(ERREVT,'V V K16',2    ,JEEEVT)
      CALL WKVECT(ERRMSG,'V V K24',ZEVEN,JEEMSG)
C
      DO 10 IEVEN = 1,ZEVEN
        ZK16(JEENOM-1+IEVEN) = NEVEN(IEVEN)
        ZK8 (JEECON-1+IEVEN) = NCRET(IEVEN)
        ZI  (JEECOV-1+IEVEN) = VCRET(IEVEN)
        ZK16(JEENIV-1+IEVEN) = TEVEN(IEVEN)
        ZK24(JEEFCT-1+IEVEN) = FEVEN(IEVEN)
        ZK24(JEEMSG-1+IEVEN) = MEVEN(IEVEN)
 10   CONTINUE
C
      CALL JEDEMA()
      END
