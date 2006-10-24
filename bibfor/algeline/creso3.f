      SUBROUTINE CRESO3(SOLVEZ,SYMZ,PCPIVZ,KTYPZ,KTYPSZ,KTYPRZ,EPS,
     &           ISTOP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 23/10/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT   NONE
      CHARACTER*(*) SOLVEZ
      CHARACTER*(*)  KTYPZ,KTYPSZ,KTYPRZ,SYMZ
      INTEGER PCPIVZ ,ISTOP
      REAL*8 EPS
C ----------------------------------------------------------
C BUT : CREER UN SOLVEUR POUR MUMPS
C
C IN K   SYMZ    : SYMETRISATION DE LA MATRICE (OUI/NON)
C                  ' ' -> DEFAUT
C IN I   PCPIVZ  : POURCENTAGE DE MEMOIRE POUR PIVOTAGE TARDIF
C                  0   -> DEFAUT
C IN K   KTYPZ   : TYPE DE FACTORISATION /SYMGEN/SYMDEF/NONSYM
C                  ' ' -> DEFAUT
C IN K   KTYPSZ   : TYPE DE SCALING /SANS/AUTO
C                  ' ' -> DEFAUT
C IN K   KTYPRZ   : TYPE DE RENUMEROTATION /AMD/AMF/PORD/METIS/QAMD/AUTO
C                  ' ' -> DEFAUT
C IN R   EPS     : ERREUR MAX RELATIVE ACCEPTEE POUR LA SOLUTION
C                  0.  -> DEFAUT
C IN/JXOUT    SOLVEU  : LE SOLVEUR EST CREE ET REMPLI
C IN I   ISTOP   : 0 : STOP_SINGULIER=OUI
C                  1 : STOP_SINGULIER=NON
C ----------------------------------------------------------
C RESPONSABLE VABHHTS J.PELLET

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------

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

C --- FIN DECLARATIONS NORMALISEES JEVEUX --------------------

      REAL*8 EPSMAX
      INTEGER      I,IBID
      INTEGER      ISLVK,ISLVI,ISLVR,PCPIV
      CHARACTER*3  SYME
      CHARACTER*8  K8BID,KTYPR,KTYPRN,KTYPS
      CHARACTER*19 SOLVEU

C------------------------------------------------------------------
      CALL JEMARQ()
      SOLVEU=SOLVEZ
      SYME=SYMZ
      KTYPR=KTYPZ
      KTYPS=KTYPSZ
      KTYPRN=KTYPRZ
      PCPIV=PCPIVZ
      EPSMAX=EPS

C     SYME : (CE MOT CLE NE CONCERNE QUE L'ASSEMBLAGE)
C     -------------------------------------------------
      IF (SYME.EQ.' ') SYME='NON'


C     PCENT_PIVOT :
C     ------------
      IF (PCPIV.EQ.0) PCPIV=80


C     TYPE_RESOL :
C     ------------
      IF (KTYPR.EQ.' ') KTYPR='AUTO'

C     TYPE_SCALING :
C     ------------
      IF (KTYPS.EQ.' ') KTYPS='AUTO'

C     TYPE_RENUM :
C     ------------
      IF (KTYPRN.EQ.' ') KTYPRN='AUTO'

C     ERRE_RELA_MAX :
C     ------------
      IF (EPSMAX.EQ.0.D0) EPSMAX=1.D-6


C     CREATION DE LA SD ET STOCKAGE DES VALEURS OBTENUES :
C     ---------------------------------------------------
      CALL WKVECT(SOLVEU//'.SLVK','V V K24',11,ISLVK)
      CALL WKVECT(SOLVEU//'.SLVR','V V R',4,ISLVR)
      CALL WKVECT(SOLVEU//'.SLVI','V V I',6,ISLVI)

      ZK24(ISLVK-1+1) = 'MUMPS'
      ZK24(ISLVK-1+2) = KTYPS
      ZK24(ISLVK-1+3) = KTYPR
      ZK24(ISLVK-1+4) = KTYPRN
      ZK24(ISLVK-1+5) = SYME

      ZI(ISLVI-1+1) = -9999
      ZI(ISLVI-1+2) = PCPIV
      ZI(ISLVI-1+3) = ISTOP
      ZI(ISLVI-1+4) = -9999

      ZR(ISLVR-1+2) = EPSMAX


C FIN ------------------------------------------------------
      CALL JEDEMA()
      END
