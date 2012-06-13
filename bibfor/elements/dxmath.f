      SUBROUTINE DXMATH(FAMI,EPAIS,DF,DM,DMF,PGL,MULTIC,INDITH,
     &                  T2EV,T2VE,T1VE,NPG)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER MULTIC,INDITH,NPG,NPGH
      REAL*8 DF(3,3),DM(3,3),DMF(3,3),DMC(3,2),DFC(3,2)
      REAL*8 PGL(3,3),T2EV(4),T2VE(4),T1VE(9)
      CHARACTER*4 FAMI
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
C     CALCUL DES MATRICES DE COEFFCIENTS THERMOELASTIQUES DE FLEXION,
C     MEMBRANE, COUPLAGE MEMBRANE-FLEXION POUR UN MATERIAU ISOTROPE OU
C     MULTICOUCHE
C     OUT MULTIC :
C        1 POUR UN MATERIAU MULTICOUCHE SANS COUPLAGE MEMBRANE-FLEXION
C        2 POUR UN MATERIAU MULTICOUCHE AVEC COUPLAGE MEMBRANE-FLEXION
C        0 DANS LES AUTRES CAS
C     LA VARIABLE INDITH EST INITIALISEE A 0
C     DANS LE CAS OU LE COEFFICIENT DE DILATATION ALPHA N'A
C     PAS ETE DONNE, INDITH VAUT -1 ET ON  NE CALCULE PAS LES
C     CONTRAINTES THERMIQUES
C     ------------------------------------------------------------------
      INTEGER JCOQU,JMATE,IRET
      INTEGER NBV,I,J,K,NBPAR,ELASCO,INDALF
      REAL*8 CDF,CDM,VALRES(56)
      REAL*8 YOUNG,NU,EPAIS,VALPAR,EXCENT
      REAL*8 XAB1(3,3),DH(3,3)
      REAL*8 DX,DY,DZ,S,C,NORM
      REAL*8 PS,PJDX,PJDY,PJDZ,ALPHAT
      REAL*8 ALPHA,BETA,R8DGRD,R8PREM
      REAL*8 DEUX
      INTEGER ICODRE(56)
      CHARACTER*3 NUM
      CHARACTER*8 NOMRES(56),NOMPAR
      CHARACTER*10 PHENOM
C     ------------------------------------------------------------------

      DEUX = 2.0D0
      CALL R8INIR(9,0.D0,DM,1)
      CALL R8INIR(9,0.D0,DF,1)
      CALL R8INIR(9,0.D0,DH,1)
      CALL R8INIR(9,0.D0,DMF,1)
      CALL R8INIR(6,0.D0,DMC,1)
      CALL R8INIR(6,0.D0,DFC,1)

      CALL JEVECH('PCACOQU','L',JCOQU)
      EPAIS = ZR(JCOQU)
      ALPHA = ZR(JCOQU+1)*R8DGRD()
      BETA  = ZR(JCOQU+2)*R8DGRD()
      EXCENT= ZR(JCOQU+4)

      DX = COS(BETA)*COS(ALPHA)
      DY = COS(BETA)*SIN(ALPHA)
      DZ = SIN(BETA)
      NORM = SQRT(DX*DX+DY*DY+DZ*DZ)
      DX = DX/NORM
      DY = DY/NORM
      DZ = DZ/NORM
      PS = DX*PGL(3,1) + DY*PGL(3,2) + DZ*PGL(3,3)
      PJDX = DX - PS*PGL(3,1)
      PJDY = DY - PS*PGL(3,2)
      PJDZ = DZ - PS*PGL(3,3)
      NORM = SQRT(PJDX*PJDX+PJDY*PJDY+PJDZ*PJDZ)
C     ------------------------------------------------
      INDITH = 0
      CALL JEVECH('PMATERC','L',JMATE)
      CALL RCCOMA(ZI(JMATE),'ELAS',PHENOM,ICODRE)
      IF (PHENOM.EQ.'ELAS_COQMU') THEN
        IF (NORM.LE.R8PREM()) THEN
          CALL U2MESS('F','ELEMENTS_39')
        END IF
