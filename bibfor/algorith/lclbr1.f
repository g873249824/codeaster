      SUBROUTINE LCLBR1 (NDIM, TYPMOD, IMATE, COMPOR, EPSM, DEPS,
     &                   VIM, TM,TP,TREF,OPTION, SIG, VIP,  DSIDEP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/04/2005   AUTEUR PBADEL P.BADEL 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*8        TYPMOD(2)
      CHARACTER*16       COMPOR(*),OPTION
      INTEGER            NDIM, IMATE
      REAL*8             EPSM(6), DEPS(6), VIM(2), TM, TP, TREF
      REAL*8             SIG(6), VIP(2), DSIDEP(6,12)
C ----------------------------------------------------------------------
C     LOI DE COMPORTEMENT BETON REGLEMENTAIRE 2D
C     ELASTIQUE NON LINEAIRE
C         PIC EN TRACTION
C         EN COMPRESSION : LOI PUISSANCE PUIS PLATEAU
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  IMATE   : NATURE DU MATERIAU
C IN  EPSM    : DEFORMATION EN T-
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  VIM     : VARIABLES INTERNES EN T-
C IN  TM      : TEMPERATURE EN T-
C IN  TP      : TEMPERATURE EN T+
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  OPTION  : OPTION DEMANDEE
C                 RIGI_MECA_TANG ->     DSIDEP
C                 FULL_MECA      -> SIG DSIDEP VIP
C                 RAPH_MECA      -> SIG        VIP
C OUT SIG     : CONTRAINTE
C OUT VIP     : VARIABLES INTERNES
C                 1   -> VALEUR DE L'ENDOMMAGEMENT
C OUT DSIDEP  : MATRICE TANGENTE
C ----------------------------------------------------------------------
C LOC EDFRC1  COMMON CARACTERISTIQUES DU MATERIAU (AFFECTE DANS EDFRMA)
      LOGICAL     RIGI, RESI,MTG, COUP, PLAN
      INTEGER     NDIMSI, K, L, I, J, M, N, P,T(3,3)
      REAL*8      EPS(6),  TREPS, SIGEL(6), KRON(6)
      REAL*8      RAC2,COEF,RBID
      REAL*8      FD, D, ENER, TROISK, G
      REAL*8      TR(6), RTEMP2
      REAL*8      EPSP(2), VECP(2,2), DSPDEP(6,6)
      REAL*8      DEUMUD(3), LAMBDD, SIGP(3),RTEMP,RTEMP3,RTEMP4
      REAL*8      E, NU, ALPHA, LAMBDA, DEUXMU, GAMMA, SEUIL,TREPSM
      REAL*8      SIGMT,SIGMC,EPSIC,COMPN
      REAL*8      R8DOT
      REAL*8      TPS(6)
      DATA        KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      
C ----------------------------------------------------------------------

C -- OPTION ET MODELISATION

      RIGI  = (OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL')
      RESI  = (OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL')
      COUP  = (OPTION(6:9).EQ.'COUP')
      PLAN  = ((TYPMOD(1) .EQ. 'C_PLAN').OR.(TYPMOD(1) .EQ. 'D_PLAN'))
      IF (.NOT.PLAN) THEN
        CALL UTMESS('F','LCLBR1','LOI BETON_REGLEMENT UTILISABLE '//
     &                  'UNIQUEMENT EN MODELISATION C_PLAN OU D_PLAN')
      ENDIF
      IF (COUP) RIGI=.TRUE.
      NDIMSI = 2*NDIM
      RAC2=SQRT(2.D0)
      ALPHA = 0.D0

C -- INITIALISATION

      CALL LCLBR2 (IMATE, COMPOR, NDIM, EPSM, T, E, SIGMT, SIGMC, 
     &             EPSIC, COMPN, GAMMA,RBID)


C -- MAJ DES DEFORMATIONS ET PASSAGE AUX DEFORMATIONS REELLES 3D

      IF (RESI) THEN
        DO 10 K = 1, NDIMSI
          EPS(K) = EPSM(K) + DEPS(K)- ALPHA * (TP - TREF) * KRON(K)
 10     CONTINUE
      ELSE
        DO 40 K=1,NDIMSI
          EPS(K) = EPSM(K) - ALPHA * (TM - TREF) * KRON(K)
40      CONTINUE
      ENDIF
      
C      write (6,*) EPS(1),EPS(2),EPS(3)
      DO 45 K=4,NDIMSI
        EPS(K) = EPS(K)/RAC2
45    CONTINUE
      EPS(3)=0.D0

C -- DIAGONALISATION DES DEFORMATIONS

      TR(1) = EPS(1)
      TR(2) = EPS(4)
      TR(3) = EPS(2)
      CALL DIAGP2(TR,VECP,EPSP)

C -- CALCUL DES CONTRAINTES

      DO 50 I=1,2
        IF (EPSP(I).LE.0.D0) THEN
          IF (EPSP(I).GT.EPSIC) THEN
            SIGP(I)=SIGMC*(1.D0-(1.D0-EPSP(I)/EPSIC)**COMPN)
            DEUMUD(I)=SIGMC*COMPN/EPSIC*(1.D0-EPSP(I)/EPSIC)
     &                                        **(COMPN-1.D0)
          ELSE
C            write (6,*) 'EPS = ',EPSP(I)
            SIGP(I)=SIGMC
            DEUMUD(I)=0.D0
          ENDIF
        ELSE 
          IF (EPSP(I).LT.(SIGMT/E)) THEN
            SIGP(I)=E*EPSP(I)
            DEUMUD(I)=E
          ELSE IF (EPSP(I).GE.(1+GAMMA)*SIGMT/E) THEN
            SIGP(I)=0.D0
            DEUMUD(I)=0.D0
          ELSE
            SIGP(I)=SIGMT-E/GAMMA*(EPSP(I)-SIGMT/E)
            DEUMUD(I)=SIGP(I)/EPSP(I)            
          ENDIF
        ENDIF
50    CONTINUE      
      IF ((RESI).AND.(.NOT.COUP)) THEN
        CALL R8INIR(6,0.D0,SIG,1)
        DO 1010 I=1,2
          RTEMP=SIGP(I)
          SIG(1)=SIG(1)+VECP(1,I)*VECP(1,I)*RTEMP
          SIG(2)=SIG(2)+VECP(2,I)*VECP(2,I)*RTEMP
          SIG(4)=SIG(4)+VECP(1,I)*VECP(2,I)*RTEMP
1010    CONTINUE
        SIG(4)=RAC2*SIG(4)
        SIG(3)=0.D0
        SIG(5)=0.D0
        SIG(6)=0.D0
      ENDIF
      
C -- CALCUL DE LA MATRICE TANGENTE
      
      
      IF (RIGI) THEN
        CALL R8INIR(36, 0.D0, DSPDEP, 1)
        IF (COUP) THEN
          CALL R8INIR(72, 0.D0, DSIDEP, 1)
        ELSE
          CALL R8INIR(36,0.D0,DSIDEP,1)
        ENDIF
        DO 120 K = 1,2
          DSPDEP(K,K) = DSPDEP(K,K) + DEUMUD(K)
 120    CONTINUE
        DSPDEP(3,3)=E
        IF (EPSP(1)*EPSP(2).GE.0.D0) THEN
          DSPDEP(4,4)=DEUMUD(1)
        ELSE
          DSPDEP(4,4)=(DEUMUD(1)*EPSP(1)-DEUMUD(2)*EPSP(2))
     &                                    /(EPSP(1)-EPSP(2))
        ENDIF
        DO 20 I=1,2
          DO 21 J=I,2          
            IF (I.EQ.J) THEN
              RTEMP3=1.D0
            ELSE
              RTEMP3=RAC2
            ENDIF
            DO 22 K=1,2
              DO 23 L=1,2
                IF (T(I,J).GE.T(K,L)) THEN
                IF (K.EQ.L) THEN
                  RTEMP4=RTEMP3
                ELSE
                  RTEMP4=RTEMP3/RAC2
                ENDIF
                RTEMP2=0.D0                
                DO 24 M=1,2
                  DO 25 N=1,2
        RTEMP2=RTEMP2+VECP(K,M)*
     &        VECP(I,N)*VECP(J,N)*VECP(L,M)*DSPDEP(N,M)
25                CONTINUE
24              CONTINUE
       RTEMP2=RTEMP2+VECP(I,1)*VECP(J,2)*VECP(K,1)*VECP(L,2)*DSPDEP(4,4)
       RTEMP2=RTEMP2+VECP(I,2)*VECP(J,1)*VECP(K,2)*VECP(L,1)*DSPDEP(4,4)
              DSIDEP(T(I,J),T(K,L))=DSIDEP(T(I,J),T(K,L))+RTEMP2*RTEMP4
               ENDIF
23            CONTINUE
22          CONTINUE
21        CONTINUE
20      CONTINUE
        DSIDEP(3,3)=DSPDEP(3,3)
        DSIDEP(1,2)=DSIDEP(2,1)
        DSIDEP(1,4)=DSIDEP(4,1)
        DSIDEP(2,4)=DSIDEP(4,2)        

      ENDIF
      END
