      SUBROUTINE SH1SIG(XETEMP,PARA,XIDEPP,DUSX,SIGMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C               ELEMENT SHB15
C
      IMPLICIT REAL *8(A-H,O-Z)
      INTEGER LAG,IRDC
      REAL*8 SIGMA(*),PARA(11)
      REAL*8 XE(45),LAMBDA,DUSX(*),XIDEPP(*)
      REAL*8 XCOQ(3,3),BKSIP(3,15,15),B(3,15)
      REAL*8 XCENT(3),PPP(3,3),PPT(3,3)
      REAL*8 XL(3,3),XXX(3),YYY(3)
      REAL*8 CMATLO(6,6)
      REAL*8 XXG5(15),XYG5(15),XZG5(15)
      REAL*8 DEPS(6),DUSDX(9),UE(3,15),RR2(3,3)
      REAL*8 DEPSLO (6),SIGLOC(6),RR12(3,3),XETEMP(*)

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
C INITIALISATIONS
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C INFOS:
C XE EST RANGE COMME CA: (XNOEUD1 YNOEUD1 ZNOEUD1, XNOEUD2 YNOEUD2
C... ZNOEUD2)
C DANS SHB15_TEST_NUM: ATTENTION A LA NUMEROTATION DES NOEUDS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C ON DEFINI LES POINTS GAUSS ET LES POIDS
C
C 5 points sur la facette 1-2-3:
C
C
      DO 10 IP=1,5
         XZG5(IP)    =  0.5D0
         XYG5(IP)    =  0.5D0
         XZG5(IP+5)  =  0.5D0
         XYG5(IP+5)  =  0.D0
         XZG5(IP+10) =  0.D0
         XYG5(IP+10) =  0.5D0
   10 CONTINUE
C
      DO 20 IP=1,3
         XXG5(5*(IP-1)+1) = -0.906179845938664D0
         XXG5(5*(IP-1)+2) = -0.538469310105683D0
         XXG5(5*(IP-1)+3) =  0.D0
         XXG5(5*(IP-1)+4) =  0.538469310105683D0
         XXG5(5*(IP-1)+5) =  0.906179845938664D0
C
C         PXG5(5*(IP-1)+1) =  0.236926885056189D0/6.D0
C         PXG5(5*(IP-1)+2) =  0.478628670499366D0/6.D0
C         PXG5(5*(IP-1)+3) =  0.568888888888889D0/6.D0
C         PXG5(5*(IP-1)+4) =  0.478628670499366D0/6.D0
C         PXG5(5*(IP-1)+5) =  0.236926885056189D0/6.D0
   20 CONTINUE
C
C     ON FAIT UNE COPIE DE XETEMP DANS XE
      DO 30 I = 1,45
        XE(I) = XETEMP(I)
   30 CONTINUE
C
C TYPE DE LOI DE COMPORTEMENT:
C     IRDC = 1 : SHB6 MEME TYPE QUE SHB8 DANS PLEXUS
C     IRDC = 2 : C.P.
C     IRDC = 3 : 3D COMPLETE
C
      IRDC = NINT(PARA(5))
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC                                                                  C
CC ON CALCULE LES CONTRAINTES : SORTIE DANS OUT(30)                 C
CC                       CONTRAINTES LOCALES DANS CHAQUE COUCHE     C
CC                       SUR LA CONFIGURATION 1                     C
CC  LE DEPLACEMENT NODAL A L'AIR D'ETRE DANS WORK(1 A 45)           C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      CALL R8INIR(36,0.D0,CMATLO,1)
CC
CC UE: INCREMENT DE DEPLACEMENT NODAL, REPERE GLOBAL
CC
CC XE: DEBUT DU PAS
      DO 290 J=1,15
        DO 280 I=1,3
            UE(I,J)=XIDEPP((J-1)*3+I)
  280   CONTINUE
  290 CONTINUE
C
      LAG = NINT(PARA(6))
CC
CC ON DEFINIT CMATLO LOI MODIFIEE SHB15
CC
      XNU = PARA(2)
      LAMBDA = PARA(1)*PARA(2)/(1.D0-PARA(2)*PARA(2))
      XMU = 0.5D0*PARA(1)/ (1.D0+PARA(2))
      CMATLO(1,1) = LAMBDA + 2.D0*XMU
      CMATLO(2,2) = LAMBDA + 2.D0*XMU
      IF (IRDC.EQ.1) THEN
C COMPORTEMENT SHB6 PLEXUS
         CMATLO(3,3) = PARA(1)
      ENDIF
C
      IF (IRDC.EQ.2) THEN
C COMPORTEMENT C.P.
          CMATLO(3,3) = 0.D0
      ENDIF
C
      CMATLO(1,2) = LAMBDA
      CMATLO(2,1) = LAMBDA
      CMATLO(4,4) = XMU
      CMATLO(5,5) = XMU
      CMATLO(6,6) = XMU
C
      IF (IRDC.EQ.3) THEN
C COMPORTEMENT LOI TRIDIM MMC 3D
        XNU = PARA(2)
        XCOOEF = PARA(1)/((1.D0+XNU)*(1.D0-2.D0*XNU))
        CMATLO(1,1) = (1.D0-XNU)*XCOOEF
        CMATLO(2,2) = (1.D0-XNU)*XCOOEF
        CMATLO(3,3) = (1.D0-XNU)*XCOOEF
        CMATLO(1,2) = XNU*XCOOEF
        CMATLO(2,1) = XNU*XCOOEF
        CMATLO(1,3) = XNU*XCOOEF
        CMATLO(3,1) = XNU*XCOOEF
        CMATLO(2,3) = XNU*XCOOEF
        CMATLO(3,2) = XNU*XCOOEF
        CMATLO(4,4) = (1.D0-2.D0*XNU)*0.5D0*XCOOEF
        CMATLO(5,5) = (1.D0-2.D0*XNU)*0.5D0*XCOOEF
        CMATLO(6,6) = (1.D0-2.D0*XNU)*0.5D0*XCOOEF
      ENDIF
C
CC CALCUL DE BKSIP(3,8,IP) DANS REPERE DE REFERENCE
CC      BKSIP(1,*,IP) = VECTEUR BX AU POINT GAUSS IP
CC      BKSIP(2,*,IP) = VECTEUR BY AU POINT GAUSS IP
CC      BKSIP(3,*,IP) = VECTEUR BZ AU POINT GAUSS IP
CC
      CALL SH1KSI(15,XXG5,XYG5,XZG5,BKSIP)
CC
      DO 380 IP=1,15
CC
CC DEFINITION DES 4 POINTS  COQUES
CC
          ZETA  = XXG5(IP)
          ZLAMB = 0.5D0*(1.D0-ZETA)
          DO 310 I=1,3
            DO 300 J=1,3
               XCOQ(J,I) = ZLAMB*XE((I-1)*3+J)
     &              + (1.D0-ZLAMB)*XE(3*I+6+J)
  300       CONTINUE
  310     CONTINUE
CC
CC CALCUL DE PPP 3*3 PASSAGE DE GLOBAL A LOCAL,COQUE
CC XCENT : COORD GLOBAL DU CENTRE DE L'ELEMENT
CC
          CALL RLOSH6(XCOQ,XCENT,PPP,XL,XXX,YYY,RBID)
CC
CC CALCUL DE B : U_GLOBAL ---> EPS_GLOBAL
CC
          CALL S1CALB(BKSIP(1,1,IP),XE,B,AJAC)
CC
CC CALCUL DE EPS DANS LE REPERE GLOBAL: 1 POUR DEFORMATIONS LINEAIRES
CC                                     2 POUR TERMES CARRES EN PLUS
          DO 320 I=1,6
            DEPS(I)=0.D0
  320     CONTINUE
          IF (LAG.EQ.1) THEN
CC ON AJOUTE LA PARTIE NON-LINEAIRE DE EPS
            CALL DSDX3D(2,B,UE,DEPS,DUSDX,15)
          ELSE
            CALL DSDX3D(1,B,UE,DEPS,DUSDX,15)
          END IF
CC
          DO 340 I = 1,3
            DO 330 J = 1,3
               PPT(J,I) = PPP(I,J)
  330       CONTINUE
  340     CONTINUE
          RR12(1,1) = DUSDX(1)
          RR12(1,2) = DUSDX(2)
          RR12(1,3) = DUSDX(3)
          RR12(2,1) = DUSDX(4)
          RR12(2,2) = DUSDX(5)
          RR12(2,3) = DUSDX(6)
          RR12(3,1) = DUSDX(7)
          RR12(3,2) = DUSDX(8)
          RR12(3,3) = DUSDX(9)
          CALL MULMAT(3,3,3,PPT,RR12,RR2)
          CALL MULMAT(3,3,3,RR2,PPP,RR12)
          DUSDX(1)  = RR12(1,1)
          DUSDX(2)  = RR12(1,2)
          DUSDX(3)  = RR12(1,3)
          DUSDX(4)  = RR12(2,1)
          DUSDX(5)  = RR12(2,2)
          DUSDX(6)  = RR12(2,3)
          DUSDX(7)  = RR12(3,1)
          DUSDX(8)  = RR12(3,2)
          DUSDX(9)  = RR12(3,3)
C
          DO 350 I=1,9
            DUSX(I+(IP-1)*9)=DUSDX(I)
  350     CONTINUE
          DO 360 I=1,6
            DEPSLO (I) = 0.D0
            SIGLOC(I)  = 0.D0
  360     CONTINUE
          CALL CHRP3D(PPP,DEPS,DEPSLO ,2)
CC
CC CALCUL DE SIGMA DANS LE REPERE LOCAL
CC
          CALL MULMAT(6,6,1,CMATLO,DEPSLO ,SIGLOC)
CC
CC CONTRAINTES ECRITES SOUS LA FORME:
CC               [SIG] = [S_11, S_22, S_33, S_12, S_23, S_13]
          DO 370 I=1,6
CC ON LAISSE LES CONTRAINTES DANS LE REPERE LOCAL POUR LA PLASTICITE
            SIGMA((IP-1)*6+I)=SIGLOC(I)
  370     CONTINUE
  380 CONTINUE
      END
