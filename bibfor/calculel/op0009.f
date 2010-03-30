      SUBROUTINE OP0009(IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER IER
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C MODIF CALCULEL  DATE 29/03/2010   AUTEUR PELLET J.PELLET 
C     COMMANDE:  CALC_MATR_ELEM

C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ------------------------------------------------------------------
      REAL*8 TIME,TPS(6)
      CHARACTER*1 BASE
      CHARACTER*4 CTYP
      CHARACTER*8 K8B,MODELE,CARA,SIGG,NOMCMP(6),BLAN8
      CHARACTER*8 RIGI8,MASS8,KBID
      CHARACTER*16 TYPE,OPER,SUROPT
      CHARACTER*19 KCHA,MATEL,RIGIEL,MASSEL
      CHARACTER*24 TIME2,MATE,SDTHET,THETA,COMPOR
      LOGICAL EXITIM
      INTEGER NCHAR, N1, JRECC
      COMPLEX*16 C16B
      DATA NOMCMP/'INST    ','DELTAT  ','THETA   ','KHI     ',
     &     'R       ','RHO     '/
      DATA TPS/0.D0,2*1.D0,3*0.D0/
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()

      BASE = 'G'

      CALL GETRES(MATEL,TYPE,OPER)
      BLAN8  = '        '
      RIGI8 = ' '
      MASS8 = ' '
      SIGG = ' '
      CALL GETVID(' ','RIGI_MECA',0,1,1,RIGI8,N1)
      RIGIEL=RIGI8
      CALL GETVID(' ','MASS_MECA',0,1,1,MASS8,N2)
      MASSEL=MASS8
      CALL GETVTX(' ','OPTION',0,1,1,SUROPT,N3)
      CALL GETVID(' ','SIEF_ELGA',0,1,1,SIGG,N4)
      IF(N4.NE.0)THEN
        CALL CHPVER('F',SIGG,'ELGA','SIEF_R',IER)
      ENDIF
      CALL GETVR8(' ','INST',0,1,1,TIME,N5)
      IF (N5.EQ.0) TIME = 0.D0
      CALL GETVIS(' ','MODE_FOURIER',0,1,1,NH,N6)
      KCHA = '&&OP0009.CHARGES'
      CALL MEDOME(MODELE,MATE,CARA,KCHA,NCHA,CTYP,BLAN8)
C POUR LES MULTIFIBRES ON SE SERT DE COMPOR
      COMPOR=MATE(1:8)//'.COMPOR'
      CALL JEVEUO(KCHA,'E',ICHA)
      EXITIM = .TRUE.
      TIME2 = '&TIME'

      TPS(1) = TIME

      IF (SUROPT.EQ.'RIGI_MECA') THEN
        CALL MERIME(MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,COMPOR,
     &              MATEL,NH,BASE)

      ELSE IF (SUROPT.EQ.'RIGI_FLUI_STRU') THEN
        CALL MERIFS(MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,MATEL,
     &              NH)

      ELSE IF (SUROPT.EQ.'RIGI_GEOM') THEN
        CALL MERIGE(MODELE,CARA,SIGG,MATEL,'G',NH)

      ELSE IF (SUROPT.EQ.'RIGI_ROTA') THEN
        CALL MERIRO(MODELE,CARA,NCHA,ZK8(ICHA),MATE,EXITIM,TIME,MATEL)

      ELSE IF (SUROPT.EQ.'MECA_GYRO') THEN
        CALL MEAMGY(MODELE,MATE,CARA,MATEL)

      ELSE IF (SUROPT.EQ.'MASS_MECA') THEN
C        COMPOR = ' '
        CALL MEMAME(SUROPT,MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,
     &              COMPOR,MATEL,BASE)

      ELSE IF (SUROPT.EQ.'MASS_FLUI_STRU') THEN
C        COMPOR = ' '
        CALL MEMAME(SUROPT,MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,
     &              COMPOR,MATEL,BASE)

      ELSE IF (SUROPT.EQ.'MASS_MECA_DIAG') THEN
C        COMPOR = ' '
        CALL MEMAME(SUROPT,MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,
     &              COMPOR,MATEL,BASE)

      ELSE IF (SUROPT(1:9).EQ.'AMOR_MECA') THEN
        CALL MEAMME(SUROPT,MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,
     &              'G',RIGIEL,MASSEL,MATEL)

      ELSE IF (SUROPT.EQ.'IMPE_MECA') THEN
        CALL MEIMME(MODELE,NCHA,ZK8(ICHA),MATE,MATEL)

      ELSE IF (SUROPT.EQ.'ONDE_FLUI') THEN
        CALL MEONME(MODELE,NCHA,ZK8(ICHA),MATE,MATEL)

      ELSE IF (SUROPT.EQ.'RIGI_MECA_HYST') THEN
        CALL MEAMME(SUROPT,MODELE,NCHA,ZK8(ICHA),MATE,CARA,EXITIM,TIME,
     &              'G',RIGIEL,MASSEL,MATEL)

      ELSE IF (SUROPT.EQ.'RIGI_THER') THEN
        CALL MECACT('V',TIME2,'MODELE',MODELE//'.MODELE','INST_R',6,
     &              NOMCMP,IBID,TPS,C16B,K8B)
        CALL MERITH(MODELE,NCHA,ZK8(ICHA),MATE,CARA,TIME2,MATEL,
     &              NH,BASE)

      ELSE IF (SUROPT.EQ.'MASS_THER') THEN
        CALL MECACT('V',TIME2,'MODELE',MODELE//'.MODELE','INST_R',6,
     &              NOMCMP,IBID,TPS,C16B,K8B)
        CALL MEMATH(SUROPT,MODELE,MATE,CARA,TIME2,MATEL)

      ELSE IF (SUROPT.EQ.'RIGI_ACOU') THEN
        CALL MERIAC(MODELE,NCHA,ZK8(ICHA),MATE,MATEL)

      ELSE IF (SUROPT.EQ.'MASS_ACOU') THEN
        CALL MEMAAC(MODELE,MATE,MATEL)

      ELSE IF (SUROPT.EQ.'AMOR_ACOU') THEN
        CALL MEAMAC(MODELE,NCHA,ZK8(ICHA),MATE,MATEL)

      END IF
      GO TO 20

   20 CONTINUE


C     -- CREATION DE L'OBJET .RECC :
C     ------------------------------
      CALL GETVID(' ','CHARGE',0,1,0,KBID,N1)
      IF (N1.LT.0) THEN
        NCHAR=-N1
        CALL WKVECT(MATEL//'.RECC','G V K8',NCHAR,JRECC)
        CALL GETVID(' ','CHARGE',0,1,NCHAR,ZK8(JRECC),N1)
      ENDIF

C     -- DESTRUCTION DES RESUELEM NULS :
      CALL REDETR(MATEL)


      CALL JEDETR('&MEAMAC2           .RELR')
      CALL JEDETR('&MEAMAC2           .RERR')

      CALL JEDETR('&MERIAC1           .RELR')
      CALL JEDETR('&MERIAC1           .RERR')
      CALL JEDETR('&MERIAC2           .RELR')
      CALL JEDETR('&MERIAC2           .RERR')

      CALL JEDETR('&MERITH1           .RELR')
      CALL JEDETR('&MERITH2           .RELR')
      CALL JEDETR('&MERITH3           .RELR')
      CALL JEDETR('&MERITH1           .RERR')
      CALL JEDETR('&MERITH2           .RERR')
      CALL JEDETR('&MERITH3           .RERR')

      CALL JEDEMA()
      END
