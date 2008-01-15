      SUBROUTINE LCPITG (COMPOR,DF,LINE,DP,DVBE,DTAUDF)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/01/2008   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

C ----------------------------------------------------------------------
C        INTEGRATION DE LA LOI SIMO MIEHE ECROUISSAGE ISOTROPE  
C  DERIVEE DE TAU PAR RAPPORT A DF * DFT = TAUDF(IJ,K,P)*DF(L,P)
C  TAU = TAU(DVTAU - TRTAU)                                     
C  TRTAU = TRTAU(DF)                                            
C  DVTAU=DVTAU(DVBE)                                            
C  DVBE = DVBE(BETR)                                            
C  BETR =  ETR(DFB)                                             
C  DFB=DVB(DF)                                                  
C ----------------------------------------------------------------------
C IN  COMPOR : COMPORTEMENT
C IN  DF     : INCREMENT DU TENSEUR DE DEFORMATION
C IN  LINE : REGIME DE LA SOLUTION (ELASTIQUE, PLASTIQUE)
C IN  DP     : INCREMENT DE DEFORMATION PLASTIQUE
C IN  DVBE   : PARTIE DEVIATORIQUE DE LA DEFORMATION
C OUT DTAUDF : DERIVEE DE TAU PAR RAPPORT A DF * DFT
C ----------------------------------------------------------------------
      CHARACTER*16  COMPOR
      INTEGER LINE
      REAL*8  DF(3,3),DP,DVBE(6),DTAUDF(6,3,3)

C COMMON GRANDES DEFORMATIONS SIMO - MIEHE      
      
      INTEGER IND(3,3),IND1(6),IND2(6)
      REAL*8  KR(6),RAC2,RC(6),ID(6,6)
      REAL*8 BEM(6),BETR(6),DVBETR(6),EQBETR,TRBETR
      REAL*8 JP,DJ,JM,DFB(3,3)  
      REAL*8 DJDF(3,3),DBTRDF(6,3,3)
             
      COMMON /GDSMC/
     &            BEM,BETR,DVBETR,EQBETR,TRBETR,
     &            JP,DJ,JM,DFB,
     &            DJDF,DBTRDF,
     &            KR,ID,RAC2,RC,IND,IND1,IND2
C ----------------------------------------------------------------------
C  COMMON MATERIAU POUR VON MISES

      INTEGER JPROL,JVALE,NBVAL
      REAL*8  PM,YOUNG,NU,MU,UNK,TROISK,COTHER
      REAL*8  SIGM0,EPSI0,DT,COEFM,RPM,PENTE,APUI,NPUI,SIGY

      COMMON /LCPIM/
     &          PM,YOUNG,NU,MU,UNK,TROISK,COTHER,
     &          SIGM0,EPSI0,DT,COEFM,RPM,PENTE,
     &          APUI,NPUI,SIGY,JPROL,JVALE,NBVAL
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
      INTEGER IJ,KL,PQ,I,J,K,L
      REAL*8  A1,A2,A3,A4,RB,ARG,EQBE
      REAL*8  DTAUDJ,DTAUDB
      REAL*8  DVBBTR(6,6),DVBEDF(6,3,3)
      REAL*8  DDOT
C ----------------------------------------------------------------------

C 1 - DEFINITION DES COEFFICIENTS UTILES


      IF (LINE.EQ.0) THEN
        A2 = 1
        A3 = 0
        A4 = 0
      ELSE
        EQBE=SQRT(1.5D0*DDOT(6,DVBE,1,DVBE,1))
        A2=1/(1+TRBETR*DP/EQBE)  
               
        RB=PENTE
        IF (COMPOR(1:4).EQ.'VISC' .AND. DP.NE.0.D0) THEN  
          ARG = (DP/(DT*EPSI0))**(1.D0/COEFM)
          RB  = RB + SIGM0*ARG/(SQRT(ARG**2+1.D0)*COEFM*DP)
        ENDIF
                 
        A3=(A2*DP/EQBE)-MU/(RB+MU*TRBETR)
        A3=3.D0*TRBETR*A3/(2.D0*EQBE*EQBE)
      
        A4=DP/EQBE*((MU*TRBETR/(RB+MU*TRBETR))-1.D0)
      END IF
      
      
C 2 - DERIVEE DE DVBE PAR RAPPORT A BETR = DVBBTR
 
      DO 110 IJ=1,6
        DO 120 KL=1,6           
          DVBBTR(IJ,KL)= A2*(ID(IJ,KL)-KR(IJ)*KR(KL)/3.D0)
     &                + A3*DVBE(IJ)*DVBE(KL)
     &                + A4*DVBE(IJ)*KR(KL)   
 120    CONTINUE
 110  CONTINUE      
      

C 3 - DERIVEE DE DVBE PAR RAPPORT A DF = DVBEDF

      DO 130 IJ=1,6
        DO 140 K=1,3
          DO 150 L=1,3
            DVBEDF(IJ,K,L) = DDOT(6,DVBBTR(IJ,1),6,DBTRDF(1,K,L),1)
 150      CONTINUE
 140    CONTINUE
 130  CONTINUE      


C 4 - MATRICE TANGENTE = DTAUDF

C    DERIVEE PARTIELLE DE TAU PAR RAPPORT A B ET J
      DTAUDB = MU
      DTAUDJ = 0.5D0*(2.D0*UNK*JP-COTHER*(1.D0-1.D0/(JP**2.D0)))
               
      DO 170 IJ=1,6
        DO 180 K=1,3
          DO 190 L=1,3
            DTAUDF(IJ,K,L) = DTAUDB*DVBEDF(IJ,K,L)
     &                   + DTAUDJ*KR(IJ)*DJDF(K,L)
 190      CONTINUE
 180    CONTINUE
 170  CONTINUE

      END
