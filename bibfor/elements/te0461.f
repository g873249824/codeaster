      SUBROUTINE TE0461(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C FONCTION REALISEE: CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES
C                    MODAUX A PARTIR DE LA FORME BILINEAIRE SYMETRIQUE
C                    G ET DES DEPLACMENTS SINGULIERS EN FOND DE FISSURE
C
C      OPTION : 'K_G_MODA'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C.......................................................................
C
      INCLUDE 'jeveux.h'
      INTEGER ICODRE(3)
      CHARACTER*4 FAMI
      CHARACTER*8 NOMRES(3)
      CHARACTER*16 NOMTE,OPTION,PHENOM,COMPOR(4)
C
      REAL*8 EPSI,DEPI,R8DEPI,R8PREM
      REAL*8 DFDI(60),F(3,3),EPS(6),E1(3),E2(3),E3(3)
      REAL*8 DUDM(3,4),DFDM(3,4),DFVDM(3,4)
      REAL*8 DTDM(3,4),DER(4)
      REAL*8 U1L(3),U2L(3),U3L(3)
C
      REAL*8 U1G(3),U2G(3),U3G(3),LSNG,LSTG
C
      REAL*8 DU1DM(3,4),DU2DM(3,4),DU3DM(3,4)
      REAL*8 DU1DPO(3,2),DU2DPO(3,2),DU3DPO(3,2),P(3,3),INVP(3,3)
      REAL*8 DU1DL(3,4),DU2DL(3,4),DU3DL(3,4),COURB(3,3,3)
      REAL*8 RHO,RBID,E,NU,ALPHA
      REAL*8 THET,TGDM(3),TTRG,TGVDM(3),TTRGV
      REAL*8 LA,MU,KA,K3A
      REAL*8 XG,YG,ZG
      REAL*8 C1,C2,C3,RG,PHIG
      REAL*8 VALRES(3),DEVRES(3)
      REAL*8 COEFF,COEFF3,CR1,CR2
      REAL*8 GUV,GUV1,GUV2,GUV3,K1,K2,K3,G,POIDS,PULS
      REAL*8 NORME
C
      INTEGER IPOIDS,IVF,IDFDE,NNO,KP,NPG,COMPT,NNOS
      INTEGER JGANO,IRET,ICOMP,IBALO,ICOUR,IPULS
      INTEGER IGEOM,ITHET,IGTHET,IDEPL
      INTEGER IMATE,K,I,J,L,NDIM
      INTEGER JLSN,JLST
C
      LOGICAL LCOUR
C
C
C DEB ------------------------------------------------------------------
C
      CALL JEMARQ
      EPSI = R8PREM()
      DEPI = R8DEPI()
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      CALL JEVECH('PTHETAR','L',ITHET)
      G = 0.D0
      K1 = 0.D0
      K2 = 0.D0
      K3 = 0.D0
      COEFF = 1.D0
      COEFF3 = 1.D0
      CALL JEVECH('PGTHETA','E',IGTHET)
C
C - PAS DE CALCUL DE G POUR LES ELEMENTS OU LA VALEUR DE THETA EST NULLE
      COMPT = 0
      DO 10 I = 1,NNO
        THET = 0.D0
        DO 11 J = 1,NDIM
          THET = THET + ABS(ZR(ITHET+NDIM*(I-1)+J-1))
 11     CONTINUE
        IF (THET .LT. EPSI) COMPT = COMPT + 1
 10   CONTINUE
      IF (COMPT .EQ. NNO) THEN
        GOTO 9999
      END IF
C
C RECUPERATION CHARGE, MATER..
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMP)
      CALL JEVECH('PBASLOR','L',IBALO)
      CALL JEVECH('PCOURB','L',ICOUR)
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PPULPRO','E',IPULS)
      PULS = ZR(IPULS)

      DO 20 I = 1,4
        COMPOR(I) = ZK16(ICOMP+I-1)
 20   CONTINUE
C
      IF ((COMPOR(3).EQ.'GROT_GDEP') .OR.
     &    (COMPOR(4)(1:9).EQ.'COMP_INCR')) THEN
        CALL U2MESS('F','RUPTURE1_27')
      END IF
C
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'ALPHA'
C
      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,ICODRE)
      CALL RCVALB(FAMI,1,1,'+',ZI(IMATE),' ',PHENOM,0,' ',0.D0,
     &            1,'RHO',RHO,ICODRE,1)
