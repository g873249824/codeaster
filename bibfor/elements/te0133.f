      SUBROUTINE TE0133 ( OPTION , NOMTE )
      IMPLICIT NONE
      CHARACTER*16       OPTION , NOMTE
      CHARACTER*8        ELREFE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
C    - FONCTION REALISEE:  OPTION : 'HYDR_ELNO_ELGA'
C                          ELEMENTS 2D ISO PARAMETRIQUES
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER   ICARAC, NNO, NNOS, NPG2, NCMP, IHYDRP, IHYDRN
C DEB ------------------------------------------------------------------
C
      CALL ELREF1(ELREFE)
C
      CALL JEVETE ( '&INEL.'//ELREFE//'.CARAC', 'L', ICARAC )
      NNO  = ZI(ICARAC)
C      NPG1 = ZI(ICARAC+2)
      NPG2 = ZI(ICARAC+3)
      NCMP = 1
C
      NNOS = NNO
      IF ( NOMTE(5:7) .EQ. 'TR6' ) THEN
         NNOS = 3
      ELSEIF ( NOMTE(5:7) .EQ. 'QU8' .OR.
     &         NOMTE(5:7) .EQ. 'QU9' ) THEN
         NNOS = 4
      ENDIF
C
      CALL JEVECH ( 'PHYDRPP' , 'L', IHYDRP )
      CALL JEVECH ( 'PHYDRNOR', 'E', IHYDRN )
C
      CALL PPGANO ( NNOS , NPG2 , NCMP , ZR(IHYDRP) ,  ZR(IHYDRN) )
C FIN ------------------------------------------------------------------
      END
