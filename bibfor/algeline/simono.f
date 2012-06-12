      SUBROUTINE SIMONO
      IMPLICIT REAL*8 (A-H,O-Z)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 11/06/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C
C     OPERATEUR :   CALC_CHAR_SEISME
C
C     CREE LE VECTEUR SECOND MEMBRE DANS LE CAS D'UN CALCUL SISMIQUE
C     STRUCTURE : MONO-APPUI
C
C     ------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      LMAT, NEQ, IBID
      REAL*8       XNORM, DEPL(6)
      CHARACTER*8  TABCMP(6), MASSE, K8B
      CHARACTER*14 NUME
      CHARACTER*16 TYPE, NOMCMD
      CHARACTER*19 RESU
      INTEGER      IARG
C     ------------------------------------------------------------------
      DATA   TABCMP / 'DX' , 'DY' , 'DZ' , 'DRX' , 'DRY' , 'DRZ' /
C     ------------------------------------------------------------------
C
C --- RECUPERATION DES ARGUMENTS DE LA COMMANDE
C
      CALL JEMARQ()
      RESU = ' '
      CALL GETRES(RESU,TYPE,NOMCMD)
C
C --- MATRICE DE MASSE
C
      CALL GETVID(' ','MATR_MASS',0,IARG,1,MASSE,NBV)
      CALL MTDSCR(MASSE)
      CALL JEVEUO(MASSE//'           .&INT','E',LMAT)
      CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,NUME,IE)
      CALL DISMOI('F','NB_EQUA'     ,MASSE,'MATR_ASSE',NEQ ,K8B ,IE)
C
C --- QUELLE EST LA DIRECTION ?
C
      CALL GETVR8(' ','DIRECTION',0,IARG,0,DEPL,NBD)
      NBDIR = -NBD
      CALL GETVR8(' ','DIRECTION',0,IARG,NBDIR,DEPL,NBD)
C
C     --- ON NORMALISE LE VECTEUR ---
      XNORM = 0.D0
      DO 10 I = 1,NBDIR
         XNORM = XNORM + DEPL(I) * DEPL(I)
 10   CONTINUE
      XNORM = SQRT(XNORM)
      IF (XNORM.LT.0.D0) THEN
         CALL U2MESS('F','ALGORITH9_81')
      ENDIF
      DO 12 I = 1,NBDIR
         DEPL(I) = DEPL(I) / XNORM
 12   CONTINUE
C
      CALL WKVECT('&&SIMONO.VECTEUR','V V R',NEQ,JVEC)
      CALL WKVECT('&&SIMONO.DDL'    ,'V V I',NEQ*NBDIR,JDDL)
      CALL PTEDDL('NUME_DDL',NUME,NBDIR,TABCMP,NEQ,ZI(JDDL))
      DO 20 I = 1 , NBDIR
         DO 22 IN = 0,NEQ-1
            ZR(JVEC+IN) = ZR(JVEC+IN) - ZI(JDDL+(I-1)*NEQ+IN)*DEPL(I)
 22      CONTINUE
 20   CONTINUE
C
C     --- CREATION DU CHAMNO ---
C
      CALL VTCREM(RESU,MASSE,'G','R')
      CALL JEVEUO(RESU//'.VALE','E',IDCHM)
C
      CALL MRMULT('ZERO',LMAT,ZR(JVEC),ZR(IDCHM),1,.TRUE.)
C
C      CALL WKVECT('&&SIMONO.DDL.BLOQUE','V V I',NEQ,IDDL)
C      CALL TYPDDL('BLOQ',NUME,NEQ,ZI(IDDL),NBACT,NBBLO,NBLAG,NBLIAI)
C      DO 40 IN = 0,NEQ-1
C         ZR(IDCHM+IN) = ( 1 - ZI(IDDL+IN) ) * ZR(IDCHM+IN)
C 40   CONTINUE
C
      CALL JEDETC(' ','&&SIMONO',1)
C
      CALL JEDEMA()
      END
