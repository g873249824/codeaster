      SUBROUTINE LCMMVX (SIGF,VIN,NMAT,MATERF,NBCOMM,
     &                   CPMONO,PGL,NVI,HSR,NFS,NSG,TOUTMS,TIMED,
     &                   TIMEF,DEPS,SEUIL)
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/09/2012   AUTEUR PROIX J-M.PROIX 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRS_1404
C     ----------------------------------------------------------------
C     MONOCRISTAL  :  CALCUL DU SEUIL POUR MONOCRISTAL
C     ----------------------------------------------------------------
C     IN  FAMI   :  FAMILLE DE POINTS DE GAUSS
C     IN  KPG    :  NUMERO DU POINT DE GAUSS
C     IN  KSP    :  NUMERO DU SOUS-POINT DE GAUSS
C     IN  SIGF   :  CONTRAINTE
C     IN  VIN    :  VARIABLES INTERNES = ( X1 X2 P )
C     IN  NMAT   :  DIMENSION MATER
C     IN  MATERF :  COEFFICIENTS MATERIAU A TEMP
C         COMP   :  NOM COMPORTEMENT
C         NBCOMM :  INCIDES DES COEF MATERIAU
C         CPMONO :  NOM DES COMPORTEMENTS
C         PGL    :  MATRICE DE PASSAGE
C         NR     :  DIMENSION DECLAREE DRDY
C         NVI    :  NOMBRE DE VARIABLES INTERNES
C         HSR    :  MATRICE D'INTERACTION
C         TOUTMS :  TENSEURS D'ORIENTATION
C     OUT SEUIL  :  SEUIL  ELASTICITE
C     ----------------------------------------------------------------
      INTEGER         NMAT, NVI, NSFA, NSFV,IEXP, NFS, NSG
      INTEGER         NBFSYS,I,NUVI,IFA,NBSYS,IS
      INTEGER         NBCOMM(NMAT,3),IRET
      REAL*8          SIGF(6),VIN(NVI),RP,HSR(NSG,NSG),DEPS(6)
      REAL*8          DDOT,MATERF(NMAT*2),SEUIL,DT,DY(NVI),ALPHAM
      REAL*8          MS(6),NG(3),Q(3,3),TIMED,TIMEF,LG(3),DEPSDT
      REAL*8          TAUS,DGAMMA,DALPHA,DP,EXPBP(NSG),DEPST(6)
      REAL*8          PGL(3,3),CRIT,SGNS,TOUTMS(NFS,NSG,6),GAMMAM
      CHARACTER*16    CPMONO(5*NMAT+1)
      CHARACTER*16    NOMFAM,NECOUL,NECRIS
      COMMON /DEPS6/DEPSDT
      INTEGER IRR,DECIRR,NBSYST,DECAL
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL
C
      SEUIL=-1.D0
      DT=TIMEF-TIMED
      NBFSYS=NBCOMM(NMAT,2)
      CALL R8INIR(NVI,0.D0, DY, 1)
      CALL DCOPY(6,DEPS,1,DEPST,1)
      DEPSDT=SQRT(DDOT(6,DEPST,1,DEPST,1)/1.5D0)/DT

C     NSFV : debut de la famille IFA dans les variables internes
      NSFV=6
C     NSFA : debut de la famille IFA dans DY et YD, YF
      NSFA=6
      DO 6 IFA=1,NBFSYS

         NOMFAM=CPMONO(5*(IFA-1)+1)
         NECOUL=CPMONO(5*(IFA-1)+3)
         NECRIS=CPMONO(5*(IFA-1)+4)

         CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS,NG,LG,0,Q)

         IF (NBSYS.EQ.0) CALL U2MESS('F','ALGORITH_70')

         DO 7 IS=1,NBSYS

            NUVI=NSFV+3*(IS-1)
            ALPHAM=VIN(NUVI+1)
            GAMMAM=VIN(NUVI+2)

C           CALCUL DE LA SCISSION REDUITE =
C           PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
C           TAU      : SCISSION REDUITE TAU=SIG:MS
            DO 101 I=1,6
               MS(I)=TOUTMS(IFA,IS,I)
 101        CONTINUE

            TAUS=0.D0
            DO 10 I=1,6
               TAUS=TAUS+SIGF(I)*MS(I)
 10         CONTINUE
C
C           ECROUISSAGE ISOTROPE
C
            IF(NECOUL.NE.'MONO_DD_KR') THEN
               IEXP=0
               IF (IS.EQ.1) IEXP=1
               CALL LCMMFI(MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRIS,
     &   IS,NBSYS,VIN,NSFV,DY(NSFA+1),NFS,NSG,HSR,IEXP,EXPBP,RP)
            ENDIF
C
C           ECOULEMENT VISCOPLASTIQUE
C
            DECAL=NSFV
            CALL LCMMFE( TAUS,MATERF(NMAT+1),MATERF,IFA,
     &      NMAT,NBCOMM,NECOUL,IS,NBSYS,VIN,DY(NSFA+1),
     &      RP,ALPHAM,GAMMAM,DT,DALPHA,DGAMMA,DP,CRIT,SGNS,NFS,NSG,
     &      HSR,IRET)

            IF (IRET.GT.0) THEN
               DP=1.D0
            ENDIF
            IF (DP.GT.0.D0) THEN
               SEUIL=1.D0
               GOTO 9999
            ENDIF

 7     CONTINUE

        NSFA=NSFA+NBSYS
        NSFV=NSFV+3*NBSYS
  6   CONTINUE
 9999 CONTINUE
      END
