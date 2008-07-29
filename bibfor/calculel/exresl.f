      SUBROUTINE EXRESL(IMODAT,IPARG,CHIN)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/07/2008   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER IMODAT,IPARG
      CHARACTER*19 CHIN
C ----------------------------------------------------------------------
C     ENTREES:
C        CHIN   : NOM DU CHAMP GLOBAL SUR LEQUEL ON FAIT L'EXTRACTION
C        IGR    : NUMERO DU GROUPE_ELEMENT (COMMON)
C        IMODAT : MODE LOCAL ATTENDU
C ----------------------------------------------------------------------
      INTEGER IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,ILCHLO
      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &       ILCHLO
      COMMON /CAKK02/TYPEGD
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,IAOPPA,
     &        NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      CHARACTER*8 TYPEGD
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER IACHII,IACHIK,IACHIX
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP

C     FONCTIONS EXTERNES:
C     ------------------
      INTEGER DIGDE2
      CHARACTER*32 JEXNUM

C     VARIABLES LOCALES:
C     ------------------
      INTEGER DESC,MODE,NCMPEL,IRET,JPARAL,IEL,IAUX1,IAUX2,IAUX0,K
      INTEGER JRESL,DEBUGR,LGGREL
      LOGICAL LPARAL
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 NOGREL


      CALL JEMARQ()

C     PARALLELE OR NOT ?
C     -------------------------
      CALL JEEXIN('&CALCUL.PARALLELE',IRET)
      IF (IRET.NE.0) THEN
        LPARAL=.TRUE.
        CALL JEVEUO('&CALCUL.PARALLELE','L',JPARAL)
      ELSE
        LPARAL=.FALSE.
      ENDIF

      LGGREL=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+4)
      DEBUGR=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+5)

      DESC=ZI(IACHII-1+11*(IICHIN-1)+4)

      MODE=ZI(DESC-1+2+IGR)

      IF (MODE.EQ.0) THEN
        CALL CODENT(IGR,'D',NOGREL)
        CALL U2MESK('E','CALCULEL2_55',1,NOGREL)
      ENDIF

      CALL ASSERT(MODE.EQ.IMODAT)
      NCMPEL=DIGDE2(MODE)
      CALL ASSERT(LGGREL.EQ.NCMPEL*NBELGR)
      CALL JEVEUO(JEXNUM(CHIN//'.RESL',IGR),'L',JRESL)
      IF (LPARAL) THEN
        DO 10 IEL=1,NBELGR
          IF (ZL(JPARAL-1+IEL)) THEN
            IAUX0=(IEL-1)*NCMPEL
            IAUX1=JRESL+IAUX0
            IAUX2=IACHLO+DEBUGR-1+IAUX0
            CALL JACOPO(NCMPEL,TYPEGD,IAUX1,IAUX2)
          ENDIF
   10   CONTINUE
      ELSE
        CALL JACOPO(LGGREL,TYPEGD,JRESL,IACHLO+DEBUGR-1)
      ENDIF


      IF (LPARAL) THEN
        DO 30 IEL=1,NBELGR
          IF (ZL(JPARAL-1+IEL)) THEN
            IAUX1=ILCHLO+DEBUGR-1+(IEL-1)*NCMPEL
            DO 20 K=1,NCMPEL
              ZL(IAUX1-1+K)=.TRUE.
   20       CONTINUE
          ENDIF
   30   CONTINUE
      ELSE
        DO 40 K=1,LGGREL
          ZL(ILCHLO+DEBUGR-1-1+K)=.TRUE.
   40   CONTINUE
      ENDIF

      CALL JEDEMA()
      END
