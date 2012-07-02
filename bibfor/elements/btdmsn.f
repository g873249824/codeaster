      SUBROUTINE BTDMSN(IND,NB1,INTSN,NPGSR,XR,BTDM,BTDF,BTDS,BTILD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
      IMPLICIT NONE
C
      INTEGER NB1,INTSN,NPGSR
      REAL*8 XR(*),BTDM1,BTDS1
      REAL*8 BTDM(4,3,42),BTDS(4,2,42),BTDF(3,42),BTILD(5,42)
C
C-----------------------------------------------------------------------
      INTEGER I ,I1 ,IND ,J ,K ,L 
C-----------------------------------------------------------------------
         L=702
C
C     CALCUL DE BTILDMN, BTILDSN AUX PTS DE GAUSS NORMAL
C            M=MEMBRANE, S=CISAILLEMENT, N=NORMAL
C
C        BTILDMN = SOMME MKBARRE BTILDMR   OU  K=1,NPGSR  R=REDUIT
C        BTILDSN = SOMME MKBARRE BTILDSR   OU  K=1,NPGSR  R=REDUIT
C        (AUX PTS DE GAUSS NORMAL)
C
C     MKBARRE = FONCTIONS DE FORME ASSOCIEES AUX PTS DE GAUSS REDUITS
C
      I1=L+4*(INTSN-1)
C
      IF (IND.EQ.0) THEN
C
C     INTEGRATION UNIFORME (ICI REDUITE)
C     BTILD =  BTDF + BTDM  : BTDF, BTDM , BTDS
C              BTDS           OBTENUES PAR INTEGRATION REDUITE
C
      DO 14 I=1,3
      DO 15 J=1,5*NB1+2
         BTILD(I,J)=BTDF(I,J)+BTDM(INTSN,I,J)
 15   CONTINUE
 14   CONTINUE
C
      DO 16 I=1,2
      DO 17 J=1,5*NB1+2
         BTILD(3+I,J)=BTDS(INTSN,I,J)
 17   CONTINUE
 16   CONTINUE
C
      ELSE IF (IND.EQ.1) THEN
C
C     INTEGRATION SELECTIVE
C     BTILD =  BTDF + BTDM  : BTDF, BTDM , BTDS
C              BTDS           BTDM, BTDS INTEGRATION REDUITE
C
C
      DO 10 I=1,3
      DO 20 J=1,5*NB1+2
                  BTDM1=0.D0
      IF (I.LE.2) BTDS1=0.D0
      DO 30 K=1,NPGSR
                  BTDM1=BTDM1+XR(I1+K)*BTDM(K,I,J)
      IF (I.LE.2) BTDS1=BTDS1+XR(I1+K)*BTDS(K,I,J)
 30   CONTINUE
C
C                               BTILDMN + BTILDFN
C     CONSTRUCTION DE BTILD =
C                               BTILDSN
C
C
                  BTILD(I,J)=BTDM1+BTDF(I,J)
      IF (I.LE.2) BTILD(I+3,J)=BTDS1
 20   CONTINUE
 10   CONTINUE
C
      ENDIF
C
      END
