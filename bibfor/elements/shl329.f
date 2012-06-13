      SUBROUTINE SHL329
      IMPLICIT NONE
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C....................................................................
C   CALCUL DES TERMES ELEMENTAIRES DE L'ACCEPTANCE
C     OPTION : ACCEPTANCE
C....................................................................
C
      INCLUDE 'jeveux.h'
      CHARACTER*7   IELEM,IMODE
      CHARACTER*24  VETEL
      REAL*8        SX(9,9),SY(9,9),SZ(9,9),JAC(9)
      REAL*8        NX(9),NY(9),NZ(9),NORM(3,9),ACC(3,9)
      REAL*8        FLUFN(9),ACLOC(3,8),QSI,ETA,ZERO,UN
      REAL*8        X(3,9),FF(4,4),DFDX(4,4),DFDY(4,4)
      INTEGER       IGEOM,IPG,IADZI,IAZK24,IVETEL
      INTEGER       IACCE,IHARM,IVECTU,I,K,IDIM,INO,JNO,J
      INTEGER  NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
C
C DEB ------------------------------------------------------------------
C
      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
C
      CALL JEVECH('PACCELR','L',IACCE)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PNUMMOD','L',IHARM)
      CALL JEVECH('PVECTUR','E',IVECTU)
C
      ZERO = 0.0D0
      UN   = 1.0D0
C
      DO 1200 I=1,NNO
         ACLOC(1,I)=ZERO
         ACLOC(2,I)=ZERO
         ACLOC(3,I)=ZERO
1200  CONTINUE
C
        K=0
        DO 1201 I=1,NNO
          DO 20 IDIM=1,3
            K=K+1
            ACLOC(IDIM,I) = ZR(IACCE+K-1)
20        CONTINUE
1201    CONTINUE
C
       DO 1052 IPG=1,NPG
          ACC(1,IPG)=ZERO
          ACC(2,IPG)=ZERO
          ACC(3,IPG)=ZERO
1052   CONTINUE
C
       DO 1061 IPG=1,NPG

          QSI = ZR(ICOOPG-1+NDIM*(IPG-1)+1)
          ETA = ZR(ICOOPG-1+NDIM*(IPG-1)+2)

          FF(1,IPG)= (UN-QSI)*(UN-ETA)/4.D0
          FF(2,IPG)= (UN+QSI)*(UN-ETA)/4.D0
          FF(3,IPG)= (UN+QSI)*(UN+ETA)/4.D0
          FF(4,IPG)= (UN-QSI)*(UN+ETA)/4.D0
C
          DFDX(1,IPG)= -(UN-ETA)/4.D0
          DFDX(2,IPG)=  (UN-ETA)/4.D0
          DFDX(3,IPG)=  (UN+ETA)/4.D0
          DFDX(4,IPG)= -(UN+ETA)/4.D0
C
          DFDY(1,IPG)= -(UN-QSI)/4.D0
          DFDY(2,IPG)= -(UN+QSI)/4.D0
          DFDY(3,IPG)=  (UN+QSI)/4.D0
          DFDY(4,IPG)=  (UN-QSI)/4.D0

1061   CONTINUE

C     CALCUL DES PRODUITS VECTORIELS OMI X OMJ
C
      DO 21 INO = 1,NNO
         I = IGEOM + 3*(INO-1) -1
         DO 22 JNO = 1,NNO
            J = IGEOM + 3*(JNO-1) -1
            SX(INO,JNO) = ZR(I+2) * ZR(J+3) - ZR(I+3) * ZR(J+2)
            SY(INO,JNO) = ZR(I+3) * ZR(J+1) - ZR(I+1) * ZR(J+3)
            SZ(INO,JNO) = ZR(I+1) * ZR(J+2) - ZR(I+2) * ZR(J+1)
