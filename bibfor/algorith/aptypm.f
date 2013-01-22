      SUBROUTINE APTYPM(SDAPPA,NOMA  ,NUMMA ,NDIM  ,NNOSD ,
     &                  ALIAS ,NOMMA )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/01/2013   AUTEUR DESOZA T.DESOZA 
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

      CHARACTER*19 SDAPPA
      CHARACTER*8  NOMA
      CHARACTER*8  ALIAS
      CHARACTER*8  NOMMA
      INTEGER      NUMMA
      INTEGER      NNOSD,NDIM
C
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C CARACTERISTIQUES DE LA MAILLE
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  NOMA   : SD MAILLAGE
C IN  NUMMA  : NUMERO DE LA MAILLE
C IN  NNOSD  : NOMBRE DE NOEUDS DE LA MAILLE SUIVANT LA SD
C OUT NOMMA  : NOM DE LA MAILLE
C OUT ALIAS  : TYPE GEOMETRIQUE DE LA MAILLE
C OUT NDIM   : DIMENSION DE LA MAILLE
C
C
      CHARACTER*32 JEXNUM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- TYPE GEOMETRIQUE DE LA MAILLE
C
      CALL MMTYPM(NOMA  ,NUMMA ,NNOSD ,ALIAS ,NDIM )
C
C --- NOM DE LA MAILLE
C
      CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMA ),NOMMA )
C
      CALL JEDEMA()
C
      END
