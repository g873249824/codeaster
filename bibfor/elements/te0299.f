      SUBROUTINE TE0299(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
C
C.......................................................................
C FONCTION REALISEE:
C
C      CALCUL DES COEFFICIENTS DE CONTRAINTES K1 ET K2
C      A PARTIR DE LA FORME BILINEAIRE SYMETRIQUE G
C      ET DES DEPLACEMENTS SINGULIERS EN FOND DE FISSURE
C
C      POUR LES ELEMENTS ISOPARAMETRIQUES 2D
C
C      OPTION : 'CALC_K_G'    (CHARGES REELLES)
C               'CALC_K_G_F'  (CHARGES FONCTIONS)
C
C ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      CHARACTER*2  CODRET(3)
      CHARACTER*4  FAMI
      CHARACTER*8  NOMRES(3),NOMPAR(3)
      CHARACTER*16 NOMTE,OPTION,PHENOM
C
      REAL*8   EPSI,DEPI,R8DEPI,R8PREM
      REAL*8   DFDI(18),F(3,3),EPS(6),FNO(18)
      REAL*8   DUDM(3,4),DFDM(3,4),DTDM(3,4),DER(4)
      REAL*8   DU1DM(3,4),DU2DM(3,4),DV1DM(7),DV2DM(7)
      REAL*8   RHO,OM,OMO,RBID,E,NU,ALPHA
      REAL*8   THET,TREF,TG(27),TPN(20),TGDM(3),TTRG,K3A,K6A
      REAL*8   XAG,YAG,XG,YG,XA,YA,RPOL,NORM,A,B
      REAL*8   PHI,CPHI,C2PHI,CPHI2,SPHI2
      REAL*8   C1,C2,C3,CS
      REAL*8   TH,VALRES(3),DEVRES(3),VALPAR(3)
      REAL*8   CK,COEFK,CFORM,CR1,CR2
      REAL*8   GELEM,GUV1,GUV2,GUV3,K1,K2,G,POIDS
C
      INTEGER  IPOIDS,IVF,IDFDE,NNO,KP,NPG1,COMPT,IER,NNOS,JGANO
      INTEGER  IGEOM,ITHET,IROTA,IPESA,IFIC,IDEPL,IRET
      INTEGER  IMATE,IFORC,IFORF,IFOND,ITEMPS,K,I,J,KK,L,NDIM
C
      LOGICAL  FONC
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
      CALL JEMARQ()
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      CALL JEVECH('PTHETAR','L',ITHET)
C
C - PAS DE CALCUL DE G POUR LES ELEMENTS OU LA VALEUR DE THETA EST NULLE
C
      GUV1   = 0.D0
      GUV2   = 0.D0
      GUV3   = 0.D0
      COMPT = 0
      EPSI = R8PREM()
      DO 15 I=1,NNO
        THET = 0.D0
        DO 14 J=1,NDIM
          THET = THET + ABS(ZR(ITHET+NDIM*(I-1)+J-1))
14      CONTINUE
        IF(THET.LT.EPSI) COMPT = COMPT+1
15    CONTINUE
      IF(COMPT.EQ.NNO)  GOTO 9999
C
C - RECUPERATION CHARGES, MATER... ----------------
      EPSI = R8PREM()
      DEPI = R8DEPI()
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PFISSR' ,'L',IFOND)
      IF (OPTION.EQ.'CALC_K_G_F') THEN
        FONC = .TRUE.
        CALL JEVECH('PFFVOLU','L',IFORF)
        CALL JEVECH('PTEMPSR','L',ITEMPS)
        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'INST'
        VALPAR(3) = ZR(ITEMPS)
      ELSE
        FONC =.FALSE.
        CALL JEVECH('PFRVOLU','L',IFORC)
      ENDIF
      CALL TECACH('ONN','PPESANR',1,IPESA,IRET)
      CALL TECACH('ONN','PROTATR',1,IROTA,IRET)
C
      CALL JEVECH('PGTHETA','E',IFIC)

      CALL RCVARC('F','TEMP','REF',FAMI,1,1,TREF,IRET)

      DO 645 KP = 1,NPG1
        CALL RCVARC('F','TEMP','+',FAMI,KP,1,TG(KP),IRET)
  645 CONTINUE

      DO 646 KP = 1,NNO
        CALL RCVARC('F','NOEU','+',FAMI,KP,1,TPN(KP),IRET)
  646 CONTINUE

      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'ALPHA'
      NORM = SQRT(ZR(IFOND+2)*ZR(IFOND+2)+ZR(IFOND+3)*ZR(IFOND+3))
      A =  ZR(IFOND+3)/NORM
      B = -ZR(IFOND+2)/NORM
C
C - RECUPERATION DES CHARGES ET DEFORMATIONS INITIALES ----------------
C
      IF (FONC) THEN
        DO 50 I=1,NNO
          DO 30 J=1,NDIM
            VALPAR(J) = ZR(IGEOM+NDIM*(I-1)+J-1)
30        CONTINUE
          DO 40 J=1,NDIM
            KK = NDIM*(I-1)+J
            CALL FOINTE('FM',ZK8(IFORF+J-1),3,NOMPAR,VALPAR,FNO(KK),IER)
40        CONTINUE
50      CONTINUE
      ELSE
        DO 80 I=1,NNO
          DO 60 J=1,NDIM
            FNO(NDIM*(I-1)+J)= ZR(IFORC+NDIM*(I-1)+J-1)
60        CONTINUE
80      CONTINUE
      ENDIF
C
      IF ((IPESA.NE.0).OR.(IROTA.NE.0)) THEN
        CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)
        CALL RCVALA(ZI(IMATE),' ',PHENOM,1,' ',RBID,1,'RHO',RHO,
     &              CODRET,'FM')
        IF (IPESA.NE.0) THEN
          DO 95 I=1,NNO
            DO 90 J=1,NDIM
              KK = NDIM*(I-1)+J
              FNO(KK)=FNO(KK)+RHO*ZR(IPESA)*ZR(IPESA+J)
