        SUBROUTINE LCMMJI( COEFT,IFA,NMAT,NBCOMM,NECRIS,HSR,
     &                     IS,IR,PR,DRDPS)
        IMPLICIT NONE
        INTEGER IFA,NMAT,NBCOMM(NMAT,3),IR,IS
        REAL*8 COEFT(NMAT),DRDPS,PS,HSR(5,24,24)
        CHARACTER*16 NECRIS
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/05/2007   AUTEUR ELGHARIB J.EL-GHARIB 
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
C RESPONSABLE JMBHH01 J.M.PROIX
C ======================================================================
C  CALCUL DE LA DERIVEE DE LA FONCTION D'ECROUISSAGE dRS/dPR
C       IN  COEFT   :  PARAMETRES MATERIAU
C           IFA     :  NUMERO DE FAMILLE
C           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           NECRIS  :  NOM DE LA LOI D'ECROUISSAGE ISOTROPE
C           IS      :  NUMERO DU SYSTEME DE GLISSEMENT EN COURS
C           IR      :  NUMERO DU SYSTEME DE GLISSEMENT POUR INTERACTION
C           PR      :  DEFORMATION PLASTIQUE CUMULEE POUR INTERACTION
C     OUT:
C           DRSDPR :  D(RS(P))/D(PR)
C     ----------------------------------------------------------------
      REAL*8 P,R0,Q,H,B,RP,K,N,B1,B2,Q1,Q2,DRDP,DP,PR
      INTEGER IFL,IEI,IEC,NS
C      INTEGER NUMHSR
C     ----------------------------------------------------------------

      IEI=NBCOMM(IFA,3)

      
      IF (NECRIS.EQ.'ECRO_ISOT1') THEN
         Q=COEFT(IEI-1+2)
         B=COEFT(IEI-1+3)
C        R(PS)=R0+Q*SOMME(HSR*(1-EXP(-B*PR))         
C        dRs/dpr
C         NUMHSR=COEFT(IEI-1+4)
         DRDPS=B*Q*HSR(IFA,IS,IR)*EXP(-B*PR)  
         
      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN
         Q1=COEFT(IEI-1+2)
         B1=COEFT(IEI-1+3)
         Q2=COEFT(IEI-1+5)
         B2=COEFT(IEI-1+6)         
C         NUMHSR=COEFT(IEI-1+6)
         DRDPS=Q1*HSR(IFA,IS,IR)*B1*EXP(-B1*PR)
         IF (IS.EQ.IR) THEN
            DRDPS=DRDPS+Q2*B2*EXP(-B2*PR)
         ENDIF
  
      ENDIF
           
      END
