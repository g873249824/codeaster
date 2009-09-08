      SUBROUTINE RESFET(MATAS,CHCINE,CHSECM,CHSOL,NITER,CRITER,SOLV19)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/09/2009   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  RESOLUTION D'UN SYSTEME LINEAIRE VIA FETI
C
C     RESOLUTION DU SYSTEME       "NOMMAT" * X = "CHAMNO"
C                                       AVEC X = U0 SUR G
C     ------------------------------------------------------------------
C     IN  MATAS  : CH19 : NOM DE LA MATR_ASSE GLOBALE
C     IN  CHCINE : CH19 : CHAM_NO DE CHARGEMENT CINEMATIQUE
C                         ASSOCIE A LA CONTRAINTE X = U0 SUR G
C     IN CHSECM  : CH19 : CHAM_NO GLOBAL SECOND MEMBRE
C     OUT CHSOL  : CH19 : CHAM_NO GLOBAL SOLUTION
C     IN  NITER  :  IN  : NOMBRE D'ITERATIONS MAXIMALES ADMISSIBLES DU
C                         GCPPC DE FETI
C     IN  CRITER :  K19 : STRUCTURE DE DONNEE STOCKANT INFOS DE CV
C     IN  SOLV19 :  K19 : SOLVEUR
C     ------------------------------------------------------------------
C     VERIFICATIONS :
C     1) SI VCINE = ' ' : ERREUR SI LE NOMBRE DE DDLS IMPOSES ELIMINES
C                         ASSOCIES A LA MATRICE EST /=0
C     2) SI VCINE/= ' ' : ERREUR SI LE NOMBRE DE DDLS IMPOSES ELIMINES
C                         ASSOCIES A LA MATRICE EST =0
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      REAL*8 EPSI,TESTCO
      CHARACTER*19 MATAS,CHCINE,CHSECM,CHSOL
      CHARACTER*19 CRITER

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C DECLARATION VARIABLES LOCALES
      INTEGER NITER,NBREOR,NBREOI,REACRE,JSLVI,JSLVK,JSLVR
      INTEGER IDIME,NBSD,IDD,IFETM,ILIMPI,IFETPT,IFETC,IINF
      INTEGER IBID,IFM,NIV
      REAL*8 RBID,TEMPS(6)
      CHARACTER*19 SOLV19,SDFETI,ARG1,ARG2,PCHN1,PCHN2
      CHARACTER*24 OPT,INFOFE,VALK(2)
      CHARACTER*24 TYREOR,PRECO,SCALIN,STOGI,ACMA,ACSM
      LOGICAL LFETIC,IDDOK,IDENSD


C CORPS DU PROGRAMME
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      CALL JEVEUO(SOLV19//'.SLVK','L',JSLVK)
      CALL JEVEUO(SOLV19//'.SLVR','L',JSLVR)
      CALL JEVEUO(SOLV19//'.SLVI','L',JSLVI)

      SDFETI=ZK24(JSLVK+5)
      EPSI=ZR(JSLVR+1)
      TESTCO=ZR(JSLVR+3)
      NITER=ZI(JSLVI+1)
      NBREOR=ZI(JSLVI+4)
      NBREOI=ZI(JSLVI+5)
      PRECO=ZK24(JSLVK+1)
      TYREOR=ZK24(JSLVK+6)
      SCALIN=ZK24(JSLVK+7)
      STOGI=ZK24(JSLVK+8)
      ACMA=ZK24(JSLVK+9)
      ACSM=ZK24(JSLVK+10)
      REACRE=ZI(JSLVI+6)


      LFETIC=.FALSE.
      CALL JEVEUO(SDFETI//'.FDIM','L',IDIME)
C     NOMBRE DE SOUS-DOMAINES
      NBSD=ZI(IDIME)
      CALL JEVEUO(MATAS//'.FETM','L',IFETM)
      CALL JEVEUO(CHSECM//'.FETC','L',IFETC)
C     ADRESSE JEVEUX OBJET FETI & MPI
      CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
      CALL JEVEUO('&FETI.FINF','L',IINF)
      INFOFE=ZK24(IINF)
      IF (INFOFE(11:11).EQ.'T')LFETIC=.TRUE.


      DO 10 IDD=0,NBSD
        IF (ZI(ILIMPI+IDD).EQ.1) THEN
          IDDOK=.TRUE.
        ELSE
          IDDOK=.FALSE.
        ENDIF
        IF (IDDOK) THEN

          IF (IDD.EQ.0) THEN
            ARG1=MATAS
            ARG2=CHSECM
          ELSE
            ARG1=ZK24(IFETM+IDD-1)
            ARG2=ZK24(IFETC+IDD-1)
          ENDIF
          CALL DISMOI('F','PROF_CHNO',ARG1,'MATR_ASSE',IBID,PCHN1,IBID)
          CALL DISMOI('F','PROF_CHNO',ARG2,'CHAM_NO',IBID,PCHN2,IBID)
          IF (.NOT.IDENSD('PROF_CHNO',PCHN1,PCHN2)) THEN
            VALK(1)=ARG1
            VALK(2)=ARG2
            CALL U2MESG('F','FACTOR_61',2,VALK,1,IDD,0,RBID)
          ENDIF
        ENDIF
   10 CONTINUE



      IF (LFETIC) THEN
        CALL UTTCPU('CPU.RESFET','INIT ',' ')
        CALL UTTCPU('CPU.RESFET','DEBUT',' ')
      ENDIF





C ADRESSE JEVEUX OBJET FETI & MPI
      CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)

C PAR SOUCIS D'HOMOGENEITE, MAJ DES OBJETS JEVEUX TEMPORAIRE .&INT
      DO 20 IDD=1,NBSD
        IF (ZI(ILIMPI+IDD).EQ.1) CALL MTDSCR(ZK24(IFETM+IDD-1)(1:19))
   20 CONTINUE

C SOLVEUR FETI SANS AFFE_CHAR_CINE
      CALL JEVEUO('&FETI.PAS.TEMPS','E',IFETPT)
C ON INCREMENTE L'INDICE DE L'INCREMENT DE TEMPS POUR MULTIPLE SECONDS
C MEMBRES
      ZI(IFETPT+1)=ZI(IFETPT+1)+1
      OPT='RESOLUTION'
      CALL ALFETI(OPT,SDFETI,MATAS,CHSECM,CHSOL,NITER,EPSI,CRITER,
     &            TESTCO,NBREOR,TYREOR,PRECO,SCALIN,STOGI,NBREOI,ACMA,
     &            ACSM,REACRE)

C     -- DESTRUCTION DES CHAM_NO FILS SOLUTION ET DU .FETC
      CALL ASSDE2(CHSOL)

      IF (LFETIC) THEN
        CALL UTTCPU('CPU.RESFET','FIN',' ')
        CALL UTTCPR('CPU.RESFET',6,TEMPS)
        WRITE (IFM,'(A44,D11.4,D11.4)')
     &    'TEMPS CPU/SYS SOLVEUR FETI                : ',TEMPS(5),
     &    TEMPS(6)
      ENDIF

      CALL JEDEMA()
      END
