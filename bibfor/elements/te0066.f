      SUBROUTINE TE0066(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/09/2003   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C.......................................................................

C     BUT: CALCUL DE L'ENERGIE THERMIQUE A L'EQUILIOBRE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'EPOT_ELEM_TEMP'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

C ----- DEBUT --- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CHARACTER*8 NOMPAR
      CHARACTER*2 CODRET
      REAL*8 VALPAR,LAMBDA,POIDS,EPOT
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),FLUX,FLUY,FLUZ
      INTEGER I,IPOIDS,IVF,IDFDE,IDFDN,IDFDK,IGEOM,IMATE
      INTEGER JVAL,K,NDIM
      INTEGER JGANO,NNO,KP,NPG1,IENER,ITEMP,ITEMPE

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      IDFDN = IDFDE + 1
      IDFDK = IDFDN + 1
      DO 10 I = 1,1
   10 CONTINUE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PENERDR','E',IENER)

      CALL TECACH('ONN','PTEMPSR',1,ITEMP,IRET)
      IF (ITEMP.EQ.0) THEN
        NBPAR = 0
        NOMPAR = ' '
        VALPAR = 0.D0
      ELSE
        NBPAR = 1
        NOMPAR = 'INST'
        VALPAR = ZR(ITEMP)
      END IF

      CALL RCVALA(ZI(IMATE),'THER',NBPAR,NOMPAR,VALPAR,1,'LAMBDA',
     &            LAMBDA,CODRET,'FM')

      EPOT = 0.D0
      DO 30 KP = 1,NPG1
        K = (KP-1)*NNO*3
        CALL DFDM3D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IDFDN+K),
     &              ZR(IDFDK+K),ZR(IGEOM),DFDX,DFDY,DFDZ,POIDS)
        FLUX = 0.D0
        FLUY = 0.D0
        FLUZ = 0.D0
        DO 20 I = 1,NNO
          FLUX = FLUX + ZR(ITEMPE-1+I)*DFDX(I)
          FLUY = FLUY + ZR(ITEMPE-1+I)*DFDY(I)
          FLUZ = FLUZ + ZR(ITEMPE-1+I)*DFDZ(I)
   20   CONTINUE

        EPOT = EPOT - (FLUX**2+FLUY**2+FLUZ**2)*POIDS

   30 CONTINUE
      ZR(IENER) = EPOT*LAMBDA/2.D0
      END