90          CONTINUE
95        CONTINUE
        ENDIF
        IF (IROTA.NE.0) THEN
          OM = ZR(IROTA)
          DO 105 I=1,NNO
            OMO = 0.D0
            DO 100 J=1,NDIM
              OMO = OMO + ZR(IROTA+J)* ZR(IGEOM+NDIM*(I-1)+J-1)
100         CONTINUE
            DO 103 J=1,NDIM
              KK = NDIM*(I-1)+J
              FNO(KK)=FNO(KK)+RHO*OM*OM*(ZR(IGEOM+KK-1)-OMO*ZR(IROTA+J))
103         CONTINUE
105       CONTINUE
        ENDIF
      ENDIF
C
C ======================================================================
C
      DO 800 KP=1,NPG1
        L  = (KP-1)*NNO
        XG = 0.D0
        YG = 0.D0
        DO 220 I=1,3
          TGDM(I) = 0.D0
          DO 210 J=1,4
            DUDM(I,J) = 0.D0
            DU1DM(I,J)= 0.D0
            DU2DM(I,J)= 0.D0
            DTDM(I,J) = 0.D0
            DFDM(I,J) = 0.D0
210       CONTINUE
220     CONTINUE
C
C - CALCUL DES ELEMENTS GEOMETRIQUES
C
        CALL NMGEOM (NDIM,NNO,.FALSE.,.FALSE.,ZR(IGEOM),KP,
     &               IPOIDS,IVF,IDFDE,
     &               ZR(IDEPL),POIDS,DFDI,F,EPS,RBID)
