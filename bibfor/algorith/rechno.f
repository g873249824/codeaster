      SUBROUTINE RECHNO(IZONE,REAAPP,REACTU,NEWGEO,DEFICO,
     &                  RESOCO,IESCL)

C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/06/2006   AUTEUR MABBAS M.ABBAS 
C TOLE CRP_20
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
      IMPLICIT     NONE
      INTEGER      IZONE
      INTEGER      REAAPP
      INTEGER      REACTU
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      INTEGER      IESCL
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : RECHCO
C ----------------------------------------------------------------------
C
C APPARIEMENT NODAL : RECHERCHE POUR CHAQUE NOEUD "ESCLAVE"
C DU NOEUD "MAITRE" LE PLUS PROCHE DANS LA MEME SURFACE DE CONTACT,
C POUR UNE ZONE DE CONTACT DONNEE. LES NOTIONS DE "MAITRE" ET
C D'"ESCLAVE" SONT FICTIVES ICI : ON PREND COMME SURFACE ESCLAVE
C CELLE QUI A LE MOINS DE NOEUDS POUR AVOIR PLUS DE CHANCES D'AVOIR
C UN APPARIEMENT INJECTIF.
C
C ON NE PREND PAS COMME NOEUDS ESCLAVES CEUX STOCKES
C DANS LE TABLEAU SANSNO ET PROVENANT DES MOTS-CLES SANS_NO ET
C SANS_GROUP_NO.
C
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  REAAPP : -1 SI PAS DE RECHERCHE MAIS REMPLISSAGE INITIAL DES SD
C              +1 SI ON CHERCHE LE NOEUD LE + PROCHE PAR "BRUTE FORCE"
C              +2 SI ON CHERCHE PAR VOISINAGE   (GRACE AU "PASSE")
C              +3 SI ON CHERCHE AVEC DES BOITES (SANS LE "PASSE")
C IN  REACTU : INDICATEUR DE REACTUALISATION POUR TOUTE LA ZONE
C              DES NORMALES ET DU JEU
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C VAR RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C VAR IESCL  : NUMERO DU DERNIER NOEUD ESCLAVE CONNU
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      INTEGER      ZAPMEM
      PARAMETER    (ZAPMEM=4)
      CHARACTER*24 METHCO,NDIMCO,PZONE,PSURNO,CONTNO,DDLCO
      INTEGER      JMETH,JDIM,JZONE,JSUNO,JNOCO,JDDL
      CHARACTER*24 SANSNO,PSANS,APMEMO,APPARI,NORINI
      INTEGER      JSANS,JPSANS,JAPMEM,JAPPAR,JNRINI
      CHARACTER*24 APCOEF,APCOFR,APJEFX,APJEFY,PDDL,APDDL,PNOMA
      INTEGER      JAPCOE,JAPCOF,JAPJFX,JAPJFY,JPDDL,JAPDDL,JPONO
      CHARACTER*24 PMANO,MANOCO,NORMCO,TANGCO,APPOIN,APJEU,NOMACO
      INTEGER      JPOMA,JMANO,JNORMO,JTANGO,JAPPTR,JAPJEU,JNOMA
      INTEGER      TYPALF,FROT3D,IBID,MOYEN,TANGDF
      INTEGER      NESMAX,NDIM,NBNOE,NBNOM,NBMA,NBNO
      INTEGER      NUMNOE,NUMNOM,NUMMIN
      INTEGER      ISURFE,ISURFM,SWAP
      INTEGER      JDECE,JDECM,JCOOR,JDEC,JDECMA
      INTEGER      K,KE,KM,NSANS,IFM,NIV
      INTEGER      POSMIN,POSNOM,POSNOE,POSMA,OLDPOS
      REAL*8       COORE(3),COORM(3),R8GAEM,DIST,PADIST,DMIN
