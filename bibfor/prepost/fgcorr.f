      SUBROUTINE FGCORR(NBCYCL,SIGMIN,SIGMAX,METHOD,SU,RCORR)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)                          METHOD
      REAL*8                   SIGMIN(*),SIGMAX(*), SU,RCORR(*)
      INTEGER           NBCYCL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     -----------------------------------------------------------------
C     CORRECTION DE HAIGH : GOODMAN OU GERBER
C     ------------------------------------------------------------------
C IN  NBCYCL : I   : NOMBRE DE CYCLES
C IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYLES
C IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
C IN  METHOD : K   : METHODE DE CORRECTION GOODMAN OU GERBER
C IN  SU     : R   :
C OUT RCORR  : R   : CORRECTION DE HAIGH POUR CHAQUE CYCLE
C     ------------------------------------------------------------------
C
      REAL*8 VALMOY
C
C-----------------------------------------------------------------------
      INTEGER I 
C-----------------------------------------------------------------------
      DO 10 I=1,NBCYCL
        VALMOY = (SIGMAX(I)+SIGMIN(I))/2.D0
        IF(METHOD.EQ.'GOODMAN') THEN
          IF(VALMOY.LT.SU) THEN
             RCORR(I) = 1.D0 - (VALMOY/SU)
          ELSE
             CALL U2MESS('F','FATIGUE1_4')
          ENDIF
        ELSEIF(METHOD.EQ.'GERBER') THEN
          IF(VALMOY.LT.SU) THEN
             RCORR(I) = 1.D0 - (VALMOY/SU)**2
          ELSE
             CALL U2MESS('F','FATIGUE1_5')
          ENDIF
        ENDIF
  10  CONTINUE
C
      END
