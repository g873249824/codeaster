      SUBROUTINE DISMFF(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE GENIAUT S.GENIAUT

C     --     DISMOI(FOND_FISS)
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,NOMOBZ,REPKZ
      CHARACTER*32 REPK
      CHARACTER*8 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOB  : NOM D'UN OBJET DE TYPE SD_FOND_FISS
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

C
      CALL JEMARQ()
      NOMOB=NOMOBZ
      REPK=' '

      IF (QUESTI.EQ.'SYME') THEN

        CALL JEVEUO(NOMOB//'.INFO','L',JINFO)
        REPK = ZK8(JINFO-1+1)

      ELSE IF (QUESTI.EQ.'CONFIG_INIT') THEN

        CALL JEVEUO(NOMOB//'.INFO','L',JINFO)
        REPK = ZK8(JINFO-1+2)

      ELSE

        IERD=1

      END IF
C
      REPKZ = REPK
      CALL JEDEMA()
      END
