      SUBROUTINE DISMCA(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     --     DISMOI(CARTE)
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER REPI,IERD
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*(*) QUESTI
      CHARACTER*24 QUESTL
      CHARACTER*32 REPK
      CHARACTER*19 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE CARTE
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*19 NOMFON, NOMCAR
      CHARACTER*8  K8B,TYPFON,NOMPF(10),TYPE,NOGD

C-----------------------------------------------------------------------
      INTEGER IADESC ,IBID ,IEXI ,IRET ,JDESC ,JNOMA ,JPROL
      INTEGER JVALE ,K ,L ,LONG ,LTYP ,NBPF
C-----------------------------------------------------------------------
      CALL JEMARQ()
      REPK  = ' '
      REPI  = 0
      IERD = 0

      NOMOB = NOMOBZ
      QUESTL = QUESTI

      CALL JEEXIN(NOMOB//'.NOMA',IEXI)
      IF (IEXI.EQ.0) THEN
        IERD=1
        GOTO 9999
      ENDIF


      IF (QUESTI.EQ.'NOM_MAILLA') THEN
         CALL JEVEUO(NOMOB//'.NOMA','L',JNOMA)
         REPK = ZK8(JNOMA-1+1)

      ELSE IF (QUESTI.EQ.'TYPE_CHAMP') THEN
         REPK = 'CART'

      ELSE IF (QUESTI.EQ.'TYPE_SUPERVIS') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',IADESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(IADESC)),NOGD)
         REPK='CART_'//NOGD

      ELSE IF (QUESTL(1:7).EQ.'NOM_GD ') THEN
         CALL JEVEUO(NOMOB//'.DESC','L',JDESC)
         CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(JDESC)),REPK)
C
      ELSE IF (QUESTI.EQ.'PARA_INST') THEN
         REPK = ' '
         NOMCAR = NOMOB
         CALL JEVEUO(NOMCAR//'.VALE','L',JVALE)
         CALL JELIRA(NOMCAR//'.VALE','TYPE',IBID,TYPE)
         IF (TYPE(1:1).EQ.'K') THEN
           CALL JELIRA(NOMCAR//'.VALE','LONMAX',LONG,K8B)
           CALL JELIRA(NOMCAR//'.VALE','LTYP',LTYP,K8B)
           DO 10 K=1,LONG
             IF (LTYP.EQ.8) THEN
               NOMFON = ZK8(JVALE+K-1)
             ELSE IF (LTYP.EQ.24) THEN
               NOMFON = ZK24(JVALE+K-1)
             ELSE
               CALL ASSERT(.FALSE.)
             END IF


             IF ( NOMFON(1:8) .NE. '        ' ) THEN
               CALL JEEXIN(NOMFON//'.PROL',IRET)
               IF ( IRET .GT. 0 ) THEN
                 CALL JEVEUO(NOMFON//'.PROL','L',JPROL)
                 CALL FONBPA(NOMFON,ZK24(JPROL),TYPFON,10,NBPF,NOMPF)
                 DO 101 L=1,NBPF
                   IF ( NOMPF(L)(1:4) .EQ. 'INST' ) THEN
                     REPK = 'OUI'
                     GOTO 11
                   ENDIF
 101             CONTINUE
               ENDIF
             ENDIF
 10        CONTINUE
 11        CONTINUE
        ENDIF


      ELSE
         IERD=1
      END IF


9999  CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
