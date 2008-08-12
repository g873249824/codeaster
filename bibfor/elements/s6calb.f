      SUBROUTINE S6CALB(BKSIP,XNOE,B,AJAC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/08/2008   AUTEUR DESROCHES X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     ------------------------------------------------------------------
C      CALCUL DE LA MATRICE B AU POINT D INTEGRATION DONNNE
C
C                                                    TRNH V.D 2007
C     ------------------------------------------------------------------
C
C  ENTREES :
C     XNOE(18) : COORDONNEES DES NOEUDS
C     IPINT      : NO DU POINT D INTEGRATION
C     MOT        : NOM DE L ELEMENT FINI
C  SORTIE
C     B(NBLIB,NBN) : MATRICE B
C     AJAC         : JACOBIEN

      IMPLICIT NONE

      REAL *8 XNOE(18),BKSIP(3,6)
      REAL *8 B(3,6),AJAC
C
C  VARIABLES LOCALES
C
      REAL *8 DJ(3,3),UJ(3,3)
      INTEGER  LRET,I,J,K,NBN
C
      NBN  =  6
C
C   DJ = BKSIP * TRANSPOSE(XNOE)
C
      DO 20 I=1,3
        DO 10 J=1,3
           DJ(I,J) = 0.D0
   10   CONTINUE
   20 CONTINUE
      DO 50 I=1,3
        DO 40 J=1,3
           DO 30 K=1,NBN
             DJ(J,I)=DJ(J,I)+BKSIP(J,K)*XNOE((K-1)*3+I)
   30      CONTINUE
   40   CONTINUE
   50 CONTINUE
C
C  UJ(J,I)  MATRICE INVERSE DE DJ(J,I)
C
      
      CALL INVE33(DJ,UJ,AJAC,LRET)
C      
C TEST SI ELEMENT TROP DEFORME: CROISEMENT
C      IF(LRET.NE.ZERO) CALL TILT
      AJAC=ABS(AJAC)
C
C MATRICE ( B ) = UJ * BKSIP
C
      DO 70 I=1,3
         DO 60 J=1,NBN
            B(I,J)=0.D0
   60    CONTINUE
   70 CONTINUE
      DO 100 K=1,3
        DO 90 J=1,3
          DO 80 I=1,NBN
            B(J,I)=B(J,I)+UJ(J,K)*BKSIP(K,I)
   80     CONTINUE
   90   CONTINUE
  100 CONTINUE
C
      END