C
C-----------------------------------------------------------------------
C     BOUCLE SUR LES POINTS DE GAUSS
      DO 100 KP = 1,NPG
C
        L = (KP-1) * NNO
        XG = 0.D0
        YG = 0.D0
        ZG = 0.D0
        LSNG=0.D0
        LSTG=0.D0
        DO 110 I = 1,3
          TGDM(I) = 0.D0
          TGVDM(I) = 0.D0
          DO 111 J = 1,4
            DUDM(I,J) = 0.D0
            DU1DL(I,J) = 0.D0
            DU2DL(I,J) = 0.D0
            DU3DL(I,J) = 0.D0
            DU1DM(I,J) = 0.D0
            DU2DM(I,J) = 0.D0
            DU3DM(I,J) = 0.D0
            DTDM(I,J) = 0.D0
            DFDM(I,J) = 0.D0
            DFVDM(I,J) = 0.D0
 111      CONTINUE
 110    CONTINUE
C
C   CALCUL DES ELEMENTS CINEMATIQUES (MATRICES F ET E) EN UN PT DE GAUSS
C
        CALL NMGEOM(NDIM,NNO,.FALSE.,.FALSE.,ZR(IGEOM),KP,IPOIDS,IVF,
     &              IDFDE,ZR(IDEPL),.TRUE.,POIDS,DFDI,F,EPS,RBID)
C
C - CALCULS DES GRADIENTS DE U (DUDM),THETA (DTDM) ET FORCE(DFDM)
C   DU GRADIENT DE LA TEMPERATURE AUX POINTS DE GAUSS (TGDM)
C   ET DES LEVEL SETS
        DO 120 I = 1,NNO
          DER(1) = DFDI(I)
          DER(2) = DFDI(I+NNO)
          DER(3) = DFDI(I+2*NNO)
          DER(4) = ZR(IVF+L+I-1)
C
          XG = XG + ZR(IGEOM-1+NDIM*(I-1)+1)*DER(4)
          YG = YG + ZR(IGEOM-1+NDIM*(I-1)+2)*DER(4)
          ZG = ZG + ZR(IGEOM-1+NDIM*(I-1)+3)*DER(4)
          LSNG = LSNG + ZR(JLSN-1+I) * DER(4)
          LSTG = LSTG + ZR(JLST-1+I) * DER(4)
C
          DO 121 J = 1,NDIM
            DO 122 K = 1,NDIM
              DUDM(J,K) = DUDM(J,K) + ZR(IDEPL+NDIM*(I-1)+J-1)*DER(K)
              DTDM(J,K) = DTDM(J,K) + ZR(ITHET+NDIM*(I-1)+J-1)*DER(K)
 122        CONTINUE
            DUDM(J,4) = DUDM(J,4) + ZR(IDEPL+NDIM*(I-1)+J-1)*DER(4)
            DTDM(J,4) = DTDM(J,4) + ZR(ITHET+NDIM*(I-1)+J-1)*DER(4)
 121      CONTINUE
 120    CONTINUE
C
C       RECUPERATION DES DONNEES MATERIAUX
        TTRG = 0.D0
        TTRGV = 0.D0
        CALL RCVAD2(FAMI,KP,1,'+',ZI(IMATE),'ELAS',3,
     &              NOMRES,VALRES,DEVRES,ICODRE)
        IF (ICODRE(3) .NE.0) THEN
          VALRES(3) = 0.D0
          DEVRES(3) = 0.D0
        END IF
        E = VALRES(1)
        NU = VALRES(2)
        ALPHA = VALRES(3)
        K3A = ALPHA * E / (1.D0-2.D0*NU)
C
        LA = NU * E / ((1.D0+NU)*(1.D0-2.D0*NU))
        MU = E / (2.D0*(1.D0+NU))
C       EN 3D COMME EN DP
        KA = 3.D0 - 4.D0*NU
        COEFF = E / (1.D0-NU*NU)
        COEFF3 = 2.D0 * MU
C
        C1 = LA + 2.D0*MU
        C2 = LA
        C3 = MU
C
C       RECUPERATION DE LA BASE LOCALE ASSOCIEE AU PT KP
C       (E1=GRLT,E2=GRLN,E3=E1^E2)
        DO 123 I = 1,3
          E1(I) = ZR(IBALO-1+9*(KP-1)+I+3)
          E2(I) = ZR(IBALO-1+9*(KP-1)+I+6)
 123    CONTINUE
