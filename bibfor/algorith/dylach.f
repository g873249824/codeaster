      SUBROUTINE DYLACH(NOMO  ,MATE  ,CARELE,LISCHA,NUMEDD,
     &                  VEDIRI,VENEUM,VEVOCH,VASSEC)
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
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMO
      CHARACTER*24  MATE,CARELE
      CHARACTER*19  LISCHA
      CHARACTER*(*) NUMEDD
      CHARACTER*19  VEDIRI,VENEUM,VEVOCH,VASSEC
C
C ----------------------------------------------------------------------
C
C DYNA_LINE_HARM
C
C CALCUL ET PRE-ASSEMBLAGE DU CHARGEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DU MODELE
C IN  LISCHA : SD LISTE DES CHARGES
C IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE   : MATERIAU CODE
C IN  NUMEDD : NOM DU NUME_DDL
C OUT VEDIRI : VECT_ELEM DE L'ASSEMBLAGE DES ELEMENTS DE LAGRANGE
C OUT VENEUM : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS DE NEUMANN
C OUT VEVOCH : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS EVOL_CHAR
C OUT VASSEC : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS VECT_ASSE_CHAR
C
C
C
C
      REAL*8       PARTPS(3),INSTAN
      CHARACTER*19 K19BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      INSTAN    = 0.D0
      PARTPS(1) = INSTAN
      PARTPS(2) = 0.D0
      PARTPS(3) = 0.D0
C
C --- CALCUL DES VECTEURS ELEMENTAIRES
C
      CALL VEDIMD(NOMO  ,LISCHA,INSTAN,0     ,' '   ,
     &            VEDIRI)
      CALL VECHMS(NOMO  ,MATE  ,CARELE,K19BID,LISCHA,
     &            'MECA',' '   ,0     ,PARTPS,VENEUM)
      CALL VEEVOC(NOMO  ,MATE  ,CARELE,K19BID,LISCHA,
     &            PARTPS,'MECA',' '   ,0     ,VEVOCH)
      CALL VEASSC(LISCHA,VASSEC)
C
C --- PREPARATION DE L'ASSEMBLAGE
C
      CALL ASVEPR(LISCHA,VEDIRI,'C',NUMEDD)
      CALL ASVEPR(LISCHA,VENEUM,'C',NUMEDD)
      CALL ASVEPR(LISCHA,VEVOCH,'C',NUMEDD)
      CALL ASVEPR(LISCHA,VASSEC,'C',NUMEDD)
C
      CALL JEDEMA()

      END
