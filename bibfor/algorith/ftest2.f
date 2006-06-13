      SUBROUTINE FTEST2(NP3,RC,THETA,XLOC,IC,TYPCH,NBSEG,DIST2)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/05/2000   AUTEUR KXBADNG T.KESTENS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C DESCRIPTION : CALCUL DE LA FONCTION TEST CHOC SUR BUTEE IC (CARRE)
C -----------
C               APPELANT : CALND1
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER    NP3
      REAL*8     RC(NP3,*), THETA(NP3,*), XLOC(*)
      INTEGER    IC, TYPCH(*), NBSEG(*)
      REAL*8     DIST2
C
C VARIABLES LOCALES
C -----------------
      INTEGER    TYPOBS, NBS, I
      REAL*8     XJEU, XLG, COST, SINT, RI, DNORM
C
C FONCTIONS INTRINSEQUES
C ----------------------
C     INTRINSIC  SQRT
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL   DISBUT, UTMESS
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      TYPOBS = TYPCH(IC)
C
C  0. OBSTACLE PLAN PARALLELE A YLOCAL
C     --------------------------------
      IF ( TYPOBS.EQ.0 ) THEN
C
         XJEU  = RC(1,IC)
         DIST2 = XJEU*XJEU - XLOC(2)*XLOC(2)
C
C  1. OBSTACLE PLAN PARALLELE A ZLOCAL
C     --------------------------------
      ELSE IF ( TYPOBS.EQ.1 ) THEN
C
         XJEU  = RC(1,IC)
         DIST2 = XJEU*XJEU - XLOC(3)*XLOC(3)
C
C  2. OBSTACLE CIRCULAIRE
C     -------------------
      ELSE IF ( TYPOBS.EQ.2 ) THEN
C
         XJEU  = RC(1,IC)
         XLG   = XLOC(2)*XLOC(2) + XLOC(3)*XLOC(3)
         DIST2 = XJEU*XJEU - XLG
C
C  3. OBSTACLE DISCRETISE
C     -------------------
      ELSE IF ( TYPOBS.EQ.3 ) THEN
C
C....... CALCUL DU SIN ET DU COS DE L'ANGLE DE LA NORMALE A L'OBSTACLE
C....... ET DE LA DISTANCE NORMALE DE CHOC
C
         NBS = NBSEG(IC)
         CALL DISBUT(NP3,IC,XLOC,TYPOBS,XJEU,RC,THETA,NBS,COST,SINT,
     &               DNORM)
C
         RI = SQRT( XLOC(2)*XLOC(2) + XLOC(3)*XLOC(3) )
         DIST2 = DNORM * (DNORM + 2.0D0*RI)
C
C  4. SORTIE EN ERREUR FATALE SI TRAITEMENT NON PREVU POUR LE TYPE
C     D'OBSTACLE DEMANDE
C     ------------------
      ELSE
C
         CALL UTMESS('F','FTEST2','TRAITEMENT NON PREVU POUR LE TYPE '//
     &               'D''OBSTACLE DEMANDE')
C
      ENDIF
C
C --- FIN DE FTEST2.
      END
