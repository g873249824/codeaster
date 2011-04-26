      SUBROUTINE DISMTE(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C     --     DISMOI(TYPE_ELEM)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*32 REPK
      CHARACTER*16 NOMOB
C ----------------------------------------------------------------------
C    IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE TYPE_ELEM (K16)
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI,IBID
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,NOMTM
      CHARACTER*16 ZK16,NOPHEN,NOMODL
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 KBID
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER ITE,NBPHEN,NBTM,ICO,IPHEN,NBMODL,IMODL,IAMODL,II,INDIIS
      INTEGER IAOPTE,NBOPT,IOPT,IOPTTE,NRIG,IRIG
      PARAMETER(NRIG=5)
      CHARACTER*16 OPTRIG(NRIG)
      DATA OPTRIG/'RIGI_ACOU','RIGI_THER','RIGI_MECA','RIGI_MECA_TANG',
     &     'FULL_MECA'/
C
C
C
      CALL JEMARQ()
      NOMOB=NOMOBZ
      REPK=' '
      IERD=0

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMOB),ITE)
      CALL JEVEUO('&CATA.TE.TYPEMA','L',IBID)
      NOMTM=ZK8(IBID-1+ITE)


      IF (QUESTI.EQ.'PHENOMENE') THEN
C     --------------------------------------
        CALL JELIRA('&CATA.PHENOMENE','NOMUTI',NBPHEN,KBID)
        CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
C
        ICO=0
        DO 20,IPHEN=1,NBPHEN
          CALL JENUNO(JEXNUM('&CATA.PHENOMENE',IPHEN),NOPHEN)
          CALL JELIRA('&CATA.'//NOPHEN,'NMAXOC',NBMODL,KBID)
          DO 10,IMODL=1,NBMODL
            CALL JEVEUO(JEXNUM('&CATA.'//NOPHEN,IMODL),'L',IAMODL)
            II=INDIIS(ZI(IAMODL),ITE,1,NBTM)
            IF (II.GT.0) THEN
              REPK=NOPHEN
              GOTO 30

            ENDIF
   10     CONTINUE
   20   CONTINUE
        IERD=1
   30   CONTINUE


      ELSEIF (QUESTI.EQ.'MODELISATION') THEN
C     --------------------------------------
        CALL JELIRA('&CATA.PHENOMENE','NOMUTI',NBPHEN,KBID)
        CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
C
        ICO=0
        DO 50,IPHEN=1,NBPHEN
          CALL JENUNO(JEXNUM('&CATA.PHENOMENE',IPHEN),NOPHEN)
          CALL JELIRA('&CATA.'//NOPHEN,'NMAXOC',NBMODL,KBID)
          DO 40,IMODL=1,NBMODL
            CALL JEVEUO(JEXNUM('&CATA.'//NOPHEN,IMODL),'L',IAMODL)
            II=INDIIS(ZI(IAMODL),ITE,1,NBTM)
            IF (II.GT.0) THEN
              CALL JENUNO(JEXNUM('&CATA.'//NOPHEN(1:13)//'.MODL',IMODL),
     &                    NOMODL)
              REPK=NOMODL
              ICO=ICO+1
            ENDIF
   40     CONTINUE
          IF (ICO.GT.0) THEN
            IF (ICO.EQ.1) THEN
              GOTO 60

            ELSEIF (ICO.GT.1) THEN
              REPK='#PLUSIEURS'
              GOTO 60

            ENDIF
          ENDIF
   50   CONTINUE
        IERD=1
   60   CONTINUE


      ELSEIF ((QUESTI.EQ.'PHEN_MODE')) THEN
C     --------------------------------------
        CALL JELIRA('&CATA.PHENOMENE','NOMUTI',NBPHEN,KBID)
        CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
C
        ICO=0
        DO 80,IPHEN=1,NBPHEN
          CALL JENUNO(JEXNUM('&CATA.PHENOMENE',IPHEN),NOPHEN)
          CALL JELIRA('&CATA.'//NOPHEN,'NMAXOC',NBMODL,KBID)
          DO 70,IMODL=1,NBMODL
            CALL JEVEUO(JEXNUM('&CATA.'//NOPHEN,IMODL),'L',IAMODL)
            II=INDIIS(ZI(IAMODL),ITE,1,NBTM)
            IF (II.GT.0) THEN
              CALL JENUNO(JEXNUM('&CATA.'//NOPHEN(1:13)//'.MODL',IMODL),
     &                    NOMODL)
              REPK=NOPHEN//NOMODL
              ICO=ICO+1
            ENDIF
   70     CONTINUE
   80   CONTINUE
        IF (ICO.GT.1) THEN
          REPK='#PLUSIEURS'
        ELSEIF (ICO.EQ.0) THEN
          REPK='#AUCUN'
        ENDIF


      ELSEIF (QUESTI.EQ.'NOM_TYPMAIL') THEN
C     --------------------------------------
        CALL JEVEUO('&CATA.TE.TYPEMA','L',IBID)
        REPK=ZK8(IBID-1+ITE)


      ELSEIF (QUESTI.EQ.'TYPE_TYPMAIL') THEN
C     --------------------------------------
        CALL DISMTM(QUESTI,NOMTM,REPI,REPK,IERD)


      ELSEIF (QUESTI.EQ.'NBNO_TYPMAIL') THEN
C     --------------------------------------
        CALL DISMTM(QUESTI,NOMTM,REPI,REPK,IERD)


      ELSEIF (QUESTI.EQ.'DIM_TOPO') THEN
C     --------------------------------------
        CALL DISMTM(QUESTI,NOMTM,REPI,REPK,IERD)


      ELSEIF (QUESTI.EQ.'DIM_GEOM') THEN
C     --------------------------------------
        CALL JEVEUO('&CATA.TE.DIM_GEOM','L',IBID)
        REPI=ZI(IBID-1+ITE)


      ELSEIF (QUESTI.EQ.'CALC_RIGI') THEN
C     --------------------------------------
        REPK='NON'
        CALL JEVEUO('&CATA.TE.OPTTE','L',IAOPTE)
        CALL JELIRA('&CATA.OP.NOMOPT','NOMMAX',NBOPT,KBID)
        DO 90,IRIG=1,NRIG
          CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',OPTRIG(IRIG)),IOPT)
          CALL ASSERT(IOPT.GT.0)
          IOPTTE=ZI(IAOPTE-1+(ITE-1)*NBOPT+IOPT)
          IF (IOPTTE.EQ.0)GOTO 90
          REPK='OUI'
          GOTO 100

   90   CONTINUE
  100   CONTINUE


      ELSE
        IERD=1
      ENDIF
C
      REPKZ=REPK
      CALL JEDEMA()
      END
