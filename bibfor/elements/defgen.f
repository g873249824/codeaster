      SUBROUTINE DEFGEN(TESTL1,TESTL2,NNO,R,X3,SINA,COSA,COUR,VF,
     &                                              DFDS,DEPL,EPS,EPSX3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
C
      INTEGER NNO
      LOGICAL TESTL1,TESTL2
      REAL*8 R,X3,SINA,COSA,COUR,VF(*),DFDS(*),DEPL(*),EPS(*),EPSX3
      REAL*8 UXL(3),UYL(3),BETASL(3)
      REAL*8 ESS,KSS,ETT,KTT,GS
C
C     CALCUL DES DEFORMATIONS GENERALISEES : ESS , ETT , KSS , KTT , GS
C
C     PARTITION DU DEPL EN UX, UY ET BETAS
C
C     DO 10 INO=1,NNO
C-----------------------------------------------------------------------
      INTEGER I 
      REAL*8 BETAS ,DBTDS ,DUXDS ,DUYDS ,RHOS ,RHOT ,UX 
      REAL*8 UY 
C-----------------------------------------------------------------------
         UXL(1)=DEPL(1)
         UXL(2)=DEPL(4)
         UXL(3)=DEPL(7)
C
         UYL(1)=DEPL(2)
         UYL(2)=DEPL(5)
         UYL(3)=DEPL(8)
C
         BETASL(1)=DEPL(3)
         BETASL(2)=DEPL(6)
         BETASL(3)=DEPL(9)
C10   CONTINUE
C
         UX   =0.D0
         UY   =0.D0
         BETAS=0.D0
C
         DUXDS=0.D0
         DUYDS=0.D0
         DBTDS=0.D0
      DO 20  I=1,NNO
         UX   =UX+VF(I)*UXL(I)
         UY   =UY+VF(I)*UYL(I)
         BETAS=BETAS+VF(I)*BETASL(I)
C
         DUXDS=DUXDS+DFDS(I)*UXL(I)
         DUYDS=DUYDS+DFDS(I)*UYL(I)
         DBTDS=DBTDS+DFDS(I)*BETASL(I)
 20   CONTINUE
C
C     ESS  ,  KSS  ,  ETT  ,  KTT  ,  GS        
C
      ESS    = DUYDS*COSA-DUXDS*SINA
      KSS    = DBTDS
      ETT    = UX/R
      KTT    = -SINA/R*BETAS
      GS     = BETAS+DUXDS*COSA+DUYDS*SINA
C
      IF (TESTL1) THEN
         RHOS=1.D0
      ELSE
         RHOS=1.D0 + X3 * COUR
      ENDIF
      IF (TESTL2) THEN
         RHOT=1.D0
      ELSE
         RHOT=1.D0 + X3 * COSA / R
      ENDIF
C
      EPS(1) = (ESS + X3*KSS) / RHOS
      EPS(2) = (ETT + X3*KTT) / RHOT
      EPS(3) = 0.D0
      EPS(4) = 0.D0
C
      EPSX3  = 0.5D0 / RHOS *  GS
C
      END
