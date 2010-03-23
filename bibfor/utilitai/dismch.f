      SUBROUTINE DISMCH(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 23/03/2010   AUTEUR GENIAUT S.GENIAUT 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C     --     DISMOI(CHARGE)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*32 REPK
      CHARACTER*8 NOMOB,MODELE
C ----------------------------------------------------------------------
C     IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE  CHARGE
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*4  SUF
      CHARACTER*8  K8BID,TEMPE,HYDRAT,SECHAG
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,KTYP
      CHARACTER*16 ZK16,TYPECO
      CHARACTER*19 NOM19
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      NOM19 = NOMOBZ
      REPK  = REPKZ

C     -- CHARGE OU CHAR_CINE ?
      CALL JEEXIN(NOMOB//'.TYPE',IER1)
      CALL JEEXIN(NOM19//'.AFCK',IER2)
      IF (IER1.EQ.0.AND.IER2.EQ.0.OR.
     &    IER1.NE.0.AND.IER2.NE.0) THEN
        IERD=1
        GOTO 9999
      ENDIF
      
      IF (IER1.GT.0) THEN
        CALL JEVEUO(NOMOB//'.TYPE','L',IATYPE)
        KTYP=ZK8(IATYPE)
      ELSEIF (IER2.GT.0) THEN
        CALL JEVEUO(NOM19//'.AFCK','L',JAFCK)
        KTYP=ZK8(JAFCK)
        MODELE=ZK8(JAFCK-1+2)
      ENDIF

      IF (KTYP(1:5).EQ.'MECA_') THEN
         IPHEN = 1
         SUF = 'CHME'
      ELSE IF (KTYP(1:5).EQ.'THER_') THEN
         IPHEN = 2
         SUF = 'CHTH'
      ELSE IF (KTYP(1:5).EQ.'ACOU_') THEN
         IPHEN = 3
         SUF = 'CHAC'
      ELSE IF (KTYP(1:5).EQ.'CIME_') THEN
         IPHEN = 1
         SUF = 'CIME'
      ELSE IF (KTYP(1:5).EQ.'CITH_') THEN
         IPHEN = 2
         SUF = 'CITH'
      ELSE IF (KTYP(1:5).EQ.'CIAC_') THEN
         IPHEN = 3
         SUF = 'CIAC'
      ELSE
         CALL U2MESS('F','UTILITAI_52')
      END IF

      IF (SUF(1:2).EQ.'CH') THEN
         CALL JEVEUO(NOMOB//'.'//SUF//'.MODEL.NOMO','L',IANOMO)
         MODELE = ZK8(IANOMO)
      ENDIF


      IF (QUESTI.EQ.'PHENOMENE') THEN
         IF (IPHEN.EQ.1) THEN
            REPK = 'MECANIQUE'
         ELSE IF (IPHEN.EQ.2) THEN
            REPK = 'THERMIQUE'
         ELSE IF (IPHEN.EQ.3) THEN
            REPK = 'ACOUSTIQUE'
         ELSE
            REPK = ' '
         END IF


      ELSE IF (QUESTI.EQ.'NOM_MODELE') THEN
         REPK = MODELE

      ELSE IF (QUESTI.EQ.'TYPE_CHARGE') THEN
         REPK = KTYP

      ELSE IF (QUESTI.EQ.'NOM_MAILLA') THEN
         CALL DISMMO(CODMES,QUESTI,MODELE,REPI,REPK,IERD)

      ELSE IF (QUESTI.EQ.'NOM_LIGREL') THEN
         REPK = NOMOB//'.'//SUF//'.LIGRE'

      ELSE
         REPK = QUESTI
         CALL U2MESK('F','UTILITAI_49',1,REPK)
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
