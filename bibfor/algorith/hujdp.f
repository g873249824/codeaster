      SUBROUTINE HUJDP (MOD, DEPS, SIGD, SIGF, MATER,
     &                  VIN, NDEC, IRET)
      IMPLICIT NONE
C          CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR FOUCAULT A.FOUCAULT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C       ---------------------------------------------------------------
C       TESTS SUR LES CRITERES D'EVOLUTION RELATIFS AUX CONTRAINTES
C       IN  DEPS   :  INCREMENT DE DEFORMATION
C           SIGD   :  CONTRAINTE  A T
C           SIGF   :  CONTRAINTE ELASTIQUE A T+DT
C           MATER  :  PROPRIETES MATERIAU
C       OUT NDEC   :  NOMBRE DE REDECOUPAGE DE DEPS
C           IRET   :  CODE RETOUR
C       ---------------------------------------------------------------
      INTEGER     NDT, NDI, I, J, NDEC, IRET, INDI(7), NBMECA 
      REAL*8      DI1D, I1D, N, PREF, K0, NI
      REAL*8      DEPS(6), SIGD(6), SIGF(6)
      REAL*8      MATER(22,2), TOLE1, TOL, RI, VIN(*)
      REAL*8      ZERO, UN, D13, DEUX, DEPSV, COEF 
      REAL*8      EPSVP, BETA, D, FR, I1E 
      REAL*8      DFDS(6), E, NU, AL, LA, DEMU 
      REAL*8      HOOKNL(6,6), DSIG(6), FIDSIG   
      REAL*8      PCO, RATIO, PF, PD, QF, QD, TAUF(3)
      REAL*8      TAUD(3), RELA1, RELA2
      REAL*8      PISO, MAX, C11, C12, C13, C22, C23, C33
      REAL*8      E1,E2,E3,NU12,NU13,NU23,G1,G2,G3,NU21,NU31,NU32,DELTA
      REAL*8      YF(18), SIGDC(3), PRODD, PRODF, MAT(6,6)
      REAL*8      M, DEGR, B, PHI, PTRAC
      CHARACTER*8   MOD
      LOGICAL     DEBUG

      COMMON /TDIM/ NDT, NDI
      COMMON /MESHUJ/ DEBUG

      PARAMETER   ( DEGR = 0.0174532925199D0 )

      DATA ZERO, D13, UN, DEUX, TOL
     &/ 0.D0, 0.33333333333334D0, 1.D0, 2.D0, 1.D-6 /

      IF (NDEC.GT.1) THEN
        IRET =1
        GOTO 500
      ENDIF

C      PISO  = 1.5D0*MATER(21,2)
      PISO  = ZERO
      PREF  = MATER(8,2)
      N     = MATER(1,2)
      BETA  = MATER(2,2)
      D     = MATER(3,2)
      PCO   = MATER(7,2)
      PHI   = MATER(5,2)
      M     = SIN(DEGR*PHI)
      B     = MATER(4,2)
      PTRAC = MATER(21,2)
      EPSVP = VIN(23)
      DEPSV = DEPS(1)+DEPS(2)+DEPS(3)       
      TOLE1 = 0.05D0


