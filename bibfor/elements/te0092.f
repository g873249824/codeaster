      SUBROUTINE TE0092 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/04/2002   AUTEUR CIBHHLV L.VIVAN 
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
C    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
C                          OPTION : 'RIGI_MECA_GEOM  '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*8        ELREFE
      CHARACTER*24       CARAC,FF
      REAL*8             DFDX(9),DFDY(9),POIDS,R,VFI,VFJ,ZERO,UN,AXIS
      REAL*8             SXX,SXY,SYY,SZZ
      INTEGER            NNO,KP,K,NPG1,II,JJ,I,J,IMATUU,KD1,KD2,IJ1,IJ2
      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM
C
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      ZERO=0.D0
      UN  =1.D0
C
      CALL ELREF1(ELREFE)
C
      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
C
      FF   ='&INEL.'//ELREFE//'.FF'
      CALL JEVETE(FF,'L',IFF)
      IPOIDS=IFF
      IVF   =IPOIDS+NPG1
      IDFDE =IVF   +NPG1*NNO
      IDFDK =IDFDE +NPG1*NNO
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTRR','L',ICONTR)
      CALL JEVECH('PMATUUR','E',IMATUU)
C
      AXIS=ZERO
      R   =UN
      IF ( NOMTE(3:4) .EQ. 'AX' ) AXIS=UN
C
      DO 101 KP=1,NPG1
        K=(KP-1)*NNO
        KC=ICONTR+4*(KP-1)
        SXX=ZR(KC  )
        SYY=ZR(KC+1)
        SZZ=ZR(KC+2)
        SXY=ZR(KC+3)
        CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDX,DFDY,POIDS )
        IF (AXIS .GT. 0.5D0) THEN
           R   = ZERO
           DO 102 I=1,NNO
             R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
102        CONTINUE
           POIDS=POIDS*R
        END IF
C
        KD1=2
        KD2=1
        DO 106 I=1,2*NNO,2
          KD1=KD1+2*I-3
          KD2=KD2+2*I-1
           II = (I+1)/2
           DO 107 J=1,I,2
             JJ = (J+1)/2
             IJ1=IMATUU+KD1+J-2
             IJ2=IMATUU+KD2+J-1
             VFI=ZR(IVF+K+II-1)
             VFJ=ZR(IVF+K+JJ-1)
             ZR(IJ2) = ZR(IJ2) +POIDS*(
     &                            DFDX(II)*(DFDX(JJ)*SXX+DFDY(JJ)*SXY)+
     &                            DFDY(II)*(DFDX(JJ)*SXY+DFDY(JJ)*SYY))
             ZR(IJ1) = ZR(IJ2)+AXIS*(SZZ*VFI*VFJ/(R**2))
107        CONTINUE
106      CONTINUE
C
101   CONTINUE
      END