C
C ----------------------------------------------------------------------
C
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ ()
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,1000) IZONE,' - NODAL        '
      ENDIF
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,RESOCO(1:14),IBID,TYPALF,FROT3D,IBID)
C
C ---  LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      DDLCO  = DEFICO(1:16)//'.DDLCO'
      DDLCO  = DEFICO(1:16)//'.DDLCO'
      MANOCO = DEFICO(1:16)//'.MANOCO'
      METHCO = DEFICO(1:16)//'.METHCO'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      NOMACO = DEFICO(1:16)//'.NOMACO'
      PDDL   = DEFICO(1:16)//'.PDDLCO'
      PMANO  = DEFICO(1:16)//'.PMANOCO'
      PNOMA  = DEFICO(1:16)//'.PNOMACO'
      PSANS  = DEFICO(1:16)//'.PSSNOCO'
      PSURNO = DEFICO(1:16)//'.PSUNOCO'
      PZONE  = DEFICO(1:16)//'.PZONECO'
      SANSNO = DEFICO(1:16)//'.SSNOCO'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      APCOFR = RESOCO(1:14)//'.APCOFR'
      APDDL  = RESOCO(1:14)//'.APDDL'
      APJEFX = RESOCO(1:14)//'.APJEFX'
      APJEFY = RESOCO(1:14)//'.APJEFY'
      APJEU  = RESOCO(1:14)//'.APJEU'
      APMEMO = RESOCO(1:14)//'.APMEMO'
      APPARI = RESOCO(1:14)//'.APPARI'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      NORINI = RESOCO(1:14)//'.NORINI'
      NORMCO = RESOCO(1:14)//'.NORMCO'
      TANGCO = RESOCO(1:14)//'.TANGCO'