C
C - CALCULS DES GRADIENTS DE U (DUDM),THETA (DTDM) ET FORCE(DFDM)
C   DU GRADIENT DE TEMPERATURE AUX POINTS DE GAUSS (TGDM)
C
        DO 320 I=1,NNO
          DER(1) = DFDI(I)
          DER(2) = DFDI(I+NNO)
          DER(3) = 0.D0
          DER(4) = ZR(IVF+L+I-1)
          XG = XG + ZR(IGEOM+2*(I-1)  )*DER(4)
          YG = YG + ZR(IGEOM+2*(I-1)+1)*DER(4)
          DO 310 J=1,NDIM
            TGDM(J)     = TGDM(J)   + TPN(I)*DER(J)
            DO 300 K=1,NDIM
              DUDM(J,K) = DUDM(J,K) + ZR(IDEPL+NDIM*(I-1)+J-1)*DER(K)
              DTDM(J,K) = DTDM(J,K) + ZR(ITHET+NDIM*(I-1)+J-1)*DER(K)
              DFDM(J,K) = DFDM(J,K) + FNO(NDIM*(I-1)+J)*DER(K)
300         CONTINUE
              DUDM(J,4) = DUDM(J,4) + ZR(IDEPL+NDIM*(I-1)+J-1)*DER(4)
              DTDM(J,4) = DTDM(J,4) + ZR(ITHET+NDIM*(I-1)+J-1)*DER(4)
              DFDM(J,4) = DFDM(J,4) + FNO(NDIM*(I-1)+J)*DER(4)
310       CONTINUE
320     CONTINUE
        TTRG  = TG(KP) - TREF
        CALL RCVAD2 (FAMI,KP,1,'+',ZI(IMATE),'ELAS',3,
     &                NOMRES,VALRES,DEVRES,CODRET)
        IF (CODRET(3).NE.'OK') THEN
          VALRES(3)= 0.D0
          DEVRES(3)= 0.D0
        ENDIF
        E     = VALRES(1)
        NU    = VALRES(2)
        ALPHA = VALRES(3)
        K3A = ALPHA*E/(1.D0-2.D0*NU)
        K6A = 2.D0*K3A
        CFORM  = (1.D0+NU)/(SQRT(DEPI)*E)
        C3 = E/(2.D0*(1.D0+NU))
        IF ( NOMTE(3:4) .EQ. 'DP' ) THEN
          C1 = E*(1.D0-NU)/((1.D0+NU)*(1.D0-2.D0*NU))
          C2 = NU/(1.D0-NU)*C1
          CK = 3.D0-4.D0*NU
          TH = 1.D0
          COEFK = E/(1.D0-NU*NU)
        ELSE
          C1 = E/(1.D0-NU*NU)
          C2 = NU*C1
          CK = (3.D0-NU)/(1.D0 + NU)
          TH = (1.D0-2.D0*NU)/(1.D0-NU)
          COEFK = E
        ENDIF
C
C   INTRODUCTION DES DEPLACEMENTS SINGULIERS ET DE LEURS DERIVEES
C   A        POINT EN FOND DE FISSURE
C   RPOL,PHI COORDONNEES POLAIRES DU POINT DE GAUSS
C
       XA = ZR(IFOND)
       YA = ZR(IFOND+1)
       XAG =  A*(XG-XA)+B*(YG-YA)
       YAG = -B*(XG-XA)+A*(YG-YA)
       RPOL = SQRT(XAG*XAG+YAG*YAG)
       PHI  = ATAN2(YAG,XAG)
       CPHI = COS(PHI)
       C2PHI= COS(2.D0*PHI)
       CPHI2= COS(0.5D0*PHI)
       SPHI2= SIN(0.5D0*PHI)
       CR1  = CFORM/(2.D0*SQRT(RPOL))
       CR2  = CFORM*SQRT(RPOL)
C
C    U1 SINGULIER ET DERIVEES POUR LE CALCUL DE K1
C
       DV1DM(1)=CR1*(CK-1.D0-CPHI+C2PHI)*CPHI2
       DV1DM(2)=CR1*(CK-1.D0+CPHI-C2PHI)*CPHI2
       DV1DM(3)=CR1*(CK+1.D0+CPHI+C2PHI)*SPHI2
       DV1DM(4)=CR2*(CK-CPHI)*CPHI2
       DV1DM(5)=CR1*(-CK-1.D0+CPHI+C2PHI)*SPHI2
       DV1DM(6)=CR2*(CK-CPHI)*CPHI2
       DV1DM(7)=CR2*(CK-CPHI)*SPHI2