C       NORMALISATION DE LA BASE
        CALL NORMEV(E1,NORME)
        CALL NORMEV(E2,NORME)
        CALL PROVEC(E1,E2,E3)
C
C       CALCUL DE LA MATRICE DE PASSAGE P TQ 'GLOBAL' = P * 'LOCAL'
        DO 124 I = 1,3
          P(I,1) = E1(I)
          P(I,2) = E2(I)
          P(I,3) = E3(I)
 124    CONTINUE
C
C       CALCUL DE L'INVERSE DE LA MATRICE DE PASSAGE : INV=TRANSPOSE(P)
        DO 125 I = 1,3
          DO 126 J = 1,3
            INVP(I,J) = P(J,I)
 126      CONTINUE
 125    CONTINUE
C
C       RECUPERATION DU TENSEUR DE COURBURE
        DO 127 I = 1,3
          DO 128 J = 1,3
            COURB(I,1,J) = ZR(ICOUR-1+3*(I-1)+J)
            COURB(I,2,J) = ZR(ICOUR-1+3*(I+3-1)+J)
            COURB(I,3,J) = ZR(ICOUR-1+3*(I+6-1)+J)
C
 128      CONTINUE
 127    CONTINUE
C       PRISE EN COMPTE DE LA COURBURE
        LCOUR = .TRUE.
C
C       COORDONN�ES POLAIRES DU POINT
        RG=SQRT(LSNG**2+LSTG**2)

        IF (RG.GT.R8PREM()) THEN
C         LE POINT N'EST PAS SUR LE FOND DE FISSURE
          PHIG = SIGN(1.D0,LSNG) * ABS(ATAN2(LSNG,LSTG))
          IRET=1
        ELSE
C         LE POINT EST SUR LE FOND DE FISSURE :
C         L'ANGLE N'EST PAS D�FINI, ON LE MET � Z�RO
C         ON NE FERA PAS LE CALCUL DES D�RIV�ES
          PHIG=0.D0
          IRET=0
        ENDIF
C
C       ON A PAS PU CALCULER LES DERIVEES DES FONCTIONS SINGULIERES
C       CAR ON SE TROUVE SUR LE FOND DE FISSURE
        CALL ASSERT(IRET.NE.0)

C
C       COEFFS  DE CALCUL
        CR1 = 1.D0 / (4.D0*MU*SQRT(DEPI*RG))
        CR2 = SQRT(RG) / (2.D0*MU*SQRT(DEPI))
C
C-----------------------------------------------------------------------
C       DEFINITION DU CHAMP SINGULIER AUXILIAIRE U1 ET SA DERIVEE
C-----------------------------------------------------------------------
C       CHAMP SINGULIER AUXILIAIRE U1 DANS LA BASE LOCALE
        U1L(1) = CR2 * COS(PHIG*0.5D0) * (KA-COS(PHIG))
        U1L(2) = CR2 * SIN(PHIG*0.5D0) * (KA-COS(PHIG))
        U1L(3) = 0.D0
C
C       MATRICE DES DERIVEES DE U1 DANS LA BASE POLAIRE (3X2)
        DU1DPO(1,1) = CR1 * (COS(PHIG*0.5D0)*(KA-COS(PHIG)))
        DU1DPO(2,1) = CR1 * (SIN(PHIG*0.5D0)*(KA-COS(PHIG)))
        DU1DPO(3,1) = 0.D0
        DU1DPO(1,2) =
     &    CR2 *
     &    (-0.5D0*SIN(PHIG*0.5D0)*(KA-COS(PHIG))+
     &     COS(PHIG*0.5D0)*SIN(PHIG))
        DU1DPO(2,2) =
     &    CR2 *
     &    (0.5D0*COS(PHIG*0.5D0)*(KA-COS(PHIG))+
     &     SIN(PHIG*0.5D0)*SIN(PHIG))
        DU1DPO(3,2) = 0.D0
C
C       MATRICE DES DERIVEES DE U1 DANS LA BASE LOCALE (3X3)
        DO 140 I = 1,3
          DU1DL(I,1) = COS(PHIG)*DU1DPO(I,1) - SIN(PHIG)/RG*DU1DPO(I,2)
          DU1DL(I,2) = SIN(PHIG)*DU1DPO(I,1) + COS(PHIG)/RG*DU1DPO(I,2)
          DU1DL(I,3) = 0.D0
 140    CONTINUE
