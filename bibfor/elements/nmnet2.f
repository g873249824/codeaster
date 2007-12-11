      SUBROUTINE NMNET2(NMNBN,CNBN,CPLAS,CDPLAS
     &                 ,CDDPLA,CZEF,CZEG,CIEF,CPROX,CDEPS
     &                 ,CNCRIT,CDTG,CIER,CDEPSP,DC1,DC2,DEPSP2)

        IMPLICIT  NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 25/09/2006   AUTEUR MARKOVIC D.MARKOVIC 
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
        REAL*8  NMNBN(6)         
        REAL*8  NMPLAS(2,3)   
        REAL*8  NMDPLA(2,2)  
        REAL*8  NMDDPL(2,2)
        REAL*8  NMZEF        
        REAL*8  NMZEG         
        INTEGER NMIEF  
        INTEGER NMPROX(2)  
        
C---------------------------------------------
        REAL*8  CNBN(6)         
        REAL*8  CPLAS(2,3)   
        REAL*8  CDPLAS(2,2)  
        REAL*8  CDDPLA(2,2)
        REAL*8  CZEF        
        REAL*8  CZEG         
        INTEGER CIEF  
        INTEGER CPROX(2)  

C---------------------------------------------
       REAL*8  CDEPS(6)   
       INTEGER CNCRIT     
       REAL*8  CDTG(6,6)  
       INTEGER CIER  
       REAL*8  CDEPSP(6)  

C-------------------------------------------
       REAL*8         DC1(6,6),DC2(6,6)
       REAL*8         DEPSP2(6,2),CP(6),GPLASS
       INTEGER     J

       CALL MATMUL(CDTG,CDEPS,6,6,1,CNBN)
       CALL MATMUL(DC1,DEPSP2,6,6,1,CP)
       DO 10, J = 1,6
         CNBN(J) = NMNBN(J) + CNBN(J) - CP(J)
 10    CONTINUE
       CALL MATMUL(DC2,DEPSP2(1,2),6,6,1,CP)
       DO 20, J = 1,6
         CNBN(J) = CNBN(J) - CP(J)
 20    CONTINUE

       CALL MPPFFN(CNBN,CPLAS,CDPLAS,CDDPLA,CZEF,CZEG,CIEF,CPROX)
       IF(CIEF .GT. 0) THEN
         CIER=2
         GOTO 30
       ENDIF

      IF ( (GPLASS(CNBN,CPLAS,1)  .GT.  CZEG) 
     & .OR.(GPLASS(CNBN,CPLAS,2)  .GT.  CZEG)) THEN
          CIER=1
      ELSE
          CIER=0
      ENDIF

 30   CONTINUE
      END 