C ----------------------------------------------------
C 1 --- CRITERE LIMITANT L EVOLUTION DE P: DP/P < TOLE1
C ----------------------------------------------------
      I1D   = D13*(SIGD(1)+SIGD(2)+SIGD(3))
      IF (MATER(17,1).EQ.UN) THEN
      
        K0   = D13*MATER(1,1) /(UN-DEUX*MATER(2,1))
        DEPSV= DEPS(1)+DEPS(2)+DEPS(3)
        DI1D = DEPSV*K0*((I1D -PISO)/PREF)**N
      
      ELSEIF (MATER(17,1).EQ.DEUX) THEN
      
        E1   = MATER(1,1)*((I1D -PISO)/PREF)**N
        E2   = MATER(2,1)*((I1D -PISO)/PREF)**N
        E3   = MATER(3,1)*((I1D -PISO)/PREF)**N
        NU12 = MATER(4,1)
        NU13 = MATER(5,1)
        NU23 = MATER(6,1)
        NU21 = MATER(13,1)
        NU31 = MATER(14,1)
        NU32 = MATER(15,1)
        DELTA= MATER(16,1)
        
        C11 = (UN - NU23*NU32)*E1/DELTA
        C12 = (NU21 + NU31*NU23)*E1/DELTA
        C13 = (NU31 + NU21*NU32)*E1/DELTA
        C22 = (UN - NU13*NU31)*E2/DELTA
        C23 = (NU32 + NU31*NU12)*E2/DELTA
        C33 = (UN - NU21*NU12)*E3/DELTA
        
        DI1D = (C11+C12+C13)*DEPS(1) + (C12+C22+C23)*DEPS(2)
     &         + (C13+C23+C33)*DEPS(3)
        DI1D = D13*DI1D
        
      ELSE
          CALL U2MESS('F', 'COMPOR1_35')
      ENDIF
      
      IF ((I1D/PREF) .GT. TOL) THEN
        RI = DI1D /I1D
      ELSEIF ((-PISO/PREF) .GT. TOL) THEN
        RI = DI1D /(-PISO)
      ELSE
        RI = ZERO
        WRITE(6,'(A)')'HUJDP :: DP/P NON CONTROLE CAR P VOISIN DE ZERO'
      ENDIF
      
      IF (RI.GT.UN) THEN
        RI = UN
      ELSEIF (RI.LT.TOLE1) THEN
        RI = TOLE1
      ENDIF
      NDEC = NINT(RI/TOLE1)   


C ----------------------------------------------------------------      
C 2 --- CRITERE A RESPECTER POUR L EVOLUTION DU MECANISME ISOTROPE
C   ---         FR/(DFDS*C*DEPS)*TOLE1 > TETA = 1/RI             
C ====================================================================
C -------------------- 2.1 CONSTRUCTION DE C -------------------------
C ====================================================================
      CALL LCINMA (ZERO, HOOKNL)
      I1E  = D13*(SIGF(1)+SIGF(2)+SIGF(3))
      
      IF (MOD(1:2) .EQ. '3D'     .OR.
     &    MOD(1:6) .EQ. 'D_PLAN' .OR.
     &    MOD(1:4) .EQ. 'AXIS')  THEN
     
        IF (MATER(17,1).EQ.UN) THEN
      
          E    = MATER(1,1)*((I1E -PISO)/PREF)**N
          NU   = MATER(2,1)
          AL   = E*(UN-NU) /(UN+NU) /(UN-DEUX*NU)
          DEMU = E     /(UN+NU)
          LA   = E*NU/(UN+NU)/(UN-DEUX*NU)

          DO 30 I = 1, NDI
            DO 30 J = 1, NDI
              IF (I.EQ.J) HOOKNL(I,J) = AL
              IF (I.NE.J) HOOKNL(I,J) = LA
 30           CONTINUE
          DO 35 I = NDI+1, NDT
            HOOKNL(I,I) = DEMU
 35         CONTINUE
 
        ELSEIF (MATER(17,1).EQ.DEUX) THEN
      
          E1   = MATER(1,1)*((I1E -PISO)/PREF)**N
          E2   = MATER(2,1)*((I1E -PISO)/PREF)**N
          E3   = MATER(3,1)*((I1E -PISO)/PREF)**N
          NU12 = MATER(4,1)
          NU13 = MATER(5,1)
          NU23 = MATER(6,1)
          G1   = MATER(7,1)*((I1E -PISO)/PREF)**N
          G2   = MATER(8,1)*((I1E -PISO)/PREF)**N
          G3   = MATER(9,1)*((I1E -PISO)/PREF)**N
          NU21 = MATER(13,1)
          NU31 = MATER(14,1)
          NU32 = MATER(15,1)
          DELTA= MATER(16,1)
         
          HOOKNL(1,1) = (UN - NU23*NU32)*E1/DELTA
          HOOKNL(1,2) = (NU21 + NU31*NU23)*E1/DELTA
          HOOKNL(1,3) = (NU31 + NU21*NU32)*E1/DELTA
          HOOKNL(2,2) = (UN - NU13*NU31)*E2/DELTA
          HOOKNL(2,3) = (NU32 + NU31*NU12)*E2/DELTA
          HOOKNL(3,3) = (UN - NU21*NU12)*E3/DELTA
          HOOKNL(2,1) = HOOKNL(1,2)
          HOOKNL(3,1) = HOOKNL(1,3)
          HOOKNL(3,2) = HOOKNL(2,3)
          HOOKNL(4,4) = G1
          HOOKNL(5,5) = G2
          HOOKNL(6,6) = G3
        
        ELSE
          CALL U2MESS('F', 'COMPOR1_35')
        ENDIF

      ELSEIF (MOD(1:6) .EQ. 'C_PLAN' .OR.
     &        MOD(1:2) .EQ. '1D')   THEN
     
        CALL U2MESS('F', 'COMPOR1_4')
     
      ENDIF
        
      CALL LCPRMV (HOOKNL, DEPS, DSIG)


