      SUBROUTINE DISMMA(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C     --     DISMOI(MAILLAGE)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*32 REPK
      CHARACTER*8 NOMOB
      CHARACTER*(*) NOMOBZ,REPKZ
C ----------------------------------------------------------------------
C    IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE LIGREL
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)

C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*8 ZK8,KBID
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------



      CALL JEMARQ()
      NOMOB = NOMOBZ
      CALL JEVEUO(NOMOB//'.DIME','L',IADIME)

      IF (QUESTI.EQ.'NB_MA_MAILLA') THEN
        REPI = ZI(IADIME-1+3)

      ELSE IF (QUESTI.EQ.'NB_SM_MAILLA') THEN
        REPI = ZI(IADIME-1+4)

      ELSE IF (QUESTI.EQ.'NB_NO_MAILLA') THEN
        REPI = ZI(IADIME-1+1)

      ELSE IF (QUESTI.EQ.'NB_NL_MAILLA') THEN
        REPI = ZI(IADIME-1+2)

      ELSE IF (QUESTI.EQ.'NB_NO_SS_MAX') THEN
        NBSM = ZI(IADIME-1+4)
        REPI = 0
        DO 10,ISM = 1,NBSM
          CALL JELIRA(JEXNUM(NOMOB//'.SUPMAIL',ISM),'LONMAX',NNO,KBID)
          REPI = MAX(REPI,NNO)
   10   CONTINUE

      ELSE IF (QUESTI.EQ.'DIM_GEOM') THEN
        REPI = ZI(IADIME-1+6)

      ELSE IF (QUESTI.EQ.'Z_CST') THEN
        NBNO = ZI(IADIME-1+1)
        CALL JEVEUO(NOMOB//'.COORDO    .VALE','L',IAGEOM)
        Z1 = ZR(IAGEOM-1+3)
        DO 20,INO = 2,NBNO
          IF (ZR(IAGEOM-1+3* (INO-1)+3).NE.Z1) GO TO 30
   20   CONTINUE
        REPK = 'OUI'
        GO TO 50
   30   CONTINUE
        REPK = 'NON'

      ELSE IF (QUESTI.EQ.'NB_NO_MA_MAX') THEN
        NBMA = ZI(IADIME-1+3)
        CALL JEVEUO(JEXATR(NOMOB//'.CONNEX','LONCUM'),'L',ILMACO)
        REPI = 0
        DO 40,K = 1,NBMA
          NBNO = ZI(ILMACO+K) - ZI(ILMACO-1+K)
          REPI = MAX(REPI,NBNO)
   40   CONTINUE

      ELSE
        REPK = QUESTI
        CALL U2MESK(CODMES,'UTILITAI_49',1,REPK)
        IERD = 1
        GO TO 50
      END IF

   50 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
