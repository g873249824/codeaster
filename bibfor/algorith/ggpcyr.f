      SUBROUTINE GGPCYR(S,DPC,TEMP,EPSFAB,TPREC,FLUPHI,THETA,
     &                  DEUXMU,PREC,G,DGDST,DGDEV)
C MODIF ALGORITH  DATE 05/04/2004   AUTEUR F6BHHBO P.DEBONNIERES 
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
       REAL*8   S,DPC,TEMP,EPSFAB,TPREC,FLUPHI,DEUXMU,PREC
       REAL*8   THETA
       REAL*8   G,DGDST,DGDEV

CDEB
C---------------------------------------------------------------
C     VITESSE DE DEF. VISQUEUSE ET SA DERIVEE PAR RAPPORT A SIGMA
C---------------------------------------------------------------
C IN  S     :R: CONTRAINTE EQUIVALENTE SIGMA
C     DPC   :R: SCALAIRE RESUMANT L'ETAT VISCOPLASTIQUE DU POINT
C               CONSIDERE DU MATERIAU (DEFORM. PLASTIQUE CUMULEE)
C     TEMP  :R: TEMPERATURE DU POINT CONSIDERE
C     EPSFAB:R: PARAMETRE EPS_FAB
C     TPREC :R: PARAMETRE TEMP_RECUIT
C     FLUPHI:R: PARAMETRE FLUX_PHI
C     THETA :R: PARAMETRE DU SCHEMA D'INTEGRATION (0.5 OU 1)
C                  THETA = 0.5 -> SEMI-IMPLICITE
C                  THETA = 1.0 -> IMPLICITE
C     PREC  :R: PRECISION DE LA RESOLUTION EN TEMPS(ROUTINE TPSCYR)
C OUT G     :R: VALEUR DE LA FONCTION G
C     DGDST :R: DERIVEE TOTALE DE G PAR RAPPORT A SIGMA
C     DGDEV :R: DERIVEE PARTIELLE DE G PAR RAPPORT A EV (I.E. DPC)
C---------------------------------------------------------------
C            DANS LE CAS DE LA LOI DE CYRANO2,
C     CETTE ROUTINE CALCULE LA FONCTION G DE LA FORMULATION
C       "STRAIN HARDENING" DE L'ECOULEMENT VISCOPLASTIQUE
C       (LOI DONNEE SOUS FORME "FLUAGE")
C            .
C            EV = G(SIGMA,LAMBDA,T)
C
C     ET LA DERIVEE TOTALE DE CETTE FONCTION G PAR RAPPORT A SIGMA
C---------------------------------------------------------------
C
      REAL*8 TPS,F1,FP1,FS1,F2,FP2,FS2
      REAL*8 G1,DG1DS,G2,DG2DS
C      
      IF (S.EQ.0.D0.OR.DPC.EQ.0.D0)THEN
        G = 0.D0
        DGDST = 0.D0
        DGDEV = 0.D0
        GO TO 99
      ELSE
        CALL TPSCYR(TPS,S,DPC,TEMP,EPSFAB,TPREC,FLUPHI,PREC)
        CALL FGDCYR(TPS,S,TEMP,EPSFAB,TPREC,FLUPHI,F1,FP1,FS1,F2,
     *              FP2,FS2,G1,DG1DS,G2,DG2DS)
        G = FP1*G1 + FP2*G2
        DGDST = (G1*DG1DS*(FP1*FP1 - F1*FS1) +
     *           G2*DG2DS*(FP2*FP2 - F2*FS2) +
     *           G1*DG2DS*(FP1*FP2 - F2*FS1) +
     *           G2*DG1DS*(FP1*FP2 - F1*FS2) -
     *           (G1*FS1+G2*FS2)/(1.5D0*DEUXMU))/
     *          (FP1*G1 + FP2*G2)
        DGDEV = (FS1*G1 + FS2*G2) / (FP1*G1 + FP2*G2)
      ENDIF
        G = G*THETA
        DGDST = DGDST*THETA
        DGDEV = DGDEV*THETA
   99 CONTINUE
C
      END