C ====================================================================
C -------------- 2.2 CALCUL DE FIDSIG = DFDS*DSIG --------------------
C ====================================================================

C 1- MECANISME ISOTROPE
      FIDSIG = ZERO
      DO 40 I = 1, NDI
        FIDSIG = FIDSIG - D13*DSIG(I)
 40     CONTINUE
      FR = D*PCO*EXP(-BETA*EPSVP)
      RI = ABS(FIDSIG/FR)

      IF (RI.GT.UN) THEN
        RI = UN
      ELSEIF (RI.LT.TOLE1) THEN
        RI = TOLE1
      ENDIF
      NI = NINT(RI/TOLE1)   
      IF (NDEC.LT.NI) NDEC = NI

C 2- MECANISME DEVIATOIRE
      DO 41 I = 1, NDT
        DFDS(I) = ZERO
 41     CONTINUE

      DO 42 I = 1, 18
        YF(I) = ZERO
 42     CONTINUE

      DO 43 I = 1, 7
        INDI(I) = 0
 43     CONTINUE

      YF(7) = EPSVP
      CALL LCEQVN(NDT, SIGD,YF)

      NBMECA = 0
      DO 44 I = 1, 8
        IF (VIN(23+I).EQ.UN) THEN
          NBMECA = NBMECA + 1
          INDI(NBMECA) = I
          YF(NDT+1+NBMECA) = VIN(I)
        ELSEIF ((VIN(23+I).EQ.ZERO).AND.(I.LT.5)) THEN
          NBMECA = NBMECA + 1
          INDI(NBMECA) = I
          YF(NDT+1+NBMECA) = VIN(I)
        ENDIF          
 44   CONTINUE

      DO 47 I = 1, 3

        CALL HUJPRJ(I, SIGD, TAUD, PD, QD)

        IF ((VIN(23+I).EQ.UN).OR.(VIN(23+I).EQ.ZERO)) THEN
          CALL HUJDDD('DFDS  ',I,MATER,INDI, YF, VIN, 
     &                 DFDS, MAT, IRET)
          FR = -M*(PD-PTRAC)*(UN-B*LOG((PD-PTRAC)/
     &         (PCO*EXP(-BETA*EPSVP))))*VIN(I)

        ELSEIF (VIN(27+I).EQ.UN) THEN
          CALL HUJDDD('DFDS  ',I+4,MATER,INDI, YF, VIN,
     &                 DFDS, MAT, IRET)
          FR = -M*(PD-PTRAC)*(UN-B*LOG((PD-PTRAC)/
     &         (PCO*EXP(-BETA*EPSVP))))*VIN(I+4)

        ENDIF

        FIDSIG = 0
        DO 46 J = 1, NDT
          FIDSIG = FIDSIG + DFDS(J)*DSIG(J)
 46       CONTINUE  

        RI = ABS(FIDSIG/FR)
        IF (RI.GT.UN) THEN
          RI = UN
        ELSEIF (RI.LT.TOLE1) THEN
          RI = TOLE1
        ENDIF
        NI = NINT(RI/TOLE1)   
        IF (NDEC.LT.NI) NDEC = NI

 47     CONTINUE

