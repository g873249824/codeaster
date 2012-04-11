      SUBROUTINE TE0292 (OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 10/04/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE DELMAS J.DELMAS
C
C     BUT:
C         CALCUL DE L'INDICATEUR D'ERREUR EN QUANTITE D'INTERET
C         SUR UN ELEMENT 2D AVEC LA METHODE DE ZHU-ZIENKIEWICZ.
C         OPTION : 'ERRE_QIZZ'
C
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
C
      INTEGER NNO,KP,NPG1,I,K,NNOS,JGANO,NDIM,MATER
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE,ISIEFP,ISIEFD
      INTEGER ISIGP,ISIGD,IERR,NIV,IBID,NBCMP

      REAL*8 DFDX(9),DFDY(9),DFDZ(9),POIDS,VALRES(2)
      REAL*8 SIGP11,SIGP22,SIGP33,SIGP12,SIGP13,SIGP23
      REAL*8 SIGD11,SIGD22,SIGD33,SIGD12,SIGD13,SIGD23
      REAL*8 R
      REAL*8 E,NU,NOR,NORSIG,NU0,EEST,HE

      INTEGER ICODRE(2)
      CHARACTER*4 FAMI
      CHARACTER*8 NOMRES(2)

      LOGICAL  LTEATT, LAXI
C
C ----------------------------------------------------------------------
      CALL JEMARQ()
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
C
      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      MATER=ZI(IMATE)
      NOMRES(1)='E'
      NOMRES(2)='NU'
      CALL JEVECH('PSIEFP_R','L',ISIEFP)
      CALL JEVECH('PSIEFD_R','L',ISIEFD)
      CALL JEVECH('PSIGMAP','L',ISIGP)
      CALL JEVECH('PSIGMAD','L',ISIGD)
      CALL JEVECH('PERREUR','E',IERR)
C
      NORSIG = 0.D0
      ZR(IERR) = 0.D0
C
C    BOUCLE SUR LES POINTS DE GAUSS
C
      DO 101 KP=1,NPG1
        K=(KP-1)*NNO

        IF (NDIM.EQ.2) THEN
          CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,POIDS)
          NBCMP=2
        ELSE IF (NDIM.EQ.3) THEN
          CALL DFDM3D(NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),DFDX,DFDY,
     &                DFDZ,POIDS)
          NBCMP=3
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

        IF ( LAXI ) THEN
           R = 0.D0
           DO 103 I=1,NNO
             R = R + ZR(IGEOM+2*(I-1)) * ZR(IVF+K+I-1)
103        CONTINUE
           POIDS = POIDS*R
        ENDIF
C
        SIGP11=0.D0
        SIGP22=0.D0
        SIGP33=0.D0
        SIGP12=0.D0
        SIGP13=0.D0
        SIGP23=0.D0
        SIGD11=0.D0
        SIGD22=0.D0
        SIGD33=0.D0
        SIGD12=0.D0
        SIGD13=0.D0
        SIGD23=0.D0
C
        DO 102 I=1,NNO
          SIGP11 = SIGP11 + ZR(ISIGP-1+NBCMP*(I-1)+1) * ZR(IVF+K+I-1)
          SIGP22 = SIGP22 + ZR(ISIGP-1+NBCMP*(I-1)+2) * ZR(IVF+K+I-1)
          SIGP33 = SIGP33 + ZR(ISIGP-1+NBCMP*(I-1)+3) * ZR(IVF+K+I-1)
          SIGP12 = SIGP12 + ZR(ISIGP-1+NBCMP*(I-1)+4) * ZR(IVF+K+I-1)
          SIGD11 = SIGD11 + ZR(ISIGD-1+NBCMP*(I-1)+1) * ZR(IVF+K+I-1)
          SIGD22 = SIGD22 + ZR(ISIGD-1+NBCMP*(I-1)+2) * ZR(IVF+K+I-1)
          SIGD33 = SIGD33 + ZR(ISIGD-1+NBCMP*(I-1)+3) * ZR(IVF+K+I-1)
          SIGD12 = SIGD12 + ZR(ISIGD-1+NBCMP*(I-1)+4) * ZR(IVF+K+I-1)
          IF (NDIM.EQ.3) THEN
            SIGP13 = SIGP13 + ZR(ISIGP-1+NBCMP*(I-1)+5) * ZR(IVF+K+I-1)
            SIGP23 = SIGP23 + ZR(ISIGP-1+NBCMP*(I-1)+6) * ZR(IVF+K+I-1)
            SIGD13 = SIGD13 + ZR(ISIGD-1+NBCMP*(I-1)+5) * ZR(IVF+K+I-1)
            SIGD23 = SIGD23 + ZR(ISIGD-1+NBCMP*(I-1)+6) * ZR(IVF+K+I-1)
          ENDIF
