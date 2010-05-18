       SUBROUTINE LCEOBL (NDIM, TYPMOD, IMATE, CRIT, EPSM, DEPS,
     &                   VIM, OPTION, SIGM, VIP,  DSIDEP, IRET)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/05/2010   AUTEUR IDOUX L.IDOUX 
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


      IMPLICIT NONE
      CHARACTER*8        TYPMOD(*)
      CHARACTER*16       OPTION
      INTEGER            NDIM, IMATE, IRET
      REAL*8             EPSM(6), DEPS(6), VIM(7), CRIT(*)
      REAL*8             SIGM(6), VIP(7), DSIDEP(6,6)
C ----------------------------------------------------------------------
C     LOI DE COMPORTEMENT DU MODELE D'ENDOMMAGEMENT ANISOTROPE
C 
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  IMATE   : NATURE DU MATERIAU
C IN  CRIT   : CRITERES DE CONVERGENCE LOCAUX
C IN  EPSM    : DEFORMATION EN T- REPERE GLOBAL
C IN  DEPS    : INCREMENT DE DEFORMATION
C IN  VIM     : VARIABLES INTERNES EN T-
C IN  OPTION  : OPTION DEMANDEE
C                 RIGI_MECA_TANG ->     DSIDEP
C                 FULL_MECA      -> SIG DSIDEP VIP
C                 RAPH_MECA      -> SIG        VIP
C OUT SIGM     : CONTRAINTE
C OUT VIP     : VARIABLES INTERNES
C                 1 A 6   -> TENSEUR D'ENDOMMAGEMENT DE TRACTION
C                 7       -> ENDOMMAGEMENT DE COMPRESSION
C OUT DSIDEP  : MATRICE TANGENTE DEFO
C OUT         : IRET CODE RETOUR
C ----------------------------------------------------------------------
C TOLE CRP_20

      LOGICAL     RIGI, RESI, ELAS,REINIT
      LOGICAL     TOTAL,TOT1,TOT2,TOT3,DBLOQ
      INTEGER     NDIMSI,I,J,K,L,P,Q,M,N, COMPTE,T(3,3)
      INTEGER     BDIM,R1(6),R2(6)

      INTEGER     INTMAX
      REAL*8      TOLER

      REAL*8      TREPS,TREB,TREM,EPS(6),CC(6),CCP(6)
      REAL*8      KRON(6),MULT,SEUIL,RK,RK1,RK2,UN,DEUX
      REAL*8      RAC2,BOBO(6,6),ZOZO(6,6),ZAZA(6,6)
      REAL*8      RTEMP1,RTEMP2,RTEMP3,RTEMP4,RTEMP5,RTEMP6
      REAL*8      E, NU, ALPHA, LAMBDA, MU,ECROB,ECROD
      REAL*8      B(6),IB(6),BM(6),BR(6),IBR(6),DB(6)
      REAL*8      VECC(3,3),VECEPS(3,3),TREPSM
      REAL*8      VALEPS(3),VPEM(3),VALCC(3)
      REAL*8      DM,D,VECB(3,3),VALB(3),TOLB
      REAL*8      INTERM(3,3),EPI(6),BMR(6),EPSR(6),BMRS,EPSRS,BRS
      REAL*8      VECBR(3,3),VALBR(3),BINTER(6),AD
      REAL*8      DELTAB(6),DELTAD,DSISUP(6,6)
      REAL*8      INTERB(3,3),EPIB(6)
      REAL*8      DSIINT(6,6),DSIMED(6,6)
      REAL*8      VECEPM(3,3),VALEPM(3)
      
      
      CHARACTER*2 CODRET(6)
      CHARACTER*8 NOMRES(6)
      REAL*8       VALRES(6)

      REAL*8      R8DOT,R8PREM
     
      DATA  KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/

      UN=1.D0
      DEUX=2.D0
      T(1,1)=1
      T(1,2)=4
      T(1,3)=5
      T(2,1)=4
      T(2,2)=2
      T(2,3)=6
      T(3,1)=5
      T(3,2)=6
      T(3,3)=3

      R1(1)=2
      R1(2)=3
      R1(3)=1
      R1(4)=6
      R1(5)=4
      R1(6)=5

      R2(1)=3
      R2(2)=1
      R2(3)=2
      R2(4)=5
      R2(5)=6
      R2(6)=4

      RAC2=SQRT(DEUX)
      TOLB=1.D-2
      MULT=0.D0
C=====================================================================
C                            INITIALISATION
C ====================================================================