C
       DU1DM(1,1)= A*A*DV1DM(1)-A*B*(DV1DM(3)+DV1DM(5))+B*B*DV1DM(2)
       DU1DM(2,2)= B*B*DV1DM(1)+A*B*(DV1DM(3)+DV1DM(5))+A*A*DV1DM(2)
       DU1DM(1,2)= A*B*(DV1DM(1)-DV1DM(2))+A*A*DV1DM(3)-B*B*DV1DM(5)
       DU1DM(2,1)= A*B*(DV1DM(1)-DV1DM(2))-B*B*DV1DM(3)+A*A*DV1DM(5)
       DU1DM(1,4)= A*DV1DM(6)-B*DV1DM(7)
       DU1DM(2,4)= B*DV1DM(6)+A*DV1DM(7)
C
C    U2 SINGULIER ET DERIVEES POUR LE CALCUL DE K2
C
       DV2DM(1)=CR1*(-CK-1.D0-CPHI-C2PHI)*SPHI2
       DV2DM(2)=CR1*(-CK+3.D0+CPHI+C2PHI)*SPHI2
       DV2DM(3)=CR1*(CK+3.D0-CPHI+C2PHI)*CPHI2
       DV2DM(4)=CR2*(CK+2.D0+CPHI)*SPHI2
       DV2DM(5)=CR1*(-CK+1.D0-CPHI+C2PHI)*CPHI2
       DV2DM(6)=CR2*(2.D0+CK+CPHI)*SPHI2
       DV2DM(7)=CR2*(2.D0-CK-CPHI)*CPHI2
C
       DU2DM(1,1)= A*A*DV2DM(1)-A*B*(DV2DM(3)+DV2DM(5))+B*B*DV2DM(2)
       DU2DM(2,2)= B*B*DV2DM(1)+A*B*(DV2DM(3)+DV2DM(5))+A*A*DV2DM(2)
       DU2DM(1,2)= A*B*(DV2DM(1)-DV2DM(2))+A*A*DV2DM(3)-B*B*DV2DM(5)
       DU2DM(2,1)= A*B*(DV2DM(1)-DV2DM(2))-B*B*DV2DM(3)+A*A*DV2DM(5)
       DU2DM(1,4)= A*DV2DM(6)-B*DV2DM(7)
       DU2DM(2,4)= B*DV2DM(6)+A*DV2DM(7)
C
C   INTRODUCTION DE U1S ET U2S DANS G(U,V)
C
        GELEM =0.D0
        CS    =0.5D0
        CALL GBILIN(DUDM,DU1DM,DTDM,DFDM,TGDM,TTRG,POIDS,
     &              C1,C2,C3,CS,TH,K3A,0.D0,0.D0,GELEM)
        GUV1  = GUV1 + GELEM
C
        GELEM =0.D0
        CS    =0.5D0
        CALL GBILIN(DUDM,DU2DM,DTDM,DFDM,TGDM,TTRG,POIDS,
     &              C1,C2,C3,CS,TH,K3A,0.D0,0.D0,GELEM)
        GUV2  = GUV2 + GELEM
C
        GELEM =0.D0
        CS    =1.D0
        CALL GBILIN(DUDM,DUDM,DTDM,DFDM,TGDM,TTRG,POIDS,
     &            C1,C2,C3,CS,TH,K6A,0.D0,0.D0,GELEM)
        GUV3  = GUV3 + GELEM
800   CONTINUE
C
      K1= GUV1*COEFK
      K2= GUV2*COEFK
      G = GUV3
C
      ZR(IFIC)   = G
      ZR(IFIC+1) = K1/SQRT(COEFK)
      ZR(IFIC+2) = K2/SQRT(COEFK)
      ZR(IFIC+3) = K1
      ZR(IFIC+4) = K2
C
9999  CONTINUE
      CALL JEDEMA()
      END
