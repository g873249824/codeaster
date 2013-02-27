      SUBROUTINE MOYTE2 ( FAMI, NPG, POUM, TEMP, IRET)
      IMPLICIT   NONE
      INTEGER             NPG,IRET,IRETM
      REAL*8              TEMP
      CHARACTER*(*)       FAMI, POUM
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/02/2013   AUTEUR DESROCHE X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER  KPG
      REAL*8   TG, TGTOT, TM, TI, TS
C
      TGTOT = 0.D0
      DO 10 KPG = 1 , NPG
        CALL RCVARC(' ','TEMP',POUM,FAMI,KPG,1,TM,IRETM)
        CALL RCVARC(' ','TEMP_INF',POUM,FAMI,KPG,1,TI,IRET)
        CALL RCVARC(' ','TEMP_SUP',POUM,FAMI,KPG,1,TS,IRET)
        IF ( IRET .EQ. 1 ) THEN
           TEMP = TM
           GOTO 9999
        ELSE IF ( IRETM .NE. 0 ) THEN
           TM=(TI+TS)/2.D0
        ENDIF
        TG=(4.D0*TM+TI+TS)/6.0D0
        TGTOT = TGTOT + TG
  10  CONTINUE
      TEMP = TGTOT/NPG
9999  CONTINUE
      END
