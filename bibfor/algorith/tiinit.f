      SUBROUTINE TIINIT(MAILLA,MODELE,RESULZ,LOSTAT,LREUSE,
     &                  LNONL ,INSTIN,SDDISC,SDSENS,SDIETO,
     &                  SDOBSE,LEVOL  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/07/2011   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      REAL*8        INSTIN
      CHARACTER*8   MAILLA
      CHARACTER*19  SDDISC
      LOGICAL       LEVOL,LOSTAT,LNONL,LREUSE
      CHARACTER*19  SDOBSE
      CHARACTER*24  RESULZ,MODELE      
      CHARACTER*24  SDIETO,SDSENS
C
C ----------------------------------------------------------------------
C
C ROUTINE THER_NON_LINE THER_LINEAIRE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
C ----------------------------------------------------------------------
C
C IN  RESULT : NOM UTILISATEUR DU RESULTAT
C IN  MAILLA : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  SDIETO : SD GESTION IN ET OUT
C IN  SDSENS : SD SENSIBILITE
C IN  INSTIN : INSTANT INITIAL QUAND ETAT_INIT
C IN  LOSTAT : .TRUE. SI CALCUL STATIONNAIRE PREALABLE OU PAS
C IN  LNONL  : .TRUE. SI NON-LINEAIRE
C IN  LREUSE : .TRUE. SI REUSE
C OUT LEVOL  : .TRUE. SI TRANSITOIRE
C OUT SDDISC : SD DISCRETISATION
C OUT SDOBSE : NOM DE LA SD POUR OBSERVATION
C
C ----------------------------------------------------------------------
C
      INTEGER      N1
      CHARACTER*8  NOMO,RESULT
      CHARACTER*19 LISINS
C
C ----------------------------------------------------------------------
C
      LISINS = ' '
      LEVOL  = .FALSE.
      NOMO   = MODELE(1:8)
      RESULT = RESULZ(1:8)
C
      CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,N1)
      IF (N1.EQ.0) THEN
        IF (.NOT.LOSTAT) THEN
          CALL U2MESS('F','DISCRETISATION_8')
        ENDIF
        LEVOL  = .FALSE.
        CALL NTCRA0(SDDISC)
        GOTO 999
      ELSE
        LEVOL = .TRUE.
      ENDIF
C
C --- CREATION SD DISCRETISATION
C
      CALL NTCRLI(INSTIN,LISINS,SDDISC)
C
C --- CREATION SD ARCHIVAGE
C
      CALL NTCRAR(RESULT,SDDISC,LREUSE)
C
C --- CREATION SD OBSERVATION
C
      IF (LNONL) THEN
        CALL NMCROB(MAILLA,NOMO  ,RESULT,SDSENS,SDIETO,
     &              SDOBSE)
      ENDIF
C
  999 CONTINUE
C
      END
