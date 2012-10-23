      SUBROUTINE NMERIM(SDERRO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/10/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  SDERRO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD ERREUR)
C
C EMISSION MESSAGE ERRREUR
C
C ----------------------------------------------------------------------
C
C
C IN  SDERRO : SD ERREUR
C
C ----------------------------------------------------------------------
C
      INTEGER      IEVEN,ZEVEN
      CHARACTER*24 ERRINF
      INTEGER      JEINFO
      CHARACTER*24 ERRAAC,ERRENI,ERRMSG
      INTEGER      JEEACT,JEENIV,JEEMSG
      INTEGER      ICODE
      CHARACTER*9  TEVEN
      CHARACTER*24 MEVEN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD
C
      ERRINF = SDERRO(1:19)//'.INFO'
      CALL JEVEUO(ERRINF,'L',JEINFO)
      ZEVEN  = ZI(JEINFO-1+1)
C
      ERRAAC = SDERRO(1:19)//'.EACT'
      ERRENI = SDERRO(1:19)//'.ENIV'
      ERRMSG = SDERRO(1:19)//'.EMSG'
      CALL JEVEUO(ERRAAC,'L',JEEACT)
      CALL JEVEUO(ERRENI,'L',JEENIV)
      CALL JEVEUO(ERRMSG,'L',JEEMSG)
C
C --- EMISSION DES MESSAGES D'ERREUR
C
      DO 10 IEVEN = 1,ZEVEN
        ICODE  = ZI(JEEACT-1+IEVEN)
        TEVEN  = ZK16(JEENIV-1+IEVEN)(1:9)
        MEVEN  = ZK24(JEEMSG-1+IEVEN)
        IF ((TEVEN(1:3).EQ.'ERR').AND.
     &      (ICODE.EQ.1))THEN
          IF (MEVEN.EQ.' ') CALL ASSERT(.FALSE.)
            IF (MEVEN.EQ.'MECANONLINE10_1') THEN
              CALL U2MESS('I','MECANONLINE10_1')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_2') THEN
              CALL U2MESS('I','MECANONLINE10_2')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_3') THEN
              CALL U2MESS('I','MECANONLINE10_3')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_4') THEN
              CALL U2MESS('I','MECANONLINE10_4')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_5') THEN
              CALL U2MESS('I','MECANONLINE10_5')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_6') THEN
              CALL U2MESS('I','MECANONLINE10_6')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_7') THEN
              CALL U2MESS('I','MECANONLINE10_7')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_8') THEN
              CALL U2MESS('I','MECANONLINE10_8')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_9') THEN
              CALL U2MESS('I','MECANONLINE10_9')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_10') THEN
              CALL U2MESS('I','MECANONLINE10_10')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_11') THEN
              CALL U2MESS('I','MECANONLINE10_11')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_12') THEN
              CALL U2MESS('I','MECANONLINE10_12')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_20') THEN
              CALL U2MESS('I','MECANONLINE10_20')
            ELSEIF (MEVEN.EQ.'MECANONLINE10_24') THEN
              CALL U2MESS('I','MECANONLINE10_24')
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF        
        ENDIF
  10  CONTINUE
C
      CALL JEDEMA()
      END
