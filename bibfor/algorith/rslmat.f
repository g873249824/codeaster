        SUBROUTINE RSLMAT( FAMI,KPG,KSP,MOD,IMAT,NMAT,
     &                     MATERD,MATERF,MATCST,NDT,NDI,NR,NVI,VIND)
        IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C       ----------------------------------------------------------------
C       ROUSSELIER : RECUPERATION DU MATERIAU A TEMPD ET TEMPF
C                    NB DE CMP DIRECTES/CISAILLEMENT , NB VAR. INTERNES
C                    MATER(*,1) = E , NU , ALPHA
C                    MATER(*,2) = D , SIG1 , PORO_INIT, PORO_CRIT
C                                            PORO_ACCE, PORO_LIMI
C                                            D_SIGM_EPSI_NORM, AN, BETA
C                    VARIABLES INTERNES : P , B , E
C       ----------------------------------------------------------------
C       IN  IMAT   :  ADRESSE DU MATERIAU CODE
C           MOD    :  TYPE DE MODELISATION
C           NMAT   :  DIMENSION  DE MATER
C           TEMPD  :  TEMPERATURE  A T
C           TEMPF  :  TEMPERATURE  A T+DT
C       OUT MATERD :  COEFFICIENTS MATERIAU A T
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C                     MATER(*,1) = CARACTERISTIQUES   ELASTIQUES
C                     MATER(*,2) = CARACTERISTIQUES   PLASTIQUES
C           MATCST :  'OUI' SI  MATERIAU A T = MATERIAU A T+DT
C                     'NON' SINON
C           NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
C           NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
C           NR     :  NB DE COMPOSANTES SYSTEME NL
C           NVI    :  NB DE VARIABLES INTERNES
C       ----------------------------------------------------------------
        INTEGER         I, IMAT, NMAT, NDT , NDI  , NR , NVI,KPG,KSP
        INTEGER         JPROL, JVALE, NBVALE,IRET
C
        REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2) , TEMPD , TEMPF
        REAL*8          EPSI, VIND(*), F0
        REAL*8           RESU
C
        CHARACTER*8     MOD, NOMC(14),TYPE
      INTEGER CERR(14)
        CHARACTER*3     MATCST
        CHARACTER*(*)   FAMI
C
        DATA EPSI       /1.D-15/
C       ----------------------------------------------------------------
C
C -     NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
C
        CALL RSLNVI ( MOD , NDT , NDI , NR , NVI )
C
C -   RECUPERATION MATERIAU ------------------------------------------
C
C
          NOMC(1) = 'E        '
          NOMC(2) = 'NU       '
          NOMC(3) = 'ALPHA    '
          NOMC(4) = 'B_ENDOGE'
          NOMC(5) = 'K_DESSIC'
          NOMC(6) = 'D        '
          NOMC(7) = 'SIGM_1   '
          NOMC(8) = 'PORO_INIT'
          NOMC(9) = 'PORO_CRIT'
          NOMC(10)= 'PORO_ACCE'
          NOMC(11)= 'PORO_LIMI'
          NOMC(12)= 'D_SIGM_EPSI_NORM'
          NOMC(13)= 'AN'
          NOMC(14)= 'BETA'
C
C
C -     RECUPERATION MATERIAU A TEMPD (T)
C
          CALL RCVALB(FAMI,KPG,KSP,'-',IMAT,' ','ELAS',0,' ',
     &                0.D0,5,NOMC(1),MATERD(1,1),CERR(1),0)
          IF ( CERR(3) .NE. 0 ) MATERD(3,1) = 0.D0
          IF ( CERR(4) .NE. 0 ) MATERD(4,1) = 0.D0
          IF ( CERR(5) .NE. 0 ) MATERD(5,1) = 0.D0
          CALL RCVALB(FAMI,KPG,KSP,'-',IMAT,' ',  'ROUSSELIER',0,' ',
     &                0.D0,9,NOMC(6),  MATERD(1,2),  CERR(6), 2)
C
C         RECUPERATION DE E(TEMPD) VIA LES COURBES DE TRACTION MONOTONES
C         SIG = F(EPS,TEMPD) ENTREES POINT PAR POINT  (MOT CLE TRACTION)
C         > ECRASEMENT DU E RECUPERE PAR MOT CLE ELAS
C
          CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TEMPD,IRET)
          CALL RCTYPE(IMAT,1,'TEMP',TEMPD,RESU,TYPE)
          IF ((TYPE.EQ.'TEMP').AND.(IRET.EQ.1))
     &        CALL U2MESS('F','CALCULEL_31')
          CALL RCTRAC (IMAT,1,'SIGM',RESU,
     &                 JPROL,JVALE,NBVALE,MATERD(1,1))
C
C -     RECUPERATION MATERIAU A TEMPF (T+DT)
C
          CALL RCVALB(FAMI,KPG,KSP,'+',IMAT,' ','ELAS',0,' ',
     &                0.D0,5,NOMC(1),MATERF(1,1),CERR(1), 0)
          IF ( CERR(3) .NE. 0 ) MATERF(3,1) = 0.D0
          IF ( CERR(4) .NE. 0 ) MATERF(4,1) = 0.D0
          IF ( CERR(5) .NE. 0 ) MATERF(5,1) = 0.D0
          CALL RCVALB(FAMI,KPG,KSP,'+',IMAT,' ',  'ROUSSELIER',0,' ',
     &                0.D0, 9,NOMC(6),  MATERF(1,2),  CERR(6), 2)
C
C         RECUPERATION DE E(TEMPF) VIA LES COURBES DE TRACTION MONOTONES
C         SIG = F(EPS,TEMP) ENTREES POINT PAR POINT  (MOT CLE TRACTION)
C         > ECRASEMENT DU E RECUPERE PAR MOT CLE ELAS
C
          CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TEMPF,IRET)
          CALL RCTYPE(IMAT,1,'TEMP',TEMPF,RESU,TYPE)
          IF ((TYPE.EQ.'TEMP').AND.(IRET.EQ.1))
     &        CALL U2MESS('F','CALCULEL_31')
          CALL RCTRAC (IMAT,1,'SIGM',RESU,
     &                 JPROL,JVALE,NBVALE,MATERF(1,1))
C
C -     MATERIAU CONSTANT ? ------------------------------------------
C
C       PRINT * ,'MATERD = ',MATERD,'MATERF = ',MATERF
        MATCST = 'OUI'
        DO 30 I = 1,5
          IF ( ABS ( MATERD(I,1) - MATERF(I,1) ) .GT. EPSI )THEN
          MATCST = 'NON'
          GOTO 50
          ENDIF
 30     CONTINUE
        DO 40 I = 1,8
          IF ( ABS ( MATERD(I,2) - MATERF(I,2) ) .GT. EPSI )THEN
          MATCST = 'NON'
          GOTO 50
          ENDIF
 40     CONTINUE
C
C ---- INITIALISATION DE LA POROSITE INITIALE -------------------------
 50     CONTINUE
        IF (VIND(2) .EQ. 0.D0) THEN
          F0 = MATERF(3,2)
          VIND(2) = F0
          IF (F0.LE.0.D0) THEN
            CALL U2MESS('F','ALGORITH10_49')
          ELSEIF (F0.GE.1.D0) THEN
            CALL U2MESS('F','ALGORITH10_50')
          ENDIF
        ENDIF
C
C ----ET C EST TOUT ---------
        END