C
C       U1 DANS LA BASE GLOBALE
        DO 500 I = 1,NDIM
          U1G(I) = 0.0D0
          DO 510 J = 1,NDIM
            U1G(I) = U1G(I) + P(I,J) * U1L(J)
 510      CONTINUE
        DU1DM(I,4) = U1G(I)
 500    CONTINUE
C
C       MATRICE DES DERIVEES DE U1 DANS LA BASE GLOBALE (3X3)
        DO 141 I = 1,NDIM
          DO 142 J = 1,NDIM
            DO 143 K = 1,NDIM
              DO 144 L = 1,NDIM
                DU1DM(I,J) = DU1DM(I,J) + DU1DL(K,L)*INVP(L,J)*INVP(K,I)
 144          CONTINUE
C             PRISE EN COMPTE DE LA BASE MOBILE
              IF (LCOUR) DU1DM(I,J) = DU1DM(I,J) + U1L(K)*COURB(K,I,J)
 143        CONTINUE
 142      CONTINUE
 141    CONTINUE
C
C-----------------------------------------------------------------------
C       DEFINITION DU CHAMP SINGULIER AUXILIAIRE U2 ET SA D�RIV�E
C-----------------------------------------------------------------------
C       CHAMP SINGULIER AUXILIAIRE U2 DANS LA BASE LOCALE
        U2L(1) = CR2 * SIN(PHIG*0.5D0) * (KA+2.D0+COS(PHIG))
        U2L(2) = CR2 * (-1.D0) * COS(PHIG*0.5D0) * (KA+2.D0+COS(PHIG))
        U2L(3) = 0.D0
C
C       MATRICE DES DERIVEES DE U2 DANS LA BASE POLAIRE (3X2)
        DU2DPO(1,1) = CR1 * (SIN(PHIG*0.5D0)*(KA+2.D0+COS(PHIG)))
        DU2DPO(2,1) = CR1 * (-COS(PHIG*0.5D0)*(KA-2.D0+COS(PHIG)))
        DU2DPO(3,1) = 0.D0
        DU2DPO(1,2) =
     &    CR2 *
     &    (0.5D0*COS(PHIG*0.5D0)*(KA+2.D0+COS(PHIG))-
     &     SIN(PHIG*0.5D0)*SIN(PHIG))
        DU2DPO(2,2) =
     &    CR2 *
     &    (0.5D0*SIN(PHIG*0.5D0)*(KA-2.D0+COS(PHIG))+
     &     COS(PHIG*0.5D0)*SIN(PHIG))
        DU2DPO(3,2) = 0.D0
C
C       MATRICE DES DERIVEES DE U2 DANS LA BASE LOCALE (3X3)
        DO 150 I = 1,3
          DU2DL(I,1) = COS(PHIG)*DU2DPO(I,1) - SIN(PHIG)/RG*DU2DPO(I,2)
          DU2DL(I,2) = SIN(PHIG)*DU2DPO(I,1) + COS(PHIG)/RG*DU2DPO(I,2)
          DU2DL(I,3) = 0.D0
 150    CONTINUE
C
C       U2 DANS LA BASE GLOBALE
        DO 600 I = 1,NDIM
          U2G(I) = 0.0D0
          DO 610 J = 1,NDIM
            U2G(I) = U2G(I) + P(I,J) * U2L(J)
 610      CONTINUE
        DU2DM(I,4) = U2G(I)
 600    CONTINUE
C
C       MATRICE DES DERIVEES DE U2 DANS LA BASE GLOBALE (3X3)
        DO 151 I = 1,NDIM
          DO 152 J = 1,NDIM
            DO 153 K = 1,NDIM
              DO 154 L = 1,NDIM
                DU2DM(I,J) = DU2DM(I,J) + DU2DL(K,L)*INVP(L,J)*INVP(K,I)
 154          CONTINUE
C             PRISE EN COMPTE DE LA BASE MOBILE
              IF (LCOUR) DU2DM(I,J) = DU2DM(I,J) + U2L(K)*COURB(K,I,J)
 153        CONTINUE
 152      CONTINUE
 151    CONTINUE
