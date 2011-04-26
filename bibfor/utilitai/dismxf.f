      SUBROUTINE DISMXF(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
      IMPLICIT NONE
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT

C     --     DISMOI(XFEM)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,NOMOBZ,REPKZ
      CHARACTER*32 REPK
      CHARACTER*8 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE SD_FISS_XFEM
C     OUT:
C       REPI   : REPONSE ( SI ENTIER )
C       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD    : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      INTEGER JINFO,JMOD,LONG
      CHARACTER*8 K8BID

C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
      CALL JEMARQ()
      NOMOB=NOMOBZ
      REPK=' '

      IF (QUESTI.EQ.'TYPE_DISCONTINUITE') THEN

        CALL JEVEUO(NOMOB//'.INFO','L',JINFO)
        REPK = ZK16(JINFO-1+1)

      ELSE IF (QUESTI.EQ.'CHAM_DISCONTINUITE') THEN

        CALL JEVEUO(NOMOB//'.INFO','L',JINFO)
        REPK = ZK16(JINFO-1+2)

      ELSE IF (QUESTI.EQ.'NOM_MODELE') THEN

        CALL JEVEUO(NOMOB//'.MODELE','L',JMOD)
        REPK = ZK8(JMOD-1+1)

      ELSE IF (QUESTI.EQ.'NB_FOND') THEN

        CALL JELIRA(NOMOB//'.FONDMULT','LONMAX',LONG,K8BID)
        REPI = LONG/2

      ELSE IF (QUESTI.EQ.'NB_POINT_FOND') THEN

        CALL JELIRA(NOMOB//'.FONDFISS','LONMAX',LONG,K8BID)
        REPI = LONG/4

      ELSE

        IERD=1

      END IF
C
      REPKZ = REPK
      CALL JEDEMA()
      END
