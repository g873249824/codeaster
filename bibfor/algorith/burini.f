        SUBROUTINE BURINI(NMAT,MATERD,MATERF,TIMED,TIMEF,
     &                    NVI,VIND,NR,YD,DEPS,DY)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/01/2013   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE FOUCAULT A.FOUCAULT
C=====================================================================
C  BETON_BURGER_FP : CALCUL SOLUTION ESSAI DY = ( DSIG DEPSFI (DEPS3))
C                    AVEC     Y  = ( SIG  EPSFI  (EPS3))
C  LA SOLUTION D'ESSAI EST ETABLIE SUIVANT UNE APPROCHE LINEARISEE
C  D'ORDRE 1 AUTOUR DE L'ETAT MATERIAU A L'INSTANT T
C  IN  NMAT   :  DIMENSION MATER
C      MATERD :  COEFFICIENTS MATERIAU A T
C      MATERF :  COEFFICIENTS MATERIAU A T+DT
C      TIMED  : INSTANT T
C      TIMEF  : INSTANT T+DT
C      NVI    :  NOMBRE VARIABLES INTERNES
C      VIND   :  VECTEUR VARIABLES INTERNES A T
C      NR     :  DIMENSION VECTEUR INCCONUES
C      YD     :  VARIABLES A T   = ( SIG  EPSFI  (EPS3)  )
C  VAR DEPS   :  INCREMENT DE DEFORMATION
C  OUT DY     :  SOLUTION ESSAI  = ( DSIG DVIN (DEPS3) )
C=====================================================================
      IMPLICIT NONE
C     ----------------------------------------------------------------
      COMMON /TDIM/   NDT ,NDI
C     ----------------------------------------------------------------
      INTEGER         NMAT,NVI,NDT,NDI,NR,I,J
      REAL*8          MATERF(NMAT,2),MATERD(NMAT,2)
      REAL*8          TIMED,TIMEF,VIND(NVI),DEPS(6)
      REAL*8          YD(*),DY(*)
      REAL*8          AFD(6),BFD(6,6),CFD(6,6)
      REAL*8          AFR(6),BFR(6,6),CFR(6,6)
      REAL*8          AFI(6),BFI(6,6),CFI(6,6)
      REAL*8          AN(6) ,BN(6,6) ,CN(6,6)
      REAL*8          DSIG(6),R8PREM,MAXI,MINI

C === =================================================================
C --- RECUPERATION DES TERMES AN(6), BN(6,6), CN(6,6)
C === =================================================================
C === =================================================================
C --- RECUPERATION DES TERMES ANFD, BNFD, CNFD (FD: FLUAGE DESSICATION)
C === =================================================================
      CALL BURAFD(MATERD,MATERF,NMAT,AFD,BFD,CFD)
C === =================================================================
C --- RECUPERATION DES TERMES ANR(6), BNR(6,6), CNR(6,6)
C === =================================================================
      CALL BURAFR(VIND,NVI,MATERD,MATERF,NMAT,TIMED,TIMEF,AFR,BFR,CFR)
C === =================================================================
C --- RECUPERATION DES TERMES ANI(6), BNI(6,6), CNI(6,6) LINEARISES
C === =================================================================
      CALL BURAFI(VIND,NVI,MATERD,MATERF,NMAT,TIMED,TIMEF,AFI,BFI,CFI)
C === =================================================================
C --- ASSEMBLAGE DES TERMES AN(6), BN(6,6), CN(6,6) LINEARISES
C === =================================================================
      DO 1 I=1,NDT
        AN(I) = AFR(I)+AFI(I)+AFD(I)
        DO 2 J = 1, NDT
          BN(I,J) = BFR(I,J)+BFI(I,J)+BFD(I,J)
          CN(I,J) = CFR(I,J)+CFI(I,J)+CFD(I,J)
 2    CONTINUE
 1    CONTINUE
C === =================================================================
C --- INITIALISATION DE DY A ZERO
C === =================================================================
      CALL VECINI ( NR  , 0.D0 , DY )
C === =================================================================
C --- CALCUL DE SIGF - PUIS DSIG = SIGF - SIGD
C === =================================================================
      CALL BURSIF(MATERD,MATERF,NMAT,AN,BN,CN,DEPS,NR,YD,DSIG)
      DO 3 I = 1,NDT
        DY(I) = DSIG(I)
 3    CONTINUE 
C === =================================================================
C --- CALCUL ESSAI : EPSFI(T+DT) - PUIS DEPSFI = EPSFI(T+DT) - EPSFI(T)
C === =================================================================
      CALL BURDFI(BFI,CFI,NR,YD,DY)

C === =================================================================
C --- TRAITEMENT DU BRUIT NUMERIQUE PAR R8PREM
C === =================================================================
      MAXI = 0.D0
      DO 11 I = 1, NR
        IF(ABS(DY(I)).GT.MAXI)MAXI = ABS(DY(I))
 11   CONTINUE
      MINI = R8PREM() * MAXI
      DO 12 I = 1, NR
        IF(ABS(DY(I)).LT.MINI)DY(I) = 0.D0
 12   CONTINUE

      END
