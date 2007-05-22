      SUBROUTINE DILDER(INTERP,DIMDEF,DIMCON,NDIM,REGULA,RPENA,DSDE2G,
     +                  DRDE)
C ======================================================================
      IMPLICIT     NONE
      INTEGER      DIMDEF,DIMCON,NDIM,REGULA(6)
      REAL*8       DSDE2G(NDIM,NDIM),DRDE(DIMCON,DIMDEF),RPENA
      CHARACTER*2  INTERP
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/05/2007   AUTEUR FERNANDES R.FERNANDES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C --- BUT : MISE A JOUR DE L OPERATEUR TANGENT POUR LA PARTIE ----------
C ---       SECOND GRADIENT A MIDCRO DILATATION AU POINT D INTEGRATION -
C ======================================================================
      INTEGER I,J,ADDER1,ADDER2,ADDER3,ADCOR1,ADCOR2,ADCOR3
C ======================================================================
      ADDER1=REGULA(1)
      ADDER2=REGULA(2)
      ADDER3=REGULA(3)
      ADCOR1=REGULA(4)
      ADCOR2=REGULA(5)
      ADCOR3=REGULA(6)
C ======================================================================
      DO 10 I=1,DIMDEF
         DO 20 J=1,DIMCON
            DRDE(J,I)=0.0D0
 20      CONTINUE
 10   CONTINUE
C ======================================================================
      DRDE(ADCOR1,ADDER1)=DRDE(ADCOR1,ADDER1)+RPENA
      DO 30 I=1,NDIM
         DO 40 J=1,NDIM
            DRDE(ADCOR2-1+J,ADDER2-1+I)=DRDE(ADCOR2-1+J,ADDER2-1+I)+
     +                                  DSDE2G(J,I)
 40      CONTINUE
 30   CONTINUE
      IF (INTERP.EQ.'P0') THEN
         DRDE(ADCOR1,ADDER3)=DRDE(ADCOR1,ADDER3)+1.0D0
         DRDE(ADCOR3,ADDER1)=DRDE(ADCOR3,ADDER1)-1.0D0
      ENDIF
C ======================================================================
      END
