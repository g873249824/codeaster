      SUBROUTINE IMPREL (MOTFAC,NBTERM,COEF,LISDDL,LISNO,BETA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/08/98   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
      IMPLICIT NONE
      CHARACTER*16 MOTFAC
      INTEGER INFO,IBID,NBTERM,IFM,IUNIFI,I
      CHARACTER*8 LISDDL(NBTERM),LISNO(NBTERM)
      REAL*8 COEF(NBTERM),BETA
C
      CALL GETVIS(' ','INFO',1,1,1,INFO,IBID)
      IF(INFO.NE.2) THEN
         GOTO 9999
      ENDIF
C
      IFM = IUNIFI('MESSAGE')
C
10    FORMAT(2X,'    COEF    ','*','   DDL  ','(',' NOEUD  ',')')
20    FORMAT(2X,1PE12.5,' * ',A8,'(',A8,')','+')
30    FORMAT(2X,'=',1PE12.5)
40    FORMAT(2X,'______________________________________')
C
      WRITE(IFM,*) 'RELATION LINEAIRE AFFECTEE PAR '//MOTFAC
      WRITE(IFM,10)
      DO 100 I=1,NBTERM
         WRITE(IFM,20) COEF(I),LISDDL(I),LISNO(I)
100   CONTINUE
      WRITE(IFM,30) BETA
      WRITE(IFM,40)
9999  CONTINUE
      END
