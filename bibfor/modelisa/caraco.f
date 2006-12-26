      SUBROUTINE CARACO(CHAR,MOTFAC,NOMA,NOMO,NDIM,NZOCO,NNOQUA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 20/12/2006   AUTEUR TARDIEU N.TARDIEU 
C RESPONSABLE MABBAS M.ABBAS
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*8 CHAR
      CHARACTER*16 MOTFAC
      CHARACTER*8 NOMA
      CHARACTER*8 NOMO
      INTEGER NDIM
      INTEGER NZOCO
      INTEGER NNOQUA
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------
C
C LECTURE DES PRINCIPALES CARACTERISTIQUES DU CONTACT (SURFACE IREAD)
C REMPLISSAGE DE LA SD 'DEFICO' (SURFACE IWRITE)
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  NDIM   : NOMBRE DE DIMENSIONS DU PROBLEME
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NNOQUA : NOMBRE TOTAL DE NOEUDS QUADRATIQUES DES SURFACES DE
C              CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZMETH
      PARAMETER (ZMETH = 8)
      INTEGER ZTOLE
      PARAMETER (ZTOLE = 7)
      INTEGER ZCONV
      PARAMETER (ZCONV=6)
      CHARACTER*24 METHCO,TOLECO,CARACF,ECPDON,JEUSUP,JEUFO1,JEUFO2
      CHARACTER*24 JEUFO3
      INTEGER JMETH,JTOLE,JCMCF,JECPD,JJSUP,JJFO1,JJFO2,JJFO3
      CHARACTER*24 DIRCO,NORLIS,TANDEF,SANSNQ,CONVCO
      INTEGER JDIR,JNORLI,JTGDEF,JSANSN,JCONV
      INTEGER IOC,ISY,ISYME
      INTEGER IREAD,IWRITE,NZOCP
      CHARACTER*24 SYMECO
      INTEGER JSYME,NSYME
      INTEGER JPOUDI
      CHARACTER*24 TANPOU
C
C ----------------------------------------------------------------------
C
      SYMECO = CHAR(1:8) // '.CONTACT.SYMECO'
      CALL JEVEUO(SYMECO,'L',JSYME)
      NSYME = ZI(JSYME)
C
      NZOCP = NZOCO - NSYME
C
C --- INITIALISATION
C
      CALL JEMARQ
C
C --- PREPARATION DES SD
C
      METHCO = CHAR(1:8) // '.CONTACT.METHCO'
      CALL WKVECT(METHCO,'G V I',ZMETH*NZOCO+1,JMETH)
C
      SANSNQ = CHAR(1:8) // '.CONTACT.SANSNQ'
      CALL WKVECT(SANSNQ,'G V I',NZOCO,JSANSN)
      TOLECO = CHAR(1:8) // '.CONTACT.TOLECO'
      CALL WKVECT(TOLECO,'G V R',ZTOLE*NZOCO,JTOLE)
C
      CONVCO = CHAR(1:8) // '.CONTACT.CONVCO'
      CALL WKVECT(CONVCO,'G V I',ZCONV*NZOCO,JCONV)
      CARACF = CHAR(1:8) // '.CONTACT.CARACF'
      CALL WKVECT(CARACF,'G V R',12*NZOCO+1,JCMCF)
      ECPDON = CHAR(1:8) // '.CONTACT.ECPDON'
      CALL WKVECT(ECPDON,'G V I',6*NZOCO+1,JECPD)
C
      JEUSUP = CHAR(1:8) // '.CONTACT.JSUPCO'
      JEUFO1 = CHAR(1:8) // '.CONTACT.JFO1CO'
      JEUFO2 = CHAR(1:8) // '.CONTACT.JFO2CO'
      JEUFO3 = CHAR(1:8) // '.CONTACT.JFO3CO'
C
      CALL WKVECT(JEUSUP,'G V R',NZOCO,JJSUP)
      CALL WKVECT(JEUFO1,'G V K8',NZOCO,JJFO1)
      CALL WKVECT(JEUFO2,'G V K8',NZOCO,JJFO2)
      CALL WKVECT(JEUFO3,'G V K8',NZOCO,JJFO3)
C
      DIRCO = CHAR(1:8) // '.CONTACT.DIRCO'
      CALL WKVECT(DIRCO,'G V R',3*NZOCO,JDIR)
      NORLIS = CHAR(1:8) // '.CONTACT.NORLIS'
      CALL WKVECT(NORLIS,'G V I',NZOCO+1,JNORLI)
      TANDEF = CHAR(1:8) // '.CONTACT.TANDEF'
      CALL WKVECT(TANDEF,'G V R',6*NZOCO,JTGDEF)
      TANPOU = CHAR(1:8) // '.CONTACT.TANPOU'
      CALL WKVECT(TANPOU,'G V R',3*NZOCO,JPOUDI)
C
C
      ZI(JMETH) = NZOCO
      ZR(JCMCF) = NZOCO
      ZI(JECPD) = 0
C
C
C --- ON NE BOUCLE QUE SUR LES ZONES PRINCIPALES:
C
      DO 8 IOC = 1,NZOCP
        IREAD = IOC
        IWRITE = IOC
        CALL CAZOCO(CHAR,MOTFAC,NOMA,NOMO,NDIM,IREAD,IWRITE)
 8    CONTINUE
C
C --- ON BOUCLE SUR LES ZONES PRINCIPALES MAIS ON AGIT SUR LES
C --- ZONES SYMETRIQUES
C
      IF (NSYME .GT. 0) THEN
        ISYME = 0
        DO 9 IOC = 1,NZOCP
          IREAD = IOC
          DO 10 ISY = 1,NSYME
            IF (ZI(JSYME+ISY) .EQ. IOC) THEN
              ISYME = ISYME + 1
              IWRITE = NZOCP + ISYME
              CALL CAZOCO(CHAR,MOTFAC,NOMA,NOMO,NDIM,IREAD,IWRITE)
            END IF
 10       CONTINUE
 9      CONTINUE
        IF (ISYME .NE. NSYME)
     &    CALL U2MESS('F','MODELISA3_38')
        IF (IWRITE .NE. NZOCO)
     &    CALL U2MESS('F','MODELISA3_38')
      END IF
C
C ======================================================================
      CALL JEDEMA
C
      END
