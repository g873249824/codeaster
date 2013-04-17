      SUBROUTINE NMETCC(SDIETO,COMPOR,SDDYNA,SDPOST,RESOCO,
     &                  NBCHAM,ZIOCH )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/04/2013   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      NBCHAM,ZIOCH
      CHARACTER*24 SDIETO,COMPOR
      CHARACTER*19 SDDYNA,SDPOST
      CHARACTER*24 RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (GESTION IN ET OUT)
C
C NOM DU CHAMP DANS OP0070
C
C ----------------------------------------------------------------------
C
C SI NOM = CHAP#TYPCHA# : CHAMP DANS VARIABLE CHAPEAU TYPCHA
C
C IN  MODELE : NOM DU MODELE
C IN  COMPOR : CARTE COMPORTEMENT
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  SDIETO : SD GESTION IN ET OUT
C
C
C
C
      CHARACTER*24 IOLCHA
      INTEGER      JIOLCH
      CHARACTER*24 NOMCHA,NOMCHX
      CHARACTER*19 XINDCO,XCOHES,XSEUCO
      CHARACTER*24 NOCHCO
      INTEGER      JNOCHC
      CHARACTER*19 CNOINR
      CHARACTER*19 VECFLA,VECVIB,VECSTA
      CHARACTER*19 DEPABS,VITABS,ACCABS
      REAL*8       R8BID
      INTEGER      IBID
      INTEGER      ICHAM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOM DES CHAMPS NON-STANDARDS (PAS DANS UNE VARIABLE CHAPEAU)
C
      XINDCO = RESOCO(1:14)//'.XFIN'
      XCOHES = RESOCO(1:14)//'.XCOH'
      XSEUCO = RESOCO(1:14)//'.XFSE'
      CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_FLAM',
     &            IBID             ,R8BID ,VECFLA)
      CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_STAB',
     &            IBID             ,R8BID ,VECSTA)
      CALL NMLESD('POST_TRAITEMENT',SDPOST,'SOLU_MODE_VIBR',
     &            IBID             ,R8BID ,VECVIB)
      CALL NDYNKK(SDDYNA,'DEPABS',DEPABS)
      CALL NDYNKK(SDDYNA,'VITABS',VITABS)
      CALL NDYNKK(SDDYNA,'ACCABS',ACCABS)
C
C --- ACCES SD CHAMPS
C
      IOLCHA = SDIETO(1:19)//'.LCHA'
      CALL JEVEUO(IOLCHA,'E',JIOLCH)
C
C --- NOM DU CHAMP DANS OP0070
C --- SI CHAP#NOMCHA# : CHAMP DANS VARIABLE CHAPEAU NOMCHA
C
      DO 40 ICHAM = 1,NBCHAM
        NOMCHA = ZK24(JIOLCH+ZIOCH*(ICHAM-1)+1-1)
        IF (NOMCHA.EQ.'DEPL') THEN
          NOMCHX = 'CHAP#VALINC#DEPMOI'
        ELSEIF (NOMCHA.EQ.'VITE') THEN
          NOMCHX = 'CHAP#VALINC#VITMOI'
        ELSEIF (NOMCHA.EQ.'ACCE') THEN
          NOMCHX = 'CHAP#VALINC#ACCMOI'
        ELSEIF (NOMCHA.EQ.'SIEF_ELGA') THEN
          NOMCHX = 'CHAP#VALINC#SIGMOI'
        ELSEIF (NOMCHA.EQ.'VARI_ELGA') THEN
          NOMCHX = 'CHAP#VALINC#VARMOI'
        ELSEIF (NOMCHA.EQ.'STRX_ELGA') THEN
          NOMCHX = 'CHAP#VALINC#STRMOI'
        ELSEIF (NOMCHA.EQ.'COMPORTEMENT') THEN
          NOMCHX = COMPOR
        ELSEIF (NOMCHA.EQ.'VALE_CONT') THEN
          NOCHCO = RESOCO(1:14)//'.NOCHCO'
          CALL JEVEUO(NOCHCO,'L',JNOCHC)
          CNOINR = ZK24(JNOCHC+2-1)(1:19)
          NOMCHX = CNOINR
        ELSEIF (NOMCHA.EQ.'INDC_ELEM') THEN
          NOMCHX = XINDCO
        ELSEIF (NOMCHA.EQ.'SECO_ELEM') THEN
          NOMCHX = XSEUCO
        ELSEIF (NOMCHA.EQ.'COHE_ELEM') THEN
          NOMCHX = XCOHES
        ELSEIF (NOMCHA.EQ.'MODE_FLAMB') THEN
          NOMCHX = VECFLA
        ELSEIF (NOMCHA.EQ.'MODE_STAB') THEN
          NOMCHX = VECSTA
        ELSEIF (NOMCHA.EQ.'DEPL_VIBR') THEN
          NOMCHX = VECVIB
        ELSEIF (NOMCHA.EQ.'DEPL_ABSOLU') THEN
          NOMCHX = DEPABS
        ELSEIF (NOMCHA.EQ.'VITE_ABSOLU') THEN
          NOMCHX = VITABS
        ELSEIF (NOMCHA.EQ.'ACCE_ABSOLU') THEN
          NOMCHX = ACCABS
        ELSEIF (NOMCHA.EQ.'FORC_NODA') THEN
          NOMCHX = 'CHAP#VEASSE#CNFINT'
        ELSEIF (NOMCHA.EQ.'FORC_AMOR') THEN
          NOMCHX = 'CHAP#VALINC#FAMMOI'
        ELSEIF (NOMCHA.EQ.'FORC_LIAI') THEN
          NOMCHX = 'CHAP#VALINC#FLIMOI'
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        ZK24(JIOLCH+ZIOCH*(ICHAM-1)+6-1) = NOMCHX
   40 CONTINUE
C
      CALL JEDEMA()
      END
