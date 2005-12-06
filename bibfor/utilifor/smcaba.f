      SUBROUTINE SMCABA ( FTRC, TRC, NBHIST, X, DZ, IND )
      IMPLICIT   NONE
      INTEGER             IND(6), NBHIST
      REAL*8          FTRC((3*NBHIST),3), TRC((3*NBHIST),5), X(5), DZ(4)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 08/09/1999   AUTEUR CIBHHLV L.VIVAN 
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
C
C         CALCUL DES COORDONNEES BARYCENTRIQUES ET DE DZT             
C-----------------------------------------------------------------------
      INTEGER  IFAIL, I, NZ
      REAL*8   SOM, ALEMB(6), A(6,6), B(6)
      REAL*8   EPSMAC, R8PREM, WORK(96), ZERO, S(6), U(6,6), V(6,6)
C     ------------------------------------------------------
C
C     CALCUL DES COORDONNEES BARYCENTRIQUES
C
      ZERO = 0.D0
      CALL SMCOSL ( TRC, IND, A, B, X, NBHIST )
C
      EPSMAC = R8PREM()
C
      CALL RSLSVD( 6, 6, 6, A(1,1), S(1), U(1,1), V(1,1),
     &            1 ,B(1), EPSMAC, IFAIL, WORK(1) )
C
      IF ( IFAIL .NE. 0 ) THEN
         CALL UTMESS('F','SMCABA_01','PROBLEME DANS LA RESOLUTION DU'
     &              // ' SYSTEME SOUS CONTRAINT VSRSRR')
      ENDIF
      DO 10 I = 1 , 6
         ALEMB(I) = B(I)
 10   CONTINUE
      SOM = ZERO
      DO 20 I = 1 , 6
         IF ( ALEMB(I) .LT. ZERO )  ALEMB(I)=ZERO
         SOM = SOM + ALEMB(I)
 20   CONTINUE
      IF ( SOM .EQ. ZERO ) THEN
         DO 30 NZ = 1 , 3
            DZ(NZ) = FTRC(IND(1),NZ)
 30      CONTINUE
      ELSE
        DO 50 NZ = 1 , 3
           DZ(NZ) = ZERO
           DO 40 I = 1 , 6
              DZ(NZ) = DZ(NZ) + ALEMB(I)*FTRC(IND(I),NZ)/SOM
 40        CONTINUE
 50      CONTINUE
      ENDIF
C
      END
