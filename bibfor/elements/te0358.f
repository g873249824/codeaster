      SUBROUTINE TE0358(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2005   AUTEUR CIBHHPD L.SALMONA 
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
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_MECA_META_Z  '
C                          POUR LES ELEMENTS 3D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................


C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      PARAMETER (NBRES=21)
      CHARACTER*16 COMPOR
      CHARACTER*8 NOMRES(NBRES),NOMCLE(5)
      CHARACTER*2 CODRET(NBRES),TEST
      REAL*8 VALRES(NBRES),E,NU
      REAL*8 ZFBM,SIG(6),KPT(5),SIGDV(6),DEUXMU
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),TPG,POIDS
      REAL*8 KRON(6),R8BID,PHAS(5),RPRIM,COEF,R0(5),TRANS,VI(5)
      REAL*8 PHASM(7),PHASP(7)

      INTEGER JGANO,NNO,KP,K,L,NPG1,I,ITEMPE,IVECTU,NDIM
      INTEGER IPOIDS,IVF,IDFDE,JPROL,JVALE,NBVAL
      INTEGER IGEOM,IMATE,JTAB(7)

      DATA KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
C ---------------------------------------------------------------------
C --- FONCTIONS DE FORMES ET POINTS DE GAUSS
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

C PARAMETRES EN ENTREE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      MATER = ZI(IMATE)
      COMPOR = ZK16(ICOMPO+7)

      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PPHASMR','L',IPHASM)
      CALL JEVECH('PPHASPR','L',IPHASP)
      CALL JEVECH('PCONTMR','L',ICONTR)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      COMPOR = ZK16(ICOMPO+7)
      CALL TECACH('OON','PVARIPR',7,JTAB,IRET)
      LGPG = MAX(JTAB(6),1)*JTAB(7)
      CALL JEVECH('PVARIPR','L',IVARI)
      CALL JEVECH('PVECTUR','E',IVECTU)

      IF (COMPOR(1:5).EQ.'ACIER') THEN

        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NOMRES(3) = 'F1_K'
        NOMRES(4) = 'F2_K'
        NOMRES(5) = 'F3_K'
        NOMRES(6) = 'F4_K'
        NOMRES(7) = 'F1_D_F_M'
        NOMRES(8) = 'F2_D_F_M'
        NOMRES(9) = 'F3_D_F_M'
        NOMRES(10) = 'F4_D_F_M'
        NOMRES(11) = 'SY_MELAN'

        IF (ZK16(ICOMPO) (1:9).EQ.'META_P_IL' .OR.
     &      ZK16(ICOMPO) (1:9).EQ.'META_V_IL' .OR.
     &      ZK16(ICOMPO) (1:9).EQ.'META_P_CL' .OR.
     &      ZK16(ICOMPO) (1:9).EQ.'META_V_CL') THEN
          NOMRES(12) = 'F1_D_SIGM'
          NOMRES(13) = 'F2_D_SIGM'
          NOMRES(14) = 'F3_D_SIGM'
          NOMRES(15) = 'F4_D_SIGM'
          NOMRES(16) = 'C_D_SIGM'
        END IF
        IF (ZK16(ICOMPO) (1:10).EQ.'META_P_INL' .OR.
     &      ZK16(ICOMPO) (1:10).EQ.'META_V_INL') THEN
          NOMCLE(1) = 'SIGM_F1'
          NOMCLE(2) = 'SIGM_F2'
          NOMCLE(3) = 'SIGM_F3'
          NOMCLE(4) = 'SIGM_F4'
          NOMCLE(5) = 'SIGM_C'
        END IF
        NOMRES(17) = 'F1_ETA'
        NOMRES(18) = 'F2_ETA'
        NOMRES(19) = 'F3_ETA'
        NOMRES(20) = 'F4_ETA'
        NOMRES(21) = 'C_ETA'

      ELSE IF (COMPOR(1:4).EQ.'ZIRC') THEN
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NOMRES(3) = 'F1_K'
        NOMRES(4) = 'F2_K'
        NOMRES(5) = 'F1_D_F_ME'
        NOMRES(6) = 'F2_D_F_ME'
        NOMRES(7) = 'SY_MELAN'

        IF (ZK16(ICOMPO) (1:9).EQ.'META_P_IL' .OR.
     &      ZK16(ICOMPO) (1:9).EQ.'META_V_IL') THEN
          NOMRES(8) = 'F1_D_SIGM'
          NOMRES(9) = 'F2_D_SIGM'
          NOMRES(10) = 'C_D_SIGM'
        END IF
        IF (ZK16(ICOMPO) (1:10).EQ.'META_P_INL' .OR.
     &      ZK16(ICOMPO) (1:10).EQ.'META_V_INL') THEN
          NOMCLE(1) = 'SIGM_F1'
          NOMCLE(2) = 'SIGM_F2'
          NOMCLE(3) = 'SIGM_C'
        END IF
        NOMRES(14) = 'F1_ETA'
        NOMRES(15) = 'F2_ETA'
        NOMRES(16) = 'C_ETA'

      END IF
      DO 10 I = 1,NBRES
        CODRET(I) = '  '
   10 CONTINUE

      DO 140 KP = 1,NPG1
        ICPG = 6* (KP-1)
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE, 
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        K = (KP-1)*NNO
        TPG = 0.D0
        DO 15 I=1,7
          PHASM(I)=0.D0
           PHASP(I)=0.D0
 15     CONTINUE
 
        DO 20 I = 1,NNO
          TPG = TPG + ZR(ITEMPE+I-1)*ZR(IVF+K+I-1)
          
