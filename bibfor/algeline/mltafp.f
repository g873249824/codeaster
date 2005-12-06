      SUBROUTINE MLTAFP(N,NCOL,ADPER,MATPER,MATFI,LOCAL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/01/2002   AUTEUR JFBHHUC C.ROSE 
C RESPONSABLE JFBHHUC C.ROSE
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
C ASSEMBLAGE DES MATRICES FRONTALES VERSION SIMPLIFIEE
C  LA VERSION PRECEDENTE ASSEMBLAIT PAR 2 COLONES
C POUR UNE MEILLEURE UTILISATION DES REGISTRES SUR CRAY
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER N,NCOL,ADPER(*),LOCAL(*)
      REAL*8 MATPER(*),MATFI(*)
C     VARIABLES LOCALES
      INTEGER DECP1,DECF1,J,I,NI,ID1,JD1,DECP
      INTEGER IP
      DECF1 = 1
      DO 120 I = 1,NCOL,1
          DECP1 = ADPER(LOCAL(I))
          MATPER(DECP1) = MATPER(DECP1) + MATFI(DECF1)
          DECP1 = DECP1 - LOCAL(I)
          NI = N - I
          DECF1 = DECF1 + 1
          DO 110 J = 1,NI
              MATPER(DECP1+LOCAL(J+I)) = MATPER(DECP1+LOCAL(J+I)) +
     +                                   MATFI(DECF1)
          DECF1 = DECF1 + 1
  110     CONTINUE
  120 CONTINUE

      END
