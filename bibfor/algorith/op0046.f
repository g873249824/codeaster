      SUBROUTINE OP0046(IER)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR MACOCCO K.MACOCCO 
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
C
      IMPLICIT NONE
      INTEGER IER
C
C ----------------------------------------------------------------------
C
C COMMANDE:  MECA_STATIQUE
C
C ----------------------------------------------------------------------
C
C
C OUT IER    : NOMBRE D'ERREURS RENCONTREES
C
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
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0046' )
C
      INTEGER IBID, NH , NBCHRE , NBCHAR, N1, N4, N5, N7
      INTEGER IERD, IORDR, NBMAX , ICH, NCHAR, JCHAR
      INTEGER IOCC, NFON, JINF, IAINST, IRET, I, JORDR, NBPASE, NBUTI
      INTEGER IFM,NIV
C
      REAL*8 TEMPS, TIME , ALPHA
      REAL*8 TBGRCA(3)
      REAL*8 RUNDF
      REAL*8 R8VIDE
C
      CHARACTER*1  BASE, TYPCOE
      CHARACTER*2  CODRET
      CHARACTER*8  K8BLA, RESULT, LISTPS, NOMODE, NOMA
      CHARACTER*8  NOMFON, CHAREP, NOMCHA, BASENO
      CHARACTER*13 INPSCO
      CHARACTER*16 NOSY,INERTE
      CHARACTER*19 SOLVEU, LISCHA, LIGREL, LISCH2
      CHARACTER*24 MODELE, CARELE, CHARGE, FOMULT
      CHARACTER*24 CHTIME, CHAMGD, CHFREQ, CHMASS
      CHARACTER*24 CHAMEL, CHSIG,  CHEPS
      CHARACTER*24 CHGEOM, CHCARA(15), CHHARM
      CHARACTER*24 CHVARC, CHVREF
      CHARACTER*24 INFOCH, MATE
      CHARACTER*24 K24BLA, NOOBJ
      CHARACTER*24 COMPOR
C
      LOGICAL EXIPOU
C
      COMPLEX*16    CALPHA
C DEB ------------------------------------------------------------------
C
      CALL JEMARQ()
      RUNDF=R8VIDE()
C
C -- TITRE
C
      CALL TITRE ()
      CALL INFMAJ()
      CALL INFDBG('MECA_STATIQUE',IFM,NIV)
C
C -- INITIALISATIONS
C
      BASE ='G'
      INPSCO = '&&'//NOMPRO//'_PSCO'
      SOLVEU = '&&'//NOMPRO//'.SOLVEUR   '
      LISCHA = '&&'//NOMPRO//'.LISCHA    '
      CHMASS = ' '
      CHFREQ = ' '
      CHTIME = ' '
      CHARGE = ' '
      NH     = 0
      TYPCOE = ' '
      CHAREP = ' '
      K24BLA = ' '
      K8BLA  = ' '
      ALPHA  = 0.D0
      CALPHA = (0.D0 , 0.D0)
      NFON   = 0
      CHVARC='&&OP0046.VARC'
      CHVREF='&&OP0046.VREF'
C
C -- LECTURE DES OPERANDES DE LA COMMANDE
C
      BASENO = '&&'//NOMPRO
C
      CALL NMLECT(RESULT,MODELE,MATE  ,CARELE,COMPOR,
     &            LISCHA,SOLVEU,NBPASE,BASENO,INPSCO,
     &            INERTE,TBGRCA)
C
C -- VERIFICATION QUE LE CHARGEMENT N EST PAS UN CHARGEMENT DE CONTACT
C
      CHARGE = LISCHA // '.LCHA'
      INFOCH = LISCHA // '.INFC'
      FOMULT = LISCHA//'.FCHA'
