      SUBROUTINE IRRRES( FAMI, KPG, KSP, MOD, NMAT, MATERD, MATERF,
     &                   YD ,  YF,   DEPS,   DY,  R )
      IMPLICIT NONE

      CHARACTER*8 MOD
      CHARACTER*(*) FAMI
      INTEGER     NMAT,KPG,KSP
      REAL*8      MATERD(NMAT,2) ,MATERF(NMAT,2)
      REAL*8      YD(*),YF(*),DEPS(6),DY(*),R(*)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE FLEJOU J-L.FLEJOU

      REAL*8  DFDS(6),ID3D(6),SF
      REAL*8  IRRAD,IRRAF,DPHI,SIGD(6),SIGF(6),DKOOH(6,6)
      REAL*8  FKOOH(6,6),HOOKF(6,6),K,N,P0,AI0,ETAIS,P,ZETAFF,ZETAG
      REAL*8  DP,DETAI,DPI,DG,ETAIF,SEQF,EPSEF(6),PE,KAPPA,R02
      REAL*8  DEPSA(6),DEPSG(6),DEV(6),EPSED(6),LCNRTS
      REAL*8  RS(6),RP,RE,RPI,RG,QF,R8PREM,R8AUX
      REAL*8  PK,PENPE,SPE,SEQD
      REAL*8  ETAID,AGDI,AGFI
      INTEGER NDT, NDI
C     ----------------------------------------------------------------
      COMMON /TDIM/   NDT , NDI
C     ----------------------------------------------------------------

      DATA ID3D /1.0D0, 1.0D0, 1.0D0, 0.0D0, 0.0D0, 0.0D0/

      CALL LCEQVN ( NDT , YF(1), SIGF)
      CALL LCEQVN ( NDT , YD(1), SIGD)
      CALL LCOPIL  ( 'ISOTROPE' , MOD , MATERD(1,1) , DKOOH )
      CALL LCOPIL  ( 'ISOTROPE' , MOD , MATERF(1,1) , FKOOH )
      CALL LCOPLI  ( 'ISOTROPE' , MOD , MATERF(1,1) , HOOKF )

C     RECUPERATION DES CARACTERISTIQUES MATERIAUX A t+
      AI0   = MATERF(4,2)
      ETAIS = MATERF(5,2)
      K     = MATERF(7,2)
      N     = MATERF(8,2)
      P0    = MATERF(9,2)
      KAPPA = MATERF(10,2)
      R02   = MATERF(11,2)
      ZETAFF= MATERF(12,2)
      PENPE = MATERF(13,2)
      PK    = MATERF(14,2)
      PE    = MATERF(15,2)
      SPE   = MATERF(16,2)
      ZETAG = MATERF(17,2)
C     RECUPERATION DES CARACTERISTIQUES MATERIAUX A t-
C     RECUPERATION GONFLEMENT DEJA INTEGRE
      AGDI  = MATERD(19,2)
      AGFI  = MATERF(19,2)

C     RECUPERATION DES VARIABLES INTERNES A t+
      P     = YF(NDT+1)
      ETAIF = YF(NDT+2)
C     RECUPERATION DES VARIABLES INTERNES A t-
      ETAID = YD(NDT+2)

C     RECUPERATION DES INCREMENTS DES VARIABLES INTERNES
      DP    = DY(NDT+1)
      DETAI = DY(NDT+2)
      DPI   = DY(NDT+3)
      DG    = DY(NDT+4)

C     RECUPERATION DE L'IRRADIATION
      IRRAD = MATERD(18,2)
      IRRAF = MATERF(18,2)
      DPHI=IRRAF-IRRAD

      CALL LCDEVI(SIGF,DEV)
      SEQF = LCNRTS(DEV)
      IF ( SEQF .EQ. 0.0D0) THEN
        CALL LCINVE(0.0D0,DFDS)
      ELSE
        CALL LCPRSV( 1.5D0/SEQF ,DEV,DFDS)
      ENDIF
      CALL LCPRMV(FKOOH,SIGF,EPSEF)
      CALL LCPRMV(DKOOH,SIGD,EPSED)
      CALL LCPRSV((DP+DPI),DFDS,DEPSA)
      CALL LCPRSV(DG,ID3D,DEPSG)

