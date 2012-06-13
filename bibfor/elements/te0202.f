      SUBROUTINE TE0202(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16       NOMTE, OPTION

C-----------------------------------------------------------------------
C
C     BUT : CALCUL DES OPTIONS NON LINEAIRES DES ELEMENTS DE
C          FISSURE JOINT
C
C     OPTION : FORC_NODA
C
C-----------------------------------------------------------------------


      INTEGER IGEOM, ICONT, IVECT,NPG
      CHARACTER*8 TYPMOD(2)
      LOGICAL LTEATT
      

      IF (LTEATT(' ','AXIS','OUI')) THEN
        TYPMOD(1) = 'AXIS'
      ELSE
        TYPMOD(1) = 'PLAN'
      END IF
      TYPMOD(2) = 'ELEMJOIN'
      
      NPG=2

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTMR','L',ICONT)
      CALL JEVECH('PVECTUR','E',IVECT)
      
      CALL NMFIFI(NPG,TYPMOD,ZR(IGEOM),ZR(ICONT),ZR(IVECT))
           
      END
