      SUBROUTINE RSEXPA(RESU,ICODE,NOMPAR,IRET)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER                 ICODE,       IRET
      CHARACTER*(*)     RESU,      NOMPAR
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE VABHHTS J.PELLET
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
C      VERIFICATION DE L'EXISTANCE D'UN NOM DE PARAMETRE OU DE
C      VARIABLE D'ACCES DANS UN RESULTAT COMPOSE
C ----------------------------------------------------------------------
C IN  : RESU  : NOM DE LA SD_RESULTAT
C IN  : NOMPAR : NOM SYMBOLIQUE DU PARAMETRE OU VARIABLE D'ACCES DONT
C                ON DESIRE VERIFIER L'EXISTANCE
C IN  : ICODE  : CODE = 0 : VARIABLE D'ACCES
C                     = 1 : PARAMETRE
C                     = 2 : VARIABLE D'ACCES OU PARAMETRE
C OUT : IRET   : = 0  LE NOM SYMBOLIQUE N'EXISTE PAS
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
      INTEGER      NBAC,NBPA,LPOUT
C
      CALL JEMARQ()
      IRET=0
C
      CALL RSNOPA(RESU,ICODE,'&&RSEXPA.NOM_PAR',NBAC,NBPA)
      CALL JEEXIN('&&RSEXPA.NOM_PAR',IRE1)
      IF (IRE1.GT.0) CALL JEVEUO('&&RSEXPA.NOM_PAR','E',LPOUT)
      IF((NBAC+NBPA).NE.0) THEN
         DO 10 IPA=1,NBAC+NBPA
           IF(NOMPAR.EQ.ZK16(LPOUT-1+IPA)) THEN
             IRET=100
           ENDIF
 10      CONTINUE
      ENDIF
C
      CALL JEDETR('&&RSEXPA.NOM_PAR')
C
      CALL JEDEMA()
      END
