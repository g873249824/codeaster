      SUBROUTINE DXPRD2(DFPLA1,DCA,DFPLA2,DFPLA3,DCB,DFPLA4,SCAL)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/11/2003   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     REALISE LE CALCUL DES TERMES DU NUMERATEUR INTERVENANT DANS LE 
C     CALCUL DE TANGENTE DANS LE CAS DE LA LOI DE COMPORTEMENT GLRC
C ----------------------------------------------------------------------
      IMPLICIT NONE
      COMMON /TDIM/ N, ND
      REAL*8 DFPLA1(6), DFPLA2(6), DFPLA3(6), DFPLA4(4)
      REAL*8 VECTA(6),  VECTB(6),  DCA(6,6),  DCB(6,6)
      REAL*8 SCAL1,     SCAL2,     SCAL
      INTEGER N, ND
C     
      N = 6
      CALL PMAVEC('ZERO',6,DCA,DFPLA2,VECTA)
      CALL LCPRSC(DFPLA1,VECTA,SCAL1)
      CALL PMAVEC('ZERO',6,DCB,DFPLA4,VECTB)
      CALL LCPRSC(DFPLA3,VECTB,SCAL2)      
      SCAL = SCAL1*SCAL2
C
      END 
