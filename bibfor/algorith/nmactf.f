      SUBROUTINE NMACTF(SDIMPR,SDDISC,SDERRO,DEFICO,RESOCO,
     &                  PARCRI,ITERAT,NUMINS)
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 SDIMPR,SDERRO
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 SDDISC
      REAL*8       PARCRI(*)
      INTEGER      ITERAT,NUMINS
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DES ACTIONS A LA FIN D'UNE BOUCLE DE POINT FIXE
C
C BOUCLE POINT FIXE -> BOUCLE TEMPS
C
C ----------------------------------------------------------------------
C
C IN  SDIMPR : SD AFFICHAGE
C IN  SDDISC : SD DISCRETISATION
C IN  SDERRO : SD GESTION DES ERREURS
C IN  PARCRI : CRITERES DE CONVERGENCE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  NUMINS : NUMERO D'INSTANT
C
C
C
C
      INTEGER      RETACT,IEVDAC
      LOGICAL      ARRET
      CHARACTER*4  ETFIXE
      INTEGER      ACTFIX
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      ARRET  = (NINT(PARCRI(4)).EQ.0)
      RETACT = 4
      ACTFIX = 3
C
C --- ETAT DU POINT FIXE ?
C
      CALL NMLEEB(SDERRO,'FIXE',ETFIXE)
C
C --- ACTIONS SUITE A UN EVENEMENT
C
      IF (ETFIXE.EQ.'CONV') THEN
        RETACT = 0
      ELSEIF (ETFIXE.EQ.'EVEN') THEN
        CALL NMACTO(SDDISC,IEVDAC)
        CALL NMEVAC(SDIMPR,SDDISC,SDERRO,DEFICO,RESOCO,
     &              IEVDAC,NUMINS,ITERAT,RETACT)
C ----- ON NE PEUT PAS CONTINUER LES ITERATIONS DE NEWTON ICI
        CALL ASSERT(RETACT.NE.2)
      ELSEIF (ETFIXE.EQ.'CONT') THEN
        RETACT = 2
      ELSEIF (ETFIXE.EQ.'ERRE') THEN
        RETACT = 1
      ELSEIF (ETFIXE.EQ.'STOP') THEN
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
        ACTFIX = 0
      ELSE IF (RETACT.EQ.1)  THEN
C
C ----- ON REFAIT LE PAS DE TEMPS
C
        ACTFIX = 1
      ELSE IF (RETACT.EQ.2) THEN
C
C ----- ON CONTINUE LES ITERATIONS DE POINT FIXE
C
        ACTFIX = 2
      ELSEIF (RETACT.EQ.3) THEN
C
C ----- ECHEC DE L'ACTION
C
        IF (.NOT.ARRET) THEN
C
C ------- CONVERGENCE FORCEE -> ON PASSE A LA SUITE
C
          CALL U2MESS('A','MECANONLINE2_37')
          ACTFIX = 0
        ELSE
C
C ------- ARRET DU CALCUL
C
          ACTFIX = 3
        ENDIF
      ELSEIF (RETACT.EQ.4) THEN
C
C ----- ARRET DU CALCUL
C
        ACTFIX = 3
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CHANGEMENT DE STATUT DE LA BOUCLE
C
      IF (ACTFIX.EQ.0) THEN
        CALL NMECEB(SDERRO,'FIXE','CONV')
      ELSEIF (ACTFIX.EQ.1) THEN
        CALL NMECEB(SDERRO,'FIXE','ERRE')
      ELSEIF (ACTFIX.EQ.2)  THEN
        CALL NMECEB(SDERRO,'FIXE','CONT')
      ELSEIF (ACTFIX.EQ.3) THEN
        CALL NMECEB(SDERRO,'FIXE','STOP')
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
C
      END
