      SUBROUTINE CFNOTR(COORDA,COORDB,COORDC,MNORM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      REAL*8       MNORM(3)    
      REAL*8       COORDA(3),COORDB(3),COORDC(3)      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - MAIT/ESCL -
C                  NORMALES)
C
C CALCUL DES NORMALES POUR LES TRIANGLES
C
C ----------------------------------------------------------------------
C
C
C IN  COORDA : COORDONNEES DU SOMMET A 
C IN  COORDB : COORDONNEES DU SOMMET B
C IN  COORDC : COORDONNEES DU SOMMET C
C OUT MNORM  : NORMALE A LA MAILLE
C
C ----------------------------------------------------------------------
C
      INTEGER K
      REAL*8 AB(3),AC(3),ABSAC,ABAC(3)
C
C ----------------------------------------------------------------------
C
      DO 10 K = 1,3
        AB(K) = COORDB(K) - COORDA(K)
        AC(K) = COORDC(K) - COORDA(K)
 10   CONTINUE
      CALL PROVEC(AB,AC,ABAC)
      CALL DCOPY (3,ABAC,1,MNORM,1)      
      ABSAC = ABAC(1)**2 + ABAC(2)**2 + ABAC(3)**2
      IF (ABSAC.EQ.0) THEN
        CALL U2MESS('F','CONTACT_15')
      END IF        
      MNORM(1) = - MNORM(1) / SQRT(ABSAC)
      MNORM(2) = - MNORM(2) / SQRT(ABSAC)
      MNORM(3) = - MNORM(3) / SQRT(ABSAC)  
C
      END
