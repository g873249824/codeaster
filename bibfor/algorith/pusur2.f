        SUBROUTINE PUSUR2(JDG,NBPT,ANG,FN,VT1,VT2,
     &                     ANGLE,T,PUSE,NOCCUR)
C***********************************************************************
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C       CALCUL DE LA PUISSANCE D USURE (LOI D ARCHARD)
C
C
C
C-----------------------------------------------------------------------

      IMPLICIT REAL *8 (A-H,O-Z)
      REAL*8 ANG(*),FN(*),VT1(*),VT2(*),ANGLE(*),T(*),
     &       PUSE,TMP
C
        ZERO=0.00D00
        TMP=0.00D00
        PUSE=0.00D00
        NOCCUR=0
C
        DO 10 I=1,NBPT-1
         IF ((ANGLE(I).LE.ANG(JDG+1)).AND.((ANGLE(I).GT.ANG(JDG))))
     &    THEN 
          PUSE=PUSE+
     &      (ABS(FN(I+1)*SQRT(VT1(I+1)**2+VT2(I+1)**2))+
     &       ABS(FN(I)*SQRT(VT1(I)**2+VT2(I)**2)))*(T(I+1)-T(I))
          TMP=TMP+T(I+1)-T(I)
          NOCCUR=NOCCUR+1
         ENDIF
 10     CONTINUE
C
        PUSE = PUSE / 2.D0
        IF (TMP.EQ.ZERO) THEN
         PUSE = ZERO
        ELSE
         PUSE=PUSE/TMP
        ENDIF
C
 9999   CONTINUE
        END
