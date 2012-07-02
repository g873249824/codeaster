      SUBROUTINE TRAN78(NOMRES,TYPRES,NOMIN)
      IMPLICIT NONE
      CHARACTER*8   NOMRES, NOMIN
      CHARACTER*16  TYPRES

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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

C TOLE CRP_20
C IN  : NOMRES : NOM UTILISATEUR POUR LA COMMANDE REST_COND_TRAN
C IN  : NOMIN  : NOM UTILISATEUR DU CONCEPT TRAN_GENE AMONT
C IN  : TYPRES : TYPE DE RESULTAT : 'DYNA_TRANS'

      CHARACTER*8   MACREL
      CHARACTER*19  TRANGE
      INTEGER      IARG

C-----------------------------------------------------------------------
      INTEGER NMC 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      TRANGE = NOMIN
      CALL GETVID(' ','MACR_ELEM_DYNA',1,IARG,1,MACREL,NMC)
C
      IF (NMC.NE.0) THEN
         CALL MACR78(NOMRES,TRANGE,TYPRES)
      ELSE
         CALL BAMO78(NOMRES,TRANGE,TYPRES)
      ENDIF
      CALL TITRE
C
      CALL JEDEMA()
      END
