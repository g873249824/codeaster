        SUBROUTINE LCMMON( FAMI,KPG,KSP,COMP,NBCOMM,CPMONO,NMAT,NVI,
     &                     VINI,X,  DTIME, E,NU,ALPHA,PGL,MOD,COEFT,
     &                     SIGI,EPSD, DETOT,
     &                     COEL,DVIN )
        IMPLICIT NONE
        INTEGER KPG,KSP,NMAT,NBCOMM(NMAT,3),NVI
        REAL*8 VINI(*),DVIN(*),NU,E,ALPHA,X,DTIME,COEFT(NMAT),COEL(NMAT)
        REAL*8 SIGI(6),EPSD(6),DETOT(6),PGL(3,3)
        CHARACTER*(*) FAMI
        CHARACTER*16 COMP(*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
C RESPONSABLE JMBHH01 J.M.PROIX
C TOLE CRP_21
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
C TOLE CRP_21
C ======================================================================
C       IN FAMI     :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C         KPG,KSP   :  NUMERO DU (SOUS)POINT DE GAUSS
C          COMP     :  NOM DU MODELE DE COMPORTEMENT
C           MOD     :  TYPE DE MODELISATION
C           IMAT    :  ADRESSE DU MATERIAU CODE
C         NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C         CPMONO :  NOMS DES LOIS MATERIAU PAR FAMILLE
C           PGL   : MATRICE DE PASSAGE GLOBAL LOCAL
C           NVI     :  NOMBRE DE VARIABLES INTERNES
C           VINI    :  VARIABLES INTERNES A T
C           X       :  INTERVALE DE TEMPS ADAPTATIF
C           DTIME   :  INTERVALE DE TEMPS
C           COEFT   :  COEFFICIENTS MATERIAU INELASTIQUE A T
C           SIGI    :  CONTRAINTES A L'INSTANT COURANT
C           EPSD    :  DEFORMATION TOTALE A T
C           DETOT   :  INCREMENT DE DEFORMATION TOTALE
C     OUT:
C           DVIN    :  DERIVEES DES VARIABLES INTERNES A T
C INTEGRATION DES LOIS MONOCRISTALLINES PAR UNE METHODE DE RUNGE KUTTA
C
C     CETTE ROUTINE FOURNIT LA DERIVEE DE L ENSEMBLE DES VARIABLES
C     INTERNES DU MODELE
C
C     ----------------------------------------------------------------
      CHARACTER*8 MOD
      CHARACTER*16 NOMFAM,NMATER,NECOUL,NECRIS,NECRCI,CPMONO(5*NMAT+1)
      REAL*8 VIS(3),DT
      REAL*8 EVI(6),SIGI33(3,3),SIGG(6),RP,SQ
      REAL*8 DEVI(6),MS(6),TAUS,DGAMMA,DALPHA,DP,SIG33(3,3),WORK(3,3)
      INTEGER ITENS,NBFSYS,I,NUVI,IFA,ICOMPO,NBSYS,IS,IV,NUMS
C     ----------------------------------------------------------------
C --  VARIABLES INTERNES
C
      DO 5 ITENS=1,6
        EVI(ITENS) = VINI(ITENS)
        DEVI(ITENS) = 0.D0
    5 CONTINUE

      CALL CALSIG(FAMI,KPG,KSP,EVI,MOD,E,NU,ALPHA,X,DTIME,EPSD,
     &              DETOT,NMAT,COEL,SIGI)

      NBFSYS=NBCOMM(NMAT,2)

      NUVI=6
      NUMS=0

      DO 6 IFA=1,NBFSYS

         NOMFAM=CPMONO(5*(IFA-1)+1)
C         NMATER=CPMONO(5*(IFA-1)+2)
         NECOUL=CPMONO(5*(IFA-1)+3)
         NECRIS=CPMONO(5*(IFA-1)+4)
         NECRCI=CPMONO(5*(IFA-1)+5)

         CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS)

         IF (NBSYS.EQ.0) CALL U2MESS('F','ALGORITH_70')

         DO 7 IS=1,NBSYS
            NUMS=NUMS+1

C           VARIABLES INTERNES DU SYST GLIS
            DO 8 IV=1,3
               NUVI=NUVI+1
               VIS(IV)=VINI(NUVI)
  8         CONTINUE

C           CALCUL DE LA SCISSION REDUITE =
C           PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
C           TAU      : SCISSION REDUITE TAU=SIG:MS
            CALL LCMMSG(NOMFAM,NBSYS,IS,PGL,MS)

            TAUS=0.D0
            DO 10 I=1,6
               TAUS=TAUS+SIGI(I)*MS(I)
 10         CONTINUE
C
C           ECROUISSAGE ISOTROPE
C
            CALL LCMMEI(COEFT,IFA,NMAT,NBCOMM,NECRIS,
     &                  NUMS,VIS,NVI,VINI(7),RP,SQ)
C
C           ECOULEMENT VISCOPLASTIQUE:
C           ROUTINE COMMUNE A L'IMPLICITE (PLASTI-LCPLNL)
C           ET L'EXPLICITE (NMVPRK-GERPAS-RK21CO-RDIF01)
C           CAS IMPLCITE : IL FAUT PRENDRE EN COMPTE DTIME
C           CAS EXPLICITE : IL NE LE FAUT PAS (C'EST FAIT PAR RDIF01)
C           D'OU :
            DT=1.D0
C
            CALL LCMMFL(FAMI,KPG,KSP,TAUS,COEFT,IFA,NMAT,NBCOMM,
     &                  NECOUL,RP,NUMS,VIS,NVI,VINI,DT,DT,DGAMMA,DP)
C
C           ECROUISSAGE CINEMATIQUE
C
            CALL LCMMEC(TAUS,COEFT,IFA,NMAT,NBCOMM,NECRCI,VIS,DGAMMA,DP,
     &                  DALPHA)

            DO 9 ITENS=1,6
               DEVI(ITENS)=DEVI(ITENS)+MS(ITENS)*DGAMMA
  9         CONTINUE

            DVIN(NUVI-2)=DALPHA
            DVIN(NUVI-1)=DGAMMA
            DVIN(NUVI  )=DP
  7     CONTINUE

  6   CONTINUE
C
C --    DERIVEES DES VARIABLES INTERNES
C
      DO 30 ITENS=1,6
        DVIN(ITENS)= DEVI(ITENS)
   30 CONTINUE
      END
