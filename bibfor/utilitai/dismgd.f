      SUBROUTINE DISMGD(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 18/09/2007   AUTEUR DURAND C.DURAND 
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
C     --     DISMOI(GRANDEUR)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*24 QUESTL
      CHARACTER*32  REPK
      CHARACTER*8   NOMOB
      CHARACTER*(*) REPKZ, NOMOBZ
C ----------------------------------------------------------------------
C    IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UNE GRANDEUR
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
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
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 KBID
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK  = REPKZ
      QUESTL = QUESTI
C
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      IF (QUESTL(1:7).EQ.'NUM_GD ') THEN
         CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMOB),REPI)
         GO TO 9999
      END IF
C
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMOB),IBID)
      CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',IBID),'L',IADGD)
      ICODE=ZI(IADGD)
C
      IF (QUESTI(1:12).EQ.'TYPE_MATRICE') THEN
         IF (ICODE.LE.3) THEN
           REPK=' '
         ELSE IF (ICODE.EQ.4) THEN
           REPK='SYMETRI'
         ELSE IF (ICODE.EQ.5) THEN
           REPK='NON_SYM'
         END IF
C
      ELSE IF (QUESTI(1:9).EQ.'NUM_GD_SI') THEN
         IF (ICODE.EQ.1) THEN
            CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMOB),REPI)
         ELSE IF (ICODE.EQ.3) THEN
            REPI=ZI(IADGD-1+4)
         ELSE IF (ICODE.EQ.4) THEN
            REPI=ZI(IADGD-1+4)
         ELSE IF (ICODE.EQ.5) THEN
            IGDLI=ZI(IADGD-1+4)
            IGDCO=ZI(IADGD-1+5)
            IF (IGDLI.NE.IGDCO) THEN
              CALL U2MESS(CODMES,'UTILITAI_57')
              IERD=1
              GO TO 9999
            ELSE
              REPI=IGDLI
            END IF
         ELSE
            CALL ASSERT(.FALSE.)
         END IF
C
      ELSE IF (QUESTI(1:9).EQ.'NOM_GD_SI') THEN
         IF (ICODE.EQ.5) THEN
            IGDLI=ZI(IADGD-1+4)
            IGDCO=ZI(IADGD-1+5)
            IF (IGDLI.NE.IGDCO) THEN
              CALL U2MESS(CODMES,'UTILITAI_59')
             IERD=1
             GO TO 9999
            ELSE
              NUMGD=IGDLI
              CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',NUMGD),REPK)
            END IF
         ELSEIF (ICODE.LE.2) THEN
            REPK=NOMOB
         ELSE
            NUMGD=ZI(IADGD-1+4)
            CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',NUMGD),REPK)
         END IF
C
      ELSE IF (QUESTI.EQ.'NB_EC') THEN
         IF (ICODE.GE.3) THEN
           CALL U2MESS(CODMES,'UTILITAI_60')
           IERD=1
           GO TO 9999
         END IF
         REPI= ZI(IADGD-1+3)
C
      ELSE IF    ((QUESTI.EQ.'NB_CMP_MAX')
     &        .OR.(QUESTI.EQ.'NU_CMP_LAGR')) THEN
         IF (ICODE.GE.3) THEN
           CALL U2MESS(CODMES,'UTILITAI_60')
           IERD=1
           GO TO 9999
         END IF
         CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOMOB),'LONMAX',NMAX,KBID)
         IF (QUESTI.EQ.'NB_CMP_MAX') THEN
           REPI=NMAX
         ELSE IF (QUESTI.EQ.'NU_CMP_LAGR') THEN
           CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOMOB),'L',IANCMP)
           REPI=INDIK8(ZK8(IANCMP),'LAGR',1,NMAX)
         ELSE
           CALL ASSERT(.FALSE.)
         END IF
C
      ELSE IF (QUESTI.EQ.'TYPE_SCA') THEN
         CALL JEVEUO('&CATA.GD.TYPEGD','L',IATYPE)
         CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMOB),NUMGD)
         REPK= ZK8(IATYPE-1+NUMGD)
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
