      SUBROUTINE DISMME(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
C     --     DISMOI(MATR_ELEM OU VECT_ELEM)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*(*) NOMOBZ, REPKZ
      CHARACTER*32  REPK
      CHARACTER*8   NOMOB
C ----------------------------------------------------------------------
C    IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE CONCEPT MATR_ELEM
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*7  TYPMAT
      INTEGER      IRET,I,I1,IALIRE,IAREFE,NBRESU
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
      LOGICAL ZL,ZEROSD
      CHARACTER*8 ZK8,MO
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 KBID
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK = REPKZ
      CALL JEVEUO(NOMOB//'.REFE_RESU      ','L',IAREFE)
      MO = ZK24(IAREFE-1+1)(1:8)
C
      IF (QUESTI.EQ.'NOM_MODELE') THEN
         REPK = MO
      ELSE IF (QUESTI.EQ.'TYPE_MATRICE') THEN
         REPK='SYMETRI'
         CALL JEEXIN(NOMOB//'.LISTE_RESU', IRET)
         IF (IRET.GT.0) THEN 
           CALL JEVEUO(NOMOB//'.LISTE_RESU','L',IALIRE)
           CALL JELIRA(NOMOB//'.LISTE_RESU','LONUTI',NBRESU,KBID)
           DO 1, I=1,NBRESU
             CALL DISMRE(CODMES,QUESTI,ZK24(IALIRE-1+I),REPI,TYPMAT,I1)
             IF ((I1.EQ.0).AND.(TYPMAT.EQ.'NON_SYM')) THEN
                IF (.NOT.ZEROSD('RESUELEM',ZK24(IALIRE-1+I)))  THEN
                   REPK='NON_SYM'
                   GO TO 9999
                END IF
             END IF
 1         CONTINUE
         ENDIF
      ELSE IF (QUESTI.EQ.'CHAM_MATER') THEN
         REPK=ZK24(IAREFE-1+4)
      ELSE IF (QUESTI.EQ.'CARA_ELEM') THEN
         REPK=ZK24(IAREFE-1+5)
      ELSE IF (QUESTI.EQ.'NOM_MAILLA') THEN
         CALL DISMMO(CODMES,QUESTI,MO,REPI,REPK,IERD)
      ELSE IF (QUESTI.EQ.'PHENOMENE') THEN
         CALL DISMMO(CODMES,QUESTI,MO,REPI,REPK,IERD)
      ELSE IF (QUESTI.EQ.'SUR_OPTION') THEN
         REPK= ZK24(IAREFE-1+2)(1:16)
      ELSE IF (QUESTI.EQ.'NB_SS_ACTI') THEN
         IF(ZK24(IAREFE-1+3)(1:3).EQ.'OUI') THEN
           CALL DISMMO(CODMES,QUESTI,MO,REPI,REPK,IERD)
         ELSE
            REPI= 0
         END IF
      ELSE
         REPK = QUESTI
         CALL U2MESK(CODMES,'UTILITAI_49',1,REPK)
         IERD=1
         GO TO 9999
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
