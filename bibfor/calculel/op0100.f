      SUBROUTINE OP0100(IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 22/05/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C      OPERATEUR :     CALC_G
C
C      BUT:CALCUL DU TAUX DE RESTITUTION D'ENERGIE PAR LA METHODE THETA,
C          CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES, ...
C ======================================================================
C TOLE CRP_20
C
      IMPLICIT NONE
C 0.1  ==> ARGUMENTS
      INTEGER IER
C 0.2. ==> COMMUNS
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C 0.3. ==> VARIABLES LOCALES
C
      INTEGER IFM,NIV,NDEP,N1,N2,LONVEC,IORD,NBINST,IBID,I,NVITES,NACCE
      INTEGER NRES,NP,NC,NEXCI,L,NCHA,N3,IEXC,IRET,ICHA,IVEC,DIME,NBPRUP
      INTEGER IFOND,LNOFF,TYPESE,JINST,IAUX,JAUX,NBPASS,ADRECG,NRPASE
      INTEGER ADCHSE,ICHAR,NBPASE,NRPASS,NDEG,NBRE,IADNUM,IADRMA,IPROPA
      INTEGER ITHETA,NBR8,NBV,IADRCO,IADRNO,NBNO,J,IPULS,IORD1,IORD2
      INTEGER NBORN,NBCO,IBOR,IG,LNOEU,LABSCU,NBVAL,NBTYCH
      PARAMETER (NBTYCH=17)
C
      REAL*8  TIME,TIMEU,TIMEV,PREC,ALPHA,R8B,DIR(3)
      REAL*8  RINF,RSUP,MODULE,VAL(2),PULS
C
      COMPLEX*16 CBID
C
      CHARACTER*4 K4B
      CHARACTER*5 SUFFIX
      CHARACTER*6 NOMPRO,NOMLIG(NBTYCH)
      PARAMETER ( NOMPRO = 'OP0100' )
      CHARACTER*8 TABLE1,MODELE,MATERI,MODCHA,MODCHI,RESUCO,K8B,K8BID
      CHARACTER*8 FOND,FISS,TYPRUP(9),SYMECH,NOPASE,MATERS,AFFCHA,CRIT
      CHARACTER*8 LATABL,LERES0,NOMA,THETAI,NOEUD,TYPEPS(-2:NBTYCH)
      CHARACTER*13 INPSCO
      CHARACTER*16 TYPCO,OPER,OPTION,TYSD, NOPRUP(9),OPTIO1,SUITE
      CHARACTER*16 OPTIO2
      CHARACTER*19 GRLT,GRLN
      CHARACTER*19 OPTIO3
      CHARACTER*24 DEPLA,MATE,K24B,COMPOR,CHVITE,CHACCE,VECORD,VCHAR
      CHARACTER*24 SDTHET,CHFOND,BASLOC,CHDESE,CHEPSE,CHSISE,THETA
      CHARACTER*24 NORECG,MATES,CHARSE,NOMCHA,LIGRCH,LCHIN,STYPSE
      CHARACTER*24 BLAN24,LISSTH,LISSG,OBJMA,NOMNO,COORN
      CHARACTER*24 TRAV1,TRAV2,TRAV3,STOK4,THETLG
      CHARACTER*24 OBJ1,TRAV4,COURB,DEPLA1,DEPLA2
C
      LOGICAL EXITIM,EXCHSE,TROIDL,THLAGR,CONNEX,GLAGR,MILIEU,DIREC
C
      DATA NOMLIG/'.FORNO','.F3D3D','.F2D3D','.F1D3D','.F2D2D','.F1D2D',
     &     '.F1D1D','.PESAN','.ROTAT','.PRESS','.FELEC','.FCO3D',
     &     '.FCO2D','.EPSIN','.FLUX','.VEASS','.ONDPL'/
      DATA TYPEPS/'MATERIAU','CARAELEM','DIRICHLE','FORCE   ',
     &     'FORCE   ','FORCE   ','FORCE   ','FORCE   ','FORCE   ',
     &     'FORCE   ','.PESAN','.ROTAT','FORCE   ','.FELEC','FORCE   ',
     &     'FORCE   ','.EPSIN','.FLUX','.VEASS','.ONDPL'/
C
C==============
C 1. PREALABLES
C==============
C
      CALL JEMARQ()
C               12   345678   9012345678901234
      VCHAR  = '&&'//NOMPRO//'.CHARGES'
      COURB  = '&&'//NOMPRO//'.COURB'
      INPSCO = '&&'//NOMPRO//'_PSCO'
      NORECG = '&&'//NOMPRO//'_PARA_SENSI     '
C               123456789012345678901234
      BLAN24 = '                        '
C
C===============================
C  2. RECUPERATION DES OPERANDES
C===============================
C
C ---------------------------------------------
C 2.1. ==>  RECUPERATION DU NIVEAU D'IMPRESSION
C ---------------------------------------------
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
C-----------------------------------------------------
C 2.2. ==> LE CONCEPT DE SORTIE, SON TYPE, LA COMMANDE
C-----------------------------------------------------
      CALL GETRES(TABLE1,TYPCO,OPER)
      IF ( NIV.GE.2 ) THEN
        CALL UTMESS('I',NOMPRO,'CREATION DE LA TABLE '//TABLE1)
      ENDIF
C
C----------------
C 2.3. ==> OPTION
C----------------
      CALL GETVTX(' ','OPTION',0,1,1,OPTION,IBID)
C
C---------------------------------------------------------------
C 2.4. ==> RECUPERATION DU DEPLACEMENT A PARTIR DU MOT CLE DEPL
C          OU EXTRACTION D'UN OU PLUSIEURS DEPLACEMENTS A PARTIR
C          D'UN RESULTAT
C---------------------------------------------------------------
      CALL GETVID(' ','DEPL',0,1,1,DEPLA,NDEP)

      IF(NDEP.NE.0) THEN
        CALL CHPVER('F',DEPLA(1:19),'NOEU','DEPL_R',IER)
        CALL GETVID(' ','MODELE'    ,0,1,1,MODELE,N1)
        CALL GETVID(' ','CHAM_MATER',0,1,1,MATERI,N2)
        IF (N1.EQ.0 ) THEN
           CALL UTMESS('F',NOMPRO,'SI LE MOT-CLE DEPL EST PRESENT'//
     &                    ' ALORS LE MOT-CLE MODELE EST OBLIGATOIRE.')
        ENDIF
        IF (N2.EQ.0 ) THEN
           CALL UTMESS('F',NOMPRO,'SI LE MOT CLE DEPL EST PRESENT'//
     &                 ' ALORS LE MOT-CLE CHAM_MATER EST OBLIGATOIRE.')
        ENDIF
        CALL DISMOI('F','DIM_GEOM',MODELE,'MODELE',DIME,K8B,IER)
C
        CALL RCMFMC(MATERI,MATE)
        CALL NMDORC(MODELE,COMPOR,K24B)
        LONVEC = 1
        IORD = 0
        CALL GETVR8(' ','INST',0,1,0,R8B,NBINST)
        IF (NBINST.EQ.0) THEN
          EXITIM = .FALSE.
          TIME  = 0.D0
          TIMEU = 0.D0
          TIMEV = 0.D0
        ELSE
          NBINST = -NBINST
          IF(NBINST.GT.1) THEN
            CALL UTMESS('F',NOMPRO,'LA LISTE D''INSTANTS NE DOIT'
     &        //'COMPORTER QU''UN SEUL INSTANT AVEC LE MOT-CLE DEPL')
          ENDIF
          CALL GETVR8(' ','INST',0,1,NBINST,TIME,IBID)
          EXITIM = .TRUE.
          TIMEU = TIME
          TIMEV = TIME
        ENDIF
      ENDIF

      CHVITE = ' '
      CHACCE = ' '
      CALL GETVID(' ','VITE',0,1,1,CHVITE,NVITES)
      IF(NVITES.NE.0) THEN
        CALL CHPVER('F',CHVITE(1:19),'NOEU','DEPL_R',IER)
        CALL GETVID(' ','ACCE',0,1,1,CHACCE,NACCE)
        CALL CHPVER('F',CHACCE(1:19),'NOEU','DEPL_R',IER)
      ENDIF

      CALL GETVID (' ','RESULTAT',0,1,1,RESUCO,NRES)
      IF (NRES.NE.0) THEN
        VECORD = '&&'//NOMPRO//'.VECTORDR'
        CALL GETVR8(' ','PRECISION',0,1,1,PREC,NP)
        CALL GETVTX(' ','CRITERE'  ,0,1,1,CRIT,NC)
        CALL RSUTNU ( RESUCO, ' ', 0, VECORD, LONVEC, PREC, CRIT, IER )
        IF(IER.NE.0) THEN
          CALL UTMESS('F',NOMPRO,
     &                'PROBLEME A LA RECUPERATION D''UN CHAMP')
        ENDIF
        CALL GETTCO(RESUCO,TYSD)
        IF (TYSD.EQ.'DYNA_TRANS') THEN
           CALL GETVID(' ','MODELE'    ,0,1,1,MODELE,N1)
           CALL GETVID(' ','CHAM_MATER',0,1,1,MATERI,N2)
           CALL GETFAC('EXCIT',NEXCI)
           IF (N1.EQ.0 ) THEN
             CALL UTMESS('F',NOMPRO,'DANS LE CAS D''UNE SD RESULTAT'//
     &                    ' DE TYPE DYNA_TRANS, LE MOT-CLE MODELE EST'//
     &                    ' OBLIGATOIRE.')
           ENDIF
           IF (N2.EQ.0 ) THEN
             CALL UTMESS('F',NOMPRO,'DANS LE CAS D''UNE SD RESULTAT'//
     &                    ' DE TYPE DYNA_TRANS, LE MOT-CLE CHAM_MATER'//
     &                    ' EST OBLIGATOIRE.')
           ENDIF
           IF (NEXCI.EQ.0 ) THEN
             CALL UTMESS('F',NOMPRO,'DANS LE CAS D''UNE SD RESULTAT'//
     &                    ' DE TYPE DYNA_TRANS, LE MOT-CLE EXCIT'//
     &                    ' EST OBLIGATOIRE.')
           ENDIF
        ENDIF

        IF (((OPTION.EQ.'K_G_MODA') .AND. (TYSD.NE.'MODE_MECA')) .OR.
     &     ((TYSD.EQ.'MODE_MECA') .AND. (OPTION.NE.'K_G_MODA'))) THEN
          CALL UTMESS('F','OP0100','POUR UN RESULTAT DE TYPE '//
     &          'MODE_MECA L OPTION DE CALCUL DOIT ETRE K_G_MODA.')
        ENDIF

        CALL JEVEUO ( VECORD, 'L', IVEC )
        IORD = ZI(IVEC)
        CALL MEDOM1(MODELE,MATE,K8B,VCHAR,NCHA,K4B,RESUCO,IORD)
        CALL DISMOI('F','DIM_GEOM',MODELE,'MODELE',DIME,K8B,IER)
        CALL NMDORC(MODELE,COMPOR,K24B)
        CALL JEVEUO(VCHAR,'L',ICHA)
      ENDIF
C
C-----------------
C 2.5. ==> CHARGES
C------------------
      CALL GETVID(' ','DEPL',0,1,1,DEPLA,NDEP)
      IF(NDEP.NE.0) THEN
        CALL GETFAC('EXCIT',NEXCI)
          NCHA = 0
        IF (NEXCI .GT. 0) THEN
          DO 21 IEXC = 1,NEXCI
            CALL GETVID('EXCIT','CHARGE',IEXC,1,1,K24B,L)
            IF (L .EQ. 1) NCHA = NCHA + 1
 21       CONTINUE
          CALL JEEXIN(VCHAR,IRET)
          IF(IRET.NE.0) CALL JEDETR(VCHAR)
          N3=MAX(1,NCHA)
          CALL WKVECT(VCHAR,'V V K8',N3,ICHA)
          IF (NCHA .NE. 0) THEN
           DO 22 , I = 1,NCHA
             CALL GETVID('EXCIT','CHARGE',I,1,1,ZK8(ICHA+I-1),IBID)
 22        CONTINUE
           CALL DISMOI('F','NOM_MODELE',ZK8(ICHA),'CHARGE',IBID,
     &                  MODCHA,IER)
           IF (MODCHA.NE.MODELE) THEN
             CALL UTMESS('F',NOMPRO,'LES CHARGES NE S''APPUIENT PAS'
     &                         //' SUR LE MODELE DONNE EN ARGUMENT')
           ENDIF
           DO 23 , I = 1,NCHA
             CALL DISMOI('F','NOM_MODELE',ZK8(ICHA-1+I),'CHARGE',IBID,
     &                   MODCHI,IER)
             IF (MODCHI.NE.MODCHA) THEN
               CALL UTMESS('F',NOMPRO,'LES CHARGES NE '
     &                   // 'S''APPUIENT PAS TOUTES SUR LE MEME MODELE')
             ENDIF
  23       CONTINUE
          ENDIF
        ENDIF
      ENDIF
C
C------------------------------------------
C 2.6. ==> CAS: 2D, 3D LOCAL ou 3D GLOBAL ?
C------------------------------------------
      TROIDL=.FALSE.
      IF(DIME.EQ.3)THEN
         IF(OPTION.NE.'CALC_G_GLOB' .AND.
     &      OPTION.NE.'G_MAX_GLOB'  .AND.
     &      OPTION.NE.'G_BILI_GLOB' .AND.
     &      OPTION.NE.'G_LAGR_GLOB' )THEN
           TROIDL=.TRUE.
           CALL GETVID ( 'THETA','FOND_FISS', 1,1,1,K8B,N1)
           CALL GETVID ( 'THETA','FISSURE', 1,1,1, K8B,N2)
           IF(N2+N1.EQ.0)THEN
              CALL UTMESS('F',NOMPRO,'MOT CLE FOND_FISS'//
     &          ' OU FISSURE MANQUANT')
           ENDIF
         ENDIF
      ENDIF
C
C----------------
C 2.7. ==> THETA
C----------------  
      CALL GETVTX ( ' ', 'SYME_CHAR', 0,1,1, SYMECH,IBID)

      CALL GETVID ( 'THETA','THETA', 1,1,1, SDTHET,IRET)
      IF (TROIDL.AND.(OPTION.EQ.'CALC_G') .AND. (IRET.NE.0)) THEN
        CALL UTMESS('F',OPER,'CHAMP THETA CALCULE AUTOMATIQUEMENT')
      END IF
      IF(IRET.NE.0.AND.OPTION.EQ.'G_LAGR'.AND.TROIDL)THEN
        CALL UTMESS('F',NOMPRO,'POUR L OPTION '//OPTION//'(3D LOCAL)'//
     &     ' UTILISER LE MOT CLE THETA_LAGR')
      ENDIF
      IF(IRET.NE.0.AND.OPTION.EQ.'CALC_K_G'.AND.DIME.EQ.2)THEN
        CALL UTMESS('F',NOMPRO,'POUR L OPTION '//OPTION//', THETA'//
     &     ' DOIT ETRE CALCULE DANS '//NOMPRO)
      ENDIF

C ---  2.7.1 : THETA FOURNI
      IF(IRET.NE.0)THEN
        CALL GETTCO(SDTHET,TYPCO)
        IF (TYPCO(1:10).EQ.'THETA_GEOM') THEN
          CALL RSEXCH(SDTHET,'THETA',0,THETA,N1)
          IF (N1.GT.0) THEN
            CALL UTMESS('F',NOMPRO,'LE CHAMP DE THETA EST INEXISTANT '//
     &                 'DANS LA STRUCTURE DE DONNEES '//SDTHET//' DE '//
     &                 'TYPE THETA_GEOM .')
          ENDIF
        ELSE
          THETA=SDTHET
        ENDIF
      ENDIF

C ---  2.7.2 : THETA CALCULE
      IF(IRET.EQ.0 .AND. .NOT.(TROIDL))THEN

         OBJ1 = MODELE//'.MODELE    .NOMA'
         CALL JEVEUO ( OBJ1, 'L', IADRMA )
         NOMA = ZK8(IADRMA)
         THETA=TABLE1//'_CHAM_THETA'
         NOMNO = NOMA//'.NOMNOE'
         COORN = NOMA//'.COORDO    .VALE'
         CALL JEVEUO ( COORN, 'L', IADRCO )
         CALL GETVID ( 'THETA', 'FOND_FISS', 1,1,1, FOND, NBV )
         CALL GETVR8 ( 'THETA', 'DIRECTION', 1,1,0, R8B, NBR8) 
         DIREC=.FALSE.  
         IF ( NBR8 .NE. 0 ) THEN
            NBR8  = -NBR8
            SUITE='.'
            IF(DIME.EQ.2)THEN
              SUITE=',LA 3-EME NULLE.'
            ENDIF
            IF ( NBR8 .NE. 3 ) THEN
               CALL UTMESS('F',NOMPRO,'IL FAUT DONNER 3 '//
     &                   'COMPOSANTES DE LA DIRECTION'//SUITE)
            ELSE
               CALL GETVR8 ( 'THETA', 'DIRECTION', 1, 1, 3, DIR, NBR8 )
               DIREC=.TRUE.
            ENDIF
         ELSE
          IF(DIME.EQ.2)THEN
            CALL UTMESS('F',NOMPRO,
     &          'IL FAUT DONNER LA DIRECTION DE PROPAGATION EN 2D'//
     &          '    LA DIRECTION PAR DEFAUT N''EXISTE PLUS')
          ENDIF
         ENDIF

C      - THETA 2D (COURONNE) 
        IF(DIME.EQ.2)THEN 
          OPTIO3='COURONNE'
          CALL GVER2D ( NOMA,1,OPTIO3,'THETA',NOMNO, 
     &                 NOEUD, RINF, RSUP, MODULE )
          CALL GCOU2D ( THETA, NOMA, NOMNO, NOEUD, ZR(IADRCO), RINF, 
     &                    RSUP, MODULE, DIR )
C     - THETA 3D 
        ELSE IF(DIME.EQ.3)THEN
          CHFOND  = FOND//'.FOND      .NOEU'
          CALL JELIRA ( CHFOND, 'LONMAX', NBNO, K8B )
          CALL JEVEUO ( CHFOND, 'L', IADRNO )
          CALL GVERIG ( NOMA,1,CHFOND, NBNO, NOMNO, COORN,
     &                  TRAV1, TRAV2, TRAV3, TRAV4 )
          CALL GCOURO ( THETA, NOMA, NOMNO,COORN,NBNO,TRAV1,TRAV2,
     &                    TRAV3,DIR,ZK8(IADRNO),FOND,DIREC,STOK4)
        ENDIF
C
      ENDIF
C
C----------------------------------------------------
C 2.8. ==> FOND_FISS, FISSURE, LISSAGE, 
C          PROPAGATION (OPTIONS: G_LAGR,G_LAGR_GLOB)
C----------------------------------------------------
C
C    - PROPAGATION ALPHA
       CALL GETVR8(' ','PROPAGATION',0,1,1,ALPHA,IPROPA)
       IF (IPROPA.EQ.0) ALPHA = 0.D0
       IF ((OPTION(1:6).NE.'G_LAGR') .AND. (IPROPA.NE.0)) THEN
         CALL UTMESS('F',NOMPRO,'MOT CLE PROPAGATION UTILISE '//
     &       'SEULEMENT POUR LE CALCUL DE G AVEC '//
     &       'PROPAGATION LAGRANGIENNE')
       END IF
C
C 2.8.1 ==> SI 3D LOCAL :
      IF(TROIDL)THEN

C     - FOND_FISS ET FISSURE :
      IF ( OPTION.NE.'CALC_K_G' .AND. OPTION.NE.'K_G_MODA')THEN
        CALL GETVID ( 'THETA', 'FOND_FISS', 1,1,1,FOND,IFOND)
        CHFOND = FOND//'.FOND      .NOEU'
        CALL JELIRA(CHFOND,'LONMAX',LNOFF,K8B)
      ENDIF
      IF (OPTION .EQ. 'CALC_K_G' .OR. OPTION .EQ. 'K_G_MODA')THEN 
        CALL GETVID ( 'THETA','FISSURE', 1,1,1, FISS, IFOND )
        CHFOND = FISS//'.FONDFISS'
        CALL JELIRA(CHFOND,'LONMAX',LNOFF,K8B)
        LNOFF=LNOFF/4
        GRLT=FISS//'.GRLTNO'
        GRLN=FISS//'.GRLNNO'
        BASLOC=FISS//'.BASLOC'
      ENDIF

C     - METHODE DE DECOMPOSITION DE THETA ET G : LAGRANGE OU LEGENDRE
      CALL GETVTX('LISSAGE','LISSAGE_THETA',1,1,1,LISSTH,IBID)
      CALL GETVTX('LISSAGE','LISSAGE_G',1,1,1,LISSG,IBID)
      CALL GETVIS('LISSAGE','DEGRE',1,1,1,NDEG,IBID)
      IF ((LISSTH.EQ.'LEGENDRE') .AND. (LISSG.EQ.'LEGENDRE')) THEN
        THLAGR = .FALSE.
        GLAGR = .FALSE.
        NBRE = NDEG
      ELSE IF ((LISSTH.EQ.'LAGRANGE') .AND. (LISSG.EQ.'LEGENDRE')) THEN
        THLAGR = .TRUE.
        GLAGR = .FALSE.
        NBRE = LNOFF
        IF ((OPTION .EQ. 'G_MAX') .OR.
     &      (OPTION .EQ. 'G_BILI')) THEN
           CALL UTMESS('F',NOMPRO,'CETTE COMBINAISON DE LISSAGE '//
     &       'N''EST PAS PROGRAMMEE POUR L''OPTION : '//OPTION//'.')
        END IF
        IF (NDEG.GT.LNOFF) THEN
          CALL UTMESS('F',NOMPRO,'LE DEGRE DES POLYNOMES DE '//
     &        'LEGENDRE DOIT ETRE INFERIEUR OU EGAL AU NOMBRE '//
     &        'DE NOEUDS DU FOND DE FISSURE AVEC LA METHODE '//
     &        'THETA-LAGRANGE')
        END IF
      ELSE IF ((LISSTH.EQ.'LAGRANGE') .AND.
     &         ((LISSG.EQ.'LAGRANGE').OR. (LISSG.EQ.
     &         'LAGRANGE_NO_NO'))) THEN
        THLAGR = .TRUE.
        GLAGR = .TRUE.
        NBRE = LNOFF
      ELSE IF ((LISSTH.EQ.'LEGENDRE') .AND. (LISSG.NE.'LEGENDRE')) THEN
        CALL UTMESS('F',NOMPRO,'LE LISSAGE DE G DOIT ETRE DE TYPE '//
     &         'LEGENDRE SI LE LISSAGE DE THETA EST DE TYPE LEGENDRE')
      END IF

C    - PROPAGATION CHAMP THETA
      CALL GETVID(' ','THETA_LAGR',0,1,1,SDTHET,ITHETA)
      IF (ITHETA.EQ.0) THEN
        THETLG = ' '
      ELSE
        CALL RSEXCH(SDTHET,'THETA',0,THETLG,IRET)
        IF (IRET.NE.0) THEN
          CALL UTMESS('F',NOMPRO,'LE CHAMP DE THETA EST INEXISTANT '//
     &                'DANS LA STRUCTURE DE DONNEES '//SDTHET//' DE '//
     &                'TYPE THETA_GEOM .')
        END IF
      END IF
      IF ((OPTION.EQ.'G_LAGR') .AND. (ITHETA.EQ.0)) THEN
        CALL UTMESS('F',NOMPRO,'CHAMP THETA OBLIGATOIRE AVEC '//
     &        OPTION//'. UTILISER LE MOT CLE THETA_LAGR.')
      ENDIF
C 
C 2.8.2 ==> SI 2D
      ELSE IF(DIME.EQ.2)THEN
C
C        - FOND_FISS 2D
           CALL GETVID ( 'THETA', 'FOND_FISS', 1,1,1,FOND,IFOND)
           IF ( (OPTION .EQ. 'CALC_K_G') .AND. (IFOND.EQ.0) ) THEN
              CALL UTMESS('F', NOMPRO,'FOND OBLIGATOIRE AVEC '//
     &               'OPTION CALC_K_G')
           ENDIF
C
      ENDIF
C
C----------------------
C 2.9. ==> SENSIBILITE
C----------------------
C
C 2.9.1 ==> NOMBRE DE PASSAGES
C           RQ : POUR UN CALCUL STANDARD DE G, CE NOMBRE VAUT 1
C              12   345678
      K8BID = '&&'//NOMPRO
      IAUX = 1
      CALL PSLECT ( ' ', IBID, K8BID, TABLE1, IAUX,
     &              NBPASE, INPSCO, IRET )
      IAUX = 1
      JAUX = 1
      CALL PSRESE(' ',IBID,IAUX,TABLE1,JAUX,NBPASS,NORECG,IRET)
      CALL JEVEUO(NORECG,'L',ADRECG)
C
C 2.9.2 ==> A-T-ON UNE DEPENDANCE VIS-A-VIS D'UN MATERIAU ? (CF. NMDOME)
C
      DO 292 , NRPASE = 1 , NBPASE
C
        IAUX = NRPASE
        JAUX = 1
        MATERI = MATE(1:8)
        CALL PSNSLE ( INPSCO,IAUX,JAUX,NOPASE )
        CALL PSRENC ( MATERI,NOPASE,MATERS,IRET )
        IF (IRET.EQ.0) THEN
          CALL PSTYPA ( NBPASE, INPSCO, MATERI, NOPASE, TYPEPS(-2) )
          CALL RCMFMC ( MATERS,MATES )
        END IF
C
  292 CONTINUE
C
C 2.9.3 ==> A-T-ON UNE DEPENDANCE VIS-A-VIS D'UNE CHARGE ? (CF. NMDOME)
C
      EXCHSE = .FALSE.
      IF ( NCHA.NE.0 .AND. NBPASE.NE.0 ) THEN
C
        CHARSE = '&&'//NOMPRO//'.CHARSE'
        IAUX = MAX(NBPASE,1)
        CALL WKVECT(CHARSE,'V V K8',IAUX,ADCHSE)
C
        CALL GETFAC('EXCIT',NEXCI)
C
        DO 293 , ICHAR = 1 , NCHA
C
C 2.9.3.1. ==> LA CHARGE EST-ELLE CONCERNEE PAR UNE SENSIBILITE ?
C
          IF(NEXCI .GT. 0) THEN
            CALL GETVID('EXCIT','CHARGE',ICHAR,1,1,NOMCHA,N1)
          ELSE
            NOMCHA = ZK8(ICHA+ICHAR-1)
          ENDIF

          DO 2931 , NRPASE = 1 , NBPASE
            IAUX = NRPASE
            JAUX = 1
            CALL PSNSLE(INPSCO,IAUX,JAUX,NOPASE)
            CALL PSRENC ( NOMCHA,NOPASE,K8BID,IRET)
            IF (IRET.EQ.0) THEN
              ZK8(ADCHSE+NRPASE-1) = NOPASE
              EXCHSE = .TRUE.
            ELSE
              ZK8(ADCHSE+NRPASE-1) = '        '
            ENDIF
 2931     CONTINUE
C
  293   CONTINUE
C
C 2.9.3.2. ==> SI LA CHARGE EST CONCERNEE, ON AFFINE
C
        IF ( EXCHSE ) THEN
C
          LIGRCH = NOMCHA(1:8)//'.CHME.LIGRE'
C
          DO 2932 , IAUX = 1,NBTYCH
C
            IF (NOMLIG(IAUX).EQ.'.VEASS') THEN
              SUFFIX = '     '
            ELSE
              SUFFIX = '.DESC'
            END IF
            LCHIN = LIGRCH(1:13)//NOMLIG(IAUX)//SUFFIX
            CALL JEEXIN(LCHIN,IRET)
C
            IF (IRET.NE.0) THEN
C
              CALL DISMOI('F','TYPE_CHARGE',NOMCHA,'CHARGE',
     &                    IBID,AFFCHA,IRET)
C
              IF (AFFCHA(5:7).EQ.'_FO') THEN
                DO 29321 , NRPASE = 1 , NBPASE
                  NOPASE = ZK8(ADCHSE+NRPASE-1)
                  IF (NOPASE.NE.'        ') THEN
                    CALL TELLME('F','NOM_FONCTION',LCHIN(1:19),NOPASE,
     &                                K8BID,IRET)
                    IF (K8BID.EQ.'OUI') THEN
                      CALL PSTYPA ( NBPASE, INPSCO, NOMCHA, NOPASE,
     &                              TYPEPS(IAUX) )
                    ENDIF
                  ENDIF
29321           CONTINUE
              ENDIF
C
            ENDIF
C
 2932     CONTINUE
C
        ENDIF
C
      ENDIF
C
C
C=======================
C 3. CALCUL DE L'OPTION
C=======================
C
C============ DEBUT DE LA BOUCLE SUR LE NOMBRE DE PASSAGES =============
      DO 30 , NRPASS = 1 , NBPASS
C
C --- DECODAGE DES NOMS DES CONCEPTS
C        POUR LE PASSAGE NUMERO NRPASS :
C        . NOPASE : NOM DU PARAMETRE DE SENSIBILITE EVENTUELLEMENT
C        . LATABL : NOM DE LA TABLE A COMPLETER
C                   C'EST 'TABLE1' POUR UN CALCUL STANDARD, UN NOM
C                   COMPOSE A PARTIR DE 'TABLE1' ET 'NOPASE' POUR 
C                   UN CALCUL DE SENSIBILITE
C        . LERES0 : IDEM POUR RESUCO
C        . OPTIO1 : C'EST OPTION POUR UN CALCUL STANDARD, 'CALC_DG' POUR
C                   UN CALCUL DE SENSIBILITE

        NOPASE = ZK24(ADRECG+2*NRPASS-1) (1:8)
        LATABL = ZK24(ADRECG+2*NRPASS-2) (1:8)
C
        OPTIO1 = OPTION
C
C DANS LE CAS D'UN CALCUL STANDARD :

        IF (NOPASE.EQ.' ') THEN

          TYPESE = 0
          STYPSE = BLAN24
          CHDESE=' '
          CHEPSE=' '
          CHSISE=' '

C DANS LE CAS D'UN CALCUL DE DERIVE :
C     TYPESE  : TYPE DE SENSIBILITE
C               -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C                3 : DERIVATION PAR RAPPORT AU MODULE D'YOUNG
C                5 : DERIVATION PAR RAPPORT AU CHARGEMENT
C DANS CES 2 DERNIERS CAS, IL NE FAUT QU'UN SEUL PARAMETRE SENSIBLE
C A CHAQUE APPEL DE CALC_G_THETA
C
        ELSE
C
          CALL METYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)
          IF ( TYPESE.EQ.-1 ) THEN
            OPTIO1 = 'CALC_DG'
          ELSE IF ( TYPESE.EQ.3 ) THEN
            IF(DIME.EQ.2)THEN
              OPTIO1 = 'CALC_DG_E'
            ELSE
              OPTIO1 = 'CALC_DGG_E'
            ENDIF
            IF(OPTION.EQ.'CALC_K_G') OPTIO1 = 'CALC_DK_DG_E'
            IF(NBPASE.GE.2) THEN
              CALL UTMESS ('F', NOMPRO,
     &          'DERIVATION DE G : UN SEUL PARAMETRE SENSIBLE '//
     &          'PAR APPEL A CALC_G ')
            ENDIF
          ELSE IF ( TYPESE.EQ.5 ) THEN
            IF(DIME.EQ.2)THEN
              OPTIO1 = 'CALC_DG_FORC'
            ELSE
              OPTIO1 = 'CALC_DGG_FORC'
            ENDIF
            IF(OPTION.EQ.'CALC_K_G') OPTIO1 = 'CALC_DK_DG_FORC'
            IF(NBPASE.GE.2) THEN
              CALL UTMESS ('F', NOMPRO,
     &          'DERIVATION DE G : UN SEUL PARAMETRE SENSIBLE '//
     &          'PAR APPEL A CALC_G ')
            ENDIF
          ELSE
            CALL UTMESS ('F', NOMPRO,
     &  'ON NE SAIT PAS TRAITER LE TYPE DE SENSIBILITE '//
     &  'ASSOCIE AU PARAMETRE SENSIBLE '//NOPASE)
          ENDIF
          IF (NRES.NE.0) THEN
            CALL PSRENC ( RESUCO, NOPASE, LERES0, IRET )
            IF ( IRET.NE.0 ) THEN
              CALL UTMESS ('F', NOMPRO,
     &  'IMPOSSIBLE DE TROUVER LE RESULTAT DERIVE ASSOCIE AU RESULTAT '
     &  //RESUCO//' ET AU PARAMETRE SENSIBLE '//NOPASE)
            ENDIF
          ENDIF

        ENDIF
C
        IF ( NIV.GE.2 ) THEN
          IF ( NOPASE.NE.'        ' ) THEN
            CALL UTMESS('I',NOMPRO,'SENSIBILITE AU PARAMETRE '//NOPASE)
          ENDIF
        ENDIF
C
C --- DETERMINATION AUTOMATIQUE DE THETA (CAS 3D LOCAL)
C
      IF (TROIDL.AND. OPTIO1 .NE.'CALC_K_G' 
     &          .AND. OPTIO1 .NE.'K_G_MODA') THEN

      CALL JEVEUO(CHFOND,'L',IADNUM)
      IF (ZK8(IADNUM+1-1).EQ.ZK8(IADNUM+LNOFF-1)) THEN
        CONNEX = .TRUE.
      ELSE
        CONNEX = .FALSE.
      END IF
      IF ((CONNEX.AND. (.NOT.THLAGR)) .OR.
     &    (CONNEX.AND. (.NOT.GLAGR))) THEN
        CALL UTMESS('F',NOMPRO,'L USAGE DES POLYNOMES DE LEGENDRE'//
     &        ' DANS LE CAS D UN FOND DE FISSURE CLOS EST INTERDIT.')
      END IF
      OBJMA = MODELE//'.MODELE    .NOMA'
      THETAI = '&&THETA '
      CALL JEVEUO(OBJMA,'L',IADRMA)
      NOMA = ZK8(IADRMA)
      NOMNO = NOMA//'.NOMNOE'
      IF ((OPTIO1.EQ.'CALC_G') .OR.
     &    (OPTIO1.EQ.'G_BILI') .OR.
     &    (OPTIO1.EQ.'G_MAX')) THEN
        COORN = NOMA//'.COORDO    .VALE'
      ELSE
        CALL VTGPLD(NOMA//'.COORDO    ',ALPHA,THETLG,'V','&&GMETH1.G2')
        COORN = '&&GMETH1.G2        '//'.VALE'
      END IF
      CALL GVERI2(CHFOND,LNOFF,NOMNO,COORN,TRAV1,TRAV2,TRAV3,
     &            THLAGR,NDEG)
      CALL GCOUR2(THETAI,NOMA,MODELE,NOMNO,COORN,LNOFF,TRAV1,TRAV2,
     &            TRAV3,CHFOND,FOND,CONNEX,STOK4,THLAGR,NDEG,
     &            MILIEU)
      CALL GIMPT2(THETAI,NBRE,TRAV1,TRAV2,TRAV3,CHFOND,STOK4,LNOFF,0)


      ELSE IF((TROIDL.AND. OPTIO1 .EQ.'CALC_K_G').OR. 
     &        (TROIDL.AND. OPTIO1 .EQ.'K_G_MODA')) THEN

C       ON A TOUJOURS � FAIRE � UN FOND OUVERT AVEC XFEM
        CONNEX = .FALSE.
        THETAI = '&&THETA '
        OBJMA = MODELE//'.MODELE    .NOMA'
        CALL JEVEUO(OBJMA,'L',IADRMA)
        NOMA = ZK8(IADRMA)
        NOMNO = NOMA//'.NOMNOE'
        COORN = NOMA//'.COORDO    .VALE'
        CALL GVERI3(CHFOND,LNOFF,THLAGR,NDEG,TRAV1,TRAV2,TRAV3)
        CALL GCOUR3(THETAI,NOMA,MODELE,NOMNO,COORN,LNOFF,TRAV1,TRAV2,
     &              TRAV3,CHFOND,GRLT,.FALSE.,CONNEX,THLAGR,
     &              NDEG,MILIEU)
        CALL XCOURB(GRLT,GRLN,NOMA,MODELE,COURB)

      ENDIF
      IF(DIME.EQ.3)THEN
        CALL JEEXIN(TRAV1,IRET)
        IF (IRET.NE.0) CALL JEDETR(TRAV1)
        CALL JEEXIN(TRAV2,IRET)
        IF (IRET.NE.0) CALL JEDETR(TRAV2)      
        CALL JEEXIN(TRAV3,IRET)
        IF (IRET.NE.0) CALL JEDETR(TRAV3)
        CALL JEEXIN(STOK4,IRET)
        IF (IRET.NE.0) CALL JEDETR(STOK4)
      ENDIF

C --- CREATION DE LA TABLE
C
      NBPRUP=9
      CALL CGCRTB(LATABL,OPTIO1,DIME,TROIDL,NDEP,NRES,NBPRUP,
     &                  NOPRUP,TYPRUP)
C
C--------------------------------------------------------------
C 3.1. ==> CALCUL DE LA FORME BILINEAIRE DU TAUX DE RESTITUTION
C--------------------------------------------------------------
C
      IF (OPTIO1(1:6) .EQ.'G_BILI'.OR. OPTIO1(1:5) .EQ.'G_MAX') THEN

        DO 3111 I = 1 , LONVEC
          DO 3112 J = 1,I
            CALL JEMARQ()
            CALL JERECU('V')
            IF (NRES.NE.0) THEN
              IORD1 = ZI(IVEC-1+I)
              CALL MEDOM1(MODELE,MATE,K8B,VCHAR,NCHA,K4B,RESUCO,IORD1)
              CALL JEVEUO(VCHAR,'L',ICHA)
              CALL RSEXCH(RESUCO,'DEPL',IORD1,DEPLA1,IRET)
              IORD2 = ZI(IVEC-1+J)
              CALL RSEXCH(RESUCO,'DEPL',IORD2,DEPLA2,IRET)
              IF(IRET.NE.0) THEN
                CALL UTMESS('F',NOMPRO,
     &                      'ACCES IMPOSSIBLE AU DEPLACEMENT')
              ENDIF
              CALL RSADPA(RESUCO,'L',1,'INST',IORD1,0,JINST,K8BID)
              TIMEU = ZR(JINST)
              CALL RSADPA(RESUCO,'L',1,'INST',IORD2,0,JINST,K8BID)
              TIMEV = ZR(JINST)
              EXITIM = .TRUE.
            ELSE
              DEPLA1 = DEPLA
              DEPLA2 = DEPLA
            ENDIF
            OPTIO2 = 'G_BILI'
            IF(TROIDL)THEN
               CALL MBILGL(OPTIO2,LATABL,MODELE,DEPLA1,DEPLA2,THETAI,
     &                     MATE,NCHA,ZK8(ICHA),SYMECH,CHFOND,LNOFF,
     &                     NDEG,THLAGR,GLAGR,MILIEU,EXITIM,
     &                     TIMEU,TIMEV,I,J,NBPRUP,NOPRUP)
            ELSE
               CALL MEBILG(OPTIO2,LATABL,MODELE,DEPLA1,DEPLA2,THETA,
     &                     MATE,NCHA,ZK8(ICHA),SYMECH,EXITIM,TIMEU,
     &                     TIMEV,I,J,NBPRUP,NOPRUP )
            ENDIF
            CALL JEDEMA()
 3112       CONTINUE
 3111     CONTINUE
C
C----------------------------------------------------
C 3.2. ==> MAXIMISATION DU G SOUS CONTRAINTES BORNES
C----------------------------------------------------
C
          IF (OPTIO1(1:5) .EQ.'G_MAX') THEN

          CALL GETFAC ('BORNES', NBORN )
          IF (NBORN.NE.0) THEN
              NBCO = 2*NBORN
              CALL WKVECT('&&'//NOMPRO//'.COUPLES_BORNES','V V R8',
     &                   NBCO,IBOR)
              DO 3213 I=1, NBORN
                CALL GETVIS('BORNES','NUME_ORDRE',I,1,1,IORD,N1)
                CALL GETVR8('BORNES','VALE_MIN',I,1,1,
     &                      ZR(IBOR+2*(IORD-1)),N1)
                CALL GETVR8('BORNES','VALE_MAX',I,1,1,
     &                      ZR(IBOR+2*(IORD-1)+1),N1)
 3213         CONTINUE

            IF(TROIDL)THEN
              CALL TBEXVE(LATABL,'G_BILI_LOCAL',
     &                    '&&'//NOMPRO//'.GBILIN','V',NBVAL,K8B)
              CALL JEVEUO('&&'//NOMPRO//'.GBILIN','L',IG)
              CALL TBEXVE(LATABL,'NOEUD',
     &                    '&&'//NOMPRO//'.NOEUD','V',NBVAL,K8B)
              CALL JEVEUO('&&'//NOMPRO//'.NOEUD','L',LNOEU)
              CALL TBEXVE(LATABL,'ABSC_CURV',
     &                    '&&'//NOMPRO//'.ABSCUR','V',NBVAL,K8B)
              CALL JEVEUO('&&'//NOMPRO//'.ABSCUR','L',LABSCU)
C
              CALL DETRSD('TABLE',LATABL)
              CALL MMAXGL(NBCO,ZR(IBOR),ZR(IG),ZK8(LNOEU),
     &                    ZR(LABSCU),LONVEC,LNOFF,LATABL)
            ELSE
              CALL TBEXVE(LATABL,'G_BILIN',
     &                    '&&'//NOMPRO//'.GBILIN','V',NBVAL,K8B)
              CALL JEVEUO('&&'//NOMPRO//'.GBILIN','L',IG)
              CALL DETRSD('TABLE',LATABL)
              CALL MEMAXG(NBCO,ZR(IBOR),ZR(IG),LONVEC,LATABL)
            ENDIF

          ELSE
            CALL UTMESS('F',NOMPRO,'MOT-CLEF <BORNES> OBLIGATOIRE'//
     &                  ' AVEC L OPTION '//OPTIO1//' !')
          ENDIF
          ENDIF
C
C-------------------------------
C 3.3. ==> CALCUL DE KG (3D LOC)
C-------------------------------
C
       ELSE IF ( TROIDL .AND. OPTIO1 .EQ. 'CALC_K_G' ) THEN

          DO 33 I = 1,LONVEC
            IF (NRES.NE.0) THEN
              IORD = ZI(IVEC-1+I)
              CALL MEDOM1(MODELE,MATE,K8B,VCHAR,NCHA,K4B,RESUCO,IORD)
              CALL JEVEUO(VCHAR,'L',ICHA)
              CALL RSEXCH(RESUCO,'DEPL',IORD,DEPLA,IRET)
              IF (IRET.NE.0) THEN
                CALL UTDEBM('F',NOMPRO,'ACCES IMPOSSIBLE ')
                CALL UTIMPK('L',' CHAMP : ',1,'DEPL')
                CALL UTIMPI('S',', NUME_ORDRE : ',1,IORD)
                CALL UTFINM()
              END IF
              CALL RSADPA(RESUCO,'L',1,'INST',IORD,0,JINST,K8B)
              TIME = ZR(JINST)
              EXITIM = .TRUE.
            END IF

            CALL CAKG3D(OPTIO1,LATABL,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &              NCHA,ZK8(ICHA),SYMECH,CHFOND,LNOFF,BASLOC,COURB,
     &              IORD,NDEG,THLAGR,GLAGR,MILIEU,THETLG,ALPHA,EXITIM,
     &              TIME,NBPRUP,NOPRUP,FISS)
   33     CONTINUE
C
C------------------------
C 3.4. ==>OPTION K_G_MODA
C------------------------
C       
      ELSE IF (OPTIO1 .EQ. 'K_G_MODA') THEN
C
C  3.4.1 ==>  K_G_MODA 2D
C  -----------------------
       IF(.NOT.TROIDL)THEN
          DO 341 I = 1 , LONVEC
            IORD = ZI(IVEC-1+I) 
            CALL RSEXCH(RESUCO,'DEPL',IORD,DEPLA,IRET)
            IF(IRET.NE.0) THEN
              CALL UTMESS('F',NOMPRO,
     &                    'ACCES IMPOSSIBLE AU MODE PROPRE')
            ENDIF
            CALL RSADPA(RESUCO,'L',1,'OMEGA2',IORD,0,IPULS,K8BID) 
            PULS = ZR(IPULS)
            PULS = SQRT(PULS)
            CALL MEMOKG(OPTIO1,LATABL,MODELE,DEPLA,THETA,MATE,NCHA,
     &                  ZK8(ICHA),SYMECH,FOND,IORD,PULS,NBPRUP,NOPRUP)
 341     CONTINUE  
C
C  3.4.2 ==> K_G_MODA 3D LOC
C  -------------------------
       ELSE
          DO 342 I = 1,LONVEC
            IF (NRES.NE.0) THEN
              IORD = ZI(IVEC-1+I)
              CALL MEDOM1(MODELE,MATE,K8BID,VCHAR,NCHA,K4B,RESUCO,IORD)
              CALL JEVEUO(VCHAR,'L',ICHA)
              CALL RSEXCH(RESUCO,'DEPL',IORD,DEPLA,IRET)
              IF (IRET.NE.0) THEN
                CALL UTDEBM('F',OPER,'ACCES IMPOSSIBLE AU MODE PROPRE')
                CALL UTIMPK('L',' CHAMP : ',1,'DEPL')
                CALL UTIMPI('S',', NUME_ORDRE : ',1,IORD)
                CALL UTFINM()
              ENDIF
              CALL RSADPA(RESUCO,'L',1,'OMEGA2',IORD,0,IPULS,K8B)
              PULS = ZR(IPULS)
              PULS = SQRT(PULS)
              EXITIM = .TRUE.
            ENDIF
            CALL CAKGMO(OPTIO1,LATABL,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &              NCHA,ZK8(ICHA),SYMECH,CHFOND,LNOFF,BASLOC,COURB,
     &              IORD,NDEG,THLAGR,GLAGR,PULS,NBPRUP,NOPRUP,FISS)
 342     CONTINUE
       ENDIF
C
C--------------------------------------------
C 3.5. ==> CALCUL DE G, G_LAGR, K_G(2D) ET DG
C--------------------------------------------
C
      ELSE
        DO 35  I = 1 , LONVEC
          CALL JEMARQ()
          CALL JERECU('V')
          IF(NRES.NE.0) THEN
            IORD = ZI(IVEC-1+I)
            CALL MEDOM1(MODELE,MATE,K8B,VCHAR,NCHA,K4B,
     &      RESUCO,IORD)
            CALL JEVEUO(VCHAR,'L',ICHA)
            CALL RSEXCH(RESUCO,'DEPL',IORD,DEPLA,IRET)
            IF(IRET.NE.0) THEN
               CALL UTDEBM('F',OPER,'ACCES IMPOSSIBLE ')
               CALL UTIMPK('L',' CHAMP : ',1,'DEPL')
               CALL UTIMPI('S',', NUME_ORDRE : ',1,IORD)
               CALL UTFINM()            
            ENDIF
            CALL RSEXCH(RESUCO,'VITE',IORD,CHVITE,IRET)
            IF(IRET.NE.0) THEN
              CHVITE = ' '
            ELSE
              CALL RSEXCH(RESUCO,'ACCE',IORD,CHACCE,IRET)
            ENDIF
            CALL RSADPA(RESUCO,'L',1,'INST',IORD,0,JINST,K8B)
            TIME  = ZR(JINST)
            EXITIM = .TRUE.  
C
C       - RECUPERATION DES CHAMNO DE DERIVEE LAGRANGIENNE DE DEPLACEMENT
C         DANS LA SD RESULTAT DERIVE DE TYPE EVOL_ELAS.
            IF (OPTIO1.EQ.'CALC_DG') THEN
              CALL RSEXC2(1,1,LERES0,'DEPL',IORD,CHDESE,OPTIO1,IRET)
              IF (IRET.GT.0) THEN
                CALL UTDEBM('F',NOMPRO,'LA DERIVEE LAGRANGIENNE')
                CALL UTIMPI('L','DU DEPLACEMENT D''OCCURRENCE N ',1,
     &            IORD)
                CALL UTIMPK('L','EST INEXISTANT DANS LA SD ',1,RESUCO)
                CALL UTIMPK('L','DERIVEE PAR RAPPORT A ',1,NOPASE)
                CALL UTFINM()
              ENDIF
            ENDIF
C
            IF (OPTIO1.EQ.'CALC_DG_E'
     &      .OR. OPTIO1.EQ.'CALC_DG_FORC'
     &      .OR. OPTIO1.EQ.'CALC_DGG_E'
     &      .OR. OPTIO1.EQ.'CALC_DGG_FORC'
     &      .OR. OPTIO1.EQ.'CALC_DK_DG_E'
     &      .OR. OPTIO1.EQ.'CALC_DK_DG_FORC') THEN
              CALL RSEXC2(1,1,LERES0,'DEPL',IORD,CHDESE,OPTIO1,IRET)
              IF (IRET.GT.0) THEN
                CALL UTDEBM('F',NOMPRO,'LA DERIVEE ')
                CALL UTIMPI('L','DU DEPLACEMENT D''OCCURRENCE N ',1,
     &            IORD)
                CALL UTIMPK('L','EST INEXISTANTE DANS LA SD ',1,RESUCO)
                CALL UTIMPK('L','DERIVEE PAR RAPPORT A ',1,NOPASE)
                CALL UTFINM()
              ENDIF
              CALL RSEXC2(1,1,LERES0,'EPSI_ELGA_DEPL',IORD,CHEPSE,
     &                    OPTIO1,IRET)
              IF (IRET.GT.0) THEN
                CALL UTDEBM('F',NOMPRO,'LA DERIVEE ')
                CALL UTIMPI('L','DE LA DEFORMATION D''OCCURRENCE N ',1,
     &            IORD)
                CALL UTIMPK('L','EST INEXISTANTE DANS LA SD ',1,RESUCO)
                CALL UTIMPK('L','DERIVEE PAR RAPPORT A ',1,NOPASE)
                CALL UTFINM()
              ENDIF
              CALL RSEXC2(1,1,LERES0,'SIEF_ELGA_DEPL',IORD,
     &                    CHSISE,OPTIO1,IRET)
              IF (IRET.GT.0) THEN
                CALL UTDEBM('F',NOMPRO,'LA DERIVEE ')
                CALL UTIMPI('L','DE LA CONTRAINTE D''OCCURRENCE N ',1,
     &            IORD)
                CALL UTIMPK('L','EST INEXISTANTE DANS LA SD ',1,RESUCO)
                CALL UTIMPK('L','DERIVEE PAR RAPPORT A ',1,NOPASE)
                CALL UTFINM()
              ENDIF
            ENDIF
          ENDIF
C
      IF(    (OPTIO1.EQ.'CALC_G' .AND. DIME.EQ.2 )
     &   .OR. OPTIO1.EQ.'CALC_DG'
     &   .OR. OPTIO1.EQ.'CALC_DG_E'
     &   .OR. OPTIO1.EQ.'CALC_DG_FORC'
     &   .OR. OPTIO1.EQ.'CALC_DGG_E'
     &   .OR. OPTIO1.EQ.'CALC_DGG_FORC'
     &   .OR. OPTIO1.EQ.'CALC_G_GLOB') THEN
C
           CALL MECALG (OPTIO1,LATABL,MODELE,DEPLA,THETA,MATE,NCHA,
     &                   ZK8(ICHA),SYMECH,COMPOR,EXITIM,TIME,IORD,
     &                   NBPRUP,NOPRUP,NOPASE,TYPESE,CHDESE,
     &                   CHEPSE,CHSISE,CHVITE,CHACCE)
C
      ELSEIF((OPTIO1.EQ.'CALC_G'.OR.OPTIO1.EQ.'G_LAGR').AND.TROIDL)THEN
C
           CALL MECAGL(OPTIO1,LATABL,MODELE,DEPLA,THETAI,MATE,COMPOR,
     &              NCHA,ZK8(ICHA),SYMECH,CHFOND,LNOFF,IORD,NDEG,THLAGR,
     &              GLAGR,MILIEU,THETLG,ALPHA,EXITIM,TIME,NBPRUP,NOPRUP,
     &              CHVITE,CHACCE)
C
      ELSE IF ((OPTIO1 .EQ.'G_LAGR'.AND. DIME.EQ.2) .OR.
     &          OPTIO1 .EQ.'G_LAGR_GLOB' ) THEN
C
            CALL MLAGRG (OPTIO1,LATABL,MODELE,DEPLA,THETA,ALPHA,MATE,
     &                   NCHA,ZK8(ICHA),SYMECH,EXITIM,TIME,IORD,
     &                   NBPRUP, NOPRUP )
C
      ELSE IF (OPTIO1.EQ.'CALC_K_G' .AND. DIME.EQ.2) THEN
C
            CALL MEFICG (OPTIO1,LATABL,MODELE,DEPLA,THETA,MATE,NCHA,
     &                   ZK8(ICHA),SYMECH,FOND,EXITIM,TIME,IORD,
     &                   NBPRUP, NOPRUP, NOPASE,TYPESE,CHDESE,
     &                   CHEPSE,CHSISE,CHVITE,CHACCE)
C
      ELSE IF (OPTIO1.EQ.'CALC_DK_DG_E') THEN 
            OPTIO2 = 'CALC_DG_E'
            CALL MECALG (OPTIO2,LATABL,MODELE,DEPLA,THETA,MATE,NCHA,
     &                   ZK8(ICHA),SYMECH,COMPOR,EXITIM,TIME,IORD,
     &                   3,NOPRUP,NOPASE,TYPESE,CHDESE,
     &                   CHEPSE,CHSISE,CHVITE,CHACCE)
C
C         - LES DERIVEES DE KI ET KII SONT NULLES. 
C           ON LES AJOUTE DIRECTEMENT
            VAL(1) = 0.D0
            VAL(2) = 0.D0
            CALL TBAJLI(LATABL,2,NOPRUP(4),IORD,VAL,CBID,K8B,1)
      ELSE IF (OPTIO1.EQ.'CALC_DK_DG_FORC') THEN 
            CALL MEFICG (OPTIO1,LATABL,MODELE,DEPLA,THETA,MATE,NCHA,
     &                   ZK8(ICHA),SYMECH,FOND,EXITIM,TIME,IORD,
     &                   NBPRUP, NOPRUP, NOPASE,TYPESE,CHDESE,
     &                   CHEPSE,CHSISE,CHVITE,CHACCE)

      ELSE
           CALL UTMESS('F',NOMPRO,'OPTION NON DISPO ACTUELLEMENT')

      ENDIF

      CALL JEDEMA()
 35   CONTINUE

      ENDIF
C
      IF(NBPASE.GT.1)THEN
        K24B = BLAN24
        K24B(1:8)   = LATABL
        K24B(20:24) = '.TITR'
        CALL TITREA('T',LATABL,LATABL,K24B,'C',' ',0,'G' )
      ELSE
        CALL TITRE
      ENDIF

 30   CONTINUE
  
      CALL JEDETC('G','&&NMDORC',1)

      CALL JEDEMA()

      END