C---------------------------------------------------
C -- OPTION ET MODELISATION
C---------------------------------------------------
      RIGI  = (OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL')
      RESI  = (OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL')
      NDIMSI = 2*NDIM
      TOTAL =.FALSE.
      REINIT=.FALSE.
      
C---------------------------------------------------
C -- LECTURE DES CARACTERISTIQUES THERMOELASTIQUES
C---------------------------------------------------
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      CALL RCVALA ( IMATE,' ','ELAS',0,' ',0.D0,2,
     &              NOMRES,VALRES,CODRET, 'FM')
      E     = VALRES(1)
      NU    = VALRES(2)
      LAMBDA = E * NU / (UN+NU) / (UN - DEUX*NU)
      MU = E/(DEUX*(UN+NU))
C-------------------------------------------------
C -- LECTURE DES CARACTERISTIQUES D'ENDOMMAGEMENT
C-------------------------------------------------
      NOMRES(1) = 'ALPHA'
      NOMRES(2) = 'K0'
      NOMRES(3) = 'K1'
      NOMRES(4) = 'K2'
      NOMRES(5) = 'ECROB'
      NOMRES(6) = 'ECROD'
      CALL RCVALA(IMATE,' ','ENDO_ORTH_BETON',0,' ',0.D0,6,
     &            NOMRES,VALRES,CODRET,'FM')
      ALPHA = VALRES(1)
      RK = VALRES(2)
      RK1 = VALRES(3)
      RK2 = VALRES(4)
      ECROB = VALRES(5)
      ECROD = VALRES(6)

      TOLER=CRIT(3)
      INTMAX=INT(CRIT(1))

      ELAS=.TRUE.

C---------------------------------------------
C---INITIALISATION MATRICE TANGENTE
C---------------------------------------------
      CALL R8INIR(36,0.D0,DSIDEP,1)
      CALL R8INIR(36,0.D0,DSISUP,1)

C-------------------------------------------------
C -- DEFORMATIONS
C-------------------------------------------------
      IF (RESI) THEN
        DO 1 K = 1, NDIMSI
          EPS(K) = EPSM(K) + DEPS(K)
 1      CONTINUE
      ELSE
        DO 2 K = 1, NDIMSI
          EPS(K) = EPSM(K)
 2      CONTINUE
      ELAS=.TRUE.
      ENDIF
      
      IF (NDIM.LT.3) THEN
        DO 456 I= NDIMSI+1, 6
        EPS(I)=0.D0
        EPSM(I)=0.D0
        DEPS(I)=0.D0
 456    CONTINUE
      ENDIF
      
      DO 301 I=4,6
        EPS(I)=EPS(I)/RAC2
        EPSM(I)=EPSM(I)/RAC2
        DEPS(I)=DEPS(I)/RAC2
 301  CONTINUE
C------------------------------------------------- 
C -- ENDOMMAGEMENT DANS LE REPERE GLOBAL
C-------------------------------------------------
      DO 3 I = 1,3
        BM(I)   = UN-VIM(I)
        B(I)   = BM(I)
 3    CONTINUE
      DO 300 I = 4,6
        BM(I)   = -VIM(I)
        B(I)   = BM(I)
 300  CONTINUE
      DM=VIM(7)
      D=DM

C------------------------------------------------------------------ 
C-- VERIFICATION SUR LES VALEURS PROPRES DE L ENDOMMAGEMENT
C-- DE TRACTION ET SUR L ENDOMMAGEMENT DE COMPRESSION POUR BLOQUAGE
C-- EVENTUEL DE L EVOLUTION
C------------------------------------------------------------------
      CALL DIAGO3(B,VECB,VALB)
      BDIM=3
      DO 201 I=1,3
        IF (VALB(I)-TOLB.LE.0.D0) THEN
          BDIM=BDIM-1
        ENDIF
 201  CONTINUE
      DBLOQ=.FALSE.
      IF (D-(UN-TOLB).GE.0.D0) THEN
        DBLOQ=.TRUE.
      ENDIF

C------------------------------------------------- 
C--DEFINITION DU SEUIL----------------------------
C------------------------------------------------- 

      CALL DIAGO3(EPSM,VECEPM,VALEPM)
        TREPSM=EPS(1)+EPS(2)+EPS(3)
        IF (TREPSM.GT.0.D0) THEN
          TREPSM=0.D0
        ENDIF
        SEUIL=RK-RK1*TREPSM*(ATAN2(-TREPSM/RK2,UN))

        

      IF (RESI) THEN
C----------------------------------------------------------------
C----CAS OU LES 3 VALEURS PROPRES D ENDO TRACTION SONT NON NULLES
C----------------------------------------------------------------

      IF (BDIM.EQ.3) THEN
        CALL LCEOB3(INTMAX,TOLER,EPS,BM,DM,
     &              LAMBDA,MU,ALPHA,ECROB,ECROD,SEUIL,
     &              B,D,MULT,ELAS,DBLOQ,IRET)
C--VERIF SUR ENDO FINAL POUR VOIR SI ENDO DEPASSE 1 OU PAS
C-- SI ENDO DEPASSE 1 PLUS QUE TOLERANCE ON PASSE DANS LCEOBB
C-- QUI DECOUPE L INCREMENT DE CHARGE POUR ALLER DOUCEMENT A ENDO=1
        
        CALL DIAGO3(B,VECB,VALB)

        DO 101 I=1,3
          IF (VALB(I).LT.0) THEN
            REINIT=.TRUE.
          ENDIF
          IF (VALB(I)-TOLB.LE.0.D0) THEN
            VALB(I)=TOLB-R8PREM()
            TOTAL=.TRUE.
          ENDIF
 101    CONTINUE
        IF (D.GT.1.D0) THEN
          REINIT=.TRUE.
        ENDIF
        IF (UN-D-TOLB.LE.0.D0) THEN
          D=UN-TOLB+R8PREM()
          DBLOQ=.TRUE.
        ENDIF
        
        IF (.NOT.REINIT) THEN
          IF (TOTAL) THEN
            CALL R8INIR(6,0.D0,B,1)
            DO 212 I=1,3
              DO 213 J=I,3
                DO 214 K=1,3
                B(T(I,J))=B(T(I,J))+VECB(I,K)*VALB(K)*VECB(J,K)
 214            CONTINUE
 213          CONTINUE
 212        CONTINUE
          ENDIF
        ELSE
          CALL LCEOBB (INTMAX,TOLER,EPSM,DEPS,BM,DM,
     &                 LAMBDA,MU,ALPHA,ECROB,ECROD,
     &                 RK,RK1,RK2,
     &                 B,D,MULT,ELAS,DBLOQ,IRET)
        ENDIF


C----------------------------------------------------------------
C----CAS OU 1 VALEUR PROPRE EST NULLE----------------------------
C----------------------------------------------------------------

      ELSEIF (BDIM.EQ.2) THEN

C-- ON RESTREINT L ESPACE CAR L ENDO N EVOLUE PLUS DANS 2 DIRECTIONS

        CALL R8INIR(9,0.D0,INTERM,1)
        CALL R8INIR(6,0.D0,EPI,1)
        DO 202 I=1,3
          DO 203 L=1,3
            DO 204 K=1,3
            INTERM(I,L)=INTERM(I,L)+VECB(K,I)*EPS(T(K,L))
 204        CONTINUE
            DO 205 J=I,3
            EPI(T(I,J))=EPI(T(I,J))+INTERM(I,L)*VECB(L,J)
 205        CONTINUE
 203      CONTINUE
 202    CONTINUE
        TOT1=.FALSE.
        TOT2=.FALSE.
        TOT3=.FALSE.
        CALL R8INIR(6,0.D0,BMR,1)
        IF (VALB(1)-TOLB.LE.0.D0) THEN
          BMR(1)=VALB(2)
          BMR(2)=VALB(3)
          DO 801 I=1,6
            EPSR(I)=EPI(R1(I))
 801      CONTINUE
          TOT1=.TRUE.
        ELSEIF (VALB(2)-TOLB.LE.0.D0) THEN
          BMR(1)=VALB(3)
          BMR(2)=VALB(1)
          DO 802 I=1,6
            EPSR(I)=EPI(R2(I))
 802      CONTINUE
          TOT2=.TRUE.
        ELSEIF (VALB(3)-TOLB.LE.0.D0) THEN
          BMR(1)=VALB(1)
          BMR(2)=VALB(2)
          DO 803 I=1,6
            EPSR(I)=EPI(I)
 803      CONTINUE
          TOT3=.TRUE.
        ENDIF 

        CALL LCEOB2(INTMAX,TOLER,EPSR,BMR,DM,
     &              LAMBDA,MU,ALPHA,ECROB,ECROD,SEUIL,
     &              BR,D,MULT,ELAS,DBLOQ,IRET)
C--VERIF SUR ENDO FINAL POUR VOIR SI ENDO DEPASSE 1 OU PAS
C-- SI ENDO DEPASSE 1 PLUS QUE TOLERANCE ON PASSE DANS LCEOBB
C-- QUI DECOUPE L INCREMENT DE CHARGE POUR ALLER DOUCEMENT A ENDO=1
C-- ENSUITE ON REVIENT AU 3D DANS REPERE INITIAL

        CALL DIAGO3(BR,VECBR,VALBR)
        DO 102 I=1,2
          IF (VALBR(I).LT.0) THEN
            REINIT=.TRUE.
          ENDIF
          IF (VALBR(I)-TOLB.LE.0.D0) THEN
            VALBR(I)=TOLB-R8PREM()
            TOTAL=.TRUE.
          ENDIF
 102    CONTINUE
        IF (D.GT.1.D0) THEN
          REINIT=.TRUE.
        ENDIF
        IF (UN-D-TOLB.LE.0.D0) THEN
          D=UN-TOLB+R8PREM()
          DBLOQ=.TRUE.
        ENDIF 
        IF (.NOT.REINIT) THEN
          IF (TOTAL) THEN
            CALL R8INIR(6,0.D0,BR,1)
            DO 222 I=1,3
              DO 223 J=I,3
                DO 224 K=1,3
                BR(T(I,J))=BR(T(I,J))+VECBR(I,K)*VALBR(K)*VECBR(J,K)
 224            CONTINUE
 223          CONTINUE
 222        CONTINUE
          ENDIF
          CALL R8INIR(6,0.D0,BINTER,1)
          IF (TOT1) THEN
          BINTER(1)=TOLB-R8PREM()
          BINTER(2)=BR(1)
          BINTER(3)=BR(2)
          BINTER(6)=BR(4)
          ELSEIF (TOT2) THEN
          BINTER(1)=BR(2)
          BINTER(2)=TOLB-R8PREM()
          BINTER(3)=BR(1)
          BINTER(5)=BR(4)
          ELSEIF (TOT3) THEN
          BINTER(1)=BR(1)
          BINTER(2)=BR(2)
          BINTER(3)=TOLB-R8PREM()
          BINTER(4)=BR(4)
          ENDIF
          CALL R8INIR(9,0.D0,INTERM,1)
          CALL R8INIR(6,0.D0,B,1)
          DO 232 I=1,3
            DO 233 L=1,3
              DO 234 K=1,3
              INTERM(I,L)=INTERM(I,L)+VECB(I,K)*BINTER(T(K,L))
 234          CONTINUE
              DO 235 J=I,3
              B(T(I,J))=B(T(I,J))+INTERM(I,L)*VECB(J,L)
 235          CONTINUE
 233        CONTINUE
 232      CONTINUE
        ELSE
          CALL LCEOBB (INTMAX,TOLER,EPSM,DEPS,BM,DM,
     &                 LAMBDA,MU,ALPHA,ECROB,ECROD,
     &                 RK,RK1,RK2,
     &                 B,D,MULT,ELAS,DBLOQ,IRET)
        ENDIF

C----------------------------------------------------------------
C----CAS OU 2 VALEURS PROPRES SONT NULLES------------------------
C----------------------------------------------------------------

      ELSEIF (BDIM.EQ.1) THEN

C-- ON RESTREINT L ESPACE CAR L ENDO N EVOLUE PLUS DANS UNE DIRECTION

        CALL R8INIR(9,0.D0,INTERM,1)
        CALL R8INIR(6,0.D0,EPI,1)
        DO 242 I=1,3
          DO 243 L=1,3
            DO 244 K=1,3
            INTERM(I,L)=INTERM(I,L)+VECB(K,I)*EPS(T(K,L))
 244        CONTINUE
            DO 245 J=I,3
            EPI(T(I,J))=EPI(T(I,J))+INTERM(I,L)*VECB(L,J)
 245        CONTINUE
 243      CONTINUE
 242    CONTINUE
        TOT1=.FALSE.
        TOT2=.FALSE.
        TOT3=.FALSE.
        CALL R8INIR(6,0.D0,BMR,1)
        IF (VALB(1)-TOLB.GT.0.D0) THEN
          BMR(1)=VALB(1)
          DO 804 I=1,6
            EPSR(I)=EPI(I)
 804      CONTINUE
          TOT1=.TRUE.
        ELSEIF (VALB(2)-TOLB.GT.0.D0) THEN
          BMR(1)=VALB(2)
          DO 805 I=1,6
            EPSR(I)=EPI(R1(I))
 805      CONTINUE
          TOT2=.TRUE.
        ELSEIF (VALB(3)-TOLB.GT.0.D0) THEN
          BMR(1)=VALB(3)
          DO 806 I=1,6
            EPSR(I)=EPI(R2(I))
 806      CONTINUE
          TOT3=.TRUE.
        ENDIF 
 
        CALL LCEOB1(INTMAX,TOLER,EPSR,BMR,DM,
     &              LAMBDA,MU,ALPHA,ECROB,ECROD,SEUIL,
     &              BR,D,MULT,ELAS,DBLOQ,IRET)
C--VERIF SUR ENDO FINAL POUR VOIR SI ENDO DEPASSE 1 OU PAS
C-- SI ENDO DEPASSE 1 PLUS QUE TOLERANCE ON PASSE DANS LCEOBB
C-- QUI DECOUPE L INCREMENT DE CHARGE POUR ALLER DOUCEMENT A ENDO=1
C-- ENSUITE ON REVIENT AU 3D DANS REPERE INITIAL

        IF (BR(1).LT.0) THEN
          REINIT=.TRUE.
        ENDIF
        IF (BR(1)-TOLB.LE.0.D0) THEN
          BR(1)=TOLB-R8PREM()
        ENDIF
        IF (D.GT.1.D0) THEN
          REINIT=.TRUE.
        ENDIF
        IF (UN-D-TOLB.LE.0.D0) THEN
          D=UN-TOLB+R8PREM()
          DBLOQ=.TRUE.
        ENDIF
        IF (.NOT.REINIT) THEN
          VALB(1)=TOLB-R8PREM()
          VALB(2)=TOLB-R8PREM()
          VALB(3)=TOLB-R8PREM()
          IF (TOT1) VALB(1)=BR(1)
          IF (TOT2) VALB(2)=BR(1)
          IF (TOT3) VALB(3)=BR(1)
          CALL R8INIR(6,0.D0,B,1)
          DO 252 I=1,3
            DO 253 J=I,3
              DO 254 K=1,3
              B(T(I,J))=B(T(I,J))+VECB(I,K)*VALB(K)*VECB(J,K)
 254          CONTINUE
 253        CONTINUE
 252      CONTINUE
        ELSE
          CALL LCEOBB (INTMAX,TOLER,EPSM,DEPS,BM,DM,
     &                 LAMBDA,MU,ALPHA,ECROB,ECROD,
     &                 RK,RK1,RK2,
     &                 B,D,MULT,ELAS,DBLOQ,IRET)
        ENDIF

      ENDIF


C-----------------------------------------------------
C--ON RECUPERE L ENDOMMAGEMENT ET LA CONTRAINTE
C-----------------------------------------------------
          DO 262 I=1,3
            VIP(I)=UN-B(I)
 262      CONTINUE
          DO 263 I=4,6
            VIP(I)=-B(I)
 263      CONTINUE
          VIP(7)=D
      CALL SIGEOB(EPS,B,D,3,LAMBDA,MU,SIGM)
      ENDIF



C ================================================================
C                            MATRICE TANGENTE
C ================================================================





C-on verifie l etat de B et D finaux pour calcul matrice tangente

C       CALL DIAGO3(B,VECB,VALB)
C       BDIM=3
C       DO 281 I=1,3
C         IF (VALB(I).EQ.0) THEN
C           BDIM=BDIM-1
C         ENDIF
C  281  CONTINUE



      IF (RIGI) THEN

        CALL R8INIR(36,0.D0,DSIDEP,1)
        IF ((B(1).EQ.1.D0).AND.(B(2).EQ.1.D0).AND.(B(3).EQ.1.D0)
     &       .AND.(D.EQ.0.D0)) THEN
          DO 910 I=1,6
              DSIDEP(I,I)=DSIDEP(I,I)+DEUX*MU
 910      CONTINUE
          DO 911 I=1,3
            DO 912 J=1,3
            DSIDEP(I,J)=DSIDEP(I,J)+LAMBDA
 912        CONTINUE
 911      CONTINUE
        
        ELSE

      AD=(UN-D)**DEUX


C -- DSIGMA/DEPS A ENDOMMAGEMENT CONSTANT = MATRICE SECANTE----

        CALL R8INIR(6,0.D0,CC,1)
        DO 98 I=1,3
          DO 99 J=I,3
            DO 100 K=1,3
              CC(T(I,J))=CC(T(I,J))+B(T(I,K))*EPS(T(K,J))+
     &                  B(T(J,K))*EPS(T(K,I))
 100        CONTINUE
 99       CONTINUE
 98     CONTINUE
        TREPS=0.D0
        TREB=0.D0
        DO 181 I=1,3
          TREB=TREB+CC(I)/DEUX
          TREPS=TREPS+EPS(I)
 181    CONTINUE
        IF (TREB.GE.0.D0) THEN
          DO 182 I=1,6
            IF (I.GT.3) THEN
              RTEMP2=RAC2
            ELSE
              RTEMP2=1.D0
            ENDIF
              DO 103 J=1,6
                IF (J.GT.3) THEN
                  RTEMP3=RAC2
                ELSE
                  RTEMP3=1.D0
                ENDIF
              DSIDEP(I,J)=DSIDEP(I,J)+LAMBDA*B(I)*B(J)*RTEMP2*RTEMP3
 103        CONTINUE
 182      CONTINUE
        ENDIF
        IF (TREPS.LT.0.D0) THEN
          DO 104 I=1,6
            IF (I.GT.3) THEN
              RTEMP2=RAC2
            ELSE
              RTEMP2=1.D0
            ENDIF
            DO 105 J=1,6
                IF (J.GT.3) THEN
                  RTEMP3=RAC2
                ELSE                              
                  RTEMP3=1.D0
                ENDIF
                  DSIDEP(I,J)=DSIDEP(I,J)+LAMBDA*AD*KRON(I)*KRON(J)
     &                       *RTEMP2*RTEMP3
 105        CONTINUE
 104      CONTINUE
        ENDIF
        CALL DFMDF(6,EPS,ZOZO)
        DO 106 I=1,6
          DO 107 J=1,6
            DSIDEP(I,J)=DSIDEP(I,J)+DEUX*AD*MU*ZOZO(I,J)
 107      CONTINUE
 106    CONTINUE
         CALL DFPDF(6,CC,ZAZA)
         CALL R8INIR(36,0.D0,BOBO,1)
         DO 108 I=1,3
           DO 109 J=I,3
           IF (I.EQ.J) THEN
           RTEMP2=1.D0
           ELSE 
           RTEMP2=RAC2
           ENDIF
             DO 110 P=1,3
               DO 111 Q=1,3
                 IF (P.EQ.Q) THEN
                 RTEMP3=1.D0
                 ELSE 
                 RTEMP3=UN/RAC2
                 ENDIF
                 DO 112 K=1,3
                   IF (K.EQ.I) THEN
                   RTEMP4=1.D0
                   ELSE 
                   RTEMP4=UN/RAC2
                   ENDIF
                   IF (K.EQ.J) THEN
                   RTEMP5=1.D0
                   ELSE 
                   RTEMP5=UN/RAC2
                   ENDIF
                   DO 113 M=1,3
                     DO 114 N=1,3
                     IF (M.EQ.N) THEN
                                  RTEMP6=1.D0
                               ELSE
                                  RTEMP6=1/RAC2
                               ENDIF
         BOBO(T(I,J),T(P,Q))=BOBO(T(I,J),T(P,Q))+(ZAZA(T(I,K),T(M,N))*
     &                     (B(T(M,P))*KRON(T(Q,N))+KRON(T(M,P))*
     &                     B(T(Q,N)))*RTEMP4*B(T(K,J))
     &                     +(ZAZA(T(K,J),T(M,N))*RTEMP5*
     &                     (B(T(M,P))*KRON(T(Q,N))+KRON(T(M,P))*
     &                     B(T(Q,N)))*B(T(I,K))))*RTEMP2*RTEMP3*RTEMP6 
  114                CONTINUE
  113              CONTINUE
  112            CONTINUE
  111          CONTINUE
  110        CONTINUE
  109      CONTINUE
  108    CONTINUE
        DO 115 I=1,6
          DO 116 J=1,6
            DSIDEP(I,J)=DSIDEP(I,J)+MU/DEUX*BOBO(I,J)
 116      CONTINUE
 115    CONTINUE
        CALL R8INIR(36,0.D0,DSISUP,1)
        IF (OPTION(10:14).NE.'_ELAS') THEN
          IF (.NOT.ELAS) THEN
 
            IF (BDIM.EQ.3) THEN
 
                    CALL R8INIR(6,0.D0,DELTAB,1)
                   DO 250 I=1,6
                       DELTAB(I)=B(I)-BM(I)
  250                CONTINUE
                   DELTAD=D-DM
 
              CALL MEOBL3(EPS,B,D,DELTAB,DELTAD,MULT,
     &                    LAMBDA,MU,ECROB,ECROD,ALPHA,RK1,RK2,DSISUP)
 
            ELSEIF (BDIM.EQ.2) THEN
 
                   CALL DIAGO3(B,VECB,VALB)
 
                   CALL R8INIR(9,0.D0,INTERM,1)
                   CALL R8INIR(9,0.D0,INTERB,1)
                   CALL R8INIR(6,0.D0,EPI,1)
                   CALL R8INIR(6,0.D0,EPIB,1)
                   DO 302 I=1,3
                          DO 303 L=1,3
                            DO 304 K=1,3
                  INTERM(I,L)=INTERM(I,L)+VECB(K,I)*EPS(T(K,L))
                  INTERB(I,L)=INTERB(I,L)+VECB(K,I)*BM(T(K,L))
  304                        CONTINUE
                           DO 305 J=I,3
                  EPI(T(I,J))=EPI(T(I,J))+INTERM(I,L)*VECB(L,J)
                  EPIB(T(I,J))=EPIB(T(I,J))+INTERB(I,L)*VECB(L,J)
  305                        CONTINUE
  303                      CONTINUE
  302               CONTINUE
                  TOT1=.FALSE.
                  TOT2=.FALSE.
                  TOT3=.FALSE.
                  CALL R8INIR(6,0.D0,BR,1)
                  CALL R8INIR(6,0.D0,DELTAB,1)
                  IF (ABS(VALB(1))-TOLB.LE.0.D0) THEN

               BR(1)=VALB(2)
                     BR(2)=VALB(3)
                         DO 807 I=1,6
                           EPSR(I)=EPI(R1(I))
  807                      CONTINUE
                    DELTAB(1)=VALB(2)-EPIB(2)
                    DELTAB(2)=VALB(3)-EPIB(3)
                    DELTAB(4)=-EPIB(6)
                    DELTAD=D-DM
                    TOT1=.TRUE.
                 ELSEIF (ABS(VALB(2))-TOLB.LE.0.D0) THEN
                      
                    BR(1)=VALB(3)
                    BR(2)=VALB(1)
                    DO 808 I=1,6
                           EPSR(I)=EPI(R2(I))
  808                      CONTINUE
               DELTAB(1)=VALB(3)-EPIB(3)
               DELTAB(2)=VALB(1)-EPIB(1)
               DELTAB(4)=-EPIB(5)
               DELTAD=D-DM
               TOT2=.TRUE.
             
                 ELSEIF (ABS(VALB(3))-TOLB.LE.0.D0) THEN
             
               BR(1)=VALB(1)
               BR(2)=VALB(2)
               DO 809 I=1,6
                 EPSR(I)=EPI(I)
  809                      CONTINUE
                    DELTAB(1)=VALB(1)-EPIB(1)
                    DELTAB(2)=VALB(2)-EPIB(2)
                    DELTAB(4)=-EPIB(4)
                    DELTAD=D-DM
                    TOT3=.TRUE.
        
                 ENDIF
 
 
                 CALL MEOBL2(EPSR,BR,D,DELTAB,DELTAD,MULT,
     &                    LAMBDA,MU,ECROB,ECROD,ALPHA,RK1,RK2,DSIINT)
 
            IF (TOT1) THEN
              DO 811 I=1,6
                DO 812 J=1,6
                  IF (I.GE.4) THEN
                    RTEMP1=UN/RAC2
                  ELSE
                              RTEMP1=1.D0
                            ENDIF
                  IF (J.GE.4) THEN
                    RTEMP2=UN/RAC2
                  ELSE
                    RTEMP2=1.D0
                  ENDIF
              DSIMED(R1(I),R1(J))=DSIINT(I,J)*RTEMP1*RTEMP2
  812                      CONTINUE
  811               CONTINUE
                ELSEIF (TOT2) THEN
                  DO 813 I=1,6
                         DO 814 J=1,6
               IF (I.GE.4) THEN
                 RTEMP1=UN/RAC2
               ELSE
                 RTEMP1=1.D0
               ENDIF
               IF (J.GE.4) THEN
                 RTEMP2=UN/RAC2
               ELSE
                 RTEMP2=1.D0
               ENDIF
               DSIMED(R2(I),R2(J))=DSIINT(I,J)*RTEMP1*RTEMP2
  814                    CONTINUE
  813             CONTINUE
             ELSEIF (TOT3) THEN
               DO 815 I=1,6
             DO 816 J=1,6
             IF (I.GE.4) THEN
               RTEMP1=UN/RAC2
             ELSE
               RTEMP1=1.D0
             ENDIF
             IF (J.GE.4) THEN
               RTEMP2=UN/RAC2
             ELSE
               RTEMP2=1.D0
             ENDIF
             DSIMED(I,J)=DSIINT(I,J)*RTEMP1*RTEMP2
  816                    CONTINUE
  815             CONTINUE
             ENDIF  
 
             CALL R8INIR(36,0.D0,DSISUP,1)
 
             DO 850 I=1,3
             DO 851 J=I,3
               IF (I.EQ.J) THEN
                 RTEMP1=1.D0
               ELSE
                 RTEMP1=RAC2
               ENDIF
             DO 852 P=1,3
             DO 853 Q=P,3
               IF (P.EQ.Q) THEN
                 RTEMP2=1.D0
               ELSE
                 RTEMP2=RAC2
               ENDIF
                  DO 860 K=1,3
                  DO 861 L=1,3
                  DO 862 M=1,3
                  DO 863 N=1,3
           
           DSISUP(T(I,J),T(P,Q))=DSISUP(T(I,J),T(P,Q))
     &          +VECB(I,K)*VECB(J,L)*VECB(P,M)*VECB(Q,N)
     &          *DSIMED(T(K,L),T(M,N))*RTEMP1*RTEMP2
 863                  CONTINUE
 862                  CONTINUE
 861                  CONTINUE
 860                  CONTINUE
 853             CONTINUE
 852             CONTINUE
 851             CONTINUE
 850             CONTINUE
 
 
 
 
C--------------------------------------------------------
C--------------------------------------------------------
 
           ELSEIF (BDIM.EQ.1) THEN
 
              CALL DIAGO3(B,VECB,VALB)
 
              CALL R8INIR(9,0.D0,INTERM,1)
              CALL R8INIR(9,0.D0,INTERB,1)
              CALL R8INIR(6,0.D0,EPI,1)
              CALL R8INIR(6,0.D0,EPIB,1)
              DO 602 I=1,3
                      DO 603 L=1,3
                        DO 604 K=1,3
                  INTERM(I,L)=INTERM(I,L)+VECB(K,I)*EPS(T(K,L))
                  INTERB(I,L)=INTERB(I,L)+VECB(K,I)*BM(T(K,L))
  604                     CONTINUE
                        DO 605 J=I,3
                  EPI(T(I,J))=EPI(T(I,J))+INTERM(I,L)*VECB(L,J)
                  EPIB(T(I,J))=EPIB(T(I,J))+INTERB(I,L)*VECB(L,J)
  605                     CONTINUE
  603              CONTINUE
  602            CONTINUE
 
              TOT1=.FALSE.
              TOT2=.FALSE.
              TOT3=.FALSE.
              CALL R8INIR(6,0.D0,BR,1)
              CALL R8INIR(6,0.D0,DELTAB,1)
 
              IF (ABS(VALB(1))-TOLB.GT.0.D0) THEN
             
                BR(1)=VALB(1)
                DO 607 I=1,6
                  EPSR(I)=EPI(I)
  607                CONTINUE
                DELTAB(1)=VALB(1)-EPIB(1)
                DELTAD=D-DM
                TOT1=.TRUE.
 
              ELSEIF (ABS(VALB(2))-TOLB.GT.0.D0) THEN
             
                BR(1)=VALB(2)
 
                DO 608 I=1,6
                  EPSR(I)=EPI(R1(I))
  608                CONTINUE
                DELTAB(1)=VALB(2)-EPIB(2)
                DELTAD=D-DM
                TOT2=.TRUE.
             
              ELSEIF (ABS(VALB(3))-TOLB.GT.0.D0) THEN
             
                BR(1)=VALB(3)
 
                DO 609 I=1,6
                  EPSR(I)=EPI(R2(I))
  609                CONTINUE
                DELTAB(1)=VALB(3)-EPIB(3)
                DELTAD=D-DM
                TOT3=.TRUE.
        
              ENDIF
 
             CALL MEOBL1(EPSR,B,D,DELTAB,DELTAD,MULT,
     &                    LAMBDA,MU,ECROB,ECROD,ALPHA,RK1,RK2,DSIINT)
             
             IF (TOT1) THEN
               DO 611 I=1,6
                 DO 612 J=1,6
                 IF (I.GE.4) THEN
                   RTEMP1=UN/RAC2
                 ELSE
                   RTEMP1=1.D0
                 ENDIF
                 IF (J.GE.4) THEN
                   RTEMP2=UN/RAC2
                 ELSE
                   RTEMP2=1.D0
                 ENDIF
                 DSIMED(I,J)=DSIINT(I,J)*RTEMP1*RTEMP2
  612                 CONTINUE
  611               CONTINUE
             ELSEIF (TOT2) THEN
               DO 613 I=1,6
                 DO 614 J=1,6
                 IF (I.GE.4) THEN
                   RTEMP1=UN/RAC2
                 ELSE
                   RTEMP1=1.D0
                 ENDIF
                 IF (J.GE.4) THEN
                   RTEMP2=UN/RAC2
                 ELSE
                   RTEMP2=1.D0
                 ENDIF
                 DSIMED(R1(I),R1(J))=DSIINT(I,J)*RTEMP1*RTEMP2
  614                 CONTINUE
  613               CONTINUE
             ELSEIF (TOT3) THEN
               DO 615 I=1,6
                 DO 616 J=1,6
                 IF (I.GE.4) THEN
                   RTEMP1=UN/RAC2
                 ELSE
                   RTEMP1=1.D0
                 ENDIF
                 IF (J.GE.4) THEN
                   RTEMP2=UN/RAC2
                 ELSE
                   RTEMP2=1.D0
                 ENDIF
                 DSIMED(R2(I),R2(J))=DSIINT(I,J)*RTEMP1*RTEMP2
  616                 CONTINUE
  615               CONTINUE
             ENDIF  
 
 
             CALL R8INIR(36,0.D0,DSISUP,1)
 
 
             DO 650 I=1,3
             DO 651 J=I,3
               IF (I.EQ.J) THEN
                 RTEMP1=1.D0
               ELSE
                 RTEMP1=RAC2
               ENDIF
             DO 652 P=1,3
             DO 653 Q=P,3
               IF (P.EQ.Q) THEN
                 RTEMP2=1.D0
               ELSE
                 RTEMP2=RAC2
               ENDIF
                  DO 660 K=1,3
                  DO 661 L=1,3
                  DO 662 M=1,3
                  DO 663 N=1,3
 
           DSISUP(T(I,J),T(P,Q))=DSISUP(T(I,J),T(P,Q))
     &          +VECB(I,K)*VECB(J,L)*VECB(P,M)*VECB(Q,N)
     &          *DSIMED(T(K,L),T(M,N))*RTEMP1*RTEMP2
 663                  CONTINUE
 662                  CONTINUE
 661                  CONTINUE
 660                  CONTINUE
 653             CONTINUE
 652             CONTINUE
 651             CONTINUE
 650             CONTINUE
 
              ENDIF
        
         ENDIF      
         ENDIF
 
             DO 120 I=1,6
               DO 121 J=1,6
                 DSIDEP(I,J)=DSIDEP(I,J)+DSISUP(I,J)
  121           CONTINUE
  120         CONTINUE



      ENDIF
      ENDIF
      END
