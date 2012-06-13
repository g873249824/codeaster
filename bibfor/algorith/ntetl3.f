      SUBROUTINE NTETL3(RESULT,SDIETO,ICHAM ,TEMPCT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 SDIETO
      CHARACTER*8  RESULT
      INTEGER      ICHAM
      REAL*8       TEMPCT
C
C ----------------------------------------------------------------------
C
C ROUTINE GESTION IN ET OUT
C
C LECTURE D'UN CHAMP - VERIFICATIONS DIVERSES (THERMIQUE)
C
C ----------------------------------------------------------------------
C
C
C IN  RESULT : NOM SD EVOL_NOLI
C IN  SDIETO : SD GESTION IN ET OUT
C IN  ICHAM  : INDEX DU CHAMP DANS SDIETO
C IN  TEMPCT : VALEUR DE LA TEMPERATURE QUAND ELLE EST DONNEE
C
C
C
C
      CHARACTER*24 IOINFO,IOLCHA
      INTEGER      JIOINF,JIOLCH
      INTEGER      ZIOCH
      INTEGER      IRET
      CHARACTER*24 CHETIN,NOMCHS,LOCCHA,NOMGD,STATUT
      CHARACTER*24 VALK(2)
      CHARACTER*24 NOMCHA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES AUX SDS
C
      IOINFO = SDIETO(1:19)//'.INFO'
      IOLCHA = SDIETO(1:19)//'.LCHA'
      CALL JEVEUO(IOINFO,'L',JIOINF)
      CALL JEVEUO(IOLCHA,'E',JIOLCH)
      ZIOCH  = ZI(JIOINF+4-1)
C
C --- CHAMP A LIRE ?
C
      CHETIN = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+8-1)
      IF (CHETIN.EQ.'NON') GOTO 999
C
C --- NOM DU CHAMP DANS SD RESULTAT
C
      NOMCHS = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+1-1)
C
C --- NOM DU CHAMP DANS L'OPERATEUR
C
      CALL NMETNC(SDIETO,ICHAM ,NOMCHA)
C
C --- LOCALISATION DU CHAMP
C
      LOCCHA = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+5-1)
C
C --- NOM DE LA GRANDEUR
C
      NOMGD  = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+7-1)
C
C --- STATUT DU CHAMP
C
      STATUT = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+4-1)
C
C --- LE CHAMP N'A JAMAIS ETE LU
C
      IF (STATUT.EQ.' ') THEN
        CALL U2MESK('F','ETATINIT_30',1,NOMCHS)
      ELSE
        VALK(1) = NOMCHS
        VALK(2) = RESULT(1:8)
        IF (STATUT.EQ.'ZERO') THEN
          CALL U2MESK('I','ETATINIT_31',1,NOMCHS)
        ELSEIF (STATUT.EQ.'SDRESU') THEN
          CALL U2MESK('I','ETATINIT_32',2,VALK  )
        ELSEIF (STATUT.EQ.'CHAMP') THEN
          CALL U2MESK('I','ETATINIT_33',1,NOMCHS)
        ELSEIF (STATUT.EQ.'STATIONNAIRE') THEN
          CALL U2MESS('I','ETATINIT_34')
        ELSEIF (STATUT.EQ.'VALE') THEN
          CALL U2MESR('I','ETATINIT_35',1,TEMPCT)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- VERIFICATION DE LA GRANDEUR ET DE LA LOCALISATION
C
      IF (NOMGD.NE.' ') THEN
        CALL CHPVER('F',NOMCHA,LOCCHA,NOMGD ,IRET)
      ENDIF
C
 999  CONTINUE
C
      CALL JEDEMA()
      END
