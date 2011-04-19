      REAL*8 FUNCTION LCROYI ()
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
      IMPLICIT NONE

C *********************************************************************
C *       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL                   *
C *  CALCUL DES BORNES INF ET SUP DE LA FONCTION S(Y) QUAND S(0)<0    *
C *  ET RESOLUTION DE S(Y)=0                                          *
C *  PAR UNE METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE   *
C *  - LA BORNE SUPERIEURE EST TELLE QUE YSUP=LOG(SIG1*FONC/RM)       *
C *  - LA BORNE INFERIEURE EST TELLE QUE YINF =LOG(SIG1*G/R(PM+DPSUP) *
C *********************************************************************

C ----------------------------------------------------------------------
C  COMMON LOI DE COMPORTEMENT ROUSSELIER

      INTEGER ITEMAX, JPROLP, JVALEP, NBVALP
      REAL*8  PREC,YOUNG,NU,SIGY,SIG1,ROUSD,F0,FCR,ACCE
      REAL*8  PM,RPM,FONC,FCD,DFCDDJ,DPMAXI
      COMMON /LCROU/ PREC,YOUNG,NU,SIGY,SIG1,ROUSD,F0,FCR,ACCE,
     &               PM,RPM,FONC,FCD,DFCDDJ,DPMAXI,
     &               ITEMAX, JPROLP, JVALEP, NBVALP
C ----------------------------------------------------------------------
C  COMMON GRANDES DEFORMATIONS CANO-LORENTZ

      INTEGER IND1(6),IND2(6)
      REAL*8  KR(6),RAC2,RC(6)
      REAL*8  LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER
      REAL*8  JM,DJ,JP,DJDF(3,3)
      REAL*8  ETR(6),DVETR(6),EQETR,TRETR,DETRDF(6,3,3)
      REAL*8  DTAUDE(6,6)

      COMMON /GDCLC/
     &          IND1,IND2,KR,RAC2,RC,
     &          LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER,
     &          JM,DJ,JP,DJDF,
     &          ETR,DVETR,EQETR,TRETR,DETRDF,
     &          DTAUDE
C ----------------------------------------------------------------------

      INTEGER ITER
      REAL*8  Y,E,DP,RP,S,DS,YINF,YSUP,R8BID,PENTE,AIRE


C 1 - CALCUL DU MAJORANT

      E  = SIG1*FONC / RPM
      YSUP = LOG(E)
      Y  = YSUP
      CALL LCROFS(Y, DP, S, DS)

C 2 - CALCUL DU MINORANT

      CALL RCFONC('V',1,JPROLP,JVALEP,NBVALP,R8BID,
     &           R8BID,R8BID,PM+DP,RP,PENTE,AIRE,R8BID,R8BID)
      E  = SIG1*FONC / RP
      YINF = MAX(0.D0, LOG(E))

C 3 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES

      DO 10 ITER = 1, ITEMAX
        IF (ABS(S)/SIGY .LE. PREC) GOTO 100

        Y = Y - S/DS
        IF (Y.LE.YINF .OR. Y.GE.YSUP)  Y=(YINF+YSUP)/2

        CALL LCROFS(Y, DP, S, DS)
        IF (S.LE.0) YINF = Y
        IF (S.GE.0) YSUP = Y
 10   CONTINUE
      CALL U2MESS('F','ALGORITH3_55')


 100  CONTINUE
      LCROYI = Y
      END
