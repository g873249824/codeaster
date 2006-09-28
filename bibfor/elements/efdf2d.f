      SUBROUTINE EFDF2D (IPOIDS, KPG,NNO2, IDFDE2,
     &                           NNO1, DFRDE1, DFRDK1,
     &                           COOR,DFDX,DFDY, POIDS )

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

      IMPLICIT NONE
      INTEGER  NNO1, NNO2,KPG,IDFDE2,IPOIDS
      REAL*8   DE2,DK2,COOR(*)
      REAL*8   DFDX(1),DFDY(1), POIDS
      REAL*8   DFRDE1(*),DFRDK1(*)
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES DERIVEES DES FONCTIONS DE FORME
C               P1 PAR RAPPORT A UNE GEOMETRIE P2
C
C IN  POIDSG  : POIDS DU POINT DE GAUSS DE REFERENCE
C IN  NNO     : NOMBRE DE NOEUDS (P2 OU P1)
C IN  DFRDE   : DERIVEE DES FONCTIONS DE FORME DE REFERENCE (P2 OU P1)
C IN  DFRDK   : DERIVEE DES FONCTIONS DE FORME DE REFERENCE (P2 OU P1)
C IN  COOR    : COORDONEES DES NOEUDS
C OUT DFDX    : DERIVEE DES FONCTIONS DE FORME P1 / P2
C OUT DFDY    : DERIVEE DES FONCTIONS DE FORME P1 / P2
C OUT POIDS   : POIDS DU POINT DE GAUSS EN GEOMETRIE REELLE
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


      CHARACTER*8        NOMAIL
      INTEGER            I, IADZI, IAZK24,K,II
      REAL*8             DXDE,DXDK,DYDE,DYDK, JAC, R8GAEM

      DXDE=0.D0
      DXDK=0.D0
      DYDE=0.D0
      DYDK=0.D0
      DO 100 I=1,NNO2
        K = 2*NNO2*(KPG-1)
        II = 2*(I-1)
        DE2 =  ZR(IDFDE2-1+K+II+1)
        DK2 =  ZR(IDFDE2-1+K+II+2)
        DXDE=DXDE+COOR(2*I-1)*DE2
        DXDK=DXDK+COOR(2*I-1)*DK2
        DYDE=DYDE+COOR(2*I  )*DE2
        DYDK=DYDK+COOR(2*I  )*DK2
100   CONTINUE
      JAC=DXDE*DYDK-DXDK*DYDE

      IF(ABS(JAC).LE.1.D0/R8GAEM()) THEN
         CALL TECAEL(IADZI,IAZK24)
         NOMAIL= ZK24(IAZK24-1+3)(1:8)
         CALL U2MESK('F','ALGORITH2_59',1,NOMAIL)
      ENDIF

      DO 200 I=1,NNO1
        DFDX(I)=(DYDK*DFRDE1(I)-DYDE*DFRDK1(I))/JAC
        DFDY(I)=(DXDE*DFRDK1(I)-DXDK*DFRDE1(I))/JAC
200   CONTINUE

      POIDS=ABS(JAC)*ZR(IPOIDS+KPG-1)
      END
