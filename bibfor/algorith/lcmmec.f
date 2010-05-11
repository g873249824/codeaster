        SUBROUTINE LCMMEC( COEFT,IFA,NMAT,NBCOMM,NECRCI,
     &     ITMAX, TOLER, ALPHAM,DGAMMA,DALPHA,IRET)
        IMPLICIT NONE
C RESPONSABLE PROIX J-M.PROIX
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/05/2010   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
        INTEGER NMAT,IFA,NBCOMM(NMAT,3),IRET,ITMAX
        REAL*8  COEFT(NMAT),DGAMMA,DALPHA,TOLER
        CHARACTER*16 NECRCI
C ======================================================================
C  INTEGRATION DES LOIS MONOCRISTALLINES : ECROUISSAGE CINEMATIQUE
C  COMME LCMMFC MAIS EXPLICITE
C ======================================================================
C       IN  COEFT   :  PARAMETRES MATERIAU
C           IFA     :  NUMERO DE FAMILLE
C           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           NECRCI  :  NOM DE LA LOI D'ECROUISSAGE CINEMATIQUE
C           DGAMMA  :  DERIVEES DES VARIABLES INTERNES A T
C           ALPHAM  : VARIABLE ECRO CINE A T     
C           ITMAX  :  ITER_INTE_MAXI
C           TOLER  :  RESI_INTE_RELA
C     OUT:
C           DALPHA  : VARIABLE INTERNE ECROUISSAGE CINEMATIQUE
C           IRET    : CODE RETOUR
C
C     ----------------------------------------------------------------
      REAL*8 D,ALPHA,GM,PM,C,CC,ALPHAM,ABSDGA,LCINE2,X(4),Y(4)
      REAL*8 F0,X1,FMAX,R8MIEM,SGNA
      INTEGER IEC,ITER,IFM,NIV,NUECIN
C     ----------------------------------------------------------------

C     DANS VIS : 1 = ALPHA, 2=GAMMA, 3=P

      IEC=NBCOMM(IFA,2)
      ABSDGA=ABS(DGAMMA)
      NUECIN=NINT(COEFT(IEC))

C----------------------------------------------------------------------
C   POUR UN NOUVEAU TYPE D'ECROUISSAGE CINEMATIQUE, AJOUTER UN BLOC IF
C----------------------------------------------------------------------

      IRET=0
C      IF (NECRCI.EQ.'ECRO_CINE1') THEN
      IF (NUECIN.EQ.1) THEN
          D=COEFT(IEC+1)
          DALPHA=DGAMMA-D*ALPHAM*ABSDGA
      
C      IF (NECRCI.EQ.'ECRO_CINE2') THEN
      ELSEIF (NUECIN.EQ.2) THEN
         IRET=0
          D =COEFT(IEC+1)
          GM=COEFT(IEC+2)
          PM=COEFT(IEC+3)
          C =COEFT(IEC+4)
          CC=ABS(C*ALPHAM)
          DALPHA=DGAMMA-D*ALPHAM*ABSDGA
          IF(CC.GT.R8MIEM()) THEN
            SGNA=ALPHAM/ABS(ALPHAM)
            DALPHA=DALPHA-SGNA*(CC/GM)**PM 
          ENDIF
      ELSE
          CALL U2MESS('F','COMPOR1_19')          
      ENDIF
           
      END
