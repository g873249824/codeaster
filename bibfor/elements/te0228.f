      SUBROUTINE TE0228 ( OPTION , NOMTE )
      IMPLICIT   NONE
      CHARACTER*16        OPTION , NOMTE
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
C .  - FONCTION REALISEE:  CALCUL  DEFORMATIONS GENERALISEES AUX NOEUDS
C .                        COQUE 1D
C .
C .                        OPTIONS : 'DEGE_ELNO_DEPL  '
C .                        ELEMENT: MECXSE3,METCSE3,METDSE3
C .
C .  - ARGUMENTS:
C .      DONNEES:      OPTION       -->  OPTION DE CALCUL
C .                    NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS NORMALISEES JEVEUX -----------------------
C
      INTEGER       I,K,KP,IGEOM,IDEPL,IDEFOR,NCMP,NNO,NPG1
      INTEGER       ICARAC,IFF,IVF,IDFDK
      CHARACTER*24  CARAC,FF
      CHARACTER*8   ELREFE
      REAL*8        DFDX(3),DEGEPG(24)
      REAL*8        COSA,SINA,COUR,R,ZERO,JAC
      REAL*8        EPS(5),E11,E22,K11,K22
C
C
      CALL ELREF1(ELREFE)
      ZERO = 0.0D0
C

      CARAC = '&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO  = ZI(ICARAC)
      NPG1 = ZI(ICARAC+2)
C
      FF = '&INEL.'//ELREFE//'.FF'
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PDEFOGR','E',IDEFOR)
      CALL JEVETE(FF,'L',IFF)
C
      IVF = IFF + NPG1
      IDFDK = IVF + NPG1*NNO
      DO 200 KP = 1,NPG1
        K = (KP-1)*NNO
        CALL DFDM1D(NNO,ZR(IFF+KP-1),ZR(IDFDK+K),ZR(IGEOM),DFDX,COUR,
     +              JAC,COSA,SINA)
        DO 210 I = 1,5
          EPS(I) = ZERO
  210   CONTINUE
        R = ZERO
        DO 220 I = 1,NNO
          EPS(1) = EPS(1) + DFDX(I)*ZR(IDEPL+3*I-3)
          EPS(2) = EPS(2) + DFDX(I)*ZR(IDEPL+3*I-2)
          EPS(3) = EPS(3) + DFDX(I)*ZR(IDEPL+3*I-1)
          EPS(4) = EPS(4) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-3)
          EPS(5) = EPS(5) + ZR(IVF+K+I-1)*ZR(IDEPL+3*I-1)
          R = R + ZR(IVF+K+I-1)*ZR(IGEOM+2* (I-1))
  220   CONTINUE
        E11 = EPS(2)*COSA - EPS(1)*SINA
        K11 = EPS(3)
        IF (NOMTE(3:4).EQ.'CX') THEN
          E22 = EPS(4)/R
          K22 = -EPS(5)*SINA/R
        ELSE
          E22 = ZERO
          K22 = ZERO
        END IF
C
        DEGEPG(6* (KP-1)+1) = E11
        DEGEPG(6* (KP-1)+2) = E22
        DEGEPG(6* (KP-1)+3) = ZERO
        DEGEPG(6* (KP-1)+4) = K11
        DEGEPG(6* (KP-1)+5) = K22
        DEGEPG(6* (KP-1)+6) = ZERO
  200 CONTINUE
C
C   RECUPERATION DE LA MATRICE DE PASSAGE GAUSS -----> SOMMETS
C
      NCMP = 6
      CALL PPGANO (NNO,NPG1,NCMP,DEGEPG,ZR(IDEFOR))
C
      END