C          CALCUL DES MATRICE T1VE ET T2VE DE PASSAGE D'UNE MATRICE
C          (3,3) ET (2,2) DU REPERE DE LA VARIETE AU REPERE ELEMENT
C          ET T2VE INVERSE DE T2EV
        PJDX = PJDX/NORM
        PJDY = PJDY/NORM
        PJDZ = PJDZ/NORM
        C = PJDX*PGL(1,1) + PJDY*PGL(1,2) + PJDZ*PGL(1,3)
        S = PJDX*PGL(2,1) + PJDY*PGL(2,2) + PJDZ*PGL(2,3)
        T2EV(1) = C
        T2EV(2) = S
        T2EV(3) = -S
        T2EV(4) = C
        T2VE(1) = C
        T2VE(2) = -S
        T2VE(3) = S
        T2VE(4) = C
        T1VE(1) = C*C
        T1VE(4) = S*S
        T1VE(7) = C*S
        T1VE(2) =  T1VE(4)
        T1VE(5) =  T1VE(1)
        T1VE(8) = -T1VE(7)
        T1VE(3) = -T1VE(7) - T1VE(7)
        T1VE(6) =  T1VE(7) + T1VE(7)
        T1VE(9) =  T1VE(1) - T1VE(4)
        NBV = 56
        DO 10 I = 1,NBV
          CALL CODENT(I,'G',NUM)
          NOMRES(I) = 'HOM_'//NUM
   10   CONTINUE

      ELSE IF (PHENOM.EQ.'ELAS') THEN
        IF (NORM.LE.R8PREM()) THEN
          CALL U2MESS('A','ELEMENTS_40')
        END IF
        NBV = 3
        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'
        NOMRES(3) = 'ALPHA'
CCC        CALL DXREPE ( PGL, T2EV, T2VE, T1VE )

      ELSE IF (PHENOM.EQ.'ELAS_COQUE') THEN
        IF (NORM.LE.R8PREM()) THEN
          CALL U2MESS('A','ELEMENTS_40')
        END IF

C        CALCUL DES MATRICE T1VE ET T2VE DE PASSAGE D'UNE MATRICE
C        (3,3) ET (2,2) DU REPERE DE LA VARIETE AU REPERE ELEMENT
C        ET T2VE INVERSE DE T2EV
        PJDX = PJDX/NORM
        PJDY = PJDY/NORM
        PJDZ = PJDZ/NORM
        C = PJDX*PGL(1,1) + PJDY*PGL(1,2) + PJDZ*PGL(1,3)
        S = PJDX*PGL(2,1) + PJDY*PGL(2,2) + PJDZ*PGL(2,3)
        T2EV(1) = C
        T2EV(2) = S
        T2EV(3) = -S
        T2EV(4) = C
        T2VE(1) = C
        T2VE(2) = -S
        T2VE(3) = S
        T2VE(4) = C
        T1VE(1) = C*C
        T1VE(4) = S*S
        T1VE(7) = C*S
        T1VE(2) =  T1VE(4)
        T1VE(5) =  T1VE(1)
        T1VE(8) = -T1VE(7)
        T1VE(3) = -T1VE(7) - T1VE(7)
        T1VE(6) =  T1VE(7) + T1VE(7)
        T1VE(9) =  T1VE(1) - T1VE(4)