C -------------------------------------------------------
C 3 --- CRITERE LIMITANT L EVOLUTION DE Q: DQ/PREF < TOLE1
C -------------------------------------------------------    
      DO 45 I = 1, 3
      
C 1- CAS DEVIATOIRE CYCLIQUE
        IF (VIN(27+I).EQ.UN) THEN      
C --- INITIALISATION DES VARIABLES NECESSAIRES A PROD/Q(K)        
C --- AVEC PROD = PRODUIT SCALAIRE (SIGDC*TH)
          CALL LCEQVN (NDT, SIGF, YF)
          YF(8) = VIN(4+I) 
          CALL HUJPRC (1, I, SIGF, VIN, MATER, YF, PF, QF, SIGDC)
          PRODF = SIGDC(1)*VIN(4*I+7)+SIGDC(3)*VIN(4*I+8)/DEUX
          PRODF = QF+PRODF
          CALL LCEQVN (NDT, SIGD, YF)
          CALL HUJPRC (1, I, SIGD, VIN, MATER, YF, PD, QD, SIGDC)
          PRODD = SIGDC(1)*VIN(4*I+7)+SIGDC(3)*VIN(4*I+8)/DEUX
          PRODD = QD+PRODD
          
          IF ((QD.LT.TOL).OR.(PRODF.LT.TOL)) THEN
            RI = ZERO
          ELSE
            RI = ABS(UN-QF*PRODD/QD/PRODF)
          ENDIF   
          IF (RI.GT.UN) THEN
            RI = UN
          ELSEIF (RI.LT.TOLE1) THEN
            RI = TOLE1
          ENDIF
          NI = NINT(RI/TOLE1)
          IF (NDEC.LT.NI) NDEC = NI

C 2- CAS DEVIATOIRE MONOTONE
        ELSE 
          CALL HUJPRJ(I, SIGD, TAUD, PD, QD)
          CALL HUJPRJ(I, SIGF, TAUF, PF, QF)
          FR = M*(PD -PTRAC)*
     &    (UN-B*LOG((PD-PTRAC)/PCO*EXP(-BETA*EPSVP)))*VIN(I)
     
          IF (ABS(FR/PREF).LT.TOL) THEN
            RI =ZERO
          ELSE  
            RI =ABS((QF-QD)/FR)
          ENDIF
        
          RELA1 = ZERO
          RELA2 = ZERO
          IF (ABS(FR/PREF).GT.TOL) THEN
            RELA1 = ABS((TAUF(1)-TAUD(1))/FR)
            RELA2 = ABS((TAUF(3)-TAUD(3))/FR)
          ENDIF
          IF (RELA1.GT.RI) RI = RELA1
          IF (RELA2.GT.RI) RI = RELA2        

          IF (RI.GT.UN) THEN
            RI = UN
          ELSEIF (RI.LT.TOLE1) THEN
            RI = TOLE1
          ENDIF
          NI = NINT(RI/TOLE1)
          IF (NDEC.LT.NI) NDEC = NI
        ENDIF 

 45   CONTINUE

CKH ----
CKH ON CONTROLE L'INCREMENT DE CONTRAINTE: DS/S- <= 10%
CKH
      PRODD  = 0.D0
      PRODF  = 0.D0
      
      DO 451 I = 1, NDT
        PRODD = PRODD + SIGD(I)**DEUX
        PRODF = PRODF + (SIGF(I)-SIGD(I))**DEUX
451   CONTINUE
      PRODD = SQRT(PRODD)
      PRODF = SQRT(PRODF)
      
C      TOLE1 = 0.1
      IF ((-PRODD/PREF) .GT. TOL) THEN
        RI = PRODF/PRODD/TOLE1
        IF (RI .GT. 1.D0) THEN
          NI = INT(RI)
          IF (NDEC.LT.NI) NDEC = NI
C            WRITE (6,'(A,I6)') 'HUJDP :: NSUBD =',NI
        ENDIF
      ENDIF
C      IF (NDEC.GT.1) WRITE (6,'(A,I4)') ' NDEC =',NDEC
      
 500  CONTINUE
      END
