       SUBROUTINE TE0451(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/03/98   AUTEUR CIBHHLV L.VIVAN 
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
C.......................................................................
C
C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS INCOMPRESSIBLES 3D
C
C          OPTION : 'CHAR_MECA_FORC_R '
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8        ALIAS1,ALIAS2
      CHARACTER*16       NOMTE,OPTION
      CHARACTER*24       CHVAL1,CHCTE1,CHCTE2
      REAL*8             DFDX(27),DFDY(27),DFDZ(27),POIDS
      INTEGER            IPOI1,IVF1,IVF2,IGEOM,IFORC
      INTEGER            NDIM,NNO1,NNO2,NPG,IVECTU
      INTEGER            JIN1,JIN2,I,JVAL1,L
      INTEGER            NBPG(2),NBFPG,K,KP
      INTEGER            IDFDE,IDFDN,IDFDK
C
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
C
      IF (NOMTE(6:9).EQ.'HEXA') THEN
        ALIAS1 = 'HEXA20  '
        ALIAS2 = 'HEXA8   '
      ELSE IF ( NOMTE(6:10).EQ.'TETRA') THEN
        ALIAS1 = 'TETRA10 '
        ALIAS2 = 'TETRA4  '
      ELSE IF ( NOMTE(6:10).EQ.'PENTA') THEN
        ALIAS1 = 'PENTA15 '
        ALIAS2 = 'PENTA6  '
      ELSE IF ( NOMTE(6:10).EQ.'PYRAM') THEN
        ALIAS1 = 'PYRAM13 '
        ALIAS2 = 'PYRAM5  '
      ENDIF
C
      CHCTE1 = '&INEL.'//ALIAS1//'.CARACTE'
      CALL JEVETE(CHCTE1,'L',JIN1)
      NDIM   = ZI(JIN1+1-1)
      NNO1   = ZI(JIN1+2-1)
      NBFPG = ZI(JIN1+3-1)
      DO 10 I = 1,NBFPG
         NBPG(I) = ZI(JIN1+3-1+I)
  10  CONTINUE
      NPG = NBPG(1)
      CHVAL1 = '&INEL.'//ALIAS1//'.FFORMES'
      CALL JEVETE(CHVAL1,'L',JVAL1)
      IPOI1   = JVAL1   +(NDIM+1)*NNO1*NNO1
      IVF1    = IPOI1   + NPG
      IDFDE   = IVF1    + NPG*NNO1
      IDFDN   = IDFDE   + 1
      IDFDK   = IDFDN   + 1
C
      CHCTE2 = '&INEL.'//ALIAS2//'.CARACTE'
      CALL JEVETE(CHCTE2,'L',JIN2)
      NNO2   = ZI(JIN2+2-1)
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PFR3D3D','L',IFORC)
C
       DO 20 I = 1,3*NNO1+NNO2
            ZR(IVECTU+I-1)   = 0.0D0
20    CONTINUE
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 KP=1,NPG
        K=(KP-1)*NNO1*3
        CALL DFDM3D ( NNO1,ZR(IPOI1+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     &   ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS )
C
        DO 102 I=1,NNO2
          L = (KP-1)*NNO1+I
          ZR(IVECTU+4*I-4) = ZR(IVECTU+4*I-4)+
     &                             POIDS*ZR(IFORC  )*ZR(IVF1+L-1)
          ZR(IVECTU+4*I-3) = ZR(IVECTU+4*I-3)+
     &                             POIDS*ZR(IFORC+1)*ZR(IVF1+L-1)
          ZR(IVECTU+4*I-2) = ZR(IVECTU+4*I-2)+
     &                             POIDS*ZR(IFORC+2)*ZR(IVF1+L-1)
          ZR(IVECTU+4*I-1) = 0.D0
102     CONTINUE
        DO 103 I=NNO2+1,NNO1
          L = (KP-1)*NNO1+I
          ZR(IVECTU+NNO2+3*I-3) = ZR(IVECTU+NNO2+3*I-3)+
     &                             POIDS*ZR(IFORC  )*ZR(IVF1+L-1)
          ZR(IVECTU+NNO2+3*I-2) = ZR(IVECTU+NNO2+3*I-2)+
     &                             POIDS*ZR(IFORC+1)*ZR(IVF1+L-1)
          ZR(IVECTU+NNO2+3*I-1) = ZR(IVECTU+NNO2+3*I-1)+
     &                             POIDS*ZR(IFORC+2)*ZR(IVF1+L-1)
103     CONTINUE
101   CONTINUE
 9999 CONTINUE
      END