102     CONTINUE
C
        CALL RCVALB(FAMI,KP,1,'+',MATER,' ','ELAS',0,' ',0.D0,
     &              2,NOMRES, VALRES, ICODRE, 1)
        E  = VALRES(1)
        NU = VALRES(2)
C
C    ESTIMATION DE L'ERREUR EN NORME DE L' ENERGIE
C
        IF (NDIM.EQ.2) THEN
        EEST = ABS((SIGP11-ZR(ISIEFP-1+4*(KP-1)+1))
     &        *(SIGD11-ZR(ISIEFD-1+4*(KP-1)+1)))
     &        +ABS((SIGP22-ZR(ISIEFP-1+4*(KP-1)+2))
     &        *(SIGD22-ZR(ISIEFD-1+4*(KP-1)+2)))
     &        +ABS((SIGP33-ZR(ISIEFP-1+4*(KP-1)+3))
     &        *(SIGD33-ZR(ISIEFD-1+4*(KP-1)+3)))
     &        +ABS((SIGP12-ZR(ISIEFP-1+4*(KP-1)+4))
     &        *(SIGD12-ZR(ISIEFD-1+4*(KP-1)+4)))*(1.D0+NU)
C
        ZR(IERR) = ZR(IERR) + EEST * POIDS / E
C
C    NORME DE L' ENERGIE DE LA SOLUTION CALCULEE
C
        NOR    = ZR(ISIEFP-1+4*(KP-1)+1)**2
     &         + ZR(ISIEFP-1+4*(KP-1)+2)**2
     &         + ZR(ISIEFP-1+4*(KP-1)+3)**2
     &         +(1.D0+NU)*ZR(ISIEFP-1+4*(KP-1)+4)**2
        NORSIG = NORSIG + NOR * POIDS / E

        ELSE IF (NDIM.EQ.3) THEN
        EEST = ABS((SIGP11-ZR(ISIEFP-1+6*(KP-1)+1))
     &        *(SIGD11-ZR(ISIEFD-1+6*(KP-1)+1)))
     &        +ABS((SIGP22-ZR(ISIEFP-1+6*(KP-1)+2))
     &        *(SIGD22-ZR(ISIEFD-1+6*(KP-1)+2)))
     &        +ABS((SIGP33-ZR(ISIEFP-1+6*(KP-1)+3))
     &        *(SIGD33-ZR(ISIEFD-1+6*(KP-1)+3)))
     &        +ABS((SIGP12-ZR(ISIEFP-1+6*(KP-1)+4))
     &        *(SIGD12-ZR(ISIEFD-1+6*(KP-1)+4)))*(1.D0+NU)
     &        +ABS((SIGP13-ZR(ISIEFP-1+6*(KP-1)+5))
     &        *(SIGD13-ZR(ISIEFD-1+6*(KP-1)+5)))*(1.D0+NU)
     &        +ABS((SIGP23-ZR(ISIEFP-1+6*(KP-1)+6))
     &        *(SIGD23-ZR(ISIEFD-1+6*(KP-1)+6)))*(1.D0+NU)
C
          ZR(IERR) = ZR(IERR) + EEST * POIDS / E
C
C    NORME DE L' ENERGIE DE LA SOLUTION CALCULEE
C
          NOR    = ZR(ISIEFP-1+6*(KP-1)+1)**2
     &           + ZR(ISIEFP-1+6*(KP-1)+2)**2
     &           + ZR(ISIEFP-1+6*(KP-1)+3)**2
     &           +(1.D0+NU)*ZR(ISIEFP-1+6*(KP-1)+4)**2
     &           +(1.D0+NU)*ZR(ISIEFP-1+6*(KP-1)+5)**2
     &           +(1.D0+NU)*ZR(ISIEFP-1+6*(KP-1)+6)**2
          NORSIG = NORSIG + NOR * POIDS / E
        ELSE
           CALL ASSERT(.FALSE.)
        ENDIF
C
101   CONTINUE
C
      NIV=1 
      CALL UTHK(NOMTE,ZR(IGEOM),HE,NDIM,IBID,IBID,IBID,IBID,NIV,IBID)
C
      IF ((ZR(IERR)+NORSIG).NE.0.D0) THEN
        NU0 = 100.D0*SQRT(ZR(IERR)/(ZR(IERR)+NORSIG))
      ELSE
        NU0 = 0.D0
      ENDIF

      ZR(IERR  ) = SQRT(ZR(IERR))
      ZR(IERR+1) = NU0
      ZR(IERR+2) = SQRT(NORSIG)
      ZR(IERR-1+10)=HE
C
      CALL JEDEMA()
C
      END
