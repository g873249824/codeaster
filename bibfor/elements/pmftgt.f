      SUBROUTINE PMFTGT(NF,E,SIM,SIP,DEP,MOD)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/03/2002   AUTEUR MJBHHPE J.L.FLEJOU 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C                                                                       
C                                                                       
C ======================================================================
C -----------------------------------------------------------
C ---  INTEGRATIONS SUR LA SECTION 
C IN
C          NF     : NOMBRE DE FIBRES
C          E      : MODULE D'YOUNG
C          SIM(*) : CONTRAINTE DANS LES FIBRES "-"
C          SIP(*) : CONTRAINTE DANS LES FIBRES "+"
C          DEP(*) : INCREMENT DE DEFORMATION DANS LES FIBRES
C
C OUT
C          MOD(*) : MODULE TANGENT DES FIBRES
C -----------------------------------------------------------
      INTEGER NF,I
      REAL*8 SIM(NF),SIP(NF),DEP(NF),MOD(NF),E

      DO 20 I = 1 , NF
        IF ( ABS( DEP(I) ) .GT. 1.0D-10 ) THEN
           MOD(I) = ABS( (SIP(I) - SIM(I)) / DEP(I) )
        ELSE
           MOD(I) = E
        ENDIF
20    CONTINUE

      END