C
C-----------------------------------------------------------------------
C       D�FINITION DU CHAMP SINGULIER AUXILIAIRE U3 ET SA D�RIV�E
C-----------------------------------------------------------------------
C       CHAMP SINGULIER AUXILIAIRE U3 DANS LA BASE LOCALE
        U3L(1) = 0.D0
        U3L(2) = 0.D0
        U3L(3) = 4.D0 * CR2 * SIN(PHIG*0.5D0)
C
C       MATRICE DES DERIVEES DE U3 DANS LA BASE POLAIRE (3X2)
        DU3DPO(1,1) = 0.D0
        DU3DPO(2,1) = 0.D0
        DU3DPO(1,2) = 0.D0
        DU3DPO(2,2) = 0.D0
        DU3DPO(3,1) = 4.D0 * CR1 * SIN(PHIG*0.5D0)
        DU3DPO(3,2) = 2.D0 * CR2 * COS(PHIG*0.5D0)
C
C       MATRICE DES DERIVEES DE U3 DANS LA BASE LOCALE (3X3)
        DO 160 I = 1,3
          DU3DL(I,1) = COS(PHIG)*DU3DPO(I,1) - SIN(PHIG)/RG*DU3DPO(I,2)
          DU3DL(I,2) = SIN(PHIG)*DU3DPO(I,1) + COS(PHIG)/RG*DU3DPO(I,2)
          DU3DL(I,3) = 0.D0
 160    CONTINUE
C
C       U3 DANS LA BASE GLOBALE
        DO 700 I = 1,NDIM
          U3G(I) = 0.0D0
          DO 710 J = 1,NDIM
            U3G(I) = U3G(I) + P(I,J) * U3L(J)
 710      CONTINUE
        DU3DM(I,4) = U3G(I)
 700    CONTINUE
C
C       MATRICE DES DERIVEES DE U3 DANS LA BASE GLOBALE (3X3)
        DO 161 I = 1,NDIM
          DO 162 J = 1,NDIM
            DO 163 K = 1,NDIM
              DO 164 L = 1,NDIM
                DU3DM(I,J) = DU3DM(I,J) + DU3DL(K,L)*INVP(L,J)*INVP(K,I)
 164          CONTINUE
C             PRISE EN COMPTE DE LA BASE MOBILE
              IF (LCOUR) DU3DM(I,J) = DU3DM(I,J) + U3L(K)*COURB(K,I,J)
 163        CONTINUE
 162      CONTINUE
 161    CONTINUE
C-----------------------------------------------------------------------
C       CALCUL DE G, K1, K2, K2 AU POINT DE GAUSS
C-----------------------------------------------------------------------
C
        GUV = 0.D0
        CALL GBIL3D(DUDM,DUDM,DTDM,DFDM,DFDM,TGDM,TGDM,
     &              TTRG,TTRG,POIDS,C1,C2,C3,K3A,RHO,PULS,GUV)
        G = G + GUV
C
        GUV1 = 0.D0
        CALL GBIL3D(DUDM,DU1DM,DTDM,DFDM,DFVDM,TGDM,TGVDM,
     &              TTRG,TTRGV,POIDS,C1,C2,C3,K3A,RHO,PULS,GUV1)
        K1 = K1 + GUV1
C
        GUV2 = 0.D0
        CALL GBIL3D(DUDM,DU2DM,DTDM,DFDM,DFVDM,TGDM,TGVDM,
     &              TTRG,TTRGV,POIDS,C1,C2,C3,K3A,RHO,PULS,GUV2)
        K2 = K2 + GUV2
C
        GUV3 = 0.D0
        CALL GBIL3D(DUDM,DU3DM,DTDM,DFDM,DFVDM,TGDM,TGVDM,
     &              TTRG,TTRGV,POIDS,C1,C2,C3,K3A,RHO,PULS,GUV3)
        K3 = K3 + GUV3
C
 100  CONTINUE
C
 9999 CONTINUE
C
      K1 = K1 * COEFF
      K2 = K2 * COEFF
      K3 = K3 * COEFF3
C
      ZR(IGTHET)    = G
      ZR(IGTHET+1) = K1 / SQRT(COEFF)
      ZR(IGTHET+2) = K2 / SQRT(COEFF)
      ZR(IGTHET+3) = K3 / SQRT(COEFF3)
      ZR(IGTHET+4) = K1
      ZR(IGTHET+5) = K2
      ZR(IGTHET+6) = K3
C
      CALL JEDEMA
C
C FIN ------------------------------------------------------------------
      END
