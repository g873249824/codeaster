      SUBROUTINE NMACTP(SDIMPR,SDDISC,SDERRO,DEFICO,RESOCO,
     &                  SOLVEU,PARCRI,NBITER,NUMINS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/10/2012   AUTEUR DESOZA T.DESOZA 
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
      CHARACTER*24 SDIMPR,SDERRO
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 SDDISC,SOLVEU
      REAL*8       PARCRI(*)
      INTEGER      NBITER,NUMINS
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DES ACTIONS A LA FIN D'UN PAS DE TEMPS
C
C ----------------------------------------------------------------------
C
C
C IN  SDIMPR : SD AFFICHAGE
C IN  SDDISC : SD DISCRETISATION
C IN  SDERRO : SD GESTION DES ERREURS
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  SOLVEU : SD SOLVEUR
C IN  PARCRI : CRITERES DE CONVERGENCE
C IN  NBITER : NOMBRE D'ITERATIONS DE NEWTON
C IN  NUMINS : NUMERO D'INSTANT
C
C
C
C
      INTEGER      RETACT,IEVDAC,ACTPAS,ITERAT,IBID
      CHARACTER*4  ETINST
      LOGICAL      ARRET
      INTEGER      PILESS,IREAPC
      CHARACTER*16 PILCHO
      REAL*8       R8BID
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      ARRET  = (NINT(PARCRI(4)).EQ.0)
      RETACT = 4
      ACTPAS = 3
      ITERAT = NBITER - 1
C
C --- ETAT DE LA BOUCLE EN TEMPS ?
C
      CALL NMLEEB(SDERRO,'INST',ETINST)
C
C --- ACTIONS SUITE A UN EVENEMENT
C
      IF (ETINST.EQ.'CONV') THEN
        RETACT = 0
      ELSEIF (ETINST.EQ.'EVEN') THEN
        CALL NMACTO(SDDISC,IEVDAC)
        CALL NMEVAC(SDIMPR,SDDISC,SDERRO,DEFICO,RESOCO,
     &              SOLVEU,IEVDAC,NUMINS,ITERAT,RETACT)
      ELSEIF (ETINST.EQ.'ERRE') THEN
        RETACT = 1
      ELSEIF (ETINST.EQ.'STOP') THEN
        RETACT = 4
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- TRAITEMENT DE L'ACTION
C
      IF (RETACT.EQ.0) THEN
C
C ----- TOUT EST OK -> ON PASSE A LA SUITE
C
        ACTPAS = 0
C
      ELSEIF (RETACT.EQ.1) THEN
C
C ----- ON REFAIT LE PAS DE TEMPS
C
        ACTPAS = 1
C
      ELSEIF (RETACT.EQ.2) THEN
C
C ----- PAS D'ITERATION EN PLUS ICI
C
        CALL ASSERT(.FALSE.)
C
      ELSEIF (RETACT.EQ.3) THEN
C
C ----- ECHEC DE L'ACTION
C
        IF (.NOT.ARRET) THEN
C
C ------- CONVERGENCE FORCEE -> ON PASSE A LA SUITE
C
          CALL U2MESS('A','MECANONLINE2_37')
          ACTPAS = 0
        ELSE
C
C ------- ARRET DU CALCUL
C
          ACTPAS = 3
        ENDIF
C
      ELSEIF (RETACT.EQ.4) THEN
C
C ----- ARRET DU CALCUL
C
        ACTPAS = 3
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CHANGEMENT DE STATUT DE LA BOUCLE
C
      IF (ACTPAS.EQ.0) THEN
        CALL NMECEB(SDERRO,'INST','CONV')
      ELSEIF (ACTPAS.EQ.1) THEN
        CALL NMECEB(SDERRO,'INST','ERRE')
      ELSEIF (ACTPAS.EQ.3) THEN
        CALL NMECEB(SDERRO,'INST','STOP')
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- PROCHAIN INSTANT: ON REINITIALISE
C
      IF (ACTPAS.EQ.0) THEN
C
C ----- REMISE A ZERO ESSAI_REAC_PRECOND
C
        CALL ISACTI(SDDISC,'REAC_PRECOND',IEVDAC)
        IF (IEVDAC.NE.0) THEN
          IREAPC = 0
          CALL UTDIDT('E'   ,SDDISC,'ECHE',IEVDAC,'ESSAI_REAC_PRECOND',
     &                R8BID ,IREAPC,K8BID )
        ENDIF
C
C ----- REMISE A ZERO ESSAI_ITER_PILO
C
        CALL ISACTI(SDDISC,'AUTRE_PILOTAGE',IEVDAC)
        IF (IEVDAC.NE.0) THEN
          PILESS = 1
          PILCHO = 'NATUREL'
          CALL UTDIDT('E'   ,SDDISC,'ECHE',IEVDAC,'ESSAI_ITER_PILO',
     &                R8BID ,PILESS,K8BID )
          CALL UTDIDT('E'   ,SDDISC,'ECHE',IEVDAC,'CHOIX_SOLU_PILO',
     &                R8BID ,IBID  ,PILCHO)
        ENDIF
      ENDIF
C
      CALL JEDEMA()
      END
