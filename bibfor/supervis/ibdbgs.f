      SUBROUTINE IBDBGS ()
      IMPLICIT REAL*8 (A-H,O-Z)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 20/11/2006   AUTEUR PELLET J.PELLET 
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
C     OPTION DE DEBUG DEMANDE
C     ------------------------------------------------------------------
C            0 TOUT C'EST BIEN PASSE
C            1 ERREUR DANS LA LECTURE DE LA COMMANDE
C     ------------------------------------------------------------------
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
C     ----- DEBUT COMMON DE DEBUG JEVEUX
      INTEGER          LUNDEF,IDEBUG
      COMMON /UNDFJE/  LUNDEF,IDEBUG
      REAL*8           TBLOC
      COMMON /RTBLJE/  TBLOC

C     COMMON DEBUI1  : INF. GENERALES DES COMMANDES DEBUT/POURSUITE :
C       - ISDVER :  /0 -> SDVERI='NON'
C                   /1 -> SDVERI='OUI'
C         ISDVER EST UTILISE PAR LA ROUTINE VERIS3
      INTEGER          ISDVER
      COMMON /DEBUI1/  ISDVER
C ----------------------------------------------------------------------
      CHARACTER*3  REPONS
      CHARACTER*16 NOMCMD,CBID,MEMOIR, CMPIN, CMPOUT
      INTEGER SEGJVX,LSEGJV, LOUT,SDVERI
      REAL*8 VPARJV
C
C     --- OPTIONS PAR DEFAUT ---
      CALL JEMARQ()
      REPONS = 'NON'
      MEMOIR = 'RAPIDE'
      TBLOC=800.D0
C
      CALL GETVTX('DEBUG','JXVERI',1,1,1,REPONS,L)
      CALL GETRES(CBID,CBID,NOMCMD)
      IF ( REPONS .EQ. 'OUI') THEN
         CALL U2MESS('I','SUPERVIS_23')
      ENDIF

      CALL GETVTX('DEBUG','SDVERI',1,1,1,REPONS,L)
      CALL GETRES(CBID,CBID,NOMCMD)
      IF ( REPONS .EQ. 'OUI') THEN
         IF (SDVERI().EQ.1) THEN
           ISDVER=1
           CALL U2MESS('I','SUPERVIS_24')
         ELSE
           ISDVER=0
           CALL U2MESS('A','SUPERVIS_42')
         ENDIF
      ELSE
         ISDVER=0
      ENDIF

      CALL GETVTX('DEBUG','JEVEUX',1,1,1,REPONS,L)
      CALL GETRES(CBID,CBID,NOMCMD)
      IF ( REPONS.NE.'OUI' .AND. REPONS.NE.'NON') THEN
         CALL UTDEBM('E','IBDBGS','ARGUMENT ERRONE POUR LE MOT '//
     &                      'CLE "DEBUG JEVEUX" ')
         CALL UTIMPK('S',':',1,REPONS)
         CALL UTIMPK('L','LES ARGUMENTS AUTORISES SONT',1,'OUI')
         CALL UTIMPK('S',',',1,'NON')
         CALL UTFINM()
      ENDIF
      IF ( REPONS .EQ. 'OUI') THEN
         CALL U2MESS('I','SUPERVIS_12')
         IDEBUG = 1
      ENDIF
C
      CALL GETVTX('DEBUG','ENVIMA',1,1,1,REPONS,L)
      IF ( REPONS .EQ. 'TES' ) THEN
         IFI = IUNIFI ( 'RESULTAT' )
         CALL IMPVEM  ( IFI )
      ENDIF
C
      CMPIN='ABORT'
      CALL GETVTX('ERREUR','ERREUR_F',1,1,1,CMPIN, L)
      IF(L.EQ.1)THEN
         CALL ONERRF(CMPIN, CMPOUT, LOUT)
      ENDIF
C
      CALL GETVTX('MEMOIRE','GESTION',1,1,1,MEMOIR,L)
      CALL GETVIS('MEMOIRE','TYPE_ALLOCATION',1,1,1,ISEG,L)
      IF (L.LE.0) ISEG = SEGJVX(-1)
      CALL GETVIS('MEMOIRE','TAILLE',1,1,1,ITAIL,L)
      IF (L.LE.0) ITAIL = LSEGJV(-1)
      CALL GETVR8('MEMOIRE','PARTITION',1,1,1,RVAL,L)
      IF (L.LE.0) THEN
        R8BID = -1.0D0
        RVAL = VPARJV(R8BID)
      ENDIF

      CALL GETVR8('MEMOIRE','TAILLE_BLOC',1,1,1,TBLOC,L)

      CALL GETRES(CBID,CBID,NOMCMD)
      IF ( MEMOIR(1:8).NE.'COMPACTE' .AND.
     &     MEMOIR(1:6).NE.'RAPIDE') THEN
         CALL UTDEBM('E','IBDBGS','ARGUMENT ERRONE POUR LE MOT '//
     &                   'CLE "MEMOIRE GESTION" ')
         CALL UTIMPK('S',':',1,MEMOIR)
         CALL UTIMPK('L','LES ARGUMENTS AUTORISES SONT',1,'COMPACTE')
         CALL UTIMPK('S',',',1,'RAPIDE')
         CALL UTFINM()
      ENDIF
      IF ( MEMOIR(1:8) .EQ. 'COMPACTE') THEN
         CALL U2MESS('I','SUPERVIS_25')
         CALL JETYPR('DEBUT','XD',ISEG,ITAIL,RVAL)
      ELSE
         CALL JETYPR('DEFAUT','XX',ISEG,ITAIL,RVAL)
      ENDIF
      IF (ISEG .EQ. 2) THEN
        CALL U2MESS('I','SUPERVIS_26')
      ELSE IF (ISEG .EQ. 3) THEN
        CALL U2MESS('I','SUPERVIS_27')
        CALL UTDEBM('I','IBDBGS','TAILLE DES SEGMENTS')
        CALL UTIMPI('S',' ',1,ITAIL)
        CALL UTFINM()
      ELSE IF (ISEG .EQ. 4) THEN
        CALL U2MESS('I','SUPERVIS_28')
        CALL UTDEBM('I','IBDBGS','TAILLE DES SEGMENTS')
        CALL UTIMPI('S',' ',1,ITAIL)
        CALL UTFINM()
        CALL UTDEBM('I','IBDBGS',
     &              'TAILLE DE LA PARTITION PRINCIPALE')
        CALL UTIMPR('S',' ',1,RVAL)
        CALL UTFINM()
      ENDIF
C
      CALL JEDEMA()
      END
