      SUBROUTINE PJTYMA(NDIM, NOMTY,ITYEL2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      INTEGER           ITYEL2
      CHARACTER*16      NOMTY

C ----------------------------------------------------------------------
C
C COMMANDE PROJ_CHAMP
C
C ----------------------------------------------------------------------
C
C IN  NDIM  : DIMENSION TOPO
C IN  NOMTY  : NOM TYPE MAILLE
C OUT ITYEL2 : NUMERO DU TE DANS '&CATA.TE.NOMTE'
C
C ----------------------------------------------------------------------
C
C
C RETOURNE LE BON TYPE D'ELEMENT POUR LE PSEUDO MODELE A PARTIR
C DU MAILLAGE INITIAL (TYPMAIL)
C
C ATTENTION : CAS SOUS-MAILS - 2D :
C    LE DECOUPAGE EN TRIA6 NE MARCHE PAS POUR L'INSTANT
C    CAR ON NE CREE QUE LES TRIA3 LORS DE LA FABRICATION
C    DES SOUS-MAILLES
C    IL FAUT REVOIR D'AUTRES FICHIERS
C
C
C ----------------------------------------------------------------------
      INTEGER      NDIM
      CHARACTER*16 NOMTE,NOMTE2
      CHARACTER*32 JEXNOM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C


      NOMTE=NOMTY


      IF (NDIM.EQ.2) THEN

        IF (NOMTE.EQ.'TRIA3') THEN
          NOMTE2='MECPTR3'
        ELSEIF (NOMTE.EQ.'TRIA6') THEN
          NOMTE2='MECPTR6'
        ELSEIF (NOMTE.EQ.'QUAD4') THEN
          NOMTE2='MECPQU4'
        ELSEIF (NOMTE.EQ.'QUAD8') THEN
          NOMTE2='MECPQU8'
        ELSEIF (NOMTE.EQ.'QUAD9') THEN
          NOMTE2='MECPQU9'
        ENDIF

      ELSEIF (NDIM.EQ.3) THEN

        IF (NOMTE.EQ.'TETRA4') THEN
          NOMTE2='MECA_TETRA4'
        ELSEIF (NOMTE.EQ.'TETRA10') THEN
          NOMTE2='MECA_TETRA10'
        ELSEIF (NOMTE.EQ.'PENTA6') THEN
          NOMTE2='MECA_PENTA6'
        ELSEIF (NOMTE.EQ.'PENTA15') THEN
          NOMTE2='MECA_PENTA15'
        ELSEIF (NOMTE.EQ.'PENTA18') THEN
          NOMTE2='MECA_PENTA18'
        ELSEIF (NOMTE.EQ.'PYRAM5') THEN
          NOMTE2='MECA_PYRAM5'
        ELSEIF (NOMTE.EQ.'HEXA8') THEN
          NOMTE2='MECA_HEXA8'
        ELSEIF (NOMTE.EQ.'HEXA20') THEN
          NOMTE2='MECA_HEXA20'
        ELSEIF (NOMTE.EQ.'HEXA27') THEN
          NOMTE2='MECA_HEXA27'
        ENDIF

      ENDIF

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE',NOMTE2),ITYEL2)


      CALL JEDEMA()



      END