22       CONTINUE
21    CONTINUE
C
C     BOUCLE SUR LES POINTS DE GAUSS

      DO 101 IPG=1,NPG
         NX(IPG) = ZERO
         NY(IPG) = ZERO
         NZ(IPG) = ZERO
         DO 102 I=1,NNO
            DO 104 J=1,NNO
              NX(IPG) = NX(IPG) + DFDX(I,IPG)*DFDY(J,IPG)*SX(I,J)
              NY(IPG) = NY(IPG) + DFDX(I,IPG)*DFDY(J,IPG)*SY(I,J)
              NZ(IPG) = NZ(IPG) + DFDX(I,IPG)*DFDY(J,IPG)*SZ(I,J)
104        CONTINUE
102      CONTINUE

C      CALCUL DU JACOBIEN AU POINT DE GAUSS IPG

         JAC(IPG) = SQRT (NX(IPG)*NX(IPG) + NY(IPG)*NY(IPG)
     &                                    + NZ(IPG)*NZ(IPG))

C       CALCUL DE LA NORMALE UNITAIRE

          NORM(1,IPG) = NX(IPG)/JAC(IPG)
          NORM(2,IPG) = NY(IPG)/JAC(IPG)
          NORM(3,IPG) = NZ(IPG)/JAC(IPG)
101     CONTINUE

C
       DO 1051 IPG=1,NPG
         DO 105 I=1,NNO
           ACC(1,IPG) = ACC(1,IPG) + ACLOC(1,I)*FF(I,IPG)
           ACC(2,IPG) = ACC(2,IPG) + ACLOC(2,I)*FF(I,IPG)
           ACC(3,IPG) = ACC(3,IPG) + ACLOC(3,I)*FF(I,IPG)
105      CONTINUE
1051   CONTINUE

C    CALCUL DE COORDONNEES AUX POINTS DE GAUSS

           DO 90 IPG=1,NPG
             X(1,IPG)=ZERO
             X(2,IPG)=ZERO
             X(3,IPG)=ZERO
              DO 91 J=1,NNO
                X(1,IPG)= X(1,IPG) + ZR(IGEOM+3*(J-1)-1+1)*FF(J,IPG)
                X(2,IPG)= X(2,IPG) + ZR(IGEOM+3*(J-1)-1+2)*FF(J,IPG)
                X(3,IPG)= X(3,IPG) + ZR(IGEOM+3*(J-1)-1+3)*FF(J,IPG)
91            CONTINUE

C CALCUL DU FLUX FLUIDE NORMAL AUX POINTS DE GAUSS

                FLUFN(IPG) = ACC(1,IPG)*NORM(1,IPG)+ACC(2,IPG)*
     &               NORM(2,IPG)+ACC(3,IPG)*NORM(3,IPG)

90        CONTINUE

C STOCKAGE DU FLUX FLUIDE DANS UN VECTEUR INDEXE
C PAR LE MODE ET L'ELEMENT

         IMODE='CHBIDON'
         IELEM ='CHBIDON'
         CALL CODENT(ZI(IHARM),'D0',IMODE)
         CALL TECAEL(IADZI,IAZK24)
         CALL CODENT(ZI(IADZI),'D0',IELEM)
         VETEL = '&&329.M'//IMODE//'.EL'//IELEM
C        ON CONSERVE L'ALLOCATION DYNAMIQUE AU DETRIMENT DE L'ALLOCATION
C        STATIQUE, CAR VETEL EST UTILIE A L'EXTERIEUR DES ROUTINES
C        ELEMENTAIRES
         CALL WKVECT(VETEL,'V V R8',4*NPG,IVETEL)
         DO 100 IPG=0,NPG-1
             ZR(IVETEL+4*IPG) = JAC(IPG+1)*FLUFN(IPG+1)
             ZR(IVETEL+4*IPG+1) = X(1,IPG+1)
             ZR(IVETEL+4*IPG+2) = X(2,IPG+1)
             ZR(IVETEL+4*IPG+3) = X(3,IPG+1)
100       CONTINUE

       END
