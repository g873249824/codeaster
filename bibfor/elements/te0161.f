      SUBROUTINE TE0161(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/04/2013   AUTEUR FLEJOU J-L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT       NONE
      INCLUDE       'jeveux.h'
      CHARACTER*16   OPTION,NOMTE
C --- ------------------------------------------------------------------
C                          CALCUL FORCES REPARTIES
C     NOMTE :
C        MECABL2
C        MECA_POU_D_T_GD
C    OPTION :
C        CHAR_MECA_FR1D1D
C        CHAR_MECA_FF1D1D
C        CHAR_MECA_SR1D1D
C        CHAR_MECA_SF1D1D'
C
C --- ------------------------------------------------------------------
      INTEGER        ICODRE,JJ
      INTEGER        NNO,KP,I,IVECTU,IPESA,NDDL,NPG,IYTY,NORDRE,LSECT
      INTEGER        IPOIDS,IVF,IGEOM,IMATE,IFORC
      INTEGER        ITEMPS,NBPAR,IDEPLA,IDEPLP,K,L,IC,NEU,IRET,NEUM1
      LOGICAL        NORMAL
      REAL*8         R8MIN,R8BID,RHO,A,COEF
      REAL*8         S,S2,S3,S4,S5,X(4),C1,C2(3),W(6),U(3),V(3),W2(3)

      INTEGER        IFCX, IDFDK, JGANO, NDIM, NNOS
      CHARACTER*8    NOMPAR(4),NOMPAV(1)
      REAL*8         VALPAV(1),FCX,VITE2,VP(3), BILINE, DDOT, R8MIEM
      LOGICAL        OKVENT,FOZERO
C --- ------------------------------------------------------------------
      DATA NOMPAR/'X','Y','Z','INST'/
      DATA NOMPAV/'VITE'/
C --- ------------------------------------------------------------------
      R8MIN = R8MIEM()
C
      IF (NOMTE.EQ.'MECA_POU_D_T_GD') THEN
         NDDL = 6
      ELSE
         NDDL = 3
      END IF
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDK,JGANO)
      CALL JEVETE('&INEL.CABPOU.YTY','L',IYTY)
C
      NORDRE = 3*NNO
C --- ------------------------------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
C --- ------------------------------------------------------------------
      IF (OPTION.EQ.'CHAR_MECA_PESA_R') THEN
         CALL JEVECH('PMATERC','L',IMATE)
         CALL JEVECH('PPESANR','L',IPESA)
         CALL RCVALB('FPG1',1,1,'+',ZI(IMATE),' ','ELAS',0,' ',R8BID,
     &               1,'RHO',RHO,ICODRE,1)
         IF (NOMTE.EQ.'MECA_POU_D_T_GD') THEN
            CALL JEVECH('PCAGNPO','L',LSECT)
         ELSE
            CALL JEVECH('PCACABL','L',LSECT)
         END IF
         A  = ZR(LSECT)
         C1 = A*RHO*ZR(IPESA)
         C2(1) = ZR(IPESA+1)
         C2(2) = ZR(IPESA+2)
         C2(3) = ZR(IPESA+3)
      END IF
C     PAR DEFAUT PAS DE VENT,  EFFORT DANS LE REPERE GLOBAL
      NORMAL = .FALSE.
      OKVENT = .FALSE.
C --- ------------------------------------------------------------------
      IF (OPTION.EQ.'CHAR_MECA_FR1D1D' .OR.
     &    OPTION.EQ.'CHAR_MECA_SR1D1D') THEN
         C1 = 1.0D0
C        POUR LE CAS DU VENT
         CALL TECACH('NNN','PVITER','L',1,IFORC,IRET)
         IF (IRET.EQ.0) THEN
            NORMAL = .TRUE.
            OKVENT = .TRUE.
         ELSE
            CALL JEVECH('PFR1D1D','L',IFORC)
            NORMAL = ABS(ZR(IFORC+6)) .GT. 1.001D0
         END IF
      END IF
C
C --- ------------------------------------------------------------------
      IF (OPTION.EQ.'CHAR_MECA_FF1D1D' .OR.
     &    OPTION.EQ.'CHAR_MECA_SF1D1D') THEN
         C1 = 1.0D0
         CALL JEVECH('PFF1D1D','L',IFORC)
         NORMAL = ZK8(IFORC+6) .EQ. 'VENT'
         CALL TECACH('NNN','PTEMPSR','L',1,ITEMPS,IRET)
         IF (IRET.EQ.0) THEN
            X(4) = ZR(ITEMPS)
            NBPAR = 4
         ELSE
            NBPAR = 3
         END IF
      END IF
C
C --- ------------------------------------------------------------------
      IF (OPTION.EQ.'CHAR_MECA_SR1D1D' .OR.
     &    OPTION.EQ.'CHAR_MECA_SF1D1D') THEN
         CALL JEVECH('PDEPLMR','L',IDEPLA)
         CALL JEVECH('PDEPLPR','L',IDEPLP)
         DO 10 I = 1,3
            W(I)   = ZR(IGEOM+I-1) + ZR(IDEPLA-1+I) + ZR(IDEPLP-1+I)
            W(I+3) = ZR(IGEOM+I+2) + ZR(IDEPLA-1+I+NDDL) +
     &               ZR(IDEPLP-1+I+NDDL)
            W2(I)  = W(I+3) - W(I)
10       CONTINUE
      ELSE
         DO 20 I = 1,3
            W(I)   = ZR(IGEOM+I-1)
            W(I+3) = ZR(IGEOM+I+2)
            W2(I)  = W(I+3) - W(I)
