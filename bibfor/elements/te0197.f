      SUBROUTINE TE0197 ( OPTION , NOMTE )
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
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_ME_ROTAR   '
C                          CAS AXISYMETRIQUE FOURIER
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*24       CARAC,FF
      CHARACTER*8        ELREFE
      CHARACTER*2        CODRET
      REAL*8             DFDX(9),DFDY(9),POIDS,R
      INTEGER            NNO,KP,NPG1,I,IVECTU,IROTA
      INTEGER            ICARAC,IFF,IPOIDS,IVF,IDFDE,IDFDK,IGEOM,IMATE
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
      CALL ELREF1(ELREFE)

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
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PROTATR','L',IROTA)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      CALL RCVALA (ZI(IMATE),'ELAS',0,' ',R8B,1,'RHO',RHO,CODRET,'FM')
C
      DO 101 KP=1,NPG1
        K=(KP-1)*NNO
        CALL DFDM2D ( NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDK+K),
     &                ZR(IGEOM),DFDX,DFDY,POIDS )
        R = 0.D0
        DO 102 I=1,NNO
          R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
102     CONTINUE
        POIDS = POIDS*RHO*R
        R = R - ZR(IROTA+4)
        DO 103 I=1,NNO
           K=(KP-1)*NNO
           ZR(IVECTU+3*I-3) = ZR(IVECTU+3*I-3) +
     &        POIDS * (ZR(IROTA)*ZR(IROTA+3))**2 * R * ZR(IVF+K+I-1)
103     CONTINUE
101   CONTINUE
      END
