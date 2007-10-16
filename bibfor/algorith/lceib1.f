      SUBROUTINE LCEIB1 (FAMI,IMATE, COMPOR, NDIM, EPSM,
     &                    TM,TREF,SREF,SECHM,HYDRM,
     &                  T, LAMBDA, DEUXMU,
     &                   EPSTHE, KDESS, BENDO,  GAMMA, SEUIL, COUP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*16       COMPOR(*)
      CHARACTER*(*)      FAMI
      LOGICAL            COUP
      INTEGER            IMATE,NDIM, T(3,3), IISNAN
      REAL*8             EPSM(6), LAMBDA, DEUXMU, EPSTHE, KDESS, BENDO
      REAL*8             GAMMA, SEUIL
C ----------------------------------------------------------------------
C     LOI DE COMPORTEMENT ENDO_ISOT_BETON - INITIALISATION
C
C IN  COMPOR     : NOM DE LA LOI DE COMPORTEMENT
C IN  IMATE      : CODE MATERIAU
C IN  EPSM       : DEFORMATION AU TEMPS MOINS
C IN  TM         : TEMPERATURE A T-
C IN  TREF       : TEMPERATURE DE REFERENCE
C IN  SREF       : SECHAGE DE REFEERNCE
C IN  SECHM      : SECHAGE AU TEMPS -
C IN  HYDRM      : HYDRATATION AU TEMPS-
C OUT T          : TENSEUR DE PLACEMENT (PASSAGE VECT -> MATRICE)
C OUT LAMBDA
C OUT DEUXMU
C OUT ALPHA
C OUT KDESS
C OUT BENDO
C OUT GAMMA
C OUT SEUIL
C ----------------------------------------------------------------------
      CHARACTER*2 CODRET(3)
      CHARACTER*8 NOMRES(3)
      INTEGER     I,K,NDIMSI
      REAL*8      VALRES(3), E, NU
      REAL*8      TM,TREF,SREF,SECHM,HYDRM
      REAL*8      K0, K1, SICR, TREPSM,EPS(6),KRON(6)
      DATA        KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/

      NDIMSI=2*NDIM
      T(1,1)=1
      T(1,2)=4
      T(1,3)=5
      T(2,1)=4
      T(2,2)=2
      T(2,3)=6
      T(3,1)=5
      T(3,2)=6
      T(3,3)=3

      IF ((.NOT.( COMPOR(1)(1:15) .EQ. 'ENDO_ISOT_BETON')).AND.
     &   (.NOT.( COMPOR(1)(1:6) .EQ. 'KIT_HM')).AND.
     &   (.NOT.( COMPOR(1)(1:7) .EQ. 'KIT_HHM')).AND.
     &   (.NOT.( COMPOR(1)(1:7) .EQ. 'KIT_THM')).AND.
     &   (.NOT.( COMPOR(1)(1:8) .EQ. 'KIT_THHM')).AND.
     &   (.NOT.( COMPOR(1)(1:7) .EQ. 'KIT_DDI'))) THEN
            CALL U2MESK('F','ALGORITH4_50',1,COMPOR(1))
      ENDIF
C    LECTURE DES CARACTERISTIQUES DU MATERIAU
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'ALPHA'
      IF ((((COMPOR(1)(1:6) .EQ. 'KIT_HM') .OR.
     &     (COMPOR(1)(1:7) .EQ. 'KIT_HHM') .OR.
     &     (COMPOR(1)(1:7) .EQ. 'KIT_THM') .OR.
     &     (COMPOR(1)(1:7) .EQ. 'KIT_DDI') .OR.
     &     (COMPOR(1)(1:8) .EQ. 'KIT_THHM')).AND.
     &     (COMPOR(11)(1:15) .EQ. 'ENDO_ISOT_BETON')).OR.
     &     (COMPOR(1)(1:15) .EQ. 'ENDO_ISOT_BETON')) THEN
C      IF (COUP) THEN
      CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',1,'TEMP',0.D0,2,
     &              NOMRES,VALRES,CODRET, 'FM')
      CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',1,'TEMP',0.D0,1,
     &              NOMRES(3),VALRES(3),CODRET(3), ' ')