C
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &              PHENOM,0,' ',0.0D0,1,'MEMB_L  ',
     &              VALRES(1),ICODRE,0)
        IF (ICODRE(1).EQ.1) THEN
          CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &                PHENOM,0,' ',0.0D0,1,'M_LLLL  ',
     &                VALRES(1),ICODRE,0)
          IF (ICODRE(1).EQ.1) THEN
            CALL U2MESS('F','ELEMENTS_41')
          ELSE
            ELASCO = 2
          ENDIF
        ELSE
          ELASCO = 1
        ENDIF
        IF (ELASCO.EQ.1) THEN
          NBV = 10
          NOMRES(1) = 'MEMB_L  '
          NOMRES(2) = 'MEMB_LT '
          NOMRES(3) = 'MEMB_T  '
          NOMRES(4) = 'MEMB_G_L'
          NOMRES(5) = 'FLEX_L  '
          NOMRES(6) = 'FLEX_LT '
          NOMRES(7) = 'FLEX_T  '
          NOMRES(8) = 'FLEX_G_L'
          NOMRES(9) = 'CISA_L  '
          NOMRES(10) = 'CISA_T  '
          NOMRES(11) = 'ALPHA   '
        ELSEIF (ELASCO.EQ.2) THEN
          NBV        = 33
          MULTIC     =  2
          NOMRES(1)  = 'M_LLLL  '
          NOMRES(2)  = 'M_LLTT  '
          NOMRES(3)  = 'M_LLLT  '
          NOMRES(4)  = 'M_TTTT  '
          NOMRES(5)  = 'M_TTLT  '
          NOMRES(6)  = 'M_LTLT  '
          NOMRES(7)  = 'F_LLLL  '
          NOMRES(8)  = 'F_LLTT  '
          NOMRES(9)  = 'F_LLLT  '
          NOMRES(10) = 'F_TTTT  '
          NOMRES(11) = 'F_TTLT  '
          NOMRES(12) = 'F_LTLT  '
          NOMRES(13) = 'MF_LLLL '
          NOMRES(14) = 'MF_LLTT '
          NOMRES(15) = 'MF_LLLT '
          NOMRES(16) = 'MF_TTTT '
          NOMRES(17) = 'MF_TTLT '
          NOMRES(18) = 'MF_LTLT '
          NOMRES(19) = 'MC_LLLZ '
          NOMRES(20) = 'MC_LLTZ '
          NOMRES(21) = 'MC_TTLZ '
          NOMRES(22) = 'MC_TTTZ '
          NOMRES(23) = 'MC_LTLZ '
          NOMRES(24) = 'MC_LTTZ '
          NOMRES(25) = 'FC_LLLZ '
          NOMRES(26) = 'FC_LLTZ '
          NOMRES(27) = 'FC_TTLZ '
          NOMRES(28) = 'FC_TTTZ '
          NOMRES(29) = 'FC_LTLZ '
          NOMRES(30) = 'FC_LTTZ '
          NOMRES(31) = 'C_LZLZ  '
          NOMRES(32) = 'C_LZTZ  '
          NOMRES(33) = 'C_TZTZ  '
          NOMRES(34) = 'ALPHA   '
        ENDIF
      ELSE
        CALL U2MESS('F','ELEMENTS_42')
      END IF

C===============================================================
C     -- RECUPERATION DE LA TEMPERATURE POUR LE MATERIAU:

      NPGH=3
      CALL MOYTEM(FAMI,NPG,NPGH,'+',VALPAR,IRET)
      NBPAR = 1
      NOMPAR = 'TEMP'
C===============================================================

      IF (PHENOM.EQ.'ELAS') THEN
C        ------ MATERIAU ISOTROPE ------------------------------------

        MULTIC = 0

        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &              PHENOM,NBPAR,NOMPAR,VALPAR,2,NOMRES,
     &              VALRES,ICODRE,1)
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &             PHENOM,NBPAR,NOMPAR,VALPAR,1,
     &             NOMRES(3), VALRES(3),ICODRE(3),0)
        IF ((ICODRE(3).NE.0).OR.(VALRES(3).EQ.0.D0)) THEN
          INDITH = -1
          GO TO 90
        END IF
        YOUNG = VALRES(1)
        NU = VALRES(2)
        ALPHAT = VALRES(3)
        YOUNG = YOUNG*ALPHAT

C      ---- CALCUL DE LA MATRICE DE RIGIDITE EN FLEXION --------------
        CDF = YOUNG*EPAIS*EPAIS*EPAIS/12.D0/ (1.D0-NU*NU)
        DF(1,1) = CDF
        DF(1,2) = CDF*NU
        DF(2,1) = DF(1,2)
        DF(2,2) = DF(1,1)
