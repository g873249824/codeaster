      SUBROUTINE VPFOPC( LMASSE, LRAIDE, FMIN,
     &                   SIGMA, MATOPA, RAIDE, NPREC)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       MATOPA, RAIDE
      INTEGER             LMASSE, LRAIDE, NPREC
      REAL*8              FMIN
      COMPLEX*16          SIGMA
C     -----------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
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
C     DETERMINATION D'UN SHIFT ET CALCUL DE LA MATRICE SHIFTEE
C     DANS LE CAS GENERALISE COMPLEXE
C     ------------------------------------------------------------------
C OUT LDYNAM  : IS : POINTEUR SUR LA FACTORISEE DE LA MATRICE DYNAMIQUE
C                    INDUITE PAR L'OPTION
C     ------------------------------------------------------------------
C
C     ------ DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      LMAT(2), LMATRA,IBID,IERX,ISINGU,NPVNEG,NDECI
      CHARACTER*24 NMAT(2),NMATRA
      REAL*8       ASHIFT, R8DEPI, CONSTC(3),FSHIFT
      REAL*8 VALR(2)
      CHARACTER*1  TYPCST(2)
      CHARACTER*8  NAMDDL
C     ------------------------------------------------------------------
      DATA NAMDDL/'        '/
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      LMAT(1) = LMASSE
      NMAT(1) = ZK24(ZI(LMAT(1)+1))
      LMAT(2) = LRAIDE
      NMAT(2) = ZK24(ZI(LMAT(2)+1))
C
      FSHIFT = R8DEPI()*FMIN
      ASHIFT = 0.D0
C
      CALL GETVR8('CALC_FREQ','AMOR_REDUIT',1,1,1,ASHIFT,IBID)
C
      IF (ABS(ASHIFT).GE.1.D0) THEN
         ASHIFT = 0.95D0
         VALR (1) = 1.D0
         VALR (2) = 0.95D0
         CALL U2MESG('I', 'ALGELINE4_75',0,' ',0,0,2,VALR)
      ENDIF

      ASHIFT = (ASHIFT*FSHIFT) / 2.0D0
      SIGMA = DCMPLX(FSHIFT,ASHIFT)
C
C        --- DECALAGE COMPLEXE ---
         CALL MTDEFS(MATOPA,RAIDE,'V','C')
         CALL MTDSCR(MATOPA)
         NMATRA=MATOPA(1:19)//'.&INT'
         CALL JEVEUO(MATOPA(1:19)//'.&INT','E',LMATRA)
         TYPCST(1) = 'C'
         TYPCST(2) = 'R'
         CONSTC(1) = -DBLE(SIGMA)
         CONSTC(2) = -DIMAG(SIGMA)
         CONSTC(3) = 1.D0
         CALL MTCMBL(2,TYPCST,CONSTC,NMAT,NMATRA,NAMDDL,' ','ELIM=')
C     --- FACTORISATION DES MATRICES ---
C
      CALL TLDLGG(2,LMATRA,1,0,NPREC,NDECI,ISINGU,NPVNEG,IERX)

      CALL JEDEMA()
      END
