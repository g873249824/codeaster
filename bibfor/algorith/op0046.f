      SUBROUTINE OP0046 ( IER )
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     COMMANDE:  MECA_STATIQUE
C
      IMPLICIT NONE
C
      INTEGER IER
C
C --------- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0046' )
C
      INTEGER IBID, NBID, NH , NBCHRE , NBCHAR
      INTEGER N1, N4, N5, N7
      INTEGER IOPT, JOPT, NOPT, IERD, IORDR, NBMAX , ICH
      INTEGER NCHAR, JCHAR, NUMCHA, NCHA, NPLAN, NPLA
      INTEGER IOCC, NFON, JINF, IAINST
      INTEGER IRET, I, JORDR
      INTEGER NBPASE, NBUTI
C
      REAL*8       TEMPS, TIME , ALPHA
      REAL*8 PARMET(30), PARCRI(11), PARCON(5)
C
      CHARACTER*1  BASE, TYPCOE
      CHARACTER*8  K8B, RESULT, LISTPS, TEMP, NOMODE, NOMA
      CHARACTER*8  NOMFON, CHAREP, PLAN, MODEDE , NOMCHA
      CHARACTER*13 INPSCO
      CHARACTER*16 NOSY
      CHARACTER*16 METHOD(6)
      CHARACTER*19 SOLVEU, LISCHA, LIGREL, LISCH2
      CHARACTER*19 SOLVDE
      CHARACTER*24 MODELE, CARELE, CHARGE, FOMULT
      CHARACTER*24 CHTIME, CHAMGD, CHFREQ, CHMASS
      CHARACTER*24 CHAMEL, CHSIG,  CHEPS
      CHARACTER*24 CHGEOM, CHCARA(15), CHTEMP, CHTREF, CHHARM
      CHARACTER*24 CHVARC, CHSECH, CHVREF
      CHARACTER*24 INFOCH, MATE
      CHARACTER*24 K24B, NOOBJ
      CHARACTER*24 COMPOR, CARCRI
C
      LOGICAL EXITIM, EXIPOU, LSIEF
C
      COMPLEX*16    CALPHA, C16B
C DEB ------------------------------------------------------------------
C
      CALL JEMARQ()
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFMAJ
C
C----------------------------------------------------------------------
      BASE ='G'
C
C 1.2. ==> NOM DES STRUCTURES
C
C               12   345678   90123
      INPSCO = '&&'//NOMPRO//'_PSCO'
C
C               12   345678   90123456789
      SOLVEU = '&&'//NOMPRO//'.SOLVEUR   '
      LISCHA = '&&'//NOMPRO//'.LISCHA    '
C
      CHMASS = ' '
      CHFREQ = ' '
      CHTIME = ' '
      CHARGE = ' '
      NH     = 0
      TYPCOE = ' '
      CHAREP = ' '
      K24B = ' '
      ALPHA  = 0.D0
      CALPHA = (0.D0 , 0.D0)
      NFON   = 0
      CHVARC='&&OP0046.VARC'
      CHVREF='&&OP0046.VREF'
C
C -- LECTURE DES OPERANDES DE LA COMMANDE
C
C            12   345678
      K8B = '&&'//NOMPRO
C
      CALL NMLECT (RESULT, MODELE, MATE  , CARELE, COMPOR,
     &             LISCHA, METHOD, SOLVEU, PARMET, PARCRI,
     &             CARCRI, MODEDE, SOLVDE,
     &             NBPASE, K8B, INPSCO, PARCON )
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
     &              NBPASE, INPSCO )
C
C ---- CALCUL DE L'OPTION SIEF_ELGA_DEPL OU RIEN
C
      NOMODE = MODELE(1:8)
      LIGREL = NOMODE//'.MODELE'
C
      CALL DISMOI('F','NOM_MAILLA',NOMODE,'MODELE',IBID,NOMA,IERD)
      CALL DISMOI('F','NB_CHAMP_MAX',RESULT,'RESULTAT',NBMAX,K8B,IERD)
      CALL GETVTX(' ','OPTION',0,1,1,NOSY,N7)

      IF (NOSY.EQ.'SANS') GO TO 9999

      EXIPOU = .FALSE.

      CALL DISMOI('F','EXI_POUX' ,MODELE,'MODELE',IBID,K8B,IERD)
      IF (K8B(1:3).EQ.'OUI') EXIPOU = .TRUE.
      CALL JELIRA(CHARGE,'LONMAX',NCHAR,K8B)
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
C     RECHERCHE DE LA CHARGE CONTENANT LA TEMPERATURE
C     -----------------------------------------------
      CALL JEVEUO(CHARGE,'L',JCHAR)
      CALL JEVEUO(INFOCH,'L',JINF)
      NBID = ZI(JINF)
      NUMCHA = ZI(JINF-1+2+2*NBID)
      IF (NUMCHA.NE.0) THEN
         TEMP = ZK24(JCHAR-1+NUMCHA)(1:8)
         NCHA = 1
      ELSE
         TEMP = ' '
         NCHA = 0
      ENDIF
C
C     BOUCLE SUR LES OPTIONS DE MECANIQUE : SIEF_ELGA_DEPL OU SANS
C     ------------------------------------------------------------
      CALL JEVEUO(LISTPS//'           .VALE','L',IAINST)
      EXITIM = .TRUE.
      DO 13 IORDR = 1,NBMAX
C
         CALL RSEXCH(RESULT,'DEPL',IORDR,CHAMGD,IRET)
         IF (IRET.GT.0) GOTO 13
C
         CALL RSEXCH(RESULT,NOSY,IORDR,CHAMEL,IRET)
         CALL MECHAM(NOSY,NOMODE,NCHA,TEMP,CARELE(1:8),NH,
     &                           CHGEOM,CHCARA,CHHARM,IRET )
         IF (IRET.NE.0) GOTO 13
         TIME = ZR(IAINST-1+IORDR)
         CALL MECHTI(CHGEOM(1:8),TIME,CHTIME)
         CALL MECHTE(NOMODE,NCHA,TEMP,MATE,EXITIM,TIME,
     &                                              CHTREF,CHTEMP )
         CALL VRCINS(MODELE(1:8),MATE(1:8),CARELE(1:8),TIME,
     &                                       CHVARC(1:19))
         CALL VRCREF(MODELE(1:8),MATE(1:8),CARELE(1:8),
     &                                       CHVREF(1:19))

         IF ( EXIPOU .AND. NFON.NE.0 ) THEN
           CALL FOINTE('F ',NOMFON,1,'INST',TIME,ALPHA,IER)
         ENDIF
C
         IBID = 0
         CALL MECALC(NOSY,NOMODE,CHAMGD,CHGEOM,MATE,CHCARA,CHTEMP,
     &               CHTREF,CHTIME,K24B,CHHARM,CHSIG,CHEPS,
     &               CHFREQ,CHMASS,K24B,CHAREP,TYPCOE,ALPHA,CALPHA,
     &               K24B,K24B,CHAMEL,LIGREL,BASE,
     &               CHVARC,CHVREF,K24B,K24B,
     &               K24B, K24B, K8B, IBID, IRET )


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
      NOOBJ ='12345678'//'.1234'//'.EXCIT01234'
      CALL GNOMSD(NOOBJ,10,13)
      LISCH2 = NOOBJ(1:19)
      CALL DISMOI('F','NB_CHAMP_UTI',RESULT,'RESULTAT',NBUTI,K8B,IERD)
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

      CALL TITRE

C     -- MENAGE FINAL :
      CALL DETMAT()

      CALL JEDEMA()
      END
