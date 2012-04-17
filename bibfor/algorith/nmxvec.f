      SUBROUTINE NMXVEC(MODELZ,MATE  ,CARELE,COMPOR,CARCRI,
     &                  SDTIME,SDDISC,SDDYNA,NUMINS,VALINC,
     &                  SOLALG,LISCHA,COMREF,RESOCO,RESOCU,
     &                  NUMEDD,PARCON,SDSENS,LSENS ,NRPASE,
     &                  VEELEM,VEASSE,MEASSE,NBVECT,LTYPVE,
     &                  LCALVE,LOPTVE,LASSVE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/04/2012   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER       NBVECT
      CHARACTER*6   LTYPVE(20)
      LOGICAL       LCALVE(20),LASSVE(20)
      CHARACTER*16  LOPTVE(20)
      CHARACTER*(*) MODELZ
      LOGICAL       LSENS
      CHARACTER*24  MATE,CARELE,SDTIME
      CHARACTER*24  COMPOR,CARCRI,NUMEDD,SDSENS
      INTEGER       NUMINS,NRPASE
      REAL*8        PARCON(8)
      CHARACTER*19  SDDISC,SDDYNA,LISCHA
      CHARACTER*24  RESOCO,RESOCU,COMREF
      CHARACTER*19  VEELEM(*),VEASSE(*),MEASSE(*)
      CHARACTER*19  SOLALG(*),VALINC(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CALCUL ET ASSEMBLAGE DES VECT_ELEM DE LA LISTE
C
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  MATE   : CHAMP MATERIAU
C IN  PARCON : PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C                     1 : SIGM_REFE
C                     2 : EPSI_REFE
C                     3 : FLUX_THER_REFE
C                     4 : FLUX_HYD1_REFE
C                     5 : FLUX_HYD2_REFE
C                     6 : VARI_REFE
C                     7 : EFFORT (FORC_REFE)
C                     8 : MOMENT (FORC_REFE)
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMPOR : COMPORTEMENT
C IN  LISCHA : LISTE DES CHARGES
C IN  RESOCO : SD RESOLUTION CONTACT
C IN  RESOCU : SD RESOLUTION LIAISON_UNILATER
C IN  SDDYNA : SD POUR LA DYNAMIQUE
C IN  SDSENS : SD SENSIBILITE
C IN  SDTIME : SD TIMER
C IN  LSENS  : .TRUE. SI SENSIBILITE
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  PARMET : PARAMETRES DES METHODES DE RESOLUTION (VOIR NMLECT)
C IN  SOLVEU : SOLVEUR
C IN  CARCRI : PARAMETRES METHODES D'INTEGRATION LOCALES (VOIR NMLECT)
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  NUMINS : NUMERO D'INSTANT
C IN  NRPASE : NUMERO PARAMETRE SENSIBLE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  NBVECT : NOMBRE DE VECT_ELEM DANS LA LISTE
C IN  LTYPVE : LISTE DES NOMS DES VECT_ELEM
C IN  LASSVE : SI VECT_ELEM A ASSEMBLER
C IN  LCALVE : SI VECT_ELEM A CALCULER
C IN  LOPTVE : OPTION DE CALCUL DES VECT_ELEM
C
C ----------------------------------------------------------------------
C
      CHARACTER*6  TYPVEC
      INTEGER      IVECT
      CHARACTER*19 VECELE,VECASS
      REAL*8       DIINST,INSTAM,INSTAP
      CHARACTER*24 MODELE
      LOGICAL      LCALC,LASSE
      CHARACTER*16 OPTION
C
C ----------------------------------------------------------------------
C

C
C --- INITIALISATIONS
C
      IF (NUMINS.EQ.0 )THEN
        INSTAM = 0.D0
        INSTAP = DIINST(SDDISC,NUMINS)
      ELSE
        INSTAM = DIINST(SDDISC,NUMINS-1)
        INSTAP = DIINST(SDDISC,NUMINS)
      ENDIF
      MODELE = MODELZ
C
C --- CALCUL ET ASSEMBLAGE DES VECT_ELEM
C
      DO 10 IVECT = 1,NBVECT
C
C --- VECT_ELEM COURANT
C
        TYPVEC = LTYPVE(IVECT)
        LCALC  = LCALVE(IVECT)
        LASSE  = LASSVE(IVECT)
        OPTION = LOPTVE(IVECT)
C
C --- UTILISER NMFINT
C
        IF (TYPVEC.EQ.'CNFINT') THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- UTILISER NMDIRI
C
        IF (TYPVEC.EQ.'CNDIRI') THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- UTILISER NMBUDI
C
        IF (TYPVEC.EQ.'CNBUDI') THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- CALCULER VECT_ELEM
C
        IF (LCALC) THEN
          CALL NMCHEX(VEELEM,'VEELEM',TYPVEC,VECELE)
          CALL NMCALV(TYPVEC,
     &                MODELE,LISCHA,MATE  ,CARELE,COMPOR,
     &                CARCRI,NUMEDD,COMREF,SDTIME,PARCON,
     &                INSTAM,INSTAP,VALINC,SOLALG,SDDYNA,
     &                SDSENS,LSENS ,NRPASE,OPTION,VECELE)
        ENDIF
C
C --- ASSEMBLER VECT_ELEM
C
        IF (LASSE) THEN
          CALL NMCHEX(VEASSE,'VEASSE',TYPVEC,VECASS)
          CALL NMASSV(TYPVEC,
     &                MODELZ,LISCHA,MATE  ,CARELE,COMPOR,
     &                NUMEDD,INSTAM,INSTAP,RESOCO,RESOCU,
     &                SDDYNA,VALINC,COMREF,MEASSE,VECELE,
     &                VECASS)
        ENDIF
  10  CONTINUE
C
      END
