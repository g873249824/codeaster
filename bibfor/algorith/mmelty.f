      SUBROUTINE MMELTY(NOMA  ,NUMA  ,ALIAS ,NNO   ,NDIM  )
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8 NOMA
      INTEGER     NUMA
      CHARACTER*8 ALIAS
      INTEGER     NNO
      INTEGER     NDIM
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C RETOURNE UN ALIAS POUR UN TYPE D'ELEMENT, LE NOMBRE DE NOEUDS
C DE CET ELEMENT ET SA DIMENSION
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMA   : NUMERO ABSOLU DE LA MAILLE
C OUT ALIAS  : TYPE DE L'ELEMENT
C               'PO1'
C               'SE2'
C               'SE3'
C               'TR3'
C               'TR6'
C               'TR7'
C               'QU4'
C               'QU8'
C               'QU9'
C OUT NNO    : NOMBRE DE NOEUDS DE CET ELEMENT
C OUT NDIM   : DIMENSION DE LA MAILLE
C
C
C
C
      INTEGER      IATYMA,ITYP,NUTYP
      CHARACTER*8  NOMTM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NOMTM = ' '
C
C --- CODE TYPE DE LA MAILLE
C
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      ITYP  = IATYMA - 1 + NUMA
      NUTYP = ZI(ITYP)
C
C --- NOM CATALOGUE
C
      CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYP),NOMTM)
C
      IF (NOMTM .EQ. 'POI1') THEN
        ALIAS  = 'PO1'
        NNO    = 1
        NDIM   = 1
      ELSEIF (NOMTM .EQ. 'SEG2') THEN
        ALIAS  = 'SE2'
        NNO    = 2
        NDIM   = 2
      ELSEIF (NOMTM .EQ. 'SEG3') THEN
        ALIAS  = 'SE3'
        NNO    = 3
        NDIM   = 2
      ELSEIF (NOMTM .EQ. 'TRIA3') THEN
        ALIAS  = 'TR3'
        NNO    = 3
        NDIM   = 3
      ELSEIF (NOMTM .EQ. 'TRIA6') THEN
        ALIAS  = 'TR6'
        NNO    = 6
        NDIM   = 3
      ELSEIF (NOMTM .EQ. 'TRIA7') THEN
        ALIAS  = 'TR7'
        NNO    = 7
        NDIM   = 3
      ELSEIF (NOMTM .EQ. 'QUAD4') THEN
        ALIAS  = 'QU4'
        NNO    = 4
        NDIM   = 3
      ELSEIF (NOMTM .EQ. 'QUAD8') THEN
        ALIAS  = 'QU8'
        NNO    = 8
        NDIM   = 3
      ELSEIF (NOMTM .EQ. 'QUAD9') THEN
        ALIAS  = 'QU9'
        NNO    = 9
        NDIM   = 3
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      CALL JEDEMA()
      END
