      SUBROUTINE SH2SIG(XETEMP,PARA,XIDEPP,DUSX,SIGMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 24/03/2009   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C               ELEMENT SHB20
C
      IMPLICIT REAL *8(A-H,O-Z)
      INTEGER LAG,IRDC
      REAL*8 EYG(5),ENU(5),SIGMA(*),PARA(11)
      REAL*8 XE(60),LAMBDA,DUSX(*),XIDEPP(*)
      REAL*8 XCOQ(3,4),BKSIP(3,20,20),B(3,20)
      REAL*8 XCENT(3),PPP(3,3),PPPT(3,3)
      REAL*8 XL(3,4),XXX(3),YYY(3)
      REAL*8 CMATLO(6,6),XETEMP(*)
      REAL*8 DEPS(6),DUSDX(9),UE(3,20)
      REAL*8 DEPLOC(6),SIGLOC(6)
      REAL*8 RR12(3,3),RR2(3,3)
      REAL*8 XXG5(20),XYG5(20),XZG5(20),PXG5(20)
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

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C INITIALISATIONS
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C INFOS:
C XE EST RANGE(XNOEUD1 YNOEUD1 ZNOEUD1, XNOEUD2 YNOEUD2 ZNOEUD2,...)
C DANS SHB8_TEST_NUM: ATTENTION A LA NUMEROTATION DES NOEUDS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C ON DEFINIT LES POINTS DE GAUSS ET LES POIDS
C
C Des points de gauss sur la facette 1-2-3:
C
C
      XZG5(1) = -0.906179845938664D0
      XZG5(2) = -0.538469310105683D0
      XZG5(3) =  0.D0
      XZG5(4) =  0.538469310105683D0
      XZG5(5) =  0.906179845938664D0
C
      PXG5(1) =  0.236926885056189D0
      PXG5(2) =  0.478628670499366D0
      PXG5(3) =  0.568888888888889D0
      PXG5(4) =  0.478628670499366D0
      PXG5(5) =  0.236926885056189D0
C
      DO 71 IZ =1,5
         XXG5(IZ)    = -0.577350269189625D0
         XXG5(IZ+5)  =  0.577350269189625D0
         XXG5(IZ+10) =  0.577350269189625D0
         XXG5(IZ+15) = -0.577350269189625D0
         XYG5(IZ)    = -0.577350269189625D0
         XYG5(IZ+5)  = -0.577350269189625D0
         XYG5(IZ+10) =  0.577350269189625D0
         XYG5(IZ+15) =  0.577350269189625D0
         XZG5(IZ+5)  = XZG5(IZ)
         PXG5(IZ+5)  = PXG5(IZ)
         XZG5(IZ+10) = XZG5(IZ)
         PXG5(IZ+10) = PXG5(IZ)
         XZG5(IZ+15) = XZG5(IZ)
         PXG5(IZ+15) = PXG5(IZ)
   71 CONTINUE
C     ON FAIT UNE COPIE DE XETEMP DANS XE
      DO 30 I = 1,60
        XE(I) = XETEMP(I)
   30 CONTINUE 
C
C TYPE DE LOI DE COMPORTEMENT:
C     IRDC = 1 : SHB8 TYPE PLEXUS
C     IRDC = 2 : C.P.
C     IRDC = 3 : 3D COMPLETE
C
      IRDC = NINT(PARA(5))
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                  C
C ON CALCULE LES CONTRAINTES : SORTIE DANS OUT(120)                 C  
C                       CONTRAINTES LOCALES DANS CHAQUE COUCHE     C
C                       SUR LA CONFIGURATION 1                     C
C  LE DEPLACEMENT NODAL A L'AIR D'ETRE DANS WORK(1 A 60)           C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      CALL R8INIR(36,0.D0,CMATLO,1)
C
C UE: INCREMENT DE DEPLACEMENT NODAL, REPERE GLOBAL
C
C XE: DEBUT DU PAS
      DO 260 J=1,20
         DO 250 I=1,3
            UE(I,J)=XIDEPP((J-1)*3+I)
  250    CONTINUE
  260 CONTINUE
C
      LAG = NINT(PARA(6))
C
C ON DEFINIT CMATLOC LOI MODIFIEE SHB20
C
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
C CALCUL DE BKSIP(3,8,IP) DANS REPERE DE REFERENCE
C      BKSIP(1,*,IP) = VECTEUR BX AU POINT GAUSS IP
C      BKSIP(2,*,IP) = VECTEUR BY AU POINT GAUSS IP
C      BKSIP(3,*,IP) = VECTEUR BZ AU POINT GAUSS IP
C
      CALL SH2KSI(20,XXG5,XYG5,XZG5,BKSIP)
C
      DO 340 IP=1,20
C
C DEFINITION DES 4 POINTS  COQUES  
C
         ZETA  = XZG5(IP)
         ZLAMB = 0.5D0*(1.D0-ZETA)    
         DO 270 I=1,4
            DO 261 J=1,3
               XCOQ(J,I) = ZLAMB*XE((I-1)*3+J) 
     &            + (1.D0-ZLAMB)*XE(I*3+9+J)
  261       CONTINUE
  270    CONTINUE
C
C CALCUL DE PPP 3*3 PASSAGE DE GLOBAL A LOCAL,COQUE
C XCENT : COORD GLOBAL DU CENTRE DE L'ELEMENT
C
         CALL RLOSHB(XCOQ,XCENT,PPP,XL,XXX,YYY,RBID)
C
C CALCUL DE B : U_GLOBAL ---> EPS_GLOBAL
C
         CALL S2CALB(BKSIP(1,1,IP),XE,B,AJAC)
C
C CALCUL DE EPS DANS LE REPERE GLOBAL: 1 POUR DEFORMATIONS LINEAIRES
C                                     2 POUR TERMES CARRES EN PLUS
         DO 280 I=1,6
            DEPS(I)=0.D0
  280    CONTINUE
         IF (LAG.EQ.1) THEN
C ON AJOUTE LA PARTIE NON-LINEAIRE DE EPS
            CALL DSDX3D(2,B,UE,DEPS,DUSDX,20)
         ELSE
            CALL DSDX3D(1,B,UE,DEPS,DUSDX,20)
         END IF
C
C SORTIE DE DUSDX DANS PROPEL(1 A 9 * 5 PT DE GAUSS)
C POUR UTILISATION ULTERIEURE DANS Q8PKCN_SHB8
C
C         CALL AEQBT(PPPT,PPP,3,3)
          DO 300 I = 1,3
            DO 290 J = 1,3
              PPPT(J,I) = PPP(I,J)
  290       CONTINUE
  300     CONTINUE
          RR12(1,1) = DUSDX(1)
          RR12(1,2) = DUSDX(2)
          RR12(1,3) = DUSDX(3)
          RR12(2,1) = DUSDX(4)
          RR12(2,2) = DUSDX(5)
          RR12(2,3) = DUSDX(6)
          RR12(3,1) = DUSDX(7)
          RR12(3,2) = DUSDX(8)
          RR12(3,3) = DUSDX(9)
          CALL MULMAT(3,3,3,PPPT,RR12,RR2)
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
          DO 310 I=1,9
             DUSX(I+(IP-1)*9)=DUSDX(I)
  310     CONTINUE
          DO 320 I=1,6
            DEPLOC(I) = 0.D0
            SIGLOC(I) = 0.D0
  320     CONTINUE
          CALL CHRP3D(PPP,DEPS,DEPLOC,2)
C
C CALCUL DE SIGMA DANS LE REPERE LOCAL
C
          CALL MULMAT(6,6,1,CMATLO,DEPLOC,SIGLOC)
C
C CONTRAINTES ECRITES SOUS LA FORME:
C               [SIG] = [S_11, S_22, S_33, S_12, S_23, S_13]
          DO 330 I=1,6
C ON LAISSE LES CONTRAINTES DANS LE REPERE LOCAL POUR LA PLASTICITE
            SIGMA((IP-1)*6+I)=SIGLOC(I)
  330     CONTINUE
  340 CONTINUE
      END