20       CONTINUE
      END IF
C
C --- ------------------------------------------------------------------
C --- FORCES REPARTIES PAR VALEURS REELLES
      IF (OPTION.EQ.'CHAR_MECA_FR1D1D') THEN
C        PAS DE MOMENT REPARTIS
         R8BID = SQRT(DDOT(3,ZR(IFORC+3),1,ZR(IFORC+3),1))
         IF (R8BID.GT.R8MIN)  THEN
            CALL U2MESK('F','ELEMENTS3_1', 1, NOMTE)
         ENDIF
C
         C2(1) = ZR(IFORC)
         C2(2) = ZR(IFORC+1)
         C2(3) = ZR(IFORC+2)
         IF (NORMAL) THEN
            S=DDOT(3,C2,1,C2,1)
            S4 = SQRT(S)
            IF (S4.GT.R8MIN) THEN
               S=DDOT(3,W2,1,W2,1)
               S2 = 1.D0/S
               CALL PROVEC(W2,C2,U)
               S=DDOT(3,U,1,U,1)
               S3 = SQRT(S)
               S5 = S3*SQRT(S2)/S4
               CALL PROVEC(U,W2,V)
               CALL PSCVEC(3,S2,V,U)
               CALL PSCVEC(3,S5,U,C2)
            END IF
         END IF
      END IF
C
C --- ------------------------------------------------------------------
      DO 80 KP = 1,NPG
         K = (KP-1)*NORDRE*NORDRE
         L = (KP-1)*NNO
         IF (OPTION.EQ.'CHAR_MECA_FF1D1D' .OR.
     &       OPTION.EQ.'CHAR_MECA_SF1D1D') THEN
C           PAS DE MOMENT REPARTIS
            FOZERO = (ZK8(IFORC+3).NE.'&FOZERO').OR.
     &               (ZK8(IFORC+4).NE.'&FOZERO').OR.
     &               (ZK8(IFORC+5).NE.'&FOZERO')
            IF ( FOZERO ) THEN
               CALL U2MESK('F','ELEMENTS3_1', 1, NOMTE)
            ENDIF
C
            DO 40 IC = 1,3
               X(IC) = 0.D0
               DO 30 NEU = 1,NNO
                  X(IC) = X(IC) + W(3*NEU+IC-3)*ZR(IVF+L+NEU-1)
30             CONTINUE
40          CONTINUE
            DO 50 IC = 1,3
               CALL FOINTE('FM',ZK8(IFORC+IC-1),NBPAR,
     &                     NOMPAR,X,C2(IC),IRET)
50          CONTINUE
            IF (NORMAL) THEN
               S=DDOT(3,C2,1,C2,1)
               S4 = SQRT(S)
               IF (S4.GT.R8MIN) THEN
                  S=DDOT(3,W2,1,W2,1)
                  S2 = 1.D0/S
                  CALL PROVEC(W2,C2,U)
                  S=DDOT(3,U,1,U,1)
                  S3 = SQRT(S)
                  S5 = S3*SQRT(S2)/S4
                  CALL PROVEC(U,W2,V)
                  CALL PSCVEC(3,S2,V,U)
                  CALL PSCVEC(3,S5,U,C2)
               END IF
            END IF
         END IF
         IF (OKVENT) THEN
C           RECUPERATION DE LA VITESSE DE VENT RELATIVE AU NOEUD
            C2(1) = ZR(IFORC)
            C2(2) = ZR(IFORC+1)
            C2(3) = ZR(IFORC+2)
C           CALCUL DU VECTEUR VITESSE PERPENDICULAIRE
            S=DDOT(3,C2,1,C2,1)
            S4 = SQRT(S)
            FCX = 0.0D0
            IF (S4.GT.R8MIN) THEN
               S=DDOT(3,W2,1,W2,1)
               S2 = 1.D0/S
               CALL PROVEC(W2,C2,U)
               CALL PROVEC(U,W2,V)
               CALL PSCVEC(3,S2,V,VP)
C              NORME DE LA VITESSE PERPENDICULAIRE
               VITE2=DDOT(3,VP,1,VP,1)
               VALPAV(1) = SQRT(VITE2)
               IF (VALPAV(1).GT.R8MIN) THEN
C                 RECUPERATION DE L'EFFORT EN FONCTION DE LA VITESSE
                  CALL TECACH('ONN','PVENTCX','L',1,IFCX,IRET)
                  IF (IRET.NE.0) THEN
                     CALL U2MESS('F','ELEMENTS3_39')
                  ENDIF
                  IF (ZK8(IFCX)(1:1).EQ.'.') THEN
                     CALL U2MESS('F','ELEMENTS3_39')
                  ENDIF
                  CALL FOINTE('FM',ZK8(IFCX),1,NOMPAV,VALPAV,FCX,IRET)
                  FCX = FCX/VALPAV(1)
               END IF
            END IF
            CALL PSCVEC(3,FCX,VP,C2)
         END IF
C
         COEF = ZR(IPOIDS-1+KP)*C1*SQRT(BILINE(NORDRE,ZR(IGEOM),
     &          ZR(IYTY+K),ZR(IGEOM)))
         DO 70 NEU = 1,NNO
            NEUM1 = NEU - 1
            DO 60 IC = 1,3
               JJ = IVECTU+NDDL*NEUM1+(IC-1)
               ZR(JJ) = ZR(JJ) + COEF*C2(IC)*ZR(IVF+L+NEUM1)
60          CONTINUE
70       CONTINUE
80    CONTINUE
      END
