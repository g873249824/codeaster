      SUBROUTINE MATTGE(NOMTE,DTILD,SINA,COSA,R,JACP,VF,DFDS,RTANGI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*16 NOMTE
      REAL*8 SINA,COSA,R,JACP,VF(*),DFDS(*)
      REAL*8 MATS(5,9),MATS1(3,9),DTILD(5,5),DTILD1(3,3),RTANGI(9,9)
      REAL*8 DTILDS(5,9),DTILDT(3,9)
C
C
C     CALCULS DE LA MATRICE TANGENTE
C
      IF ( NOMTE(3:4) .EQ. 'CX' ) THEN
C
      MATS(1,1)=-SINA*DFDS(1)
      MATS(1,2)= COSA*DFDS(1)
      MATS(1,3)= 0.D0
      MATS(1,4)=-SINA*DFDS(2)
      MATS(1,5)= COSA*DFDS(2)
      MATS(1,6)= 0.D0
      MATS(1,7)=-SINA*DFDS(3)
      MATS(1,8)= COSA*DFDS(3)
      MATS(1,9)= 0.D0
C
      MATS(2,1)= 0.D0
      MATS(2,2)= 0.D0
      MATS(2,3)= DFDS(1)
      MATS(2,4)= 0.D0
      MATS(2,5)= 0.D0
      MATS(2,6)= DFDS(2)
      MATS(2,7)= 0.D0
      MATS(2,8)= 0.D0
      MATS(2,9)= DFDS(3)
C
      MATS(3,1)= VF(1)/R
      MATS(3,2)= 0.D0
      MATS(3,3)= 0.D0
      MATS(3,4)= VF(2)/R
      MATS(3,5)= 0.D0
      MATS(3,6)= 0.D0
      MATS(3,7)= VF(3)/R
      MATS(3,8)= 0.D0
      MATS(3,9)= 0.D0
C
      MATS(4,1)= 0.D0
      MATS(4,2)= 0.D0
      MATS(4,3)=-SINA*VF(1)/R
      MATS(4,4)= 0.D0
      MATS(4,5)= 0.D0
      MATS(4,6)=-SINA*VF(2)/R
      MATS(4,7)= 0.D0
      MATS(4,8)= 0.D0
      MATS(4,9)=-SINA*VF(3)/R
C
      MATS(5,1)= COSA*DFDS(1)
      MATS(5,2)= SINA*DFDS(1)
      MATS(5,3)= VF(1)
      MATS(5,4)= COSA*DFDS(2)
      MATS(5,5)= SINA*DFDS(2)
      MATS(5,6)= VF(2)
      MATS(5,7)= COSA*DFDS(3)
      MATS(5,8)= SINA*DFDS(3)
      MATS(5,9)= VF(3)
C
      CALL R8SCAL(25,JACP,DTILD,1)
C
      CALL  BTKB(5,9,9,DTILD,MATS,DTILDS,RTANGI)
C
      ELSE
C
      DO 20 I=1,3
      DO 30 J=1,3
         DTILD1(I,J)=DTILD(I,J)
 30   CONTINUE
 20   CONTINUE
C
      MATS1(1,1)=-SINA*DFDS(1)
      MATS1(1,2)= COSA*DFDS(1)
      MATS1(1,3)= 0.D0
      MATS1(1,4)=-SINA*DFDS(2)
      MATS1(1,5)= COSA*DFDS(2)
      MATS1(1,6)= 0.D0
      MATS1(1,7)=-SINA*DFDS(3)
      MATS1(1,8)= COSA*DFDS(3)
      MATS1(1,9)= 0.D0
C
      MATS1(2,1)= 0.D0
      MATS1(2,2)= 0.D0
      MATS1(2,3)= DFDS(1)
      MATS1(2,4)= 0.D0
      MATS1(2,5)= 0.D0
      MATS1(2,6)= DFDS(2)
      MATS1(2,7)= 0.D0
      MATS1(2,8)= 0.D0
      MATS1(2,9)= DFDS(3)
C
      MATS1(3,1)= COSA*DFDS(1)
      MATS1(3,2)= SINA*DFDS(1)
      MATS1(3,3)= VF(1)
      MATS1(3,4)= COSA*DFDS(2)
      MATS1(3,5)= SINA*DFDS(2)
      MATS1(3,6)= VF(2)
      MATS1(3,7)= COSA*DFDS(3)
      MATS1(3,8)= SINA*DFDS(3)
      MATS1(3,9)= VF(3)
C
      CALL R8SCAL(9,JACP,DTILD1,1)
C
      CALL  BTKB(3,9,9,DTILD1,MATS1,DTILDT,RTANGI)
C
      ENDIF
C
      END