C      ELSE
C      CALL RCVALA(IMATE,' ','ELAS',0,' ',0.D0,2,
C     &              NOMRES,VALRES,CODRET, 'FM')
C      CALL RCVALA(IMATE,' ','ELAS',3,' ',0.D0,1,
C     &              NOMRES(3),VALRES(3),CODRET(3), ' ')
C      ENDIF
      IF (IISNAN(TM).EQ.0) THEN
        IF ((IISNAN(TREF).EQ.1).OR.(CODRET(3).NE.'OK'))  THEN
          CALL U2MESS('F','CALCULEL_15')
        ELSE
          EPSTHE = VALRES(3) * (TM - TREF)
        ENDIF
      ELSE
        VALRES(3) = 0.D0
        EPSTHE = 0.D0        
      ENDIF 
      E     = VALRES(1)
      NU    = VALRES(2)
   
      LAMBDA = E * NU / (1.D0+NU) / (1.D0 - 2.D0*NU)
      DEUXMU = E/(1.D0+NU)

C    LECTURE DES CARACTERISTIQUES DE RETRAIT ENDOGENE ET DESSICCATION
      NOMRES(1)='B_ENDOGE'
      NOMRES(2)='K_DESSIC'
      CALL RCVALB(FAMI,1,1,'+',IMATE,' ','ELAS',0,' ',0.D0,2,
     &             NOMRES,VALRES,CODRET, ' ' )
      IF ( CODRET(1) .NE. 'OK' ) VALRES(1) = 0.D0
      IF ( CODRET(2) .NE. 'OK' ) VALRES(2) = 0.D0
      BENDO=VALRES(1)
      KDESS=VALRES(2)

C    LECTURE DES CARACTERISTIQUES D'ENDOMMAGEMENT
      NOMRES(1) = 'D_SIGM_EPSI'
      NOMRES(2) = 'SYT'
      NOMRES(3) = 'SYC'
      CALL RCVALB(FAMI,1,1,'+',IMATE,' ','BETON_ECRO_LINE',
     &           0,' ',0.D0,3,
     &            NOMRES,VALRES,CODRET,' ')
      IF ((CODRET(1).NE.'OK').OR.(CODRET(2).NE.'OK')) THEN
         CALL U2MESS('F','ALGORITH4_51')
      ENDIF
      GAMMA  = - E/VALRES(1)
      K0=VALRES(2)**2 *(1.D0+GAMMA)/(2.D0*E)
     &               *(1.D0+NU-2.D0*NU**2)/(1.D0+NU)
      IF (NU.EQ.0) THEN
        IF (CODRET(3).EQ.'OK') THEN
          CALL U2MESS('F','ALGORITH4_52')
        ELSE
          SEUIL=K0
        ENDIF
      ELSE
        SICR=SQRT((1.D0+NU-2.D0*NU**2)/(2.D0*NU**2))*VALRES(2)
        IF (CODRET(3).EQ.'NO') THEN
          SEUIL=K0
        ELSE
          IF (VALRES(3).LT.SICR) THEN
            CALL U2MESS('F','ALGORITH4_53')
          ELSE
            K1=VALRES(3)*(1.D0+GAMMA)*NU**2/(1.D0+NU)/(1.D0-2.D0*NU)
     &        -K0*E/(1.D0-2.D0*NU)/VALRES(3)
C      PASSAGE AUX DEFORMATIONS ELASTIQUES
            CALL R8INIR(6,0.D0,EPS,1)
            DO 5 K=1,NDIMSI
              EPS(K) = EPSM(K) - (  EPSTHE
     &                       - KDESS * (SREF-SECHM)
     &                       - BENDO *  HYDRM  )     * KRON(K)
 5          CONTINUE
            TREPSM=0.D0
            DO 1 I=1,NDIM
              TREPSM=TREPSM+EPS(I)
 1          CONTINUE
            IF (TREPSM.GT.0.D0) THEN
              TREPSM=0.D0
            ENDIF
            SEUIL  = K0-K1*TREPSM
          ENDIF
        ENDIF
      ENDIF
      ENDIF

      END
