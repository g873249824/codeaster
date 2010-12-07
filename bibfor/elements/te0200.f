      SUBROUTINE TE0200 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
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
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_ME_FF2D2D  '
C                          ELEMENTS AXISYMETRIQUES FOURIER
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      PARAMETER         ( NBRES=3 )

      CHARACTER*8        NOMPAR(NBRES)
      REAL*8             VALPAR(NBRES)
      REAL*8             DFDX(9),DFDY(9),POIDS,R,Z,TX,TY,TZ
      INTEGER            NNO,KP,NPG1,I,ITEMPS,IFR2D,IVECTU,NNOS,JGANO
      INTEGER            IPOIDS,IVF,IDFDE,IGEOM,NDIM
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PFF2D2D','L',IFR2D)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'INST'
      VALPAR(3) = ZR(ITEMPS)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      DO 101 KP=1,NPG1
        K=(KP-1)*NNO
        CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
        R = 0.D0
        Z = 0.D0
        DO 102 I=1,NNO
          R = R + ZR(IGEOM+2*I-2)*ZR(IVF+K+I-1)
          Z = Z + ZR(IGEOM+2*I-1)*ZR(IVF+K+I-1)
102     CONTINUE
        POIDS = POIDS*R
        VALPAR(1) = R
        VALPAR(2) = Z
        CALL FOINTE('FM',ZK8(IFR2D  ),3,NOMPAR,VALPAR,TX,ICODE)
        CALL FOINTE('FM',ZK8(IFR2D+1),3,NOMPAR,VALPAR,TY,ICODE)
        CALL FOINTE('FM',ZK8(IFR2D+2),3,NOMPAR,VALPAR,TZ,ICODE)
        DO 103 I=1,NNO
           K=(KP-1)*NNO
           ZR(IVECTU+3*I-3) = ZR(IVECTU+3*I-3) +
     &        POIDS * TX * ZR(IVF+K+I-1)
           ZR(IVECTU+3*I-2) = ZR(IVECTU+3*I-2) +
     &        POIDS * TY * ZR(IVF+K+I-1)
           ZR(IVECTU+3*I-1) = ZR(IVECTU+3*I-1) +
     &        POIDS * TZ * ZR(IVF+K+I-1)
103     CONTINUE
101   CONTINUE
      END
