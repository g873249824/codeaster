      SUBROUTINE DISMCN(CODMES,QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 02/10/96   AUTEUR CIBHHLV L.VIVAN 
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
C     --     DISMOI(CHAM_NO)
C     ARGUMENTS:
C     ----------
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,CODMES
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*24 REPK,QUESTL
      CHARACTER*19 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE NUM_DDL
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
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
      CHARACTER*8 ZK8,NOGD
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8 K8BID
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK = REPKZ
      QUESTL = QUESTI
      IF (QUESTI.EQ.'NB_EQUA') THEN
         CALL JELIRA(NOMOB//'.VALE','LONMAX',REPI,K8BID)
      ELSE IF (QUESTI.EQ.'NOM_MAILLA') THEN
         CALL JEVEUO(NOMOB//'.REFE','L',IAREFE)
         REPK = ZK24(IAREFE-1+1) (1:8)
      ELSE IF (QUESTI.EQ.'NB_DDLACT') THEN
         CALL JEVEUO(NOMOB//'.REFE','L',IAREFE)
         CALL DISMPN(CODMES,QUESTI,ZK24(IAREFE-1+2)(1:8)//'.NUME      '
     +               ,REPI,REPK,IERD)
      ELSE IF (QUESTI.EQ.'TYPE_CHAMP') THEN
         REPK = 'NOEU'
      ELSE IF (QUESTL(1:7).EQ.'NUM_GD ') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',IADESC)
         REPI = ZI(IADESC)
      ELSE IF (QUESTL(1:7).EQ.'NOM_GD ') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',IADESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(IADESC)),REPK)
      ELSE IF (QUESTI.EQ.'TYPE_SUPERVIS') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',IADESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(IADESC)),NOGD)
         REPK='CHAM_NO_'//NOGD
      ELSE IF (QUESTI.EQ.'PROF_CHNO' ) THEN
         CALL JEVEUO(NOMOB//'.REFE','L',IAREFE)
         REPK = ZK24(IAREFE+1)
      ELSE IF (QUESTI.EQ.'NOM_NUME_DDL' ) THEN
         CALL JEVEUO(NOMOB//'.REFE','L',IAREFE)
         REPK = ZK24(IAREFE+1)
         CALL JEEXIN(REPK(1:19)//'.NEQU',IRET)
         IF (IRET.EQ.0) THEN
           CALL UTMESS(CODMES,'DISMCN:',
     +               'IL N Y A PAS DE NUME_DDL POUR CE CHAM_NO')
           IERD=1
           GO TO 9999
         END IF
      ELSE
         REPK = QUESTI
         CALL UTMESS(CODMES,'DISMCN:',
     +               'LA QUESTION : "'//REPK//'" EST INCONNUE')
         IERD=1
         GO TO 9999
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
