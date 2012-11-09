      SUBROUTINE MELIMA(CHIN,MA,ICODE,IENT,LIMA,NB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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

      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C     RETOURNE LE NOMBRE DE MAILLE D'1 GROUPE AFFECTE D'1 CARTE
C            AINSI QUE L'ADRESSE DU DEDEBUT DE LA LISTE DANS ZI.
C ----------------------------------------------------------------------
C
C
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*8 MA
      CHARACTER*19 CHIN
      INTEGER ICODE,IENT,LIMA,NB
C ----------------------------------------------------------------------
C     ENTREES:
C     CHIN : NOM D'1 CARTE
C     MA   : NOM DU MAILLAGE SUPPORT DE LA CARTE.
C     IENT : NUMERO DE L'ENTITE AFFECTE PAR LA GRANDEUR
C             IENT = NUMERO DU GROUPE_MA SI CODE=2
C             IENT = NUMERO DE LA GRANDEUR EDITEE SI CODE = 3 OU -3
C     ICODE :  2  OU -3 OU 3
C
C     SORTIES:
C     NB   : NOMBRE DE MAILLES DANS LA LISTE.
C     LIMA : ADRESSE DANS ZI DE LA LISTE DES NUMEROS DE MAILLES.
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
C
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*1 K1BID
C
C
C     TRAITE LES 2 CAS :  - GROUPE NOMME DU MAILLAGE MA
C                         - GROUPE TARDIF DE LA CARTE CHIN
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      IF (ICODE.EQ.2) THEN
C
C        GROUPE DE MAILLES DU MAILLAGE:
         CALL JELIRA(JEXNUM(MA//'.GROUPEMA',IENT),'LONUTI',NB,K1BID)
         CALL JEVEUO(JEXNUM(MA//'.GROUPEMA',IENT),'L',LIMA)
      ELSE IF (ABS(ICODE).EQ.3) THEN
C
C        GROUPE TARDIF :
         CALL JELIRA(JEXNUM(CHIN(1:19)//'.LIMA',IENT),'LONMAX',NB,
     &               K1BID)
         CALL JEVEUO(JEXNUM(CHIN(1:19)//'.LIMA',IENT),'L',LIMA)
      ELSE
         CALL ASSERT(.FALSE.)
      END IF
      END
