      SUBROUTINE OP0127 (IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C***********************************************************************
C    P. RICHARD     DATE 13/07/90
C-----------------------------------------------------------------------
C    BUT: CREER LA NUMEROTATION DES DEGRES DE LIBERTE GENERALISES
C    CONCEPT CREE: NUME_DDL_GENE
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
      INTEGER  IER
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      CHARACTER*8  NOMRES,MODGEN,MODMEC,OPTION
      CHARACTER*16 NOMCON,NOMOPE
      CHARACTER*14 NUGENE
      CHARACTER*24 TYPROF
      INTEGER      IBID1,IBID2,IOPT
      REAL*8       RTBLOC,JEVTBL

C
C-----------------------------------------------------------------------
      CALL INFMAJ()
C
C-----RECUPERATION DU MODELE AMONT
C
      CALL GETVID(' ','MODELE_GENE',1,1,1,MODGEN,IBID1)
      CALL GETVID(' ','BASE',1,1,1,MODMEC,IBID2)
C
      IF (IBID1.EQ.0.AND.IBID2.EQ.0) THEN
        CALL U2MESG('F', 'ALGORITH13_84',0,' ',0,0,0,0.D0)
      ENDIF
C
      CALL GETVTX(' ','STOCKAGE',0,1,1,TYPROF,IBID2)
C
      CALL GETRES(NOMRES,NOMCON,NOMOPE)
      NUGENE=NOMRES


C-----NUMEROTATION DES DEGRES DE LIBERTE
      IF (IBID1.NE.0) THEN
        CALL GETVTX(' ','METHODE',1,1,1,OPTION,IOPT)
        IF (OPTION.EQ.'CLASSIQU') THEN
          CALL NUMGEN(NUGENE,MODGEN)
          CALL STRMAG(NUGENE,TYPROF)
        ELSE
          CALL NUMGCY(NUGENE,MODGEN)
        ENDIF
      ELSEIF (IBID2.NE.0) THEN
        CALL NUMMOD(NUGENE,MODMEC)
      ENDIF
      CALL CRNSLV(NUGENE,'LDLT','SANS','G')

C     -- ON CREE LE PROFIL LCIEL:
      RTBLOC=JEVTBL()
      CALL SMOSLI(NUGENE//'.SMOS',NUGENE//'.SLCS','G',RTBLOC)

      END
