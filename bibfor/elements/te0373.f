      SUBROUTINE TE0373(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C.......................................................................
      IMPLICIT REAL*8 (A-H,O-Z)

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 2D

C          OPTION : 'CHAR_MECA_ONDE'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      CHARACTER*2 CODRET
      CHARACTER*16 NOMTE,OPTION
      REAL*8 POIDS,NX,NY,CELER,R8PI,PI
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IONDE
      INTEGER NDI,NNO,KP,NPG,IVECTU,IMATE,LDEC

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

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PONDECR','L',IONDE)
      CALL JEVECH('PVECTUR','E',IVECTU)

      CALL RCVALA(ZI(IMATE),' ','FLUIDE',0,' ',RBID,1,'CELE_R',CELER,
     &            CODRET,'FM')

      DO 10 I = 1,2*NNO
        ZR(IVECTU+I-1) = 0.0D0
   10 CONTINUE

C     BOUCLE SUR LES POINTS DE GAUSS

      DO 40 KP = 1,NPG
        LDEC = (KP-1)*NNO
        NX = 0.0D0
        NY = 0.0D0
        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)

        IF (NOMTE(3:4).EQ.'AX') THEN
          R = 0.D0
          DO 20 I = 1,NNO
            R = R + ZR(IGEOM+2* (I-1))*ZR(IVF+LDEC+I-1)
   20     CONTINUE
          POIDS = POIDS*R
        END IF
        DO 30 I = 1,NNO
          II = 2*I
          ZR(IVECTU+II-1) = ZR(IVECTU+II-1) +
     &                      POIDS*ZR(IONDE+KP-1)*ZR(IVF+LDEC+I-1)/CELER
   30   CONTINUE
   40 CONTINUE

      END
