      FUNCTION VPACYR(X)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/06/2004   AUTEUR MABBAS M.ABBAS 
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
      REAL*8     X,VPACYR
C
CDEB
C---------------------------------------------------------------
C     FONCTION A(X)  :  CAS DE LA LOI DE CYRANO2
C---------------------------------------------------------------
C IN  X     :R: ARGUMENT RECHERCHE LORS DE LA RESOLUTION SCALAIRE
C---------------------------------------------------------------
C     L'ETAPE LOCALE DU CALCUL VISCOPLASTIQUE (CALCUL DU TERME
C       ELEMENTAIRE DE LA MATRICE DE RIGIDITE TANGENTE) COMPORTE
C       LA RESOLUTION D'UNE EQUATION SCALAIRE NON LINEAIRE:
C
C           A(X) = 0
C
C     (DPC,TSCHEM,SIELEQ,DEUXMU,DELTAT JOUENT LE ROLE DE PARAMETRES)
C---------------------------------------------------------------
CFIN
C     COMMON POUR LES PARAMETRES DES LOIS VISCOPLASTIQUES
      COMMON / NMPAVP / DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
      REAL*8            DPC,SIELEQ,DEUXMU,DELTAT,TSCHEM,PREC,THETA,NITER
C     COMMON POUR LES PARAMETRES DES LOIS DE FLUAGE SOUS IRRADIATION
C     ZIRC_EPRI    : FLUPHI VALDRP TTAMAX
C     ZIRC_CYRA2   : FLUPHI EPSFAB TPREC  
C     VISC_IRRA_LOG: FLUPHI A      B      CTPS    ENER 
      COMMON / NMPAIR / FLUPHI,
     *                  EPSFAB,TPREC,
     *                  VALDRP,TTAMAX,
     *                  A,B,CTPS,ENER
      REAL*8            FLUPHI
      REAL*8            VALDRP,TTAMAX          
      REAL*8            EPSFAB,TPREC
      REAL*8            A,B,CTPS,ENER
C
      REAL*8 R8GAEM
      REAL*8 R3S2,AUX,TPS,CTH,FREC,CTPS2,S1,ATH,XN,XK,AIRR
      REAL*8 FP1,FP2,G1,G2,G
C      
      R3S2 = 0.5D0*SQRT(3.D0)
C
      AUX = DPC + (SIELEQ - X) / (1.5D0*DEUXMU)
      CALL TPSCYR(TPS,X,AUX,TSCHEM,EPSFAB,
     &            TPREC,FLUPHI,PREC,INT(NITER))
C
C---------------------------------------------------------------
C---------------------------------------------------------------
C
C----CALCUL DE FP1-------------------------------------------
C
      CTH = 4450.D0
      CTPS = 4.5 D-3
      FREC = 1.816D-4*EXP(6400.D0/(TPREC+273.15D0))
C
C ---      ATTENTION : MESSAGE D'ERREUR SI EXP(X<-LOG(R8GAEM()))
C                      D'OU LE TEST SUIVANT SUR CTPS2
C
      CTPS2=CTPS*TPS
      IF (CTPS2.GE.LOG(R8GAEM())) THEN
         FP1= FREC
      ELSE
         FP1 = (CTH*EPSFAB*CTPS*EXP(-CTPS2)+1.D0)*FREC
      ENDIF
C
C----CALCUL DE FP2-------------------------------------------
C
      CTH = 4000.D0
      CTPS = 3. D-3
C
C ---      ATTENTION : MESSAGE D'ERREUR SI EXP(X<-LOG(R8GAEM()))
C                      D'OU LE TEST SUIVANT SUR CTPS2
C
      CTPS2=CTPS*TPS
      IF (CTPS2.GE.LOG(R8GAEM())) THEN
         FP2= FREC
      ELSE
         FP2 = (CTH*EPSFAB*CTPS*EXP(-CTPS2)+1.D0)*FREC
      ENDIF
C
C----CALCUL DE G1-----------------------------------------------
C
C       LES CONTRAINTES DOIVENT ETRE CONVERTIES DE N/CM2 EN MPA
C       S1=X/100.D0
      S1=X
      S1=S1/R3S2
C
      ATH = 9.529D17
      XN = EXP(2.304D-3*S1-0.413D0)
      XK = 39000.D0
      G1 = ATH*EXP(-XK/(TSCHEM+273.15D0))*EXP(XN*LOG(S1))
      G1 = G1/R3S2
C
C----CALCUL DE G2-----------------------------------------------
C
C       LES CONTRAINTES DOIVENT ETRE CONVERTIES DE N/CM2 EN MPA
C       S1=X/100.D0
C       S1=S1/R3S2
C
      AIRR = 1.2D-22
      G2 = AIRR*FLUPHI*S1/R3S2
C---------------------------------------------------------------
C---------------------------------------------------------------
C
      G = FP1*G1 + FP2*G2
      G = G*THETA
      VPACYR  = 1.5D0*DEUXMU*DELTAT*G + X - SIELEQ
C
      END
