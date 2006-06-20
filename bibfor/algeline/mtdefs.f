      SUBROUTINE MTDEFS ( MATOUT, MATIN, BASE, TYPC)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       MATOUT, MATIN, BASE, TYPC
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 19/06/2006   AUTEUR VABHHTS J.PELLET 
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
C     ------------------------------------------------------------------
C     DEFINITION DE LA STRUCTURE D'UNE MATRICE "MATOUT"
C       QUI S'APPUIE SUR LA MEME NUMEROTATION QUE "MATIN",
C       QUI A LA MEME STRUCTURE (PROFIL PAR BLOC/MORSE) QUE "MATIN"
C     LA MATRICE "MATOUT" EST CREEE SUR LA BASE "BASE".
C     LA MATRICE "MATOUT" EST A COEFFICIENTS "TYPE".
C     ------------------------------------------------------------------
C IN  MATOUT : CH19: NOM DE LA MATRICE A CREER
C IN  MATIN  : CH19: NOM DE LA MATRICE MODELE
C IN  BASE   : CH1 : NOM DE LA BASE SUR LAQUELLE LA MATRICE DOIT ETRE
C                    CREER
C IN  TYPC   : CH1 : TYPE DES VALEURS DE LA MATRICE A CREER
C              'R'  ==> COEFFICIENTS REELS
C              'C'  ==> COEFFICIENTS COMPLEXES
C              ' '  ==> COEFFICIENTS DU TYPE DE LA MATRICE MATIN
C     ------------------------------------------------------------------
C     PRECAUTIONS D'EMPLOI :
C       1) LA MATRICE "MATOUT" NE DOIT PAS EXISTER
C       2) LES COEFFICIENTS DE LA MATRICE "MATOUT" NE SONT PAS AFFECTES
C     ------------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      INTEGER       NBVAL,IVAL, JREFAO, JREFAI
      CHARACTER*1   CLASSE, TYPE
      CHARACTER*2   TYMA
      CHARACTER*8   CBID
      CHARACTER*19  NOMOUT, NOMIN
      CHARACTER*24  VALM, REFA , LIME
      CHARACTER*32  JEXNUM
C     ------------------------------------------------------------------
      CALL JEMARQ()
      CLASSE = BASE(1:1)

      NOMIN = MATIN
      NOMOUT = MATOUT

C     -- OBJET .REFA :
C     ----------------------------
      REFA = NOMIN//'.REFA'
      CALL JELIRA(REFA,'LONMAX',NBVAL,CBID)
      CALL JEVEUO(REFA,'L',JREFAI)
      REFA = NOMOUT//'.REFA'
      CALL JECREO(REFA,CLASSE//' V K24')
      CALL JEECRA(REFA,'LONMAX',NBVAL,'  ')
      CALL JEVEUO(REFA,'E',JREFAO)
      DO 10 IVAL=0,NBVAL-1
         ZK24(JREFAO+IVAL) = ZK24(JREFAI+IVAL)
  10  CONTINUE

      REFA = NOMIN//'.REFA'


C     -- RECOPIE DU .LIME:
C     --------------------------
      LIME = NOMIN//'.LIME'
      CALL JEEXIN(LIME,IRET)
      IF (IRET.GT.0) THEN
        CALL JELIRA(LIME,'LONMAX',NBVAL,CBID)
        CALL JEVEUO(LIME,'L',JREFAI)
C
        LIME = NOMOUT//'.LIME'
        CALL JECREO(LIME,CLASSE//' V K8')
        CALL JEECRA(LIME,'LONMAX',NBVAL,'  ')
        CALL JEVEUO(LIME,'E',JREFAO)
        DO 15 IVAL=0,NBVAL-1
           ZK8(JREFAO+IVAL) = ZK8(JREFAI+IVAL)
  15    CONTINUE
      ENDIF


C     -- CREATION DE LA COLLECTION .VALM :
C     --------------------------------------------------------------
      VALM = NOMIN//'.VALM'
      TYPE = TYPC(1:1)
      IF (TYPE.EQ.' ' ) CALL JELIRA(VALM,'TYPE',IVAL,TYPE)
      CALL JELIRA(VALM,'NMAXOC',NBBLOC,CBID)
      CALL JELIRA(JEXNUM(VALM,1),'LONMAX',LGBLOC,CBID)
      VALM = NOMOUT//'.VALM'
      CALL JECREC(VALM,CLASSE//' V '//TYPE,
     +                           'NU','DISPERSE','CONSTANT',NBBLOC)
      CALL JEECRA(VALM,'LONMAX',LGBLOC,CBID)
      DO 20 IBLOC = 1, NBBLOC
         CALL JECROC( JEXNUM(VALM,IBLOC) )
  20  CONTINUE


      CALL JEDEMA()
      END
