      SUBROUTINE MONTE1(OPT,TE2,NOUT,LCHOUT,LPAOUT,IGR2)
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

C     ARGUMENTS:
C     ----------
      INTEGER OPT,NOUT,TE2,IGR2
      CHARACTER*19 CH19
      CHARACTER*(*) LCHOUT(*)
      CHARACTER*8 LPAOUT(*)
C ----------------------------------------------------------------------
C     ENTREES:
C     IGR2   : NUMERO DU GREL DONT ON SAUVE LES CHAMPS LOCAUX

C     SORTIES:
C     MET A JOUR LES CHAMPS GLOBAUX DE SORTIE DE L OPTION OPT
C ----------------------------------------------------------------------
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS
      INTEGER IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      INTEGER IACHOI,IACHOK
      COMMON /CAII07/IACHOI,IACHOK
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI

C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER NBPARA,GRDEUR,INDIK8,DIGDE2,MODATT
      CHARACTER*8 NOPARA
      CHARACTER*32 JEXNUM

C     VARIABLES LOCALES:
C     ------------------
      INTEGER IPAR,NP,MOD1,JPAR,GD,JPARAL,IRET,IEL,IAUX1,IAUX2,IAUX0
      INTEGER IPARG,IACHLO,LGGREL,JCELV,JRESL
      INTEGER DESCGD,JCELD,CODE,DEBUGR,NCMPEL,DEBGR2
      CHARACTER*8 NOMPAR,TYPSCA
      LOGICAL LPARAL
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80

      CALL JEMARQ()


C     PARALLELE OR NOT ?
      LPARAL=.FALSE.
      CALL JEEXIN('&CALCUL.PARALLELE',IRET)
      IF (IRET.NE.0) THEN
        LPARAL=.TRUE.
        CALL JEVEUO('&CALCUL.PARALLELE','L',JPARAL)
      ENDIF


      NP=NBPARA(OPT,TE2,'OUT')
      DO 20 IPAR=1,NP
        NOMPAR=NOPARA(OPT,TE2,'OUT',IPAR)
        IPARG=INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
        IACHLO=ZI(IAWLOC-1+3*(IPARG-1)+1)
        IF (IACHLO.EQ.-1)GOTO 20

        GD=GRDEUR(NOMPAR)
        DESCGD=IADSGD+7*(GD-1)
        CODE=ZI(DESCGD-1+1)

        MOD1=MODATT(OPT,TE2,'OUT',IPAR)
        JPAR=INDIK8(LPAOUT,NOMPAR,1,NOUT)
        CH19=LCHOUT(JPAR)


        TYPSCA=ZK8(IAWTYP-1+IPARG)
        LGGREL=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR2-1)+4)
        DEBUGR=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR2-1)+5)
        IF (LGGREL.EQ.0) GOTO 20


        IF (CODE.EQ.1) THEN
C         -- CAS : CHAM_ELEM
          JCELD=ZI(IACHOI-1+3*(JPAR-1)+1)
          DEBGR2=ZI(JCELD-1+ZI(JCELD-1+4+IGR2)+8)
          JCELV=ZI(IACHOI-1+3*(JPAR-1)+2)
          CALL JACOPO(LGGREL,TYPSCA,IACHLO+DEBUGR-1,JCELV-1+DEBGR2)


        ELSE
C         -- CAS : RESUELEM
          CALL JEVEUO(JEXNUM(CH19//'.RESL',IGR2),'E',JRESL)

          IF (LPARAL) THEN
C           -- POUR L'INSTANT ON N'ACCEPTE PAS EVFINI=1
            CALL ASSERT(EVFINI.EQ.0)
            NCMPEL=DIGDE2(MOD1)
            DO 10 IEL=1,NBELGR
              IF (ZL(JPARAL-1+IEL)) THEN
                IAUX0=(IEL-1)*NCMPEL
                IAUX1=IACHLO+DEBUGR-1+IAUX0
                IAUX2=JRESL+IAUX0
                CALL JACOPO(NCMPEL,TYPSCA,IAUX1,IAUX2)
              ENDIF
   10       CONTINUE
          ELSE
            CALL JACOPO(LGGREL,TYPSCA,IACHLO+DEBUGR-1,JRESL)
          ENDIF

          CALL JELIBE(JEXNUM(CH19//'.RESL',IGR2))
        ENDIF


   20 CONTINUE

      CALL JEDEMA()
      END
