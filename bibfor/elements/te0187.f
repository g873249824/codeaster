      SUBROUTINE TE0187(OPTION,NOMTE)
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

C     BUT: CALCUL DU VECTEUR INTENSITE ACTIVE AUX NOEUDS
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'INTE_ELNO_ACTI'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      IMPLICIT REAL*8 (A-H,O-Z)

      CHARACTER*2 CODRET
      CHARACTER*16 NOMTE,OPTION

      REAL*8 OMEGA
      REAL*8 OMERHO,PI
      COMPLEX*16 VITX(27),VITY(27),VITZ(27)

      REAL*8 DFDX(27),DFDY(27),DFDZ(27),JAC
      INTEGER IDFDE,IGEOM,IDINO,IPINO

      INTEGER IINTE,IPRES,IMATE,IFREQ
      INTEGER JGANO,NNO,INO,I

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

      CALL JEMARQ()
      CALL ELREF4(' ','NOEU',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PINTEAC','E',IINTE)
      CALL JEVECH('PPRESSC','L',IPRES)
      CALL JEVECH('PMATERC','L',IMATE)

      MATER = ZI(IMATE)
      CALL RCVALA(MATER,' ','FLUIDE',0,' ',R8B,1,'RHO',RHO,CODRET,'FM')

      PI = R8PI()
      CALL JEVEUO('FREQ.VALE','L',IFREQ)
      OMEGA = 2.D0*PI*ZR(IFREQ)
      OMERHO = OMEGA*RHO

      DO 10 I = 1,3*NNO
        ZR(IINTE+I-1) = 0.0D0
   10 CONTINUE

C    BOUCLE SUR LES NOEUDS

      DO 30 INO = 1,NNO

        IDINO = IINTE + (INO-1)*3 - 1
        IPINO = IPRES + INO - 1
        CALL DFDM3D ( NNO, INO, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, JAC )

        VITX(INO) = (0.0D0,0.0D0)
        VITY(INO) = (0.0D0,0.0D0)
        VITZ(INO) = (0.0D0,0.0D0)

        DO 20 I = 1,NNO

          VITX(INO) = VITX(INO) + DFDX(I)*ZC(IPRES+I-1)
          VITY(INO) = VITY(INO) + DFDY(I)*ZC(IPRES+I-1)
          VITZ(INO) = VITZ(INO) + DFDZ(I)*ZC(IPRES+I-1)
   20   CONTINUE

        VITX(INO) = VITX(INO)* (0.D0,1.D0)/OMERHO
        VITY(INO) = VITY(INO)* (0.D0,1.D0)/OMERHO
        VITZ(INO) = VITZ(INO)* (0.D0,1.D0)/OMERHO

        ZR(IDINO+1) = 0.5D0*DBLE(ZC(IPINO)*DCONJG(VITX(INO)))

        ZR(IDINO+2) = 0.5D0*DBLE(ZC(IPINO)*DCONJG(VITY(INO)))

        ZR(IDINO+3) = 0.5D0*DBLE(ZC(IPINO)*DCONJG(VITZ(INO)))
   30 CONTINUE

      CALL JEDEMA()
      END