C ======================================================================
      CALL JEVEUO(CONTNO,'L',JNOCO )
      CALL JEVEUO(DDLCO, 'L',JDDL )
      CALL JEVEUO(MANOCO,'L',JMANO)
      CALL JEVEUO(METHCO,'L',JMETH)
      CALL JEVEUO(NDIMCO,'E',JDIM )
      CALL JEVEUO(NOMACO,'L',JNOMA )
      CALL JEVEUO(PDDL  ,'L',JPDDL )
      CALL JEVEUO(PMANO, 'L',JPOMA)
      CALL JEVEUO(PNOMA, 'L',JPONO )
      CALL JEVEUO(PSANS, 'L',JPSANS)
      CALL JEVEUO(PSURNO,'L',JSUNO )
      CALL JEVEUO(PZONE, 'L',JZONE )
      CALL JEVEUO(SANSNO,'L',JSANS )
      CALL JEVEUO(NORINI,'L',JNRINI)
      CALL JEVEUO(NORMCO,'E',JNORMO)
      CALL JEVEUO(TANGCO,'E',JTANGO)
      CALL JEVEUO(APMEMO,'E',JAPMEM)
      CALL JEVEUO(APPARI,'E',JAPPAR)
      CALL JEVEUO(APPOIN,'E',JAPPTR)
      CALL JEVEUO(APCOEF,'E',JAPCOE)
      CALL JEVEUO(APJEU, 'E',JAPJEU)
      CALL JEVEUO(APDDL, 'E',JAPDDL)

      IF (TYPALF.NE.0) THEN
        CALL JEVEUO(APCOFR,'E',JAPCOF)
        CALL JEVEUO(APJEFX,'E',JAPJFX)
        CALL JEVEUO(APJEFY,'E',JAPJFY)
      ENDIF

      CALL JEVEUO(NEWGEO(1:19)//'.VALE','L',JCOOR)
C 
C --- INITIALISATION DE VARIABLES 
C
C
C --- NORMALE MOYENNES 
C
      MOYEN = 0
      IF (ZI(JMETH+ZMETH*(IZONE-1)+8).EQ.1) THEN
        MOYEN = 1
      ENDIF
C
C --- NORMALE DEFINIE PAR USER (VECT_Y)
C
      TANGDF = ZI(JMETH+ZMETH*(IZONE-1)+2)
C
C --- NOMBRE MAXIMUM DE NOEUDS ESCLAVES ET DIMENSION DU PROBLEME
C
      NESMAX = ZI(JDIM+8)
      NDIM   = ZI(JDIM)
C
C --- NUMEROS DES SURFACES MAITRE ET ESCLAVE
C
      ISURFE = ZI(JZONE+IZONE)
      ISURFM = ZI(JZONE+IZONE-1) + 1
C
C --- NOMBRE DE NOEUDS DES SURFACES
C
      NBNOE = ZI(JSUNO+ISURFE) - ZI(JSUNO+ISURFE-1)
      NBNOM = ZI(JSUNO+ISURFM) - ZI(JSUNO+ISURFM-1)
C
C --- ON SE DEBROUILLE POUR QUE LA
C --- SURFACE ESCLAVE SOIT CELLE AVEC LE MOINS DE NOEUDS
C
      IF (NBNOM.LT.NBNOE) THEN
        SWAP   = NBNOE
        NBNOE  = NBNOM
        NBNOM  = SWAP
        SWAP   = ISURFE
        ISURFE = ISURFM
        ISURFM = SWAP
      END IF
C
C --- DECALAGE DANS CONTNO POUR TROUVER LES NOEUDS DES SURFACES
C
      JDECE = ZI(JSUNO+ISURFE-1)
      JDECM = ZI(JSUNO+ISURFM-1)
C
C --- NOMBRE DE NOEUDS ESCLAVES DE LA ZONE A PRIORI
C
      ZI(JDIM+8+IZONE) = NBNOE
C
C --- APPARIEMENT PAR METHODE "BRUTE FORCE" 
C --- DOUBLE BOUCLE SUR LES NOEUDS
C
      IF (REAAPP.EQ.1) THEN

        DO 50 KE = 1,NBNOE
C
C --- INDICE DANS CONTNO, NUMERO ABSOLU DU NOEUD DE LA SURFACE ESCLAVE
C
          POSNOE   = JDECE + KE
          NUMNOE   = ZI(JNOCO+POSNOE-1)
C
C --- COORDONNEES ACTUELLES DU NOEUD ESCLAVE
C
          COORE(1) = ZR(JCOOR+3* (NUMNOE-1))
          COORE(2) = ZR(JCOOR+3* (NUMNOE-1)+1)
          COORE(3) = ZR(JCOOR+3* (NUMNOE-1)+2)
C
C --- ON REGARDE SI LE NOEUD EST INTERDIT COMME ESCLAVE
C
          NSANS = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
          JDEC  = ZI(JPSANS+IZONE-1)
          DO 10 K = 1,NSANS
            IF (NUMNOE.EQ.ZI(JSANS+JDEC+K-1)) THEN
              ZI(JDIM+8+IZONE) = ZI(JDIM+8+IZONE) - 1
              ZI(JAPMEM+ZAPMEM* (POSNOE-1)) = -1
              GO TO 50
            END IF
   10     CONTINUE
C
C --- RECHERCHE DU NOEUD LE PLUS PROCHE 
C
          DMIN     = R8GAEM()
C
          DO 20 KM = 1,NBNOM
            POSNOM   = JDECM + KM
            NUMNOM   = ZI(JNOCO+POSNOM-1)
            ZI(JAPMEM+ZAPMEM* (POSNOM-1)) = 0
            COORM(1) = ZR(JCOOR+3* (NUMNOM-1))
            COORM(2) = ZR(JCOOR+3* (NUMNOM-1)+1)
            COORM(3) = ZR(JCOOR+3* (NUMNOM-1)+2)
            DIST     = PADIST(3,COORE,COORM)
            IF (DIST.LT.DMIN) THEN
              POSMIN = POSNOM
              DMIN   = DIST
              NUMMIN = NUMNOM
            END IF
   20     CONTINUE
C
C --- NOEUD ESCLAVE SUIVANT
C
          IESCL = IESCL + 1
C
C --- STOCKAGE DANS APPARI ET APMEMO.
C --- ON STOCKE LES NOEUDS, LES DDLS, LES COEFFICIENTS, 
C --- LA DIRECTION DE PROJECTION ET LE JEU
C
          CALL CFJEUN(NDIM,
     &                JAPCOE,JAPCOF,JAPDDL,JAPJEU,JAPJFX,JAPJFY,
     &                JAPMEM,JAPPAR,JAPPTR,JCOOR,JDDL,JNORMO,JNRINI,
     &                JPDDL,JTANGO,
     &                TYPALF,FROT3D,MOYEN,TANGDF,
     &                COORE,
     &                POSNOE,POSMIN,NUMMIN,IESCL,NESMAX,REACTU)

   50   CONTINUE
C
C --- APPARIEMENT PAR VOISINAGE
C --- ON CHERCHE UN NOEUD CONNECTE A L'ANCIEN NOEUD LE PLUS PROCHE
C ---  PAR UNE MAILLE DE CONTACT
C
      ELSE IF (REAAPP.EQ.2) THEN

        DO 110 KE = 1,NBNOE
C
C --- INDICE DANS CONTNO, NUMERO ABSOLU DU NOEUD DE LA SURFACE ESCLAVE
C
          POSNOE   = JDECE + KE
          NUMNOE   = ZI(JNOCO+POSNOE-1)
C
C --- COORDONNEES ACTUELLES DU NOEUD ESCLAVE
C
          COORE(1) = ZR(JCOOR+3* (NUMNOE-1))
          COORE(2) = ZR(JCOOR+3* (NUMNOE-1)+1)
          COORE(3) = ZR(JCOOR+3* (NUMNOE-1)+2)
C
C --- ON REGARDE SI LE NOEUD EST INTERDIT COMME ESCLAVE
C
          NSANS    = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
          JDEC     = ZI(JPSANS+IZONE-1)
          DO 60 K = 1,NSANS
            IF (NUMNOE.EQ.ZI(JSANS+JDEC+K-1)) THEN
              ZI(JDIM+8+IZONE) = ZI(JDIM+8+IZONE) - 1
              ZI(JAPMEM+ZAPMEM* (POSNOE-1)) = -1
              GO TO 110
            END IF
   60     CONTINUE
C
C --- ANCIEN NOEUD MAITRE LE PLUS PROCHE
C
          OLDPOS = ZI(JAPMEM+ZAPMEM* (POSNOE-1)+1)
C
C --- BOUCLE SUR LES MAILLES CONTENANT CET ANCIEN NOEUD
C
          JDECMA = ZI(JPOMA+OLDPOS-1)
          NBMA   = ZI(JPOMA+OLDPOS) - ZI(JPOMA+OLDPOS-1)
          DMIN   = R8GAEM()

          DO 80 KM = 1,NBMA

            POSMA = ZI(JMANO+JDECMA+KM-1)
C
C --- BOUCLE SUR LES NOEUDS DE LA MAILLE ET CALCUL DE LA DISTANCE
C
            JDEC = ZI(JPONO+POSMA-1)
            NBNO = ZI(JPONO+POSMA) - ZI(JPONO+POSMA-1)
            DO 70 K = 1,NBNO
              POSNOM   = ZI(JNOMA+JDEC+K-1)
              NUMNOM   = ZI(JNOCO+POSNOM-1)
              ZI(JAPMEM+ZAPMEM* (POSNOM-1)) = 0
              COORM(1) = ZR(JCOOR+3* (NUMNOM-1))
              COORM(2) = ZR(JCOOR+3* (NUMNOM-1)+1)
              COORM(3) = ZR(JCOOR+3* (NUMNOM-1)+2)
              DIST = PADIST(3,COORE,COORM)
              IF (DIST.LT.DMIN) THEN
                POSMIN = POSNOM
                DMIN   = DIST
                NUMMIN = NUMNOM
              END IF
   70       CONTINUE
   80     CONTINUE
C
C --- NOEUD ESCLAVE SUIVANT
C
          IESCL = IESCL + 1
C
C --- STOCKAGE DANS APPARI ET APMEMO.
C --- ON STOCKE LES NOEUDS, LES DDLS, LES COEFFICIENTS, 
C --- LA DIRECTION DE PROJECTION ET LE JEU
C
          CALL CFJEUN(NDIM,
     &                JAPCOE,JAPCOF,JAPDDL,JAPJEU,JAPJFX,JAPJFY,
     &                JAPMEM,JAPPAR,JAPPTR,JCOOR,JDDL,JNORMO,JNRINI,
     &                JPDDL,JTANGO,
     &                TYPALF,FROT3D,MOYEN,TANGDF,
     &                COORE,
     &                POSNOE,POSMIN,NUMMIN,IESCL,NESMAX,REACTU)

  110   CONTINUE
C
C --- APPARIEMENT PAR BOITES 
C --- ON PARCOURT L'ENSEMBLE DES NOEUDS APPARTENANT
C ---  A DES BOITES VOISINES DU NOEUD ESCLAVE CONSIDERE
C
      ELSE IF (REAAPP.EQ.3) THEN
C
          CALL UTMESS ('F','RECHNO','L''APPARIEMENT NODAL PAR BOITES'
     &               //' N''EST PAS OPERATIONNEL')
C
      END IF
C ----------------------------------------------------------------------

      CALL JEDEMA()
 1000 FORMAT (' <CONTACT> <> APPARIEMENT - ZONE: ',I6,A16)
      END
