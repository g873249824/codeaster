        SUBROUTINE LCMMEC( TAUS,COEFT,IFA,NMAT,NBCOMM,NECRCI,
     &                     VIS,DGAMMA,DP,DALPHA )
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2004   AUTEUR KANIT T.KANIT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
        INTEGER NMAT,IFA,NBCOMM(NMAT,3)
        REAL*8  COEFT(NMAT),VIS(3),TAUS,DGAMMA,DALPHA,DP
        CHARACTER*16 NECRCI
C ======================================================================
C       IN  TAUS     :  SCISSION REDUITE
C           COEFT   :  PARAMETRES MATERIAU
C           IFA :  NUMERO DE FAMILLE
C           NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           NECRCI  :  NOM DE LA LOI D'ECROUISSAGE CINEMATIQUE
C           VIS   VARIABLES INTERNES DU SYSTEME DE GLISSEMENT COURANT
C           DGAMMA    :  DERIVEES DES VARIABLES INTERNES A T
C           DP
C     OUT:
C           DALPHA  : VARIABLE INTERNE ECROUISSAGE CINEMATIQUE
C  INTEGRATION DES LOIS MONOCRISTALLINES PAR UNE METHODE DE RUNGE KUTTA
C
C     ----------------------------------------------------------------
      REAL*8 D,ALPHA,GM,PM,C,CC
      INTEGER IEC
C     ----------------------------------------------------------------

C     DANS VIS : 1 = ALPHA, 2=GAMMA, 3=P

      IEC=NBCOMM(IFA,2)
      ALPHA=VIS(2)
      IF (NECRCI.EQ.'ECRO_CINE1') THEN
          D=COEFT(IEC-1+1)
          DALPHA=DGAMMA-D*ALPHA*DP
      ENDIF
      
      IF (NECRCI.EQ.'ECRO_CINE2') THEN
          D=COEFT(IEC-1+1)
          GM=COEFT(IEC-1+2)
          PM=COEFT(IEC-1+3)
          C=COEFT(IEC-1+4)
          CC=C*ALPHA
          IF(ALPHA.EQ.0.D0) THEN
            DALPHA=DGAMMA-D*ALPHA*DP
          ELSE
            DALPHA=DGAMMA-D*ALPHA*DP-((ABS(CC)/GM)**PM)*ALPHA/ABS(ALPHA)
          ENDIF
      ENDIF
      
           
      END
