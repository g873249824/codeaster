      SUBROUTINE DISMQU(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 17/06/2003   AUTEUR VABHHTS J.PELLET 
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
C     --     DISMOI(DEGRE ELEMENTS 3D)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*32  REPK
      CHARACTER*19  NOMOB
      CHARACTER*(*) REPKZ, NOMOBZ
C ----------------------------------------------------------------------
C    IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*16 NOMTE
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
      CHARACTER*16 ZK16,PHENOM
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 KBID
      CHARACTER*1 K1BID
C---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK  = REPKZ
         REPI=0
         NBOUI=0
         NBNON=0
         CALL JEEXIN(NOMOB//'.LIEL',IRET)
         IERD=1
         IF (IRET.GT.0) THEN
           CALL JELIRA(NOMOB//'.LIEL','NUTIOC',NBGR,K1BID)
           DO 1, IGR=1,NBGR
             CALL JEVEUO(JEXNUM(NOMOB//'.LIEL',IGR),'L',IAGREL)
             CALL JELIRA(JEXNUM(NOMOB//'.LIEL',IGR),'LONMAX',N1,K1BID)
             ITE=ZI(IAGREL-1+N1)
             CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOMTE)
             IF(NOMTE.EQ.'MECA_HEXA20' .OR.NOMTE.EQ.'MECA_HEXA27' .OR.
     &          NOMTE.EQ.'MECA_PENTA15'.OR.NOMTE.EQ.'MECA_TETRA10'.OR.
     &          NOMTE.EQ.'MECA_PYRAM13'.OR.NOMTE.EQ.'MECA_HEXS20') THEN
                REPK = 'OUI'
                NBOUI=NBOUI+1
             ELSE IF(NOMTE.EQ.'MECA_HEXA8' .OR.
     &          NOMTE.EQ.'MECA_PENTA6'.OR.NOMTE.EQ.'MECA_TETRA4'.OR.
     &          NOMTE.EQ.'MECA_PYRAM5') THEN
                REPK = 'NON'
                NBNON=NBNON+1
             END IF
             IERD=0
 1         CONTINUE
         END IF
      IF(NBOUI.NE.0.AND.NBNON.NE.0) REPK='MEL'
C
 9999 CONTINUE
      REPKZ  = REPK
      CALL JEDEMA()
      END
