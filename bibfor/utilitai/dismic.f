      SUBROUTINE DISMIC(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C     --     DISMOI(INCONNU)
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER REPI,IERD
      CHARACTER*19 NOMOB
      CHARACTER*(*) QUESTI
      CHARACTER*32  REPK
      CHARACTER*(*) NOMOBZ,REPKZ
C ----------------------------------------------------------------------
C    IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE "INCONNU"(K19)
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*4 DOCU
C
C
C-----------------------------------------------------------------------
      INTEGER IBID ,IRE1 ,IRE2 ,IRE3 ,IRE4 ,IRE5 ,IRE6
      INTEGER IRE7 ,IRET ,JPRO
C-----------------------------------------------------------------------
      CALL JEMARQ()
      REPK  = ' '
      REPI  = 0
      IERD = 0

      NOMOB = NOMOBZ
C
      IF ( QUESTI(1:8) .EQ. 'RESULTAT' ) THEN
         CALL JEEXIN(NOMOB//'.NOVA',IRE3)
         CALL JEEXIN(NOMOB//'.DESC',IRE4)
         CALL JEEXIN(NOMOB//'.ORDR',IRE5)
         CALL JEEXIN(NOMOB//'.TAVA',IRE6)
         CALL JEEXIN(NOMOB//'.TACH',IRE7)
         IF (IRE3.GT.0 .AND. IRE4.GT.0 .AND. IRE5.GT.0 .AND.
     &                       IRE6.GT.0 .AND. IRE7.GT.0 ) THEN
           REPK = 'OUI'
           GO TO 9999
         ENDIF
C
      ELSEIF ( QUESTI(1:5) .EQ. 'TABLE' ) THEN
         CALL JEEXIN(NOMOB//'.TBBA',IRE3)
         CALL JEEXIN(NOMOB//'.TBNP',IRE4)
         CALL JEEXIN(NOMOB//'.TBLP',IRE5)
         IF (IRE3.GT.0 .AND. IRE4.GT.0 .AND. IRE5.GT.0 ) THEN
           REPK = 'OUI'
           GO TO 9999
         ENDIF
C
      ELSEIF ( QUESTI(1:7) .EQ. 'CHAM_NO' ) THEN
         CALL JEEXIN ( NOMOB//'.DESC', IRET )
         IF ( IRET .GT.0 ) THEN
            CALL JELIRA(NOMOB//'.DESC','DOCU',IBID,DOCU)
            IF ( DOCU .EQ. 'CHNO' ) THEN
               REPK = 'OUI'
               GO TO 9999
            ENDIF
         ENDIF
C
      ELSEIF ( QUESTI(1:9) .EQ. 'CHAM_ELEM' ) THEN
         CALL JEEXIN ( NOMOB//'.CELD', IRET )
         IF ( IRET .GT.0 ) THEN
            REPK = 'OUI'
            GO TO 9999
         ENDIF
C
      ELSEIF  (QUESTI(1:4).EQ.'TYPE') THEN
         CALL JEEXIN(NOMOB//'.TYPE',IRE1)
         CALL JEEXIN(NOMOB//'.NOPA',IRE2)
         CALL JEEXIN(NOMOB//'.NOVA',IRE3)
         IF (IRE1.GT.0 .AND. IRE2.GT.0 .AND. IRE3.GT.0) THEN
            REPK = 'TABLE'
            GO TO 9999
         END IF

         CALL JEEXIN(NOMOB//'.DESC',IRE1)
         IF ( IRE1 .GT. 0 ) THEN
             CALL JELIRA(NOMOB//'.DESC','DOCU',IBID,DOCU)
             IF (DOCU.EQ.'CHNO') THEN
               REPK = 'CHAM_NO'
               GO TO 9999
             ELSE
               CALL RSDOCU ( DOCU, REPK, IRET )
               IF ( IRET .NE. 0 ) IERD=1
               GO TO 9999
             ENDIF
         ENDIF

         CALL JEEXIN(NOMOB//'.CELD',IRE1)
         IF (IRE1.GT.0) THEN
            REPK='CHAM_ELEM'
            GO TO 9999
         ENDIF

         CALL JEEXIN(NOMOB//'.PROL',IRE1)
         IF (IRE1.GT.0) THEN
           CALL JEVEUO(NOMOB//'.PROL','L',JPRO)
           IF ( ZK24(JPRO).EQ.'CONSTANTE' .OR. ZK24(JPRO).EQ.'FONCTION'
     &     .OR. ZK24(JPRO).EQ.'NAPPE'.OR. ZK24(JPRO).EQ.'FONCT_C' ) THEN
              REPK='FONCTION'
              GO TO 9999
           ENDIF
         ENDIF

      ELSE
         IERD=1
      END IF
C
 9999 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
