      SUBROUTINE DISMPM(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C     --     DISMOI(PHEN_MODE)
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI
      CHARACTER*24 REPK
      CHARACTER*32 NOMOB
      CHARACTER*(*) NOMOBZ,REPKZ
C ----------------------------------------------------------------------
C    IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN PHENMODE : (1:16)  : PHENOMENE
C                                    (17:32) : MODELISATION
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)

C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      INTEGER NBTM,JPHEN,IMODE
      CHARACTER*8 KBID
      CHARACTER*16 PHEN,MODE
C DEB-------------------------------------------------------------------
      REPK  = ' '
      REPI  = 0
      IERD = 0

      NOMOB = NOMOBZ
      PHEN=NOMOB(1:16)
      MODE=NOMOB(17:32)

      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTM,KBID)
      CALL JENONU(JEXNOM('&CATA.'//PHEN(1:13)//'.MODL',MODE),IMODE)
      CALL ASSERT(IMODE.GT.0)
      CALL JEVEUO(JEXNUM('&CATA.'//PHEN,IMODE),'L',JPHEN)

      IF (QUESTI.EQ.'DIM_GEOM') THEN
          REPI=ZI(JPHEN-1+NBTM+2)
      ELSE IF (QUESTI.EQ.'DIM_TOPO') THEN
          REPI=ZI(JPHEN-1+NBTM+1)
      ELSE
        IERD = 1
      END IF

      REPKZ = REPK
      END
