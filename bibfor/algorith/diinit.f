      SUBROUTINE DIINIT(NOMA  ,NOMO  ,RESULT,MATE  ,CARELE,
     &                  FONACT,SDDYNA,PARCRI,INSTIN,SDIETO,
     &                  SDSENS,SOLVEU,SDDISC,SDOBSE,SDSUIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
C
      IMPLICIT      NONE
      REAL*8        INSTIN,PARCRI(*)
      CHARACTER*8   RESULT,NOMA,NOMO
      CHARACTER*19  SDDISC,SDDYNA,SDSUIV,SDOBSE,SOLVEU
      CHARACTER*24  CARELE,MATE
      CHARACTER*24  SDSENS,SDIETO
      INTEGER       FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
C ----------------------------------------------------------------------
C
C
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  CARELE : NOM DU CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C IN  SDDYNA : NOM DE LA SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C IN  PARCRI : PARAMETRES DES CRITERES DE CONVERGENCE (CF NMDOCN)
C IN  RESULT : NOM UTILISATEUR DU RESULTAT
C IN  SDIETO : SD GESTION IN ET OUT
C IN  SDSENS : SD SENSIBILITE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  INSTIN : INSTANT INITIAL QUAND ETAT_INIT
C IN  SOLVEU : SD SOLVEUR
C OUT SDDISC : SD DISCRETISATION
C OUT SDSUIV : NOM DE LA SD POUR SUIVI DDL
C OUT SDOBSE : NOM DE LA SD POUR OBSERVATION
C
C ----------------------------------------------------------------------
C
      INTEGER      N1,NM
      LOGICAL      NDYNLO,LEXPL,LPRMO
      CHARACTER*8  MECA
      CHARACTER*19 LISINS
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL GETVID('INCREMENT','LIST_INST',1,IARG,1,LISINS,N1)
      CALL ASSERT(N1.NE.0)
C
C --- FONCTIONNALITES ACTIVEES
C
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE' )
      LPRMO  = NDYNLO(SDDYNA,'PROJ_MODAL')
C
C --- CREATION SD DISCRETISATION
C
      CALL NMCRLI(INSTIN,LISINS,SDDISC)
C
C --- EVALUATION DE LA CONDITION DE COURANT EN EXPLICITE
C
      IF (LEXPL) THEN
        IF (LPRMO)THEN
          CALL GETVID('PROJ_MODAL','MODE_MECA',1,IARG,1,MECA,NM)
          CALL PASCOM(MECA  ,SDDYNA,SDDISC)
        ELSE
          CALL PASCOU(MATE  ,CARELE,SDDYNA,SDDISC)
        ENDIF
      ENDIF
C
C --- CREATION SD ARCHIVAGE
C
      CALL NMCRAR(RESULT,SDDISC,FONACT)
C
C --- SUBDIVISION AUTOMATIQUE DU PAS DE TEMPS
C
      CALL NMCRSU(SDDISC,LISINS,PARCRI,FONACT,SOLVEU)
C
C --- CREATION SD OBSERVATION
C
      CALL NMCROB(NOMA  ,NOMO  ,RESULT,SDSENS,SDIETO,
     &            SDOBSE)
C
C --- CREATION SD SUIVI_DDL
C
      CALL NMCRDD(NOMA  ,NOMO  ,SDIETO,SDSENS,SDSUIV)

      END
