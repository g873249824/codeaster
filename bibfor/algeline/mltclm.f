      SUBROUTINE MLTCLM(NB,N,P,FRONT,ADPER,T1,AD,EPS,IER,C)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE JFBHHUC C.ROSE
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
      INTEGER N,P,ADPER(*),AD(*),IER,NB
      REAL*8 EPS
      COMPLEX*16  FRONT(*),T1(*),C(NB,NB,*),ALPHA,BETA
      INTEGER I,KB,ADK,ADKI,DECAL,L
      INTEGER   M,LL,  K, IND,IA,J,RESTP,NPB
      INTEGER INCX,INCY
      CHARACTER*1 TRA
      NPB=P/NB
      RESTP = P -(NB*NPB)
      LL = N
      TRA='N'
      ALPHA= DCMPLX(-1.D0,0.D0)
      BETA = DCMPLX( 1.D0,0.D0)
      INCX = 1
      INCY = 1
C
      DO 1000 KB = 1,NPB
C     K : INDICE (DANS LA MATRICE FRONTALE ( DE 1 A P)),
C     DE LA PREMIERE COLONNE DU BLOC
         K = NB*(KB-1) + 1
         ADK=ADPER(K)
C     BLOC DIAGONAL
         CALL MLTCLD(NB,FRONT(ADK),ADPER,T1,AD,EPS,IER)
         IF(IER.GT.0) GOTO 9999
C
C     NORMALISATION DES BLOCS SOUS LE BLOC DIAGONAL
C
         LL = LL -NB
            IA = ADK + NB
            DO 55 I=1,NB
               IND = IA +N*(I-1)
              IF(I.GT.1) THEN
                  DO 51 L=1,I-1
                     T1(L) = FRONT(ADPER(K+L-1))*FRONT(N*(K+L-2)+K+I-1)
 51                  CONTINUE
                     ENDIF
               CALL ZGEMV(TRA,LL,I-1,ALPHA,FRONT(IA),N,T1,INCX,BETA,
     &                    FRONT(IND),INCY)
               ADKI = ADPER(K+I-1)
               DO 53 J=1,LL
                  FRONT(IND) = FRONT(IND)/FRONT(ADKI)
                  IND = IND +1
 53            CONTINUE
 55         CONTINUE
C
        DECAL = KB*NB
        LL = N- DECAL
        M = P -DECAL
        IND =ADPER(K+NB)
        CALL MLTCLJ(NB,N,LL,M,K,DECAL,FRONT,FRONT(IND),ADPER,T1,C)
 1000 CONTINUE
C     COLONNES RESTANTES
      IF(RESTP.GT.0 ) THEN
C     K : INDICE (DANS LA MATRICE FRONTALE ( DE 1 A P)),
C     DE LA PREMIERE COLONNE DU BLOC
         KB = NPB + 1
         K = NB*NPB + 1
         ADK=ADPER(K)
C     BLOC DIAGONAL
         CALL MLTCLD(RESTP,FRONT(ADK),ADPER,T1,AD,EPS,IER)
         IF(IER.GT.0) GOTO 9999
C
C     NORMALISATION DES BLOCS SOUS LE BLOC DIAGONAL
C
         LL = N-P
         IA = ADK +RESTP
         DO 65 I=1,RESTP
            IND = IA +N*(I-1)
              IF(I.GT.1) THEN
                  DO 59 L=1,I-1
                     T1(L) = FRONT(ADPER(K+L-1))*FRONT(N*(K+L-2)+K+I-1)
 59               CONTINUE
                     ENDIF
               CALL ZGEMV(TRA,LL,I-1,ALPHA,FRONT(IA),N,T1,INCX,BETA,
     &                    FRONT(IND),INCY)
               ADKI = ADPER(K+I-1)
               DO 63 J=1,LL
                  FRONT(IND) = FRONT(IND)/FRONT(ADKI)
                  IND = IND +1
 63            CONTINUE
 65         CONTINUE

       ENDIF
 9999 CONTINUE
      IF(IER.GT.0) IER = IER + NB*(KB-1)
      END
