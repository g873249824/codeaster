      SUBROUTINE RSDOCU ( DOCU , REPK, IRET )
      IMPLICIT   NONE
      INTEGER             IRET
      CHARACTER*4         DOCU
      CHARACTER*24        REPK
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/01/2001   AUTEUR DURAND C.DURAND 
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
C ----------------------------------------------------------------------
C
      IRET = 0
      IF (     DOCU .EQ. 'EVEL' ) THEN
         REPK = 'EVOL_ELAS'
C
      ELSEIF ( DOCU .EQ. 'MUEL' ) THEN
         REPK = 'MULT_ELAS'
C
      ELSEIF ( DOCU .EQ. 'FOEL' ) THEN
         REPK = 'FOURIER_ELAS'
C
      ELSEIF ( DOCU .EQ. 'COFO' ) THEN
         REPK = 'COMB_FOURIER'
C
      ELSEIF ( DOCU .EQ. 'EVNO' ) THEN
         REPK = 'EVOL_NOLI'
C
      ELSEIF ( DOCU .EQ. 'EVCH' ) THEN
         REPK = 'EVOL_CHAR'
C
      ELSEIF ( DOCU .EQ. 'DYTR' ) THEN
         REPK = 'DYNA_TRANS'
C
      ELSEIF ( DOCU .EQ. 'DYHA' ) THEN
         REPK = 'DYNA_HARMO'
C
      ELSEIF ( DOCU .EQ. 'HAGE' ) THEN
         REPK = 'HARM_GENE'
C
      ELSEIF ( DOCU .EQ. 'ACHA' ) THEN
         REPK = 'ACOU_HARMO'
C
      ELSEIF ( DOCU .EQ. 'MOAC' ) THEN
         REPK = 'MODE_ACOU'
C
      ELSEIF ( DOCU .EQ. 'MOFL' ) THEN
         REPK = 'MODE_FLAMB'
C
      ELSEIF ( DOCU .EQ. 'MOME' ) THEN
         REPK = 'MODE_MECA'
C
      ELSEIF ( DOCU .EQ. 'MOGE' ) THEN
         REPK = 'MODE_GENE'
C
      ELSEIF ( DOCU .EQ. 'MOST' ) THEN
         REPK = 'MODE_STAT'
C
      ELSEIF ( DOCU .EQ. 'EVTH' ) THEN
         REPK = 'EVOL_THER'
C
      ELSEIF ( DOCU .EQ. 'EVVA' ) THEN
         REPK = 'EVOL_VARC'
C
      ELSEIF ( DOCU .EQ. 'BAMO' ) THEN
         REPK = 'BASE_MODALE'
C
      ELSEIF ( DOCU .EQ. 'THET' ) THEN
         REPK = 'THETA_GEOM'
C
      ELSE
         IRET = 1
      ENDIF
C
      END
