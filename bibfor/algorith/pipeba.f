      SUBROUTINE PIPEBA(MATE, SUP, SUD, VIM, DTAU, COPILO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/03/2005   AUTEUR LAVERNE J.LAVERNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      INTEGER MATE
      REAL*8 SUP(2), SUD(2), VIM(*),DTAU, COPILO(2,3)
C-----------------------------------------------------------------------
C
C     PILOTAGE PRED_ELAS POUR LA LOI DE BARENBLATT (ELEMENT DE JOINT)
C   
C-----------------------------------------------------------------------

      INTEGER I,J,NRAC,OK(4), NSOL
      REAL*8  P0,P1,P2, RAC(2), ETA(4), A0(4), A1(4), TMP
      REAL*8  LC,K0,KA,KREF,C,VAL(3),ETASOL(4), ETAMIN,XN
      REAL*8  DDOT, R8GAEM
      CHARACTER*2 COD(3)
      CHARACTER*8 NOM(3)
      
      REAL*8 E(2)
C-----------------------------------------------------------------------
      
      
C INITIALISATION
            
      NOM(1) = 'GC'
      NOM(2) = 'SIGM_C'
      NOM(3) = 'PENA_ADHERENCE'
      CALL RCVALA (MATE,' ','RUPT_FRAG',0,' ',0.D0,3,NOM,VAL,COD,'F ')
      LC   = VAL(1)/VAL(2)
      K0   = VAL(1)/VAL(2)*VAL(3)
      KA   = MAX(VIM(1),K0)
      KREF = MAX(KA,LC)

      C  = DTAU*KREF + KA

      OK(1) = 0
      OK(2) = 0
      OK(3) = 0
      OK(4) = 0

C    RESOLUTION FEL(ETA) = DTAU
C    OU FEL(ETA) = ( SQRT(P0 + 2 P1 ETA + P2 ETA**2) - KA) / KREF


C    PORTION EN COMPRESSION : FEL = (ABS(SU(2)) - KA ) / KREF     
C    ON INCLUT EGALEMENT UN SAFE-GUARD SU_N > -KREF CAR AU-DELA CE SONT
C    DES SOLUTIONS TRES FORTEMENT EN COMPRESSION QUI FONT EXPLOSER LA
C    PENALISATION      

      P2 = SUD(2)*SUD(2)
      P1 = SUD(2)*SUP(2)
      P0 = SUP(2)*SUP(2)
      
C    PAS DE SOLUTION
      IF (P2 .LT. (1.D0/R8GAEM()**0.5D0)) GOTO 1000
 
C    RECHERCHE DES SOLUTIONS
      CALL ZEROP2(2*P1/P2, (P0-C**2)/P2, RAC, NRAC)
      IF (NRAC.LE.1) GOTO 1000
      
      XN = SUP(1)+RAC(2)*SUD(1) 
      IF (XN.LE.0 .AND. XN.GE.-KREF) THEN
        OK(1)  = 1
        ETA(1) = RAC(2)
        A1(1)  = (P1+P2*ETA(1))/(KREF*C)                 
        A0(1)  = DTAU-ETA(1)*A1(1)
      END IF
      
      XN = SUP(1)+RAC(1)*SUD(1) 
      IF (XN .LE. 0 .AND. XN.GE.-KREF) THEN
        OK(2)  = 1
        ETA(2) = RAC(1)
        A1(2)  = (P1+P2*ETA(2))/(KREF*C)                 
        A0(2)  = DTAU-ETA(2)*A1(2)
      END IF
      
 1000 CONTINUE
      
      
C    PORTION EN TRACTION : FEL = (SQR(SU(1)**2 + SU(2)**2) - KA) / KREF

      P2 = DDOT(2,SUD,1,SUD,1)  
      P1 = DDOT(2,SUD,1,SUP,1) 
      P0 = DDOT(2,SUP,1,SUP,1)
           
C    PAS DE SOLUTION
      IF (P2 .LT. (1.D0/R8GAEM()**0.5D0)) GOTO 2000
 
C    RECHERCHE DES SOLUTIONS
      CALL ZEROP2(2*P1/P2, (P0-C**2)/P2, RAC, NRAC)
      IF (NRAC.LE.1) GOTO 2000
      
      IF (SUP(1)+RAC(2)*SUD(1) .GT. 0) THEN
        OK(3)  = 1
        ETA(3) = RAC(2)
        A1(3)  = (P1+P2*ETA(3))/(KREF*C)                 
        A0(3)  = DTAU-ETA(3)*A1(3)
      END IF
      
      IF (SUP(1)+RAC(1)*SUD(1) .GT. 0) THEN
        OK(4)  = 1
        ETA(4) = RAC(1)
        A1(4)  = (P1+P2*ETA(4))/(KREF*C)                 
        A0(4)  = DTAU-ETA(4)*A1(4)
      END IF
      
 2000 CONTINUE


C -- CLASSEMENT DES SOLUTIONS

      NSOL = OK(1)+OK(2)+OK(3)+OK(4)
      IF (NSOL.GT.2) CALL UTMESS('F','PIPEBA 2','ERREUR DVP')
      
      J = 0
      DO 20 I = 1,4
        IF (OK(I).EQ.1) THEN
          J = J+1
          ETASOL(J)   = ETA(I)
          COPILO(1,J) = A0(I)
          COPILO(2,J) = A1(I)
        END IF
 20   CONTINUE 

C    ON RANGE LES SOLUTIONS DANS L'ORDRE CROISSANT (SI NECESSAIRE)
      IF (NSOL.EQ.2) THEN
        IF (ETASOL(2) .LT. ETASOL(1)) THEN
          TMP = ETASOL(2)
          ETASOL(2) = ETASOL(1)
          ETASOL(1) = TMP
 
          TMP = COPILO(1,1)
          COPILO(1,1) = COPILO(1,2)
          COPILO(1,2) = TMP
 
          TMP = COPILO(2,1)
          COPILO(2,1) = COPILO(2,2)
          COPILO(2,2) = TMP
        END IF
      END IF



C    TRAITEMENT EN L'ABSENCE DE SOLUTION  -> MINIMISATION
      IF (NSOL .EQ. 0) THEN
        IF (P2 .LT. (1.D0/R8GAEM()**0.5D0)) THEN
          ETAMIN = 0
        ELSE
          ETAMIN = - P1/P2
        END IF
        
        COPILO(1,1) = (SQRT(P0+2*P1*ETAMIN+P2*ETAMIN**2) - KA)/KREF
        COPILO(1,3) = ETAMIN
      END IF
             
      END
