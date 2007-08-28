      SUBROUTINE LCMAFL (FAMI, KPG, KSP, POUM, NMATER,IMAT,NECOUL,
     &                   NBVAL,VALRES,NMAT,HSR,NBHSR,NBSYS)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2007   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ----------------------------------------------------------------
C     MONOCRISTAL : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
C                  MATER(*,2) = COEF ECOULEMENT VISCOPLASTIQUE
C     ----------------------------------------------------------------
C     IN  IMAT   :  ADRESSE DU MATERIAU CODE
C         NMATER :  NOM DU MATERIAU
C         NMAT   :  DIMENSION  DE MATER
C         NECOUL :  NOM DE LA LOI D'ECOULEMENT
C         VALPAR :  VALEUR DES PARAMETRES
C         NOMPAR :  NOM DES PARAMETRES
C     OUT VALRES :  COEFFICIENTS MATERIAU A T
C         NBVAL  :  NOMBRE DE COEF MATERIAU LUS
C     ----------------------------------------------------------------
      INTEGER         KPG,KSP,NMAT,NVINI,I,IFA,IMAT,NBVAL,IDIFF,NBCOEF
      INTEGER         IRET2,N,NBHSR,NBSYS,J
      REAL*8          VALRES(NMAT),HSRI(24,24),H,HSR(5,24,24),R8PREM
      REAL*8          TEMPF,VALH(6),EPSI,VALLUE(NMAT)
      CHARACTER*8     NOMRES(NMAT)
      CHARACTER*2     CODRET(NMAT)
      CHARACTER*(*)   FAMI,POUM
      CHARACTER*16    NMATER, NECOUL
C     ----------------------------------------------------------------
C
      IF (NECOUL.EQ.'ECOU_VISC1') THEN
          NBVAL=3
          NOMRES(1)='N'
          NOMRES(2)='K'
          NOMRES(3)='C'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,0,' ',0.D0,
     1                 NBVAL,NOMRES, VALLUE,CODRET,'FM')
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECOU_VISC1 A LE NUMERO 1
          VALRES(1)=1

      ENDIF
      IF (NECOUL.EQ.'ECOU_VISC2') THEN
          NBVAL=5
          NOMRES(1)='N'
          NOMRES(2)='K'
          NOMRES(3)='C'
          NOMRES(4)='A'
          NOMRES(5)='D'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,0,' ',0.D0,
     1                 NBVAL,NOMRES, VALLUE,CODRET,'FM')
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECOU_VISC2 A LE NUMERO 2
          VALRES(1)=2

      ENDIF
      IF (NECOUL.EQ.'ECOU_VISC3') THEN
          NBVAL=5
          NOMRES(1)='K'
          NOMRES(2)='TAUMU'
          NOMRES(3)='GAMMA0'
          NOMRES(4)='DELTAV'
          NOMRES(5)='DELTAG0'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,0,' ',0.D0,
     1                 NBVAL,NOMRES, VALLUE,CODRET,'FM')
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION ECOU_VISC3 A LE NUMERO 3
          VALRES(1)=3

          CALL RCVARC('F','TEMP',POUM,FAMI,KPG,KSP,TEMPF,IRET2)
          NBVAL=NBVAL+1
          VALRES(NBVAL)=TEMPF
      ENDIF
      IF (NECOUL.EQ.'KOCKS_RAUCH') THEN
          NBVAL=10
          NOMRES(1)='K'
          NOMRES(2)='TAUR'
          NOMRES(3)='TAU0'
          NOMRES(4)='GAMMA0'
          NOMRES(5)='DELTAG0'
          NOMRES(6)='BSD'
          NOMRES(7)='GCB'
          NOMRES(8)='KDCS'
          NOMRES(9)='P'
          NOMRES(10)='Q'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,0,' ',0.D0,
     1                 NBVAL,NOMRES, VALLUE,CODRET,'FM')
          CALL LCEQVN ( NBVAL , VALLUE  , VALRES(2) )
          NBVAL=NBVAL+1
C         PAR CONVENTION KOCKS_RAUCH A LE NUMERO 4
          VALRES(1)=4

          CALL RCVARC('F','TEMP',POUM,FAMI,KPG,KSP,TEMPF,IRET2)
          NBVAL=NBVAL+1
          VALRES(NBVAL)=TEMPF
          

C         DEFINITION DE LA MATRICE D'INTERACTION POUR KOCKS-RAUCH
          NOMRES(1)='H'
          CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,0,' ',0.D0,
     &                 1, NOMRES, H,CODRET,' ')
          IF (CODRET(1).EQ.'OK') THEN
              NBCOEF=1                          
              VALH(1)=H                                        
          ELSE
              NOMRES(1)='H1'
              NOMRES(2)='H2'
              NOMRES(3)='H3'
              NOMRES(4)='H4'
              NOMRES(5)='H5'
              NOMRES(6)='H6'
              CALL RCVALB (FAMI,KPG,KSP,POUM,IMAT,NMATER, NECOUL,
     &                   0,' ',0.D0,6,NOMRES,VALH,CODRET,' ')
              IF (CODRET(5).EQ.'OK') THEN
                  NBCOEF=6                          
              ELSE
                  NBCOEF=4
              ENDIF                          

          ENDIF
      
          CALL LCMHSR (NBSYS, NBCOEF, VALH, HSRI)
          EPSI=R8PREM()
          IDIFF=0
          DO 3 N=1,NBHSR
          DO 1 I=1,NBSYS
          DO 2 J=1,NBSYS
              IF (ABS(HSR(NBHSR,I,J)-HSRI(I,J)).GT.EPSI)  IDIFF=1
  2       CONTINUE
  1       CONTINUE
  3       CONTINUE
  4       CONTINUE
          IF (IDIFF.GT.0.OR.NBHSR.EQ.0) THEN
             NBHSR=NBHSR+1
             IF (NBHSR.GT.5) CALL U2MESS('F','COMPOR1_22')
             DO 5 I=1,NBSYS
             DO 6 J=1,NBSYS
                 HSR(NBHSR,I,J)=HSRI(I,J)
  6          CONTINUE
  5          CONTINUE
          ENDIF
      
          NBVAL=NBVAL+1
          VALRES(NBVAL)=NBHSR

      ENDIF
      END
