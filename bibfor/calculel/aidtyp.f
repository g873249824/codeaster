      SUBROUTINE AIDTYP(IMPR)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
C ----------------------------------------------------------------------
C    BUT:
C       ECRIRE SUR LE FICHIER "IMPR"
C       LES COUPLES (OPTION, TYPE_ELEMENT) POSSIBLES DANS LES CATALOGUES
C      (POUR VERIFIER LA COMPLETUDE)
C ----------------------------------------------------------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,KBID
      CHARACTER*16 ZK16,NOPHEN,NOTE,NOOP,NOMODL
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80,LIGNE
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER IMPR,NBTM,NBPHEN,IAOPTE,NBTE,NBOP,IANBOP,IANBTE,IANOT2
      INTEGER IANOP2,IOP,IPHEN,NBMODL,IMODL,IAMODL,ITM,ITE,IOPTTE
      INTEGER IAOPMO,NUCALC
C
C
      CALL JEMARQ()

C
C
      LIGNE(1:40)= '========================================'
      LIGNE(41:80)='========================================'
C
      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
      CALL JELIRA('&CATA.PHENOMENE','NOMUTI',NBPHEN,KBID)
      CALL JEVEUO('&CATA.TE.OPTTE','L',IAOPTE)
      CALL JELIRA('&CATA.TE.NOMTE','NOMUTI',NBTE,KBID)
      CALL JELIRA('&CATA.OP.NOMOPT','NOMUTI',NBOP,KBID)
C
      CALL WKVECT('&&AIDTYP.NBOP','V V I',NBOP,IANBOP)
      CALL WKVECT('&&AIDTYP.NBTE','V V I',NBTE ,IANBTE)
      CALL WKVECT('&&AIDTYP.NOT2','V V K80',NBTE ,IANOT2)
      CALL WKVECT('&&AIDTYP.NOP2','V V K16',NBOP ,IANOP2)
C
C
C     -- REMPLISSAGE DE .NOP2:
C     ------------------------
      DO 7,IOP=1,NBOP
        CALL JENUNO(JEXNUM('&CATA.OP.NOMOPT',IOP),NOOP)
        ZK16(IANOP2-1+IOP)=NOOP
 7    CONTINUE
C
C
C     -- REMPLISSAGE DE .NOT2:
C     ------------------------
      DO 1,IPHEN=1,NBPHEN
        CALL JENUNO(JEXNUM('&CATA.PHENOMENE',IPHEN),NOPHEN)
        CALL JELIRA('&CATA.'//NOPHEN,'NUTIOC',NBMODL,KBID)
        DO 2,IMODL=1,NBMODL
          CALL JEVEUO(JEXNUM('&CATA.'//NOPHEN ,IMODL),'L',IAMODL)
          CALL JENUNO(JEXNUM('&CATA.'//NOPHEN(1:13)//'.MODL',
     &                      IMODL),NOMODL)
          DO 3,ITM=1,NBTM
            ITE= ZI(IAMODL-1+ITM)
            IF (ITE.EQ.0) GO TO 3
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOTE)
            ZK80(IANOT2-1+ITE)=NOPHEN//' '//NOMODL//' '//NOTE
 3        CONTINUE
 2      CONTINUE
 1    CONTINUE
C
C     ON COMPLETE .NOT2 AVEC LES ELEMENTS N'APPARTENANT A AUCUNE
C        MODELISATION NI PHENOMENE:
      DO 6, ITE=1,NBTE
        IF (ZK80(IANOT2-1+ITE)(1:1).EQ.' ') THEN
          CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOTE)
          ZK80(IANOT2-1+ITE)(35:50)=NOTE
        END IF
 6    CONTINUE
C
C
C     -- ECRITURE DES COUPLES (TE,OPT)
C     --------------------------------
      WRITE(IMPR,'(A80)') LIGNE
      WRITE(IMPR,*)' NOMBRE D''OPTION        : ', NBOP
      WRITE(IMPR,*)' NOMBRE DE TYPE_ELEMENT : ', NBTE
      WRITE(IMPR,'(A80)') LIGNE
      DO 10,ITE=1,NBTE
        DO 101,IOP=1,NBOP
          IOPTTE= ZI(IAOPTE-1+NBOP*(ITE-1)+IOP)
          IF (IOPTTE.EQ.0) GO TO 101
          CALL JEVEUO(JEXNUM('&CATA.TE.OPTMOD',IOPTTE),'L',IAOPMO)
          NUCALC= ZI(IAOPMO)
          IF (NUCALC.EQ.0) GO TO 101
          ZI(IANBTE-1+ITE)=ZI(IANBTE-1+ITE)+1
          ZI(IANBOP-1+IOP)=ZI(IANBOP-1+IOP)+1
          WRITE(IMPR,1001) ZK80(IANOT2-1+ITE)(1:50),
     +         ZK16(IANOP2-1+IOP),NUCALC
 101    CONTINUE
 10   CONTINUE
C
C
C     -- ECRITURE RESUME TYPE_ELEMENT:
C     --------------------------------
      WRITE(IMPR,'(A80)') LIGNE
      WRITE(IMPR,*)' RESUME TYPE_ELEMENTS : '
      DO 20, ITE=1,NBTE
        WRITE(IMPR,1001) ZK80(IANOT2-1+ITE)(1:50),' NB_OPT_CALC: ',
     +              ZI(IANBTE-1+ITE)
 20   CONTINUE
C
C
C     -- ECRITURE RESUME OPTIONS:
C     ---------------------------
      WRITE(IMPR,'(A80)') LIGNE
      WRITE(IMPR,*)' RESUME OPTIONS : '
      DO 30, IOP=1,NBOP
        WRITE(IMPR,*)ZK16(IANOP2-1+IOP),' NB_TYP_CALC: ',
     +      ZI(IANBOP-1+IOP)
 30   CONTINUE
      WRITE(IMPR,'(A80)') LIGNE


      CALL JEDETC('V','&&AIDTYP',1)


1001  FORMAT (A50,1X,A16,1X,I5)
      CALL JEDEMA()
      END