C passage de PHASMR et PHASPR aux points de Gauss
          IF (COMPOR(1:5) .EQ. 'ACIER') THEN
            DO 7 L=1,7
               PHASM(L)=PHASM(L) + ZR(IPHASM+7*(I-1)+L-1)*ZR(IVF+K+I-1)
               PHASP(L)=PHASP(L) + ZR(IPHASP+7*(I-1)+L-1)*ZR(IVF+K+I-1)
    7       CONTINUE
          ELSEIF (COMPOR(1:4) .EQ. 'ZIRC') THEN
            DO 9 L=1,3
               PHASM(L)=PHASM(L) + ZR(IPHASM+3*(I-1)+L-1)*ZR(IVF+K+I-1)
               PHASP(L)=PHASP(L) + ZR(IPHASP+3*(I-1)+L-1)*ZR(IVF+K+I-1)
    9       CONTINUE   
          ENDIF
          
   20   CONTINUE
        CALL RCVALA(MATER,' ','ELAS_META',1,'TEMP',TPG,2,NOMRES,VALRES,
     &              CODRET,'FM')
        E = VALRES(1)
        NU = VALRES(2)
        DEUXMU = E/ (1.D0+NU)

        IF (COMPOR(1:5).EQ.'ACIER') THEN

          CALL RCVALA(MATER,' ','META_PT',1,'TEMP',TPG,4,NOMRES(3),
     &                VALRES(3),CODRET(3),' ')

          DO 30 I = 3,6
            IF (CODRET(I).NE.'OK') THEN
              KPT(I-2) = 0.D0
            ELSE
              KPT(I-2) = VALRES(I)
            END IF
   30     CONTINUE

          ZFBM = PHASP(1)
          DO 40 I = 1,3
             ZFBM = ZFBM + PHASP(1+I)
   40     CONTINUE

          TRANS = 0.D0
          DO 50 I = 1,4
            ZVARIM = PHASM(I)
            ZVARIP = PHASP(I)
            DELTAZ = (ZVARIP-ZVARIM)
            IF (DELTAZ.GT.0) THEN
              J = 6 + I
              CALL RCVALA(MATER,' ','META_PT',1,'META',ZFBM,1,NOMRES(J),
     &                    VALRES(J),CODRET(J),'  ')
              IF (CODRET(J).NE.'OK') VALRES(J) = 0.D0

              TRANS = TRANS + KPT(I)*VALRES(J)*DELTAZ
            END IF
   50     CONTINUE

          CALL RCVALA(MATER,' ','META_VISC',5,'TEMP',TPG,1,NOMRES(17),
     &                VALRES(17),CODRET(17),' ')
          TEST = 'NO'
          DO 60 I = 17,21
            IF (CODRET(I).EQ.'OK') TEST = 'OK'
   60     CONTINUE
          IF ((ZR(IVARI+ (KP-1)*LGPG+5).GT.0.5D0) .AND.
     &        (TEST.EQ.'NO')) THEN

            CALL RCVALA(MATER,' ','ELAS_META',1,'META',ZFBM,1,
     &                NOMRES(11),  VALRES(11),CODRET(11),'  ')
            IF (CODRET(11).NE.'OK') THEN
              VALRES(11) = ZFBM
            END IF


            PHAS(1) = PHASP(1)
            PHAS(2) = PHASP(2)
            PHAS(3) = PHASP(3)
            PHAS(4) = PHASP(4)
            PHAS(5) = 1.D0 - (PHAS(1)+PHAS(2)+PHAS(3)+PHAS(4))

            IF (ZK16(ICOMPO) (1:9).EQ.'META_P_IL' .OR.
     &          ZK16(ICOMPO) (1:9).EQ.'META_V_IL') THEN

              CALL RCVALA(MATER,' ','META_ECRO_LINE',1,'TEMP',TPG,5,
     &                    NOMRES(12),VALRES(12),CODRET(12),'FM')
              R0(1) = VALRES(12)*E/ (E-VALRES(12))
              R0(2) = VALRES(13)*E/ (E-VALRES(13))
              R0(3) = VALRES(14)*E/ (E-VALRES(14))
              R0(4) = VALRES(15)*E/ (E-VALRES(15))
              R0(5) = VALRES(16)*E/ (E-VALRES(16))
            END IF
            IF (ZK16(ICOMPO) (1:9).EQ.'META_P_CL' .OR.
     &          ZK16(ICOMPO) (1:9).EQ.'META_V_CL') THEN
              CALL RCVALA(MATER,' ','META_ECRO_LINE',1,'TEMP',TPG,5,
     &                    NOMRES(12),VALRES(12),CODRET(12),'FM')
              R0(1) = (2.D0/3.D0)*VALRES(12)*E/ (E-VALRES(12))
              R0(2) = (2.D0/3.D0)*VALRES(13)*E/ (E-VALRES(13))
              R0(3) = (2.D0/3.D0)*VALRES(14)*E/ (E-VALRES(14))
              R0(4) = (2.D0/3.D0)*VALRES(15)*E/ (E-VALRES(15))
              R0(5) = (2.D0/3.D0)*VALRES(16)*E/ (E-VALRES(16))
            END IF

            IF (ZK16(ICOMPO) (1:10).EQ.'META_P_INL' .OR.
     &          ZK16(ICOMPO) (1:10).EQ.'META_V_INL') THEN
              VI(1) = ZR(IVARI+ (KP-1)*LGPG)
              VI(2) = ZR(IVARI+ (KP-1)*LGPG+1)
              VI(3) = ZR(IVARI+ (KP-1)*LGPG+2)
              VI(4) = ZR(IVARI+ (KP-1)*LGPG+3)
              VI(5) = ZR(IVARI+ (KP-1)*LGPG+4)
              DO 70 I = 1,5
                CALL RCTRAC(MATER,'META_TRACTION',NOMCLE(I),TPG,JPROL,
     &                      JVALE,NBVAL,R8BID)
                CALL RCFONC('V','META_TRACTION',JPROL,JVALE,NBVAL,R8BID,
     &                      R8BID,R8BID,VI(I),R8BID,R0(I),R8BID,R8BID,
     &                      R8BID)
   70         CONTINUE
            END IF

            IF (ZFBM.GT.0.D0) THEN
              RPRIM = PHAS(1)*R0(1) + PHAS(2)*R0(2) + PHAS(3)*R0(3) +
     &                PHAS(4)*R0(4)
              RPRIM = RPRIM/ZFBM
            ELSE
              RPRIM = 0.D0
            END IF
            RPRIM = (1.D0-VALRES(11))*R0(5) + VALRES(11)*RPRIM
            COEF = 1.D0 - (1.5D0*DEUXMU)/ (1.5D0*DEUXMU+RPRIM)

          ELSE
            COEF = 1.D0
          END IF

        ELSE IF (COMPOR(1:4).EQ.'ZIRC') THEN
          CALL RCVALA(MATER,' ','META_PT',1,'TEMP',TPG,2,NOMRES(3),
     &                VALRES(3),CODRET(3),' ')

          DO 80 I = 3,4
            IF (CODRET(I).NE.'OK') THEN
              KPT(I-2) = 0.D0
            ELSE
              KPT(I-2) = VALRES(I)
            END IF
   80     CONTINUE

          ZALPHA = PHASP(1) + PHASP(2)


          ZVARIM = PHASM(1)
          ZVARIP = PHASP(1)
          DELTAZ = (ZVARIP-ZVARIM)

          TRANS = 0.D0
          IF (DELTAZ.GT.0) THEN
            CALL RCVALA(MATER,' ','META_PT',1,'META',ZFBM,1,NOMRES(5),
     &                  VALRES(5),CODRET(5),'  ')
            IF (CODRET(5).NE.'OK') VALRES(5) = 0.D0

            TRANS = TRANS + KPT(1)*VALRES(5)*DELTAZ
          END IF


          ZVARIM = PHASM(2)
          ZVARIP = PHASP(2)
          DELTAZ = (ZVARIP-ZVARIM)
          IF (DELTAZ.GT.0) THEN

            CALL RCVALA(MATER,' ','META_PT',1,'META',ZFBM,1,NOMRES(6),
     &                  VALRES(6),CODRET(6),'  ')
            IF (CODRET(6).NE.'OK') VALRES(6) = 0.D0

            TRANS = TRANS + KPT(2)*VALRES(6)*DELTAZ
          END IF


          CALL RCVALA(MATER,' ','META_VISC',3,'TEMP',TPG,1,NOMRES(14),
     &                VALRES(14),CODRET(14),' ')
          TEST = 'NO'
          DO 90 I = 14,16
            IF (CODRET(14).EQ.'OK') TEST = 'OK'
   90     CONTINUE
          IF ((ZR(IVARI+ (KP-1)*LGPG+3).GT.0.5D0) .AND.
     &        (TEST.EQ.'NO')) THEN

            CALL RCVALA(MATER,' ','ELAS_META',1,'META',ZALPHA,1,
     &                 NOMRES(7), VALRES(7),CODRET(7),'  ')
            IF (CODRET(7).NE.'OK') THEN
              VALRES(7) = ZALPHA
            END IF

            PHAS(1) = PHASP(1)
            PHAS(2) = PHASP(2)

            PHAS(3) = 1.D0 - (PHAS(1)+PHAS(2))

            IF (ZK16(ICOMPO) (1:9).EQ.'META_P_IL' .OR.
     &          ZK16(ICOMPO) (1:9).EQ.'META_V_IL') THEN
              CALL RCVALA(MATER,' ','META_ECRO_LINE',1,'TEMP',TPG,3,
     &                    NOMRES(8),VALRES(8),CODRET(8),'FM')
              R0(1) = VALRES(8)*E/ (E-VALRES(8))
              R0(2) = VALRES(9)*E/ (E-VALRES(9))
              R0(3) = VALRES(10)*E/ (E-VALRES(10))
            END IF
            IF (ZK16(ICOMPO) (1:9).EQ.'META_P_CL' .OR.
     &          ZK16(ICOMPO) (1:9).EQ.'META_V_CL') THEN
              CALL RCVALA(MATER,' ','META_ECRO_LINE',1,'TEMP',TPG,5,
     &                    NOMRES(8),VALRES(8),CODRET(8),'FM')
              R0(1) = (2.D0/3.D0)*VALRES(8)*E/ (E-VALRES(8))
              R0(2) = (2.D0/3.D0)*VALRES(9)*E/ (E-VALRES(9))
              R0(3) = (2.D0/3.D0)*VALRES(10)*E/ (E-VALRES(10))

            END IF

            IF (ZK16(ICOMPO) (1:10).EQ.'META_P_INL' .OR.
     &          ZK16(ICOMPO) (1:10).EQ.'META_V_INL') THEN
              VI(1) = ZR(IVARI+ (KP-1)*LGPG)
              VI(2) = ZR(IVARI+ (KP-1)*LGPG+1)
              VI(3) = ZR(IVARI+ (KP-1)*LGPG+2)

              DO 100 I = 1,3
                CALL RCTRAC(MATER,'META_TRAC_ZIRC',NOMCLE(I),TPG,JPROL,
     &                      JVALE,NBVAL,R8BID)
                CALL RCFONC('V','META_TRAC_ZIRC',JPROL,JVALE,NBVAL,
     &                      R8BID,R8BID,R8BID,VI(I),R8BID,R0(I),R8BID,
     &                      R8BID,R8BID)
  100         CONTINUE
            END IF

            IF (ZALPHA.GT.0.D0) THEN
              RPRIM = PHAS(1)*R0(1) + PHAS(2)*R0(2)
              RPRIM = RPRIM/ZALPHA
            ELSE
              RPRIM = 0.D0
            END IF
            RPRIM = (1.D0-VALRES(7))*R0(3) + VALRES(7)*RPRIM
            COEF = 1.D0 - (1.5D0*DEUXMU)/ (1.5D0*DEUXMU+RPRIM)

          ELSE
            COEF = 1.D0
          END IF
        END IF


        SIGMO = 0.D0
        DO 110 I = 1,3
          SIGMO = SIGMO + ZR(ICONTR+ICPG+I-1)
  110   CONTINUE
        SIGMO = SIGMO/3.D0
        DO 120 I = 1,6
          SIGDV(I) = ZR(ICONTR+ICPG+I-1) - SIGMO*KRON(I)
          SIG(I) = COEF* (+1.5D0*TRANS*SIGDV(I))
          SIG(I) = DEUXMU*SIG(I)
  120   CONTINUE
        DO 130 I = 1,NNO
          ZR(IVECTU+3* (I-1)) = ZR(IVECTU+3* (I-1)) +
     &                          POIDS* (SIG(1)*DFDX(I)+SIG(4)*DFDY(I)+
     &                          SIG(5)*DFDZ(I))
          ZR(IVECTU+3* (I-1)+1) = ZR(IVECTU+3* (I-1)+1) +
     &                            POIDS* (SIG(2)*DFDY(I)+SIG(4)*DFDX(I)+
     &                            SIG(6)*DFDZ(I))
          ZR(IVECTU+3* (I-1)+2) = ZR(IVECTU+3* (I-1)+2) +
     &                            POIDS* (SIG(3)*DFDZ(I)+SIG(5)*DFDX(I)+
     &                            SIG(6)*DFDY(I))
  130   CONTINUE
  140 CONTINUE
      END
