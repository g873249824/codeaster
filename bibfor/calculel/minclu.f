      FUNCTION MINCLU(DIME  ,PREC  ,M1    ,D1    ,MM1   ,
     &                SOM1  ,M2    ,D2    ,PAN2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      LOGICAL  MINCLU       
      REAL*8   PREC
      INTEGER  DIME,M1,D1(*),M2,D2(*)
      REAL*8   MM1(2,DIME,*),SOM1(DIME,*)
      REAL*8   PAN2(DIME+2,*)
C      
C ----------------------------------------------------------------------
C
C APPARIEMENT DE DEUX GROUPES DE MAILLE PAR LA METHODE
C BOITES ENGLOBANTES + ARBRE BSP
C
C TEST APPROCHE D'INCLUSION DE LA MAILLE M1 DANS LA MAILLE M2
C
C ----------------------------------------------------------------------
C
C
C IN  DIME  : DIMENSION DE L'ESPACE      
C IN  M1    : MAILLE 1
C IN  M2    : MAILLE 2
C IN  D1    : SD BOITE.DIME ASSOCIEE A M1 (CF BOITE)
C IN  D2    : SD BOITE.DIME ASSOCIEE A M2 (CF BOITE)
C IN  MM1   : SD BOITE.MINMAX ASSOCIEE A M1 (CF BOITE)
C IN  SOM1  : SD BOITE.SOMMET ASSOCIEE A M1 (CF BOITE)
C IN  PAN2  : SD BOITE.PAN ASSOCIEE A M2 (CF BOITE)
C IN  PREC  : PRECISION POUR TESTER INCLUSION
C OUT INCLU : .TRUE. SI LES BOITES ENGLOBANT M1 SONT INCLUSES 
C                  DANS LE CONVEXE (ENGLOBANT/INSCRIT) DE M2
C
C ----------------------------------------------------------------------
C
      INTEGER  I,J,K,NSOM,NPAN,P1,P2,ID(3)
      REAL*8   R
C
C ----------------------------------------------------------------------
C
C
C --- PREMIER TEST: INCLUSION CONVEXE EXTERIEUR
C
      P1   = D1(2+2*M1)
      NSOM = D1(4+2*M1) - P1
      P2   = D2(1+2*M2)
      NPAN = D2(3+2*M2) - P2
C
      DO 10 I = 1, NSOM       
        DO 11 J = 1, NPAN 
          R = PAN2(DIME+2,P2-1+J)
          DO 20 K = 1, DIME
            R = R + SOM1(K,P1-1+I)*PAN2(K,P2-1+J)
 20       CONTINUE
          IF (R.GT.PREC) GOTO 30
 11     CONTINUE          
 10   CONTINUE
C          
      MINCLU = .TRUE.
      GOTO 100
C
 30   CONTINUE
C
C --- SECOND TEST: INCLUSION MINMAX
C
      DO 40 I = 1, DIME
        ID(I) = 1
 40   CONTINUE
C
      DO 50 I = 1, 2**DIME     
        DO 60 J = 1, NPAN        
          R = PAN2(DIME+2,P2-1+J)   
          DO 70 K = 1, DIME
            R = R + MM1(ID(K),K,M1)*PAN2(K,P2-1+J) 
 70       CONTINUE
          IF (R.GT.PREC) GOTO 90
 60     CONTINUE
        K = 1
 80     CONTINUE
        J     = 3 - ID(K)
        ID(K) = J
        K     = K + 1
        IF (J.EQ.1) GOTO 80
 50   CONTINUE
C
      MINCLU = .TRUE.
      GOTO 100
C
C --- FIN
C
 90   CONTINUE
      MINCLU = .FALSE.
C
 100  CONTINUE
C
      END
