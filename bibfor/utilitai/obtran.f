      SUBROUTINE OBTRAN(NOMST1,NOMPA1,NOMST2,NOMPA2)
C
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'

      CHARACTER*24  NOMST1,NOMST2
      CHARACTER*(*) NOMPA1,NOMPA2
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (GESTION STRUCT)
C
C TRANSFERT D'UN PARAMETRE D'UN STRUCT A L'AUTRE
C
C ----------------------------------------------------------------------
C
C
C IN  NOMST1 : NOM DU STRUCT 1
C IN  NOMPA1 : NOM DU PARAMETRE DANS LE STRUCT 1
C IN  NOMST2 : NOM DU STRUCT 2
C IN  NOMPA2 : NOM DU PARAMETRE DANS LE STRUCT 2
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 VALK,VALO
      LOGICAL      VALB
      INTEGER      VALI
      REAL*8       VALR
      CHARACTER*1  TYPPA1,TYPPA2
      INTEGER      INDICE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      INDICE = 0
      TYPPA1 = ' '
      TYPPA2 = ' '
C
C --- REPERAGE PARAMETRE DANS LA SD IN
C
      CALL OBPARA(NOMST1,NOMPA1,INDICE,TYPPA1)
C
C --- LECTURE VALEUR DANS LA SD IN
C
      IF (TYPPA1.EQ.'B') THEN
        CALL OBGETB(NOMST1,NOMPA1,VALB)
      ELSEIF (TYPPA1.EQ.'I') THEN
        CALL OBGETI(NOMST1,NOMPA1,VALI)
      ELSEIF (TYPPA1.EQ.'R') THEN
        CALL OBGETR(NOMST1,NOMPA1,VALR)
      ELSEIF (TYPPA1.EQ.'K') THEN
        CALL OBGETK(NOMST1,NOMPA1,VALK)
      ELSEIF (TYPPA1.EQ.'O') THEN
        CALL OBGETO(NOMST1,NOMPA1,VALO)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- REPERAGE PARAMETRE DANS LA SD OUT
C
      CALL OBPARA(NOMST2,NOMPA2,INDICE,TYPPA2)
      IF (TYPPA1.NE.TYPPA2) THEN
        WRITE(6,*) 'TYPE DES PARAMETRES INCOMPATIBLES: ',TYPPA1,TYPPA2
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- ECRITURE VALEUR DANS LA SD OUT
C
      IF (TYPPA1.EQ.'B') THEN
        CALL OBSETB(NOMST2,NOMPA2,VALB)
      ELSEIF (TYPPA1.EQ.'I') THEN
        CALL OBSETI(NOMST2,NOMPA2,VALI)
      ELSEIF (TYPPA1.EQ.'R') THEN
        CALL OBSETR(NOMST2,NOMPA2,VALR)
      ELSEIF (TYPPA1.EQ.'K') THEN
        CALL OBSETK(NOMST2,NOMPA2,VALK)
      ELSEIF (TYPPA1.EQ.'O') THEN
        CALL OBSETO(NOMST2,NOMPA2,VALO)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
