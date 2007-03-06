      SUBROUTINE LCMMVX (  SIGF ,VIN, NMAT, MATERF,TEMPF,
     &             COMP,NBCOMM, CPMONO, PGL, NR, NVI,HSR,TOUTMS,SEUIL)
      IMPLICIT NONE
C TOLE CRP_21
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/03/2007   AUTEUR ELGHARIB J.EL-GHARIB 
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
C     MONOCRISTAL  :  CALCUL DU SEUIL POUR MONOCRISTAL
C     ----------------------------------------------------------------
C     IN  SIGF   :  CONTRAINTE
C     IN  VIN    :  VARIABLES INTERNES = ( X1 X2 P )
C     IN  NMAT   :  DIMENSION MATER
C     IN  MATERF :  COEFFICIENTS MATERIAU A TEMP
C     IN  TEMPF  :  TEMPERATURE
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
      INTEGER         NDT , NDI , NMAT, NR, NVI, NSFA, NSFV,IEXP
      INTEGER         ITENS,NBFSYS,I,NUVI,IFA,ICOMPO,NBSYS,IS,IV
      INTEGER         NBCOMM(NMAT,3),IRET
      REAL*8          SIGF(6),VIN(NVI),RP,TEMPF,HSR(5,24,24)
      REAL*8          MATERF(NMAT*2),SEUIL,DT,SQ,DY(NVI),ALPHAM
      REAL*8          VIS(3),MS(6),TAUS,DGAMMA,DALPHA,DP,EXPBP(24)
      REAL*8          PGL(3,3),CRIT,SGNS,TOUTMS(5,24,6),GAMMAM
      CHARACTER*8     MOD
      CHARACTER*16    CPMONO(5*NMAT+1),COMP(*)
      CHARACTER*16 NOMFAM,NMATER,NECOUL,NECRIS
C
      NBFSYS=NBCOMM(NMAT,2)
      CALL R8INIR(NVI,0.D0, DY, 1)

      SEUIL=-1.D0
      DT=1.D0
C     NSFV : debut de la famille IFA dans les variables internes       
      NSFV=6
      DO 6 IFA=1,NBFSYS

         NOMFAM=CPMONO(5*(IFA-1)+1)
         NECOUL=CPMONO(5*(IFA-1)+3)
         NECRIS=CPMONO(5*(IFA-1)+4)

         CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS)

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
            IEXP=0
            IF (IS.EQ.1) IEXP=1
            CALL LCMMFI(MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRIS,
     &           IS,NBSYS,VIN(NSFV+1),DY,HSR,IEXP,EXPBP,RP)
C
C           ECOULEMENT VISCOPLASTIQUE
C
            CALL LCMMFE(TAUS,MATERF(NMAT+1),MATERF,IFA,NMAT,NBCOMM,
     &      NECOUL,IS,NBSYS,VIN(NSFV+1),DY,RP,ALPHAM,GAMMAM,DT,DALPHA,
     &      DGAMMA,DP,TEMPF,CRIT,SGNS,HSR,IRET)
            
            IF (DP.GT.0.D0) THEN
               SEUIL=1.D0
            ENDIF
            
 7     CONTINUE

        NSFV=NSFV+3*NBSYS
  

  6   CONTINUE
        END
