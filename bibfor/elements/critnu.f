      FUNCTION CRITNU(NMNBN,NMPLAS,NMDPLA,NMDDPL,NMZEF,NMZEG,NMIEF
     &                ,NMPROX,DEPS,DTG)
       IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C
      INTEGER CRITNU

C---------------------------------------------
      REAL*8  NMNBN(6), NPRNBN(6)
      REAL*8  NMPLAS(2,3), NMPRPL(2,3)
      REAL*8  NMDPLA(2,2), NMPRDP(2,2)
      REAL*8  NMDDPL(2,2), NMPRDD(2,2)
      REAL*8  NMZEF, NMPRZF
      REAL*8  NMZEG, NMPRZG
      INTEGER NMIEF, NMPRIF
      INTEGER NMPROX(2), NMPRPR(2)
C---------------------------------------------

      REAL*8
     &      DEPS(6), DTG(6,6),
     &      F1ELAS, F2ELAS, G1ELAS, G2ELAS
      INTEGER IER

      INTEGER  I, J
      REAL*8   CP(6),FPLASS,GPLASS

C      ELASTIC PREDICTOR
       CALL MATMUL(DTG,DEPS,6,6,1,CP)
       DO 10, J = 1,6
         NPRNBN(J) = NMNBN(J) + CP(J)
 10    CONTINUE


        CALL MPPFFN(NPRNBN,NMPRPL,NMPRDP,NMPRDD,NMPRZF
     &             ,NMPRZG,NMPRIF,NMPRPR )
      IF(NMPRIF  .GT.  0) THEN
         CRITNU=-1
         CALL U2MESS('A','ELEMENTS_21')
         GOTO 20
      ENDIF

C       F1ELAS = FPLASS(NPRNBN,NMPRPL,NMPRDP,NMPRDD,NMPRZF
C      &                 ,NMPRZG,NMPRIF,NMPRPR,1)
      F1ELAS = FPLASS(NPRNBN,NMPRPL,1)
C       F2ELAS = FPLASS(NPRNBN,NMPRPL,NMPRDP,NMPRDD,NMPRZF
C      &                 ,NMPRZG,NMPRIF,NMPRPR,2)
      F2ELAS = FPLASS(NPRNBN,NMPRPL,2)
C       G1ELAS = GPLASS(NPRNBN,NMPRPL,NMPRDP,NMPRDD,NMPRZF
C      &                 ,NMPRZG,NMPRIF,NMPRPR,1)
      G1ELAS = GPLASS(NPRNBN,NMPRPL,1)
C       G2ELAS = GPLASS(NPRNBN,NMPRPL,NMPRDP,NMPRDD,NMPRZF
C      &                 ,NMPRZG,NMPRIF,NMPRPR,2)
      G2ELAS = GPLASS(NPRNBN,NMPRPL,2)


      IF ((F1ELAS .GT. 0).OR.(G1ELAS .GT. 0)) THEN
         IF ((F2ELAS .GT. 0).OR.(G2ELAS .GT. 0)) THEN
             CRITNU = 12
         ELSE
             CRITNU = 1
         ENDIF
      ELSEIF ((F2ELAS .GT. 0).OR.(G2ELAS .GT. 0)) THEN
         CRITNU = 2
      ELSE
         CRITNU = 0
      ENDIF

 20   CONTINUE
      END
