      SUBROUTINE CRSDCO(NOMA,LISCHA,NUMEDD,NEQ,DEFICO,RESOCO)

C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/11/2004   AUTEUR MABBAS M.ABBAS 
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
C TOLE CRP_20
      IMPLICIT     NONE
      INTEGER      NEQ
      CHARACTER*8  NOMA
      CHARACTER*19 LISCHA
      CHARACTER*24 NUMEDD
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMINIT
C ----------------------------------------------------------------------
C
C CREATION DES STRUCTURES DE DONNEES NECESSAIRES AU TRAITEMENT
C DU CONTACT/FROTTEMENT (MOT-CLE "CONTACT" D'AFFE_CHAR_MECA).
C ROUTINE APPELEE AU DEBUT DE L'OPERATEUR STAT_NON_LINE.
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  LISCHA : SD L_CHARGES
C IN  NUMEDD : NUMEROTATION
C IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME ASSEMBLE
C OUT DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C              ON LA COMPLETE PAR :
C                - DDLCO  (NUMEROS DES DDL DES NOEUDS DE CONTACT)
C OUT RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32       JEXNUM
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZAPMEM
      PARAMETER    (ZAPMEM=4)
      INTEGER      ZAPPAR
      PARAMETER    (ZAPPAR=3)
      INTEGER      ZREAC
      PARAMETER    (ZREAC=4)
      INTEGER      IER,NEC,NCHAR,JCHAR,JINF,ICHA,ICON,JAPPAR,JAPMEM
      INTEGER      JAPCOE,JAPPTR,JAPJEU,JAPDDL,JPDDL,JTANGO
      INTEGER      INO,JDIM,JNOCO,JDDL,NNOCO,NUMNO,NUNOE,NESMAX,NDDL
      INTEGER      IZONE,NZOCO,JREAC,NDIM,NBLIAI,JZOCO,JCHAM,ICHAM,IDDL
      INTEGER      JBID,II,NBBLOC,JJEUIN,JNORMO,JNRINI
      INTEGER      JAPCOF,JAPJFX,JAPJFY
      CHARACTER*1  K1BID
      CHARACTER*8  K8BID,CHAR,NOMNO
      CHARACTER*19 COCO,LIAC,LIOT,MU,ATMU,DELT0,DELTA,CM1A,MATR,STOC
      CHARACTER*19 CM2A,CM3A,AFMU,CONVEC
      CHARACTER*24 NDIMCO,CONTNO,NOZOCO,CHAMCO,DDLCO,PDDL,APPARI,APMEMO
      CHARACTER*24 APCOEF,APPOIN,APJEU,APDDL,APREAC,COEFMU,JEUINI
      CHARACTER*24 APCOFR,APJEFX,APJEFY
      CHARACTER*24 NORINI,NORMCO,TANGCO
      INTEGER      IFM,NIV
      INTEGER      TYPALC,TYPALF,FROT3D,MATTAN,VERDIM
      REAL*8       TMAX,JEVTBL,TVALA,TVMAX,TV
      INTEGER      ITBLOC
      INTEGER      IDADIA,IDHCOL,IDABLO,IDIABL,IDDESC
      INTEGER      NBREEL,NEQU,NTBLC,HMAX,NBLC,IVALA,IEQUA,ICOMPT,I,J
      INTEGER      NBCOL,IBLC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
      CALL INFNIV(IFM,NIV)

C
C --- REPERAGE DE LA CHARGE CONTENANT DU CONTACT
C
      CALL JEEXIN (LISCHA // '.LCHA',IER)
      IF (IER.EQ.0) THEN 
        GOTO 9999
      ENDIF
      CALL JELIRA (LISCHA // '.LCHA','LONMAX',NCHAR,K8BID)
      CALL JEVEUO (LISCHA // '.LCHA','L',JCHAR)
      ICON = 0
      CALL JEVEUO (LISCHA // '.INFC','L',JINF)
      DO 10 ICHA = 1, NCHAR
         IF (ZI(JINF+2*NCHAR+2+ICHA).EQ.2) THEN
            CHAR = ZK24(JCHAR+ICHA-1)(1:8)
            ICON = ICON + 1
         END IF
 10   CONTINUE
C
C --- PAS DE CHARGES DE CONTACT
C
      IF (ICON.EQ.0) THEN
        DEFICO = '&&CRSDCO'
        GO TO 9999
      END IF
C
C --- PLUS D'UNE CHARGE DE CONTACT
C
      IF (ICON.GT.1) THEN
        CALL UTMESS ('F','CRSDCO','IL Y A PLUSIEURS '
     &               //'CHARGES CONTENANT DES CONDITIONS DE CONTACT ')
      END IF
C
C --- NOM DE LA SD DE DEFINITION DU CONTACT
C
      DEFICO = CHAR(1:8)//'.CONTACT'
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,RESOCO(1:14),TYPALC,TYPALF,FROT3D,MATTAN)
C
C --- SI METHODE CONTINUE, ON SORT
C
      IF (ABS(TYPALC).EQ.3) THEN
         GOTO 9999
      ENDIF


C ----------------------------------------------------------------------
C 
C  STRUCTURES COMMUNES POUR CONTACT ET FROTTEMENT
C
C ----------------------------------------------------------------------
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION DE LA SD RESULTAT DE CONTACT'
      END IF

      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      CALL JEVEUO (NDIMCO, 'E',JDIM)
      NDIM = ZI(JDIM)

      ATMU   = RESOCO(1:14)//'.ATMU'
      CALL JEEXIN (ATMU,IER)
      IF (IER.EQ.0) CALL WKVECT (ATMU,'V V R',NEQ,JBID)


C --- ARGUMENT POUR PREMIERE UTILISATION DU CONTACT OU NON
      CALL WKVECT (RESOCO(1:14) // '.PREM','V V L',1,JBID)
      ZL(JBID) = .TRUE.
C
C --- NUMEROS DE DDL DE TOUS LES NOEUDS DE CONTACT POTENTIELS
C
      NNOCO  = ZI(JDIM+4)
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      NOZOCO = DEFICO(1:16)//'.NOZOCO'
      CHAMCO = DEFICO(1:16)//'.CHAMCO'
      CALL JEVEUO (CONTNO, 'L',JNOCO)
      CALL JEVEUO (NOZOCO, 'L',JZOCO)
      CALL JEVEUO (CHAMCO, 'L',JCHAM)
C
C - POINTEUR
C
      PDDL  = DEFICO(1:16)//'.PDDLCO'
      CALL WKVECT (PDDL,'V V I',NNOCO+1,JPDDL)
      ZI(JPDDL) = 0
      NDDL = 0
C
C --- VERIFICATION DE LA COHERENCE DES DIMENSIONS
C
      VERDIM = 0
      IF (NDIM.GT.3) THEN
         DO 24 INO = 1,NNOCO
           NUMNO = ZI(JNOCO+INO-1)
           CALL JENUNO (JEXNUM(NOMA//'.NOMNOE',NUMNO),NOMNO)
           IZONE = ZI(JZOCO+INO-1)
           ICHAM = ZI(JCHAM+IZONE-1)

           IF ((ICHAM.EQ.1).OR.(ICHAM.EQ.-1)) THEN
            CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'DZ',
     &                              JBID,VERDIM)
           END IF
           IF (VERDIM.NE.0) THEN
            CALL UTMESS('F','CRSDCO','MELANGE 2D ET 3D DANS LE CONTACT')
           ENDIF
 24     CONTINUE
        ZI(JDIM) = 2
        NDIM = 2
      ENDIF
C
      DO 20 INO = 1,NNOCO
        IZONE = ZI(JZOCO+INO-1)
        ICHAM = ZI(JCHAM+IZONE-1)
        IF ((ICHAM.EQ.1).OR.(ICHAM.EQ.-1)) THEN
            NDDL = NDDL + NDIM
            ZI(JPDDL+INO) = NDDL
        ELSE IF (ICHAM.EQ.-2) THEN
          NDDL = NDDL + 1
          ZI(JPDDL+INO) = NDDL
        ELSE IF (ICHAM.EQ.-3) THEN
          NDDL = NDDL + 1
          ZI(JPDDL+INO) = NDDL
        ELSE IF (ICHAM.EQ.-4) THEN
          NDDL = NDDL + 1
          ZI(JPDDL+INO) = NDDL
        ELSE IF (ICHAM.EQ.-5) THEN
          NDDL = NDDL + 1
          ZI(JPDDL+INO) = NDDL
        END IF
 20   CONTINUE
C
C - NUMEROS DE DDL
C
      DDLCO = DEFICO(1:16)//'.DDLCO'
      CALL WKVECT (DDLCO,'V V I',NDDL,JDDL)
C
      DO 25 INO = 1,NNOCO
        NUMNO = ZI(JNOCO+INO-1)
        CALL JENUNO (JEXNUM(NOMA//'.NOMNOE',NUMNO),NOMNO)
        IZONE = ZI(JZOCO+INO-1)
        ICHAM = ZI(JCHAM+IZONE-1)
        IDDL = ZI(JPDDL+INO-1) + 1
        IF ((ICHAM.EQ.1).OR.(ICHAM.EQ.-1)) THEN
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'DX',NUNOE,
     &                 ZI(JDDL+IDDL-1))
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'DY',NUNOE,
     &                 ZI(JDDL+IDDL))
          IF (NDIM.EQ.3) CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'DZ',
     &                                NUNOE,ZI(JDDL+IDDL+1))
        ELSE IF (ICHAM.EQ.-2) THEN
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'PRES',NUNOE,
     &                 ZI(JDDL+IDDL-1))
        ELSE IF (ICHAM.EQ.-3) THEN
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'TEMP',NUNOE,
     &                 ZI(JDDL+IDDL-1))
        ELSE IF (ICHAM.EQ.-4) THEN
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'PRE1',NUNOE,
     &                 ZI(JDDL+IDDL-1))
        ELSE IF (ICHAM.EQ.-5) THEN
          CALL POSDDL ('NUME_DDL',NUMEDD,NOMNO,'PRE2',NUNOE,
     &                 ZI(JDDL+IDDL-1))
        END IF
 25   CONTINUE
C
C --- CREATION DES TABLEAUX D'APPARIEMENT (DIMENSIONNES AU MAX)
C
      NESMAX = ZI(JDIM+8)
C
      APPARI = RESOCO(1:14)//'.APPARI'
      APMEMO = RESOCO(1:14)//'.APMEMO'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APJEU  = RESOCO(1:14)//'.APJEU'
      APDDL  = RESOCO(1:14)//'.APDDL'
      JEUINI = RESOCO(1:14)//'.JEUINI'
C
      CALL WKVECT (APPARI,'V V I',ZAPPAR*NESMAX+1,JAPPAR)
      CALL WKVECT (APMEMO,'V V I',ZAPMEM*NNOCO   ,JAPMEM)
      CALL WKVECT (APCOEF,'V V R',30*NESMAX ,JAPCOE)
      CALL WKVECT (APPOIN,'V V I',NESMAX+1  ,JAPPTR)
      CALL WKVECT (APJEU ,'V V R',NESMAX    ,JAPJEU)
      CALL WKVECT (APDDL ,'V V I',30*NESMAX ,JAPDDL)
      CALL WKVECT (JEUINI,'V V R',NESMAX    ,JJEUIN)
C
C --- DIMENSIONNEMENT DES VECTEURS NORMAUX ET TANGENT
C
      NORINI = RESOCO(1:14)//'.NORINI'
      NORMCO = RESOCO(1:14)//'.NORMCO'
      TANGCO = RESOCO(1:14)//'.TANGCO'
      CALL WKVECT (NORINI,'V V R', 3*NNOCO ,JNRINI)
      CALL WKVECT (NORMCO,'V V R', 3*NESMAX,JNORMO)
      CALL WKVECT (TANGCO,'V V R', 6*NESMAX,JTANGO)
C
      ZI(JAPPAR) = NESMAX
C
C --- INDICATEURS DE REACTUALISATION
C
      NZOCO  = ZI(JDIM+1)
      APREAC = RESOCO(1:14)//'.APREAC'
      CALL WKVECT (APREAC,'V V I',ZREAC*NZOCO,JREAC)
      DO 30 IZONE = 1,NZOCO
        ZI(JREAC+ZREAC*(IZONE-1)  ) = 1
        ZI(JREAC+ZREAC*(IZONE-1)+1) = 0
        ZI(JREAC+ZREAC*(IZONE-1)+2) = 1
        ZI(JREAC+ZREAC*(IZONE-1)+3) = 0
 30   CONTINUE

C ======================================================================
C --- VECTEURS DE TRAVAIL ----------------------------------------------
C ======================================================================
      COCO   = RESOCO(1:14)//'.COCO'
      LIAC   = RESOCO(1:14)//'.LIAC'
      LIOT   = RESOCO(1:14)//'.LIOT'      
      MU     = RESOCO(1:14)//'.MU'
      COEFMU = RESOCO(1:14)//'.COEFMU'
      DELT0  = RESOCO(1:14)//'.DEL0'
      DELTA  = RESOCO(1:14)//'.DELT'
      CONVEC = RESOCO(1:14)//'.CONVEC'
C ======================================================================
C --- VECTEUR COCO : ---------------------------------------------------
C ---       JBID 0 : DIMENSION -----------------------------------------
C ---       JBID 1 : INDIC VAUT 1 LORSQU'ON AJOUTE UNE LIAISON ---------
C ---              :       VAUT 0 LORSQU'ON SUPPRIME UNE LIAISON -------
C ---       JBID 2 : NOMBRE DE LIAISON DE CONTACT ----------------------
C ---       JBID 3 : POSITION DE LA LIAISON AJOUTEE --------------------
C ---       JBID 4 : POSITION DE LA LIAISON SUPPRIMEE ------------------
C ---       JBID 5 : NOMBRE DE LIAISON DE FROTTEMENT (DEUX DIRECTIONS) -
C ---       JBID 6 : NOMBRE DE LIAISON DE FROTTEMENT (1ERE DIRECTION ) -
C ---       JBID 7 : NOMBRE DE LIAISON DE FROTTEMENT (2EME DIRECTION ) -
C ======================================================================
      CALL JEEXIN (COCO,IER)
      IF (IER.EQ.0) CALL WKVECT (COCO,'V V I',8,JBID)
      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NEC,K1BID,IER)
      ZI(JBID  ) = NDIM
      ZI(JBID+1) = 0
      ZI(JBID+2) = 0
      ZI(JBID+3) = 0
      ZI(JBID+4) = 1
      ZI(JBID+5) = 0
      ZI(JBID+6) = 0
      ZI(JBID+7) = 0
C
      CALL JEEXIN (LIAC,IER)
      IF (IER.EQ.0) CALL WKVECT (LIAC,'V V I',3*NESMAX+1,JBID)
C
      CALL JEEXIN (LIOT,IER)
      IF (IER.EQ.0) CALL WKVECT (LIOT,'V V I',4*NESMAX+4,JBID)
C
      CALL JEEXIN (MU,IER)
      IF (IER.EQ.0) CALL WKVECT (MU,'V V R',6*NESMAX,JBID)
C
      CALL JEEXIN (COEFMU,IER)
      IF (IER.EQ.0) CALL WKVECT (COEFMU,'V V R',NESMAX,JBID)
C
      CALL JEEXIN (DELT0,IER)
      IF (IER.EQ.0) CALL WKVECT (DELT0,'V V R',NEQ,JBID)
C
      CALL JEEXIN (DELTA,IER)
      IF (IER.EQ.0) CALL WKVECT (DELTA,'V V R',NEQ,JBID)
C ======================================================================
C --- VECTEUR CONVEC : -------------------------------------------------
C ---        VAUT C0 : LIAISON DE CONTACT ------------------------------
C ---        VAUT F0 : LIAISON DE FROTTEMENT ADHERENT (DEUX DIRECTIONS)-
C ---        VAUT F1 : LIAISON DE FROTTEMENT ADHERENT (1ERE DIRECTION )-
C ---        VAUT F2 : LIAISON DE FROTTEMENT ADHERENT (2EME DIRECTION )-
C ======================================================================
      CALL JEEXIN (CONVEC,IER)
      IF (IER.EQ.0) CALL WKVECT (CONVEC,'V V K8',2*NESMAX,JBID)


C ----------------------------------------------------------------------
C 
C  STRUCTURES RESERVEES POUR LE FROTTEMENT
C
C ----------------------------------------------------------------------

      IF (TYPALF.NE.0) THEN
        AFMU   = RESOCO(1:14)//'.AFMU'
        CALL JEEXIN (AFMU,IER)
        IF (IER.EQ.0) CALL WKVECT (AFMU,'V V R',NEQ,JBID)

        APCOFR = RESOCO(1:14)//'.APCOFR'
        CALL WKVECT (APCOFR,'V V R',60*NESMAX ,JAPCOF)

        APJEFX = RESOCO(1:14)//'.APJEFX'
        APJEFY = RESOCO(1:14)//'.APJEFY'
        CALL WKVECT (APJEFX,'V V R',NESMAX    ,JAPJFX)
        CALL WKVECT (APJEFY,'V V R',NESMAX    ,JAPJFY)    

      ENDIF

C CAS DE LA METHODE PENALISEE: ON UTILISE AFMU
      IF (ABS(TYPALC).EQ.1) THEN
        AFMU   = RESOCO(1:14)//'.AFMU'
        CALL JEEXIN (AFMU,IER)
        IF (IER.EQ.0) CALL WKVECT (AFMU,'V V R',NEQ,JBID)
      ENDIF


C ----------------------------------------------------------------------
C 
C  OBJETS ASSOCIES AUX MATRICES
C
C ----------------------------------------------------------------------
C
      NBLIAI = NESMAX
      NBBLOC = 1 
C
      CM1A   = RESOCO(1:14)//'.CM1A'
      CM2A   = RESOCO(1:14)//'.CM2A'
      CM3A   = RESOCO(1:14)//'.CM3A'
C
      IF (TYPALF.EQ.0) THEN
         NBREEL = NBLIAI
      ELSE
         NBREEL = 3*NBLIAI
      ENDIF

C --- MATRICE PRINCIPALE CM1AT (UTILISEE EN CONTACT ET FROTTEMENT)
      CALL JECREC(CM1A,'V V R','NU','DISPERSE','CONSTANT',NBREEL)
      CALL JEECRA(CM1A,'LONMAX',NEQ,K8BID)
      DO 40 II = 1, NBREEL
         CALL JECROC (JEXNUM(CM1A,II))
 40   CONTINUE

C --- MATRICE CM2AT ET CM3AT (UTILISEE EN FROTTEMENT UNIQUEMENT)
      IF (TYPALF.NE.0) THEN
         CALL JECREC (CM2A,'V V R','NU','DISPERSE','CONSTANT',NBREEL)
         CALL JECREC (CM3A,'V V R','NU','DISPERSE','CONSTANT',NBREEL)
         CALL JEECRA (CM2A,'LONMAX',NEQ,K8BID)
         CALL JEECRA (CM3A,'LONMAX',NEQ,K8BID)
         DO 42 II = 1, NBREEL
            CALL JECROC (JEXNUM(CM2A,II))
            CALL JEVEUO (JEXNUM(CM2A,II),'E',JBID)
            CALL JELIBE (JEXNUM(CM2A,II))
            CALL JECROC (JEXNUM(CM3A,II))
            CALL JEVEUO (JEXNUM(CM3A,II),'E',JBID)
            CALL JELIBE (JEXNUM(CM3A,II))
 42      CONTINUE
      ENDIF

C ----------------------------------------------------------------------
C --- MATRICE DE CONTACT ACM1AT
C --- CETTE MATRICE EST STOCKEE EN LIGNE DE CIEL
C ---   TRIANGULAIRE SYMETRIQUE PLEINE   
C ----------------------------------------------------------------------

C ---
C --- OBJET NUME_DDL
C ---
      STOC   = RESOCO(1:14)//'.SLCS'

C     NOMBRE D'EQUATIONS DE LA MATRICE
      NEQU = NBREEL
C     TAILLE MAXI D'UN BLOC      
      TMAX   = JEVTBL()
      ITBLOC = NINT(TMAX*1024)
C     HAUTEUR MAXI D'UNE COLONNE
      HMAX   = NEQU

C --- CREATION REFE
      CALL JECREO (STOC//'.REFE','V V K24')
      CALL JEECRA (STOC//'.REFE','LONMAX',1,' ')
      CALL JEECRA (STOC//'.REFE','DOCU',1,'SLCS')
      CALL JEVEUO (STOC//'.REFE','E',JBID)
      ZK24(JBID) = '??CONTACT??'

C --- CREATION HCOL
      CALL WKVECT (STOC//'.HCOL','V V I',NEQU,IDHCOL)
      DO 5 II = 1, NEQU
         ZI(IDHCOL+II-1) = II
 5    CONTINUE
C --- CREATION ADIA
      CALL WKVECT (STOC//'.ADIA','V V I',NEQU,IDADIA)
      DO 6 II = 1, NEQU
         ZI(IDADIA+II-1) = II*(II+1)/2
 6    CONTINUE
C
      ZI(IDADIA) = ZI(IDHCOL)
C     HAUTEUR COLONNE CUMULEE
      NTBLC =  ZI(IDHCOL)
C     NOMBRE DE BLOCS
      NBLC  = 1
C     TAUX DE VIDE MAXI POUR ALARME
      TVALA = 0.25D0
C     NOMBRE DE BLOCS TROP VIDES
      IVALA = 0
C     TAUX DE VIDE MAXI
      TVMAX = 1.D0

      DO 180 IEQUA = 2,NEQU
        NTBLC = NTBLC + ZI(IDHCOL+IEQUA-1)
        IF (NTBLC.LE.ITBLOC) THEN
C         ON PEUT TOUJOURS AJOUTER LA COLONNE DANS LE BLOC
          ZI(IDADIA+IEQUA-1) = ZI(IDADIA+IEQUA-2) + ZI(IDHCOL+IEQUA-1)
        ELSE

C         LA COLONNE NE PEUT PAS ENTRER DANS LE NOUVEAU BLOC
C         TAUX DE VIDE LAISSE DANS LE BLOC
          TV = (ITBLOC-NTBLC)/ITBLOC
          IF (TV.GE.TVMAX) THEN
            TVMAX = TV
            IF (TVMAX.GE.TVALA) THEN
              IVALA = IVALA+1
            ENDIF
          ENDIF
C         NOUVEAU BLOC
          NTBLC = ZI(IDHCOL+IEQUA-1)
          IF (NTBLC.GT.ITBLOC) THEN
           CALL UTDEBM('F','CRSDCO','---')
           CALL UTIMPI('L',' LA TAILLE BLOC  :',1,ITBLOC)
           CALL UTIMPI('S','EST < HAUTEUR_MAX :',1,HMAX)
           CALL UTIMPK('L',' CHANGEZ LA TAILLE_BLOC DES PROFILS:',0,' ')
           CALL UTIMPI('S',' PRENEZ AU MOINS :',1,HMAX/1024+1)
           CALL UTFINM()
          ENDIF
          NBLC = NBLC + 1
          ZI(IDADIA+IEQUA-1) = ZI(IDHCOL+IEQUA-1)
        END IF
  180 CONTINUE          

      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '--- TAILLE MAXI DES BLOCS : ',ITBLOC
        WRITE (IFM,*) '--- HAUTEUR MAXIMUM D''UNE COLONNE : ',HMAX
        WRITE (IFM,*) '--- TAUX DE VIDE MAXI DANS UN BLOC : ',TVMAX
        WRITE (IFM,*) '--- NOMBRE DE BLOCS UTILISES : ',NBLC
        WRITE (IFM,*) '--- TAUX DE VIDE PROVOQUANT ALARME: ',TVALA
        WRITE (IFM,*) '--- NOMBRE DE BLOCS ALARMANT ',IVALA
      END IF
C
C --- CREATION ABLO
      CALL WKVECT (STOC//'.ABLO','V V I',NBLC+1,IDABLO)

      ZI(IDABLO) = 0
      IBLC = 1
      NTBLC = ZI(IDHCOL)

      DO 190 IEQUA = 2,NEQU
        NTBLC = NTBLC + ZI(IDHCOL+IEQUA-1)
        IF (NTBLC.GT.ITBLOC) THEN
          NTBLC = ZI(IDHCOL+IEQUA-1)
          ZI(IDABLO+IBLC) = IEQUA - 1
          IBLC = IBLC + 1
        END IF
  190 CONTINUE
      ZI(IDABLO+NBLC) = NEQU
      IF (NBLC.EQ.1) THEN
        ITBLOC = NTBLC
      END IF      

C --- CREATION IABL 
      CALL WKVECT(STOC//'.IABL','V V I',NEQU,IDIABL)
      ICOMPT = 0
      DO 210 I = 1,NBLC
        NBCOL = ZI(IDABLO+I) - ZI(IDABLO+I-1)
        DO 200 J = 1,NBCOL
          ICOMPT = ICOMPT + 1
          ZI(IDIABL-1+ICOMPT) = I
  200   CONTINUE
  210 CONTINUE
      IF (ICOMPT.NE. (NEQU)) THEN
        CALL UTMESS('F','CRSDCO','ERREUR PGMEUR 1')
      END IF

C --- CREATION DESC
      CALL WKVECT(STOC//'.DESC','V V I',6,IDDESC)
      ZI(IDDESC)   = NEQU
      ZI(IDDESC+1) = ITBLOC
      ZI(IDDESC+2) = NBLC
      ZI(IDDESC+3) = HMAX

C ---
C --- OBJET MATR_ASSE
C ---
      MATR   = RESOCO(1:14)//'.MATR'
C
      CALL WKVECT(MATR//'.REFA','V V K24',4,JBID)
      ZK24(JBID)   = NOMA
      ZK24(JBID+1) = RESOCO(1:14)
      ZK24(JBID+2) = STOC
C
      CALL WKVECT (MATR//'.&VDI','V V R',NBREEL,JBID)
      CALL WKVECT (MATR//'.&TRA','V V R',NBREEL,JBID)
      CALL WKVECT (MATR//'.LIME','V V K8',1,JBID)
      ZK8(JBID) = ' '
C
      CALL JECREC (MATR//'.VALE','V V R','NU','DISPERSE'
     &     ,'CONSTANT',NBBLOC)
      CALL JEECRA (MATR//'.VALE','LONMAX',
     &     NBREEL*(NBREEL+1)/2,K8BID)
      DO 4 II = 1, NBBLOC
         CALL JECROC (JEXNUM(MATR//'.VALE',II))
 4    CONTINUE
      CALL JEECRA (MATR//'.VALE','DOCU',1,'MS')
C
 9999 CONTINUE
C
C ----------------------------------------------------------------------
C
      CALL JEDEMA ()
      END
