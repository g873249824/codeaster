      SUBROUTINE MLFMLT(B,F,Y,LDB,N,P,L,OPTA,OPTB)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 31/01/2005   AUTEUR REZETTE C.REZETTE 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C     B = B - F*Y PAR BLOCS
      IMPLICIT NONE
      INTEGER LDB,N,P,L,NB
      REAL*8 B(LDB,L), F(N,P),Y(LDB,L)
      PARAMETER(NB=96)
      INTEGER M,NPB,RESTP,NLB,RESTL
      INTEGER I,J,K,IB,JB
      REAL*8 BETA,ALPHA
      INTEGER OPTA,OPTB
      CHARACTER*1 TRA,TRB
C     
      TRA='T'
      IF(OPTA.EQ.1)TRA='N'
      TRB='T'
      IF(OPTB.EQ.1)TRB='N'
      ALPHA = -1.D0
      BETA  =  1.D0
      M= N - P
      NPB=P/NB
      NLB=L/NB
      RESTP = P - (NB*NPB)
      RESTL= L - (NB*NLB)
      IF(NLB.GT.0) THEN
C$OMP PARALLEL DO  DEFAULT(SHARED) PRIVATE(J,JB,I,IB) SCHEDULE(STATIC,1)
      DO 500 J=1,NLB
         JB= NB*(J-1)+1
         DO 600 I=1,NPB
            IB= NB*(I-1)+1
            CALL DGEMM(TRA,TRB,NB,NB,M,ALPHA,F(1,IB),N,Y(1,JB),LDB,
     &                 BETA,B(IB,JB),LDB)
 600     CONTINUE
         IF(RESTP.GT.0) THEN
            IB=NB*NPB+1
           CALL DGEMM(TRA,TRB,RESTP,NB,M,ALPHA,F(1,IB),N,Y(1,JB),LDB,
     &                BETA,B(IB,JB),LDB)
        ENDIF
 500     CONTINUE
C$OMP END PARALLEL DO
      END IF
         IF(RESTL.GT.0) THEN
            JB=NB*NLB+1
            DO 601 I=1,NPB
               IB= NB*(I-1)+1
          CALL DGEMM(TRA,TRB,NB,RESTL,M,ALPHA,F(1,IB),N,Y(1,JB),LDB,
     &               BETA,B(IB,JB),LDB)
 601        CONTINUE
            IF(RESTP.GT.0) THEN
               IB=NB*NPB+1
        CALL DGEMM(TRA,TRB,RESTP,RESTL,M,ALPHA,F(1,IB),N,Y(1,JB),LDB,
     &             BETA,B(IB,JB),LDB)
            ENDIF
         ENDIF
      END
