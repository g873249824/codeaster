      SUBROUTINE TE0202(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2005   AUTEUR LAVERNE J.LAVERNE 
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

      IMPLICIT NONE
      CHARACTER*16       NOMTE, OPTION

C-----------------------------------------------------------------------
C
C     BUT : CALCUL DES OPTIONS NON LINEAIRES DES ELEMENTS DE
C          FISSURE JOINT
C
C     OPTION : FORC_NODA
C
C-----------------------------------------------------------------------

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER IGEOM, ICONT, IVECT,NPG
      CHARACTER*8 TYPMOD(2)
      

      IF (NOMTE(3:4) .EQ. 'AX') THEN
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
