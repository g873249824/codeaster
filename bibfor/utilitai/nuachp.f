      SUBROUTINE NUACHP ( NUAGE, LNO, CHPT )
      IMPLICIT NONE
      CHARACTER*(*)       NUAGE, LNO, CHPT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     PASSAGE D'UNE SD NUAGE A UNE SD CHAM_GD
C
C IN  NUAGE  : NOM DE LA SD NUAGE ALLOUEE
C IN  LNO    : LISTE DES NOEUDS A PRENDRE EN COMPTE
C VAR CHPT   : NOM DE LA SD CHAM_GD (CHPT A ETE CREE)
C     ------------------------------------------------------------------
      INTEGER       IBID, IE
      CHARACTER*4   TYPE
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CALL DISMOI('F','TYPE_CHAMP',CHPT,'CHAMP',IBID,TYPE,IE)
C
      IF ( TYPE .EQ. 'NOEU' ) THEN
         CALL NUACNO ( NUAGE, LNO, CHPT )
      ELSE
         CALL U2MESS('F','CALCULEL_17')
      ENDIF
C
      END