C
      CALL JEEXIN ( CHARGE, IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL JEVEUO ( INFOCH, 'L', JINF )
         CALL JEVEUO ( CHARGE, 'L', JCHAR )
         NBCHAR = ZI(JINF)
         DO 9 ICH = 1, NBCHAR
            NOMCHA = ZK24(JCHAR+ICH-1)(1:8)
            CALL JEEXIN ( NOMCHA//'.CONTACT.METHCO', IRET )
            IF ( IRET .NE. 0 )  THEN
               CALL U2MESS('F','ALGORITH9_24')
            ENDIF
  9      CONTINUE
      ENDIF
C
C ---
C
      CALL GETVID(' ','LIST_INST',0,1,1,LISTPS,N4)
      IF (N4.EQ.0) THEN
         CALL GETVR8(' ','INST',0,1,1,TEMPS,N5)
         IF (N5.EQ.0) THEN
           TEMPS = 0.D0
         ENDIF
         LISTPS = RESULT
         CALL ALLIR8('V',LISTPS,1,TEMPS)
      ENDIF
C
C ---- CALCUL MECANIQUE
C
      CALL MESTAT ( MODELE, FOMULT, LISCHA,
     &              MATE,   CARELE,
     &              LISTPS, SOLVEU,
     &              NBPASE, INPSCO, COMPOR )
C
C ---- CALCUL DE L'OPTION SIEF_ELGA_DEPL OU RIEN
C
      NOMODE = MODELE(1:8)
      LIGREL = NOMODE//'.MODELE'
C
      CALL DISMOI('F','NOM_MAILLA',NOMODE,'MODELE',IBID,NOMA,IERD)
      CALL DISMOI('F','NB_CHAMP_MAX',RESULT,'RESULTAT',NBMAX,K8BLA,IERD)
      CALL GETVTX(' ','OPTION',0,1,1,NOSY,N7)

      IF (NOSY.EQ.'SANS') GO TO 9999

      EXIPOU = .FALSE.

      CALL DISMOI('F','EXI_POUX' ,MODELE,'MODELE',IBID,K8BLA,IERD)
      IF (K8BLA(1:3).EQ.'OUI') EXIPOU = .TRUE.
      CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8BLA)
C
      IF ( EXIPOU ) THEN
C
        CALL JEVEUO(CHARGE,'L',JCHAR)
        CALL COCHRE (ZK24(JCHAR),NCHAR,NBCHRE,IOCC)
        IF ( NBCHRE .GT. 1 ) THEN
           CALL U2MESS('F','ALGORITH9_25')
        ENDIF
C
        TYPCOE = 'R'
        ALPHA = 1.D0
        IF (IOCC.GT.0) THEN
          CALL GETVID('EXCIT','CHARGE'   ,IOCC,1,1,CHAREP,N1)
          CALL GETVID('EXCIT','FONC_MULT',IOCC,1,1,NOMFON,NFON)
        ENDIF
      ENDIF
C
C     BOUCLE SUR LES OPTIONS DE MECANIQUE : SIEF_ELGA_DEPL OU SANS
C     ------------------------------------------------------------
      CALL JEVEUO(LISTPS//'           .VALE','L',IAINST)
      DO 13 IORDR = 1,NBMAX
C
         CALL RSEXCH(RESULT,'DEPL',IORDR,CHAMGD,IRET)
         IF (IRET.GT.0) GOTO 13
C
         CALL RSEXCH(RESULT,NOSY,IORDR,CHAMEL,IRET)
         CALL MECHAM(NOSY,NOMODE,0,' ',CARELE(1:8),NH,
     &                           CHGEOM,CHCARA,CHHARM,IRET )
         IF (IRET.NE.0) GOTO 13
         TIME = ZR(IAINST-1+IORDR)
         CALL MECHTI(CHGEOM(1:8),TIME,RUNDF,RUNDF,CHTIME)
         CALL VRCINS(MODELE,MATE,CARELE,TIME,CHVARC(1:19),CODRET)
         CALL VRCREF(MODELE(1:8),MATE(1:8),CARELE(1:8),
     &                                       CHVREF(1:19))

         IF ( EXIPOU .AND. NFON.NE.0 ) THEN
           CALL FOINTE('F ',NOMFON,1,'INST',TIME,ALPHA,IER)
         ENDIF
C
         IBID = 0
         CALL MECALC(NOSY  ,NOMODE,CHAMGD,CHGEOM,MATE  ,
     &               CHCARA,K24BLA,K24BLA,CHTIME,K24BLA,
     &               CHHARM,CHSIG ,CHEPS ,CHFREQ,CHMASS,
     &               K24BLA,CHAREP,TYPCOE,ALPHA ,CALPHA,
     &               K24BLA,K24BLA,CHAMEL,LIGREL,BASE  ,
     &               CHVARC,CHVREF,K24BLA,COMPOR,K24BLA,
     &               K24BLA,K8BLA ,IBID  ,K24BLA,IRET )


C
         CALL RSNOCH(RESULT,NOSY,IORDR,' ')
 13   CONTINUE
C
 9999 CONTINUE
C
C     ----------------------------------------------------------------
C --- STOCKAGE POUR CHAQUE NUMERO D'ORDRE DU MODELE, DU CHAMP MATERIAU
C     DES CARACTERISTIQUES ELEMENTAIRES ET DES CHARGES DANS LA SD RESU
C     ----------------------------------------------------------------
C             12345678    90123    45678901234
      NOOBJ ='12345678'//'.1234'//'.EXCIT.INFC'
      CALL GNOMSD(NOOBJ,10,13)
      LISCH2 = NOOBJ(1:19)
      CALL DISMOI('F','NB_CHAMP_UTI',RESULT,'RESULTAT',NBUTI,K8BLA,IERD)
      CALL JEVEUO(RESULT//'           .ORDR','L',JORDR)
      DO 14 I=1,NBUTI
          IORDR=ZI(JORDR+I-1)
          CALL RSSEPA(RESULT,IORDR,MODELE(1:8),MATE(1:8),CARELE(1:8),
     &                LISCH2(1:19))
 14    CONTINUE
C
C     -----------------------------------------------
C --- COPIE DE LA SD INFO_CHARGE DANS LA BASE GLOBALE
C     -----------------------------------------------
      CALL COPISD(' ','G',LISCHA,LISCH2(1:19))
C

C     -- MENAGE FINAL :
      CALL DETMAT()

      CALL JEDEMA()
      END
