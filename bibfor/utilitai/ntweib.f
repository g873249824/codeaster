      SUBROUTINE NTWEIB(NRUPT,CALS,SK,SIGW,NUR,NT,NBRES,X1,X2,
     &                  XACC,RTSAFE,IMPR,IFM,INDTP,NBTP)
      IMPLICIT NONE
      INTEGER       NRUPT,NUR(*),NT(*),NBRES,INDTP(*),NBTP,IFM
      REAL*8        SIGW(*),X1,X2,XACC,RTSAFE,SK(*)
      LOGICAL       CALS,IMPR
C     ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C     ----------------------------------------------------------------
C     AUTEUR : M. BONNAMY
C     ----------------------------------------------------------------
C
C     BUT: CALCUL DE RECALAGE DES PARAMETRES DE WEIBULL PAR LA
C          METHODE DU MAXIMUM DE VRAISSEMBLANCE : METHODE DE NEWTON
C          COMBINEE AVEC METHODE DE LA BISSECTRICE
C
C     ----------------------------------------------------------------
C
C     NRUPT        /IN/:NOMBRE TOTAL DE CONTRAINTES DE WEIBULL
C     CALS         /IN/:TRUE SI SIGMA_U EST FIXE
C     SK           /IN/:PARAMETRE SIGMA-U(K) DE WEIBULL
C     SIGW         /IN/:CONTRAINTES DE WEIBULL AUX INSTANTS DE RUPTURE
C     NUR          /IN/:NUMERO DE RESULTAT ASSOCIEE A
C                       LA CONTRAINTE SIGW(I)
C     NT           /IN/:DIMENSION DE LA SOUS-BASE CORRESPONDANT A LA
C                       TEMPERATURE T
C     NBRES        /IN/:NOMBRE DE BASES DE RESULTATS
C     IMPR         /IN/:IMPRESSION DETAILLEE
C     INDTP        /IN/:INDICE DE TEMPERATURE POUR CHAQUE RESULTAT
C     NBTP         /IN/:NOMBRE DE TEMPERATURE DIFFERENTES
C     X1           /IN/:BORNE GAUCHE DE RECHERCHE
C     X2           /IN/:BORNE DROITE DE RECHERCHE
C     XACC         /IN/:PRECISION VOULUE
C
C     X,Y          /OUT/:VALEUR DES FONCTIONS LOG(SIGMAW)
C                        ET LOG(LOG(1/(1-PF)))
C     MKP          /OUT/:PARAMETRE M(K+1)DE WEIBULL
C     SKP          /OUT/:PARAMETRE SIGMA-U(K+1) DE WEIBULL
C     RTSAFE       /OUT/:PARAMETRE M(K+1)DE WEIBULL
C
C     ----------------------------------------------------------------
C
      REAL*8  DF,DX,DXOLD,F,FH,FL,TEMP,XH,XL,DFL,DFH
      REAL*8 VALR(4)
      INTEGER MAXIT,J
      INTEGER VALI
      PARAMETER (MAXIT=100)
C     ----------------------------------------------------------------
C
 4    CONTINUE
      CALL FCWEIB(NRUPT,CALS,SK,SIGW,NUR,NT,NBRES,INDTP,NBTP,X1,FL,DFL)
      IF (IMPR) WRITE(IFM,*) 'F,DF,X1 SUR BORNE GAUCHE : ',FL,DFL,X1
 5    CONTINUE
      CALL FCWEIB(NRUPT,CALS,SK,SIGW,NUR,NT,NBRES,INDTP,NBTP,X2,FH,DFH)
      IF (IMPR) WRITE(IFM,*) 'F,DF,X2 SUR BORNE DROITE : ',FH,DFH,X2
C
C     RECHERCHE DE LA BORNE DROITE SI F(X1) ET F(X2) DE MEME SIGNE
C
      IF ( ((FL.GT.0.D0.AND.FH.GT.0.D0).AND.DFH.LT.0.D0 )
     &   .OR. ((FL.LT.0.D0.AND.FH.LT.0.D0).AND.DFH.GT.0.D0) ) THEN
        X2 = X2 + 0.9D0
        GOTO 5
      END IF
      IF ( ((FL.GT.0.D0.AND.FH.GT.0.D0).AND.DFL.GT.0.D0 )
     &   .OR. ((FL.LT.0.D0.AND.FH.LT.0.D0).AND.DFL.LT.0.D0) ) THEN
        X1 = X1 - 0.9D0
        GOTO 4
      END IF
      IF (FL.EQ.0.D0) THEN
        RTSAFE = X1
        GOTO 9999
      ELSE IF (FH.EQ.0.D0) THEN
        RTSAFE = X2
        GOTO 9999
      ELSE IF (FL.LT.0.D0) THEN
        XL = X1
        XH = X2
      ELSE
        XH = X1
        XL = X2
      END IF
      RTSAFE = 0.5D0*(X1+X2)
      DXOLD = ABS(X2-X1)
      DX = DXOLD
      CALL FCWEIB(NRUPT,CALS,SK,SIGW,NUR,NT,NBRES,INDTP,NBTP,
     &            RTSAFE,F,DF)
      IF (IMPR) WRITE(IFM,*) 'F ET DF MILIEU INTERVALLE :',RTSAFE,F,DF
      DO 10 J=1,MAXIT
         IF (IMPR) WRITE(IFM,*) '*** ITERATION DE NEWTON NO',J
         IF (((RTSAFE-XH)*DF-F)*((RTSAFE-XL)*DF-F).GT.0.D0
     &       .OR. ABS(2.D0*F).GT.ABS(DXOLD*DF) ) THEN
            DXOLD = DX
            DX = 0.5D0*(XH-XL)
            RTSAFE = XL+DX
            IF (XL.EQ.RTSAFE) GOTO 9999
            IF (IMPR) WRITE(IFM,*) 'INCREMENT - SOLUTION : ',DX,RTSAFE
         ELSE
            DXOLD = DX
            DX = F/DF
            TEMP = RTSAFE
            RTSAFE = RTSAFE-DX
            IF (TEMP.EQ.RTSAFE) GOTO 9999
            IF (IMPR) WRITE(IFM,*) 'INCREMENT - SOLUTION : ',DX,RTSAFE
         END IF
         IF (ABS(DX).LT.XACC) GOTO 9999
         CALL FCWEIB(NRUPT,CALS,SK,SIGW,NUR,NT,NBRES,INDTP,NBTP,
     &               RTSAFE,F,DF)
         IF (IMPR) WRITE(IFM,*) 'SOLUTION/F-DF : ',RTSAFE,F,DF
         IF (F.LT.0.D0) THEN
           XL = RTSAFE
         ELSE
           XH = RTSAFE
         END IF
 10   CONTINUE
      CALL U2MESS('F','UTILITAI2_53')
 9999 CONTINUE
      IF (IMPR) THEN
        VALR (1) = RTSAFE
        VALR (2) = F
        VALR (3) = DX
        VALR (4) = XACC
        VALI = J
        CALL U2MESG('I', 'UTILITAI6_48',0,' ',1,VALI,4,VALR)
      END IF
C
      END