C   RESIDU EN SIGMA, HOMOGENE A DES DEFORMATIONS
      CALL LCDIVE(EPSEF,EPSED,RS)
      CALL LCSOVE(RS,DEPSA,RS)
      CALL LCSOVE(RS,DEPSG,RS)
      CALL LCDIVE(RS,DEPS,RS)
      CALL LCPRSV(-1.D0,RS,RS)

C  RESIDU EN DEFORMATION PLASTIQUE
      IF      ( P .LT. PK ) THEN
         SF = KAPPA*R02
      ELSE IF ( P .LT. PE ) THEN
         SF = PENPE*(P - PE) + SPE
      ELSE
         SF = K*(P+P0)**N
      ENDIF
      IF (((SEQF.GE.SF).AND.(DP.GE.0.D0)).OR.(DP.GT.R8PREM())) THEN
         RP = -(SEQF-SF)/HOOKF(1,1)
      ELSE
         RP = -DP
      ENDIF

C     CONTRAINTE EQUIVALENTE A T-
      CALL LCDEVI(SIGD,DEV)
      SEQD = LCNRTS(DEV)

C  RESIDU EN DEFORMATION D IRRADIATION
      MATERF(21,2) = 0.0D0
      R8AUX = 0.0D0
      IF      ( ETAID .GT. ETAIS ) THEN
         RPI = -( DPI - AI0*DETAI )
         R8AUX = ZETAFF*(SEQD+SEQF)*DPHI*0.5D0
      ELSE IF ( ETAIF .LE. ETAIS ) THEN
         RPI = - DPI
         R8AUX = ZETAFF*(SEQD+SEQF)*DPHI*0.5D0
      ELSE IF ( DETAI .GT. 0.0D0 ) THEN
         RPI = -( DPI - AI0*(ETAIF-ETAIS) )
         R8AUX = (SEQD+SEQF)*DPHI*0.5D0
         IF ( SEQD .GT. 0.0D0 ) THEN
            R8AUX = R8AUX - (SEQF-SEQD)*(ETAIS-ETAID)/(2.0D0*SEQD)
         ENDIF
         R8AUX = R8AUX*ZETAFF
C        INDICATEUR DE FRANCHISSEMENT DU SEUIL ETAIS
         IF ( ETAIS .GT. 0.0D0 ) THEN
            MATERF(21,2) = (ETAIF-ETAIS)/ETAIS
         ENDIF
      ELSE
         RPI = - DPI
      ENDIF

C  RESIDU PAR RAPPORT A ETA, HOMOGENE A DES DEFORMATIONS : RE
      RE  = -(DETAI-R8AUX)/HOOKF(1,1)

C  RESIDU PAR RAPPORT AU GONFLEMENT
      IF ( DPHI .GT. 0.0D0 ) THEN
         RG= -( DG - ZETAG*(AGFI - AGDI) )
      ELSE
         RG = - DG
      ENDIF

C  RESIDU PAR RAPPORT A LA DEFORMATION ( C_PLAN )
      IF ( MOD(1:6) .EQ. 'C_PLAN' ) THEN
         QF = (-HOOKF(3,3)*EPSEF(3)
     &         -HOOKF(3,1)*EPSEF(1)
     &         -HOOKF(3,2)*EPSEF(2)
     &         -HOOKF(3,4)*EPSEF(4))/HOOKF(1,1)
      ENDIF

      CALL LCEQVN(NDT,RS,R(1))
      R(NDT+1)=RP
      R(NDT+2)=RE
      R(NDT+3)=RPI
      R(NDT+4)=RG
      IF ( MOD(1:6).EQ.'C_PLAN' ) R(NDT+5) = QF

      END
