      SUBROUTINE DCHLMX(OPT,LIGREL,NOMPAR,NIN,LPAIN,NOUT,LPAOUT,
     &          TAILLE)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 22/07/2008   AUTEUR PELLET J.PELLET 
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
      INTEGER OPT,NIN,NOUT,TAILLE
      CHARACTER*19 LIGREL
      CHARACTER*8 NOMPAR
      CHARACTER*8 LPAIN(*),LPAOUT(*)
C ----------------------------------------------------------------------
C     ENTREES:
C      OPT : OPTION
C     LIGREL: LIGREL
C     NOMPAR: NOM DU PARAMETRE

C     SORTIES:
C     TAILLE: DIMENSION MAXIMALE D'UN CHAMP_LOC (NOMPAR)
C             =MAX(DIMENSION_D_UN_ELEMENT)*NBEL(IGR))
C             =0 => AUCUN TYPE_ELEM NE CONNAIT LE PARAMETRE NOMPAR
C ----------------------------------------------------------------------

      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII07/IACHOI,IACHOK
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     +       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
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
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER NBGREL,TYPELE,NBPARA,MODATT,DIGDE2,MAX,INDIK8,NBELEM
      INTEGER IACHII,IACHIK,IACHIX,IACHOI,IACHOK
      INTEGER IPARIN,IPAROU,JCELD
      INTEGER LGGREL,NBELGR,NGREL,NPIN,NPOU
      INTEGER IGR,TE,IPAR,NVAL,MODE
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,IAOPPA
      INTEGER NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER NBSP,NCDYN,JEL,TAILL1,JRSVI,JCRSVI
      CHARACTER*8 NOPARA,TYCH
      CHARACTER*8 NOPARE

C DEB-------------------------------------------------------------------

      TAILLE = 0

      NGREL = NBGREL(LIGREL)
      DO 30 IGR = 1,NGREL
        TE = TYPELE(LIGREL,IGR)
        NBELGR = NBELEM(LIGREL,IGR)
        NPIN = NBPARA(OPT,TE,'IN ')
        NPOU = NBPARA(OPT,TE,'OUT')

C           ---IN:
C           ------
        DO 10 IPAR = 1,NPIN
          NOPARE = NOPARA(OPT,TE,'IN ',IPAR)
          IF (NOPARE.EQ.NOMPAR) THEN
            IPARIN = INDIK8(LPAIN,NOMPAR,1,NIN)
            MODE = MODATT(OPT,TE,'IN ',IPAR)
            NVAL = DIGDE2(MODE)
            TYCH = ZK8(IACHIK-1+2* (IPARIN-1)+1)

C           CAS DES CHAM_ELEM POTENTIELLEMENT ETENDUS :
            IF (TYCH(1:4).EQ.'CHML') THEN
              JCELD = ZI(IACHII-1+11* (IPARIN-1)+4)

C             CAS DES CHAM_ELEM ETENDUS :
              IF ((ZI(JCELD-1+3).GT.1).OR.(ZI(JCELD-1+4).GT.1)) THEN
                TAILL1=0
                DO 11, JEL=1,NBELGR
                  NBSP  = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4*(JEL-1)+1)
                  NCDYN = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4*(JEL-1)+2)
                  NBSP =MAX(NBSP,1)
                  NCDYN=MAX(NCDYN,1)
                  TAILL1=TAILL1+NVAL*NCDYN*NBSP
 11             CONTINUE

C             CAS DES CHAM_ELEM NON ETENDUS :
              ELSE
                TAILL1=NVAL*NBELGR
              ENDIF
            ELSE
              TAILL1=NVAL*NBELGR
            ENDIF

            IF (CALVOI.EQ.0) THEN
              TAILLE = MAX(TAILLE,TAILL1)
            ELSE
              TAILLE = TAILLE+TAILL1
            ENDIF

            GO TO 29
          END IF
   10   CONTINUE

C           ---OUT:
C           ------
        DO 20 IPAR = 1,NPOU
          NOPARE = NOPARA(OPT,TE,'OUT',IPAR)
          IF (NOPARE.EQ.NOMPAR) THEN
            IPAROU = INDIK8(LPAOUT,NOMPAR,1,NOUT)
            MODE = MODATT(OPT,TE,'OUT',IPAR)
            NVAL = DIGDE2(MODE)
            TYCH = ZK8(IACHOK-1+2* (IPAROU-1)+1)

            IF (TYCH(1:4).EQ.'CHML') THEN
C             -- CAS DES CHAM_ELEM :
              JCELD = ZI(IACHOI-1+3*(IPAROU-1)+1)
              LGGREL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4)
            ELSE
C             -- CAS DES RESUELEM :
              LGGREL = NVAL*NBELGR
              IF (EVFINI.EQ.1) THEN
                JRSVI = ZI(IACHOI-1+3*(IPAROU-1)+2)
                IF (JRSVI.NE.0) THEN
                  JCRSVI = ZI(IACHOI-1+3*(IPAROU-1)+3)
                  LGGREL = ZI(JRSVI-1+ZI(JCRSVI-1+IGR)+NBELGR)-1
                ENDIF
              ENDIF
            END IF
            TAILLE = MAX(TAILLE,LGGREL)

            GO TO 29
          END IF
   20   CONTINUE

   29   CONTINUE

   30 CONTINUE
   40 CONTINUE
      END