C      ---- CALCUL DE LA MATRICE DE RIGIDITE EN MEMBRANE -------------
        CDM = EPAIS*YOUNG/ (1.D0-NU*NU)
        DM(1,1) = CDM
        DM(1,2) = CDM*NU
        DM(2,1) = DM(1,2)
        DM(2,2) = DM(1,1)
C      --- CALCUL DE LA MATRICE DE COUPLAGE MEMBRANE-FLEXION --------
C      --- ET REACTUALISATION DE LA MATRICE DE FLEXION       --------
C      --- DANS LE CAS D'UN EXCENTREMENT                     --------
        DO 50 I = 1, 3
        DO 50 J = 1, 3
          DMF(I,J) =                  EXCENT*DM(I,J)
          DF (I,J) = DF(I,J) + EXCENT*EXCENT*DM(I,J)
  50    CONTINUE

C        ---------------------------------------------------------------
      ELSE IF (PHENOM.EQ.'ELAS_COQUE') THEN
        MULTIC = 0
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &              PHENOM,NBPAR,NOMPAR,VALPAR,NBV,NOMRES,
     &              VALRES,ICODRE,1)
        IF (ELASCO.EQ.1) THEN
          INDALF = 11
        ELSEIF (ELASCO.EQ.2) THEN
          INDALF = 34
        ENDIF
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &              PHENOM,NBPAR,NOMPAR,VALPAR,1,
     &              NOMRES(INDALF),VALRES(INDALF),ICODRE(INDALF),0)
        IF ((ICODRE(INDALF).NE.0).OR.(VALRES(INDALF).EQ.0.D0)) THEN
          INDITH = -1
          GO TO 90
        END IF
        ALPHAT = VALRES(INDALF)
C
        IF (ELASCO.EQ.1) THEN
C        ---- CALCUL DE LA MATRICE DE RIGIDITE EN MEMBRANE -------------
          DM(1,1) = VALRES(1)*ALPHAT
          DM(1,2) = VALRES(2)*ALPHAT
          DM(2,1) = DM(1,2)
          DM(2,2) = VALRES(3)*ALPHAT
C        ---- CALCUL DE LA MATRICE DE RIGIDITE EN FLEXION --------------
          DF(1,1) = VALRES(5)*ALPHAT
          DF(1,2) = VALRES(6)*ALPHAT
          DF(2,1) = DF(1,2)
          DF(2,2) = VALRES(7)*ALPHAT
C
        ELSEIF (ELASCO.EQ.2) THEN
C
          MULTIC = 2
C        ---- CALCUL DE LA MATRICE DE RIGIDITE EN MEMBRANE -------------
          DM(1,1) = VALRES(1)*ALPHAT
          DM(1,2) = VALRES(2)*ALPHAT
          DM(1,3) = VALRES(3)*ALPHAT
          DM(2,1) = DM(1,2)
          DM(3,1) = DM(1,3)
          DM(2,2) = VALRES(4)*ALPHAT
          DM(2,3) = VALRES(5)*ALPHAT
          DM(3,3) = VALRES(6)*ALPHAT
C        ---- CALCUL DE LA MATRICE DE RIGIDITE EN FLEXION --------------
          DF(1,1) = VALRES(7)*ALPHAT
          DF(1,2) = VALRES(8)*ALPHAT
          DF(1,3) = VALRES(9)*ALPHAT
          DF(2,1) = DF(1,2)
          DF(3,1) = DF(1,3)
          DF(2,2) = VALRES(10)*ALPHAT
          DF(2,3) = VALRES(11)*ALPHAT
          DF(3,2) = DF(2,3)
          DF(3,3) = VALRES(12)*ALPHAT
C        --- COUPLAGE  MEMBRANE FLEXION --------------------------------
          DMF(1,1) = VALRES(13)*ALPHAT
          DMF(1,2) = VALRES(14)*ALPHAT
          DMF(1,3) = VALRES(15)*ALPHAT
          DMF(2,1) = DMF(1,2)
          DMF(3,1) = DMF(1,3)
          DMF(2,2) = VALRES(16)*ALPHAT
          DMF(2,3) = VALRES(17)*ALPHAT
          DMF(3,2) = DMF(2,3)
          DMF(3,3) = VALRES(18)*ALPHAT
