      FUNCTION AEPR(X)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
CDEB
C---------------------------------------------------------------
C     FONCTION A(X)  :  CAS DE LA LOI DE L'EPRI
C---------------------------------------------------------------
C IN  X     :R: ARGUMENT RECHERCHE LORS DE LA RESOLUTION SCALAIRE
C---------------------------------------------------------------
C     L'ETAPE LOCALE DU CALCUL VISCOPLASTIQUE (CALCUL DU TERME
C       ELEMENTAIRE DE LA MATRICE DE RIGIDITE TANGENTE) COMPORTE
C       LA RESOLUTION D'UNE EQUATION SCALAIRE NON LINEAIRE:
C
C           A(X) = 0
C
C       (DPC,TMIL,SIELEQ,DEUXMU,DELTAT JOUENT LE ROLE DE PARAMETRES)
C---------------------------------------------------------------
CFIN
C
      REAL*8 AEPR
      REAL*8 TMIL,DPC,DEUXMU,DELTAT,SIELEQ,VALDEN,UNSURK,
     *       UNSURM,EPSFAB,TPREC,FLUPHI,VALDRP,TTAMAX,PREC
      COMMON / NMPACY / TMIL,DPC,DEUXMU,DELTAT,SIELEQ,VALDEN,UNSURK,
     *                  UNSURM,EPSFAB,TPREC,FLUPHI,VALDRP,TTAMAX,PREC
C
        AUX = DPC + (SIELEQ - X) / (1.5D0*DEUXMU)
        CALL TPSEPR(TPS,X,AUX,TMIL,FLUPHI,VALDRP,TTAMAX,PREC)
C
C---------------------------------------------------------------
C---------------------------------------------------------------
C     ECRITURE DE LA LOI DE FLUAGE EN CONTRAINTE ET
C      DEFORMATION VISQUEUSE EQUIVALENTES (AU LIEU DE
C      CONTRAINTE ET DEFORMATION VISQUEUSE CIRCONFERENTIELLES),
C     CE QUI SE TRADUIT PAR LA MODIFICATION DES COEF A1,A2 ET B1 :
C
C     A1 = 1.388D+8/R3S2
C     A2 = 3.29D-5/(R3S2**A3)
C
C     B1 = 2.35D-21/(R3S2**(B4+1))
C
        A1 = 1.603D+8
        A2 = 4.567D-5
        A3 = 2.28D0
        A4 = 0.997D0
        A5 = 0.77D0
        A6 = 0.956D0
        A7 = 23000.D0
        B1 = 3.296D-21
        B2 = 0.811D0
        B3 = 0.595D0
        B4 = 1.352D0
        B5 = 22.91D0
        B6 = 1.58D0
        B7 = 2.228D0
C
C----CALCUL DE F1,FP1-------------------------------------------
C
        F1 = EXP(A5*LOG(TPS))
        FP1= A5*F1/TPS
C
C----CALCUL DE F2,FP2-------------------------------------------
C
        F2 = EXP(B2*LOG(TPS))
        FP2= B2*F2/TPS
C
C----CALCUL DE G1-----------------------------------------------
C
        G1 = A1*EXP(A4*LOG(SINH(A2*EXP(A3*LOG(X))))+A6*LOG(VALDRP)
     *       -A7/(TMIL+273.15D0))
C
C----CALCUL DE G2-----------------------------------------------
C
        IF (FLUPHI.EQ.0.D0) THEN
          G2 = 0.D0
        ELSE
          G2 = B1*EXP(B3*LOG(FLUPHI)+B4*LOG(X)-B5/(TMIL+273.15D0)
     *         +B6*LOG(VALDRP)+B7*LOG(COS(TTAMAX)))
        ENDIF
C---------------------------------------------------------------
C---------------------------------------------------------------
C
      G = FP1*G1 + FP2*G2
      G = G*0.5D0
      AEPR  = 1.5D0*DEUXMU*DELTAT*G + X - SIELEQ
C
      END
