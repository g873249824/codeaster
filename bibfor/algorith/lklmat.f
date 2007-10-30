        SUBROUTINE LKLMAT ( MOD, IMAT, NBMAT, TEMPD, MATERD,
     &                      MATERF, MATCST, NDT, NDI, NVI, INDAL)
C
        IMPLICIT     NONE
        INTEGER      NDT, NDI, NVI, IMAT, NBMAT
        REAL*8       MATERD(NBMAT,2), MATERF(NBMAT,2), TEMPD
        CHARACTER*3  MATCST
        CHARACTER*8  MOD
C =================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/10/2007   AUTEUR ELGHARIB J.EL-GHARIB 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C =================================================================
C --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
C =================================================================
C |---------------------------------------------------------------|
C |-- BUT : RECUPERATION DES DONNEES MATERIAU POUR LA LOI DE -----|
C |------ : COMPORTEMENT LETK VISCOPLASTIQUE(MECANIQUE DES ROCHES)|
C |---------------------------------------------------------------|
C |----- NB DE CMP DIRECTES/CISAILLEMENT , NB VAR. INTERNES ------|
C |----- MATER(*,1) = E, NU, MU, K -------------------------------|
C |----- MATER(*,2) = GAMMA_ULT, GAMMA_E, M_ULT, M_E, A_E, -------|
C |---------------- : M_PIC, A_PIC, ETA, SIGMA_C, GAMMA, ---------|
C |---------------- : KSI, GAMMA_CJS, SIGMA_P1, SIGMA_P2, PA -----|
C |----- VARIABLE INTERNE : GAMMA_P, EPS_P-  ---------------------|
C |---------------------------------------------------------------|
C =================================================================
C IN  : MOD    : TYPE DE MODELISATION -----------------------------
C --- : IMAT   : ADRESSE DU MATERIAU CODE -------------------------
C --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU --------------------
C --- : TEMPD  : TEMPERATURE BIDON --------------------------------
C OUT : MATERD : COEFFICIENTS MATERIAU A T ------------------------
C --- : MATERF : COEFFICIENTS MATERIAU A T+DT ---------------------
C ------------ : MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
C ------------ : MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
C --- : MATCST : 'OUI' --------------------------------------------
C --- : NDT    : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR -----------
C --- : NDI    : NOMBRE DE COMPOSANTES DIRECTES DU TENSEUR --------
C --- : NVI    : NB DE VARIABLES INTERNES -------------------------
C --- : INDAL  : INDICATEUR SUR ALPHA
C =================================================================
      INTEGER         II,INDAL
      REAL*8          E, NU, MU, K, GAMMA, KSI, SIGC, MULT, ME, AE
      REAL*8          UN, DEUX, TROIS, SIGMP2, SIGMP1, APIC, MPIC
      REAL*8          COHERE
      REAL*8          MU0V, XI0V,S0
      CHARACTER*2     CERR(32)
      CHARACTER*8     NOMC(32)
C =================================================================
C --- INITIALISATION DE PARAMETRES --------------------------------
C =================================================================
      PARAMETER       ( UN     =  1.0D0  )
      PARAMETER       ( DEUX   =  2.0D0  )
      PARAMETER       ( TROIS  =  3.0D0  )
C =================================================================
C --- NB DE COMPOSANTES / VARIABLES INTERNES ----------------------
C =================================================================
      CALL LKLNVI(MOD, NDT, NDI, NVI)
C =================================================================
C --- DEFINITION DES CHAMPS ---------------------------------------
C =================================================================
      NOMC(1)  =  'E        '
      NOMC(2)  =  'NU       '
      NOMC(3)  =  'ALPHA    '
      NOMC(4)  =  'PA       '
      NOMC(5)  =  'NELAS    '
      NOMC(6)  =  'SIGMA_C  '
      NOMC(7)  =  'H0_EXT   '
      NOMC(8)  =  'GAMMA_CJS'
      NOMC(9)  =  'XAMS     '
      NOMC(10) =  'ETA      '
      NOMC(11) =  'A_0      '
      NOMC(12) =  'A_E      '
      NOMC(13) =  'A_PIC    '
      NOMC(14) =  'S_0      '
      NOMC(15) =  'S_E      '
      NOMC(16) =  'M_0      '
      NOMC(17) =  'M_E      '
      NOMC(18) =  'M_PIC    '
      NOMC(19) =  'M_ULT    '
      NOMC(20) =  'XI_ULT   '
      NOMC(21) =  'XI_E     '
      NOMC(22) =  'XI_PIC   '
      NOMC(23) =  'MV_MAX   '
      NOMC(24) =  'XIV_MAX'
      NOMC(25) =  'A        '
      NOMC(26) =  'N        '
      NOMC(27) =  'SIGMA_P1 '
      NOMC(28) =  'SIGMA_P2 '
      NOMC(29) =  'MU0_V    '
      NOMC(30) =  'XI0_V    '
      NOMC(31) =  'MU1      '
      NOMC(32) =  'XI1      '     
C =================================================================
C --- RECUPERATION DES PARAMETRES MATERIAU ------------------------
C =================================================================
      CALL RCVALA(IMAT,' ', 'ELAS', 1, 'TEMP', TEMPD, 3,
     &               NOMC(1),  MATERD(1,1),  CERR(1), ' ')
      INDAL=1
      IF (CERR(3).NE.'OK') INDAL=0

      CALL RCVALA(IMAT,' ', 'LETK', 1, 'TEMP', TEMPD, 29,
     &               NOMC(4),  MATERD(1,2),  CERR(4), ' ' )
C =================================================================
C - CALCUL DES MODULES DE CISAILLEMENT ET DE DEFORMATION VOLUMIQUE-
C =================================================================
      E     = MATERD(1,1)
      NU    = MATERD(2,1)
      MU    = E / (DEUX*(UN+NU))
      K     = E / (TROIS*(UN-DEUX*NU))
C =================================================================
C --- STOCKAGE DES MODULES CALCULES COMME PARAMETRES MATERIAU -----
C =================================================================
      MATERD(4,1) = MU
      MATERD(5,1) = K
C =================================================================
C - VERIFICATIONS -------------------------------------------------
C =================================================================
      MU0V   = MATERD(29,2)
      XI0V   = MATERD(30,2)
      S0     = MATERD(14,2)
      IF ((MU0V.GT.XI0V).AND.((UN/S0).GT.((UN+MU0V)/(MU0V-XI0V)))) THEN
         CALL U2MESS('F','COMPOR1_26')
      ENDIF
C =================================================================
C --- DEFINITION D'UN MATERIAU FINAL ------------------------------
C =================================================================
      DO 10 II=1,NBMAT
         MATERF(II,1) = MATERD(II,1)
         MATERF(II,2) = MATERD(II,2)
 10   CONTINUE
      MATCST = 'OUI'
C =================================================================
      END