C
        ENDIF
C        --- CALCUL DE LA MATRICE DE COUPLAGE MEMBRANE-FLEXION --------
C        --- REACTUALISATION DE LA MATRICE DE FLEXION          --------
C        --- DANS LE CAS D'UN EXCENTREMENT                     --------
          DO 60 I = 1, 3
          DO 60 J = 1, 3
            DF(I,J) = DF(I,J)+DEUX*EXCENT*DMF(I,J)+EXCENT*EXCENT*DM(I,J)
            DMF(I,J)= DMF(I,J)                    +       EXCENT*DM(I,J)
  60      CONTINUE
C        ----------- MATRICES DANS LE REPERE INTRINSEQUE DE L'ELEMENT --

        CALL UTBTAB('ZERO',3,3, DM,T1VE,XAB1,DM)
        CALL UTBTAB('ZERO',3,3, DF,T1VE,XAB1,DF)
        CALL UTBTAB('ZERO',3,3,DMF,T1VE,XAB1,DMF)

      ELSE IF (PHENOM.EQ.'ELAS_COQMU') THEN
C        ------ MATERIAU MULTICOUCHE -----------------------------------
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &             PHENOM,NBPAR,NOMPAR,VALPAR,1,
     &             NOMRES(19), VALRES(19),ICODRE(19),0)
        EPAIS = VALRES(19)
        CALL RCVALB(FAMI,1,1,'+',ZI(JMATE),' ',
     &              PHENOM,NBPAR,NOMPAR,VALPAR,27,
     &              NOMRES(30),VALRES(30),ICODRE(30),0)
        DM(1,1) = VALRES(30)
        DM(1,2) = VALRES(31)
        DM(1,3) = VALRES(32)
        DM(2,1) = VALRES(33)
        DM(2,2) = VALRES(34)
        DM(2,3) = VALRES(35)
        DM(3,1) = VALRES(36)
        DM(3,2) = VALRES(37)
        DM(3,3) = VALRES(38)
        DMF(1,1) = VALRES(39)
        DMF(1,2) = VALRES(40)
        DMF(1,3) = VALRES(41)
        DMF(2,1) = VALRES(42)
        DMF(2,2) = VALRES(43)
        DMF(2,3) = VALRES(44)
        DMF(3,1) = VALRES(45)
        DMF(3,2) = VALRES(46)
        DMF(3,3) = VALRES(47)
        DF(1,1) = VALRES(48)
        DF(1,2) = VALRES(49)
        DF(1,3) = VALRES(50)
        DF(2,1) = VALRES(51)
        DF(2,2) = VALRES(52)
        DF(2,3) = VALRES(53)
        DF(3,1) = VALRES(54)
        DF(3,2) = VALRES(55)
        DF(3,3) = VALRES(56)
C
C        --- CALCUL DE LA MATRICE DE COUPLAGE MEMBRANE-FLEXION --------
C        --- REACTUALISATION DE LA MATRICE DE FLEXION          --------
C        --- DANS LE CAS D'UN EXCENTREMENT                     --------
          DO 70 I = 1, 3
          DO 70 J = 1, 3
            DF(I,J) = DF(I,J)+DEUX*EXCENT*DMF(I,J)+EXCENT*EXCENT*DM(I,J)
            DMF(I,J)= DMF(I,J)                    +       EXCENT*DM(I,J)
  70      CONTINUE
C        ----------- MATRICES DANS LE REPERE INTRINSEQUE DE L'ELEMENT --

        CALL UTBTAB('ZERO',3,3, DM,T1VE,XAB1,DM)
        CALL UTBTAB('ZERO',3,3, DF,T1VE,XAB1,DF)
        CALL UTBTAB('ZERO',3,3,DMF,T1VE,XAB1,DMF)
C
        MULTIC = 1
C
      END IF
C
      DO 80 K = 1,9
          IF (ABS(DMF(K,1)).GT.1.D-10) MULTIC = 2
   80 CONTINUE
C
   90 CONTINUE
      END
