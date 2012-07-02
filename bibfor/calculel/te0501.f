      SUBROUTINE TE0501 ( OPTION , NOMTE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C ======================================================================
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16        OPTION , NOMTE
C ----------------------------------------------------------------------
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'RIGI_THER_TRANS'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C
      REAL*8         DFDX(9),DFDY(9),POIDS,R,TPG,XKPT,ALPHA
      INTEGER        KP,I,J,K,ITEMPS,IFON(3),IMATTT,IGEOM,IMATE
      INTEGER        NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO
      LOGICAL        LTEATT
C DEB ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER IJ ,ITEMP ,ITEMPI 
C-----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH('PGEOMER','L',IGEOM )
      CALL JEVECH('PMATERC','L',IMATE )
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPER','L',ITEMP )
      CALL JEVECH('PTEMPEI','L',ITEMPI)
      CALL JEVECH('PMATTTR','E',IMATTT)
C
      CALL NTFCMA (ZI(IMATE),IFON)
      DO 101 KP=1,NPG
        K=(KP-1)*NNO
        CALL DFDM2D ( NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS )
        R = 0.D0
        TPG = 0.D0
        DO 102 I = 1, NNO
          R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
          TPG =TPG + ZR(ITEMPI+I-1)*ZR(IVF+K+I-1)
102     CONTINUE
        IF ( LTEATT(' ','AXIS','OUI') ) POIDS = POIDS*R
C
        CALL RCFODE(IFON(2), TPG, ALPHA, XKPT)
C
        IJ = IMATTT - 1
         DO 103 I=1,NNO
C
           DO 103 J=1,I
             IJ = IJ + 1
             ZR(IJ) = ZR(IJ) +
     &                POIDS*( ALPHA*(DFDX(I)*DFDX(J)+DFDY(I)*DFDY(J)) )
C
103      CONTINUE
101   CONTINUE
C
C FIN ------------------------------------------------------------------
      END
